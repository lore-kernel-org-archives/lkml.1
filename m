Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYCQUE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYCQUE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbYCQUCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:02:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51460 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbYCQUCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:02:33 -0400
Message-Id: <20080317200150.124782424@szeredi.hu>
References: <20080317200053.447640802@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 17 Mar 2008 21:00:58 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 05/11] unprivileged mounts: allow unprivileged bind mounts
Content-Disposition: inline; filename=unprivileged-mounts-allow-unprivileged-bind-mounts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Allow bind mounts to unprivileged users if the following conditions are met:

  - mountpoint is not a symlink
  - parent mount is owned by the user
  - the number of user mounts is below the maximum

Unprivileged mounts imply MS_SETUSER, and will also have the "nosuid" and
"nodev" mount flags set.

In particular, if mounting process doesn't have CAP_SETUID capability,
then the "nosuid" flag will be added, and if it doesn't have CAP_MKNOD
capability, then the "nodev" flag will be added.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/namespace.c |   44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-03-17 20:55:47.000000000 +0100
+++ linux/fs/namespace.c	2008-03-17 20:55:48.000000000 +0100
@@ -555,6 +555,11 @@ static void __set_mnt_user(struct vfsmou
 	WARN_ON(mnt->mnt_flags & MNT_USER);
 	mnt->mnt_uid = current->fsuid;
 	mnt->mnt_flags |= MNT_USER;
+
+	if (!capable(CAP_SETUID))
+		mnt->mnt_flags |= MNT_NOSUID;
+	if (!capable(CAP_MKNOD))
+		mnt->mnt_flags |= MNT_NODEV;
 }
 
 static void set_mnt_user(struct vfsmount *mnt)
@@ -1201,22 +1206,26 @@ asmlinkage long sys_oldumount(char __use
 
 #endif
 
-static int mount_is_safe(struct nameidata *nd)
+/*
+ * Conditions for unprivileged mounts are:
+ * - mountpoint is not a symlink
+ * - mountpoint is in a mount owned by the user
+ */
+static bool permit_mount(struct nameidata *nd, int *flags)
 {
+	struct inode *inode = nd->path.dentry->d_inode;
+
 	if (capable(CAP_SYS_ADMIN))
-		return 0;
-	return -EPERM;
-#ifdef notyet
-	if (S_ISLNK(nd->path.dentry->d_inode->i_mode))
-		return -EPERM;
-	if (nd->path.dentry->d_inode->i_mode & S_ISVTX) {
-		if (current->uid != nd->path.dentry->d_inode->i_uid)
-			return -EPERM;
-	}
-	if (vfs_permission(nd, MAY_WRITE))
-		return -EPERM;
-	return 0;
-#endif
+		return true;
+
+	if (S_ISLNK(inode->i_mode))
+		return false;
+
+	if (!is_mount_owner(nd->path.mnt, current->fsuid))
+		return false;
+
+	*flags |= MS_SETUSER;
+	return true;
 }
 
 static int lives_below_in_same_fs(struct dentry *d, struct dentry *dentry)
@@ -1463,9 +1472,10 @@ static noinline int do_loopback(struct n
 	int clone_fl;
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
-	int err = mount_is_safe(nd);
-	if (err)
-		return err;
+	int err;
+
+	if (!permit_mount(nd, &flags))
+		return -EPERM;
 	if (!old_name || !*old_name)
 		return -EINVAL;
 	err = path_lookup(old_name, LOOKUP_FOLLOW, &old_nd);

--
