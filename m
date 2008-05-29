Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbYE2Nvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbYE2Nvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbYE2Nuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:50:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46122 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637AbYE2Nuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:50:50 -0400
Message-Id: <20080529135006.275669166@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:10 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 07/15] security: pass path to inode_link
Content-Disposition: inline; filename=security_link_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_link() security operation and related functions pass the
path (vfsmount + dentry) to the parent directory instead of the inode.
AppArmor will need this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c                 |   10 +++++-----
 include/linux/security.h   |    8 ++++----
 security/dummy.c           |    4 ++--
 security/security.c        |    2 +-
 security/selinux/hooks.c   |    5 +++--
 security/smack/smack_lsm.c |    2 +-
 6 files changed, 16 insertions(+), 15 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:54.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:55.000000000 +0200
@@ -2531,17 +2531,17 @@ asmlinkage long sys_symlink(const char _
 	return sys_symlinkat(oldname, AT_FDCWD, newname);
 }
 
-static int vfs_link(struct dentry *old_dentry, struct dentry *new_dir_dentry,
+static int vfs_link(struct dentry *old_dentry, struct path *new_dir_path,
 		    struct dentry *new_dentry)
 {
-	struct inode *dir = new_dir_dentry->d_inode;
+	struct inode *dir = new_dir_path->dentry->d_inode;
 	struct inode *inode = old_dentry->d_inode;
 	int error;
 
 	if (!inode)
 		return -ENOENT;
 
-	error = may_create(new_dir_dentry, new_dentry);
+	error = may_create(new_dir_path->dentry, new_dentry);
 	if (error)
 		return error;
 
@@ -2558,7 +2558,7 @@ static int vfs_link(struct dentry *old_d
 	if (S_ISDIR(inode->i_mode))
 		return -EPERM;
 
-	error = security_inode_link(old_dentry, dir, new_dentry);
+	error = security_inode_link(old_dentry, new_dir_path, new_dentry);
 	if (error)
 		return error;
 
@@ -2577,7 +2577,7 @@ int path_link(struct dentry *old_dentry,
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_link(old_dentry, dir_path->dentry, new_dentry);
+		error = vfs_link(old_dentry, dir_path, new_dentry);
 		mnt_drop_write(dir_path->mnt);
 	}
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:54.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:55.000000000 +0200
@@ -346,7 +346,7 @@ static inline void security_free_mnt_opt
  * @inode_link:
  *	Check permission before creating a new hard link to a file.
  *	@old_dentry contains the dentry structure for an existing link to the file.
- *	@dir contains the inode structure of the parent directory of the new link.
+ *	@dir contains the path to the parent of the new link.
  *	@new_dentry contains the dentry structure for the new link.
  *	Return 0 if permission is granted.
  * @inode_unlink:
@@ -1355,7 +1355,7 @@ struct security_operations {
 				    char **name, void **value, size_t *len);
 	int (*inode_create) (struct path *dir, struct dentry *dentry, int mode);
 	int (*inode_link) (struct dentry *old_dentry,
-			   struct inode *dir, struct dentry *new_dentry);
+			   struct path *dir, struct dentry *new_dentry);
 	int (*inode_unlink) (struct path *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct path *dir,
 			      struct dentry *dentry, const char *old_name);
@@ -1626,7 +1626,7 @@ void security_inode_free(struct inode *i
 int security_inode_init_security(struct inode *inode, struct inode *dir,
 				  char **name, void **value, size_t *len);
 int security_inode_create(struct path *dir, struct dentry *dentry, int mode);
-int security_inode_link(struct dentry *old_dentry, struct inode *dir,
+int security_inode_link(struct dentry *old_dentry, struct path *dir,
 			 struct dentry *new_dentry);
 int security_inode_unlink(struct path *dir, struct dentry *dentry);
 int security_inode_symlink(struct path *dir, struct dentry *dentry,
@@ -1972,7 +1972,7 @@ static inline int security_inode_create(
 }
 
 static inline int security_inode_link(struct dentry *old_dentry,
-				       struct inode *dir,
+				       struct path *dir,
 				       struct dentry *new_dentry)
 {
 	return 0;
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:54.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:55.000000000 +0200
@@ -292,8 +292,8 @@ static int dummy_inode_create(struct pat
 	return 0;
 }
 
-static int dummy_inode_link (struct dentry *old_dentry, struct inode *inode,
-			     struct dentry *new_dentry)
+static int dummy_inode_link(struct dentry *old_dentry, struct path *dir,
+			    struct dentry *new_dentry)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:54.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:55.000000000 +0200
@@ -395,7 +395,7 @@ int security_inode_create(struct path *d
 	return security_ops->inode_create(dir, dentry, mode);
 }
 
-int security_inode_link(struct dentry *old_dentry, struct inode *dir,
+int security_inode_link(struct dentry *old_dentry, struct path *dir,
 			 struct dentry *new_dentry)
 {
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:54.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:55.000000000 +0200
@@ -2488,14 +2488,15 @@ static int selinux_inode_create(struct p
 	return may_create(dir->dentry->d_inode, dentry, SECCLASS_FILE);
 }
 
-static int selinux_inode_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
+static int selinux_inode_link(struct dentry *old_dentry, struct path *dir,
+			      struct dentry *new_dentry)
 {
 	int rc;
 
 	rc = secondary_ops->inode_link(old_dentry, dir, new_dentry);
 	if (rc)
 		return rc;
-	return may_link(dir, old_dentry, MAY_LINK);
+	return may_link(dir->dentry->d_inode, old_dentry, MAY_LINK);
 }
 
 static int selinux_inode_unlink(struct path *dir, struct dentry *dentry)
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-29 12:20:55.000000000 +0200
@@ -412,7 +412,7 @@ static int smack_inode_init_security(str
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
+static int smack_inode_link(struct dentry *old_dentry, struct path *dir,
 			    struct dentry *new_dentry)
 {
 	int rc;

--
