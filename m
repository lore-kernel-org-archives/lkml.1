Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYF0Gu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYF0Gu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758757AbYF0Gti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:49:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758713AbYF0Gth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:49:37 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jun 2008 16:49:30 +1000
Message-Id: <1080627064930.10302@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: <stable@kernel.org>
Subject: [PATCH 002 of 29] md: Don't acknowlege that stripe-expand is complete until it really is.
References: <20080627164503.9671.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We shouldn't acknowledge that a stripe has been expanded (When
reshaping a raid5 by adding a device) until the moved data has
actually been written out.  However we are currently
acknowledging (by calling md_done_sync) when the POST_XOR
is complete and before the write.

So track in s.locked whether there are pending writes, and don't
call md_done_sync yet if there are.

Note: we all set R5_LOCKED on devices which are are about to
read from.  This probably isn't technically necessary, but is
usually done when writing a block, and justifies the use of
s.locked here.

This bug can lead to a crash if an array is stopped while an reshape
is in progress.

Cc: <stable@kernel.org>
Signed-off-by: Neil Brown <neilb@suse.de>



### Diffstat output
 ./drivers/md/raid5.c |    3 +++
 1 file changed, 3 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 15:30:19.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 15:22:48.000000000 +1000
@@ -2898,6 +2898,8 @@ static void handle_stripe5(struct stripe
 
 		for (i = conf->raid_disks; i--; ) {
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			s.locked++;
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
 		}
@@ -2911,6 +2913,7 @@ static void handle_stripe5(struct stripe
 			conf->raid_disks);
 		s.locked += handle_write_operations5(sh, 1, 1);
 	} else if (s.expanded &&
+		   s.locked == 0 &&
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
