Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbZFHTbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbZFHTbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZFHTXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:49 -0400
Received: from thunk.org ([69.25.196.29]:39571 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbZFHTXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 34/49] ext4: Merge ext4_da_get_block_write() into mpage_da_map_blocks()
Date: Mon,  8 Jun 2009 15:22:52 -0400
Message-Id: <1244488987-32564-35-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-34-git-send-email-tytso@mit.edu>
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
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
 <1244488987-32564-29-git-send-email-tytso@mit.edu>
 <1244488987-32564-30-git-send-email-tytso@mit.edu>
 <1244488987-32564-31-git-send-email-tytso@mit.edu>
 <1244488987-32564-32-git-send-email-tytso@mit.edu>
 <1244488987-32564-33-git-send-email-tytso@mit.edu>
 <1244488987-32564-34-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The static function ext4_da_get_block_write() was only used by
mpage_da_map_blocks().  So to simplify the code, merge that function
into mpage_da_map_blocks().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |  110 +++++++++++++++++++++---------------------------------
 1 files changed, 43 insertions(+), 67 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e6113c3..bfe50a2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2006,57 +2006,6 @@ static void ext4_print_free_blocks(struct inode *inode)
 }
 
 /*
- * This function is used by mpage_da_map_blocks().  We separate it out
- * as a separate function just to make life easier, and because
- * mpage_da_map_blocks() used to be a generic function that took a
- * get_block_t.
- */
-static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
-				   struct buffer_head *bh_result)
-{
-	int ret;
-	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
-	loff_t disksize = EXT4_I(inode)->i_disksize;
-	handle_t *handle = NULL;
-
-	handle = ext4_journal_current_handle();
-	BUG_ON(!handle);
-	ret = ext4_get_blocks(handle, inode, iblock, max_blocks,
-			      bh_result, EXT4_GET_BLOCKS_CREATE|
-			      EXT4_GET_BLOCKS_DELALLOC_RESERVE);
-	if (ret <= 0)
-		return ret;
-
-	bh_result->b_size = (ret << inode->i_blkbits);
-
-	if (ext4_should_order_data(inode)) {
-		int retval;
-		retval = ext4_jbd2_file_inode(handle, inode);
-		if (retval)
-			/*
-			 * Failed to add inode for ordered mode. Don't
-			 * update file size
-			 */
-			return retval;
-	}
-
-	/*
-	 * Update on-disk size along with block allocation we don't
-	 * use EXT4_GET_BLOCKS_EXTEND_DISKSIZE as size may change
-	 * within already allocated block -bzzz
-	 */
-	disksize = ((loff_t) iblock + ret) << inode->i_blkbits;
-	if (disksize > i_size_read(inode))
-		disksize = i_size_read(inode);
-	if (disksize > EXT4_I(inode)->i_disksize) {
-		ext4_update_i_disksize(inode, disksize);
-		ret = ext4_mark_inode_dirty(handle, inode);
-		return ret;
-	}
-	return 0;
-}
-
-/*
  * mpage_da_map_blocks - go through given space
  *
  * @mpd - bh describing space
@@ -2066,9 +2015,12 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
  */
 static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
-	int err = 0;
+	int err, blks;
 	struct buffer_head new;
-	sector_t next;
+	sector_t next = mpd->b_blocknr;
+	unsigned max_blocks = mpd->b_size >> mpd->inode->i_blkbits;
+	loff_t disksize = EXT4_I(mpd->inode)->i_disksize;
+	handle_t *handle = NULL;
 
 	/*
 	 * We consider only non-mapped and non-allocated blocks
@@ -2077,6 +2029,16 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 		!(mpd->b_state & (1 << BH_Delay)) &&
 		!(mpd->b_state & (1 << BH_Unwritten)))
 		return 0;
+
+	/*
+	 * If we didn't accumulate anything to write simply return
+	 */
+	if (!mpd->b_size)
+		return 0;
+
+	handle = ext4_journal_current_handle();
+	BUG_ON(!handle);
+
 	/*
 	 * We need to make sure the BH_Delay flag is passed down to
 	 * ext4_da_get_block_write(), since it calls ext4_get_blocks()
@@ -2092,18 +2054,11 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	 * EXT4_GET_BLOCKS_DELALLOC_RESERVE flag.
 	 */
 	new.b_state = mpd->b_state & (1 << BH_Delay);
-	new.b_blocknr = 0;
-	new.b_size = mpd->b_size;
-	next = mpd->b_blocknr;
-	/*
-	 * If we didn't accumulate anything
-	 * to write simply return
-	 */
-	if (!new.b_size)
-		return 0;
-
-	err = ext4_da_get_block_write(mpd->inode, next, &new);
-	if (err) {
+	blks = ext4_get_blocks(handle, mpd->inode, next, max_blocks,
+			       &new, EXT4_GET_BLOCKS_CREATE|
+			       EXT4_GET_BLOCKS_DELALLOC_RESERVE);
+	if (blks < 0) {
+		err = blks;
 		/*
 		 * If get block returns with error we simply
 		 * return. Later writepage will redirty the page and
@@ -2136,12 +2091,14 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 		if (err == -ENOSPC) {
 			ext4_print_free_blocks(mpd->inode);
 		}
-		/* invlaidate all the pages */
+		/* invalidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
 				mpd->b_size >> mpd->inode->i_blkbits);
 		return err;
 	}
-	BUG_ON(new.b_size == 0);
+	BUG_ON(blks == 0);
+
+	new.b_size = (blks << mpd->inode->i_blkbits);
 
 	if (buffer_new(&new))
 		__unmap_underlying_blocks(mpd->inode, &new);
@@ -2154,6 +2111,25 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	    (mpd->b_state & (1 << BH_Unwritten)))
 		mpage_put_bnr_to_bhs(mpd, next, &new);
 
+	if (ext4_should_order_data(mpd->inode)) {
+		err = ext4_jbd2_file_inode(handle, mpd->inode);
+		if (err)
+			return err;
+	}
+
+	/*
+	 * Update on-disk size along with block allocation we don't
+	 * use EXT4_GET_BLOCKS_EXTEND_DISKSIZE as size may change
+	 * within already allocated block -bzzz
+	 */
+	disksize = ((loff_t) next + blks) << mpd->inode->i_blkbits;
+	if (disksize > i_size_read(mpd->inode))
+		disksize = i_size_read(mpd->inode);
+	if (disksize > EXT4_I(mpd->inode)->i_disksize) {
+		ext4_update_i_disksize(mpd->inode, disksize);
+		return ext4_mark_inode_dirty(handle, mpd->inode);
+	}
+
 	return 0;
 }
 
-- 
1.6.3.2.1.gb9f7d.dirty

