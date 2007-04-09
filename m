Return-Path: <linux-kernel-owner+w=401wt.eu-S966022AbXDIVdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966022AbXDIVdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966010AbXDIVcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:32:55 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33464 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030302AbXDIVb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:31:56 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 9/18] ARM: OMAP: abstract debug card setup (smc, leds)
Date: Mon,  9 Apr 2007 17:30:52 -0400
Message-Id: <1176154294883-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761542912185-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com> <1176154277435-git-send-email-tony@atomide.com> <11761542841909-git-send-email-tony@atomide.com> <1176154286590-git-send-email-tony@atomide.com> <11761542912185-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Additional cleanup for debug boards on H2/P2/H3/H4:  move the init
code that's not board-specific into a new file where it can be easily
shared between all the different boards (avoiding code duplication,
and making it easier to support more devices).  Make H4 use that.

This should be easy to drop in to the OMAP1 boards using these debug
cards; the only difference seems to be that the p2 does an extra reset
of the smc using the fpga (probably all boards could do that, if it's
necessary) and doesn't use the gpio mux or request APIs.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Kconfig        |    2 +-
 arch/arm/mach-omap2/board-h4.c     |   46 +------------------
 arch/arm/plat-omap/Kconfig         |    9 +++-
 arch/arm/plat-omap/Makefile        |    1 +
 arch/arm/plat-omap/debug-devices.c |   86 ++++++++++++++++++++++++++++++++++++
 include/asm-arm/arch-omap/board.h  |    4 ++
 6 files changed, 102 insertions(+), 46 deletions(-)

Index: linux-2.6/arch/arm/mach-omap2/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/Kconfig	2007-04-09 15:12:08.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/Kconfig	2007-04-09 15:25:03.000000000 -0400
@@ -21,7 +21,7 @@ config MACH_OMAP_GENERIC
 config MACH_OMAP_H4
 	bool "OMAP 2420 H4 board"
 	depends on ARCH_OMAP2 && ARCH_OMAP24XX
-	select OMAP_DEBUG_LEDS if LEDS || LEDS_OMAP_DEBUG
+	select OMAP_DEBUG_DEVICES
 
 config MACH_OMAP_APOLLON
 	bool "OMAP 2420 Apollon board"
Index: linux-2.6/arch/arm/mach-omap2/board-h4.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/board-h4.c	2007-04-09 15:12:08.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/board-h4.c	2007-04-09 15:25:03.000000000 -0400
@@ -131,26 +131,6 @@ static struct platform_device h4_flash_d
 	.resource	= &h4_flash_resource,
 };
 
-static struct resource h4_smc91x_resources[] = {
-	[0] = {
-		.start  = OMAP24XX_ETHR_START,          /* Physical */
-		.end    = OMAP24XX_ETHR_START + 0xf,
-		.flags  = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start  = OMAP_GPIO_IRQ(OMAP24XX_ETHR_GPIO_IRQ),
-		.end    = OMAP_GPIO_IRQ(OMAP24XX_ETHR_GPIO_IRQ),
-		.flags  = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device h4_smc91x_device = {
-	.name		= "smc91x",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(h4_smc91x_resources),
-	.resource	= h4_smc91x_resources,
-};
-
 /* Select between the IrDA and aGPS module
  */
 static int h4_select_irda(struct device *dev, int state)
@@ -266,29 +246,14 @@ static struct platform_device h4_lcd_dev
 	.id		= -1,
 };
 
-static struct resource h4_led_resources[] = {
-	[0] = {
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device h4_led_device = {
-	.name		= "omap_dbg_led",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(h4_led_resources),
-	.resource	= h4_led_resources,
-};
-
 static struct platform_device *h4_devices[] __initdata = {
-	&h4_smc91x_device,
 	&h4_flash_device,
 	&h4_irda_device,
 	&h4_kp_device,
 	&h4_lcd_device,
-	&h4_led_device,
 };
 
-static inline void __init h4_init_smc91x(void)
+static inline void __init h4_init_debug(void)
 {
 	/* Make sure CS1 timings are correct */
 	GPMC_CONFIG1_1 = 0x00011200;
@@ -301,12 +266,8 @@ static inline void __init h4_init_smc91x
 	udelay(100);
 
 	omap_cfg_reg(M15_24XX_GPIO92);
-	if (omap_request_gpio(OMAP24XX_ETHR_GPIO_IRQ) < 0) {
-		printk(KERN_ERR "Failed to request GPIO%d for smc91x IRQ\n",
-			OMAP24XX_ETHR_GPIO_IRQ);
-		return;
-	}
-	omap_set_gpio_direction(OMAP24XX_ETHR_GPIO_IRQ, 1);
+	if (debug_card_init(cs_mem_base, OMAP24XX_ETHR_GPIO_IRQ) < 0)
+		gpmc_cs_free(eth_cs);
 }
 
 static void __init omap_h4_init_irq(void)
@@ -314,7 +275,6 @@ static void __init omap_h4_init_irq(void
 	omap2_init_common_hw();
 	omap_init_irq();
 	omap_gpio_init();
-	h4_init_smc91x();
 }
 
 static struct omap_uart_config h4_uart_config __initdata = {
Index: linux-2.6/arch/arm/plat-omap/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/Kconfig	2007-04-09 15:12:08.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/Kconfig	2007-04-09 15:25:03.000000000 -0400
@@ -19,10 +19,15 @@ endchoice
 
 comment "OMAP Feature Selections"
 
-config OMAP_DEBUG_LEDS
+config OMAP_DEBUG_DEVICES
 	bool
 	help
-	  For debug card leds on TI reference boards.
+	  For debug cards on TI reference boards.
+
+config OMAP_DEBUG_LEDS
+	bool
+	depends on OMAP_DEBUG_DEVICES
+	default y if LEDS || LEDS_OMAP_DEBUG
 
 config OMAP_RESET_CLOCKS
 	bool "Reset unused clocks during boot"
Index: linux-2.6/arch/arm/plat-omap/Makefile
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/Makefile	2007-04-09 15:12:08.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/Makefile	2007-04-09 15:25:03.000000000 -0400
@@ -17,4 +17,5 @@ obj-$(CONFIG_ARCH_OMAP16XX) += ocpi.o
 
 obj-$(CONFIG_CPU_FREQ) += cpu-omap.o
 obj-$(CONFIG_OMAP_DM_TIMER) += dmtimer.o
+obj-$(CONFIG_OMAP_DEBUG_DEVICES) += debug-devices.o
 obj-$(CONFIG_OMAP_DEBUG_LEDS) += debug-leds.o
Index: linux-2.6/arch/arm/plat-omap/debug-devices.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/arm/plat-omap/debug-devices.c	2007-04-09 15:25:03.000000000 -0400
@@ -0,0 +1,86 @@
+/*
+ * linux/arch/arm/plat-omap/debug-devices.c
+ *
+ * Copyright (C) 2005 Nokia Corporation
+ * Modified from mach-omap2/board-h4.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <asm/hardware.h>
+#include <asm/io.h>
+
+#include <asm/arch/board.h>
+#include <asm/arch/gpio.h>
+
+
+/* Many OMAP development platforms reuse the same "debug board"; these
+ * platforms include H2, H3, H4, and Perseus2.
+ */
+
+static struct resource smc91x_resources[] = {
+	[0] = {
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device smc91x_device = {
+	.name		= "smc91x",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(smc91x_resources),
+	.resource	= smc91x_resources,
+};
+
+static struct resource led_resources[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device led_device = {
+	.name		= "omap_dbg_led",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(led_resources),
+	.resource	= led_resources,
+};
+
+static struct platform_device *debug_devices[] __initdata = {
+	&smc91x_device,
+	&led_device,
+	/* ps2 kbd + mouse ports */
+	/* 4 extra uarts */
+	/* 6 input dip switches */
+	/* 8 output pins */
+};
+
+int __init debug_card_init(u32 addr, unsigned gpio)
+{
+	int	status;
+
+	smc91x_resources[0].start = addr + 0x300;
+	smc91x_resources[0].end   = addr + 0x30f;
+
+	smc91x_resources[1].start = OMAP_GPIO_IRQ(gpio);
+	smc91x_resources[1].end   = OMAP_GPIO_IRQ(gpio);
+
+	status = omap_request_gpio(gpio);
+	if (status < 0) {
+		printk(KERN_ERR "GPIO%d unavailable for smc91x IRQ\n", gpio);
+		return status;
+	}
+	omap_set_gpio_direction(gpio, 1);
+
+	led_resources[0].start = addr;
+	led_resources[0].end   = addr + SZ_4K - 1;
+
+	return platform_add_devices(debug_devices, ARRAY_SIZE(debug_devices));
+}
Index: linux-2.6/include/asm-arm/arch-omap/board.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/board.h	2007-04-09 15:12:08.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/board.h	2007-04-09 15:25:03.000000000 -0400
@@ -179,4 +179,8 @@ extern const void *omap_get_var_config(u
 extern struct omap_board_config_kernel *omap_board_config;
 extern int omap_board_config_size;
 
+
+/* for TI reference platforms sharing the same debug card */
+extern int debug_card_init(u32 addr, unsigned gpio);
+
 #endif
