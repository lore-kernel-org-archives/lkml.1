Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXH3GF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXH3GF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 02:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXH3GFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 02:05:17 -0400
Received: from ns2.suse.de ([195.135.220.15]:55949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbXH3GFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 02:05:16 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 30 Aug 2007 16:05:08 +1000
Message-Id: <1070830060508.5223@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] md: Fix some bugs with growing raid5/raid6 arrays.
References: <20070830155923.553.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The recent changed to raid5 to allow offload of parity calculation etc
introduced some bugs in the code for growing (i.e. adding a disk to)
raid5 and raid6.  This fixes them

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

---

This is against 2.6.23-rc4.   It applies to current -mm with quite a bit of fuzz...

Thanks,
NeilBrown


### Diffstat output
 ./drivers/md/raid5.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-08-30 15:58:55.000000000 +1000
+++ ./drivers/md/raid5.c	2007-08-30 15:58:55.000000000 +1000
@@ -2541,7 +2541,7 @@ static void handle_stripe_expansion(raid
 	struct dma_async_tx_descriptor *tx = NULL;
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
-		if (i != sh->pd_idx && (r6s && i != r6s->qd_idx)) {
+		if (i != sh->pd_idx && (!r6s || i != r6s->qd_idx)) {
 			int dd_idx, pd_idx, j;
 			struct stripe_head *sh2;
 
@@ -2574,7 +2574,8 @@ static void handle_stripe_expansion(raid
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
 			for (j = 0; j < conf->raid_disks; j++)
 				if (j != sh2->pd_idx &&
-				    (r6s && j != r6s->qd_idx) &&
+				    (!r6s || j != raid6_next_disk(sh2->pd_idx,
+								 sh2->disks)) &&
 				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
 					break;
 			if (j == conf->raid_disks) {
@@ -2583,12 +2584,12 @@ static void handle_stripe_expansion(raid
 			}
 			release_stripe(sh2);
 
-			/* done submitting copies, wait for them to complete */
-			if (i + 1 >= sh->disks) {
-				async_tx_ack(tx);
-				dma_wait_for_async_tx(tx);
-			}
 		}
+	/* done submitting copies, wait for them to complete */
+	if (tx) {
+		async_tx_ack(tx);
+		dma_wait_for_async_tx(tx);
+	}
 }
 
 /*
@@ -2855,7 +2856,7 @@ static void handle_stripe5(struct stripe
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
 			conf->raid_disks);
-		s.locked += handle_write_operations5(sh, 0, 1);
+		s.locked += handle_write_operations5(sh, 1, 1);
 	} else if (s.expanded &&
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
