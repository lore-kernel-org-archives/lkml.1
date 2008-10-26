Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbYJZKI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbYJZKI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 06:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYJZKIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 06:08:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47320 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbYJZKIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 06:08:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 26 Oct 2008 11:04:20 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: remove unnecessary locking
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.59b267943ae02344@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What was I thinking when I added sbp2_set_generation()?  Its locking did
nothing (except for implicitly providing the necessary barrier between
node IDs update and generation update).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -665,17 +665,6 @@ static void sbp2_agent_reset_no_wait(str
 			&d, sizeof(d), complete_agent_reset_write_no_wait, t);
 }
 
-static void sbp2_set_generation(struct sbp2_logical_unit *lu, int generation)
-{
-	struct fw_card *card = fw_device(lu->tgt->unit->device.parent)->card;
-	unsigned long flags;
-
-	/* serialize with comparisons of lu->generation and card->generation */
-	spin_lock_irqsave(&card->lock, flags);
-	lu->generation = generation;
-	spin_unlock_irqrestore(&card->lock, flags);
-}
-
 static inline void sbp2_allow_block(struct sbp2_logical_unit *lu)
 {
 	/*
@@ -879,7 +868,7 @@ static void sbp2_login(struct work_struc
 		goto out;
 
 	generation    = device->generation;
-	smp_rmb();    /* node_id must not be older than generation */
+	smp_rmb();    /* node IDs must not be older than generation */
 	node_id       = device->node_id;
 	local_node_id = device->card->node_id;
 
@@ -903,7 +892,8 @@ static void sbp2_login(struct work_struc
 
 	tgt->node_id	  = node_id;
 	tgt->address_high = local_node_id << 16;
-	sbp2_set_generation(lu, generation);
+	smp_wmb();	  /* node IDs must not be older than generation */
+	lu->generation	  = generation;
 
 	lu->command_block_agent_address =
 		((u64)(be32_to_cpu(response.command_block_agent.high) & 0xffff)
@@ -1196,7 +1186,7 @@ static void sbp2_reconnect(struct work_s
 		goto out;
 
 	generation    = device->generation;
-	smp_rmb();    /* node_id must not be older than generation */
+	smp_rmb();    /* node IDs must not be older than generation */
 	node_id       = device->node_id;
 	local_node_id = device->card->node_id;
 
@@ -1223,7 +1213,8 @@ static void sbp2_reconnect(struct work_s
 
 	tgt->node_id      = node_id;
 	tgt->address_high = local_node_id << 16;
-	sbp2_set_generation(lu, generation);
+	smp_wmb();	  /* node IDs must not be older than generation */
+	lu->generation	  = generation;
 
 	fw_notify("%s: reconnected to LUN %04x (%d retries)\n",
 		  tgt->bus_id, lu->lun, lu->retries);

-- 
Stefan Richter
-=====-==--- =-=- ==-=-
http://arcgraph.de/sr/

