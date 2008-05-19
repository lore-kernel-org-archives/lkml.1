Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYESIRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYESIRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYESIRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:17:08 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:34104 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYESIRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:17:04 -0400
Date: Mon, 19 May 2008 10:17:00 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx,
       sshtylyov@ru.mvista.com
Subject: Re: [PATCH 3/9] au1xmmc: remove pb1200 board-specific code from
	driver file
Message-ID: <20080519081700.GA22270@roarinelk.homelinux.net>
References: <20080519080339.GA21985@roarinelk.homelinux.net> <20080519080533.GD21985@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519080533.GD21985@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theres a tiny bug in the previous patch, please use this one here.

Thanks!

--- 
>From 20a9a4d454e6e381f632dfadf713b515f30045b1 Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Wed, 7 May 2008 14:57:01 +0200
Subject: [PATCH] au1xmmc: remove pb1200 board-specific code from driver file

Remove the DB1200 board-specific functions (card present, read-only,
activity LED methods) and instead add platform data which is passed
to the driver.  This also allows for platforms to implement other
carddetect schemes (e.g. dedicated irq) without having to pollute the
driver code.  The poll timer (used for pb1200) is kept for compatibility.

With the board-specific stuff gone, the drivers probe code can be
cleaned up considerably: this patch also rewrites the probe and
remove functions and removes a few unused variables.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/mmc/host/au1xmmc.c                |  508 +++++++++++++++++------------
 drivers/mmc/host/au1xmmc.h                |    9 +-
 include/asm-mips/mach-au1x00/au1100_mmc.h |   15 +-
 3 files changed, 304 insertions(+), 228 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index cc5f7bc..9036677 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -54,6 +54,7 @@
 #define DRIVER_NAME "au1xxx-mmc"
 
 /* Set this to enable special debugging macros */
+/* #define DEBUG */
 
 #ifdef DEBUG
 #define DBG(fmt, idx, args...) printk("au1xx(%d): DEBUG: " fmt, idx, ##args)
@@ -61,32 +62,6 @@
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
-#endif
-};
-
-#define AU1XMMC_CONTROLLER_COUNT (ARRAY_SIZE(au1xmmc_card_table))
-
-/* This array stores pointers for the hosts (used by the IRQ handler) */
-struct au1xmmc_host *au1xmmc_hosts[AU1XMMC_CONTROLLER_COUNT];
-static int dma = 1;
-
-#ifdef MODULE
-module_param(dma, bool, 0);
-MODULE_PARM_DESC(dma, "Use DMA engine for data transfers (0 = disabled)");
-#endif
-
 static inline void IRQ_ON(struct au1xmmc_host *host, u32 mask)
 {
 	u32 val = au_readl(HOST_CONFIG(host));
@@ -135,26 +110,33 @@ static inline void SEND_STOP(struct au1xmmc_host *host)
 
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
@@ -174,8 +156,6 @@ static void au1xmmc_finish_request(struct au1xmmc_host *host)
 
 	host->status = HOST_S_IDLE;
 
-	bcsr->disk_leds |= (1 << 8);
-
 	mmc_request_done(host->mmc, mrq);
 }
 
@@ -420,18 +400,18 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 			break;
 
 		if (status & SD_STATUS_RC) {
-			DBG("RX CRC Error [%d + %d].\n", host->id,
+			DBG("RX CRC Error [%d + %d].\n", host->pdev->id,
 					host->pio.len, count);
 			break;
 		}
 
 		if (status & SD_STATUS_RO) {
-			DBG("RX Overrun [%d + %d]\n", host->id,
+			DBG("RX Overrun [%d + %d]\n", host->pdev->id,
 					host->pio.len, count);
 			break;
 		}
 		else if (status & SD_STATUS_RU) {
-			DBG("RX Underrun [%d + %d]\n", host->id,
+			DBG("RX Underrun [%d + %d]\n", host->pdev->id,
 					host->pio.len,	count);
 			break;
 		}
@@ -571,12 +551,8 @@ static void au1xmmc_set_clock(struct au1xmmc_host *host, int rate)
 static int
 au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
 {
-
 	int datalen = data->blocks * data->blksz;
 
-	if (dma != 0)
-		host->flags |= HOST_F_DMA;
-
 	if (data->flags & MMC_DATA_READ)
 		host->flags |= HOST_F_RECV;
 	else
@@ -663,8 +639,6 @@ static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
 	host->mrq = mrq;
 	host->status = HOST_S_CMD;
 
-	bcsr->disk_leds &= ~(1 << 8);
-
 	if (mrq->data) {
 		FLUSH_FIFO(host);
 		flags = mrq->data->flags;
@@ -749,245 +723,339 @@ static void au1xmmc_dma_callback(int irq, void *dev_id)
 
 static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
 {
-
+	struct au1xmmc_host *host = dev_id;
 	u32 status;
-	int i, ret = 0;
 
-	disable_irq(AU1100_SD_IRQ);
+	status = au_readl(HOST_STATUS(host));
 
-	for(i = 0; i < AU1XMMC_CONTROLLER_COUNT; i++) {
-		struct au1xmmc_host * host = au1xmmc_hosts[i];
-		u32 handled = 1;
+	if (!(status & SD_STATUS_I))
+		return IRQ_NONE;	/* not ours */
 
-		status = au_readl(HOST_STATUS(host));
-
-		if (host->mrq && (status & STATUS_TIMEOUT)) {
-			if (status & SD_STATUS_RAT)
-				host->mrq->cmd->error = -ETIMEDOUT;
+	if (host->mrq && (status & STATUS_TIMEOUT)) {
+		if (status & SD_STATUS_RAT)
+			host->mrq->cmd->error = -ETIMEDOUT;
+		else if (status & SD_STATUS_DT)
+			host->mrq->data->error = -ETIMEDOUT;
 
-			else if (status & SD_STATUS_DT)
-				host->mrq->data->error = -ETIMEDOUT;
+		/* In PIO mode, interrupts might still be enabled */
+		IRQ_OFF(host, SD_CONFIG_NE | SD_CONFIG_TH);
 
-			/* In PIO mode, interrupts might still be enabled */
-			IRQ_OFF(host, SD_CONFIG_NE | SD_CONFIG_TH);
-
-			//IRQ_OFF(host, SD_CONFIG_TH|SD_CONFIG_RA|SD_CONFIG_RF);
-			tasklet_schedule(&host->finish_task);
-		}
+		/* IRQ_OFF(host, SD_CONFIG_TH|SD_CONFIG_RA|SD_CONFIG_RF); */
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
+	else if (status & SD_STATUS_DD) {
+		/* Sometimes we get a DD before a NE in PIO mode */
+		if (!(host->flags & HOST_F_DMA) && (status & SD_STATUS_NE))
+			au1xmmc_receive_pio(host);
+		else {
+			au1xmmc_data_complete(host, status);
+			/* tasklet_schedule(&host->data_task); */
 		}
+	}
 #endif
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
-		}
+	else if (status & SD_STATUS_CR) {
+		if (host->status == HOST_S_CMD)
+			au1xmmc_cmd_complete(host, status);
+
+	} else if (!(host->flags & HOST_F_DMA)) {
+		if ((host->flags & HOST_F_XMIT) && (status & STATUS_DATA_OUT))
+			au1xmmc_send_pio(host);
+		else if ((host->flags & HOST_F_RECV) && (status & STATUS_DATA_IN))
+			au1xmmc_receive_pio(host);
+
+	} else if (status & 0x203F3C70) {
+			DBG("Unhandled status %8.8x\n", host->pdev->id,
+				status);
+	}
 
-		au_writel(status, HOST_STATUS(host));
-		au_sync();
+	au_writel(status, HOST_STATUS(host));
+	au_sync();
 
-		ret |= handled;
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_SOC_AU1200
+/* 8bit memory DMA device */
+static dbdev_tab_t au1xmmc_mem_dbdev = {
+	.dev_id		= DSCR_CMD0_ALWAYS,
+	.dev_flags	= DEV_FLAGS_ANYUSE,
+	.dev_tsize	= 0,
+	.dev_devwidth	= 8,
+	.dev_physaddr	= 0x00000000,
+	.dev_intlevel	= 0,
+	.dev_intpolarity = 0,
+};
+static int memid;
+
+static int au1xmmc_dbdma_init(struct au1xmmc_host *host)
+{
+	struct resource *res;
+	int txid, rxid;
+
+	res = platform_get_resource(host->pdev, IORESOURCE_DMA, 0);
+	if (!res)
+		return -ENODEV;
+	txid = res->start;
+
+	res = platform_get_resource(host->pdev, IORESOURCE_DMA, 1);
+	if (!res)
+		return -ENODEV;
+	rxid = res->start;
+
+	if (!memid)
+		return -ENODEV;
+
+	host->tx_chan = au1xxx_dbdma_chan_alloc(memid, txid,
+				au1xmmc_dma_callback, (void *)host);
+	if (!host->tx_chan) {
+		dev_err(&host->pdev->dev, "cannot allocate TX DMA\n");
+		return -ENODEV;
 	}
 
-	enable_irq(AU1100_SD_IRQ);
-	return ret;
+	host->rx_chan = au1xxx_dbdma_chan_alloc(rxid, memid,
+				au1xmmc_dma_callback, (void *)host);
+	if (!host->rx_chan) {
+		dev_err(&host->pdev->dev, "cannot allocate RX DMA\n");
+		au1xxx_dbdma_chan_free(host->tx_chan);
+		return -ENODEV;
+	}
+
+	au1xxx_dbdma_set_devwidth(host->tx_chan, 8);
+	au1xxx_dbdma_set_devwidth(host->rx_chan, 8);
+
+	au1xxx_dbdma_ring_alloc(host->tx_chan, AU1XMMC_DESCRIPTOR_COUNT);
+	au1xxx_dbdma_ring_alloc(host->rx_chan, AU1XMMC_DESCRIPTOR_COUNT);
+
+	/* DBDMA is good to go */
+	host->flags |= HOST_F_DMA;
+
+	return 0;
 }
 
-static void au1xmmc_poll_event(unsigned long arg)
+static void au1xmmc_dbdma_shutdown(struct au1xmmc_host *host)
 {
-	struct au1xmmc_host *host = (struct au1xmmc_host *) arg;
+	if (host->flags & HOST_F_DMA) {
+		host->flags &= ~HOST_F_DMA;
+		au1xxx_dbdma_chan_free(host->tx_chan);
+		au1xxx_dbdma_chan_free(host->rx_chan);
+	}
+}
+#endif
 
+static const struct mmc_host_ops au1xmmc_ops = {
+	.request	= au1xmmc_request,
+	.set_ios	= au1xmmc_set_ios,
+	.get_ro		= au1xmmc_card_readonly,
+};
+
+static void au1xmmc_poll_event(unsigned long arg)
+{
+	struct au1xmmc_host *host = (struct au1xmmc_host *)arg;
 	int card = au1xmmc_card_inserted(host);
-        int controller = (host->flags & HOST_F_ACTIVE) ? 1 : 0;
+	int controller = (host->flags & HOST_F_ACTIVE) ? 1 : 0;
 
 	if (card != controller) {
 		host->flags &= ~HOST_F_ACTIVE;
-		if (card) host->flags |= HOST_F_ACTIVE;
+		if (card)
+			host->flags |= HOST_F_ACTIVE;
 		mmc_detect_change(host->mmc, 0);
 	}
 
+#ifdef DEBUG
 	if (host->mrq != NULL) {
 		u32 status = au_readl(HOST_STATUS(host));
-		DBG("PENDING - %8.8x\n", host->id, status);
+		DBG("PENDING - %8.8x\n", host->pdev->id, status);
 	}
-
+#endif
 	mod_timer(&host->timer, jiffies + AU1XMMC_DETECT_TIMEOUT);
 }
 
-static dbdev_tab_t au1xmmc_mem_dbdev =
-{
-	DSCR_CMD0_ALWAYS, DEV_FLAGS_ANYUSE, 0, 8, 0x00000000, 0, 0
-};
-
-static void au1xmmc_init_dma(struct au1xmmc_host *host)
+static void au1xmmc_init_cd_poll_timer(struct au1xmmc_host *host)
 {
-
-	u32 rxchan, txchan;
-
-	int txid = au1xmmc_card_table[host->id].tx_devid;
-	int rxid = au1xmmc_card_table[host->id].rx_devid;
-
-	/* DSCR_CMD0_ALWAYS has a stride of 32 bits, we need a stride
-	   of 8 bits.  And since devices are shared, we need to create
-	   our own to avoid freaking out other devices
-	*/
-
-	int memid = au1xxx_ddma_add_device(&au1xmmc_mem_dbdev);
-
-	txchan = au1xxx_dbdma_chan_alloc(memid, txid,
-					 au1xmmc_dma_callback, (void *) host);
-
-	rxchan = au1xxx_dbdma_chan_alloc(rxid, memid,
-					 au1xmmc_dma_callback, (void *) host);
-
-	au1xxx_dbdma_set_devwidth(txchan, 8);
-	au1xxx_dbdma_set_devwidth(rxchan, 8);
-
-	au1xxx_dbdma_ring_alloc(txchan, AU1XMMC_DESCRIPTOR_COUNT);
-	au1xxx_dbdma_ring_alloc(rxchan, AU1XMMC_DESCRIPTOR_COUNT);
-
-	host->tx_chan = txchan;
-	host->rx_chan = rxchan;
+	init_timer(&host->timer);
+	host->timer.function = au1xmmc_poll_event;
+	host->timer.data = (unsigned long)host;
+	host->timer.expires = jiffies + AU1XMMC_DETECT_TIMEOUT;
 }
 
-static const struct mmc_host_ops au1xmmc_ops = {
-	.request	= au1xmmc_request,
-	.set_ios	= au1xmmc_set_ios,
-	.get_ro		= au1xmmc_card_readonly,
-};
-
 static int __devinit au1xmmc_probe(struct platform_device *pdev)
 {
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
 
-	int i, ret = 0;
-
-	/* THe interrupt is shared among all controllers */
-	ret = request_irq(AU1100_SD_IRQ, au1xmmc_irq, IRQF_DISABLED, "MMC", 0);
+	host = mmc_priv(mmc);
+	host->mmc = mmc;
+	host->platdata = pdev->dev.platform_data;
+	host->pdev = pdev;
 
-	if (ret) {
-		printk(DRIVER_NAME "ERROR: Couldn't get int %d: %d\n",
-				AU1100_SD_IRQ, ret);
-		return -ENXIO;
+	ret = -ENODEV;
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "no mmio defined\n");
+		goto out1;
 	}
 
-	disable_irq(AU1100_SD_IRQ);
+	host->ioarea = request_mem_region(r->start, r->end - r->start + 1,
+					   pdev->name);
+	if (!host->ioarea) {
+		dev_err(&pdev->dev, "mmio already used\n");
+		goto out1;
+	}
 
-	for(i = 0; i < AU1XMMC_CONTROLLER_COUNT; i++) {
-		struct mmc_host *mmc = mmc_alloc_host(sizeof(struct au1xmmc_host), &pdev->dev);
-		struct au1xmmc_host *host = 0;
+	host->iobase = (unsigned long)ioremap(r->start, r->end - r->start + 1);
+	if (!host->iobase) {
+		dev_err(&pdev->dev, "cannot remap mmio\n");
+		goto out2;
+	}
 
-		if (!mmc) {
-			printk(DRIVER_NAME "ERROR: no mem for host %d\n", i);
-			au1xmmc_hosts[i] = 0;
-			continue;
-		}
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "no IRQ defined\n");
+		goto out3;
+	}
 
-		mmc->ops = &au1xmmc_ops;
+	host->irq = r->start;
+	/* IRQ is shared among both SD controllers */
+	ret = request_irq(host->irq, au1xmmc_irq, IRQF_SHARED,
+			  DRIVER_NAME, host);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot grab IRQ\n");
+		goto out3;
+	}
 
-		mmc->f_min =   450000;
-		mmc->f_max = 24000000;
+	mmc->ops = &au1xmmc_ops;
 
-		mmc->max_seg_size = AU1XMMC_DESCRIPTOR_SIZE;
-		mmc->max_phys_segs = AU1XMMC_DESCRIPTOR_COUNT;
+	mmc->f_min =   450000;
+	mmc->f_max = 24000000;
 
-		mmc->max_blk_size = 2048;
-		mmc->max_blk_count = 512;
+	mmc->max_seg_size = AU1XMMC_DESCRIPTOR_SIZE;
+	mmc->max_phys_segs = AU1XMMC_DESCRIPTOR_COUNT;
 
-		mmc->ocr_avail = AU1XMMC_OCR;
+	mmc->max_blk_size = 2048;
+	mmc->max_blk_count = 512;
 
-		host = mmc_priv(mmc);
-		host->mmc = mmc;
+	mmc->ocr_avail = AU1XMMC_OCR;
+	mmc->caps = 0;
 
-		host->id = i;
-		host->iobase = au1xmmc_card_table[host->id].iobase;
-		host->clock = 0;
-		host->power_mode = MMC_POWER_OFF;
+	host->status = HOST_S_IDLE;
 
-		host->flags = au1xmmc_card_inserted(host) ? HOST_F_ACTIVE : 0;
-		host->status = HOST_S_IDLE;
+	/* board-specific carddetect setup, if any */
+	if (host->platdata && host->platdata->cd_setup) {
+		ret = host->platdata->cd_setup(mmc, 1);
+		if (ret) {
+			dev_err(&pdev->dev, "board CD setup failed\n");
+			goto out4;
+		}
+	} else {
+		/* poll the board-specific is-card-in-socket-? method */
+		au1xmmc_init_cd_poll_timer(host);
+	}
 
-		init_timer(&host->timer);
+	tasklet_init(&host->data_task, au1xmmc_tasklet_data,
+			(unsigned long)host);
 
-		host->timer.function = au1xmmc_poll_event;
-		host->timer.data = (unsigned long) host;
-		host->timer.expires = jiffies + AU1XMMC_DETECT_TIMEOUT;
+	tasklet_init(&host->finish_task, au1xmmc_tasklet_finish,
+			(unsigned long)host);
 
-		tasklet_init(&host->data_task, au1xmmc_tasklet_data,
-				(unsigned long) host);
+#ifdef CONFIG_SOC_AU1200
+	ret = au1xmmc_dbdma_init(host);
+	if (ret)
+		printk(KERN_INFO DRIVER_NAME ": DBDMA init failed; using PIO\n");
+#endif
 
-		tasklet_init(&host->finish_task, au1xmmc_tasklet_finish,
-				(unsigned long) host);
+	au1xmmc_reset_controller(host);
 
-		spin_lock_init(&host->lock);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot add mmc host\n");
+		goto out5;
+	}
 
-		if (dma != 0)
-			au1xmmc_init_dma(host);
+	platform_set_drvdata(pdev, mmc);
 
-		au1xmmc_reset_controller(host);
+	/* start the carddetect poll timer */
+	if (!(host->platdata && host->platdata->cd_setup))
+		add_timer(&host->timer);
 
-		mmc_add_host(mmc);
-		au1xmmc_hosts[i] = host;
+	printk(KERN_INFO DRIVER_NAME ": MMC Controller %d set up at %8.8X"
+		" (mode=%s)\n", pdev->id, host->iobase,
+		host->flags & HOST_F_DMA ? "dma" : "pio");
 
-		add_timer(&host->timer);
+	return 0;	/* all ok */
 
-		printk(KERN_INFO DRIVER_NAME ": MMC Controller %d set up at %8.8X (mode=%s)\n",
-		       host->id, host->iobase, dma ? "dma" : "pio");
-	}
+out5:
+	au_writel(0, HOST_ENABLE(host));
+	au_writel(0, HOST_CONFIG(host));
+	au_writel(0, HOST_CONFIG2(host));
+	au_sync();
 
-	enable_irq(AU1100_SD_IRQ);
+#ifdef CONFIG_SOC_AU1200
+	au1xmmc_dbdma_shutdown(host);
+#endif
 
-	return 0;
+	tasklet_kill(&host->data_task);
+	tasklet_kill(&host->finish_task);
+
+	if (host->platdata && host->platdata->cd_setup)
+		host->platdata->cd_setup(mmc, 0);
+out4:
+	free_irq(host->irq, host);
+out3:
+	iounmap((void *)host->iobase);
+out2:
+	release_resource(host->ioarea);
+	kfree(host->ioarea);
+out1:
+	mmc_free_host(mmc);
+out0:
+	return ret;
 }
 
 static int __devexit au1xmmc_remove(struct platform_device *pdev)
 {
+	struct mmc_host *mmc = platform_get_drvdata(pdev);
+	struct au1xmmc_host *host;
+
+	if (mmc) {
+		host  = mmc_priv(mmc);
 
-	int i;
+		mmc_remove_host(mmc);
 
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
+		au_writel(0, HOST_CONFIG2(host));
+		au_sync();
 
 		tasklet_kill(&host->data_task);
 		tasklet_kill(&host->finish_task);
 
-		del_timer_sync(&host->timer);
+#ifdef CONFIG_SOC_AU1200
+		au1xmmc_dbdma_shutdown(host);
+#endif
 		au1xmmc_set_power(host, 0);
 
-		mmc_remove_host(host->mmc);
-
-		au1xxx_dbdma_chan_free(host->tx_chan);
-		au1xxx_dbdma_chan_free(host->rx_chan);
+		free_irq(host->irq, host);
+		iounmap((void *)host->iobase);
+		release_resource(host->ioarea);
+		kfree(host->ioarea);
 
-		au_writel(0x0, HOST_ENABLE(host));
-		au_sync();
+		mmc_free_host(mmc);
 	}
-
-	free_irq(AU1100_SD_IRQ, 0);
 	return 0;
 }
 
@@ -1004,21 +1072,31 @@ static struct platform_driver au1xmmc_driver = {
 
 static int __init au1xmmc_init(void)
 {
+#ifdef CONFIG_SOC_AU1200
+	/* DSCR_CMD0_ALWAYS has a stride of 32 bits, we need a stride
+	 * of 8 bits.  And since devices are shared, we need to create
+	 * our own to avoid freaking out other devices.
+	 */
+	memid = au1xxx_ddma_add_device(&au1xmmc_mem_dbdev);
+	if (!memid)
+		printk(KERN_ERR "au1xmmc: cannot add memory dbdma dev\n");
+#endif
 	return platform_driver_register(&au1xmmc_driver);
 }
 
 static void __exit au1xmmc_exit(void)
 {
+#ifdef CONFIG_SOC_AU1200
+	if (memid)
+		au1xxx_ddma_del_device(memid);
+#endif
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
index 341cbdf..3b40065 100644
--- a/drivers/mmc/host/au1xmmc.h
+++ b/drivers/mmc/host/au1xmmc.h
@@ -49,8 +49,6 @@ struct au1xmmc_host {
   struct mmc_host *mmc;
   struct mmc_request *mrq;
 
-  u32 id;
-
   u32 flags;
   u32 iobase;
   u32 clock;
@@ -73,11 +71,14 @@ struct au1xmmc_host {
   u32 tx_chan;
   u32 rx_chan;
 
+  int irq;
+
   struct timer_list timer;
   struct tasklet_struct finish_task;
   struct tasklet_struct data_task;
-
-  spinlock_t lock;
+  struct au1xmmc_platform_data *platdata;
+  struct platform_device *pdev;
+  struct resource *ioarea;
 };
 
 /* Status flags used by the host structure */
diff --git a/include/asm-mips/mach-au1x00/au1100_mmc.h b/include/asm-mips/mach-au1x00/au1100_mmc.h
index 9e0028f..c79dec1 100644
--- a/include/asm-mips/mach-au1x00/au1100_mmc.h
+++ b/include/asm-mips/mach-au1x00/au1100_mmc.h
@@ -38,15 +38,12 @@
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
+struct au1xmmc_platform_data {
+	int(*cd_setup)(void *mmc_host, int on);
+	int(*card_inserted)(void *mmc_host);
+	int(*card_readonly)(void *mmc_host);
+	void(*set_power)(void *mmc_host, int state);
+};
 
 #define SD0_BASE	0xB0600000
 #define SD1_BASE	0xB0680000
-- 
1.5.5.1

