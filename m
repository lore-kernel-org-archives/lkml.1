Return-Path: <linux-kernel-owner+w=401wt.eu-S1764631AbXJZHIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764631AbXJZHIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761298AbXJZG6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:58:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:36982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761169AbXJZG60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:58:26 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:50 2007
Message-Id: <20071026064050.830987459@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:52 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 28/45] Pass struct vfsmount to the inode_removexattr LSM hook
Content-Disposition: inline; filename=security-removexattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/xattr.c               |    2 +-
 include/linux/security.h |   14 +++++++++-----
 security/commoncap.c     |    3 ++-
 security/dummy.c         |    3 ++-
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    3 ++-
 6 files changed, 19 insertions(+), 11 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -175,7 +175,7 @@ vfs_removexattr(struct dentry *dentry, s
 	if (error)
 		return error;
 
-	error = security_inode_removexattr(dentry, name);
+	error = security_inode_removexattr(dentry, mnt, name);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -57,7 +57,8 @@ extern int cap_bprm_set_security (struct
 extern void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
 extern int cap_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name, void *value, size_t size, int flags);
-extern int cap_inode_removexattr(struct dentry *dentry, char *name);
+extern int cap_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt,
+				 char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
@@ -1281,7 +1282,8 @@ struct security_operations {
 	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
 			       char *name);
 	int (*inode_listxattr) (struct dentry *dentry, struct vfsmount *mnt);
-	int (*inode_removexattr) (struct dentry *dentry, char *name);
+	int (*inode_removexattr) (struct dentry *dentry, struct vfsmount *mnt,
+				  char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
@@ -1545,7 +1547,8 @@ void security_inode_post_setxattr(struct
 int security_inode_getxattr(struct dentry *dentry, struct vfsmount *mnt,
 			    char *name);
 int security_inode_listxattr(struct dentry *dentry, struct vfsmount *mnt);
-int security_inode_removexattr(struct dentry *dentry, char *name);
+int security_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt,
+			       char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
@@ -1955,9 +1958,10 @@ static inline int security_inode_listxat
 	return 0;
 }
 
-static inline int security_inode_removexattr (struct dentry *dentry, char *name)
+static inline int security_inode_removexattr (struct dentry *dentry,
+					      struct vfsmount *mnt, char *name)
 {
-	return cap_inode_removexattr(dentry, name);
+	return cap_inode_removexattr(dentry, mnt, name);
 }
 
 static inline int security_inode_need_killpriv(struct dentry *dentry)
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -375,7 +375,8 @@ int cap_inode_setxattr(struct dentry *de
 	return 0;
 }
 
-int cap_inode_removexattr(struct dentry *dentry, char *name)
+int cap_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt,
+			  char *name)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -376,7 +376,8 @@ static int dummy_inode_listxattr (struct
 	return 0;
 }
 
-static int dummy_inode_removexattr (struct dentry *dentry, char *name)
+static int dummy_inode_removexattr (struct dentry *dentry, struct vfsmount *mnt,
+				    char *name)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
--- a/security/security.c
+++ b/security/security.c
@@ -475,11 +475,12 @@ int security_inode_listxattr(struct dent
 	return security_ops->inode_listxattr(dentry, mnt);
 }
 
-int security_inode_removexattr(struct dentry *dentry, char *name)
+int security_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt,
+			       char *name)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_removexattr(dentry, name);
+	return security_ops->inode_removexattr(dentry, mnt, name);
 }
 
 int security_inode_need_killpriv(struct dentry *dentry)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2420,7 +2420,8 @@ static int selinux_inode_listxattr (stru
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_removexattr (struct dentry *dentry, char *name)
+static int selinux_inode_removexattr (struct dentry *dentry,
+				      struct vfsmount *mnt, char *name)
 {
 	if (strcmp(name, XATTR_NAME_SELINUX))
 		return selinux_inode_setotherxattr(dentry, name);

-- 

