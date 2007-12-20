Return-Path: <linux-kernel-owner+w=401wt.eu-S1764574AbXLTOX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764574AbXLTOX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932945AbXLTOMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbXLTOMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:21 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:45 2007
Message-Id: <20071220140945.332961472@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:36 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 26/47] Pass struct vfsmount to the inode_listxattr LSM hook
Content-Disposition: inline; filename=security-listxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
@@ -174,7 +174,7 @@ vfs_listxattr(struct dentry *dentry, str
 	struct inode *inode = dentry->d_inode;
 	ssize_t error;
 
-	error = security_inode_listxattr(dentry);
+	error = security_inode_listxattr(dentry, mnt);
 	if (error)
 		return error;
 	error = -EOPNOTSUPP;
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -426,7 +426,7 @@ struct request_sock;
  * 	Return 0 if permission is granted.
  * @inode_listxattr:
  * 	Check permission before obtaining the list of extended attribute 
- * 	names for @dentry.
+ * 	names for @dentry and @mnt.
  * 	Return 0 if permission is granted.
  * @inode_removexattr:
  * 	Check permission before removing the extended attribute
@@ -1318,7 +1318,7 @@ struct security_operations {
 				     size_t size, int flags);
 	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
 			       char *name);
-	int (*inode_listxattr) (struct dentry *dentry);
+	int (*inode_listxattr) (struct dentry *dentry, struct vfsmount *mnt);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
@@ -1590,7 +1590,7 @@ void security_inode_post_setxattr(struct
 				  int flags);
 int security_inode_getxattr(struct dentry *dentry, struct vfsmount *mnt,
 			    char *name);
-int security_inode_listxattr(struct dentry *dentry);
+int security_inode_listxattr(struct dentry *dentry, struct vfsmount *mnt);
 int security_inode_removexattr(struct dentry *dentry, char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
@@ -1996,7 +1996,8 @@ static inline int security_inode_getxatt
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
@@ -399,7 +399,7 @@ static int dummy_inode_getxattr (struct 
 	return 0;
 }
 
-static int dummy_inode_listxattr (struct dentry *dentry)
+static int dummy_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -486,11 +486,11 @@ int security_inode_getxattr(struct dentr
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
@@ -2642,7 +2642,7 @@ static int selinux_inode_getxattr (struc
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_listxattr (struct dentry *dentry)
+static int selinux_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }

-- 

