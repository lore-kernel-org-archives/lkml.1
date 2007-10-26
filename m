Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbXJZG46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbXJZG46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbXJZG4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:56:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:36680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbXJZG4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:56:37 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:47 2007
Message-Id: <20071026064046.976343280@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:25 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 01/45] Pass struct vfsmount to the inode_create LSM hook
Content-Disposition: inline; filename=security-create.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c               |    2 +-
 include/linux/security.h |    9 ++++++---
 security/dummy.c         |    2 +-
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    3 ++-
 5 files changed, 13 insertions(+), 8 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1584,7 +1584,7 @@ int vfs_create(struct inode *dir, struct
 		return -EACCES;	/* shouldn't it be ENOSYS? */
 	mode &= S_IALLUGO;
 	mode |= S_IFREG;
-	error = security_inode_create(dir, dentry, mode);
+	error = security_inode_create(dir, dentry, nd ? nd->mnt : NULL, mode);
 	if (error)
 		return error;
 	DQUOT_INIT(dir);
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -297,6 +297,7 @@ struct request_sock;
  *	Check permission to create a regular file.
  *	@dir contains inode structure of the parent of the new file.
  *	@dentry contains the dentry structure for the file to be created.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the file mode of the file to be created.
  *	Return 0 if permission is granted.
  * @inode_link:
@@ -1234,8 +1235,8 @@ struct security_operations {
 	void (*inode_free_security) (struct inode *inode);
 	int (*inode_init_security) (struct inode *inode, struct inode *dir,
 				    char **name, void **value, size_t *len);
-	int (*inode_create) (struct inode *dir,
-	                     struct dentry *dentry, int mode);
+	int (*inode_create) (struct inode *dir, struct dentry *dentry,
+			     struct vfsmount *mnt, int mode);
 	int (*inode_link) (struct dentry *old_dentry,
 	                   struct inode *dir, struct dentry *new_dentry);
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
@@ -1490,7 +1491,8 @@ int security_inode_alloc(struct inode *i
 void security_inode_free(struct inode *inode);
 int security_inode_init_security(struct inode *inode, struct inode *dir,
 				  char **name, void **value, size_t *len);
-int security_inode_create(struct inode *dir, struct dentry *dentry, int mode);
+int security_inode_create(struct inode *dir, struct dentry *dentry,
+			  struct vfsmount *mnt, int mode);
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry);
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
@@ -1800,6 +1802,7 @@ static inline int security_inode_init_se
 	
 static inline int security_inode_create (struct inode *dir,
 					 struct dentry *dentry,
+					 struct vfsmount *mnt,
 					 int mode)
 {
 	return 0;
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -262,7 +262,7 @@ static int dummy_inode_init_security (st
 }
 
 static int dummy_inode_create (struct inode *inode, struct dentry *dentry,
-			       int mask)
+			       struct vfsmount *mnt, int mask)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -328,11 +328,12 @@ int security_inode_init_security(struct 
 }
 EXPORT_SYMBOL(security_inode_init_security);
 
-int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
+int security_inode_create(struct inode *dir, struct dentry *dentry,
+			  struct vfsmount *mnt, int mode)
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_create(dir, dentry, mode);
+	return security_ops->inode_create(dir, dentry, mnt, mode);
 }
 
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2184,7 +2184,8 @@ static int selinux_inode_init_security(s
 	return 0;
 }
 
-static int selinux_inode_create(struct inode *dir, struct dentry *dentry, int mask)
+static int selinux_inode_create(struct inode *dir, struct dentry *dentry,
+				 struct vfsmount *mnt, int mask)
 {
 	return may_create(dir, dentry, SECCLASS_FILE);
 }

-- 

