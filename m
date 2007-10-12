Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbXJLQKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbXJLQKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760018AbXJLQGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbXJLQGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/52] CRED: Pass credentials down to ext4 block allocator
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:05 +0100
Message-ID: <20071012160605.15119.60626.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials down to the ext4 block allocator.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext4/balloc.c                |   23 ++--
 fs/ext4/dir.c                   |   15 ++-
 fs/ext4/extents.c               |  129 +++++++++++++----------
 fs/ext4/ialloc.c                |    7 +
 fs/ext4/inode.c                 |  118 +++++++++++++--------
 fs/ext4/ioctl.c                 |    4 +
 fs/ext4/namei.c                 |  221 +++++++++++++++++++++++----------------
 fs/ext4/super.c                 |    8 +
 fs/ext4/xattr.c                 |   25 ++--
 fs/ext4/xattr.h                 |    7 +
 fs/ext4/xattr_trusted.c         |    4 +
 fs/ext4/xattr_user.c            |    4 +
 include/linux/ext4_fs.h         |   36 ++++--
 include/linux/ext4_fs_extents.h |    2 
 include/linux/ext4_jbd2.h       |    3 -
 15 files changed, 359 insertions(+), 247 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index a6ced53..e95557c 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1367,19 +1367,20 @@ out:
 /**
  * ext4_has_free_blocks()
  * @sbi:		in-core super block structure.
+ * @cred:		credentials currently in force
  *
  * Check if filesystem has at least 1 free block available for allocation.
  */
-static int ext4_has_free_blocks(struct ext4_sb_info *sbi)
+static int ext4_has_free_blocks(struct ext4_sb_info *sbi, struct cred *cred)
 {
 	ext4_fsblk_t free_blocks, root_blocks;
 
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = ext4_r_blocks_count(sbi->s_es);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->cred->uid &&
+		sbi->s_resuid != cred->uid &&
 		(sbi->s_resgid == 0 ||
-		 !in_group_p (current->cred, sbi->s_resgid))) {
+		 !in_group_p (cred, sbi->s_resgid))) {
 		return 0;
 	}
 	return 1;
@@ -1389,6 +1390,7 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi)
  * ext4_should_retry_alloc()
  * @sb:			super block
  * @retries		number of attemps has been made
+ * @cred:		credentials currently in force
  *
  * ext4_should_retry_alloc() is called when ENOSPC is returned, and if
  * it is profitable to retry the operation, this function will wait
@@ -1397,9 +1399,10 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi)
  *
  * if the total number of retries exceed three times, return FALSE.
  */
-int ext4_should_retry_alloc(struct super_block *sb, int *retries)
+int ext4_should_retry_alloc(struct super_block *sb, int *retries,
+			    struct cred *cred)
 {
-	if (!ext4_has_free_blocks(EXT4_SB(sb)) || (*retries)++ > 3)
+	if (!ext4_has_free_blocks(EXT4_SB(sb), cred) || (*retries)++ > 3)
 		return 0;
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
@@ -1414,6 +1417,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
  * @goal:		given target block(filesystem wide)
  * @count:		target number of blocks to allocate
  * @errp:		error code
+ * @cred:		credentials currently in force
  *
  * ext4_new_blocks uses a goal block to assist allocation.  It tries to
  * allocate block(s) from the block group contains the goal block first. If that
@@ -1422,7 +1426,8 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
  *
  */
 ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, unsigned long *count, int *errp)
+			ext4_fsblk_t goal, unsigned long *count, int *errp,
+			struct cred *cred)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *gdp_bh;
@@ -1478,7 +1483,7 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
 		my_rsv = &block_i->rsv_window_node;
 
-	if (!ext4_has_free_blocks(sbi)) {
+	if (!ext4_has_free_blocks(sbi, cred)) {
 		*errp = -ENOSPC;
 		goto out;
 	}
@@ -1682,11 +1687,11 @@ out:
 }
 
 ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, int *errp)
+			ext4_fsblk_t goal, int *errp, struct cred *cred)
 {
 	unsigned long count = 1;
 
-	return ext4_new_blocks(handle, inode, goal, &count, errp);
+	return ext4_new_blocks(handle, inode, goal, &count, errp, cred);
 }
 
 /**
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 3ab01c0..3ccd926 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -34,7 +34,7 @@ static unsigned char ext4_filetype_table[] = {
 
 static int ext4_readdir(struct file *, void *, filldir_t);
 static int ext4_dx_readdir(struct file * filp,
-			   void * dirent, filldir_t filldir);
+			   void * dirent, filldir_t filldir, struct cred *cred);
 static int ext4_release_dir (struct inode * inode,
 				struct file * filp);
 
@@ -96,6 +96,7 @@ int ext4_check_dir_entry (const char * function, struct inode * dir,
 static int ext4_readdir(struct file * filp,
 			 void * dirent, filldir_t filldir)
 {
+	struct cred *cred = filp->f_cred;
 	int error = 0;
 	unsigned long offset;
 	int i, stored;
@@ -112,7 +113,7 @@ static int ext4_readdir(struct file * filp,
 				    EXT4_FEATURE_COMPAT_DIR_INDEX) &&
 	    ((EXT4_I(inode)->i_flags & EXT4_INDEX_FL) ||
 	     ((inode->i_size >> sb->s_blocksize_bits) == 1))) {
-		err = ext4_dx_readdir(filp, dirent, filldir);
+		err = ext4_dx_readdir(filp, dirent, filldir, cred);
 		if (err != ERR_BAD_DX_DIR) {
 			ret = err;
 			goto out;
@@ -133,7 +134,8 @@ static int ext4_readdir(struct file * filp,
 		struct buffer_head *bh = NULL;
 
 		map_bh.b_state = 0;
-		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh, 0, 0);
+		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh, 0, 0,
+					   cred);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
@@ -143,7 +145,7 @@ static int ext4_readdir(struct file * filp,
 					&filp->f_ra, filp,
 					index, 1);
 			filp->f_ra.prev_index = index;
-			bh = ext4_bread(NULL, inode, blk, 0, &err);
+			bh = ext4_bread(NULL, inode, blk, 0, &err, cred);
 		}
 
 		/*
@@ -430,7 +432,8 @@ static int call_filldir(struct file * filp, void * dirent,
 }
 
 static int ext4_dx_readdir(struct file * filp,
-			 void * dirent, filldir_t filldir)
+			 void * dirent, filldir_t filldir,
+			 struct cred *cred)
 {
 	struct dir_private_info *info = filp->private_data;
 	struct inode *inode = filp->f_path.dentry->d_inode;
@@ -480,7 +483,7 @@ static int ext4_dx_readdir(struct file * filp,
 			filp->f_version = inode->i_version;
 			ret = ext4_htree_fill_tree(filp, info->curr_hash,
 						   info->curr_minor_hash,
-						   &info->next_hash);
+						   &info->next_hash, cred);
 			if (ret < 0)
 				return ret;
 			if (ret == 0) {
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 78beb09..472be1a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -129,7 +129,8 @@ static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
  *  - EIO
  */
 static int ext4_ext_dirty(handle_t *handle, struct inode *inode,
-				struct ext4_ext_path *path)
+				struct ext4_ext_path *path,
+				struct cred *cred)
 {
 	int err;
 	if (path->p_bh) {
@@ -137,7 +138,7 @@ static int ext4_ext_dirty(handle_t *handle, struct inode *inode,
 		err = ext4_journal_dirty_metadata(handle, path->p_bh);
 	} else {
 		/* path points to leaf/index in inode body */
-		err = ext4_mark_inode_dirty(handle, inode);
+		err = ext4_mark_inode_dirty(handle, inode, cred);
 	}
 	return err;
 }
@@ -177,12 +178,13 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 static ext4_fsblk_t
 ext4_ext_new_block(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path,
-			struct ext4_extent *ex, int *err)
+			struct ext4_extent *ex, int *err,
+			struct cred *cred)
 {
 	ext4_fsblk_t goal, newblock;
 
 	goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
-	newblock = ext4_new_block(handle, inode, goal, err);
+	newblock = ext4_new_block(handle, inode, goal, err, cred);
 	return newblock;
 }
 
@@ -479,7 +481,7 @@ ext4_ext_binsearch(struct inode *inode, struct ext4_ext_path *path, int block)
 
 }
 
-int ext4_ext_tree_init(handle_t *handle, struct inode *inode)
+int ext4_ext_tree_init(handle_t *handle, struct inode *inode, struct cred *cred)
 {
 	struct ext4_extent_header *eh;
 
@@ -488,7 +490,7 @@ int ext4_ext_tree_init(handle_t *handle, struct inode *inode)
 	eh->eh_entries = 0;
 	eh->eh_magic = EXT4_EXT_MAGIC;
 	eh->eh_max = cpu_to_le16(ext4_ext_space_root(inode));
-	ext4_mark_inode_dirty(handle, inode);
+	ext4_mark_inode_dirty(handle, inode, cred);
 	ext4_ext_invalidate_cache(inode);
 	return 0;
 }
@@ -568,7 +570,8 @@ err:
  */
 static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *curp,
-				int logical, ext4_fsblk_t ptr)
+				int logical, ext4_fsblk_t ptr,
+				struct cred *cred)
 {
 	struct ext4_extent_idx *ix;
 	int len, err;
@@ -611,7 +614,7 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 			     > le16_to_cpu(curp->p_hdr->eh_max));
 	BUG_ON(ix > EXT_LAST_INDEX(curp->p_hdr));
 
-	err = ext4_ext_dirty(handle, inode, curp);
+	err = ext4_ext_dirty(handle, inode, curp, cred);
 	ext4_std_error(inode->i_sb, err);
 
 	return err;
@@ -629,7 +632,8 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
  */
 static int ext4_ext_split(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path,
-				struct ext4_extent *newext, int at)
+				struct ext4_extent *newext, int at,
+				struct cred *cred)
 {
 	struct buffer_head *bh = NULL;
 	int depth = ext_depth(inode);
@@ -679,7 +683,8 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	/* allocate all needed blocks */
 	ext_debug("allocate %d blocks for indexes/leaf\n", depth - at);
 	for (a = 0; a < depth - at; a++) {
-		newblock = ext4_ext_new_block(handle, inode, path, newext, &err);
+		newblock = ext4_ext_new_block(handle, inode, path, newext, &err,
+					      cred);
 		if (newblock == 0)
 			goto cleanup;
 		ablocks[a] = newblock;
@@ -746,7 +751,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 			goto cleanup;
 		path[depth].p_hdr->eh_entries =
 		     cpu_to_le16(le16_to_cpu(path[depth].p_hdr->eh_entries)-m);
-		err = ext4_ext_dirty(handle, inode, path + depth);
+		err = ext4_ext_dirty(handle, inode, path + depth, cred);
 		if (err)
 			goto cleanup;
 
@@ -827,7 +832,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 			if (err)
 				goto cleanup;
 			path[i].p_hdr->eh_entries = cpu_to_le16(le16_to_cpu(path[i].p_hdr->eh_entries)-m);
-			err = ext4_ext_dirty(handle, inode, path + i);
+			err = ext4_ext_dirty(handle, inode, path + i, cred);
 			if (err)
 				goto cleanup;
 		}
@@ -837,7 +842,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 
 	/* insert new index */
 	err = ext4_ext_insert_index(handle, inode, path + at,
-				    le32_to_cpu(border), newblock);
+				    le32_to_cpu(border), newblock, cred);
 
 cleanup:
 	if (bh) {
@@ -869,7 +874,8 @@ cleanup:
  */
 static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					struct ext4_extent *newext)
+					struct ext4_extent *newext,
+					struct cred *cred)
 {
 	struct ext4_ext_path *curp = path;
 	struct ext4_extent_header *neh;
@@ -878,7 +884,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t newblock;
 	int err = 0;
 
-	newblock = ext4_ext_new_block(handle, inode, path, newext, &err);
+	newblock = ext4_ext_new_block(handle, inode, path, newext, &err, cred);
 	if (newblock == 0)
 		return err;
 
@@ -940,7 +946,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 		  le32_to_cpu(fidx->ei_block), idx_pblock(fidx));
 
 	neh->eh_depth = cpu_to_le16(path->p_depth + 1);
-	err = ext4_ext_dirty(handle, inode, curp);
+	err = ext4_ext_dirty(handle, inode, curp, cred);
 out:
 	brelse(bh);
 
@@ -954,7 +960,8 @@ out:
  */
 static int ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					struct ext4_extent *newext)
+					struct ext4_extent *newext,
+					struct cred *cred)
 {
 	struct ext4_ext_path *curp;
 	int depth, i, err = 0;
@@ -974,7 +981,7 @@ repeat:
 	if (EXT_HAS_FREE_INDEX(curp)) {
 		/* if we found index with free entry, then use that
 		 * entry: create all needed subtree and add new leaf */
-		err = ext4_ext_split(handle, inode, path, newext, i);
+		err = ext4_ext_split(handle, inode, path, newext, i, cred);
 
 		/* refill path */
 		ext4_ext_drop_refs(path);
@@ -985,7 +992,7 @@ repeat:
 			err = PTR_ERR(path);
 	} else {
 		/* tree is full, time to grow in depth */
-		err = ext4_ext_grow_indepth(handle, inode, path, newext);
+		err = ext4_ext_grow_indepth(handle, inode, path, newext, cred);
 		if (err)
 			goto out;
 
@@ -1086,7 +1093,7 @@ static unsigned ext4_ext_next_leaf_block(struct inode *inode,
  * TODO: do we need to correct tree in all cases?
  */
 int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
-				struct ext4_ext_path *path)
+				struct ext4_ext_path *path, struct cred *cred)
 {
 	struct ext4_extent_header *eh;
 	int depth = ext_depth(inode);
@@ -1118,7 +1125,7 @@ int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 	if (err)
 		return err;
 	path[k].p_idx->ei_block = border;
-	err = ext4_ext_dirty(handle, inode, path + k);
+	err = ext4_ext_dirty(handle, inode, path + k, cred);
 	if (err)
 		return err;
 
@@ -1130,7 +1137,7 @@ int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 		if (err)
 			break;
 		path[k].p_idx->ei_block = border;
-		err = ext4_ext_dirty(handle, inode, path + k);
+		err = ext4_ext_dirty(handle, inode, path + k, cred);
 		if (err)
 			break;
 	}
@@ -1284,7 +1291,8 @@ out:
  */
 int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path,
-				struct ext4_extent *newext)
+				struct ext4_extent *newext,
+				struct cred *cred)
 {
 	struct ext4_extent_header * eh;
 	struct ext4_extent *ex, *fex;
@@ -1356,7 +1364,7 @@ repeat:
 	 * There is no free space in the found leaf.
 	 * We're gonna add a new leaf in the tree.
 	 */
-	err = ext4_ext_create_new_leaf(handle, inode, path, newext);
+	err = ext4_ext_create_new_leaf(handle, inode, path, newext, cred);
 	if (err)
 		goto cleanup;
 	depth = ext_depth(inode);
@@ -1420,11 +1428,11 @@ merge:
 	/* try to merge extents to the left */
 
 	/* time to correct all indexes above */
-	err = ext4_ext_correct_indexes(handle, inode, path);
+	err = ext4_ext_correct_indexes(handle, inode, path, cred);
 	if (err)
 		goto cleanup;
 
-	err = ext4_ext_dirty(handle, inode, path + depth);
+	err = ext4_ext_dirty(handle, inode, path + depth, cred);
 
 cleanup:
 	if (npath) {
@@ -1638,7 +1646,7 @@ ext4_ext_in_cache(struct inode *inode, unsigned long block,
  * last index in the block only.
  */
 int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
-			struct ext4_ext_path *path)
+			struct ext4_ext_path *path, struct cred *cred)
 {
 	struct buffer_head *bh;
 	int err;
@@ -1652,7 +1660,7 @@ int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
 	if (err)
 		return err;
 	path->p_hdr->eh_entries = cpu_to_le16(le16_to_cpu(path->p_hdr->eh_entries)-1);
-	err = ext4_ext_dirty(handle, inode, path);
+	err = ext4_ext_dirty(handle, inode, path, cred);
 	if (err)
 		return err;
 	ext_debug("index is empty, remove it, free block %llu\n", leaf);
@@ -1762,7 +1770,8 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 
 static int
 ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
-		struct ext4_ext_path *path, unsigned long start)
+		struct ext4_ext_path *path, unsigned long start,
+		struct cred *cred)
 {
 	int err = 0, correct_index = 0;
 	int depth = ext_depth(inode), credits;
@@ -1861,7 +1870,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		if (uninitialized && num)
 			ext4_ext_mark_uninitialized(ex);
 
-		err = ext4_ext_dirty(handle, inode, path + depth);
+		err = ext4_ext_dirty(handle, inode, path + depth, cred);
 		if (err)
 			goto out;
 
@@ -1873,12 +1882,12 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	}
 
 	if (correct_index && eh->eh_entries)
-		err = ext4_ext_correct_indexes(handle, inode, path);
+		err = ext4_ext_correct_indexes(handle, inode, path, cred);
 
 	/* if this leaf is free, then we should
 	 * remove it from index block above */
 	if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
-		err = ext4_ext_rm_idx(handle, inode, path + depth);
+		err = ext4_ext_rm_idx(handle, inode, path + depth, cred);
 
 out:
 	return err;
@@ -1905,7 +1914,8 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
 	return 1;
 }
 
-int ext4_ext_remove_space(struct inode *inode, unsigned long start)
+int ext4_ext_remove_space(struct inode *inode, unsigned long start,
+			  struct cred *cred)
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
@@ -1941,7 +1951,8 @@ int ext4_ext_remove_space(struct inode *inode, unsigned long start)
 	while (i >= 0 && err == 0) {
 		if (i == depth) {
 			/* this is leaf block */
-			err = ext4_ext_rm_leaf(handle, inode, path, start);
+			err = ext4_ext_rm_leaf(handle, inode, path, start,
+					       cred);
 			/* root level has p_bh == NULL, brelse() eats this */
 			brelse(path[i].p_bh);
 			path[i].p_bh = NULL;
@@ -2003,7 +2014,8 @@ int ext4_ext_remove_space(struct inode *inode, unsigned long start)
 				/* index is empty, remove it;
 				 * handle must be already prepared by the
 				 * truncatei_leaf() */
-				err = ext4_ext_rm_idx(handle, inode, path + i);
+				err = ext4_ext_rm_idx(handle, inode, path + i,
+						      cred);
 			}
 			/* root level has p_bh == NULL, brelse() eats this */
 			brelse(path[i].p_bh);
@@ -2024,7 +2036,7 @@ int ext4_ext_remove_space(struct inode *inode, unsigned long start)
 			ext_inode_hdr(inode)->eh_depth = 0;
 			ext_inode_hdr(inode)->eh_max =
 				cpu_to_le16(ext4_ext_space_root(inode));
-			err = ext4_ext_dirty(handle, inode, path);
+			err = ext4_ext_dirty(handle, inode, path, cred);
 		}
 	}
 out:
@@ -2098,7 +2110,8 @@ void ext4_ext_release(struct super_block *sb)
 int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
 					ext4_fsblk_t iblock,
-					unsigned long max_blocks)
+					unsigned long max_blocks,
+					struct cred *cred)
 {
 	struct ext4_extent *ex, newex;
 	struct ext4_extent *ex1 = NULL;
@@ -2141,7 +2154,7 @@ int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 		ext4_ext_store_pblock(ex3, newblock + max_blocks);
 		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
 		ext4_ext_mark_uninitialized(ex3);
-		err = ext4_ext_insert_extent(handle, inode, path, ex3);
+		err = ext4_ext_insert_extent(handle, inode, path, ex3, cred);
 		if (err)
 			goto out;
 		/*
@@ -2198,7 +2211,8 @@ int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 		 */
 		ret = ext4_ext_try_to_merge(inode, path, ex2 - 1);
 		if (ret) {
-			err = ext4_ext_correct_indexes(handle, inode, path);
+			err = ext4_ext_correct_indexes(handle, inode, path,
+						       cred);
 			if (err)
 				goto out;
 			depth = ext_depth(inode);
@@ -2213,16 +2227,17 @@ int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 	if (!ex3) {
 		ret = ext4_ext_try_to_merge(inode, path, ex2);
 		if (ret) {
-			err = ext4_ext_correct_indexes(handle, inode, path);
+			err = ext4_ext_correct_indexes(handle, inode, path,
+						       cred);
 			if (err)
 				goto out;
 		}
 	}
 	/* Mark modified extent as dirty */
-	err = ext4_ext_dirty(handle, inode, path + depth);
+	err = ext4_ext_dirty(handle, inode, path + depth, cred);
 	goto out;
 insert:
-	err = ext4_ext_insert_extent(handle, inode, path, &newex);
+	err = ext4_ext_insert_extent(handle, inode, path, &newex, cred);
 out:
 	return err ? err : allocated;
 }
@@ -2230,7 +2245,8 @@ out:
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
-			int create, int extend_disksize)
+			int create, int extend_disksize,
+			struct cred *cred)
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent_header *eh;
@@ -2321,7 +2337,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 
 			ret = ext4_ext_convert_to_initialized(handle, inode,
 								path, iblock,
-								max_blocks);
+								max_blocks,
+								cred);
 			if (ret <= 0)
 				goto out2;
 			else
@@ -2373,7 +2390,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		allocated = le16_to_cpu(newex.ee_len);
 	else
 		allocated = max_blocks;
-	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
+	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err, cred);
 	if (!newblock)
 		goto out2;
 	ext_debug("allocate new block: goal %llu, found %llu/%lu\n",
@@ -2384,7 +2401,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	newex.ee_len = cpu_to_le16(allocated);
 	if (create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
 		ext4_ext_mark_uninitialized(&newex);
-	err = ext4_ext_insert_extent(handle, inode, path, &newex);
+	err = ext4_ext_insert_extent(handle, inode, path, &newex, cred);
 	if (err) {
 		/* free data blocks we just allocated */
 		ext4_free_blocks(handle, inode, ext_pblock(&newex),
@@ -2421,7 +2438,8 @@ out2:
 	return err ? err : allocated;
 }
 
-void ext4_ext_truncate(struct inode * inode, struct page *page)
+void ext4_ext_truncate(struct inode * inode, struct page *page,
+		       struct cred *cred)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct super_block *sb = inode->i_sb;
@@ -2460,11 +2478,11 @@ void ext4_ext_truncate(struct inode * inode, struct page *page)
 
 	/* we have to know where to truncate from in crash case */
 	EXT4_I(inode)->i_disksize = inode->i_size;
-	ext4_mark_inode_dirty(handle, inode);
+	ext4_mark_inode_dirty(handle, inode, cred);
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
-	err = ext4_ext_remove_space(inode, last_block);
+	err = ext4_ext_remove_space(inode, last_block, cred);
 
 	/* In a multi-transaction truncate, we only make the final
 	 * transaction synchronous.
@@ -2517,6 +2535,7 @@ int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
  */
 long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	ext4_fsblk_t block, max_blocks;
 	ext4_fsblk_t nblocks = 0;
@@ -2558,7 +2577,8 @@ retry:
 
 		ret = ext4_ext_get_blocks(handle, inode, block,
 					  max_blocks, &map_bh,
-					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
+					  EXT4_CREATE_UNINITIALIZED_EXT, 0,
+					  cred);
 		WARN_ON(!ret);
 		if (!ret) {
 			ext4_error(inode->i_sb, "ext4_fallocate",
@@ -2566,7 +2586,7 @@ retry:
 				   ", block=%llu, max_blocks=%llu",
 				   inode->i_ino, block, max_blocks);
 			ret = -EIO;
-			ext4_mark_inode_dirty(handle, inode);
+			ext4_mark_inode_dirty(handle, inode, cred);
 			ret2 = ext4_journal_stop(handle);
 			break;
 		}
@@ -2574,7 +2594,7 @@ retry:
 			/* check wrap through sign-bit/zero here */
 			if ((block + ret) < 0 || (block + ret) < block) {
 				ret = -EIO;
-				ext4_mark_inode_dirty(handle, inode);
+				ext4_mark_inode_dirty(handle, inode, cred);
 				ret2 = ext4_journal_stop(handle);
 				break;
 			}
@@ -2593,13 +2613,14 @@ retry:
 				inode->i_ctime = now;
 		}
 
-		ext4_mark_inode_dirty(handle, inode);
+		ext4_mark_inode_dirty(handle, inode, cred);
 		ret2 = ext4_journal_stop(handle);
 		if (ret2)
 			break;
 	}
 
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == -ENOSPC &&
+	    ext4_should_retry_alloc(inode->i_sb, &retries, cred))
 		goto retry;
 
 	/*
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 488cc2b..937610d 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -424,7 +424,8 @@ static int find_group_other(struct super_block *sb, struct inode *parent)
  * For other inodes, search forward from the parent directory's block
  * group to find a free inode.
  */
-struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
+struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode,
+			     struct cred *cred)
 {
 	struct super_block *sb;
 	struct buffer_head *bitmap_bh = NULL;
@@ -613,14 +614,14 @@ got:
 	if (err)
 		goto fail_free_drop;
 
-	err = ext4_mark_inode_dirty(handle, inode);
+	err = ext4_mark_inode_dirty(handle, inode, cred);
 	if (err) {
 		ext4_std_error(sb, err);
 		goto fail_free_drop;
 	}
 	if (test_opt(sb, EXTENTS)) {
 		EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
-		ext4_ext_tree_init(handle, inode);
+		ext4_ext_tree_init(handle, inode, cred);
 		if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 			err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
 			if (err) goto fail;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c4fb1eb..f09cb71 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -179,6 +179,7 @@ static int ext4_journal_test_restart(handle_t *handle, struct inode *inode)
  */
 void ext4_delete_inode (struct inode * inode)
 {
+	struct cred *cred = &init_cred;
 	handle_t *handle;
 
 	truncate_inode_pages(&inode->i_data, 0);
@@ -220,7 +221,7 @@ void ext4_delete_inode (struct inode * inode)
 	 * having errors), but we can't free the inode if the mark_dirty
 	 * fails.
 	 */
-	if (ext4_mark_inode_dirty(handle, inode))
+	if (ext4_mark_inode_dirty(handle, inode, cred))
 		/* If that failed, just do the required in-core inode clear. */
 		clear_inode(inode);
 	else
@@ -511,10 +512,11 @@ static int ext4_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
  *	the indirect blocks(if needed) and the first direct block,
  *	@blks:	on return it will store the total number of allocated
  *		direct blocks
+ *	@cred:	the credentials currently in force
  */
 static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, int indirect_blks, int blks,
-			ext4_fsblk_t new_blocks[4], int *err)
+			ext4_fsblk_t new_blocks[4], int *err, struct cred *cred)
 {
 	int target, i;
 	unsigned long count = 0;
@@ -535,7 +537,8 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 	while (1) {
 		count = target;
 		/* allocating blocks for indirect blocks and direct blocks */
-		current_block = ext4_new_blocks(handle,inode,goal,&count,err);
+		current_block = ext4_new_blocks(handle, inode, goal, &count,
+						err, cred);
 		if (*err)
 			goto failed_out;
 
@@ -590,7 +593,7 @@ failed_out:
  */
 static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 			int indirect_blks, int *blks, ext4_fsblk_t goal,
-			int *offsets, Indirect *branch)
+			int *offsets, Indirect *branch, struct cred *cred)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int i, n = 0;
@@ -601,7 +604,7 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t current_block;
 
 	num = ext4_alloc_blocks(handle, inode, goal, indirect_blks,
-				*blks, new_blocks, &err);
+				*blks, new_blocks, &err, cred);
 	if (err)
 		return err;
 
@@ -674,13 +677,15 @@ failed:
  * @where: location of missing link
  * @num:   number of indirect blocks we are adding
  * @blks:  number of direct blocks we are adding
+ * @cred:  the credentials in force
  *
  * This function fills the missing link and does all housekeeping needed in
  * inode (->i_blocks, etc.). In case of success we end up with the full
  * chain to new block and return 0.
  */
 static int ext4_splice_branch(handle_t *handle, struct inode *inode,
-			long block, Indirect *where, int num, int blks)
+			long block, Indirect *where, int num, int blks,
+			struct cred *cred)
 {
 	int i;
 	int err = 0;
@@ -727,7 +732,7 @@ static int ext4_splice_branch(handle_t *handle, struct inode *inode,
 	/* We are done with atomic stuff, now do the rest of housekeeping */
 
 	inode->i_ctime = ext4_current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	ext4_mark_inode_dirty(handle, inode, cred);
 
 	/* had we spliced it onto indirect block? */
 	if (where->bh) {
@@ -786,7 +791,7 @@ err_out:
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		sector_t iblock, unsigned long maxblocks,
 		struct buffer_head *bh_result,
-		int create, int extend_disksize)
+		int create, int extend_disksize, struct cred *cred)
 {
 	int err = -EIO;
 	int offsets[4];
@@ -898,7 +903,7 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	 * Block out ext4_truncate while we alter the tree
 	 */
 	err = ext4_alloc_branch(handle, inode, indirect_blks, &count, goal,
-				offsets + (partial - chain), partial);
+				offsets + (partial - chain), partial, cred);
 
 	/*
 	 * The ext4_splice_branch call will free and forget any buffers
@@ -909,7 +914,7 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	 */
 	if (!err)
 		err = ext4_splice_branch(handle, inode, iblock,
-					partial, indirect_blks, count);
+					partial, indirect_blks, count, cred);
 	/*
 	 * i_disksize growing is protected by truncate_mutex.  Don't forget to
 	 * protect it if you're about to implement concurrent
@@ -945,6 +950,7 @@ out:
 static int ext4_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle = ext4_journal_current_handle();
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
@@ -983,7 +989,7 @@ static int ext4_get_block(struct inode *inode, sector_t iblock,
 get_block:
 	if (ret == 0) {
 		ret = ext4_get_blocks_wrap(handle, inode, iblock,
-					max_blocks, bh_result, create, 0);
+					max_blocks, bh_result, create, 0, cred);
 		if (ret > 0) {
 			bh_result->b_size = (ret << inode->i_blkbits);
 			ret = 0;
@@ -996,7 +1002,8 @@ get_block:
  * `handle' can be NULL if create is zero
  */
 struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
-				long block, int create, int *errp)
+				long block, int create, int *errp,
+				struct cred *cred)
 {
 	struct buffer_head dummy;
 	int fatal = 0, err;
@@ -1007,7 +1014,7 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 	dummy.b_blocknr = -1000;
 	buffer_trace_init(&dummy.b_history);
 	err = ext4_get_blocks_wrap(handle, inode, block, 1,
-					&dummy, create, 1);
+					&dummy, create, 1, cred);
 	/*
 	 * ext4_get_blocks_handle() returns number of blocks
 	 * mapped. 0 in case of a HOLE.
@@ -1063,11 +1070,12 @@ err:
 }
 
 struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
-			       int block, int create, int *err)
+			       int block, int create, int *err,
+			       struct cred *cred)
 {
 	struct buffer_head * bh;
 
-	bh = ext4_getblk(handle, inode, block, create, err);
+	bh = ext4_getblk(handle, inode, block, create, err, cred);
 	if (!bh)
 		return bh;
 	if (buffer_uptodate(bh))
@@ -1149,6 +1157,7 @@ static int do_journal_get_write_access(handle_t *handle,
 static int ext4_prepare_write(struct file *file, struct page *page,
 			      unsigned from, unsigned to)
 {
+	struct cred *cred = file->f_cred;
 	struct inode *inode = page->mapping->host;
 	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
 	handle_t *handle;
@@ -1174,7 +1183,8 @@ retry:
 prepare_write_failed:
 	if (ret)
 		ext4_journal_stop(handle);
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == -ENOSPC &&
+	    ext4_should_retry_alloc(inode->i_sb, &retries, cred))
 		goto retry;
 out:
 	return ret;
@@ -1260,6 +1270,7 @@ static int ext4_writeback_commit_write(struct file *file, struct page *page,
 static int ext4_journalled_commit_write(struct file *file,
 			struct page *page, unsigned from, unsigned to)
 {
+	struct cred *cred = file->f_cred;
 	handle_t *handle = ext4_journal_current_handle();
 	struct inode *inode = page->mapping->host;
 	int ret = 0, ret2;
@@ -1280,7 +1291,7 @@ static int ext4_journalled_commit_write(struct file *file,
 	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
 	if (inode->i_size > EXT4_I(inode)->i_disksize) {
 		EXT4_I(inode)->i_disksize = inode->i_size;
-		ret2 = ext4_mark_inode_dirty(handle, inode);
+		ret2 = ext4_mark_inode_dirty(handle, inode, cred);
 		if (!ret)
 			ret = ret2;
 	}
@@ -1619,6 +1630,7 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 			unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
+	struct cred *cred = file->f_cred;
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	handle_t *handle = NULL;
@@ -1670,7 +1682,7 @@ out_stop:
 				 * ext4_mark_inode_dirty() to userspace.  So
 				 * ignore it.
 				 */
-				ext4_mark_inode_dirty(handle, inode);
+				ext4_mark_inode_dirty(handle, inode, cred);
 			}
 		}
 		err = ext4_journal_stop(handle);
@@ -1955,7 +1967,8 @@ no_top:
  */
 static void ext4_clear_blocks(handle_t *handle, struct inode *inode,
 		struct buffer_head *bh, ext4_fsblk_t block_to_free,
-		unsigned long count, __le32 *first, __le32 *last)
+		unsigned long count, __le32 *first, __le32 *last,
+		struct cred *cred)
 {
 	__le32 *p;
 	if (try_to_extend_transaction(handle, inode)) {
@@ -1963,7 +1976,7 @@ static void ext4_clear_blocks(handle_t *handle, struct inode *inode,
 			BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
 			ext4_journal_dirty_metadata(handle, bh);
 		}
-		ext4_mark_inode_dirty(handle, inode);
+		ext4_mark_inode_dirty(handle, inode, cred);
 		ext4_journal_test_restart(handle, inode);
 		if (bh) {
 			BUFFER_TRACE(bh, "retaking write access");
@@ -2000,6 +2013,7 @@ static void ext4_clear_blocks(handle_t *handle, struct inode *inode,
  * @this_bh:	indirect buffer_head which contains *@first and *@last
  * @first:	array of block numbers
  * @last:	points immediately past the end of array
+ * @cred:	credentials to use
  *
  * We are freeing all blocks refered from that array (numbers are stored as
  * little-endian 32-bit) and updating @inode->i_blocks appropriately.
@@ -2014,7 +2028,8 @@ static void ext4_clear_blocks(handle_t *handle, struct inode *inode,
  */
 static void ext4_free_data(handle_t *handle, struct inode *inode,
 			   struct buffer_head *this_bh,
-			   __le32 *first, __le32 *last)
+			   __le32 *first, __le32 *last,
+			   struct cred *cred)
 {
 	ext4_fsblk_t block_to_free = 0;    /* Starting block # of a run */
 	unsigned long count = 0;	    /* Number of blocks in the run */
@@ -2048,7 +2063,8 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 			} else {
 				ext4_clear_blocks(handle, inode, this_bh,
 						  block_to_free,
-						  count, block_to_free_p, p);
+						  count, block_to_free_p, p,
+						  cred);
 				block_to_free = nr;
 				block_to_free_p = p;
 				count = 1;
@@ -2058,7 +2074,7 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 
 	if (count > 0)
 		ext4_clear_blocks(handle, inode, this_bh, block_to_free,
-				  count, block_to_free_p, p);
+				  count, block_to_free_p, p, cred);
 
 	if (this_bh) {
 		BUFFER_TRACE(this_bh, "call ext4_journal_dirty_metadata");
@@ -2081,7 +2097,8 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
  */
 static void ext4_free_branches(handle_t *handle, struct inode *inode,
 			       struct buffer_head *parent_bh,
-			       __le32 *first, __le32 *last, int depth)
+			       __le32 *first, __le32 *last, int depth,
+			       struct cred *cred)
 {
 	ext4_fsblk_t nr;
 	__le32 *p;
@@ -2117,7 +2134,7 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 			ext4_free_branches(handle, inode, bh,
 					   (__le32*)bh->b_data,
 					   (__le32*)bh->b_data + addr_per_block,
-					   depth);
+					   depth, cred);
 
 			/*
 			 * We've probably journalled the indirect block several
@@ -2159,7 +2176,7 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 			if (is_handle_aborted(handle))
 				return;
 			if (try_to_extend_transaction(handle, inode)) {
-				ext4_mark_inode_dirty(handle, inode);
+				ext4_mark_inode_dirty(handle, inode, cred);
 				ext4_journal_test_restart(handle, inode);
 			}
 
@@ -2184,7 +2201,7 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 	} else {
 		/* We have reached the bottom of the tree. */
 		BUFFER_TRACE(parent_bh, "free data blocks");
-		ext4_free_data(handle, inode, parent_bh, first, last);
+		ext4_free_data(handle, inode, parent_bh, first, last, cred);
 	}
 }
 
@@ -2218,6 +2235,7 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
  */
 void ext4_truncate(struct inode *inode)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	__le32 *i_data = ei->i_data;
@@ -2255,7 +2273,7 @@ void ext4_truncate(struct inode *inode)
 	}
 
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
-		return ext4_ext_truncate(inode, page);
+		return ext4_ext_truncate(inode, page, cred);
 
 	handle = start_transaction(inode);
 	if (IS_ERR(handle)) {
@@ -2307,7 +2325,7 @@ void ext4_truncate(struct inode *inode)
 
 	if (n == 1) {		/* direct blocks */
 		ext4_free_data(handle, inode, NULL, i_data+offsets[0],
-			       i_data + EXT4_NDIR_BLOCKS);
+			       i_data + EXT4_NDIR_BLOCKS, cred);
 		goto do_indirects;
 	}
 
@@ -2317,7 +2335,8 @@ void ext4_truncate(struct inode *inode)
 		if (partial == chain) {
 			/* Shared branch grows from the inode */
 			ext4_free_branches(handle, inode, NULL,
-					   &nr, &nr+1, (chain+n-1) - partial);
+					   &nr, &nr+1, (chain+n-1) - partial,
+					   cred);
 			*partial->p = 0;
 			/*
 			 * We mark the inode dirty prior to restart,
@@ -2328,14 +2347,15 @@ void ext4_truncate(struct inode *inode)
 			BUFFER_TRACE(partial->bh, "get_write_access");
 			ext4_free_branches(handle, inode, partial->bh,
 					partial->p,
-					partial->p+1, (chain+n-1) - partial);
+					partial->p+1, (chain+n-1) - partial,
+					cred);
 		}
 	}
 	/* Clear the ends of indirect blocks on the shared branch */
 	while (partial > chain) {
 		ext4_free_branches(handle, inode, partial->bh, partial->p + 1,
 				   (__le32*)partial->bh->b_data+addr_per_block,
-				   (chain+n-1) - partial);
+				   (chain+n-1) - partial, cred);
 		BUFFER_TRACE(partial->bh, "call brelse");
 		brelse (partial->bh);
 		partial--;
@@ -2346,19 +2366,22 @@ do_indirects:
 	default:
 		nr = i_data[EXT4_IND_BLOCK];
 		if (nr) {
-			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 1);
+			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 1,
+					   cred);
 			i_data[EXT4_IND_BLOCK] = 0;
 		}
 	case EXT4_IND_BLOCK:
 		nr = i_data[EXT4_DIND_BLOCK];
 		if (nr) {
-			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 2);
+			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 2,
+					   cred);
 			i_data[EXT4_DIND_BLOCK] = 0;
 		}
 	case EXT4_DIND_BLOCK:
 		nr = i_data[EXT4_TIND_BLOCK];
 		if (nr) {
-			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 3);
+			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 3,
+					   cred);
 			i_data[EXT4_TIND_BLOCK] = 0;
 		}
 	case EXT4_TIND_BLOCK:
@@ -2369,7 +2392,7 @@ do_indirects:
 
 	mutex_unlock(&ei->truncate_mutex);
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	ext4_mark_inode_dirty(handle, inode, cred);
 
 	/*
 	 * In a multi-transaction truncate, we only make the final transaction
@@ -2946,6 +2969,7 @@ int ext4_write_inode(struct inode *inode, int wait)
  */
 int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
 	const unsigned int ia_valid = attr->ia_valid;
@@ -2977,7 +3001,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			inode->i_uid = attr->ia_uid;
 		if (attr->ia_valid & ATTR_GID)
 			inode->i_gid = attr->ia_gid;
-		error = ext4_mark_inode_dirty(handle, inode);
+		error = ext4_mark_inode_dirty(handle, inode, cred);
 		ext4_journal_stop(handle);
 	}
 
@@ -2993,7 +3017,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 
 		error = ext4_orphan_add(handle, inode);
 		EXT4_I(inode)->i_disksize = attr->ia_size;
-		rc = ext4_mark_inode_dirty(handle, inode);
+		rc = ext4_mark_inode_dirty(handle, inode, cred);
 		if (!error)
 			error = rc;
 		ext4_journal_stop(handle);
@@ -3116,7 +3140,8 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
  * Returns 0 on success or negative error number on failure.
  */
 int ext4_expand_extra_isize(struct inode *inode, unsigned int new_extra_isize,
-			struct ext4_iloc iloc, handle_t *handle)
+			struct ext4_iloc iloc, handle_t *handle,
+			struct cred *cred)
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
@@ -3141,7 +3166,7 @@ int ext4_expand_extra_isize(struct inode *inode, unsigned int new_extra_isize,
 
 	/* try to expand with EAs present */
 	return ext4_expand_extra_isize_ea(inode, new_extra_isize,
-					  raw_inode, handle);
+					  raw_inode, handle, cred);
 }
 
 /*
@@ -3165,7 +3190,8 @@ int ext4_expand_extra_isize(struct inode *inode, unsigned int new_extra_isize,
  * to do a write_super() to free up some memory.  It has the desired
  * effect.
  */
-int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
+int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode,
+			  struct cred *cred)
 {
 	struct ext4_iloc iloc;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -3187,7 +3213,7 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb))) == 0) {
 			ret = ext4_expand_extra_isize(inode,
 						      sbi->s_want_extra_isize,
-						      iloc, handle);
+						      iloc, handle, cred);
 			if (ret) {
 				EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
 				if (mnt_count != sbi->s_es->s_mnt_count) {
@@ -3221,6 +3247,7 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
  */
 void ext4_dirty_inode(struct inode *inode)
 {
+	struct cred *cred = current->cred;
 	handle_t *current_handle = ext4_journal_current_handle();
 	handle_t *handle;
 
@@ -3235,7 +3262,7 @@ void ext4_dirty_inode(struct inode *inode)
 	} else {
 		jbd_debug(5, "marking dirty.  outer handle=%p\n",
 				current_handle);
-		ext4_mark_inode_dirty(handle, inode);
+		ext4_mark_inode_dirty(handle, inode, cred);
 	}
 	ext4_journal_stop(handle);
 out:
@@ -3271,7 +3298,8 @@ static int ext4_pin_inode(handle_t *handle, struct inode *inode)
 }
 #endif
 
-int ext4_change_inode_journal_flag(struct inode *inode, int val)
+int ext4_change_inode_journal_flag(struct inode *inode, int val,
+				   struct cred *cred)
 {
 	journal_t *journal;
 	handle_t *handle;
@@ -3316,7 +3344,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	err = ext4_mark_inode_dirty(handle, inode);
+	err = ext4_mark_inode_dirty(handle, inode, cred);
 	handle->h_sync = 1;
 	ext4_journal_stop(handle);
 	ext4_std_error(inode->i_sb, err);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c04c7cc..4110510 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -21,6 +21,7 @@ int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 		unsigned long arg)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct cred *cred = filp->f_cred;
 	unsigned int flags;
 	unsigned short rsv_window_size;
 
@@ -108,7 +109,8 @@ flags_err:
 		}
 
 		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
-			err = ext4_change_inode_journal_flag(inode, jflag);
+			err = ext4_change_inode_journal_flag(inode, jflag,
+							     cred);
 		mutex_unlock(&inode->i_mutex);
 		return err;
 	}
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 301f41f..be28f73 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -51,13 +51,14 @@
 
 static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
-					u32 *block, int *err)
+					u32 *block, int *err,
+					struct cred *cred)
 {
 	struct buffer_head *bh;
 
 	*block = inode->i_size >> inode->i_sb->s_blocksize_bits;
 
-	if ((bh = ext4_bread(handle, inode, *block, 1, err))) {
+	if ((bh = ext4_bread(handle, inode, *block, 1, err, cred))) {
 		inode->i_size += inode->i_sb->s_blocksize;
 		EXT4_I(inode)->i_disksize = inode->i_size;
 		ext4_journal_get_write_access(handle,bh);
@@ -159,7 +160,8 @@ static struct dx_frame *dx_probe(struct dentry *dentry,
 				 struct inode *dir,
 				 struct dx_hash_info *hinfo,
 				 struct dx_frame *frame,
-				 int *err);
+				 int *err,
+				 struct cred *cred);
 static void dx_release (struct dx_frame *frames);
 static int dx_make_map (struct ext4_dir_entry_2 *de, int size,
 			struct dx_hash_info *hinfo, struct dx_map_entry map[]);
@@ -171,11 +173,13 @@ static void dx_insert_block (struct dx_frame *frame, u32 hash, u32 block);
 static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
 				 struct dx_frame *frames,
-				 __u32 *start_hash);
+				 __u32 *start_hash,
+				 struct cred *cred);
 static struct buffer_head * ext4_dx_find_entry(struct dentry *dentry,
-		       struct ext4_dir_entry_2 **res_dir, int *err);
+		       struct ext4_dir_entry_2 **res_dir, int *err,
+		       struct cred *cred);
 static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
-			     struct inode *inode);
+			     struct inode *inode, struct cred *cred);
 
 /*
  * Future: use high four bits of block for coalesce-on-delete flags
@@ -329,7 +333,8 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
  */
 static struct dx_frame *
 dx_probe(struct dentry *dentry, struct inode *dir,
-	 struct dx_hash_info *hinfo, struct dx_frame *frame_in, int *err)
+	 struct dx_hash_info *hinfo, struct dx_frame *frame_in, int *err,
+	 struct cred *cred)
 {
 	unsigned count, indirect;
 	struct dx_entry *at, *entries, *p, *q, *m;
@@ -341,7 +346,7 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 	frame->bh = NULL;
 	if (dentry)
 		dir = dentry->d_parent->d_inode;
-	if (!(bh = ext4_bread (NULL,dir, 0, 0, err)))
+	if (!(bh = ext4_bread (NULL,dir, 0, 0, err, cred)))
 		goto fail;
 	root = (struct dx_root *) bh->b_data;
 	if (root->info.hash_version != DX_HASH_TEA &&
@@ -436,7 +441,7 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 		frame->entries = entries;
 		frame->at = at;
 		if (!indirect--) return frame;
-		if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err)))
+		if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err, cred)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
 		if (dx_get_limit(entries) != dx_node_limit (dir)) {
@@ -492,7 +497,8 @@ static void dx_release (struct dx_frame *frames)
 static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
 				 struct dx_frame *frames,
-				 __u32 *start_hash)
+				 __u32 *start_hash,
+				 struct cred *cred)
 {
 	struct dx_frame *p;
 	struct buffer_head *bh;
@@ -536,7 +542,7 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 	 */
 	while (num_frames--) {
 		if (!(bh = ext4_bread(NULL, dir, dx_get_block(p->at),
-				      0, &err)))
+				      0, &err, cred)))
 			return err; /* Failure */
 		p++;
 		brelse (p->bh);
@@ -563,14 +569,15 @@ static inline struct ext4_dir_entry_2 *ext4_next_entry(struct ext4_dir_entry_2 *
 static int htree_dirblock_to_tree(struct file *dir_file,
 				  struct inode *dir, int block,
 				  struct dx_hash_info *hinfo,
-				  __u32 start_hash, __u32 start_minor_hash)
+				  __u32 start_hash, __u32 start_minor_hash,
+				  struct cred *cred)
 {
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de, *top;
 	int err, count = 0;
 
 	dxtrace(printk("In htree dirblock_to_tree: block %d\n", block));
-	if (!(bh = ext4_bread (NULL, dir, block, 0, &err)))
+	if (!(bh = ext4_bread (NULL, dir, block, 0, &err, cred)))
 		return err;
 
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
@@ -615,7 +622,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
  * or a negative error code.
  */
 int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
-			 __u32 start_minor_hash, __u32 *next_hash)
+			 __u32 start_minor_hash, __u32 *next_hash,
+			 struct cred *cred)
 {
 	struct dx_hash_info hinfo;
 	struct ext4_dir_entry_2 *de;
@@ -633,13 +641,15 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		hinfo.hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
 		hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
 		count = htree_dirblock_to_tree(dir_file, dir, 0, &hinfo,
-					       start_hash, start_minor_hash);
+					       start_hash, start_minor_hash,
+					       cred);
 		*next_hash = ~0;
 		return count;
 	}
 	hinfo.hash = start_hash;
 	hinfo.minor_hash = 0;
-	frame = dx_probe(NULL, dir_file->f_path.dentry->d_inode, &hinfo, frames, &err);
+	frame = dx_probe(NULL, dir_file->f_path.dentry->d_inode, &hinfo, frames,
+			 &err, cred);
 	if (!frame)
 		return err;
 
@@ -661,7 +671,8 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	while (1) {
 		block = dx_get_block(frame->at);
 		ret = htree_dirblock_to_tree(dir_file, dir, block, &hinfo,
-					     start_hash, start_minor_hash);
+					     start_hash, start_minor_hash,
+					     cred);
 		if (ret < 0) {
 			err = ret;
 			goto errout;
@@ -669,7 +680,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		count += ret;
 		hashval = ~0;
 		ret = ext4_htree_next_block(dir, HASH_NB_ALWAYS,
-					    frame, frames, &hashval);
+					    frame, frames, &hashval, cred);
 		*next_hash = hashval;
 		if (ret < 0) {
 			err = ret;
@@ -845,7 +856,8 @@ static inline int search_dirblock(struct buffer_head * bh,
  * to brelse() it when appropriate.
  */
 static struct buffer_head * ext4_find_entry (struct dentry *dentry,
-					struct ext4_dir_entry_2 ** res_dir)
+					struct ext4_dir_entry_2 ** res_dir,
+					struct cred *cred)
 {
 	struct super_block * sb;
 	struct buffer_head * bh_use[NAMEI_RA_SIZE];
@@ -871,7 +883,7 @@ static struct buffer_head * ext4_find_entry (struct dentry *dentry,
 		return NULL;
 #ifdef CONFIG_EXT4_INDEX
 	if (is_dx(dir)) {
-		bh = ext4_dx_find_entry(dentry, res_dir, &err);
+		bh = ext4_dx_find_entry(dentry, res_dir, &err, cred);
 		/*
 		 * On success, or if the error was file not found,
 		 * return.  Otherwise, fall back to doing a search the
@@ -907,7 +919,7 @@ restart:
 					break;
 				}
 				num++;
-				bh = ext4_getblk(NULL, dir, b++, 0, &err);
+				bh = ext4_getblk(NULL, dir, b++, 0, &err, cred);
 				bh_use[ra_max] = bh;
 				if (bh)
 					ll_rw_block(READ_META, 1, &bh);
@@ -959,7 +971,8 @@ cleanup_and_exit:
 
 #ifdef CONFIG_EXT4_INDEX
 static struct buffer_head * ext4_dx_find_entry(struct dentry *dentry,
-		       struct ext4_dir_entry_2 **res_dir, int *err)
+		       struct ext4_dir_entry_2 **res_dir, int *err,
+		       struct cred *cred)
 {
 	struct super_block * sb;
 	struct dx_hash_info	hinfo;
@@ -976,7 +989,8 @@ static struct buffer_head * ext4_dx_find_entry(struct dentry *dentry,
 	sb = dir->i_sb;
 	/* NFS may look up ".." - look at dx_root directory block */
 	if (namelen > 2 || name[0] != '.'||(name[1] != '.' && name[1] != '\0')){
-		if (!(frame = dx_probe(dentry, NULL, &hinfo, frames, err)))
+		if (!(frame = dx_probe(dentry, NULL, &hinfo, frames, err,
+				       cred)))
 			return NULL;
 	} else {
 		frame = frames;
@@ -987,7 +1001,7 @@ static struct buffer_head * ext4_dx_find_entry(struct dentry *dentry,
 	hash = hinfo.hash;
 	do {
 		block = dx_get_block(frame->at);
-		if (!(bh = ext4_bread (NULL,dir, block, 0, err)))
+		if (!(bh = ext4_bread (NULL,dir, block, 0, err, cred)))
 			goto errout;
 		de = (struct ext4_dir_entry_2 *) bh->b_data;
 		top = (struct ext4_dir_entry_2 *) ((char *) de + sb->s_blocksize -
@@ -1009,7 +1023,7 @@ static struct buffer_head * ext4_dx_find_entry(struct dentry *dentry,
 		brelse (bh);
 		/* Check to see if we should continue to search */
 		retval = ext4_htree_next_block(dir, hash, frame,
-					       frames, NULL);
+					       frames, NULL, cred);
 		if (retval < 0) {
 			ext4_warning(sb, __FUNCTION__,
 			     "error reading index page in directory #%lu",
@@ -1029,6 +1043,7 @@ errout:
 
 static struct dentry *ext4_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
 {
+	struct cred *cred = current->cred;
 	struct inode * inode;
 	struct ext4_dir_entry_2 * de;
 	struct buffer_head * bh;
@@ -1036,7 +1051,7 @@ static struct dentry *ext4_lookup(struct inode * dir, struct dentry *dentry, str
 	if (dentry->d_name.len > EXT4_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	bh = ext4_find_entry(dentry, &de);
+	bh = ext4_find_entry(dentry, &de, cred);
 	inode = NULL;
 	if (bh) {
 		unsigned long ino = le32_to_cpu(de->inode);
@@ -1056,6 +1071,7 @@ static struct dentry *ext4_lookup(struct inode * dir, struct dentry *dentry, str
 
 struct dentry *ext4_get_parent(struct dentry *child)
 {
+	struct cred *cred = current->cred;
 	unsigned long ino;
 	struct dentry *parent;
 	struct inode *inode;
@@ -1067,7 +1083,7 @@ struct dentry *ext4_get_parent(struct dentry *child)
 	dotdot.d_name.len = 2;
 	dotdot.d_parent = child; /* confusing, isn't it! */
 
-	bh = ext4_find_entry(&dotdot, &de);
+	bh = ext4_find_entry(&dotdot, &de, cred);
 	inode = NULL;
 	if (!bh)
 		return ERR_PTR(-ENOENT);
@@ -1166,7 +1182,8 @@ static struct ext4_dir_entry_2* dx_pack_dirents(char *base, int size)
  */
 static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 			struct buffer_head **bh,struct dx_frame *frame,
-			struct dx_hash_info *hinfo, int *error)
+			struct dx_hash_info *hinfo, int *error,
+			struct cred *cred)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
 	unsigned count, continued;
@@ -1179,7 +1196,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	struct ext4_dir_entry_2 *de = NULL, *de2;
 	int	err = 0;
 
-	bh2 = ext4_append (handle, dir, &newblock, &err);
+	bh2 = ext4_append (handle, dir, &newblock, &err, cred);
 	if (!(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
@@ -1271,7 +1288,7 @@ errout:
  */
 static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 			     struct inode *inode, struct ext4_dir_entry_2 *de,
-			     struct buffer_head * bh)
+			     struct buffer_head * bh, struct cred *cred)
 {
 	struct inode	*dir = dentry->d_parent->d_inode;
 	const char	*name = dentry->d_name.name;
@@ -1344,7 +1361,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	dir->i_mtime = dir->i_ctime = ext4_current_time(dir);
 	ext4_update_dx_flag(dir);
 	dir->i_version++;
-	ext4_mark_inode_dirty(handle, dir);
+	ext4_mark_inode_dirty(handle, dir, cred);
 	BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
 	err = ext4_journal_dirty_metadata(handle, bh);
 	if (err)
@@ -1359,7 +1376,8 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
  * directory, and adds the dentry to the indexed directory.
  */
 static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
-			    struct inode *inode, struct buffer_head *bh)
+			    struct inode *inode, struct buffer_head *bh,
+			    struct cred *cred)
 {
 	struct inode	*dir = dentry->d_parent->d_inode;
 	const char	*name = dentry->d_name.name;
@@ -1387,7 +1405,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	}
 	root = (struct dx_root *) bh->b_data;
 
-	bh2 = ext4_append (handle, dir, &block, &retval);
+	bh2 = ext4_append (handle, dir, &block, &retval, cred);
 	if (!(bh2)) {
 		brelse(bh);
 		return retval;
@@ -1425,12 +1443,12 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
-	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
+	de = do_split(handle,dir, &bh, frame, &hinfo, &retval, cred);
 	dx_release (frames);
 	if (!(de))
 		return retval;
 
-	return add_dirent_to_buf(handle, dentry, inode, de, bh);
+	return add_dirent_to_buf(handle, dentry, inode, de, bh, cred);
 }
 #endif
 
@@ -1445,7 +1463,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
  * the entry, as someone else might have used it while you slept.
  */
 static int ext4_add_entry (handle_t *handle, struct dentry *dentry,
-	struct inode *inode)
+	struct inode *inode, struct cred *cred)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	unsigned long offset;
@@ -1465,37 +1483,39 @@ static int ext4_add_entry (handle_t *handle, struct dentry *dentry,
 		return -EINVAL;
 #ifdef CONFIG_EXT4_INDEX
 	if (is_dx(dir)) {
-		retval = ext4_dx_add_entry(handle, dentry, inode);
+		retval = ext4_dx_add_entry(handle, dentry, inode, cred);
 		if (!retval || (retval != ERR_BAD_DX_DIR))
 			return retval;
 		EXT4_I(dir)->i_flags &= ~EXT4_INDEX_FL;
 		dx_fallback++;
-		ext4_mark_inode_dirty(handle, dir);
+		ext4_mark_inode_dirty(handle, dir, cred);
 	}
 #endif
 	blocks = dir->i_size >> sb->s_blocksize_bits;
 	for (block = 0, offset = 0; block < blocks; block++) {
-		bh = ext4_bread(handle, dir, block, 0, &retval);
+		bh = ext4_bread(handle, dir, block, 0, &retval, cred);
 		if(!bh)
 			return retval;
-		retval = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
+		retval = add_dirent_to_buf(handle, dentry, inode, NULL, bh,
+					   cred);
 		if (retval != -ENOSPC)
 			return retval;
 
 #ifdef CONFIG_EXT4_INDEX
 		if (blocks == 1 && !dx_fallback &&
 		    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX))
-			return make_indexed_dir(handle, dentry, inode, bh);
+			return make_indexed_dir(handle, dentry, inode, bh,
+						cred);
 #endif
 		brelse(bh);
 	}
-	bh = ext4_append(handle, dir, &block, &retval);
+	bh = ext4_append(handle, dir, &block, &retval, cred);
 	if (!bh)
 		return retval;
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
 	de->inode = 0;
 	de->rec_len = cpu_to_le16(blocksize);
-	return add_dirent_to_buf(handle, dentry, inode, de, bh);
+	return add_dirent_to_buf(handle, dentry, inode, de, bh, cred);
 }
 
 #ifdef CONFIG_EXT4_INDEX
@@ -1503,7 +1523,7 @@ static int ext4_add_entry (handle_t *handle, struct dentry *dentry,
  * Returns 0 for success, or a negative error value
  */
 static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
-			     struct inode *inode)
+			     struct inode *inode, struct cred *cred)
 {
 	struct dx_frame frames[2], *frame;
 	struct dx_entry *entries, *at;
@@ -1514,13 +1534,14 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 	struct ext4_dir_entry_2 *de;
 	int err;
 
-	frame = dx_probe(dentry, NULL, &hinfo, frames, &err);
+	frame = dx_probe(dentry, NULL, &hinfo, frames, &err, cred);
 	if (!frame)
 		return err;
 	entries = frame->entries;
 	at = frame->at;
 
-	if (!(bh = ext4_bread(handle,dir, dx_get_block(frame->at), 0, &err)))
+	if (!(bh = ext4_bread(handle,dir, dx_get_block(frame->at), 0, &err,
+			      cred)))
 		goto cleanup;
 
 	BUFFER_TRACE(bh, "get_write_access");
@@ -1528,7 +1549,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 	if (err)
 		goto journal_error;
 
-	err = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
+	err = add_dirent_to_buf(handle, dentry, inode, NULL, bh, cred);
 	if (err != -ENOSPC) {
 		bh = NULL;
 		goto cleanup;
@@ -1553,7 +1574,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			err = -ENOSPC;
 			goto cleanup;
 		}
-		bh2 = ext4_append (handle, dir, &newblock, &err);
+		bh2 = ext4_append (handle, dir, &newblock, &err, cred);
 		if (!(bh2))
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
@@ -1618,10 +1639,10 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 		}
 		ext4_journal_dirty_metadata(handle, frames[0].bh);
 	}
-	de = do_split(handle, dir, &bh, frame, &hinfo, &err);
+	de = do_split(handle, dir, &bh, frame, &hinfo, &err, cred);
 	if (!de)
 		goto cleanup;
-	err = add_dirent_to_buf(handle, dentry, inode, de, bh);
+	err = add_dirent_to_buf(handle, dentry, inode, de, bh, cred);
 	bh = NULL;
 	goto cleanup;
 
@@ -1705,11 +1726,11 @@ static void ext4_dec_count(handle_t *handle, struct inode *inode)
 
 
 static int ext4_add_nondir(handle_t *handle,
-		struct dentry *dentry, struct inode *inode)
+		struct dentry *dentry, struct inode *inode, struct cred *cred)
 {
-	int err = ext4_add_entry(handle, dentry, inode);
+	int err = ext4_add_entry(handle, dentry, inode, cred);
 	if (!err) {
-		ext4_mark_inode_dirty(handle, inode);
+		ext4_mark_inode_dirty(handle, inode, cred);
 		d_instantiate(dentry, inode);
 		return 0;
 	}
@@ -1729,6 +1750,7 @@ static int ext4_add_nondir(handle_t *handle,
 static int ext4_create (struct inode * dir, struct dentry * dentry, int mode,
 		struct nameidata *nd)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * inode;
 	int err, retries = 0;
@@ -1743,16 +1765,17 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, mode);
+	inode = ext4_new_inode (handle, dir, mode, cred);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
 		ext4_set_aops(inode);
-		err = ext4_add_nondir(handle, dentry, inode);
+		err = ext4_add_nondir(handle, dentry, inode, cred);
 	}
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC &&
+	    ext4_should_retry_alloc(dir->i_sb, &retries, cred))
 		goto retry;
 	return err;
 }
@@ -1760,6 +1783,7 @@ retry:
 static int ext4_mknod (struct inode * dir, struct dentry *dentry,
 			int mode, dev_t rdev)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode *inode;
 	int err, retries = 0;
@@ -1777,23 +1801,25 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, mode);
+	inode = ext4_new_inode (handle, dir, mode, cred);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
 #ifdef CONFIG_EXT4DEV_FS_XATTR
 		inode->i_op = &ext4_special_inode_operations;
 #endif
-		err = ext4_add_nondir(handle, dentry, inode);
+		err = ext4_add_nondir(handle, dentry, inode, cred);
 	}
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC &&
+	    ext4_should_retry_alloc(dir->i_sb, &retries, cred))
 		goto retry;
 	return err;
 }
 
 static int ext4_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * inode;
 	struct buffer_head * dir_block;
@@ -1813,7 +1839,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, S_IFDIR | mode);
+	inode = ext4_new_inode (handle, dir, S_IFDIR | mode, cred);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
@@ -1821,10 +1847,10 @@ retry:
 	inode->i_op = &ext4_dir_inode_operations;
 	inode->i_fop = &ext4_dir_operations;
 	inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-	dir_block = ext4_bread (handle, inode, 0, 1, &err);
+	dir_block = ext4_bread (handle, inode, 0, 1, &err, cred);
 	if (!dir_block) {
 		ext4_dec_count(handle, inode); /* is this nlink == 0? */
-		ext4_mark_inode_dirty(handle, inode);
+		ext4_mark_inode_dirty(handle, inode, cred);
 		iput (inode);
 		goto out_stop;
 	}
@@ -1847,21 +1873,22 @@ retry:
 	BUFFER_TRACE(dir_block, "call ext4_journal_dirty_metadata");
 	ext4_journal_dirty_metadata(handle, dir_block);
 	brelse (dir_block);
-	ext4_mark_inode_dirty(handle, inode);
-	err = ext4_add_entry (handle, dentry, inode);
+	ext4_mark_inode_dirty(handle, inode, cred);
+	err = ext4_add_entry (handle, dentry, inode, cred);
 	if (err) {
 		inode->i_nlink = 0;
-		ext4_mark_inode_dirty(handle, inode);
+		ext4_mark_inode_dirty(handle, inode, cred);
 		iput (inode);
 		goto out_stop;
 	}
 	ext4_inc_count(handle, dir);
 	ext4_update_dx_flag(dir);
-	ext4_mark_inode_dirty(handle, dir);
+	ext4_mark_inode_dirty(handle, dir, cred);
 	d_instantiate(dentry, inode);
 out_stop:
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC &&
+	    ext4_should_retry_alloc(dir->i_sb, &retries, cred))
 		goto retry;
 	return err;
 }
@@ -1869,7 +1896,7 @@ out_stop:
 /*
  * routine to check that the specified directory is empty (for rmdir)
  */
-static int empty_dir (struct inode * inode)
+static int empty_dir (struct inode * inode, struct cred *cred)
 {
 	unsigned long offset;
 	struct buffer_head * bh;
@@ -1879,7 +1906,7 @@ static int empty_dir (struct inode * inode)
 
 	sb = inode->i_sb;
 	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2) ||
-	    !(bh = ext4_bread (NULL, inode, 0, 0, &err))) {
+	    !(bh = ext4_bread (NULL, inode, 0, 0, &err, cred))) {
 		if (err)
 			ext4_error(inode->i_sb, __FUNCTION__,
 				   "error %d reading directory #%lu offset 0",
@@ -1912,7 +1939,8 @@ static int empty_dir (struct inode * inode)
 			err = 0;
 			brelse (bh);
 			bh = ext4_bread (NULL, inode,
-				offset >> EXT4_BLOCK_SIZE_BITS(sb), 0, &err);
+				offset >> EXT4_BLOCK_SIZE_BITS(sb), 0, &err,
+				cred);
 			if (!bh) {
 				if (err)
 					ext4_error(sb, __FUNCTION__,
@@ -2086,6 +2114,7 @@ out_brelse:
 
 static int ext4_rmdir (struct inode * dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	int retval;
 	struct inode * inode;
 	struct buffer_head * bh;
@@ -2100,7 +2129,7 @@ static int ext4_rmdir (struct inode * dir, struct dentry *dentry)
 		return PTR_ERR(handle);
 
 	retval = -ENOENT;
-	bh = ext4_find_entry (dentry, &de);
+	bh = ext4_find_entry (dentry, &de, cred);
 	if (!bh)
 		goto end_rmdir;
 
@@ -2114,7 +2143,7 @@ static int ext4_rmdir (struct inode * dir, struct dentry *dentry)
 		goto end_rmdir;
 
 	retval = -ENOTEMPTY;
-	if (!empty_dir (inode))
+	if (!empty_dir (inode, cred))
 		goto end_rmdir;
 
 	retval = ext4_delete_entry(handle, dir, de, bh);
@@ -2132,10 +2161,10 @@ static int ext4_rmdir (struct inode * dir, struct dentry *dentry)
 	inode->i_size = 0;
 	ext4_orphan_add(handle, inode);
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = ext4_current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	ext4_mark_inode_dirty(handle, inode, cred);
 	ext4_dec_count(handle, dir);
 	ext4_update_dx_flag(dir);
-	ext4_mark_inode_dirty(handle, dir);
+	ext4_mark_inode_dirty(handle, dir, cred);
 
 end_rmdir:
 	ext4_journal_stop(handle);
@@ -2145,6 +2174,7 @@ end_rmdir:
 
 static int ext4_unlink(struct inode * dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	int retval;
 	struct inode * inode;
 	struct buffer_head * bh;
@@ -2162,7 +2192,7 @@ static int ext4_unlink(struct inode * dir, struct dentry *dentry)
 		handle->h_sync = 1;
 
 	retval = -ENOENT;
-	bh = ext4_find_entry (dentry, &de);
+	bh = ext4_find_entry (dentry, &de, cred);
 	if (!bh)
 		goto end_unlink;
 
@@ -2183,12 +2213,12 @@ static int ext4_unlink(struct inode * dir, struct dentry *dentry)
 		goto end_unlink;
 	dir->i_ctime = dir->i_mtime = ext4_current_time(dir);
 	ext4_update_dx_flag(dir);
-	ext4_mark_inode_dirty(handle, dir);
+	ext4_mark_inode_dirty(handle, dir, cred);
 	ext4_dec_count(handle, inode);
 	if (!inode->i_nlink)
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime = ext4_current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	ext4_mark_inode_dirty(handle, inode, cred);
 	retval = 0;
 
 end_unlink:
@@ -2200,6 +2230,7 @@ end_unlink:
 static int ext4_symlink (struct inode * dir,
 		struct dentry *dentry, const char * symname)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * inode;
 	int l, err, retries = 0;
@@ -2218,7 +2249,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, S_IFLNK|S_IRWXUGO);
+	inode = ext4_new_inode (handle, dir, S_IFLNK|S_IRWXUGO, cred);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
@@ -2235,7 +2266,7 @@ retry:
 				mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 		if (err) {
 			ext4_dec_count(handle, inode);
-			ext4_mark_inode_dirty(handle, inode);
+			ext4_mark_inode_dirty(handle, inode, cred);
 			iput (inode);
 			goto out_stop;
 		}
@@ -2245,10 +2276,11 @@ retry:
 		inode->i_size = l-1;
 	}
 	EXT4_I(inode)->i_disksize = inode->i_size;
-	err = ext4_add_nondir(handle, dentry, inode);
+	err = ext4_add_nondir(handle, dentry, inode, cred);
 out_stop:
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC &&
+	    ext4_should_retry_alloc(dir->i_sb, &retries, cred))
 		goto retry;
 	return err;
 }
@@ -2256,6 +2288,7 @@ out_stop:
 static int ext4_link (struct dentry * old_dentry,
 		struct inode * dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode *inode = old_dentry->d_inode;
 	int err, retries = 0;
@@ -2283,9 +2316,10 @@ retry:
 	ext4_inc_count(handle, inode);
 	atomic_inc(&inode->i_count);
 
-	err = ext4_add_nondir(handle, dentry, inode);
+	err = ext4_add_nondir(handle, dentry, inode, cred);
 	ext4_journal_stop(handle);
-	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC &&
+	    ext4_should_retry_alloc(dir->i_sb, &retries, cred))
 		goto retry;
 	return err;
 }
@@ -2301,6 +2335,7 @@ retry:
 static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 			   struct inode * new_dir,struct dentry *new_dentry)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * old_inode, * new_inode;
 	struct buffer_head * old_bh, * new_bh, * dir_bh;
@@ -2322,7 +2357,7 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
 		handle->h_sync = 1;
 
-	old_bh = ext4_find_entry (old_dentry, &old_de);
+	old_bh = ext4_find_entry (old_dentry, &old_de, cred);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -2335,7 +2370,7 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 		goto end_rename;
 
 	new_inode = new_dentry->d_inode;
-	new_bh = ext4_find_entry (new_dentry, &new_de);
+	new_bh = ext4_find_entry (new_dentry, &new_de, cred);
 	if (new_bh) {
 		if (!new_inode) {
 			brelse (new_bh);
@@ -2345,11 +2380,11 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 	if (S_ISDIR(old_inode->i_mode)) {
 		if (new_inode) {
 			retval = -ENOTEMPTY;
-			if (!empty_dir (new_inode))
+			if (!empty_dir (new_inode, cred))
 				goto end_rename;
 		}
 		retval = -EIO;
-		dir_bh = ext4_bread (handle, old_inode, 0, 0, &retval);
+		dir_bh = ext4_bread (handle, old_inode, 0, 0, &retval, cred);
 		if (!dir_bh)
 			goto end_rename;
 		if (le32_to_cpu(PARENT_INO(dir_bh->b_data)) != old_dir->i_ino)
@@ -2360,7 +2395,7 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 			goto end_rename;
 	}
 	if (!new_bh) {
-		retval = ext4_add_entry (handle, new_dentry, old_inode);
+		retval = ext4_add_entry (handle, new_dentry, old_inode, cred);
 		if (retval)
 			goto end_rename;
 	} else {
@@ -2382,7 +2417,7 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 	 * rename.
 	 */
 	old_inode->i_ctime = ext4_current_time(old_inode);
-	ext4_mark_inode_dirty(handle, old_inode);
+	ext4_mark_inode_dirty(handle, old_inode, cred);
 
 	/*
 	 * ok, that's it
@@ -2399,7 +2434,7 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 		struct buffer_head *old_bh2;
 		struct ext4_dir_entry_2 *old_de2;
 
-		old_bh2 = ext4_find_entry(old_dentry, &old_de2);
+		old_bh2 = ext4_find_entry(old_dentry, &old_de2, cred);
 		if (old_bh2) {
 			retval = ext4_delete_entry(handle, old_dir,
 						   old_de2, old_bh2);
@@ -2432,12 +2467,12 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 		} else {
 			ext4_inc_count(handle, new_dir);
 			ext4_update_dx_flag(new_dir);
-			ext4_mark_inode_dirty(handle, new_dir);
+			ext4_mark_inode_dirty(handle, new_dir, cred);
 		}
 	}
-	ext4_mark_inode_dirty(handle, old_dir);
+	ext4_mark_inode_dirty(handle, old_dir, cred);
 	if (new_inode) {
-		ext4_mark_inode_dirty(handle, new_inode);
+		ext4_mark_inode_dirty(handle, new_inode, cred);
 		if (!new_inode->i_nlink)
 			ext4_orphan_add(handle, new_inode);
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 05434a1..f8d5bc7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2791,6 +2791,7 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	sector_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
 	int err = 0;
@@ -2808,7 +2809,7 @@ static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 	while (toread > 0) {
 		tocopy = sb->s_blocksize - offset < toread ?
 				sb->s_blocksize - offset : toread;
-		bh = ext4_bread(NULL, inode, blk, 0, &err);
+		bh = ext4_bread(NULL, inode, blk, 0, &err, cred);
 		if (err)
 			return err;
 		if (!bh)	/* A hole? */
@@ -2829,6 +2830,7 @@ static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 static ssize_t ext4_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	sector_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
 	int err = 0;
@@ -2849,7 +2851,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
 				sb->s_blocksize - offset : towrite;
-		bh = ext4_bread(handle, inode, blk, 1, &err);
+		bh = ext4_bread(handle, inode, blk, 1, &err, cred);
 		if (!bh)
 			goto out;
 		if (journal_quota) {
@@ -2887,7 +2889,7 @@ out:
 	}
 	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	ext4_mark_inode_dirty(handle, inode);
+	ext4_mark_inode_dirty(handle, inode, cred);
 	mutex_unlock(&inode->i_mutex);
 	return len - towrite;
 }
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b10d68f..0c43a31 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -686,7 +686,8 @@ cleanup:
 static int
 ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 		     struct ext4_xattr_info *i,
-		     struct ext4_xattr_block_find *bs)
+		     struct ext4_xattr_block_find *bs,
+		     struct cred *cred)
 {
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *new_bh = NULL;
@@ -814,7 +815,7 @@ inserted:
 				(ext4_fsblk_t)EXT4_I(inode)->i_block_group *
 				EXT4_BLOCKS_PER_GROUP(sb);
 			ext4_fsblk_t block = ext4_new_block(handle, inode,
-							goal, &error);
+							goal, &error, cred);
 			if (error)
 				goto cleanup;
 			ea_idebug(inode, "creating block %d", block);
@@ -947,7 +948,7 @@ ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 int
 ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		      const char *name, const void *value, size_t value_len,
-		      int flags)
+		      int flags, struct cred *cred)
 {
 	struct ext4_xattr_info i = {
 		.name_index = name_index,
@@ -1005,14 +1006,14 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		if (!is.s.not_found)
 			error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 		else if (!bs.s.not_found)
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs, cred);
 	} else {
 		error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 		if (!error && !bs.s.not_found) {
 			i.value = NULL;
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs, cred);
 		} else if (error == -ENOSPC) {
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs, cred);
 			if (error)
 				goto cleanup;
 			if (!is.s.not_found) {
@@ -1054,7 +1055,8 @@ cleanup:
  */
 int
 ext4_xattr_set(struct inode *inode, int name_index, const char *name,
-	       const void *value, size_t value_len, int flags)
+	       const void *value, size_t value_len, int flags,
+	       struct cred *cred)
 {
 	handle_t *handle;
 	int error, retries = 0;
@@ -1067,10 +1069,10 @@ retry:
 		int error2;
 
 		error = ext4_xattr_set_handle(handle, inode, name_index, name,
-					      value, value_len, flags);
+					      value, value_len, flags, cred);
 		error2 = ext4_journal_stop(handle);
 		if (error == -ENOSPC &&
-		    ext4_should_retry_alloc(inode->i_sb, &retries))
+		    ext4_should_retry_alloc(inode->i_sb, &retries, cred))
 			goto retry;
 		if (error == 0)
 			error = error2;
@@ -1109,7 +1111,8 @@ static void ext4_xattr_shift_entries(struct ext4_xattr_entry *entry,
  * Returns 0 on success or negative error number on failure.
  */
 int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
-			       struct ext4_inode *raw_inode, handle_t *handle)
+			       struct ext4_inode *raw_inode, handle_t *handle,
+			       struct cred *cred)
 {
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_xattr_entry *entry, *last, *first;
@@ -1299,7 +1302,7 @@ retry:
 			goto cleanup;
 
 		/* Add entry which was removed from the inode into the block */
-		error = ext4_xattr_block_set(handle, inode, &i, bs);
+		error = ext4_xattr_block_set(handle, inode, &i, bs, cred);
 		if (error)
 			goto cleanup;
 		kfree(b_entry_name);
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index d7f5d6a..f737d16 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -75,14 +75,15 @@ extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext4_xattr_list(struct inode *, char *, size_t);
-extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
-extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
+extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int, struct cred *);
+extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int, struct cred *);
 
 extern void ext4_xattr_delete_inode(handle_t *, struct inode *);
 extern void ext4_xattr_put_super(struct super_block *);
 
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
-			    struct ext4_inode *raw_inode, handle_t *handle);
+			    struct ext4_inode *raw_inode, handle_t *handle,
+			    struct cred *cred);
 
 extern int init_ext4_xattr(void);
 extern void exit_ext4_xattr(void);
diff --git a/fs/ext4/xattr_trusted.c b/fs/ext4/xattr_trusted.c
index e0f05ac..283e4c3 100644
--- a/fs/ext4/xattr_trusted.c
+++ b/fs/ext4/xattr_trusted.c
@@ -47,10 +47,12 @@ static int
 ext4_xattr_trusted_set(struct inode *inode, const char *name,
 		       const void *value, size_t size, int flags)
 {
+	struct cred *cred = current->cred;
+
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 	return ext4_xattr_set(inode, EXT4_XATTR_INDEX_TRUSTED, name,
-			      value, size, flags);
+			      value, size, flags, cred);
 }
 
 struct xattr_handler ext4_xattr_trusted_handler = {
diff --git a/fs/ext4/xattr_user.c b/fs/ext4/xattr_user.c
index 7ed3d8e..d3dd4de 100644
--- a/fs/ext4/xattr_user.c
+++ b/fs/ext4/xattr_user.c
@@ -47,12 +47,14 @@ static int
 ext4_xattr_user_set(struct inode *inode, const char *name,
 		    const void *value, size_t size, int flags)
 {
+	struct cred *cred = current->cred;
+
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 	if (!test_opt(inode->i_sb, XATTR_USER))
 		return -EOPNOTSUPP;
 	return ext4_xattr_set(inode, EXT4_XATTR_INDEX_USER, name,
-			      value, size, flags);
+			      value, size, flags, cred);
 }
 
 struct xattr_handler ext4_xattr_user_handler = {
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 12354d5..7fd3ae8 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -892,9 +892,10 @@ extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
 extern int ext4_bg_has_super(struct super_block *sb, int group);
 extern unsigned long ext4_bg_num_gdb(struct super_block *sb, int group);
 extern ext4_fsblk_t ext4_new_block (handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, int *errp);
+			ext4_fsblk_t goal, int *errp, struct cred *cred);
 extern ext4_fsblk_t ext4_new_blocks (handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, unsigned long *count, int *errp);
+			ext4_fsblk_t goal, unsigned long *count, int *errp,
+			struct cred *cred);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count);
 extern void ext4_free_blocks_sb (handle_t *handle, struct super_block *sb,
@@ -905,7 +906,8 @@ extern void ext4_check_blocks_bitmap (struct super_block *);
 extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 						    unsigned int block_group,
 						    struct buffer_head ** bh);
-extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);
+extern int ext4_should_retry_alloc(struct super_block *sb, int *retries,
+				   struct cred *cred);
 extern void ext4_init_block_alloc_info(struct inode *);
 extern void ext4_rsv_window_add(struct super_block *sb, struct ext4_reserve_window_node *rsv);
 
@@ -926,7 +928,8 @@ extern int ext4fs_dirhash(const char *name, int len, struct
 			  dx_hash_info *hinfo);
 
 /* ialloc.c */
-extern struct inode * ext4_new_inode (handle_t *, struct inode *, int);
+extern struct inode * ext4_new_inode (handle_t *, struct inode *, int,
+				      struct cred *);
 extern void ext4_free_inode (handle_t *, struct inode *);
 extern struct inode * ext4_orphan_get (struct super_block *, unsigned long);
 extern unsigned long ext4_count_free_inodes (struct super_block *);
@@ -938,11 +941,13 @@ extern unsigned long ext4_count_free (struct buffer_head *, unsigned);
 /* inode.c */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 		struct buffer_head *bh, ext4_fsblk_t blocknr);
-struct buffer_head * ext4_getblk (handle_t *, struct inode *, long, int, int *);
-struct buffer_head * ext4_bread (handle_t *, struct inode *, int, int, int *);
+struct buffer_head * ext4_getblk (handle_t *, struct inode *, long, int, int *,
+				  struct cred *);
+struct buffer_head * ext4_bread (handle_t *, struct inode *, int, int, int *,
+				 struct cred *);
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	sector_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
-	int create, int extend_disksize);
+	int create, int extend_disksize, struct cred *cred);
 
 extern struct inode *ext4_iget(struct super_block *, unsigned long);
 extern int  ext4_write_inode (struct inode *, int);
@@ -951,7 +956,7 @@ extern void ext4_delete_inode (struct inode *);
 extern int  ext4_sync_inode (handle_t *, struct inode *);
 extern void ext4_discard_reservation (struct inode *);
 extern void ext4_dirty_inode(struct inode *);
-extern int ext4_change_inode_journal_flag(struct inode *, int);
+extern int ext4_change_inode_journal_flag(struct inode *, int, struct cred *);
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
 extern void ext4_truncate (struct inode *);
 extern void ext4_set_inode_flags(struct inode *);
@@ -970,7 +975,8 @@ extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
 extern int ext4_orphan_add(handle_t *, struct inode *);
 extern int ext4_orphan_del(handle_t *, struct inode *);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
-				__u32 start_minor_hash, __u32 *next_hash);
+				__u32 start_minor_hash, __u32 *next_hash,
+				struct cred *cred);
 
 /* resize.c */
 extern int ext4_group_add(struct super_block *sb,
@@ -1068,13 +1074,13 @@ extern const struct inode_operations ext4_symlink_inode_operations;
 extern const struct inode_operations ext4_fast_symlink_inode_operations;
 
 /* extents.c */
-extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
+extern int ext4_ext_tree_init(handle_t *handle, struct inode *, struct cred *);
 extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
 extern int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
-			int create, int extend_disksize);
-extern void ext4_ext_truncate(struct inode *, struct page *);
+			int create, int extend_disksize, struct cred *cred);
+extern void ext4_ext_truncate(struct inode *, struct page *, struct cred *);
 extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
@@ -1082,13 +1088,13 @@ extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
 static inline int
 ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			unsigned long max_blocks, struct buffer_head *bh,
-			int create, int extend_disksize)
+			int create, int extend_disksize, struct cred *cred)
 {
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
 		return ext4_ext_get_blocks(handle, inode, block, max_blocks,
-					bh, create, extend_disksize);
+					bh, create, extend_disksize, cred);
 	return ext4_get_blocks_handle(handle, inode, block, max_blocks, bh,
-					create, extend_disksize);
+					create, extend_disksize, cred);
 }
 
 
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index 81406f3..8f38419 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -232,7 +232,7 @@ extern int ext4_ext_try_to_merge(struct inode *inode,
 				 struct ext4_ext_path *path,
 				 struct ext4_extent *);
 extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
-extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
+extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *, struct cred *);
 extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
 extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
 
diff --git a/include/linux/ext4_jbd2.h b/include/linux/ext4_jbd2.h
index d716e63..3ec5e5b 100644
--- a/include/linux/ext4_jbd2.h
+++ b/include/linux/ext4_jbd2.h
@@ -105,7 +105,8 @@ ext4_mark_iloc_dirty(handle_t *handle,
 int ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
 			struct ext4_iloc *iloc);
 
-int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode);
+int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode,
+			  struct cred *cred);
 
 /*
  * Wrapper functions with which ext4 calls into JBD.  The intent here is

