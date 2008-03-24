Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYCXT7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYCXT7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbYCXT7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:59:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51935 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493AbYCXT7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:59:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 24 Mar 2008 20:57:12 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fix synchronization of gap counts
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.afb5d03352e6f965@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:  The fact that nodes had different gap counts would be overlooked
if the bus manager code would pick gap count 63 because of beta
repeaters or because of very large hop counts.  In this case, the bus
manager code would miss that it actually has to send the PHY config
packet with gap count 63.

Related trivial changes:  Use bool for an int used as bool, touch up
some comments.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c     |    8 ++++----
 drivers/firewire/fw-topology.c |    7 +++----
 2 files changed, 7 insertions(+), 8 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -220,7 +220,7 @@ fw_card_bm_work(struct work_struct *work
 	struct bm_data bmd;
 	unsigned long flags;
 	int root_id, new_root_id, irm_id, gap_count, generation, grace;
-	int do_reset = 0;
+	bool do_reset = false;
 
 	spin_lock_irqsave(&card->lock, flags);
 	local_node = card->local_node;
@@ -361,14 +361,14 @@ fw_card_bm_work(struct work_struct *work
 		gap_count = 63;
 
 	/*
-	 * Finally, figure out if we should do a reset or not.  If we've
-	 * done less that 5 resets with the same physical topology and we
+	 * Finally, figure out if we should do a reset or not.  If we have
+	 * done less than 5 resets with the same physical topology and we
 	 * have either a new root or a new gap count setting, let's do it.
 	 */
 
 	if (card->bm_retries++ < 5 &&
 	    (card->gap_count != gap_count || new_root_id != root_id))
-		do_reset = 1;
+		do_reset = true;
 
 	spin_unlock_irqrestore(&card->lock, flags);
 
Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -290,12 +290,11 @@ static struct fw_node *build_tree(struct
 			beta_repeaters_present = true;
 
 		/*
-		 * If all PHYs does not report the same gap count
-		 * setting, we fall back to 63 which will force a gap
-		 * count reconfiguration and a reset.
+		 * If PHYs report different gap counts, set an invalid count
+		 * which will force a gap count reconfiguration and a reset.
 		 */
 		if (SELF_ID_GAP_COUNT(q) != gap_count)
-			gap_count = 63;
+			gap_count = 0;
 
 		update_hop_count(node);
 

-- 
Stefan Richter
-=====-==--- --== ==---
http://arcgraph.de/sr/

