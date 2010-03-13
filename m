Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0CMJnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 04:43:01 -0500
Received: from mail.df.lth.se ([194.47.250.12]:46165 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933495Ab0CMJm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 04:42:58 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/2] DMAENGINE: U300 platform configuration
Date: Sat, 13 Mar 2010 10:42:45 +0100
Message-Id: <1268473365-30197-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This completes the DMA40 support with the platform-specific
configuration for U8500/DB8500.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500.c           |  222 +++++++++++++++++++++
 arch/arm/mach-ux500/clock.c                  |    4 +-
 arch/arm/mach-ux500/include/mach/hardware.h  |   16 ++-
 arch/arm/mach-ux500/include/mach/ste_dma40.h |  268 ++++++++++++++++++++++++++
 arch/arm/mach-ux500/ste-dma40-db8500.h       |  133 +++++++++++++
 5 files changed, 640 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-ux500/include/mach/ste_dma40.h
 create mode 100644 arch/arm/mach-ux500/ste-dma40-db8500.h

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 4335186..cfcc5cb 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -16,6 +16,7 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
 #include <linux/spi/spi.h>
+#include <mach/ste_dma40.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -25,6 +26,8 @@
 #include <mach/hardware.h>
 #include <mach/setup.h>
 
+#include "ste-dma40-db8500.h"
+
 #define __MEM_4K_RESOURCE(x) \
 	.res = {.start = (x), .end = (x) + SZ_4K - 1, .flags = IORESOURCE_MEM}
 
@@ -183,6 +186,221 @@ U8500_I2C_PDEVICE(1);
 U8500_I2C_PDEVICE(2);
 U8500_I2C_PDEVICE(3);
 
+static struct resource dma40_resources[] = {
+	[0] = {
+		.start = U8500_DMA_BASE_V1,
+		.end = U8500_DMA_BASE_V1 + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+		.name = "base",
+	},
+	[1] = {
+		.start = U8500_DMA_LCPA_BASE,
+		.end = U8500_DMA_LCPA_BASE + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+		.name = "lcpa",
+	},
+	[2] = {
+		.start = U8500_DMA_LCLA_BASE,
+		.end = U8500_DMA_LCLA_BASE + 16 * 1024 - 1,
+		.flags = IORESOURCE_MEM,
+		.name = "lcla",
+	},
+	[3] = {
+		.start = IRQ_DMA,
+		.end = IRQ_DMA,
+		.flags = IORESOURCE_IRQ}
+};
+
+/* Default configuration for physcial memcpy */
+struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
+	.channel_type = (STEDMA40_CHANNEL_IN_PHY_MODE |
+			 STEDMA40_LOW_PRIORITY_CHANNEL |
+			 STEDMA40_PCHAN_BASIC_MODE),
+	.dir = STEDMA40_MEM_TO_MEM,
+
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.src_info.psize = STEDMA40_PSIZE_PHY_1,
+
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.psize = STEDMA40_PSIZE_PHY_1,
+
+};
+/* Default configuration for logical memcpy */
+struct stedma40_chan_cfg dma40_memcpy_conf_log = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE |
+			 STEDMA40_LOW_PRIORITY_CHANNEL |
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG |
+			 STEDMA40_NO_TIM_FOR_LINK),
+	.dir = STEDMA40_MEM_TO_MEM,
+
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.src_info.psize = STEDMA40_PSIZE_LOG_1,
+
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
+
+};
+
+/*
+ * Mapping between destination event lines and physical device address.
+ * The event line is tied to a device and therefor the address is constant.
+ */
+const static dma_addr_t dma40_tx_map[STEDMA40_DEV_MAX] = {
+	[STEDMA40_DEV_SPI0_TX] = 0,
+	[STEDMA40_DEV_SD_MMC0_TX] = 0,
+	[STEDMA40_DEV_SD_MMC1_TX] = 0,
+	[STEDMA40_DEV_SD_MMC2_TX] = 0,
+	[STEDMA40_DEV_I2C1_TX] = 0,
+	[STEDMA40_DEV_I2C3_TX] = 0,
+	[STEDMA40_DEV_I2C2_TX] = 0,
+	[STEDMA40_DEV_SSP0_TX] = 0,
+	[STEDMA40_DEV_SSP1_TX] = 0,
+	[STEDMA40_DEV_UART2_TX] = 0,
+	[STEDMA40_DEV_UART1_TX] = 0,
+	[STEDMA40_DEV_UART0_TX] = 0,
+	[STEDMA40_DEV_MSP2_TX] = 0,
+	[STEDMA40_DEV_I2C0_TX] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_8] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_1_9] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_2_10] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_3_11] = 0,
+	[STEDMA40_DEV_SLIM0_CH0_TX_HSI_TX_CH0] = 0,
+	[STEDMA40_DEV_SLIM0_CH1_TX_HSI_TX_CH1] = 0,
+	[STEDMA40_DEV_SLIM0_CH2_TX_HSI_TX_CH2] = 0,
+	[STEDMA40_DEV_SLIM0_CH3_TX_HSI_TX_CH3] = 0,
+	[STEDMA40_DEV_DST_SXA0_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA1_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA2_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA3_RX_TX] = 0,
+	[STEDMA40_DEV_SD_MM2_TX] = 0,
+	[STEDMA40_DEV_SD_MM0_TX] = 0,
+	[STEDMA40_DEV_MSP1_TX] = 0,
+	[STEDMA40_SLIM0_CH0_TX] = 0,
+	[STEDMA40_DEV_MSP0_TX] = 0,
+	[STEDMA40_DEV_SD_MM1_TX] = 0,
+	[STEDMA40_DEV_SPI2_TX] = 0,
+	[STEDMA40_DEV_I2C3_TX2] = 0,
+	[STEDMA40_DEV_SPI1_TX] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_4_12] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_5_13] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_6_14] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_7_15] = 0,
+	[STEDMA40_DEV_SPI3_TX] = 0,
+	[STEDMA40_DEV_SD_MM3_TX] = 0,
+	[STEDMA40_DEV_SD_MM4_TX] = 0,
+	[STEDMA40_DEV_SD_MM5_TX] = 0,
+	[STEDMA40_DEV_DST_SXA4_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA5_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA6_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA7_RX_TX] = 0,
+	[STEDMA40_DEV_CAC1_TX] = 0,
+	[STEDMA40_DEV_CAC1_TX_HAC1_TX] = 0,
+	[STEDMA40_DEV_HAC1_TX] = 0,
+	[STEDMA40_DEV_CAC0_TX] = 0,
+	[STEDMA40_DEV_CAC0_TX_HAC0_TX] = 0,
+	[STEDMA40_DEV_HAC0_TX] = 0,
+};
+
+/* Mapping between source event lines and physical device address */
+const static dma_addr_t dma40_rx_map[STEDMA40_DEV_MAX] = {
+	[STEDMA40_DEV_SPI0_RX] = 0,
+	[STEDMA40_DEV_SD_MMC0_RX] = 0,
+	[STEDMA40_DEV_SD_MMC1_RX] = 0,
+	[STEDMA40_DEV_SD_MMC2_RX] = 0,
+	[STEDMA40_DEV_I2C1_RX] = 0,
+	[STEDMA40_DEV_I2C3_RX] = 0,
+	[STEDMA40_DEV_I2C2_RX] = 0,
+	[STEDMA40_DEV_SSP0_RX] = 0,
+	[STEDMA40_DEV_SSP1_RX] = 0,
+	[STEDMA40_DEV_MCDE_RX] = 0,
+	[STEDMA40_DEV_UART2_RX] = 0,
+	[STEDMA40_DEV_UART1_RX] = 0,
+	[STEDMA40_DEV_UART0_RX] = 0,
+	[STEDMA40_DEV_MSP2_RX] = 0,
+	[STEDMA40_DEV_I2C0_RX] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_8] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_1_9] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_2_10] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_3_11] = 0,
+	[STEDMA40_DEV_SLIM0_CH0_RX_HSI_RX_CH0] = 0,
+	[STEDMA40_DEV_SLIM0_CH1_RX_HSI_RX_CH1] = 0,
+	[STEDMA40_DEV_SLIM0_CH2_RX_HSI_RX_CH2] = 0,
+	[STEDMA40_DEV_SLIM0_CH3_RX_HSI_RX_CH3] = 0,
+	[STEDMA40_DEV_SRC_SXA0_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA1_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA2_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA3_RX_TX] = 0,
+	[STEDMA40_DEV_SD_MM2_RX] = 0,
+	[STEDMA40_DEV_SD_MM0_RX] = 0,
+	[STEDMA40_DEV_MSP1_RX] = 0,
+	[STEDMA40_SLIM0_CH0_RX] = 0,
+	[STEDMA40_DEV_MSP0_RX] = 0,
+	[STEDMA40_DEV_SD_MM1_RX] = 0,
+	[STEDMA40_DEV_SPI2_RX] = 0,
+	[STEDMA40_DEV_I2C3_RX2] = 0,
+	[STEDMA40_DEV_SPI1_RX] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_4_12] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_5_13] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_6_14] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_7_15] = 0,
+	[STEDMA40_DEV_SPI3_RX] = 0,
+	[STEDMA40_DEV_SD_MM3_RX] = 0,
+	[STEDMA40_DEV_SD_MM4_RX] = 0,
+	[STEDMA40_DEV_SD_MM5_RX] = 0,
+	[STEDMA40_DEV_SRC_SXA4_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA5_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA6_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA7_RX_TX] = 0,
+	[STEDMA40_DEV_CAC1_RX] = 0,
+	[STEDMA40_DEV_MSHC_RX] = 0,
+	[STEDMA40_DEV_SLIM1_CH0_RX_HSI_RX_CH4] = 0,
+	[STEDMA40_DEV_SLIM1_CH1_RX_HSI_RX_CH5] = 0,
+	[STEDMA40_DEV_SLIM1_CH2_RX_HSI_RX_CH6] = 0,
+	[STEDMA40_DEV_SLIM1_CH3_RX_HSI_RX_CH7] = 0,
+	[STEDMA40_DEV_CAC0_RX] = 0,
+};
+
+/* Reserved event lines for memcpy only */
+static int dma40_memcpy_event[] = {
+	STEDMA40_MEMCPY_TX_1,
+	STEDMA40_MEMCPY_TX_2,
+	STEDMA40_MEMCPY_TX_3,
+	STEDMA40_MEMCPY_TX_4,
+};
+
+static struct stedma40_platform_data dma40_plat_data = {
+	.dev_len = STEDMA40_DEV_MAX,
+	.dev_rx = dma40_rx_map,
+	.dev_tx = dma40_tx_map,
+	.memcpy = dma40_memcpy_event,
+	.memcpy_len = ARRAY_SIZE(dma40_memcpy_event),
+	.memcpy_conf_phy = &dma40_memcpy_conf_phy,
+	.memcpy_conf_log = &dma40_memcpy_conf_log,
+	.llis_per_log = 8,
+};
+
+static struct platform_device dma40_device = {
+	.dev = {
+		.platform_data = &dma40_plat_data,
+	},
+	.name = "dma40",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(dma40_resources),
+	.resource = dma40_resources
+};
+
+static void dma40_u8500ed_updates(void)
+{
+	dma40_plat_data.memcpy = NULL;
+	dma40_plat_data.memcpy_len = 0;
+	dma40_resources[0].start = U8500_DMA_BASE_ED;
+	dma40_resources[0].end = U8500_DMA_BASE_ED + SZ_4K - 1;
+}
+
 static struct amba_device *amba_devs[] __initdata = {
 	&uart0_device,
 	&uart1_device,
@@ -197,12 +415,16 @@ static struct platform_device *platform_devs[] __initdata = {
 	&i2c_controller1,
 	&i2c_controller2,
 	&i2c_controller3,
+	&dma40_device,
 };
 
 static void __init u8500_init_machine(void)
 {
 	int i;
 
+	if (cpu_is_u8500ed())
+		dma40_u8500ed_updates();
+
 	/* Register the active AMBA devices on this board */
 	for (i = 0; i < ARRAY_SIZE(amba_devs); i++)
 		amba_device_register(amba_devs[i], &iomem_resource);
diff --git a/arch/arm/mach-ux500/clock.c b/arch/arm/mach-ux500/clock.c
index d16b8b5..74cdba2 100644
--- a/arch/arm/mach-ux500/clock.c
+++ b/arch/arm/mach-ux500/clock.c
@@ -1,6 +1,5 @@
 /*
  *  Copyright (C) 2009 ST-Ericsson
- *  Copyright (C) 2009 STMicroelectronics
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -170,6 +169,7 @@ static void clk_prcmu_disable(struct clk *clk)
 }
 
 /* ED doesn't have the combined set/clr registers */
+
 static void clk_prcmu_ed_enable(struct clk *clk)
 {
 	void __iomem *addr = __io_address(U8500_PRCMU_BASE)
@@ -407,7 +407,7 @@ static struct clk_lookup u8500_common_clks[] = {
 	CLK(apetraceclk,	"apetrace",	NULL),
 	CLK(mcdeclk,	"mcde",		NULL),
 	CLK(ipi2clk,	"ipi2",		NULL),
-	CLK(dmaclk,	"dma40",	NULL),
+	CLK(dmaclk,	"dma40.0",	NULL),
 	CLK(b2r2clk,	"b2r2",		NULL),
 	CLK(tvclk,	"tv",		NULL),
 };
diff --git a/arch/arm/mach-ux500/include/mach/hardware.h b/arch/arm/mach-ux500/include/mach/hardware.h
index 99ca89f..5d12212 100644
--- a/arch/arm/mach-ux500/include/mach/hardware.h
+++ b/arch/arm/mach-ux500/include/mach/hardware.h
@@ -26,6 +26,19 @@
 /* used by some plat-nomadik code */
 #define io_p2v(n)		__io_address(n)
 
+
+/* Base address and bank offsets for ESRAM */
+#define U8500_ESRAM_BASE	0x40000000
+#define U8500_ESRAM_BANK_SIZE	0x00020000
+#define U8500_ESRAM_BANK0	U8500_ESRAM_BASE
+#define U8500_ESRAM_BANK1	(U8500_ESRAM_BASE + U8500_ESRAM_BANK_SIZE)
+#define U8500_ESRAM_BANK2	(U8500_ESRAM_BANK1 + U8500_ESRAM_BANK_SIZE)
+#define U8500_ESRAM_BANK3	(U8500_ESRAM_BANK2 + U8500_ESRAM_BANK_SIZE)
+#define U8500_ESRAM_BANK4	(U8500_ESRAM_BANK3 + U8500_ESRAM_BANK_SIZE)
+/* Use bank 4 for DMA LCLA and LCPA */
+#define U8500_DMA_LCLA_BASE	U8500_ESRAM_BANK4
+#define U8500_DMA_LCPA_BASE	(U8500_ESRAM_BANK4 + 0x4000)
+
 /*
  * Base address definitions for U8500 Onchip IPs. All the
  * peripherals are contained in a single 1 Mbyte region, with
@@ -47,7 +60,8 @@
 
 #define U8500_SGA_BASE		0xa0300000
 #define U8500_MCDE_BASE		0xa0350000
-#define U8500_DMA_BASE		0xa0362000
+#define U8500_DMA_BASE_ED	0xa0362000
+#define U8500_DMA_BASE_V1	0x801C0000
 
 #define U8500_SCU_BASE		0xa0410000
 #define U8500_GIC_CPU_BASE	0xa0410100
diff --git a/arch/arm/mach-ux500/include/mach/ste_dma40.h b/arch/arm/mach-ux500/include/mach/ste_dma40.h
new file mode 100644
index 0000000..e66424a
--- /dev/null
+++ b/arch/arm/mach-ux500/include/mach/ste_dma40.h
@@ -0,0 +1,268 @@
+/*
+ * arch/arm/mach-ux500/include/mach/ste_dma40.h
+ *
+ * Copyright (C) ST-Ericsson 2007-2010
+ * License terms: GNU General Public License (GPL) version 2
+ * Author: Per Friden <per.friden@stericsson.com>
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
+ */
+
+
+#ifndef STE_DMA40_H
+#define STE_DMA40_H
+
+#include <linux/dmaengine.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/dmaengine.h>
+
+/* dev types for memcpy */
+#define STEDMA40_DEV_DST_MEMORY (-1)
+#define	STEDMA40_DEV_SRC_MEMORY (-1)
+
+/*
+ * Description of bitfields of channel_type variable is available in
+ * the info structure.
+ */
+
+/* Priority */
+#define STEDMA40_INFO_PRIO_TYPE_POS 2
+#define STEDMA40_HIGH_PRIORITY_CHANNEL (0x1 << STEDMA40_INFO_PRIO_TYPE_POS)
+#define STEDMA40_LOW_PRIORITY_CHANNEL (0x2 << STEDMA40_INFO_PRIO_TYPE_POS)
+
+/* Mode  */
+#define STEDMA40_INFO_CH_MODE_TYPE_POS 6
+#define STEDMA40_CHANNEL_IN_PHY_MODE (0x1 << STEDMA40_INFO_CH_MODE_TYPE_POS)
+#define STEDMA40_CHANNEL_IN_LOG_MODE (0x2 << STEDMA40_INFO_CH_MODE_TYPE_POS)
+#define STEDMA40_CHANNEL_IN_OPER_MODE (0x3 << STEDMA40_INFO_CH_MODE_TYPE_POS)
+
+/* Mode options */
+#define STEDMA40_INFO_CH_MODE_OPT_POS 8
+#define STEDMA40_PCHAN_BASIC_MODE (0x1 << STEDMA40_INFO_CH_MODE_OPT_POS)
+#define STEDMA40_PCHAN_MODULO_MODE (0x2 << STEDMA40_INFO_CH_MODE_OPT_POS)
+#define STEDMA40_PCHAN_DOUBLE_DST_MODE (0x3 << STEDMA40_INFO_CH_MODE_OPT_POS)
+#define STEDMA40_LCHAN_SRC_PHY_DST_LOG (0x1 << STEDMA40_INFO_CH_MODE_OPT_POS)
+#define STEDMA40_LCHAN_SRC_LOG_DST_PHS (0x2 << STEDMA40_INFO_CH_MODE_OPT_POS)
+#define STEDMA40_LCHAN_SRC_LOG_DST_LOG (0x3 << STEDMA40_INFO_CH_MODE_OPT_POS)
+
+/* Interrupt */
+#define STEDMA40_INFO_TIM_POS 10
+#define STEDMA40_NO_TIM_FOR_LINK (0x0 << STEDMA40_INFO_TIM_POS)
+#define STEDMA40_TIM_FOR_LINK (0x1 << STEDMA40_INFO_TIM_POS)
+
+/* End of channel_type configuration */
+
+#define STEDMA40_ESIZE_8_BIT  0x0
+#define STEDMA40_ESIZE_16_BIT 0x1
+#define STEDMA40_ESIZE_32_BIT 0x2
+#define STEDMA40_ESIZE_64_BIT 0x3
+
+/* The value 4 indicates that PEN-reg shall be set to 0 */
+#define STEDMA40_PSIZE_PHY_1  0x4
+#define STEDMA40_PSIZE_PHY_2  0x0
+#define STEDMA40_PSIZE_PHY_4  0x1
+#define STEDMA40_PSIZE_PHY_8  0x2
+#define STEDMA40_PSIZE_PHY_16 0x3
+
+/*
+ * The number of elements differ in logical and
+ * physical mode
+ */
+#define STEDMA40_PSIZE_LOG_1  STEDMA40_PSIZE_PHY_2
+#define STEDMA40_PSIZE_LOG_4  STEDMA40_PSIZE_PHY_4
+#define STEDMA40_PSIZE_LOG_8  STEDMA40_PSIZE_PHY_8
+#define STEDMA40_PSIZE_LOG_16 STEDMA40_PSIZE_PHY_16
+
+enum stedma40_flow_ctrl {
+	STEDMA40_NO_FLOW_CTRL,
+	STEDMA40_FLOW_CTRL,
+};
+
+enum stedma40_endianess {
+	STEDMA40_LITTLE_ENDIAN,
+	STEDMA40_BIG_ENDIAN
+};
+
+enum stedma40_periph_data_width {
+	STEDMA40_BYTE_WIDTH = STEDMA40_ESIZE_8_BIT,
+	STEDMA40_HALFWORD_WIDTH = STEDMA40_ESIZE_16_BIT,
+	STEDMA40_WORD_WIDTH = STEDMA40_ESIZE_32_BIT,
+	STEDMA40_DOUBLEWORD_WIDTH = STEDMA40_ESIZE_64_BIT
+};
+
+struct stedma40_half_channel_info {
+	enum stedma40_endianess endianess;
+	enum stedma40_periph_data_width data_width;
+	int psize;
+	enum stedma40_flow_ctrl flow_ctrl;
+};
+
+enum stedma40_xfer_dir {
+	STEDMA40_MEM_TO_MEM,
+	STEDMA40_MEM_TO_PERIPH,
+	STEDMA40_PERIPH_TO_MEM,
+	STEDMA40_PERIPH_TO_PERIPH
+};
+
+
+/**
+ * struct stedma40_chan_cfg - Structure to be filled by client drivers.
+ *
+ * @dir: MEM 2 MEM, PERIPH 2 MEM , MEM 2 PERIPH, PERIPH 2 PERIPH
+ * @channel_type: priority, mode, mode options and interrupt configuration.
+ * @src_dev_type: Src device type
+ * @dst_dev_type: Dst device type
+ * @src_info: Parameters for dst half channel
+ * @dst_info: Parameters for dst half channel
+ * @pre_transfer_data: Data to be passed on to the pre_transfer() function.
+ * @pre_transfer: Callback used if needed before preparation of transfer.
+ * Only called if device is set. size of bytes to transfer
+ * (in case of multiple element transfer size is size of the first element).
+ *
+ *
+ * This structure has to be filled by the client drivers.
+ * It is recommended to do all dma configurations for clients in the machine.
+ *
+ */
+struct stedma40_chan_cfg {
+	enum stedma40_xfer_dir			 dir;
+	unsigned int				 channel_type;
+	int					 src_dev_type;
+	int					 dst_dev_type;
+	struct stedma40_half_channel_info	 src_info;
+	struct stedma40_half_channel_info	 dst_info;
+	void					*pre_transfer_data;
+	int (*pre_transfer)			(struct dma_chan *chan,
+						 void *data,
+						 int size);
+};
+
+/**
+ * struct stedma40_platform_data - Configuration struct for the dma device.
+ *
+ * @dev_len: length of dev_tx and dev_rx
+ * @dev_tx: mapping between destination event line and io address
+ * @dev_rx: mapping between source event line and io address
+ * @memcpy: list of memcpy event lines
+ * @memcpy_len: length of memcpy
+ * @memcpy_conf_phy: default configuration of physical channel memcpy
+ * @memcpy_conf_log: default configuration of logical channel memcpy
+ * @llis_per_log: number of max linked list items per logical channel
+ *
+ */
+struct stedma40_platform_data {
+	u32				 dev_len;
+	const dma_addr_t		*dev_tx;
+	const dma_addr_t		*dev_rx;
+	int				*memcpy;
+	u32				 memcpy_len;
+	struct stedma40_chan_cfg	*memcpy_conf_phy;
+	struct stedma40_chan_cfg	*memcpy_conf_log;
+	unsigned int			 llis_per_log;
+};
+
+/**
+ * setdma40_set_psize() - Used for changing the package size of an
+ * already configured dma channel.
+ *
+ * @chan: dmaengine handle
+ * @src_psize: new package side for src. (STEDMA40_PSIZE*)
+ * @src_psize: new package side for dst. (STEDMA40_PSIZE*)
+ *
+ * returns 0 on ok, otherwise negative error number.
+ */
+int stedma40_set_psize(struct dma_chan *chan,
+		       int src_psize,
+		       int dst_psize);
+
+
+/**
+ * setdma40_pause() - Pause an ongoing dma transfer.
+ *
+ * @chan: dmaengine handle
+ *
+ * returns 0 on ok, otherwise negative error number.
+ */
+int stedma40_pause(struct dma_chan *chan);
+
+/**
+ * setdma40_unpause() - Resumes an paused dma transfer.
+ *
+ * @chan: dmaengine handle
+ *
+ * returns 0 on ok, otherwise negative error number.
+ */
+int stedma40_unpause(struct dma_chan *chan);
+
+/**
+ * setdma40_residue() - Returna the remaining bytes to transfer.
+ *
+ * @chan: dmaengine handle
+ *
+ * returns 0 or positive number of remaning bytes,
+ *         otherwise negative error number.
+ */
+int stedma40_residue(struct dma_chan *chan);
+
+/**
+ * stedma40_filter() - Provides stedma40_chan_cfg to the
+ * ste_dma40 dma driver via the dmaengine framework.
+ * does some checking of what's provided.
+ *
+ * Never directly called by client. It used by dmaengine.
+ * @chan: dmaengine handle.
+ * @data: Must be of type: struct stedma40_chan_cfg and is
+ * the configuration of the framework.
+ *
+ *
+ */
+
+bool stedma40_filter(struct dma_chan *chan, void *data);
+
+/**
+ * stedma40_memcpy_sg() - extension of the dma framework, memcpy to/from
+ * scattergatter lists.
+ *
+ * @chan: dmaengine handle
+ * @sgl_dst: Destination scatter list
+ * @sgl_src: Source scatter list
+ * @sgl_len: The length of each scatterlist. Both lists must be of equal length
+ * and each element must match the corresponding element in the other scatter
+ * list.
+ * @flags: is actually enum dma_ctrl_flags. See dmaengine.h
+ */
+
+struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
+						   struct scatterlist *sgl_dst,
+						   struct scatterlist *sgl_src,
+						   unsigned int sgl_len,
+						   unsigned long flags);
+
+/**
+ * stedma40_slave_mem() - Transfers a raw data buffer to or from a slave
+ * (=device)
+ *
+ * @chan: dmaengine handle
+ * @addr: source or destination physicall address.
+ * @size: bytes to transfer
+ * @direction: direction of transfer
+ * @flags: is actually enum dma_ctrl_flags. See dmaengine.h
+ */
+
+static inline struct
+dma_async_tx_descriptor *stedma40_slave_mem(struct dma_chan *chan,
+					    dma_addr_t addr,
+					    unsigned int size,
+					    enum dma_data_direction direction,
+					    unsigned long flags)
+{
+	struct scatterlist sg;
+	sg_init_table(&sg, 1);
+	sg.dma_address = addr;
+	sg.length = size;
+
+	return chan->device->device_prep_slave_sg(chan, &sg, 1,
+						  direction, flags);
+}
+
+#endif
diff --git a/arch/arm/mach-ux500/ste-dma40-db8500.h b/arch/arm/mach-ux500/ste-dma40-db8500.h
new file mode 100644
index 0000000..8a4994e
--- /dev/null
+++ b/arch/arm/mach-ux500/ste-dma40-db8500.h
@@ -0,0 +1,133 @@
+/*
+ * arch/arm/mach-ux500/ste_dma40_db8500.h
+ * DB8500-SoC-specific configuration for DMA40
+ *
+ * Copyright (C) ST-Ericsson 2007-2010
+ * License terms: GNU General Public License (GPL) version 2
+ * Author: Per Friden <per.friden@stericsson.com>
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
+ */
+#ifndef STE_DMA40_DB8500_H
+#define STE_DMA40_DB8500_H
+
+#define STEDMA40_DEV_MAX 64
+
+enum dma_src_dev_type {
+	STEDMA40_DEV_SPI0_RX = 0,
+	STEDMA40_DEV_SD_MMC0_RX,
+	STEDMA40_DEV_SD_MMC1_RX,
+	STEDMA40_DEV_SD_MMC2_RX,
+	STEDMA40_DEV_I2C1_RX,
+	STEDMA40_DEV_I2C3_RX,
+	STEDMA40_DEV_I2C2_RX,
+	STEDMA40_DEV_SSP0_RX = 8,
+	STEDMA40_DEV_SSP1_RX,
+	STEDMA40_DEV_MCDE_RX,
+	STEDMA40_DEV_UART2_RX,
+	STEDMA40_DEV_UART1_RX,
+	STEDMA40_DEV_UART0_RX,
+	STEDMA40_DEV_MSP2_RX,
+	STEDMA40_DEV_I2C0_RX,	/*15*/
+	STEDMA40_DEV_USB_OTG_IEP_8,
+	STEDMA40_DEV_USB_OTG_IEP_1_9,
+	STEDMA40_DEV_USB_OTG_IEP_2_10,
+	STEDMA40_DEV_USB_OTG_IEP_3_11,
+	STEDMA40_DEV_SLIM0_CH0_RX_HSI_RX_CH0,
+	STEDMA40_DEV_SLIM0_CH1_RX_HSI_RX_CH1,
+	STEDMA40_DEV_SLIM0_CH2_RX_HSI_RX_CH2,
+	STEDMA40_DEV_SLIM0_CH3_RX_HSI_RX_CH3,
+	STEDMA40_DEV_SRC_SXA0_RX_TX,
+	STEDMA40_DEV_SRC_SXA1_RX_TX,
+	STEDMA40_DEV_SRC_SXA2_RX_TX,
+	STEDMA40_DEV_SRC_SXA3_RX_TX,
+	STEDMA40_DEV_SD_MM2_RX,
+	STEDMA40_DEV_SD_MM0_RX,
+	STEDMA40_DEV_MSP1_RX,
+	STEDMA40_SLIM0_CH0_RX,
+	STEDMA40_DEV_MSP0_RX = STEDMA40_SLIM0_CH0_RX,
+	STEDMA40_DEV_SD_MM1_RX,
+	STEDMA40_DEV_SPI2_RX,
+	STEDMA40_DEV_I2C3_RX2,
+	STEDMA40_DEV_SPI1_RX,
+	STEDMA40_DEV_USB_OTG_IEP_4_12,
+	STEDMA40_DEV_USB_OTG_IEP_5_13,
+	STEDMA40_DEV_USB_OTG_IEP_6_14,
+	STEDMA40_DEV_USB_OTG_IEP_7_15,
+	STEDMA40_DEV_SPI3_RX,
+	STEDMA40_DEV_SD_MM3_RX,
+	STEDMA40_DEV_SD_MM4_RX,
+	STEDMA40_DEV_SD_MM5_RX,
+	STEDMA40_DEV_SRC_SXA4_RX_TX,
+	STEDMA40_DEV_SRC_SXA5_RX_TX,
+	STEDMA40_DEV_SRC_SXA6_RX_TX,
+	STEDMA40_DEV_SRC_SXA7_RX_TX,
+	STEDMA40_DEV_CAC1_RX,
+	STEDMA40_DEV_MSHC_RX = 51,
+	STEDMA40_DEV_SLIM1_CH0_RX_HSI_RX_CH4,
+	STEDMA40_DEV_SLIM1_CH1_RX_HSI_RX_CH5,
+	STEDMA40_DEV_SLIM1_CH2_RX_HSI_RX_CH6,
+	STEDMA40_DEV_SLIM1_CH3_RX_HSI_RX_CH7,
+	STEDMA40_DEV_CAC0_RX = 61,
+};
+
+enum dma_dest_dev_type {
+	STEDMA40_DEV_SPI0_TX = 0,
+	STEDMA40_DEV_SD_MMC0_TX,
+	STEDMA40_DEV_SD_MMC1_TX,
+	STEDMA40_DEV_SD_MMC2_TX,
+	STEDMA40_DEV_I2C1_TX,
+	STEDMA40_DEV_I2C3_TX,
+	STEDMA40_DEV_I2C2_TX,
+	STEDMA40_DEV_SSP0_TX = 8,
+	STEDMA40_DEV_SSP1_TX,
+	STEDMA40_DEV_UART2_TX = 11,
+	STEDMA40_DEV_UART1_TX,
+	STEDMA40_DEV_UART0_TX,
+	STEDMA40_DEV_MSP2_TX,
+	STEDMA40_DEV_I2C0_TX,
+	STEDMA40_DEV_USB_OTG_OEP_8,
+	STEDMA40_DEV_USB_OTG_OEP_1_9,
+	STEDMA40_DEV_USB_OTG_OEP_2_10,
+	STEDMA40_DEV_USB_OTG_OEP_3_11,
+	STEDMA40_DEV_SLIM0_CH0_TX_HSI_TX_CH0,
+	STEDMA40_DEV_SLIM0_CH1_TX_HSI_TX_CH1,
+	STEDMA40_DEV_SLIM0_CH2_TX_HSI_TX_CH2,
+	STEDMA40_DEV_SLIM0_CH3_TX_HSI_TX_CH3,
+	STEDMA40_DEV_DST_SXA0_RX_TX,
+	STEDMA40_DEV_DST_SXA1_RX_TX,
+	STEDMA40_DEV_DST_SXA2_RX_TX,
+	STEDMA40_DEV_DST_SXA3_RX_TX,
+	STEDMA40_DEV_SD_MM2_TX,
+	STEDMA40_DEV_SD_MM0_TX,
+	STEDMA40_DEV_MSP1_TX,
+	STEDMA40_SLIM0_CH0_TX,
+	STEDMA40_DEV_MSP0_TX = STEDMA40_SLIM0_CH0_TX,
+	STEDMA40_DEV_SD_MM1_TX,
+	STEDMA40_DEV_SPI2_TX,
+	STEDMA40_DEV_I2C3_TX2,
+	STEDMA40_DEV_SPI1_TX,
+	STEDMA40_DEV_USB_OTG_OEP_4_12,
+	STEDMA40_DEV_USB_OTG_OEP_5_13,
+	STEDMA40_DEV_USB_OTG_OEP_6_14,
+	STEDMA40_DEV_USB_OTG_OEP_7_15,
+	STEDMA40_DEV_SPI3_TX,
+	STEDMA40_DEV_SD_MM3_TX,
+	STEDMA40_DEV_SD_MM4_TX,
+	STEDMA40_DEV_SD_MM5_TX,
+	STEDMA40_DEV_DST_SXA4_RX_TX,
+	STEDMA40_DEV_DST_SXA5_RX_TX,
+	STEDMA40_DEV_DST_SXA6_RX_TX,
+	STEDMA40_DEV_DST_SXA7_RX_TX,
+	STEDMA40_DEV_CAC1_TX,
+	STEDMA40_DEV_CAC1_TX_HAC1_TX,
+	STEDMA40_DEV_HAC1_TX,
+	STEDMA40_MEMCPY_TX_1 = 56,
+	STEDMA40_MEMCPY_TX_2,
+	STEDMA40_MEMCPY_TX_3,
+	STEDMA40_MEMCPY_TX_4,
+	STEDMA40_DEV_CAC0_TX = 61,
+	STEDMA40_DEV_CAC0_TX_HAC0_TX,
+	STEDMA40_DEV_HAC0_TX,
+};
+
+#endif
-- 
1.6.2.5

