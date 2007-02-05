Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXBES3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXBES3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933270AbXBES3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:29:07 -0500
Received: from ns.suse.de ([195.135.220.2]:43493 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204AbXBES0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:26:55 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:25:57 -0800
Message-Id: <20070205182557.12164.96680.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 24/28] Pass struct vfsmount to the inode_getxattr LSM hook
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_getxattr LSM hook

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c
+++ linux-2.6/fs/xattr.c
@@ -117,7 +117,7 @@ vfs_getxattr(struct dentry *dentry, stru
 	if (error)
 		return error;
 
-	error = security_inode_getxattr(dentry, name);
+	error = security_inode_getxattr(dentry, mnt, name);
 	if (error)
 		return error;
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
@@ -391,7 +391,7 @@ struct request_sock;
  * 	@value identified by @name for @dentry and @mnt.
  * @inode_getxattr:
  * 	Check permission before obtaining the extended attributes
- * 	identified by @name for @dentry.
+ * 	identified by @name for @dentry and @mnt.
  * 	Return 0 if permission is granted.
  * @inode_listxattr:
  * 	Check permission before obtaining the list of extended attribute 
@@ -1248,7 +1248,8 @@ struct security_operations {
 				     struct vfsmount *mnt,
 				     char *name, void *value,
 				     size_t size, int flags);
-	int (*inode_getxattr) (struct dentry *dentry, char *name);
+	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
+			       char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	const char *(*inode_xattr_getsuffix) (void);
@@ -1782,11 +1783,12 @@ static inline void security_inode_post_s
 	security_ops->inode_post_setxattr (dentry, mnt, name, value, size, flags);
 }
 
-static inline int security_inode_getxattr (struct dentry *dentry, char *name)
+static inline int security_inode_getxattr (struct dentry *dentry,
+					    struct vfsmount *mnt, char *name)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getxattr (dentry, name);
+	return security_ops->inode_getxattr (dentry, mnt, name);
 }
 
 static inline int security_inode_listxattr (struct dentry *dentry)
@@ -2487,7 +2489,8 @@ static inline void security_inode_post_s
 						 int flags)
 { }
 
-static inline int security_inode_getxattr (struct dentry *dentry, char *name)
+static inline int security_inode_getxattr (struct dentry *dentry,
+					    struct vfsmount *mnt, char *name)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -368,7 +368,8 @@ static void dummy_inode_post_setxattr (s
 {
 }
 
-static int dummy_inode_getxattr (struct dentry *dentry, char *name)
+static int dummy_inode_getxattr (struct dentry *dentry,
+			          struct vfsmount *mnt, char *name)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2352,7 +2352,8 @@ static void selinux_inode_post_setxattr(
 	return;
 }
 
-static int selinux_inode_getxattr (struct dentry *dentry, char *name)
+static int selinux_inode_getxattr (struct dentry *dentry, struct vfsmount *mnt,
+				   char *name)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
