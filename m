Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbYCZUOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbYCZUOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbYCZUMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:12:43 -0400
Received: from smtp.nokia.com ([192.100.105.134]:62261 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202AbYCZUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:12:35 -0400
Message-ID: <47EAAD64.4020401@indt.org.br>
Date: Wed, 26 Mar 2008 16:09:08 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/18] MMC: OMAP: Add back cover switch support
References: <47DAD39C.90405@indt.org.br> <20080324132631.1e0d2125@mjolnir.drzeus.cx>
In-Reply-To: <20080324132631.1e0d2125@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 20:11:51.0436 (UTC) FILETIME=[A0F824C0:01C88F7D]
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
 drivers/mmc/host/omap.c |   87 +++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 6b4f040..fc46a70 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -106,6 +106,10 @@ struct mmc_omap_slot {
 	unsigned int		fclk_freq;
 	unsigned		powered:1;
 
+	struct work_struct      switch_work;
+	struct timer_list       switch_timer;
+	unsigned		cover_open;
+
 	struct mmc_request      *mrq;
 	struct mmc_omap_host    *host;
 	struct mmc_host		*mmc;
@@ -226,6 +230,25 @@ static void mmc_omap_release_slot(struct mmc_omap_slot *slot)
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
 static ssize_t
 mmc_omap_show_slot_name(struct device *dev, struct device_attribute *attr,
 			char *buf)
@@ -544,9 +567,10 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 			if (host->cmd) {
 				struct mmc_omap_slot *slot =
 					host->current_slot;
-				dev_err(mmc_dev(host->mmc),
-					"command timeout, CMD %d\n",
-					host->cmd->opcode);
+				if (!mmc_omap_cover_is_open(slot))
+					dev_err(mmc_dev(host->mmc),
+						"command timeout, CMD %d\n",
+						host->cmd->opcode);
 				host->cmd->error = -ETIMEDOUT;
 				end_command = 1;
 			}
@@ -592,6 +616,42 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
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
@@ -1062,8 +1122,24 @@ static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
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
 	return 0;
 
+err_remove_slot_name:
+	if (slot->pdata->name != NULL)
+		device_remove_file(&mmc->class_dev, &dev_attr_slot_name);
 err_remove_host:
 	mmc_remove_host(mmc);
 	mmc_free_host(mmc);
@@ -1076,6 +1152,11 @@ static void mmc_omap_remove_slot(struct mmc_omap_slot *slot)
 
 	if (slot->pdata->name != NULL)
 		device_remove_file(&mmc->class_dev, &dev_attr_slot_name);
+	if (slot->pdata->get_cover_state != NULL)
+		device_remove_file(&mmc->class_dev, &dev_attr_cover_switch);
+
+	del_timer_sync(&slot->switch_timer);
+	flush_scheduled_work();
 
 	mmc_remove_host(mmc);
 	mmc_free_host(mmc);
-- 1.5.3.GIT

