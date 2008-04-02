Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbYDBUQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbYDBUQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760808AbYDBUPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:15:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34971 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbYDBUOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:14:20 -0400
Message-Id: <20080402201330.689695350@szeredi.hu>
References: <20080402201247.358430231@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 02 Apr 2008 22:12:54 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 07/10] vfs: add path_rename()
Content-Disposition: inline; filename=path_rename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_rename().  Make vfs_rename() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |   13 +++++++------
 fs/namei.c          |   27 +++++++++++++++++++--------
 fs/nfsd/vfs.c       |   17 +++++------------
 include/linux/fs.h  |    2 +-
 4 files changed, 32 insertions(+), 27 deletions(-)

Index: vfs-2.6/fs/ecryptfs/inode.c
===================================================================
--- vfs-2.6.orig/fs/ecryptfs/inode.c	2008-04-02 21:36:43.000000000 +0200
+++ vfs-2.6/fs/ecryptfs/inode.c	2008-04-02 21:37:52.000000000 +0200
@@ -559,25 +559,26 @@ ecryptfs_rename(struct inode *old_dir, s
 	int rc;
 	struct dentry *lower_old_dentry;
 	struct dentry *lower_new_dentry;
-	struct dentry *lower_old_dir_dentry;
+	struct path lower_old_dir;
 	struct dentry *lower_new_dir_dentry;
 
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
 	dget(lower_old_dentry);
 	dget(lower_new_dentry);
-	lower_old_dir_dentry = dget_parent(lower_old_dentry);
+	lower_old_dir.mnt = ecryptfs_dentry_to_lower_mnt(old_dentry);
+	lower_old_dir.dentry = dget_parent(lower_old_dentry);
 	lower_new_dir_dentry = dget_parent(lower_new_dentry);
-	lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
-	rc = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
+	lock_rename(lower_old_dir.dentry, lower_new_dir_dentry);
+	rc = path_rename(&lower_old_dir, lower_old_dentry,
 			lower_new_dir_dentry->d_inode, lower_new_dentry);
 	if (rc)
 		goto out_lock;
 	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode, NULL);
 	if (new_dir != old_dir)
-		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode, NULL);
+		fsstack_copy_attr_all(old_dir, lower_old_dir.dentry->d_inode, NULL);
 out_lock:
-	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
+	unlock_rename(lower_old_dir.dentry, lower_new_dir_dentry);
 	dput(lower_new_dentry->d_parent);
 	dput(lower_old_dentry->d_parent);
 	dput(lower_new_dentry);
Index: vfs-2.6/fs/namei.c
===================================================================
--- vfs-2.6.orig/fs/namei.c	2008-04-02 21:36:43.000000000 +0200
+++ vfs-2.6/fs/namei.c	2008-04-02 21:38:45.000000000 +0200
@@ -2723,8 +2723,8 @@ static int vfs_rename_other(struct inode
 	return error;
 }
 
-int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-	       struct inode *new_dir, struct dentry *new_dentry)
+static int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+		      struct inode *new_dir, struct dentry *new_dentry)
 {
 	int error;
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
@@ -2766,6 +2766,22 @@ int vfs_rename(struct inode *old_dir, st
 	return error;
 }
 
+int path_rename(struct path *old_dir_path, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
+{
+	int error = mnt_want_write(old_dir_path->mnt);
+
+	if (!error) {
+		struct inode *old_dir = old_dir_path->dentry->d_inode;
+
+		error = vfs_rename(old_dir, old_dentry, new_dir, new_dentry);
+		mnt_drop_write(old_dir_path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_rename);
+
 static int do_rename(int olddfd, const char *oldname,
 			int newdfd, const char *newname)
 {
@@ -2827,12 +2843,8 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
-	error = mnt_want_write(oldnd.path.mnt);
-	if (error)
-		goto exit5;
-	error = vfs_rename(old_dir->d_inode, old_dentry,
+	error = path_rename(&oldnd.path, old_dentry,
 				   new_dir->d_inode, new_dentry);
-	mnt_drop_write(oldnd.path.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
@@ -3023,7 +3035,6 @@ EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_follow_link);
 EXPORT_SYMBOL(generic_permission);
 EXPORT_SYMBOL(vfs_readlink);
-EXPORT_SYMBOL(vfs_rename);
 EXPORT_SYMBOL(vfs_rmdir);
 EXPORT_SYMBOL(dentry_unhash);
 EXPORT_SYMBOL(generic_readlink);
Index: vfs-2.6/fs/nfsd/vfs.c
===================================================================
--- vfs-2.6.orig/fs/nfsd/vfs.c	2008-04-02 21:36:43.000000000 +0200
+++ vfs-2.6/fs/nfsd/vfs.c	2008-04-02 21:37:52.000000000 +0200
@@ -1633,8 +1633,9 @@ __be32
 nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 			    struct svc_fh *tfhp, char *tname, int tlen)
 {
+	struct path 	old_dir_path;
 	struct dentry	*fdentry, *tdentry, *odentry, *ndentry, *trap;
-	struct inode	*fdir, *tdir;
+	struct inode	*tdir;
 	__be32		err;
 	int		host_err;
 
@@ -1646,7 +1647,6 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 		goto out;
 
 	fdentry = ffhp->fh_dentry;
-	fdir = fdentry->d_inode;
 
 	tdentry = tfhp->fh_dentry;
 	tdir = tdentry->d_inode;
@@ -1693,22 +1693,15 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 			goto out_dput_new;
 	}
 
-	host_err = -EXDEV;
-	if (ffhp->fh_export->ex_path.mnt != tfhp->fh_export->ex_path.mnt)
-		goto out_dput_new;
-	host_err = mnt_want_write(ffhp->fh_export->ex_path.mnt);
-	if (host_err)
-		goto out_dput_new;
-
-	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
+	old_dir_path.mnt = ffhp->fh_export->ex_path.mnt;
+	old_dir_path.dentry = fdentry;
+	host_err = path_rename(&old_dir_path, odentry, tdir, ndentry);
 	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
 		host_err = nfsd_sync_dir(tdentry);
 		if (!host_err)
 			host_err = nfsd_sync_dir(fdentry);
 	}
 
-	mnt_drop_write(ffhp->fh_export->ex_path.mnt);
-
  out_dput_new:
 	dput(ndentry);
  out_dput_old:
Index: vfs-2.6/include/linux/fs.h
===================================================================
--- vfs-2.6.orig/include/linux/fs.h	2008-04-02 21:36:43.000000000 +0200
+++ vfs-2.6/include/linux/fs.h	2008-04-02 21:37:52.000000000 +0200
@@ -1132,7 +1132,7 @@ extern int path_link(struct dentry *, st
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int path_rmdir(struct path *, struct dentry *);
 extern int path_unlink(struct path *, struct dentry *);
-extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int path_rename(struct path *, struct dentry *, struct inode *, struct dentry *);
 
 /*
  * VFS dentry helper functions.

--
