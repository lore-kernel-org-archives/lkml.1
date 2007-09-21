Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbXIUMeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbXIUMeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbXIUMd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:33:58 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:41922 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbXIUMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:33:57 -0400
Message-Id: <20070921123336.095183254@szeredi.hu>
References: <20070921122343.307289079@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 21 Sep 2007 14:23:48 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [patch 5/5] VFS: allow filesystem to override mknod capability checks
Content-Disposition: inline; filename=vfs_mknod_nocheck.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new filesystem flag, that results in the VFS not checking if the
current process has enough privileges to do an mknod().

This is needed on filesystems, where an unprivileged user may be able
to create a device node, without causing security problems.

One such example is "mountlo" a loopback mount utility implemented
with fuse and UML, which runs as an unprivileged userspace process.
In this case the user does in fact have the right to create device
nodes within the filesystem image, as long as the user has write
access to the image.  Since the filesystem is mounted with "nodev",
adding device nodes is not a security concern.

This feature is basically "fuse-only", so it does not make sense to
change the semantics of ->mknod().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namei.c
===================================================================
--- linux.orig/fs/namei.c	2007-09-21 13:45:14.000000000 +0200
+++ linux/fs/namei.c	2007-09-21 13:45:16.000000000 +0200
@@ -1922,7 +1922,8 @@ int vfs_mknod(struct inode *dir, struct 
 	if (error)
 		return error;
 
-	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
+	if (!(dir->i_sb->s_type->fs_flags & FS_MKNOD_CHECKS_PERM) &&
+	    (S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
 		return -EPERM;
 
 	if (!dir->i_op || !dir->i_op->mknod)
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-09-21 13:45:14.000000000 +0200
+++ linux/include/linux/fs.h	2007-09-21 13:45:16.000000000 +0200
@@ -97,6 +97,7 @@ extern int dir_notify_enable;
 #define FS_BINARY_MOUNTDATA 2
 #define FS_HAS_SUBTYPE 4
 #define FS_SAFE 8		/* Safe to mount by unprivileged users */
+#define FS_MKNOD_CHECKS_PERM 16	/* FS checks if device creation is allowed */
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.

--
