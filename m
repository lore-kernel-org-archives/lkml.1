Return-Path: <linux-kernel-owner+w=401wt.eu-S938841AbXHIJ0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938841AbXHIJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935414AbXHIJZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:25:55 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:38896 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934226AbXHIJZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:25:54 -0400
Message-Id: <20070809092453.203431503@szeredi.hu>
References: <20070809092046.656183199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 11:20:47 +0200
From: miklos@szeredi.hu
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/9] unprivileged mounts: fix subtype handling
Content-Disposition: inline; filename=unprivileged-mounts-fix-subtype.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Subtype handling was done in do_kern_mount(), but "unprivileged
mounts: allow unprivileged mounts" patch made do_new_mount() use
vfs_kern_mount().  This broke the filesystem subtype handling.

Fix this by moving the subtype handling from do_kern_mount() into
do_new_mount().  All other callers are kernel-internal and do not need
subtype support.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2007-08-09 11:01:55.000000000 +0200
+++ linux/fs/namespace.c	2007-08-09 11:04:15.000000000 +0200
@@ -1198,6 +1198,29 @@ out:
 	return err;
 }
 
+static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
+{
+	int err;
+	const char *subtype = strchr(fstype, '.');
+	if (subtype) {
+		subtype++;
+		err = -EINVAL;
+		if (!subtype[0])
+			goto err;
+	} else
+		subtype = "";
+
+	mnt->mnt_sb->s_subtype = kstrdup(subtype, GFP_KERNEL);
+	err = -ENOMEM;
+	if (!mnt->mnt_sb->s_subtype)
+		goto err;
+	return mnt;
+
+ err:
+	mntput(mnt);
+	return ERR_PTR(err);
+}
+
 /*
  * create a new mount for userspace and request it to be added into the
  * namespace's tree
@@ -1227,6 +1250,9 @@ static int do_new_mount(struct nameidata
 	}
 
 	mnt = vfs_kern_mount(type, flags & ~MS_SETUSER, name, data);
+	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
+	    !mnt->mnt_sb->s_subtype)
+		mnt = fs_set_subtype(mnt, fstype);
 	put_filesystem(type);
 	if (IS_ERR(mnt)) {
 		if (flags & MS_SETUSER)
Index: linux/fs/super.c
===================================================================
--- linux.orig/fs/super.c	2007-08-09 11:01:55.000000000 +0200
+++ linux/fs/super.c	2007-08-09 11:04:15.000000000 +0200
@@ -906,29 +906,6 @@ out:
 
 EXPORT_SYMBOL_GPL(vfs_kern_mount);
 
-static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
-{
-	int err;
-	const char *subtype = strchr(fstype, '.');
-	if (subtype) {
-		subtype++;
-		err = -EINVAL;
-		if (!subtype[0])
-			goto err;
-	} else
-		subtype = "";
-
-	mnt->mnt_sb->s_subtype = kstrdup(subtype, GFP_KERNEL);
-	err = -ENOMEM;
-	if (!mnt->mnt_sb->s_subtype)
-		goto err;
-	return mnt;
-
- err:
-	mntput(mnt);
-	return ERR_PTR(err);
-}
-
 struct vfsmount *
 do_kern_mount(const char *fstype, int flags, const char *name, void *data)
 {
@@ -937,9 +914,6 @@ do_kern_mount(const char *fstype, int fl
 	if (!type)
 		return ERR_PTR(-ENODEV);
 	mnt = vfs_kern_mount(type, flags, name, data);
-	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
-	    !mnt->mnt_sb->s_subtype)
-		mnt = fs_set_subtype(mnt, fstype);
 	put_filesystem(type);
 	return mnt;
 }

--
