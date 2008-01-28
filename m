Return-Path: <linux-kernel-owner+w=401wt.eu-S1763235AbYA1TNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763235AbYA1TNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762177AbYA1TKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:10:03 -0500
Received: from smtp.nokia.com ([192.100.122.230]:62324 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762169AbYA1TKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:10:00 -0500
Message-ID: <479E2810.3000300@indt.org.br>
Date: Mon, 28 Jan 2008 15:08:00 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/18] MMC: OMAP: Use tasklet instead of workqueue for cover
 switch notification
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:09:45.0617 (UTC) FILETIME=[583FC810:01C861E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

The cover waitqueue is occasionally scheduled twice from timer
and the interrupt and oops follows. It would have been possible
to fix this problem with spinlocks but using tasklet was a dropin
sloution with no need for locking.

This path also adds some cleanups.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 drivers/mmc/host/omap.c |   67 ++++++++++++++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 61d2293..276ccf4 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -95,7 +95,7 @@
 
 /* Specifies how often in millisecs to poll for card status changes
  * when the cover switch is open */
-#define OMAP_MMC_SWITCH_POLL_DELAY	500
+#define OMAP_MMC_COVER_POLL_DELAY	500
 
 struct mmc_omap_host;
 
@@ -107,8 +107,8 @@ struct mmc_omap_slot {
 	unsigned int		fclk_freq;
 	unsigned		powered:1;
 
-	struct work_struct      switch_work;
-	struct timer_list       switch_timer;
+	struct tasklet_struct	cover_tasklet;
+	struct timer_list       cover_timer;
 	unsigned		cover_open;
 
 	struct mmc_request      *mrq;
@@ -758,40 +758,51 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-void omap_mmc_notify_cover_event(struct device *dev, int slot, int is_closed)
+void omap_mmc_notify_cover_event(struct device *dev, int num, int is_closed)
 {
+	int cover_open;
 	struct mmc_omap_host *host = dev_get_drvdata(dev);
+	struct mmc_omap_slot *slot = host->slots[num];
 
-	BUG_ON(slot >= host->nr_slots);
+	BUG_ON(num >= host->nr_slots);
 
 	/* Other subsystems can call in here before we're initialised. */
-	if (host->nr_slots == 0 || !host->slots[slot])
+	if (host->nr_slots == 0 || !host->slots[num])
 		return;
 
-	schedule_work(&host->slots[slot]->switch_work);
+	cover_open = mmc_omap_cover_is_open(slot);
+	if (cover_open != slot->cover_open) {
+		slot->cover_open = cover_open;
+		sysfs_notify(&slot->mmc->class_dev.kobj, NULL, "cover_switch");
+	}
+
+	tasklet_hi_schedule(&slot->cover_tasklet);
 }
 
-static void mmc_omap_switch_timer(unsigned long arg)
+static void mmc_omap_cover_timer(unsigned long arg)
 {
 	struct mmc_omap_slot *slot = (struct mmc_omap_slot *) arg;
-
-	schedule_work(&slot->switch_work);
+	tasklet_schedule(&slot->cover_tasklet);
 }
 
-static void mmc_omap_cover_handler(struct work_struct *work)
+static void mmc_omap_cover_handler(unsigned long param)
 {
-	struct mmc_omap_slot *slot = container_of(work, struct mmc_omap_slot,
-						  switch_work);
-	int cover_open;
+	struct mmc_omap_slot *slot = (struct mmc_omap_slot *)param;
+	int cover_open = mmc_omap_cover_is_open(slot);
 
-	cover_open = mmc_omap_cover_is_open(slot);
-	if (cover_open != slot->cover_open) {
-		sysfs_notify(&slot->mmc->class_dev.kobj, NULL, "cover_switch");
-		slot->cover_open = cover_open;
-		dev_info(mmc_dev(slot->mmc), "cover is now %s\n",
-			 cover_open ? "open" : "closed");
-	}
-	mmc_detect_change(slot->mmc, slot->id);
+	mmc_detect_change(slot->mmc, 0);
+	if (!cover_open)
+		return;
+
+	/*
+	 * If no card is inserted, we postpone polling until
+	 * the cover has been closed.
+	 */
+	if (slot->mmc->card == NULL || !mmc_card_present(slot->mmc->card))
+		return;
+
+	mod_timer(&slot->cover_timer,
+		  jiffies + msecs_to_jiffies(OMAP_MMC_COVER_POLL_DELAY));
 }
 
 /* Prepare to transfer the next segment of a scatterlist */
@@ -1266,10 +1277,11 @@ static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 		if (r < 0)
 			goto err_remove_slot_name;
 
-		INIT_WORK(&slot->switch_work, mmc_omap_cover_handler);
-		setup_timer(&slot->switch_timer, mmc_omap_switch_timer,
-			    (unsigned long) slot);
-		schedule_work(&slot->switch_work);
+		setup_timer(&slot->cover_timer, mmc_omap_cover_timer,
+			    (unsigned long)slot);
+		tasklet_init(&slot->cover_tasklet, mmc_omap_cover_handler,
+			     (unsigned long)slot);
+		tasklet_schedule(&slot->cover_tasklet);
 	}
 
 	if (slot->pdata->get_ro != NULL) {
@@ -1303,7 +1315,8 @@ static void mmc_omap_remove_slot(struct mmc_omap_slot *slot)
 	if (slot->pdata->get_ro != NULL)
 		device_remove_file(&mmc->class_dev, &dev_attr_ro);
 
-	del_timer_sync(&slot->switch_timer);
+	tasklet_kill(&slot->cover_tasklet);
+	del_timer_sync(&slot->cover_timer);
 	flush_scheduled_work();
 
 	mmc_remove_host(mmc);
-- 1.5.3.GIT

