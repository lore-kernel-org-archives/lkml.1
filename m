Return-Path: <linux-kernel-owner+w=401wt.eu-S1761448AbXFZXU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448AbXFZXU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbXFZXLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:11:38 -0400
Received: from mail.suse.de ([195.135.220.2]:42987 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760059AbXFZXLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:11:35 -0400
Message-Id: <20070626231049.035709065@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:24 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 28/44] Pass struct vfsmount to the inode_removexattr LSM hook
Content-Disposition: inline; filename=security-removexattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/xattr.c               |    2 +-
 include/linux/security.h |   15 +++++++++------
 security/commoncap.c     |    3 ++-
 security/dummy.c         |    3 ++-
 security/selinux/hooks.c |    3 ++-
 5 files changed, 16 insertions(+), 10 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -177,7 +177,7 @@ vfs_removexattr(struct dentry *dentry, s
 	if (error)
 		return error;
 
-	error = security_inode_removexattr(dentry, name);
+	error = security_inode_removexattr(dentry, mnt, name);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -50,7 +50,7 @@ extern int cap_bprm_set_security (struct
 extern void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
 extern int cap_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name, void *value, size_t size, int flags);
-extern int cap_inode_removexattr(struct dentry *dentry, char *name);
+extern int cap_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt, char *name);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
 extern int cap_syslog (int type);
@@ -1251,7 +1251,8 @@ struct security_operations {
 	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
 			       char *name);
 	int (*inode_listxattr) (struct dentry *dentry, struct vfsmount *mnt);
-	int (*inode_removexattr) (struct dentry *dentry, char *name);
+	int (*inode_removexattr) (struct dentry *dentry, struct vfsmount *mnt,
+				  char *name);
 	const char *(*inode_xattr_getsuffix) (void);
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
@@ -1799,11 +1800,12 @@ static inline int security_inode_listxat
 	return security_ops->inode_listxattr (dentry, mnt);
 }
 
-static inline int security_inode_removexattr (struct dentry *dentry, char *name)
+static inline int security_inode_removexattr (struct dentry *dentry,
+					      struct vfsmount *mnt, char *name)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_removexattr (dentry, name);
+	return security_ops->inode_removexattr (dentry, mnt, name);
 }
 
 static inline const char *security_inode_xattr_getsuffix(void)
@@ -2502,9 +2504,10 @@ static inline int security_inode_listxat
 	return 0;
 }
 
-static inline int security_inode_removexattr (struct dentry *dentry, char *name)
+static inline int security_inode_removexattr (struct dentry *dentry,
+					      struct vfsmount *mnt, char *name)
 {
-	return cap_inode_removexattr(dentry, name);
+	return cap_inode_removexattr(dentry, mnt, name);
 }
 
 static inline const char *security_inode_xattr_getsuffix (void)
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -200,7 +200,8 @@ int cap_inode_setxattr(struct dentry *de
 	return 0;
 }
 
-int cap_inode_removexattr(struct dentry *dentry, char *name)
+int cap_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt,
+			  char *name)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -379,7 +379,8 @@ static int dummy_inode_listxattr (struct
 	return 0;
 }
 
-static int dummy_inode_removexattr (struct dentry *dentry, char *name)
+static int dummy_inode_removexattr (struct dentry *dentry, struct vfsmount *mnt,
+				    char *name)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2404,7 +2404,8 @@ static int selinux_inode_listxattr (stru
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_removexattr (struct dentry *dentry, char *name)
+static int selinux_inode_removexattr (struct dentry *dentry,
+				      struct vfsmount *mnt, char *name)
 {
 	if (strcmp(name, XATTR_NAME_SELINUX)) {
 		if (!strncmp(name, XATTR_SECURITY_PREFIX,

-- 
