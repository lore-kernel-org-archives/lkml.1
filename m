Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYIVQjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYIVQjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYIVQi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:38:56 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35085 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbYIVQiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:38:52 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 3/4] atmel-mci: support multiple mmc slots
Date: Mon, 22 Sep 2008 18:38:16 +0200
Message-Id: <1222101497-21183-4-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 22 Sep 2008 16:38:06.0001 (UTC) FILETIME=[96C51210:01C91CD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Atmel MCI controller can drive multiple cards through separate sets
of pins, but only one at a time. This patch adds support for
multiplexing access to the controller so that multiple card slots can be
used as if they were hooked up to separate mmc controllers.

The atmel-mci driver registers each slot as a separate mmc_host. Both
access the same common controller state, but they also have some state
on their own for card detection/write protect handling, and separate
shadows of the MR and SDCR registers.

When one of the slots receives a request from the mmc core, the common
controller state is checked. If it's idle, the request is submitted
immediately. If not, the request is added to a queue. When a request is
done, the queue is checked and if there is a queued request, it is
submitted before the completion callback is called.

This patch also includes a few cleanups and fixes, including a locking
overhaul. I had to change the locking extensively in any case, so I
might as well try to get it right. The driver no longer takes any
irq-safe locks, which may or may not improve the overall system
performance.

This patch also adds a bit of documentation of the internal data
structures.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |  851 ++++++++++++++++++++++++++----------------
 1 files changed, 525 insertions(+), 326 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index e2d321a..a7de55f 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -42,20 +42,81 @@ enum {
 };
 
 enum atmel_mci_state {
-	STATE_SENDING_CMD = 0,
+	STATE_IDLE = 0,
+	STATE_SENDING_CMD,
 	STATE_SENDING_DATA,
 	STATE_DATA_BUSY,
 	STATE_SENDING_STOP,
 	STATE_DATA_ERROR,
 };
 
+/**
+ * struct atmel_mci - MMC controller state shared between all slots
+ * @lock: Spinlock protecting the queue and associated data.
+ * @regs: Pointer to MMIO registers.
+ * @sg: Scatterlist entry currently being processed by PIO code, if any.
+ * @pio_offset: Offset into the current scatterlist entry.
+ * @cur_slot: The slot which is currently using the controller.
+ * @mrq: The request currently being processed on @cur_slot,
+ *	or NULL if the controller is idle.
+ * @cmd: The command currently being sent to the card, or NULL.
+ * @data: The data currently being transferred, or NULL if no data
+ *	transfer is in progress.
+ * @dma: DMA client state.
+ * @data_chan: DMA channel being used for the current data transfer.
+ * @cmd_status: Snapshot of SR taken upon completion of the current
+ *	command. Only valid when EVENT_CMD_COMPLETE is pending.
+ * @data_status: Snapshot of SR taken upon completion of the current
+ *	data transfer. Only valid when EVENT_DATA_COMPLETE or
+ *	EVENT_DATA_ERROR is pending.
+ * @stop_cmdr: Value to be loaded into CMDR when the stop command is
+ *	to be sent.
+ * @tasklet: Tasklet running the request state machine.
+ * @pending_events: Bitmask of events flagged by the interrupt handler
+ *	to be processed by the tasklet.
+ * @completed_events: Bitmask of events which the state machine has
+ *	processed.
+ * @state: Tasklet state.
+ * @queue: List of slots waiting for access to the controller.
+ * @bus_hz: The rate of @mck in Hz. This forms the basis for MMC bus
+ *	rate and timeout calculations.
+ * @mapbase: Physical address of the MMIO registers.
+ * @mck: The peripheral bus clock hooked up to the MMC controller.
+ * @pdev: Platform device associated with the MMC controller.
+ * @slots: List of all slots sharing this MMC controller.
+ *
+ * Locking
+ * =======
+ *
+ * @lock is a softirq-safe spinlock protecting @queue as well as
+ * @cur_slot, @mrq and @state. These must always be updated
+ * at the same time while holding @lock.
+ *
+ * The @mrq field of struct atmel_mci_slot is also protected by @lock,
+ * and must always be written at the same time as the slot is added to
+ * @queue.
+ *
+ * @pending_events and @completed_events are accessed using atomic bit
+ * operations, so they don't need any locking.
+ *
+ * None of the fields touched by the interrupt handler need any
+ * locking. However, ordering is important: Before EVENT_DATA_ERROR or
+ * EVENT_DATA_COMPLETE is set in @pending_events, all data-related
+ * interrupts must be disabled and @data_status updated with a
+ * snapshot of SR. Similarly, before EVENT_CMD_COMPLETE is set, the
+ * CMDRDY interupt must be disabled and @cmd_status updated with a
+ * snapshot of SR, and before EVENT_XFER_COMPLETE can be set, the
+ * bytes_xfered field of @data must be written. This is ensured by
+ * using barriers.
+ */
 struct atmel_mci {
-	struct mmc_host		*mmc;
+	spinlock_t		lock;
 	void __iomem		*regs;
 
 	struct scatterlist	*sg;
 	unsigned int		pio_offset;
 
+	struct atmel_mci_slot	*cur_slot;
 	struct mmc_request	*mrq;
 	struct mmc_command	*cmd;
 	struct mmc_data		*data;
@@ -64,25 +125,60 @@ struct atmel_mci {
 	u32			data_status;
 	u32			stop_cmdr;
 
-	u32			mode_reg;
-	u32			sdc_reg;
-
 	struct tasklet_struct	tasklet;
 	unsigned long		pending_events;
 	unsigned long		completed_events;
 	enum atmel_mci_state	state;
+	struct list_head	queue;
+
+	unsigned long		bus_hz;
+	unsigned long		mapbase;
+	struct clk		*mck;
+	struct platform_device	*pdev;
+
+	struct list_head	slots;
+};
+
+/**
+ * struct atmel_mci_slot - MMC slot state
+ * @mmc: The mmc_host representing this slot.
+ * @host: The MMC controller this slot is using.
+ * @mode_reg: Value of MR to be written before using this slot.
+ * @sdc_reg: Value of SDCR to be written before using this slot.
+ * @mrq: mmc_request currently being processed or waiting to be
+ *	processed, or NULL when the slot is idle.
+ * @queue_node: List node for placing this node in the @queue list of
+ *	&struct atmel_mci.
+ * @flags: Random state bits associated with the slot.
+ * @detect_pin: GPIO pin used for card detection, or negative if not
+ *	available.
+ * @wp_pin: GPIO pin used for card write protect sending, or negative
+ *	if not available.
+ * @detect_timer: Timer used for debouncing @detect_pin interrupts.
+ * @slot_node: List node for placing this node in the @slots list of
+ *	&struct atmel_mci.
+ */
+struct atmel_mci_slot {
+	struct mmc_host		*mmc;
+	struct atmel_mci	*host;
+
+	u32			mode_reg;
+	u32			sdc_reg;
+
+	struct mmc_request	*mrq;
+	struct list_head	queue_node;
+
+	unsigned long		flags;
+#define ATMCI_CARD_PRESENT	0
+#define ATMCI_CARD_NEED_INIT	1
+#define ATMCI_SHUTDOWN		2
 
-	int			present;
 	int			detect_pin;
 	int			wp_pin;
 
-	/* For detect pin debouncing */
 	struct timer_list	detect_timer;
 
-	unsigned long		bus_hz;
-	unsigned long		mapbase;
-	struct clk		*mck;
-	struct platform_device	*pdev;
+	struct list_head	slot_node;
 };
 
 #define atmci_test_and_clear_pending(host, event)		\
@@ -98,14 +194,15 @@ struct atmel_mci {
  */
 static int atmci_req_show(struct seq_file *s, void *v)
 {
-	struct atmel_mci	*host = s->private;
-	struct mmc_request	*mrq = host->mrq;
+	struct atmel_mci_slot	*slot = s->private;
+	struct mmc_request	*mrq;
 	struct mmc_command	*cmd;
 	struct mmc_command	*stop;
 	struct mmc_data		*data;
 
 	/* Make sure we get a consistent snapshot */
-	spin_lock_irq(&host->mmc->lock);
+	spin_lock_bh(&slot->host->lock);
+	mrq = slot->mrq;
 
 	if (mrq) {
 		cmd = mrq->cmd;
@@ -130,7 +227,7 @@ static int atmci_req_show(struct seq_file *s, void *v)
 				stop->resp[2], stop->error);
 	}
 
-	spin_unlock_irq(&host->mmc->lock);
+	spin_unlock_bh(&slot->host->lock);
 
 	return 0;
 }
@@ -193,12 +290,16 @@ static int atmci_regs_show(struct seq_file *s, void *v)
 	if (!buf)
 		return -ENOMEM;
 
-	/* Grab a more or less consistent snapshot */
-	spin_lock_irq(&host->mmc->lock);
+	/*
+	 * Grab a more or less consistent snapshot. Note that we're
+	 * not disabling interrupts, so IMR and SR may not be
+	 * consistent.
+	 */
+	spin_lock_bh(&host->lock);
 	clk_enable(host->mck);
 	memcpy_fromio(buf, host->regs, MCI_REGS_SIZE);
 	clk_disable(host->mck);
-	spin_unlock_irq(&host->mmc->lock);
+	spin_unlock_bh(&host->lock);
 
 	seq_printf(s, "MR:\t0x%08x%s%s CLKDIV=%u\n",
 			buf[MCI_MR / 4],
@@ -236,13 +337,13 @@ static const struct file_operations atmci_regs_fops = {
 	.release	= single_release,
 };
 
-static void atmci_init_debugfs(struct atmel_mci *host)
+static void atmci_init_debugfs(struct atmel_mci_slot *slot)
 {
-	struct mmc_host	*mmc;
-	struct dentry	*root;
-	struct dentry	*node;
+	struct mmc_host		*mmc = slot->mmc;
+	struct atmel_mci	*host = slot->host;
+	struct dentry		*root;
+	struct dentry		*node;
 
-	mmc = host->mmc;
 	root = mmc->debugfs_root;
 	if (!root)
 		return;
@@ -254,7 +355,7 @@ static void atmci_init_debugfs(struct atmel_mci *host)
 	if (!node)
 		goto err;
 
-	node = debugfs_create_file("req", S_IRUSR, root, host, &atmci_req_fops);
+	node = debugfs_create_file("req", S_IRUSR, root, slot, &atmci_req_fops);
 	if (!node)
 		goto err;
 
@@ -275,25 +376,7 @@ static void atmci_init_debugfs(struct atmel_mci *host)
 	return;
 
 err:
-	dev_err(&host->pdev->dev,
-		"failed to initialize debugfs for controller\n");
-}
-
-static void atmci_enable(struct atmel_mci *host)
-{
-	clk_enable(host->mck);
-	mci_writel(host, CR, MCI_CR_MCIEN);
-	mci_writel(host, MR, host->mode_reg);
-	mci_writel(host, SDCR, host->sdc_reg);
-}
-
-static void atmci_disable(struct atmel_mci *host)
-{
-	mci_writel(host, CR, MCI_CR_SWRST);
-
-	/* Stall until write is complete, then disable the bus clock */
-	mci_readl(host, SR);
-	clk_disable(host->mck);
+	dev_err(&mmc->class_dev, "failed to initialize debugfs for slot\n");
 }
 
 static inline unsigned int ns_to_clocks(struct atmel_mci *host,
@@ -303,7 +386,7 @@ static inline unsigned int ns_to_clocks(struct atmel_mci *host,
 }
 
 static void atmci_set_timeout(struct atmel_mci *host,
-			      struct mmc_data *data)
+		struct atmel_mci_slot *slot, struct mmc_data *data)
 {
 	static unsigned	dtomul_to_shift[] = {
 		0, 4, 7, 8, 10, 12, 16, 20
@@ -326,7 +409,7 @@ static void atmci_set_timeout(struct atmel_mci *host,
 		dtocyc = 15;
 	}
 
-	dev_vdbg(&host->mmc->class_dev, "setting timeout to %u cycles\n",
+	dev_vdbg(&slot->mmc->class_dev, "setting timeout to %u cycles\n",
 			dtocyc << dtomul_to_shift[dtomul]);
 	mci_writel(host, DTOR, (MCI_DTOMUL(dtomul) | MCI_DTOCYC(dtocyc)));
 }
@@ -379,13 +462,12 @@ static u32 atmci_prepare_command(struct mmc_host *mmc,
 }
 
 static void atmci_start_command(struct atmel_mci *host,
-				struct mmc_command *cmd,
-				u32 cmd_flags)
+		struct mmc_command *cmd, u32 cmd_flags)
 {
 	WARN_ON(host->cmd);
 	host->cmd = cmd;
 
-	dev_vdbg(&host->mmc->class_dev,
+	dev_vdbg(&host->pdev->dev,
 			"start command: ARGR=0x%08x CMDR=0x%08x\n",
 			cmd->arg, cmd_flags);
 
@@ -393,34 +475,19 @@ static void atmci_start_command(struct atmel_mci *host,
 	mci_writel(host, CMDR, cmd_flags);
 }
 
-static void send_stop_cmd(struct mmc_host *mmc, struct mmc_data *data)
+static void send_stop_cmd(struct atmel_mci *host, struct mmc_data *data)
 {
-	struct atmel_mci *host = mmc_priv(mmc);
-
 	atmci_start_command(host, data->stop, host->stop_cmdr);
 	mci_writel(host, IER, MCI_CMDRDY);
 }
 
-static void atmci_request_end(struct mmc_host *mmc, struct mmc_request *mrq)
-{
-	struct atmel_mci *host = mmc_priv(mmc);
-
-	WARN_ON(host->cmd || host->data);
-	host->mrq = NULL;
-
-	atmci_disable(host);
-
-	mmc_request_done(mmc, mrq);
-}
-
 /*
  * Returns a mask of interrupt flags to be enabled after the whole
  * request has been prepared.
  */
-static u32 atmci_submit_data(struct mmc_host *mmc, struct mmc_data *data)
+static u32 atmci_submit_data(struct atmel_mci *host, struct mmc_data *data)
 {
-	struct atmel_mci	*host = mmc_priv(mmc);
-	u32			iflags;
+	u32 iflags;
 
 	data->error = -EINPROGRESS;
 
@@ -428,11 +495,6 @@ static u32 atmci_submit_data(struct mmc_host *mmc, struct mmc_data *data)
 	host->sg = NULL;
 	host->data = data;
 
-	mci_writel(host, BLKR, MCI_BCNT(data->blocks)
-			| MCI_BLKLEN(data->blksz));
-	dev_vdbg(&mmc->class_dev, "BLKR=0x%08x\n",
-			MCI_BCNT(data->blocks) | MCI_BLKLEN(data->blksz));
-
 	iflags = ATMCI_DATA_ERROR_FLAGS;
 	host->sg = data->sg;
 	host->pio_offset = 0;
@@ -444,60 +506,57 @@ static u32 atmci_submit_data(struct mmc_host *mmc, struct mmc_data *data)
 	return iflags;
 }
 
-static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
+static void atmci_start_request(struct atmel_mci *host,
+		struct atmel_mci_slot *slot)
 {
-	struct atmel_mci	*host = mmc_priv(mmc);
-	struct mmc_data		*data;
+	struct mmc_request	*mrq;
 	struct mmc_command	*cmd;
+	struct mmc_data		*data;
 	u32			iflags;
-	u32			cmdflags = 0;
-
-	iflags = mci_readl(host, IMR);
-	if (iflags)
-		dev_warn(&mmc->class_dev, "WARNING: IMR=0x%08x\n",
-				mci_readl(host, IMR));
-
-	WARN_ON(host->mrq != NULL);
-
-	/*
-	 * We may "know" the card is gone even though there's still an
-	 * electrical connection. If so, we really need to communicate
-	 * this to the MMC core since there won't be any more
-	 * interrupts as the card is completely removed. Otherwise,
-	 * the MMC core might believe the card is still there even
-	 * though the card was just removed very slowly.
-	 */
-	if (!host->present) {
-		mrq->cmd->error = -ENOMEDIUM;
-		mmc_request_done(mmc, mrq);
-		return;
-	}
+	u32			cmdflags;
 
+	mrq = slot->mrq;
+	host->cur_slot = slot;
 	host->mrq = mrq;
+
 	host->pending_events = 0;
 	host->completed_events = 0;
-	host->state = STATE_SENDING_CMD;
 
-	atmci_enable(host);
+	mci_writel(host, CR, MCI_CR_MCIEN);
+	mci_writel(host, MR, slot->mode_reg);
+	mci_writel(host, SDCR, slot->sdc_reg);
+
+	iflags = mci_readl(host, IMR);
+	if (iflags)
+		dev_warn(&slot->mmc->class_dev, "WARNING: IMR=0x%08x\n",
+				iflags);
+
+	if (unlikely(test_and_clear_bit(ATMCI_CARD_NEED_INIT, &slot->flags))) {
+		/* Send init sequence (74 clock cycles) */
+		mci_writel(host, CMDR, MCI_CMDR_SPCMD_INIT);
+		while (!(mci_readl(host, SR) & MCI_CMDRDY))
+			cpu_relax();
+	}
 
-	/* We don't support multiple blocks of weird lengths. */
 	data = mrq->data;
 	if (data) {
-		if (data->blocks > 1 && data->blksz & 3)
-			goto fail;
-		atmci_set_timeout(host, data);
+		atmci_set_timeout(host, slot, data);
+		mci_writel(host, BLKR, MCI_BCNT(data->blocks)
+				| MCI_BLKLEN(data->blksz));
+		dev_vdbg(&slot->mmc->class_dev, "BLKR=0x%08x\n",
+			MCI_BCNT(data->blocks) | MCI_BLKLEN(data->blksz));
 	}
 
 	iflags = MCI_CMDRDY;
 	cmd = mrq->cmd;
-	cmdflags = atmci_prepare_command(mmc, cmd);
+	cmdflags = atmci_prepare_command(slot->mmc, cmd);
 	atmci_start_command(host, cmd, cmdflags);
 
 	if (data)
-		iflags |= atmci_submit_data(mmc, data);
+		iflags |= atmci_submit_data(host, data);
 
 	if (mrq->stop) {
-		host->stop_cmdr = atmci_prepare_command(mmc, mrq->stop);
+		host->stop_cmdr = atmci_prepare_command(slot->mmc, mrq->stop);
 		host->stop_cmdr |= MCI_CMDR_STOP_XFER;
 		if (!(data->flags & MMC_DATA_WRITE))
 			host->stop_cmdr |= MCI_CMDR_TRDIR_READ;
@@ -514,19 +573,62 @@ static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	 * prepared yet.)
 	 */
 	mci_writel(host, IER, iflags);
+}
 
-	return;
+static void atmci_queue_request(struct atmel_mci *host,
+		struct atmel_mci_slot *slot, struct mmc_request *mrq)
+{
+	dev_vdbg(&slot->mmc->class_dev, "queue request: state=%d\n",
+			host->state);
 
-fail:
-	atmci_disable(host);
-	host->mrq = NULL;
-	mrq->cmd->error = -EINVAL;
-	mmc_request_done(mmc, mrq);
+	spin_lock_bh(&host->lock);
+	slot->mrq = mrq;
+	if (host->state == STATE_IDLE) {
+		host->state = STATE_SENDING_CMD;
+		clk_enable(host->mck);
+		atmci_start_request(host, slot);
+	} else {
+		list_add_tail(&slot->queue_node, &host->queue);
+	}
+	spin_unlock_bh(&host->lock);
+}
+
+static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct atmel_mci_slot	*slot = mmc_priv(mmc);
+	struct atmel_mci	*host = slot->host;
+	struct mmc_data		*data;
+
+	WARN_ON(slot->mrq);
+
+	/*
+	 * We may "know" the card is gone even though there's still an
+	 * electrical connection. If so, we really need to communicate
+	 * this to the MMC core since there won't be any more
+	 * interrupts as the card is completely removed. Otherwise,
+	 * the MMC core might believe the card is still there even
+	 * though the card was just removed very slowly.
+	 */
+	if (!test_bit(ATMCI_CARD_PRESENT, &slot->flags)) {
+		mrq->cmd->error = -ENOMEDIUM;
+		mmc_request_done(mmc, mrq);
+		return;
+	}
+
+	/* We don't support multiple blocks of weird lengths. */
+	data = mrq->data;
+	if (data && data->blocks > 1 && data->blksz & 3) {
+		mrq->cmd->error = -EINVAL;
+		mmc_request_done(mmc, mrq);
+	}
+
+	atmci_queue_request(host, slot, mrq);
 }
 
 static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
-	struct atmel_mci	*host = mmc_priv(mmc);
+	struct atmel_mci_slot	*slot = mmc_priv(mmc);
+	struct atmel_mci	*host = slot->host;
 
 	if (ios->clock) {
 		u32 clkdiv;
@@ -540,28 +642,23 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 			clkdiv = 255;
 		}
 
-		host->mode_reg = MCI_MR_CLKDIV(clkdiv) | MCI_MR_WRPROOF
+		slot->mode_reg = MCI_MR_CLKDIV(clkdiv) | MCI_MR_WRPROOF
 					| MCI_MR_RDPROOF;
 	}
 
-	host->sdc_reg &= ~MCI_SDCBUS_MASK;
+	slot->sdc_reg &= ~MCI_SDCBUS_MASK;
 	switch (ios->bus_width) {
 	case MMC_BUS_WIDTH_1:
-		host->sdc_reg |= MCI_SDCBUS_1BIT;
+		slot->sdc_reg |= MCI_SDCBUS_1BIT;
 		break;
 	case MMC_BUS_WIDTH_4:
-		host->sdc_reg |= MCI_SDCBUS_4BIT;
+		slot->sdc_reg |= MCI_SDCBUS_4BIT;
 		break;
 	}
 
 	switch (ios->power_mode) {
-	case MMC_POWER_ON:
-		/* Send init sequence (74 clock cycles) */
-		atmci_enable(host);
-		mci_writel(host, CMDR, MCI_CMDR_SPCMD_INIT);
-		while (!(mci_readl(host, SR) & MCI_CMDRDY))
-			cpu_relax();
-		atmci_disable(host);
+	case MMC_POWER_UP:
+		set_bit(ATMCI_CARD_NEED_INIT, &slot->flags);
 		break;
 	default:
 		/*
@@ -575,28 +672,75 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 static int atmci_get_ro(struct mmc_host *mmc)
 {
-	int			read_only = 0;
-	struct atmel_mci	*host = mmc_priv(mmc);
+	int			read_only = -ENOSYS;
+	struct atmel_mci_slot	*slot = mmc_priv(mmc);
 
-	if (gpio_is_valid(host->wp_pin)) {
-		read_only = gpio_get_value(host->wp_pin);
+	if (gpio_is_valid(slot->wp_pin)) {
+		read_only = gpio_get_value(slot->wp_pin);
 		dev_dbg(&mmc->class_dev, "card is %s\n",
 				read_only ? "read-only" : "read-write");
-	} else {
-		dev_dbg(&mmc->class_dev,
-			"no pin for checking read-only switch."
-			" Assuming write-enable.\n");
 	}
 
 	return read_only;
 }
 
-static struct mmc_host_ops atmci_ops = {
+static int atmci_get_cd(struct mmc_host *mmc)
+{
+	int			present = -ENOSYS;
+	struct atmel_mci_slot	*slot = mmc_priv(mmc);
+
+	if (gpio_is_valid(slot->detect_pin)) {
+		present = !gpio_get_value(slot->detect_pin);
+		dev_dbg(&mmc->class_dev, "card is %spresent\n",
+				present ? "" : "not ");
+	}
+
+	return present;
+}
+
+static const struct mmc_host_ops atmci_ops = {
 	.request	= atmci_request,
 	.set_ios	= atmci_set_ios,
 	.get_ro		= atmci_get_ro,
+	.get_cd		= atmci_get_cd,
 };
 
+/* Called with host->lock held */
+static void atmci_request_end(struct atmel_mci *host, struct mmc_request *mrq)
+	__releases(&host->lock)
+	__acquires(&host->lock)
+{
+	struct atmel_mci_slot	*slot = NULL;
+	struct mmc_host		*prev_mmc = host->cur_slot->mmc;
+
+	WARN_ON(host->cmd || host->data);
+
+	mci_writel(host, CR, MCI_CR_SWRST);
+
+	host->cur_slot->mrq = NULL;
+	host->mrq = NULL;
+	if (!list_empty(&host->queue)) {
+		slot = list_entry(host->queue.next,
+				struct atmel_mci_slot, queue_node);
+		list_del(&slot->queue_node);
+		dev_vdbg(&host->pdev->dev, "list not empty: %s is next\n",
+				mmc_hostname(slot->mmc));
+		host->state = STATE_SENDING_CMD;
+		atmci_start_request(host, slot);
+	} else {
+		dev_vdbg(&host->pdev->dev, "list empty, disabling clock\n");
+		/* Stall until write is complete, then disable the bus clock */
+		mci_readl(host, SR);
+		clk_disable(host->mck);
+
+		host->state = STATE_IDLE;
+	}
+
+	spin_unlock(&host->lock);
+	mmc_request_done(prev_mmc, mrq);
+	spin_lock(&host->lock);
+}
+
 static void atmci_command_complete(struct atmel_mci *host,
 			struct mmc_command *cmd)
 {
@@ -618,7 +762,7 @@ static void atmci_command_complete(struct atmel_mci *host,
 		cmd->error = 0;
 
 	if (cmd->error) {
-		dev_dbg(&host->mmc->class_dev,
+		dev_dbg(&host->pdev->dev,
 			"command error: status=0x%08x\n", status);
 
 		if (cmd->data) {
@@ -632,81 +776,100 @@ static void atmci_command_complete(struct atmel_mci *host,
 
 static void atmci_detect_change(unsigned long data)
 {
-	struct atmel_mci *host = (struct atmel_mci *)data;
-	struct mmc_request *mrq = host->mrq;
-	int present;
+	struct atmel_mci_slot	*slot = (struct atmel_mci_slot *)data;
+	bool			present;
+	bool			present_old;
 
 	/*
-	 * atmci_remove() sets detect_pin to -1 before freeing the
-	 * interrupt. We must not re-enable the interrupt if it has
-	 * been freed.
+	 * atmci_cleanup_slot() sets the ATMCI_SHUTDOWN flag before
+	 * freeing the interrupt. We must not re-enable the interrupt
+	 * if it has been freed, and if we're shutting down, it
+	 * doesn't really matter whether the card is present or not.
 	 */
 	smp_rmb();
-	if (!gpio_is_valid(host->detect_pin))
+	if (test_bit(ATMCI_SHUTDOWN, &slot->flags))
 		return;
 
-	enable_irq(gpio_to_irq(host->detect_pin));
-	present = !gpio_get_value(host->detect_pin);
+	enable_irq(gpio_to_irq(slot->detect_pin));
+	present = !gpio_get_value(slot->detect_pin);
+	present_old = test_bit(ATMCI_CARD_PRESENT, &slot->flags);
 
-	dev_vdbg(&host->pdev->dev, "detect change: %d (was %d)\n",
-			present, host->present);
+	dev_vdbg(&slot->mmc->class_dev, "detect change: %d (was %d)\n",
+			present, present_old);
 
-	if (present != host->present) {
-		dev_dbg(&host->mmc->class_dev, "card %s\n",
+	if (present != present_old) {
+		struct atmel_mci	*host = slot->host;
+		struct mmc_request	*mrq;
+
+		dev_dbg(&slot->mmc->class_dev, "card %s\n",
 			present ? "inserted" : "removed");
-		host->present = present;
 
-		/* Reset controller if card is gone */
-		if (!present) {
-			mci_writel(host, CR, MCI_CR_SWRST);
-			mci_writel(host, IDR, ~0UL);
-			mci_writel(host, CR, MCI_CR_MCIEN);
-		}
+		spin_lock(&host->lock);
+
+		if (!present)
+			clear_bit(ATMCI_CARD_PRESENT, &slot->flags);
+		else
+			set_bit(ATMCI_CARD_PRESENT, &slot->flags);
 
 		/* Clean up queue if present */
+		mrq = slot->mrq;
 		if (mrq) {
-			/*
-			 * Reset controller to terminate any ongoing
-			 * commands or data transfers.
-			 */
-			mci_writel(host, CR, MCI_CR_SWRST);
-			mci_readl(host, SR);
-
-			host->data = NULL;
-			host->cmd = NULL;
-
-			switch (host->state) {
-			case STATE_SENDING_CMD:
-				mrq->cmd->error = -ENOMEDIUM;
-				if (!mrq->data)
+			if (mrq == host->mrq) {
+				/*
+				 * Reset controller to terminate any ongoing
+				 * commands or data transfers.
+				 */
+				mci_writel(host, CR, MCI_CR_SWRST);
+				mci_readl(host, SR);
+				host->data = NULL;
+				host->cmd = NULL;
+
+				switch (host->state) {
+				case STATE_IDLE:
 					break;
-				/* fall through */
-			case STATE_SENDING_DATA:
-				mrq->data->error = -ENOMEDIUM;
-				break;
-			case STATE_DATA_BUSY:
-			case STATE_DATA_ERROR:
-				if (mrq->data->error == -EINPROGRESS)
+				case STATE_SENDING_CMD:
+					mrq->cmd->error = -ENOMEDIUM;
+					if (!mrq->data)
+						break;
+					/* fall through */
+				case STATE_SENDING_DATA:
 					mrq->data->error = -ENOMEDIUM;
-				if (!mrq->stop)
 					break;
-				/* fall through */
-			case STATE_SENDING_STOP:
-				mrq->stop->error = -ENOMEDIUM;
-				break;
-			}
+				case STATE_DATA_BUSY:
+				case STATE_DATA_ERROR:
+					if (mrq->data->error == -EINPROGRESS)
+						mrq->data->error = -ENOMEDIUM;
+					if (!mrq->stop)
+						break;
+					/* fall through */
+				case STATE_SENDING_STOP:
+					mrq->stop->error = -ENOMEDIUM;
+					break;
+				}
 
-			atmci_request_end(host->mmc, mrq);
+				atmci_request_end(host, mrq);
+			} else {
+				list_del(&slot->queue_node);
+				mrq->cmd->error = -ENOMEDIUM;
+				if (mrq->data)
+					mrq->data->error = -ENOMEDIUM;
+				if (mrq->stop)
+					mrq->stop->error = -ENOMEDIUM;
+
+				spin_unlock(&host->lock);
+				mmc_request_done(slot->mmc, mrq);
+				spin_lock(&host->lock);
+			}
 		}
+		spin_unlock(&host->lock);
 
-		mmc_detect_change(host->mmc, 0);
+		mmc_detect_change(slot->mmc, 0);
 	}
 }
 
 static void atmci_tasklet_func(unsigned long priv)
 {
-	struct mmc_host		*mmc = (struct mmc_host *)priv;
-	struct atmel_mci	*host = mmc_priv(mmc);
+	struct atmel_mci	*host = (struct atmel_mci *)priv;
 	struct mmc_request	*mrq = host->mrq;
 	struct mmc_data		*data = host->data;
 	struct mmc_command	*cmd = host->cmd;
@@ -714,9 +877,11 @@ static void atmci_tasklet_func(unsigned long priv)
 	enum atmel_mci_state	prev_state;
 	u32			status;
 
+	spin_lock(&host->lock);
+
 	state = host->state;
 
-	dev_vdbg(&mmc->class_dev,
+	dev_vdbg(&host->pdev->dev,
 		"tasklet: state %u pending/completed/mask %lx/%lx/%x\n",
 		state, host->pending_events, host->completed_events,
 		mci_readl(host, IMR));
@@ -725,6 +890,9 @@ static void atmci_tasklet_func(unsigned long priv)
 		prev_state = state;
 
 		switch (state) {
+		case STATE_IDLE:
+			break;
+
 		case STATE_SENDING_CMD:
 			if (!atmci_test_and_clear_pending(host,
 						EVENT_CMD_COMPLETE))
@@ -734,8 +902,8 @@ static void atmci_tasklet_func(unsigned long priv)
 			atmci_set_completed(host, EVENT_CMD_COMPLETE);
 			atmci_command_complete(host, mrq->cmd);
 			if (!mrq->data || cmd->error) {
-				atmci_request_end(mmc, host->mrq);
-				break;
+				atmci_request_end(host, host->mrq);
+				goto unlock;
 			}
 
 			prev_state = state = STATE_SENDING_DATA;
@@ -745,7 +913,7 @@ static void atmci_tasklet_func(unsigned long priv)
 			if (atmci_test_and_clear_pending(host,
 						EVENT_DATA_ERROR)) {
 				if (data->stop)
-					send_stop_cmd(host->mmc, data);
+					send_stop_cmd(host, data);
 				state = STATE_DATA_ERROR;
 				break;
 			}
@@ -768,15 +936,15 @@ static void atmci_tasklet_func(unsigned long priv)
 			status = host->data_status;
 			if (unlikely(status & ATMCI_DATA_ERROR_FLAGS)) {
 				if (status & MCI_DTOE) {
-					dev_dbg(&mmc->class_dev,
+					dev_dbg(&host->pdev->dev,
 							"data timeout error\n");
 					data->error = -ETIMEDOUT;
 				} else if (status & MCI_DCRCE) {
-					dev_dbg(&mmc->class_dev,
+					dev_dbg(&host->pdev->dev,
 							"data CRC error\n");
 					data->error = -EILSEQ;
 				} else {
-					dev_dbg(&mmc->class_dev,
+					dev_dbg(&host->pdev->dev,
 						"data FIFO error (status=%08x)\n",
 						status);
 					data->error = -EIO;
@@ -787,14 +955,13 @@ static void atmci_tasklet_func(unsigned long priv)
 			}
 
 			if (!data->stop) {
-				atmci_request_end(mmc, host->mrq);
-				prev_state = state;
-				break;
+				atmci_request_end(host, host->mrq);
+				goto unlock;
 			}
 
 			prev_state = state = STATE_SENDING_STOP;
 			if (!data->error)
-				send_stop_cmd(host->mmc, data);
+				send_stop_cmd(host, data);
 			/* fall through */
 
 		case STATE_SENDING_STOP:
@@ -804,9 +971,8 @@ static void atmci_tasklet_func(unsigned long priv)
 
 			host->cmd = NULL;
 			atmci_command_complete(host, mrq->stop);
-			atmci_request_end(mmc, host->mrq);
-			prev_state = state;
-			break;
+			atmci_request_end(host, host->mrq);
+			goto unlock;
 
 		case STATE_DATA_ERROR:
 			if (!atmci_test_and_clear_pending(host,
@@ -819,6 +985,9 @@ static void atmci_tasklet_func(unsigned long priv)
 	} while (state != prev_state);
 
 	host->state = state;
+
+unlock:
+	spin_unlock(&host->lock);
 }
 
 static void atmci_read_data_pio(struct atmel_mci *host)
@@ -868,9 +1037,11 @@ static void atmci_read_data_pio(struct atmel_mci *host)
 			mci_writel(host, IDR, (MCI_NOTBUSY | MCI_RXRDY
 						| ATMCI_DATA_ERROR_FLAGS));
 			host->data_status = status;
+			data->bytes_xfered += nbytes;
+			smp_wmb();
 			atmci_set_pending(host, EVENT_DATA_ERROR);
 			tasklet_schedule(&host->tasklet);
-			break;
+			return;
 		}
 	} while (status & MCI_RXRDY);
 
@@ -883,6 +1054,7 @@ done:
 	mci_writel(host, IDR, MCI_RXRDY);
 	mci_writel(host, IER, MCI_NOTBUSY);
 	data->bytes_xfered += nbytes;
+	smp_wmb();
 	atmci_set_pending(host, EVENT_XFER_COMPLETE);
 }
 
@@ -936,9 +1108,11 @@ static void atmci_write_data_pio(struct atmel_mci *host)
 			mci_writel(host, IDR, (MCI_NOTBUSY | MCI_TXRDY
 						| ATMCI_DATA_ERROR_FLAGS));
 			host->data_status = status;
+			data->bytes_xfered += nbytes;
+			smp_wmb();
 			atmci_set_pending(host, EVENT_DATA_ERROR);
 			tasklet_schedule(&host->tasklet);
-			break;
+			return;
 		}
 	} while (status & MCI_TXRDY);
 
@@ -951,29 +1125,26 @@ done:
 	mci_writel(host, IDR, MCI_TXRDY);
 	mci_writel(host, IER, MCI_NOTBUSY);
 	data->bytes_xfered += nbytes;
+	smp_wmb();
 	atmci_set_pending(host, EVENT_XFER_COMPLETE);
 }
 
-static void atmci_cmd_interrupt(struct mmc_host *mmc, u32 status)
+static void atmci_cmd_interrupt(struct atmel_mci *host, u32 status)
 {
-	struct atmel_mci	*host = mmc_priv(mmc);
-
 	mci_writel(host, IDR, MCI_CMDRDY);
 
 	host->cmd_status = status;
+	smp_wmb();
 	atmci_set_pending(host, EVENT_CMD_COMPLETE);
 	tasklet_schedule(&host->tasklet);
 }
 
 static irqreturn_t atmci_interrupt(int irq, void *dev_id)
 {
-	struct mmc_host		*mmc = dev_id;
-	struct atmel_mci	*host = mmc_priv(mmc);
+	struct atmel_mci	*host = dev_id;
 	u32			status, mask, pending;
 	unsigned int		pass_count = 0;
 
-	spin_lock(&mmc->lock);
-
 	do {
 		status = mci_readl(host, SR);
 		mask = mci_readl(host, IMR);
@@ -985,7 +1156,9 @@ static irqreturn_t atmci_interrupt(int irq, void *dev_id)
 			mci_writel(host, IDR, ATMCI_DATA_ERROR_FLAGS
 					| MCI_RXRDY | MCI_TXRDY);
 			pending &= mci_readl(host, IMR);
+
 			host->data_status = status;
+			smp_wmb();
 			atmci_set_pending(host, EVENT_DATA_ERROR);
 			tasklet_schedule(&host->tasklet);
 		}
@@ -993,6 +1166,7 @@ static irqreturn_t atmci_interrupt(int irq, void *dev_id)
 			mci_writel(host, IDR,
 					ATMCI_DATA_ERROR_FLAGS | MCI_NOTBUSY);
 			host->data_status = status;
+			smp_wmb();
 			atmci_set_pending(host, EVENT_DATA_COMPLETE);
 			tasklet_schedule(&host->tasklet);
 		}
@@ -1002,18 +1176,15 @@ static irqreturn_t atmci_interrupt(int irq, void *dev_id)
 			atmci_write_data_pio(host);
 
 		if (pending & MCI_CMDRDY)
-			atmci_cmd_interrupt(mmc, status);
+			atmci_cmd_interrupt(host, status);
 	} while (pass_count++ < 5);
 
-	spin_unlock(&mmc->lock);
-
 	return pass_count ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static irqreturn_t atmci_detect_interrupt(int irq, void *dev_id)
 {
-	struct mmc_host		*mmc = dev_id;
-	struct atmel_mci	*host = mmc_priv(mmc);
+	struct atmel_mci_slot	*slot = dev_id;
 
 	/*
 	 * Disable interrupts until the pin has stabilized and check
@@ -1021,21 +1192,120 @@ static irqreturn_t atmci_detect_interrupt(int irq, void *dev_id)
 	 * middle of the timer routine when this interrupt triggers.
 	 */
 	disable_irq_nosync(irq);
-	mod_timer(&host->detect_timer, jiffies + msecs_to_jiffies(20));
+	mod_timer(&slot->detect_timer, jiffies + msecs_to_jiffies(20));
 
 	return IRQ_HANDLED;
 }
 
+static int __init atmci_init_slot(struct atmel_mci *host,
+		struct mci_slot_pdata *slot_data, u32 sdc_reg)
+{
+	struct mmc_host			*mmc;
+	struct atmel_mci_slot		*slot;
+
+	mmc = mmc_alloc_host(sizeof(struct atmel_mci_slot), &host->pdev->dev);
+	if (!mmc)
+		return -ENOMEM;
+
+	slot = mmc_priv(mmc);
+	slot->mmc = mmc;
+	slot->host = host;
+	slot->detect_pin = slot_data->detect_pin;
+	slot->wp_pin = slot_data->wp_pin;
+	slot->sdc_reg = sdc_reg;
+
+	mmc->ops = &atmci_ops;
+	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
+	mmc->f_max = host->bus_hz / 2;
+	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+	if (slot_data->bus_width >= 4)
+		mmc->caps |= MMC_CAP_4_BIT_DATA;
+
+	mmc->max_hw_segs = 64;
+	mmc->max_phys_segs = 64;
+	mmc->max_req_size = 32768 * 512;
+	mmc->max_blk_size = 32768;
+	mmc->max_blk_count = 512;
+
+	/* Assume card is present initially */
+	set_bit(ATMCI_CARD_PRESENT, &slot->flags);
+	if (gpio_is_valid(slot->detect_pin)) {
+		if (gpio_request(slot->detect_pin, "mmc_detect")) {
+			dev_dbg(&mmc->class_dev, "no detect pin available\n");
+			slot->detect_pin = -EBUSY;
+		} else if (gpio_get_value(slot->detect_pin)) {
+			clear_bit(ATMCI_CARD_PRESENT, &slot->flags);
+		}
+	}
+
+	if (!gpio_is_valid(slot->detect_pin))
+		mmc->caps |= MMC_CAP_NEEDS_POLL;
+
+	if (gpio_is_valid(slot->wp_pin)) {
+		if (gpio_request(slot->wp_pin, "mmc_wp")) {
+			dev_dbg(&mmc->class_dev, "no WP pin available\n");
+			slot->wp_pin = -EBUSY;
+		}
+	}
+
+	mmc_add_host(mmc);
+
+	if (gpio_is_valid(slot->detect_pin)) {
+		int ret;
+
+		setup_timer(&slot->detect_timer, atmci_detect_change,
+				(unsigned long)slot);
+
+		ret = request_irq(gpio_to_irq(slot->detect_pin),
+				atmci_detect_interrupt,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				"mmc-detect", slot);
+		if (ret) {
+			dev_dbg(&mmc->class_dev,
+				"could not request IRQ %d for detect pin\n",
+				gpio_to_irq(slot->detect_pin));
+			gpio_free(slot->detect_pin);
+			slot->detect_pin = -EBUSY;
+		}
+	}
+
+	list_add_tail(&slot->slot_node, &host->slots);
+
+	atmci_init_debugfs(slot);
+
+	return 0;
+}
+
+static void __exit atmci_cleanup_slot(struct atmel_mci_slot *slot)
+{
+	/* Debugfs stuff is cleaned up by mmc core */
+
+	set_bit(ATMCI_SHUTDOWN, &slot->flags);
+	smp_wmb();
+
+	mmc_remove_host(slot->mmc);
+
+	if (gpio_is_valid(slot->detect_pin)) {
+		int pin = slot->detect_pin;
+
+		free_irq(gpio_to_irq(pin), slot);
+		del_timer_sync(&slot->detect_timer);
+		gpio_free(pin);
+	}
+	if (gpio_is_valid(slot->wp_pin))
+		gpio_free(slot->wp_pin);
+
+	list_del(&slot->slot_node);
+	mmc_free_host(slot->mmc);
+}
+
 static int __init atmci_probe(struct platform_device *pdev)
 {
 	struct mci_platform_data	*pdata;
-	struct mci_slot_pdata		*slot;
-	struct atmel_mci *host;
-	struct mmc_host *mmc;
-	struct resource *regs;
-	u32 sdc_reg;
-	int irq;
-	int ret;
+	struct atmel_mci		*host;
+	struct resource			*regs;
+	int				irq;
+	int				ret;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs)
@@ -1047,27 +1317,14 @@ static int __init atmci_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	/* TODO: Allow using several slots at once */
-	if (pdata->slot[0].bus_width) {
-		sdc_reg = MCI_SDCSEL_SLOT_A;
-		slot = &pdata->slot[0];
-	} else if (pdata->slot[1].bus_width) {
-		sdc_reg = MCI_SDCSEL_SLOT_B;
-		slot = &pdata->slot[1];
-	} else {
-		return -EINVAL;
-	}
-
-	mmc = mmc_alloc_host(sizeof(struct atmel_mci), &pdev->dev);
-	if (!mmc)
+	host = kzalloc(sizeof(struct atmel_mci), GFP_KERNEL);
+	if (!host)
 		return -ENOMEM;
 
-	host = mmc_priv(mmc);
 	host->pdev = pdev;
-	host->mmc = mmc;
-	host->detect_pin = slot->detect_pin;
-	host->wp_pin = slot->wp_pin;
-	host->sdc_reg = sdc_reg;
+	spin_lock_init(&host->lock);
+	INIT_LIST_HEAD(&host->queue);
+	INIT_LIST_HEAD(&host->slots);
 
 	host->mck = clk_get(&pdev->dev, "mci_clk");
 	if (IS_ERR(host->mck)) {
@@ -1087,123 +1344,65 @@ static int __init atmci_probe(struct platform_device *pdev)
 
 	host->mapbase = regs->start;
 
-	mmc->ops = &atmci_ops;
-	mmc->f_min = (host->bus_hz + 511) / 512;
-	mmc->f_max = host->bus_hz / 2;
-	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
-	if (slot->bus_width >= 4)
-		mmc->caps |= MMC_CAP_4_BIT_DATA;
-
-	mmc->max_hw_segs = 64;
-	mmc->max_phys_segs = 64;
-	mmc->max_req_size = 32768 * 512;
-	mmc->max_blk_size = 32768;
-	mmc->max_blk_count = 512;
+	tasklet_init(&host->tasklet, atmci_tasklet_func, (unsigned long)host);
 
-	tasklet_init(&host->tasklet, atmci_tasklet_func, (unsigned long)mmc);
-
-	ret = request_irq(irq, atmci_interrupt, 0, pdev->dev.bus_id, mmc);
+	ret = request_irq(irq, atmci_interrupt, 0, pdev->dev.bus_id, host);
 	if (ret)
 		goto err_request_irq;
 
-	/* Assume card is present if we don't have a detect pin */
-	host->present = 1;
-	if (gpio_is_valid(host->detect_pin)) {
-		if (gpio_request(host->detect_pin, "mmc_detect")) {
-			dev_dbg(&mmc->class_dev, "no detect pin available\n");
-			host->detect_pin = -1;
-		} else {
-			host->present = !gpio_get_value(host->detect_pin);
-		}
-	}
-
-	if (!gpio_is_valid(host->detect_pin))
-		mmc->caps |= MMC_CAP_NEEDS_POLL;
-
-	if (gpio_is_valid(host->wp_pin)) {
-		if (gpio_request(host->wp_pin, "mmc_wp")) {
-			dev_dbg(&mmc->class_dev, "no WP pin available\n");
-			host->wp_pin = -1;
-		}
-	}
-
 	platform_set_drvdata(pdev, host);
 
-	mmc_add_host(mmc);
-
-	if (gpio_is_valid(host->detect_pin)) {
-		setup_timer(&host->detect_timer, atmci_detect_change,
-				(unsigned long)host);
-
-		ret = request_irq(gpio_to_irq(host->detect_pin),
-				atmci_detect_interrupt,
-				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
-				"mmc-detect", mmc);
-		if (ret) {
-			dev_dbg(&mmc->class_dev,
-				"could not request IRQ %d for detect pin\n",
-				gpio_to_irq(host->detect_pin));
-			gpio_free(host->detect_pin);
-			host->detect_pin = -1;
-		}
+	/* We need at least one slot to succeed */
+	ret = -1;
+	if (pdata->slot[0].bus_width)
+		ret &= atmci_init_slot(host, &pdata->slot[0],
+				MCI_SDCSEL_SLOT_A);
+	if (pdata->slot[1].bus_width)
+		ret &= atmci_init_slot(host, &pdata->slot[1],
+				MCI_SDCSEL_SLOT_B);
+	if (ret) {
+		ret = -ENODEV;
+		goto err_init_slot;
 	}
 
-	dev_info(&mmc->class_dev,
-			"Atmel MCI controller at 0x%08lx irq %d\n",
+	dev_info(&pdev->dev, "Atmel MCI controller at 0x%08lx irq %d\n",
 			host->mapbase, irq);
 
-	atmci_init_debugfs(host);
-
 	return 0;
 
+err_init_slot:
+	free_irq(irq, host);
 err_request_irq:
 	iounmap(host->regs);
 err_ioremap:
 	clk_put(host->mck);
 err_clk_get:
-	mmc_free_host(mmc);
+	kfree(host);
 	return ret;
 }
 
 static int __exit atmci_remove(struct platform_device *pdev)
 {
-	struct atmel_mci *host = platform_get_drvdata(pdev);
+	struct atmel_mci	*host = platform_get_drvdata(pdev);
+	struct atmel_mci_slot	*slot, *_slot;
 
 	platform_set_drvdata(pdev, NULL);
 
-	if (host) {
-		/* Debugfs stuff is cleaned up by mmc core */
-
-		if (gpio_is_valid(host->detect_pin)) {
-			int pin = host->detect_pin;
-
-			/* Make sure the timer doesn't enable the interrupt */
-			host->detect_pin = -1;
-			smp_wmb();
-
-			free_irq(gpio_to_irq(pin), host->mmc);
-			del_timer_sync(&host->detect_timer);
-			gpio_free(pin);
-		}
-
-		mmc_remove_host(host->mmc);
-
-		clk_enable(host->mck);
-		mci_writel(host, IDR, ~0UL);
-		mci_writel(host, CR, MCI_CR_MCIDIS);
-		mci_readl(host, SR);
-		clk_disable(host->mck);
+	list_for_each_entry_safe(slot, _slot, &host->slots, slot_node)
+		atmci_cleanup_slot(slot);
 
-		if (gpio_is_valid(host->wp_pin))
-			gpio_free(host->wp_pin);
+	clk_enable(host->mck);
+	mci_writel(host, IDR, ~0UL);
+	mci_writel(host, CR, MCI_CR_MCIDIS);
+	mci_readl(host, SR);
+	clk_disable(host->mck);
 
-		free_irq(platform_get_irq(pdev, 0), host->mmc);
-		iounmap(host->regs);
+	free_irq(platform_get_irq(pdev, 0), host);
+	iounmap(host->regs);
 
-		clk_put(host->mck);
+	clk_put(host->mck);
+	kfree(host);
 
-		mmc_free_host(host->mmc);
-	}
 	return 0;
 }
 
-- 
1.5.6.5

