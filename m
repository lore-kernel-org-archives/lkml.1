Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZCJUJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZCJUJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZCJUIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:08:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48191 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZCJUIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:08:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 21:08:37 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/5] firewire: core: simplify broadcast channel allocation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.be62682e320707a0@s5r6.in-berlin.de>
Message-ID: <tkrat.b8e5e5e5df25c313@s5r6.in-berlin.de>
References: <tkrat.be62682e320707a0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw-iso.c has channel allocation code now, use it.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c |  124 +++++++++----------------------------
 1 file changed, 33 insertions(+), 91 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -181,10 +181,6 @@ void fw_core_remove_descriptor(struct fw
 	mutex_unlock(&card_mutex);
 }
 
-/* ------------------------------------------------------------------ */
-/* Code to handle 1394a broadcast channel */
-
-#define THIRTY_TWO_CHANNELS (0xFFFFFFFFU)
 #define IRM_RETRIES 2
 
 /*
@@ -265,62 +261,18 @@ tryagain_w:
 	return 0;
 }
 
-static void
-irm_allocate_broadcast(struct fw_device *irm_dev, struct device *locald)
+static void allocate_broadcast_channel(struct fw_card *card, int generation)
 {
-	u32 generation;
-	u32 node_id;
-	u32 max_speed;
-	u32 retries;
-	__be32 old_data;
-	__be32 lock_data[2];
-	int rcode;
+	int channel, bandwidth = 0;
 
-	/*
-	 * The device we are updating is the IRM, so we must do
-	 * some extra work.
-	 */
-	retries = IRM_RETRIES;
-	generation = irm_dev->generation;
-	/* FIXME: do we need locking here? */
-	smp_rmb();
-	node_id = irm_dev->node_id;
-	max_speed = irm_dev->max_speed;
-
-	lock_data[0] = cpu_to_be32(THIRTY_TWO_CHANNELS);
-	lock_data[1] = cpu_to_be32(THIRTY_TWO_CHANNELS & ~1);
-tryagain:
-	old_data = lock_data[0];
-	rcode = fw_run_transaction(irm_dev->card, TCODE_LOCK_COMPARE_SWAP,
-				   node_id, generation, max_speed,
-				   CSR_REGISTER_BASE+CSR_CHANNELS_AVAILABLE_HI,
-				   &lock_data[0], 8);
-	switch (rcode) {
-	case RCODE_BUSY:
-		if (retries--)
-			goto tryagain;
-		/* fallthrough */
-	default:
-		fw_error("node %x: allocate broadcast channel failed (%x)\n",
-			 node_id, rcode);
-		return;
-
-	case RCODE_COMPLETE:
-		if (lock_data[0] == old_data)
-			break;
-		if (retries--) {
-			lock_data[1] = cpu_to_be32(be32_to_cpu(lock_data[0])&~1);
-			goto tryagain;
-		}
-		fw_error("node %x: allocate broadcast channel failed: too many"
-			 " retries\n", node_id);
-		return;
+	fw_iso_resource_manage(card, generation, 1ULL << 31,
+			       &channel, &bandwidth, true);
+	if (channel == 31) {
+		card->is_irm = true;
+		device_for_each_child(card->device, NULL,
+				      fw_irm_set_broadcast_channel_register);
 	}
-	irm_dev->card->is_irm = true;
-	device_for_each_child(locald, NULL, fw_irm_set_broadcast_channel_register);
 }
-/* ------------------------------------------------------------------ */
-
 
 static const char gap_count_table[] = {
 	63, 5, 7, 8, 10, 13, 16, 18, 21, 24, 26, 29, 32, 35, 37, 40
@@ -339,10 +291,11 @@ void fw_schedule_bm_work(struct fw_card 
 static void fw_card_bm_work(struct work_struct *work)
 {
 	struct fw_card *card = container_of(work, struct fw_card, work.work);
-	struct fw_device *root_device, *irm_device, *local_device;
-	struct fw_node *root_node, *local_node, *irm_node;
+	struct fw_device *root_device;
+	struct fw_node *root_node;
 	unsigned long flags;
-	int root_id, new_root_id, irm_id, gap_count, generation, grace, rcode;
+	int root_id, new_root_id, irm_id, local_id;
+	int gap_count, generation, grace, rcode;
 	bool do_reset = false;
 	bool root_device_is_running;
 	bool root_device_is_cmc;
@@ -350,26 +303,22 @@ static void fw_card_bm_work(struct work_
 
 	spin_lock_irqsave(&card->lock, flags);
 	card->is_irm = false;
-	local_node = card->local_node;
-	root_node  = card->root_node;
-	irm_node = card->irm_node;
 
-	if (local_node == NULL) {
+	if (card->local_node == NULL) {
 		spin_unlock_irqrestore(&card->lock, flags);
 		goto out_put_card;
 	}
-	fw_node_get(local_node);
-	fw_node_get(root_node);
-	fw_node_get(irm_node);
 
 	generation = card->generation;
+	root_node = card->root_node;
+	fw_node_get(root_node);
 	root_device = root_node->data;
 	root_device_is_running = root_device &&
 			atomic_read(&root_device->state) == FW_DEVICE_RUNNING;
 	root_device_is_cmc = root_device && root_device->cmc;
-	root_id = root_node->node_id;
-	irm_device = irm_node->data;
-	local_device = local_node->data;
+	root_id  = root_node->node_id;
+	irm_id   = card->irm_node->node_id;
+	local_id = card->local_node->node_id;
 
 	grace = time_after(jiffies, card->reset_jiffies + DIV_ROUND_UP(HZ, 8));
 
@@ -387,16 +336,15 @@ static void fw_card_bm_work(struct work_
 		 * next generation.
 		 */
 
-		irm_id = irm_node->node_id;
-		if (!irm_node->link_on) {
-			new_root_id = local_node->node_id;
+		if (!card->irm_node->link_on) {
+			new_root_id = local_id;
 			fw_notify("IRM has link off, making local node (%02x) root.\n",
 				  new_root_id);
 			goto pick_me;
 		}
 
 		lock_data[0] = cpu_to_be32(0x3f);
-		lock_data[1] = cpu_to_be32(local_node->node_id);
+		lock_data[1] = cpu_to_be32(local_id);
 
 		spin_unlock_irqrestore(&card->lock, flags);
 
@@ -411,12 +359,11 @@ static void fw_card_bm_work(struct work_
 
 		if (rcode == RCODE_COMPLETE &&
 		    lock_data[0] != cpu_to_be32(0x3f)) {
-			/* Somebody else is BM, let them do the work. */
-			if (irm_id == local_node->node_id) {
-				/* But we are IRM, so do irm-y things */
-				irm_allocate_broadcast(irm_device,
-						       card->device);
-			}
+
+			/* Somebody else is BM.  Only act as IRM. */
+			if (local_id == irm_id)
+				allocate_broadcast_channel(card, generation);
+
 			goto out;
 		}
 
@@ -429,7 +376,7 @@ static void fw_card_bm_work(struct work_
 			 * do a bus reset and pick the local node as
 			 * root, and thus, IRM.
 			 */
-			new_root_id = local_node->node_id;
+			new_root_id = local_id;
 			fw_notify("BM lock failed, making local node (%02x) root.\n",
 				  new_root_id);
 			goto pick_me;
@@ -456,7 +403,7 @@ static void fw_card_bm_work(struct work_
 		 * Either link_on is false, or we failed to read the
 		 * config rom.  In either case, pick another root.
 		 */
-		new_root_id = local_node->node_id;
+		new_root_id = local_id;
 	} else if (!root_device_is_running) {
 		/*
 		 * If we haven't probed this device yet, bail out now
@@ -478,7 +425,7 @@ static void fw_card_bm_work(struct work_
 		 * successfully read the config rom, but it's not
 		 * cycle master capable.
 		 */
-		new_root_id = local_node->node_id;
+		new_root_id = local_id;
 	}
 
  pick_me:
@@ -509,19 +456,14 @@ static void fw_card_bm_work(struct work_
 			  card->index, new_root_id, gap_count);
 		fw_send_phy_config(card, new_root_id, generation, gap_count);
 		fw_core_initiate_bus_reset(card, 1);
-	} else if (irm_node->node_id == local_node->node_id) {
-		/*
-		 * We are IRM, so do irm-y things.
-		 * There's no reason to do this if we're doing a reset. . .
-		 * We'll be back.
-		 */
-		irm_allocate_broadcast(irm_device, card->device);
+		/* Will allocate broadcast channel after the reset. */
+	} else {
+		if (local_id == irm_id)
+			allocate_broadcast_channel(card, generation);
 	}
 
  out:
 	fw_node_put(root_node);
-	fw_node_put(local_node);
-	fw_node_put(irm_node);
  out_put_card:
 	fw_card_put(card);
 }

-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/

