Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbXFZXLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbXFZXLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758968AbXFZXKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:10:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:42876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374AbXFZXJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:09:51 -0400
Message-Id: <20070626230851.325388038@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:07:57 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 01/44] Pass struct vfsmount to the inode_create LSM hook
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
 security/selinux/hooks.c |    3 ++-
 4 files changed, 10 insertions(+), 6 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1521,7 +1521,7 @@ int vfs_create(struct inode *dir, struct
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
@@ -283,6 +283,7 @@ struct request_sock;
  *	Check permission to create a regular file.
  *	@dir contains inode structure of the parent of the new file.
  *	@dentry contains the dentry structure for the file to be created.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the file mode of the file to be created.
  *	Return 0 if permission is granted.
  * @inode_link:
@@ -1204,8 +1205,8 @@ struct security_operations {
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
@@ -1611,11 +1612,12 @@ static inline int security_inode_init_se
 	
 static inline int security_inode_create (struct inode *dir,
 					 struct dentry *dentry,
+					 struct vfsmount *mnt,
 					 int mode)
 {
 	if (unlikely (IS_PRIVATE (dir)))
 		return 0;
-	return security_ops->inode_create (dir, dentry, mode);
+	return security_ops->inode_create (dir, dentry, mnt, mode);
 }
 
 static inline int security_inode_link (struct dentry *old_dentry,
@@ -2338,6 +2340,7 @@ static inline int security_inode_init_se
 	
 static inline int security_inode_create (struct inode *dir,
 					 struct dentry *dentry,
+					 struct vfsmount *mnt,
 					 int mode)
 {
 	return 0;
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -265,7 +265,7 @@ static int dummy_inode_init_security (st
 }
 
 static int dummy_inode_create (struct inode *inode, struct dentry *dentry,
-			       int mask)
+			       struct vfsmount *mnt, int mask)
 {
 	return 0;
 }
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2176,7 +2176,8 @@ static int selinux_inode_init_security(s
 	return 0;
 }
 
-static int selinux_inode_create(struct inode *dir, struct dentry *dentry, int mask)
+static int selinux_inode_create(struct inode *dir, struct dentry *dentry,
+				 struct vfsmount *mnt, int mask)
 {
 	return may_create(dir, dentry, SECCLASS_FILE);
 }

-- 
