Return-Path: <linux-kernel-owner+w=401wt.eu-S1764405AbXJZHGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764405AbXJZHGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760649AbXJZG6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:58:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761334AbXJZG6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:58:11 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:50 2007
Message-Id: <20071026064050.250149327@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:48 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 24/45] Pass struct vfsmount to the inode_getxattr LSM hook
Content-Disposition: inline; filename=security-getxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
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
@@ -114,7 +114,7 @@ vfs_getxattr(struct dentry *dentry, stru
 	if (error)
 		return error;
 
-	error = security_inode_getxattr(dentry, name);
+	error = security_inode_getxattr(dentry, mnt, name);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -405,7 +405,7 @@ struct request_sock;
  * 	@value identified by @name for @dentry and @mnt.
  * @inode_getxattr:
  * 	Check permission before obtaining the extended attributes
- * 	identified by @name for @dentry.
+ * 	identified by @name for @dentry and @mnt.
  * 	Return 0 if permission is granted.
  * @inode_listxattr:
  * 	Check permission before obtaining the list of extended attribute 
@@ -1278,7 +1278,8 @@ struct security_operations {
 				     struct vfsmount *mnt,
 				     char *name, void *value,
 				     size_t size, int flags);
-	int (*inode_getxattr) (struct dentry *dentry, char *name);
+	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
+			       char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
@@ -1541,7 +1542,8 @@ int security_inode_setxattr(struct dentr
 void security_inode_post_setxattr(struct dentry *dentry, struct vfsmount *mnt,
 				  char *name, void *value, size_t size,
 				  int flags);
-int security_inode_getxattr(struct dentry *dentry, char *name);
+int security_inode_getxattr(struct dentry *dentry, struct vfsmount *mnt,
+			    char *name);
 int security_inode_listxattr(struct dentry *dentry);
 int security_inode_removexattr(struct dentry *dentry, char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
@@ -1941,7 +1943,8 @@ static inline void security_inode_post_s
 						 int flags)
 { }
 
-static inline int security_inode_getxattr (struct dentry *dentry, char *name)
+static inline int security_inode_getxattr (struct dentry *dentry,
+					   struct vfsmount *mnt, char *name)
 {
 	return 0;
 }
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -365,7 +365,8 @@ static void dummy_inode_post_setxattr (s
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
@@ -460,11 +460,12 @@ void security_inode_post_setxattr(struct
 					  flags);
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
@@ -2409,7 +2409,8 @@ static void selinux_inode_post_setxattr(
 	return;
 }
 
-static int selinux_inode_getxattr (struct dentry *dentry, char *name)
+static int selinux_inode_getxattr (struct dentry *dentry, struct vfsmount *mnt,
+				   char *name)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }

-- 

