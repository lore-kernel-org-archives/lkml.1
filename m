Return-Path: <linux-kernel-owner+w=401wt.eu-S933308AbXBEScv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbXBEScv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbXBESZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:25:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:43291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933033AbXBESZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:25:09 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:24:10 -0800
Message-Id: <20070205182410.12164.78472.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 12/28] Pass struct vfsmount to the inode_readlink LSM hook
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_readlink LSM hook

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/stat.c
===================================================================
--- linux-2.6.orig/fs/stat.c
+++ linux-2.6/fs/stat.c
@@ -307,7 +307,7 @@ asmlinkage long sys_readlinkat(int dfd, 
 
 		error = -EINVAL;
 		if (inode->i_op && inode->i_op->readlink) {
-			error = security_inode_readlink(nd.dentry);
+			error = security_inode_readlink(nd.dentry, nd.mnt);
 			if (!error) {
 				touch_atime(nd.mnt, nd.dentry);
 				error = inode->i_op->readlink(nd.dentry, buf, bufsiz);
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
@@ -338,6 +338,7 @@ struct request_sock;
  * @inode_readlink:
  *	Check the permission to read the symbolic link.
  *	@dentry contains the dentry structure for the file link.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_follow_link:
  *	Check permission to follow a symbolic link when looking up a pathname.
@@ -1223,7 +1224,7 @@ struct security_operations {
 			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
 	                     struct inode *new_dir, struct dentry *new_dentry);
-	int (*inode_readlink) (struct dentry *dentry);
+	int (*inode_readlink) (struct dentry *dentry, struct vfsmount *mnt);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask, struct nameidata *nd);
 	int (*inode_setattr) (struct dentry *dentry, struct vfsmount *mnt,
@@ -1693,11 +1694,12 @@ static inline int security_inode_rename 
 					   new_dir, new_dentry);
 }
 
-static inline int security_inode_readlink (struct dentry *dentry)
+static inline int security_inode_readlink (struct dentry *dentry,
+					   struct vfsmount *mnt)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_readlink (dentry);
+	return security_ops->inode_readlink (dentry, mnt);
 }
 
 static inline int security_inode_follow_link (struct dentry *dentry,
@@ -2407,7 +2409,8 @@ static inline int security_inode_rename 
 	return 0;
 }
 
-static inline int security_inode_readlink (struct dentry *dentry)
+static inline int security_inode_readlink (struct dentry *dentry,
+					   struct vfsmount *mnt)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -312,7 +312,7 @@ static int dummy_inode_rename (struct in
 	return 0;
 }
 
-static int dummy_inode_readlink (struct dentry *dentry)
+static int dummy_inode_readlink (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2196,7 +2196,7 @@ static int selinux_inode_rename(struct i
 	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
 }
 
-static int selinux_inode_readlink(struct dentry *dentry)
+static int selinux_inode_readlink(struct dentry *dentry, struct vfsmount *mnt)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__READ);
 }
