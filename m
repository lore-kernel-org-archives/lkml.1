Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbYEQHhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbYEQHhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 03:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYEQHhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 03:37:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37130 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbYEQHhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 03:37:08 -0400
To: penguin-kernel@I-love.SAKURA.ne.jp
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <200805171014.JJC34315.MOFSFQHOJFtLOV@I-love.SAKURA.ne.jp>
	(message from Tetsuo Handa on Sat, 17 May 2008 10:14:33 +0900)
Subject: Re: [patch 17/22] vfs: add path_symlink()
References: <20080516163136.560107038@szeredi.hu>
	<20080516163237.755590775@szeredi.hu> <200805171014.JJC34315.MOFSFQHOJFtLOV@I-love.SAKURA.ne.jp>
Message-Id: <E1JxGyM-000456-CD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 17 May 2008 09:36:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Miklos Szeredi wrote:
> > -int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, int mode)
> > +static int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, int mode)
> 
> I think the "mode" parameter is not needed unless somebody has a
> plan to pass it to "struct inode_operations"->symlink method.

Yes, this would be a nice cleanup and I don't think it will ever be
needed.  I've added this patch to the vfs-cleanups tree.

Thanks,
Miklos
----


Subject: vfs: remove mode parameter from path_symlink()

From: Miklos Szeredi <mszeredi@suse.cz>

Remove the unused mode parameter from vfs_symlink, path_symlink() and
callers.

Thanks to Tetsuo Handa for noticing.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/ecryptfs/inode.c |    4 +---
 fs/namei.c          |    8 ++++----
 fs/nfsd/vfs.c       |   10 ++--------
 include/linux/fs.h  |    2 +-
 4 files changed, 8 insertions(+), 16 deletions(-)

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-05-17 09:28:29.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-05-17 09:28:31.000000000 +0200
@@ -440,7 +440,6 @@ static int ecryptfs_symlink(struct inode
 	int rc;
 	struct dentry *lower_dentry;
 	struct path lower_dir;
-	umode_t mode;
 	char *encoded_symname;
 	int encoded_symlen;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
@@ -449,7 +448,6 @@ static int ecryptfs_symlink(struct inode
 	dget(lower_dentry);
 	lower_dir.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	lower_dir.dentry = lock_parent(lower_dentry);
-	mode = S_IALLUGO;
 	encoded_symlen = ecryptfs_encode_filename(crypt_stat, symname,
 						  strlen(symname),
 						  &encoded_symname);
@@ -457,7 +455,7 @@ static int ecryptfs_symlink(struct inode
 		rc = encoded_symlen;
 		goto out_lock;
 	}
-	rc = path_symlink(&lower_dir, lower_dentry, encoded_symname, mode);
+	rc = path_symlink(&lower_dir, lower_dentry, encoded_symname);
 	kfree(encoded_symname);
 	if (rc || !lower_dentry->d_inode)
 		goto out_lock;
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-17 09:28:29.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-17 09:28:31.000000000 +0200
@@ -2437,7 +2437,7 @@ asmlinkage long sys_unlink(const char __
 	return do_unlinkat(AT_FDCWD, pathname);
 }
 
-static int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, int mode)
+static int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2459,14 +2459,14 @@ static int vfs_symlink(struct inode *dir
 }
 
 int path_symlink(struct path *dir_path, struct dentry *dentry,
-		 const char *oldname, int mode)
+		 const char *oldname)
 {
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
 		struct inode *dir = dir_path->dentry->d_inode;
 
-		error = vfs_symlink(dir, dentry, oldname, mode);
+		error = vfs_symlink(dir, dentry, oldname);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2499,7 +2499,7 @@ asmlinkage long sys_symlinkat(const char
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	error = path_symlink(&nd.path, dentry, from, S_IALLUGO);
+	error = path_symlink(&nd.path, dentry, from);
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-17 09:28:29.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-17 09:28:31.000000000 +0200
@@ -1527,7 +1527,6 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	struct dentry	*dentry, *dnew;
 	__be32		err, cerr;
 	int		host_err;
-	umode_t		mode;
 
 	err = nfserr_noent;
 	if (!flen || !plen)
@@ -1546,11 +1545,6 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	if (IS_ERR(dnew))
 		goto out_nfserr;
 
-	mode = S_IALLUGO;
-	/* Only the MODE ATTRibute is even vaguely meaningful */
-	if (iap && (iap->ia_valid & ATTR_MODE))
-		mode = iap->ia_mode & S_IALLUGO;
-
 	fh_to_path(fhp, &dir_path);
 	if (unlikely(path[plen] != 0)) {
 		char *path_alloced = kmalloc(plen+1, GFP_KERNEL);
@@ -1559,11 +1553,11 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 		else {
 			strncpy(path_alloced, path, plen);
 			path_alloced[plen] = 0;
-			host_err = path_symlink(&dir_path, dnew, path_alloced, mode);
+			host_err = path_symlink(&dir_path, dnew, path_alloced);
 			kfree(path_alloced);
 		}
 	} else
-		host_err = path_symlink(&dir_path, dnew, path, mode);
+		host_err = path_symlink(&dir_path, dnew, path);
 
 	if (!host_err) {
 		if (EX_ISSYNC(fhp->fh_export))
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-17 09:28:29.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-17 09:28:31.000000000 +0200
@@ -1127,7 +1127,7 @@ extern int vfs_permission(struct nameida
 extern int path_create(struct path *, struct dentry *, int, struct nameidata *);
 extern int path_mkdir(struct path *, struct dentry *, int);
 extern int path_mknod(struct path *, struct dentry *, int, dev_t);
-extern int path_symlink(struct path *, struct dentry *, const char *, int);
+extern int path_symlink(struct path *, struct dentry *, const char *);
 extern int path_link(struct dentry *, struct path *, struct dentry *);
 extern int path_rmdir(struct path *, struct dentry *);
 extern int path_unlink(struct path *, struct dentry *);
