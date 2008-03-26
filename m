Return-Path: <linux-kernel-owner+w=401wt.eu-S1763258AbYCZURp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763258AbYCZURp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759543AbYCZUNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:13:01 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46769 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759404AbYCZUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:12:59 -0400
Message-ID: <47EAAD90.1080707@indt.org.br>
Date: Wed, 26 Mar 2008 16:09:52 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/18] MMC: OMAP: Lazy clock shutdown
References: <47DAD39C.90405@indt.org.br> <20080324132631.1e0d2125@mjolnir.drzeus.cx>
In-Reply-To: <20080324132631.1e0d2125@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 20:12:35.0483 (UTC) FILETIME=[BB392EB0:01C88F7D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

MMCA spec says the mmc clock should be kept running for at least
8 cycles after the last RW request. Ensure this with lazy clock
disable after a request, or with an explicit delay before
switching a slot.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 drivers/mmc/host/omap.c |   89 +++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 75 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index aaecf4d..19001d3 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -161,9 +161,38 @@ struct mmc_omap_host {
 	wait_queue_head_t       slot_wq;
 	int                     nr_slots;
 
+	struct timer_list       clk_timer;
+	spinlock_t		clk_lock;     /* for changing enabled state */
+	unsigned int            fclk_enabled:1;
+
 	struct omap_mmc_platform_data *pdata;
 };
 
+void mmc_omap_fclk_offdelay(struct mmc_omap_slot *slot)
+{
+	unsigned long tick_ns;
+
+	if (slot != NULL && slot->host->fclk_enabled && slot->fclk_freq > 0) {
+		tick_ns = (1000000000 + slot->fclk_freq - 1) / slot->fclk_freq;
+		ndelay(8 * tick_ns);
+	}
+}
+
+void mmc_omap_fclk_enable(struct mmc_omap_host *host, unsigned int enable)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->clk_lock, flags);
+	if (host->fclk_enabled != enable) {
+		host->fclk_enabled = enable;
+		if (enable)
+			clk_enable(host->fclk);
+		else
+			clk_disable(host->fclk);
+	}
+	spin_unlock_irqrestore(&host->clk_lock, flags);
+}
+
 static void mmc_omap_select_slot(struct mmc_omap_slot *slot, int claimed)
 {
 	struct mmc_omap_host *host = slot->host;
@@ -180,32 +209,49 @@ static void mmc_omap_select_slot(struct mmc_omap_slot *slot, int claimed)
 	host->mmc = slot->mmc;
 	spin_unlock_irqrestore(&host->slot_lock, flags);
 no_claim:
-	clk_enable(host->fclk);
+	del_timer(&host->clk_timer);
+	if (host->current_slot != slot || !claimed)
+		mmc_omap_fclk_offdelay(host->current_slot);
+
 	if (host->current_slot != slot) {
+		OMAP_MMC_WRITE(host, CON, slot->saved_con & 0xFC00);
 		if (host->pdata->switch_slot != NULL)
 			host->pdata->switch_slot(mmc_dev(slot->mmc), slot->id);
 		host->current_slot = slot;
 	}
 
-	/* Doing the dummy read here seems to work around some bug
-	 * at least in OMAP24xx silicon where the command would not
-	 * start after writing the CMD register. Sigh. */
-	OMAP_MMC_READ(host, CON);
+	if (claimed) {
+		mmc_omap_fclk_enable(host, 1);
+
+		/* Doing the dummy read here seems to work around some bug
+		 * at least in OMAP24xx silicon where the command would not
+		 * start after writing the CMD register. Sigh. */
+		OMAP_MMC_READ(host, CON);
 
-	OMAP_MMC_WRITE(host, CON, slot->saved_con);
+		OMAP_MMC_WRITE(host, CON, slot->saved_con);
+	} else
+		mmc_omap_fclk_enable(host, 0);
 }
 
 static void mmc_omap_start_request(struct mmc_omap_host *host,
 				   struct mmc_request *req);
 
-static void mmc_omap_release_slot(struct mmc_omap_slot *slot)
+static void mmc_omap_release_slot(struct mmc_omap_slot *slot, int clk_enabled)
 {
 	struct mmc_omap_host *host = slot->host;
 	unsigned long flags;
 	int i;
 
 	BUG_ON(slot == NULL || host->mmc == NULL);
-	clk_disable(host->fclk);
+
+	if (clk_enabled)
+		/* Keeps clock running for at least 8 cycles on valid freq */
+		mod_timer(&host->clk_timer, jiffies  + HZ/10);
+	else {
+		del_timer(&host->clk_timer);
+		mmc_omap_fclk_offdelay(slot);
+		mmc_omap_fclk_enable(host, 0);
+	}
 
 	spin_lock_irqsave(&host->slot_lock, flags);
 	/* Check for any pending requests */
@@ -373,7 +419,7 @@ mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 
 		host->mrq = NULL;
 		mmc = host->mmc;
-		mmc_omap_release_slot(host->current_slot);
+		mmc_omap_release_slot(host->current_slot, 1);
 		mmc_request_done(mmc, data->mrq);
 		return;
 	}
@@ -507,7 +553,7 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 			mmc_omap_abort_xfer(host, host->data);
 		host->mrq = NULL;
 		mmc = host->mmc;
-		mmc_omap_release_slot(host->current_slot);
+		mmc_omap_release_slot(host->current_slot, 1);
 		mmc_request_done(mmc, cmd->mrq);
 	}
 }
@@ -538,7 +584,7 @@ static void mmc_omap_abort_command(struct work_struct *work)
 
 		host->mrq = NULL;
 		mmc = host->mmc;
-		mmc_omap_release_slot(host->current_slot);
+		mmc_omap_release_slot(host->current_slot, 1);
 		mmc_request_done(mmc, cmd->mrq);
 	} else
 		mmc_omap_cmd_done(host, host->cmd);
@@ -576,6 +622,14 @@ mmc_omap_sg_to_buf(struct mmc_omap_host *host)
 		host->buffer_bytes_left = host->total_bytes_left;
 }
 
+static void
+mmc_omap_clk_timer(unsigned long data)
+{
+	struct mmc_omap_host *host = (struct mmc_omap_host *) data;
+
+	mmc_omap_fclk_enable(host, 0);
+}
+
 /* PIO only */
 static void
 mmc_omap_xfer_data(struct mmc_omap_host *host, int write)
@@ -1149,14 +1203,16 @@ static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	struct mmc_omap_slot *slot = mmc_priv(mmc);
 	struct mmc_omap_host *host = slot->host;
 	int i, dsor;
-
-	dsor = mmc_omap_calc_divisor(mmc, ios);
+	int clk_enabled;
 
 	mmc_omap_select_slot(slot, 0);
 
+	dsor = mmc_omap_calc_divisor(mmc, ios);
+
 	if (ios->vdd != slot->vdd)
 		slot->vdd = ios->vdd;
 
+	clk_enabled = 0;
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
 		mmc_omap_set_power(slot, 0, ios->vdd);
@@ -1166,6 +1222,8 @@ static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		mmc_omap_set_power(slot, 1, ios->vdd);
 		goto exit;
 	case MMC_POWER_ON:
+		mmc_omap_fclk_enable(host, 1);
+		clk_enabled = 1;
 		dsor |= 1 << 11;
 		break;
 	}
@@ -1194,7 +1252,7 @@ static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	}
 
 exit:
-	mmc_omap_release_slot(slot);
+	mmc_omap_release_slot(slot, clk_enabled);
 }
 
 static const struct mmc_host_ops mmc_omap_ops = {
@@ -1335,6 +1393,9 @@ static int __init mmc_omap_probe(struct platform_device *pdev)
 	setup_timer(&host->cmd_abort_timer, mmc_omap_cmd_timer,
 		    (unsigned long) host);
 
+	spin_lock_init(&host->clk_lock);
+	setup_timer(&host->clk_timer, mmc_omap_clk_timer, (unsigned long) host);
+
 	spin_lock_init(&host->dma_lock);
 	setup_timer(&host->dma_timer, mmc_omap_dma_timer, (unsigned long) host);
 	spin_lock_init(&host->slot_lock);
-- 1.5.3.GIT

