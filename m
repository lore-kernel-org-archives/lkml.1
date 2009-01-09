Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZAITu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZAITu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 14:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZAITuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 14:50:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42042 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZAITuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 14:50:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 9 Jan 2009 20:49:37 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH post 2.6.28] firewire: core: fix sleep in atomic context due
 to driver core change
To: linux1394-devel@lists.sourceforge.net
cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <496798FE.8030900@s5r6.in-berlin.de>
Message-ID: <tkrat.34f28fe71f678057@s5r6.in-berlin.de>
References: <496798FE.8030900@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to commit 2831fe6f9cc4e16c103504ee09a47a084297c0f3, "driver core:
create a private portion of struct device", device_initialize() can no
longer be called from atomic contexts.

We now defer it until after config ROM probing.  This requires changes
to the bus manager code because this may use a device before it was
probed.

Reported-by: Jay Fenlason <fenlason@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This still needs a lot of testing since I may have easily missed
something.  Even if it works, it complicates firewire-core's lifetime
rules.

Better would be to fix driver core to not sleep in device_initialize
(and besides, never fail in void device_initialize).

 drivers/firewire/fw-card.c   |   13 +++++++------
 drivers/firewire/fw-device.c |   23 +++++++++++++----------
 2 files changed, 20 insertions(+), 16 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -160,7 +160,8 @@ static void fw_device_release(struct dev
 
 	/*
 	 * Take the card lock so we don't set this to NULL while a
-	 * FW_NODE_UPDATED callback is being handled.
+	 * FW_NODE_UPDATED callback is being handled or while the
+	 * bus manager work looks at this node.
 	 */
 	spin_lock_irqsave(&card->lock, flags);
 	device->node->data = NULL;
@@ -693,12 +694,13 @@ static void fw_device_init(struct work_s
 		return;
 	}
 
-	err = -ENOMEM;
+	device_initialize(&device->device);
 
 	fw_device_get(device);
 	down_write(&fw_device_rwsem);
-	if (idr_pre_get(&fw_device_idr, GFP_KERNEL))
-		err = idr_get_new(&fw_device_idr, device, &minor);
+	err = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
+	      idr_get_new(&fw_device_idr, device, &minor) :
+	      -ENOMEM;
 	up_write(&fw_device_rwsem);
 
 	if (err < 0)
@@ -909,13 +911,14 @@ void fw_node_event(struct fw_card *card,
 
 		/*
 		 * Do minimal intialization of the device here, the
-		 * rest will happen in fw_device_init().  We need the
-		 * card and node so we can read the config rom and we
-		 * need to do device_initialize() now so
-		 * device_for_each_child() in FW_NODE_UPDATED is
-		 * doesn't freak out.
+		 * rest will happen in fw_device_init().
+		 *
+		 * Attention:  A lot of things, even fw_device_get(),
+		 * cannot be done before fw_device_init() finished!
+		 * You can basically just check device->state and
+		 * schedule work until then, but only while holding
+		 * card->lock.
 		 */
-		device_initialize(&device->device);
 		atomic_set(&device->state, FW_DEVICE_INITIALIZING);
 		device->card = fw_card_get(card);
 		device->node = fw_node_get(node);
Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -203,6 +203,8 @@ static void fw_card_bm_work(struct work_
 	unsigned long flags;
 	int root_id, new_root_id, irm_id, gap_count, generation, grace, rcode;
 	bool do_reset = false;
+	bool root_device_is_running;
+	bool root_device_is_cmc;
 	__be32 lock_data[2];
 
 	spin_lock_irqsave(&card->lock, flags);
@@ -218,8 +220,9 @@ static void fw_card_bm_work(struct work_
 
 	generation = card->generation;
 	root_device = root_node->data;
-	if (root_device)
-		fw_device_get(root_device);
+	root_device_is_running = root_device &&
+			atomic_read(&root_device->state) == FW_DEVICE_RUNNING;
+	root_device_is_cmc = root_device && root_device->cmc;
 	root_id = root_node->node_id;
 	grace = time_after(jiffies, card->reset_jiffies + DIV_ROUND_UP(HZ, 10));
 
@@ -302,14 +305,14 @@ static void fw_card_bm_work(struct work_
 		 * config rom.  In either case, pick another root.
 		 */
 		new_root_id = local_node->node_id;
-	} else if (atomic_read(&root_device->state) != FW_DEVICE_RUNNING) {
+	} else if (!root_device_is_running) {
 		/*
 		 * If we haven't probed this device yet, bail out now
 		 * and let's try again once that's done.
 		 */
 		spin_unlock_irqrestore(&card->lock, flags);
 		goto out;
-	} else if (root_device->cmc) {
+	} else if (root_device_is_cmc) {
 		/*
 		 * FIXME: I suppose we should set the cmstr bit in the
 		 * STATE_CLEAR register of this node, as described in
@@ -356,8 +359,6 @@ static void fw_card_bm_work(struct work_
 		fw_core_initiate_bus_reset(card, 1);
 	}
  out:
-	if (root_device)
-		fw_device_put(root_device);
 	fw_node_put(root_node);
 	fw_node_put(local_node);
  out_put_card:

-- 
Stefan Richter
-=====-==--= ---= -=--=
http://arcgraph.de/sr/

