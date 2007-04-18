Return-Path: <linux-kernel-owner+w=401wt.eu-S2992864AbXDRWXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992864AbXDRWXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992877AbXDRWX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:23:29 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:38106 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992864AbXDRWXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:23:16 -0400
Message-ID: <46269A0C.8070900@tremplin-utc.net>
Date: Thu, 19 Apr 2007 00:22:04 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wistron_btns: add led support
Content-Type: multipart/mixed;
 boundary="------------010208000806050103040609"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010208000806050103040609
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds support for mail and wifi leds. It modifies the Kconfig
file to automatically pull led_class with wistron_btns, hopefully
everyone is fine with this.

It doesn't add support for bluetooth led because, so far, it seems all 
the laptops with bluetooth have led and bluetooth system linked (meaning 
it is already managed by the driver).

This was tested on a TM 610 and a Aspire 3020.

Eric
(sorry for the multiple receptions)


--------------010208000806050103040609
Content-Type: text/x-patch;
 name="wistron_btns-led-2.6.21.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wistron_btns-led-2.6.21.patch"

From: Eric Piel <eric.piel@tremplin-utc.net>

wriston_btns: Add led support
Add support to wistron_btns for leds that comes with the multimedia keys. Mail
and wifi leds are supported, on laptops which have them. Depending on the
laptop, wifi subsystem may control just the led, or both the led and the wifi
card. Wifi led interface is activated only for the former type of laptops, as
the latter type is already managed. Leds are controled by the interface in
/sys/class/leds. 

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>

--- linux-2.6.21/drivers/input/misc/wistron_btns.c.bak	2007-04-07 15:09:30.000000000 +0200
+++ linux-2.6.21/drivers/input/misc/wistron_btns.c	2007-04-14 12:42:38.000000000 +0200
@@ -30,6 +30,7 @@
 #include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
+#include <linux/leds.h>
 
 /*
  * Number of attempts to read data from queue per poll;
@@ -46,11 +47,12 @@
 /* BIOS subsystem IDs */
 #define WIFI		0x35
 #define BLUETOOTH	0x34
+#define MAIL_LED	0x31
 
 MODULE_AUTHOR("Miloslav Trmac <mitr@volny.cz>");
 MODULE_DESCRIPTION("Wistron laptop button driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION("0.2");
+MODULE_VERSION("0.3");
 
 static int force; /* = 0; */
 module_param(force, bool, 0);
@@ -251,6 +253,7 @@
 static const struct key_entry *keymap; /* = NULL; Current key map */
 static int have_wifi;
 static int have_bluetooth;
+static int have_leds;
 
 static int __init dmi_matched(struct dmi_system_id *dmi)
 {
@@ -263,6 +266,8 @@
 		else if (key->type == KE_BLUETOOTH)
 			have_bluetooth = 1;
 	}
+	have_leds = key->code & (FE_MAIL_LED | FE_WIFI_LED);
+
 	return 1;
 }
 
@@ -1028,6 +1033,83 @@
 	input_sync(input_dev);
 }
 
+
+ /* led management */
+static void wistron_mail_led_set(struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	bios_set_state(MAIL_LED, (value != LED_OFF) ? 1 : 0);
+}
+
+/* same as setting up wifi card, but for laptops on which the led is managed */
+static void wistron_wifi_led_set(struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	bios_set_state(WIFI, (value != LED_OFF) ? 1 : 0);
+}
+
+static struct led_classdev wistron_mail_led = {
+	.name			= "mail:green",
+	.brightness_set		= wistron_mail_led_set,
+};
+
+static struct led_classdev wistron_wifi_led = {
+	.name			= "wifi:red",
+	.brightness_set		= wistron_wifi_led_set,
+};
+
+static void __devinit wistron_led_init(struct device *parent)
+{
+	if (have_leds & FE_WIFI_LED) {
+		u16 wifi = bios_get_default_setting(WIFI);
+		if (wifi & 1) {
+			wistron_wifi_led.brightness = (wifi & 2) ? LED_FULL : LED_OFF;
+			if (led_classdev_register(parent, &wistron_wifi_led))
+				have_leds &= ~FE_WIFI_LED;
+			else
+				bios_set_state(WIFI, wistron_wifi_led.brightness);
+
+		} else
+			have_leds &= ~FE_WIFI_LED;
+	}
+
+	if (have_leds & FE_MAIL_LED) {
+		/* bios_get_default_setting(MAIL) always retuns 0, so just turn the led off */
+		wistron_mail_led.brightness = LED_OFF;
+		if (led_classdev_register(parent, &wistron_mail_led))
+			have_leds &= ~FE_MAIL_LED;
+		else
+			bios_set_state(MAIL_LED, wistron_mail_led.brightness);
+	}
+}
+
+static void __devexit wistron_led_remove(void)
+{
+	if (have_leds & FE_MAIL_LED)
+		led_classdev_unregister(&wistron_mail_led);
+
+	if (have_leds & FE_WIFI_LED)
+		led_classdev_unregister(&wistron_wifi_led);
+}
+
+static inline void wistron_led_suspend(void)
+{
+	if (have_leds & FE_MAIL_LED)
+		led_classdev_suspend(&wistron_mail_led);
+
+	if (have_leds & FE_WIFI_LED)
+		led_classdev_suspend(&wistron_wifi_led);
+}
+
+static inline void wistron_led_resume(void)
+{
+	if (have_leds & FE_MAIL_LED)
+		led_classdev_resume(&wistron_mail_led);
+
+	if (have_leds & FE_WIFI_LED)
+		led_classdev_resume(&wistron_wifi_led);
+}
+
  /* Driver core */
 
 static int wifi_enabled;
@@ -1125,6 +1207,7 @@
 			bios_set_state(BLUETOOTH, bluetooth_enabled);
 	}
 
+	wistron_led_init(&dev->dev);
 	poll_bios(1); /* Flush stale event queue and arm timer */
 
 	return 0;
@@ -1133,6 +1216,7 @@
 static int __devexit wistron_remove(struct platform_device *dev)
 {
 	del_timer_sync(&poll_timer);
+	wistron_led_remove();
 	input_unregister_device(input_dev);
 	bios_detach();

@@ -1150,6 +1233,7 @@
 	if (have_bluetooth)
 		bios_set_state(BLUETOOTH, 0);
 
+	wistron_led_suspend();
 	return 0;
 }
 
@@ -1161,6 +1245,7 @@
 	if (have_bluetooth)
 		bios_set_state(BLUETOOTH, bluetooth_enabled);
 
+	wistron_led_resume();
 	poll_bios(1);
 
 	return 0;
--- linux-2.6.21/drivers/input/misc/Kconfig.bak	2007-04-09 23:18:49.000000000 +0200
+++ linux-2.6.21/drivers/input/misc/Kconfig	2007-04-14 02:53:01.000000000 +0200
@@ -43,9 +43,12 @@
 config INPUT_WISTRON_BTNS
 	tristate "x86 Wistron laptop button interface"
 	depends on X86 && !X86_64
+	select NEW_LEDS
+	select LEDS_CLASS
 	help
 	  Say Y here for support of Winstron laptop button interface, used on
-	  laptops of various brands, including Acer and Fujitsu-Siemens.
+	  laptops of various brands, including Acer and Fujitsu-Siemens. If 
+	  available, mail and wifi leds will be controlable via /sys/class/leds.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called wistron_btns.


--------------010208000806050103040609--
