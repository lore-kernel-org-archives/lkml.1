Return-Path: <linux-kernel-owner+w=401wt.eu-S1763053AbYCZUR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763053AbYCZUR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759440AbYCZUM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:12:59 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46767 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321AbYCZUM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:12:58 -0400
Message-ID: <47EAAD8C.3090101@indt.org.br>
Date: Wed, 26 Mar 2008 16:09:48 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] MMC: OMAP: Move failing command abortion to workqueue
References: <47DAD39C.90405@indt.org.br> <20080324132631.1e0d2125@mjolnir.drzeus.cx>
In-Reply-To: <20080324132631.1e0d2125@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 20:12:31.0218 (UTC) FILETIME=[B8AE6520:01C88F7D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

Abort failed command from workqueue rather than from an interrupt,
allowing longer delays in abortion.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 drivers/mmc/host/omap.c |   82 ++++++++++++++++++++++++++++-------------------
 1 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index f97f390..aaecf4d 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -134,8 +134,9 @@ struct mmc_omap_host {
 	unsigned char		bus_mode;
 	unsigned char		hw_bus_mode;
 
-	struct work_struct	cmd_abort;
-	struct timer_list	cmd_timer;
+	struct work_struct	cmd_abort_work;
+	unsigned		abort:1;
+	struct timer_list	cmd_abort_timer;
 
 	unsigned int		sg_len;
 	int			sg_idx;
@@ -320,7 +321,7 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd)
 	if (host->data && !(host->data->flags & MMC_DATA_WRITE))
 		cmdreg |= 1 << 15;
 
-	mod_timer(&host->cmd_timer, jiffies + HZ/2);
+	mod_timer(&host->cmd_abort_timer, jiffies + HZ/2);
 
 	OMAP_MMC_WRITE(host, CTO, 200);
 	OMAP_MMC_WRITE(host, ARGL, cmd->arg & 0xffff);
@@ -381,7 +382,7 @@ mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 }
 
 static void
-mmc_omap_send_abort(struct mmc_omap_host *host)
+mmc_omap_send_abort(struct mmc_omap_host *host, int maxloops)
 {
 	struct mmc_omap_slot *slot = host->current_slot;
 	unsigned int restarts, passes, timeout;
@@ -390,7 +391,7 @@ mmc_omap_send_abort(struct mmc_omap_host *host)
 	/* Sending abort takes 80 clocks. Have some extra and round up */
 	timeout = (120*1000000 + slot->fclk_freq - 1)/slot->fclk_freq;
 	restarts = 0;
-	while (restarts < 10000) {
+	while (restarts < maxloops) {
 		OMAP_MMC_WRITE(host, STAT, 0xFFFF);
 		OMAP_MMC_WRITE(host, CMD, (3 << 12) | (1 << 7));
 
@@ -412,18 +413,13 @@ out:
 static void
 mmc_omap_abort_xfer(struct mmc_omap_host *host, struct mmc_data *data)
 {
-	u16 ie;
-
 	if (host->dma_in_use)
 		mmc_omap_release_dma(host, data, 1);
 
 	host->data = NULL;
 	host->sg_len = 0;
 
-	ie = OMAP_MMC_READ(host, IE);
-	OMAP_MMC_WRITE(host, IE, 0);
-	OMAP_MMC_WRITE(host, IE, ie);
-	mmc_omap_send_abort(host);
+	mmc_omap_send_abort(host, 10000);
 }
 
 static void
@@ -479,7 +475,7 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 {
 	host->cmd = NULL;
 
-	del_timer(&host->cmd_timer);
+	del_timer(&host->cmd_abort_timer);
 
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		if (cmd->flags & MMC_RSP_136) {
@@ -523,38 +519,48 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 static void mmc_omap_abort_command(struct work_struct *work)
 {
 	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
-						  cmd_abort);
-	u16 ie;
-
-	ie = OMAP_MMC_READ(host, IE);
-	OMAP_MMC_WRITE(host, IE, 0);
-
-	if (!host->cmd) {
-		OMAP_MMC_WRITE(host, IE, ie);
-		return;
-	}
+						  cmd_abort_work);
+	BUG_ON(!host->cmd);
 
 	dev_dbg(mmc_dev(host->mmc), "Aborting stuck command CMD%d\n",
 		host->cmd->opcode);
 
-	if (host->data && host->dma_in_use)
-		mmc_omap_release_dma(host, host->data, 1);
+	if (host->cmd->error == 0)
+		host->cmd->error = -ETIMEDOUT;
 
-	host->data = NULL;
-	host->sg_len = 0;
+	if (host->data == NULL) {
+		struct mmc_command *cmd;
+		struct mmc_host    *mmc;
+
+		cmd = host->cmd;
+		host->cmd = NULL;
+		mmc_omap_send_abort(host, 10000);
+
+		host->mrq = NULL;
+		mmc = host->mmc;
+		mmc_omap_release_slot(host->current_slot);
+		mmc_request_done(mmc, cmd->mrq);
+	} else
+		mmc_omap_cmd_done(host, host->cmd);
 
-	mmc_omap_send_abort(host);
-	host->cmd->error = -ETIMEDOUT;
-	mmc_omap_cmd_done(host, host->cmd);
-	OMAP_MMC_WRITE(host, IE, ie);
+	host->abort = 0;
+	enable_irq(host->irq);
 }
 
 static void
 mmc_omap_cmd_timer(unsigned long data)
 {
 	struct mmc_omap_host *host = (struct mmc_omap_host *) data;
+	unsigned long flags;
 
-	schedule_work(&host->cmd_abort);
+	spin_lock_irqsave(&host->slot_lock, flags);
+	if (host->cmd != NULL && !host->abort) {
+		OMAP_MMC_WRITE(host, IE, 0);
+		disable_irq(host->irq);
+		host->abort = 1;
+		schedule_work(&host->cmd_abort_work);
+	}
+	spin_unlock_irqrestore(&host->slot_lock, flags);
 }
 
 /* PIO only */
@@ -728,6 +734,15 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 		}
 	}
 
+	if (cmd_error && host->data) {
+		del_timer(&host->cmd_abort_timer);
+		host->abort = 1;
+		OMAP_MMC_WRITE(host, IE, 0);
+		disable_irq(host->irq);
+		schedule_work(&host->cmd_abort_work);
+		return IRQ_HANDLED;
+	}
+
 	if (end_command)
 		mmc_omap_cmd_done(host, host->cmd);
 	if (host->data != NULL) {
@@ -1316,8 +1331,9 @@ static int __init mmc_omap_probe(struct platform_device *pdev)
 		goto err_free_mem_region;
 	}
 
-	INIT_WORK(&host->cmd_abort, mmc_omap_abort_command);
-	setup_timer(&host->cmd_timer, mmc_omap_cmd_timer, (unsigned long) host);
+	INIT_WORK(&host->cmd_abort_work, mmc_omap_abort_command);
+	setup_timer(&host->cmd_abort_timer, mmc_omap_cmd_timer,
+		    (unsigned long) host);
 
 	spin_lock_init(&host->dma_lock);
 	setup_timer(&host->dma_timer, mmc_omap_dma_timer, (unsigned long) host);
-- 1.5.3.GIT

