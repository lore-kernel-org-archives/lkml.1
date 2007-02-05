Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbXBES2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbXBES2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933250AbXBES1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:27:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:47890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214AbXBES1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:27:12 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:26:14 -0800
Message-Id: <20070205182614.12164.66183.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 26/28] Pass struct vfsmount to the inode_listxattr LSM hook
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_listxattr LSM hook

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c
+++ linux-2.6/fs/xattr.c
@@ -150,7 +150,7 @@ vfs_listxattr(struct dentry *dentry, str
 	struct inode *inode = dentry->d_inode;
 	ssize_t error;
 
-	error = security_inode_listxattr(dentry);
+	error = security_inode_listxattr(dentry, mnt);
 	if (error)
 		return error;
 	error = -EOPNOTSUPP;
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
@@ -395,7 +395,7 @@ struct request_sock;
  * 	Return 0 if permission is granted.
  * @inode_listxattr:
  * 	Check permission before obtaining the list of extended attribute 
- * 	names for @dentry.
+ * 	names for @dentry and @mnt.
  * 	Return 0 if permission is granted.
  * @inode_removexattr:
  * 	Check permission before removing the extended attribute
@@ -1250,7 +1250,7 @@ struct security_operations {
 				     size_t size, int flags);
 	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
 			       char *name);
-	int (*inode_listxattr) (struct dentry *dentry);
+	int (*inode_listxattr) (struct dentry *dentry, struct vfsmount *mnt);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	const char *(*inode_xattr_getsuffix) (void);
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
@@ -1791,11 +1791,12 @@ static inline int security_inode_getxatt
 	return security_ops->inode_getxattr (dentry, mnt, name);
 }
 
-static inline int security_inode_listxattr (struct dentry *dentry)
+static inline int security_inode_listxattr (struct dentry *dentry,
+					    struct vfsmount *mnt)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_listxattr (dentry);
+	return security_ops->inode_listxattr (dentry, mnt);
 }
 
 static inline int security_inode_removexattr (struct dentry *dentry, char *name)
@@ -2495,7 +2496,8 @@ static inline int security_inode_getxatt
 	return 0;
 }
 
-static inline int security_inode_listxattr (struct dentry *dentry)
+static inline int security_inode_listxattr (struct dentry *dentry,
+					    struct vfsmount *mnt)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -374,7 +374,7 @@ static int dummy_inode_getxattr (struct 
 	return 0;
 }
 
-static int dummy_inode_listxattr (struct dentry *dentry)
+static int dummy_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2358,7 +2358,7 @@ static int selinux_inode_getxattr (struc
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_listxattr (struct dentry *dentry)
+static int selinux_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
