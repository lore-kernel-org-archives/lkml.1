Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYE0Gcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYE0Gcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbYE0GcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:32:14 -0400
Received: from mx1.suse.de ([195.135.220.2]:53165 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbYE0GcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:32:10 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 27 May 2008 16:32:03 +1000
Message-Id: <1080527063203.16418@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@kernel.org>
Subject: [PATCH 001 of 3] md: md: fix prexor vs sync_request race
References: <20080527162558.16305.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dan Williams <dan.j.williams@intel.com>

During the initial array synchronization process there is a window between
when a prexor operation is scheduled to a specific stripe and when it
completes for a sync_request to be scheduled to the same stripe.  When this
happens the prexor completes and the stripe is unconditionally marked
"insync", effectively canceling the sync_request for the stripe.  Prior to
2.6.23 this was not a problem because the prexor operation was done under
sh->lock.  The effect in older kernels being that the prexor would still
erroneously mark the stripe "insync", but sync_request would be held off
and re-mark the stripe as "!in_sync".

Change the write completion logic to not mark the stripe "in_sync" if
a prexor was performed. The effect of the change is to sometimes not
set STRIPE_INSYNC.  The worst this can do is cause the resync to stall
waiting for STRIPE_INSYNC to be set.  If this were happening, then
STRIPE_SYNCING would be set and handle_issuing_new_read_requests would
cause all available blocks to eventually be read, at which point
prexor would never be used on that stripe any more and STRIPE_INSYNC
would eventually be set.

echo repair > /sys/block/mdN/md/sync_action will correct arrays that may
have lost this race.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    5 +++++
 1 file changed, 5 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-05-27 16:24:02.000000000 +1000
+++ ./drivers/md/raid5.c	2008-05-27 16:24:18.000000000 +1000
@@ -2645,6 +2645,7 @@ static void handle_stripe5(struct stripe
 	struct r5dev *dev;
 	unsigned long pending = 0;
 	mdk_rdev_t *blocked_rdev = NULL;
+	int prexor;
 
 	memset(&s, 0, sizeof(s));
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d "
@@ -2774,9 +2775,11 @@ static void handle_stripe5(struct stripe
 	/* leave prexor set until postxor is done, allows us to distinguish
 	 * a rmw from a rcw during biodrain
 	 */
+	prexor = 0;
 	if (test_bit(STRIPE_OP_PREXOR, &sh->ops.complete) &&
 		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
 
+		prexor = 1;
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.ack);
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
@@ -2810,6 +2813,8 @@ static void handle_stripe5(struct stripe
 				if (!test_and_set_bit(
 				    STRIPE_OP_IO, &sh->ops.pending))
 					sh->ops.count++;
+				if (prexor)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    (i == sh->pd_idx && s.failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);
