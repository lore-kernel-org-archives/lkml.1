Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbYE2Nz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbYE2Nz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYE2Nva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:30 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46163 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106AbYE2NvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:51:10 -0400
Message-Id: <20080529135014.339717459@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:16 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 13/15] security: pass path to inode_removexattr
Content-Disposition: inline; filename=security_removexattr_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_removexattr() security operation and related functions pass
the path (vfsmount + dentry) instead of the dentry.  AppArmor will need
this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/xattr.c                 |    2 +-
 include/linux/security.h   |   12 ++++++------
 security/commoncap.c       |    2 +-
 security/dummy.c           |    2 +-
 security/security.c        |    6 +++---
 security/selinux/hooks.c   |    4 ++--
 security/smack/smack_lsm.c |    8 ++++----
 7 files changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-29 12:20:59.000000000 +0200
@@ -218,7 +218,7 @@ vfs_removexattr(struct path *path, const
 	if (error)
 		return error;
 
-	error = security_inode_removexattr(dentry, name);
+	error = security_inode_removexattr(path, name);
 	if (error)
 		return error;
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:59.000000000 +0200
@@ -55,7 +55,7 @@ extern void cap_bprm_apply_creds(struct 
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
 extern int cap_inode_setxattr(struct path *path, const char *name,
 			      const void *value, size_t size, int flags);
-extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
+extern int cap_inode_removexattr(struct path *path, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid(uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
@@ -443,7 +443,7 @@ static inline void security_free_mnt_opt
  *	Return 0 if permission is granted.
  * @inode_removexattr:
  *	Check permission before removing the extended attribute
- *	identified by @name for @dentry.
+ *	identified by @name for @path.
  *	Return 0 if permission is granted.
  * @inode_getsecurity:
  *	Retrieve a copy of the extended attribute representation of the
@@ -1377,7 +1377,7 @@ struct security_operations {
 				     const void *value, size_t size, int flags);
 	int (*inode_getxattr) (struct path *path, const char *name);
 	int (*inode_listxattr) (struct path *path);
-	int (*inode_removexattr) (struct dentry *dentry, const char *name);
+	int (*inode_removexattr) (struct path *path, const char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
 	int (*inode_getsecurity) (const struct inode *inode, const char *name, void **buffer, bool alloc);
@@ -1649,7 +1649,7 @@ void security_inode_post_setxattr(struct
 				  const void *value, size_t size, int flags);
 int security_inode_getxattr(struct path *path, const char *name);
 int security_inode_listxattr(struct path *path);
-int security_inode_removexattr(struct dentry *dentry, const char *name);
+int security_inode_removexattr(struct path *path, const char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
@@ -2068,10 +2068,10 @@ static inline int security_inode_listxat
 	return 0;
 }
 
-static inline int security_inode_removexattr(struct dentry *dentry,
+static inline int security_inode_removexattr(struct path *path,
 			const char *name)
 {
-	return cap_inode_removexattr(dentry, name);
+	return cap_inode_removexattr(path, name);
 }
 
 static inline int security_inode_need_killpriv(struct dentry *dentry)
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:59.000000000 +0200
@@ -389,7 +389,7 @@ static int dummy_inode_listxattr(struct 
 	return 0;
 }
 
-static int dummy_inode_removexattr (struct dentry *dentry, const char *name)
+static int dummy_inode_removexattr(struct path *path, const char *name)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:59.000000000 +0200
@@ -523,11 +523,11 @@ int security_inode_listxattr(struct path
 	return security_ops->inode_listxattr(path);
 }
 
-int security_inode_removexattr(struct dentry *dentry, const char *name)
+int security_inode_removexattr(struct path *path, const char *name)
 {
-	if (unlikely(IS_PRIVATE(dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->inode_removexattr(dentry, name);
+	return security_ops->inode_removexattr(path, name);
 }
 
 int security_inode_need_killpriv(struct dentry *dentry)
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:59.000000000 +0200
@@ -2708,10 +2708,10 @@ static int selinux_inode_listxattr(struc
 	return dentry_has_perm(current, NULL, path->dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_removexattr(struct dentry *dentry, const char *name)
+static int selinux_inode_removexattr(struct path *path, const char *name)
 {
 	if (strcmp(name, XATTR_NAME_SELINUX))
-		return selinux_inode_setotherxattr(dentry, name);
+		return selinux_inode_setotherxattr(path->dentry, name);
 
 	/* No one is allowed to remove a SELinux security label.
 	   You can change the label, but all data must be labeled. */
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-29 12:20:59.000000000 +0200
@@ -648,14 +648,14 @@ static int smack_inode_getxattr(struct p
 
 /*
  * smack_inode_removexattr - Smack check on removexattr
- * @dentry: the object
+ * @path: the object
  * @name: name of the attribute
  *
  * Removing the Smack attribute requires CAP_MAC_ADMIN
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_removexattr(struct dentry *dentry, const char *name)
+static int smack_inode_removexattr(struct path *path, const char *name)
 {
 	int rc = 0;
 
@@ -665,10 +665,10 @@ static int smack_inode_removexattr(struc
 		if (!capable(CAP_MAC_ADMIN))
 			rc = -EPERM;
 	} else
-		rc = cap_inode_removexattr(dentry, name);
+		rc = cap_inode_removexattr(path, name);
 
 	if (rc == 0)
-		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+		rc = smk_curacc(smk_of_inode(path->dentry->d_inode), MAY_WRITE);
 
 	return rc;
 }
Index: linux-2.6/security/commoncap.c
===================================================================
--- linux-2.6.orig/security/commoncap.c	2008-05-29 12:20:58.000000000 +0200
+++ linux-2.6/security/commoncap.c	2008-05-29 12:20:59.000000000 +0200
@@ -397,7 +397,7 @@ int cap_inode_setxattr(struct path *path
 	return 0;
 }
 
-int cap_inode_removexattr(struct dentry *dentry, const char *name)
+int cap_inode_removexattr(struct path *path, const char *name)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))

--
