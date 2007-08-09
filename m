Return-Path: <linux-kernel-owner+w=401wt.eu-S1764855AbXHIJ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764855AbXHIJ2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765574AbXHIJ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:26:17 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:45682 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765042AbXHIJ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:26:14 -0400
Message-Id: <20070809092506.884721608@szeredi.hu>
References: <20070809092046.656183199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 11:20:51 +0200
From: miklos@szeredi.hu
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 5/9] fuse: fix setting i_mode bits
Content-Disposition: inline; filename=fuse_mode_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The patch titled "fuse: fix permission checking on sticky directories"
removed all but the S_IFMT bits from i_mode.

However some of these are unfortunately used by the VFS, such as the
execute, suid and sgid bits.

So only remove the sticky bit, which is used for checking deletion
from a directory.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-08-09 11:01:55.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-08-09 11:04:26.000000000 +0200
@@ -124,14 +124,7 @@ void fuse_change_attributes(struct inode
 	loff_t oldsize;
 
 	inode->i_ino     = attr->ino;
-	fi->orig_i_mode  = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
-	/*
-	 * Don't set the mode bits in i_mode, unless we want the VFS
-	 * to check permissions.  This prevents failures due to the
-	 * sticky bit check in may_delete().
-	 */
-	if (fc->flags & FUSE_DEFAULT_PERMISSIONS)
-		inode->i_mode = fi->orig_i_mode;
+	inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	inode->i_nlink   = attr->nlink;
 	inode->i_uid     = attr->uid;
 	inode->i_gid     = attr->gid;
@@ -143,6 +136,15 @@ void fuse_change_attributes(struct inode
 	inode->i_ctime.tv_sec   = attr->ctime;
 	inode->i_ctime.tv_nsec  = attr->ctimensec;
 
+	/*
+	 * Don't set the sticky bit in i_mode, unless we want the VFS
+	 * to check permissions.  This prevents failures due to the
+	 * check in may_delete().
+	 */
+	fi->orig_i_mode = inode->i_mode;
+	if (!(fc->flags & FUSE_DEFAULT_PERMISSIONS))
+		inode->i_mode &= ~S_ISVTX;
+
 	spin_lock(&fc->lock);
 	oldsize = inode->i_size;
 	i_size_write(inode, attr->size);

--
