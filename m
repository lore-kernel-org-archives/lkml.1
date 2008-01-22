Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbYAVDPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbYAVDPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbYAVDGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:06:54 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65238 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757757AbYAVDGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:06:48 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 29/49] ext4: Make ext4_get_blocks_wrap take the truncate_mutex early.
Date: Mon, 21 Jan 2008 22:02:08 -0500
Message-Id: <1200970948-17903-30-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-29-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

When doing a migrate from ext3 to ext4 inode we need to make sure the test
for inode type and walking inode data happens inside  lock. To make this
happen move truncate_mutex early before checking the i_flags.


This actually should enable us to remove the verify_chain().

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c       |    9 ++++--
 fs/ext4/inode.c         |   69 +++++-----------------------------------------
 include/linux/ext4_fs.h |    2 +
 3 files changed, 16 insertions(+), 64 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8593e59..ec5019f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2129,6 +2129,10 @@ out:
 	return err ? err : allocated;
 }
 
+/*
+ * Need to be called with
+ * mutex_lock(&EXT4_I(inode)->truncate_mutex);
+ */
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
@@ -2144,7 +2148,6 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	__clear_bit(BH_New, &bh_result->b_state);
 	ext_debug("blocks %u/%lu requested for inode %u\n",
 			iblock, max_blocks, inode->i_ino);
-	mutex_lock(&EXT4_I(inode)->truncate_mutex);
 
 	/* check in cache */
 	goal = ext4_ext_in_cache(inode, iblock, &newex);
@@ -2318,8 +2321,6 @@ out2:
 		ext4_ext_drop_refs(path);
 		kfree(path);
 	}
-	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
-
 	return err ? err : allocated;
 }
 
@@ -2449,6 +2450,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	 * modify 1 super block, 1 block bitmap and 1 group descriptor.
 	 */
 	credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb) + 3;
+	mutex_lock(&EXT4_I(inode)->truncate_mutex)
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		block = block + ret;
@@ -2505,6 +2507,7 @@ retry:
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex)
 	/*
 	 * Time to update the file size.
 	 * Update only when preallocation was requested beyond the file size.
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index eaace13..71c7ad0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -243,13 +243,6 @@ static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
 	p->bh = bh;
 }
 
-static int verify_chain(Indirect *from, Indirect *to)
-{
-	while (from <= to && from->key == *from->p)
-		from++;
-	return (from > to);
-}
-
 /**
  *	ext4_block_to_path - parse the block number into array of offsets
  *	@inode: inode in question (we are only interested in its superblock)
@@ -348,10 +341,11 @@ static int ext4_block_to_path(struct inode *inode,
  *		(pointer to last triple returned, *@err == 0)
  *	or when it gets an IO error reading an indirect block
  *		(ditto, *@err == -EIO)
- *	or when it notices that chain had been changed while it was reading
- *		(ditto, *@err == -EAGAIN)
  *	or when it reads all @depth-1 indirect blocks successfully and finds
  *	the whole chain, all way to the data (returns %NULL, *err == 0).
+ *
+ *      Need to be called with
+ *      mutex_lock(&EXT4_I(inode)->truncate_mutex)
  */
 static Indirect *ext4_get_branch(struct inode *inode, int depth,
 				 ext4_lblk_t  *offsets,
@@ -370,9 +364,6 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 		bh = sb_bread(sb, le32_to_cpu(p->key));
 		if (!bh)
 			goto failure;
-		/* Reader: pointers */
-		if (!verify_chain(chain, p))
-			goto changed;
 		add_chain(++p, bh, (__le32*)bh->b_data + *++offsets);
 		/* Reader: end */
 		if (!p->key)
@@ -380,10 +371,6 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	}
 	return NULL;
 
-changed:
-	brelse(bh);
-	*err = -EAGAIN;
-	goto no_block;
 failure:
 	*err = -EIO;
 no_block:
@@ -787,6 +774,10 @@ err_out:
  * return > 0, # of blocks mapped or allocated.
  * return = 0, if plain lookup failed.
  * return < 0, error case.
+ *
+ *
+ * Need to be called with
+ * mutex_lock(&EXT4_I(inode)->truncate_mutex)
  */
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		ext4_lblk_t iblock, unsigned long maxblocks,
@@ -825,18 +816,6 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		while (count < maxblocks && count <= blocks_to_boundary) {
 			ext4_fsblk_t blk;
 
-			if (!verify_chain(chain, partial)) {
-				/*
-				 * Indirect block might be removed by
-				 * truncate while we were reading it.
-				 * Handling of that case: forget what we've
-				 * got now. Flag the err as EAGAIN, so it
-				 * will reread.
-				 */
-				err = -EAGAIN;
-				count = 0;
-				break;
-			}
 			blk = le32_to_cpu(*(chain[depth-1].p + count));
 
 			if (blk == first_block + count)
@@ -844,44 +823,13 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 			else
 				break;
 		}
-		if (err != -EAGAIN)
-			goto got_it;
+		goto got_it;
 	}
 
 	/* Next simple case - plain lookup or failed read of indirect block */
 	if (!create || err == -EIO)
 		goto cleanup;
 
-	mutex_lock(&ei->truncate_mutex);
-
-	/*
-	 * If the indirect block is missing while we are reading
-	 * the chain(ext4_get_branch() returns -EAGAIN err), or
-	 * if the chain has been changed after we grab the semaphore,
-	 * (either because another process truncated this branch, or
-	 * another get_block allocated this branch) re-grab the chain to see if
-	 * the request block has been allocated or not.
-	 *
-	 * Since we already block the truncate/other get_block
-	 * at this point, we will have the current copy of the chain when we
-	 * splice the branch into the tree.
-	 */
-	if (err == -EAGAIN || !verify_chain(chain, partial)) {
-		while (partial > chain) {
-			brelse(partial->bh);
-			partial--;
-		}
-		partial = ext4_get_branch(inode, depth, offsets, chain, &err);
-		if (!partial) {
-			count++;
-			mutex_unlock(&ei->truncate_mutex);
-			if (err)
-				goto cleanup;
-			clear_buffer_new(bh_result);
-			goto got_it;
-		}
-	}
-
 	/*
 	 * Okay, we need to do block allocation.  Lazily initialize the block
 	 * allocation info here if necessary
@@ -923,7 +871,6 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	*/
 	if (!err && extend_disksize && inode->i_size > ei->i_disksize)
 		ei->i_disksize = inode->i_size;
-	mutex_unlock(&ei->truncate_mutex);
 	if (err)
 		goto cleanup;
 
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 55a376e..583049c 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -1113,6 +1113,7 @@ ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			int create, int extend_disksize)
 {
 	int retval;
+	mutex_lock(&EXT4_I(inode)->truncate_mutex);
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		retval = ext4_ext_get_blocks(handle, inode,
 						(ext4_lblk_t)block, max_blocks,
@@ -1122,6 +1123,7 @@ ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 						(ext4_lblk_t)block, max_blocks,
 						bh, create, extend_disksize);
 	}
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
 	return retval;
 }
 
-- 
1.5.4.rc3.31.g1271-dirty

