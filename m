Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbXF0Bzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbXF0Bzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 21:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbXF0Bvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 21:51:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:1164 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbXF0Bvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 21:51:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,465,1175497200"; 
   d="scan'208";a="261537539"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 11/19] md: handle_stripe5 - add request/completion
	logic for async check ops
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net,
       christopher.leech@intel.com, shannon.nelson@intel.com,
       herbert@gondor.apana.org.au, jeff@garzik.org
Date: Tue, 26 Jun 2007 18:51:30 -0700
Message-ID: <20070627015130.18962.39545.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Check operations are scheduled when the array is being resynced or an
explicit 'check/repair' command was sent to the array.  Previously check
operations would destroy the parity block in the cache such that even if
parity turned out to be correct the parity block would be marked
!R5_UPTODATE at the completion of the check.  When the operation can be
carried out by a dma engine the assumption is that it can check parity as a
read-only operation.  If raid5_run_ops notices that the check was handled
by hardware it will preserve the R5_UPTODATE status of the parity disk.

When a check operation determines that the parity needs to be repaired we
reuse the existing compute block infrastructure to carry out the operation.
Repair operations imply an immediate write back of the data, so to
differentiate a repair from a normal compute operation the
STRIPE_OP_MOD_REPAIR_PD flag is added.

Changelog:
* remove test_and_set/test_and_clear BUG_ONs, Neil Brown

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-By: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   84 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 65 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 38b8167..89d3890 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2464,26 +2464,67 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 				struct stripe_head_state *s, int disks)
 {
 	set_bit(STRIPE_HANDLE, &sh->state);
-	if (s->failed == 0) {
-		BUG_ON(s->uptodate != disks);
-		compute_parity5(sh, CHECK_PARITY);
-		s->uptodate--;
-		if (page_is_zero(sh->dev[sh->pd_idx].page)) {
-			/* parity is correct (on disc, not in buffer any more)
-			 */
-			set_bit(STRIPE_INSYNC, &sh->state);
-		} else {
-			conf->mddev->resync_mismatches += STRIPE_SECTORS;
-			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
-				/* don't try to repair!! */
+	/* Take one of the following actions:
+	 * 1/ start a check parity operation if (uptodate == disks)
+	 * 2/ finish a check parity operation and act on the result
+	 * 3/ skip to the writeback section if we previously
+	 *    initiated a recovery operation
+	 */
+	if (s->failed == 0 &&
+	    !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+		if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+			BUG_ON(s->uptodate != disks);
+			clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
+			sh->ops.count++;
+			s->uptodate--;
+		} else if (
+		       test_and_clear_bit(STRIPE_OP_CHECK, &sh->ops.complete)) {
+			clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
+			clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
+
+			if (sh->ops.zero_sum_result == 0)
+				/* parity is correct (on disc,
+				 * not in buffer any more)
+				 */
 				set_bit(STRIPE_INSYNC, &sh->state);
 			else {
-				compute_block(sh, sh->pd_idx);
-				s->uptodate++;
+				conf->mddev->resync_mismatches +=
+					STRIPE_SECTORS;
+				if (test_bit(
+				     MD_RECOVERY_CHECK, &conf->mddev->recovery))
+					/* don't try to repair!! */
+					set_bit(STRIPE_INSYNC, &sh->state);
+				else {
+					set_bit(STRIPE_OP_COMPUTE_BLK,
+						&sh->ops.pending);
+					set_bit(STRIPE_OP_MOD_REPAIR_PD,
+						&sh->ops.pending);
+					set_bit(R5_Wantcompute,
+						&sh->dev[sh->pd_idx].flags);
+					sh->ops.target = sh->pd_idx;
+					sh->ops.count++;
+					s->uptodate++;
+				}
 			}
 		}
 	}
-	if (!test_bit(STRIPE_INSYNC, &sh->state)) {
+
+	/* check if we can clear a parity disk reconstruct */
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
+		test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+
+		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+	}
+
+	/* Wait for check parity and compute block operations to complete
+	 * before write-back
+	 */
+	if (!test_bit(STRIPE_INSYNC, &sh->state) &&
+		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending) &&
+		!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
 		struct r5dev *dev;
 		/* either failed parity check, or recovery is happening */
 		if (s->failed == 0)
@@ -2848,12 +2889,17 @@ static void handle_stripe5(struct stripe_head *sh)
 		handle_issuing_new_write_requests5(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
-	 * Any reads will already have been scheduled, so we just see if enough data
-	 * is available
+	 * Any reads will already have been scheduled, so we just see if enough
+	 * data is available.  The parity check is held off while parity
+	 * dependent operations are in flight.
 	 */
-	if (s.syncing && s.locked == 0 &&
-	    !test_bit(STRIPE_INSYNC, &sh->state))
+	if ((s.syncing && s.locked == 0 &&
+	     !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
+	     !test_bit(STRIPE_INSYNC, &sh->state)) ||
+	      test_bit(STRIPE_OP_CHECK, &sh->ops.pending) ||
+	      test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending))
 		handle_parity_checks5(conf, sh, &s, disks);
+
 	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
