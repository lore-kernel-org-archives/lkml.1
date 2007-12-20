Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbXLTOLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbXLTOLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932696AbXLTOKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:10:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258AbXLTOKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:10:39 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:41 2007
Message-Id: <20071220140941.217983059@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:11 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 01/47] Pass struct vfsmount to the inode_create LSM hook
Content-Disposition: inline; filename=security-create.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
@@ -1586,7 +1586,7 @@ int vfs_create(struct inode *dir, struct
 		return -EACCES;	/* shouldn't it be ENOSYS? */
 	mode &= S_IALLUGO;
 	mode |= S_IFREG;
-	error = security_inode_create(dir, dentry, mode);
+	error = security_inode_create(dir, dentry, nd ? nd->path.mnt : NULL, mode);
 	if (error)
 		return error;
 	DQUOT_INIT(dir);
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -314,6 +314,7 @@ struct request_sock;
  *	Check permission to create a regular file.
  *	@dir contains inode structure of the parent of the new file.
  *	@dentry contains the dentry structure for the file to be created.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the file mode of the file to be created.
  *	Return 0 if permission is granted.
  * @inode_link:
@@ -1272,8 +1273,8 @@ struct security_operations {
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
@@ -1536,7 +1537,8 @@ int security_inode_alloc(struct inode *i
 void security_inode_free(struct inode *inode);
 int security_inode_init_security(struct inode *inode, struct inode *dir,
 				  char **name, void **value, size_t *len);
-int security_inode_create(struct inode *dir, struct dentry *dentry, int mode);
+int security_inode_create(struct inode *dir, struct dentry *dentry,
+			  struct vfsmount *mnt, int mode);
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry);
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
@@ -1847,6 +1849,7 @@ static inline int security_inode_init_se
 	
 static inline int security_inode_create (struct inode *dir,
 					 struct dentry *dentry,
+					 struct vfsmount *mnt,
 					 int mode)
 {
 	return 0;
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -290,7 +290,7 @@ static int dummy_inode_init_security (st
 }
 
 static int dummy_inode_create (struct inode *inode, struct dentry *dentry,
-			       int mask)
+			       struct vfsmount *mnt, int mask)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -348,11 +348,12 @@ int security_inode_init_security(struct 
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
@@ -2411,7 +2411,8 @@ static int selinux_inode_init_security(s
 	return 0;
 }
 
-static int selinux_inode_create(struct inode *dir, struct dentry *dentry, int mask)
+static int selinux_inode_create(struct inode *dir, struct dentry *dentry,
+				 struct vfsmount *mnt, int mask)
 {
 	return may_create(dir, dentry, SECCLASS_FILE);
 }

-- 

