Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbYEPQh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbYEPQh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbYEPQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:33:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33753 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbYEPQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:32:50 -0400
Message-Id: <20080516163235.249747827@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:51 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 15/22] vfs: add path_rmdir()
Content-Disposition: inline; filename=path_rmdir.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_rmdir().  Make vfs_rmdir() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c   |   13 +++++++------
 fs/namei.c            |   23 +++++++++++++++--------
 fs/nfsd/nfs4recover.c |    3 ++-
 fs/nfsd/vfs.c         |    4 +++-
 include/linux/fs.h    |    2 +-
 5 files changed, 28 insertions(+), 17 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-16 17:50:48.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-16 17:50:49.000000000 +0200
@@ -2231,7 +2231,7 @@ void dentry_unhash(struct dentry *dentry
 	spin_unlock(&dcache_lock);
 }
 
-int vfs_rmdir(struct inode *dir, struct dentry *dentry)
+static int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int error = may_delete(dir, dentry, 1);
 
@@ -2264,6 +2264,19 @@ int vfs_rmdir(struct inode *dir, struct 
 	return error;
 }
 
+int path_rmdir(struct path *dir_path, struct dentry *dentry)
+{
+	int error = mnt_want_write(dir_path->mnt);
+
+	if (!error) {
+		error = vfs_rmdir(dir_path->dentry->d_inode, dentry);
+		mnt_drop_write(dir_path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_rmdir);
+
 static long do_rmdir(int dfd, const char __user *pathname)
 {
 	int error = 0;
@@ -2295,12 +2308,7 @@ static long do_rmdir(int dfd, const char
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto exit3;
-	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
-	mnt_drop_write(nd.path.mnt);
-exit3:
+	error = path_rmdir(&nd.path, dentry);
 	dput(dentry);
 exit2:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
@@ -2995,7 +3003,6 @@ EXPORT_SYMBOL(vfs_link);
 EXPORT_SYMBOL(generic_permission);
 EXPORT_SYMBOL(vfs_readlink);
 EXPORT_SYMBOL(vfs_rename);
-EXPORT_SYMBOL(vfs_rmdir);
 EXPORT_SYMBOL(vfs_symlink);
 EXPORT_SYMBOL(vfs_unlink);
 EXPORT_SYMBOL(dentry_unhash);
Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-05-16 17:50:48.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-05-16 17:50:49.000000000 +0200
@@ -502,20 +502,21 @@ out:
 static int ecryptfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *lower_dentry;
-	struct dentry *lower_dir_dentry;
+	struct path lower_dir;
 	int rc;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	dget(dentry);
-	lower_dir_dentry = lock_parent(lower_dentry);
+	lower_dir.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+	lower_dir.dentry = lock_parent(lower_dentry);
 	dget(lower_dentry);
-	rc = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry);
+	rc = path_rmdir(&lower_dir, lower_dentry);
 	dput(lower_dentry);
 	if (!rc)
 		d_delete(lower_dentry);
-	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
-	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
-	unlock_dir(lower_dir_dentry);
+	fsstack_copy_attr_times(dir, lower_dir.dentry->d_inode);
+	dir->i_nlink = lower_dir.dentry->d_inode->i_nlink;
+	unlock_dir(lower_dir.dentry);
 	if (!rc)
 		d_drop(dentry);
 	dput(dentry);
Index: linux-2.6/fs/nfsd/nfs4recover.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs4recover.c	2008-05-16 17:50:48.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs4recover.c	2008-05-16 17:50:49.000000000 +0200
@@ -267,6 +267,7 @@ nfsd4_remove_clid_file(struct dentry *di
 static int
 nfsd4_clear_clid_dir(struct dentry *dir, struct dentry *dentry)
 {
+	struct path dir_path = { .dentry = dir, .mnt = rec_dir.path.mnt };
 	int status;
 
 	/* For now this directory should already be empty, but we empty it of
@@ -274,7 +275,7 @@ nfsd4_clear_clid_dir(struct dentry *dir,
 	 * a kernel from the future.... */
 	nfsd4_list_rec_dir(dentry, nfsd4_remove_clid_file);
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
-	status = vfs_rmdir(dir->d_inode, dentry);
+	status = path_rmdir(&dir_path, dentry);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	return status;
 }
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-16 17:50:48.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-16 17:50:49.000000000 +0200
@@ -1764,6 +1764,7 @@ __be32
 nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 				char *fname, int flen)
 {
+	struct path 	dir_path;
 	struct dentry	*dentry, *rdentry;
 	struct inode	*dirp;
 	__be32		err;
@@ -1798,6 +1799,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 	if (host_err)
 		goto out_nfserr;
 
+	fh_to_path(fhp, &dir_path);
 	if (type != S_IFDIR) { /* It's UNLINK */
 #ifdef MSNFS
 		if ((fhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
@@ -1807,7 +1809,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 #endif
 		host_err = vfs_unlink(dirp, rdentry);
 	} else { /* It's RMDIR */
-		host_err = vfs_rmdir(dirp, rdentry);
+		host_err = path_rmdir(&dir_path, rdentry);
 	}
 
 	dput(rdentry);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-16 17:50:48.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-16 17:50:49.000000000 +0200
@@ -1129,7 +1129,7 @@ extern int path_mkdir(struct path *, str
 extern int path_mknod(struct path *, struct dentry *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
-extern int vfs_rmdir(struct inode *, struct dentry *);
+extern int path_rmdir(struct path *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 

--
