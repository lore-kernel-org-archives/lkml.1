Return-Path: <linux-kernel-owner+w=401wt.eu-S1751745AbXINES5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbXINES5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 00:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXINESf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 00:18:35 -0400
Received: from mo31.po.2iij.NET ([210.128.50.54]:13083 "EHLO mo31.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbXINESe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 00:18:34 -0400
Message-Id: <200709140418.l8E4IRC2028669@po-mbox300.hop.2iij.net>
Date: Fri, 14 Sep 2007 13:16:53 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][3/3] led: update Cobalt Qube series front LED support
In-Reply-To: <20070914131111.2f077977.yoichi_yuasa@tripeaks.co.jp>
References: <20070914131111.2f077977.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update Cobalt Qube series front LED support.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/leds-cobalt-qube.c mips/drivers/leds/leds-cobalt-qube.c
--- mips-orig/drivers/leds/leds-cobalt-qube.c	2007-09-14 11:16:22.397075500 +0900
+++ mips/drivers/leds/leds-cobalt-qube.c	2007-09-14 11:38:52.797470250 +0900
@@ -3,40 +3,100 @@
  *
  * Control the Cobalt Qube series front LED
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
+#define LED_FRONT_LEFT	0x01
+#define LED_FRONT_RIGHT	0x02
+
+static void __iomem *led_port;
+static u8 led_value;
+
+static void qube_front_led_set(struct led_classdev *led_cdev,
+                               enum led_brightness brightness)
 {
 	if (brightness)
-		COBALT_LED_PORT = COBALT_LED_BAR_LEFT | COBALT_LED_BAR_RIGHT;
+		led_value = LED_FRONT_LEFT | LED_FRONT_RIGHT;
 	else
-		COBALT_LED_PORT = 0;
+		led_value = ~(LED_FRONT_LEFT | LED_FRONT_RIGHT);
+	writeb(led_value, led_port);
+}
+
+static struct led_classdev qube_front_led = {
+	.name			= "qube-front",
+	.brightness		= LED_FULL,
+	.brightness_set		= qube_front_led_set,
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
+	led_value = LED_FRONT_LEFT | LED_FRONT_RIGHT;
+	writeb(led_value, led_port);
+
+	retval = led_classdev_register(&pdev->dev, &qube_front_led);
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
+	led_classdev_unregister(&qube_front_led);
+
+	if (led_port) {
+		iounmap(led_port);
+		led_port = NULL;
+	}
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
 MODULE_DESCRIPTION("Front LED support for Cobalt Qube series");
