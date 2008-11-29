Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYK2Qpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYK2Qpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 11:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYK2QpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 11:45:22 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52193 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYK2QpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 11:45:21 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 29 Nov 2008 17:44:57 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: improve refcounting of fw_card
To: Jay Fenlason <fenlason@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20081020222131.GB12720@redhat.com>
Message-ID: <tkrat.395055fa1252aede@s5r6.in-berlin.de>
References: <20081020191213.GA12720@redhat.com>
 <48FCEE83.7070506@s5r6.in-berlin.de> <20081020222131.GB12720@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Fenlason <fenlason@redhat.com>

Take a reference to the card whenever fw_card_bm_work() is scheduled on
that card and release it when the work is done.  This allows us to
remove the cancel_delayed_work_sync() in fw_core_remove_card().

Signed-off-by: Jay Fenlason <fenlason@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (patch update)
---

Changes by Stefan R:

Changed fw_schedule_bm_work() delay argument from bool to unsigned long
in order to have the delay specified at the call site in broad daylight.
Moved its declaration into the fw_card section of fw-transaction.h.


 drivers/firewire/fw-card.c        |   18 +++++++++++++++---
 drivers/firewire/fw-device.c      |    6 +++---
 drivers/firewire/fw-topology.c    |    2 +-
 drivers/firewire/fw-transaction.h |    2 ++
 4 files changed, 21 insertions(+), 7 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -189,6 +189,17 @@ static const char gap_count_table[] = {
 	63, 5, 7, 8, 10, 13, 16, 18, 21, 24, 26, 29, 32, 35, 37, 40
 };
 
+void
+fw_schedule_bm_work(struct fw_card *card, unsigned long delay)
+{
+	int scheduled;
+
+	fw_card_get(card);
+	scheduled = schedule_delayed_work(&card->work, delay);
+	if (!scheduled)
+		fw_card_put(card);
+}
+
 static void
 fw_card_bm_work(struct work_struct *work)
 {
@@ -206,7 +217,7 @@ fw_card_bm_work(struct work_struct *work
 
 	if (local_node == NULL) {
 		spin_unlock_irqrestore(&card->lock, flags);
-		return;
+		goto out_put_card;
 	}
 	fw_node_get(local_node);
 	fw_node_get(root_node);
@@ -280,7 +291,7 @@ fw_card_bm_work(struct work_struct *work
 		 * this task 100ms from now.
 		 */
 		spin_unlock_irqrestore(&card->lock, flags);
-		schedule_delayed_work(&card->work, DIV_ROUND_UP(HZ, 10));
+		fw_schedule_bm_work(card, DIV_ROUND_UP(HZ, 10));
 		goto out;
 	}
 
@@ -355,6 +366,8 @@ fw_card_bm_work(struct work_struct *work
 		fw_device_put(root_device);
 	fw_node_put(root_node);
 	fw_node_put(local_node);
+ out_put_card:
+	fw_card_put(card);
 }
 
 static void
@@ -510,7 +523,6 @@ fw_core_remove_card(struct fw_card *card
 	fw_card_put(card);
 	wait_for_completion(&card->done);
 
-	cancel_delayed_work_sync(&card->work);
 	WARN_ON(!list_empty(&card->transaction_list));
 	del_timer_sync(&card->flush_timer);
 }
Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -691,7 +691,7 @@ static void fw_device_init(struct work_s
 			fw_notify("giving up on config rom for node id %x\n",
 				  device->node_id);
 			if (device->node == device->card->root_node)
-				schedule_delayed_work(&device->card->work, 0);
+				fw_schedule_bm_work(device->card, 0);
 			fw_device_release(&device->device);
 		}
 		return;
@@ -760,7 +760,7 @@ static void fw_device_init(struct work_s
 	 * pretty harmless.
 	 */
 	if (device->node == device->card->root_node)
-		schedule_delayed_work(&device->card->work, 0);
+		fw_schedule_bm_work(device->card, 0);
 
 	return;
 
@@ -894,7 +894,7 @@ static void fw_device_refresh(struct wor
 	fw_device_shutdown(work);
  out:
 	if (node_id == card->root_node->node_id)
-		schedule_delayed_work(&card->work, 0);
+		fw_schedule_bm_work(card, 0);
 }
 
 void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -542,7 +542,7 @@ fw_core_handle_bus_reset(struct fw_card 
 	smp_wmb();
 	card->generation = generation;
 	card->reset_jiffies = jiffies;
-	schedule_delayed_work(&card->work, 0);
+	fw_schedule_bm_work(card, 0);
 
 	local_node = build_tree(card, self_ids, self_id_count);
 
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -276,6 +276,8 @@ static inline void fw_card_put(struct fw
 	kref_put(&card->kref, fw_card_release);
 }
 
+extern void fw_schedule_bm_work(struct fw_card *card, unsigned long delay);
+
 /*
  * Check whether new_generation is the immediate successor of old_generation.
  * Take counter roll-over at 255 (as per to OHCI) into account.

-- 
Stefan Richter
-=====-==--- =-== ===-=
http://arcgraph.de/sr/

