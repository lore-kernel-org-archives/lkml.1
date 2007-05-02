Return-Path: <linux-kernel-owner+w=401wt.eu-S1161744AbXEBGUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161744AbXEBGUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161746AbXEBGUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:20:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:56929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161740AbXEBGUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:20:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,477,1170662400"; 
   d="scan'208";a="240426162"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 11/16] md: use async_tx and raid5_run_ops for raid5 expansion
	operations
To: neilb@suse.de, akpm@linux-foundation.org, christopher.leech@intel.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Date: Tue, 01 May 2007 23:20:11 -0700
Message-ID: <20070502062011.7066.3182.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
References: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The parity calculation for an expansion operation is the same as the
calculation performed at the end of a write with the caveat that all blocks
in the stripe are scheduled to be written.  An expansion operation is
identified as a stripe with the POSTXOR flag set and the BIODRAIN flag not
set.

The bulk copy operation to the new stripe is handled inline by async_tx.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   48 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6bde174..1966713 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2538,18 +2538,32 @@ static void handle_stripe5(struct stripe_head *sh)
 		}
 	}
 
-	if (expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
-		/* Need to write out all blocks after computing parity */
-		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, conf->raid_disks);
-		compute_parity5(sh, RECONSTRUCT_WRITE);
+	/* Finish postxor operations initiated by the expansion
+	 * process
+	 */
+	if (test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete) &&
+		!test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending)) {
+
+		clear_bit(STRIPE_EXPANDING, &sh->state);
+
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+
 		for (i= conf->raid_disks; i--;) {
-			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			locked++;
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
 		}
-		clear_bit(STRIPE_EXPANDING, &sh->state);
-	} else if (expanded) {
+	}
+
+	if (expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
+		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+		/* Need to write out all blocks after computing parity */
+		sh->disks = conf->raid_disks;
+		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, conf->raid_disks);
+		locked += handle_write_operations5(sh, 0, 1);
+	} else if (expanded && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
@@ -2560,6 +2574,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		/* We have read all the blocks in this stripe and now we need to
 		 * copy some of them into a target stripe for expand.
 		 */
+		struct dma_async_tx_descriptor *tx = NULL;
 		clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 		for (i=0; i< sh->disks; i++)
 			if (i != sh->pd_idx) {
@@ -2583,9 +2598,12 @@ static void handle_stripe5(struct stripe_head *sh)
 					release_stripe(sh2);
 					continue;
 				}
-				memcpy(page_address(sh2->dev[dd_idx].page),
-				       page_address(sh->dev[i].page),
-				       STRIPE_SIZE);
+
+				/* place all the copies on one channel */
+				tx = async_memcpy(sh2->dev[dd_idx].page,
+					sh->dev[i].page, 0, 0, STRIPE_SIZE,
+					ASYNC_TX_DEP_ACK, tx, NULL, NULL);
+
 				set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
 				set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
 				for (j=0; j<conf->raid_disks; j++)
@@ -2597,6 +2615,12 @@ static void handle_stripe5(struct stripe_head *sh)
 					set_bit(STRIPE_HANDLE, &sh2->state);
 				}
 				release_stripe(sh2);
+
+				/* done submitting copies, wait for them to complete */
+				if (i + 1 >= sh->disks) {
+					async_tx_ack(tx);
+					dma_wait_for_async_tx(tx);
+				}
 			}
 	}
 
