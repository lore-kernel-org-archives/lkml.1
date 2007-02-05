Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXBESeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXBESeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933029AbXBESY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:24:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:43235 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090AbXBESYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:24:21 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:23:23 -0800
Message-Id: <20070205182323.12164.27325.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 7/28] Pass struct vfsmount to the inode_mkdir LSM hook
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_mkdir LSM hook

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -1928,7 +1928,7 @@ int vfs_mkdir(struct inode *dir, struct 
 		return -EPERM;
 
 	mode &= (S_IRWXUGO|S_ISVTX);
-	error = security_inode_mkdir(dir, dentry, mode);
+	error = security_inode_mkdir(dir, dentry, mnt, mode);
 	if (error)
 		return error;
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
@@ -308,6 +308,7 @@ struct request_sock;
  *	associated with inode strcture @dir. 
  *	@dir containst the inode structure of parent of the directory to be created.
  *	@dentry contains the dentry structure of new directory.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the mode of new directory.
  *	Return 0 if permission is granted.
  * @inode_rmdir:
@@ -1213,7 +1214,8 @@ struct security_operations {
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct inode *dir,
 	                      struct dentry *dentry, const char *old_name);
-	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, int mode);
+	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
+			    struct vfsmount *mnt, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 	                    int mode, dev_t dev);
@@ -1650,11 +1652,12 @@ static inline int security_inode_symlink
 
 static inline int security_inode_mkdir (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode)
 {
 	if (unlikely (IS_PRIVATE (dir)))
 		return 0;
-	return security_ops->inode_mkdir (dir, dentry, mode);
+	return security_ops->inode_mkdir (dir, dentry, mnt, mode);
 }
 
 static inline int security_inode_rmdir (struct inode *dir,
@@ -2371,6 +2374,7 @@ static inline int security_inode_symlink
 
 static inline int security_inode_mkdir (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode)
 {
 	return 0;
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -288,7 +288,7 @@ static int dummy_inode_symlink (struct i
 }
 
 static int dummy_inode_mkdir (struct inode *inode, struct dentry *dentry,
-			      int mask)
+			      struct vfsmount *mnt, int mask)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2166,7 +2166,8 @@ static int selinux_inode_symlink(struct 
 	return may_create(dir, dentry, SECCLASS_LNK_FILE);
 }
 
-static int selinux_inode_mkdir(struct inode *dir, struct dentry *dentry, int mask)
+static int selinux_inode_mkdir(struct inode *dir, struct dentry *dentry,
+			       struct vfsmount *mnt, int mask)
 {
 	return may_create(dir, dentry, SECCLASS_DIR);
 }
