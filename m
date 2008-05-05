Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbYEEJ6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbYEEJ6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758490AbYEEJzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:55:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38329 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbYEEJz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:55:28 -0400
Message-Id: <20080505095518.844178123@szeredi.hu>
References: <20080505095440.820370974@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 05 May 2008 11:54:49 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [patch 08/15] fat: dont call notify_change
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
--- linux-2.6.orig/fs/fat/file.c	2008-05-05 11:29:20.000000000 +0200
+++ linux-2.6/fs/fat/file.c	2008-05-05 11:29:26.000000000 +0200
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
