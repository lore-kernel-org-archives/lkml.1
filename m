Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXJLJO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXJLJO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932497AbXJLJIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:08:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307AbXJLJIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:08:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/31] IGET: Stop EXT4 from using iget() and read_inode() [try
	#4]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 12 Oct 2007 10:08:20 +0100
Message-ID: <20071012090820.3442.43109.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
References: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the EXT4 filesystem from using iget() and read_inode().  Replace
ext4_read_inode() with ext4_iget(), and call that instead of iget().
ext4_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

ext4_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Jan Kara <jack@suse.cz>
---

 fs/ext4/ialloc.c        |   58 ++++++++++++++++++++++++++++-------------------
 fs/ext4/inode.c         |   25 +++++++++++++++-----
 fs/ext4/namei.c         |   29 +++++++-----------------
 fs/ext4/resize.c        |    7 ++----
 fs/ext4/super.c         |   36 ++++++++++++++++-------------
 include/linux/ext4_fs.h |    2 +-
 6 files changed, 87 insertions(+), 70 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 427f830..4fba007 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -659,14 +659,15 @@ struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
 	unsigned long max_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
 	unsigned long block_group;
 	int bit;
-	struct buffer_head *bitmap_bh = NULL;
+	struct buffer_head *bitmap_bh;
 	struct inode *inode = NULL;
+	long err = -EIO;
 
 	/* Error cases - e2fsck has already cleaned up for us */
 	if (ino > max_ino) {
 		ext4_warning(sb, __FUNCTION__,
 			     "bad orphan ino %lu!  e2fsck was run?", ino);
-		goto out;
+		goto error;
 	}
 
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
@@ -675,38 +676,49 @@ struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
 	if (!bitmap_bh) {
 		ext4_warning(sb, __FUNCTION__,
 			     "inode bitmap error for orphan %lu", ino);
-		goto out;
+		goto error;
 	}
 
 	/* Having the inode bit set should be a 100% indicator that this
 	 * is a valid orphan (no e2fsck run on fs).  Orphans also include
 	 * inodes that were being truncated, so we can't check i_nlink==0.
 	 */
-	if (!ext4_test_bit(bit, bitmap_bh->b_data) ||
-			!(inode = iget(sb, ino)) || is_bad_inode(inode) ||
-			NEXT_ORPHAN(inode) > max_ino) {
-		ext4_warning(sb, __FUNCTION__,
-			     "bad orphan inode %lu!  e2fsck was run?", ino);
-		printk(KERN_NOTICE "ext4_test_bit(bit=%d, block=%llu) = %d\n",
-		       bit, (unsigned long long)bitmap_bh->b_blocknr,
-		       ext4_test_bit(bit, bitmap_bh->b_data));
-		printk(KERN_NOTICE "inode=%p\n", inode);
-		if (inode) {
-			printk(KERN_NOTICE "is_bad_inode(inode)=%d\n",
-			       is_bad_inode(inode));
-			printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
-			       NEXT_ORPHAN(inode));
-			printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
-		}
+	if (!ext4_test_bit(bit, bitmap_bh->b_data))
+		goto bad_orphan;
+
+	inode = ext4_iget(sb, ino);
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
+	ext4_warning(sb, __FUNCTION__,
+		     "bad orphan inode %lu!  e2fsck was run?", ino);
+	printk(KERN_NOTICE "ext4_test_bit(bit=%d, block=%llu) = %d\n",
+	       bit, (unsigned long long)bitmap_bh->b_blocknr,
+	       ext4_test_bit(bit, bitmap_bh->b_data));
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
 
 unsigned long ext4_count_free_inodes (struct super_block * sb)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a4848e0..c4fb1eb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2595,21 +2595,31 @@ void ext4_get_inode_flags(struct ext4_inode_info *ei)
 		ei->i_flags |= EXT4_DIRSYNC_FL;
 }
 
-void ext4_read_inode(struct inode * inode)
+struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 {
 	struct ext4_iloc iloc;
 	struct ext4_inode *raw_inode;
-	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_inode_info *ei;
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
+	ei = EXT4_I(inode);
 #ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
 	ei->i_acl = EXT4_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT4_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
 
-	if (__ext4_get_inode_loc(inode, &iloc, 0))
+	ret = __ext4_get_inode_loc(inode, &iloc, 0);
+	if (ret < 0)
 		goto bad_inode;
 	bh = iloc.bh;
 	raw_inode = ext4_raw_inode(&iloc);
@@ -2636,6 +2646,7 @@ void ext4_read_inode(struct inode * inode)
 		    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) {
 			/* this inode is deleted */
 			brelse (bh);
+			ret = -ESTALE;
 			goto bad_inode;
 		}
 		/* The only unlinked inodes we let through here have
@@ -2683,6 +2694,7 @@ void ext4_read_inode(struct inode * inode)
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
 		    EXT4_INODE_SIZE(inode->i_sb)) {
 			brelse (bh);
+			ret = -EIO;
 			goto bad_inode;
 		}
 		if (ei->i_extra_isize == 0) {
@@ -2729,11 +2741,12 @@ void ext4_read_inode(struct inode * inode)
 	}
 	brelse (iloc.bh);
 	ext4_set_inode_flags(inode);
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
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5fdb862..301f41f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1044,17 +1044,11 @@ static struct dentry *ext4_lookup(struct inode * dir, struct dentry *dentry, str
 		if (!ext4_valid_inum(dir->i_sb, ino)) {
 			ext4_error(dir->i_sb, "ext4_lookup",
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
+		inode = ext4_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -1083,18 +1077,13 @@ struct dentry *ext4_get_parent(struct dentry *child)
 	if (!ext4_valid_inum(child->d_inode->i_sb, ino)) {
 		ext4_error(child->d_inode->i_sb, "ext4_get_parent",
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
 
+	inode = ext4_iget(child->d_inode->i_sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
 	parent = d_alloc_anon(inode);
 	if (!parent) {
 		iput(inode);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index aa11d7d..345f901 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -757,12 +757,11 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
 		}
-		inode = iget(sb, EXT4_RESIZE_INO);
-		if (!inode || is_bad_inode(inode)) {
+		inode = ext4_iget(sb, EXT4_RESIZE_INO);
+		if (IS_ERR(inode)) {
 			ext4_warning(sb, __FUNCTION__,
 				     "Error opening resize inode");
-			iput(inode);
-			return -ENOENT;
+			return PTR_ERR(inode);
 		}
 	}
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3c1397f..05434a1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -634,11 +634,10 @@ static struct dentry *ext4_get_dentry(struct super_block *sb, void *vobjp)
 	 * Currently we don't know the generation for parent directory, so
 	 * a generation of 0 means "accept any"
 	 */
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	inode = ext4_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
@@ -700,7 +699,6 @@ static struct quotactl_ops ext4_qctl_operations = {
 static const struct super_operations ext4_sops = {
 	.alloc_inode	= ext4_alloc_inode,
 	.destroy_inode	= ext4_destroy_inode,
-	.read_inode	= ext4_read_inode,
 	.write_inode	= ext4_write_inode,
 	.dirty_inode	= ext4_dirty_inode,
 	.delete_inode	= ext4_delete_inode,
@@ -1472,6 +1470,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	unsigned long journal_devnum = 0;
 	unsigned long def_mount_opts;
 	struct inode *root;
+	int ret = -EINVAL;
 	int blocksize;
 	int hblock;
 	int db_count;
@@ -1862,19 +1861,24 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	 * so we can safely mount the rest of the filesystem now.
 	 */
 
-	root = iget(sb, EXT4_ROOT_INO);
-	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root) {
+	root = ext4_iget(sb, EXT4_ROOT_INO);
+	if (IS_ERR(root)) {
 		printk(KERN_ERR "EXT4-fs: get root inode failed\n");
-		iput(root);
+		ret = PTR_ERR(root);
 		goto failed_mount4;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
-		dput(sb->s_root);
-		sb->s_root = NULL;
+		iput(root);
 		printk(KERN_ERR "EXT4-fs: corrupt root inode, run e2fsck\n");
 		goto failed_mount4;
 	}
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		printk(KERN_ERR "EXT4-fs: get root dentry failed\n");
+		iput(root);
+		ret = -ENOMEM;
+		goto failed_mount4;
+	}
 
 	ext4_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 
@@ -1954,7 +1958,7 @@ out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 	lock_kernel();
-	return -EINVAL;
+	return ret;
 }
 
 /*
@@ -1990,8 +1994,8 @@ static journal_t *ext4_get_journal(struct super_block *sb,
 	 * things happen if we iget() an unused inode, as the subsequent
 	 * iput() will try to delete it. */
 
-	journal_inode = iget(sb, journal_inum);
-	if (!journal_inode) {
+	journal_inode = ext4_iget(sb, journal_inum);
+	if (IS_ERR(journal_inode)) {
 		printk(KERN_ERR "EXT4-fs: no journal found.\n");
 		return NULL;
 	}
@@ -2004,7 +2008,7 @@ static journal_t *ext4_get_journal(struct super_block *sb,
 
 	jbd_debug(2, "Journal inode found at %p: %Ld bytes\n",
 		  journal_inode, journal_inode->i_size);
-	if (is_bad_inode(journal_inode) || !S_ISREG(journal_inode->i_mode)) {
+	if (!S_ISREG(journal_inode->i_mode)) {
 		printk(KERN_ERR "EXT4-fs: invalid journal inode.\n");
 		iput(journal_inode);
 		return NULL;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index cdee7aa..12354d5 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -944,7 +944,7 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	sector_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
 	int create, int extend_disksize);
 
-extern void ext4_read_inode (struct inode *);
+extern struct inode *ext4_iget(struct super_block *, unsigned long);
 extern int  ext4_write_inode (struct inode *, int);
 extern int  ext4_setattr (struct dentry *, struct iattr *);
 extern void ext4_delete_inode (struct inode *);

