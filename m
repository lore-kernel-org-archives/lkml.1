Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbXKBBnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbXKBBnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbXKBBng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:43:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:39677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbXKBBnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:43:35 -0400
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 2 Nov 2007 12:43:26 +1100
Message-Id: <1071102014326.26923@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Dan Williams" <dan.j.williams@intel.com>
Cc: stable@kernel.org
Subject: [PATCH] md: Fix misapplied patch in raid5.c
References: <20071102123814.26603.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4ae3f847e49e3787eca91bced31f8fd328d50496 did not get applied
correctly, presumably due to substantial similarities between
handle_stripe5 and handle_stripe6.

This patch (with lots of context) moves the chunk of new code from
handle_stripe6 (where it isn't needed (yet)) to handle_stripe5.


Signed-off-by: Neil Brown <neilb@suse.de>
cc: "Dan Williams" <dan.j.williams@intel.com>

---
 The patch is correctly applied in -mm.
 The same patch was sent to stable@ but doesn't seem to have made it yet.
 When it does get applied, we should make sure it gets applied properly...

### Diffstat output
 ./drivers/md/raid5.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-11-02 12:10:49.000000000 +1100
+++ ./drivers/md/raid5.c	2007-11-02 12:25:31.000000000 +1100
@@ -2607,40 +2607,47 @@ static void handle_stripe5(struct stripe
 	struct bio *return_bi = NULL;
 	struct stripe_head_state s;
 	struct r5dev *dev;
 	unsigned long pending = 0;
 
 	memset(&s, 0, sizeof(s));
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d "
 		"ops=%lx:%lx:%lx\n", (unsigned long long)sh->sector, sh->state,
 		atomic_read(&sh->count), sh->pd_idx,
 		sh->ops.pending, sh->ops.ack, sh->ops.complete);
 
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
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
 		struct r5dev *dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx toread %p read %p write %p "
 			"written %p\n",	i, dev->flags, dev->toread, dev->read,
 			dev->towrite, dev->written);
 
 		/* maybe we can request a biofill operation
 		 *
 		 * new wantfill requests are only permitted while
 		 * STRIPE_OP_BIOFILL is clear
 		 */
 		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread &&
 			!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
 			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
@@ -2880,47 +2887,40 @@ static void handle_stripe6(struct stripe
 	struct stripe_head_state s;
 	struct r6_state r6s;
 	struct r5dev *dev, *pdev, *qdev;
 
 	r6s.qd_idx = raid6_next_disk(pd_idx, disks);
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
 		"pd_idx=%d, qd_idx=%d\n",
 	       (unsigned long long)sh->sector, sh->state,
 	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
 	memset(&s, 0, sizeof(s));
 
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
-	/* clean-up completed biofill operations */
-	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
-		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
-		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
-	}
-
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
 		dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
 			i, dev->flags, dev->toread, dev->towrite, dev->written);
 		/* maybe we can reply to a read */
 		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
 			struct bio *rbi, *rbi2;
 			pr_debug("Return read for disc %d\n", i);
 			spin_lock_irq(&conf->device_lock);
 			rbi = dev->toread;
 			dev->toread = NULL;
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&conf->wait_for_overlap);
 			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector < dev->sector + STRIPE_SECTORS) {
 				copy_data(0, rbi, dev->page, dev->sector);
