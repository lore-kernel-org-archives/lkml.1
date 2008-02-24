Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbYBXR6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbYBXR6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbYBXR6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:58:23 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45494 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYBXR6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:58:22 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Feb 2008 18:57:23 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/5] firewire: invalid pointers used in fw_card_bm_work
To: linux1394-devel@lists.sourceforge.net
cc: Kristian Hoegsberg <krh@bitplanet.net>, Jarod Wilson <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
Message-ID: <tkrat.6f6b61769edc0dd6@s5r6.in-berlin.de>
References: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bus management workqueue job was in danger to dereference NULL
pointers.  Also, after having temporarily lifted card->lock, a few node
pointers and a device pointer may have become invalid.

Add NULL pointer checks and get the necessary references.  Also, move
card->local_node out of fw_card_bm_work's sight during shutdown of the
card.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c     |   51 ++++++++++++++++++++++-----------
 drivers/firewire/fw-topology.c |    1 
 2 files changed, 35 insertions(+), 17 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -214,17 +214,29 @@ static void
 fw_card_bm_work(struct work_struct *work)
 {
 	struct fw_card *card = container_of(work, struct fw_card, work.work);
-	struct fw_device *root;
+	struct fw_device *root_device;
+	struct fw_node *root_node, *local_node;
 	struct bm_data bmd;
 	unsigned long flags;
 	int root_id, new_root_id, irm_id, gap_count, generation, grace;
 	int do_reset = 0;
 
 	spin_lock_irqsave(&card->lock, flags);
+	local_node = card->local_node;
+	root_node  = card->root_node;
+
+	if (local_node == NULL) {
+		spin_unlock_irqrestore(&card->lock, flags);
+		return;
+	}
+	fw_node_get(local_node);
+	fw_node_get(root_node);
 
 	generation = card->generation;
-	root = card->root_node->data;
-	root_id = card->root_node->node_id;
+	root_device = root_node->data;
+	if (root_device)
+		fw_device_get(root_device);
+	root_id = root_node->node_id;
 	grace = time_after(jiffies, card->reset_jiffies + DIV_ROUND_UP(HZ, 10));
 
 	if (card->bm_generation + 1 == generation ||
@@ -243,14 +255,14 @@ fw_card_bm_work(struct work_struct *work
 
 		irm_id = card->irm_node->node_id;
 		if (!card->irm_node->link_on) {
-			new_root_id = card->local_node->node_id;
+			new_root_id = local_node->node_id;
 			fw_notify("IRM has link off, making local node (%02x) root.\n",
 				  new_root_id);
 			goto pick_me;
 		}
 
 		bmd.lock.arg = cpu_to_be32(0x3f);
-		bmd.lock.data = cpu_to_be32(card->local_node->node_id);
+		bmd.lock.data = cpu_to_be32(local_node->node_id);
 
 		spin_unlock_irqrestore(&card->lock, flags);
 
@@ -267,12 +279,12 @@ fw_card_bm_work(struct work_struct *work
 			 * Another bus reset happened. Just return,
 			 * the BM work has been rescheduled.
 			 */
-			return;
+			goto out;
 		}
 
 		if (bmd.rcode == RCODE_COMPLETE && bmd.old != 0x3f)
 			/* Somebody else is BM, let them do the work. */
-			return;
+			goto out;
 
 		spin_lock_irqsave(&card->lock, flags);
 		if (bmd.rcode != RCODE_COMPLETE) {
@@ -282,7 +294,7 @@ fw_card_bm_work(struct work_struct *work
 			 * do a bus reset and pick the local node as
 			 * root, and thus, IRM.
 			 */
-			new_root_id = card->local_node->node_id;
+			new_root_id = local_node->node_id;
 			fw_notify("BM lock failed, making local node (%02x) root.\n",
 				  new_root_id);
 			goto pick_me;
@@ -295,7 +307,7 @@ fw_card_bm_work(struct work_struct *work
 		 */
 		spin_unlock_irqrestore(&card->lock, flags);
 		schedule_delayed_work(&card->work, DIV_ROUND_UP(HZ, 10));
-		return;
+		goto out;
 	}
 
 	/*
@@ -305,20 +317,20 @@ fw_card_bm_work(struct work_struct *work
 	 */
 	card->bm_generation = generation;
 
-	if (root == NULL) {
+	if (root_device == NULL) {
 		/*
 		 * Either link_on is false, or we failed to read the
 		 * config rom.  In either case, pick another root.
 		 */
-		new_root_id = card->local_node->node_id;
-	} else if (atomic_read(&root->state) != FW_DEVICE_RUNNING) {
+		new_root_id = local_node->node_id;
+	} else if (atomic_read(&root_device->state) != FW_DEVICE_RUNNING) {
 		/*
 		 * If we haven't probed this device yet, bail out now
 		 * and let's try again once that's done.
 		 */
 		spin_unlock_irqrestore(&card->lock, flags);
-		return;
-	} else if (root->config_rom[2] & BIB_CMC) {
+		goto out;
+	} else if (root_device->config_rom[2] & BIB_CMC) {
 		/*
 		 * FIXME: I suppose we should set the cmstr bit in the
 		 * STATE_CLEAR register of this node, as described in
@@ -332,7 +344,7 @@ fw_card_bm_work(struct work_struct *work
 		 * successfully read the config rom, but it's not
 		 * cycle master capable.
 		 */
-		new_root_id = card->local_node->node_id;
+		new_root_id = local_node->node_id;
 	}
 
  pick_me:
@@ -341,8 +353,8 @@ fw_card_bm_work(struct work_struct *work
 	 * the typically much larger 1394b beta repeater delays though.
 	 */
 	if (!card->beta_repeaters_present &&
-	    card->root_node->max_hops < ARRAY_SIZE(gap_count_table))
-		gap_count = gap_count_table[card->root_node->max_hops];
+	    root_node->max_hops < ARRAY_SIZE(gap_count_table))
+		gap_count = gap_count_table[root_node->max_hops];
 	else
 		gap_count = 63;
 
@@ -364,6 +376,11 @@ fw_card_bm_work(struct work_struct *work
 		fw_send_phy_config(card, new_root_id, generation, gap_count);
 		fw_core_initiate_bus_reset(card, 1);
 	}
+ out:
+	if (root_device)
+		fw_device_put(root_device);
+	fw_node_put(root_node);
+	fw_node_put(local_node);
 }
 
 static void
Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -383,6 +383,7 @@ void fw_destroy_nodes(struct fw_card *ca
 	card->color++;
 	if (card->local_node != NULL)
 		for_each_fw_node(card, card->local_node, report_lost_node);
+	card->local_node = NULL;
 	spin_unlock_irqrestore(&card->lock, flags);
 }
 

-- 
Stefan Richter
-=====-==--- --=- ==---
http://arcgraph.de/sr/

