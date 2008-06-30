Return-Path: <linux-kernel-owner+w=401wt.eu-S1761490AbYF3Qfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761490AbYF3Qfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYF3Qf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:35:26 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35564 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbYF3QfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:35:24 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v5] Atmel MCI: Driver for Atmel on-chip MMC controllers
Date: Mon, 30 Jun 2008 18:35:03 +0200
Message-Id: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6
X-OriginalArrivalTime: 30 Jun 2008 16:35:05.0027 (UTC) FILETIME=[4033A130:01C8DACF]
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

Currently, the driver only support PIO transfers. DMA support has been
split out to a separate patch to hopefully make it easier to review.

The driver has been tested using mmc-block and ext3fs on several SD,
SDHC and MMC+ cards. Reads and writes work fine, with read transfer
rates up to 3.5 MiB/s on fast cards with debugging disabled.

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

Changes since v4:
  * Remove DMA support (will be added back in a separate patch)
  * Remove debugfs support (ditto)
  * Clean up register definitions

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
Hi Pierre,

Here's a simpler version of the driver with the DMA and debugfs bits
removed, so you can apply it separately if you want. I'll hopefully
have patches to add both back in by tomorrow.

I also made the register definitions much more compact and hopefully
easier to read.

Haavard

 arch/avr32/boards/atngw100/setup.c      |    7 +
 arch/avr32/boards/atstk1000/atstk1002.c |    3 +
 arch/avr32/mach-at32ap/at32ap700x.c     |   30 +-
 drivers/mmc/host/Kconfig                |   10 +
 drivers/mmc/host/Makefile               |    1 +
 drivers/mmc/host/atmel-mci-regs.h       |   91 +++
 drivers/mmc/host/atmel-mci.c            |  981 +++++++++++++++++++++++++++++++
 include/asm-avr32/arch-at32ap/board.h   |    6 +-
 include/asm-avr32/atmel-mci.h           |    9 +
 9 files changed, 1132 insertions(+), 6 deletions(-)
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
index 0f24b4f..609e22f 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -14,6 +14,7 @@
 #include <linux/spi/spi.h>
 #include <linux/usb/atmel_usba_udc.h>
 
+#include <asm/atmel-mci.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
@@ -1199,20 +1200,32 @@ static struct clk atmel_mci0_pclk = {
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
+	if (platform_device_add_data(pdev, data,
+				sizeof(struct mci_platform_data)))
+		goto fail;
 
 	select_peripheral(PA(10), PERIPH_A, 0);	/* CLK	 */
 	select_peripheral(PA(11), PERIPH_A, 0);	/* CMD	 */
@@ -1221,12 +1234,19 @@ struct platform_device *__init at32_add_device_mci(unsigned int id)
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
index dead617..91b5ef2 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -91,6 +91,16 @@ config MMC_AT91
 
 	  If unsure, say N.
 
+config MMC_ATMELMCI
+	tristate "Atmel Multimedia Card Interface support"
+	depends on AVR32
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
index 0000000..a9a5657
--- /dev/null
+++ b/drivers/mmc/host/atmel-mci-regs.h
@@ -0,0 +1,91 @@
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
+/* MCI Register Definitions */
+#define MCI_CR			0x0000	/* Control */
+# define MCI_CR_MCIEN		(  1 <<  0)	/* MCI Enable */
+# define MCI_CR_MCIDIS		(  1 <<  1)	/* MCI Disable */
+# define MCI_CR_SWRST		(  1 <<  7)	/* Software Reset */
+#define MCI_MR			0x0004	/* Mode */
+# define MCI_MR_CLKDIV(x)	((x) <<  0)	/* Clock Divider */
+# define MCI_MR_RDPROOF		(  1 << 11)	/* Read Proof */
+# define MCI_MR_WRPROOF		(  1 << 12)	/* Write Proof */
+#define MCI_DTOR		0x0008	/* Data Timeout */
+# define MCI_DTOCYC(x)		((x) <<  0)	/* Data Timeout Cycles */
+# define MCI_DTOMUL(x)		((x) <<  4)	/* Data Timeout Multiplier */
+#define MCI_SDCR		0x000c	/* SD Card / SDIO */
+# define MCI_SDCSEL_SLOT_A	(  0 <<  0)	/* Select SD slot A */
+# define MCI_SDCSEL_SLOT_B	(  1 <<  0)	/* Select SD slot A */
+# define MCI_SDCBUS_1BIT	(  0 <<  7)	/* 1-bit data bus */
+# define MCI_SDCBUS_4BIT	(  1 <<  7)	/* 4-bit data bus */
+#define MCI_ARGR		0x0010	/* Command Argument */
+#define MCI_CMDR		0x0014	/* Command */
+# define MCI_CMDR_CMDNB(x)	((x) <<  0)	/* Command Opcode */
+# define MCI_CMDR_RSPTYP_NONE	(  0 <<  6)	/* No response */
+# define MCI_CMDR_RSPTYP_48BIT	(  1 <<  6)	/* 48-bit response */
+# define MCI_CMDR_RSPTYP_136BIT	(  2 <<  6)	/* 136-bit response */
+# define MCI_CMDR_SPCMD_INIT	(  1 <<  8)	/* Initialization command */
+# define MCI_CMDR_SPCMD_SYNC	(  2 <<  8)	/* Synchronized command */
+# define MCI_CMDR_SPCMD_INT	(  4 <<  8)	/* Interrupt command */
+# define MCI_CMDR_SPCMD_INTRESP	(  5 <<  8)	/* Interrupt response */
+# define MCI_CMDR_OPDCMD	(  1 << 11)	/* Open Drain */
+# define MCI_CMDR_MAXLAT_5CYC	(  0 << 12)	/* Max latency 5 cycles */
+# define MCI_CMDR_MAXLAT_64CYC	(  1 << 12)	/* Max latency 64 cycles */
+# define MCI_CMDR_START_XFER	(  1 << 16)	/* Start data transfer */
+# define MCI_CMDR_STOP_XFER	(  2 << 16)	/* Stop data transfer */
+# define MCI_CMDR_TRDIR_WRITE	(  0 << 18)	/* Write data */
+# define MCI_CMDR_TRDIR_READ	(  1 << 18)	/* Read data */
+# define MCI_CMDR_BLOCK		(  0 << 19)	/* Single-block transfer */
+# define MCI_CMDR_MULTI_BLOCK	(  1 << 19)	/* Multi-block transfer */
+# define MCI_CMDR_STREAM	(  2 << 19)	/* MMC Stream transfer */
+# define MCI_CMDR_SDIO_BYTE	(  4 << 19)	/* SDIO Byte transfer */
+# define MCI_CMDR_SDIO_BLOCK	(  5 << 19)	/* SDIO Block transfer */
+# define MCI_CMDR_SDIO_SUSPEND	(  1 << 24)	/* SDIO Suspend Command */
+# define MCI_CMDR_SDIO_RESUME	(  2 << 24)	/* SDIO Resume Command */
+#define MCI_BLKR		0x0018	/* Block */
+# define MCI_BCNT(x)		((x) <<  0)	/* Data Block Count */
+# define MCI_BLKLEN(x)		((x) << 16)	/* Data Block Length */
+#define MCI_RSPR		0x0020	/* Response 0 */
+#define MCI_RSPR1		0x0024	/* Response 1 */
+#define MCI_RSPR2		0x0028	/* Response 2 */
+#define MCI_RSPR3		0x002c	/* Response 3 */
+#define MCI_RDR			0x0030	/* Receive Data */
+#define MCI_TDR			0x0034	/* Transmit Data */
+#define MCI_SR			0x0040	/* Status */
+#define MCI_IER			0x0044	/* Interrupt Enable */
+#define MCI_IDR			0x0048	/* Interrupt Disable */
+#define MCI_IMR			0x004c	/* Interrupt Mask */
+# define MCI_CMDRDY		(  1 <<   0)	/* Command Ready */
+# define MCI_RXRDY		(  1 <<   1)	/* Receiver Ready */
+# define MCI_TXRDY		(  1 <<   2)	/* Transmitter Ready */
+# define MCI_BLKE		(  1 <<   3)	/* Data Block Ended */
+# define MCI_DTIP		(  1 <<   4)	/* Data Transfer In Progress */
+# define MCI_NOTBUSY		(  1 <<   5)	/* Data Not Busy */
+# define MCI_SDIOIRQA		(  1 <<   8)	/* SDIO IRQ in slot A */
+# define MCI_SDIOIRQB		(  1 <<   9)	/* SDIO IRQ in slot B */
+# define MCI_RINDE		(  1 <<  16)	/* Response Index Error */
+# define MCI_RDIRE		(  1 <<  17)	/* Response Direction Error */
+# define MCI_RCRCE		(  1 <<  18)	/* Response CRC Error */
+# define MCI_RENDE		(  1 <<  19)	/* Response End Bit Error */
+# define MCI_RTOE		(  1 <<  20)	/* Response Time-Out Error */
+# define MCI_DCRCE		(  1 <<  21)	/* Data CRC Error */
+# define MCI_DTOE		(  1 <<  22)	/* Data Time-Out Error */
+# define MCI_OVRE		(  1 <<  30)	/* RX Overrun Error */
+# define MCI_UNRE		(  1 <<  31)	/* TX Underrun Error */
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
index 0000000..25d5324
--- /dev/null
+++ b/drivers/mmc/host/atmel-mci.c
@@ -0,0 +1,981 @@
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
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
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
+#define ATMCI_DATA_ERROR_FLAGS	(MCI_DCRCE | MCI_DTOE | MCI_OVRE | MCI_UNRE)
+
+enum {
+	EVENT_CMD_COMPLETE = 0,
+	EVENT_DATA_ERROR,
+	EVENT_DATA_COMPLETE,
+	EVENT_STOP_SENT,
+	EVENT_STOP_COMPLETE,
+	EVENT_XFER_COMPLETE,
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
+};
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
+static void atmci_enable(struct atmel_mci *host)
+{
+	clk_enable(host->mck);
+	mci_writel(host, CR, MCI_CR_MCIEN);
+	mci_writel(host, MR, host->mode_reg);
+	mci_writel(host, SDCR, host->sdc_reg);
+}
+
+static void atmci_disable(struct atmel_mci *host)
+{
+	mci_writel(host, CR, MCI_CR_SWRST);
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
+	mci_writel(host, DTOR, (MCI_DTOMUL(dtomul) | MCI_DTOCYC(dtocyc)));
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
+	cmdr = MCI_CMDR_CMDNB(cmd->opcode);
+
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		if (cmd->flags & MMC_RSP_136)
+			cmdr |= MCI_CMDR_RSPTYP_136BIT;
+		else
+			cmdr |= MCI_CMDR_RSPTYP_48BIT;
+	}
+
+	/*
+	 * This should really be MAXLAT_5 for CMD2 and ACMD41, but
+	 * it's too difficult to determine whether this is an ACMD or
+	 * not. Better make it 64.
+	 */
+	cmdr |= MCI_CMDR_MAXLAT_64CYC;
+
+	if (mmc->ios.bus_mode == MMC_BUSMODE_OPENDRAIN)
+		cmdr |= MCI_CMDR_OPDCMD;
+
+	data = cmd->data;
+	if (data) {
+		cmdr |= MCI_CMDR_START_XFER;
+		if (data->flags & MMC_DATA_STREAM)
+			cmdr |= MCI_CMDR_STREAM;
+		else if (data->blocks > 1)
+			cmdr |= MCI_CMDR_MULTI_BLOCK;
+		else
+			cmdr |= MCI_CMDR_BLOCK;
+
+		if (data->flags & MMC_DATA_READ)
+			cmdr |= MCI_CMDR_TRDIR_READ;
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
+	mci_writel(host, IER, MCI_CMDRDY);
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
+	mci_writel(host, BLKR, MCI_BCNT(data->blocks)
+			| MCI_BLKLEN(data->blksz));
+	dev_vdbg(&mmc->class_dev, "BLKR=0x%08x\n",
+			MCI_BCNT(data->blocks) | MCI_BLKLEN(data->blksz));
+
+	iflags = ATMCI_DATA_ERROR_FLAGS;
+	host->sg = data->sg;
+	host->pio_offset = 0;
+	if (data->flags & MMC_DATA_READ)
+		iflags |= MCI_RXRDY;
+	else
+		iflags |= MCI_TXRDY;
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
+	iflags = MCI_CMDRDY;
+	cmd = mrq->cmd;
+	cmdflags = atmci_prepare_command(mmc, cmd);
+	atmci_start_command(host, cmd, cmdflags);
+
+	if (data)
+		iflags |= atmci_submit_data(mmc, data);
+
+	if (mrq->stop) {
+		host->stop_cmdr = atmci_prepare_command(mmc, mrq->stop);
+		host->stop_cmdr |= MCI_CMDR_STOP_XFER;
+		if (!(data->flags & MMC_DATA_WRITE))
+			host->stop_cmdr |= MCI_CMDR_TRDIR_READ;
+		if (data->flags & MMC_DATA_STREAM)
+			host->stop_cmdr |= MCI_CMDR_STREAM;
+		else
+			host->stop_cmdr |= MCI_CMDR_MULTI_BLOCK;
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
+		host->mode_reg = MCI_MR_CLKDIV(clkdiv) | MCI_MR_WRPROOF
+					| MCI_MR_RDPROOF;
+	}
+
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_1:
+		host->sdc_reg = 0;
+		break;
+	case MMC_BUS_WIDTH_4:
+		host->sdc_reg = MCI_SDCBUS_4BIT;
+		break;
+	}
+
+	switch (ios->power_mode) {
+	case MMC_POWER_ON:
+		/* Send init sequence (74 clock cycles) */
+		atmci_enable(host);
+		mci_writel(host, CMDR, MCI_CMDR_SPCMD_INIT);
+		while (!(mci_readl(host, SR) & MCI_CMDRDY))
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
+	if (status & MCI_RTOE)
+		cmd->error = -ETIMEDOUT;
+	else if ((cmd->flags & MMC_RSP_CRC) && (status & MCI_RCRCE))
+		cmd->error = -EILSEQ;
+	else if (status & (MCI_RINDE | MCI_RDIRE | MCI_RENDE))
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
+			mci_writel(host, IDR, MCI_NOTBUSY
+					| MCI_TXRDY | MCI_RXRDY
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
+			mci_writel(host, CR, MCI_CR_SWRST);
+			mci_writel(host, IDR, ~0UL);
+			mci_writel(host, CR, MCI_CR_MCIEN);
+		}
+
+		/* Clean up queue if present */
+		if (mrq) {
+			/*
+			 * Reset controller to terminate any ongoing
+			 * commands or data transfers.
+			 */
+			mci_writel(host, CR, MCI_CR_SWRST);
+
+			if (!atmci_is_completed(host, EVENT_CMD_COMPLETE))
+				mrq->cmd->error = -ENOMEDIUM;
+
+			if (mrq->data && !atmci_is_completed(host,
+						EVENT_DATA_COMPLETE)) {
+				host->data = NULL;
+				mrq->data->error = -ENOMEDIUM;
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
+				&& atmci_is_completed(host, EVENT_XFER_COMPLETE)
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
+
+		if (status & MCI_DTOE) {
+			dev_dbg(&mmc->class_dev,
+					"data timeout error\n");
+			data->error = -ETIMEDOUT;
+		} else if (status & MCI_DCRCE) {
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
+			mci_writel(host, IDR, (MCI_NOTBUSY | MCI_RXRDY
+						| ATMCI_DATA_ERROR_FLAGS));
+			host->data_status = status;
+			atmci_set_pending(host, EVENT_DATA_ERROR);
+			tasklet_schedule(&host->tasklet);
+			break;
+		}
+	} while (status & MCI_RXRDY);
+
+	host->pio_offset = offset;
+	data->bytes_xfered += nbytes;
+
+	return;
+
+done:
+	mci_writel(host, IDR, MCI_RXRDY);
+	mci_writel(host, IER, MCI_NOTBUSY);
+	data->bytes_xfered += nbytes;
+	atmci_set_completed(host, EVENT_XFER_COMPLETE);
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
+			mci_writel(host, IDR, (MCI_NOTBUSY | MCI_TXRDY
+						| ATMCI_DATA_ERROR_FLAGS));
+			host->data_status = status;
+			atmci_set_pending(host, EVENT_DATA_ERROR);
+			tasklet_schedule(&host->tasklet);
+			break;
+		}
+	} while (status & MCI_TXRDY);
+
+	host->pio_offset = offset;
+	data->bytes_xfered += nbytes;
+
+	return;
+
+done:
+	mci_writel(host, IDR, MCI_TXRDY);
+	mci_writel(host, IER, MCI_NOTBUSY);
+	data->bytes_xfered += nbytes;
+	atmci_set_completed(host, EVENT_XFER_COMPLETE);
+	if (data->stop && atmci_is_completed(host, EVENT_CMD_COMPLETE)
+			&& !atmci_test_and_set_completed(host, EVENT_STOP_SENT))
+		send_stop_cmd(host->mmc, data);
+}
+
+static void atmci_cmd_interrupt(struct mmc_host *mmc, u32 status)
+{
+	struct atmel_mci	*host = mmc_priv(mmc);
+
+	mci_writel(host, IDR, MCI_CMDRDY);
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
+					| MCI_RXRDY | MCI_TXRDY);
+			pending &= mci_readl(host, IMR);
+			host->data_status = status;
+			atmci_set_pending(host, EVENT_DATA_ERROR);
+			tasklet_schedule(&host->tasklet);
+		}
+		if (pending & MCI_NOTBUSY) {
+			mci_writel(host, IDR, (MCI_NOTBUSY
+					       | ATMCI_DATA_ERROR_FLAGS));
+			atmci_set_pending(host, EVENT_DATA_COMPLETE);
+			tasklet_schedule(&host->tasklet);
+		}
+		if (pending & MCI_RXRDY)
+			atmci_read_data_pio(host);
+		if (pending & MCI_TXRDY)
+			atmci_write_data_pio(host);
+
+		if (pending & MCI_CMDRDY)
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
+	mci_writel(host, CR, MCI_CR_SWRST);
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
+		mci_writel(host, CR, MCI_CR_MCIDIS);
+		mci_readl(host, SR);
+		clk_disable(host->mck);
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
index 0000000..c2ea6e1
--- /dev/null
+++ b/include/asm-avr32/atmel-mci.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_AVR32_ATMEL_MCI_H
+#define __ASM_AVR32_ATMEL_MCI_H
+
+struct mci_platform_data {
+	int			detect_pin;
+	int			wp_pin;
+};
+
+#endif /* __ASM_AVR32_ATMEL_MCI_H */
-- 
1.5.6

