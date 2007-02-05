Return-Path: <linux-kernel-owner+w=401wt.eu-S933194AbXBES0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbXBES0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXBES0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:26:53 -0500
Received: from ns2.suse.de ([195.135.220.15]:47825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933186AbXBES0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:26:38 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:25:40 -0800
Message-Id: <20070205182540.12164.70553.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 22/28] Pass struct vfsmount to the inode_setxattr LSM hook
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_setxattr LSM hook

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
@@ -49,7 +49,7 @@ extern void cap_capset_set (struct task_
 extern int cap_bprm_set_security (struct linux_binprm *bprm);
 extern void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
-extern int cap_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags);
+extern int cap_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name, void *value, size_t size, int flags);
 extern int cap_inode_removexattr(struct dentry *dentry, char *name);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
@@ -384,11 +384,11 @@ struct request_sock;
  *	inode.
  * @inode_setxattr:
  * 	Check permission before setting the extended attributes
- * 	@value identified by @name for @dentry.
+ * 	@value identified by @name for @dentry and @mnt.
  * 	Return 0 if permission is granted.
  * @inode_post_setxattr:
  * 	Update inode security field after successful setxattr operation.
- * 	@value identified by @name for @dentry.
+ * 	@value identified by @name for @dentry and @mnt.
  * @inode_getxattr:
  * 	Check permission before obtaining the extended attributes
  * 	identified by @name for @dentry.
@@ -1242,9 +1242,11 @@ struct security_operations {
 			      struct iattr *attr);
 	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
         void (*inode_delete) (struct inode *inode);
-	int (*inode_setxattr) (struct dentry *dentry, char *name, void *value,
-			       size_t size, int flags);
-	void (*inode_post_setxattr) (struct dentry *dentry, char *name, void *value,
+	int (*inode_setxattr) (struct dentry *dentry, struct vfsmount *mnt,
+			       char *name, void *value, size_t size, int flags);
+	void (*inode_post_setxattr) (struct dentry *dentry,
+				     struct vfsmount *mnt,
+				     char *name, void *value,
 				     size_t size, int flags);
 	int (*inode_getxattr) (struct dentry *dentry, char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
@@ -1760,20 +1762,24 @@ static inline void security_inode_delete
 	security_ops->inode_delete (inode);
 }
 
-static inline int security_inode_setxattr (struct dentry *dentry, char *name,
+static inline int security_inode_setxattr (struct dentry *dentry,
+					   struct vfsmount *mnt, char *name,
 					   void *value, size_t size, int flags)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_setxattr (dentry, name, value, size, flags);
+	return security_ops->inode_setxattr (dentry, mnt, name, value, size,
+					     flags);
 }
 
-static inline void security_inode_post_setxattr (struct dentry *dentry, char *name,
-						void *value, size_t size, int flags)
+static inline void security_inode_post_setxattr (struct dentry *dentry,
+						 struct vfsmount *mnt,
+						 char *name, void *value,
+						 size_t size, int flags)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return;
-	security_ops->inode_post_setxattr (dentry, name, value, size, flags);
+	security_ops->inode_post_setxattr (dentry, mnt, name, value, size, flags);
 }
 
 static inline int security_inode_getxattr (struct dentry *dentry, char *name)
@@ -2467,14 +2473,18 @@ static inline int security_inode_getattr
 static inline void security_inode_delete (struct inode *inode)
 { }
 
-static inline int security_inode_setxattr (struct dentry *dentry, char *name,
+static inline int security_inode_setxattr (struct dentry *dentry,
+					   struct vfsmount *mnt, char *name,
 					   void *value, size_t size, int flags)
 {
-	return cap_inode_setxattr(dentry, name, value, size, flags);
+	return cap_inode_setxattr(dentry, mnt, name, value, size, flags);
 }
 
-static inline void security_inode_post_setxattr (struct dentry *dentry, char *name,
-						 void *value, size_t size, int flags)
+static inline void security_inode_post_setxattr (struct dentry *dentry,
+						 struct vfsmount *mnt,
+						 char *name,
+						 void *value, size_t size,
+						 int flags)
 { }
 
 static inline int security_inode_getxattr (struct dentry *dentry, char *name)
Index: linux-2.6/security/commoncap.c
===================================================================
--- linux-2.6.orig/security/commoncap.c
+++ linux-2.6/security/commoncap.c
@@ -191,8 +191,8 @@ int cap_bprm_secureexec (struct linux_bi
 		current->egid != current->gid);
 }
 
-int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
-		       size_t size, int flags)
+int cap_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
+		       void *value, size_t size, int flags)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -350,8 +350,9 @@ static void dummy_inode_delete (struct i
 	return;
 }
 
-static int dummy_inode_setxattr (struct dentry *dentry, char *name, void *value,
-				size_t size, int flags)
+static int dummy_inode_setxattr (struct dentry *dentry, struct vfsmount *mnt,
+				 char *name, void *value, size_t size,
+				 int flags)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
@@ -360,7 +361,9 @@ static int dummy_inode_setxattr (struct 
 	return 0;
 }
 
-static void dummy_inode_post_setxattr (struct dentry *dentry, char *name, void *value,
+static void dummy_inode_post_setxattr (struct dentry *dentry,
+				       struct vfsmount *mnt,
+				       char *name, void *value,
 				       size_t size, int flags)
 {
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2264,7 +2264,9 @@ static int selinux_inode_getattr(struct 
 	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
+static int selinux_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt,
+				  char *name, void *value, size_t size,
+				  int flags)
 {
 	struct task_security_struct *tsec = current->security;
 	struct inode *inode = dentry->d_inode;
@@ -2324,7 +2326,9 @@ static int selinux_inode_setxattr(struct
 			    &ad);
 }
 
-static void selinux_inode_post_setxattr(struct dentry *dentry, char *name,
+static void selinux_inode_post_setxattr(struct dentry *dentry,
+					struct vfsmount *mnt,
+					char *name,
                                         void *value, size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c
+++ linux-2.6/fs/xattr.c
@@ -81,7 +81,7 @@ vfs_setxattr(struct dentry *dentry, stru
 		return error;
 
 	mutex_lock(&inode->i_mutex);
-	error = security_inode_setxattr(dentry, name, value, size, flags);
+	error = security_inode_setxattr(dentry, mnt, name, value, size, flags);
 	if (error)
 		goto out;
 	error = -EOPNOTSUPP;
@@ -89,7 +89,7 @@ vfs_setxattr(struct dentry *dentry, stru
 		error = inode->i_op->setxattr(dentry, name, value, size, flags);
 		if (!error) {
 			fsnotify_xattr(dentry);
-			security_inode_post_setxattr(dentry, name, value,
+			security_inode_post_setxattr(dentry, mnt, name, value,
 						     size, flags);
 		}
 	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
