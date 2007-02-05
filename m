Return-Path: <linux-kernel-owner+w=401wt.eu-S933293AbXBESaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbXBESaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbXBES0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:26:25 -0500
Received: from mail.suse.de ([195.135.220.2]:43441 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933186AbXBES0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:26:21 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:25:19 -0800
Message-Id: <20070205182519.12164.15684.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 20/28] Pass struct vfsmount to the inode_rename LSM hook
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_rename LSM hook

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2398,7 +2398,8 @@ static int vfs_rename_dir(struct inode *
 			return error;
 	}
 
-	error = security_inode_rename(old_dir, old_dentry, new_dir, new_dentry);
+	error = security_inode_rename(old_dir, old_dentry, old_mnt,
+				      new_dir, new_dentry, new_mnt);
 	if (error)
 		return error;
 
@@ -2432,7 +2433,8 @@ static int vfs_rename_other(struct inode
 	struct inode *target;
 	int error;
 
-	error = security_inode_rename(old_dir, old_dentry, new_dir, new_dentry);
+	error = security_inode_rename(old_dir, old_dentry, old_mnt,
+				      new_dir, new_dentry, new_mnt);
 	if (error)
 		return error;
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
@@ -336,8 +336,10 @@ struct request_sock;
  *	Check for permission to rename a file or directory.
  *	@old_dir contains the inode structure for parent of the old link.
  *	@old_dentry contains the dentry structure of the old link.
+ *	@old_mnt is the vfsmount corresponding to @old_dentry (may be NULL).
  *	@new_dir contains the inode structure for parent of the new link.
  *	@new_dentry contains the dentry structure of the new link.
+ *	@new_mnt is the vfsmount corresponding to @new_dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_readlink:
  *	Check the permission to read the symbolic link.
@@ -1230,7 +1232,9 @@ struct security_operations {
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
-	                     struct inode *new_dir, struct dentry *new_dentry);
+			     struct vfsmount *old_mnt,
+	                     struct inode *new_dir, struct dentry *new_dentry,
+			     struct vfsmount *new_mnt);
 	int (*inode_readlink) (struct dentry *dentry, struct vfsmount *mnt);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask, struct nameidata *nd);
@@ -1696,14 +1700,16 @@ static inline int security_inode_mknod (
 
 static inline int security_inode_rename (struct inode *old_dir,
 					 struct dentry *old_dentry,
+					 struct vfsmount *old_mnt,
 					 struct inode *new_dir,
-					 struct dentry *new_dentry)
+					 struct dentry *new_dentry,
+					 struct vfsmount *new_mnt)
 {
         if (unlikely (IS_PRIVATE (old_dentry->d_inode) ||
             (new_dentry->d_inode && IS_PRIVATE (new_dentry->d_inode))))
 		return 0;
-	return security_ops->inode_rename (old_dir, old_dentry,
-					   new_dir, new_dentry);
+	return security_ops->inode_rename (old_dir, old_dentry, old_mnt,
+					   new_dir, new_dentry, new_mnt);
 }
 
 static inline int security_inode_readlink (struct dentry *dentry,
@@ -2419,8 +2425,10 @@ static inline int security_inode_mknod (
 
 static inline int security_inode_rename (struct inode *old_dir,
 					 struct dentry *old_dentry,
+					 struct vfsmount *old_mnt,
 					 struct inode *new_dir,
-					 struct dentry *new_dentry)
+					 struct dentry *new_dentry,
+					 struct vfsmount *new_mnt)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -310,8 +310,10 @@ static int dummy_inode_mknod (struct ino
 
 static int dummy_inode_rename (struct inode *old_inode,
 			       struct dentry *old_dentry,
+			       struct vfsmount *old_mnt,
 			       struct inode *new_inode,
-			       struct dentry *new_dentry)
+			       struct dentry *new_dentry,
+			       struct vfsmount *new_mnt)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2197,8 +2197,12 @@ static int selinux_inode_mknod(struct in
 	return may_create(dir, dentry, inode_mode_to_security_class(mode));
 }
 
-static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
-                                struct inode *new_inode, struct dentry *new_dentry)
+static int selinux_inode_rename(struct inode *old_inode,
+				struct dentry *old_dentry,
+				struct vfsmount *old_mnt,
+                                struct inode *new_inode,
+				struct dentry *new_dentry,
+				struct vfsmount *new_mnt)
 {
 	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
 }
