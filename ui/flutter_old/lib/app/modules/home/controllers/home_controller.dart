import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    HardwareKeyboard.instance.addHandler(_onGlobalKeyEvent);
  }

  @override
  void onClose() {
    HardwareKeyboard.instance.removeHandler(_onGlobalKeyEvent);
    super.onClose();
  }

  /// Cmd/Ctrl+V outside text fields opens the create-task page, which
  /// auto-fills the URL from the clipboard (create_view validates schemes).
  bool _onGlobalKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.keyV) {
      return false;
    }
    final keyboard = HardwareKeyboard.instance;
    if (!keyboard.isMetaPressed && !keyboard.isControlPressed) {
      return false;
    }
    // Don't hijack paste while a text field is focused.
    final focusCtx = FocusManager.instance.primaryFocus?.context;
    if (focusCtx?.findAncestorWidgetOfExactType<EditableText>() != null) {
      return false;
    }
    if (Get.currentRoute == Routes.CREATE) {
      return false;
    }
    Get.rootDelegate.toNamed(Routes.CREATE);
    return true;
  }
}
