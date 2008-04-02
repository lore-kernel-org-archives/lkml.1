Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbYDBUPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbYDBUPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbYDBUOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:14:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34972 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760300AbYDBUOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:14:22 -0400
Message-Id: <20080402201332.189456442@szeredi.hu>
References: <20080402201247.358430231@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 02 Apr 2008 22:12:55 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 08/10] vfs: add path_setattr()
Content-Disposition: inline; filename=path_setattr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_setattr().  Add checks to IS_IMMUTABLE(inode) and
IS_APPEND(inode) since all callers require it.  Maybe these should be
moved into notify_change()?

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/attr.c           |   23 ++++++++++++++++-
 fs/ecryptfs/inode.c |   11 ++++----
 fs/nfsd/vfs.c       |   21 +++++++++++-----
 fs/open.c           |   68 ++++++----------------------------------------------
 include/linux/fs.h  |    1 
 5 files changed, 53 insertions(+), 71 deletions(-)

Index: vfs-2.6/fs/open.c
===================================================================
--- vfs-2.6.orig/fs/open.c	2008-04-02 21:10:13.000000000 +0200
+++ vfs-2.6/fs/open.c	2008-04-02 21:41:21.000000000 +0200
@@ -578,23 +578,13 @@ asmlinkage long sys_fchmod(unsigned int 
 
 	audit_inode(NULL, dentry);
 
-	err = mnt_want_write(file->f_vfsmnt);
-	if (err)
-		goto out_putf;
-	err = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	err = notify_change(dentry, &newattrs);
+	err = path_setattr(&file->f_path, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-
-out_drop_write:
-	mnt_drop_write(file->f_vfsmnt);
-out_putf:
 	fput(file);
 out:
 	return err;
@@ -613,25 +603,14 @@ asmlinkage long sys_fchmodat(int dfd, co
 		goto out;
 	inode = nd.path.dentry->d_inode;
 
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto dput_and_out;
-
-	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_drop_write;
-
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	error = notify_change(nd.path.dentry, &newattrs);
+	error = path_setattr(&nd.path, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
-out_drop_write:
-	mnt_drop_write(nd.path.mnt);
-dput_and_out:
 	path_put(&nd.path);
 out:
 	return error;
@@ -642,20 +621,12 @@ asmlinkage long sys_chmod(const char __u
 	return sys_fchmodat(AT_FDCWD, filename, mode);
 }
 
-static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
+static int chown_common(struct path *path, uid_t user, gid_t group)
 {
-	struct inode * inode;
+	struct inode *inode = path->dentry->d_inode;
 	int error;
 	struct iattr newattrs;
 
-	error = -ENOENT;
-	if (!(inode = dentry->d_inode)) {
-		printk(KERN_ERR "chown_common: NULL inode\n");
-		goto out;
-	}
-	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out;
 	newattrs.ia_valid =  ATTR_CTIME;
 	if (user != (uid_t) -1) {
 		newattrs.ia_valid |= ATTR_UID;
@@ -669,9 +640,8 @@ static int chown_common(struct dentry * 
 		newattrs.ia_valid |=
 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, &newattrs);
+	error = path_setattr(path, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-out:
 	return error;
 }
 
@@ -683,12 +653,7 @@ asmlinkage long sys_chown(const char __u
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto out_release;
-	error = chown_common(nd.path.dentry, user, group);
-	mnt_drop_write(nd.path.mnt);
-out_release:
+	error = chown_common(&nd.path, user, group);
 	path_put(&nd.path);
 out:
 	return error;
@@ -708,12 +673,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
 		goto out;
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto out_release;
-	error = chown_common(nd.path.dentry, user, group);
-	mnt_drop_write(nd.path.mnt);
-out_release:
+	error = chown_common(&nd.path, user, group);
 	path_put(&nd.path);
 out:
 	return error;
@@ -727,12 +687,7 @@ asmlinkage long sys_lchown(const char __
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto out_release;
-	error = chown_common(nd.path.dentry, user, group);
-	mnt_drop_write(nd.path.mnt);
-out_release:
+	error = chown_common(&nd.path, user, group);
 	path_put(&nd.path);
 out:
 	return error;
@@ -749,14 +704,9 @@ asmlinkage long sys_fchown(unsigned int 
 	if (!file)
 		goto out;
 
-	error = mnt_want_write(file->f_vfsmnt);
-	if (error)
-		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = chown_common(dentry, user, group);
-	mnt_drop_write(file->f_vfsmnt);
-out_fput:
+	error = chown_common(&file->f_path, user, group);
 	fput(file);
 out:
 	return error;
Index: vfs-2.6/fs/attr.c
===================================================================
--- vfs-2.6.orig/fs/attr.c	2008-04-02 21:10:13.000000000 +0200
+++ vfs-2.6/fs/attr.c	2008-04-02 21:41:21.000000000 +0200
@@ -14,6 +14,7 @@
 #include <linux/fcntl.h>
 #include <linux/quotaops.h>
 #include <linux/security.h>
+#include <linux/mount.h>
 
 /* Taken over from the old code... */
 
@@ -182,5 +183,25 @@ int notify_change(struct dentry * dentry
 
 	return error;
 }
-
 EXPORT_SYMBOL(notify_change);
+
+int path_setattr(struct path *path, struct iattr *attr)
+{
+	struct inode *inode = path->dentry->d_inode;
+	int error = mnt_want_write(path->mnt);
+
+	if (error)
+		goto out;
+
+	error = -EPERM;
+	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+		goto out_drop_write;
+
+	error = notify_change(path->dentry, attr);
+
+ out_drop_write:
+	mnt_drop_write(path->mnt);
+ out:
+	return error;
+}
+EXPORT_SYMBOL(path_setattr);
Index: vfs-2.6/fs/nfsd/vfs.c
===================================================================
--- vfs-2.6.orig/fs/nfsd/vfs.c	2008-04-02 21:37:52.000000000 +0200
+++ vfs-2.6/fs/nfsd/vfs.c	2008-04-02 21:41:21.000000000 +0200
@@ -387,8 +387,13 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 
 	err = nfserr_notsync;
 	if (!check_guard || guardtime == inode->i_ctime.tv_sec) {
+		struct path path = {
+			.mnt = fhp->fh_export->ex_path.mnt,
+			.dentry = dentry,
+		};
+
 		fh_lock(fhp);
-		host_err = notify_change(dentry, iap);
+		host_err = path_setattr(&path, iap);
 		err = nfserrno(host_err);
 		fh_unlock(fhp);
 	}
@@ -944,14 +949,18 @@ out:
 	return err;
 }
 
-static void kill_suid(struct dentry *dentry)
+static void kill_suid(struct svc_fh *fhp)
 {
+	struct path path = {
+		.mnt = fhp->fh_export->ex_path.mnt,
+		.dentry = fhp->fh_dentry,
+	};
 	struct iattr	ia;
 	ia.ia_valid = ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
-	notify_change(dentry, &ia);
-	mutex_unlock(&dentry->d_inode->i_mutex);
+	mutex_lock(&path.dentry->d_inode->i_mutex);
+	path_setattr(&path, &ia);
+	mutex_unlock(&path.dentry->d_inode->i_mutex);
 }
 
 static __be32
@@ -1009,7 +1018,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 
 	/* clear setuid/setgid flag after write */
 	if (host_err >= 0 && (inode->i_mode & (S_ISUID | S_ISGID)))
-		kill_suid(dentry);
+		kill_suid(fhp);
 
 	if (host_err >= 0 && stable) {
 		static ino_t	last_ino;
Index: vfs-2.6/include/linux/fs.h
===================================================================
--- vfs-2.6.orig/include/linux/fs.h	2008-04-02 21:37:52.000000000 +0200
+++ vfs-2.6/include/linux/fs.h	2008-04-02 21:41:21.000000000 +0200
@@ -1760,6 +1760,7 @@ extern int do_remount_sb(struct super_bl
 extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
+extern int path_setattr(struct path *, struct iattr *);
 extern int permission(struct inode *, int, struct nameidata *);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
Index: vfs-2.6/fs/ecryptfs/inode.c
===================================================================
--- vfs-2.6.orig/fs/ecryptfs/inode.c	2008-04-02 21:37:52.000000000 +0200
+++ vfs-2.6/fs/ecryptfs/inode.c	2008-04-02 21:41:21.000000000 +0200
@@ -846,7 +846,7 @@ ecryptfs_permission(struct inode *inode,
 static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 {
 	int rc = 0;
-	struct dentry *lower_dentry;
+	struct path lower_path;
 	struct inode *inode;
 	struct inode *lower_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
@@ -856,7 +856,8 @@ static int ecryptfs_setattr(struct dentr
 		ecryptfs_init_crypt_stat(crypt_stat);
 	inode = dentry->d_inode;
 	lower_inode = ecryptfs_inode_to_lower(inode);
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	lower_path.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+	lower_path.dentry = ecryptfs_dentry_to_lower(dentry);
 	mutex_lock(&crypt_stat->cs_mutex);
 	if (S_ISDIR(dentry->d_inode->i_mode))
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
@@ -907,9 +908,9 @@ static int ecryptfs_setattr(struct dentr
 	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		ia->ia_valid &= ~ATTR_MODE;
 
-	mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = notify_change(lower_dentry, ia);
-	mutex_unlock(&lower_dentry->d_inode->i_mutex);
+	mutex_lock(&lower_path.dentry->d_inode->i_mutex);
+	rc = path_setattr(&lower_path, ia);
+	mutex_unlock(&lower_path.dentry->d_inode->i_mutex);
 out:
 	fsstack_copy_attr_all(inode, lower_inode, NULL);
 	return rc;

--
