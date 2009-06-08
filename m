Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZFHTZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZFHTZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZFHTXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:20 -0400
Received: from thunk.org ([69.25.196.29]:39530 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbZFHTXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 03/49] ext4: Mark the unwritten buffer_head as mapped during write_begin
Date: Mon,  8 Jun 2009 15:22:21 -0400
Message-Id: <1244488987-32564-4-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-3-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Setting BH_Unwritten buffer_heads as BH_Mapped avoids multiple
(unnecessary) calls to get_block() during the call to the write(2)
system call.  Setting BH_Unwritten buffer heads as BH_Mapped requires
that the writepages() functions can handle BH_Unwritten buffer_heads.

After this commit, things work as follows:

ext4_ext_get_block() returns unmapped, unwritten, buffer head when
called with create = 0 for prealloc space. This makes sure we handle
the read path and non-delayed allocation case correctly.  Even though
the buffer head is marked unmapped we have valid b_blocknr and b_bdev
values in the buffer_head.

ext4_da_get_block_prep() called for block resrevation will now return
mapped, unwritten, new buffer_head for prealloc space. This avoids
multiple calls to get_block() for write to same offset. By making such
buffers as BH_New, we also assure that sub-block zeroing of buffered
writes happens correctly.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    4 +-
 fs/ext4/inode.c   |   82 +++++++++++++++++++++++++++++++++-------------------
 2 files changed, 54 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a953214..ea5c476 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2872,6 +2872,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
 				goto out;
 			if (!create) {
+				if (allocated > max_blocks)
+					allocated = max_blocks;
 				/*
 				 * We have blocks reserved already.  We
 				 * return allocated blocks so that delalloc
@@ -2879,8 +2881,6 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 				 * the buffer head will be unmapped so that
 				 * a read from the block returns 0s.
 				 */
-				if (allocated > max_blocks)
-					allocated = max_blocks;
 				set_buffer_unwritten(bh_result);
 				bh_result->b_bdev = inode->i_sb->s_bdev;
 				bh_result->b_blocknr = newblock;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d7ad0bb..96f3366 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1852,7 +1852,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
  * @logical - first logical block to start assignment with
  *
  * the function goes through all passed space and put actual disk
- * block numbers into buffer heads, dropping BH_Delay
+ * block numbers into buffer heads, dropping BH_Delay and BH_Unwritten
  */
 static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 				 struct buffer_head *exbh)
@@ -1902,16 +1902,24 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 			do {
 				if (cur_logical >= logical + blocks)
 					break;
-				if (buffer_delay(bh)) {
-					bh->b_blocknr = pblock;
-					clear_buffer_delay(bh);
-					bh->b_bdev = inode->i_sb->s_bdev;
-				} else if (buffer_unwritten(bh)) {
-					bh->b_blocknr = pblock;
-					clear_buffer_unwritten(bh);
-					set_buffer_mapped(bh);
-					set_buffer_new(bh);
-					bh->b_bdev = inode->i_sb->s_bdev;
+
+				if (buffer_delay(bh) ||
+						buffer_unwritten(bh)) {
+
+					BUG_ON(bh->b_bdev != inode->i_sb->s_bdev);
+
+					if (buffer_delay(bh)) {
+						clear_buffer_delay(bh);
+						bh->b_blocknr = pblock;
+					} else {
+						/*
+						 * unwritten already should have
+						 * blocknr assigned. Verify that
+						 */
+						clear_buffer_unwritten(bh);
+						BUG_ON(bh->b_blocknr != pblock);
+					}
+
 				} else if (buffer_mapped(bh))
 					BUG_ON(bh->b_blocknr != pblock);
 
@@ -2053,7 +2061,8 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	 * We consider only non-mapped and non-allocated blocks
 	 */
 	if ((mpd->b_state  & (1 << BH_Mapped)) &&
-	    !(mpd->b_state & (1 << BH_Delay)))
+		!(mpd->b_state & (1 << BH_Delay)) &&
+		!(mpd->b_state & (1 << BH_Unwritten)))
 		return 0;
 	/*
 	 * We need to make sure the BH_Delay flag is passed down to
@@ -2205,6 +2214,17 @@ flush_it:
 	return;
 }
 
+static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
+{
+	/*
+	 * unmapped buffer is possible for holes.
+	 * delay buffer is possible with delayed allocation.
+	 * We also need to consider unwritten buffer as unmapped.
+	 */
+	return (!buffer_mapped(bh) || buffer_delay(bh) ||
+				buffer_unwritten(bh)) && buffer_dirty(bh);
+}
+
 /*
  * __mpage_da_writepage - finds extent of pages and blocks
  *
@@ -2289,8 +2309,7 @@ static int __mpage_da_writepage(struct page *page,
 			 * Otherwise we won't make progress
 			 * with the page in ext4_da_writepage
 			 */
-			if (buffer_dirty(bh) &&
-			    (!buffer_mapped(bh) || buffer_delay(bh))) {
+			if (ext4_bh_unmapped_or_delay(NULL, bh)) {
 				mpage_add_bh_to_extent(mpd, logical,
 						       bh->b_size,
 						       bh->b_state);
@@ -2318,6 +2337,14 @@ static int __mpage_da_writepage(struct page *page,
 /*
  * this is a special callback for ->write_begin() only
  * it's intention is to return mapped block or reserve space
+ *
+ * For delayed buffer_head we have BH_Mapped, BH_New, BH_Delay set.
+ * We also have b_blocknr = -1 and b_bdev initialized properly
+ *
+ * For unwritten buffer_head we have BH_Mapped, BH_New, BH_Unwritten set.
+ * We also have b_blocknr = physicalblock mapping unwritten extent and b_bdev
+ * initialized properly.
+ *
  */
 static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 				  struct buffer_head *bh_result, int create)
@@ -2353,28 +2380,23 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
-		/*
-		 * With sub-block writes into unwritten extents
-		 * we also need to mark the buffer as new so that
-		 * the unwritten parts of the buffer gets correctly zeroed.
-		 */
-		if (buffer_unwritten(bh_result))
+		if (buffer_unwritten(bh_result)) {
+			/* A delayed write to unwritten bh should
+			 * be marked new and mapped.  Mapped ensures
+			 * that we don't do get_block multiple times
+			 * when we write to the same offset and new
+			 * ensures that we do proper zero out for
+			 * partial write.
+			 */
 			set_buffer_new(bh_result);
+			set_buffer_mapped(bh_result);
+		}
 		ret = 0;
 	}
 
 	return ret;
 }
 
-static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
-{
-	/*
-	 * unmapped buffer is possible for holes.
-	 * delay buffer is possible with delayed allocation
-	 */
-	return ((!buffer_mapped(bh) || buffer_delay(bh)) && buffer_dirty(bh));
-}
-
 static int ext4_normal_get_block_write(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
@@ -2828,7 +2850,7 @@ static int ext4_da_should_update_i_disksize(struct page *page,
 	for (i = 0; i < idx; i++)
 		bh = bh->b_this_page;
 
-	if (!buffer_mapped(bh) || (buffer_delay(bh)))
+	if (!buffer_mapped(bh) || (buffer_delay(bh)) || buffer_unwritten(bh))
 		return 0;
 	return 1;
 }
-- 
1.6.3.2.1.gb9f7d.dirty

