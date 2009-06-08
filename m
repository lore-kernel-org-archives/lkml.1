Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZFHTat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZFHTat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZFHTXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:46 -0400
Received: from thunk.org ([69.25.196.29]:39594 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbZFHTXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 31/49] ext4: Define a new set of flags for ext4_get_blocks()
Date: Mon,  8 Jun 2009 15:22:49 -0400
Message-Id: <1244488987-32564-32-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-31-git-send-email-tytso@mit.edu>
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
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions ext4_get_blocks(), ext4_ext_get_blocks(), and
ext4_ind_get_blocks() used an ad-hoc set of integer variables used as
boolean flags passed in as arguments.  Use a single flags parameter
and a setandard set of bitfield flags instead.  This saves space on
the call stack, and it also makes the code a bit more understandable.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/dir.c     |    2 +-
 fs/ext4/ext4.h    |   22 ++++++++++++++------
 fs/ext4/extents.c |   22 ++++++++++----------
 fs/ext4/inode.c   |   57 +++++++++++++++++++++++++++-------------------------
 4 files changed, 57 insertions(+), 46 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 052d637..9dc9316 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -131,7 +131,7 @@ static int ext4_readdir(struct file *filp,
 		struct buffer_head *bh = NULL;
 
 		map_bh.b_state = 0;
-		err = ext4_get_blocks(NULL, inode, blk, 1, &map_bh, 0, 0, 0);
+		err = ext4_get_blocks(NULL, inode, blk, 1, &map_bh, 0);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5dc8368..17feb4a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -314,10 +314,20 @@ struct ext4_new_group_data {
 };
 
 /*
- * Following is used by preallocation code to tell get_blocks() that we
- * want uninitialzed extents.
+ * Flags used by ext4_get_blocks()
  */
-#define EXT4_CREATE_UNINITIALIZED_EXT		2
+	/* Allocate any needed blocks and/or convert an unitialized
+	   extent to be an initialized ext4 */
+#define EXT4_GET_BLOCKS_CREATE			1
+	/* Request the creation of an unitialized extent */
+#define EXT4_GET_BLOCKS_UNINIT_EXT		2
+#define EXT4_GET_BLOCKS_CREATE_UNINIT_EXT	(EXT4_GET_BLOCKS_UNINIT_EXT|\
+						 EXT4_GET_BLOCKS_CREATE)
+	/* Update the ext4_inode_info i_disksize field */
+#define EXT4_GET_BLOCKS_EXTEND_DISKSIZE		4
+	/* Caller is from the delayed allocation writeout path,
+	   so the filesystem blocks have already been accounted for */
+#define EXT4_GET_BLOCKS_DELALLOC_RESERVE	8
 
 /*
  * ioctl commands
@@ -1610,8 +1620,7 @@ extern int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks,
 				       int chunk);
 extern int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			       ext4_lblk_t iblock, unsigned int max_blocks,
-			       struct buffer_head *bh_result,
-			       int create, int extend_disksize);
+			       struct buffer_head *bh_result, int flags);
 extern void ext4_ext_truncate(struct inode *);
 extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
@@ -1619,8 +1628,7 @@ extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
 extern int ext4_get_blocks(handle_t *handle, struct inode *inode,
 			   sector_t block, unsigned int max_blocks,
-			   struct buffer_head *bh, int create,
-			   int extend_disksize, int flag);
+			   struct buffer_head *bh, int flags);
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7e7d02d..27c383c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2784,7 +2784,7 @@ fix_extent_len:
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock,
 			unsigned int max_blocks, struct buffer_head *bh_result,
-			int create, int extend_disksize)
+			int flags)
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent_header *eh;
@@ -2803,7 +2803,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	cache_type = ext4_ext_in_cache(inode, iblock, &newex);
 	if (cache_type) {
 		if (cache_type == EXT4_EXT_CACHE_GAP) {
-			if (!create) {
+			if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
 				/*
 				 * block isn't allocated yet and
 				 * user doesn't want to allocate it
@@ -2869,9 +2869,9 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 							EXT4_EXT_CACHE_EXTENT);
 				goto out;
 			}
-			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
+			if (flags & EXT4_GET_BLOCKS_UNINIT_EXT)
 				goto out;
-			if (!create) {
+			if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
 				if (allocated > max_blocks)
 					allocated = max_blocks;
 				/*
@@ -2903,7 +2903,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	 * requested block isn't allocated yet;
 	 * we couldn't try to create block if create flag is zero
 	 */
-	if (!create) {
+	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
 		/*
 		 * put just found gap into cache to speed up
 		 * subsequent requests
@@ -2932,10 +2932,10 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	 * EXT_UNINIT_MAX_LEN.
 	 */
 	if (max_blocks > EXT_INIT_MAX_LEN &&
-	    create != EXT4_CREATE_UNINITIALIZED_EXT)
+	    !(flags & EXT4_GET_BLOCKS_UNINIT_EXT))
 		max_blocks = EXT_INIT_MAX_LEN;
 	else if (max_blocks > EXT_UNINIT_MAX_LEN &&
-		 create == EXT4_CREATE_UNINITIALIZED_EXT)
+		 (flags & EXT4_GET_BLOCKS_UNINIT_EXT))
 		max_blocks = EXT_UNINIT_MAX_LEN;
 
 	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
@@ -2966,7 +2966,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	/* try to insert new extent into found leaf and return */
 	ext4_ext_store_pblock(&newex, newblock);
 	newex.ee_len = cpu_to_le16(ar.len);
-	if (create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
+	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT)  /* Mark uninitialized */
 		ext4_ext_mark_uninitialized(&newex);
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
 	if (err) {
@@ -2983,7 +2983,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	newblock = ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
 outnew:
-	if (extend_disksize) {
+	if (flags & EXT4_GET_BLOCKS_EXTEND_DISKSIZE) {
 		disksize = ((loff_t) iblock + ar.len) << inode->i_blkbits;
 		if (disksize > i_size_read(inode))
 			disksize = i_size_read(inode);
@@ -2994,7 +2994,7 @@ outnew:
 	set_buffer_new(bh_result);
 
 	/* Cache only when it is _not_ an uninitialized extent */
-	if (create != EXT4_CREATE_UNINITIALIZED_EXT)
+	if ((flags & EXT4_GET_BLOCKS_UNINIT_EXT) == 0)
 		ext4_ext_put_in_cache(inode, iblock, allocated, newblock,
 						EXT4_EXT_CACHE_EXTENT);
 out:
@@ -3153,7 +3153,7 @@ retry:
 		map_bh.b_state = 0;
 		ret = ext4_get_blocks(handle, inode, block,
 				      max_blocks, &map_bh,
-				      EXT4_CREATE_UNINITIALIZED_EXT, 0, 0);
+				      EXT4_GET_BLOCKS_CREATE_UNINIT_EXT);
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
 			WARN_ON(ret <= 0);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a9a9b9b..8b7564d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -917,7 +917,7 @@ err_out:
 static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 				  ext4_lblk_t iblock, unsigned int maxblocks,
 				  struct buffer_head *bh_result,
-				  int create, int extend_disksize)
+				  int flags)
 {
 	int err = -EIO;
 	ext4_lblk_t offsets[4];
@@ -934,7 +934,7 @@ static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 
 
 	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
-	J_ASSERT(handle != NULL || create == 0);
+	J_ASSERT(handle != NULL || (flags & EXT4_GET_BLOCKS_CREATE) == 0);
 	depth = ext4_block_to_path(inode, iblock, offsets,
 					&blocks_to_boundary);
 
@@ -963,7 +963,7 @@ static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	/* Next simple case - plain lookup or failed read of indirect block */
-	if (!create || err == -EIO)
+	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0 || err == -EIO)
 		goto cleanup;
 
 	/*
@@ -1002,7 +1002,7 @@ static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 	 * protect it if you're about to implement concurrent
 	 * ext4_get_block() -bzzz
 	*/
-	if (!err && extend_disksize) {
+	if (!err && (flags & EXT4_GET_BLOCKS_EXTEND_DISKSIZE)) {
 		disksize = ((loff_t) iblock + count) << inode->i_blkbits;
 		if (disksize > i_size_read(inode))
 			disksize = i_size_read(inode);
@@ -1144,7 +1144,7 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
  */
 int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 		    unsigned int max_blocks, struct buffer_head *bh,
-		    int create, int extend_disksize, int flag)
+		    int flags)
 {
 	int retval;
 
@@ -1158,15 +1158,15 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 	down_read((&EXT4_I(inode)->i_data_sem));
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
-				bh, 0, 0);
+				bh, 0);
 	} else {
 		retval = ext4_ind_get_blocks(handle, inode, block, max_blocks,
-					     bh, 0, 0);
+					     bh, 0);
 	}
 	up_read((&EXT4_I(inode)->i_data_sem));
 
 	/* If it is only a block(s) look up */
-	if (!create)
+	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0)
 		return retval;
 
 	/*
@@ -1205,7 +1205,7 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 	 * let the underlying get_block() function know to
 	 * avoid double accounting
 	 */
-	if (flag)
+	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
 		EXT4_I(inode)->i_delalloc_reserved_flag = 1;
 	/*
 	 * We need to check for EXT4 here because migrate
@@ -1213,10 +1213,10 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 	 */
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
-				bh, create, extend_disksize);
+					      bh, flags);
 	} else {
 		retval = ext4_ind_get_blocks(handle, inode, block,
-				max_blocks, bh, create, extend_disksize);
+					     max_blocks, bh, flags);
 
 		if (retval > 0 && buffer_new(bh)) {
 			/*
@@ -1229,7 +1229,7 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 		}
 	}
 
-	if (flag) {
+	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
 		EXT4_I(inode)->i_delalloc_reserved_flag = 0;
 		/*
 		 * Update reserved blocks/metadata blocks
@@ -1269,7 +1269,7 @@ int ext4_get_block(struct inode *inode, sector_t iblock,
 	}
 
 	ret = ext4_get_blocks(handle, inode, iblock, max_blocks, bh_result,
-			      create, 0, 0);
+			      create ? EXT4_GET_BLOCKS_CREATE : 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
@@ -1288,16 +1288,19 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 {
 	struct buffer_head dummy;
 	int fatal = 0, err;
+	int flags = EXT4_GET_BLOCKS_EXTEND_DISKSIZE;
 
 	J_ASSERT(handle != NULL || create == 0);
 
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
 	buffer_trace_init(&dummy.b_history);
-	err = ext4_get_blocks(handle, inode, block, 1, &dummy, create, 1, 0);
+	if (create)
+		flags |= EXT4_GET_BLOCKS_CREATE;
+	err = ext4_get_blocks(handle, inode, block, 1, &dummy, flags);
 	/*
-	 * ext4_get_blocks() returns number of blocks
-	 * mapped. 0 in case of a HOLE.
+	 * ext4_get_blocks() returns number of blocks mapped. 0 in
+	 * case of a HOLE.
 	 */
 	if (err > 0) {
 		if (err > 1)
@@ -1997,7 +2000,6 @@ static void ext4_print_free_blocks(struct inode *inode)
 	return;
 }
 
-#define		EXT4_DELALLOC_RSVED	1
 static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result)
 {
@@ -2009,7 +2011,8 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 	handle = ext4_journal_current_handle();
 	BUG_ON(!handle);
 	ret = ext4_get_blocks(handle, inode, iblock, max_blocks,
-			      bh_result, 1, 0, EXT4_DELALLOC_RSVED);
+			      bh_result, EXT4_GET_BLOCKS_CREATE|
+			      EXT4_GET_BLOCKS_DELALLOC_RESERVE);
 	if (ret <= 0)
 		return ret;
 
@@ -2065,16 +2068,17 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 		return 0;
 	/*
 	 * We need to make sure the BH_Delay flag is passed down to
-	 * ext4_da_get_block_write(), since it calls
-	 * ext4_get_blocks() with the EXT4_DELALLOC_RSVED flag.
-	 * This flag causes ext4_get_blocks() to call
+	 * ext4_da_get_block_write(), since it calls ext4_get_blocks()
+	 * with the EXT4_GET_BLOCKS_DELALLOC_RESERVE flag.  This flag
+	 * causes ext4_get_blocks() to call
 	 * ext4_da_update_reserve_space() if the passed buffer head
 	 * has the BH_Delay flag set.  In the future, once we clean up
-	 * the interfaces to ext4_get_blocks(), we should pass in
-	 * a separate flag which requests that the delayed allocation
+	 * the interfaces to ext4_get_blocks(), we should pass in a
+	 * separate flag which requests that the delayed allocation
 	 * statistics should be updated, instead of depending on the
 	 * state information getting passed down via the map_bh's
-	 * state bitmasks plus the magic EXT4_DELALLOC_RSVED flag.
+	 * state bitmasks plus the magic
+	 * EXT4_GET_BLOCKS_DELALLOC_RESERVE flag.
 	 */
 	new.b_state = mpd->b_state & (1 << BH_Delay);
 	new.b_blocknr = 0;
@@ -2362,7 +2366,7 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 	 * preallocated blocks are unmapped but should treated
 	 * the same as allocated blocks.
 	 */
-	ret = ext4_get_blocks(NULL, inode, iblock, 1,  bh_result, 0, 0, 0);
+	ret = ext4_get_blocks(NULL, inode, iblock, 1,  bh_result, 0);
 	if ((ret == 0) && !buffer_delay(bh_result)) {
 		/* the block isn't (pre)allocated yet, let's reserve space */
 		/*
@@ -2406,8 +2410,7 @@ static int ext4_normal_get_block_write(struct inode *inode, sector_t iblock,
 	 * we don't want to do block allocation in writepage
 	 * so call get_block_wrap with create = 0
 	 */
-	ret = ext4_get_blocks(NULL, inode, iblock, max_blocks,
-			      bh_result, 0, 0, 0);
+	ret = ext4_get_blocks(NULL, inode, iblock, max_blocks, bh_result, 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
-- 
1.6.3.2.1.gb9f7d.dirty

