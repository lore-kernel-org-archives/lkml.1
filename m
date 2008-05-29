Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbYE2Nxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbYE2Nxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYE2NvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46147 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbYE2NvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:51:05 -0400
Message-Id: <20080529135008.959754680@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:12 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 09/15] security: pass path to inode_setattr
Content-Disposition: inline; filename=security_setattr_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_setattr() security operation and related functions pass
the path (vfsmount + dentry) instead of the dentry.  AppArmor will need
this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/attr.c                  |    9 +++++----
 fs/fat/file.c              |    2 +-
 fs/namei.c                 |    2 +-
 fs/open.c                  |   17 +++++++++--------
 include/linux/fs.h         |    4 ++--
 include/linux/security.h   |    9 ++++-----
 mm/filemap.c               |   14 ++++----------
 security/dummy.c           |    2 +-
 security/security.c        |    6 +++---
 security/selinux/hooks.c   |    5 +++--
 security/smack/smack_lsm.c |    6 +++---
 11 files changed, 36 insertions(+), 40 deletions(-)

Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2008-05-29 12:20:15.000000000 +0200
+++ linux-2.6/fs/attr.c	2008-05-29 12:20:56.000000000 +0200
@@ -101,8 +101,9 @@ int inode_setattr(struct inode * inode, 
 }
 EXPORT_SYMBOL(inode_setattr);
 
-int notify_change(struct dentry * dentry, struct iattr * attr)
+int notify_change(struct path *path, struct iattr *attr)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	mode_t mode = inode->i_mode;
 	int error;
@@ -165,13 +166,13 @@ int notify_change(struct dentry * dentry
 		down_write(&dentry->d_inode->i_alloc_sem);
 
 	if (inode->i_op && inode->i_op->setattr) {
-		error = security_inode_setattr(dentry, attr);
+		error = security_inode_setattr(path, attr);
 		if (!error)
 			error = inode->i_op->setattr(dentry, attr);
 	} else {
 		error = inode_change_ok(inode, attr);
 		if (!error)
-			error = security_inode_setattr(dentry, attr);
+			error = security_inode_setattr(path, attr);
 		if (!error) {
 			if ((ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
 			    (ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid))
@@ -195,7 +196,7 @@ int path_setattr(struct path *path, stru
 	int error = mnt_want_write(path->mnt);
 
 	if (!error) {
-		error = notify_change(path->dentry, attr);
+		error = notify_change(path, attr);
 		mnt_drop_write(path->mnt);
 	}
 
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-05-29 12:20:49.000000000 +0200
+++ linux-2.6/fs/open.c	2008-05-29 12:20:56.000000000 +0200
@@ -197,16 +197,17 @@ out:
 
 /*
  * do_truncate - truncate (or extend) an inode
- * @dentry: the dentry to truncate
+ * @path: the path of the file to truncate
  * @length: the new length
  * @time_attrs: file times to be updated (e.g. ATTR_MTIME|ATTR_CTIME)
  * @filp: an open file or NULL (see file_truncate() as well)
  */
-int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
+int do_truncate(struct path *path, loff_t length, unsigned int time_attrs,
 	struct file *filp)
 {
 	int err;
 	struct iattr newattrs;
+	struct inode *inode = path->dentry->d_inode;
 
 	/* Not pretty: "inode->i_size" shouldn't really be signed. But it is. */
 	if (length < 0)
@@ -220,11 +221,11 @@ int do_truncate(struct dentry *dentry, l
 	}
 
 	/* Remove suid/sgid on truncate too */
-	newattrs.ia_valid |= should_remove_suid(dentry);
+	newattrs.ia_valid |= should_remove_suid(path->dentry);
 
-	mutex_lock(&dentry->d_inode->i_mutex);
-	err = notify_change(dentry, &newattrs);
-	mutex_unlock(&dentry->d_inode->i_mutex);
+	mutex_lock(&inode->i_mutex);
+	err = notify_change(path, &newattrs);
+	mutex_unlock(&inode->i_mutex);
 	return err;
 }
 
@@ -236,7 +237,7 @@ int do_truncate(struct dentry *dentry, l
  */
 int file_truncate(struct file *filp, loff_t length, unsigned int time_attrs)
 {
-	return do_truncate(filp->f_path.dentry, length, time_attrs, filp);
+	return do_truncate(&filp->f_path, length, time_attrs, filp);
 }
 
 static long do_sys_truncate(const char __user * path, loff_t length)
@@ -290,7 +291,7 @@ static long do_sys_truncate(const char _
 	error = locks_verify_truncate(inode, NULL, length);
 	if (!error) {
 		DQUOT_INIT(inode);
-		error = do_truncate(nd.path.dentry, length, 0, NULL);
+		error = do_truncate(&nd.path, length, 0, NULL);
 	}
 
 put_write_and_out:
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-29 12:20:51.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-29 12:20:56.000000000 +0200
@@ -1628,7 +1628,7 @@ static inline int break_lease(struct ino
 
 /* fs/open.c */
 
-extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
+extern int do_truncate(struct path *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
 extern int file_truncate(struct file *filp, loff_t start,
 			 unsigned int time_attrs);
@@ -1785,7 +1785,7 @@ extern int do_remount_sb(struct super_bl
 #ifdef CONFIG_BLOCK
 extern sector_t bmap(struct inode *, sector_t);
 #endif
-extern int notify_change(struct dentry *, struct iattr *);
+extern int notify_change(struct path *, struct iattr *);
 extern int path_setattr(struct path *, struct iattr *);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:56.000000000 +0200
@@ -413,7 +413,7 @@ static inline void security_free_mnt_opt
  *	call to notify_change is performed from several locations, whenever
  *	file attributes change (such as when a file is truncated, chown/chmod
  *	operations, transferring disk quotas, etc).
- *	@dentry contains the dentry structure for the file.
+ *	@path contains the path to the file.
  *	@attr is the iattr structure containing the new file attributes.
  *	Return 0 if permission is granted.
  * @inode_getattr:
@@ -1368,7 +1368,7 @@ struct security_operations {
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask);
-	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
+	int (*inode_setattr)	(struct path *path, struct iattr *attr);
 	int (*inode_getattr) (struct path *path);
 	void (*inode_delete) (struct inode *inode);
 	int (*inode_setxattr) (struct dentry *dentry, const char *name,
@@ -1640,7 +1640,7 @@ int security_inode_rename(struct path *o
 int security_inode_readlink(struct dentry *dentry);
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
 int security_inode_permission(struct inode *inode, int mask);
-int security_inode_setattr(struct dentry *dentry, struct iattr *attr);
+int security_inode_setattr(struct path *path, struct iattr *attr);
 int security_inode_getattr(struct path *path);
 void security_inode_delete(struct inode *inode);
 int security_inode_setxattr(struct dentry *dentry, const char *name,
@@ -2035,8 +2035,7 @@ static inline int security_inode_permiss
 	return 0;
 }
 
-static inline int security_inode_setattr(struct dentry *dentry,
-					  struct iattr *attr)
+static inline int security_inode_setattr(struct path *path, struct iattr *attr)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:56.000000000 +0200
@@ -348,7 +348,7 @@ static int dummy_inode_permission (struc
 	return 0;
 }
 
-static int dummy_inode_setattr (struct dentry *dentry, struct iattr *iattr)
+static int dummy_inode_setattr(struct path *path, struct iattr *iattr)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:56.000000000 +0200
@@ -471,11 +471,11 @@ int security_inode_permission(struct ino
 	return security_ops->inode_permission(inode, mask);
 }
 
-int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
+int security_inode_setattr(struct path *path, struct iattr *attr)
 {
-	if (unlikely(IS_PRIVATE(dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->inode_setattr(dentry, attr);
+	return security_ops->inode_setattr(path, attr);
 }
 EXPORT_SYMBOL_GPL(security_inode_setattr);
 
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:56.000000000 +0200
@@ -2579,11 +2579,12 @@ static int selinux_inode_permission(stru
 			       open_file_mask_to_av(inode->i_mode, mask), NULL);
 }
 
-static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
+static int selinux_inode_setattr(struct path *path, struct iattr *iattr)
 {
+	struct dentry *dentry = path->dentry;
 	int rc;
 
-	rc = secondary_ops->inode_setattr(dentry, iattr);
+	rc = secondary_ops->inode_setattr(path, iattr);
 	if (rc)
 		return rc;
 
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-29 12:20:56.000000000 +0200
@@ -534,12 +534,12 @@ static int smack_inode_permission(struct
 
 /**
  * smack_inode_setattr - Smack check for setting attributes
- * @dentry: the object
+ * @path: the object
  * @iattr: for the force flag
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
+static int smack_inode_setattr(struct path *path, struct iattr *iattr)
 {
 	/*
 	 * Need to allow for clearing the setuid bit.
@@ -547,7 +547,7 @@ static int smack_inode_setattr(struct de
 	if (iattr->ia_valid & ATTR_FORCE)
 		return 0;
 
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+	return smk_curacc(smk_of_inode(path->dentry->d_inode), MAY_WRITE);
 }
 
 /**
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:56.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:56.000000000 +0200
@@ -1691,7 +1691,7 @@ int may_open(struct nameidata *nd, int a
 		if (!error) {
 			DQUOT_INIT(inode);
 
-			error = do_truncate(dentry, 0,
+			error = do_truncate(&nd->path, 0,
 					    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
 					    NULL);
 		}
Index: linux-2.6/fs/fat/file.c
===================================================================
--- linux-2.6.orig/fs/fat/file.c	2008-05-29 12:20:15.000000000 +0200
+++ linux-2.6/fs/fat/file.c	2008-05-29 12:20:56.000000000 +0200
@@ -99,7 +99,7 @@ int fat_generic_ioctl(struct inode *inod
 		 * out the RO attribute for checking by the security
 		 * module, just because it maps to a file mode.
 		 */
-		err = security_inode_setattr(filp->f_path.dentry, &ia);
+		err = security_inode_setattr(&filp->f_path, &ia);
 		if (err)
 			goto up;
 
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2008-05-29 12:20:51.000000000 +0200
+++ linux-2.6/mm/filemap.c	2008-05-29 12:20:56.000000000 +0200
@@ -1660,14 +1660,6 @@ int should_remove_suid(struct dentry *de
 }
 EXPORT_SYMBOL(should_remove_suid);
 
-static int __remove_suid(struct dentry *dentry, int kill)
-{
-	struct iattr newattrs;
-
-	newattrs.ia_valid = ATTR_FORCE | kill;
-	return notify_change(dentry, &newattrs);
-}
-
 int file_remove_suid(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
@@ -1679,8 +1671,10 @@ int file_remove_suid(struct file *file)
 		return killpriv;
 	if (killpriv)
 		error = security_inode_killpriv(dentry);
-	if (!error && killsuid)
-		error = __remove_suid(dentry, killsuid);
+	if (!error && killsuid) {
+		struct iattr newattrs = {.ia_valid = ATTR_FORCE | killsuid };
+		error = notify_change(&file->f_path, &newattrs);
+	}
 
 	return error;
 }

--
