Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbYFGBRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbYFGBRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759829AbYFGBJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:20 -0400
Received: from sous-sol.org ([216.99.217.87]:42438 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759447AbYFGBJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:09 -0400
Message-Id: <20080607010634.879061944@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:03:01 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>
Subject: [patch 46/50] md: do not compute parity unless it is on a failed drive
Content-Disposition: inline; filename=md-do-not-compute-parity-unless-it-is-on-a-failed-drive.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Williams <dan.j.williams@intel.com>

upstream commit: c337869d95011495fa181536786e74aa2d7ff031

If a block is computed (rather than read) then a check/repair operation
may be lead to believe that the data on disk is correct, when infact it
isn't.  So only compute blocks for failed devices.

This issue has been around since at least 2.6.12, but has become harder to
hit in recent kernels since most reads bypass the cache.

echo repair > /sys/block/mdN/md/sync_action will set the parity blocks to the
correct state.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/raid5.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1984,6 +1984,7 @@ static int __handle_issuing_new_read_req
 		 * have quiesced.
 		 */
 		if ((s->uptodate == disks - 1) &&
+		    (s->failed && disk_idx == s->failed_num) &&
 		    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
 			set_bit(R5_Wantcompute, &dev->flags);
@@ -2069,7 +2070,9 @@ static void handle_issuing_new_read_requ
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

-- 
