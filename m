Return-Path: <linux-kernel-owner+w=401wt.eu-S1762051AbYEPQlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762051AbYEPQlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbYEPQdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:33:37 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33781 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbYEPQdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:33:05 -0400
Message-Id: <20080516163241.886885737@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:56 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 20/22] vfs: add path_setattr()
Content-Disposition: inline; filename=path_setattr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_setattr().  Stop exporting notify_change() to modules.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/attr.c           |   14 +++++++++++++-
 fs/ecryptfs/inode.c |   11 ++++++-----
 fs/nfsd/vfs.c       |   17 +++++++++++------
 fs/open.c           |   52 ++++++++++------------------------------------------
 fs/utimes.c         |    6 +-----
 include/linux/fs.h  |    1 +
 6 files changed, 42 insertions(+), 59 deletions(-)

Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-05-16 17:50:46.000000000 +0200
+++ linux-2.6/fs/open.c	2008-05-16 17:50:52.000000000 +0200
@@ -595,18 +595,13 @@ asmlinkage long sys_fchmod(unsigned int 
 
 	audit_inode(NULL, dentry);
 
-	err = mnt_want_write(file->f_path.mnt);
-	if (err)
-		goto out_putf;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	err = notify_change(dentry, &newattrs);
+	err = path_setattr(&file->f_path, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-	mnt_drop_write(file->f_path.mnt);
-out_putf:
 	fput(file);
 out:
 	return err;
@@ -625,18 +620,13 @@ asmlinkage long sys_fchmodat(int dfd, co
 		goto out;
 	inode = nd.path.dentry->d_inode;
 
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto dput_and_out;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	error = notify_change(nd.path.dentry, &newattrs);
+	error = path_setattr(&nd.path, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-	mnt_drop_write(nd.path.mnt);
-dput_and_out:
 	path_put(&nd.path);
 out:
 	return error;
@@ -647,9 +637,9 @@ asmlinkage long sys_chmod(const char __u
 	return sys_fchmodat(AT_FDCWD, filename, mode);
 }
 
-static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
+static int chown_common(struct path *path, uid_t user, gid_t group)
 {
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = path->dentry->d_inode;
 	int error;
 	struct iattr newattrs;
 
@@ -666,7 +656,7 @@ static int chown_common(struct dentry * 
 		newattrs.ia_valid |=
 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, &newattrs);
+	error = path_setattr(path, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
 	return error;
@@ -680,12 +670,7 @@ asmlinkage long sys_chown(const char __u
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
@@ -705,12 +690,7 @@ asmlinkage long sys_fchownat(int dfd, co
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
@@ -724,12 +704,7 @@ asmlinkage long sys_lchown(const char __
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
@@ -740,20 +715,13 @@ asmlinkage long sys_fchown(unsigned int 
 {
 	struct file * file;
 	int error = -EBADF;
-	struct dentry * dentry;
 
 	file = fget(fd);
 	if (!file)
 		goto out;
 
-	error = mnt_want_write(file->f_path.mnt);
-	if (error)
-		goto out_fput;
-	dentry = file->f_path.dentry;
-	audit_inode(NULL, dentry);
-	error = chown_common(dentry, user, group);
-	mnt_drop_write(file->f_path.mnt);
-out_fput:
+	audit_inode(NULL, file->f_path.dentry);
+	error = chown_common(&file->f_path, user, group);
 	fput(file);
 out:
 	return error;
Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2008-05-16 17:50:45.000000000 +0200
+++ linux-2.6/fs/attr.c	2008-05-16 17:50:52.000000000 +0200
@@ -14,6 +14,7 @@
 #include <linux/fcntl.h>
 #include <linux/quotaops.h>
 #include <linux/security.h>
+#include <linux/mount.h>
 
 /* Taken over from the old code... */
 
@@ -189,4 +190,15 @@ int notify_change(struct dentry * dentry
 	return error;
 }
 
-EXPORT_SYMBOL(notify_change);
+int path_setattr(struct path *path, struct iattr *attr)
+{
+	int error = mnt_want_write(path->mnt);
+
+	if (!error) {
+		error = notify_change(path->dentry, attr);
+		mnt_drop_write(path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_setattr);
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-16 17:50:51.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-16 17:50:52.000000000 +0200
@@ -392,8 +392,11 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 
 	err = nfserr_notsync;
 	if (!check_guard || guardtime == inode->i_ctime.tv_sec) {
+		struct path path;
+
 		fh_lock(fhp);
-		host_err = notify_change(dentry, iap);
+		fh_to_path(fhp, &path);
+		host_err = path_setattr(&path, iap);
 		err = nfserrno(host_err);
 		fh_unlock(fhp);
 	}
@@ -949,14 +952,16 @@ out:
 	return err;
 }
 
-static void kill_suid(struct dentry *dentry)
+static void kill_suid(struct svc_fh *fhp)
 {
+	struct path	path;
 	struct iattr	ia;
 	ia.ia_valid = ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
-	notify_change(dentry, &ia);
-	mutex_unlock(&dentry->d_inode->i_mutex);
+	mutex_lock(&path.dentry->d_inode->i_mutex);
+	fh_to_path(fhp, &path);
+	path_setattr(&path, &ia);
+	mutex_unlock(&path.dentry->d_inode->i_mutex);
 }
 
 static __be32
@@ -1014,7 +1019,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 
 	/* clear setuid/setgid flag after write */
 	if (host_err >= 0 && (inode->i_mode & (S_ISUID | S_ISGID)))
-		kill_suid(dentry);
+		kill_suid(fhp);
 
 	if (host_err >= 0 && stable) {
 		static ino_t	last_ino;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-16 17:50:51.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-16 17:50:52.000000000 +0200
@@ -1757,6 +1757,7 @@ extern int do_remount_sb(struct super_bl
 extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
+extern int path_setattr(struct path *, struct iattr *);
 extern int permission(struct inode *, int, struct nameidata *);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-05-16 17:50:51.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-05-16 17:50:52.000000000 +0200
@@ -843,7 +843,7 @@ ecryptfs_permission(struct inode *inode,
 static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 {
 	int rc = 0;
-	struct dentry *lower_dentry;
+	struct path lower_path;
 	struct inode *inode;
 	struct inode *lower_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
@@ -853,7 +853,8 @@ static int ecryptfs_setattr(struct dentr
 		ecryptfs_init_crypt_stat(crypt_stat);
 	inode = dentry->d_inode;
 	lower_inode = ecryptfs_inode_to_lower(inode);
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	lower_path.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+	lower_path.dentry = ecryptfs_dentry_to_lower(dentry);
 	mutex_lock(&crypt_stat->cs_mutex);
 	if (S_ISDIR(dentry->d_inode->i_mode))
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
@@ -904,9 +905,9 @@ static int ecryptfs_setattr(struct dentr
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
Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-05-16 17:50:47.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-05-16 17:50:52.000000000 +0200
@@ -78,11 +78,7 @@ static int utimes_common(struct path *pa
 		}
 	}
 	mutex_lock(&path->dentry->d_inode->i_mutex);
-	error = mnt_want_write(path->mnt);
-	if (!error) {
-		error = notify_change(path->dentry, &newattrs);
-		mnt_drop_write(path->mnt);
-	}
+	error = path_setattr(path, &newattrs);
 	mutex_unlock(&path->dentry->d_inode->i_mutex);
 
 	return error;

--
