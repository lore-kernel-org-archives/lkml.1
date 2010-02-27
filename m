Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0B0HWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 02:22:11 -0500
Received: from bosmailout08.eigbox.net ([66.96.190.8]:35514 "EHLO
	bosmailout08.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab0B0HWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 02:22:06 -0500
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Feb 2010 02:22:06 EST
X-EN-OrigOutIP: 10.20.18.15
X-EN-IMPSID: muqt1d0020KWaAJ01uqt4z
Message-ID: <4B88BC8A.1000407@jaysonking.com>
Date: Sat, 27 Feb 2010 00:32:42 -0600
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Thunderbird/3.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Stable team <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jayson King <dev@jaysonking.com>
Subject: [05/11] ext4: Retry block reservation
References: <4B88BA1B.4050500@jaysonking.com>
In-Reply-To: <4B88BA1B.4050500@jaysonking.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 69.150.131.230
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Mon Sep 8 23:14:50 2008 -0400
Subject: ext4: Retry block reservation

commit 030ba6bc67b4f2bc5cd174f57785a1745c929abe upstream.

During block reservation if we don't have enough blocks left, retry
block reservation with smaller block counts.  This makes sure we try
fallocate and DIO with smaller request size and don't fail early.  The
delayed allocation reservation cannot try with smaller block count. So
retry block reservation to handle temporary disk full conditions.  Also
print free blocks details if we fail block allocation during writepages.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jayson R. King <dev@jaysonking.com>

---
 fs/ext4/balloc.c  |    8 +++++++-
 fs/ext4/inode.c   |   14 +++++++++++---
 fs/ext4/mballoc.c |    7 ++++++-
 3 files changed, 24 insertions(+), 5 deletions(-)

diff -urNp linux-2.6.27.orig/fs/ext4/balloc.c linux-2.6.27/fs/ext4/balloc.c
--- linux-2.6.27.orig/fs/ext4/balloc.c	2010-02-26 14:22:58.236252972 -0600
+++ linux-2.6.27/fs/ext4/balloc.c	2010-02-26 14:23:05.964253171 -0600
@@ -1907,10 +1907,16 @@ ext4_fsblk_t ext4_old_new_blocks(handle_
 		/*
 		 * With delalloc we already reserved the blocks
 		 */
-		if (ext4_claim_free_blocks(sbi, *count)) {
+		while (*count && ext4_claim_free_blocks(sbi, *count)) {
+			/* let others to free the space */
+			yield();
+			*count = *count >> 1;
+		}
+		if (!*count) {
 			*errp = -ENOSPC;
 			return 0;	/*return with ENOSPC error */
 		}
+		num = *count;
 	}
 	/*
 	 * Check quota for allocation of this block.
diff -urNp linux-2.6.27.orig/fs/ext4/inode.c linux-2.6.27/fs/ext4/inode.c
--- linux-2.6.27.orig/fs/ext4/inode.c	2010-02-26 14:22:58.237252599 -0600
+++ linux-2.6.27/fs/ext4/inode.c	2010-02-26 14:23:05.965252990 -0600
@@ -1549,6 +1549,7 @@ static int ext4_journalled_write_end(str
 
 static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
+	int retries = 0;
        struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
        unsigned long md_needed, mdblocks, total = 0;
 
@@ -1557,6 +1558,7 @@ static int ext4_da_reserve_space(struct 
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
+repeat:
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
 	mdblocks = ext4_calc_metadata_amount(inode, total);
@@ -1567,6 +1569,10 @@ static int ext4_da_reserve_space(struct 
 
 	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
+			yield();
+			goto repeat;
+		}
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
@@ -1864,20 +1870,18 @@ static void ext4_da_block_invalidatepage
 static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
 	int err = 0;
+	struct buffer_head new;
 	struct buffer_head *lbh = &mpd->lbh;
 	sector_t next = lbh->b_blocknr;
-	struct buffer_head new;
 
 	/*
 	 * We consider only non-mapped and non-allocated blocks
 	 */
 	if (buffer_mapped(lbh) && !buffer_delay(lbh))
 		return 0;
-
 	new.b_state = lbh->b_state;
 	new.b_blocknr = 0;
 	new.b_size = lbh->b_size;
-
 	/*
 	 * If we didn't accumulate anything
 	 * to write simply return
@@ -1910,6 +1914,10 @@ static int  mpage_da_map_blocks(struct m
 				  lbh->b_size >> mpd->inode->i_blkbits, err);
 		printk(KERN_EMERG "This should not happen.!! "
 					"Data will be lost\n");
+		if (err == -ENOSPC) {
+			printk(KERN_CRIT "Total free blocks count %lld\n",
+				ext4_count_free_blocks(mpd->inode->i_sb));
+		}
 		/* invlaidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
 				lbh->b_size >> mpd->inode->i_blkbits);
diff -urNp linux-2.6.27.orig/fs/ext4/mballoc.c linux-2.6.27/fs/ext4/mballoc.c
--- linux-2.6.27.orig/fs/ext4/mballoc.c	2010-02-26 14:22:58.238252631 -0600
+++ linux-2.6.27/fs/ext4/mballoc.c	2010-02-26 14:23:05.967252672 -0600
@@ -4651,7 +4651,12 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 		/*
 		 * With delalloc we already reserved the blocks
 		 */
-		if (ext4_claim_free_blocks(sbi, ar->len)) {
+		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
+			/* let others to free the space */
+			yield();
+			ar->len = ar->len >> 1;
+		}
+		if (!ar->len) {
 			*errp = -ENOSPC;
 			return 0;
 		}
