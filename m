Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbXIQS2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbXIQS2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXIQS1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43983 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958AbXIQS1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:23 -0400
Subject: [PATCH 02/24] rearrange may_open() to be r/o friendly
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:20 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182720.A41D6484@kernel>
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

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/namei.c~rearrange-permission-and-ro-checks-in-may_open fs/namei.c
--- lxc/fs/namei.c~rearrange-permission-and-ro-checks-in-may_open	2007-09-17 09:43:56.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-17 09:43:56.000000000 -0700
@@ -228,6 +228,10 @@ int generic_permission(struct inode *ino
 int permission(struct inode *inode, int mask, struct nameidata *nd)
 {
 	int retval, submask;
+	struct vfsmount *mnt = NULL;
+
+	if (nd)
+		mnt = nd->mnt;
 
 	if (mask & MAY_WRITE) {
 		umode_t mode = inode->i_mode;
@@ -251,7 +255,7 @@ int permission(struct inode *inode, int 
 		 * MAY_EXEC on regular files is denied if the fs is mounted
 		 * with the "noexec" flag.
 		 */
-		if (nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))
+		if (mnt && (mnt->mnt_flags & MNT_NOEXEC))
 			return -EACCES;
 	}
 
@@ -1604,10 +1608,6 @@ int may_open(struct nameidata *nd, int a
 	if (S_ISDIR(inode->i_mode) && (flag & FMODE_WRITE))
 		return -EISDIR;
 
-	error = vfs_permission(nd, acc_mode);
-	if (error)
-		return error;
-
 	/*
 	 * FIFO's, sockets and device files are special: they don't
 	 * actually live on the filesystem itself, and as such you
@@ -1622,6 +1622,10 @@ int may_open(struct nameidata *nd, int a
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
