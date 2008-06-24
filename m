Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbYFXOw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbYFXOw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759484AbYFXOuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:50:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58198 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149AbYFXOuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:50:51 -0400
Message-Id: <20080624145048.367596617@szeredi.hu>
References: <20080624145011.722691277@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 24 Jun 2008 16:50:16 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [patch 5/5] vfs: remove mode parameter from vfs_symlink()
Content-Disposition: inline; filename=vfs-remove-mode-parameter-from-path_symlink.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Remove the unused mode parameter from vfs_symlink and callers.

Thanks to Tetsuo Handa for noticing.

CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |    4 +---
 fs/namei.c          |    4 ++--
 fs/nfsd/vfs.c       |   10 ++--------
 include/linux/fs.h  |    2 +-
 4 files changed, 6 insertions(+), 14 deletions(-)

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-06-19 14:58:09.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-06-24 16:26:14.000000000 +0200
@@ -444,7 +444,6 @@ static int ecryptfs_symlink(struct inode
 	int rc;
 	struct dentry *lower_dentry;
 	struct dentry *lower_dir_dentry;
-	umode_t mode;
 	char *encoded_symname;
 	int encoded_symlen;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
@@ -452,7 +451,6 @@ static int ecryptfs_symlink(struct inode
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	dget(lower_dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
-	mode = S_IALLUGO;
 	encoded_symlen = ecryptfs_encode_filename(crypt_stat, symname,
 						  strlen(symname),
 						  &encoded_symname);
@@ -461,7 +459,7 @@ static int ecryptfs_symlink(struct inode
 		goto out_lock;
 	}
 	rc = vfs_symlink(lower_dir_dentry->d_inode, lower_dentry,
-			 encoded_symname, mode);
+			 encoded_symname);
 	kfree(encoded_symname);
 	if (rc || !lower_dentry->d_inode)
 		goto out_lock;
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-06-24 16:26:00.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-06-24 16:26:14.000000000 +0200
@@ -2408,7 +2408,7 @@ asmlinkage long sys_unlink(const char __
 	return do_unlinkat(AT_FDCWD, pathname);
 }
 
-int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, int mode)
+int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2457,7 +2457,7 @@ asmlinkage long sys_symlinkat(const char
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
-	error = vfs_symlink(nd.path.dentry->d_inode, dentry, from, S_IALLUGO);
+	error = vfs_symlink(nd.path.dentry->d_inode, dentry, from);
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(dentry);
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-06-24 13:58:36.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-06-24 16:26:14.000000000 +0200
@@ -1517,7 +1517,6 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	struct dentry	*dentry, *dnew;
 	__be32		err, cerr;
 	int		host_err;
-	umode_t		mode;
 
 	err = nfserr_noent;
 	if (!flen || !plen)
@@ -1536,11 +1535,6 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	if (IS_ERR(dnew))
 		goto out_nfserr;
 
-	mode = S_IALLUGO;
-	/* Only the MODE ATTRibute is even vaguely meaningful */
-	if (iap && (iap->ia_valid & ATTR_MODE))
-		mode = iap->ia_mode & S_IALLUGO;
-
 	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
 	if (host_err)
 		goto out_nfserr;
@@ -1552,11 +1546,11 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 		else {
 			strncpy(path_alloced, path, plen);
 			path_alloced[plen] = 0;
-			host_err = vfs_symlink(dentry->d_inode, dnew, path_alloced, mode);
+			host_err = vfs_symlink(dentry->d_inode, dnew, path_alloced);
 			kfree(path_alloced);
 		}
 	} else
-		host_err = vfs_symlink(dentry->d_inode, dnew, path, mode);
+		host_err = vfs_symlink(dentry->d_inode, dnew, path);
 
 	if (!host_err) {
 		if (EX_ISSYNC(fhp->fh_export))
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-06-24 16:25:25.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-06-24 16:26:14.000000000 +0200
@@ -1125,7 +1125,7 @@ extern int vfs_permission(struct nameida
 extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
 extern int vfs_mkdir(struct inode *, struct dentry *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, int, dev_t);
-extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
+extern int vfs_symlink(struct inode *, struct dentry *, const char *);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);

--
