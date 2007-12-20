Return-Path: <linux-kernel-owner+w=401wt.eu-S1761705AbXLTORF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761705AbXLTORF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbXLTOLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:40735 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258AbXLTOL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:28 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:43 2007
Message-Id: <20071220140943.294302058@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:23 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 13/47] Pass the struct vfsmounts to the inode_link LSM hook
Content-Disposition: inline; filename=security-link.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c               |    3 ++-
 include/linux/security.h |   16 +++++++++++-----
 security/dummy.c         |    6 ++++--
 security/security.c      |    8 +++++---
 security/selinux/hooks.c |    9 +++++++--
 5 files changed, 29 insertions(+), 13 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2486,7 +2486,8 @@ int vfs_link(struct dentry *old_dentry, 
 	if (S_ISDIR(old_dentry->d_inode->i_mode))
 		return -EPERM;
 
-	error = security_inode_link(old_dentry, dir, new_dentry);
+	error = security_inode_link(old_dentry, old_mnt, dir, new_dentry,
+				    new_mnt);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -320,8 +320,10 @@ struct request_sock;
  * @inode_link:
  *	Check permission before creating a new hard link to a file.
  *	@old_dentry contains the dentry structure for an existing link to the file.
+ *	@old_mnt is the vfsmount corresponding to @old_dentry (may be NULL).
  *	@dir contains the inode structure of the parent directory of the new link.
  *	@new_dentry contains the dentry structure for the new link.
+ *	@new_mnt is the vfsmount corresponding to @new_dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_unlink:
  *	Check the permission to remove a hard link to a file. 
@@ -1280,8 +1282,9 @@ struct security_operations {
 				    char **name, void **value, size_t *len);
 	int (*inode_create) (struct inode *dir, struct dentry *dentry,
 			     struct vfsmount *mnt, int mode);
-	int (*inode_link) (struct dentry *old_dentry,
-	                   struct inode *dir, struct dentry *new_dentry);
+	int (*inode_link) (struct dentry *old_dentry, struct vfsmount *old_mnt,
+	                   struct inode *dir, struct dentry *new_dentry,
+			   struct vfsmount *new_mnt);
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct inode *dir, struct dentry *dentry,
 			      struct vfsmount *mnt, const char *old_name);
@@ -1546,8 +1549,9 @@ int security_inode_init_security(struct 
 				  char **name, void **value, size_t *len);
 int security_inode_create(struct inode *dir, struct dentry *dentry,
 			  struct vfsmount *mnt, int mode);
-int security_inode_link(struct dentry *old_dentry, struct inode *dir,
-			 struct dentry *new_dentry);
+int security_inode_link(struct dentry *old_dentry, struct vfsmount *old_mnt,
+			struct inode *dir, struct dentry *new_dentry,
+			struct vfsmount *new_mnt);
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			   struct vfsmount *mnt, const char *old_name);
@@ -1866,8 +1870,10 @@ static inline int security_inode_create 
 }
 
 static inline int security_inode_link (struct dentry *old_dentry,
+				       struct vfsmount *old_mnt,
 				       struct inode *dir,
-				       struct dentry *new_dentry)
+				       struct dentry *new_dentry,
+				       struct vfsmount *new_mnt)
 {
 	return 0;
 }
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -295,8 +295,10 @@ static int dummy_inode_create (struct in
 	return 0;
 }
 
-static int dummy_inode_link (struct dentry *old_dentry, struct inode *inode,
-			     struct dentry *new_dentry)
+static int dummy_inode_link (struct dentry *old_dentry,
+			     struct vfsmount *old_mnt, struct inode *inode,
+			     struct dentry *new_dentry,
+			     struct vfsmount *new_mnt)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -356,12 +356,14 @@ int security_inode_create(struct inode *
 	return security_ops->inode_create(dir, dentry, mnt, mode);
 }
 
-int security_inode_link(struct dentry *old_dentry, struct inode *dir,
-			 struct dentry *new_dentry)
+int security_inode_link(struct dentry *old_dentry, struct vfsmount *old_mnt,
+			struct inode *dir, struct dentry *new_dentry,
+			struct vfsmount *new_mnt)
 {
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
 		return 0;
-	return security_ops->inode_link(old_dentry, dir, new_dentry);
+	return security_ops->inode_link(old_dentry, old_mnt, dir,
+					 new_dentry, new_mnt);
 }
 
 int security_inode_unlink(struct inode *dir, struct dentry *dentry)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2417,11 +2417,16 @@ static int selinux_inode_create(struct i
 	return may_create(dir, dentry, SECCLASS_FILE);
 }
 
-static int selinux_inode_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
+static int selinux_inode_link(struct dentry *old_dentry,
+			      struct vfsmount *old_mnt,
+			      struct inode *dir,
+			      struct dentry *new_dentry,
+			      struct vfsmount *new_mnt)
 {
 	int rc;
 
-	rc = secondary_ops->inode_link(old_dentry,dir,new_dentry);
+	rc = secondary_ops->inode_link(old_dentry, old_mnt, dir, new_dentry,
+				       new_mnt);
 	if (rc)
 		return rc;
 	return may_link(dir, old_dentry, MAY_LINK);

-- 

