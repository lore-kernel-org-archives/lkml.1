Return-Path: <linux-kernel-owner+w=401wt.eu-S964861AbXGLASd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861AbXGLASd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934558AbXGLART
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:17:19 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36121 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934857AbXGLARO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:14 -0400
Subject: [PATCH 01/23] rearrange may_open() to be r/o friendly
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:11 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001711.ED55C482@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


may_open() calls vfs_permission() before it does checks for
IS_RDONLY(inode).  It checks _again_ inside of vfs_permission().

The check inside of vfs_permission() is going away eventually.
With the mnt_want/drop_write() functions, all of the r/o
checks (except for this one) are consistently done before
calling permission().  Because of this, I'd like to use
permission() to hold a debugging check to make sure that
the mnt_want/drop_write() calls are actually being made.

So, to do this:
1. remove the IS_RDONLY() check from permission()
2. enforce that you must mnt_want_write() before
   even calling permission()
3. enable a debugging in permission()

We need to rearrange may_open().  Here's the patch.

---

 lxc-dave/fs/namei.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/namei.c~rearrange-permission-and-ro-checks-in-may_open fs/namei.c
--- lxc/fs/namei.c~rearrange-permission-and-ro-checks-in-may_open	2007-07-10 12:46:01.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-07-10 12:46:01.000000000 -0700
@@ -228,6 +228,10 @@ int permission(struct inode *inode, int 
 {
 	umode_t mode = inode->i_mode;
 	int retval, submask;
+	struct vfsmount *mnt = NULL;
+
+	if (nd)
+		mnt = nd->mnt;
 
 	if (mask & MAY_WRITE) {
 
@@ -252,7 +256,7 @@ int permission(struct inode *inode, int 
 	 * the fs is mounted with the "noexec" flag.
 	 */
 	if ((mask & MAY_EXEC) && S_ISREG(mode) && (!(mode & S_IXUGO) ||
-			(nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))))
+			(mnt && (mnt->mnt_flags & MNT_NOEXEC))))
 		return -EACCES;
 
 	/* Ordinary permission routines do not understand MAY_APPEND. */
@@ -1546,10 +1550,6 @@ int may_open(struct nameidata *nd, int a
 	if (S_ISDIR(inode->i_mode) && (flag & FMODE_WRITE))
 		return -EISDIR;
 
-	error = vfs_permission(nd, acc_mode);
-	if (error)
-		return error;
-
 	/*
 	 * FIFO's, sockets and device files are special: they don't
 	 * actually live on the filesystem itself, and as such you
@@ -1564,6 +1564,10 @@ int may_open(struct nameidata *nd, int a
 		flag &= ~O_TRUNC;
 	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
 		return -EROFS;
+
+	error = vfs_permission(nd, acc_mode);
+	if (error)
+		return error;
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
_
