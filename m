Return-Path: <linux-kernel-owner+w=401wt.eu-S1764900AbYEGQMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764900AbYEGQMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbYEGQM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:12:29 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:42784 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbYEGQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:12:25 -0400
Date: Wed, 7 May 2008 18:05:40 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] au1xmmc: remove db1x00 specific functions and platform
	device conversion
Message-ID: <20080507160540.GD17806@roarinelk.homelinux.net>
References: <20080507160154.GA17806@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507160154.GA17806@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8dc23d568939c8c12c358ee063fd38e8093d3c6f Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Wed, 7 May 2008 14:57:01 +0200
Subject: [PATCH] au1xmmc: remove db1x00 board-specific functions from driver

Remove the DB1200 board-specific functions (card present, read-only
methods) and instead add platform data which is passed to the driver.

With the board-specific stuff gone, the driver no longer needs to know
how many physical controllers the silicon actually has; every device
can be registered as needed,  update the code as necessary.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/mmc/host/au1xmmc.c                |  494 ++++++++++++++++++-----------
 drivers/mmc/host/au1xmmc.h                |   96 ------
 include/asm-mips/mach-au1x00/au1100_mmc.h |   43 +++-
 3 files changed, 338 insertions(+), 295 deletions(-)
 delete mode 100644 drivers/mmc/host/au1xmmc.h

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index cc5f7bc..17870cd 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -49,7 +49,6 @@
 #include <asm/mach-au1x00/au1100_mmc.h>
 
 #include <au1xxx.h>
-#include "au1xmmc.h"
 
 #define DRIVER_NAME "au1xxx-mmc"
 
@@ -61,31 +60,71 @@
 #define DBG(fmt, idx, args...)
 #endif
 
-const struct {
-	u32 iobase;
-	u32 tx_devid, rx_devid;
-	u16 bcsrpwr;
-	u16 bcsrstatus;
-	u16 wpstatus;
-} au1xmmc_card_table[] = {
-	{ SD0_BASE, DSCR_CMD0_SDMS_TX0, DSCR_CMD0_SDMS_RX0,
-	  BCSR_BOARD_SD0PWR, BCSR_INT_SD0INSERT, BCSR_STATUS_SD0WP },
-#ifndef CONFIG_MIPS_DB1200
-	{ SD1_BASE, DSCR_CMD0_SDMS_TX1, DSCR_CMD0_SDMS_RX1,
-	  BCSR_BOARD_DS1PWR, BCSR_INT_SD1INSERT, BCSR_STATUS_SD1WP }
+#define AU1XMMC_DESCRIPTOR_COUNT 1
+#define AU1XMMC_DESCRIPTOR_SIZE  4096
+
+#define AU1XMMC_OCR ( MMC_VDD_27_28 | MMC_VDD_28_29 | MMC_VDD_29_30  | \
+		      MMC_VDD_30_31 | MMC_VDD_31_32 | MMC_VDD_32_33  | \
+		      MMC_VDD_33_34 | MMC_VDD_34_35 | MMC_VDD_35_36)
+
+/* Easy access macros */
+
+#define HOST_STATUS(h)	((h)->iobase + SD_STATUS)
+#define HOST_CONFIG(h)	((h)->iobase + SD_CONFIG)
+#define HOST_ENABLE(h)	((h)->iobase + SD_ENABLE)
+#define HOST_TXPORT(h)	((h)->iobase + SD_TXPORT)
+#define HOST_RXPORT(h)	((h)->iobase + SD_RXPORT)
+#define HOST_CMDARG(h)	((h)->iobase + SD_CMDARG)
+#define HOST_BLKSIZE(h)	((h)->iobase + SD_BLKSIZE)
+#define HOST_CMD(h)	((h)->iobase + SD_CMD)
+#define HOST_CONFIG2(h)	((h)->iobase + SD_CONFIG2)
+#define HOST_TIMEOUT(h)	((h)->iobase + SD_TIMEOUT)
+#define HOST_DEBUG(h)	((h)->iobase + SD_DEBUG)
+
+#define DMA_CHANNEL(h) \
+	( ((h)->flags & HOST_F_XMIT) ? (h)->dma.tx_chan : (h)->dma.rx_chan)
+
+/* This gives us a hard value for the stop command that we can write directly
+ * to the command register
+ */
+
+#define STOP_CMD (SD_CMD_RT_1B|SD_CMD_CT_7|(0xC << SD_CMD_CI_SHIFT)|SD_CMD_GO)
+
+/* This is the set of interrupts that we configure by default */
+
+#if 0
+#define AU1XMMC_INTERRUPTS (SD_CONFIG_SC | SD_CONFIG_DT | SD_CONFIG_DD | \
+		SD_CONFIG_RAT | SD_CONFIG_CR | SD_CONFIG_I)
 #endif
-};
 
-#define AU1XMMC_CONTROLLER_COUNT (ARRAY_SIZE(au1xmmc_card_table))
+#define AU1XMMC_INTERRUPTS (SD_CONFIG_SC | SD_CONFIG_DT | \
+		SD_CONFIG_RAT | SD_CONFIG_CR | SD_CONFIG_I)
+/* The poll event (looking for insert/remove events runs twice a second */
+#define AU1XMMC_DETECT_TIMEOUT (HZ/2)
+
+/* Status flags used by the host structure */
+#define HOST_F_XMIT   0x0001
+#define HOST_F_RECV   0x0002
+#define HOST_F_DMA    0x0010
+#define HOST_F_ACTIVE 0x0100
+#define HOST_F_STOP   0x1000
+
+#define HOST_S_IDLE   0x0001
+#define HOST_S_CMD    0x0002
+#define HOST_S_DATA   0x0003
+#define HOST_S_STOP   0x0004
 
-/* This array stores pointers for the hosts (used by the IRQ handler) */
-struct au1xmmc_host *au1xmmc_hosts[AU1XMMC_CONTROLLER_COUNT];
 static int dma = 1;
 
-#ifdef MODULE
 module_param(dma, bool, 0);
 MODULE_PARM_DESC(dma, "Use DMA engine for data transfers (0 = disabled)");
-#endif
+
+/* 8bit memory device */
+static dbdev_tab_t au1xmmc_mem_dbdev = {
+	DSCR_CMD0_ALWAYS, DEV_FLAGS_ANYUSE, 0, 8, 0x00000000, 0, 0
+};
+static int memid;
+
 
 static inline void IRQ_ON(struct au1xmmc_host *host, u32 mask)
 {
@@ -135,31 +174,37 @@ static inline void SEND_STOP(struct au1xmmc_host *host)
 
 static void au1xmmc_set_power(struct au1xmmc_host *host, int state)
 {
-
-	u32 val = au1xmmc_card_table[host->id].bcsrpwr;
-
-	bcsr->board &= ~val;
-	if (state) bcsr->board |= val;
-
-	au_sync_delay(1);
+	if (host->platdata && host->platdata->set_power)
+		host->platdata->set_power(host->mmc, state);
 }
 
-static inline int au1xmmc_card_inserted(struct au1xmmc_host *host)
+static int au1xmmc_card_inserted(struct au1xmmc_host *host)
 {
-	return (bcsr->sig_status & au1xmmc_card_table[host->id].bcsrstatus)
-		? 1 : 0;
+	int ret;
+
+	if (host->platdata && host->platdata->card_inserted)
+		ret = host->platdata->card_inserted(host->mmc);
+	else
+		ret = 1;	/* assume there is a card */
+
+	return ret;
 }
 
 static int au1xmmc_card_readonly(struct mmc_host *mmc)
 {
 	struct au1xmmc_host *host = mmc_priv(mmc);
-	return (bcsr->status & au1xmmc_card_table[host->id].wpstatus)
-		? 1 : 0;
+	int ret;
+
+	if (host->platdata && host->platdata->card_readonly)
+		ret = host->platdata->card_readonly(mmc);
+	else
+		ret = 1;	/* assume card is read-only */
+
+	return ret;
 }
 
 static void au1xmmc_finish_request(struct au1xmmc_host *host)
 {
-
 	struct mmc_request *mrq = host->mrq;
 
 	host->mrq = NULL;
@@ -174,8 +219,6 @@ static void au1xmmc_finish_request(struct au1xmmc_host *host)
 
 	host->status = HOST_S_IDLE;
 
-	bcsr->disk_leds |= (1 << 8);
-
 	mmc_request_done(host->mmc, mrq);
 }
 
@@ -663,7 +706,9 @@ static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
 	host->mrq = mrq;
 	host->status = HOST_S_CMD;
 
-	bcsr->disk_leds &= ~(1 << 8);
+	au_writel(0, HOST_STATUS(host));
+	au_sync();
+	FLUSH_FIFO(host);
 
 	if (mrq->data) {
 		FLUSH_FIFO(host);
@@ -749,118 +794,87 @@ static void au1xmmc_dma_callback(int irq, void *dev_id)
 
 static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
 {
-
+	struct au1xmmc_host *host = dev_id;
 	u32 status;
-	int i, ret = 0;
-
-	disable_irq(AU1100_SD_IRQ);
-
-	for(i = 0; i < AU1XMMC_CONTROLLER_COUNT; i++) {
-		struct au1xmmc_host * host = au1xmmc_hosts[i];
-		u32 handled = 1;
 
-		status = au_readl(HOST_STATUS(host));
+	status = au_readl(HOST_STATUS(host));
 
-		if (host->mrq && (status & STATUS_TIMEOUT)) {
-			if (status & SD_STATUS_RAT)
-				host->mrq->cmd->error = -ETIMEDOUT;
+	if (!(status & (1<<15)))
+		return IRQ_NONE;	/* not ours */
 
-			else if (status & SD_STATUS_DT)
-				host->mrq->data->error = -ETIMEDOUT;
+	if (host->mrq && (status & STATUS_TIMEOUT)) {
+		if (status & SD_STATUS_RAT)
+			host->mrq->cmd->error = -ETIMEDOUT;
+		else if (status & SD_STATUS_DT)
+			host->mrq->data->error = -ETIMEDOUT;
 
-			/* In PIO mode, interrupts might still be enabled */
-			IRQ_OFF(host, SD_CONFIG_NE | SD_CONFIG_TH);
+		/* In PIO mode, interrupts might still be enabled */
+		IRQ_OFF(host, SD_CONFIG_NE | SD_CONFIG_TH);
 
-			//IRQ_OFF(host, SD_CONFIG_TH|SD_CONFIG_RA|SD_CONFIG_RF);
-			tasklet_schedule(&host->finish_task);
-		}
+		//IRQ_OFF(host, SD_CONFIG_TH|SD_CONFIG_RA|SD_CONFIG_RF);
+		tasklet_schedule(&host->finish_task);
+	}
 #if 0
-		else if (status & SD_STATUS_DD) {
-
-			/* Sometimes we get a DD before a NE in PIO mode */
-
-			if (!(host->flags & HOST_F_DMA) &&
-					(status & SD_STATUS_NE))
-				au1xmmc_receive_pio(host);
-			else {
-				au1xmmc_data_complete(host, status);
-				//tasklet_schedule(&host->data_task);
-			}
-		}
-#endif
-		else if (status & (SD_STATUS_CR)) {
-			if (host->status == HOST_S_CMD)
-				au1xmmc_cmd_complete(host,status);
-		}
-		else if (!(host->flags & HOST_F_DMA)) {
-			if ((host->flags & HOST_F_XMIT) &&
-			    (status & STATUS_DATA_OUT))
-				au1xmmc_send_pio(host);
-			else if ((host->flags & HOST_F_RECV) &&
-			    (status & STATUS_DATA_IN))
-				au1xmmc_receive_pio(host);
-		}
-		else if (status & 0x203FBC70) {
-			DBG("Unhandled status %8.8x\n", host->id, status);
-			handled = 0;
+	else if (status & SD_STATUS_DD) {
+		/* Sometimes we get a DD before a NE in PIO mode */
+		if (!(host->flags & HOST_F_DMA) && (status & SD_STATUS_NE))
+			au1xmmc_receive_pio(host);
+		else {
+			au1xmmc_data_complete(host, status);
+			//tasklet_schedule(&host->data_task);
 		}
-
-		au_writel(status, HOST_STATUS(host));
-		au_sync();
-
-		ret |= handled;
 	}
+#endif
+	else if (status & (SD_STATUS_CR)) {
+		if (host->status == HOST_S_CMD)
+			au1xmmc_cmd_complete(host,status);
 
-	enable_irq(AU1100_SD_IRQ);
-	return ret;
-}
-
-static void au1xmmc_poll_event(unsigned long arg)
-{
-	struct au1xmmc_host *host = (struct au1xmmc_host *) arg;
-
-	int card = au1xmmc_card_inserted(host);
-        int controller = (host->flags & HOST_F_ACTIVE) ? 1 : 0;
+	} else if (!(host->flags & HOST_F_DMA)) {
+		if ((host->flags & HOST_F_XMIT) && (status & STATUS_DATA_OUT))
+			au1xmmc_send_pio(host);
+		else if ((host->flags & HOST_F_RECV) && (status & STATUS_DATA_IN))
+			au1xmmc_receive_pio(host);
 
-	if (card != controller) {
-		host->flags &= ~HOST_F_ACTIVE;
-		if (card) host->flags |= HOST_F_ACTIVE;
-		mmc_detect_change(host->mmc, 0);
+	} else if (status & 0x203FBC70) {
+			DBG("Unhandled status %8.8x\n", host->id, status);
 	}
 
-	if (host->mrq != NULL) {
-		u32 status = au_readl(HOST_STATUS(host));
-		DBG("PENDING - %8.8x\n", host->id, status);
-	}
+	au_writel(status, HOST_STATUS(host));
+	au_sync();
 
-	mod_timer(&host->timer, jiffies + AU1XMMC_DETECT_TIMEOUT);
+	return IRQ_HANDLED;
 }
 
-static dbdev_tab_t au1xmmc_mem_dbdev =
-{
-	DSCR_CMD0_ALWAYS, DEV_FLAGS_ANYUSE, 0, 8, 0x00000000, 0, 0
-};
-
-static void au1xmmc_init_dma(struct au1xmmc_host *host)
+static int au1xmmc_init_dma(struct au1xmmc_host *host)
 {
-
+	struct resource *res;
 	u32 rxchan, txchan;
+	int txid, rxid;
 
-	int txid = au1xmmc_card_table[host->id].tx_devid;
-	int rxid = au1xmmc_card_table[host->id].rx_devid;
-
-	/* DSCR_CMD0_ALWAYS has a stride of 32 bits, we need a stride
-	   of 8 bits.  And since devices are shared, we need to create
-	   our own to avoid freaking out other devices
-	*/
+	res = platform_get_resource(host->pdev, IORESOURCE_DMA, 0);
+	if (!res)
+		return -ENODEV;
+	txid = res->start;
 
-	int memid = au1xxx_ddma_add_device(&au1xmmc_mem_dbdev);
+	res = platform_get_resource(host->pdev, IORESOURCE_DMA, 1);
+	if (!res)
+		return -ENODEV;
+	rxid = res->start;
 
 	txchan = au1xxx_dbdma_chan_alloc(memid, txid,
-					 au1xmmc_dma_callback, (void *) host);
+				au1xmmc_dma_callback, (void *)host);
+	if (!txchan) {
+		dev_err(&host->pdev->dev, "cannot allocate TX DMA\n");
+		return -ENODEV;
+	}
 
 	rxchan = au1xxx_dbdma_chan_alloc(rxid, memid,
-					 au1xmmc_dma_callback, (void *) host);
+				au1xmmc_dma_callback, (void *)host);
+	if (!rxchan) {
+		dev_err(&host->pdev->dev, "cannot allocate RX DMA\n");
+		au1xxx_dbdma_chan_free(txchan);
+		return -ENODEV;
+	}
 
 	au1xxx_dbdma_set_devwidth(txchan, 8);
 	au1xxx_dbdma_set_devwidth(rxchan, 8);
@@ -868,8 +882,10 @@ static void au1xmmc_init_dma(struct au1xmmc_host *host)
 	au1xxx_dbdma_ring_alloc(txchan, AU1XMMC_DESCRIPTOR_COUNT);
 	au1xxx_dbdma_ring_alloc(rxchan, AU1XMMC_DESCRIPTOR_COUNT);
 
-	host->tx_chan = txchan;
-	host->rx_chan = rxchan;
+	host->dma.tx_chan = txchan;
+	host->dma.rx_chan = rxchan;
+
+	return 0;
 }
 
 static const struct mmc_host_ops au1xmmc_ops = {
@@ -878,116 +894,197 @@ static const struct mmc_host_ops au1xmmc_ops = {
 	.get_ro		= au1xmmc_card_readonly,
 };
 
-static int __devinit au1xmmc_probe(struct platform_device *pdev)
+static void au1xmmc_poll_event(unsigned long arg)
 {
+	struct au1xmmc_host *host = (struct au1xmmc_host *)arg;
 
-	int i, ret = 0;
+	int card = au1xmmc_card_inserted(host);
+	int controller = (host->flags & HOST_F_ACTIVE) ? 1 : 0;
 
-	/* THe interrupt is shared among all controllers */
-	ret = request_irq(AU1100_SD_IRQ, au1xmmc_irq, IRQF_DISABLED, "MMC", 0);
+	if (card != controller) {
+		host->flags &= ~HOST_F_ACTIVE;
+		if (card)
+			host->flags |= HOST_F_ACTIVE;
+		mmc_detect_change(host->mmc, 0);
+	}
 
-	if (ret) {
-		printk(DRIVER_NAME "ERROR: Couldn't get int %d: %d\n",
-				AU1100_SD_IRQ, ret);
-		return -ENXIO;
+#if 0
+	if (host->mrq != NULL) {
+		u32 status = au_readl(HOST_STATUS(host));
+		DBG("PENDING - %8.8x\n", host->id, status);
 	}
+#endif
+	mod_timer(&host->timer, jiffies + AU1XMMC_DETECT_TIMEOUT);
+}
 
-	disable_irq(AU1100_SD_IRQ);
+static void au1xmmc_init_cd_poll_timer(struct au1xmmc_host *host)
+{
+	init_timer(&host->timer);
+	host->timer.function = au1xmmc_poll_event;
+	host->timer.data = (unsigned long)host;
+	host->timer.expires = jiffies + AU1XMMC_DETECT_TIMEOUT;
+}
 
-	for(i = 0; i < AU1XMMC_CONTROLLER_COUNT; i++) {
-		struct mmc_host *mmc = mmc_alloc_host(sizeof(struct au1xmmc_host), &pdev->dev);
-		struct au1xmmc_host *host = 0;
+static int __devinit au1xmmc_probe(struct platform_device *pdev)
+{
+	struct mmc_host *mmc;
+	struct au1xmmc_host *host;
+	struct resource *r;
+	int ret;
+
+	mmc = mmc_alloc_host(sizeof(struct au1xmmc_host), &pdev->dev);
+	if (!mmc) {
+		dev_err(&pdev->dev, "no memory for mmc host\n");
+		ret = -ENOMEM;
+		goto out0;
+	}
 
-		if (!mmc) {
-			printk(DRIVER_NAME "ERROR: no mem for host %d\n", i);
-			au1xmmc_hosts[i] = 0;
-			continue;
-		}
+	host = mmc_priv(mmc);
+	host->mmc = mmc;
+	host->platdata = pdev->dev.platform_data;
+	host->pdev = pdev;
 
-		mmc->ops = &au1xmmc_ops;
+	ret = -ENODEV;
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "no mmio defined\n");
+		goto out1;
+	}
+	host->iobase = (unsigned long)ioremap(r->start, 0xff);
+	if (!host->iobase) {
+		dev_err(&pdev->dev, "cannot remap mmio\n");
+		goto out1;
+	}
 
-		mmc->f_min =   450000;
-		mmc->f_max = 24000000;
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "no IRQ defined\n");
+		goto out2;
+	}
 
-		mmc->max_seg_size = AU1XMMC_DESCRIPTOR_SIZE;
-		mmc->max_phys_segs = AU1XMMC_DESCRIPTOR_COUNT;
+	host->irq = r->start;
+	/* IRQ is shared among both SD controllers */
+	ret = request_irq(host->irq, au1xmmc_irq, IRQF_SHARED,
+			  DRIVER_NAME, host);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot grab IRQ\n");
+		goto out2;
+	}
 
-		mmc->max_blk_size = 2048;
-		mmc->max_blk_count = 512;
+	mmc->ops = &au1xmmc_ops;
 
-		mmc->ocr_avail = AU1XMMC_OCR;
+	mmc->f_min =   450000;
+	mmc->f_max = 24000000;
 
-		host = mmc_priv(mmc);
-		host->mmc = mmc;
+	mmc->max_seg_size = AU1XMMC_DESCRIPTOR_SIZE;
+	mmc->max_phys_segs = AU1XMMC_DESCRIPTOR_COUNT;
 
-		host->id = i;
-		host->iobase = au1xmmc_card_table[host->id].iobase;
-		host->clock = 0;
-		host->power_mode = MMC_POWER_OFF;
+	mmc->max_blk_size = 2048;
+	mmc->max_blk_count = 512;
 
-		host->flags = au1xmmc_card_inserted(host) ? HOST_F_ACTIVE : 0;
-		host->status = HOST_S_IDLE;
+	mmc->ocr_avail = AU1XMMC_OCR;
+	mmc->caps = 0;
 
-		init_timer(&host->timer);
+	host->id = pdev->id;
+	host->status = HOST_S_IDLE;
 
-		host->timer.function = au1xmmc_poll_event;
-		host->timer.data = (unsigned long) host;
-		host->timer.expires = jiffies + AU1XMMC_DETECT_TIMEOUT;
+	/* board-specific carddetect setup, if any */
+	if (host->platdata && host->platdata->cd_setup) {
+		ret = host->platdata->cd_setup(mmc, 1);
+		if (ret) {
+			dev_err(&pdev->dev, "board CD setup failed\n");
+			goto out3;
+		}
+	} else {
+		/* poll the board-specific card-is-in-socket method */
+		au1xmmc_init_cd_poll_timer(host);
+	}
 
-		tasklet_init(&host->data_task, au1xmmc_tasklet_data,
-				(unsigned long) host);
+	tasklet_init(&host->data_task, au1xmmc_tasklet_data,
+			(unsigned long)host);
 
-		tasklet_init(&host->finish_task, au1xmmc_tasklet_finish,
-				(unsigned long) host);
+	tasklet_init(&host->finish_task, au1xmmc_tasklet_finish,
+			(unsigned long)host);
 
-		spin_lock_init(&host->lock);
+	if (dma) {
+		ret = au1xmmc_init_dma(host);
+		if (ret)
+			goto out4;
+	}
 
-		if (dma != 0)
-			au1xmmc_init_dma(host);
+	au1xmmc_reset_controller(host);
 
-		au1xmmc_reset_controller(host);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot add mmc host\n");
+		goto out5;
+	}
 
-		mmc_add_host(mmc);
-		au1xmmc_hosts[i] = host;
+	platform_set_drvdata(pdev, mmc);
 
+	/* start the carddetect poll timer */
+	if (!(host->platdata && host->platdata->cd_setup))
 		add_timer(&host->timer);
 
-		printk(KERN_INFO DRIVER_NAME ": MMC Controller %d set up at %8.8X (mode=%s)\n",
-		       host->id, host->iobase, dma ? "dma" : "pio");
-	}
+	printk(KERN_INFO DRIVER_NAME ": MMC Controller %d set up at %8.8X (mode=%s)\n",
+		       pdev->id, host->iobase, dma ? "dma" : "pio");
 
-	enable_irq(AU1100_SD_IRQ);
+	return 0;	/* all ok */
 
-	return 0;
+out5:
+	if (dma) {
+		au1xxx_dbdma_chan_free(host->dma.tx_chan);
+		au1xxx_dbdma_chan_free(host->dma.rx_chan);
+	}
+out4:
+	tasklet_kill(&host->data_task);
+	tasklet_kill(&host->finish_task);
+
+	if (host->platdata && host->platdata->cd_setup)
+		host->platdata->cd_setup(mmc, 0);
+out3:
+	free_irq(host->irq, host);
+out2:
+	iounmap((void *)host->iobase);
+out1:
+	mmc_free_host(mmc);
+out0:
+	return ret;
 }
 
 static int __devexit au1xmmc_remove(struct platform_device *pdev)
 {
+	struct mmc_host *mmc = platform_get_drvdata(pdev);
+	struct au1xmmc_host *host;
 
-	int i;
+	if (mmc) {
+		host  = mmc_priv(mmc);
 
-	disable_irq(AU1100_SD_IRQ);
+		if (host->platdata && host->platdata->cd_setup)
+			host->platdata->cd_setup(mmc, 0);
+		else
+			del_timer_sync(&host->timer);
 
-	for(i = 0; i < AU1XMMC_CONTROLLER_COUNT; i++) {
-		struct au1xmmc_host *host = au1xmmc_hosts[i];
-		if (!host) continue;
+		au_writel(0, HOST_ENABLE(host));
+		au_writel(0, HOST_CONFIG(host));
+		au_sync();
 
 		tasklet_kill(&host->data_task);
 		tasklet_kill(&host->finish_task);
 
-		del_timer_sync(&host->timer);
 		au1xmmc_set_power(host, 0);
 
-		mmc_remove_host(host->mmc);
+		free_irq(host->irq, host);
 
-		au1xxx_dbdma_chan_free(host->tx_chan);
-		au1xxx_dbdma_chan_free(host->rx_chan);
+		mmc_remove_host(mmc);
 
-		au_writel(0x0, HOST_ENABLE(host));
-		au_sync();
-	}
+		if (dma) {
+			au1xxx_dbdma_chan_free(host->dma.tx_chan);
+			au1xxx_dbdma_chan_free(host->dma.rx_chan);
+		}
 
-	free_irq(AU1100_SD_IRQ, 0);
+		mmc_free_host(mmc);
+	}
 	return 0;
 }
 
@@ -1004,21 +1101,32 @@ static struct platform_driver au1xmmc_driver = {
 
 static int __init au1xmmc_init(void)
 {
+	if (dma) {
+		/* DSCR_CMD0_ALWAYS has a stride of 32 bits, we need a stride
+		   of 8 bits.  And since devices are shared, we need to create
+		   our own to avoid freaking out other devices
+		 */
+		if (!memid)
+			memid = au1xxx_ddma_add_device(&au1xmmc_mem_dbdev);
+		if (!memid) {
+			printk(KERN_ERR "au1xmmc: cannot add memory dma dev\n");
+			return -ENODEV;
+		}
+	}
 	return platform_driver_register(&au1xmmc_driver);
 }
 
 static void __exit au1xmmc_exit(void)
 {
+	if (dma && memid)
+		au1xxx_ddma_del_device(memid);
 	platform_driver_unregister(&au1xmmc_driver);
 }
 
 module_init(au1xmmc_init);
 module_exit(au1xmmc_exit);
 
-#ifdef MODULE
 MODULE_AUTHOR("Advanced Micro Devices, Inc");
 MODULE_DESCRIPTION("MMC/SD driver for the Alchemy Au1XXX");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:au1xxx-mmc");
-#endif
-
diff --git a/drivers/mmc/host/au1xmmc.h b/drivers/mmc/host/au1xmmc.h
deleted file mode 100644
index 341cbdf..0000000
--- a/drivers/mmc/host/au1xmmc.h
+++ /dev/null
@@ -1,96 +0,0 @@
-#ifndef _AU1XMMC_H_
-#define _AU1XMMC_H_
-
-/* Hardware definitions */
-
-#define AU1XMMC_DESCRIPTOR_COUNT 1
-#define AU1XMMC_DESCRIPTOR_SIZE  2048
-
-#define AU1XMMC_OCR ( MMC_VDD_27_28 | MMC_VDD_28_29 | MMC_VDD_29_30  | \
-		      MMC_VDD_30_31 | MMC_VDD_31_32 | MMC_VDD_32_33  | \
-		      MMC_VDD_33_34 | MMC_VDD_34_35 | MMC_VDD_35_36)
-
-/* Easy access macros */
-
-#define HOST_STATUS(h)	((h)->iobase + SD_STATUS)
-#define HOST_CONFIG(h)	((h)->iobase + SD_CONFIG)
-#define HOST_ENABLE(h)	((h)->iobase + SD_ENABLE)
-#define HOST_TXPORT(h)	((h)->iobase + SD_TXPORT)
-#define HOST_RXPORT(h)	((h)->iobase + SD_RXPORT)
-#define HOST_CMDARG(h)	((h)->iobase + SD_CMDARG)
-#define HOST_BLKSIZE(h)	((h)->iobase + SD_BLKSIZE)
-#define HOST_CMD(h)	((h)->iobase + SD_CMD)
-#define HOST_CONFIG2(h)	((h)->iobase + SD_CONFIG2)
-#define HOST_TIMEOUT(h)	((h)->iobase + SD_TIMEOUT)
-#define HOST_DEBUG(h)	((h)->iobase + SD_DEBUG)
-
-#define DMA_CHANNEL(h) \
-	( ((h)->flags & HOST_F_XMIT) ? (h)->tx_chan : (h)->rx_chan)
-
-/* This gives us a hard value for the stop command that we can write directly
- * to the command register
- */
-
-#define STOP_CMD (SD_CMD_RT_1B|SD_CMD_CT_7|(0xC << SD_CMD_CI_SHIFT)|SD_CMD_GO)
-
-/* This is the set of interrupts that we configure by default */
-
-#if 0
-#define AU1XMMC_INTERRUPTS (SD_CONFIG_SC | SD_CONFIG_DT | SD_CONFIG_DD | \
-		SD_CONFIG_RAT | SD_CONFIG_CR | SD_CONFIG_I)
-#endif
-
-#define AU1XMMC_INTERRUPTS (SD_CONFIG_SC | SD_CONFIG_DT | \
-		SD_CONFIG_RAT | SD_CONFIG_CR | SD_CONFIG_I)
-/* The poll event (looking for insert/remove events runs twice a second */
-#define AU1XMMC_DETECT_TIMEOUT (HZ/2)
-
-struct au1xmmc_host {
-  struct mmc_host *mmc;
-  struct mmc_request *mrq;
-
-  u32 id;
-
-  u32 flags;
-  u32 iobase;
-  u32 clock;
-  u32 bus_width;
-  u32 power_mode;
-
-  int status;
-
-   struct {
-	   int len;
-	   int dir;
-  } dma;
-
-   struct {
-	   int index;
-	   int offset;
-	   int len;
-  } pio;
-
-  u32 tx_chan;
-  u32 rx_chan;
-
-  struct timer_list timer;
-  struct tasklet_struct finish_task;
-  struct tasklet_struct data_task;
-
-  spinlock_t lock;
-};
-
-/* Status flags used by the host structure */
-
-#define HOST_F_XMIT   0x0001
-#define HOST_F_RECV   0x0002
-#define HOST_F_DMA    0x0010
-#define HOST_F_ACTIVE 0x0100
-#define HOST_F_STOP   0x1000
-
-#define HOST_S_IDLE   0x0001
-#define HOST_S_CMD    0x0002
-#define HOST_S_DATA   0x0003
-#define HOST_S_STOP   0x0004
-
-#endif
diff --git a/include/asm-mips/mach-au1x00/au1100_mmc.h b/include/asm-mips/mach-au1x00/au1100_mmc.h
index 9e0028f..6474fac 100644
--- a/include/asm-mips/mach-au1x00/au1100_mmc.h
+++ b/include/asm-mips/mach-au1x00/au1100_mmc.h
@@ -38,15 +38,46 @@
 #ifndef __ASM_AU1100_MMC_H
 #define __ASM_AU1100_MMC_H
 
-
-#define NUM_AU1100_MMC_CONTROLLERS	2
-
-#if defined(CONFIG_SOC_AU1100)
-#define AU1100_SD_IRQ	AU1100_SD_INT
-#elif defined(CONFIG_SOC_AU1200)
-#define AU1100_SD_IRQ	AU1200_SD_INT
-#endif
-
+struct au1xmmc_platdata {
+	int(*cd_setup)(void *mmc_host, int on);
+	int(*card_inserted)(void *mmc_host);
+	int(*card_readonly)(void *mmc_host);
+	void(*set_power)(void *mmc_host, int state);
+};
+
+struct au1xmmc_host {
+	struct mmc_host *mmc;
+	struct mmc_request *mrq;
+
+	u32 id;
+
+	u32 flags;
+	u32 iobase;
+	u32 clock;
+
+	int status;
+
+	struct {
+		int len;
+		int dir;
+		u32 tx_chan;
+		u32 rx_chan;
+	} dma;
+
+	struct {
+		int index;
+		int offset;
+		int len;
+	} pio;
+
+	struct timer_list timer;
+	struct tasklet_struct finish_task;
+	struct tasklet_struct data_task;
+
+	struct platform_device *pdev;
+	struct au1xmmc_platdata *platdata;
+	int irq;
+};
 
 #define SD0_BASE	0xB0600000
 #define SD1_BASE	0xB0680000
-- 
1.5.5.1

