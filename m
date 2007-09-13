Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbXIMO5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbXIMO5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXIMO50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:57:26 -0400
Received: from mo32.po.2iij.NET ([210.128.50.17]:8952 "EHLO mo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbXIMO5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:57:25 -0400
Date: Thu, 13 Sep 2007 23:54:41 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][1/2] led: add Cobalt Raq LEDs support
Message-Id: <20070913235441.5bab3d8e.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add Cobalt Raq LEDs support.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/Kconfig mips/drivers/leds/Kconfig
--- mips-orig/drivers/leds/Kconfig	2007-09-12 12:01:58.027251750 +0900
+++ mips/drivers/leds/Kconfig	2007-09-12 12:04:34.021000750 +0900
@@ -87,11 +87,18 @@ config LEDS_H1940
 	help
 	  This option enables support for the LEDs on the h1940.
 
-config LEDS_COBALT
-	tristate "LED Support for Cobalt Server front LED"
+config LEDS_COBALT_QUBE
+	tristate "LED Support for Cobalt Qube front LED"
 	depends on LEDS_CLASS && MIPS_COBALT
 	help
-	  This option enables support for the front LED on Cobalt Server
+	  This option enables support for the front LEDs on Cobalt Qube/Qube2.
+
+config LEDS_COBALT_RAQ
+	bool "LED Support for Cobalt Raq series"
+	depends on LEDS_CLASS && MIPS_COBALT
+	select LEDS_TRIGGERS
+	help
+	  This option enables support for LEDs on the Cobalt Raq series.
 
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/Makefile mips/drivers/leds/Makefile
--- mips-orig/drivers/leds/Makefile	2007-09-12 12:01:58.035252250 +0900
+++ mips/drivers/leds/Makefile	2007-09-12 12:04:34.021000750 +0900
@@ -15,7 +15,8 @@ obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-am
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
-obj-$(CONFIG_LEDS_COBALT)		+= leds-cobalt.o
+obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
+obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 
 # LED Triggers
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/leds-cobalt-qube.c mips/drivers/leds/leds-cobalt-qube.c
--- mips-orig/drivers/leds/leds-cobalt-qube.c	1970-01-01 09:00:00.000000000 +0900
+++ mips/drivers/leds/leds-cobalt-qube.c	2007-09-12 13:29:20.088085000 +0900
@@ -0,0 +1,43 @@
+/*
+ * Copyright 2006 - Florian Fainelli <florian@openwrt.org>
+ *
+ * Control the Cobalt Qube/RaQ front LED
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
+MODULE_DESCRIPTION("Front LED support for Cobalt Server");
+MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/leds-cobalt-raq.c mips/drivers/leds/leds-cobalt-raq.c
--- mips-orig/drivers/leds/leds-cobalt-raq.c	1970-01-01 09:00:00.000000000 +0900
+++ mips/drivers/leds/leds-cobalt-raq.c	2007-09-12 12:04:34.021000750 +0900
@@ -0,0 +1,135 @@
+/*
+ *  Cobalt Raq/Raq2 LED driver.
+ *
+ *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#include <asm/io.h>
+
+#define LED_WEB		0x04
+#define LED_POWER_OFF	0x08
+
+static void __iomem *led_port;
+static u8 led_value;
+DEFINE_SPINLOCK(raq_led_lock);
+
+static void raq_web_led_set(struct led_classdev *led_cdev,
+                            enum led_brightness brightness)
+{
+	spin_lock_irq(&raq_led_lock);
+
+	if (brightness)
+		led_value |= LED_WEB;
+	else
+		led_value &= ~LED_WEB;
+	writeb(led_value, led_port);
+
+	spin_unlock_irq(&raq_led_lock);
+}
+
+static struct led_classdev raq_web_led = {
+	.name		= "raq-web-led",
+	.brightness_set	= raq_web_led_set,
+};
+
+static void raq_power_off_led_set(struct led_classdev *led_cdev,
+                                  enum led_brightness brightness)
+{
+	spin_lock_irq(&raq_led_lock);
+
+	if (brightness)
+		led_value |= LED_POWER_OFF;
+	else
+		led_value &= ~LED_POWER_OFF;
+	writeb(led_value, led_port);
+
+	spin_unlock_irq(&raq_led_lock);
+}
+
+static struct led_classdev raq_power_off_led = {
+	.name			= "raq-power-off-led",
+	.brightness_set		= raq_power_off_led_set,
+	.default_trigger	= "power-off",
+};
+
+static int __devinit cobalt_raq_led_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int retval;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EBUSY;
+
+	led_port = ioremap(res->start, res->end - res->start + 1);
+	if (!led_port)
+		return -ENOMEM;
+
+	retval = led_classdev_register(&pdev->dev, &raq_power_off_led);
+	if (retval)
+		goto err_iounmap;
+
+	retval = led_classdev_register(&pdev->dev, &raq_web_led);
+	if (retval)
+		goto err_unregister;
+
+	return 0;
+
+err_unregister:
+	led_classdev_unregister(&raq_power_off_led);
+
+err_iounmap:
+	iounmap(led_port);
+	led_port = NULL;
+
+	return retval;
+}
+
+static int __devexit cobalt_raq_led_remove(struct platform_device *pdev)
+{
+	if (led_port) {
+		iounmap(led_port);
+		led_port = NULL;
+	}
+
+	led_classdev_unregister(&raq_power_off_led);
+	led_classdev_unregister(&raq_web_led);
+
+	return 0;
+}
+
+static struct platform_driver cobalt_raq_led_driver = {
+	.probe	= cobalt_raq_led_probe,
+	.remove	= __devexit_p(cobalt_raq_led_remove),
+	.driver = {
+		.name	= "Cobalt Raq LEDs",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init cobalt_raq_led_init(void)
+{
+	return platform_driver_register(&cobalt_raq_led_driver);
+}
+
+module_init(cobalt_raq_led_init);
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/leds-cobalt.c mips/drivers/leds/leds-cobalt.c
--- mips-orig/drivers/leds/leds-cobalt.c	2007-09-12 12:01:58.083255250 +0900
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
