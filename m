Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbXJZHBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbXJZHBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbXJZG5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:57:15 -0400
Received: from mx1.suse.de ([195.135.220.2]:34770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbXJZG5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:57:11 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:48 2007
Message-Id: <20071026064048.112945864@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:33 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 09/45] Add a struct vfsmount parameter to vfs_symlink()
Content-Disposition: inline; filename=vfs-symlink.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c |    4 +++-
 fs/namei.c          |    6 ++++--
 fs/nfsd/vfs.c       |   12 ++++++++----
 include/linux/fs.h  |    2 +-
 4 files changed, 16 insertions(+), 8 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -461,6 +461,7 @@ static int ecryptfs_symlink(struct inode
 {
 	int rc;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry;
 	umode_t mode;
 	char *encoded_symname;
@@ -469,6 +470,7 @@ static int ecryptfs_symlink(struct inode
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	dget(lower_dentry);
+	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
 	mode = S_IALLUGO;
 	encoded_symlen = ecryptfs_encode_filename(crypt_stat, symname,
@@ -478,7 +480,7 @@ static int ecryptfs_symlink(struct inode
 		rc = encoded_symlen;
 		goto out_lock;
 	}
-	rc = vfs_symlink(lower_dir_dentry->d_inode, lower_dentry,
+	rc = vfs_symlink(lower_dir_dentry->d_inode, lower_dentry, lower_mnt,
 			 encoded_symname, mode);
 	kfree(encoded_symname);
 	if (rc || !lower_dentry->d_inode)
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2303,7 +2303,8 @@ asmlinkage long sys_unlink(const char __
 	return do_unlinkat(AT_FDCWD, pathname);
 }
 
-int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, int mode)
+int vfs_symlink(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt,
+		const char *oldname, int mode)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2352,7 +2353,8 @@ asmlinkage long sys_symlinkat(const char
 	error = mnt_want_write(nd.mnt);
 	if (error)
 		goto out_dput;
-	error = vfs_symlink(nd.dentry->d_inode, dentry, from, S_IALLUGO);
+	error = vfs_symlink(nd.dentry->d_inode, dentry, nd.mnt, from,
+			    S_IALLUGO);
 	mnt_drop_write(nd.mnt);
 out_dput:
 	dput(dentry);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1493,6 +1493,7 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 				struct iattr *iap)
 {
 	struct dentry	*dentry, *dnew;
+	struct svc_export *exp;
 	__be32		err, cerr;
 	int		host_err;
 	umode_t		mode;
@@ -1519,6 +1520,7 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	if (iap && (iap->ia_valid & ATTR_MODE))
 		mode = iap->ia_mode & S_IALLUGO;
 
+	exp = fhp->fh_export;
 	if (unlikely(path[plen] != 0)) {
 		char *path_alloced = kmalloc(plen+1, GFP_KERNEL);
 		if (path_alloced == NULL)
@@ -1526,20 +1528,22 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 		else {
 			strncpy(path_alloced, path, plen);
 			path_alloced[plen] = 0;
-			host_err = vfs_symlink(dentry->d_inode, dnew, path_alloced, mode);
+			host_err = vfs_symlink(dentry->d_inode, dnew,
+					       exp->ex_mnt, path_alloced, mode);
 			kfree(path_alloced);
 		}
 	} else
-		host_err = vfs_symlink(dentry->d_inode, dnew, path, mode);
+		host_err = vfs_symlink(dentry->d_inode, dnew, exp->ex_mnt, path,
+				       mode);
 
 	if (!host_err) {
-		if (EX_ISSYNC(fhp->fh_export))
+		if (EX_ISSYNC(exp))
 			host_err = nfsd_sync_dir(dentry);
 	}
 	err = nfserrno(host_err);
 	fh_unlock(fhp);
 
-	cerr = fh_compose(resfhp, fhp->fh_export, dnew, fhp);
+	cerr = fh_compose(resfhp, exp, dnew, fhp);
 	dput(dnew);
 	if (err==0) err = cerr;
 out:
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1076,7 +1076,7 @@ extern int vfs_permission(struct nameida
 extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
 extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
-extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
+extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);

-- 

