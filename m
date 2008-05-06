Return-Path: <linux-kernel-owner+w=401wt.eu-S1765087AbYEFJSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765087AbYEFJSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764010AbYEFJOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:14:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59521 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763079AbYEFJO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:14:29 -0400
Message-Id: <20080506091414.440652004@szeredi.hu>
References: <20080506091327.259950960@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 May 2008 11:13:34 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [patch 07/24] fat: dont call notify_change
Content-Disposition: inline; filename=fat_notify_change_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The FAT_IOCTL_SET_ATTRIBUTES ioctl() calls notify_change() to change
the file mode before changing the inode attributes.  Replace with
explicit call to fat_setattr().

This is equivalent, except that security_inode_setattr() is not called
before fat_setattr().  I think this is not needed, since the mode
change is just a side effect of the attribute change.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/fat/file.c
===================================================================
--- linux-2.6.orig/fs/fat/file.c	2008-05-06 11:04:29.000000000 +0200
+++ linux-2.6/fs/fat/file.c	2008-05-06 11:04:34.000000000 +0200
@@ -16,6 +16,7 @@
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
+#include <linux/fsnotify.h>
 
 int fat_generic_ioctl(struct inode *inode, struct file *filp,
 		      unsigned int cmd, unsigned long arg)
@@ -65,6 +66,7 @@ int fat_generic_ioctl(struct inode *inod
 
 		/* Equivalent to a chmod() */
 		ia.ia_valid = ATTR_MODE | ATTR_CTIME;
+		ia.ia_ctime = current_fs_time(inode->i_sb);
 		if (is_dir) {
 			ia.ia_mode = MSDOS_MKMODE(attr,
 				S_IRWXUGO & ~sbi->options.fs_dmask)
@@ -92,10 +94,11 @@ int fat_generic_ioctl(struct inode *inod
 		}
 
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
