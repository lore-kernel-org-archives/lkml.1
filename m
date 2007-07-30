Return-Path: <linux-kernel-owner+w=401wt.eu-S965400AbXG3QXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400AbXG3QXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938734AbXG3QPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:15:03 -0400
Received: from ns.suse.de ([195.135.220.2]:40573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161324.340905604@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:36 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 13/26] ext3 whiteout support
Content-Disposition: inline; filename=um/ext3-whiteout.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce whiteout support for ext3.

- Needs a reserved inode number for white-outs
- S_OPAQUE isn't persistently stored

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext3/dir.c           |    3 ++-
 fs/ext3/namei.c         |   33 +++++++++++++++++++++++++++++++++
 fs/ext3/super.c         |    5 ++++-
 include/linux/ext3_fs.h |    5 ++++-
 4 files changed, 43 insertions(+), 3 deletions(-)

--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -29,7 +29,8 @@
 #include <linux/rbtree.h>
 
 static unsigned char ext3_filetype_table[] = {
-	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
+	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK,
+	DT_WHT
 };
 
 static int ext3_readdir(struct file *, void *, filldir_t);
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1081,6 +1081,7 @@ static unsigned char ext3_type_by_mode[S
 	[S_IFIFO >> S_SHIFT]	= EXT3_FT_FIFO,
 	[S_IFSOCK >> S_SHIFT]	= EXT3_FT_SOCK,
 	[S_IFLNK >> S_SHIFT]	= EXT3_FT_SYMLINK,
+	[S_IFWHT >> S_SHIFT]	= EXT3_FT_WHT,
 };
 
 static inline void ext3_set_de_type(struct super_block *sb,
@@ -2070,6 +2071,37 @@ end_rmdir:
 	return retval;
 }
 
+static int ext3_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode;
+	int err, retries = 0;
+	handle_t *handle;
+
+retry:
+	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
+					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 3 +
+					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	if (IS_DIRSYNC(dir))
+		handle->h_sync = 1;
+
+	inode = ext3_new_inode (handle, dir, S_IFWHT | S_IRUGO);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out_stop;
+
+	init_special_inode(inode, inode->i_mode, 0);
+	err = ext3_add_nondir(handle, dentry, inode);
+
+out_stop:
+	ext3_journal_stop(handle);
+	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
+		goto retry;
+	return err;
+}
+
 static int ext3_unlink(struct inode * dir, struct dentry *dentry)
 {
 	int retval;
@@ -2387,6 +2419,7 @@ const struct inode_operations ext3_dir_i
 	.mkdir		= ext3_mkdir,
 	.rmdir		= ext3_rmdir,
 	.mknod		= ext3_mknod,
+	.whiteout	= ext3_whiteout,
 	.rename		= ext3_rename,
 	.setattr	= ext3_setattr,
 #ifdef CONFIG_EXT3_FS_XATTR
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1500,6 +1500,9 @@ static int ext3_fill_super (struct super
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((sbi->s_mount_opt & EXT3_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
 
+	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_WHITEOUT))
+		sb->s_flags |= MS_WHITEOUT;
+
 	if (le32_to_cpu(es->s_rev_level) == EXT3_GOOD_OLD_REV &&
 	    (EXT3_HAS_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT3_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
@@ -2764,7 +2767,7 @@ static struct file_system_type ext3_fs_t
 	.name		= "ext3",
 	.get_sb		= ext3_get_sb,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_WHT,
 };
 
 static int __init init_ext3_fs(void)
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -63,6 +63,7 @@
 #define EXT3_UNDEL_DIR_INO	 6	/* Undelete directory inode */
 #define EXT3_RESIZE_INO		 7	/* Reserved group descriptors inode */
 #define EXT3_JOURNAL_INO	 8	/* Journal inode */
+#define EXT3_WHT_INO		 9	/* Whiteout inode */
 
 /* First non-reserved inode for old ext3 filesystems */
 #define EXT3_GOOD_OLD_FIRST_INO	11
@@ -582,6 +583,7 @@ static inline int ext3_valid_inum(struct
 #define EXT3_FEATURE_INCOMPAT_RECOVER		0x0004 /* Needs recovery */
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008 /* Journal device */
 #define EXT3_FEATURE_INCOMPAT_META_BG		0x0010
+#define EXT3_FEATURE_INCOMPAT_WHITEOUT		0x0020
 
 #define EXT3_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT3_FEATURE_INCOMPAT_SUPP	(EXT3_FEATURE_INCOMPAT_FILETYPE| \
@@ -648,8 +650,9 @@ struct ext3_dir_entry_2 {
 #define EXT3_FT_FIFO		5
 #define EXT3_FT_SOCK		6
 #define EXT3_FT_SYMLINK		7
+#define EXT3_FT_WHT		8
 
-#define EXT3_FT_MAX		8
+#define EXT3_FT_MAX		9
 
 /*
  * EXT3_DIR_PAD defines the directory entries boundaries

-- 

