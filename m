Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXDIVmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXDIVmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030279AbXDIVbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:31:45 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33281 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966028AbXDIVbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:31:35 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5/18] ARM: OMAP: Board Apollon update, fix boot
Date: Mon,  9 Apr 2007 17:30:48 -0400
Message-Id: <1176154277435-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761542731458-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Update Apollon board init to initialize NAND, USB,
and LEDs. Also configure GPMC memory for smc91x Ethernet.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-apollon.c |   99 +++++++++++++++++++++++++++++++---
 1 files changed, 90 insertions(+), 9 deletions(-)

--- a/arch/arm/mach-omap2/board-apollon.c
+++ b/arch/arm/mach-omap2/board-apollon.c
@@ -25,6 +25,8 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/leds.h>
+#include <linux/irq.h>
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
@@ -32,10 +34,12 @@
 #include <asm/mach/flash.h>
 
 #include <asm/arch/gpio.h>
+#include <asm/arch/led.h>
 #include <asm/arch/mux.h>
 #include <asm/arch/usb.h>
 #include <asm/arch/board.h>
 #include <asm/arch/common.h>
+#include <asm/arch/gpmc.h>
 #include "prcm-regs.h"
 
 /* LED & Switch macros */
@@ -46,6 +50,9 @@
 #define SW_UP_GPIO17		17
 #define SW_DOWN_GPIO58		58
 
+#define APOLLON_FLASH_CS	0
+#define APOLLON_ETH_CS		1
+
 static struct mtd_partition apollon_partitions[] = {
 	{
 		.name		= "X-Loader + U-Boot",
@@ -85,10 +92,10 @@ static struct flash_platform_data apollon_flash_data = {
 	.nr_parts	= ARRAY_SIZE(apollon_partitions),
 };
 
-static struct resource apollon_flash_resource = {
-	.start		= APOLLON_CS0_BASE,
-	.end		= APOLLON_CS0_BASE + SZ_128K,
-	.flags		= IORESOURCE_MEM,
+static struct resource apollon_flash_resource[] = {
+	[0] = {
+		.flags		= IORESOURCE_MEM,
+	},
 };
 
 static struct platform_device apollon_onenand_device = {
@@ -97,14 +104,24 @@ static struct platform_device apollon_onenand_device = {
 	.dev		= {
 		.platform_data	= &apollon_flash_data,
 	},
-	.num_resources	= ARRAY_SIZE(&apollon_flash_resource),
-	.resource	= &apollon_flash_resource,
+	.num_resources	= ARRAY_SIZE(apollon_flash_resource),
+	.resource	= apollon_flash_resource,
 };
 
+static void __init apollon_flash_init(void)
+{
+	unsigned long base;
+
+	if (gpmc_cs_request(APOLLON_FLASH_CS, SZ_128K, &base) < 0) {
+		printk(KERN_ERR "Cannot request OneNAND GPMC CS\n");
+		return;
+	}
+	apollon_flash_resource[0].start = base;
+	apollon_flash_resource[0].end   = base + SZ_128K - 1;
+}
+
 static struct resource apollon_smc91x_resources[] = {
 	[0] = {
-		.start	= APOLLON_ETHR_START,		/* Physical */
-		.end	= APOLLON_ETHR_START + 0xf,
 		.flags  = IORESOURCE_MEM,
 	},
 	[1] = {
@@ -126,14 +143,51 @@ static struct platform_device apollon_lcd_device = {
 	.id		= -1,
 };
 
+static struct omap_led_config apollon_led_config[] = {
+	{
+		.cdev	= {
+			.name	= "apollon:led0",
+		},
+		.gpio	= LED0_GPIO13,
+	},
+	{
+		.cdev	= {
+			.name	= "apollon:led1",
+		},
+		.gpio	= LED1_GPIO14,
+	},
+	{
+		.cdev	= {
+			.name	= "apollon:led2",
+		},
+		.gpio	= LED2_GPIO15,
+	},
+};
+
+static struct omap_led_platform_data apollon_led_data = {
+	.nr_leds	= ARRAY_SIZE(apollon_led_config),
+	.leds		= apollon_led_config,
+};
+
+static struct platform_device apollon_led_device = {
+	.name		= "omap-led",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &apollon_led_data,
+	},
+};
+
 static struct platform_device *apollon_devices[] __initdata = {
 	&apollon_onenand_device,
 	&apollon_smc91x_device,
 	&apollon_lcd_device,
+	&apollon_led_device,
 };
 
 static inline void __init apollon_init_smc91x(void)
 {
+	unsigned long base;
+
 	/* Make sure CS1 timings are correct */
 	GPMC_CONFIG1_1 = 0x00011203;
 	GPMC_CONFIG2_1 = 0x001f1f01;
@@ -141,13 +195,20 @@ static inline void __init apollon_init_smc91x(void)
 	GPMC_CONFIG4_1 = 0x1c091c09;
 	GPMC_CONFIG5_1 = 0x041f1f1f;
 	GPMC_CONFIG6_1 = 0x000004c4;
-	GPMC_CONFIG7_1 = 0x00000f40 | (APOLLON_CS1_BASE >> 24);
+
+	if (gpmc_cs_request(APOLLON_ETH_CS, SZ_16M, &base) < 0) {
+		printk(KERN_ERR "Failed to request GPMC CS for smc91x\n");
+		return;
+	}
+	apollon_smc91x_resources[0].start = base + 0x300;
+	apollon_smc91x_resources[0].end   = base + 0x30f;
 	udelay(100);
 
 	omap_cfg_reg(W4__24XX_GPIO74);
 	if (omap_request_gpio(APOLLON_ETHR_GPIO_IRQ) < 0) {
 		printk(KERN_ERR "Failed to request GPIO%d for smc91x IRQ\n",
 			APOLLON_ETHR_GPIO_IRQ);
+		gpmc_cs_free(APOLLON_ETH_CS);
 		return;
 	}
 	omap_set_gpio_direction(APOLLON_ETHR_GPIO_IRQ, 1);
@@ -175,6 +236,13 @@ static struct omap_mmc_config apollon_mmc_config __initdata = {
 	},
 };
 
+static struct omap_usb_config apollon_usb_config __initdata = {
+	.register_dev	= 1,
+	.hmc_mode	= 0x14,	/* 0:dev 1:host1 2:disable */
+
+	.pins[0]	= 6,
+};
+
 static struct omap_lcd_config apollon_lcd_config __initdata = {
 	.ctrl_name	= "internal",
 };
@@ -182,6 +250,7 @@ static struct omap_lcd_config apollon_lcd_config __initdata = {
 static struct omap_board_config_kernel apollon_config[] = {
 	{ OMAP_TAG_UART,	&apollon_uart_config },
 	{ OMAP_TAG_MMC,		&apollon_mmc_config },
+	{ OMAP_TAG_USB,		&apollon_usb_config },
 	{ OMAP_TAG_LCD,		&apollon_lcd_config },
 };
 
@@ -250,10 +319,22 @@ static void __init apollon_sw_init(void)
 		return;
 }
 
+static void __init apollon_usb_init(void)
+{
+	/* USB device */
+	/* DEVICE_SUSPEND */
+	omap_cfg_reg(P21_242X_GPIO12);
+	omap_request_gpio(12);
+	omap_set_gpio_direction(12, 0);		/* OUT */
+	omap_set_gpio_dataout(12, 0);
+}
+
 static void __init omap_apollon_init(void)
 {
 	apollon_led_init();
 	apollon_sw_init();
+	apollon_flash_init();
+	apollon_usb_init();
 
 	/* REVISIT: where's the correct place */
 	omap_cfg_reg(W19_24XX_SYS_NIRQ);
-- 
1.4.4.2

