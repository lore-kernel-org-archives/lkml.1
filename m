Return-Path: <linux-kernel-owner+w=401wt.eu-S965931AbXDIV3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965931AbXDIV3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030285AbXDIV3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:29:42 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:31658 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030278AbXDIV3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:29:24 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3/14] ARM: OMAP: PalmZ71 support
Date: Mon,  9 Apr 2007 17:28:28 -0400
Message-Id: <1176154139299-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761541282179-git-send-email-tony@atomide.com>
References: <1176154119123-git-send-email-tony@atomide.com> <11761541231278-git-send-email-tony@atomide.com> <11761541282179-git-send-email-tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l39LoNZJ027245

From: Marek Vasut <marek.vasut@gmail.com>

Palmz71 specific things - board file.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/Kconfig               |    9 +
 arch/arm/mach-omap1/Makefile              |    1 +
 arch/arm/mach-omap1/board-palmz71.c       |  384 +++++++++++++++++++++++++++++
 include/asm-arm/arch-omap/board-palmz71.h |   26 ++
 include/asm-arm/arch-omap/hardware.h      |    4 +
 5 files changed, 424 insertions(+), 0 deletions(-)

Index: linux-2.6/arch/arm/mach-omap1/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/Kconfig	2007-04-09 15:12:08.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/Kconfig	2007-04-09 15:16:08.000000000 -0400
@@ -89,6 +89,15 @@ config MACH_OMAP_PALMTE
 	  http://palmtelinux.sourceforge.net/ for more information.
 	  Say Y here if you have this PDA model, say N otherwise.
 
+config MACH_OMAP_PALMZ71
+	bool "Palm Zire71"
+	depends on ARCH_OMAP1 && ARCH_OMAP15XX
+	help
+	 Support for the Palm Zire71 PDA. To boot the kernel,
+	 you'll need a PalmOS compatible bootloader; check out
+	 http://hackndev.com/palm/z71 for more informations.
+	 Say Y here if you have such a PDA, say N otherwise.
+
 config MACH_NOKIA770
 	bool "Nokia 770"
 	depends on ARCH_OMAP1 && ARCH_OMAP16XX
Index: linux-2.6/arch/arm/mach-omap1/Makefile
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/Makefile	2007-04-09 15:12:08.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/Makefile	2007-04-09 15:16:08.000000000 -0400
@@ -22,6 +22,7 @@ obj-$(CONFIG_MACH_OMAP_OSK)		+= board-os
 obj-$(CONFIG_MACH_OMAP_H3)		+= board-h3.o
 obj-$(CONFIG_MACH_VOICEBLUE)		+= board-voiceblue.o
 obj-$(CONFIG_MACH_OMAP_PALMTE)		+= board-palmte.o
+obj-$(CONFIG_MACH_OMAP_PALMZ71)		+= board-palmz71.o
 obj-$(CONFIG_MACH_NOKIA770)		+= board-nokia770.o
 obj-$(CONFIG_MACH_AMS_DELTA)		+= board-ams-delta.o
 
Index: linux-2.6/arch/arm/mach-omap1/board-palmz71.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/arm/mach-omap1/board-palmz71.c	2007-04-09 15:16:27.000000000 -0400
@@ -0,0 +1,383 @@
+/*
+ * linux/arch/arm/mach-omap1/board-palmz71.c
+ *
+ * Modified from board-generic.c
+ *
+ * Support for the Palm Zire71 PDA.
+ *
+ * Original version : Laurent Gonzalez
+ *
+ * Modified for zire71 : Marek Vasut
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/notifier.h>
+#include <linux/clk.h>
+#include <linux/irq.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+
+#include <asm/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/flash.h>
+
+#include <asm/arch/mcbsp.h>
+#include <asm/arch/gpio.h>
+#include <asm/arch/mux.h>
+#include <asm/arch/usb.h>
+#include <asm/arch/dma.h>
+#include <asm/arch/tc.h>
+#include <asm/arch/board.h>
+#include <asm/arch/irda.h>
+#include <asm/arch/keypad.h>
+#include <asm/arch/common.h>
+#include <asm/arch/omap-alsa.h>
+
+#include <linux/input.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/ads7846.h>
+
+static void __init
+omap_palmz71_init_irq(void)
+{
+	omap1_init_common_hw();
+	omap_init_irq();
+	omap_gpio_init();
+}
+
+static int palmz71_keymap[] = {
+	KEY(0, 0, KEY_F1),
+	KEY(0, 1, KEY_F2),
+	KEY(0, 2, KEY_F3),
+	KEY(0, 3, KEY_F4),
+	KEY(0, 4, KEY_POWER),
+	KEY(1, 0, KEY_LEFT),
+	KEY(1, 1, KEY_DOWN),
+	KEY(1, 2, KEY_UP),
+	KEY(1, 3, KEY_RIGHT),
+	KEY(1, 4, KEY_CENTER),
+	KEY(2, 0, KEY_CAMERA),
+	0,
+};
+
+static struct omap_kp_platform_data palmz71_kp_data = {
+	.rows	= 8,
+	.cols	= 8,
+	.keymap	= palmz71_keymap,
+	.rep	= 1,
+	.delay	= 80,
+};
+
+static struct resource palmz71_kp_resources[] = {
+	[0] = {
+		.start	= INT_KEYBOARD,
+		.end	= INT_KEYBOARD,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device palmz71_kp_device = {
+	.name	= "omap-keypad",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &palmz71_kp_data,
+	},
+	.num_resources	= ARRAY_SIZE(palmz71_kp_resources),
+	.resource	= palmz71_kp_resources,
+};
+
+static struct mtd_partition palmz71_rom_partitions[] = {
+	/* PalmOS "Small ROM", contains the bootloader and the debugger */
+	{
+		.name		= "smallrom",
+		.offset		= 0,
+		.size		= 0xa000,
+		.mask_flags	= MTD_WRITEABLE,
+	},
+	/* PalmOS "Big ROM", a filesystem with all the OS code and data */
+	{
+		.name	= "bigrom",
+		.offset	= SZ_128K,
+		/*
+		 * 0x5f0000 bytes big in the multi-language ("EFIGS") version,
+		 * 0x7b0000 bytes in the English-only ("enUS") version.
+		 */
+		.size		= 0x7b0000,
+		.mask_flags	= MTD_WRITEABLE,
+	},
+};
+
+static struct flash_platform_data palmz71_rom_data = {
+	.map_name	= "map_rom",
+	.name		= "onboardrom",
+	.width		= 2,
+	.parts		= palmz71_rom_partitions,
+	.nr_parts	= ARRAY_SIZE(palmz71_rom_partitions),
+};
+
+static struct resource palmz71_rom_resource = {
+	.start	= OMAP_CS0_PHYS,
+	.end	= OMAP_CS0_PHYS + SZ_8M - 1,
+	.flags	= IORESOURCE_MEM,
+};
+
+static struct platform_device palmz71_rom_device = {
+	.name	= "omapflash",
+	.id	= -1,
+	.dev = {
+		.platform_data = &palmz71_rom_data,
+	},
+	.num_resources	= 1,
+	.resource	= &palmz71_rom_resource,
+};
+
+static struct platform_device palmz71_lcd_device = {
+	.name	= "lcd_palmz71",
+	.id	= -1,
+};
+
+static struct omap_irda_config palmz71_irda_config = {
+	.transceiver_cap	= IR_SIRMODE,
+	.rx_channel		= OMAP_DMA_UART3_RX,
+	.tx_channel		= OMAP_DMA_UART3_TX,
+	.dest_start		= UART3_THR,
+	.src_start		= UART3_RHR,
+	.tx_trigger		= 0,
+	.rx_trigger		= 0,
+};
+
+static struct resource palmz71_irda_resources[] = {
+	[0] = {
+		.start	= INT_UART3,
+		.end	= INT_UART3,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device palmz71_irda_device = {
+	.name	= "omapirda",
+	.id	= -1,
+	.dev = {
+		.platform_data = &palmz71_irda_config,
+	},
+	.num_resources	= ARRAY_SIZE(palmz71_irda_resources),
+	.resource	= palmz71_irda_resources,
+};
+
+static struct platform_device palmz71_spi_device = {
+	.name	= "spi_palmz71",
+	.id	= -1,
+};
+
+#define DEFAULT_BITPERSAMPLE 16
+
+static struct omap_mcbsp_reg_cfg mcbsp_regs = {
+	.spcr2	= FREE | FRST | GRST | XRST | XINTM(3),
+	.spcr1	= RINTM(3) | RRST,
+	.rcr2	= RPHASE | RFRLEN2(OMAP_MCBSP_WORD_8) |
+			RWDLEN2(OMAP_MCBSP_WORD_16) | RDATDLY(0),
+	.rcr1	= RFRLEN1(OMAP_MCBSP_WORD_8) | RWDLEN1(OMAP_MCBSP_WORD_16),
+	.xcr2	= XPHASE | XFRLEN2(OMAP_MCBSP_WORD_8) |
+			XWDLEN2(OMAP_MCBSP_WORD_16) | XDATDLY(0) | XFIG,
+	.xcr1	= XFRLEN1(OMAP_MCBSP_WORD_8) | XWDLEN1(OMAP_MCBSP_WORD_16),
+	.srgr1	= FWID(DEFAULT_BITPERSAMPLE - 1),
+	.srgr2	= GSYNC | CLKSP | FSGM | FPER(DEFAULT_BITPERSAMPLE * 2 - 1),
+	.pcr0	= CLKXP | CLKRP,	/* mcbsp: slave */
+};
+
+static struct omap_alsa_codec_config alsa_config = {
+	.name			= "PalmZ71 AIC23",
+	.mcbsp_regs_alsa	= &mcbsp_regs,
+	.codec_configure_dev	= NULL,	/* aic23_configure */
+	.codec_set_samplerate	= NULL,	/* aic23_set_samplerate */
+	.codec_clock_setup	= NULL,	/* aic23_clock_setup */
+	.codec_clock_on		= NULL,	/* aic23_clock_on */
+	.codec_clock_off	= NULL,	/* aic23_clock_off */
+	.get_default_samplerate	= NULL,	/* aic23_get_default_samplerate */
+};
+
+static struct platform_device palmz71_mcbsp1_device = {
+	.name	= "omap_alsa_mcbsp",
+	.id	= 1,
+	.dev = {
+		.platform_data = &alsa_config,
+	},
+};
+
+static struct omap_backlight_config palmz71_backlight_config = {
+	.default_intensity	= 0xa0,
+};
+
+static struct platform_device palmz71_backlight_device = {
+	.name	= "omap-bl",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &palmz71_backlight_config,
+	},
+};
+
+static struct platform_device *devices[] __initdata = {
+	&palmz71_rom_device,
+	&palmz71_kp_device,
+	&palmz71_mcbsp1_device,
+	&palmz71_lcd_device,
+	&palmz71_irda_device,
+	&palmz71_spi_device,
+	&palmz71_backlight_device,
+};
+
+static int
+palmz71_get_pendown_state(void)
+{
+	return !omap_get_gpio_datain(PALMZ71_PENIRQ_GPIO);
+}
+
+static const struct ads7846_platform_data palmz71_ts_info = {
+	.model			= 7846,
+	.vref_delay_usecs	= 100,	/* internal, no capacitor */
+	.x_plate_ohms		= 419,
+	.y_plate_ohms		= 486,
+	.get_pendown_state	= palmz71_get_pendown_state,
+};
+
+static struct spi_board_info __initdata palmz71_boardinfo[] = { {
+	/* MicroWire (bus 2) CS0 has an ads7846e */
+	.modalias	= "ads7846",
+	.platform_data	= &palmz71_ts_info,
+	.irq		= OMAP_GPIO_IRQ(PALMZ71_PENIRQ_GPIO),
+	.max_speed_hz	= 120000	/* max sample rate at 3V */
+				* 26	/* command + data + overhead */,
+	.bus_num	= 2,
+	.chip_select	= 0,
+} };
+
+static struct omap_usb_config palmz71_usb_config __initdata = {
+	.register_dev	= 1,	/* Mini-B only receptacle */
+	.hmc_mode	= 0,
+	.pins[0]	= 2,
+};
+
+static struct omap_mmc_config palmz71_mmc_config __initdata = {
+	.mmc[0] = {
+		.enabled	= 1,
+		.wire4		= 0,
+		.wp_pin		= PALMZ71_MMC_WP_GPIO,
+		.power_pin	= -1,
+		.switch_pin	= PALMZ71_MMC_IN_GPIO,
+	},
+};
+
+static struct omap_lcd_config palmz71_lcd_config __initdata = {
+	.ctrl_name = "internal",
+};
+
+static struct omap_uart_config palmz71_uart_config __initdata = {
+	.enabled_uarts = (1 << 0) | (1 << 1) | (0 << 2),
+};
+
+static struct omap_board_config_kernel palmz71_config[] = {
+	{OMAP_TAG_USB,	&palmz71_usb_config},
+	{OMAP_TAG_MMC,	&palmz71_mmc_config},
+	{OMAP_TAG_LCD,	&palmz71_lcd_config},
+	{OMAP_TAG_UART,	&palmz71_uart_config},
+};
+
+static irqreturn_t
+palmz71_powercable(int irq, void *dev_id)
+{
+	if (omap_get_gpio_datain(PALMZ71_USBDETECT_GPIO)) {
+		printk(KERN_INFO "PM: Power cable connected\n");
+		set_irq_type(OMAP_GPIO_IRQ(PALMZ71_USBDETECT_GPIO),
+				IRQT_FALLING);
+	} else {
+		printk(KERN_INFO "PM: Power cable disconnected\n");
+		set_irq_type(OMAP_GPIO_IRQ(PALMZ71_USBDETECT_GPIO),
+				IRQT_RISING);
+	}
+	return IRQ_HANDLED;
+}
+
+static void __init
+omap_mpu_wdt_mode(int mode)
+{
+	if (mode)
+		omap_writew(0x8000, OMAP_WDT_TIMER_MODE);
+	else {
+		omap_writew(0x00f5, OMAP_WDT_TIMER_MODE);
+		omap_writew(0x00a0, OMAP_WDT_TIMER_MODE);
+	}
+}
+
+static void __init
+palmz71_gpio_setup(int early)
+{
+	if (early) {
+		/* Only set GPIO1 so we have a working serial */
+		omap_set_gpio_dataout(1, 1);
+		omap_set_gpio_direction(1, 0);
+	} else {
+		/* Set MMC/SD host WP pin as input */
+		if (omap_request_gpio(PALMZ71_MMC_WP_GPIO)) {
+			printk(KERN_ERR "Could not reserve WP GPIO!\n");
+			return;
+		}
+		omap_set_gpio_direction(PALMZ71_MMC_WP_GPIO, 1);
+
+		/* Monitor the Power-cable-connected signal */
+		if (omap_request_gpio(PALMZ71_USBDETECT_GPIO)) {
+			printk(KERN_ERR
+				"Could not reserve cable signal GPIO!\n");
+			return;
+		}
+		omap_set_gpio_direction(PALMZ71_USBDETECT_GPIO, 1);
+		if (request_irq(OMAP_GPIO_IRQ(PALMZ71_USBDETECT_GPIO),
+				palmz71_powercable, IRQF_SAMPLE_RANDOM,
+				"palmz71-cable", 0))
+			printk(KERN_ERR
+					"IRQ request for power cable failed!\n");
+		palmz71_powercable(OMAP_GPIO_IRQ(PALMZ71_USBDETECT_GPIO), 0);
+	}
+}
+
+static void __init
+omap_palmz71_init(void)
+{
+	palmz71_gpio_setup(1);
+	omap_mpu_wdt_mode(0);
+
+	omap_board_config = palmz71_config;
+	omap_board_config_size = ARRAY_SIZE(palmz71_config);
+
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+
+	spi_register_board_info(palmz71_boardinfo,
+				ARRAY_SIZE(palmz71_boardinfo));
+	omap_serial_init();
+	palmz71_gpio_setup(0);
+}
+
+static void __init
+omap_palmz71_map_io(void)
+{
+	omap1_map_common_io();
+}
+
+MACHINE_START(OMAP_PALMZ71, "OMAP310 based Palm Zire71")
+	.phys_io = 0xfff00000,
+	.io_pg_offst = ((0xfef00000) >> 18) & 0xfffc,
+	.boot_params = 0x10000100,.map_io = omap_palmz71_map_io,
+	.init_irq = omap_palmz71_init_irq,
+	.init_machine = omap_palmz71_init,
+	.timer = &omap_timer,
+MACHINE_END
Index: linux-2.6/include/asm-arm/arch-omap/board-palmz71.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/asm-arm/arch-omap/board-palmz71.h	2007-04-09 15:12:14.000000000 -0400
@@ -0,0 +1,26 @@
+/*
+ * linux/include/asm-arm/arch-omap/board-palmz71.h
+ *
+ * Hardware definitions for the Palm Zire71 device.
+ *
+ * Maintainters :	Marek Vasut <marek.vasut@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __OMAP_BOARD_PALMZ71_H
+#define __OMAP_BOARD_PALMZ71_H
+
+#define PALMZ71_USBDETECT_GPIO	0
+#define PALMZ71_PENIRQ_GPIO	6
+#define PALMZ71_MMC_WP_GPIO	8
+#define PALMZ71_HDQ_GPIO 	11
+
+#define PALMZ71_HOTSYNC_GPIO	OMAP_MPUIO(1)
+#define PALMZ71_CABLE_GPIO	OMAP_MPUIO(2)
+#define PALMZ71_SLIDER_GPIO	OMAP_MPUIO(3)
+#define PALMZ71_MMC_IN_GPIO	OMAP_MPUIO(4)
+
+#endif	/* __OMAP_BOARD_PALMZ71_H */
Index: linux-2.6/include/asm-arm/arch-omap/hardware.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/hardware.h	2007-04-09 15:12:08.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/hardware.h	2007-04-09 15:16:08.000000000 -0400
@@ -334,6 +334,10 @@
 #include "board-palmte.h"
 #endif
 
+#ifdef CONFIG_MACH_OMAP_PALMZ71
+#include "board-palmz71.h"
+#endif
+
 #endif /* !__ASSEMBLER__ */
 
 #endif	/* __ASM_ARCH_OMAP_HARDWARE_H */
