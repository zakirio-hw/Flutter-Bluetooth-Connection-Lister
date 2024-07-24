import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth API',
      home: BluetoothListPanel(),
    );
  }
}

class BluetoothListPanel extends StatefulWidget {
  @override
  _BluetoothListPanelState createState() => _BluetoothListPanelState();
}

class _BluetoothListPanelState extends State<BluetoothListPanel> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 6));
    flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.any((device) => device.id == result.device.id)) {
          setState(() {
            devices.add(result.device);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zakirio\'s Bluetooth\nConnection List'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (BuildContext context, int index) {
          BluetoothDevice device = devices[index];
          return ListTile(
            title: Text(device.name.isNotEmpty ? device.name : 'Unknown device'),
            subtitle: Text(device.id.toString()),
          );
        },
      ),
    );
  }
}
