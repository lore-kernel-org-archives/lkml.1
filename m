Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZFHTeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZFHTeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbZFHTYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:24:00 -0400
Received: from thunk.org ([69.25.196.29]:39625 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230AbZFHTXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
Subject: [PATCH 16/49] ext4: Don't avoid using BLOCK_UNINIT block groups in mballoc
Date: Mon,  8 Jun 2009 15:22:34 -0400
Message-Id: <1244488987-32564-17-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-16-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By avoiding the use of not-yet-used block groups (i.e., block groups
with the BLOCK_UNINIT flag), mballoc had a tendency to create large
files with large non-contiguous gaps.  In addition avoiding the use of
new block groups had a tendency to push regular file data into the
first block group in a flex_bg group, which slows down the speed of
e2fsck pass 2, since it has a tendency to seek much more.  For
example:

               Before Patch                       After Patch
              Time in seconds                   Time in seconds
            Real /  User/  Sys   MB/s      Real /  User/  Sys    MB/s
Pass 1      8.52 / 2.21 / 0.46  20.43      8.84 / 4.97 / 1.11   19.68
Pass 2     21.16 / 1.02 / 1.86  11.30      6.54 / 1.77 / 1.78   36.39
Pass 3      0.01 / 0.00 / 0.00 139.00      0.01 / 0.01 / 0.00  128.90
Pass 4      0.16 / 0.15 / 0.00   0.00      0.17 / 0.17 / 0.00    0.00
Pass 5      2.52 / 1.99 / 0.09   0.79      2.31 / 1.78 / 0.06    0.86
Total      32.40 / 5.11 / 2.49  12.81     17.99 / 8.75 / 2.98   23.01

This was on a sample 80 gig root filesystem which was approximately
50% full.  Note the improved e2fsck pass 2 performance, by over a
factor of 3, due to a decreased number of seeks.  (The total amount of
I/O in pass 2 was unchanged; the layout of the directory blocks was
simply much better from e2fsck's's perspective.)

Other changes as a result of this patch on this sample filesystem:

                             Before Patch    After Patch
# of non-contig files           762             779
# of non-contig directories     571             570
# of BLOCK_UNINIT bg's          307             293
# of INODE_UNINIT bg's          503             503

Out of 640 block groups, of which 333 were in use, this patch caused
an extra 14 block groups to be utilized.  The number of non-contiguous
files did go up slightly, but when measured against the 99.9% of the
files (603,154) which were contiguously allocated, this is pretty
insignificant.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andreas Dilger <adilger@sun.com>
---
 fs/ext4/mballoc.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c3af9e6..dbd47ea 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1728,7 +1728,6 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 	unsigned free, fragments;
 	unsigned i, bits;
 	int flex_size = ext4_flex_bg_size(EXT4_SB(ac->ac_sb));
-	struct ext4_group_desc *desc;
 	struct ext4_group_info *grp = ext4_get_group_info(ac->ac_sb, group);
 
 	BUG_ON(cr < 0 || cr >= 4);
@@ -1744,10 +1743,6 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 	switch (cr) {
 	case 0:
 		BUG_ON(ac->ac_2order == 0);
-		/* If this group is uninitialized, skip it initially */
-		desc = ext4_get_group_desc(ac->ac_sb, group, NULL);
-		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))
-			return 0;
 
 		/* Avoid using the first bg of a flexgroup for data files */
 		if ((ac->ac_flags & EXT4_MB_HINT_DATA) &&
@@ -2067,9 +2062,7 @@ repeat:
 
 			ac->ac_groups_scanned++;
 			desc = ext4_get_group_desc(sb, group, NULL);
-			if (cr == 0 || (desc->bg_flags &
-					cpu_to_le16(EXT4_BG_BLOCK_UNINIT) &&
-					ac->ac_2order != 0))
+			if (cr == 0)
 				ext4_mb_simple_scan_group(ac, &e4b);
 			else if (cr == 1 &&
 					ac->ac_g_ex.fe_len == sbi->s_stripe)
-- 
1.6.3.2.1.gb9f7d.dirty

