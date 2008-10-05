Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbYJEQ2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbYJEQ2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758984AbYJEQWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:22:42 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62763 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976AbYJEQWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:38 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v2 5/7] atmel-mci: Add experimental DMA support
Date: Sun,  5 Oct 2008 18:21:28 +0200
Message-Id: <1223223690-2637-6-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223223690-2637-5-git-send-email-haavard.skinnemoen@atmel.com>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-5-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 05 Oct 2008 16:21:15.0197 (UTC) FILETIME=[63A75ED0:01C92706]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for DMA transfers through the generic DMA engine
framework with the DMA slave extensions.

The driver has been tested using mmc-block and ext3fs on several SD,
SDHC and MMC+ cards. Reads and writes work fine, with read transfer
rates up to 7.5 MiB/s on fast cards with debugging disabled.

Unfortunately, the driver has been known to lock up from time to time
with DMA enabled, so DMA support is currently optional and marked
EXPERIMENTAL. However, I didn't see any problems while testing 13
different cards (MMC, SD and SDHC of different brands and sizes), so I
suspect the "Initialize BLKR before sending data transfer command" fix
that was posted earlier fixed this as well.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/include/asm/atmel-mci.h  |    4 +
 arch/avr32/mach-at32ap/at32ap700x.c |   16 ++
 drivers/mmc/host/Kconfig            |   11 ++
 drivers/mmc/host/atmel-mci.c        |  274 +++++++++++++++++++++++++++++++++--
 4 files changed, 289 insertions(+), 16 deletions(-)

diff --git a/arch/avr32/include/asm/atmel-mci.h b/arch/avr32/include/asm/atmel-mci.h
index 5d5ae12..59f3fad 100644
--- a/arch/avr32/include/asm/atmel-mci.h
+++ b/arch/avr32/include/asm/atmel-mci.h
@@ -3,6 +3,8 @@
 
 #define ATMEL_MCI_MAX_NR_SLOTS	2
 
+struct dma_slave;
+
 /**
  * struct mci_slot_pdata - board-specific per-slot configuration
  * @bus_width: Number of data lines wired up the slot
@@ -26,9 +28,11 @@ struct mci_slot_pdata {
 
 /**
  * struct mci_platform_data - board-specific MMC/SDcard configuration
+ * @dma_slave: DMA slave interface to use in data transfers, or NULL.
  * @slot: Per-slot configuration data.
  */
 struct mci_platform_data {
+	struct dma_slave	*dma_slave;
 	struct mci_slot_pdata	slot[ATMEL_MCI_MAX_NR_SLOTS];
 };
 
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 9967d5a..f1b9a3a 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1273,6 +1273,7 @@ struct platform_device *__init
 at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
 	struct platform_device		*pdev;
+	struct dw_dma_slave		*dws;
 
 	if (id != 0 || !data)
 		return NULL;
@@ -1289,6 +1290,21 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 				ARRAY_SIZE(atmel_mci0_resource)))
 		goto fail;
 
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
 
 	if (platform_device_add_data(pdev, data,
 				sizeof(struct mci_platform_data)))
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index ea8d7a3..1ce21d4 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -114,6 +114,17 @@ config MMC_ATMELMCI
 
 	  If unsure, say N.
 
+config MMC_ATMELMCI_DMA
+	bool "Atmel MCI DMA support (EXPERIMENTAL)"
+	depends on MMC_ATMELMCI && DMA_ENGINE && EXPERIMENTAL
+	help
+	  Say Y here to have the Atmel MCI driver use a DMA engine to
+	  do data transfers and thus increase the throughput and
+	  reduce the CPU utilization. Note that this is highly
+	  experimental and may cause the driver to lock up.
+
+	  If unsure, say N.
+
 config MMC_IMX
 	tristate "Motorola i.MX Multimedia Card Interface support"
 	depends on ARCH_IMX
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index d8ab351..d45dfa2 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -11,6 +11,8 @@
 #include <linux/clk.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/init.h>
@@ -33,6 +35,7 @@
 #include "atmel-mci-regs.h"
 
 #define ATMCI_DATA_ERROR_FLAGS	(MCI_DCRCE | MCI_DTOE | MCI_OVRE | MCI_UNRE)
+#define ATMCI_DMA_THRESHOLD	16
 
 enum {
 	EVENT_CMD_COMPLETE = 0,
@@ -50,6 +53,14 @@ enum atmel_mci_state {
 	STATE_DATA_ERROR,
 };
 
+struct atmel_mci_dma {
+#ifdef CONFIG_MMC_ATMELMCI_DMA
+	struct dma_client		client;
+	struct dma_chan			*chan;
+	struct dma_async_tx_descriptor	*data_desc;
+#endif
+};
+
 /**
  * struct atmel_mci - MMC controller state shared between all slots
  * @lock: Spinlock protecting the queue and associated data.
@@ -62,6 +73,8 @@ enum atmel_mci_state {
  * @cmd: The command currently being sent to the card, or NULL.
  * @data: The data currently being transferred, or NULL if no data
  *	transfer is in progress.
+ * @dma: DMA client state.
+ * @data_chan: DMA channel being used for the current data transfer.
  * @cmd_status: Snapshot of SR taken upon completion of the current
  *	command. Only valid when EVENT_CMD_COMPLETE is pending.
  * @data_status: Snapshot of SR taken upon completion of the current
@@ -126,6 +139,9 @@ struct atmel_mci {
 	struct mmc_command	*cmd;
 	struct mmc_data		*data;
 
+	struct atmel_mci_dma	dma;
+	struct dma_chan		*data_chan;
+
 	u32			cmd_status;
 	u32			data_status;
 	u32			stop_cmdr;
@@ -485,6 +501,144 @@ static void send_stop_cmd(struct atmel_mci *host, struct mmc_data *data)
 	mci_writel(host, IER, MCI_CMDRDY);
 }
 
+#ifdef CONFIG_MMC_ATMELMCI_DMA
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
+	} else {
+		/* Data transfer was stopped by the interrupt handler */
+		atmci_set_pending(host, EVENT_XFER_COMPLETE);
+		mci_writel(host, IER, MCI_NOTBUSY);
+	}
+}
+
+/* This function is called by the DMA driver from tasklet context. */
+static void atmci_dma_complete(void *arg)
+{
+	struct atmel_mci	*host = arg;
+	struct mmc_data		*data = host->data;
+
+	dev_vdbg(&host->pdev->dev, "DMA complete\n");
+
+	atmci_dma_cleanup(host);
+
+	/*
+	 * If the card was removed, data will be NULL. No point trying
+	 * to send the stop command or waiting for NBUSY in this case.
+	 */
+	if (data) {
+		atmci_set_pending(host, EVENT_XFER_COMPLETE);
+		tasklet_schedule(&host->tasklet);
+
+		/*
+		 * Regardless of what the documentation says, we have
+		 * to wait for NOTBUSY even after block read
+		 * operations.
+		 *
+		 * When the DMA transfer is complete, the controller
+		 * may still be reading the CRC from the card, i.e.
+		 * the data transfer is still in progress and we
+		 * haven't seen all the potential error bits yet.
+		 *
+		 * The interrupt handler will schedule a different
+		 * tasklet to finish things up when the data transfer
+		 * is completely done.
+		 *
+		 * We may not complete the mmc request here anyway
+		 * because the mmc layer may call back and cause us to
+		 * violate the "don't submit new operations from the
+		 * completion callback" rule of the dma engine
+		 * framework.
+		 */
+		mci_writel(host, IER, MCI_NOTBUSY);
+	}
+}
+
+static int
+atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
+{
+	struct dma_chan			*chan;
+	struct dma_async_tx_descriptor	*desc;
+	struct scatterlist		*sg;
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
+	chan = host->dma.chan;
+	if (chan) {
+		dma_chan_get(chan);
+		host->data_chan = chan;
+	}
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
+#else /* CONFIG_MMC_ATMELMCI_DMA */
+
+static int atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
+{
+	return -ENOSYS;
+}
+
+static void atmci_stop_dma(struct atmel_mci *host)
+{
+	/* Data transfer was stopped by the interrupt handler */
+	atmci_set_pending(host, EVENT_XFER_COMPLETE);
+	mci_writel(host, IER, MCI_NOTBUSY);
+}
+
+#endif /* CONFIG_MMC_ATMELMCI_DMA */
+
 /*
  * Returns a mask of interrupt flags to be enabled after the whole
  * request has been prepared.
@@ -500,24 +654,27 @@ static u32 atmci_submit_data(struct atmel_mci *host, struct mmc_data *data)
 	host->data = data;
 
 	iflags = ATMCI_DATA_ERROR_FLAGS;
+	if (atmci_submit_data_dma(host, data)) {
+		host->data_chan = NULL;
 
-	/*
-	 * Errata: MMC data write operation with less than 12
-	 * bytes is impossible.
-	 *
-	 * Errata: MCI Transmit Data Register (TDR) FIFO
-	 * corruption when length is not multiple of 4.
-	 */
-	if (data->blocks * data->blksz < 12
-			|| (data->blocks * data->blksz) & 3)
-		host->need_reset = true;
+		/*
+		 * Errata: MMC data write operation with less than 12
+		 * bytes is impossible.
+		 *
+		 * Errata: MCI Transmit Data Register (TDR) FIFO
+		 * corruption when length is not multiple of 4.
+		 */
+		if (data->blocks * data->blksz < 12
+				|| (data->blocks * data->blksz) & 3)
+			host->need_reset = true;
 
-	host->sg = data->sg;
-	host->pio_offset = 0;
-	if (data->flags & MMC_DATA_READ)
-		iflags |= MCI_RXRDY;
-	else
-		iflags |= MCI_TXRDY;
+		host->sg = data->sg;
+		host->pio_offset = 0;
+		if (data->flags & MMC_DATA_READ)
+			iflags |= MCI_RXRDY;
+		else
+			iflags |= MCI_TXRDY;
+	}
 
 	return iflags;
 }
@@ -848,6 +1005,7 @@ static void atmci_command_complete(struct atmel_mci *host,
 
 		if (cmd->data) {
 			host->data = NULL;
+			atmci_stop_dma(host);
 			mci_writel(host, IDR, MCI_NOTBUSY
 					| MCI_TXRDY | MCI_RXRDY
 					| ATMCI_DATA_ERROR_FLAGS);
@@ -917,6 +1075,7 @@ static void atmci_detect_change(unsigned long data)
 					/* fall through */
 				case STATE_SENDING_DATA:
 					mrq->data->error = -ENOMEDIUM;
+					atmci_stop_dma(host);
 					break;
 				case STATE_DATA_BUSY:
 				case STATE_DATA_ERROR:
@@ -995,6 +1154,7 @@ static void atmci_tasklet_func(unsigned long priv)
 		case STATE_SENDING_DATA:
 			if (atmci_test_and_clear_pending(host,
 						EVENT_DATA_ERROR)) {
+				atmci_stop_dma(host);
 				if (data->stop)
 					send_stop_cmd(host, data);
 				state = STATE_DATA_ERROR;
@@ -1280,6 +1440,60 @@ static irqreturn_t atmci_detect_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_MMC_ATMELMCI_DMA
+
+static inline struct atmel_mci *
+dma_client_to_atmel_mci(struct dma_client *client)
+{
+	return container_of(client, struct atmel_mci, dma.client);
+}
+
+static enum dma_state_client atmci_dma_event(struct dma_client *client,
+		struct dma_chan *chan, enum dma_state state)
+{
+	struct atmel_mci	*host;
+	enum dma_state_client	ret = DMA_NAK;
+
+	host = dma_client_to_atmel_mci(client);
+
+	switch (state) {
+	case DMA_RESOURCE_AVAILABLE:
+		spin_lock_bh(&host->lock);
+		if (!host->dma.chan) {
+			host->dma.chan = chan;
+			ret = DMA_ACK;
+		}
+		spin_unlock_bh(&host->lock);
+
+		if (ret == DMA_ACK)
+			dev_info(&host->pdev->dev,
+					"Using %s for DMA transfers\n",
+					chan->dev.bus_id);
+		break;
+
+	case DMA_RESOURCE_REMOVED:
+		spin_lock_bh(&host->lock);
+		if (host->dma.chan == chan) {
+			host->dma.chan = NULL;
+			ret = DMA_ACK;
+		}
+		spin_unlock_bh(&host->lock);
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
+#endif /* CONFIG_MMC_ATMELMCI_DMA */
+
 static int __init atmci_init_slot(struct atmel_mci *host,
 		struct mci_slot_pdata *slot_data, unsigned int id,
 		u32 sdc_reg)
@@ -1434,6 +1648,25 @@ static int __init atmci_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_request_irq;
 
+#ifdef CONFIG_MMC_ATMELMCI_DMA
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
+#endif /* CONFIG_MMC_ATMELMCI_DMA */
+
 	platform_set_drvdata(pdev, host);
 
 	/* We need at least one slot to succeed */
@@ -1462,6 +1695,10 @@ static int __init atmci_probe(struct platform_device *pdev)
 	return 0;
 
 err_init_slot:
+#ifdef CONFIG_MMC_ATMELMCI_DMA
+	if (pdata->dma_slave)
+		dma_async_client_unregister(&host->dma.client);
+#endif
 	free_irq(irq, host);
 err_request_irq:
 	iounmap(host->regs);
@@ -1490,6 +1727,11 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	mci_readl(host, SR);
 	clk_disable(host->mck);
 
+#ifdef CONFIG_MMC_ATMELMCI_DMA
+	if (host->dma.client.slave)
+		dma_async_client_unregister(&host->dma.client);
+#endif
+
 	free_irq(platform_get_irq(pdev, 0), host);
 	iounmap(host->regs);
 
-- 
1.5.6.5

