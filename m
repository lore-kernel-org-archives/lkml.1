Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXINESn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXINESn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 00:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbXINESe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 00:18:34 -0400
Received: from mo31.po.2iij.NET ([210.128.50.54]:13077 "EHLO mo31.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXINESd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 00:18:33 -0400
Message-Id: <200709140418.l8E4IQPw024439@po-mbox302.po.2iij.net>
Date: Fri, 14 Sep 2007 13:16:48 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][2/3] led: add Cobalt Raq series LEDs support
In-Reply-To: <20070914131111.2f077977.yoichi_yuasa@tripeaks.co.jp>
References: <20070914131111.2f077977.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add Cobalt Raq series LEDs support.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/Kconfig mips/drivers/leds/Kconfig
--- mips-orig/drivers/leds/Kconfig	2007-09-14 13:05:27.969928000 +0900
+++ mips/drivers/leds/Kconfig	2007-09-14 13:05:39.450645500 +0900
@@ -93,6 +93,13 @@ config LEDS_COBALT_QUBE
 	help
 	  This option enables support for the front LED on Cobalt Qube series
 
+config LEDS_COBALT_RAQ
+	bool "LED Support for the Cobalt Raq series"
+	depends on LEDS_CLASS && MIPS_COBALT
+	select LEDS_TRIGGERS
+	help
+	  This option enables support for the Cobalt Raq series LEDs.
+
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
 	depends on LEDS_CLASS && GENERIC_GPIO
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/Makefile mips/drivers/leds/Makefile
--- mips-orig/drivers/leds/Makefile	2007-09-14 13:05:27.981928750 +0900
+++ mips/drivers/leds/Makefile	2007-09-14 13:05:39.450645500 +0900
@@ -16,6 +16,7 @@ obj-$(CONFIG_LEDS_NET48XX)		+= leds-net4
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
+obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 
 # LED Triggers
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/leds-cobalt-raq.c mips/drivers/leds/leds-cobalt-raq.c
--- mips-orig/drivers/leds/leds-cobalt-raq.c	1970-01-01 09:00:00.000000000 +0900
+++ mips/drivers/leds/leds-cobalt-raq.c	2007-09-14 13:06:03.900173500 +0900
@@ -0,0 +1,135 @@
+/*
+ *  LEDs driver for the Cobalt Raq series.
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
+static DEFINE_SPINLOCK(led_value_lock);
+
+static void raq_web_led_set(struct led_classdev *led_cdev,
+                            enum led_brightness brightness)
+{
+	spin_lock_irq(&led_value_lock);
+
+	if (brightness)
+		led_value |= LED_WEB;
+	else
+		led_value &= ~LED_WEB;
+	writeb(led_value, led_port);
+
+	spin_unlock_irq(&led_value_lock);
+}
+
+static struct led_classdev raq_web_led = {
+	.name		= "raq-web",
+	.brightness_set	= raq_web_led_set,
+};
+
+static void raq_power_off_led_set(struct led_classdev *led_cdev,
+                                  enum led_brightness brightness)
+{
+	spin_lock_irq(&led_value_lock);
+
+	if (brightness)
+		led_value |= LED_POWER_OFF;
+	else
+		led_value &= ~LED_POWER_OFF;
+	writeb(led_value, led_port);
+
+	spin_unlock_irq(&led_value_lock);
+}
+
+static struct led_classdev raq_power_off_led = {
+	.name			= "raq-power-off",
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
+	led_classdev_unregister(&raq_power_off_led);
+	led_classdev_unregister(&raq_web_led);
+
+	if (led_port) {
+		iounmap(led_port);
+		led_port = NULL;
+	}
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
