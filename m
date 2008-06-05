Return-Path: <linux-kernel-owner+w=401wt.eu-S1763695AbYFEXdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763695AbYFEXdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 19:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYFEXc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 19:32:58 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:54222 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbYFEXc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:32:57 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] fat: Relax the permission check of fat_setattr()
Date: Fri, 06 Jun 2008 08:32:50 +0900
Message-ID: <8763sntq3h.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New chmod() allows only acceptable permission, and if not acceptable,
it returns -EPERM. Old one allows even if it can't store permission to
on disk inode. But it seems too strict for users.

E.g. https://bugzilla.redhat.com/show_bug.cgi?id=449080: With new one,
rsync couldn't create the temporary file.

So, this patch allows like old one, but now it doesn't change the
permission if it can't store, and it returns 0.

Also, this patch fixes missing check.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/file.c |   44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff -puN fs/fat/file.c~fat_setattr-fix fs/fat/file.c
--- linux-2.6/fs/fat/file.c~fat_setattr-fix	2008-06-05 06:48:11.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/file.c	2008-06-05 09:58:14.000000000 +0900
@@ -257,26 +257,34 @@ int fat_getattr(struct vfsmount *mnt, st
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
 
-static int fat_check_mode(const struct msdos_sb_info *sbi, struct inode *inode,
-			  mode_t mode)
+static int fat_sanitize_mode(const struct msdos_sb_info *sbi,
+			     struct inode *inode, umode_t *mode_ptr)
 {
-	mode_t mask, req = mode & ~S_IFMT;
+	mode_t mask, perm;
 
-	if (S_ISREG(mode))
+	/*
+	 * Note, the basic check is already done by a caller of
+	 * (attr->ia_mode & ~MSDOS_VALID_MODE)
+	 */
+
+	if (S_ISREG(inode->i_mode))
 		mask = sbi->options.fs_fmask;
 	else
 		mask = sbi->options.fs_dmask;
 
+	perm = *mode_ptr & ~(S_IFMT | mask);
+
 	/*
 	 * Of the r and x bits, all (subject to umask) must be present. Of the
 	 * w bits, either all (subject to umask) or none must be present.
 	 */
-	req &= ~mask;
-	if ((req & (S_IRUGO | S_IXUGO)) != (inode->i_mode & (S_IRUGO|S_IXUGO)))
+	if ((perm & (S_IRUGO | S_IXUGO)) != (inode->i_mode & (S_IRUGO|S_IXUGO)))
 		return -EPERM;
-	if ((req & S_IWUGO) && ((req & S_IWUGO) != (S_IWUGO & ~mask)))
+	if ((perm & S_IWUGO) && ((perm & S_IWUGO) != (S_IWUGO & ~mask)))
 		return -EPERM;
 
+	*mode_ptr &= S_IFMT | perm;
+
 	return 0;
 }
 
@@ -299,7 +307,7 @@ int fat_setattr(struct dentry *dentry, s
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 	struct inode *inode = dentry->d_inode;
-	int mask, error = 0;
+	int error = 0;
 	unsigned int ia_valid;
 
 	lock_kernel();
@@ -332,12 +340,13 @@ int fat_setattr(struct dentry *dentry, s
 			error = 0;
 		goto out;
 	}
+
 	if (((attr->ia_valid & ATTR_UID) &&
 	     (attr->ia_uid != sbi->options.fs_uid)) ||
 	    ((attr->ia_valid & ATTR_GID) &&
 	     (attr->ia_gid != sbi->options.fs_gid)) ||
 	    ((attr->ia_valid & ATTR_MODE) &&
-	     fat_check_mode(sbi, inode, attr->ia_mode) < 0))
+	     (attr->ia_mode & ~MSDOS_VALID_MODE)))
 		error = -EPERM;
 
 	if (error) {
@@ -346,15 +355,16 @@ int fat_setattr(struct dentry *dentry, s
 		goto out;
 	}
 
-	error = inode_setattr(inode, attr);
-	if (error)
-		goto out;
+	/*
+	 * We don't return -EPERM here. Yes, strange, but this is too
+	 * old behavior.
+	 */
+	if (attr->ia_valid & ATTR_MODE) {
+		if (fat_sanitize_mode(sbi, inode, &attr->ia_mode) < 0)
+			attr->ia_valid &= ~ATTR_MODE;
+	}
 
-	if (S_ISDIR(inode->i_mode))
-		mask = sbi->options.fs_dmask;
-	else
-		mask = sbi->options.fs_fmask;
-	inode->i_mode &= S_IFMT | (S_IRWXUGO & ~mask);
+	error = inode_setattr(inode, attr);
 out:
 	unlock_kernel();
 	return error;
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
