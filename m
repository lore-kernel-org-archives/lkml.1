Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbZCJUIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbZCJUIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757808AbZCJUH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:07:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48186 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886AbZCJUH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:07:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 21:07:46 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/5] firewire: core: increase bus manager grace period
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.be62682e320707a0@s5r6.in-berlin.de>
Message-ID: <tkrat.0d2f05bb353d93be@s5r6.in-berlin.de>
References: <tkrat.be62682e320707a0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per IEEE 1394 clause 8.4.2.5, bus manager capable nodes which are not
incumbent shall wait at least 125ms before trying to establish
themselves as bus manager.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -368,9 +368,11 @@ static void fw_card_bm_work(struct work_
 			atomic_read(&root_device->state) == FW_DEVICE_RUNNING;
 	root_device_is_cmc = root_device && root_device->cmc;
 	root_id = root_node->node_id;
-	grace = time_after(jiffies, card->reset_jiffies + DIV_ROUND_UP(HZ, 10));
 	irm_device = irm_node->data;
 	local_device = local_node->data;
+
+	grace = time_after(jiffies, card->reset_jiffies + DIV_ROUND_UP(HZ, 8));
+
 	if (is_next_generation(generation, card->bm_generation) ||
 	    (card->bm_generation != generation && grace)) {
 		/*
@@ -434,12 +436,11 @@ static void fw_card_bm_work(struct work_
 		}
 	} else if (card->bm_generation != generation) {
 		/*
-		 * OK, we weren't BM in the last generation, and it's
-		 * less than 100ms since last bus reset. Reschedule
-		 * this task 100ms from now.
+		 * We weren't BM in the last generation, and the last
+		 * bus reset is less than 125ms ago.  Reschedule this job.
 		 */
 		spin_unlock_irqrestore(&card->lock, flags);
-		fw_schedule_bm_work(card, DIV_ROUND_UP(HZ, 10));
+		fw_schedule_bm_work(card, DIV_ROUND_UP(HZ, 8));
 		goto out;
 	}
 

-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/

