Return-Path: <linux-kernel-owner+w=401wt.eu-S936583AbYEURXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936583AbYEURXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936001AbYEURQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:16:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33088 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935731AbYEURQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:16:15 -0400
Message-Id: <20080521171600.082178318@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:11 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 13/14] vfs: dont use dentry_permission()
Content-Disposition: inline; filename=path_permission_dentry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move most calls of dentry_permission() to path_permission().  The
remaining few uses are all in namei.c, so dentry_permission() can be
made static, further simplifying the API.

This will have the side effect, that MNT_NOEXEC checking on the mount
will be performed for these callers as well.  But this should not
cause any problems.

At this point file_permission() is just a helper for
path_permission(), so remove comment about not being preferred.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |    7 +++++--
 fs/namei.c          |   12 +++---------
 fs/nfsd/nfsfh.c     |   11 ++++++-----
 fs/nfsd/vfs.c       |    8 ++++++--
 fs/xattr.c          |   22 ++++++++++++----------
 include/linux/fs.h  |    1 -
 ipc/mqueue.c        |   15 +++++++++------
 7 files changed, 41 insertions(+), 35 deletions(-)

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-05-21 18:16:31.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-05-21 18:17:08.000000000 +0200
@@ -810,9 +810,12 @@ out:
 static int
 ecryptfs_permission(struct dentry *dentry, int mask, int flags)
 {
-	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	struct path lower_path;
+
+	lower_path.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+	lower_path.dentry = ecryptfs_dentry_to_lower(dentry);
 
-	return dentry_permission(lower_dentry, mask, flags);
+	return path_permission(&lower_path, mask, flags);
 }
 
 /**
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-21 18:16:31.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-21 18:17:08.000000000 +0200
@@ -246,7 +246,7 @@ int exec_permission(struct inode *inode,
 	return 0;
 }
 
-int dentry_permission(struct dentry *dentry, int mask, int flags)
+static int dentry_permission(struct dentry *dentry, int mask, int flags)
 {
 	struct inode *inode = dentry->d_inode;
 	int retval, submask;
@@ -320,16 +320,11 @@ int path_permission(struct path *path, i
  * @file:	file to check access rights for
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  *
- * Used to check for read/write/execute permissions on an already opened
- * file.
- *
- * Note:
- *	Do not use this function in new code.  All access checks should
- *	be done using path_permission().
+ * This is a helper for path_permission().
  */
 int file_permission(struct file *file, int mask)
 {
-	return dentry_permission(file->f_path.dentry, mask, 0);
+	return path_permission(&file->f_path, mask, 0);
 }
 
 /*
@@ -3061,7 +3056,6 @@ EXPORT_SYMBOL(page_symlink);
 EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(vfs_path_lookup);
-EXPORT_SYMBOL(dentry_permission);
 EXPORT_SYMBOL(path_permission);
 EXPORT_SYMBOL(file_permission);
 EXPORT_SYMBOL(unlock_rename);
Index: linux-2.6/fs/nfsd/nfsfh.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsfh.c	2008-05-21 18:16:31.000000000 +0200
+++ linux-2.6/fs/nfsd/nfsfh.c	2008-05-21 18:17:08.000000000 +0200
@@ -41,7 +41,7 @@ static int nfsd_acceptable(void *expv, s
 	struct svc_export *exp = expv;
 	int rv;
 	struct dentry *tdentry;
-	struct dentry *parent;
+	struct path parent = { .mnt = exp->ex_path.mnt };
 
 	if (exp->ex_flags & NFSEXP_NOSUBTREECHECK)
 		return 1;
@@ -50,14 +50,15 @@ static int nfsd_acceptable(void *expv, s
 	while (tdentry != exp->ex_path.dentry && !IS_ROOT(tdentry)) {
 		/* make sure parents give x permission to user */
 		int err;
-		parent = dget_parent(tdentry);
-		err = dentry_permission(parent, MAY_EXEC, 0);
+
+		parent.dentry = dget_parent(tdentry);
+		err = path_permission(&parent, MAY_EXEC, 0);
 		if (err < 0) {
-			dput(parent);
+			dput(parent.dentry);
 			break;
 		}
 		dput(tdentry);
-		tdentry = parent;
+		tdentry = parent.dentry;
 	}
 	if (tdentry != exp->ex_path.dentry)
 		dprintk("nfsd_acceptable failed at %p %s\n", tdentry, tdentry->d_name.name);
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-21 18:16:31.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-21 18:17:08.000000000 +0200
@@ -1878,6 +1878,10 @@ nfsd_permission(struct svc_rqst *rqstp, 
 {
 	struct inode	*inode = dentry->d_inode;
 	int		err;
+	struct path	path = {
+		.mnt = exp->ex_path.mnt,
+		.dentry = dentry,
+	};
 
 	if (acc == MAY_NOP)
 		return 0;
@@ -1942,12 +1946,12 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	    inode->i_uid == current->fsuid)
 		return 0;
 
-	err = dentry_permission(dentry, acc & (MAY_READ|MAY_WRITE|MAY_EXEC), 0);
+	err = path_permission(&path, acc & (MAY_READ|MAY_WRITE|MAY_EXEC), 0);
 
 	/* Allow read access to binaries even when mode 111 */
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
 	    acc == (MAY_READ | MAY_OWNER_OVERRIDE))
-		err = dentry_permission(dentry, MAY_EXEC, 0);
+		err = path_permission(&path, MAY_EXEC, 0);
 
 	return err? nfserrno(err) : 0;
 }
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2008-05-21 18:16:31.000000000 +0200
+++ linux-2.6/ipc/mqueue.c	2008-05-21 18:17:08.000000000 +0200
@@ -647,19 +647,22 @@ static struct file *do_open(struct dentr
 static int oflag2acc[O_ACCMODE] = { MAY_READ, MAY_WRITE,
 					MAY_READ | MAY_WRITE };
 
+	struct path path = {
+		.mnt = mqueue_mnt,
+		.dentry = dentry,
+	};
+
 	if ((oflag & O_ACCMODE) == (O_RDWR | O_WRONLY)) {
-		dput(dentry);
-		mntput(mqueue_mnt);
+		path_put(&path);
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (dentry_permission(dentry, oflag2acc[oflag & O_ACCMODE], 0)) {
-		dput(dentry);
-		mntput(mqueue_mnt);
+	if (path_permission(&path, oflag2acc[oflag & O_ACCMODE], 0)) {
+		path_put(&path);
 		return ERR_PTR(-EACCES);
 	}
 
-	return dentry_open(dentry, mqueue_mnt, oflag);
+	return dentry_open(path.dentry, path.mnt, oflag);
 }
 
 asmlinkage long sys_mq_open(const char __user *u_name, int oflag, mode_t mode,
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-21 18:16:31.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-21 18:17:08.000000000 +0200
@@ -26,9 +26,9 @@
  * because different namespaces have very different rules.
  */
 static int
-xattr_permission(struct dentry *dentry, const char *name, int mask)
+xattr_permission(struct path *path, const char *name, int mask)
 {
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = path->dentry->d_inode;
 
 	/*
 	 * We can never set or remove an extended attribute on a read-only
@@ -65,17 +65,18 @@ xattr_permission(struct dentry *dentry, 
 			return -EPERM;
 	}
 
-	return dentry_permission(dentry, mask, 0);
+	return path_permission(path, mask, 0);
 }
 
 static int
-vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+vfs_setxattr(struct path *path, const char *name, const void *value,
 		size_t size, int flags)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	error = xattr_permission(dentry, name, MAY_WRITE);
+	error = xattr_permission(path, name, MAY_WRITE);
 	if (error)
 		return error;
 
@@ -110,7 +111,7 @@ int path_setxattr(struct path *path, con
 	int error = mnt_want_write(path->mnt);
 
 	if (!error) {
-		error = vfs_setxattr(path->dentry, name, value, size, flags);
+		error = vfs_setxattr(path, name, value, size, flags);
 		mnt_drop_write(path->mnt);
 	}
 
@@ -152,7 +153,7 @@ path_getxattr(struct path *path, const c
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	error = xattr_permission(dentry, name, MAY_READ);
+	error = xattr_permission(path, name, MAY_READ);
 	if (error)
 		return error;
 
@@ -204,15 +205,16 @@ path_listxattr(struct path *path, char *
 EXPORT_SYMBOL_GPL(path_listxattr);
 
 static int
-vfs_removexattr(struct dentry *dentry, const char *name)
+vfs_removexattr(struct path *path, const char *name)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
 	if (!inode->i_op->removexattr)
 		return -EOPNOTSUPP;
 
-	error = xattr_permission(dentry, name, MAY_WRITE);
+	error = xattr_permission(path, name, MAY_WRITE);
 	if (error)
 		return error;
 
@@ -234,7 +236,7 @@ int path_removexattr(struct path *path, 
 	int error = mnt_want_write(path->mnt);
 
 	if (!error) {
-		error = vfs_removexattr(path->dentry, name);
+		error = vfs_removexattr(path, name);
 		mnt_drop_write(path->mnt);
 	}
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-21 18:15:02.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-21 18:17:08.000000000 +0200
@@ -1758,7 +1758,6 @@ extern sector_t bmap(struct inode *, sec
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int path_setattr(struct path *, struct iattr *);
-extern int dentry_permission(struct dentry *, int, int);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 extern int exec_permission(struct inode *, int);

--
