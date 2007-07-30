Return-Path: <linux-kernel-owner+w=401wt.eu-S966159AbXG3QX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966159AbXG3QX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765626AbXG3QPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:15:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:58718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161324.261652101@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:35 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 12/26] ext2 white-out support
Content-Disposition: inline; filename=um/ext2-whiteout.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce white-out support to ext2.

Known Bugs:
- Needs a reserved inode number for white-outs
- S_OPAQUE isn't persistently stored

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
---
 fs/ext2/dir.c           |    2 ++
 fs/ext2/namei.c         |   18 ++++++++++++++++++
 fs/ext2/super.c         |    5 ++++-
 include/linux/ext2_fs.h |    4 ++++
 4 files changed, 28 insertions(+), 1 deletion(-)

--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -230,6 +230,7 @@ static unsigned char ext2_filetype_table
 	[EXT2_FT_FIFO]		= DT_FIFO,
 	[EXT2_FT_SOCK]		= DT_SOCK,
 	[EXT2_FT_SYMLINK]	= DT_LNK,
+	[EXT2_FT_WHT]		= DT_WHT,
 };
 
 #define S_SHIFT 12
@@ -241,6 +242,7 @@ static unsigned char ext2_type_by_mode[S
 	[S_IFIFO >> S_SHIFT]	= EXT2_FT_FIFO,
 	[S_IFSOCK >> S_SHIFT]	= EXT2_FT_SOCK,
 	[S_IFLNK >> S_SHIFT]	= EXT2_FT_SYMLINK,
+	[S_IFWHT >> S_SHIFT]	= EXT2_FT_WHT,
 };
 
 static inline void ext2_set_de_type(ext2_dirent *de, struct inode *inode)
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -288,6 +288,23 @@ static int ext2_rmdir (struct inode * di
 	return err;
 }
 
+static int ext2_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode;
+	int err;
+
+	inode = ext2_new_inode (dir, S_IFWHT | S_IRUGO);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out;
+
+	init_special_inode(inode, inode->i_mode, 0);
+	mark_inode_dirty(inode);
+	err = ext2_add_nondir(dentry, inode);
+out:
+	return err;
+}
+
 static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	struct inode * new_dir,	struct dentry * new_dentry )
 {
@@ -382,6 +399,7 @@ const struct inode_operations ext2_dir_i
 	.mkdir		= ext2_mkdir,
 	.rmdir		= ext2_rmdir,
 	.mknod		= ext2_mknod,
+	.whiteout	= ext2_whiteout,
 	.rename		= ext2_rename,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -752,6 +752,9 @@ static int ext2_fill_super(struct super_
 	ext2_xip_verify_sb(sb); /* see if bdev supports xip, unset
 				    EXT2_MOUNT_XIP if not */
 
+	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_WHITEOUT))
+		sb->s_flags |= MS_WHITEOUT;
+
 	if (le32_to_cpu(es->s_rev_level) == EXT2_GOOD_OLD_REV &&
 	    (EXT2_HAS_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT2_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
@@ -1299,7 +1302,7 @@ static struct file_system_type ext2_fs_t
 	.name		= "ext2",
 	.get_sb		= ext2_get_sb,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_WHT,
 };
 
 static int __init init_ext2_fs(void)
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -61,6 +61,7 @@
 #define EXT2_ROOT_INO		 2	/* Root inode */
 #define EXT2_BOOT_LOADER_INO	 5	/* Boot loader inode */
 #define EXT2_UNDEL_DIR_INO	 6	/* Undelete directory inode */
+#define EXT2_WHT_INO		 7	/* Whiteout inode */
 
 /* First non-reserved inode for old ext2 filesystems */
 #define EXT2_GOOD_OLD_FIRST_INO	11
@@ -479,10 +480,12 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_RECOVER		0x0004
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
+#define EXT2_FEATURE_INCOMPAT_WHITEOUT		0x0020
 #define EXT2_FEATURE_INCOMPAT_ANY		0xffffffff
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT2_FEATURE_INCOMPAT_WHITEOUT| \
 					 EXT2_FEATURE_INCOMPAT_META_BG)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
@@ -549,6 +552,7 @@ enum {
 	EXT2_FT_FIFO,
 	EXT2_FT_SOCK,
 	EXT2_FT_SYMLINK,
+	EXT2_FT_WHT,
 	EXT2_FT_MAX
 };
 

-- 

