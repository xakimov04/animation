import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  bool toggleMode = false;
  int _currentIndex = 0;
  late PageController _pageController;
  Timer? _timer;
  final int imageCount = 6;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: .8,
      initialPage: imageCount *
          1000, // Start at a high number to simulate infinite scrolling
    );
    _currentIndex = _pageController.initialPage;
    startAutoScrolling();
  }

  void startAutoScrolling() {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        setState(() {
          _currentIndex++;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Animation",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                toggleMode = !toggleMode;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    toggleMode ? "images/asfalt.png" : "images/cloud.png",
                  ),
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: AnimatedAlign(
                alignment:
                    toggleMode ? Alignment.centerLeft : Alignment.centerRight,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Transform.rotate(
                      angle: pi * 2.26,
                      child: Image.asset(
                        "images/airplane.png",
                        color: toggleMode ? Colors.grey.shade600 : Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(30),
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    final displayIndex = index % imageCount;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        "images/${displayIndex + 1}.png",
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: imageCount,
            effect: const WormEffect(
              activeDotColor: Colors.blue,
              dotHeight: 8,
              dotWidth: 18,
            ),
          ),
        ],
      ),
    );
  }
}
