import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

import 'package:onboarding_ui/data.dart';
import 'package:onboarding_ui/page_indicator.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  PageController _controller;
  int _currentPage = 0;
  bool _isLastPage = false;

  // animation
  AnimationController animationController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: _currentPage,
    );
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF485563), Color(0xFF29323C)],
          tileMode: TileMode.clamp,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
              itemCount: pageList.length,
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _isLastPage = _currentPage == pageList.length - 1;
                  if (_isLastPage) {
                    animationController.forward();
                  } else {
                    animationController.reset();
                  }
                });
              },
              itemBuilder: (context, index) => AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => animatedPageViewBuilder(index),
              ),
            ),
            // page indicator
            Positioned(
              left: 30,
              bottom: 45,
              width: 160,
              child: PageIndicator(
                currentIndex: _currentPage,
                pageCount: pageList.length,
              ),
            ),
            // Floating Action Button
            Positioned(
              right: 30,
              bottom: 30,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _isLastPage
                  ? FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    )
                  : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget animatedPageViewBuilder(int index) {
    PageModel page = pageList[index];

    double delta;
    double y = 1.0;

    if (_controller.position.haveDimensions) {
      delta = _controller.page - index;
      y = delta.abs().clamp(0.0, 1.0);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      // dont know what this means...
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset(page.imageUrl),
        Container(
          margin: const EdgeInsets.only(left: 12),
          height: 100,
          child: Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.1,
                child: GradientText(
                  page.title,
                  gradient: LinearGradient(
                    colors: page.titleGradient,
                  ),
                  style: TextStyle(
                    fontSize: 100,
                    fontFamily: 'Montserrat-Black',
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 22.0),
                child: Container(
                  child: GradientText(
                    page.title,
                    gradient: LinearGradient(
                      colors: page.titleGradient,
                    ),
                    style: TextStyle(
                      fontSize: 70,
                      fontFamily: 'Montserrat-Black',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 34.0, top: 12.0),
          transform: Matrix4.translationValues(0, 50.0 * y, 0),
          child: Text(
            page.body,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat-Medium',
              color: Color(0xFF9B9B9B),
            ),
          ),
        ),
      ],
    );
  }
}
