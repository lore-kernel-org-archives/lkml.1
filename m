Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbYEPQjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbYEPQjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbYEPQdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:33:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33775 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbYEPQdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:33:01 -0400
Message-Id: <20080516163236.356498075@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:52 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 16/22] vfs: add path_unlink()
Content-Disposition: inline; filename=path_unlink.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_unlink().  Make vfs_unlink() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c   |   12 ++++++------
 fs/namei.c            |   22 +++++++++++++++-------
 fs/nfsd/nfs4recover.c |    3 ++-
 fs/nfsd/vfs.c         |   12 ++----------
 include/linux/fs.h    |    2 +-
 ipc/mqueue.c          |   10 +++++-----
 6 files changed, 31 insertions(+), 30 deletions(-)

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-05-16 17:50:49.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-05-16 17:50:49.000000000 +0200
@@ -415,22 +415,22 @@ static int ecryptfs_unlink(struct inode 
 {
 	int rc = 0;
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
-	struct dentry *lower_dir_dentry;
+	struct path lower_dir;
 
-	lower_dir_dentry = lock_parent(lower_dentry);
-	rc = vfs_unlink(lower_dir_inode, lower_dentry);
+	lower_dir.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+	lower_dir.dentry = lock_parent(lower_dentry);
+	rc = path_unlink(&lower_dir, lower_dentry);
 	if (rc) {
 		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
 		goto out_unlock;
 	}
-	fsstack_copy_attr_times(dir, lower_dir_inode);
+	fsstack_copy_attr_times(dir, lower_dir.dentry->d_inode);
 	dentry->d_inode->i_nlink =
 		ecryptfs_inode_to_lower(dentry->d_inode)->i_nlink;
 	dentry->d_inode->i_ctime = dir->i_ctime;
 	d_drop(dentry);
 out_unlock:
-	unlock_dir(lower_dir_dentry);
+	unlock_dir(lower_dir.dentry);
 	return rc;
 }
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-16 17:50:49.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-16 17:50:49.000000000 +0200
@@ -2324,7 +2324,7 @@ asmlinkage long sys_rmdir(const char __u
 	return do_rmdir(AT_FDCWD, pathname);
 }
 
-int vfs_unlink(struct inode *dir, struct dentry *dentry)
+static int vfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int error = may_delete(dir, dentry, 0);
 
@@ -2355,6 +2355,19 @@ int vfs_unlink(struct inode *dir, struct
 	return error;
 }
 
+int path_unlink(struct path *dir_path, struct dentry *dentry)
+{
+	int error = mnt_want_write(dir_path->mnt);
+
+	if (!error) {
+		error = vfs_unlink(dir_path->dentry->d_inode, dentry);
+		mnt_drop_write(dir_path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_unlink);
+
 /*
  * Make sure that the actual truncation of the file will occur outside its
  * directory's i_mutex.  Truncate can take a long time if there is a lot of
@@ -2389,11 +2402,7 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
-		error = mnt_want_write(nd.path.mnt);
-		if (error)
-			goto exit2;
-		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
-		mnt_drop_write(nd.path.mnt);
+		error = path_unlink(&nd.path, dentry);
 	exit2:
 		dput(dentry);
 	}
@@ -3004,6 +3013,5 @@ EXPORT_SYMBOL(generic_permission);
 EXPORT_SYMBOL(vfs_readlink);
 EXPORT_SYMBOL(vfs_rename);
 EXPORT_SYMBOL(vfs_symlink);
-EXPORT_SYMBOL(vfs_unlink);
 EXPORT_SYMBOL(dentry_unhash);
 EXPORT_SYMBOL(generic_readlink);
Index: linux-2.6/fs/nfsd/nfs4recover.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs4recover.c	2008-05-16 17:50:49.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs4recover.c	2008-05-16 17:50:49.000000000 +0200
@@ -252,6 +252,7 @@ out:
 static int
 nfsd4_remove_clid_file(struct dentry *dir, struct dentry *dentry)
 {
+	struct path dir_path = { .dentry = dir, .mnt = rec_dir.path.mnt };
 	int status;
 
 	if (!S_ISREG(dir->d_inode->i_mode)) {
@@ -259,7 +260,7 @@ nfsd4_remove_clid_file(struct dentry *di
 		return -EINVAL;
 	}
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
-	status = vfs_unlink(dir->d_inode, dentry);
+	status = path_unlink(&dir_path, dentry);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	return status;
 }
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-16 17:50:49.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-16 17:50:49.000000000 +0200
@@ -1766,7 +1766,6 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 {
 	struct path 	dir_path;
 	struct dentry	*dentry, *rdentry;
-	struct inode	*dirp;
 	__be32		err;
 	int		host_err;
 
@@ -1779,7 +1778,6 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 
 	fh_lock_nested(fhp, I_MUTEX_PARENT);
 	dentry = fhp->fh_dentry;
-	dirp = dentry->d_inode;
 
 	rdentry = lookup_one_len(fname, dentry, flen);
 	host_err = PTR_ERR(rdentry);
@@ -1795,10 +1793,6 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 	if (!type)
 		type = rdentry->d_inode->i_mode & S_IFMT;
 
-	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
-	if (host_err)
-		goto out_nfserr;
-
 	fh_to_path(fhp, &dir_path);
 	if (type != S_IFDIR) { /* It's UNLINK */
 #ifdef MSNFS
@@ -1807,7 +1801,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 			host_err = -EPERM;
 		} else
 #endif
-		host_err = vfs_unlink(dirp, rdentry);
+		host_err = path_unlink(&dir_path, rdentry);
 	} else { /* It's RMDIR */
 		host_err = path_rmdir(&dir_path, rdentry);
 	}
@@ -1815,12 +1809,10 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 	dput(rdentry);
 
 	if (host_err)
-		goto out_drop;
+		goto out_nfserr;
 	if (EX_ISSYNC(fhp->fh_export))
 		host_err = nfsd_sync_dir(dentry);
 
-out_drop:
-	mnt_drop_write(fhp->fh_export->ex_path.mnt);
 out_nfserr:
 	err = nfserrno(host_err);
 out:
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-16 17:50:49.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-16 17:50:49.000000000 +0200
@@ -1130,7 +1130,7 @@ extern int path_mknod(struct path *, str
 extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int path_rmdir(struct path *, struct dentry *);
-extern int vfs_unlink(struct inode *, struct dentry *);
+extern int path_unlink(struct path *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 
 /*
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2008-05-16 17:50:48.000000000 +0200
+++ linux-2.6/ipc/mqueue.c	2008-05-16 17:50:49.000000000 +0200
@@ -736,6 +736,7 @@ asmlinkage long sys_mq_unlink(const char
 	char *name;
 	struct dentry *dentry;
 	struct inode *inode = NULL;
+	struct path dir_path;
 
 	name = getname(u_name);
 	if (IS_ERR(name))
@@ -757,11 +758,10 @@ asmlinkage long sys_mq_unlink(const char
 	inode = dentry->d_inode;
 	if (inode)
 		atomic_inc(&inode->i_count);
-	err = mnt_want_write(mqueue_mnt);
-	if (err)
-		goto out_err;
-	err = vfs_unlink(dentry->d_parent->d_inode, dentry);
-	mnt_drop_write(mqueue_mnt);
+
+	dir_path.mnt = mqueue_mnt;
+	dir_path.dentry = dentry->d_parent;
+	err = path_unlink(&dir_path, dentry);
 out_err:
 	dput(dentry);
 

--
