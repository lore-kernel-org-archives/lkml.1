Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYK2R5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYK2R5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 12:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYK2R47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 12:56:59 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52631 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYK2R47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 12:56:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 29 Nov 2008 18:56:47 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fix resetting of bus manager retry counter
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.c0ba1ba99cd6f8c3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An earlier change, maybe long ago, removed the copying of self_id_count
into card->self_id_count.  Since then each bus reset cleared
card->bm_retries even when it shouldn't.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-topology.c    |   14 ++++++--------
 drivers/firewire/fw-transaction.h |    1 -
 2 files changed, 6 insertions(+), 9 deletions(-)

Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -355,6 +355,9 @@ report_lost_node(struct fw_card *card,
 {
 	fw_node_event(card, node, FW_NODE_DESTROYED);
 	fw_node_put(node);
+
+	/* Topology has changed - reset bus manager retry counter */
+	card->bm_retries = 0;
 }
 
 static void
@@ -374,6 +377,9 @@ report_found_node(struct fw_card *card,
 	}
 
 	fw_node_event(card, node, FW_NODE_CREATED);
+
+	/* Topology has changed - reset bus manager retry counter */
+	card->bm_retries = 0;
 }
 
 void fw_destroy_nodes(struct fw_card *card)
@@ -526,14 +532,6 @@ fw_core_handle_bus_reset(struct fw_card 
 
 	spin_lock_irqsave(&card->lock, flags);
 
-	/*
-	 * If the new topology has a different self_id_count the topology
-	 * changed, either nodes were added or removed. In that case we
-	 * reset the IRM reset counter.
-	 */
-	if (card->self_id_count != self_id_count)
-		card->bm_retries = 0;
-
 	card->node_id = node_id;
 	/*
 	 * Update node_id before generation to prevent anybody from using
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -239,7 +239,6 @@ struct fw_card {
 	 * We need to store up to 4 self ID for a maximum of 63
 	 * devices plus 3 words for the topology map header.
 	 */
-	int self_id_count;
 	u32 topology_map[252 + 3];
 	u32 broadcast_channel;
 

-- 
Stefan Richter
-=====-==--- =-== ===-=
http://arcgraph.de/sr/

