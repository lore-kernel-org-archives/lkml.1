Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbXFZXVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbXFZXVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760218AbXFZXLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:11:46 -0400
Received: from ns1.suse.de ([195.135.220.2]:42980 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759053AbXFZXLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:11:31 -0400
Message-Id: <20070626231039.159481811@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:22 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 26/44] Pass struct vfsmount to the inode_listxattr LSM hook
Content-Disposition: inline; filename=security-listxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/xattr.c               |    2 +-
 include/linux/security.h |   12 +++++++-----
 security/dummy.c         |    2 +-
 security/selinux/hooks.c |    2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -149,7 +149,7 @@ vfs_listxattr(struct dentry *dentry, str
 	struct inode *inode = dentry->d_inode;
 	ssize_t error;
 
-	error = security_inode_listxattr(dentry);
+	error = security_inode_listxattr(dentry, mnt);
 	if (error)
 		return error;
 	error = -EOPNOTSUPP;
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -395,7 +395,7 @@ struct request_sock;
  * 	Return 0 if permission is granted.
  * @inode_listxattr:
  * 	Check permission before obtaining the list of extended attribute 
- * 	names for @dentry.
+ * 	names for @dentry and @mnt.
  * 	Return 0 if permission is granted.
  * @inode_removexattr:
  * 	Check permission before removing the extended attribute
@@ -1250,7 +1250,7 @@ struct security_operations {
 				     size_t size, int flags);
 	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
 			       char *name);
-	int (*inode_listxattr) (struct dentry *dentry);
+	int (*inode_listxattr) (struct dentry *dentry, struct vfsmount *mnt);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	const char *(*inode_xattr_getsuffix) (void);
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
@@ -1791,11 +1791,12 @@ static inline int security_inode_getxatt
 	return security_ops->inode_getxattr (dentry, mnt, name);
 }
 
-static inline int security_inode_listxattr (struct dentry *dentry)
+static inline int security_inode_listxattr (struct dentry *dentry,
+					    struct vfsmount *mnt)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_listxattr (dentry);
+	return security_ops->inode_listxattr (dentry, mnt);
 }
 
 static inline int security_inode_removexattr (struct dentry *dentry, char *name)
@@ -2495,7 +2496,8 @@ static inline int security_inode_getxatt
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
@@ -374,7 +374,7 @@ static int dummy_inode_getxattr (struct 
 	return 0;
 }
 
-static int dummy_inode_listxattr (struct dentry *dentry)
+static int dummy_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2399,7 +2399,7 @@ static int selinux_inode_getxattr (struc
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_listxattr (struct dentry *dentry)
+static int selinux_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }

-- 
