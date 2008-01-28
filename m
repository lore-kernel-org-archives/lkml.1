Return-Path: <linux-kernel-owner+w=401wt.eu-S1762597AbYA1TLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762597AbYA1TLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762041AbYA1TJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:09:46 -0500
Received: from smtp.nokia.com ([192.100.122.233]:23417 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762023AbYA1TJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:09:43 -0500
Message-ID: <479E27EF.5000000@indt.org.br>
Date: Mon, 28 Jan 2008 15:07:27 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/18] MMC: OMAP: Add back cover switch support
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:09:12.0992 (UTC) FILETIME=[44CD9A00:01C861E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

This patch adds back MMC cover switch support in a way that
supports multiple slots.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 84 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 35719e7..c6dac7e 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -107,6 +107,10 @@ struct mmc_omap_slot {
 	unsigned int		fclk_freq;
 	unsigned		powered:1;
 
+	struct work_struct      switch_work;
+	struct timer_list       switch_timer;
+	unsigned		cover_open;
+
 	struct mmc_request      *mrq;
 	struct mmc_omap_host    *host;
 	struct mmc_host		*mmc;
@@ -227,6 +231,25 @@ static void mmc_omap_release_slot(struct mmc_omap_slot *slot)
 	spin_unlock_irqrestore(&host->slot_lock, flags);
 }
 
+static inline
+int mmc_omap_cover_is_open(struct mmc_omap_slot *slot)
+{
+	return slot->pdata->get_cover_state(mmc_dev(slot->mmc), slot->id);
+}
+
+static ssize_t
+mmc_omap_show_cover_switch(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
+	struct mmc_omap_slot *slot = mmc_priv(mmc);
+
+	return sprintf(buf, "%s\n", mmc_omap_cover_is_open(slot) ? "open" :
+		       "closed");
+}
+
+static DEVICE_ATTR(cover_switch, S_IRUGO, mmc_omap_show_cover_switch, NULL);
+
 /* Access to the R/O switch is required for production testing
  * purposes. */
 static ssize_t
@@ -563,7 +586,8 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 						host->cmd->opcode !=
 						MMC_SEND_OP_COND &&
 						host->cmd->opcode !=
-						MMC_APP_CMD)
+						MMC_APP_CMD &&
+						!mmc_omap_cover_is_open(slot))
 					dev_err(mmc_dev(host->mmc),
 						"command timeout, CMD %d\n",
 						host->cmd->opcode);
@@ -612,6 +636,42 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+void omap_mmc_notify_cover_event(struct device *dev, int slot, int is_closed)
+{
+	struct mmc_omap_host *host = dev_get_drvdata(dev);
+
+	BUG_ON(slot >= host->nr_slots);
+
+	/* Other subsystems can call in here before we're initialised. */
+	if (host->nr_slots == 0 || !host->slots[slot])
+		return;
+
+	schedule_work(&host->slots[slot]->switch_work);
+}
+
+static void mmc_omap_switch_timer(unsigned long arg)
+{
+	struct mmc_omap_slot *slot = (struct mmc_omap_slot *) arg;
+
+	schedule_work(&slot->switch_work);
+}
+
+static void mmc_omap_cover_handler(struct work_struct *work)
+{
+	struct mmc_omap_slot *slot = container_of(work, struct mmc_omap_slot,
+						  switch_work);
+	int cover_open;
+
+	cover_open = mmc_omap_cover_is_open(slot);
+	if (cover_open != slot->cover_open) {
+		sysfs_notify(&slot->mmc->class_dev.kobj, NULL, "cover_switch");
+		slot->cover_open = cover_open;
+		dev_info(mmc_dev(slot->mmc), "cover is now %s\n",
+			 cover_open ? "open" : "closed");
+	}
+	mmc_detect_change(slot->mmc, slot->id);
+}
+
 /* Prepare to transfer the next segment of a scatterlist */
 static void
 mmc_omap_prepare_dma(struct mmc_omap_host *host, struct mmc_data *data)
@@ -1093,13 +1153,31 @@ static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 			goto err_remove_host;
 	}
 
+	if (slot->pdata->get_cover_state != NULL) {
+		r = device_create_file(&mmc->class_dev,
+					&dev_attr_cover_switch);
+		if (r < 0)
+			goto err_remove_slot_name;
+
+		INIT_WORK(&slot->switch_work, mmc_omap_cover_handler);
+		init_timer(&slot->switch_timer);
+		slot->switch_timer.function = mmc_omap_switch_timer;
+		slot->switch_timer.data = (unsigned long) slot;
+		schedule_work(&slot->switch_work);
+	}
+
 	if (slot->pdata->get_ro != NULL) {
 		r = device_create_file(&mmc->class_dev,
 					&dev_attr_ro);
+		if (r < 0)
+			goto err_remove_cover_attr;
 	}
 
 	return 0;
 
+err_remove_cover_attr:
+	if (slot->pdata->get_cover_state != NULL)
+		device_remove_file(&mmc->class_dev, &dev_attr_cover_switch);
 err_remove_slot_name:
 	if (slot->pdata->name != NULL)
 		device_remove_file(&mmc->class_dev, &dev_attr_ro);
@@ -1114,9 +1192,14 @@ static void mmc_omap_remove_slot(struct mmc_omap_slot *slot)
 
 	if (slot->pdata->name != NULL)
 		device_remove_file(&mmc->class_dev, &dev_attr_slot_name);
+	if (slot->pdata->get_cover_state != NULL)
+		device_remove_file(&mmc->class_dev, &dev_attr_cover_switch);
 	if (slot->pdata->get_ro != NULL)
 		device_remove_file(&mmc->class_dev, &dev_attr_ro);
 
+	del_timer_sync(&slot->switch_timer);
+	flush_scheduled_work();
+
 	mmc_remove_host(mmc);
 	mmc_free_host(mmc);
 }
-- 1.5.3.GIT

