Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbXIMO5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbXIMO5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbXIMO5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:57:25 -0400
Received: from mo31.po.2iij.NET ([210.128.50.54]:5464 "EHLO mo31.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXIMO5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:57:24 -0400
Date: Thu, 13 Sep 2007 23:56:45 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][2/2] led: update Cobalt Qube LED support
Message-Id: <20070913235645.0fe06bc2.yoichi_yuasa@tripeaks.co.jp>
In-Reply-To: <20070913235441.5bab3d8e.yoichi_yuasa@tripeaks.co.jp>
References: <20070913235441.5bab3d8e.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update Cobalt Qube front LED support.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/leds-cobalt-qube.c mips/drivers/leds/leds-cobalt-qube.c
--- mips-orig/drivers/leds/leds-cobalt-qube.c	2007-08-24 19:35:51.689587500 +0900
+++ mips/drivers/leds/leds-cobalt-qube.c	2007-08-24 19:57:45.391688750 +0900
@@ -1,43 +1,103 @@
 /*
  * Copyright 2006 - Florian Fainelli <florian@openwrt.org>
  *
- * Control the Cobalt Qube/RaQ front LED
+ * Control the Cobalt Qube/Qube2 front LED
  */
-
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/leds.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/leds.h>
-#include <asm/mach-cobalt/cobalt.h>
 
-static void cobalt_led_set(struct led_classdev *led_cdev, enum led_brightness brightness)
+#include <asm/io.h>
+
+#define LED_BAR_LEFT	0x01
+#define LED_BAR_RIGHT	0x02
+
+static void __iomem *led_port;
+static u8 led_value;
+
+static void qube_bar_led_set(struct led_classdev *led_cdev,
+                             enum led_brightness brightness)
 {
 	if (brightness)
-		COBALT_LED_PORT = COBALT_LED_BAR_LEFT | COBALT_LED_BAR_RIGHT;
+		led_value = LED_BAR_LEFT | LED_BAR_RIGHT;
 	else
-		COBALT_LED_PORT = 0;
+		led_value = ~(LED_BAR_LEFT | LED_BAR_RIGHT);
+	writeb(led_value, led_port);
+}
+
+static struct led_classdev qube_bar_led = {
+	.name			= "qube-bar-led",
+	.brightness		= LED_FULL,
+	.brightness_set		= qube_bar_led_set,
+	.default_trigger	= "ide-disk",
+};
+
+static int __devinit cobalt_qube_led_probe(struct platform_device *pdev)
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
+	led_value = LED_BAR_LEFT | LED_BAR_RIGHT;
+	writeb(led_value, led_port);
+
+	retval = led_classdev_register(&pdev->dev, &qube_bar_led);
+	if (retval)
+		goto err_iounmap;
+
+	return 0;
+
+err_iounmap:
+	iounmap(led_port);
+	led_port = NULL;
+
+	return retval;
+}
+
+static int __devexit cobalt_qube_led_remove(struct platform_device *pdev)
+{
+	if (led_port) {
+		iounmap(led_port);
+		led_port = NULL;
+	}
+
+	led_classdev_unregister(&qube_bar_led);
+
+	return 0;
 }
 
-static struct led_classdev cobalt_led = {
-       .name = "cobalt-front-led",
-       .brightness_set = cobalt_led_set,
-       .default_trigger = "ide-disk",
+static struct platform_driver cobalt_qube_led_driver = {
+	.probe	= cobalt_qube_led_probe,
+	.remove	= __devexit_p(cobalt_qube_led_remove),
+	.driver	= {
+		.name	= "Cobalt Qube LEDs",
+		.owner	= THIS_MODULE,
+	},
 };
 
-static int __init cobalt_led_init(void)
+static int __init cobalt_qube_led_init(void)
 {
-	return led_classdev_register(NULL, &cobalt_led);
+	return platform_driver_register(&cobalt_qube_led_driver);
 }
 
-static void __exit cobalt_led_exit(void)
+static void __exit cobalt_qube_led_exit(void)
 {
-	led_classdev_unregister(&cobalt_led);
+	platform_driver_unregister(&cobalt_qube_led_driver);
 }
 
-module_init(cobalt_led_init);
-module_exit(cobalt_led_exit);
+module_init(cobalt_qube_led_init);
+module_exit(cobalt_qube_led_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Front LED support for Cobalt Server");
+MODULE_DESCRIPTION("Front LED support for Cobalt Qube");
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
