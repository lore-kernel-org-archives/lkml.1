Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbYDTS0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbYDTS0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYDTSYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:24:40 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45910 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbYDTSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:24:36 -0400
Subject: [PATCH 2/9] fat: fat_notify_change() and check_mode() cleanup
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 21 Apr 2008 03:13:24 +0900
Message-ID: <5cb1b5773e8480b87c425695.ps@mail.parknet.co.jp>
References: <60d0156a3e8480b87c215695.ps@mail.parknet.co.jp>
In-Reply-To: <60d0156a3e8480b87c215695.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Rename fat_notify_change() to fat_setattr()
- check_mode() cleanup
- Change layout of code

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/file.c            |  183 +++++++++++++++++++++-------------------------
 fs/msdos/namei.c         |    2 
 fs/vfat/namei.c          |    2 
 include/linux/msdos_fs.h |    2 
 4 files changed, 87 insertions(+), 102 deletions(-)

diff -puN fs/fat/file.c~fat_notify_change-cleanup fs/fat/file.c
--- linux-2.6/fs/fat/file.c~fat_notify_change-cleanup	2008-02-15 19:09:45.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/file.c	2008-02-15 19:31:52.000000000 +0900
@@ -155,104 +155,6 @@ out:
 	return err;
 }
 
-static int check_mode(const struct msdos_sb_info *sbi, mode_t mode)
-{
-	mode_t req = mode & ~S_IFMT;
-
-	/*
-	 * Of the r and x bits, all (subject to umask) must be present. Of the
-	 * w bits, either all (subject to umask) or none must be present.
-	 */
-
-	if (S_ISREG(mode)) {
-		req &= ~sbi->options.fs_fmask;
-
-		if ((req & (S_IRUGO | S_IXUGO)) !=
-		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_fmask))
-			return -EPERM;
-
-		if ((req & S_IWUGO) != 0 &&
-		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_fmask))
-			return -EPERM;
-	} else if (S_ISDIR(mode)) {
-		req &= ~sbi->options.fs_dmask;
-
-		if ((req & (S_IRUGO | S_IXUGO)) !=
-		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_dmask))
-			return -EPERM;
-
-		if ((req & S_IWUGO) != 0 &&
-		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_dmask))
-			return -EPERM;
-	} else {
-		return -EPERM;
-	}
-
-	return 0;
-}
-
-int fat_notify_change(struct dentry *dentry, struct iattr *attr)
-{
-	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
-	struct inode *inode = dentry->d_inode;
-	int mask, error = 0;
-
-	lock_kernel();
-
-	/*
-	 * Expand the file. Since inode_setattr() updates ->i_size
-	 * before calling the ->truncate(), but FAT needs to fill the
-	 * hole before it.
-	 */
-	if (attr->ia_valid & ATTR_SIZE) {
-		if (attr->ia_size > inode->i_size) {
-			error = fat_cont_expand(inode, attr->ia_size);
-			if (error || attr->ia_valid == ATTR_SIZE)
-				goto out;
-			attr->ia_valid &= ~ATTR_SIZE;
-		}
-	}
-
-	error = inode_change_ok(inode, attr);
-	if (error) {
-		if (sbi->options.quiet)
-			error = 0;
-		goto out;
-	}
-	if (((attr->ia_valid & ATTR_UID) &&
-	     (attr->ia_uid != sbi->options.fs_uid)) ||
-	    ((attr->ia_valid & ATTR_GID) &&
-	     (attr->ia_gid != sbi->options.fs_gid)))
-		error = -EPERM;
-
-	if (error) {
-		if (sbi->options.quiet)
-			error = 0;
-		goto out;
-	}
-
-	if (attr->ia_valid & ATTR_MODE) {
-		error = check_mode(sbi, attr->ia_mode);
-		if (error != 0 && !sbi->options.quiet)
-			goto out;
-	}
-
-	error = inode_setattr(inode, attr);
-	if (error)
-		goto out;
-
-	if (S_ISDIR(inode->i_mode))
-		mask = sbi->options.fs_dmask;
-	else
-		mask = sbi->options.fs_fmask;
-	inode->i_mode &= S_IFMT | (S_IRWXUGO & ~mask);
-out:
-	unlock_kernel();
-	return error;
-}
-
-EXPORT_SYMBOL_GPL(fat_notify_change);
-
 /* Free all clusters after the skip'th cluster. */
 static int fat_free(struct inode *inode, int skip)
 {
@@ -353,8 +255,91 @@ int fat_getattr(struct vfsmount *mnt, st
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
 
+static int fat_check_mode(const struct msdos_sb_info *sbi, mode_t mode)
+{
+	mode_t mask, req = mode & ~S_IFMT;
+
+	if (S_ISREG(mode))
+		mask = sbi->options.fs_fmask;
+	else
+		mask = sbi->options.fs_dmask;
+
+	/*
+	 * Of the r and x bits, all (subject to umask) must be present. Of the
+	 * w bits, either all (subject to umask) or none must be present.
+	 */
+	req &= ~mask;
+	if ((req & (S_IRUGO | S_IXUGO)) != ((S_IRUGO | S_IXUGO) & ~mask))
+		return -EPERM;
+	if ((req & S_IWUGO) && ((req & S_IWUGO) != (S_IWUGO & ~mask)))
+		return -EPERM;
+
+	return 0;
+}
+
+int fat_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
+	struct inode *inode = dentry->d_inode;
+	int mask, error = 0;
+
+	lock_kernel();
+
+	/*
+	 * Expand the file. Since inode_setattr() updates ->i_size
+	 * before calling the ->truncate(), but FAT needs to fill the
+	 * hole before it.
+	 */
+	if (attr->ia_valid & ATTR_SIZE) {
+		if (attr->ia_size > inode->i_size) {
+			error = fat_cont_expand(inode, attr->ia_size);
+			if (error || attr->ia_valid == ATTR_SIZE)
+				goto out;
+			attr->ia_valid &= ~ATTR_SIZE;
+		}
+	}
+
+	error = inode_change_ok(inode, attr);
+	if (error) {
+		if (sbi->options.quiet)
+			error = 0;
+		goto out;
+	}
+	if (((attr->ia_valid & ATTR_UID) &&
+	     (attr->ia_uid != sbi->options.fs_uid)) ||
+	    ((attr->ia_valid & ATTR_GID) &&
+	     (attr->ia_gid != sbi->options.fs_gid)))
+		error = -EPERM;
+
+	if (error) {
+		if (sbi->options.quiet)
+			error = 0;
+		goto out;
+	}
+
+	if (attr->ia_valid & ATTR_MODE) {
+		error = fat_check_mode(sbi, attr->ia_mode);
+		if (error != 0 && !sbi->options.quiet)
+			goto out;
+	}
+
+	error = inode_setattr(inode, attr);
+	if (error)
+		goto out;
+
+	if (S_ISDIR(inode->i_mode))
+		mask = sbi->options.fs_dmask;
+	else
+		mask = sbi->options.fs_fmask;
+	inode->i_mode &= S_IFMT | (S_IRWXUGO & ~mask);
+out:
+	unlock_kernel();
+	return error;
+}
+EXPORT_SYMBOL_GPL(fat_setattr);
+
 const struct inode_operations fat_file_inode_operations = {
 	.truncate	= fat_truncate,
-	.setattr	= fat_notify_change,
+	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 };
diff -puN fs/msdos/namei.c~fat_notify_change-cleanup fs/msdos/namei.c
--- linux-2.6/fs/msdos/namei.c~fat_notify_change-cleanup	2008-02-15 19:13:05.000000000 +0900
+++ linux-2.6-hirofumi/fs/msdos/namei.c	2008-02-15 19:13:09.000000000 +0900
@@ -653,7 +653,7 @@ static const struct inode_operations msd
 	.mkdir		= msdos_mkdir,
 	.rmdir		= msdos_rmdir,
 	.rename		= msdos_rename,
-	.setattr	= fat_notify_change,
+	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 };
 
diff -puN fs/vfat/namei.c~fat_notify_change-cleanup fs/vfat/namei.c
--- linux-2.6/fs/vfat/namei.c~fat_notify_change-cleanup	2008-02-15 19:13:18.000000000 +0900
+++ linux-2.6-hirofumi/fs/vfat/namei.c	2008-02-15 19:13:23.000000000 +0900
@@ -1003,7 +1003,7 @@ static const struct inode_operations vfa
 	.mkdir		= vfat_mkdir,
 	.rmdir		= vfat_rmdir,
 	.rename		= vfat_rename,
-	.setattr	= fat_notify_change,
+	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 };
 
diff -puN include/linux/msdos_fs.h~fat_notify_change-cleanup include/linux/msdos_fs.h
--- linux-2.6/include/linux/msdos_fs.h~fat_notify_change-cleanup	2008-02-15 19:13:32.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/msdos_fs.h	2008-02-15 19:13:37.000000000 +0900
@@ -401,7 +401,7 @@ extern int fat_generic_ioctl(struct inod
 			     unsigned int cmd, unsigned long arg);
 extern const struct file_operations fat_file_operations;
 extern const struct inode_operations fat_file_inode_operations;
-extern int fat_notify_change(struct dentry * dentry, struct iattr * attr);
+extern int fat_setattr(struct dentry * dentry, struct iattr * attr);
 extern void fat_truncate(struct inode *inode);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		       struct kstat *stat);
_
