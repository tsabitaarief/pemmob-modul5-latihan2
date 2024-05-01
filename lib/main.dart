import 'package:flutter/material.dart'; // Import yang berfungsi untuk mengonversi data JSON ke dart.
import 'package:http/http.dart'
    as http; // Import yang berfungsi untuk membangun interface pengguna.
import 'dart:convert'; // Import library http dari package http untuk menjalankan permintaan HTTP.

void main() {
  runApp(const MyApp());
}

// Mengambil data dengan melakukan pemanggilan ke situs API
class Activity {
  String aktivitas;
  String jenis;

  Activity({required this.aktivitas, required this.jenis}); //constructor

  //Pembuatan map dari json ke dalam atribut aktivtas dan jenis
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity>
      futureActivity; //Berfungsi menampung hasil aktivitas yang dipanggil

  String url =
      "https://www.boredapi.com/api/activity"; //URL yang menjadi sumber data

  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: "");
  }

  //fetch data
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // jika server mengembalikan 200 OK (berhasil),
      // parse json
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // jika gagal (bukan  200 OK),
      // lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init();
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData();
                });
              },
              child: Text("Saya bosan ..."),
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas),
                      Text("Jenis: ${snapshot.data!.jenis}")
                    ]));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // default: Menampilkan loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
