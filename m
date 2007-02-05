Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbXBESba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbXBESba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbXBES0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:26:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167AbXBESZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:25:43 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:24:45 -0800
Message-Id: <20070205182445.12164.94899.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 16/28] Pass struct vfsmount to the inode_rmdir LSM hook
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_rmdir LSM hook

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2023,7 +2023,7 @@ int vfs_rmdir(struct inode *dir, struct 
 	if (d_mountpoint(dentry))
 		error = -EBUSY;
 	else {
-		error = security_inode_rmdir(dir, dentry);
+		error = security_inode_rmdir(dir, dentry, mnt);
 		if (!error) {
 			error = dir->i_op->rmdir(dir, dentry);
 			if (!error)
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
@@ -318,6 +318,7 @@ struct request_sock;
  *	Check the permission to remove a directory.
  *	@dir contains the inode structure of parent of the directory to be removed.
  *	@dentry contains the dentry structure of directory to be removed.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_mknod:
  *	Check permissions when creating a special file (or a socket or a fifo
@@ -1222,7 +1223,8 @@ struct security_operations {
 			      struct vfsmount *mnt, const char *old_name);
 	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
 			    struct vfsmount *mnt, int mode);
-	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
+	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry,
+			    struct vfsmount *mnt);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
@@ -1671,11 +1673,12 @@ static inline int security_inode_mkdir (
 }
 
 static inline int security_inode_rmdir (struct inode *dir,
-					struct dentry *dentry)
+					struct dentry *dentry,
+					struct vfsmount *mnt)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_rmdir (dir, dentry);
+	return security_ops->inode_rmdir (dir, dentry, mnt);
 }
 
 static inline int security_inode_mknod (struct inode *dir,
@@ -2396,7 +2399,8 @@ static inline int security_inode_mkdir (
 }
 
 static inline int security_inode_rmdir (struct inode *dir,
-					struct dentry *dentry)
+					struct dentry *dentry,
+					struct vfsmount *mnt)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -295,7 +295,8 @@ static int dummy_inode_mkdir (struct ino
 	return 0;
 }
 
-static int dummy_inode_rmdir (struct inode *inode, struct dentry *dentry)
+static int dummy_inode_rmdir (struct inode *inode, struct dentry *dentry,
+			      struct vfsmount *mnt)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2178,7 +2178,8 @@ static int selinux_inode_mkdir(struct in
 	return may_create(dir, dentry, SECCLASS_DIR);
 }
 
-static int selinux_inode_rmdir(struct inode *dir, struct dentry *dentry)
+static int selinux_inode_rmdir(struct inode *dir, struct dentry *dentry,
+			       struct vfsmount *mnt)
 {
 	return may_link(dir, dentry, MAY_RMDIR);
 }
