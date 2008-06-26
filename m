Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbYFZNZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbYFZNZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761057AbYFZNY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:24:27 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59192 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYFZNYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:24:21 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       kernel@avr32linux.org, shannon.nelson@intel.com,
       David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v4 6/6] Atmel MCI: Driver for Atmel on-chip MMC controllers
Date: Thu, 26 Jun 2008 15:23:23 +0200
Message-Id: <1214486603-23655-7-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214486603-23655-6-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
 <1214486603-23655-6-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 26 Jun 2008 13:23:06.0947 (UTC) FILETIME=[C53D1930:01C8D78F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for the MMC controller on the AP7000 chips from
Atmel. It should in theory work on AT91 systems too with some
tweaking, but since the DMA interface is quite different, it's not
entirely clear if it's worth merging this with the at91_mci driver.

This driver has been around for a while in BSPs and kernel sources
provided by Atmel, but this particular version uses the generic DMA
Engine framework (with the slave extensions) instead of an
avr32-only DMA controller framework.

This driver can also use PIO transfers when no DMA channels are
available, and for transfers where using DMA may be difficult or
impractical for some reason (e.g. the DMA setup overhead is usually
not worth it for very short transfers, and badly aligned buffers or
lengths are difficult to handle.)

The driver has been tested using mmc-block and ext3fs on several SD,
SDHC and MMC+ cards. Reads and writes work fine, with read transfer
rates up to 7.2 MiB/s on fast cards with debugging disabled.

The driver has also been tested using the mmc_test module on the same
cards. All tests except 7, 9, 15 and 17 succeed. The first two are
unsupported by all the cards I have, so I don't know if the driver
handles this correctly. The last two fail because the hardware flags a
Data CRC Error instead of a Data Timeout error. I'm not sure how to deal
with that.

Documentation for this controller can be found in many data sheets from
Atmel, including the AT32AP7000 data sheet which can be found here:

http://www.atmel.com/dyn/products/datasheets.asp?family_id=682

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Changes since v3:
  * Update to latest DMA slave API
  * Use debugfs root created by mmc core
  * Kill fmax module parameter
  * Round MMC clock rate down
  * Fix unreliable card detection (using a debounce timer and
    terminating commands early.)
  * Handle descriptor allocation errors (just fail the transfer)
  * Tune block parameters (max_hw_segs, etc.)

Changes since v2:
  * Reset the controller after each transfer since we're violating the
    spec sometimes. This is very cheap, so we don't try to be clever.
  * Turn off the MMC clock when no requests are pending.
  * Implement support for PIO transfers (i.e. not using DMA.)
  * Rename atmel-mci.h -> atmel-mci-regs.h
  * Use controller-specific data passed from the platform code to set
    up DMA slave transfers. These parameters include including physical
    DMA device, peripheral handshake IDs, channel priorities, etc.
  * Fix several card removal bugs
---
 arch/avr32/boards/atngw100/setup.c      |    7 +
 arch/avr32/boards/atstk1000/atstk1002.c |    3 +
 arch/avr32/mach-at32ap/at32ap700x.c     |   47 +-
 drivers/mmc/host/Kconfig                |   10 +
 drivers/mmc/host/Makefile               |    1 +
 drivers/mmc/host/atmel-mci-regs.h       |  194 +++++
 drivers/mmc/host/atmel-mci.c            | 1428 +++++++++++++++++++++++++++++++
 include/asm-avr32/arch-at32ap/board.h   |    6 +-
 include/asm-avr32/atmel-mci.h           |   12 +
 9 files changed, 1702 insertions(+), 6 deletions(-)
 create mode 100644 drivers/mmc/host/atmel-mci-regs.h
 create mode 100644 drivers/mmc/host/atmel-mci.c
 create mode 100644 include/asm-avr32/atmel-mci.h

diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index a398be2..96833bf 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -17,6 +17,7 @@
 #include <linux/leds.h>
 #include <linux/spi/spi.h>
 
+#include <asm/atmel-mci.h>
 #include <asm/io.h>
 #include <asm/setup.h>
 
@@ -42,6 +43,11 @@ static struct spi_board_info spi0_board_info[] __initdata = {
 	},
 };
 
+static struct mci_platform_data __initdata mci0_data = {
+	.detect_pin	= GPIO_PIN_PC(25),
+	.wp_pin		= GPIO_PIN_PE(0),
+};
+
 /*
  * The next two functions should go away as the boot loader is
  * supposed to initialize the macb address registers with a valid
@@ -157,6 +163,7 @@ static int __init atngw100_init(void)
 	set_hw_addr(at32_add_device_eth(1, &eth_data[1]));
 
 	at32_add_device_spi(0, spi0_board_info, ARRAY_SIZE(spi0_board_info));
+	at32_add_device_mci(0, &mci0_data);
 	at32_add_device_usba(0, NULL);
 
 	for (i = 0; i < ARRAY_SIZE(ngw_leds); i++) {
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index 000eb42..8b92cd6 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -228,6 +228,9 @@ static int __init atstk1002_init(void)
 #ifdef CONFIG_BOARD_ATSTK100X_SPI1
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
+#ifndef CONFIG_BOARD_ATSTK1002_SW2_CUSTOM
+	at32_add_device_mci(0, NULL);
+#endif
 #ifdef CONFIG_BOARD_ATSTK1002_SW5_CUSTOM
 	set_hw_addr(at32_add_device_eth(1, &eth_data[1]));
 #else
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 2b92047..1d47605 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -7,6 +7,7 @@
  */
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/dw_dmac.h>
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -14,6 +15,7 @@
 #include <linux/spi/spi.h>
 #include <linux/usb/atmel_usba_udc.h>
 
+#include <asm/atmel-mci.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
@@ -1199,20 +1201,48 @@ static struct clk atmel_mci0_pclk = {
 	.index		= 9,
 };
 
-struct platform_device *__init at32_add_device_mci(unsigned int id)
+struct platform_device *__init
+at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
-	struct platform_device *pdev;
+	struct mci_platform_data	_data;
+	struct platform_device		*pdev;
+	struct dw_dma_slave		*dws;
 
 	if (id != 0)
 		return NULL;
 
 	pdev = platform_device_alloc("atmel_mci", id);
 	if (!pdev)
-		return NULL;
+		goto fail;
 
 	if (platform_device_add_resources(pdev, atmel_mci0_resource,
 				ARRAY_SIZE(atmel_mci0_resource)))
-		goto err_add_resources;
+		goto fail;
+
+	if (!data) {
+		data = &_data;
+		memset(data, 0, sizeof(struct mci_platform_data));
+	}
+
+	if (data->dma_slave)
+		dws = kmemdup(to_dw_dma_slave(data->dma_slave),
+				sizeof(struct dw_dma_slave), GFP_KERNEL);
+	else
+		dws = kzalloc(sizeof(struct dw_dma_slave), GFP_KERNEL);
+
+	dws->slave.dev = &pdev->dev;
+	dws->slave.dma_dev = &dw_dmac0_device.dev;
+	dws->slave.reg_width = DMA_SLAVE_WIDTH_32BIT;
+	dws->cfg_hi = (DWC_CFGH_SRC_PER(0)
+				| DWC_CFGH_DST_PER(1));
+	dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL
+				| DWC_CFGL_HS_SRC_POL);
+
+	data->dma_slave = &dws->slave;
+
+	if (platform_device_add_data(pdev, data,
+				sizeof(struct mci_platform_data)))
+		goto fail;
 
 	select_peripheral(PA(10), PERIPH_A, 0);	/* CLK	 */
 	select_peripheral(PA(11), PERIPH_A, 0);	/* CMD	 */
@@ -1221,12 +1251,19 @@ struct platform_device *__init at32_add_device_mci(unsigned int id)
 	select_peripheral(PA(14), PERIPH_A, 0);	/* DATA2 */
 	select_peripheral(PA(15), PERIPH_A, 0);	/* DATA3 */
 
+	if (data) {
+		if (data->detect_pin != GPIO_PIN_NONE)
+			at32_select_gpio(data->detect_pin, 0);
+		if (data->wp_pin != GPIO_PIN_NONE)
+			at32_select_gpio(data->wp_pin, 0);
+	}
+
 	atmel_mci0_pclk.dev = &pdev->dev;
 
 	platform_device_add(pdev);
 	return pdev;
 
-err_add_resources:
+fail:
 	platform_device_put(pdev);
 	return NULL;
 }
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index dead617..fca47c1 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -91,6 +91,16 @@ config MMC_AT91
 
 	  If unsure, say N.
 
+config MMC_ATMELMCI
+	tristate "Atmel Multimedia Card Interface support"
+	depends on AVR32 && DMA_ENGINE
+	help
+	  This selects the Atmel Multimedia Card Interface driver. If
+	  you have an AT32 (AVR32) platform with a Multimedia Card
+	  slot, say Y or M here.
+
+	  If unsure, say N.
+
 config MMC_IMX
 	tristate "Motorola i.MX Multimedia Card Interface support"
 	depends on ARCH_IMX
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 3877c87..e80ea72 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_MMC_WBSD)		+= wbsd.o
 obj-$(CONFIG_MMC_AU1X)		+= au1xmmc.o
 obj-$(CONFIG_MMC_OMAP)		+= omap.o
 obj-$(CONFIG_MMC_AT91)		+= at91_mci.o
+obj-$(CONFIG_MMC_ATMELMCI)	+= atmel-mci.o
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
 obj-$(CONFIG_MMC_SPI)		+= mmc_spi.o
 
diff --git a/drivers/mmc/host/atmel-mci-regs.h b/drivers/mmc/host/atmel-mci-regs.h
new file mode 100644
index 0000000..7719e37
--- /dev/null
+++ b/drivers/mmc/host/atmel-mci-regs.h
@@ -0,0 +1,194 @@
+/*
+ * Atmel MultiMedia Card Interface driver
+ *
+ * Copyright (C) 2004-2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __DRIVERS_MMC_ATMEL_MCI_H__
+#define __DRIVERS_MMC_ATMEL_MCI_H__
+
+/* MCI register offsets */
+#define MCI_CR					0x0000
+#define MCI_MR					0x0004
+#define MCI_DTOR				0x0008
+#define MCI_SDCR				0x000c
+#define MCI_ARGR				0x0010
+#define MCI_CMDR				0x0014
+#define MCI_BLKR				0x0018
+#define MCI_RSPR				0x0020
+#define MCI_RSPR1				0x0024
+#define MCI_RSPR2				0x0028
+#define MCI_RSPR3				0x002c
+#define MCI_RDR					0x0030
+#define MCI_TDR					0x0034
+#define MCI_SR					0x0040
+#define MCI_IER					0x0044
+#define MCI_IDR					0x0048
+#define MCI_IMR					0x004c
+
+/* Bitfields in CR */
+#define MCI_MCIEN_OFFSET			0
+#define MCI_MCIEN_SIZE				1
+#define MCI_MCIDIS_OFFSET			1
+#define MCI_MCIDIS_SIZE				1
+#define MCI_PWSEN_OFFSET			2
+#define MCI_PWSEN_SIZE				1
+#define MCI_PWSDIS_OFFSET			3
+#define MCI_PWSDIS_SIZE				1
+#define MCI_SWRST_OFFSET			7
+#define MCI_SWRST_SIZE				1
+
+/* Bitfields in MR */
+#define MCI_CLKDIV_OFFSET			0
+#define MCI_CLKDIV_SIZE				8
+#define MCI_PWSDIV_OFFSET			8
+#define MCI_PWSDIV_SIZE				3
+#define MCI_RDPROOF_OFFSET			11
+#define MCI_RDPROOF_SIZE			1
+#define MCI_WRPROOF_OFFSET			12
+#define MCI_WRPROOF_SIZE			1
+#define MCI_PDCFBYTE_OFFSET			13
+#define MCI_PDCFBYTE_SIZE			1
+#define MCI_DMAPADV_OFFSET			14
+#define MCI_DMAPADV_SIZE			1
+#define MCI_BLKLEN_OFFSET			16
+#define MCI_BLKLEN_SIZE				16
+
+/* Bitfields in DTOR */
+#define MCI_DTOCYC_OFFSET			0
+#define MCI_DTOCYC_SIZE				4
+#define MCI_DTOMUL_OFFSET			4
+#define MCI_DTOMUL_SIZE				3
+
+/* Bitfields in SDCR */
+#define MCI_SDCSEL_OFFSET			0
+#define MCI_SDCSEL_SIZE				4
+#define MCI_SDCBUS_OFFSET			7
+#define MCI_SDCBUS_SIZE				1
+
+/* Bitfields in ARGR */
+#define MCI_ARG_OFFSET				0
+#define MCI_ARG_SIZE				32
+
+/* Bitfields in CMDR */
+#define MCI_CMDNB_OFFSET			0
+#define MCI_CMDNB_SIZE				6
+#define MCI_RSPTYP_OFFSET			6
+#define MCI_RSPTYP_SIZE				2
+#define MCI_SPCMD_OFFSET			8
+#define MCI_SPCMD_SIZE				3
+#define MCI_OPDCMD_OFFSET			11
+#define MCI_OPDCMD_SIZE				1
+#define MCI_MAXLAT_OFFSET			12
+#define MCI_MAXLAT_SIZE				1
+#define MCI_TRCMD_OFFSET			16
+#define MCI_TRCMD_SIZE				2
+#define MCI_TRDIR_OFFSET			18
+#define MCI_TRDIR_SIZE				1
+#define MCI_TRTYP_OFFSET			19
+#define MCI_TRTYP_SIZE				2
+
+/* Bitfields in BLKR */
+#define MCI_BCNT_OFFSET				0
+#define MCI_BCNT_SIZE				16
+
+/* Bitfields in RSPRn */
+#define MCI_RSP_OFFSET				0
+#define MCI_RSP_SIZE				32
+
+/* Bitfields in SR/IER/IDR/IMR */
+#define MCI_CMDRDY_OFFSET			0
+#define MCI_CMDRDY_SIZE				1
+#define MCI_RXRDY_OFFSET			1
+#define MCI_RXRDY_SIZE				1
+#define MCI_TXRDY_OFFSET			2
+#define MCI_TXRDY_SIZE				1
+#define MCI_BLKE_OFFSET				3
+#define MCI_BLKE_SIZE				1
+#define MCI_DTIP_OFFSET				4
+#define MCI_DTIP_SIZE				1
+#define MCI_NOTBUSY_OFFSET			5
+#define MCI_NOTBUSY_SIZE			1
+#define MCI_ENDRX_OFFSET			6
+#define MCI_ENDRX_SIZE				1
+#define MCI_ENDTX_OFFSET			7
+#define MCI_ENDTX_SIZE				1
+#define MCI_RXBUFF_OFFSET			14
+#define MCI_RXBUFF_SIZE				1
+#define MCI_TXBUFE_OFFSET			15
+#define MCI_TXBUFE_SIZE				1
+#define MCI_RINDE_OFFSET			16
+#define MCI_RINDE_SIZE				1
+#define MCI_RDIRE_OFFSET			17
+#define MCI_RDIRE_SIZE				1
+#define MCI_RCRCE_OFFSET			18
+#define MCI_RCRCE_SIZE				1
+#define MCI_RENDE_OFFSET			19
+#define MCI_RENDE_SIZE				1
+#define MCI_RTOE_OFFSET				20
+#define MCI_RTOE_SIZE				1
+#define MCI_DCRCE_OFFSET			21
+#define MCI_DCRCE_SIZE				1
+#define MCI_DTOE_OFFSET				22
+#define MCI_DTOE_SIZE				1
+#define MCI_OVRE_OFFSET				30
+#define MCI_OVRE_SIZE				1
+#define MCI_UNRE_OFFSET				31
+#define MCI_UNRE_SIZE				1
+
+/* Constants for DTOMUL */
+#define MCI_DTOMUL_1_CYCLE			0
+#define MCI_DTOMUL_16_CYCLES			1
+#define MCI_DTOMUL_128_CYCLES			2
+#define MCI_DTOMUL_256_CYCLES			3
+#define MCI_DTOMUL_1024_CYCLES			4
+#define MCI_DTOMUL_4096_CYCLES			5
+#define MCI_DTOMUL_65536_CYCLES			6
+#define MCI_DTOMUL_1048576_CYCLES		7
+
+/* Constants for RSPTYP */
+#define MCI_RSPTYP_NO_RESP			0
+#define MCI_RSPTYP_48_BIT			1
+#define MCI_RSPTYP_136_BIT			2
+
+/* Constants for SPCMD */
+#define MCI_SPCMD_NO_SPEC_CMD			0
+#define MCI_SPCMD_INIT_CMD			1
+#define MCI_SPCMD_SYNC_CMD			2
+#define MCI_SPCMD_INT_CMD			4
+#define MCI_SPCMD_INT_RESP			5
+
+/* Constants for TRCMD */
+#define MCI_TRCMD_NO_TRANS			0
+#define MCI_TRCMD_START_TRANS			1
+#define MCI_TRCMD_STOP_TRANS			2
+
+/* Constants for TRTYP */
+#define MCI_TRTYP_BLOCK				0
+#define MCI_TRTYP_MULTI_BLOCK			1
+#define MCI_TRTYP_STREAM			2
+
+/* Bit manipulation macros */
+#define MCI_BIT(name)					\
+	(1 << MCI_##name##_OFFSET)
+#define MCI_BF(name,value)				\
+	(((value) & ((1 << MCI_##name##_SIZE) - 1))	\
+	 << MCI_##name##_OFFSET)
+#define MCI_BFEXT(name,value)				\
+	(((value) >> MCI_##name##_OFFSET)		\
+	 & ((1 << MCI_##name##_SIZE) - 1))
+#define MCI_BFINS(name,value,old)			\
+	(((old) & ~(((1 << MCI_##name##_SIZE) - 1)	\
+		    << MCI_##name##_OFFSET))		\
+	 | MCI_BF(name,value))
+
+/* Register access macros */
+#define mci_readl(port,reg)				\
+	__raw_readl((port)->regs + MCI_##reg)
+#define mci_writel(port,reg,value)			\
+	__raw_writel((value), (port)->regs + MCI_##reg)
+
+#endif /* __DRIVERS_MMC_ATMEL_MCI_H__ */
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
new file mode 100644
index 0000000..429bea8
--- /dev/null
+++ b/drivers/mmc/host/atmel-mci.c
@@ -0,0 +1,1428 @@
+/*
+ * Atmel MultiMedia Card Interface driver
+ *
+ * Copyright (C) 2004-2008 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/blkdev.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <linux/mmc/host.h>
+
+#include <asm/atmel-mci.h>
+#include <asm/io.h>
+#include <asm/unaligned.h>
+
+#include <asm/arch/board.h>
+#include <asm/arch/gpio.h>
+
+#include "atmel-mci-regs.h"
+
+#define ATMCI_DATA_ERROR_FLAGS	(MCI_BIT(DCRCE) | MCI_BIT(DTOE) |	\
+				 MCI_BIT(OVRE) | MCI_BIT(UNRE))
+
+#define ATMCI_DMA_THRESHOLD	16
+
+enum {
+	EVENT_CMD_COMPLETE = 0,
+	EVENT_DATA_ERROR,
+	EVENT_DATA_COMPLETE,
+	EVENT_STOP_SENT,
+	EVENT_STOP_COMPLETE,
+	EVENT_DMA_COMPLETE,
+};
+
+struct atmel_mci_dma {
+	struct dma_client		client;
+	struct dma_chan			*chan;
+	struct dma_async_tx_descriptor	*data_desc;
+};
+
+struct atmel_mci {
+	struct mmc_host		*mmc;
+	void __iomem		*regs;
+
+	struct scatterlist	*sg;
+	unsigned int		pio_offset;
+
+	struct mmc_request	*mrq;
+	struct mmc_command	*cmd;
+	struct mmc_data		*data;
+
+	struct atmel_mci_dma	dma;
+
+	/* DMA channel being used for the current data transfer */
+	struct dma_chan		*data_chan;
+
+	u32			cmd_status;
+	u32			data_status;
+	u32			stop_status;
+	u32			stop_cmdr;
+
+	u32			mode_reg;
+	u32			sdc_reg;
+
+	struct tasklet_struct	tasklet;
+	unsigned long		pending_events;
+	unsigned long		completed_events;
+
+	int			present;
+	int			detect_pin;
+	int			wp_pin;
+
+	/* For detect pin debouncing */
+	struct timer_list	detect_timer;
+
+	unsigned long		bus_hz;
+	unsigned long		mapbase;
+	struct clk		*mck;
+	struct platform_device	*pdev;
+
+#ifdef CONFIG_MMC_DEBUG_FS
+	struct dentry		*debugfs_regs;
+	struct dentry		*debugfs_req;
+	struct dentry		*debugfs_pending_events;
+	struct dentry		*debugfs_completed_events;
+#endif
+};
+
+static inline struct atmel_mci *
+dma_client_to_atmel_mci(struct dma_client *client)
+{
+	return container_of(client, struct atmel_mci, dma.client);
+}
+
+#define atmci_is_completed(host, event)				\
+	test_bit(event, &host->completed_events)
+#define atmci_test_and_clear_pending(host, event)		\
+	test_and_clear_bit(event, &host->pending_events)
+#define atmci_test_and_set_completed(host, event)		\
+	test_and_set_bit(event, &host->completed_events)
+#define atmci_set_completed(host, event)			\
+	set_bit(event, &host->completed_events)
+#define atmci_set_pending(host, event)				\
+	set_bit(event, &host->pending_events)
+#define atmci_clear_pending(host, event)			\
+	clear_bit(event, &host->pending_events)
+
+
+#ifdef CONFIG_MMC_DEBUG_FS
+#include <linux/debugfs.h>
+
+#define DBG_REQ_BUF_SIZE	(4096U - (unsigned int)sizeof(unsigned int))
+
+struct req_dbg_data {
+	unsigned int	nbytes;
+	char		str[DBG_REQ_BUF_SIZE];
+};
+
+static int req_dbg_open(struct inode *inode, struct file *file)
+{
+	struct atmel_mci	*host;
+	struct mmc_request	*mrq;
+	struct mmc_command	*cmd;
+	struct mmc_command	*stop;
+	struct mmc_data		*data;
+	struct req_dbg_data	*priv;
+	char			*str;
+	unsigned int		n = 0;
+
+	priv = kzalloc(DBG_REQ_BUF_SIZE, GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	str = priv->str;
+
+	mutex_lock(&inode->i_mutex);
+	host = inode->i_private;
+
+	spin_lock_irq(&host->mmc->lock);
+	mrq = host->mrq;
+	if (mrq) {
+		cmd = mrq->cmd;
+		data = mrq->data;
+		stop = mrq->stop;
+		n = snprintf(str, DBG_REQ_BUF_SIZE,
+			     "CMD%u(0x%x) %x %x %x %x %x (err %d)\n",
+			     cmd->opcode, cmd->arg, cmd->flags,
+			     cmd->resp[0], cmd->resp[1], cmd->resp[2],
+			     cmd->resp[3], cmd->error);
+		if (n < DBG_REQ_BUF_SIZE && data)
+			n += snprintf(str + n, DBG_REQ_BUF_SIZE - n,
+				      "DATA %u * %u (%u) %x (err %d)\n",
+				      data->blocks, data->blksz,
+				      data->bytes_xfered, data->flags,
+				      data->error);
+		if (n < DBG_REQ_BUF_SIZE && stop)
+			n += snprintf(str + n, DBG_REQ_BUF_SIZE - n,
+				      "CMD%u(0x%x) %x %x %x %x %x (err %d)\n",
+				      stop->opcode, stop->arg, stop->flags,
+				      stop->resp[0], stop->resp[1],
+				      stop->resp[2], stop->resp[3],
+				      stop->error);
+	}
+	spin_unlock_irq(&host->mmc->lock);
+	mutex_unlock(&inode->i_mutex);
+
+	priv->nbytes = min(n, DBG_REQ_BUF_SIZE);
+	file->private_data = priv;
+
+	return 0;
+}
+
+static ssize_t req_dbg_read(struct file *file, char __user *buf,
+			    size_t nbytes, loff_t *ppos)
+{
+	struct req_dbg_data *priv = file->private_data;
+
+	return simple_read_from_buffer(buf, nbytes, ppos,
+				       priv->str, priv->nbytes);
+}
+
+static int req_dbg_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static const struct file_operations req_dbg_fops = {
+	.owner		= THIS_MODULE,
+	.open		= req_dbg_open,
+	.llseek		= no_llseek,
+	.read		= req_dbg_read,
+	.release	= req_dbg_release,
+};
+
+static int regs_dbg_open(struct inode *inode, struct file *file)
+{
+	struct atmel_mci	*host;
+	unsigned int		i;
+	u32			*data;
+	int			ret;
+
+	mutex_lock(&inode->i_mutex);
+	host = inode->i_private;
+	data = kmalloc(inode->i_size, GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	spin_lock_irq(&host->mmc->lock);
+	for (i = 0; i < inode->i_size / 4; i++)
+		data[i] = __raw_readl(host->regs + i * 4);
+	spin_unlock_irq(&host->mmc->lock);
+
+	file->private_data = data;
+	ret = 0;
+
+out:
+	mutex_unlock(&inode->i_mutex);
+
+	return ret;
+}
+
+static ssize_t regs_dbg_read(struct file *file, char __user *buf,
+			     size_t nbytes, loff_t *ppos)
+{
+	struct inode	*inode = file->f_dentry->d_inode;
+	int		ret;
+
+	mutex_lock(&inode->i_mutex);
+	ret = simple_read_from_buffer(buf, nbytes, ppos,
+				      file->private_data,
+				      file->f_dentry->d_inode->i_size);
+	mutex_unlock(&inode->i_mutex);
+
+	return ret;
+}
+
+static int regs_dbg_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static const struct file_operations regs_dbg_fops = {
+	.owner		= THIS_MODULE,
+	.open		= regs_dbg_open,
+	.llseek		= generic_file_llseek,
+	.read		= regs_dbg_read,
+	.release	= regs_dbg_release,
+};
+
+static void atmci_init_debugfs(struct atmel_mci *host)
+{
+	struct mmc_host	*mmc;
+	struct dentry	*root;
+	struct dentry	*regs;
+	struct resource	*res;
+
+	mmc = host->mmc;
+	root = mmc->debugfs_root;
+	if (!root)
+		return;
+
+	regs = debugfs_create_file("regs", 0400, root, host, &regs_dbg_fops);
+	if (!regs)
+		goto err_regs;
+
+	res = platform_get_resource(host->pdev, IORESOURCE_MEM, 0);
+	regs->d_inode->i_size = res->end - res->start + 1;
+	host->debugfs_regs = regs;
+
+	host->debugfs_req = debugfs_create_file("req", 0400, root,
+						host, &req_dbg_fops);
+	if (!host->debugfs_req)
+		goto err_req;
+
+	host->debugfs_pending_events
+		= debugfs_create_x32("pending_events", 0400, root,
+				     (u32 *)&host->pending_events);
+	if (!host->debugfs_pending_events)
+		goto err_pending_events;
+
+	host->debugfs_completed_events
+		= debugfs_create_x32("completed_events", 0400, root,
+				     (u32 *)&host->completed_events);
+	if (!host->debugfs_completed_events)
+		goto err_completed_events;
+
+	return;
+
+err_completed_events:
+	debugfs_remove(host->debugfs_pending_events);
+	host->debugfs_pending_events = NULL;
+err_pending_events:
+	debugfs_remove(host->debugfs_regs);
+	host->debugfs_regs = NULL;
+err_regs:
+	debugfs_remove(host->debugfs_req);
+	host->debugfs_req = NULL;
+err_req:
+	dev_err(&host->pdev->dev,
+		"failed to initialize debugfs for controller\n");
+}
+
+static void atmci_cleanup_debugfs(struct atmel_mci *host)
+{
+	debugfs_remove(host->debugfs_completed_events);
+	debugfs_remove(host->debugfs_pending_events);
+	debugfs_remove(host->debugfs_regs);
+	debugfs_remove(host->debugfs_req);
+}
+#else
+static inline void atmci_init_debugfs(struct atmel_mci *host)
+{
+
+}
+
+static inline void atmci_cleanup_debugfs(struct atmel_mci *host)
+{
+
+}
+#endif /* CONFIG_MMC_DEBUG_FS */
+
+static void atmci_enable(struct atmel_mci *host)
+{
+	clk_enable(host->mck);
+	mci_writel(host, CR, MCI_BIT(MCIEN));
+	mci_writel(host, MR, host->mode_reg);
+	mci_writel(host, SDCR, host->sdc_reg);
+}
+
+static void atmci_disable(struct atmel_mci *host)
+{
+	mci_writel(host, CR, MCI_BIT(SWRST));
+
+	/* Stall until write is complete, then disable the bus clock */
+	mci_readl(host, SR);
+	clk_disable(host->mck);
+}
+
+static inline unsigned int ns_to_clocks(struct atmel_mci *host,
+					unsigned int ns)
+{
+	return (ns * (host->bus_hz / 1000000) + 999) / 1000;
+}
+
+static void atmci_set_timeout(struct atmel_mci *host,
+			      struct mmc_data *data)
+{
+	static unsigned	dtomul_to_shift[] = {
+		0, 4, 7, 8, 10, 12, 16, 20
+	};
+	unsigned	timeout;
+	unsigned	dtocyc;
+	unsigned	dtomul;
+
+	timeout = ns_to_clocks(host, data->timeout_ns) + data->timeout_clks;
+
+	for (dtomul = 0; dtomul < 8; dtomul++) {
+		unsigned shift = dtomul_to_shift[dtomul];
+		dtocyc = (timeout + (1 << shift) - 1) >> shift;
+		if (dtocyc < 15)
+			break;
+	}
+
+	if (dtomul >= 8) {
+		dtomul = 7;
+		dtocyc = 15;
+	}
+
+	dev_vdbg(&host->mmc->class_dev, "setting timeout to %u cycles\n",
+			dtocyc << dtomul_to_shift[dtomul]);
+	mci_writel(host, DTOR, (MCI_BF(DTOMUL, dtomul)
+				| MCI_BF(DTOCYC, dtocyc)));
+}
+
+/*
+ * Return mask with command flags to be enabled for this command.
+ */
+static u32 atmci_prepare_command(struct mmc_host *mmc,
+				 struct mmc_command *cmd)
+{
+	struct mmc_data	*data;
+	u32		cmdr;
+
+	cmd->error = -EINPROGRESS;
+
+	cmdr = MCI_BF(CMDNB, cmd->opcode);
+
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		if (cmd->flags & MMC_RSP_136)
+			cmdr |= MCI_BF(RSPTYP, MCI_RSPTYP_136_BIT);
+		else
+			cmdr |= MCI_BF(RSPTYP, MCI_RSPTYP_48_BIT);
+	}
+
+	/*
+	 * This should really be MAXLAT_5 for CMD2 and ACMD41, but
+	 * it's too difficult to determine whether this is an ACMD or
+	 * not. Better make it 64.
+	 */
+	cmdr |= MCI_BIT(MAXLAT);
+
+	if (mmc->ios.bus_mode == MMC_BUSMODE_OPENDRAIN)
+		cmdr |= MCI_BIT(OPDCMD);
+
+	data = cmd->data;
+	if (data) {
+		cmdr |= MCI_BF(TRCMD, MCI_TRCMD_START_TRANS);
+		if (data->flags & MMC_DATA_STREAM)
+			cmdr |= MCI_BF(TRTYP, MCI_TRTYP_STREAM);
+		else if (data->blocks > 1)
+			cmdr |= MCI_BF(TRTYP, MCI_TRTYP_MULTI_BLOCK);
+		else
+			cmdr |= MCI_BF(TRTYP, MCI_TRTYP_BLOCK);
+
+		if (data->flags & MMC_DATA_READ)
+			cmdr |= MCI_BIT(TRDIR);
+	}
+
+	return cmdr;
+}
+
+static void atmci_start_command(struct atmel_mci *host,
+				struct mmc_command *cmd,
+				u32 cmd_flags)
+{
+	/* Must read host->cmd after testing event flags */
+	smp_rmb();
+	WARN_ON(host->cmd);
+	host->cmd = cmd;
+
+	dev_vdbg(&host->mmc->class_dev,
+			"start command: ARGR=0x%08x CMDR=0x%08x\n",
+			cmd->arg, cmd_flags);
+
+	mci_writel(host, ARGR, cmd->arg);
+	mci_writel(host, CMDR, cmd_flags);
+}
+
+static void send_stop_cmd(struct mmc_host *mmc, struct mmc_data *data)
+{
+	struct atmel_mci *host = mmc_priv(mmc);
+
+	atmci_start_command(host, data->stop, host->stop_cmdr);
+	mci_writel(host, IER, MCI_BIT(CMDRDY));
+}
+
+static void atmci_request_end(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct atmel_mci *host = mmc_priv(mmc);
+
+	WARN_ON(host->cmd || host->data);
+	host->mrq = NULL;
+
+	atmci_disable(host);
+
+	mmc_request_done(mmc, mrq);
+}
+
+static void atmci_dma_cleanup(struct atmel_mci *host)
+{
+	struct mmc_data			*data = host->data;
+
+	dma_unmap_sg(&host->pdev->dev, data->sg, data->sg_len,
+		     ((data->flags & MMC_DATA_WRITE)
+		      ? DMA_TO_DEVICE : DMA_FROM_DEVICE));
+}
+
+static void atmci_stop_dma(struct atmel_mci *host)
+{
+	struct dma_chan *chan = host->data_chan;
+
+	if (chan) {
+		chan->device->device_terminate_all(chan);
+		atmci_dma_cleanup(host);
+	}
+}
+
+/* This function is called by the DMA driver from tasklet context. */
+static void atmci_dma_complete(void *arg)
+{
+	struct atmel_mci	*host = arg;
+	struct mmc_data		*data = host->data;
+
+	dev_vdbg(&host->mmc->class_dev, "DMA complete\n");
+
+	/*
+	 * If the card was removed, data will be NULL. No point trying
+	 * to send the stop command or waiting for NBUSY in this case.
+	 */
+	if (data) {
+		/* A short DMA transfer may complete before the command */
+		atmci_set_completed(host, EVENT_DMA_COMPLETE);
+		smp_mb();
+		if (atmci_is_completed(host, EVENT_CMD_COMPLETE)
+				&& data->stop
+				&& !atmci_test_and_set_completed(host,
+					EVENT_STOP_SENT))
+			send_stop_cmd(host->mmc, data);
+	}
+
+	atmci_dma_cleanup(host);
+
+	/*
+	 * Regardless of what the documentation says, we have to wait
+	 * for NOTBUSY even after block read operations.
+	 *
+	 * When the DMA transfer is complete, the controller may still
+	 * be reading the CRC from the card, i.e. the data transfer is
+	 * still in progress and we haven't seen all the potential
+	 * error bits yet.
+	 *
+	 * The interrupt handler will schedule a different tasklet to
+	 * finish things up when the data transfer is completely done.
+	 *
+	 * We may not complete the mmc request here anyway because the
+	 * mmc layer may call back and cause us to violate the "don't
+	 * submit new operations from the completion callback" rule of
+	 * the dma engine framework.
+	 */
+	if (data)
+		mci_writel(host, IER, MCI_BIT(NOTBUSY));
+}
+
+static int
+atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
+{
+	struct dma_chan			*chan;
+	struct dma_async_tx_descriptor	*desc;
+	struct scatterlist		*sg;
+	unsigned long			flags;
+	unsigned int			i;
+	enum dma_data_direction		direction;
+
+	/*
+	 * We don't do DMA on "complex" transfers, i.e. with
+	 * non-word-aligned buffers or lengths. Also, we don't bother
+	 * with all the DMA setup overhead for short transfers.
+	 */
+	if (data->blocks * data->blksz < ATMCI_DMA_THRESHOLD)
+		return -EINVAL;
+	if (data->blksz & 3)
+		return -EINVAL;
+
+	for_each_sg(data->sg, sg, data->sg_len, i) {
+		if (sg->offset & 3 || sg->length & 3)
+			return -EINVAL;
+	}
+
+	/* If we don't have a channel, we can't do DMA */
+	spin_lock_irqsave(&host->mmc->lock, flags);
+	chan = host->dma.chan;
+	if (chan) {
+		dma_chan_get(chan);
+		host->data_chan = chan;
+	}
+	spin_unlock_irqrestore(&host->mmc->lock, flags);
+
+	if (!chan)
+		return -ENODEV;
+
+	if (data->flags & MMC_DATA_READ)
+		direction = DMA_FROM_DEVICE;
+	else
+		direction = DMA_TO_DEVICE;
+
+	desc = chan->device->device_prep_slave_sg(chan,
+			data->sg, data->sg_len, direction,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc)
+		return -ENOMEM;
+
+	host->dma.data_desc = desc;
+	desc->callback = atmci_dma_complete;
+	desc->callback_param = host;
+	desc->tx_submit(desc);
+
+	/* Go! */
+	chan->device->device_issue_pending(chan);
+
+	return 0;
+}
+
+/*
+ * Returns a mask of interrupt flags to be enabled after the whole
+ * request has been prepared.
+ */
+static u32 atmci_submit_data(struct mmc_host *mmc, struct mmc_data *data)
+{
+	struct atmel_mci	*host = mmc_priv(mmc);
+	u32			iflags;
+
+	data->error = -EINPROGRESS;
+
+	WARN_ON(host->data);
+	host->sg = NULL;
+	host->data = data;
+
+	mci_writel(host, BLKR, (MCI_BF(BCNT, data->blocks)
+				| MCI_BF(BLKLEN, data->blksz)));
+	dev_vdbg(&mmc->class_dev, "BLKR=0x%08x\n",
+			(MCI_BF(BCNT, data->blocks)
+				| MCI_BF(BLKLEN, data->blksz)));
+
+	iflags = ATMCI_DATA_ERROR_FLAGS;
+	if (atmci_submit_data_dma(host, data)) {
+		host->data_chan = NULL;
+		host->sg = data->sg;
+		host->pio_offset = 0;
+		if (data->flags & MMC_DATA_READ)
+			iflags |= MCI_BIT(RXRDY);
+		else
+			iflags |= MCI_BIT(TXRDY);
+	}
+
+	return iflags;
+}
+
+static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct atmel_mci	*host = mmc_priv(mmc);
+	struct mmc_data		*data;
+	struct mmc_command	*cmd;
+	u32			iflags;
+	u32			cmdflags = 0;
+
+	iflags = mci_readl(host, IMR);
+	if (iflags)
+		dev_warn(&mmc->class_dev, "WARNING: IMR=0x%08x\n",
+				mci_readl(host, IMR));
+
+	WARN_ON(host->mrq != NULL);
+
+	/*
+	 * We may "know" the card is gone even though there's still an
+	 * electrical connection. If so, we really need to communicate
+	 * this to the MMC core since there won't be any more
+	 * interrupts as the card is completely removed. Otherwise,
+	 * the MMC core might believe the card is still there even
+	 * though the card was just removed very slowly.
+	 */
+	if (!host->present) {
+		mrq->cmd->error = -ENOMEDIUM;
+		mmc_request_done(mmc, mrq);
+		return;
+	}
+
+	host->mrq = mrq;
+	host->pending_events = 0;
+	host->completed_events = 0;
+
+	atmci_enable(host);
+
+	/* We don't support multiple blocks of weird lengths. */
+	data = mrq->data;
+	if (data) {
+		if (data->blocks > 1 && data->blksz & 3)
+			goto fail;
+		atmci_set_timeout(host, data);
+	}
+
+	iflags = MCI_BIT(CMDRDY);
+	cmd = mrq->cmd;
+	cmdflags = atmci_prepare_command(mmc, cmd);
+	atmci_start_command(host, cmd, cmdflags);
+
+	if (data)
+		iflags |= atmci_submit_data(mmc, data);
+
+	if (mrq->stop) {
+		host->stop_cmdr = atmci_prepare_command(mmc, mrq->stop);
+		host->stop_cmdr |= MCI_BF(TRCMD, MCI_TRCMD_STOP_TRANS);
+		if (!(data->flags & MMC_DATA_WRITE))
+			host->stop_cmdr |= MCI_BIT(TRDIR);
+		if (data->flags & MMC_DATA_STREAM)
+			host->stop_cmdr |= MCI_BF(TRTYP, MCI_TRTYP_STREAM);
+		else
+			host->stop_cmdr |= MCI_BF(TRTYP, MCI_TRTYP_MULTI_BLOCK);
+	}
+
+	/*
+	 * We could have enabled interrupts earlier, but I suspect
+	 * that would open up a nice can of interesting race
+	 * conditions (e.g. command and data complete, but stop not
+	 * prepared yet.)
+	 */
+	mci_writel(host, IER, iflags);
+
+	return;
+
+fail:
+	atmci_disable(host);
+	host->mrq = NULL;
+	mrq->cmd->error = -EINVAL;
+	mmc_request_done(mmc, mrq);
+}
+
+static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct atmel_mci	*host = mmc_priv(mmc);
+
+	if (ios->clock) {
+		u32 clkdiv;
+
+		/* Set clock rate */
+		clkdiv = DIV_ROUND_UP(host->bus_hz, 2 * ios->clock) - 1;
+		if (clkdiv > 255) {
+			dev_warn(&mmc->class_dev,
+				"clock %u too slow; using %lu\n",
+				ios->clock, host->bus_hz / (2 * 256));
+			clkdiv = 255;
+		}
+
+		host->mode_reg = MCI_BF(CLKDIV, clkdiv)
+					| MCI_BIT(WRPROOF)
+					| MCI_BIT(RDPROOF);
+	}
+
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_1:
+		host->sdc_reg = 0;
+		break;
+	case MMC_BUS_WIDTH_4:
+		host->sdc_reg = MCI_BIT(SDCBUS);
+		break;
+	}
+
+	switch (ios->power_mode) {
+	case MMC_POWER_ON:
+		/* Send init sequence (74 clock cycles) */
+		atmci_enable(host);
+		mci_writel(host, CMDR, MCI_BF(SPCMD, MCI_SPCMD_INIT_CMD));
+		while (!(mci_readl(host, SR) & MCI_BIT(CMDRDY)))
+			cpu_relax();
+		atmci_disable(host);
+		break;
+	default:
+		/*
+		 * TODO: None of the currently available AVR32-based
+		 * boards allow MMC power to be turned off. Implement
+		 * power control when this can be tested properly.
+		 */
+		break;
+	}
+}
+
+static int atmci_get_ro(struct mmc_host *mmc)
+{
+	int			read_only = 0;
+	struct atmel_mci	*host = mmc_priv(mmc);
+
+	if (host->wp_pin >= 0) {
+		read_only = gpio_get_value(host->wp_pin);
+		dev_dbg(&mmc->class_dev, "card is %s\n",
+				read_only ? "read-only" : "read-write");
+	} else {
+		dev_dbg(&mmc->class_dev,
+			"no pin for checking read-only switch."
+			" Assuming write-enable.\n");
+	}
+
+	return read_only;
+}
+
+static struct mmc_host_ops atmci_ops = {
+	.request	= atmci_request,
+	.set_ios	= atmci_set_ios,
+	.get_ro		= atmci_get_ro,
+};
+
+static void atmci_command_complete(struct atmel_mci *host,
+			struct mmc_command *cmd, u32 status)
+{
+	/* Read the response from the card (up to 16 bytes) */
+	cmd->resp[0] = mci_readl(host, RSPR);
+	cmd->resp[1] = mci_readl(host, RSPR);
+	cmd->resp[2] = mci_readl(host, RSPR);
+	cmd->resp[3] = mci_readl(host, RSPR);
+
+	if (status & MCI_BIT(RTOE))
+		cmd->error = -ETIMEDOUT;
+	else if ((cmd->flags & MMC_RSP_CRC) && (status & MCI_BIT(RCRCE)))
+		cmd->error = -EILSEQ;
+	else if (status & (MCI_BIT(RINDE) | MCI_BIT(RDIRE) | MCI_BIT(RENDE)))
+		cmd->error = -EIO;
+	else
+		cmd->error = 0;
+
+	if (cmd->error) {
+		dev_dbg(&host->mmc->class_dev,
+			"command error: status=0x%08x\n", status);
+
+		if (cmd->data) {
+			host->data = NULL;
+			atmci_stop_dma(host);
+			mci_writel(host, IDR, MCI_BIT(NOTBUSY)
+					| ATMCI_DATA_ERROR_FLAGS);
+		}
+	}
+}
+
+static void atmci_detect_change(unsigned long data)
+{
+	struct atmel_mci *host = (struct atmel_mci *)data;
+	struct mmc_request *mrq = host->mrq;
+	int present;
+
+	/*
+	 * atmci_remove() sets detect_pin to -1 before freeing the
+	 * interrupt. We must not re-enable the interrupt if it has
+	 * been freed.
+	 */
+	smp_rmb();
+	if (host->detect_pin < 0)
+		return;
+
+	enable_irq(gpio_to_irq(host->detect_pin));
+	present = !gpio_get_value(host->detect_pin);
+
+	dev_vdbg(&host->pdev->dev, "detect change: %d (was %d)\n",
+			present, host->present);
+
+	if (present != host->present) {
+		dev_dbg(&host->mmc->class_dev, "card %s\n",
+			present ? "inserted" : "removed");
+		host->present = present;
+
+		/* Reset controller if card is gone */
+		if (!present) {
+			mci_writel(host, CR, MCI_BIT(SWRST));
+			mci_writel(host, IDR, ~0UL);
+			mci_writel(host, CR, MCI_BIT(MCIEN));
+		}
+
+		/* Clean up queue if present */
+		if (mrq) {
+			/*
+			 * Reset controller to terminate any ongoing
+			 * commands or data transfers.
+			 */
+			mci_writel(host, CR, MCI_BIT(SWRST));
+
+			if (!atmci_is_completed(host, EVENT_CMD_COMPLETE))
+				mrq->cmd->error = -ENOMEDIUM;
+
+			if (mrq->data && !atmci_is_completed(host,
+						EVENT_DATA_COMPLETE)) {
+				host->data = NULL;
+				mrq->data->error = -ENOMEDIUM;
+				atmci_stop_dma(host);
+			}
+			if (mrq->stop && !atmci_is_completed(host,
+						EVENT_STOP_COMPLETE))
+				mrq->stop->error = -ENOMEDIUM;
+
+			host->cmd = NULL;
+			atmci_request_end(host->mmc, mrq);
+		}
+
+		mmc_detect_change(host->mmc, 0);
+	}
+}
+
+static void atmci_tasklet_func(unsigned long priv)
+{
+	struct mmc_host		*mmc = (struct mmc_host *)priv;
+	struct atmel_mci	*host = mmc_priv(mmc);
+	struct mmc_request	*mrq = host->mrq;
+	struct mmc_data		*data = host->data;
+
+	dev_vdbg(&mmc->class_dev,
+		"tasklet: pending/completed/mask %lx/%lx/%x\n",
+		host->pending_events, host->completed_events,
+		mci_readl(host, IMR));
+
+	if (atmci_test_and_clear_pending(host, EVENT_CMD_COMPLETE)) {
+		/*
+		 * host->cmd must be set to NULL before the interrupt
+		 * handler sees EVENT_CMD_COMPLETE
+		 */
+		host->cmd = NULL;
+		smp_wmb();
+		atmci_set_completed(host, EVENT_CMD_COMPLETE);
+		atmci_command_complete(host, mrq->cmd, host->cmd_status);
+
+		if (!mrq->cmd->error && mrq->stop
+				&& atmci_is_completed(host, EVENT_DMA_COMPLETE)
+				&& !atmci_test_and_set_completed(host,
+					EVENT_STOP_SENT))
+			send_stop_cmd(host->mmc, mrq->data);
+	}
+	if (atmci_test_and_clear_pending(host, EVENT_STOP_COMPLETE)) {
+		/*
+		 * host->cmd must be set to NULL before the interrupt
+		 * handler sees EVENT_STOP_COMPLETE
+		 */
+		host->cmd = NULL;
+		smp_wmb();
+		atmci_set_completed(host, EVENT_STOP_COMPLETE);
+		atmci_command_complete(host, mrq->stop, host->stop_status);
+	}
+	if (atmci_test_and_clear_pending(host, EVENT_DATA_ERROR)) {
+		u32 status = host->data_status;
+
+		dev_vdbg(&mmc->class_dev, "data error: status=%08x\n", status);
+
+		atmci_set_completed(host, EVENT_DATA_ERROR);
+		atmci_set_completed(host, EVENT_DATA_COMPLETE);
+		atmci_stop_dma(host);
+
+		if (status & MCI_BIT(DTOE)) {
+			dev_dbg(&mmc->class_dev,
+					"data timeout error\n");
+			data->error = -ETIMEDOUT;
+		} else if (status & MCI_BIT(DCRCE)) {
+			dev_dbg(&mmc->class_dev, "data CRC error\n");
+			data->error = -EILSEQ;
+		} else {
+			dev_dbg(&mmc->class_dev,
+					"data FIFO error (status=%08x)\n",
+					status);
+			data->error = -EIO;
+		}
+
+		if (host->present && data->stop
+				&& atmci_is_completed(host, EVENT_CMD_COMPLETE)
+				&& !atmci_test_and_set_completed(
+					host, EVENT_STOP_SENT))
+			send_stop_cmd(host->mmc, data);
+
+		host->data = NULL;
+	}
+	if (atmci_test_and_clear_pending(host, EVENT_DATA_COMPLETE)) {
+		atmci_set_completed(host, EVENT_DATA_COMPLETE);
+
+		if (!atmci_is_completed(host, EVENT_DATA_ERROR)) {
+			data->bytes_xfered = data->blocks * data->blksz;
+			data->error = 0;
+		}
+
+		host->data = NULL;
+	}
+
+	if (host->mrq && !host->cmd && !host->data)
+		atmci_request_end(mmc, host->mrq);
+}
+
+static void atmci_read_data_pio(struct atmel_mci *host)
+{
+	struct scatterlist	*sg = host->sg;
+	void			*buf = sg_virt(sg);
+	unsigned int		offset = host->pio_offset;
+	struct mmc_data		*data = host->data;
+	u32			value;
+	u32			status;
+	unsigned int		nbytes = 0;
+
+	do {
+		value = mci_readl(host, RDR);
+		if (likely(offset + 4 <= sg->length)) {
+			put_unaligned(value, (u32 *)(buf + offset));
+
+			offset += 4;
+			nbytes += 4;
+
+			if (offset == sg->length) {
+				host->sg = sg = sg_next(sg);
+				if (!sg)
+					goto done;
+
+				offset = 0;
+				buf = sg_virt(sg);
+			}
+		} else {
+			unsigned int remaining = sg->length - offset;
+			memcpy(buf + offset, &value, remaining);
+			nbytes += remaining;
+
+			flush_dcache_page(sg_page(sg));
+			host->sg = sg = sg_next(sg);
+			if (!sg)
+				goto done;
+
+			offset = 4 - remaining;
+			buf = sg_virt(sg);
+			memcpy(buf, (u8 *)&value + remaining, offset);
+			nbytes += offset;
+		}
+
+		status = mci_readl(host, SR);
+		if (status & ATMCI_DATA_ERROR_FLAGS) {
+			mci_writel(host, IDR, (MCI_BIT(NOTBUSY)
+						| MCI_BIT(RXRDY)
+						| ATMCI_DATA_ERROR_FLAGS));
+			host->data_status = status;
+			atmci_set_pending(host, EVENT_DATA_ERROR);
+			tasklet_schedule(&host->tasklet);
+			break;
+		}
+	} while (status & MCI_BIT(RXRDY));
+
+	host->pio_offset = offset;
+	data->bytes_xfered += nbytes;
+
+	return;
+
+done:
+	mci_writel(host, IDR, MCI_BIT(RXRDY));
+	mci_writel(host, IER, MCI_BIT(NOTBUSY));
+	data->bytes_xfered += nbytes;
+	atmci_set_completed(host, EVENT_DMA_COMPLETE);
+	if (data->stop && atmci_is_completed(host, EVENT_CMD_COMPLETE)
+			&& !atmci_test_and_set_completed(host, EVENT_STOP_SENT))
+		send_stop_cmd(host->mmc, data);
+}
+
+static void atmci_write_data_pio(struct atmel_mci *host)
+{
+	struct scatterlist	*sg = host->sg;
+	void			*buf = sg_virt(sg);
+	unsigned int		offset = host->pio_offset;
+	struct mmc_data		*data = host->data;
+	u32			value;
+	u32			status;
+	unsigned int		nbytes = 0;
+
+	do {
+		if (likely(offset + 4 <= sg->length)) {
+			value = get_unaligned((u32 *)(buf + offset));
+			mci_writel(host, TDR, value);
+
+			offset += 4;
+			nbytes += 4;
+			if (offset == sg->length) {
+				host->sg = sg = sg_next(sg);
+				if (!sg)
+					goto done;
+
+				offset = 0;
+				buf = sg_virt(sg);
+			}
+		} else {
+			unsigned int remaining = sg->length - offset;
+
+			value = 0;
+			memcpy(&value, buf + offset, remaining);
+			nbytes += remaining;
+
+			host->sg = sg = sg_next(sg);
+			if (!sg) {
+				mci_writel(host, TDR, value);
+				goto done;
+			}
+
+			offset = 4 - remaining;
+			buf = sg_virt(sg);
+			memcpy((u8 *)&value + remaining, buf, offset);
+			mci_writel(host, TDR, value);
+			nbytes += offset;
+		}
+
+		status = mci_readl(host, SR);
+		if (status & ATMCI_DATA_ERROR_FLAGS) {
+			mci_writel(host, IDR, (MCI_BIT(NOTBUSY)
+						| MCI_BIT(TXRDY)
+						| ATMCI_DATA_ERROR_FLAGS));
+			host->data_status = status;
+			atmci_set_pending(host, EVENT_DATA_ERROR);
+			tasklet_schedule(&host->tasklet);
+			break;
+		}
+	} while (status & MCI_BIT(TXRDY));
+
+	host->pio_offset = offset;
+	data->bytes_xfered += nbytes;
+
+	return;
+
+done:
+	mci_writel(host, IDR, MCI_BIT(TXRDY));
+	mci_writel(host, IER, MCI_BIT(NOTBUSY));
+	data->bytes_xfered += nbytes;
+	atmci_set_completed(host, EVENT_DMA_COMPLETE);
+	if (data->stop && atmci_is_completed(host, EVENT_CMD_COMPLETE)
+			&& !atmci_test_and_set_completed(host, EVENT_STOP_SENT))
+		send_stop_cmd(host->mmc, data);
+}
+
+static void atmci_cmd_interrupt(struct mmc_host *mmc, u32 status)
+{
+	struct atmel_mci	*host = mmc_priv(mmc);
+
+	mci_writel(host, IDR, MCI_BIT(CMDRDY));
+
+	if (atmci_is_completed(host, EVENT_STOP_SENT)) {
+		host->stop_status = status;
+		atmci_set_pending(host, EVENT_STOP_COMPLETE);
+	} else {
+		host->cmd_status = status;
+		atmci_set_pending(host, EVENT_CMD_COMPLETE);
+	}
+
+	tasklet_schedule(&host->tasklet);
+}
+
+static irqreturn_t atmci_interrupt(int irq, void *dev_id)
+{
+	struct mmc_host		*mmc = dev_id;
+	struct atmel_mci	*host = mmc_priv(mmc);
+	u32			status, mask, pending;
+	unsigned int		pass_count = 0;
+
+	spin_lock(&mmc->lock);
+
+	do {
+		status = mci_readl(host, SR);
+		mask = mci_readl(host, IMR);
+		pending = status & mask;
+		if (!pending)
+			break;
+
+		if (pending & ATMCI_DATA_ERROR_FLAGS) {
+			mci_writel(host, IDR, ATMCI_DATA_ERROR_FLAGS
+					| MCI_BIT(RXRDY) | MCI_BIT(TXRDY));
+			pending &= mci_readl(host, IMR);
+			host->data_status = status;
+			atmci_set_pending(host, EVENT_DATA_ERROR);
+			tasklet_schedule(&host->tasklet);
+		}
+		if (pending & (MCI_BIT(NOTBUSY))) {
+			mci_writel(host, IDR, (MCI_BIT(NOTBUSY)
+					       | ATMCI_DATA_ERROR_FLAGS));
+			atmci_set_pending(host, EVENT_DATA_COMPLETE);
+			tasklet_schedule(&host->tasklet);
+		}
+		if (pending & MCI_BIT(RXRDY))
+			atmci_read_data_pio(host);
+		if (pending & MCI_BIT(TXRDY))
+			atmci_write_data_pio(host);
+
+		if (pending & MCI_BIT(CMDRDY))
+			atmci_cmd_interrupt(mmc, status);
+	} while (pass_count++ < 5);
+
+	spin_unlock(&mmc->lock);
+
+	return pass_count ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static irqreturn_t atmci_detect_interrupt(int irq, void *dev_id)
+{
+	struct mmc_host		*mmc = dev_id;
+	struct atmel_mci	*host = mmc_priv(mmc);
+
+	/*
+	 * Disable interrupts until the pin has stabilized and check
+	 * the state then. Use mod_timer() since we may be in the
+	 * middle of the timer routine when this interrupt triggers.
+	 */
+	disable_irq_nosync(irq);
+	mod_timer(&host->detect_timer, jiffies + msecs_to_jiffies(20));
+
+	return IRQ_HANDLED;
+}
+
+static enum dma_state_client atmci_dma_event(struct dma_client *client,
+		struct dma_chan *chan, enum dma_state state)
+{
+	struct atmel_mci	*host;
+	enum dma_state_client	ret = DMA_NAK;
+	unsigned long		flags;
+
+	host = dma_client_to_atmel_mci(client);
+
+	switch (state) {
+	case DMA_RESOURCE_AVAILABLE:
+		spin_lock_irqsave(&host->mmc->lock, flags);
+		if (!host->dma.chan) {
+			host->dma.chan = chan;
+			ret = DMA_ACK;
+		}
+		spin_unlock_irqrestore(&host->mmc->lock, flags);
+
+		if (ret == DMA_ACK)
+			dev_info(&host->pdev->dev,
+					"Using %s for DMA transfers\n",
+					chan->dev.bus_id);
+		break;
+
+	case DMA_RESOURCE_REMOVED:
+		spin_lock_irqsave(&host->mmc->lock, flags);
+		if (host->dma.chan == chan) {
+			host->dma.chan = NULL;
+			ret = DMA_ACK;
+		}
+		spin_unlock_irqrestore(&host->mmc->lock, flags);
+
+		if (ret == DMA_ACK)
+			dev_info(&host->pdev->dev,
+					"Lost %s, falling back to PIO\n",
+					chan->dev.bus_id);
+		break;
+
+	default:
+		break;
+	}
+
+
+	return ret;
+}
+
+static int __init atmci_probe(struct platform_device *pdev)
+{
+	struct mci_platform_data	*pdata;
+	struct atmel_mci *host;
+	struct mmc_host *mmc;
+	struct resource *regs;
+	int irq;
+	int ret;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs)
+		return -ENXIO;
+	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		return -ENXIO;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	mmc = mmc_alloc_host(sizeof(struct atmel_mci), &pdev->dev);
+	if (!mmc)
+		return -ENOMEM;
+
+	host = mmc_priv(mmc);
+	host->pdev = pdev;
+	host->mmc = mmc;
+	host->detect_pin = pdata->detect_pin;
+	host->wp_pin = pdata->wp_pin;
+
+	host->mck = clk_get(&pdev->dev, "mci_clk");
+	if (IS_ERR(host->mck)) {
+		ret = PTR_ERR(host->mck);
+		goto err_clk_get;
+	}
+
+	ret = -ENOMEM;
+	host->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!host->regs)
+		goto err_ioremap;
+
+	clk_enable(host->mck);
+	mci_writel(host, CR, MCI_BIT(SWRST));
+	host->bus_hz = clk_get_rate(host->mck);
+	clk_disable(host->mck);
+
+	host->mapbase = regs->start;
+
+	mmc->ops = &atmci_ops;
+	mmc->f_min = (host->bus_hz + 511) / 512;
+	mmc->f_max = host->bus_hz / 2;
+	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+	mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_MULTIWRITE;
+
+	mmc->max_hw_segs = 64;
+	mmc->max_phys_segs = 64;
+	mmc->max_req_size = 32768 * 512;
+	mmc->max_blk_size = 32768;
+	mmc->max_blk_count = 512;
+
+	tasklet_init(&host->tasklet, atmci_tasklet_func, (unsigned long)mmc);
+
+	ret = request_irq(irq, atmci_interrupt, 0, pdev->dev.bus_id, mmc);
+	if (ret)
+		goto err_request_irq;
+
+	if (pdata->dma_slave) {
+		struct dma_slave *slave = pdata->dma_slave;
+
+		slave->tx_reg = regs->start + MCI_TDR;
+		slave->rx_reg = regs->start + MCI_RDR;
+
+		/* Try to grab a DMA channel */
+		host->dma.client.event_callback = atmci_dma_event;
+		dma_cap_set(DMA_SLAVE, host->dma.client.cap_mask);
+		host->dma.client.slave = slave;
+
+		dma_async_client_register(&host->dma.client);
+		dma_async_client_chan_request(&host->dma.client);
+	} else {
+		dev_notice(&pdev->dev, "DMA not available, using PIO\n");
+	}
+
+	/* Assume card is present if we don't have a detect pin */
+	host->present = 1;
+	if (host->detect_pin >= 0) {
+		if (gpio_request(host->detect_pin, "mmc_detect")) {
+			dev_dbg(&mmc->class_dev, "no detect pin available\n");
+			host->detect_pin = -1;
+		} else {
+			host->present = !gpio_get_value(host->detect_pin);
+		}
+	}
+	if (host->wp_pin >= 0) {
+		if (gpio_request(host->wp_pin, "mmc_wp")) {
+			dev_dbg(&mmc->class_dev, "no WP pin available\n");
+			host->wp_pin = -1;
+		}
+	}
+
+	platform_set_drvdata(pdev, host);
+
+	mmc_add_host(mmc);
+
+	if (host->detect_pin >= 0) {
+		setup_timer(&host->detect_timer, atmci_detect_change,
+				(unsigned long)host);
+
+		ret = request_irq(gpio_to_irq(host->detect_pin),
+				atmci_detect_interrupt,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				"mmc-detect", mmc);
+		if (ret) {
+			dev_dbg(&mmc->class_dev,
+				"could not request IRQ %d for detect pin\n",
+				gpio_to_irq(host->detect_pin));
+			gpio_free(host->detect_pin);
+			host->detect_pin = -1;
+		}
+	}
+
+	dev_info(&mmc->class_dev,
+			"Atmel MCI controller at 0x%08lx irq %d\n",
+			host->mapbase, irq);
+
+	atmci_init_debugfs(host);
+
+	return 0;
+
+err_request_irq:
+	iounmap(host->regs);
+err_ioremap:
+	clk_put(host->mck);
+err_clk_get:
+	mmc_free_host(mmc);
+	return ret;
+}
+
+static int __exit atmci_remove(struct platform_device *pdev)
+{
+	struct atmel_mci *host = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	if (host) {
+		atmci_cleanup_debugfs(host);
+
+		if (host->detect_pin >= 0) {
+			int pin = host->detect_pin;
+
+			/* Make sure the timer doesn't enable the interrupt */
+			host->detect_pin = -1;
+			smp_wmb();
+
+			free_irq(gpio_to_irq(pin), host->mmc);
+			del_timer_sync(&host->detect_timer);
+			gpio_free(pin);
+		}
+
+		mmc_remove_host(host->mmc);
+
+		clk_enable(host->mck);
+		mci_writel(host, IDR, ~0UL);
+		mci_writel(host, CR, MCI_BIT(MCIDIS));
+		mci_readl(host, SR);
+		clk_disable(host->mck);
+
+		dma_async_client_unregister(&host->dma.client);
+
+		if (host->wp_pin >= 0)
+			gpio_free(host->wp_pin);
+
+		free_irq(platform_get_irq(pdev, 0), host->mmc);
+		iounmap(host->regs);
+
+		clk_put(host->mck);
+
+		mmc_free_host(host->mmc);
+	}
+	return 0;
+}
+
+static struct platform_driver atmci_driver = {
+	.remove		= __exit_p(atmci_remove),
+	.driver		= {
+		.name		= "atmel_mci",
+	},
+};
+
+static int __init atmci_init(void)
+{
+	return platform_driver_probe(&atmci_driver, atmci_probe);
+}
+
+static void __exit atmci_exit(void)
+{
+	platform_driver_unregister(&atmci_driver);
+}
+
+module_init(atmci_init);
+module_exit(atmci_exit);
+
+MODULE_DESCRIPTION("Atmel Multimedia Card Interface driver");
+MODULE_AUTHOR("Haavard Skinnemoen <haavard.skinnemoen@atmel.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/asm-avr32/arch-at32ap/board.h b/include/asm-avr32/arch-at32ap/board.h
index a4e2d28..b6f805b 100644
--- a/include/asm-avr32/arch-at32ap/board.h
+++ b/include/asm-avr32/arch-at32ap/board.h
@@ -70,7 +70,11 @@ struct i2c_board_info;
 struct platform_device *at32_add_device_twi(unsigned int id,
 					    struct i2c_board_info *b,
 					    unsigned int n);
-struct platform_device *at32_add_device_mci(unsigned int id);
+
+struct mci_platform_data;
+struct platform_device *
+at32_add_device_mci(unsigned int id, struct mci_platform_data *data);
+
 struct platform_device *at32_add_device_ac97c(unsigned int id);
 struct platform_device *at32_add_device_abdac(unsigned int id);
 
diff --git a/include/asm-avr32/atmel-mci.h b/include/asm-avr32/atmel-mci.h
new file mode 100644
index 0000000..ea6e29d
--- /dev/null
+++ b/include/asm-avr32/atmel-mci.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_AVR32_ATMEL_MCI_H
+#define __ASM_AVR32_ATMEL_MCI_H
+
+struct dma_slave;
+
+struct mci_platform_data {
+	struct dma_slave	*dma_slave;
+	int			detect_pin;
+	int			wp_pin;
+};
+
+#endif /* __ASM_AVR32_ATMEL_MCI_H */
-- 
1.5.5.4

