Return-Path: <linux-kernel-owner+w=401wt.eu-S1763377AbYA1TO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763377AbYA1TO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761487AbYA1TKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:10:18 -0500
Received: from smtp.nokia.com ([192.100.122.230]:62363 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbYA1TKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:10:16 -0500
Message-ID: <479E281D.1030706@indt.org.br>
Date: Mon, 28 Jan 2008 15:08:13 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/18] MMC: OMAP: Start new commands from work queue instead
 of irq
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:09:58.0602 (UTC) FILETIME=[5FFD22A0:01C861E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

Use work queues for starting new commands instead of starting them
directly from irq handler. The command scheduling needs to be delayed
a bit for some cards which should not be done from an interrupt.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 drivers/mmc/host/omap.c |   48 +++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 1d8bb69..5349f9f 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -139,6 +139,11 @@ struct mmc_omap_host {
 	unsigned		abort:1;
 	struct timer_list	cmd_abort_timer;
 
+	struct work_struct      slot_release_work;
+	struct mmc_omap_slot    *next_slot;
+	struct work_struct      send_stop_work;
+	struct mmc_data		*stop_data;
+
 	unsigned int		sg_len;
 	int			sg_idx;
 	u16 *			buffer;
@@ -237,6 +242,21 @@ no_claim:
 static void mmc_omap_start_request(struct mmc_omap_host *host,
 				   struct mmc_request *req);
 
+static void mmc_omap_slot_release_work(struct work_struct *work)
+{
+	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
+						  slot_release_work);
+	struct mmc_omap_slot *next_slot = host->next_slot;
+	struct mmc_request *rq;
+
+	host->next_slot = NULL;
+	mmc_omap_select_slot(next_slot, 1);
+
+	rq = next_slot->mrq;
+	next_slot->mrq = NULL;
+	mmc_omap_start_request(host, rq);
+}
+
 static void mmc_omap_release_slot(struct mmc_omap_slot *slot, int clk_enabled)
 {
 	struct mmc_omap_host *host = slot->host;
@@ -258,21 +278,19 @@ static void mmc_omap_release_slot(struct mmc_omap_slot *slot, int clk_enabled)
 	/* Check for any pending requests */
 	for (i = 0; i < host->nr_slots; i++) {
 		struct mmc_omap_slot *new_slot;
-		struct mmc_request *rq;
 
 		if (host->slots[i] == NULL || host->slots[i]->mrq == NULL)
 			continue;
 
+		BUG_ON(host->next_slot != NULL);
 		new_slot = host->slots[i];
 		/* The current slot should not have a request in queue */
 		BUG_ON(new_slot == host->current_slot);
 
+		host->next_slot = new_slot;
 		host->mmc = new_slot->mmc;
 		spin_unlock_irqrestore(&host->slot_lock, flags);
-		mmc_omap_select_slot(new_slot, 1);
-		rq = new_slot->mrq;
-		new_slot->mrq = NULL;
-		mmc_omap_start_request(host, rq);
+		schedule_work(&host->slot_release_work);
 		return;
 	}
 
@@ -415,6 +433,20 @@ mmc_omap_release_dma(struct mmc_omap_host *host, struct mmc_data *data,
 		     dma_data_dir);
 }
 
+static void mmc_omap_send_stop_work(struct work_struct *work)
+{
+	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
+						  send_stop_work);
+	struct mmc_omap_slot *slot = host->current_slot;
+	struct mmc_data *data = host->stop_data;
+	unsigned long tick_ns;
+
+	tick_ns = (1000000000 + slot->fclk_freq - 1)/slot->fclk_freq;
+	ndelay(8*tick_ns);
+
+	mmc_omap_start_command(host, data->stop);
+}
+
 static void
 mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 {
@@ -439,7 +471,8 @@ mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 		return;
 	}
 
-	mmc_omap_start_command(host, data->stop);
+	host->stop_data = data;
+	schedule_work(&host->send_stop_work);
 }
 
 static void
@@ -1429,6 +1462,9 @@ static int __init mmc_omap_probe(struct platform_device *pdev)
 		goto err_free_mem_region;
 	}
 
+	INIT_WORK(&host->slot_release_work, mmc_omap_slot_release_work);
+	INIT_WORK(&host->send_stop_work, mmc_omap_send_stop_work);
+
 	INIT_WORK(&host->cmd_abort_work, mmc_omap_abort_command);
 	setup_timer(&host->cmd_abort_timer, mmc_omap_cmd_timer,
 		    (unsigned long) host);
-- 1.5.3.GIT

