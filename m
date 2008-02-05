Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbYBEVit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbYBEVit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761602AbYBEVhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:37:46 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38767 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761545AbYBEVho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:37:44 -0500
Message-Id: <20080205213702.151143676@szeredi.hu>
References: <20080205213616.343721693@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 05 Feb 2008 22:36:21 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 05/10] unprivileged mounts: allow unprivileged bind mounts
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

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-02-04 23:47:58.000000000 +0100
+++ linux/fs/namespace.c	2008-02-04 23:48:00.000000000 +0100
@@ -545,6 +545,11 @@ static void __set_mnt_user(struct vfsmou
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
@@ -1160,22 +1165,26 @@ asmlinkage long sys_oldumount(char __use
 
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
@@ -1419,9 +1428,10 @@ static int do_loopback(struct nameidata 
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
