Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZFHT21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZFHT21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZFHTXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:36 -0400
Received: from thunk.org ([69.25.196.29]:39576 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbZFHTXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 32/49] ext4: Add documentation to the ext4_*get_block* functions
Date: Mon,  8 Jun 2009 15:22:50 -0400
Message-Id: <1244488987-32564-33-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-32-git-send-email-tytso@mit.edu>
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
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds more documentation to various internal functions in
fs/ext4/inode.c, most notably ext4_ind_get_blocks(),
ext4_da_get_block_write(), ext4_da_get_block_prep(),
ext4_normal_get_block_write().

In addition, the static function ext4_normal_get_block_write() has
been renamed noalloc_get_block_write(), since it is used in many
places far beyond ext4_normal_writepage().

Plenty of warnings have been added to the noalloc_get_block_write()
function, since the way it is used is amazingly fragile.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   86 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8b7564d..fd5f27a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -892,6 +892,10 @@ err_out:
 }
 
 /*
+ * The ext4_ind_get_blocks() function handles non-extents inodes
+ * (i.e., using the traditional indirect/double-indirect i_blocks
+ * scheme) for ext4_get_blocks().
+ *
  * Allocation strategy is simple: if we have to allocate something, we will
  * have to go the whole way to leaf. So let's do it before attaching anything
  * to tree, set linkage between the newborn blocks, write them if sync is
@@ -909,10 +913,11 @@ err_out:
  * return = 0, if plain lookup failed.
  * return < 0, error case.
  *
- *
- * Need to be called with
- * down_read(&EXT4_I(inode)->i_data_sem) if not allocating file system block
- * (ie, create is zero). Otherwise down_write(&EXT4_I(inode)->i_data_sem)
+ * The ext4_ind_get_blocks() function should be called with
+ * down_write(&EXT4_I(inode)->i_data_sem) if allocating filesystem
+ * blocks (i.e., flags has EXT4_GET_BLOCKS_CREATE set) or
+ * down_read(&EXT4_I(inode)->i_data_sem) if not allocating file system
+ * blocks.
  */
 static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 				  ext4_lblk_t iblock, unsigned int maxblocks,
@@ -1152,8 +1157,8 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 	clear_buffer_unwritten(bh);
 
 	/*
-	 * Try to see if we can get  the block without requesting
-	 * for new file system block.
+	 * Try to see if we can get the block without requesting a new
+	 * file system block.
 	 */
 	down_read((&EXT4_I(inode)->i_data_sem));
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
@@ -2000,6 +2005,12 @@ static void ext4_print_free_blocks(struct inode *inode)
 	return;
 }
 
+/*
+ * This function is used by mpage_da_map_blocks().  We separate it out
+ * as a separate function just to make life easier, and because
+ * mpage_da_map_blocks() used to be a generic function that took a
+ * get_block_t.
+ */
 static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result)
 {
@@ -2031,8 +2042,8 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 
 	/*
 	 * Update on-disk size along with block allocation we don't
-	 * use 'extend_disksize' as size may change within already
-	 * allocated block -bzzz
+	 * use EXT4_GET_BLOCKS_EXTEND_DISKSIZE as size may change
+	 * within already allocated block -bzzz
 	 */
 	disksize = ((loff_t) iblock + ret) << inode->i_blkbits;
 	if (disksize > i_size_read(inode))
@@ -2338,8 +2349,9 @@ static int __mpage_da_writepage(struct page *page,
 }
 
 /*
- * this is a special callback for ->write_begin() only
- * it's intention is to return mapped block or reserve space
+ * This is a special get_blocks_t callback which is used by
+ * ext4_da_write_begin().  It will either return mapped block or
+ * reserve space for a single block.
  *
  * For delayed buffer_head we have BH_Mapped, BH_New, BH_Delay set.
  * We also have b_blocknr = -1 and b_bdev initialized properly
@@ -2347,7 +2359,6 @@ static int __mpage_da_writepage(struct page *page,
  * For unwritten buffer_head we have BH_Mapped, BH_New, BH_Unwritten set.
  * We also have b_blocknr = physicalblock mapping unwritten extent and b_bdev
  * initialized properly.
- *
  */
 static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 				  struct buffer_head *bh_result, int create)
@@ -2400,7 +2411,23 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
-static int ext4_normal_get_block_write(struct inode *inode, sector_t iblock,
+/*
+ * This function is used as a standard get_block_t calback function
+ * when there is no desire to allocate any blocks.  It is used as a
+ * callback function for block_prepare_write(), nobh_writepage(), and
+ * block_write_full_page().  These functions should only try to map a
+ * single block at a time.
+ *
+ * Since this function doesn't do block allocations even if the caller
+ * requests it by passing in create=1, it is critically important that
+ * any caller checks to make sure that any buffer heads are returned
+ * by this function are either all already mapped or marked for
+ * delayed allocation before calling nobh_writepage() or
+ * block_write_full_page().  Otherwise, b_blocknr could be left
+ * unitialized, and the page write functions will be taken by
+ * surprise.
+ */
+static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
 	int ret = 0;
@@ -2419,10 +2446,11 @@ static int ext4_normal_get_block_write(struct inode *inode, sector_t iblock,
 }
 
 /*
- * get called vi ext4_da_writepages after taking page lock (have journal handle)
- * get called via journal_submit_inode_data_buffers (no journal handle)
- * get called via shrink_page_list via pdflush (no journal handle)
- * or grab_page_cache when doing write_begin (have journal handle)
+ * This function can get called via...
+ *   - ext4_da_writepages after taking page lock (have journal handle)
+ *   - journal_submit_inode_data_buffers (no journal handle)
+ *   - shrink_page_list via pdflush (no journal handle)
+ *   - grab_page_cache when doing write_begin (have journal handle)
  */
 static int ext4_da_writepage(struct page *page,
 				struct writeback_control *wbc)
@@ -2473,7 +2501,7 @@ static int ext4_da_writepage(struct page *page,
 		 * do block allocation here.
 		 */
 		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
-						ext4_normal_get_block_write);
+					  noalloc_get_block_write);
 		if (!ret) {
 			page_bufs = page_buffers(page);
 			/* check whether all are mapped and non delay */
@@ -2498,11 +2526,10 @@ static int ext4_da_writepage(struct page *page,
 	}
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-		ret = nobh_writepage(page, ext4_normal_get_block_write, wbc);
+		ret = nobh_writepage(page, noalloc_get_block_write, wbc);
 	else
-		ret = block_write_full_page(page,
-						ext4_normal_get_block_write,
-						wbc);
+		ret = block_write_full_page(page, noalloc_get_block_write,
+					    wbc);
 
 	return ret;
 }
@@ -2814,7 +2841,7 @@ retry:
 	*pagep = page;
 
 	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-							ext4_da_get_block_prep);
+				ext4_da_get_block_prep);
 	if (ret < 0) {
 		unlock_page(page);
 		ext4_journal_stop(handle);
@@ -3122,12 +3149,10 @@ static int __ext4_normal_writepage(struct page *page,
 	struct inode *inode = page->mapping->host;
 
 	if (test_opt(inode->i_sb, NOBH))
-		return nobh_writepage(page,
-					ext4_normal_get_block_write, wbc);
+		return nobh_writepage(page, noalloc_get_block_write, wbc);
 	else
-		return block_write_full_page(page,
-						ext4_normal_get_block_write,
-						wbc);
+		return block_write_full_page(page, noalloc_get_block_write,
+					     wbc);
 }
 
 static int ext4_normal_writepage(struct page *page,
@@ -3179,7 +3204,7 @@ static int __ext4_journalled_writepage(struct page *page,
 	int err;
 
 	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
-					ext4_normal_get_block_write);
+				  noalloc_get_block_write);
 	if (ret != 0)
 		goto out_unlock;
 
@@ -3264,9 +3289,8 @@ static int ext4_journalled_writepage(struct page *page,
 		 * really know unless we go poke around in the buffer_heads.
 		 * But block_write_full_page will do the right thing.
 		 */
-		return block_write_full_page(page,
-						ext4_normal_get_block_write,
-						wbc);
+		return block_write_full_page(page, noalloc_get_block_write,
+					     wbc);
 	}
 no_write:
 	redirty_page_for_writepage(wbc, page);
-- 
1.6.3.2.1.gb9f7d.dirty

