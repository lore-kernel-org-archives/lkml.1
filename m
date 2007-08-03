Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbXHCUEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbXHCUEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762579AbXHCUDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:03:55 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:57116 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763744AbXHCUDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:03:54 -0400
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jengelh@computergmbh.de
Subject: [patch v2] fuse: fix permission checking on sticky directories
Message-Id: <E1IH3MV-0006hx-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 03 Aug 2007 22:03:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The VFS checks sticky bits on the parent directory even if the
filesystem defines it's own ->permission().  In some situations
(sshfs, mountlo, etc) the user does have permission to delete a file
even if the attribute based checking would not allow it.

So work around this by storing the permission bits separately and
returning them in stat(), but cutting the permission bits off from
inode->i_mode.

This is slightly hackish, but it's probably not worth it to add new
infrastructure in VFS and a slight performance penalty for all
filesystems, just for the sake of fuse.

[Jan Engelhardt] cosmetic fixes

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-08-03 21:57:53.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-08-03 21:57:58.000000000 +0200
@@ -1054,8 +1054,10 @@ static int fuse_getattr(struct vfsmount 
 	if (fi->i_time < get_jiffies_64())
 		err = fuse_do_getattr(inode);
 
-	if (!err)
+	if (!err) {
 		generic_fillattr(inode, stat);
+		stat->mode = fi->orig_i_mode;
+	}
 
 	return err;
 }
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-08-03 21:57:53.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-08-03 21:58:23.000000000 +0200
@@ -63,6 +63,10 @@ struct fuse_inode {
 
 	/** Time in jiffies until the file attributes are valid */
 	u64 i_time;
+
+	/** The sticky bit in inode->i_mode may have been removed, so
+	    preserve the original mode */
+	mode_t orig_i_mode;
 };
 
 /** FUSE specific file data */
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-08-03 21:57:53.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-08-03 21:58:23.000000000 +0200
@@ -120,10 +120,18 @@ static void fuse_truncate(struct address
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	loff_t oldsize;
 
 	inode->i_ino     = attr->ino;
-	inode->i_mode    = (inode->i_mode & S_IFMT) + (attr->mode & 07777);
+	fi->orig_i_mode  = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
+	/*
+	 * Don't set the mode bits in i_mode, unless we want the VFS
+	 * to check permissions.  This prevents failures due to the
+	 * sticky bit check in may_delete().
+	 */
+	if (fc->flags & FUSE_DEFAULT_PERMISSIONS)
+		inode->i_mode = fi->orig_i_mode;
 	inode->i_nlink   = attr->nlink;
 	inode->i_uid     = attr->uid;
 	inode->i_gid     = attr->gid;
