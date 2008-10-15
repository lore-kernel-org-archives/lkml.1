Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYJOOJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYJOOJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYJOOFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:05:00 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45128 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYJOOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:48 -0400
Subject: [PATCH 14/21] fat: Cleanup FAT attribute stuff
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:00 +0900
Message-ID: <6b812e3e3e848f5f6e81422369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
	<a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
	<091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
	<649ecd633e848f5f6e6822369.ps@mail.parknet.co.jp>
	<2f7c69713e848f5f6e6922369.ps@mail.parknet.co.jp>
	<db8ca48d3e848f5f6e71022369.ps@mail.parknet.co.jp>
	<6caa18733e848f5f6e71122369.ps@mail.parknet.co.jp>
	<c862f7d73e848f5f6e71222369.ps@mail.parknet.co.jp>
	<5cfc12333e848f5f6e71322369.ps@mail.parknet.co.jp>
In-Reply-To: <5cfc12333e848f5f6e71322369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds three helpers:

fat_make_attrs() - makes FAT attributes from inode.
fat_make_mode()  - makes mode_t from FAT attributes.
fat_save_attrs() - saves FAT attributes to inode.

Then this replaces: MSDOS_MKMODE() by fat_make_mode(), fat_attr() by
fat_make_attrs(), ->i_attrs = attr & ATTR_UNUSED by fat_save_attrs().
And for root inode, those is used with ATTR_DIR instead of bogus
ATTR_NONE.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fat.h             |   20 +++++++++++++++++++-
 fs/fat/file.c            |   32 ++++++++++++--------------------
 fs/fat/inode.c           |   19 +++++++++----------
 include/linux/msdos_fs.h |    5 -----
 4 files changed, 40 insertions(+), 36 deletions(-)

diff -puN fs/fat/file.c~fat-attrs-cleanup fs/fat/file.c
--- linux-2.6/fs/fat/file.c~fat-attrs-cleanup	2008-08-27 19:33:26.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/file.c	2008-08-27 22:24:41.000000000 +0900
@@ -27,13 +27,7 @@ int fat_generic_ioctl(struct inode *inod
 	switch (cmd) {
 	case FAT_IOCTL_GET_ATTRIBUTES:
 	{
-		u32 attr;
-
-		if (inode->i_ino == MSDOS_ROOT_INO)
-			attr = ATTR_DIR;
-		else
-			attr = fat_attr(inode);
-
+		u32 attr = fat_make_attrs(inode);
 		return put_user(attr, user_attr);
 	}
 	case FAT_IOCTL_SET_ATTRIBUTES:
@@ -62,20 +56,16 @@ int fat_generic_ioctl(struct inode *inod
 		/* Merge in ATTR_VOLUME and ATTR_DIR */
 		attr |= (MSDOS_I(inode)->i_attrs & ATTR_VOLUME) |
 			(is_dir ? ATTR_DIR : 0);
-		oldattr = fat_attr(inode);
+		oldattr = fat_make_attrs(inode);
 
 		/* Equivalent to a chmod() */
 		ia.ia_valid = ATTR_MODE | ATTR_CTIME;
 		ia.ia_ctime = current_fs_time(inode->i_sb);
-		if (is_dir) {
-			ia.ia_mode = MSDOS_MKMODE(attr,
-				S_IRWXUGO & ~sbi->options.fs_dmask)
-				| S_IFDIR;
-		} else {
-			ia.ia_mode = MSDOS_MKMODE(attr,
-				(S_IRUGO | S_IWUGO | (inode->i_mode & S_IXUGO))
-				& ~sbi->options.fs_fmask)
-				| S_IFREG;
+		if (is_dir)
+			ia.ia_mode = fat_make_mode(sbi, attr, S_IRWXUGO);
+		else {
+			ia.ia_mode = fat_make_mode(sbi, attr,
+				S_IRUGO | S_IWUGO | (inode->i_mode & S_IXUGO));
 		}
 
 		/* The root directory has no attributes */
@@ -115,7 +105,7 @@ int fat_generic_ioctl(struct inode *inod
 				inode->i_flags &= S_IMMUTABLE;
 		}
 
-		MSDOS_I(inode)->i_attrs = attr & ATTR_UNUSED;
+		fat_save_attrs(inode, attr);
 		mark_inode_dirty(inode);
 up:
 		mnt_drop_write(filp->f_path.mnt);
@@ -274,7 +264,7 @@ static int fat_sanitize_mode(const struc
 
 	/*
 	 * Note, the basic check is already done by a caller of
-	 * (attr->ia_mode & ~MSDOS_VALID_MODE)
+	 * (attr->ia_mode & ~FAT_VALID_MODE)
 	 */
 
 	if (S_ISREG(inode->i_mode))
@@ -314,6 +304,8 @@ static int fat_allow_set_time(struct msd
 }
 
 #define TIMES_SET_FLAGS	(ATTR_MTIME_SET | ATTR_ATIME_SET | ATTR_TIMES_SET)
+/* valid file mode bits */
+#define FAT_VALID_MODE	(S_IFREG | S_IFDIR | S_IRWXUGO)
 
 int fat_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -356,7 +348,7 @@ int fat_setattr(struct dentry *dentry, s
 	    ((attr->ia_valid & ATTR_GID) &&
 	     (attr->ia_gid != sbi->options.fs_gid)) ||
 	    ((attr->ia_valid & ATTR_MODE) &&
-	     (attr->ia_mode & ~MSDOS_VALID_MODE)))
+	     (attr->ia_mode & ~FAT_VALID_MODE)))
 		error = -EPERM;
 
 	if (error) {
diff -puN fs/fat/fat.h~fat-attrs-cleanup fs/fat/fat.h
--- linux-2.6/fs/fat/fat.h~fat-attrs-cleanup	2008-08-27 19:33:26.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fat.h	2008-08-27 22:24:41.000000000 +0900
@@ -117,14 +117,32 @@ static inline struct msdos_inode_info *M
 	return container_of(inode, struct msdos_inode_info, vfs_inode);
 }
 
+/* Convert attribute bits and a mask to the UNIX mode. */
+static inline mode_t fat_make_mode(struct msdos_sb_info *sbi,
+				   u8 attrs, mode_t mode)
+{
+	if (attrs & ATTR_RO)
+		mode &= ~S_IWUGO;
+
+	if (attrs & ATTR_DIR)
+		return (mode & ~sbi->options.fs_dmask) | S_IFDIR;
+	else
+		return (mode & ~sbi->options.fs_fmask) | S_IFREG;
+}
+
 /* Return the FAT attribute byte for this inode */
-static inline u8 fat_attr(struct inode *inode)
+static inline u8 fat_make_attrs(struct inode *inode)
 {
 	return ((inode->i_mode & S_IWUGO) ? ATTR_NONE : ATTR_RO) |
 		(S_ISDIR(inode->i_mode) ? ATTR_DIR : ATTR_NONE) |
 		MSDOS_I(inode)->i_attrs;
 }
 
+static inline void fat_save_attrs(struct inode *inode, u8 attrs)
+{
+	MSDOS_I(inode)->i_attrs = attrs & ATTR_UNUSED;
+}
+
 static inline unsigned char fat_checksum(const __u8 *name)
 {
 	unsigned char s = name[0];
diff -puN fs/fat/inode.c~fat-attrs-cleanup fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat-attrs-cleanup	2008-08-27 19:33:26.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-08-27 22:24:41.000000000 +0900
@@ -337,8 +337,7 @@ static int fat_fill_inode(struct inode *
 
 	if ((de->attr & ATTR_DIR) && !IS_FREE(de->name)) {
 		inode->i_generation &= ~1;
-		inode->i_mode = MSDOS_MKMODE(de->attr,
-			S_IRWXUGO & ~sbi->options.fs_dmask) | S_IFDIR;
+		inode->i_mode = fat_make_mode(sbi, de->attr, S_IRWXUGO);
 		inode->i_op = sbi->dir_ops;
 		inode->i_fop = &fat_dir_operations;
 
@@ -355,10 +354,9 @@ static int fat_fill_inode(struct inode *
 		inode->i_nlink = fat_subdirs(inode);
 	} else { /* not a directory */
 		inode->i_generation |= 1;
-		inode->i_mode = MSDOS_MKMODE(de->attr,
-		    ((sbi->options.showexec && !is_exec(de->name + 8))
-			? S_IRUGO|S_IWUGO : S_IRWXUGO)
-		    & ~sbi->options.fs_fmask) | S_IFREG;
+		inode->i_mode = fat_make_mode(sbi, de->attr,
+			((sbi->options.showexec && !is_exec(de->name + 8))
+			 ? S_IRUGO|S_IWUGO : S_IRWXUGO));
 		MSDOS_I(inode)->i_start = le16_to_cpu(de->start);
 		if (sbi->fat_bits == 32)
 			MSDOS_I(inode)->i_start |= (le16_to_cpu(de->starthi) << 16);
@@ -374,7 +372,8 @@ static int fat_fill_inode(struct inode *
 		if (sbi->options.sys_immutable)
 			inode->i_flags |= S_IMMUTABLE;
 	}
-	MSDOS_I(inode)->i_attrs = de->attr & ATTR_UNUSED;
+	fat_save_attrs(inode, de->attr);
+
 	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 
@@ -569,7 +568,7 @@ retry:
 		raw_entry->size = 0;
 	else
 		raw_entry->size = cpu_to_le32(inode->i_size);
-	raw_entry->attr = fat_attr(inode);
+	raw_entry->attr = fat_make_attrs(inode);
 	raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
 	raw_entry->starthi = cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
 	fat_time_unix2fat(sbi, &inode->i_mtime, &raw_entry->time,
@@ -1121,7 +1120,7 @@ static int fat_read_root(struct inode *i
 	inode->i_gid = sbi->options.fs_gid;
 	inode->i_version++;
 	inode->i_generation = 0;
-	inode->i_mode = (S_IRWXUGO & ~sbi->options.fs_dmask) | S_IFDIR;
+	inode->i_mode = fat_make_mode(sbi, ATTR_DIR, S_IRWXUGO);
 	inode->i_op = sbi->dir_ops;
 	inode->i_fop = &fat_dir_operations;
 	if (sbi->fat_bits == 32) {
@@ -1138,7 +1137,7 @@ static int fat_read_root(struct inode *i
 	MSDOS_I(inode)->i_logstart = 0;
 	MSDOS_I(inode)->mmu_private = inode->i_size;
 
-	MSDOS_I(inode)->i_attrs = ATTR_NONE;
+	fat_save_attrs(inode, ATTR_DIR);
 	inode->i_mtime.tv_sec = inode->i_atime.tv_sec = inode->i_ctime.tv_sec = 0;
 	inode->i_mtime.tv_nsec = inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = 0;
 	inode->i_nlink = fat_subdirs(inode)+2;
diff -puN include/linux/msdos_fs.h~fat-attrs-cleanup include/linux/msdos_fs.h
--- linux-2.6/include/linux/msdos_fs.h~fat-attrs-cleanup	2008-08-27 19:33:26.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/msdos_fs.h	2008-08-27 22:24:40.000000000 +0900
@@ -46,11 +46,6 @@
 #define DELETED_FLAG	0xe5	/* marks file as deleted when in name[0] */
 #define IS_FREE(n)	(!*(n) || *(n) == DELETED_FLAG)
 
-/* valid file mode bits */
-#define MSDOS_VALID_MODE (S_IFREG | S_IFDIR | S_IRWXU | S_IRWXG | S_IRWXO)
-/* Convert attribute bits and a mask to the UNIX mode. */
-#define MSDOS_MKMODE(a, m) (m & (a & ATTR_RO ? S_IRUGO|S_IXUGO : S_IRWXUGO))
-
 #define MSDOS_NAME	11	/* maximum name length */
 #define MSDOS_LONGNAME	256	/* maximum name length */
 #define MSDOS_SLOTS	21	/* max # of slots for short and long names */
_
