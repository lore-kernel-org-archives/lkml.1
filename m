Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbZFJXls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbZFJXls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 19:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbZFJXll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 19:41:41 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:27498 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbZFJXlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 19:41:39 -0400
MIME-Version: 1.0
Date: Wed, 10 Jun 2009 16:41:38 -0700
X-Google-Sender-Auth: 123c6af9984c0a16
Message-ID: <c8284b5b0906101641v586c3487i465263bb6908e3f7@mail.gmail.com>
Subject: [PATCH][Fix] New Unified AVR32/AT91 MCI Driver that supports both MCI 
	slots used at the same time (was: [PATCH][Updated] New AT91 MCI Driver that 
	supports both MCI slots used at the same time)
From: Rob Emanuele <poorarm@shoreis.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Joey Oravec <joravec@drewtech.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard & company,

This patch unifies the at91 changes I had into the atmel-mci
(originally for AVR32) driver.

This also fixes an important bug where in 4-bit mode you could only
select Slot A.

As with the at91 port I had of this driver, I had to add more flags to
the ATMCI_DATA_ERROR_FLAGS as other communication errors were
occurring and they were not be reported back.  Can anyone add more
insight into this?

Again, anyone who can, please test (on either or both the AT91 and
AVR32) and comment.

Thank you,

Rob


diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 323b47f..7f6c96a 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -326,6 +326,12 @@ config MTD_NAND_ATMEL_BUSWIDTH_16
 	  On AT91SAM926x boards both types of NAND flash can be present
 	  (8 and 16 bit data bus width).

+config AT91_2MMC
+	bool "Use both MMC Ports"
+	depends on MACH_AT91SAM9G20EK
+	help
+	  Select this if you have connected both MMC Slots.  Answer No if unsure.
+
 # ----------------------------------------------------------

 comment "AT91 Feature Selections"
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c
b/arch/arm/mach-at91/at91sam9260_devices.c
index d74c9ac..e4c9c1b 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -2,6 +2,7 @@
  * arch/arm/mach-at91/at91sam9260_devices.c
  *
  *  Copyright (C) 2006 Atmel
+ *  Copyright (C) 2009 Rob Emanuele
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -275,8 +276,104 @@ void __init at91_add_device_mmc(short mmc_id,
struct at91_mmc_data *data)
 	platform_device_register(&at91sam9260_mmc_device);
 }
 #else
+
+/* --------------------------------------------------------------------
+ *  MMC / SD Slot for Unified Atmel Driver
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
+static u64 mmc_dmamask = DMA_BIT_MASK(32);
+static struct mci_platform_data mmc_data;
+
+static struct resource mmc_resources[] = {
+	[0] = {
+		.start	= AT91SAM9260_BASE_MCI,
+		.end	= AT91SAM9260_BASE_MCI + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9260_ID_MCI,
+		.end	= AT91SAM9260_ID_MCI,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9260_mmc_device = {
+	.name		= "atmel_mci",
+	.id		= -1,
+	.dev		= {
+				.dma_mask		= &mmc_dmamask,
+				.coherent_dma_mask	= DMA_BIT_MASK(32),
+				.platform_data		= &mmc_data,
+	},
+	.resource	= mmc_resources,
+	.num_resources	= ARRAY_SIZE(mmc_resources),
+};
+
+void __init at91_add_device_mmc(short mmc_id, struct mci_platform_data *data)
+{
+        unsigned int i;
+        unsigned int slot_count = 0;
+
+	if (!data)
+		return;
+
+        for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
+                if (data->slot[i].bus_width) {
+                        /* input/irq */
+                        if (data->slot[i].detect_pin) {
+
at91_set_gpio_input(data->slot[i].detect_pin, 1);
+                                at91_set_deglitch(data->slot[i].detect_pin, 1);
+			}
+			if (data->slot[i].wp_pin)
+				at91_set_gpio_input(data->slot[i].wp_pin, 1);
+			if (data->slot[i].vcc_pin)
+				at91_set_gpio_output(data->slot[i].vcc_pin, 0);
+
+			switch(i) {
+			case 0:
+				/* CMD */
+				at91_set_A_periph(AT91_PIN_PA7, 1);
+				/* DAT0, maybe DAT1..DAT3 */
+				at91_set_A_periph(AT91_PIN_PA6, 1);
+				if (data->slot[i].bus_width == 4) {
+					at91_set_A_periph(AT91_PIN_PA9, 1);
+					at91_set_A_periph(AT91_PIN_PA10, 1);
+					at91_set_A_periph(AT91_PIN_PA11, 1);
+				}
+				break;
+			case 1:
+				/* CMD */
+				at91_set_B_periph(AT91_PIN_PA1, 1);
+				/* DAT0, maybe DAT1..DAT3 */
+				at91_set_B_periph(AT91_PIN_PA0, 1);
+				if (data->slot[i].bus_width == 4) {
+					at91_set_B_periph(AT91_PIN_PA5, 1);
+					at91_set_B_periph(AT91_PIN_PA4, 1);
+					at91_set_B_periph(AT91_PIN_PA3, 1);
+				}
+				break;
+			default:
+				printk("Configuration Error, No MMC Port %d\n",i);
+				break;
+			};
+			slot_count++;
+                }
+        }
+
+        if (slot_count) {
+                /* CLK */
+                at91_set_A_periph(AT91_PIN_PA8, 0);
+
+                mmc_data = *data;
+                platform_device_register(&at91sam9260_mmc_device);
+        }
+}
+#else
 void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
 #endif
+#endif
+


 /* --------------------------------------------------------------------
@@ -329,7 +426,7 @@ void __init at91_add_device_nand(struct
atmel_nand_data *data)
 	if (data->rdy_pin)
 		at91_set_gpio_input(data->rdy_pin, 1);

-	/* card detect pin */
+	/* card det pin */
 	if (data->det_pin)
 		at91_set_gpio_input(data->det_pin, 1);

diff --git a/arch/arm/mach-at91/board-sam9g20ek.c
b/arch/arm/mach-at91/board-sam9g20ek.c
index 81439fe..2005fb9 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -1,6 +1,7 @@
 /*
  *  Copyright (C) 2005 SAN People
  *  Copyright (C) 2008 Atmel
+ *  Copyright (C) 2009 Rob Emanuele
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -24,7 +25,6 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/at73c213.h>
-#include <linux/clk.h>

 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -89,7 +89,7 @@ static struct at91_udc_data __initdata ek_udc_data = {
  * SPI devices.
  */
 static struct spi_board_info ek_spi_devices[] = {
-#if !defined(CONFIG_MMC_AT91)
+#if !defined(CONFIG_MMC_AT91) && !defined(CONFIG_MMC_ATMELMCI)
 	{	/* DataFlash chip */
 		.modalias	= "mtd_dataflash",
 		.chip_select	= 1,
@@ -112,7 +112,11 @@ static struct spi_board_info ek_spi_devices[] = {
  * MACB Ethernet device
  */
 static struct at91_eth_data __initdata ek_macb_data = {
+#if defined(CONFIG_AT91_2MMC)
+	.phy_irq_pin	= AT91_PIN_PC12,
+#else
 	.phy_irq_pin	= AT91_PIN_PA7,
+#endif
 	.is_rmii	= 1,
 };

@@ -195,11 +199,37 @@ static void __init ek_add_device_nand(void)
  * MCI (SD/MMC)
  * det_pin, wp_pin and vcc_pin are not connected
  */
+#if defined(CONFIG_MMC_AT91) || defined(CONFIG_MMC_AT91_MODULE)
 static struct at91_mmc_data __initdata ek_mmc_data = {
 	.slot_b		= 1,
 	.wire4		= 1,
-};
+}
+#elif defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
+static struct mci_platform_data __initdata ek_mmc_data = {
+	.slot[0] = {
+#if defined(CONFIG_AT91_2MMC)
+		.bus_width	= 4,
+		.vcc_pin	= AT91_PIN_PA30,
+		.vcc_pin_act_low= 1,
+#else
+		.bus_width	= 0,
+		.vcc_pin	= -ENODEV,
+#endif
+		.detect_pin	= -ENODEV,
+		.wp_pin		= -ENODEV,
+	},
+	.slot[1] = {
+		.bus_width	= 4,
+		.detect_pin	= -ENODEV,
+		.wp_pin		= -ENODEV,
+		.vcc_pin	= -ENODEV,
+	},

+};
+#else
+static struct amci_platform_data __initdata ek_mmc_data = {
+};
+#endif

 /*
  * LEDs
@@ -207,13 +237,21 @@ static struct at91_mmc_data __initdata ek_mmc_data = {
 static struct gpio_led ek_leds[] = {
 	{	/* "bottom" led, green, userled1 to be defined */
 		.name			= "ds5",
+#if defined(CONFIG_AT91_2MMC)
+		.gpio			= AT91_PIN_PB12,
+#else
 		.gpio			= AT91_PIN_PA6,
+#endif
 		.active_low		= 1,
 		.default_trigger	= "none",
 	},
 	{	/* "power" led, yellow */
 		.name			= "ds1",
+#if defined(CONFIG_AT91_2MMC)
+		.gpio			= AT91_PIN_PB13,
+#else
 		.gpio			= AT91_PIN_PA9,
+#endif
 		.default_trigger	= "heartbeat",
 	}
 };
diff --git a/arch/arm/mach-at91/include/mach/board.h
b/arch/arm/mach-at91/include/mach/board.h
index 793fe7b..d7fbd78 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -37,6 +37,9 @@
 #include <linux/leds.h>
 #include <linux/spi/spi.h>
 #include <linux/usb/atmel_usba_udc.h>
+#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
+#include <linux/atmel-mci.h>
+#endif

  /* USB Device */
 struct at91_udc_data {
@@ -63,6 +66,7 @@ struct at91_cf_data {
 extern void __init at91_add_device_cf(struct at91_cf_data *data);

  /* MMC / SD */
+#if defined(CONFIG_MMC_AT91) || defined(CONFIG_MMC_AT91_MODULE)
 struct at91_mmc_data {
 	u8		det_pin;	/* card detect IRQ */
 	unsigned	slot_b:1;	/* uses Slot B */
@@ -71,6 +75,9 @@ struct at91_mmc_data {
 	u8		vcc_pin;	/* power switching (high == on) */
 };
 extern void __init at91_add_device_mmc(short mmc_id, struct
at91_mmc_data *data);
+#else
+extern void __init at91_add_device_mmc(short mmc_id, struct
mci_platform_data *data);
+#endif

  /* Ethernet (EMAC & MACB) */
 struct at91_eth_data {
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 99d4b28..f3cc521 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -115,18 +115,42 @@ config MMC_AT91
 	  If unsure, say N.

 config MMC_ATMELMCI
-	tristate "Atmel Multimedia Card Interface support"
-	depends on AVR32
+	tristate "Atmel Multimedia Card Interface support (Now supports AT91)"
+	depends on AVR32 || ARCH_AT91
 	help
 	  This selects the Atmel Multimedia Card Interface driver. If
-	  you have an AT32 (AVR32) platform with a Multimedia Card
-	  slot, say Y or M here.
+	  you have an AT32 (AVR32) or AT91 platform with a Multimedia
+	  Card slot, say Y or M here.
+
+	  If unsure, say N.
+
+config MMC_ATMELMCI_CLKDIV_CAP
+	int "Cap the CLKDIV to keep the controller from going too fast."
+	depends on MMC_ATMELMCI
+	default 0
+	range 0 255
+	help
+	  This is the lowest value the clock divisor for the MMC
+	  controller can be.  Value is between 0 and 255.
+	  MCI_CK = MCK/(2*(CLKDIV+1))
+	  Raising this value may improve your controller's reliability
+	  at the cost of speed.
+
+	  If unsure, leave at 0.
+
+config MMC_ATMELMCI_ALWAYS_RESET
+	bool "Reset before every request.  Sometimes needed for buggy chips."
+	depends on MMC_ATMELMCI
+	help
+	  There are reports that some buggy controllers work better
+	  with a reset before every command.  This may improve your
+	  controller's reliability.

 	  If unsure, say N.

 config MMC_ATMELMCI_DMA
 	bool "Atmel MCI DMA support (EXPERIMENTAL)"
-	depends on MMC_ATMELMCI && DMA_ENGINE && EXPERIMENTAL
+	depends on MMC_ATMELMCI && AVR32 && DMA_ENGINE && EXPERIMENTAL
 	help
 	  Say Y here to have the Atmel MCI driver use a DMA engine to
 	  do data transfers and thus increase the throughput and
diff --git a/drivers/mmc/host/atmel-mci-regs.h
b/drivers/mmc/host/atmel-mci-regs.h
index b58364e..ecde9a4 100644
--- a/drivers/mmc/host/atmel-mci-regs.h
+++ b/drivers/mmc/host/atmel-mci-regs.h
@@ -2,11 +2,17 @@
  * Atmel MultiMedia Card Interface driver
  *
  * Copyright (C) 2004-2006 Atmel Corporation
+ * Copyright (C) 2009 Rob Emanuele
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+/*
+ * Superset of registers for the Atmel AVR32 and AT91 Processors
+ */
+
 #ifndef __DRIVERS_MMC_ATMEL_MCI_H__
 #define __DRIVERS_MMC_ATMEL_MCI_H__

@@ -14,14 +20,20 @@
 #define MCI_CR			0x0000	/* Control */
 # define MCI_CR_MCIEN		(  1 <<  0)	/* MCI Enable */
 # define MCI_CR_MCIDIS		(  1 <<  1)	/* MCI Disable */
+# define MCI_CR_PWSEN		(  1 <<  2)	/* Power Save Enable */
+# define MCI_CR_PWSDIS		(  1 <<  3)	/* Power Save Disable */
 # define MCI_CR_SWRST		(  1 <<  7)	/* Software Reset */
 #define MCI_MR			0x0004	/* Mode */
-# define MCI_MR_CLKDIV(x)	((x) <<  0)	/* Clock Divider */
+# define MCI_MR_CLKDIV(x)	((x & 0xff) << 0)	/* Clock Divider */
+# define MCI_MR_PWSDIV(x)	((x & 0x7)  << 8)	/* Power Saving Divider */
 # define MCI_MR_RDPROOF		(  1 << 11)	/* Read Proof */
 # define MCI_MR_WRPROOF		(  1 << 12)	/* Write Proof */
+# define MCI_MR_FBYTE		(  1 << 13)	/* Force Byte Transfer */
+# define MCI_MR_PADV		(  1 << 14)	/* Padding Value */
+# define MCI_MR_MODE		(  1 << 15)	/* AT91 PDC-oriented Mode */
 #define MCI_DTOR		0x0008	/* Data Timeout */
-# define MCI_DTOCYC(x)		((x) <<  0)	/* Data Timeout Cycles */
-# define MCI_DTOMUL(x)		((x) <<  4)	/* Data Timeout Multiplier */
+# define MCI_DTOCYC(x)		((x & 0xf) <<  0)	/* Data Timeout Cycles */
+# define MCI_DTOMUL(x)		((x & 0x7) <<  4)	/* Data Timeout Multiplier */
 #define MCI_SDCR		0x000c	/* SD Card / SDIO */
 # define MCI_SDCSEL_SLOT_A	(  0 <<  0)	/* Select SD slot A */
 # define MCI_SDCSEL_SLOT_B	(  1 <<  0)	/* Select SD slot A */
@@ -31,7 +43,7 @@
 # define MCI_SDCBUS_MASK	(  3 <<  6)
 #define MCI_ARGR		0x0010	/* Command Argument */
 #define MCI_CMDR		0x0014	/* Command */
-# define MCI_CMDR_CMDNB(x)	((x) <<  0)	/* Command Opcode */
+# define MCI_CMDR_CMDNB(x)	((x & 0x3f) <<  0)	/* Command Opcode */
 # define MCI_CMDR_RSPTYP_NONE	(  0 <<  6)	/* No response */
 # define MCI_CMDR_RSPTYP_48BIT	(  1 <<  6)	/* 48-bit response */
 # define MCI_CMDR_RSPTYP_136BIT	(  2 <<  6)	/* 136-bit response */
@@ -54,8 +66,8 @@
 # define MCI_CMDR_SDIO_SUSPEND	(  1 << 24)	/* SDIO Suspend Command */
 # define MCI_CMDR_SDIO_RESUME	(  2 << 24)	/* SDIO Resume Command */
 #define MCI_BLKR		0x0018	/* Block */
-# define MCI_BCNT(x)		((x) <<  0)	/* Data Block Count */
-# define MCI_BLKLEN(x)		((x) << 16)	/* Data Block Length */
+# define MCI_BCNT(x)		((x & 0xffff) <<  0)	/* Data Block Count */
+# define MCI_BLKLEN(x)		((x & 0xffff) << 16)	/* Data Block Length */
 #define MCI_RSPR		0x0020	/* Response 0 */
 #define MCI_RSPR1		0x0024	/* Response 1 */
 #define MCI_RSPR2		0x0028	/* Response 2 */
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 2b1196e..62fa4f2 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2,11 +2,13 @@
  * Atmel MultiMedia Card Interface driver
  *
  * Copyright (C) 2004-2008 Atmel Corporation
+ * Copyright (C) 2009 Rob Emanuele
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
 #include <linux/blkdev.h>
 #include <linux/clk.h>
 #include <linux/debugfs.h>
@@ -30,11 +32,14 @@
 #include <asm/io.h>
 #include <asm/unaligned.h>

+#include <mach/cpu.h>
 #include <mach/board.h>

 #include "atmel-mci-regs.h"

-#define ATMCI_DATA_ERROR_FLAGS	(MCI_DCRCE | MCI_DTOE | MCI_OVRE | MCI_UNRE)
+#define ATMCI_DATA_ERROR_FLAGS	(MCI_RINDE | MCI_RDIRE | MCI_RCRCE  \
+				 | MCI_RENDE | MCI_RTOE | MCI_DCRCE \
+				 | MCI_DTOE | MCI_OVRE | MCI_UNRE)
 #define ATMCI_DMA_THRESHOLD	16

 enum {
@@ -60,6 +65,19 @@ struct atmel_mci_dma {
 #endif
 };

+/*
+ * Configuration options from the kernel config
+ */
+#ifdef CONFIG_MMC_ATMELMCI_ALWAYS_RESET
+#define MMC_ALWAYS_RESET 1
+#else
+#define MMC_ALWAYS_RESET 0
+#endif
+
+#ifndef CONFIG_MMC_ATMELMCI_CLKDIV_CAP
+#define CONFIG_MMC_ATMELMCI_CLKDIV_CAP 0
+#endif
+
 /**
  * struct atmel_mci - MMC controller state shared between all slots
  * @lock: Spinlock protecting the queue and associated data.
@@ -196,6 +214,8 @@ struct atmel_mci_slot {

 	int			detect_pin;
 	int			wp_pin;
+	int			vcc_pin;
+	bool			vcc_pin_act_low;

 	struct timer_list	detect_timer;
 };
@@ -208,6 +228,18 @@ struct atmel_mci_slot {
 	set_bit(event, &host->pending_events)

 /*
+ * Enable or disable features/registers based on
+ * whether the processor supports them
+ */
+static bool mci_has_rwproof(void)
+{
+	if (cpu_is_at91sam9261() || cpu_is_at91rm9200())
+		return false;
+	else
+		return true;
+}
+
+/*
  * The debugfs stuff below is mostly optimized away when
  * CONFIG_DEBUG_FS is not set.
  */
@@ -274,8 +306,12 @@ static void atmci_show_status_reg(struct seq_file *s,
 		[3]	= "BLKE",
 		[4]	= "DTIP",
 		[5]	= "NOTBUSY",
+		[6]	= "ENDRX",
+		[7]	= "ENDTX",
 		[8]	= "SDIOIRQA",
 		[9]	= "SDIOIRQB",
+		[14]	= "RXBUFF",
+		[15]	= "TXBUFE",
 		[16]	= "RINDE",
 		[17]	= "RDIRE",
 		[18]	= "RCRCE",
@@ -693,7 +729,7 @@ static void atmci_start_request(struct atmel_mci *host,
 	host->completed_events = 0;
 	host->data_status = 0;

-	if (host->need_reset) {
+	if (host->need_reset || MMC_ALWAYS_RESET) {
 		mci_writel(host, CR, MCI_CR_SWRST);
 		mci_writel(host, CR, MCI_CR_MCIEN);
 		mci_writel(host, MR, host->mode_reg);
@@ -812,7 +848,7 @@ static void atmci_set_ios(struct mmc_host *mmc,
struct mmc_ios *ios)
 		slot->sdc_reg |= MCI_SDCBUS_1BIT;
 		break;
 	case MMC_BUS_WIDTH_4:
-		slot->sdc_reg = MCI_SDCBUS_4BIT;
+		slot->sdc_reg |= MCI_SDCBUS_4BIT;
 		break;
 	}

@@ -846,14 +882,22 @@ static void atmci_set_ios(struct mmc_host *mmc,
struct mmc_ios *ios)
 				clock_min, host->bus_hz / (2 * 256));
 			clkdiv = 255;
 		}
+		if (clkdiv < CONFIG_MMC_ATMELMCI_CLKDIV_CAP) {
+			dev_warn(&mmc->class_dev,
+				"clkdiv %u too fast; capped using %u\n",
+				 clkdiv, CONFIG_MMC_ATMELMCI_CLKDIV_CAP);
+			clkdiv = CONFIG_MMC_ATMELMCI_CLKDIV_CAP;
+		}
+
+		host->mode_reg = MCI_MR_CLKDIV(clkdiv);

 		/*
 		 * WRPROOF and RDPROOF prevent overruns/underruns by
 		 * stopping the clock when the FIFO is full/empty.
 		 * This state is not expected to last for long.
 		 */
-		host->mode_reg = MCI_MR_CLKDIV(clkdiv) | MCI_MR_WRPROOF
-					| MCI_MR_RDPROOF;
+		if (mci_has_rwproof())
+			host->mode_reg |= (MCI_MR_WRPROOF | MCI_MR_RDPROOF);

 		if (list_empty(&host->queue))
 			mci_writel(host, MR, host->mode_reg);
@@ -884,23 +928,19 @@ static void atmci_set_ios(struct mmc_host *mmc,
struct mmc_ios *ios)
 	}

 	switch (ios->power_mode) {
+	case MMC_POWER_OFF:
+		if (gpio_is_valid(slot->vcc_pin))
+			gpio_set_value(slot->vcc_pin, slot->vcc_pin_act_low);
+		break;
 	case MMC_POWER_UP:
+		if (gpio_is_valid(slot->vcc_pin))
+			gpio_set_value(slot->vcc_pin, !slot->vcc_pin_act_low);
 		set_bit(ATMCI_CARD_NEED_INIT, &slot->flags);
 		break;
-	default:
-		/*
-		 * TODO: None of the currently available AVR32-based
-		 * boards allow MMC power to be turned off. Implement
-		 * power control when this can be tested properly.
-		 *
-		 * We also need to hook this into the clock management
-		 * somehow so that newly inserted cards aren't
-		 * subjected to a fast clock before we have a chance
-		 * to figure out what the maximum rate is. Currently,
-		 * there's no way to avoid this, and there never will
-		 * be for boards that don't support power control.
-		 */
+	case MMC_POWER_ON:
 		break;
+	default:
+		WARN_ON(1);
 	}
 }

@@ -1456,6 +1496,8 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 	slot->host = host;
 	slot->detect_pin = slot_data->detect_pin;
 	slot->wp_pin = slot_data->wp_pin;
+	slot->vcc_pin = slot_data->vcc_pin;
+	slot->vcc_pin_act_low = slot_data->vcc_pin_act_low;
 	slot->sdc_reg = sdc_reg;

 	mmc->ops = &atmci_ops;
@@ -1492,6 +1534,13 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 		}
 	}

+	if (gpio_is_valid(slot->vcc_pin)) {
+		if (gpio_request(slot->vcc_pin, "mmc_pow")) {
+			dev_dbg(&mmc->class_dev, "no power pin available\n");
+			slot->vcc_pin = -EBUSY;
+		}
+	}
+
 	host->slot[id] = slot;
 	mmc_add_host(mmc);

@@ -1642,11 +1691,13 @@ static int __init atmci_probe(struct
platform_device *pdev)
 			nr_slots++;
 	}

-	if (!nr_slots)
+	if (!nr_slots) {
+		printk(KERN_ERR "Atmel MCI controller init failed.  atmci_init_slot
error or no slots with bus_width > 0.\n");
 		goto err_init_slot;
+	}

 	dev_info(&pdev->dev,
-			"Atmel MCI controller at 0x%08lx irq %d, %u slots\n",
+			"Atmel MCI controller at 0x%08lx irq %d, %u slots, Unified Driver\n",
 			host->mapbase, irq, nr_slots);

 	return 0;
@@ -1718,6 +1769,6 @@ static void __exit atmci_exit(void)
 late_initcall(atmci_init); /* try to load after dma driver when built-in */
 module_exit(atmci_exit);

-MODULE_DESCRIPTION("Atmel Multimedia Card Interface driver");
+MODULE_DESCRIPTION("Atmel Unified Multimedia Card Interface driver");
 MODULE_AUTHOR("Haavard Skinnemoen <haavard.skinnemoen@atmel.com>");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/atmel-mci.h b/include/linux/atmel-mci.h
index 2f1f957..3b4239a 100644
--- a/include/linux/atmel-mci.h
+++ b/include/linux/atmel-mci.h
@@ -24,6 +24,8 @@ struct mci_slot_pdata {
 	unsigned int		bus_width;
 	int			detect_pin;
 	int			wp_pin;
+	int			vcc_pin;
+	unsigned		vcc_pin_act_low:1;
 };

 /**
