Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbYEPQew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbYEPQew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYEPQck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:32:40 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33715 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbYEPQcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:32:36 -0400
Message-Id: <20080516163222.235825996@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:43 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [patch 07/22] fat: dont call notify_change
Content-Disposition: inline; filename=fat_notify_change_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The FAT_IOCTL_SET_ATTRIBUTES ioctl() calls notify_change() to change
the file mode before changing the inode attributes.  Replace with
explicit calls to security_inode_setattr(), fat_setattr() and
fsnotify_change().

This is equivalent to the original.  The reason it is needed, is that
later in the series we move the immutable check into notify_change().
That would break the FAT_IOCTL_SET_ATTRIBUTES ioctl, as it needs to
perform the mode change regardless of the immutability of the file.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/file.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/fat/file.c
===================================================================
--- linux-2.6.orig/fs/fat/file.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/fs/fat/file.c	2008-05-16 17:50:45.000000000 +0200
@@ -16,6 +16,8 @@
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
+#include <linux/fsnotify.h>
+#include <linux/security.h>
 
 int fat_generic_ioctl(struct inode *inode, struct file *filp,
 		      unsigned int cmd, unsigned long arg)
@@ -65,6 +67,7 @@ int fat_generic_ioctl(struct inode *inod
 
 		/* Equivalent to a chmod() */
 		ia.ia_valid = ATTR_MODE | ATTR_CTIME;
+		ia.ia_ctime = current_fs_time(inode->i_sb);
 		if (is_dir) {
 			ia.ia_mode = MSDOS_MKMODE(attr,
 				S_IRWXUGO & ~sbi->options.fs_dmask)
@@ -91,11 +94,21 @@ int fat_generic_ioctl(struct inode *inod
 			}
 		}
 
+		/*
+		 * The security check is questionable...  We single
+		 * out the RO attribute for checking by the security
+		 * module, just because it maps to a file mode.
+		 */
+		err = security_inode_setattr(filp->f_path.dentry, &ia);
+		if (err)
+			goto up;
+
 		/* This MUST be done before doing anything irreversible... */
-		err = notify_change(filp->f_path.dentry, &ia);
+		err = fat_setattr(filp->f_path.dentry, &ia);
 		if (err)
 			goto up;
 
+		fsnotify_change(filp->f_path.dentry, ia.ia_valid);
 		if (sbi->options.sys_immutable) {
 			if (attr & ATTR_SYS)
 				inode->i_flags |= S_IMMUTABLE;

--
