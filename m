Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZHNW00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZHNW00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbZHNW0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:26:24 -0400
Received: from ru.mvista.com ([213.79.90.228]:26665 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757198AbZHNW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:26:19 -0400
Date: Sat, 15 Aug 2009 02:26:19 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] spi_mpc8xxx: Add support for QE DMA mode and CPM1/CPM2
 chips
Message-ID: <20090814222619.GH14458@oksana.dev.rtsoft.ru>
References: <20090814222453.GA9568@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090814222453.GA9568@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds QE buffer descriptors mode support for the
spi_mpc8xxx driver, and as a side effect we now support CPM1
and CPM2 SPI controllers.

That means that today we support almost all MPC SPI controllers:

- MPC834x-style controllers (support PIO mode only);
- CPM1 and CPM2 controllers (support DMA mode only);
- QE SPI controllers in CPU mode (PIO mode with shift quirks);
- QE SPI controllers in buffer descriptors (DMA) mode;

The only controller we don't currently support is a newer eSPI
(with a dedicated chip selects and a bit different registers map).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/spi/Kconfig       |    3 -
 drivers/spi/spi_mpc8xxx.c |  540 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 500 insertions(+), 43 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 2c733c2..b22a4b4 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -146,9 +146,6 @@ config SPI_MPC8xxx
 	  This enables using the Freescale MPC8xxx SPI controllers in master
 	  mode.
 
-	  This driver uses a simple set of shift registers for data (opposed
-	  to the CPM based descriptor model).
-
 config SPI_OMAP_UWIRE
 	tristate "OMAP1 MicroWire"
 	depends on ARCH_OMAP1
diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
index 80374df..bf56202 100644
--- a/drivers/spi/spi_mpc8xxx.c
+++ b/drivers/spi/spi_mpc8xxx.c
@@ -5,6 +5,10 @@
  *
  * Copyright (C) 2006 Polycom, Inc.
  *
+ * CPM SPI and QE buffer descriptors mode support:
+ * Copyright (c) 2009  MontaVista Software, Inc.
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
@@ -27,6 +31,9 @@
 #include <linux/spi/spi_bitbang.h>
 #include <linux/platform_device.h>
 #include <linux/fsl_devices.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/gpio.h>
@@ -34,8 +41,19 @@
 #include <linux/of_spi.h>
 
 #include <sysdev/fsl_soc.h>
+#include <asm/cpm.h>
+#include <asm/qe.h>
 #include <asm/irq.h>
 
+/* CPM1 and CPM2 are mutually exclusive. */
+#ifdef CONFIG_CPM1
+#include <asm/cpm1.h>
+#define CPM_SPI_CMD mk_cr_cmd(CPM_CR_CH_SPI, 0)
+#else
+#include <asm/cpm2.h>
+#define CPM_SPI_CMD mk_cr_cmd(CPM_CR_SPI_PAGE, CPM_CR_SPI_SBLOCK, 0, 0)
+#endif
+
 /* SPI Controller registers */
 struct mpc8xxx_spi_reg {
 	u8 res1[0x20];
@@ -47,6 +65,28 @@ struct mpc8xxx_spi_reg {
 	__be32 receive;
 };
 
+/* SPI Parameter RAM */
+struct spi_pram {
+	__be16	rbase;	/* Rx Buffer descriptor base address */
+	__be16	tbase;	/* Tx Buffer descriptor base address */
+	u8	rfcr;	/* Rx function code */
+	u8	tfcr;	/* Tx function code */
+	__be16	mrblr;	/* Max receive buffer length */
+	__be32	rstate;	/* Internal */
+	__be32	rdp;	/* Internal */
+	__be16	rbptr;	/* Internal */
+	__be16	rbc;	/* Internal */
+	__be32	rxtmp;	/* Internal */
+	__be32	tstate;	/* Internal */
+	__be32	tdp;	/* Internal */
+	__be16	tbptr;	/* Internal */
+	__be16	tbc;	/* Internal */
+	__be32	txtmp;	/* Internal */
+	__be32	res;	/* Tx temp. */
+	__be16  rpbase;	/* Relocation pointer (CPM1 only) */
+	__be16	res1;	/* Reserved */
+};
+
 /* SPI Controller mode register definitions */
 #define	SPMODE_LOOP		(1 << 30)
 #define	SPMODE_CI_INACTIVEHIGH	(1 << 29)
@@ -75,14 +115,40 @@ struct mpc8xxx_spi_reg {
 #define	SPIM_NE		0x00000200	/* Not empty */
 #define	SPIM_NF		0x00000100	/* Not full */
 
+#define	SPIE_TXB	0x00000200	/* Last char is written to tx fifo */
+#define	SPIE_RXB	0x00000100	/* Last char is written to rx buf */
+
+/* SPCOM register values */
+#define	SPCOM_STR	(1 << 23)	/* Start transmit */
+
+#define	SPI_PRAM_SIZE	0x100
+#define	SPI_MRBLR	((unsigned int)PAGE_SIZE)
+
 /* SPI Controller driver's private data. */
 struct mpc8xxx_spi {
+	struct device *dev;
 	struct mpc8xxx_spi_reg __iomem *base;
 
 	/* rx & tx bufs from the spi_transfer */
 	const void *tx;
 	void *rx;
 
+	int subblock;
+	struct spi_pram __iomem *pram;
+	struct cpm_buf_desc __iomem *tx_bd;
+	struct cpm_buf_desc __iomem *rx_bd;
+
+	struct spi_transfer *xfer_in_progress;
+
+	/* dma addresses for CPM transfers */
+	dma_addr_t tx_dma;
+	dma_addr_t rx_dma;
+	bool map_tx_dma;
+	bool map_rx_dma;
+
+	dma_addr_t dma_dummy_tx;
+	dma_addr_t dma_dummy_rx;
+
 	/* functions to deal with different sized buffers */
 	void (*get_rx) (u32 rx_data, struct mpc8xxx_spi *);
 	u32(*get_tx) (struct mpc8xxx_spi *);
@@ -98,6 +164,10 @@ struct mpc8xxx_spi {
 
 	unsigned int flags;
 #define SPI_QE_CPU_MODE		(1 << 0) /* QE CPU ("PIO") mode */
+#define SPI_CPM_MODE		(1 << 1) /* CPM2/QE ("DMA") mode */
+#define SPI_CPM1		(1 << 2) /* SPI unit is in CPM1 block */
+#define SPI_CPM2		(1 << 3) /* SPI unit is in CPM2 block */
+#define SPI_QE			(1 << 4) /* SPI unit is in QE block */
 
 	struct workqueue_struct *workqueue;
 	struct work_struct work;
@@ -108,6 +178,10 @@ struct mpc8xxx_spi {
 	struct completion done;
 };
 
+static void *mpc8xxx_dummy_rx;
+static DEFINE_MUTEX(mpc8xxx_dummy_rx_lock);
+static int mpc8xxx_dummy_rx_refcnt;
+
 struct spi_mpc8xxx_cs {
 	/* functions to deal with different sized buffers */
 	void (*get_rx) (u32 rx_data, struct mpc8xxx_spi *);
@@ -173,6 +247,22 @@ static void mpc8xxx_spi_change_mode(struct spi_device *spi)
 	mpc8xxx_spi_write_reg(mode, cs->hw_mode & ~SPMODE_ENABLE);
 	mpc8xxx_spi_write_reg(mode, cs->hw_mode);
 
+	/* When in CPM mode, we need to reinit tx and rx. */
+	if (mspi->flags & SPI_CPM_MODE) {
+		if (mspi->flags & SPI_QE)
+			qe_issue_cmd(QE_INIT_TX_RX, mspi->subblock,
+				     QE_CR_PROTOCOL_UNSPECIFIED, 0);
+		else {
+			cpm_command(CPM_SPI_CMD, CPM_CR_INIT_TRX);
+			if (mspi->flags & SPI_CPM1) {
+				out_be16(&mspi->pram->rbptr,
+					 in_be16(&mspi->pram->rbase));
+				out_be16(&mspi->pram->tbptr,
+					 in_be16(&mspi->pram->tbase));
+			}
+		}
+	}
+
 	local_irq_restore(flags);
 }
 
@@ -298,19 +388,133 @@ int mpc8xxx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 	return 0;
 }
 
-static int mpc8xxx_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
+static void mpc8xxx_spi_cpm_bufs_start(struct mpc8xxx_spi *mspi)
 {
-	struct mpc8xxx_spi *mpc8xxx_spi;
-	u32 word, len, bits_per_word;
+	struct cpm_buf_desc __iomem *tx_bd = mspi->tx_bd;
+	struct cpm_buf_desc __iomem *rx_bd = mspi->rx_bd;
+	unsigned int xfer_len = min(mspi->count, SPI_MRBLR);
+	unsigned int xfer_ofs;
 
-	mpc8xxx_spi = spi_master_get_devdata(spi->master);
+	xfer_ofs = mspi->xfer_in_progress->len - mspi->count;
+
+	out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma + xfer_ofs);
+	out_be16(&rx_bd->cbd_datlen, 0);
+	out_be16(&rx_bd->cbd_sc, BD_SC_EMPTY | BD_SC_INTRPT | BD_SC_WRAP);
+
+	out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma + xfer_ofs);
+	out_be16(&tx_bd->cbd_datlen, xfer_len);
+	out_be16(&tx_bd->cbd_sc, BD_SC_READY | BD_SC_INTRPT | BD_SC_WRAP |
+				 BD_SC_LAST);
+
+	/* start transfer */
+	mpc8xxx_spi_write_reg(&mspi->base->command, SPCOM_STR);
+}
+
+static int mpc8xxx_spi_cpm_bufs(struct mpc8xxx_spi *mspi,
+				struct spi_transfer *t, bool is_dma_mapped)
+{
+	struct device *dev = mspi->dev;
+
+	if (is_dma_mapped) {
+		mspi->map_tx_dma = 0;
+		mspi->map_rx_dma = 0;
+	} else {
+		mspi->map_tx_dma = 1;
+		mspi->map_rx_dma = 1;
+	}
+
+	if (!t->tx_buf) {
+		mspi->tx_dma = mspi->dma_dummy_tx;
+		mspi->map_tx_dma = 0;
+	}
+
+	if (!t->rx_buf) {
+		mspi->rx_dma = mspi->dma_dummy_rx;
+		mspi->map_rx_dma = 0;
+	}
+
+	if (mspi->map_tx_dma) {
+		void *nonconst_tx = (void *)mspi->tx; /* shut up gcc */
+
+		mspi->tx_dma = dma_map_single(dev, nonconst_tx, t->len,
+					      DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, mspi->tx_dma)) {
+			dev_err(dev, "unable to map tx dma\n");
+			return -ENOMEM;
+		}
+	} else {
+		mspi->tx_dma = t->tx_dma;
+	}
+
+	if (mspi->map_rx_dma) {
+		mspi->rx_dma = dma_map_single(dev, mspi->rx, t->len,
+					      DMA_FROM_DEVICE);
+		if (dma_mapping_error(dev, mspi->rx_dma)) {
+			dev_err(dev, "unable to map rx dma\n");
+			goto err_rx_dma;
+		}
+	} else {
+		mspi->rx_dma = t->rx_dma;
+	}
+
+	/* enable rx ints */
+	mpc8xxx_spi_write_reg(&mspi->base->mask, SPIE_RXB);
+
+	mspi->xfer_in_progress = t;
+	mspi->count = t->len;
+
+	/* start CPM transfers */
+	mpc8xxx_spi_cpm_bufs_start(mspi);
+
+	return 0;
+
+err_rx_dma:
+	if (mspi->map_tx_dma)
+		dma_unmap_single(dev, mspi->tx_dma, t->len, DMA_TO_DEVICE);
+	return -ENOMEM;
+}
+
+static void mpc8xxx_spi_cpm_bufs_complete(struct mpc8xxx_spi *mspi)
+{
+	struct device *dev = mspi->dev;
+	struct spi_transfer *t = mspi->xfer_in_progress;
+
+	if (mspi->map_tx_dma)
+		dma_unmap_single(dev, mspi->tx_dma, t->len, DMA_TO_DEVICE);
+	if (mspi->map_tx_dma)
+		dma_unmap_single(dev, mspi->rx_dma, t->len, DMA_FROM_DEVICE);
+	mspi->xfer_in_progress = NULL;
+}
+
+static int mpc8xxx_spi_cpu_bufs(struct mpc8xxx_spi *mspi,
+				struct spi_transfer *t, unsigned int len)
+{
+	u32 word;
+
+	mspi->count = len;
+
+	/* enable rx ints */
+	mpc8xxx_spi_write_reg(&mspi->base->mask, SPIM_NE);
+
+	/* transmit word */
+	word = mspi->get_tx(mspi);
+	mpc8xxx_spi_write_reg(&mspi->base->transmit, word);
+
+	return 0;
+}
+
+static int mpc8xxx_spi_bufs(struct spi_device *spi, struct spi_transfer *t,
+			    bool is_dma_mapped)
+{
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
+	unsigned int len = t->len;
+	u8 bits_per_word;
+	int ret;
 
-	mpc8xxx_spi->tx = t->tx_buf;
-	mpc8xxx_spi->rx = t->rx_buf;
 	bits_per_word = spi->bits_per_word;
 	if (t->bits_per_word)
 		bits_per_word = t->bits_per_word;
-	len = t->len;
+
 	if (bits_per_word > 8) {
 		/* invalid length? */
 		if (len & 1)
@@ -323,22 +527,27 @@ static int mpc8xxx_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
 			return -EINVAL;
 		len /= 2;
 	}
-	mpc8xxx_spi->count = len;
 
-	INIT_COMPLETION(mpc8xxx_spi->done);
+	mpc8xxx_spi->tx = t->tx_buf;
+	mpc8xxx_spi->rx = t->rx_buf;
 
-	/* enable rx ints */
-	mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->mask, SPIM_NE);
+	INIT_COMPLETION(mpc8xxx_spi->done);
 
-	/* transmit word */
-	word = mpc8xxx_spi->get_tx(mpc8xxx_spi);
-	mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->transmit, word);
+	if (mpc8xxx_spi->flags & SPI_CPM_MODE)
+		ret = mpc8xxx_spi_cpm_bufs(mpc8xxx_spi, t, is_dma_mapped);
+	else
+		ret = mpc8xxx_spi_cpu_bufs(mpc8xxx_spi, t, len);
+	if (ret)
+		return ret;
 
 	wait_for_completion(&mpc8xxx_spi->done);
 
 	/* disable rx ints */
 	mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->mask, 0);
 
+	if (mpc8xxx_spi->flags & SPI_CPM_MODE)
+		mpc8xxx_spi_cpm_bufs_complete(mpc8xxx_spi);
+
 	return mpc8xxx_spi->count;
 }
 
@@ -369,7 +578,7 @@ static void mpc8xxx_spi_do_one_msg(struct spi_message *m)
 		}
 		cs_change = t->cs_change;
 		if (t->len)
-			status = mpc8xxx_spi_bufs(spi, t);
+			status = mpc8xxx_spi_bufs(spi, t, m->is_dma_mapped);
 		if (status) {
 			status = -EMSGSIZE;
 			break;
@@ -458,45 +667,80 @@ static int mpc8xxx_spi_setup(struct spi_device *spi)
 	return 0;
 }
 
-static irqreturn_t mpc8xxx_spi_irq(s32 irq, void *context_data)
+static void mpc8xxx_spi_cpm_irq(struct mpc8xxx_spi *mspi, u32 events)
 {
-	struct mpc8xxx_spi *mpc8xxx_spi = context_data;
-	u32 event;
-	irqreturn_t ret = IRQ_NONE;
+	u16 len;
 
-	/* Get interrupt events(tx/rx) */
-	event = mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->event);
+	dev_dbg(mspi->dev, "%s: bd datlen %d, count %d\n", __func__,
+		in_be16(&mspi->rx_bd->cbd_datlen), mspi->count);
 
-	/* We need handle RX first */
-	if (event & SPIE_NE) {
-		u32 rx_data = mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->receive);
+	len = in_be16(&mspi->rx_bd->cbd_datlen);
+	if (len > mspi->count) {
+		WARN_ON(1);
+		len = mspi->count;
+	}
 
-		if (mpc8xxx_spi->rx)
-			mpc8xxx_spi->get_rx(rx_data, mpc8xxx_spi);
+	/* Clear the events */
+	mpc8xxx_spi_write_reg(&mspi->base->event, events);
 
-		ret = IRQ_HANDLED;
+	mspi->count -= len;
+	if (mspi->count)
+		mpc8xxx_spi_cpm_bufs_start(mspi);
+	else
+		complete(&mspi->done);
+}
+
+static void mpc8xxx_spi_cpu_irq(struct mpc8xxx_spi *mspi, u32 events)
+{
+	/* We need handle RX first */
+	if (events & SPIE_NE) {
+		u32 rx_data = mpc8xxx_spi_read_reg(&mspi->base->receive);
+
+		if (mspi->rx)
+			mspi->get_rx(rx_data, mspi);
 	}
 
-	if ((event & SPIE_NF) == 0)
+	if ((events & SPIE_NF) == 0)
 		/* spin until TX is done */
-		while (((event =
-			 mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->event)) &
+		while (((events =
+			mpc8xxx_spi_read_reg(&mspi->base->event)) &
 						SPIE_NF) == 0)
 			cpu_relax();
 
-	mpc8xxx_spi->count -= 1;
-	if (mpc8xxx_spi->count) {
-		u32 word = mpc8xxx_spi->get_tx(mpc8xxx_spi);
-		mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->transmit, word);
+	/* Clear the events */
+	mpc8xxx_spi_write_reg(&mspi->base->event, events);
+
+	mspi->count -= 1;
+	if (mspi->count) {
+		u32 word = mspi->get_tx(mspi);
+
+		mpc8xxx_spi_write_reg(&mspi->base->transmit, word);
 	} else {
-		complete(&mpc8xxx_spi->done);
+		complete(&mspi->done);
 	}
+}
 
-	/* Clear the events */
-	mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->event, event);
+static irqreturn_t mpc8xxx_spi_irq(s32 irq, void *context_data)
+{
+	struct mpc8xxx_spi *mspi = context_data;
+	irqreturn_t ret = IRQ_NONE;
+	u32 events;
+
+	/* Get interrupt events(tx/rx) */
+	events = mpc8xxx_spi_read_reg(&mspi->base->event);
+	if (events)
+		ret = IRQ_HANDLED;
+
+	dev_dbg(mspi->dev, "%s: events %x\n", __func__, events);
+
+	if (mspi->flags & SPI_CPM_MODE)
+		mpc8xxx_spi_cpm_irq(mspi, events);
+	else
+		mpc8xxx_spi_cpu_irq(mspi, events);
 
 	return ret;
 }
+
 static int mpc8xxx_spi_transfer(struct spi_device *spi,
 				struct spi_message *m)
 {
@@ -520,10 +764,212 @@ static void mpc8xxx_spi_cleanup(struct spi_device *spi)
 	kfree(spi->controller_state);
 }
 
+static void *mpc8xxx_spi_alloc_dummy_rx(void)
+{
+	mutex_lock(&mpc8xxx_dummy_rx_lock);
+
+	if (!mpc8xxx_dummy_rx)
+		mpc8xxx_dummy_rx = kmalloc(SPI_MRBLR, GFP_KERNEL);
+	if (mpc8xxx_dummy_rx)
+		mpc8xxx_dummy_rx_refcnt++;
+
+	mutex_unlock(&mpc8xxx_dummy_rx_lock);
+
+	return mpc8xxx_dummy_rx;
+}
+
+static void mpc8xxx_spi_free_dummy_rx(void)
+{
+	mutex_lock(&mpc8xxx_dummy_rx_lock);
+
+	switch (mpc8xxx_dummy_rx_refcnt) {
+	case 0:
+		WARN_ON(1);
+		break;
+	case 1:
+		kfree(mpc8xxx_dummy_rx);
+		mpc8xxx_dummy_rx = NULL;
+		/* fall through */
+	default:
+		mpc8xxx_dummy_rx_refcnt--;
+		break;
+	}
+
+	mutex_unlock(&mpc8xxx_dummy_rx_lock);
+}
+
+static unsigned long mpc8xxx_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
+{
+	struct device *dev = mspi->dev;
+	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	const u32 *iprop;
+	int size;
+	unsigned long spi_base_ofs;
+	unsigned long pram_ofs = -ENOMEM;
+
+	/* Can't use of_address_to_resource(), QE muram isn't at 0. */
+	iprop = of_get_property(np, "reg", &size);
+
+	/* QE with a fixed pram location? */
+	if (mspi->flags & SPI_QE && iprop && size == sizeof(*iprop) * 4)
+		return cpm_muram_alloc_fixed(iprop[2], SPI_PRAM_SIZE);
+
+	/* QE but with a dynamic pram location? */
+	if (mspi->flags & SPI_QE) {
+		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
+		qe_issue_cmd(QE_ASSIGN_PAGE_TO_DEVICE, mspi->subblock,
+				QE_CR_PROTOCOL_UNSPECIFIED, pram_ofs);
+		return pram_ofs;
+	}
+
+	/* CPM1 and CPM2 pram must be at a fixed addr. */
+	if (!iprop || size != sizeof(*iprop) * 4)
+		return -ENOMEM;
+
+	spi_base_ofs = cpm_muram_alloc_fixed(iprop[2], 2);
+	if (IS_ERR_VALUE(spi_base_ofs))
+		return -ENOMEM;
+
+	if (mspi->flags & SPI_CPM2) {
+		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
+		if (!IS_ERR_VALUE(pram_ofs)) {
+			u16 __iomem *spi_base = cpm_muram_addr(spi_base_ofs);
+
+			out_be16(spi_base, pram_ofs);
+		}
+	} else {
+		struct spi_pram __iomem *pram = cpm_muram_addr(spi_base_ofs);
+		u16 rpbase = in_be16(&pram->rpbase);
+
+		/* Microcode relocation patch applied? */
+		if (rpbase)
+			pram_ofs = rpbase;
+		else
+			return spi_base_ofs;
+	}
+
+	cpm_muram_free(spi_base_ofs);
+	return pram_ofs;
+}
+
+static int mpc8xxx_spi_cpm_init(struct mpc8xxx_spi *mspi)
+{
+	struct device *dev = mspi->dev;
+	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	const u32 *iprop;
+	int size;
+	unsigned long pram_ofs;
+	unsigned long bds_ofs;
+
+	if (!(mspi->flags & SPI_CPM_MODE))
+		return 0;
+
+	if (!mpc8xxx_spi_alloc_dummy_rx())
+		return -ENOMEM;
+
+	if (mspi->flags & SPI_QE) {
+		iprop = of_get_property(np, "cell-index", &size);
+		if (iprop && size == sizeof(*iprop))
+			mspi->subblock = *iprop;
+
+		switch (mspi->subblock) {
+		default:
+			dev_warn(dev, "cell-index unspecified, assuming SPI1");
+			/* fall through */
+		case 0:
+			mspi->subblock = QE_CR_SUBBLOCK_SPI1;
+			break;
+		case 1:
+			mspi->subblock = QE_CR_SUBBLOCK_SPI2;
+			break;
+		}
+	}
+
+	pram_ofs = mpc8xxx_spi_cpm_get_pram(mspi);
+	if (IS_ERR_VALUE(pram_ofs)) {
+		dev_err(dev, "can't allocate spi parameter ram\n");
+		goto err_pram;
+	}
+
+	bds_ofs = cpm_muram_alloc(sizeof(*mspi->tx_bd) +
+				  sizeof(*mspi->rx_bd), 8);
+	if (IS_ERR_VALUE(bds_ofs)) {
+		dev_err(dev, "can't allocate bds\n");
+		goto err_bds;
+	}
+
+	mspi->dma_dummy_tx = dma_map_single(dev, empty_zero_page, PAGE_SIZE,
+					    DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, mspi->dma_dummy_tx)) {
+		dev_err(dev, "unable to map dummy tx buffer\n");
+		goto err_dummy_tx;
+	}
+
+	mspi->dma_dummy_rx = dma_map_single(dev, mpc8xxx_dummy_rx, SPI_MRBLR,
+					    DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, mspi->dma_dummy_rx)) {
+		dev_err(dev, "unable to map dummy rx buffer\n");
+		goto err_dummy_rx;
+	}
+
+	mspi->pram = cpm_muram_addr(pram_ofs);
+
+	mspi->tx_bd = cpm_muram_addr(bds_ofs);
+	mspi->rx_bd = cpm_muram_addr(bds_ofs + sizeof(*mspi->tx_bd));
+
+	/* Initialize parameter ram. */
+	out_be16(&mspi->pram->tbase, cpm_muram_offset(mspi->tx_bd));
+	out_be16(&mspi->pram->rbase, cpm_muram_offset(mspi->rx_bd));
+	out_8(&mspi->pram->tfcr, CPMFCR_EB | CPMFCR_GBL);
+	out_8(&mspi->pram->rfcr, CPMFCR_EB | CPMFCR_GBL);
+	out_be16(&mspi->pram->mrblr, SPI_MRBLR);
+	out_be32(&mspi->pram->rstate, 0);
+	out_be32(&mspi->pram->rdp, 0);
+	out_be16(&mspi->pram->rbptr, 0);
+	out_be16(&mspi->pram->rbc, 0);
+	out_be32(&mspi->pram->rxtmp, 0);
+	out_be32(&mspi->pram->tstate, 0);
+	out_be32(&mspi->pram->tdp, 0);
+	out_be16(&mspi->pram->tbptr, 0);
+	out_be16(&mspi->pram->tbc, 0);
+	out_be32(&mspi->pram->txtmp, 0);
+
+	return 0;
+
+err_dummy_rx:
+	dma_unmap_single(dev, mspi->dma_dummy_tx, PAGE_SIZE, DMA_TO_DEVICE);
+err_dummy_tx:
+	cpm_muram_free(bds_ofs);
+err_bds:
+	cpm_muram_free(pram_ofs);
+err_pram:
+	mpc8xxx_spi_free_dummy_rx();
+	return -ENOMEM;
+}
+
+static void mpc8xxx_spi_cpm_free(struct mpc8xxx_spi *mspi)
+{
+	struct device *dev = mspi->dev;
+
+	dma_unmap_single(dev, mspi->dma_dummy_rx, SPI_MRBLR, DMA_FROM_DEVICE);
+	dma_unmap_single(dev, mspi->dma_dummy_tx, PAGE_SIZE, DMA_TO_DEVICE);
+	cpm_muram_free(cpm_muram_offset(mspi->tx_bd));
+	cpm_muram_free(cpm_muram_offset(mspi->pram));
+	mpc8xxx_spi_free_dummy_rx();
+}
+
 static const char *mpc8xxx_spi_strmode(unsigned int flags)
 {
-	if (flags & SPI_QE_CPU_MODE)
+	if (flags & SPI_QE_CPU_MODE) {
 		return "QE CPU";
+	} else if (flags & SPI_CPM_MODE) {
+		if (flags & SPI_QE)
+			return "QE";
+		else if (flags & SPI_CPM2)
+			return "CPM2";
+		else
+			return "CPM1";
+	}
 	return "CPU";
 }
 
@@ -553,11 +999,16 @@ mpc8xxx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
 	master->cleanup = mpc8xxx_spi_cleanup;
 
 	mpc8xxx_spi = spi_master_get_devdata(master);
+	mpc8xxx_spi->dev = dev;
 	mpc8xxx_spi->get_rx = mpc8xxx_spi_rx_buf_u8;
 	mpc8xxx_spi->get_tx = mpc8xxx_spi_tx_buf_u8;
 	mpc8xxx_spi->flags = pdata->flags;
 	mpc8xxx_spi->spibrg = pdata->sysclk;
 
+	ret = mpc8xxx_spi_cpm_init(mpc8xxx_spi);
+	if (ret)
+		goto err_cpm_init;
+
 	mpc8xxx_spi->rx_shift = 0;
 	mpc8xxx_spi->tx_shift = 0;
 	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE) {
@@ -570,7 +1021,7 @@ mpc8xxx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
 	mpc8xxx_spi->base = ioremap(mem->start, mem->end - mem->start + 1);
 	if (mpc8xxx_spi->base == NULL) {
 		ret = -ENOMEM;
-		goto put_master;
+		goto err_ioremap;
 	}
 
 	mpc8xxx_spi->irq = irq;
@@ -624,7 +1075,9 @@ free_irq:
 	free_irq(mpc8xxx_spi->irq, mpc8xxx_spi);
 unmap_io:
 	iounmap(mpc8xxx_spi->base);
-put_master:
+err_ioremap:
+	mpc8xxx_spi_cpm_free(mpc8xxx_spi);
+err_cpm_init:
 	spi_master_put(master);
 err:
 	return ERR_PTR(ret);
@@ -644,6 +1097,7 @@ static int __devexit mpc8xxx_spi_remove(struct device *dev)
 
 	free_irq(mpc8xxx_spi->irq, mpc8xxx_spi);
 	iounmap(mpc8xxx_spi->base);
+	mpc8xxx_spi_cpm_free(mpc8xxx_spi);
 
 	return 0;
 }
@@ -806,6 +1260,12 @@ static int __devinit of_mpc8xxx_spi_probe(struct of_device *ofdev,
 	prop = of_get_property(np, "mode", NULL);
 	if (prop && !strcmp(prop, "cpu-qe"))
 		pdata->flags = SPI_QE_CPU_MODE;
+	else if (prop && !strcmp(prop, "qe"))
+		pdata->flags = SPI_CPM_MODE | SPI_QE;
+	else if (of_device_is_compatible(np, "fsl,cpm2-spi"))
+		pdata->flags = SPI_CPM_MODE | SPI_CPM2;
+	else if (of_device_is_compatible(np, "fsl,cpm1-spi"))
+		pdata->flags = SPI_CPM_MODE | SPI_CPM1;
 
 	ret = of_mpc8xxx_spi_get_chipselects(dev);
 	if (ret)
-- 
1.6.3.3
