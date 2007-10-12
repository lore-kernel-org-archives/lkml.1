Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbXJLQJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbXJLQJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760219AbXJLQGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760174AbXJLQGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/52] CRED: Pass credentials down to ext3 block allocator
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:05:34 +0100
Message-ID: <20071012160534.15119.90640.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials down to the ext3 block allocator.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/acl.c            |   24 ++++--
 fs/ext3/acl.h            |    5 +
 fs/ext3/balloc.c         |   24 ++++--
 fs/ext3/dir.c            |    9 ++
 fs/ext3/ialloc.c         |    5 +
 fs/ext3/inode.c          |   35 ++++++---
 fs/ext3/namei.c          |  174 +++++++++++++++++++++++++++-------------------
 fs/ext3/super.c          |    6 +-
 fs/ext3/xattr.c          |   23 ++++--
 fs/ext3/xattr.h          |    6 +-
 fs/ext3/xattr_security.c |    7 +-
 fs/ext3/xattr_trusted.c  |    4 +
 fs/ext3/xattr_user.c     |    4 +
 include/linux/ext3_fs.h  |   22 ++++--
 14 files changed, 212 insertions(+), 136 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index d34e996..1db810a 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -221,7 +221,7 @@ ext3_get_acl(struct inode *inode, int type)
  */
 static int
 ext3_set_acl(handle_t *handle, struct inode *inode, int type,
-	     struct posix_acl *acl)
+	     struct posix_acl *acl, struct cred *cred)
 {
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	int name_index;
@@ -265,7 +265,7 @@ ext3_set_acl(handle_t *handle, struct inode *inode, int type,
 	}
 
 	error = ext3_xattr_set_handle(handle, inode, name_index, "",
-				      value, size, 0);
+				      value, size, 0, cred);
 
 	kfree(value);
 	if (!error) {
@@ -311,7 +311,8 @@ ext3_permission(struct inode *inode, int mask, struct nameidata *nd)
  * inode->i_mutex: up (access to inode is still exclusive)
  */
 int
-ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
+ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir,
+	      struct cred *cred)
 {
 	struct posix_acl *acl = NULL;
 	int error = 0;
@@ -331,7 +332,7 @@ ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
 
 		if (S_ISDIR(inode->i_mode)) {
 			error = ext3_set_acl(handle, inode,
-					     ACL_TYPE_DEFAULT, acl);
+					     ACL_TYPE_DEFAULT, acl, cred);
 			if (error)
 				goto cleanup;
 		}
@@ -347,7 +348,8 @@ ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
 			if (error > 0) {
 				/* This is an extended ACL */
 				error = ext3_set_acl(handle, inode,
-						     ACL_TYPE_ACCESS, clone);
+						     ACL_TYPE_ACCESS, clone,
+						     cred);
 			}
 		}
 		posix_acl_release(clone);
@@ -372,7 +374,7 @@ cleanup:
  * inode->i_mutex: down
  */
 int
-ext3_acl_chmod(struct inode *inode)
+ext3_acl_chmod(struct inode *inode, struct cred *cred)
 {
 	struct posix_acl *acl, *clone;
         int error;
@@ -401,10 +403,10 @@ ext3_acl_chmod(struct inode *inode)
 			ext3_std_error(inode->i_sb, error);
 			goto out;
 		}
-		error = ext3_set_acl(handle, inode, ACL_TYPE_ACCESS, clone);
+		error = ext3_set_acl(handle, inode, ACL_TYPE_ACCESS, clone, cred);
 		ext3_journal_stop(handle);
 		if (error == -ENOSPC &&
-		    ext3_should_retry_alloc(inode->i_sb, &retries))
+		    ext3_should_retry_alloc(inode->i_sb, &retries, cred))
 			goto retry;
 	}
 out:
@@ -483,6 +485,7 @@ static int
 ext3_xattr_set_acl(struct inode *inode, int type, const void *value,
 		   size_t size)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct posix_acl *acl;
 	int error, retries = 0;
@@ -508,9 +511,10 @@ retry:
 	handle = ext3_journal_start(inode, EXT3_DATA_TRANS_BLOCKS(inode->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
-	error = ext3_set_acl(handle, inode, type, acl);
+	error = ext3_set_acl(handle, inode, type, acl, cred);
 	ext3_journal_stop(handle);
-	if (error == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
+	if (error == -ENOSPC &&
+	    ext3_should_retry_alloc(inode->i_sb, &retries, cred))
 		goto retry;
 
 release_and_out:
diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
index 0d1e627..f35ccac 100644
--- a/fs/ext3/acl.h
+++ b/fs/ext3/acl.h
@@ -59,8 +59,9 @@ static inline int ext3_acl_count(size_t size)
 
 /* acl.c */
 extern int ext3_permission (struct inode *, int, struct nameidata *);
-extern int ext3_acl_chmod (struct inode *);
-extern int ext3_init_acl (handle_t *, struct inode *, struct inode *);
+extern int ext3_acl_chmod (struct inode *, struct cred *);
+extern int ext3_init_acl (handle_t *, struct inode *, struct inode *,
+			  struct cred *);
 
 #else  /* CONFIG_EXT3_FS_POSIX_ACL */
 #include <linux/sched.h>
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 316ec8b..c1ff445 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1350,19 +1350,19 @@ out:
 /**
  * ext3_has_free_blocks()
  * @sbi:		in-core super block structure.
+ * @cred:		the credentials in force
  *
  * Check if filesystem has at least 1 free block available for allocation.
  */
-static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
+static int ext3_has_free_blocks(struct ext3_sb_info *sbi, struct cred *cred)
 {
 	ext3_fsblk_t free_blocks, root_blocks;
 
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->cred->uid &&
-		(sbi->s_resgid == 0 ||
-		 !in_group_p (current->cred, sbi->s_resgid))) {
+		sbi->s_resuid != cred->uid &&
+		(sbi->s_resgid == 0 || !in_group_p(cred, sbi->s_resgid))) {
 		return 0;
 	}
 	return 1;
@@ -1372,6 +1372,7 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
  * ext3_should_retry_alloc()
  * @sb:			super block
  * @retries		number of attemps has been made
+ * @cred:		the credentials in force
  *
  * ext3_should_retry_alloc() is called when ENOSPC is returned, and if
  * it is profitable to retry the operation, this function will wait
@@ -1380,9 +1381,10 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
  *
  * if the total number of retries exceed three times, return FALSE.
  */
-int ext3_should_retry_alloc(struct super_block *sb, int *retries)
+int ext3_should_retry_alloc(struct super_block *sb, int *retries,
+			    struct cred *cred)
 {
-	if (!ext3_has_free_blocks(EXT3_SB(sb)) || (*retries)++ > 3)
+	if (!ext3_has_free_blocks(EXT3_SB(sb), cred) || (*retries)++ > 3)
 		return 0;
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
@@ -1397,6 +1399,7 @@ int ext3_should_retry_alloc(struct super_block *sb, int *retries)
  * @goal:		given target block(filesystem wide)
  * @count:		target number of blocks to allocate
  * @errp:		error code
+ * @cred:		the credentials in force
  *
  * ext3_new_blocks uses a goal block to assist allocation.  It tries to
  * allocate block(s) from the block group contains the goal block first. If that
@@ -1405,7 +1408,8 @@ int ext3_should_retry_alloc(struct super_block *sb, int *retries)
  *
  */
 ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, unsigned long *count, int *errp)
+			ext3_fsblk_t goal, unsigned long *count, int *errp,
+			struct cred *cred)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *gdp_bh;
@@ -1461,7 +1465,7 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
 		my_rsv = &block_i->rsv_window_node;
 
-	if (!ext3_has_free_blocks(sbi)) {
+	if (!ext3_has_free_blocks(sbi, cred)) {
 		*errp = -ENOSPC;
 		goto out;
 	}
@@ -1668,11 +1672,11 @@ out:
 }
 
 ext3_fsblk_t ext3_new_block(handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, int *errp)
+			ext3_fsblk_t goal, int *errp, struct cred *cred)
 {
 	unsigned long count = 1;
 
-	return ext3_new_blocks(handle, inode, goal, &count, errp);
+	return ext3_new_blocks(handle, inode, goal, &count, errp, cred);
 }
 
 /**
diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index c00723a..d745f99 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -96,6 +96,7 @@ int ext3_check_dir_entry (const char * function, struct inode * dir,
 static int ext3_readdir(struct file * filp,
 			 void * dirent, filldir_t filldir)
 {
+	struct cred *cred = filp->f_cred;
 	int error = 0;
 	unsigned long offset;
 	int i, stored;
@@ -134,7 +135,7 @@ static int ext3_readdir(struct file * filp,
 
 		map_bh.b_state = 0;
 		err = ext3_get_blocks_handle(NULL, inode, blk, 1,
-						&map_bh, 0, 0);
+						&map_bh, 0, 0, cred);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
@@ -144,7 +145,7 @@ static int ext3_readdir(struct file * filp,
 					&filp->f_ra, filp,
 					index, 1);
 			filp->f_ra.prev_index = index;
-			bh = ext3_bread(NULL, inode, blk, 0, &err);
+			bh = ext3_bread(NULL, inode, blk, 0, &err, cred);
 		}
 
 		/*
@@ -432,6 +433,7 @@ static int call_filldir(struct file * filp, void * dirent,
 static int ext3_dx_readdir(struct file * filp,
 			 void * dirent, filldir_t filldir)
 {
+	struct cred *cred = filp->f_cred;
 	struct dir_private_info *info = filp->private_data;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct fname *fname;
@@ -480,7 +482,8 @@ static int ext3_dx_readdir(struct file * filp,
 			filp->f_version = inode->i_version;
 			ret = ext3_htree_fill_tree(filp, info->curr_hash,
 						   info->curr_minor_hash,
-						   &info->next_hash);
+						   &info->next_hash,
+						   cred);
 			if (ret < 0)
 				return ret;
 			if (ret == 0) {
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 195e9e8..596d8ca 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -421,7 +421,8 @@ static int find_group_other(struct super_block *sb, struct inode *parent)
  * For other inodes, search forward from the parent directory's block
  * group to find a free inode.
  */
-struct inode *ext3_new_inode(handle_t *handle, struct inode * dir, int mode)
+struct inode *ext3_new_inode(handle_t *handle, struct inode * dir, int mode,
+			     struct cred *cred)
 {
 	struct super_block *sb;
 	struct buffer_head *bitmap_bh = NULL;
@@ -602,7 +603,7 @@ got:
 		goto fail_drop;
 	}
 
-	err = ext3_init_acl(handle, inode, dir);
+	err = ext3_init_acl(handle, inode, dir, cred);
 	if (err)
 		goto fail_free_drop;
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 6c74622..57a2e74 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -513,10 +513,12 @@ static int ext3_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
  *	the indirect blocks(if needed) and the first direct block,
  *	@blks:	on return it will store the total number of allocated
  *		direct blocks
+ *	@cred:	the credentials in force
  */
 static int ext3_alloc_blocks(handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, int indirect_blks, int blks,
-			ext3_fsblk_t new_blocks[4], int *err)
+			ext3_fsblk_t new_blocks[4], int *err,
+			struct cred *cred)
 {
 	int target, i;
 	unsigned long count = 0;
@@ -537,7 +539,8 @@ static int ext3_alloc_blocks(handle_t *handle, struct inode *inode,
 	while (1) {
 		count = target;
 		/* allocating blocks for indirect blocks and direct blocks */
-		current_block = ext3_new_blocks(handle,inode,goal,&count,err);
+		current_block = ext3_new_blocks(handle,inode,goal,&count,err,
+						cred);
 		if (*err)
 			goto failed_out;
 
@@ -572,6 +575,7 @@ failed_out:
  *	@blks: number of allocated direct blocks
  *	@offsets: offsets (in the blocks) to store the pointers to next.
  *	@branch: place to store the chain in.
+ *	@cred:	the credentials in force
  *
  *	This function allocates blocks, zeroes out all but the last one,
  *	links them into chain and (if we are synchronous) writes them to disk.
@@ -592,7 +596,7 @@ failed_out:
  */
 static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
 			int indirect_blks, int *blks, ext3_fsblk_t goal,
-			int *offsets, Indirect *branch)
+			int *offsets, Indirect *branch, struct cred *cred)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int i, n = 0;
@@ -603,7 +607,7 @@ static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
 	ext3_fsblk_t current_block;
 
 	num = ext3_alloc_blocks(handle, inode, goal, indirect_blks,
-				*blks, new_blocks, &err);
+				*blks, new_blocks, &err, cred);
 	if (err)
 		return err;
 
@@ -788,7 +792,7 @@ err_out:
 int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 		sector_t iblock, unsigned long maxblocks,
 		struct buffer_head *bh_result,
-		int create, int extend_disksize)
+		int create, int extend_disksize, struct cred *cred)
 {
 	int err = -EIO;
 	int offsets[4];
@@ -899,7 +903,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	 * Block out ext3_truncate while we alter the tree
 	 */
 	err = ext3_alloc_branch(handle, inode, indirect_blks, &count, goal,
-				offsets + (partial - chain), partial);
+				offsets + (partial - chain), partial, cred);
 
 	/*
 	 * The ext3_splice_branch call will free and forget any buffers
@@ -946,6 +950,7 @@ out:
 static int ext3_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle = ext3_journal_current_handle();
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
@@ -984,7 +989,7 @@ static int ext3_get_block(struct inode *inode, sector_t iblock,
 get_block:
 	if (ret == 0) {
 		ret = ext3_get_blocks_handle(handle, inode, iblock,
-					max_blocks, bh_result, create, 0);
+					max_blocks, bh_result, create, 0, cred);
 		if (ret > 0) {
 			bh_result->b_size = (ret << inode->i_blkbits);
 			ret = 0;
@@ -997,7 +1002,8 @@ get_block:
  * `handle' can be NULL if create is zero
  */
 struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
-				long block, int create, int *errp)
+				long block, int create, int *errp,
+				struct cred *cred)
 {
 	struct buffer_head dummy;
 	int fatal = 0, err;
@@ -1008,7 +1014,7 @@ struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
 	dummy.b_blocknr = -1000;
 	buffer_trace_init(&dummy.b_history);
 	err = ext3_get_blocks_handle(handle, inode, block, 1,
-					&dummy, create, 1);
+					&dummy, create, 1, cred);
 	/*
 	 * ext3_get_blocks_handle() returns number of blocks
 	 * mapped. 0 in case of a HOLE.
@@ -1064,11 +1070,12 @@ err:
 }
 
 struct buffer_head *ext3_bread(handle_t *handle, struct inode *inode,
-			       int block, int create, int *err)
+			       int block, int create, int *err,
+			       struct cred *cred)
 {
 	struct buffer_head * bh;
 
-	bh = ext3_getblk(handle, inode, block, create, err);
+	bh = ext3_getblk(handle, inode, block, create, err, cred);
 	if (!bh)
 		return bh;
 	if (buffer_uptodate(bh))
@@ -1175,7 +1182,8 @@ retry:
 prepare_write_failed:
 	if (ret)
 		ext3_journal_stop(handle);
-	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == -ENOSPC &&
+	    ext3_should_retry_alloc(inode->i_sb, &retries, file->f_cred))
 		goto retry;
 out:
 	return ret;
@@ -2930,6 +2938,7 @@ int ext3_write_inode(struct inode *inode, int wait)
  */
 int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
 	const unsigned int ia_valid = attr->ia_valid;
@@ -2992,7 +3001,7 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 		ext3_orphan_del(NULL, inode);
 
 	if (!rc && (ia_valid & ATTR_MODE))
-		rc = ext3_acl_chmod(inode);
+		rc = ext3_acl_chmod(inode, cred);
 
 err_out:
 	ext3_std_error(inode->i_sb, error);
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 6919a18..4a6adaa 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -51,13 +51,14 @@
 
 static struct buffer_head *ext3_append(handle_t *handle,
 					struct inode *inode,
-					u32 *block, int *err)
+					u32 *block, int *err,
+					struct cred *cred)
 {
 	struct buffer_head *bh;
 
 	*block = inode->i_size >> inode->i_sb->s_blocksize_bits;
 
-	if ((bh = ext3_bread(handle, inode, *block, 1, err))) {
+	if ((bh = ext3_bread(handle, inode, *block, 1, err, cred))) {
 		inode->i_size += inode->i_sb->s_blocksize;
 		EXT3_I(inode)->i_disksize = inode->i_size;
 		ext3_journal_get_write_access(handle,bh);
@@ -159,7 +160,8 @@ static struct dx_frame *dx_probe(struct dentry *dentry,
 				 struct inode *dir,
 				 struct dx_hash_info *hinfo,
 				 struct dx_frame *frame,
-				 int *err);
+				 int *err,
+				 struct cred *cred);
 static void dx_release (struct dx_frame *frames);
 static int dx_make_map (struct ext3_dir_entry_2 *de, int size,
 			struct dx_hash_info *hinfo, struct dx_map_entry map[]);
@@ -171,11 +173,13 @@ static void dx_insert_block (struct dx_frame *frame, u32 hash, u32 block);
 static int ext3_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
 				 struct dx_frame *frames,
-				 __u32 *start_hash);
+				 __u32 *start_hash,
+				 struct cred *cred);
 static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
-		       struct ext3_dir_entry_2 **res_dir, int *err);
+		       struct ext3_dir_entry_2 **res_dir, int *err,
+		       struct cred *cred);
 static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
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
-	if (!(bh = ext3_bread (NULL,dir, 0, 0, err)))
+	if (!(bh = ext3_bread (NULL,dir, 0, 0, err, cred)))
 		goto fail;
 	root = (struct dx_root *) bh->b_data;
 	if (root->info.hash_version != DX_HASH_TEA &&
@@ -436,7 +441,8 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 		frame->entries = entries;
 		frame->at = at;
 		if (!indirect--) return frame;
-		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err)))
+		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err,
+				       cred)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
 		if (dx_get_limit(entries) != dx_node_limit (dir)) {
@@ -492,7 +498,8 @@ static void dx_release (struct dx_frame *frames)
 static int ext3_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
 				 struct dx_frame *frames,
-				 __u32 *start_hash)
+				 __u32 *start_hash,
+				 struct cred *cred)
 {
 	struct dx_frame *p;
 	struct buffer_head *bh;
@@ -536,7 +543,7 @@ static int ext3_htree_next_block(struct inode *dir, __u32 hash,
 	 */
 	while (num_frames--) {
 		if (!(bh = ext3_bread(NULL, dir, dx_get_block(p->at),
-				      0, &err)))
+				      0, &err, cred)))
 			return err; /* Failure */
 		p++;
 		brelse (p->bh);
@@ -563,14 +570,15 @@ static inline struct ext3_dir_entry_2 *ext3_next_entry(struct ext3_dir_entry_2 *
 static int htree_dirblock_to_tree(struct file *dir_file,
 				  struct inode *dir, int block,
 				  struct dx_hash_info *hinfo,
-				  __u32 start_hash, __u32 start_minor_hash)
+				  __u32 start_hash, __u32 start_minor_hash,
+				  struct cred *cred)
 {
 	struct buffer_head *bh;
 	struct ext3_dir_entry_2 *de, *top;
 	int err, count = 0;
 
 	dxtrace(printk("In htree dirblock_to_tree: block %d\n", block));
-	if (!(bh = ext3_bread (NULL, dir, block, 0, &err)))
+	if (!(bh = ext3_bread (NULL, dir, block, 0, &err, cred)))
 		return err;
 
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
@@ -615,7 +623,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
  * or a negative error code.
  */
 int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
-			 __u32 start_minor_hash, __u32 *next_hash)
+			 __u32 start_minor_hash, __u32 *next_hash,
+			 struct cred *cred)
 {
 	struct dx_hash_info hinfo;
 	struct ext3_dir_entry_2 *de;
@@ -633,13 +642,15 @@ int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		hinfo.hash_version = EXT3_SB(dir->i_sb)->s_def_hash_version;
 		hinfo.seed = EXT3_SB(dir->i_sb)->s_hash_seed;
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
 
@@ -661,7 +672,8 @@ int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	while (1) {
 		block = dx_get_block(frame->at);
 		ret = htree_dirblock_to_tree(dir_file, dir, block, &hinfo,
-					     start_hash, start_minor_hash);
+					     start_hash, start_minor_hash,
+					     cred);
 		if (ret < 0) {
 			err = ret;
 			goto errout;
@@ -669,7 +681,7 @@ int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		count += ret;
 		hashval = ~0;
 		ret = ext3_htree_next_block(dir, HASH_NB_ALWAYS,
-					    frame, frames, &hashval);
+					    frame, frames, &hashval, cred);
 		*next_hash = hashval;
 		if (ret < 0) {
 			err = ret;
@@ -847,7 +859,8 @@ static inline int search_dirblock(struct buffer_head * bh,
  * to brelse() it when appropriate.
  */
 static struct buffer_head * ext3_find_entry (struct dentry *dentry,
-					struct ext3_dir_entry_2 ** res_dir)
+					struct ext3_dir_entry_2 ** res_dir,
+					struct cred *cred)
 {
 	struct super_block * sb;
 	struct buffer_head * bh_use[NAMEI_RA_SIZE];
@@ -873,7 +886,7 @@ static struct buffer_head * ext3_find_entry (struct dentry *dentry,
 		return NULL;
 #ifdef CONFIG_EXT3_INDEX
 	if (is_dx(dir)) {
-		bh = ext3_dx_find_entry(dentry, res_dir, &err);
+		bh = ext3_dx_find_entry(dentry, res_dir, &err, cred);
 		/*
 		 * On success, or if the error was file not found,
 		 * return.  Otherwise, fall back to doing a search the
@@ -909,7 +922,7 @@ restart:
 					break;
 				}
 				num++;
-				bh = ext3_getblk(NULL, dir, b++, 0, &err);
+				bh = ext3_getblk(NULL, dir, b++, 0, &err, cred);
 				bh_use[ra_max] = bh;
 				if (bh)
 					ll_rw_block(READ_META, 1, &bh);
@@ -961,7 +974,8 @@ cleanup_and_exit:
 
 #ifdef CONFIG_EXT3_INDEX
 static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
-		       struct ext3_dir_entry_2 **res_dir, int *err)
+		       struct ext3_dir_entry_2 **res_dir, int *err,
+		       struct cred *cred)
 {
 	struct super_block * sb;
 	struct dx_hash_info	hinfo;
@@ -978,7 +992,8 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 	sb = dir->i_sb;
 	/* NFS may look up ".." - look at dx_root directory block */
 	if (namelen > 2 || name[0] != '.'||(name[1] != '.' && name[1] != '\0')){
-		if (!(frame = dx_probe(dentry, NULL, &hinfo, frames, err)))
+		if (!(frame = dx_probe(dentry, NULL, &hinfo, frames, err,
+				       cred)))
 			return NULL;
 	} else {
 		frame = frames;
@@ -989,7 +1004,7 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 	hash = hinfo.hash;
 	do {
 		block = dx_get_block(frame->at);
-		if (!(bh = ext3_bread (NULL,dir, block, 0, err)))
+		if (!(bh = ext3_bread (NULL,dir, block, 0, err, cred)))
 			goto errout;
 		de = (struct ext3_dir_entry_2 *) bh->b_data;
 		top = (struct ext3_dir_entry_2 *) ((char *) de + sb->s_blocksize -
@@ -1011,7 +1026,7 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 		brelse (bh);
 		/* Check to see if we should continue to search */
 		retval = ext3_htree_next_block(dir, hash, frame,
-					       frames, NULL);
+					       frames, NULL, cred);
 		if (retval < 0) {
 			ext3_warning(sb, __FUNCTION__,
 			     "error reading index page in directory #%lu",
@@ -1031,6 +1046,7 @@ errout:
 
 static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
 {
+	struct cred *cred = current->cred;
 	struct inode * inode;
 	struct ext3_dir_entry_2 * de;
 	struct buffer_head * bh;
@@ -1038,7 +1054,7 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 	if (dentry->d_name.len > EXT3_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	bh = ext3_find_entry(dentry, &de);
+	bh = ext3_find_entry(dentry, &de, cred);
 	inode = NULL;
 	if (bh) {
 		unsigned long ino = le32_to_cpu(de->inode);
@@ -1058,6 +1074,7 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 
 struct dentry *ext3_get_parent(struct dentry *child)
 {
+	struct cred *cred = current->cred;
 	unsigned long ino;
 	struct dentry *parent;
 	struct inode *inode;
@@ -1069,7 +1086,7 @@ struct dentry *ext3_get_parent(struct dentry *child)
 	dotdot.d_name.len = 2;
 	dotdot.d_parent = child; /* confusing, isn't it! */
 
-	bh = ext3_find_entry(&dotdot, &de);
+	bh = ext3_find_entry(&dotdot, &de, cred);
 	inode = NULL;
 	if (!bh)
 		return ERR_PTR(-ENOENT);
@@ -1168,7 +1185,8 @@ static struct ext3_dir_entry_2* dx_pack_dirents(char *base, int size)
  */
 static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 			struct buffer_head **bh,struct dx_frame *frame,
-			struct dx_hash_info *hinfo, int *error)
+			struct dx_hash_info *hinfo, int *error,
+			struct cred *cred)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
 	unsigned count, continued;
@@ -1181,7 +1199,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	struct ext3_dir_entry_2 *de = NULL, *de2;
 	int	err = 0;
 
-	bh2 = ext3_append (handle, dir, &newblock, &err);
+	bh2 = ext3_append (handle, dir, &newblock, &err, cred);
 	if (!(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
@@ -1361,7 +1379,8 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
  * directory, and adds the dentry to the indexed directory.
  */
 static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
-			    struct inode *inode, struct buffer_head *bh)
+			    struct inode *inode, struct buffer_head *bh,
+			    struct cred *cred)
 {
 	struct inode	*dir = dentry->d_parent->d_inode;
 	const char	*name = dentry->d_name.name;
@@ -1389,7 +1408,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	}
 	root = (struct dx_root *) bh->b_data;
 
-	bh2 = ext3_append (handle, dir, &block, &retval);
+	bh2 = ext3_append (handle, dir, &block, &retval, cred);
 	if (!(bh2)) {
 		brelse(bh);
 		return retval;
@@ -1427,7 +1446,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
-	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
+	de = do_split(handle,dir, &bh, frame, &hinfo, &retval, cred);
 	dx_release (frames);
 	if (!(de))
 		return retval;
@@ -1447,7 +1466,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
  * the entry, as someone else might have used it while you slept.
  */
 static int ext3_add_entry (handle_t *handle, struct dentry *dentry,
-	struct inode *inode)
+	struct inode *inode, struct cred *cred)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	unsigned long offset;
@@ -1467,7 +1486,7 @@ static int ext3_add_entry (handle_t *handle, struct dentry *dentry,
 		return -EINVAL;
 #ifdef CONFIG_EXT3_INDEX
 	if (is_dx(dir)) {
-		retval = ext3_dx_add_entry(handle, dentry, inode);
+		retval = ext3_dx_add_entry(handle, dentry, inode, cred);
 		if (!retval || (retval != ERR_BAD_DX_DIR))
 			return retval;
 		EXT3_I(dir)->i_flags &= ~EXT3_INDEX_FL;
@@ -1477,7 +1496,7 @@ static int ext3_add_entry (handle_t *handle, struct dentry *dentry,
 #endif
 	blocks = dir->i_size >> sb->s_blocksize_bits;
 	for (block = 0, offset = 0; block < blocks; block++) {
-		bh = ext3_bread(handle, dir, block, 0, &retval);
+		bh = ext3_bread(handle, dir, block, 0, &retval, cred);
 		if(!bh)
 			return retval;
 		retval = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
@@ -1487,11 +1506,11 @@ static int ext3_add_entry (handle_t *handle, struct dentry *dentry,
 #ifdef CONFIG_EXT3_INDEX
 		if (blocks == 1 && !dx_fallback &&
 		    EXT3_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_DIR_INDEX))
-			return make_indexed_dir(handle, dentry, inode, bh);
+			return make_indexed_dir(handle, dentry, inode, bh, cred);
 #endif
 		brelse(bh);
 	}
-	bh = ext3_append(handle, dir, &block, &retval);
+	bh = ext3_append(handle, dir, &block, &retval, cred);
 	if (!bh)
 		return retval;
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
@@ -1505,7 +1524,7 @@ static int ext3_add_entry (handle_t *handle, struct dentry *dentry,
  * Returns 0 for success, or a negative error value
  */
 static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
-			     struct inode *inode)
+			     struct inode *inode, struct cred *cred)
 {
 	struct dx_frame frames[2], *frame;
 	struct dx_entry *entries, *at;
@@ -1516,13 +1535,14 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 	struct ext3_dir_entry_2 *de;
 	int err;
 
-	frame = dx_probe(dentry, NULL, &hinfo, frames, &err);
+	frame = dx_probe(dentry, NULL, &hinfo, frames, &err, cred);
 	if (!frame)
 		return err;
 	entries = frame->entries;
 	at = frame->at;
 
-	if (!(bh = ext3_bread(handle,dir, dx_get_block(frame->at), 0, &err)))
+	if (!(bh = ext3_bread(handle,dir, dx_get_block(frame->at), 0, &err,
+			      cred)))
 		goto cleanup;
 
 	BUFFER_TRACE(bh, "get_write_access");
@@ -1555,7 +1575,7 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			err = -ENOSPC;
 			goto cleanup;
 		}
-		bh2 = ext3_append (handle, dir, &newblock, &err);
+		bh2 = ext3_append (handle, dir, &newblock, &err, cred);
 		if (!(bh2))
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
@@ -1620,7 +1640,7 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 		}
 		ext3_journal_dirty_metadata(handle, frames[0].bh);
 	}
-	de = do_split(handle, dir, &bh, frame, &hinfo, &err);
+	de = do_split(handle, dir, &bh, frame, &hinfo, &err, cred);
 	if (!de)
 		goto cleanup;
 	err = add_dirent_to_buf(handle, dentry, inode, de, bh);
@@ -1678,9 +1698,9 @@ static int ext3_delete_entry (handle_t *handle,
 }
 
 static int ext3_add_nondir(handle_t *handle,
-		struct dentry *dentry, struct inode *inode)
+		struct dentry *dentry, struct inode *inode, struct cred *cred)
 {
-	int err = ext3_add_entry(handle, dentry, inode);
+	int err = ext3_add_entry(handle, dentry, inode, cred);
 	if (!err) {
 		ext3_mark_inode_dirty(handle, inode);
 		d_instantiate(dentry, inode);
@@ -1702,6 +1722,7 @@ static int ext3_add_nondir(handle_t *handle,
 static int ext3_create (struct inode * dir, struct dentry * dentry, int mode,
 		struct nameidata *nd)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * inode;
 	int err, retries = 0;
@@ -1716,16 +1737,16 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext3_new_inode (handle, dir, mode);
+	inode = ext3_new_inode (handle, dir, mode, cred);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op = &ext3_file_inode_operations;
 		inode->i_fop = &ext3_file_operations;
 		ext3_set_aops(inode);
-		err = ext3_add_nondir(handle, dentry, inode);
+		err = ext3_add_nondir(handle, dentry, inode, cred);
 	}
 	ext3_journal_stop(handle);
-	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries, cred))
 		goto retry;
 	return err;
 }
@@ -1733,6 +1754,7 @@ retry:
 static int ext3_mknod (struct inode * dir, struct dentry *dentry,
 			int mode, dev_t rdev)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode *inode;
 	int err, retries = 0;
@@ -1750,23 +1772,25 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext3_new_inode (handle, dir, mode);
+	inode = ext3_new_inode (handle, dir, mode, cred);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
 #ifdef CONFIG_EXT3_FS_XATTR
 		inode->i_op = &ext3_special_inode_operations;
 #endif
-		err = ext3_add_nondir(handle, dentry, inode);
+		err = ext3_add_nondir(handle, dentry, inode, cred);
 	}
 	ext3_journal_stop(handle);
-	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries,
+						      cred))
 		goto retry;
 	return err;
 }
 
 static int ext3_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * inode;
 	struct buffer_head * dir_block;
@@ -1786,7 +1810,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext3_new_inode (handle, dir, S_IFDIR | mode);
+	inode = ext3_new_inode (handle, dir, S_IFDIR | mode, cred);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
@@ -1794,7 +1818,7 @@ retry:
 	inode->i_op = &ext3_dir_inode_operations;
 	inode->i_fop = &ext3_dir_operations;
 	inode->i_size = EXT3_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-	dir_block = ext3_bread (handle, inode, 0, 1, &err);
+	dir_block = ext3_bread (handle, inode, 0, 1, &err, cred);
 	if (!dir_block) {
 		drop_nlink(inode); /* is this nlink == 0? */
 		ext3_mark_inode_dirty(handle, inode);
@@ -1821,7 +1845,7 @@ retry:
 	ext3_journal_dirty_metadata(handle, dir_block);
 	brelse (dir_block);
 	ext3_mark_inode_dirty(handle, inode);
-	err = ext3_add_entry (handle, dentry, inode);
+	err = ext3_add_entry (handle, dentry, inode, cred);
 	if (err) {
 		inode->i_nlink = 0;
 		ext3_mark_inode_dirty(handle, inode);
@@ -1834,7 +1858,7 @@ retry:
 	d_instantiate(dentry, inode);
 out_stop:
 	ext3_journal_stop(handle);
-	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries, cred))
 		goto retry;
 	return err;
 }
@@ -1842,7 +1866,7 @@ out_stop:
 /*
  * routine to check that the specified directory is empty (for rmdir)
  */
-static int empty_dir (struct inode * inode)
+static int empty_dir (struct inode * inode, struct cred *cred)
 {
 	unsigned long offset;
 	struct buffer_head * bh;
@@ -1852,7 +1876,7 @@ static int empty_dir (struct inode * inode)
 
 	sb = inode->i_sb;
 	if (inode->i_size < EXT3_DIR_REC_LEN(1) + EXT3_DIR_REC_LEN(2) ||
-	    !(bh = ext3_bread (NULL, inode, 0, 0, &err))) {
+	    !(bh = ext3_bread (NULL, inode, 0, 0, &err, cred))) {
 		if (err)
 			ext3_error(inode->i_sb, __FUNCTION__,
 				   "error %d reading directory #%lu offset 0",
@@ -1885,7 +1909,8 @@ static int empty_dir (struct inode * inode)
 			err = 0;
 			brelse (bh);
 			bh = ext3_bread (NULL, inode,
-				offset >> EXT3_BLOCK_SIZE_BITS(sb), 0, &err);
+				offset >> EXT3_BLOCK_SIZE_BITS(sb), 0, &err,
+				cred);
 			if (!bh) {
 				if (err)
 					ext3_error(sb, __FUNCTION__,
@@ -2059,6 +2084,7 @@ out_brelse:
 
 static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	int retval;
 	struct inode * inode;
 	struct buffer_head * bh;
@@ -2073,7 +2099,7 @@ static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
 		return PTR_ERR(handle);
 
 	retval = -ENOENT;
-	bh = ext3_find_entry (dentry, &de);
+	bh = ext3_find_entry (dentry, &de, cred);
 	if (!bh)
 		goto end_rmdir;
 
@@ -2087,7 +2113,7 @@ static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
 		goto end_rmdir;
 
 	retval = -ENOTEMPTY;
-	if (!empty_dir (inode))
+	if (!empty_dir (inode, cred))
 		goto end_rmdir;
 
 	retval = ext3_delete_entry(handle, dir, de, bh);
@@ -2118,6 +2144,7 @@ end_rmdir:
 
 static int ext3_unlink(struct inode * dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	int retval;
 	struct inode * inode;
 	struct buffer_head * bh;
@@ -2135,7 +2162,7 @@ static int ext3_unlink(struct inode * dir, struct dentry *dentry)
 		handle->h_sync = 1;
 
 	retval = -ENOENT;
-	bh = ext3_find_entry (dentry, &de);
+	bh = ext3_find_entry (dentry, &de, cred);
 	if (!bh)
 		goto end_unlink;
 
@@ -2173,6 +2200,7 @@ end_unlink:
 static int ext3_symlink (struct inode * dir,
 		struct dentry *dentry, const char * symname)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * inode;
 	int l, err, retries = 0;
@@ -2191,7 +2219,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext3_new_inode (handle, dir, S_IFLNK|S_IRWXUGO);
+	inode = ext3_new_inode (handle, dir, S_IFLNK|S_IRWXUGO, cred);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
@@ -2218,10 +2246,11 @@ retry:
 		inode->i_size = l-1;
 	}
 	EXT3_I(inode)->i_disksize = inode->i_size;
-	err = ext3_add_nondir(handle, dentry, inode);
+	err = ext3_add_nondir(handle, dentry, inode, cred);
 out_stop:
 	ext3_journal_stop(handle);
-	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC &&
+	    ext3_should_retry_alloc(dir->i_sb, &retries, cred))
 		goto retry;
 	return err;
 }
@@ -2229,6 +2258,7 @@ out_stop:
 static int ext3_link (struct dentry * old_dentry,
 		struct inode * dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode *inode = old_dentry->d_inode;
 	int err, retries = 0;
@@ -2255,9 +2285,10 @@ retry:
 	inc_nlink(inode);
 	atomic_inc(&inode->i_count);
 
-	err = ext3_add_nondir(handle, dentry, inode);
+	err = ext3_add_nondir(handle, dentry, inode, cred);
 	ext3_journal_stop(handle);
-	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+	if (err == -ENOSPC &&
+	    ext3_should_retry_alloc(dir->i_sb, &retries, cred))
 		goto retry;
 	return err;
 }
@@ -2273,6 +2304,7 @@ retry:
 static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 			   struct inode * new_dir,struct dentry *new_dentry)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * old_inode, * new_inode;
 	struct buffer_head * old_bh, * new_bh, * dir_bh;
@@ -2294,7 +2326,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
 		handle->h_sync = 1;
 
-	old_bh = ext3_find_entry (old_dentry, &old_de);
+	old_bh = ext3_find_entry (old_dentry, &old_de, cred);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -2307,7 +2339,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 		goto end_rename;
 
 	new_inode = new_dentry->d_inode;
-	new_bh = ext3_find_entry (new_dentry, &new_de);
+	new_bh = ext3_find_entry (new_dentry, &new_de, cred);
 	if (new_bh) {
 		if (!new_inode) {
 			brelse (new_bh);
@@ -2317,11 +2349,11 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	if (S_ISDIR(old_inode->i_mode)) {
 		if (new_inode) {
 			retval = -ENOTEMPTY;
-			if (!empty_dir (new_inode))
+			if (!empty_dir (new_inode, cred))
 				goto end_rename;
 		}
 		retval = -EIO;
-		dir_bh = ext3_bread (handle, old_inode, 0, 0, &retval);
+		dir_bh = ext3_bread (handle, old_inode, 0, 0, &retval, cred);
 		if (!dir_bh)
 			goto end_rename;
 		if (le32_to_cpu(PARENT_INO(dir_bh->b_data)) != old_dir->i_ino)
@@ -2332,7 +2364,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 			goto end_rename;
 	}
 	if (!new_bh) {
-		retval = ext3_add_entry (handle, new_dentry, old_inode);
+		retval = ext3_add_entry (handle, new_dentry, old_inode, cred);
 		if (retval)
 			goto end_rename;
 	} else {
@@ -2371,7 +2403,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 		struct buffer_head *old_bh2;
 		struct ext3_dir_entry_2 *old_de2;
 
-		old_bh2 = ext3_find_entry(old_dentry, &old_de2);
+		old_bh2 = ext3_find_entry(old_dentry, &old_de2, cred);
 		if (old_bh2) {
 			retval = ext3_delete_entry(handle, old_dir,
 						   old_de2, old_bh2);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index add683b..14a558b 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2671,6 +2671,7 @@ static int ext3_quota_on(struct super_block *sb, int type, int format_id,
 static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	sector_t blk = off >> EXT3_BLOCK_SIZE_BITS(sb);
 	int err = 0;
@@ -2688,7 +2689,7 @@ static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 	while (toread > 0) {
 		tocopy = sb->s_blocksize - offset < toread ?
 				sb->s_blocksize - offset : toread;
-		bh = ext3_bread(NULL, inode, blk, 0, &err);
+		bh = ext3_bread(NULL, inode, blk, 0, &err, cred);
 		if (err)
 			return err;
 		if (!bh)	/* A hole? */
@@ -2709,6 +2710,7 @@ static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 static ssize_t ext3_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	sector_t blk = off >> EXT3_BLOCK_SIZE_BITS(sb);
 	int err = 0;
@@ -2729,7 +2731,7 @@ static ssize_t ext3_quota_write(struct super_block *sb, int type,
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
 				sb->s_blocksize - offset : towrite;
-		bh = ext3_bread(handle, inode, blk, 1, &err);
+		bh = ext3_bread(handle, inode, blk, 1, &err, cred);
 		if (!bh)
 			goto out;
 		if (journal_quota) {
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index f58cbb2..3b34cea 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -676,7 +676,8 @@ cleanup:
 static int
 ext3_xattr_block_set(handle_t *handle, struct inode *inode,
 		     struct ext3_xattr_info *i,
-		     struct ext3_xattr_block_find *bs)
+		     struct ext3_xattr_block_find *bs,
+		     struct cred *cred)
 {
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *new_bh = NULL;
@@ -805,7 +806,7 @@ inserted:
 				(ext3_fsblk_t)EXT3_I(inode)->i_block_group *
 				EXT3_BLOCKS_PER_GROUP(sb);
 			ext3_fsblk_t block = ext3_new_block(handle, inode,
-							goal, &error);
+							goal, &error, cred);
 			if (error)
 				goto cleanup;
 			ea_idebug(inode, "creating block %d", block);
@@ -938,7 +939,7 @@ ext3_xattr_ibody_set(handle_t *handle, struct inode *inode,
 int
 ext3_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		      const char *name, const void *value, size_t value_len,
-		      int flags)
+		      int flags, struct cred *cred)
 {
 	struct ext3_xattr_info i = {
 		.name_index = name_index,
@@ -996,14 +997,17 @@ ext3_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		if (!is.s.not_found)
 			error = ext3_xattr_ibody_set(handle, inode, &i, &is);
 		else if (!bs.s.not_found)
-			error = ext3_xattr_block_set(handle, inode, &i, &bs);
+			error = ext3_xattr_block_set(handle, inode, &i, &bs,
+						     cred);
 	} else {
 		error = ext3_xattr_ibody_set(handle, inode, &i, &is);
 		if (!error && !bs.s.not_found) {
 			i.value = NULL;
-			error = ext3_xattr_block_set(handle, inode, &i, &bs);
+			error = ext3_xattr_block_set(handle, inode, &i, &bs,
+						     cred);
 		} else if (error == -ENOSPC) {
-			error = ext3_xattr_block_set(handle, inode, &i, &bs);
+			error = ext3_xattr_block_set(handle, inode, &i, &bs,
+						     cred);
 			if (error)
 				goto cleanup;
 			if (!is.s.not_found) {
@@ -1043,7 +1047,8 @@ cleanup:
  */
 int
 ext3_xattr_set(struct inode *inode, int name_index, const char *name,
-	       const void *value, size_t value_len, int flags)
+	       const void *value, size_t value_len, int flags,
+	       struct cred *cred)
 {
 	handle_t *handle;
 	int error, retries = 0;
@@ -1056,10 +1061,10 @@ retry:
 		int error2;
 
 		error = ext3_xattr_set_handle(handle, inode, name_index, name,
-					      value, value_len, flags);
+					      value, value_len, flags, cred);
 		error2 = ext3_journal_stop(handle);
 		if (error == -ENOSPC &&
-		    ext3_should_retry_alloc(inode->i_sb, &retries))
+		    ext3_should_retry_alloc(inode->i_sb, &retries, cred))
 			goto retry;
 		if (error == 0)
 			error = error2;
diff --git a/fs/ext3/xattr.h b/fs/ext3/xattr.h
index 6b1ae1c..761772a 100644
--- a/fs/ext3/xattr.h
+++ b/fs/ext3/xattr.h
@@ -68,8 +68,10 @@ extern ssize_t ext3_listxattr(struct dentry *, char *, size_t);
 
 extern int ext3_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext3_xattr_list(struct inode *, char *, size_t);
-extern int ext3_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
-extern int ext3_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
+extern int ext3_xattr_set(struct inode *, int, const char *, const void *,
+			  size_t, int, struct cred *);
+extern int ext3_xattr_set_handle(handle_t *, struct inode *, int, const char *,
+				 const void *, size_t, int, struct cred *);
 
 extern void ext3_xattr_delete_inode(handle_t *, struct inode *);
 extern void ext3_xattr_put_super(struct super_block *);
diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index 821efaf..76ccead 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -41,15 +41,18 @@ static int
 ext3_xattr_security_set(struct inode *inode, const char *name,
 		       const void *value, size_t size, int flags)
 {
+	struct cred *cred = current->cred;
+
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 	return ext3_xattr_set(inode, EXT3_XATTR_INDEX_SECURITY, name,
-			      value, size, flags);
+			      value, size, flags, cred);
 }
 
 int
 ext3_init_security(handle_t *handle, struct inode *inode, struct inode *dir)
 {
+	struct cred *cred = current->cred;
 	int err;
 	size_t len;
 	void *value;
@@ -62,7 +65,7 @@ ext3_init_security(handle_t *handle, struct inode *inode, struct inode *dir)
 		return err;
 	}
 	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
-				    name, value, len, 0);
+				    name, value, len, 0, cred);
 	kfree(name);
 	kfree(value);
 	return err;
diff --git a/fs/ext3/xattr_trusted.c b/fs/ext3/xattr_trusted.c
index 0327497..eead225 100644
--- a/fs/ext3/xattr_trusted.c
+++ b/fs/ext3/xattr_trusted.c
@@ -47,10 +47,12 @@ static int
 ext3_xattr_trusted_set(struct inode *inode, const char *name,
 		       const void *value, size_t size, int flags)
 {
+	struct cred *cred = current->cred;
+
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 	return ext3_xattr_set(inode, EXT3_XATTR_INDEX_TRUSTED, name,
-			      value, size, flags);
+			      value, size, flags, cred);
 }
 
 struct xattr_handler ext3_xattr_trusted_handler = {
diff --git a/fs/ext3/xattr_user.c b/fs/ext3/xattr_user.c
index 1abd8f9..1aa87ae 100644
--- a/fs/ext3/xattr_user.c
+++ b/fs/ext3/xattr_user.c
@@ -47,12 +47,14 @@ static int
 ext3_xattr_user_set(struct inode *inode, const char *name,
 		    const void *value, size_t size, int flags)
 {
+	struct cred *cred = current->cred;
+
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 	if (!test_opt(inode->i_sb, XATTR_USER))
 		return -EOPNOTSUPP;
 	return ext3_xattr_set(inode, EXT3_XATTR_INDEX_USER, name,
-			      value, size, flags);
+			      value, size, flags, cred);
 }
 
 struct xattr_handler ext3_xattr_user_handler = {
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index a5ccfea..23db760 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -761,9 +761,10 @@ ext3_group_first_block_no(struct super_block *sb, unsigned long group_no)
 extern int ext3_bg_has_super(struct super_block *sb, int group);
 extern unsigned long ext3_bg_num_gdb(struct super_block *sb, int group);
 extern ext3_fsblk_t ext3_new_block (handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, int *errp);
+			ext3_fsblk_t goal, int *errp, struct cred *cred);
 extern ext3_fsblk_t ext3_new_blocks (handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, unsigned long *count, int *errp);
+			ext3_fsblk_t goal, unsigned long *count, int *errp,
+			struct cred *cred);
 extern void ext3_free_blocks (handle_t *handle, struct inode *inode,
 			ext3_fsblk_t block, unsigned long count);
 extern void ext3_free_blocks_sb (handle_t *handle, struct super_block *sb,
@@ -774,7 +775,8 @@ extern void ext3_check_blocks_bitmap (struct super_block *);
 extern struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
 						    unsigned int block_group,
 						    struct buffer_head ** bh);
-extern int ext3_should_retry_alloc(struct super_block *sb, int *retries);
+extern int ext3_should_retry_alloc(struct super_block *sb, int *retries,
+				   struct cred *cred);
 extern void ext3_init_block_alloc_info(struct inode *);
 extern void ext3_rsv_window_add(struct super_block *sb, struct ext3_reserve_window_node *rsv);
 
@@ -795,7 +797,8 @@ extern int ext3fs_dirhash(const char *name, int len, struct
 			  dx_hash_info *hinfo);
 
 /* ialloc.c */
-extern struct inode * ext3_new_inode (handle_t *, struct inode *, int);
+extern struct inode * ext3_new_inode (handle_t *, struct inode *, int,
+				      struct cred *);
 extern void ext3_free_inode (handle_t *, struct inode *);
 extern struct inode * ext3_orphan_get (struct super_block *, unsigned long);
 extern unsigned long ext3_count_free_inodes (struct super_block *);
@@ -807,11 +810,13 @@ extern unsigned long ext3_count_free (struct buffer_head *, unsigned);
 /* inode.c */
 int ext3_forget(handle_t *handle, int is_metadata, struct inode *inode,
 		struct buffer_head *bh, ext3_fsblk_t blocknr);
-struct buffer_head * ext3_getblk (handle_t *, struct inode *, long, int, int *);
-struct buffer_head * ext3_bread (handle_t *, struct inode *, int, int, int *);
+struct buffer_head * ext3_getblk (handle_t *, struct inode *, long, int, int *,
+				  struct cred *);
+struct buffer_head * ext3_bread (handle_t *, struct inode *, int, int, int *,
+				 struct cred *);
 int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	sector_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
-	int create, int extend_disksize);
+	int create, int extend_disksize, struct cred *cred);
 
 extern struct inode *ext3_iget (struct super_block *, unsigned long);
 extern int  ext3_write_inode (struct inode *, int);
@@ -836,7 +841,8 @@ extern long ext3_compat_ioctl (struct file *, unsigned int, unsigned long);
 extern int ext3_orphan_add(handle_t *, struct inode *);
 extern int ext3_orphan_del(handle_t *, struct inode *);
 extern int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
-				__u32 start_minor_hash, __u32 *next_hash);
+				__u32 start_minor_hash, __u32 *next_hash,
+				struct cred *cred);
 
 /* resize.c */
 extern int ext3_group_add(struct super_block *sb,

