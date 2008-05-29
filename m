Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYE2N4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYE2N4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbYE2NvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46162 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbYE2NvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:51:10 -0400
Message-Id: <20080529135012.283939708@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:14 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 11/15] security: pass path to inode_listxattr
Content-Disposition: inline; filename=security_listxattr_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_listxattr() security operation and related functions pass
the path (vfsmount + dentry) instead of the dentry.  AppArmor will need
this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/xattr.c               |    2 +-
 include/linux/security.h |    8 ++++----
 security/dummy.c         |    2 +-
 security/security.c      |    6 +++---
 security/selinux/hooks.c |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-29 12:20:57.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-29 12:20:58.000000000 +0200
@@ -189,7 +189,7 @@ path_listxattr(struct path *path, char *
 	struct dentry *d = path->dentry;
 	ssize_t error;
 
-	error = security_inode_listxattr(d);
+	error = security_inode_listxattr(path);
 	if (error)
 		return error;
 	error = -EOPNOTSUPP;
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:57.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:58.000000000 +0200
@@ -439,7 +439,7 @@ static inline void security_free_mnt_opt
  *	Return 0 if permission is granted.
  * @inode_listxattr:
  *	Check permission before obtaining the list of extended attribute
- *	names for @dentry.
+ *	names for @path.
  *	Return 0 if permission is granted.
  * @inode_removexattr:
  *	Check permission before removing the extended attribute
@@ -1376,7 +1376,7 @@ struct security_operations {
 	void (*inode_post_setxattr) (struct dentry *dentry, const char *name,
 				     const void *value, size_t size, int flags);
 	int (*inode_getxattr) (struct path *path, const char *name);
-	int (*inode_listxattr) (struct dentry *dentry);
+	int (*inode_listxattr) (struct path *path);
 	int (*inode_removexattr) (struct dentry *dentry, const char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
@@ -1648,7 +1648,7 @@ int security_inode_setxattr(struct dentr
 void security_inode_post_setxattr(struct dentry *dentry, const char *name,
 				  const void *value, size_t size, int flags);
 int security_inode_getxattr(struct path *path, const char *name);
-int security_inode_listxattr(struct dentry *dentry);
+int security_inode_listxattr(struct path *path);
 int security_inode_removexattr(struct dentry *dentry, const char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
@@ -2063,7 +2063,7 @@ static inline int security_inode_getxatt
 	return 0;
 }
 
-static inline int security_inode_listxattr(struct dentry *dentry)
+static inline int security_inode_listxattr(struct path *path)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:57.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:58.000000000 +0200
@@ -384,7 +384,7 @@ static int dummy_inode_getxattr(struct p
 	return 0;
 }
 
-static int dummy_inode_listxattr (struct dentry *dentry)
+static int dummy_inode_listxattr(struct path *path)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:57.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:58.000000000 +0200
@@ -516,11 +516,11 @@ int security_inode_getxattr(struct path 
 	return security_ops->inode_getxattr(path, name);
 }
 
-int security_inode_listxattr(struct dentry *dentry)
+int security_inode_listxattr(struct path *path)
 {
-	if (unlikely(IS_PRIVATE(dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->inode_listxattr(dentry);
+	return security_ops->inode_listxattr(path);
 }
 
 int security_inode_removexattr(struct dentry *dentry, const char *name)
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:57.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:58.000000000 +0200
@@ -2702,9 +2702,9 @@ static int selinux_inode_getxattr(struct
 	return dentry_has_perm(current, NULL, path->dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_listxattr(struct dentry *dentry)
+static int selinux_inode_listxattr(struct path *path)
 {
-	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
+	return dentry_has_perm(current, NULL, path->dentry, FILE__GETATTR);
 }
 
 static int selinux_inode_removexattr(struct dentry *dentry, const char *name)

--
