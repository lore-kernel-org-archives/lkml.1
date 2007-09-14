Return-Path: <linux-kernel-owner+w=401wt.eu-S1763015AbXINETX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763015AbXINETX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 00:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbXINESg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 00:18:36 -0400
Received: from mo31.po.2iij.NET ([210.128.50.54]:13088 "EHLO mo31.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXINESe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 00:18:34 -0400
Date: Fri, 14 Sep 2007 13:16:38 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][1/3] led: fix machines supported by leds-cobalt
Message-Id: <20070914131638.2be809ec.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The leds-cobalt driver only supports the Coable Qube series
(not included in Cobalt Raq series).
This patch has fixed Kconfig and renamed the driver.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/Kconfig mips/drivers/leds/Kconfig
--- mips-orig/drivers/leds/Kconfig	2007-09-14 12:11:41.222575000 +0900
+++ mips/drivers/leds/Kconfig	2007-09-14 12:12:06.820174750 +0900
@@ -87,11 +87,11 @@ config LEDS_H1940
 	help
 	  This option enables support for the LEDs on the h1940.
 
-config LEDS_COBALT
-	tristate "LED Support for Cobalt Server front LED"
+config LEDS_COBALT_QUBE
+	tristate "LED Support for the Cobalt Qube series front LED"
 	depends on LEDS_CLASS && MIPS_COBALT
 	help
-	  This option enables support for the front LED on Cobalt Server
+	  This option enables support for the front LED on Cobalt Qube series
 
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/Makefile mips/drivers/leds/Makefile
--- mips-orig/drivers/leds/Makefile	2007-09-14 12:11:41.234575750 +0900
+++ mips/drivers/leds/Makefile	2007-09-14 12:11:23.217449750 +0900
@@ -15,7 +15,7 @@ obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-am
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
-obj-$(CONFIG_LEDS_COBALT)		+= leds-cobalt.o
+obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 
 # LED Triggers
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/leds-cobalt-qube.c mips/drivers/leds/leds-cobalt-qube.c
--- mips-orig/drivers/leds/leds-cobalt-qube.c	1970-01-01 09:00:00.000000000 +0900
+++ mips/drivers/leds/leds-cobalt-qube.c	2007-09-14 12:11:23.217449750 +0900
@@ -0,0 +1,43 @@
+/*
+ * Copyright 2006 - Florian Fainelli <florian@openwrt.org>
+ *
+ * Control the Cobalt Qube series front LED
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/leds.h>
+#include <asm/mach-cobalt/cobalt.h>
+
+static void cobalt_led_set(struct led_classdev *led_cdev, enum led_brightness brightness)
+{
+	if (brightness)
+		COBALT_LED_PORT = COBALT_LED_BAR_LEFT | COBALT_LED_BAR_RIGHT;
+	else
+		COBALT_LED_PORT = 0;
+}
+
+static struct led_classdev cobalt_led = {
+       .name = "cobalt-front-led",
+       .brightness_set = cobalt_led_set,
+       .default_trigger = "ide-disk",
+};
+
+static int __init cobalt_led_init(void)
+{
+	return led_classdev_register(NULL, &cobalt_led);
+}
+
+static void __exit cobalt_led_exit(void)
+{
+	led_classdev_unregister(&cobalt_led);
+}
+
+module_init(cobalt_led_init);
+module_exit(cobalt_led_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Front LED support for Cobalt Qube series");
+MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/leds-cobalt.c mips/drivers/leds/leds-cobalt.c
--- mips-orig/drivers/leds/leds-cobalt.c	2007-09-14 12:11:41.258577250 +0900
+++ mips/drivers/leds/leds-cobalt.c	1970-01-01 09:00:00.000000000 +0900
@@ -1,43 +0,0 @@
-/*
- * Copyright 2006 - Florian Fainelli <florian@openwrt.org>
- *
- * Control the Cobalt Qube/RaQ front LED
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/leds.h>
-#include <asm/mach-cobalt/cobalt.h>
-
-static void cobalt_led_set(struct led_classdev *led_cdev, enum led_brightness brightness)
-{
-	if (brightness)
-		COBALT_LED_PORT = COBALT_LED_BAR_LEFT | COBALT_LED_BAR_RIGHT;
-	else
-		COBALT_LED_PORT = 0;
-}
-
-static struct led_classdev cobalt_led = {
-       .name = "cobalt-front-led",
-       .brightness_set = cobalt_led_set,
-       .default_trigger = "ide-disk",
-};
-
-static int __init cobalt_led_init(void)
-{
-	return led_classdev_register(NULL, &cobalt_led);
-}
-
-static void __exit cobalt_led_exit(void)
-{
-	led_classdev_unregister(&cobalt_led);
-}
-
-module_init(cobalt_led_init);
-module_exit(cobalt_led_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Front LED support for Cobalt Server");
-MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
