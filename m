Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYDBUOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYDBUOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbYDBUN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:13:59 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34950 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbYDBUN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:13:57 -0400
Message-Id: <20080402201322.317327738@szeredi.hu>
References: <20080402201247.358430231@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 02 Apr 2008 22:12:49 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 02/10] vfs: add path_mkdir()
Content-Disposition: inline; filename=path_mkdir.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_mkdir().  Unexport vfs_mkdir() to modules.

The only internal user of vfs_mkdir() remaining is cgroup_clone().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c   |   15 ++++++++-------
 fs/namei.c            |   21 ++++++++++++++-------
 fs/nfsd/nfs4recover.c |    6 +-----
 fs/nfsd/vfs.c         |    2 +-
 include/linux/fs.h    |    1 +
 5 files changed, 25 insertions(+), 20 deletions(-)

Index: vfs-2.6/fs/ecryptfs/inode.c
===================================================================
--- vfs-2.6.orig/fs/ecryptfs/inode.c	2008-04-02 21:10:17.000000000 +0200
+++ vfs-2.6/fs/ecryptfs/inode.c	2008-04-02 21:10:28.000000000 +0200
@@ -487,21 +487,22 @@ static int ecryptfs_mkdir(struct inode *
 {
 	int rc;
 	struct dentry *lower_dentry;
-	struct dentry *lower_dir_dentry;
+	struct path lower_dir;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	lower_dir_dentry = lock_parent(lower_dentry);
-	rc = vfs_mkdir(lower_dir_dentry->d_inode, lower_dentry, mode);
+	lower_dir.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+	lower_dir.dentry = lock_parent(lower_dentry);
+	rc = path_mkdir(&lower_dir, lower_dentry, mode);
 	if (rc || !lower_dentry->d_inode)
 		goto out;
 	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
 	if (rc)
 		goto out;
-	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
-	fsstack_copy_inode_size(dir, lower_dir_dentry->d_inode);
-	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
+	fsstack_copy_attr_times(dir, lower_dir.dentry->d_inode);
+	fsstack_copy_inode_size(dir, lower_dir.dentry->d_inode);
+	dir->i_nlink = lower_dir.dentry->d_inode->i_nlink;
 out:
-	unlock_dir(lower_dir_dentry);
+	unlock_dir(lower_dir.dentry);
 	if (!dentry->d_inode)
 		d_drop(dentry);
 	return rc;
Index: vfs-2.6/fs/namei.c
===================================================================
--- vfs-2.6.orig/fs/namei.c	2008-04-02 21:10:17.000000000 +0200
+++ vfs-2.6/fs/namei.c	2008-04-02 21:10:28.000000000 +0200
@@ -2144,6 +2144,19 @@ int vfs_mkdir(struct inode *dir, struct 
 	return error;
 }
 
+int path_mkdir(struct path *dir_path, struct dentry *dentry, int mode)
+{
+	int error = mnt_want_write(dir_path->mnt);
+
+	if (!error) {
+		error = vfs_mkdir(dir_path->dentry->d_inode, dentry, mode);
+		mnt_drop_write(dir_path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_mkdir);
+
 asmlinkage long sys_mkdirat(int dfd, const char __user *pathname, int mode)
 {
 	int error = 0;
@@ -2166,12 +2179,7 @@ asmlinkage long sys_mkdirat(int dfd, con
 
 	if (!IS_POSIXACL(nd.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto out_dput;
-	error = vfs_mkdir(nd.path.dentry->d_inode, dentry, mode);
-	mnt_drop_write(nd.path.mnt);
-out_dput:
+	error = path_mkdir(&nd.path, dentry, mode);
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
@@ -2975,7 +2983,6 @@ EXPORT_SYMBOL(file_permission);
 EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_follow_link);
 EXPORT_SYMBOL(vfs_link);
-EXPORT_SYMBOL(vfs_mkdir);
 EXPORT_SYMBOL(generic_permission);
 EXPORT_SYMBOL(vfs_readlink);
 EXPORT_SYMBOL(vfs_rename);
Index: vfs-2.6/fs/nfsd/nfs4recover.c
===================================================================
--- vfs-2.6.orig/fs/nfsd/nfs4recover.c	2008-04-02 21:10:14.000000000 +0200
+++ vfs-2.6/fs/nfsd/nfs4recover.c	2008-04-02 21:10:28.000000000 +0200
@@ -155,11 +155,7 @@ nfsd4_create_clid_dir(struct nfs4_client
 		dprintk("NFSD: nfsd4_create_clid_dir: DIRECTORY EXISTS\n");
 		goto out_put;
 	}
-	status = mnt_want_write(rec_dir.path.mnt);
-	if (status)
-		goto out_put;
-	status = vfs_mkdir(rec_dir.path.dentry->d_inode, dentry, S_IRWXU);
-	mnt_drop_write(rec_dir.path.mnt);
+	status = path_mkdir(&rec_dir.path, dentry, S_IRWXU);
 out_put:
 	dput(dentry);
 out_unlock:
Index: vfs-2.6/fs/nfsd/vfs.c
===================================================================
--- vfs-2.6.orig/fs/nfsd/vfs.c	2008-04-02 21:10:17.000000000 +0200
+++ vfs-2.6/fs/nfsd/vfs.c	2008-04-02 21:10:28.000000000 +0200
@@ -1258,7 +1258,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		host_err = path_create(&dir_path, dchild, iap->ia_mode, NULL);
 		break;
 	case S_IFDIR:
-		host_err = vfs_mkdir(dirp, dchild, iap->ia_mode);
+		host_err = path_mkdir(&dir_path, dchild, iap->ia_mode);
 		break;
 	case S_IFCHR:
 	case S_IFBLK:
Index: vfs-2.6/include/linux/fs.h
===================================================================
--- vfs-2.6.orig/include/linux/fs.h	2008-04-02 21:10:17.000000000 +0200
+++ vfs-2.6/include/linux/fs.h	2008-04-02 21:10:28.000000000 +0200
@@ -1125,6 +1125,7 @@ extern void unlock_super(struct super_bl
 extern int vfs_permission(struct nameidata *, int);
 extern int path_create(struct path *, struct dentry *, int, struct nameidata *);
 extern int vfs_mkdir(struct inode *, struct dentry *, int);
+extern int path_mkdir(struct path *, struct dentry *, int);
 extern int path_mknod(struct path *, struct dentry *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);

--
