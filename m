Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbXBESYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbXBESYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXBESYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:24:44 -0500
Received: from mx1.suse.de ([195.135.220.2]:43257 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbXBESYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:24:39 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:23:40 -0800
Message-Id: <20070205182340.12164.75619.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 9/28] Pass struct vfsmount to the inode_mknod LSM hook
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_mknod LSM hook

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -1851,7 +1851,7 @@ int vfs_mknod(struct inode *dir, struct 
 	if (!dir->i_op || !dir->i_op->mknod)
 		return -EPERM;
 
-	error = security_inode_mknod(dir, dentry, mode, dev);
+	error = security_inode_mknod(dir, dentry, mnt, mode, dev);
 	if (error)
 		return error;
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
@@ -323,6 +323,7 @@ struct request_sock;
  *	and not this hook.
  *	@dir contains the inode structure of parent of the new file.
  *	@dentry contains the dentry structure of the new file.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the mode of the new file.
  *	@dev contains the the device number.
  *	Return 0 if permission is granted.
@@ -1218,7 +1219,7 @@ struct security_operations {
 			    struct vfsmount *mnt, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
-	                    int mode, dev_t dev);
+			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
 	                     struct inode *new_dir, struct dentry *new_dentry);
 	int (*inode_readlink) (struct dentry *dentry);
@@ -1670,11 +1671,12 @@ static inline int security_inode_rmdir (
 
 static inline int security_inode_mknod (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode, dev_t dev)
 {
 	if (unlikely (IS_PRIVATE (dir)))
 		return 0;
-	return security_ops->inode_mknod (dir, dentry, mode, dev);
+	return security_ops->inode_mknod (dir, dentry, mnt, mode, dev);
 }
 
 static inline int security_inode_rename (struct inode *old_dir,
@@ -2388,6 +2390,7 @@ static inline int security_inode_rmdir (
 
 static inline int security_inode_mknod (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode, dev_t dev)
 {
 	return 0;
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -299,7 +299,7 @@ static int dummy_inode_rmdir (struct ino
 }
 
 static int dummy_inode_mknod (struct inode *inode, struct dentry *dentry,
-			      int mode, dev_t dev)
+			      struct vfsmount *mnt, int mode, dev_t dev)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2177,11 +2177,12 @@ static int selinux_inode_rmdir(struct in
 	return may_link(dir, dentry, MAY_RMDIR);
 }
 
-static int selinux_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+static int selinux_inode_mknod(struct inode *dir, struct dentry *dentry,
+			       struct vfsmount *mnt, int mode, dev_t dev)
 {
 	int rc;
 
-	rc = secondary_ops->inode_mknod(dir, dentry, mode, dev);
+	rc = secondary_ops->inode_mknod(dir, dentry, mnt, mode, dev);
 	if (rc)
 		return rc;
 
