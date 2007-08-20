Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbXHTNDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbXHTNDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXHTNDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:03:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52215 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXHTNDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:03:05 -0400
Date: Mon, 20 Aug 2007 15:03:04 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: hirofumi@mail.parknet.co.jp
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] Refine FAT chmod checks
Message-ID: <Pine.LNX.4.64.0708201500490.30570@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


when a vfat filesystem is mounted without the quiet option, chown fails, 
but chmod still succeeds. I think that is wrong.

Run-tested, it does what I want it to do.

===

[fs/fat/]: Refine FAT chmod checks

Prohibit mode changes in non-quiet mode that cannot be stored reliably
with the on-disk format.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 fs/fat/file.c |   47 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 4 deletions(-)

Index: linux-2.6.22/fs/fat/file.c
===================================================================
--- linux-2.6.22.orig/fs/fat/file.c
+++ linux-2.6.22/fs/fat/file.c
@@ -155,6 +155,42 @@ out:
 	return err;
 }
 
+static int check_mode(const struct msdos_sb_info *sbi, mode_t mode)
+{
+	mode_t req = mode & ~S_IFMT;
+
+	/*
+	 * Of the r and x bits, all (subject to umask) must be present. Of the
+	 * w bits, either all (subject to umask) or none must be present.
+	 */
+
+	if (S_ISREG(mode)) {
+		req &= ~sbi->options.fs_fmask;
+
+		if ((req & (S_IRUGO | S_IXUGO)) !=
+		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_fmask))
+			return -EPERM;
+
+		if ((req & S_IWUGO) != 0 &&
+		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_fmask))
+			return -EPERM;
+	} else if (S_ISDIR(mode)) {
+		req &= ~sbi->options.fs_dmask;
+
+		if ((req & (S_IRUGO | S_IXUGO)) !=
+		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_dmask))
+			return -EPERM;
+
+		if ((req & S_IWUGO) != 0 &&
+		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_dmask))
+			return -EPERM;
+	} else {
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 int fat_notify_change(struct dentry *dentry, struct iattr *attr)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
@@ -186,16 +222,19 @@ int fat_notify_change(struct dentry *den
 	if (((attr->ia_valid & ATTR_UID) &&
 	     (attr->ia_uid != sbi->options.fs_uid)) ||
 	    ((attr->ia_valid & ATTR_GID) &&
-	     (attr->ia_gid != sbi->options.fs_gid)) ||
-	    ((attr->ia_valid & ATTR_MODE) &&
-	     (attr->ia_mode & ~MSDOS_VALID_MODE)))
+	     (attr->ia_gid != sbi->options.fs_gid)))
 		error = -EPERM;
-
 	if (error) {
 		if (sbi->options.quiet)
 			error = 0;
 		goto out;
 	}
+
+	if (error == 0 && (attr->ia_valid & ATTR_MODE))
+		if ((error = check_mode(sbi, attr->ia_mode)) != 0 &&
+		    sbi->options.quiet)
+			error = 0;
+
 	error = inode_setattr(inode, attr);
 	if (error)
 		goto out;
