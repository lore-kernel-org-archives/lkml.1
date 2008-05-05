Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYEEKTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYEEKTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYEEKRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:17:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43906 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbYEEKRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:17:11 -0400
Message-Id: <20080505101649.190664701@szeredi.hu>
References: <20080505101621.216789969@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 05 May 2008 12:16:28 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 07/10] vfs: add path_rename()
Content-Disposition: inline; filename=path_rename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_rename().  Make vfs_rename() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |   22 ++++++++++++----------
 fs/namei.c          |   33 ++++++++++++++++++++++++---------
 fs/nfsd/vfs.c       |   19 +++++--------------
 include/linux/fs.h  |    3 ++-
 4 files changed, 43 insertions(+), 34 deletions(-)

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-05-05 11:29:32.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-05-05 11:29:32.000000000 +0200
@@ -555,25 +555,27 @@ ecryptfs_rename(struct inode *old_dir, s
 	int rc;
 	struct dentry *lower_old_dentry;
 	struct dentry *lower_new_dentry;
-	struct dentry *lower_old_dir_dentry;
-	struct dentry *lower_new_dir_dentry;
+	struct path lower_old_dir;
+	struct path lower_new_dir;
 
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
 	dget(lower_old_dentry);
 	dget(lower_new_dentry);
-	lower_old_dir_dentry = dget_parent(lower_old_dentry);
-	lower_new_dir_dentry = dget_parent(lower_new_dentry);
-	lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
-	rc = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
-			lower_new_dir_dentry->d_inode, lower_new_dentry);
+	lower_old_dir.mnt = ecryptfs_dentry_to_lower_mnt(old_dentry);
+	lower_old_dir.dentry = dget_parent(lower_old_dentry);
+	lower_new_dir.mnt = ecryptfs_dentry_to_lower_mnt(new_dentry);
+	lower_new_dir.dentry = dget_parent(lower_new_dentry);
+	lock_rename(lower_old_dir.dentry, lower_new_dir.dentry);
+	rc = path_rename(&lower_old_dir, lower_old_dentry,
+			 &lower_new_dir, lower_new_dentry);
 	if (rc)
 		goto out_lock;
-	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode, NULL);
+	fsstack_copy_attr_all(new_dir, lower_new_dir.dentry->d_inode, NULL);
 	if (new_dir != old_dir)
-		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode, NULL);
+		fsstack_copy_attr_all(old_dir, lower_old_dir.dentry->d_inode, NULL);
 out_lock:
-	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
+	unlock_rename(lower_old_dir.dentry, lower_new_dir.dentry);
 	dput(lower_new_dentry->d_parent);
 	dput(lower_old_dentry->d_parent);
 	dput(lower_new_dentry);
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-05 11:29:32.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-05 11:29:32.000000000 +0200
@@ -2729,8 +2729,8 @@ static int vfs_rename_other(struct inode
 	return error;
 }
 
-int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-	       struct inode *new_dir, struct dentry *new_dentry)
+static int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+		      struct inode *new_dir, struct dentry *new_dentry)
 {
 	int error;
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
@@ -2772,6 +2772,27 @@ int vfs_rename(struct inode *old_dir, st
 	return error;
 }
 
+int path_rename(struct path *old_dir_path, struct dentry *old_dentry,
+		struct path *new_dir_path, struct dentry *new_dentry)
+{
+	int error;
+	struct vfsmount *mnt = old_dir_path->mnt;
+
+	BUG_ON(mnt != new_dir_path->mnt);
+
+	error = mnt_want_write(mnt);
+	if (!error) {
+		struct inode *old_dir = old_dir_path->dentry->d_inode;
+		struct inode *new_dir = new_dir_path->dentry->d_inode;
+
+		error = vfs_rename(old_dir, old_dentry, new_dir, new_dentry);
+		mnt_drop_write(mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_rename);
+
 static int do_rename(int olddfd, const char *oldname,
 			int newdfd, const char *newname)
 {
@@ -2833,12 +2854,7 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
-	error = mnt_want_write(oldnd.path.mnt);
-	if (error)
-		goto exit5;
-	error = vfs_rename(old_dir->d_inode, old_dentry,
-				   new_dir->d_inode, new_dentry);
-	mnt_drop_write(oldnd.path.mnt);
+	error = path_rename(&oldnd.path, old_dentry, &newnd.path, new_dentry);
 exit5:
 	dput(new_dentry);
 exit4:
@@ -3029,6 +3045,5 @@ EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_follow_link);
 EXPORT_SYMBOL(generic_permission);
 EXPORT_SYMBOL(vfs_readlink);
-EXPORT_SYMBOL(vfs_rename);
 EXPORT_SYMBOL(dentry_unhash);
 EXPORT_SYMBOL(generic_readlink);
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-05 11:29:32.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-05 11:29:32.000000000 +0200
@@ -1650,8 +1650,9 @@ __be32
 nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 			    struct svc_fh *tfhp, char *tname, int tlen)
 {
+	struct path 	old_dir_path;
+	struct path	new_dir_path;
 	struct dentry	*fdentry, *tdentry, *odentry, *ndentry, *trap;
-	struct inode	*fdir, *tdir;
 	__be32		err;
 	int		host_err;
 
@@ -1663,10 +1664,7 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 		goto out;
 
 	fdentry = ffhp->fh_dentry;
-	fdir = fdentry->d_inode;
-
 	tdentry = tfhp->fh_dentry;
-	tdir = tdentry->d_inode;
 
 	err = (rqstp->rq_vers == 2) ? nfserr_acces : nfserr_xdev;
 	if (ffhp->fh_export != tfhp->fh_export)
@@ -1710,22 +1708,15 @@ nfsd_rename(struct svc_rqst *rqstp, stru
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
+	fh_to_path(ffhp, &old_dir_path);
+	fh_to_path(tfhp, &new_dir_path);
+	host_err = path_rename(&old_dir_path, odentry, &new_dir_path, ndentry);
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
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-05 11:29:32.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-05 11:29:32.000000000 +0200
@@ -1131,7 +1131,8 @@ extern int path_symlink(struct path *, s
 extern int path_link(struct dentry *, struct path *, struct dentry *);
 extern int path_rmdir(struct path *, struct dentry *);
 extern int path_unlink(struct path *, struct dentry *);
-extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int path_rename(struct path *, struct dentry *,
+		       struct path *, struct dentry *);
 
 /*
  * VFS dentry helper functions.

--
