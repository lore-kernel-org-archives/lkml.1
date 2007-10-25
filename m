Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbXJYQkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbXJYQkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbXJYQfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:35:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbXJYQfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:35:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/31] IGET: Stop EXT3 from using iget() and read_inode() [try
	#5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:34:59 +0100
Message-ID: <20071025163459.5057.55659.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the EXT3 filesystem from using iget() and read_inode().  Replace
ext3_read_inode() with ext3_iget(), and call that instead of iget().
ext3_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

ext3_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Jan Kara <jack@suse.cz>
---

 fs/ext3/ialloc.c        |   58 ++++++++++++++++++++++++++++-------------------
 fs/ext3/inode.c         |   25 +++++++++++++++-----
 fs/ext3/namei.c         |   29 +++++++-----------------
 fs/ext3/resize.c        |    7 ++----
 fs/ext3/super.c         |   40 ++++++++++++++++++--------------
 include/linux/ext3_fs.h |    2 +-
 6 files changed, 89 insertions(+), 72 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 1bc8cd8..58ae2f9 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -642,14 +642,15 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
 	unsigned long max_ino = le32_to_cpu(EXT3_SB(sb)->s_es->s_inodes_count);
 	unsigned long block_group;
 	int bit;
-	struct buffer_head *bitmap_bh = NULL;
+	struct buffer_head *bitmap_bh;
 	struct inode *inode = NULL;
+	long err = -EIO;
 
 	/* Error cases - e2fsck has already cleaned up for us */
 	if (ino > max_ino) {
 		ext3_warning(sb, __FUNCTION__,
 			     "bad orphan ino %lu!  e2fsck was run?", ino);
-		goto out;
+		goto error;
 	}
 
 	block_group = (ino - 1) / EXT3_INODES_PER_GROUP(sb);
@@ -658,38 +659,49 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
 	if (!bitmap_bh) {
 		ext3_warning(sb, __FUNCTION__,
 			     "inode bitmap error for orphan %lu", ino);
-		goto out;
+		goto error;
 	}
 
 	/* Having the inode bit set should be a 100% indicator that this
 	 * is a valid orphan (no e2fsck run on fs).  Orphans also include
 	 * inodes that were being truncated, so we can't check i_nlink==0.
 	 */
-	if (!ext3_test_bit(bit, bitmap_bh->b_data) ||
-			!(inode = iget(sb, ino)) || is_bad_inode(inode) ||
-			NEXT_ORPHAN(inode) > max_ino) {
-		ext3_warning(sb, __FUNCTION__,
-			     "bad orphan inode %lu!  e2fsck was run?", ino);
-		printk(KERN_NOTICE "ext3_test_bit(bit=%d, block=%llu) = %d\n",
-		       bit, (unsigned long long)bitmap_bh->b_blocknr,
-		       ext3_test_bit(bit, bitmap_bh->b_data));
-		printk(KERN_NOTICE "inode=%p\n", inode);
-		if (inode) {
-			printk(KERN_NOTICE "is_bad_inode(inode)=%d\n",
-			       is_bad_inode(inode));
-			printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
-			       NEXT_ORPHAN(inode));
-			printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
-		}
+	if (!ext3_test_bit(bit, bitmap_bh->b_data))
+		goto bad_orphan;
+
+	inode = ext3_iget(sb, ino);
+	if (IS_ERR(inode))
+		goto iget_failed;
+
+	if (NEXT_ORPHAN(inode) > max_ino)
+		goto bad_orphan;
+	brelse(bitmap_bh);
+	return inode;
+
+iget_failed:
+	err = PTR_ERR(inode);
+	inode = NULL;
+bad_orphan:
+	ext3_warning(sb, __FUNCTION__,
+		     "bad orphan inode %lu!  e2fsck was run?", ino);
+	printk(KERN_NOTICE "ext3_test_bit(bit=%d, block=%llu) = %d\n",
+	       bit, (unsigned long long)bitmap_bh->b_blocknr,
+	       ext3_test_bit(bit, bitmap_bh->b_data));
+	printk(KERN_NOTICE "inode=%p\n", inode);
+	if (inode) {
+		printk(KERN_NOTICE "is_bad_inode(inode)=%d\n",
+		       is_bad_inode(inode));
+		printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
+		       NEXT_ORPHAN(inode));
+		printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
 		/* Avoid freeing blocks if we got a bad deleted inode */
-		if (inode && inode->i_nlink == 0)
+		if (inode->i_nlink == 0)
 			inode->i_blocks = 0;
 		iput(inode);
-		inode = NULL;
 	}
-out:
 	brelse(bitmap_bh);
-	return inode;
+error:
+	return ERR_PTR(err);
 }
 
 unsigned long ext3_count_free_inodes (struct super_block * sb)
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 9b162cd..164934a 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2658,21 +2658,31 @@ void ext3_get_inode_flags(struct ext3_inode_info *ei)
 		ei->i_flags |= EXT3_DIRSYNC_FL;
 }
 
-void ext3_read_inode(struct inode * inode)
+struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 {
 	struct ext3_iloc iloc;
 	struct ext3_inode *raw_inode;
-	struct ext3_inode_info *ei = EXT3_I(inode);
+	struct ext3_inode_info *ei;
 	struct buffer_head *bh;
+	struct inode *inode;
+	long ret;
 	int block;
 
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	ei = EXT3_I(inode);
 #ifdef CONFIG_EXT3_FS_POSIX_ACL
 	ei->i_acl = EXT3_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT3_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
 
-	if (__ext3_get_inode_loc(inode, &iloc, 0))
+	ret = __ext3_get_inode_loc(inode, &iloc, 0);
+	if (ret < 0)
 		goto bad_inode;
 	bh = iloc.bh;
 	raw_inode = ext3_raw_inode(&iloc);
@@ -2703,6 +2713,7 @@ void ext3_read_inode(struct inode * inode)
 		    !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ORPHAN_FS)) {
 			/* this inode is deleted */
 			brelse (bh);
+			ret = -ESTALE;
 			goto bad_inode;
 		}
 		/* The only unlinked inodes we let through here have
@@ -2746,6 +2757,7 @@ void ext3_read_inode(struct inode * inode)
 		if (EXT3_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
 		    EXT3_INODE_SIZE(inode->i_sb)) {
 			brelse (bh);
+			ret = -EIO;
 			goto bad_inode;
 		}
 		if (ei->i_extra_isize == 0) {
@@ -2787,11 +2799,12 @@ void ext3_read_inode(struct inode * inode)
 	}
 	brelse (iloc.bh);
 	ext3_set_inode_flags(inode);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
 bad_inode:
-	make_bad_inode(inode);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(ret);
 }
 
 /*
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index ec8170a..476cf03 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1039,17 +1039,11 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 		if (!ext3_valid_inum(dir->i_sb, ino)) {
 			ext3_error(dir->i_sb, "ext3_lookup",
 				   "bad inode number: %lu", ino);
-			inode = NULL;
-		} else
-			inode = iget(dir->i_sb, ino);
-
-		if (!inode)
-			return ERR_PTR(-EACCES);
-
-		if (is_bad_inode(inode)) {
-			iput(inode);
-			return ERR_PTR(-ENOENT);
+			return ERR_PTR(-EIO);
 		}
+		inode = ext3_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -1078,18 +1072,13 @@ struct dentry *ext3_get_parent(struct dentry *child)
 	if (!ext3_valid_inum(child->d_inode->i_sb, ino)) {
 		ext3_error(child->d_inode->i_sb, "ext3_get_parent",
 			   "bad inode number: %lu", ino);
-		inode = NULL;
-	} else
-		inode = iget(child->d_inode->i_sb, ino);
-
-	if (!inode)
-		return ERR_PTR(-EACCES);
-
-	if (is_bad_inode(inode)) {
-		iput(inode);
-		return ERR_PTR(-ENOENT);
+		return ERR_PTR(-EIO);
 	}
 
+	inode = ext3_iget(child->d_inode->i_sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
 	parent = d_alloc_anon(inode);
 	if (!parent) {
 		iput(inode);
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 44de145..ebc05af 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -795,12 +795,11 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
 		}
-		inode = iget(sb, EXT3_RESIZE_INO);
-		if (!inode || is_bad_inode(inode)) {
+		inode = ext3_iget(sb, EXT3_RESIZE_INO);
+		if (IS_ERR(inode)) {
 			ext3_warning(sb, __FUNCTION__,
 				     "Error opening resize inode");
-			iput(inode);
-			return -ENOENT;
+			return PTR_ERR(inode);
 		}
 	}
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index de55da9..26aaa91 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -649,11 +649,10 @@ static struct inode *ext3_nfs_get_inode(struct super_block *sb,
 	 * Currently we don't know the generation for parent directory, so
 	 * a generation of 0 means "accept any"
 	 */
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	inode = ext3_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
@@ -722,7 +721,6 @@ static struct quotactl_ops ext3_qctl_operations = {
 static const struct super_operations ext3_sops = {
 	.alloc_inode	= ext3_alloc_inode,
 	.destroy_inode	= ext3_destroy_inode,
-	.read_inode	= ext3_read_inode,
 	.write_inode	= ext3_write_inode,
 	.dirty_inode	= ext3_dirty_inode,
 	.delete_inode	= ext3_delete_inode,
@@ -1383,8 +1381,8 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 	while (es->s_last_orphan) {
 		struct inode *inode;
 
-		if (!(inode =
-		      ext3_orphan_get(sb, le32_to_cpu(es->s_last_orphan)))) {
+		inode = ext3_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
+		if (IS_ERR(inode)) {
 			es->s_last_orphan = 0;
 			break;
 		}
@@ -1489,6 +1487,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	int db_count;
 	int i;
 	int needs_recovery;
+	int ret = -EINVAL;
 	__le32 features;
 	int err;
 
@@ -1858,19 +1857,24 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	 * so we can safely mount the rest of the filesystem now.
 	 */
 
-	root = iget(sb, EXT3_ROOT_INO);
-	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root) {
+	root = ext3_iget(sb, EXT3_ROOT_INO);
+	if (IS_ERR(root)) {
 		printk(KERN_ERR "EXT3-fs: get root inode failed\n");
-		iput(root);
+		ret = PTR_ERR(root);
 		goto failed_mount4;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
-		dput(sb->s_root);
-		sb->s_root = NULL;
+		iput(root);
 		printk(KERN_ERR "EXT3-fs: corrupt root inode, run e2fsck\n");
 		goto failed_mount4;
 	}
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		printk(KERN_ERR "EXT3-fs: get root dentry failed\n");
+		iput(root);
+		ret = -ENOMEM;
+		goto failed_mount4;
+	}
 
 	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 	/*
@@ -1922,7 +1926,7 @@ out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 	lock_kernel();
-	return -EINVAL;
+	return ret;
 }
 
 /*
@@ -1958,8 +1962,8 @@ static journal_t *ext3_get_journal(struct super_block *sb,
 	 * things happen if we iget() an unused inode, as the subsequent
 	 * iput() will try to delete it. */
 
-	journal_inode = iget(sb, journal_inum);
-	if (!journal_inode) {
+	journal_inode = ext3_iget(sb, journal_inum);
+	if (IS_ERR(journal_inode)) {
 		printk(KERN_ERR "EXT3-fs: no journal found.\n");
 		return NULL;
 	}
@@ -1972,7 +1976,7 @@ static journal_t *ext3_get_journal(struct super_block *sb,
 
 	jbd_debug(2, "Journal inode found at %p: %Ld bytes\n",
 		  journal_inode, journal_inode->i_size);
-	if (is_bad_inode(journal_inode) || !S_ISREG(journal_inode->i_mode)) {
+	if (!S_ISREG(journal_inode->i_mode)) {
 		printk(KERN_ERR "EXT3-fs: invalid journal inode.\n");
 		iput(journal_inode);
 		return NULL;
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 6413445..42f8cf8 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -803,7 +803,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	sector_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
 	int create, int extend_disksize);
 
-extern void ext3_read_inode (struct inode *);
+extern struct inode *ext3_iget (struct super_block *, unsigned long);
 extern int  ext3_write_inode (struct inode *, int);
 extern int  ext3_setattr (struct dentry *, struct iattr *);
 extern void ext3_delete_inode (struct inode *);

