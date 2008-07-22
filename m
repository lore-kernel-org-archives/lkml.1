Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYGVWQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYGVWQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbYGVWNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:13:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59100 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbYGVWNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:13:35 -0400
Message-Id: <20080722221331.746623740@szeredi.hu>
References: <20080722221259.866628660@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 23 Jul 2008 00:13:09 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [patch 10/14] vfs: add path_link()
Content-Disposition: inline; filename=vfs-add-path_link.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_link().  Make vfs_link() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |   10 +++++-----
 fs/namei.c          |   26 ++++++++++++++++++--------
 fs/nfsd/vfs.c       |   14 ++++----------
 include/linux/fs.h  |    2 +-
 4 files changed, 28 insertions(+), 24 deletions(-)

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-07-23 00:10:24.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-07-23 00:10:25.000000000 +0200
@@ -379,7 +379,7 @@ static int ecryptfs_link(struct dentry *
 {
 	struct dentry *lower_old_dentry;
 	struct dentry *lower_new_dentry;
-	struct dentry *lower_dir_dentry;
+	struct path lower_dir;
 	u64 file_size_save;
 	int rc;
 
@@ -388,9 +388,9 @@ static int ecryptfs_link(struct dentry *
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
 	dget(lower_old_dentry);
 	dget(lower_new_dentry);
-	lower_dir_dentry = lock_parent(lower_new_dentry);
-	rc = vfs_link(lower_old_dentry, lower_dir_dentry->d_inode,
-		      lower_new_dentry);
+	lower_dir.mnt = ecryptfs_dentry_to_lower_mnt(new_dentry);
+	lower_dir.dentry = lock_parent(lower_new_dentry);
+	rc = path_link(lower_old_dentry, &lower_dir, lower_new_dentry);
 	if (rc || !lower_new_dentry->d_inode)
 		goto out_lock;
 	rc = ecryptfs_interpose(lower_new_dentry, new_dentry, dir->i_sb, 0);
@@ -402,7 +402,7 @@ static int ecryptfs_link(struct dentry *
 		ecryptfs_inode_to_lower(old_dentry->d_inode)->i_nlink;
 	i_size_write(new_dentry->d_inode, file_size_save);
 out_lock:
-	unlock_dir(lower_dir_dentry);
+	unlock_dir(lower_dir.dentry);
 	dput(lower_new_dentry);
 	dput(lower_old_dentry);
 	d_drop(lower_old_dentry);
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-07-23 00:10:24.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-07-23 00:10:25.000000000 +0200
@@ -2437,7 +2437,7 @@ asmlinkage long sys_symlink(const char _
 	return sys_symlinkat(oldname, AT_FDCWD, newname);
 }
 
-int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
+static int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
 	int error;
@@ -2475,6 +2475,22 @@ int vfs_link(struct dentry *old_dentry, 
 	return error;
 }
 
+int path_link(struct dentry *old_dentry, struct path *dir_path,
+	      struct dentry *new_dentry)
+{
+	int error = mnt_want_write(dir_path->mnt);
+
+	if (!error) {
+		struct inode *dir = dir_path->dentry->d_inode;
+
+		error = vfs_link(old_dentry, dir, new_dentry);
+		mnt_drop_write(dir_path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_link);
+
 /*
  * Hardlinks are often used in delicate situations.  We avoid
  * security-related surprises by not following symlinks on the
@@ -2516,12 +2532,7 @@ asmlinkage long sys_linkat(int olddfd, c
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out_unlock;
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto out_dput;
-	error = vfs_link(old_path.dentry, nd.path.dentry->d_inode, new_dentry);
-	mnt_drop_write(nd.path.mnt);
-out_dput:
+	error = path_link(old_path.dentry, &nd.path, new_dentry);
 	dput(new_dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
@@ -2941,7 +2952,6 @@ EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
 EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_follow_link);
-EXPORT_SYMBOL(vfs_link);
 EXPORT_SYMBOL(generic_permission);
 EXPORT_SYMBOL(vfs_readlink);
 EXPORT_SYMBOL(vfs_rename);
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-07-23 00:10:24.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-07-23 00:10:25.000000000 +0200
@@ -1582,8 +1582,9 @@ __be32
 nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 				char *name, int len, struct svc_fh *tfhp)
 {
+	struct path 	dir_path;
 	struct dentry	*ddir, *dnew, *dold;
-	struct inode	*dirp, *dest;
+	struct inode	*dest;
 	__be32		err;
 	int		host_err;
 
@@ -1603,7 +1604,6 @@ nfsd_link(struct svc_rqst *rqstp, struct
 
 	fh_lock_nested(ffhp, I_MUTEX_PARENT);
 	ddir = ffhp->fh_dentry;
-	dirp = ddir->d_inode;
 
 	dnew = lookup_one_len(name, ddir, len);
 	host_err = PTR_ERR(dnew);
@@ -1613,12 +1613,8 @@ nfsd_link(struct svc_rqst *rqstp, struct
 	dold = tfhp->fh_dentry;
 	dest = dold->d_inode;
 
-	host_err = mnt_want_write(tfhp->fh_export->ex_path.mnt);
-	if (host_err) {
-		err = nfserrno(host_err);
-		goto out_dput;
-	}
-	host_err = vfs_link(dold, dirp, dnew);
+	fh_to_path(ffhp, &dir_path);
+	host_err = path_link(dold, &dir_path, dnew);
 	if (!host_err) {
 		if (EX_ISSYNC(ffhp->fh_export)) {
 			err = nfserrno(nfsd_sync_dir(ddir));
@@ -1631,8 +1627,6 @@ nfsd_link(struct svc_rqst *rqstp, struct
 		else
 			err = nfserrno(host_err);
 	}
-	mnt_drop_write(tfhp->fh_export->ex_path.mnt);
-out_dput:
 	dput(dnew);
 out_unlock:
 	fh_unlock(ffhp);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-07-23 00:10:24.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-07-23 00:10:25.000000000 +0200
@@ -1130,7 +1130,7 @@ extern int path_create(struct path *, st
 extern int path_mkdir(struct path *, struct dentry *, int);
 extern int path_mknod(struct path *, struct dentry *, int, dev_t);
 extern int path_symlink(struct path *, struct dentry *, const char *);
-extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
+extern int path_link(struct dentry *, struct path *, struct dentry *);
 extern int path_rmdir(struct path *, struct dentry *);
 extern int path_unlink(struct path *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);

--
