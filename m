Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYGVWQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYGVWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbYGVWNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:13:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59098 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbYGVWNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:13:34 -0400
Message-Id: <20080722221330.302809639@szeredi.hu>
References: <20080722221259.866628660@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 23 Jul 2008 00:13:08 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [patch 09/14] vfs: add path_symlink()
Content-Disposition: inline; filename=vfs-add-path_symlink.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_symlink().  Make vfs_symlink() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |   14 +++++++-------
 fs/namei.c          |   26 ++++++++++++++++++--------
 fs/nfsd/vfs.c       |   12 ++++--------
 include/linux/fs.h  |    2 +-
 4 files changed, 30 insertions(+), 24 deletions(-)

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-07-23 00:10:23.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-07-23 00:10:24.000000000 +0200
@@ -439,14 +439,15 @@ static int ecryptfs_symlink(struct inode
 {
 	int rc;
 	struct dentry *lower_dentry;
-	struct dentry *lower_dir_dentry;
+	struct path lower_dir;
 	char *encoded_symname;
 	int encoded_symlen;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	dget(lower_dentry);
-	lower_dir_dentry = lock_parent(lower_dentry);
+	lower_dir.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+	lower_dir.dentry = lock_parent(lower_dentry);
 	encoded_symlen = ecryptfs_encode_filename(crypt_stat, symname,
 						  strlen(symname),
 						  &encoded_symname);
@@ -454,18 +455,17 @@ static int ecryptfs_symlink(struct inode
 		rc = encoded_symlen;
 		goto out_lock;
 	}
-	rc = vfs_symlink(lower_dir_dentry->d_inode, lower_dentry,
-			 encoded_symname);
+	rc = path_symlink(&lower_dir, lower_dentry, encoded_symname);
 	kfree(encoded_symname);
 	if (rc || !lower_dentry->d_inode)
 		goto out_lock;
 	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
 	if (rc)
 		goto out_lock;
-	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
-	fsstack_copy_inode_size(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_attr_times(dir, lower_dir.dentry->d_inode);
+	fsstack_copy_inode_size(dir, lower_dir.dentry->d_inode);
 out_lock:
-	unlock_dir(lower_dir_dentry);
+	unlock_dir(lower_dir.dentry);
 	dput(lower_dentry);
 	if (!dentry->d_inode)
 		d_drop(dentry);
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-07-23 00:10:23.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-07-23 00:10:24.000000000 +0200
@@ -2358,7 +2358,7 @@ asmlinkage long sys_unlink(const char __
 	return do_unlinkat(AT_FDCWD, pathname);
 }
 
-int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
+static int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2379,6 +2379,22 @@ int vfs_symlink(struct inode *dir, struc
 	return error;
 }
 
+int path_symlink(struct path *dir_path, struct dentry *dentry,
+		 const char *oldname)
+{
+	int error = mnt_want_write(dir_path->mnt);
+
+	if (!error) {
+		struct inode *dir = dir_path->dentry->d_inode;
+
+		error = vfs_symlink(dir, dentry, oldname);
+		mnt_drop_write(dir_path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_symlink);
+
 asmlinkage long sys_symlinkat(const char __user *oldname,
 			      int newdfd, const char __user *newname)
 {
@@ -2404,12 +2420,7 @@ asmlinkage long sys_symlinkat(const char
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto out_dput;
-	error = vfs_symlink(nd.path.dentry->d_inode, dentry, from);
-	mnt_drop_write(nd.path.mnt);
-out_dput:
+	error = path_symlink(&nd.path, dentry, from);
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
@@ -2934,6 +2945,5 @@ EXPORT_SYMBOL(vfs_link);
 EXPORT_SYMBOL(generic_permission);
 EXPORT_SYMBOL(vfs_readlink);
 EXPORT_SYMBOL(vfs_rename);
-EXPORT_SYMBOL(vfs_symlink);
 EXPORT_SYMBOL(dentry_unhash);
 EXPORT_SYMBOL(generic_readlink);
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-07-23 00:10:23.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-07-23 00:10:24.000000000 +0200
@@ -1520,6 +1520,7 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 				struct svc_fh *resfhp,
 				struct iattr *iap)
 {
+	struct path 	dir_path;
 	struct dentry	*dentry, *dnew;
 	__be32		err, cerr;
 	int		host_err;
@@ -1541,10 +1542,7 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	if (IS_ERR(dnew))
 		goto out_nfserr;
 
-	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
-	if (host_err)
-		goto out_nfserr;
-
+	fh_to_path(fhp, &dir_path);
 	if (unlikely(path[plen] != 0)) {
 		char *path_alloced = kmalloc(plen+1, GFP_KERNEL);
 		if (path_alloced == NULL)
@@ -1552,11 +1550,11 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 		else {
 			strncpy(path_alloced, path, plen);
 			path_alloced[plen] = 0;
-			host_err = vfs_symlink(dentry->d_inode, dnew, path_alloced);
+			host_err = path_symlink(&dir_path, dnew, path_alloced);
 			kfree(path_alloced);
 		}
 	} else
-		host_err = vfs_symlink(dentry->d_inode, dnew, path);
+		host_err = path_symlink(&dir_path, dnew, path);
 
 	if (!host_err) {
 		if (EX_ISSYNC(fhp->fh_export))
@@ -1565,8 +1563,6 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	err = nfserrno(host_err);
 	fh_unlock(fhp);
 
-	mnt_drop_write(fhp->fh_export->ex_path.mnt);
-
 	cerr = fh_compose(resfhp, fhp->fh_export, dnew, fhp);
 	dput(dnew);
 	if (err==0) err = cerr;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-07-23 00:10:23.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-07-23 00:10:24.000000000 +0200
@@ -1129,7 +1129,7 @@ extern int vfs_permission(struct nameida
 extern int path_create(struct path *, struct dentry *, int, struct nameidata *);
 extern int path_mkdir(struct path *, struct dentry *, int);
 extern int path_mknod(struct path *, struct dentry *, int, dev_t);
-extern int vfs_symlink(struct inode *, struct dentry *, const char *);
+extern int path_symlink(struct path *, struct dentry *, const char *);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int path_rmdir(struct path *, struct dentry *);
 extern int path_unlink(struct path *, struct dentry *);

--
