Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbXJVHQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbXJVHQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbXJVHP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:15:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:43276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbXJVHP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:15:57 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 Oct 2007 17:15:50 +1000
Message-Id: <1071022071550.31281@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Stable <stable@kernel.org>
Subject: [PATCH 002 of 2] md: raid5: fix clearing of biofill operations
References: <20071022171426.31103.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dan Williams <dan.j.williams@intel.com>

ops_complete_biofill() runs outside of spin_lock(&sh->lock) and clears the
'pending' and 'ack' bits.  Since the test_and_ack_op() macro only checks
against 'complete' it can get an inconsistent snapshot of pending work.

Move the clearing of these bits to handle_stripe5(), under the lock.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Joël Bertrand <joel.bertrand@systella.fr>
Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Stable <stable@kernel.org>

### Diffstat output
 ./drivers/md/raid5.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-10-22 16:55:49.000000000 +1000
+++ ./drivers/md/raid5.c	2007-10-22 16:57:41.000000000 +1000
@@ -665,7 +665,12 @@ static unsigned long get_stripe_work(str
 		ack++;
 
 	sh->ops.count -= ack;
-	BUG_ON(sh->ops.count < 0);
+	if (unlikely(sh->ops.count < 0)) {
+		printk(KERN_ERR "pending: %#lx ops.pending: %#lx ops.ack: %#lx "
+			"ops.complete: %#lx\n", pending, sh->ops.pending,
+			sh->ops.ack, sh->ops.complete);
+		BUG();
+	}
 
 	return pending;
 }
@@ -842,8 +847,7 @@ static void ops_complete_biofill(void *s
 			}
 		}
 	}
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+	set_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
 
 	return_io(return_bi);
 
@@ -3130,6 +3134,13 @@ static void handle_stripe5(struct stripe
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
+	/* clean-up completed biofill operations */
+	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
+	}
+
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
