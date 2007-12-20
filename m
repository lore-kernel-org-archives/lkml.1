Return-Path: <linux-kernel-owner+w=401wt.eu-S934008AbXLTOWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbXLTOWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933043AbXLTOMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:56745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933032AbXLTOMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:13 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:45 2007
Message-Id: <20071220140945.044970472@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:34 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 24/47] Pass struct vfsmount to the inode_getxattr LSM hook
Content-Disposition: inline; filename=security-getxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/xattr.c               |    2 +-
 include/linux/security.h |   11 +++++++----
 security/dummy.c         |    3 ++-
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    3 ++-
 5 files changed, 15 insertions(+), 9 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -141,7 +141,7 @@ vfs_getxattr(struct dentry *dentry, stru
 	if (error)
 		return error;
 
-	error = security_inode_getxattr(dentry, name);
+	error = security_inode_getxattr(dentry, mnt, name);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -422,7 +422,7 @@ struct request_sock;
  * 	@value identified by @name for @dentry and @mnt.
  * @inode_getxattr:
  * 	Check permission before obtaining the extended attributes
- * 	identified by @name for @dentry.
+ * 	identified by @name for @dentry and @mnt.
  * 	Return 0 if permission is granted.
  * @inode_listxattr:
  * 	Check permission before obtaining the list of extended attribute 
@@ -1316,7 +1316,8 @@ struct security_operations {
 				     struct vfsmount *mnt,
 				     char *name, void *value,
 				     size_t size, int flags);
-	int (*inode_getxattr) (struct dentry *dentry, char *name);
+	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
+			       char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
@@ -1587,7 +1588,8 @@ int security_inode_setxattr(struct dentr
 void security_inode_post_setxattr(struct dentry *dentry, struct vfsmount *mnt,
 				  char *name, void *value, size_t size,
 				  int flags);
-int security_inode_getxattr(struct dentry *dentry, char *name);
+int security_inode_getxattr(struct dentry *dentry, struct vfsmount *mnt,
+			    char *name);
 int security_inode_listxattr(struct dentry *dentry);
 int security_inode_removexattr(struct dentry *dentry, char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
@@ -1988,7 +1990,8 @@ static inline void security_inode_post_s
 						 int flags)
 { }
 
-static inline int security_inode_getxattr (struct dentry *dentry, char *name)
+static inline int security_inode_getxattr (struct dentry *dentry,
+					    struct vfsmount *mnt, char *name)
 {
 	return 0;
 }
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -393,7 +393,8 @@ static void dummy_inode_post_setxattr (s
 {
 }
 
-static int dummy_inode_getxattr (struct dentry *dentry, char *name)
+static int dummy_inode_getxattr (struct dentry *dentry,
+			          struct vfsmount *mnt, char *name)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -478,11 +478,12 @@ void security_inode_post_setxattr(struct
 	security_ops->inode_post_setxattr(dentry, mnt, name, value, size, flags);
 }
 
-int security_inode_getxattr(struct dentry *dentry, char *name)
+int security_inode_getxattr(struct dentry *dentry, struct vfsmount *mnt,
+			    char *name)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getxattr(dentry, name);
+	return security_ops->inode_getxattr(dentry, mnt, name);
 }
 
 int security_inode_listxattr(struct dentry *dentry)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2636,7 +2636,8 @@ static void selinux_inode_post_setxattr(
 	return;
 }
 
-static int selinux_inode_getxattr (struct dentry *dentry, char *name)
+static int selinux_inode_getxattr (struct dentry *dentry, struct vfsmount *mnt,
+				   char *name)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }

-- 

