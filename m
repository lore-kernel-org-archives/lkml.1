Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbYE2Ny6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbYE2Ny6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbYE2Nv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46165 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107AbYE2NvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:51:10 -0400
Message-Id: <20080529135013.166912240@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:15 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 12/15] security: pass path to inode_setxattr
Content-Disposition: inline; filename=security_setxattr_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_setxattr() security operation and related functions pass
the path (vfsmount + dentry) instead of the dentry.  AppArmor will need
this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/xattr.c                 |    2 +-
 include/linux/security.h   |   12 ++++++------
 security/commoncap.c       |    2 +-
 security/dummy.c           |    4 ++--
 security/security.c        |    6 +++---
 security/selinux/hooks.c   |    3 ++-
 security/smack/smack_lsm.c |    7 ++++---
 7 files changed, 19 insertions(+), 17 deletions(-)

Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-29 12:20:58.000000000 +0200
@@ -81,7 +81,7 @@ vfs_setxattr(struct path *path, const ch
 		return error;
 
 	mutex_lock(&inode->i_mutex);
-	error = security_inode_setxattr(dentry, name, value, size, flags);
+	error = security_inode_setxattr(path, name, value, size, flags);
 	if (error)
 		goto out;
 	error = -EOPNOTSUPP;
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:58.000000000 +0200
@@ -53,7 +53,7 @@ extern void cap_capset_set(struct task_s
 extern int cap_bprm_set_security(struct linux_binprm *bprm);
 extern void cap_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
-extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
+extern int cap_inode_setxattr(struct path *path, const char *name,
 			      const void *value, size_t size, int flags);
 extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
@@ -428,7 +428,7 @@ static inline void security_free_mnt_opt
  *	inode.
  * @inode_setxattr:
  *	Check permission before setting the extended attributes
- *	@value identified by @name for @dentry.
+ *	@value identified by @name for @path.
  *	Return 0 if permission is granted.
  * @inode_post_setxattr:
  *	Update inode security field after successful setxattr operation.
@@ -1371,7 +1371,7 @@ struct security_operations {
 	int (*inode_setattr)	(struct path *path, struct iattr *attr);
 	int (*inode_getattr) (struct path *path);
 	void (*inode_delete) (struct inode *inode);
-	int (*inode_setxattr) (struct dentry *dentry, const char *name,
+	int (*inode_setxattr) (struct path *path, const char *name,
 			       const void *value, size_t size, int flags);
 	void (*inode_post_setxattr) (struct dentry *dentry, const char *name,
 				     const void *value, size_t size, int flags);
@@ -1643,7 +1643,7 @@ int security_inode_permission(struct ino
 int security_inode_setattr(struct path *path, struct iattr *attr);
 int security_inode_getattr(struct path *path);
 void security_inode_delete(struct inode *inode);
-int security_inode_setxattr(struct dentry *dentry, const char *name,
+int security_inode_setxattr(struct path *path, const char *name,
 			    const void *value, size_t size, int flags);
 void security_inode_post_setxattr(struct dentry *dentry, const char *name,
 				  const void *value, size_t size, int flags);
@@ -2048,10 +2048,10 @@ static inline int security_inode_getattr
 static inline void security_inode_delete(struct inode *inode)
 { }
 
-static inline int security_inode_setxattr(struct dentry *dentry,
+static inline int security_inode_setxattr(struct path *path,
 		const char *name, const void *value, size_t size, int flags)
 {
-	return cap_inode_setxattr(dentry, name, value, size, flags);
+	return cap_inode_setxattr(path, name, value, size, flags);
 }
 
 static inline void security_inode_post_setxattr(struct dentry *dentry,
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:58.000000000 +0200
@@ -363,8 +363,8 @@ static void dummy_inode_delete (struct i
 	return;
 }
 
-static int dummy_inode_setxattr (struct dentry *dentry, const char *name,
-				 const void *value, size_t size, int flags)
+static int dummy_inode_setxattr(struct path *path, const char *name,
+				const void *value, size_t size, int flags)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:58.000000000 +0200
@@ -493,12 +493,12 @@ void security_inode_delete(struct inode 
 	security_ops->inode_delete(inode);
 }
 
-int security_inode_setxattr(struct dentry *dentry, const char *name,
+int security_inode_setxattr(struct path *path, const char *name,
 			    const void *value, size_t size, int flags)
 {
-	if (unlikely(IS_PRIVATE(dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->inode_setxattr(dentry, name, value, size, flags);
+	return security_ops->inode_setxattr(path, name, value, size, flags);
 }
 
 void security_inode_post_setxattr(struct dentry *dentry, const char *name,
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:58.000000000 +0200
@@ -2622,10 +2622,11 @@ static int selinux_inode_setotherxattr(s
 	return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
 }
 
-static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
+static int selinux_inode_setxattr(struct path *path, const char *name,
 				  const void *value, size_t size, int flags)
 {
 	struct task_security_struct *tsec = current->security;
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	struct inode_security_struct *isec = inode->i_security;
 	struct superblock_security_struct *sbsec;
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-29 12:20:57.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-29 12:20:58.000000000 +0200
@@ -563,7 +563,7 @@ static int smack_inode_getattr(struct pa
 
 /**
  * smack_inode_setxattr - Smack check for setting xattrs
- * @dentry: the object
+ * @path: the object
  * @name: name of the attribute
  * @value: unused
  * @size: unused
@@ -573,9 +573,10 @@ static int smack_inode_getattr(struct pa
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_setxattr(struct dentry *dentry, const char *name,
+static int smack_inode_setxattr(struct path *path, const char *name,
 				const void *value, size_t size, int flags)
 {
+	struct dentry *dentry = path->dentry;
 	int rc = 0;
 
 	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
@@ -584,7 +585,7 @@ static int smack_inode_setxattr(struct d
 		if (!capable(CAP_MAC_ADMIN))
 			rc = -EPERM;
 	} else
-		rc = cap_inode_setxattr(dentry, name, value, size, flags);
+		rc = cap_inode_setxattr(path, name, value, size, flags);
 
 	if (rc == 0)
 		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
Index: linux-2.6/security/commoncap.c
===================================================================
--- linux-2.6.orig/security/commoncap.c	2008-05-29 12:20:15.000000000 +0200
+++ linux-2.6/security/commoncap.c	2008-05-29 12:20:58.000000000 +0200
@@ -383,7 +383,7 @@ int cap_bprm_secureexec (struct linux_bi
 		current->egid != current->gid);
 }
 
-int cap_inode_setxattr(struct dentry *dentry, const char *name,
+int cap_inode_setxattr(struct path *path, const char *name,
 		       const void *value, size_t size, int flags)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {

--
