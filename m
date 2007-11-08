Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbXKHQ25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbXKHQ25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758984AbXKHQ2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:28:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:27614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbXKHQ2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:28:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,390,1188802800"; 
   d="scan'208";a="266016217"
Subject: [PATCH] raid5: fix unending write sequence
From: Dan Williams <dan.j.williams@intel.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, stable@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Nov 2007 09:27:39 -0700
Message-Id: <1194539259.15713.30.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
X-OriginalArrivalTime: 08 Nov 2007 16:27:39.0592 (UTC) FILETIME=[47A06480:01C82224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

<debug output from Joël's system>
handling stripe 7629696, state=0x14 cnt=1, pd_idx=2 ops=0:0:0
check 5: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800ffcffcc0 written 0000000000000000
check 4: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800fdd4e360 written 0000000000000000
check 3: state 0x1 toread 0000000000000000 read 0000000000000000 write 0000000000000000 written 0000000000000000
check 2: state 0x1 toread 0000000000000000 read 0000000000000000 write 0000000000000000 written 0000000000000000
check 1: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800ff517e40 written 0000000000000000
check 0: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800fd4cae60 written 0000000000000000
locked=4 uptodate=2 to_read=0 to_write=4 failed=0 failed_num=0
for sector 7629696, rmw=0 rcw=0
</debug>

These blocks were prepared to be written out, but were never handled in
ops_run_biodrain(), so they remain locked forever.  The operations flags
are all clear which means handle_stripe() thinks nothing else needs to be
done.

This state suggests that the STRIPE_OP_PREXOR bit was sampled 'set' when it
should not have been.  This patch cleans up cases where the code looks at
sh->ops.pending when it should be looking at the consistent stack-based
snapshot of the operations flags.

Report from Joël:
	Resync done. Patch fix this bug.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Joël Bertrand <joel.bertrand@systella.fr>
Cc: stable@kernel.org
---

 drivers/md/raid5.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3808f52..e86cacb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -689,7 +689,8 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 }
 
 static struct dma_async_tx_descriptor *
-ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
+		 unsigned long pending)
 {
 	int disks = sh->disks;
 	int pd_idx = sh->pd_idx, i;
@@ -697,7 +698,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
 	 */
-	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -774,7 +775,8 @@ static void ops_complete_write(void *stripe_head_ref)
 }
 
 static void
-ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
+		unsigned long pending)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
@@ -782,7 +784,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
-	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 	unsigned long flags;
 	dma_async_tx_callback callback;
 
@@ -809,7 +811,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	}
 
 	/* check whether this postxor is part of a write */
-	callback = test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending) ?
+	callback = test_bit(STRIPE_OP_BIODRAIN, &pending) ?
 		ops_complete_write : ops_complete_postxor;
 
 	/* 1/ if we prexor'd then the dest is reused as a source
@@ -897,12 +899,12 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 		tx = ops_run_prexor(sh, tx);
 
 	if (test_bit(STRIPE_OP_BIODRAIN, &pending)) {
-		tx = ops_run_biodrain(sh, tx);
+		tx = ops_run_biodrain(sh, tx, pending);
 		overlap_clear++;
 	}
 
 	if (test_bit(STRIPE_OP_POSTXOR, &pending))
-		ops_run_postxor(sh, tx);
+		ops_run_postxor(sh, tx, pending);
 
 	if (test_bit(STRIPE_OP_CHECK, &pending))
 		ops_run_check(sh);
