Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbYE2NxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbYE2NxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbYE2NvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:07 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46142 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbYE2NvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:51:01 -0400
Message-Id: <20080529135010.263227933@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:13 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 10/15] security: pass path to inode_getxattr
Content-Disposition: inline; filename=security_getxattr_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_getxattr() security operation and related functions pass
the path (vfsmount + dentry) instead of the dentry.  AppArmor will need
this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/xattr.c                 |    2 +-
 include/linux/security.h   |    9 ++++-----
 security/dummy.c           |    2 +-
 security/security.c        |    6 +++---
 security/selinux/hooks.c   |    4 ++--
 security/smack/smack_lsm.c |    6 +++---
 6 files changed, 14 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:56.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:57.000000000 +0200
@@ -435,7 +435,7 @@ static inline void security_free_mnt_opt
  *	@value identified by @name for @dentry.
  * @inode_getxattr:
  *	Check permission before obtaining the extended attributes
- *	identified by @name for @dentry.
+ *	identified by @name for @path.
  *	Return 0 if permission is granted.
  * @inode_listxattr:
  *	Check permission before obtaining the list of extended attribute
@@ -1375,7 +1375,7 @@ struct security_operations {
 			       const void *value, size_t size, int flags);
 	void (*inode_post_setxattr) (struct dentry *dentry, const char *name,
 				     const void *value, size_t size, int flags);
-	int (*inode_getxattr) (struct dentry *dentry, const char *name);
+	int (*inode_getxattr) (struct path *path, const char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
 	int (*inode_removexattr) (struct dentry *dentry, const char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
@@ -1647,7 +1647,7 @@ int security_inode_setxattr(struct dentr
 			    const void *value, size_t size, int flags);
 void security_inode_post_setxattr(struct dentry *dentry, const char *name,
 				  const void *value, size_t size, int flags);
-int security_inode_getxattr(struct dentry *dentry, const char *name);
+int security_inode_getxattr(struct path *path, const char *name);
 int security_inode_listxattr(struct dentry *dentry);
 int security_inode_removexattr(struct dentry *dentry, const char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
@@ -2058,8 +2058,7 @@ static inline void security_inode_post_s
 		const char *name, const void *value, size_t size, int flags)
 { }
 
-static inline int security_inode_getxattr(struct dentry *dentry,
-			const char *name)
+static inline int security_inode_getxattr(struct path *path, const char *name)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:56.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:57.000000000 +0200
@@ -379,7 +379,7 @@ static void dummy_inode_post_setxattr (s
 {
 }
 
-static int dummy_inode_getxattr (struct dentry *dentry, const char *name)
+static int dummy_inode_getxattr(struct path *path, const char *name)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:56.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:57.000000000 +0200
@@ -509,11 +509,11 @@ void security_inode_post_setxattr(struct
 	security_ops->inode_post_setxattr(dentry, name, value, size, flags);
 }
 
-int security_inode_getxattr(struct dentry *dentry, const char *name)
+int security_inode_getxattr(struct path *path, const char *name)
 {
-	if (unlikely(IS_PRIVATE(dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getxattr(dentry, name);
+	return security_ops->inode_getxattr(path, name);
 }
 
 int security_inode_listxattr(struct dentry *dentry)
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:56.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:57.000000000 +0200
@@ -2697,9 +2697,9 @@ static void selinux_inode_post_setxattr(
 	return;
 }
 
-static int selinux_inode_getxattr(struct dentry *dentry, const char *name)
+static int selinux_inode_getxattr(struct path *path, const char *name)
 {
-	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
+	return dentry_has_perm(current, NULL, path->dentry, FILE__GETATTR);
 }
 
 static int selinux_inode_listxattr(struct dentry *dentry)
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-29 12:20:56.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-29 12:20:57.000000000 +0200
@@ -635,14 +635,14 @@ static void smack_inode_post_setxattr(st
 
 /*
  * smack_inode_getxattr - Smack check on getxattr
- * @dentry: the object
+ * @path: the object
  * @name: unused
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_getxattr(struct dentry *dentry, const char *name)
+static int smack_inode_getxattr(struct path *path, const char *name)
 {
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	return smk_curacc(smk_of_inode(path->dentry->d_inode), MAY_READ);
 }
 
 /*
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-29 12:20:49.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-29 12:20:57.000000000 +0200
@@ -157,7 +157,7 @@ path_getxattr(struct path *path, const c
 	if (error)
 		return error;
 
-	error = security_inode_getxattr(dentry, name);
+	error = security_inode_getxattr(path, name);
 	if (error)
 		return error;
 

--
