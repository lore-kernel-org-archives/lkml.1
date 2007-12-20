Return-Path: <linux-kernel-owner+w=401wt.eu-S934460AbXLTOZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbXLTOZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933072AbXLTOMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:33 -0500
Received: from ns.suse.de ([195.135.220.2]:40842 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056AbXLTOM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:28 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:45 2007
Message-Id: <20071220140945.624033417@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:38 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 28/47] Pass struct vfsmount to the inode_removexattr LSM hook
Content-Disposition: inline; filename=security-removexattr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/xattr.c               |    2 +-
 include/linux/security.h |   13 ++++++++-----
 security/commoncap.c     |    3 ++-
 security/dummy.c         |    3 ++-
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    3 ++-
 6 files changed, 18 insertions(+), 11 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -202,7 +202,7 @@ vfs_removexattr(struct dentry *dentry, s
 	if (error)
 		return error;
 
-	error = security_inode_removexattr(dentry, name);
+	error = security_inode_removexattr(dentry, mnt, name);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -58,7 +58,7 @@ extern int cap_bprm_set_security (struct
 extern void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
 extern int cap_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name, void *value, size_t size, int flags);
-extern int cap_inode_removexattr(struct dentry *dentry, char *name);
+extern int cap_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt, char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
@@ -1319,7 +1319,8 @@ struct security_operations {
 	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
 			       char *name);
 	int (*inode_listxattr) (struct dentry *dentry, struct vfsmount *mnt);
-	int (*inode_removexattr) (struct dentry *dentry, char *name);
+	int (*inode_removexattr) (struct dentry *dentry, struct vfsmount *mnt,
+				  char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
 	int (*inode_getsecurity)(const struct inode *inode, const char *name, void **buffer, bool alloc);
@@ -1591,7 +1592,8 @@ void security_inode_post_setxattr(struct
 int security_inode_getxattr(struct dentry *dentry, struct vfsmount *mnt,
 			    char *name);
 int security_inode_listxattr(struct dentry *dentry, struct vfsmount *mnt);
-int security_inode_removexattr(struct dentry *dentry, char *name);
+int security_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt,
+			       char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
@@ -2002,9 +2004,10 @@ static inline int security_inode_listxat
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
@@ -393,7 +393,8 @@ int cap_inode_setxattr(struct dentry *de
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
@@ -404,7 +404,8 @@ static int dummy_inode_listxattr (struct
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
@@ -493,11 +493,12 @@ int security_inode_listxattr(struct dent
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
@@ -2647,7 +2647,8 @@ static int selinux_inode_listxattr (stru
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_removexattr (struct dentry *dentry, char *name)
+static int selinux_inode_removexattr (struct dentry *dentry,
+				      struct vfsmount *mnt, char *name)
 {
 	if (strcmp(name, XATTR_NAME_SELINUX))
 		return selinux_inode_setotherxattr(dentry, name);

-- 

