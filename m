Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZIPITU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZIPITU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZIPITS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:19:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52003 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZIPITQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:19:16 -0400
Date: Wed, 16 Sep 2009 17:19:17 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 1/3] ARM: S5PC100: add dma platform resources for s5pc100
To: linux-arm-kernel@lists.infradead.org
Cc: ben-linux@fluff.org, dan.j.williams@intel.com, kyungmin.park@samsung.com,
       bhmin@samsung.com, linux-kernel@vger.kernel.org
Message-id: <4AB09F85.3070508@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
X-OriginalArrivalTime: 16 Sep 2009 08:19:17.0598 (UTC)
 FILETIME=[62596FE0:01CA36A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S5PC100 has three the pl330 dma controller. The mdma is for memory
to memory transfer, and the pdma0 and pdma1 are for peripheral to memory
transfer. Also this can be used on the S5PC110 later.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 arch/arm/mach-s5pc100/include/mach/map.h     |    5 +
 arch/arm/plat-s5pc1xx/Makefile               |    1 +
 arch/arm/plat-s5pc1xx/dev-dma.c              |  110 +++++++++++++++++++++++++
 arch/arm/plat-s5pc1xx/include/plat/dma.h     |  112 ++++++++++++++++++++++++++
 arch/arm/plat-s5pc1xx/include/plat/s5pc100.h |    3 +
 5 files changed, 231 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-s5pc1xx/dev-dma.c
 create mode 100644 arch/arm/plat-s5pc1xx/include/plat/dma.h

diff --git a/arch/arm/mach-s5pc100/include/mach/map.h b/arch/arm/mach-s5pc100/include/mach/map.h
index 4f82430..477b50c 100644
--- a/arch/arm/mach-s5pc100/include/mach/map.h
+++ b/arch/arm/mach-s5pc100/include/mach/map.h
@@ -40,6 +40,11 @@
 #define S5PC1XX_PA_VIC(x)	(S5PC100_PA_VIC + ((x) * S5PC100_PA_VIC_OFFSET))
 #define S5PC1XX_VA_VIC(x)	(S5PC100_VA_VIC + ((x) * S5PC100_VA_VIC_OFFSET))
 
+/* DMA */
+#define S5PC100_PA_MDMA		(0xE8100000)
+#define S5PC100_PA_PDMA0	(0xE9000000)
+#define S5PC100_PA_PDMA1	(0xE9200000)
+
 /* Timer */
 #define S5PC100_PA_TIMER	(0xEA000000)
 #define S5PC1XX_PA_TIMER	S5PC100_PA_TIMER
diff --git a/arch/arm/plat-s5pc1xx/Makefile b/arch/arm/plat-s5pc1xx/Makefile
index f1ecb2c..7dd3e74 100644
--- a/arch/arm/plat-s5pc1xx/Makefile
+++ b/arch/arm/plat-s5pc1xx/Makefile
@@ -11,6 +11,7 @@ obj-				:=
 
 # Core files
 
+obj-y				+= dev-dma.o
 obj-y				+= dev-uart.o
 obj-y				+= cpu.o
 obj-y				+= irq.o
diff --git a/arch/arm/plat-s5pc1xx/dev-dma.c b/arch/arm/plat-s5pc1xx/dev-dma.c
new file mode 100644
index 0000000..6e36073
--- /dev/null
+++ b/arch/arm/plat-s5pc1xx/dev-dma.c
@@ -0,0 +1,110 @@
+/*
+ * linux/arch/arm/plat-s5pc1xx/dev-dma.c
+ *
+ * Copyright (C) 2009 Samsung Electronics Co.Ltd
+ * Author: Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/platform_device.h>
+
+#include <asm/mach/irq.h>
+#include <mach/map.h>
+#include <plat/dma.h>
+
+static struct resource s5pc1xx_mdma_resource[] = {
+	[0] = {
+		.start  = S5PC100_PA_MDMA,
+		.end    = S5PC100_PA_MDMA + SZ_4K,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_MDMA,
+		.end	= IRQ_MDMA,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource s5pc1xx_pdma0_resource[] = {
+	[0] = {
+		.start  = S5PC100_PA_PDMA0,
+		.end    = S5PC100_PA_PDMA0 + SZ_4K,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_PDMA0,
+		.end	= IRQ_PDMA0,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource s5pc1xx_pdma1_resource[] = {
+	[0] = {
+		.start  = S5PC100_PA_PDMA1,
+		.end    = S5PC100_PA_PDMA1 + SZ_4K,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_PDMA1,
+		.end	= IRQ_PDMA1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static u64 s5pc1xx_device_dma_dmamask = 0xffffffffUL;
+
+static struct pl330_platform_data s5pc1xx_mdma_pdata;
+static struct pl330_platform_data s5pc1xx_pdma0_pdata;
+static struct pl330_platform_data s5pc1xx_pdma1_pdata;
+
+struct platform_device s5pc1xx_device_mdma = {
+	.name		= "pl330",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(s5pc1xx_mdma_resource),
+	.resource	= s5pc1xx_mdma_resource,
+	.dev		= {
+		.dma_mask		= &s5pc1xx_device_dma_dmamask,
+		.coherent_dma_mask	= 0xffffffffUL,
+		.platform_data		= &s5pc1xx_mdma_pdata,
+	},
+};
+
+struct platform_device s5pc1xx_device_pdma0 = {
+	.name		= "pl330",
+	.id		= 1,
+	.num_resources	= ARRAY_SIZE(s5pc1xx_pdma0_resource),
+	.resource	= s5pc1xx_pdma0_resource,
+	.dev		= {
+		.dma_mask		= &s5pc1xx_device_dma_dmamask,
+		.coherent_dma_mask	= 0xffffffffUL,
+		.platform_data		= &s5pc1xx_pdma0_pdata,
+	},
+};
+
+struct platform_device s5pc1xx_device_pdma1 = {
+	.name		= "pl330",
+	.id		= 2,
+	.num_resources	= ARRAY_SIZE(s5pc1xx_pdma1_resource),
+	.resource	= s5pc1xx_pdma1_resource,
+	.dev		= {
+		.dma_mask		= &s5pc1xx_device_dma_dmamask,
+		.coherent_dma_mask	= 0xffffffffUL,
+		.platform_data		= &s5pc1xx_pdma1_pdata,
+	},
+};
+
+static __init int s5pc1xx_dma_init(void)
+{
+	dma_cap_set(DMA_MEMCPY, s5pc1xx_mdma_pdata.cap_mask);
+	dma_cap_set(DMA_SLAVE, s5pc1xx_pdma0_pdata.cap_mask);
+	dma_cap_set(DMA_SLAVE, s5pc1xx_pdma1_pdata.cap_mask);
+
+	return 0;
+}
+
+arch_initcall(s5pc1xx_dma_init);
diff --git a/arch/arm/plat-s5pc1xx/include/plat/dma.h b/arch/arm/plat-s5pc1xx/include/plat/dma.h
new file mode 100644
index 0000000..83e9102
--- /dev/null
+++ b/arch/arm/plat-s5pc1xx/include/plat/dma.h
@@ -0,0 +1,112 @@
+/*
+ * linux/arch/arm/plat-s5pc1xx/include/plat/dma.h
+ *
+ * Copyright (C) 2009 Samsung Electronics Co.Ltd
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * PL330 DMAC platform data definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __PLAT_DMA_H
+#define __PLAT_DMA_H
+
+#include <linux/dmaengine.h>
+
+/**
+ * enum s5pc1xx_pdma_peri - Peripheral number of S5PC1XX
+ */
+enum s5pc1xx_pdma_peri {
+	PDMA_UART0_RX = 0,
+	PDMA_UART0_TX,
+	PDMA_UART1_RX,
+	PDMA_UART1_TX,
+	PDMA_UART2_RX,
+	PDMA_UART2_TX,
+	PDMA_UART3_RX,
+	PDMA_UART3_TX,
+	PDMA_IRDA,		/* s5pc100 only */
+	PDMA_I2S0_RX = 9,
+	PDMA_I2S0_TX,
+	PDMA_I2S0S_TX,
+	PDMA_I2S1_RX,
+	PDMA_I2S1_TX,
+	PDMA_I2S2_RX,
+	PDMA_I2S2_TX,
+	PDMA_SPI0_RX = 16,
+	PDMA_SPI0_TX,
+	PDMA_SPI1_RX,
+	PDMA_SPI1_TX,
+	PDMA_SPI2_RX,
+	PDMA_SPI2_TX,
+	PDMA0_AC_MICIN,
+	PDMA0_AC_PCMIN,
+	PDMA0_AC_PCMOUT,
+	PDMA0_EXTERNAL_GPIO,	/* s5pc100 only */
+	PDMA0_PWM = 26,
+	PDMA0_SPDIF,
+	PDMA0_HSI_RX,		/* s5pc100 only */
+	PDMA0_HSI_TX,		/* s5pc100 only */
+	PDMA1_PCM0_RX = 22,
+	PDMA1_PCM0_TX,
+	PDMA1_PCM1_RX,
+	PDMA1_PCM1_TX,
+	PDMA1_MSM_REQ0,
+	PDMA1_MSM_REQ1,
+	PDMA1_MSM_REQ2,
+	PDMA1_MSM_REQ3,
+	PDMA1_PCM2_RX,		/* s5pc110 only */
+	PDMA1_PCM2_TX,		/* s5pc110 only */
+};
+
+/**
+ * struct pl330_platform_data - Platform device data for PL330 DMAC
+ * @cap_mask: one or more dma_capability flags
+ */
+struct pl330_platform_data {
+	dma_cap_mask_t		cap_mask;
+};
+
+/**
+ * enum pl330_dma_slave_width - DMA slave register access width.
+ * @PL330_DMA_SLAVE_WIDTH_1BYTE: Do 1-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_2BYTE: Do 2-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_4BYTE: Do 4-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_8BYTE: Do 8-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_16BYTE: Do 16-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_32BYTE: Do 32-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_64BYTE: Do 64-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_128BYTE: Do 128-byte slave register accesses
+ */
+enum pl330_dma_slave_width {
+	PL330_DMA_SLAVE_WIDTH_1BYTE = 0,
+	PL330_DMA_SLAVE_WIDTH_2BYTE,
+	PL330_DMA_SLAVE_WIDTH_4BYTE,
+	PL330_DMA_SLAVE_WIDTH_8BYTE,
+	PL330_DMA_SLAVE_WIDTH_16BYTE,
+	PL330_DMA_SLAVE_WIDTH_32BYTE,
+	PL330_DMA_SLAVE_WIDTH_64BYTE,
+	PL330_DMA_SLAVE_WIDTH_128BYTE,
+};
+
+/**
+ * struct pl330_dma_slave - Controller-specific information about a slave
+ * @tx_reg: physical address of data register used for
+ *	memory-to-peripheral transfers
+ * @rx_reg: physical address of data register used for
+ *	peripheral-to-memory transfers
+ * @reg_width: peripheral register width
+ * @peri_num: peripheral number
+ */
+struct pl330_dma_slave {
+	dma_addr_t			tx_reg;
+	dma_addr_t			rx_reg;
+	enum pl330_dma_slave_width	reg_width;
+	enum s5pc1xx_pdma_peri		peri_num;
+};
+
+#endif /* __PLAT_DMA_H */
diff --git a/arch/arm/plat-s5pc1xx/include/plat/s5pc100.h b/arch/arm/plat-s5pc1xx/include/plat/s5pc100.h
index 45e2751..5f67447 100644
--- a/arch/arm/plat-s5pc1xx/include/plat/s5pc100.h
+++ b/arch/arm/plat-s5pc1xx/include/plat/s5pc100.h
@@ -63,3 +63,6 @@ extern struct platform_device s3c_device_fimc0;
 extern struct platform_device s3c_device_fimc1;
 extern struct platform_device s3c_device_fimc2;
 
+extern struct platform_device s5pc1xx_device_mdma;
+extern struct platform_device s5pc1xx_device_pdma0;
+extern struct platform_device s5pc1xx_device_pdma1;
-- 
1.6.0.4
