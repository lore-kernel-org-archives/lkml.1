Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbXDIVgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbXDIVgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXDIVgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:36:09 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:35377 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbXDIVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:34:44 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 7/7] ARM: OMAP: Add apollon gpio keys using gpio-keys input
Date: Mon,  9 Apr 2007 17:34:02 -0400
Message-Id: <1176154467313-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761544642104-git-send-email-tony@atomide.com>
References: <11761544421667-git-send-email-tony@atomide.com> <11761544452798-git-send-email-tony@atomide.com> <11761544492069-git-send-email-tony@atomide.com> <11761544523253-git-send-email-tony@atomide.com> <11761544544019-git-send-email-tony@atomide.com> <11761544583886-git-send-email-tony@atomide.com> <11761544642104-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Add apollon gpio keys using gpio-keys input

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Makefile             |    3 +-
 arch/arm/mach-omap2/board-apollon-keys.c |   79 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-apollon.c      |   53 --------------------
 3 files changed, 81 insertions(+), 54 deletions(-)

Index: linux-2.6/arch/arm/mach-omap2/Makefile
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/Makefile	2007-04-09 16:21:18.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/Makefile	2007-04-09 16:21:52.000000000 -0400
@@ -15,7 +15,8 @@ obj-$(CONFIG_PM) += pm.o sleep.o
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o
 obj-$(CONFIG_MACH_OMAP_H4)		+= board-h4.o
 obj-$(CONFIG_MACH_OMAP_2430SDP)		+= board-2430sdp.o
-obj-$(CONFIG_MACH_OMAP_APOLLON)		+= board-apollon.o
+obj-$(CONFIG_MACH_OMAP_APOLLON)		+= board-apollon.o \
+					   board-apollon-keys.o
 obj-$(CONFIG_MACH_NOKIA_N800)		+= board-n800.o board-n800-flash.o \
 					   board-n800-mmc.o board-n800-bt.o \
 					   board-n800-audio.o board-n800-usb.o \
Index: linux-2.6/arch/arm/mach-omap2/board-apollon-keys.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/arm/mach-omap2/board-apollon-keys.c	2007-04-09 16:21:52.000000000 -0400
@@ -0,0 +1,79 @@
+/*
+ * linux/arch/arm/mach-omap2/board-apollon-keys.c
+ *
+ * Copyright (C) 2007 Samsung Electronics
+ * Author: Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+
+#include <asm/arch/gpio.h>
+#include <asm/arch/mux.h>
+
+#define SW_ENTER_GPIO16		16
+#define SW_UP_GPIO17		17
+#define SW_DOWN_GPIO58		58
+
+static struct gpio_keys_button apollon_gpio_keys_buttons[] = {
+	[0] = {
+		.keycode	= KEY_ENTER,
+		.gpio		= SW_ENTER_GPIO16,
+		.desc		= "enter sw",
+	},
+	[1] = {
+		.keycode	= KEY_UP,
+		.gpio		= SW_UP_GPIO17,
+		.desc		= "up sw",
+	},
+	[2] = {
+		.keycode	= KEY_DOWN,
+		.gpio		= SW_DOWN_GPIO58,
+		.desc		= "down sw",
+	},
+};
+
+static struct gpio_keys_platform_data apollon_gpio_keys = {
+	.buttons		= apollon_gpio_keys_buttons,
+	.nbuttons		= ARRAY_SIZE(apollon_gpio_keys_buttons),
+};
+
+static struct platform_device apollon_gpio_keys_device = {
+	.name			= "gpio-keys",
+	.id			= -1,
+	.dev			= {
+		.platform_data	= &apollon_gpio_keys,
+	},
+};
+
+static void __init apollon_sw_init(void)
+{
+	/* Enter SW - Y11 */
+	omap_cfg_reg(Y11_242X_GPIO16);
+	omap_request_gpio(SW_ENTER_GPIO16);
+	omap_set_gpio_direction(SW_ENTER_GPIO16, 1);
+	/* Up SW - AA12 */
+	omap_cfg_reg(AA12_242X_GPIO17);
+	omap_request_gpio(SW_UP_GPIO17);
+	omap_set_gpio_direction(SW_UP_GPIO17, 1);
+	/* Down SW - AA8 */
+	omap_cfg_reg(AA8_242X_GPIO58);
+	omap_request_gpio(SW_DOWN_GPIO58);
+	omap_set_gpio_direction(SW_DOWN_GPIO58, 1);
+}
+
+static int __init omap_apollon_keys_init(void)
+{
+	apollon_sw_init();
+
+	return platform_device_register(&apollon_gpio_keys_device);
+}
+
+arch_initcall(omap_apollon_keys_init);
Index: linux-2.6/arch/arm/mach-omap2/board-apollon.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/board-apollon.c	2007-04-09 16:21:41.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/board-apollon.c	2007-04-09 16:21:52.000000000 -0400
@@ -22,11 +22,8 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/onenand.h>
-#include <linux/irq.h>
-#include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/leds.h>
-#include <linux/irq.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 
@@ -48,9 +45,6 @@
 #define LED0_GPIO13		13
 #define LED1_GPIO14		14
 #define LED2_GPIO15		15
-#define SW_ENTER_GPIO16		16
-#define SW_UP_GPIO17		17
-#define SW_DOWN_GPIO58		58
 
 #define APOLLON_FLASH_CS	0
 #define APOLLON_ETH_CS		1
@@ -302,52 +296,6 @@ static void __init apollon_led_init(void
 	omap_set_gpio_dataout(LED2_GPIO15, 0);
 }
 
-static irqreturn_t apollon_sw_interrupt(int irq, void *ignored)
-{
-	static unsigned int led0, led1, led2;
-
-	if (irq == OMAP_GPIO_IRQ(SW_ENTER_GPIO16))
-		omap_set_gpio_dataout(LED0_GPIO13, led0 ^= 1);
-	else if (irq == OMAP_GPIO_IRQ(SW_UP_GPIO17))
-		omap_set_gpio_dataout(LED1_GPIO14, led1 ^= 1);
-	else if (irq == OMAP_GPIO_IRQ(SW_DOWN_GPIO58))
-		omap_set_gpio_dataout(LED2_GPIO15, led2 ^= 1);
-
-	return IRQ_HANDLED;
-}
-
-static void __init apollon_sw_init(void)
-{
-	/* Enter SW - Y11 */
-	omap_cfg_reg(Y11_242X_GPIO16);
-	omap_request_gpio(SW_ENTER_GPIO16);
-	omap_set_gpio_direction(SW_ENTER_GPIO16, 1);
-	/* Up SW - AA12 */
-	omap_cfg_reg(AA12_242X_GPIO17);
-	omap_request_gpio(SW_UP_GPIO17);
-	omap_set_gpio_direction(SW_UP_GPIO17, 1);
-	/* Down SW - AA8 */
-	omap_cfg_reg(AA8_242X_GPIO58);
-	omap_request_gpio(SW_DOWN_GPIO58);
-	omap_set_gpio_direction(SW_DOWN_GPIO58, 1);
-
-	set_irq_type(OMAP_GPIO_IRQ(SW_ENTER_GPIO16), IRQT_RISING);
-	if (request_irq(OMAP_GPIO_IRQ(SW_ENTER_GPIO16), &apollon_sw_interrupt,
-				IRQF_SHARED, "enter sw",
-				&apollon_sw_interrupt))
-		return;
-	set_irq_type(OMAP_GPIO_IRQ(SW_UP_GPIO17), IRQT_RISING);
-	if (request_irq(OMAP_GPIO_IRQ(SW_UP_GPIO17), &apollon_sw_interrupt,
-				IRQF_SHARED, "up sw",
-				&apollon_sw_interrupt))
-		return;
-	set_irq_type(OMAP_GPIO_IRQ(SW_DOWN_GPIO58), IRQT_RISING);
-	if (request_irq(OMAP_GPIO_IRQ(SW_DOWN_GPIO58), &apollon_sw_interrupt,
-				IRQF_SHARED, "down sw",
-				&apollon_sw_interrupt))
-		return;
-}
-
 static void __init apollon_usb_init(void)
 {
 	/* USB device */
@@ -361,7 +309,6 @@ static void __init apollon_usb_init(void
 static void __init omap_apollon_init(void)
 {
 	apollon_led_init();
-	apollon_sw_init();
 	apollon_flash_init();
 	apollon_usb_init();
 
