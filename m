Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbXJZHFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbXJZHFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760004AbXJZG6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:58:08 -0400
Received: from ns1.suse.de ([195.135.220.2]:34854 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760232AbXJZG6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:58:05 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:50 2007
Message-Id: <20071026064049.972815106@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:46 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 22/45] Pass struct vfsmount to the inode_setxattr LSM hook
Content-Disposition: inline; filename=security-setxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/xattr.c               |    4 ++--
 include/linux/security.h |   35 +++++++++++++++++++++--------------
 security/commoncap.c     |    4 ++--
 security/dummy.c         |    9 ++++++---
 security/security.c      |   15 +++++++++------
 security/selinux/hooks.c |    8 ++++++--
 6 files changed, 46 insertions(+), 29 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -78,7 +78,7 @@ vfs_setxattr(struct dentry *dentry, stru
 		return error;
 
 	mutex_lock(&inode->i_mutex);
-	error = security_inode_setxattr(dentry, name, value, size, flags);
+	error = security_inode_setxattr(dentry, mnt, name, value, size, flags);
 	if (error)
 		goto out;
 	error = -EOPNOTSUPP;
@@ -86,7 +86,7 @@ vfs_setxattr(struct dentry *dentry, stru
 		error = inode->i_op->setxattr(dentry, name, value, size, flags);
 		if (!error) {
 			fsnotify_xattr(dentry);
-			security_inode_post_setxattr(dentry, name, value,
+			security_inode_post_setxattr(dentry, mnt, name, value,
 						     size, flags);
 		}
 	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -56,7 +56,7 @@ extern void cap_capset_set (struct task_
 extern int cap_bprm_set_security (struct linux_binprm *bprm);
 extern void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
-extern int cap_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags);
+extern int cap_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name, void *value, size_t size, int flags);
 extern int cap_inode_removexattr(struct dentry *dentry, char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
@@ -398,11 +398,11 @@ struct request_sock;
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
@@ -1272,9 +1272,11 @@ struct security_operations {
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
@@ -1534,10 +1536,11 @@ int security_inode_setattr(struct dentry
 			   struct iattr *attr);
 int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry);
 void security_inode_delete(struct inode *inode);
-int security_inode_setxattr(struct dentry *dentry, char *name,
-			     void *value, size_t size, int flags);
-void security_inode_post_setxattr(struct dentry *dentry, char *name,
-				   void *value, size_t size, int flags);
+int security_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt,
+			    char *name, void *value, size_t size, int flags);
+void security_inode_post_setxattr(struct dentry *dentry, struct vfsmount *mnt,
+				  char *name, void *value, size_t size,
+				  int flags);
 int security_inode_getxattr(struct dentry *dentry, char *name);
 int security_inode_listxattr(struct dentry *dentry);
 int security_inode_removexattr(struct dentry *dentry, char *name);
@@ -1924,14 +1927,18 @@ static inline int security_inode_getattr
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
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -361,8 +361,8 @@ int cap_bprm_secureexec (struct linux_bi
 		current->egid != current->gid);
 }
 
-int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
-		       size_t size, int flags)
+int cap_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
+		       void *value, size_t size, int flags)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -347,8 +347,9 @@ static void dummy_inode_delete (struct i
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
@@ -357,7 +358,9 @@ static int dummy_inode_setxattr (struct 
 	return 0;
 }
 
-static void dummy_inode_post_setxattr (struct dentry *dentry, char *name, void *value,
+static void dummy_inode_post_setxattr (struct dentry *dentry,
+				       struct vfsmount *mnt,
+				       char *name, void *value,
 				       size_t size, int flags)
 {
 }
--- a/security/security.c
+++ b/security/security.c
@@ -441,20 +441,23 @@ void security_inode_delete(struct inode 
 	security_ops->inode_delete(inode);
 }
 
-int security_inode_setxattr(struct dentry *dentry, char *name,
-			     void *value, size_t size, int flags)
+int security_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt,
+			    char *name, void *value, size_t size, int flags)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_setxattr(dentry, name, value, size, flags);
+	return security_ops->inode_setxattr(dentry, mnt, name, value, size,
+					    flags);
 }
 
-void security_inode_post_setxattr(struct dentry *dentry, char *name,
-				   void *value, size_t size, int flags)
+void security_inode_post_setxattr(struct dentry *dentry, struct vfsmount *mnt,
+				  char *name, void *value, size_t size,
+				  int flags)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return;
-	security_ops->inode_post_setxattr(dentry, name, value, size, flags);
+	security_ops->inode_post_setxattr(dentry, mnt, name, value, size,
+					  flags);
 }
 
 int security_inode_getxattr(struct dentry *dentry, char *name)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2332,7 +2332,9 @@ static int selinux_inode_setotherxattr(s
 	return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
 }
 
-static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
+static int selinux_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt,
+				  char *name, void *value, size_t size,
+				  int flags)
 {
 	struct task_security_struct *tsec = current->security;
 	struct inode *inode = dentry->d_inode;
@@ -2381,7 +2383,9 @@ static int selinux_inode_setxattr(struct
 			    &ad);
 }
 
-static void selinux_inode_post_setxattr(struct dentry *dentry, char *name,
+static void selinux_inode_post_setxattr(struct dentry *dentry,
+					struct vfsmount *mnt,
+					char *name,
                                         void *value, size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;

-- 

