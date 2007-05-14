Return-Path: <linux-kernel-owner+w=401wt.eu-S966183AbXENJiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966183AbXENJiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030357AbXENJh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:37:27 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43116 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965765AbXENJhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:37:23 -0400
Date: Mon, 14 May 2007 15:14:50 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH 13/14] ext3 whiteout support
Message-ID: <20070514094450.GO4139@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514093722.GB4139@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: ext3 whiteout support

Introduce whiteout support for ext3.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext3/dir.c           |    2 -
 fs/ext3/namei.c         |   62 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/ext3/super.c         |   11 +++++++-
 include/linux/ext3_fs.h |    5 +++
 4 files changed, 72 insertions(+), 8 deletions(-)

--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -29,7 +29,7 @@
 #include <linux/rbtree.h>
 
 static unsigned char ext3_filetype_table[] = {
-	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
+	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK, DT_WHT
 };
 
 static int ext3_readdir(struct file *, void *, filldir_t);
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1071,6 +1071,7 @@ static unsigned char ext3_type_by_mode[S
 	[S_IFIFO >> S_SHIFT]	= EXT3_FT_FIFO,
 	[S_IFSOCK >> S_SHIFT]	= EXT3_FT_SOCK,
 	[S_IFLNK >> S_SHIFT]	= EXT3_FT_SYMLINK,
+	[S_IFWHT >> S_SHIFT]	= EXT3_FT_WHT,
 };
 
 static inline void ext3_set_de_type(struct super_block *sb,
@@ -1786,7 +1787,7 @@ out_stop:
 /*
  * routine to check that the specified directory is empty (for rmdir)
  */
-static int empty_dir (struct inode * inode)
+static int empty_dir (handle_t *handle, struct inode * inode)
 {
 	unsigned long offset;
 	struct buffer_head * bh;
@@ -1848,8 +1849,28 @@ static int empty_dir (struct inode * ino
 			continue;
 		}
 		if (le32_to_cpu(de->inode)) {
-			brelse (bh);
-			return 0;
+			/* If this is a whiteout, remove it */
+			if (de->file_type == EXT3_FT_WHT) {
+				unsigned long ino = le32_to_cpu(de->inode);
+				struct inode *tmp_inode = iget(inode->i_sb, ino);
+				if (!tmp_inode) {
+					brelse (bh);
+					return 0;
+				}
+
+				if (ext3_delete_entry(handle, inode, de, bh)) {
+					iput(tmp_inode);
+					brelse (bh);
+					return 0;
+				}
+
+				tmp_inode->i_ctime = inode->i_ctime;
+				tmp_inode->i_nlink--;
+				iput(tmp_inode);
+			} else {
+				brelse (bh);
+				return 0;
+			}
 		}
 		offset += le16_to_cpu(de->rec_len);
 		de = (struct ext3_dir_entry_2 *)
@@ -2031,7 +2052,7 @@ static int ext3_rmdir (struct inode * di
 		goto end_rmdir;
 
 	retval = -ENOTEMPTY;
-	if (!empty_dir (inode))
+	if (!empty_dir (handle, inode))
 		goto end_rmdir;
 
 	retval = ext3_delete_entry(handle, dir, de, bh);
@@ -2060,6 +2081,36 @@ end_rmdir:
 	return retval;
 }
 
+static int ext3_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	struct inode * inode;
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
@@ -2261,7 +2312,7 @@ static int ext3_rename (struct inode * o
 	if (S_ISDIR(old_inode->i_mode)) {
 		if (new_inode) {
 			retval = -ENOTEMPTY;
-			if (!empty_dir (new_inode))
+			if (!empty_dir (handle, new_inode))
 				goto end_rename;
 		}
 		retval = -EIO;
@@ -2377,6 +2428,7 @@ const struct inode_operations ext3_dir_i
 	.mkdir		= ext3_mkdir,
 	.rmdir		= ext3_rmdir,
 	.mknod		= ext3_mknod,
+	.whiteout	= ext3_whiteout,
 	.rename		= ext3_rename,
 	.setattr	= ext3_setattr,
 #ifdef CONFIG_EXT3_FS_XATTR
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1492,6 +1492,15 @@ static int ext3_fill_super (struct super
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((sbi->s_mount_opt & EXT3_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
 
+	if ((sb->s_flags & MS_UNION) && !(sb->s_flags & MS_RDONLY)) {
+		if (!EXT3_HAS_INCOMPAT_FEATURE(sb,
+				EXT3_FEATURE_INCOMPAT_WHITEOUT)) {
+			sb->s_flags |= MS_RDONLY;
+			ext3_warning(sb, __FUNCTION__,
+			"no whiteout support, mounting filesystem read-only");
+		}
+	}
+
 	if (le32_to_cpu(es->s_rev_level) == EXT3_GOOD_OLD_REV &&
 	    (EXT3_HAS_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT3_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
@@ -2748,7 +2757,7 @@ static struct file_system_type ext3_fs_t
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
