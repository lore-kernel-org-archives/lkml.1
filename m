Return-Path: <linux-kernel-owner+w=401wt.eu-S1422686AbXCWGwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422686AbXCWGwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422707AbXCWGwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:52:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:39067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422686AbXCWGwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:52:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,317,1170662400"; 
   d="scan'208"; a="62774684:sNHT18923778"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.21-rc4 10/15] md: use async_tx and raid5_run_ops for raid5
	expansion operations
To: neilb@suse.de, christopher.leech@intel.com, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, yur@emcraft.com,
       wd@denx.de, arjan@linux.intel.com, rmk+kernel@arm.linux.org.uk
Date: Thu, 22 Mar 2007 23:52:28 -0700
Message-ID: <20070323065228.15570.85214.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com>
References: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com>
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
index bcd23fb..84a3f35 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2511,18 +2511,32 @@ static void handle_stripe5(struct stripe_head *sh)
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
@@ -2533,6 +2547,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		/* We have read all the blocks in this stripe and now we need to
 		 * copy some of them into a target stripe for expand.
 		 */
+		struct dma_async_tx_descriptor *tx = NULL;
 		clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 		for (i=0; i< sh->disks; i++)
 			if (i != sh->pd_idx) {
@@ -2556,9 +2571,12 @@ static void handle_stripe5(struct stripe_head *sh)
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
@@ -2570,6 +2588,12 @@ static void handle_stripe5(struct stripe_head *sh)
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
 
