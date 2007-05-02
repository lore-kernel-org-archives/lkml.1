Return-Path: <linux-kernel-owner+w=401wt.eu-S2992815AbXEBGSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992815AbXEBGSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992797AbXEBGSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:18:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:6235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992812AbXEBGSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:18:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,477,1170662400"; 
   d="scan'208";a="222855959"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 07/16] md: move write operations to raid5_run_ops
To: neilb@suse.de, akpm@linux-foundation.org, christopher.leech@intel.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Date: Tue, 01 May 2007 23:18:11 -0700
Message-ID: <20070502061811.7066.16213.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
References: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

handle_stripe sets STRIPE_OP_PREXOR, STRIPE_OP_BIODRAIN, STRIPE_OP_POSTXOR
to request a write to the stripe cache.  raid5_run_ops is triggerred to run
and executes the request outside the stripe lock.

Changelog:
* make the 'rcw' parameter to handle_write_operations5 a simple flag, Neil
  Brown
* remove test_and_set/test_and_clear BUG_ONs, Neil Brown

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |  151 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 130 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 14e9f6a..03a435d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1807,7 +1807,74 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 	}
 }
 
+static int handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
+{
+	int i, pd_idx = sh->pd_idx, disks = sh->disks;
+	int locked=0;
+
+	if (rcw) {
+		/* skip the drain operation on an expand */
+		if (!expand) {
+			set_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+			sh->ops.count++;
+		}
+
+		set_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+		sh->ops.count++;
+
+		for (i=disks ; i-- ;) {
+			struct r5dev *dev = &sh->dev[i];
+
+			if (dev->towrite) {
+				set_bit(R5_LOCKED, &dev->flags);
+				if (!expand)
+					clear_bit(R5_UPTODATE, &dev->flags);
+				locked++;
+			}
+		}
+	} else {
+		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
+			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
+
+		set_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+		set_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+		set_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+
+		sh->ops.count += 3;
+
+		for (i=disks ; i-- ;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (i==pd_idx)
+				continue;
 
+			/* For a read-modify write there may be blocks that are
+			 * locked for reading while others are ready to be written
+			 * so we distinguish these blocks by the R5_Wantprexor bit
+			 */
+			if (dev->towrite &&
+			    (test_bit(R5_UPTODATE, &dev->flags) ||
+			    test_bit(R5_Wantcompute, &dev->flags))) {
+				set_bit(R5_Wantprexor, &dev->flags);
+				set_bit(R5_LOCKED, &dev->flags);
+				clear_bit(R5_UPTODATE, &dev->flags);
+				locked++;
+			}
+		}
+	}
+
+	/* keep the parity disk locked while asynchronous operations
+	 * are in flight
+	 */
+	set_bit(R5_LOCKED, &sh->dev[pd_idx].flags);
+	clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+	locked++;
+
+	PRINTK("%s: stripe %llu locked: %d pending: %lx\n",
+		__FUNCTION__, (unsigned long long)sh->sector,
+		locked, sh->ops.pending);
+
+	return locked;
+}
 
 /*
  * Each stripe/dev can have one or more bion attached.
@@ -2170,8 +2237,67 @@ static void handle_stripe5(struct stripe_head *sh)
 		set_bit(STRIPE_HANDLE, &sh->state);
 	}
 
-	/* now to consider writing and what else, if anything should be read */
-	if (to_write) {
+	/* Now we check to see if any write operations have recently
+	 * completed
+	 */
+
+	/* leave prexor set until postxor is done, allows us to distinguish
+	 * a rmw from a rcw during biodrain
+	 */
+	if (test_bit(STRIPE_OP_PREXOR, &sh->ops.complete) &&
+		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
+
+		clear_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
+		clear_bit(STRIPE_OP_PREXOR, &sh->ops.ack);
+		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+
+		for (i=disks; i--;)
+			clear_bit(R5_Wantprexor, &sh->dev[i].flags);
+	}
+
+	/* if only POSTXOR is set then this is an 'expand' postxor */
+	if (test_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete) &&
+		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
+
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+
+		/* All the 'written' buffers and the parity block are ready to be
+		 * written back to disk
+		 */
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
+		for (i=disks; i--;) {
+			dev = &sh->dev[i];
+			if (test_bit(R5_LOCKED, &dev->flags) &&
+				(i == sh->pd_idx || dev->written)) {
+				PRINTK("Writing block %d\n", i);
+				set_bit(R5_Wantwrite, &dev->flags);
+				if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+					sh->ops.count++;
+				if (!test_bit(R5_Insync, &dev->flags)
+				    || (i==sh->pd_idx && failed == 0))
+					set_bit(STRIPE_INSYNC, &sh->state);
+			}
+		}
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			atomic_dec(&conf->preread_active_stripes);
+			if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
+				md_wakeup_thread(conf->mddev->thread);
+		}
+	}
+
+	/* 1/ Now to consider new write requests and what else, if anything should be read
+	 * 2/ Check operations clobber the parity block so do not start new writes while
+	 *    a check is in flight
+	 * 3/ Write operations do not stack
+	 */
+	if (to_write && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending) &&
+		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 		int rmw=0, rcw=0;
 		for (i=disks ; i--;) {
 			/* would I have to read this buffer for read_modify_write */
@@ -2238,25 +2364,8 @@ static void handle_stripe5(struct stripe_head *sh)
 			}
 		/* now if nothing is locked, and if we have enough data, we can start a write request */
 		if (locked == 0 && (rcw == 0 ||rmw == 0) &&
-		    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
-			PRINTK("Computing parity...\n");
-			compute_parity5(sh, rcw==0 ? RECONSTRUCT_WRITE : READ_MODIFY_WRITE);
-			/* now every locked buffer is ready to be written */
-			for (i=disks; i--;)
-				if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
-					PRINTK("Writing block %d\n", i);
-					locked++;
-					set_bit(R5_Wantwrite, &sh->dev[i].flags);
-					if (!test_bit(R5_Insync, &sh->dev[i].flags)
-					    || (i==sh->pd_idx && failed == 0))
-						set_bit(STRIPE_INSYNC, &sh->state);
-				}
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->mddev->thread);
-			}
-		}
+		    !test_bit(STRIPE_BIT_DELAY, &sh->state))
+			locked += handle_write_operations5(sh, rcw == 0, 0);
 	}
 
 	/* maybe we need to check and possibly fix the parity for this stripe
