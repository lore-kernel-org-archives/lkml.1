Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbXJZHH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbXJZHH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761455AbXJZG6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:58:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:34880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760461AbXJZG6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:58:18 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:50 2007
Message-Id: <20071026064050.550710239@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:50 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 26/45] Pass struct vfsmount to the inode_listxattr LSM hook
Content-Disposition: inline; filename=security-listxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/xattr.c               |    2 +-
 include/linux/security.h |    9 +++++----
 security/dummy.c         |    2 +-
 security/security.c      |    4 ++--
 security/selinux/hooks.c |    2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -147,7 +147,7 @@ vfs_listxattr(struct dentry *dentry, str
 	struct inode *inode = dentry->d_inode;
 	ssize_t error;
 
-	error = security_inode_listxattr(dentry);
+	error = security_inode_listxattr(dentry, mnt);
 	if (error)
 		return error;
 	error = -EOPNOTSUPP;
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -409,7 +409,7 @@ struct request_sock;
  * 	Return 0 if permission is granted.
  * @inode_listxattr:
  * 	Check permission before obtaining the list of extended attribute 
- * 	names for @dentry.
+ * 	names for @dentry and @mnt.
  * 	Return 0 if permission is granted.
  * @inode_removexattr:
  * 	Check permission before removing the extended attribute
@@ -1280,7 +1280,7 @@ struct security_operations {
 				     size_t size, int flags);
 	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
 			       char *name);
-	int (*inode_listxattr) (struct dentry *dentry);
+	int (*inode_listxattr) (struct dentry *dentry, struct vfsmount *mnt);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
@@ -1544,7 +1544,7 @@ void security_inode_post_setxattr(struct
 				  int flags);
 int security_inode_getxattr(struct dentry *dentry, struct vfsmount *mnt,
 			    char *name);
-int security_inode_listxattr(struct dentry *dentry);
+int security_inode_listxattr(struct dentry *dentry, struct vfsmount *mnt);
 int security_inode_removexattr(struct dentry *dentry, char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
@@ -1949,7 +1949,8 @@ static inline int security_inode_getxatt
 	return 0;
 }
 
-static inline int security_inode_listxattr (struct dentry *dentry)
+static inline int security_inode_listxattr (struct dentry *dentry,
+					    struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -371,7 +371,7 @@ static int dummy_inode_getxattr (struct 
 	return 0;
 }
 
-static int dummy_inode_listxattr (struct dentry *dentry)
+static int dummy_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -468,11 +468,11 @@ int security_inode_getxattr(struct dentr
 	return security_ops->inode_getxattr(dentry, mnt, name);
 }
 
-int security_inode_listxattr(struct dentry *dentry)
+int security_inode_listxattr(struct dentry *dentry, struct vfsmount *mnt)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_listxattr(dentry);
+	return security_ops->inode_listxattr(dentry, mnt);
 }
 
 int security_inode_removexattr(struct dentry *dentry, char *name)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2415,7 +2415,7 @@ static int selinux_inode_getxattr (struc
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_listxattr (struct dentry *dentry)
+static int selinux_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }

-- 

