Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXF0BEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXF0BEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 21:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbXF0BEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 21:04:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:59838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbXF0BEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 21:04:12 -0400
X-Mailbox-Line: From jjohansen@suse.de Tue Jun 26 17:32:31 2007
Message-Id: <20070627003230.918844332@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 17:32:21 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 24/44] Pass struct vfsmount to the inode_getxattr LSM hook
Content-Disposition: inline; filename=security-getxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/xattr.c               |    2 +-
 include/linux/security.h |   13 ++++++++-----
 security/dummy.c         |    3 ++-
 security/selinux/hooks.c |    3 ++-
 4 files changed, 13 insertions(+), 8 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -116,7 +116,7 @@ vfs_getxattr(struct dentry *dentry, stru
 	if (error)
 		return error;
 
-	error = security_inode_getxattr(dentry, name);
+	error = security_inode_getxattr(dentry, mnt, name);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -391,7 +391,7 @@ struct request_sock;
  * 	@value identified by @name for @dentry and @mnt.
  * @inode_getxattr:
  * 	Check permission before obtaining the extended attributes
- * 	identified by @name for @dentry.
+ * 	identified by @name for @dentry and @mnt.
  * 	Return 0 if permission is granted.
  * @inode_listxattr:
  * 	Check permission before obtaining the list of extended attribute 
@@ -1248,7 +1248,8 @@ struct security_operations {
 				     struct vfsmount *mnt,
 				     char *name, void *value,
 				     size_t size, int flags);
-	int (*inode_getxattr) (struct dentry *dentry, char *name);
+	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
+			       char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	const char *(*inode_xattr_getsuffix) (void);
@@ -1782,11 +1783,12 @@ static inline void security_inode_post_s
 	security_ops->inode_post_setxattr (dentry, mnt, name, value, size, flags);
 }
 
-static inline int security_inode_getxattr (struct dentry *dentry, char *name)
+static inline int security_inode_getxattr (struct dentry *dentry,
+					    struct vfsmount *mnt, char *name)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getxattr (dentry, name);
+	return security_ops->inode_getxattr (dentry, mnt, name);
 }
 
 static inline int security_inode_listxattr (struct dentry *dentry)
@@ -2487,7 +2489,8 @@ static inline void security_inode_post_s
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
@@ -368,7 +368,8 @@ static void dummy_inode_post_setxattr (s
 {
 }
 
-static int dummy_inode_getxattr (struct dentry *dentry, char *name)
+static int dummy_inode_getxattr (struct dentry *dentry,
+			          struct vfsmount *mnt, char *name)
 {
 	return 0;
 }
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2393,7 +2393,8 @@ static void selinux_inode_post_setxattr(
 	return;
 }
 
-static int selinux_inode_getxattr (struct dentry *dentry, char *name)
+static int selinux_inode_getxattr (struct dentry *dentry, struct vfsmount *mnt,
+				   char *name)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }

-- 

