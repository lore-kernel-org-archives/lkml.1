Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZIQPZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZIQPZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZIQPZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:25:31 -0400
Received: from mail.atmel.fr ([81.80.104.162]:34967 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbZIQPZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:25:29 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       kernel@avr32linux.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] mmc: atmel-mci: New MCI2 module support in atmel-mci driver
Date: Thu, 17 Sep 2009 18:29:27 +0200
Message-Id: <1253204967-30010-3-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1253204967-30010-1-git-send-email-nicolas.ferre@atmel.com>
References: <1253204967-30010-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new revision of the IP adds some improvements to the MCI already present
in several Atmel SOC.
Some new registers are added and a particular way of handling DMA interaction
lead to a new sequence in function call which is backward compatible: On MCI2,
we must set the DMAEN bit to enable the DMA handshaking interface. This must
happen before the data transfer command is sent.

A new function is able to differentiate MCI2 code and is based on knowledge of
processor id (cpu_is_xxx()).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |   85 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 1689396..d9a1a8e 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -92,6 +92,7 @@ struct atmel_mci_dma {
  * @need_clock_update: Update the clock rate before the next request.
  * @need_reset: Reset controller before next request.
  * @mode_reg: Value of the MR register.
+ * @cfg_reg: Value of the CFG register.
  * @bus_hz: The rate of @mck in Hz. This forms the basis for MMC bus
  *	rate and timeout calculations.
  * @mapbase: Physical address of the MMIO registers.
@@ -155,6 +156,7 @@ struct atmel_mci {
 	bool			need_clock_update;
 	bool			need_reset;
 	u32			mode_reg;
+	u32			cfg_reg;
 	unsigned long		bus_hz;
 	unsigned long		mapbase;
 	struct clk		*mck;
@@ -223,6 +225,19 @@ static bool mci_has_rwproof(void)
 }
 
 /*
+ * The new MCI2 module isn't 100% compatible with the old MCI module,
+ * and it has a few nice features which we want to use...
+ */
+static inline bool atmci_is_mci2(void)
+{
+	if (cpu_is_at91sam9g45())
+		return true;
+
+	return false;
+}
+
+
+/*
  * The debugfs stuff below is mostly optimized away when
  * CONFIG_DEBUG_FS is not set.
  */
@@ -357,12 +372,33 @@ static int atmci_regs_show(struct seq_file *s, void *v)
 			buf[MCI_BLKR / 4],
 			buf[MCI_BLKR / 4] & 0xffff,
 			(buf[MCI_BLKR / 4] >> 16) & 0xffff);
+	if (atmci_is_mci2())
+		seq_printf(s, "CSTOR:\t0x%08x\n", buf[MCI_CSTOR / 4]);
 
 	/* Don't read RSPR and RDR; it will consume the data there */
 
 	atmci_show_status_reg(s, "SR", buf[MCI_SR / 4]);
 	atmci_show_status_reg(s, "IMR", buf[MCI_IMR / 4]);
 
+	if (atmci_is_mci2()) {
+		u32 val;
+
+		val = buf[MCI_DMA / 4];
+		seq_printf(s, "DMA:\t0x%08x OFFSET=%u CHKSIZE=%u%s\n",
+				val, val & 3,
+				((val >> 4) & 3) ?
+					1 << (((val >> 4) & 3) + 1) : 1,
+				val & MCI_DMAEN ? " DMAEN" : "");
+
+		val = buf[MCI_CFG / 4];
+		seq_printf(s, "CFG:\t0x%08x%s%s%s%s\n",
+				val,
+				val & MCI_CFG_FIFOMODE_1DATA ? " FIFOMODE_ONE_DATA" : "",
+				val & MCI_CFG_FERRCTRL_COR ? " FERRCTRL_CLEAR_ON_READ" : "",
+				val & MCI_CFG_HSMODE ? " HSMODE" : "",
+				val & MCI_CFG_LSYNC ? " LSYNC" : "");
+	}
+
 	kfree(buf);
 
 	return 0;
@@ -557,6 +593,10 @@ static void atmci_dma_complete(void *arg)
 
 	dev_vdbg(&host->pdev->dev, "DMA complete\n");
 
+	if (atmci_is_mci2())
+		/* Disable DMA hardware handshaking on MCI */
+		mci_writel(host, DMA, mci_readl(host, DMA) & ~MCI_DMAEN);
+
 	atmci_dma_cleanup(host);
 
 	/*
@@ -592,7 +632,7 @@ static void atmci_dma_complete(void *arg)
 }
 
 static int
-atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
+atmci_prepare_data_dma(struct atmel_mci *host, struct mmc_data *data)
 {
 	struct dma_chan			*chan;
 	struct dma_async_tx_descriptor	*desc;
@@ -623,6 +663,9 @@ atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
 	if (!chan)
 		return -ENODEV;
 
+	if (atmci_is_mci2())
+		mci_writel(host, DMA, MCI_DMA_CHKSIZE(3) | MCI_DMAEN);
+
 	if (data->flags & MMC_DATA_READ)
 		direction = DMA_FROM_DEVICE;
 	else
@@ -637,21 +680,30 @@ atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
 	host->dma.data_desc = desc;
 	desc->callback = atmci_dma_complete;
 	desc->callback_param = host;
-	desc->tx_submit(desc);
-
-	/* Go! */
-	chan->device->device_issue_pending(chan);
 
 	return 0;
 }
 
+static void atmci_submit_data(struct atmel_mci *host)
+{
+	struct dma_chan			*chan = host->data_chan;
+	struct dma_async_tx_descriptor	*desc = host->dma.data_desc;
+
+	if (chan) {
+		desc->tx_submit(desc);
+		chan->device->device_issue_pending(chan);
+	}
+}
+
 #else /* CONFIG_MMC_ATMELMCI_DMA */
 
-static int atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
+static int atmci_prepare_data_dma(struct atmel_mci *host, struct mmc_data *data)
 {
 	return -ENOSYS;
 }
 
+static void atmci_submit_data(struct atmel_mci *host) {}
+
 static void atmci_stop_dma(struct atmel_mci *host)
 {
 	/* Data transfer was stopped by the interrupt handler */
@@ -665,7 +717,7 @@ static void atmci_stop_dma(struct atmel_mci *host)
  * Returns a mask of interrupt flags to be enabled after the whole
  * request has been prepared.
  */
-static u32 atmci_submit_data(struct atmel_mci *host, struct mmc_data *data)
+static u32 atmci_prepare_data(struct atmel_mci *host, struct mmc_data *data)
 {
 	u32 iflags;
 
@@ -676,7 +728,7 @@ static u32 atmci_submit_data(struct atmel_mci *host, struct mmc_data *data)
 	host->data = data;
 
 	iflags = ATMCI_DATA_ERROR_FLAGS;
-	if (atmci_submit_data_dma(host, data)) {
+	if (atmci_prepare_data_dma(host, data)) {
 		host->data_chan = NULL;
 
 		/*
@@ -722,6 +774,8 @@ static void atmci_start_request(struct atmel_mci *host,
 		mci_writel(host, CR, MCI_CR_SWRST);
 		mci_writel(host, CR, MCI_CR_MCIEN);
 		mci_writel(host, MR, host->mode_reg);
+		if (atmci_is_mci2())
+			mci_writel(host, CFG, host->cfg_reg);
 		host->need_reset = false;
 	}
 	mci_writel(host, SDCR, slot->sdc_reg);
@@ -737,6 +791,7 @@ static void atmci_start_request(struct atmel_mci *host,
 		while (!(mci_readl(host, SR) & MCI_CMDRDY))
 			cpu_relax();
 	}
+	iflags = 0;
 	data = mrq->data;
 	if (data) {
 		atmci_set_timeout(host, slot, data);
@@ -746,15 +801,17 @@ static void atmci_start_request(struct atmel_mci *host,
 				| MCI_BLKLEN(data->blksz));
 		dev_vdbg(&slot->mmc->class_dev, "BLKR=0x%08x\n",
 			MCI_BCNT(data->blocks) | MCI_BLKLEN(data->blksz));
+
+		iflags |= atmci_prepare_data(host, data);
 	}
 
-	iflags = MCI_CMDRDY;
+	iflags |= MCI_CMDRDY;
 	cmd = mrq->cmd;
 	cmdflags = atmci_prepare_command(slot->mmc, cmd);
 	atmci_start_command(host, cmd, cmdflags);
 
 	if (data)
-		iflags |= atmci_submit_data(host, data);
+		atmci_submit_data(host);
 
 	if (mrq->stop) {
 		host->stop_cmdr = atmci_prepare_command(slot->mmc, mrq->stop);
@@ -850,6 +907,8 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 			clk_enable(host->mck);
 			mci_writel(host, CR, MCI_CR_SWRST);
 			mci_writel(host, CR, MCI_CR_MCIEN);
+			if (atmci_is_mci2())
+				mci_writel(host, CFG, host->cfg_reg);
 		}
 
 		/*
@@ -1088,6 +1147,8 @@ static void atmci_detect_change(unsigned long data)
 				mci_writel(host, CR, MCI_CR_SWRST);
 				mci_writel(host, CR, MCI_CR_MCIEN);
 				mci_writel(host, MR, host->mode_reg);
+				if (atmci_is_mci2())
+					mci_writel(host, CFG, host->cfg_reg);
 
 				host->data = NULL;
 				host->cmd = NULL;
@@ -1637,6 +1698,10 @@ static void atmci_configure_dma(struct atmel_mci *host)
 	}
 	if (!host->dma.chan)
 		dev_notice(&host->pdev->dev, "DMA not available, using PIO\n");
+	else
+		dev_info(&host->pdev->dev,
+					"Using %s for DMA transfers\n",
+					dma_chan_name(host->dma.chan));
 }
 #else
 static void atmci_configure_dma(struct atmel_mci *host) {}
-- 
1.5.6.5

