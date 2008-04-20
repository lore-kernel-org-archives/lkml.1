Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbYDTSZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbYDTSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbYDTSYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:24:37 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45908 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYDTSYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:24:34 -0400
Subject: [PATCH 3/9] fat: fat_setattr() fix
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 21 Apr 2008 03:13:25 +0900
Message-ID: <954304cc3e8480b87c535695.ps@mail.parknet.co.jp>
References: <60d0156a3e8480b87c215695.ps@mail.parknet.co.jp>
	<5cb1b5773e8480b87c425695.ps@mail.parknet.co.jp>
In-Reply-To: <5cb1b5773e8480b87c425695.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Fix fat_setattr() on the case of showexec option. If user specified
showexec option, inode->i_mode may not have S_IXUGO. This just use
inode->i_mode to fix it.

And with this patch, we don't allow chmod() on memory inode, it's just
bad behaviour. IOW, we allow changing S_IWUGO only which can be stored
to disk.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/file.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN fs/fat/file.c~fat_setattr-fix fs/fat/file.c
--- linux-2.6/fs/fat/file.c~fat_setattr-fix	2008-02-20 15:28:06.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/file.c	2008-02-21 11:42:25.000000000 +0900
@@ -255,7 +255,8 @@ int fat_getattr(struct vfsmount *mnt, st
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
 
-static int fat_check_mode(const struct msdos_sb_info *sbi, mode_t mode)
+static int fat_check_mode(const struct msdos_sb_info *sbi, struct inode *inode,
+			  mode_t mode)
 {
 	mode_t mask, req = mode & ~S_IFMT;
 
@@ -269,7 +270,7 @@ static int fat_check_mode(const struct m
 	 * w bits, either all (subject to umask) or none must be present.
 	 */
 	req &= ~mask;
-	if ((req & (S_IRUGO | S_IXUGO)) != ((S_IRUGO | S_IXUGO) & ~mask))
+	if ((req & (S_IRUGO | S_IXUGO)) != (inode->i_mode & (S_IRUGO|S_IXUGO)))
 		return -EPERM;
 	if ((req & S_IWUGO) && ((req & S_IWUGO) != (S_IWUGO & ~mask)))
 		return -EPERM;
@@ -308,7 +309,9 @@ int fat_setattr(struct dentry *dentry, s
 	if (((attr->ia_valid & ATTR_UID) &&
 	     (attr->ia_uid != sbi->options.fs_uid)) ||
 	    ((attr->ia_valid & ATTR_GID) &&
-	     (attr->ia_gid != sbi->options.fs_gid)))
+	     (attr->ia_gid != sbi->options.fs_gid)) ||
+	    ((attr->ia_valid & ATTR_MODE) &&
+	     fat_check_mode(sbi, inode, attr->ia_mode) < 0))
 		error = -EPERM;
 
 	if (error) {
@@ -317,12 +320,6 @@ int fat_setattr(struct dentry *dentry, s
 		goto out;
 	}
 
-	if (attr->ia_valid & ATTR_MODE) {
-		error = fat_check_mode(sbi, attr->ia_mode);
-		if (error != 0 && !sbi->options.quiet)
-			goto out;
-	}
-
 	error = inode_setattr(inode, attr);
 	if (error)
 		goto out;
_
