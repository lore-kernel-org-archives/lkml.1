Return-Path: <linux-kernel-owner+w=401wt.eu-S1762318AbXJYQj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318AbXJYQj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbXJYQfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:35:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbXJYQf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:35:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/31] IGET: Stop EXT2 from using iget() and read_inode() [try
	#5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:34:53 +0100
Message-ID: <20071025163453.5057.32841.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the EXT2 filesystem from using iget() and read_inode().  Replace
ext2_read_inode() with ext2_iget(), and call that instead of iget().
ext2_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

ext2_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
---

 fs/ext2/ext2.h  |    2 +-
 fs/ext2/inode.c |   29 +++++++++++++++++++++--------
 fs/ext2/namei.c |   12 ++++++------
 fs/ext2/super.c |   32 ++++++++++++++++++--------------
 4 files changed, 46 insertions(+), 29 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 7730388..5890fc0 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -124,7 +124,7 @@ extern void ext2_check_inodes_bitmap (struct super_block *);
 extern unsigned long ext2_count_free (struct buffer_head *, unsigned);
 
 /* inode.c */
-extern void ext2_read_inode (struct inode *);
+extern struct inode *ext2_iget (struct super_block *, unsigned long);
 extern int ext2_write_inode (struct inode *, int);
 extern void ext2_put_inode (struct inode *);
 extern void ext2_delete_inode (struct inode *);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index b1ab32a..864a534 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1185,22 +1185,33 @@ void ext2_get_inode_flags(struct ext2_inode_info *ei)
 		ei->i_flags |= EXT2_DIRSYNC_FL;
 }
 
-void ext2_read_inode (struct inode * inode)
+struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 {
-	struct ext2_inode_info *ei = EXT2_I(inode);
-	ino_t ino = inode->i_ino;
+	struct ext2_inode_info *ei;
 	struct buffer_head * bh;
-	struct ext2_inode * raw_inode = ext2_get_inode(inode->i_sb, ino, &bh);
+	struct ext2_inode * raw_inode;
+	struct inode *inode;
+	long ret = -EIO;
 	int n;
 
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	ei = EXT2_I(inode);
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
 	ei->i_acl = EXT2_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT2_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
 
-	if (IS_ERR(raw_inode))
+	raw_inode = ext2_get_inode(inode->i_sb, ino, &bh);
+	if (IS_ERR(raw_inode)) {
+		ret = PTR_ERR(raw_inode);
  		goto bad_inode;
+	}
 
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	inode->i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
@@ -1224,6 +1235,7 @@ void ext2_read_inode (struct inode * inode)
 	if (inode->i_nlink == 0 && (inode->i_mode == 0 || ei->i_dtime)) {
 		/* this inode is deleted */
 		brelse (bh);
+		ret = -ESTALE;
 		goto bad_inode;
 	}
 	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
@@ -1290,11 +1302,12 @@ void ext2_read_inode (struct inode * inode)
 	}
 	brelse (bh);
 	ext2_set_inode_flags(inode);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 	
 bad_inode:
-	make_bad_inode(inode);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(ret);
 }
 
 static int ext2_update_inode(struct inode * inode, int do_sync)
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index e69beed..80c97fd 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -63,9 +63,9 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
 	ino = ext2_inode_by_name(dir, dentry);
 	inode = NULL;
 	if (ino) {
-		inode = iget(dir->i_sb, ino);
-		if (!inode)
-			return ERR_PTR(-EACCES);
+		inode = ext2_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -83,10 +83,10 @@ struct dentry *ext2_get_parent(struct dentry *child)
 	ino = ext2_inode_by_name(child->d_inode, &dotdot);
 	if (!ino)
 		return ERR_PTR(-ENOENT);
-	inode = iget(child->d_inode->i_sb, ino);
+	inode = ext2_iget(child->d_inode->i_sb, ino);
 
-	if (!inode)
-		return ERR_PTR(-EACCES);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 	parent = d_alloc_anon(inode);
 	if (!parent) {
 		iput(inode);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 154e25f..c405c8a 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -296,7 +296,6 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type, const char *da
 static const struct super_operations ext2_sops = {
 	.alloc_inode	= ext2_alloc_inode,
 	.destroy_inode	= ext2_destroy_inode,
-	.read_inode	= ext2_read_inode,
 	.write_inode	= ext2_write_inode,
 	.delete_inode	= ext2_delete_inode,
 	.put_super	= ext2_put_super,
@@ -326,11 +325,10 @@ static struct inode *ext2_nfs_get_inode(struct super_block *sb,
 	 * it might be "neater" to call ext2_get_inode first and check
 	 * if the inode is valid.....
 	 */
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	inode = ext2_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
 		/* we didn't find the right inode.. */
 		iput(inode);
 		return ERR_PTR(-ESTALE);
@@ -726,6 +724,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned long logic_sb_block;
 	unsigned long offset = 0;
 	unsigned long def_mount_opts;
+	long ret = -EINVAL;
 	int blocksize = BLOCK_SIZE;
 	int db_count;
 	int i, j;
@@ -1022,19 +1021,24 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_op = &ext2_sops;
 	sb->s_export_op = &ext2_export_ops;
 	sb->s_xattr = ext2_xattr_handlers;
-	root = iget(sb, EXT2_ROOT_INO);
-	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root) {
-		iput(root);
-		printk(KERN_ERR "EXT2-fs: get root inode failed\n");
+	root = ext2_iget(sb, EXT2_ROOT_INO);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
 		goto failed_mount3;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
-		dput(sb->s_root);
-		sb->s_root = NULL;
+		iput(root);
 		printk(KERN_ERR "EXT2-fs: corrupt root inode, run e2fsck\n");
 		goto failed_mount3;
 	}
+
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		iput(root);
+		printk(KERN_ERR "EXT2-fs: get root inode failed\n");
+		ret = -ENOMEM;
+		goto failed_mount3;
+	}
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		ext2_warning(sb, __FUNCTION__,
 			"mounting ext3 filesystem as ext2");
@@ -1061,7 +1065,7 @@ failed_mount:
 failed_sbi:
 	sb->s_fs_info = NULL;
 	kfree(sbi);
-	return -EINVAL;
+	return ret;
 }
 
 static void ext2_commit_super (struct super_block * sb,

