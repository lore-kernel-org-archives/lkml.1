Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbYE0GdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbYE0GdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbYE0Gc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:32:29 -0400
Received: from mx1.suse.de ([195.135.220.2]:53191 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122AbYE0GcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:32:24 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 27 May 2008 16:32:17 +1000
Message-Id: <1080527063217.16444@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@kernel.org>
Subject: [PATCH 003 of 3] md: Do not compute parity unless it is on a failed drive
References: <20080527162558.16305.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dan Williams <dan.j.williams@intel.com>

If a block is computed (rather than read) then a check/repair operation
may be lead to believe that the data on disk is correct, when infact it
isn't.  So only compute blocks for failed devices.

This issue has been around since at least 2.6.12, but has become harder to hit
in recent kernels since most reads bypass the cache.

echo repair > /sys/block/mdN/md/sync_action will set the parity blocks to the
correct state.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-05-27 16:24:18.000000000 +1000
+++ ./drivers/md/raid5.c	2008-05-27 16:24:41.000000000 +1000
@@ -2002,6 +2002,7 @@ static int __handle_issuing_new_read_req
 		 * have quiesced.
 		 */
 		if ((s->uptodate == disks - 1) &&
+		    (s->failed && disk_idx == s->failed_num) &&
 		    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
 			set_bit(R5_Wantcompute, &dev->flags);
@@ -2087,7 +2088,9 @@ static void handle_issuing_new_read_requ
 			/* we would like to get this block, possibly
 			 * by computing it, but we might not be able to
 			 */
-			if (s->uptodate == disks-1) {
+			if ((s->uptodate == disks - 1) &&
+			    (s->failed && (i == r6s->failed_num[0] ||
+					   i == r6s->failed_num[1]))) {
 				pr_debug("Computing stripe %llu block %d\n",
 				       (unsigned long long)sh->sector, i);
 				compute_block_1(sh, i, 0);
