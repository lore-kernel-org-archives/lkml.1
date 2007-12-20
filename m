Return-Path: <linux-kernel-owner+w=401wt.eu-S933520AbXLTOPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520AbXLTOPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbXLTOLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:56551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbXLTOLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:11 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:42 2007
Message-Id: <20071220140942.729793188@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:19 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 09/47] Add a struct vfsmount parameter to vfs_symlink()
Content-Disposition: inline; filename=vfs-symlink.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c |    4 +++-
 fs/namei.c          |    6 ++++--
 fs/nfsd/vfs.c       |   13 +++++++++----
 fs/unionfs/copyup.c |    1 +
 fs/unionfs/inode.c  |    4 +++-
 fs/unionfs/sioq.c   |    3 ++-
 fs/unionfs/sioq.h   |    1 +
 include/linux/fs.h  |    2 +-
 8 files changed, 24 insertions(+), 10 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -460,6 +460,7 @@ static int ecryptfs_symlink(struct inode
 {
 	int rc;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry;
 	umode_t mode;
 	char *encoded_symname;
@@ -468,6 +469,7 @@ static int ecryptfs_symlink(struct inode
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	dget(lower_dentry);
+	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
 	mode = S_IALLUGO;
 	encoded_symlen = ecryptfs_encode_filename(crypt_stat, symname,
@@ -477,7 +479,7 @@ static int ecryptfs_symlink(struct inode
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
@@ -2391,7 +2391,8 @@ asmlinkage long sys_unlink(const char __
 	return do_unlinkat(AT_FDCWD, pathname);
 }
 
-int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, int mode)
+int vfs_symlink(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt,
+		const char *oldname, int mode)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2440,7 +2441,8 @@ asmlinkage long sys_symlinkat(const char
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
-	error = vfs_symlink(nd.path.dentry->d_inode, dentry, from, S_IALLUGO);
+	error = vfs_symlink(nd.path.dentry->d_inode, dentry, nd.path.mnt, from,
+			    S_IALLUGO);
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(dentry);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1495,6 +1495,7 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 				struct iattr *iap)
 {
 	struct dentry	*dentry, *dnew;
+	struct svc_export *exp;
 	__be32		err, cerr;
 	int		host_err;
 	umode_t		mode;
@@ -1521,6 +1522,7 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	if (iap && (iap->ia_valid & ATTR_MODE))
 		mode = iap->ia_mode & S_IALLUGO;
 
+	exp = fhp->fh_export;
 	if (unlikely(path[plen] != 0)) {
 		char *path_alloced = kmalloc(plen+1, GFP_KERNEL);
 		if (path_alloced == NULL)
@@ -1528,20 +1530,23 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 		else {
 			strncpy(path_alloced, path, plen);
 			path_alloced[plen] = 0;
-			host_err = vfs_symlink(dentry->d_inode, dnew, path_alloced, mode);
+			host_err = vfs_symlink(dentry->d_inode, dnew,
+					       exp->ex_path.mnt, path_alloced,
+					       mode);
 			kfree(path_alloced);
 		}
 	} else
-		host_err = vfs_symlink(dentry->d_inode, dnew, path, mode);
+		host_err = vfs_symlink(dentry->d_inode, dnew, exp->ex_path.mnt,
+				       path, mode);
 
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
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -184,6 +184,7 @@ static int __copyup_ndentry(struct dentr
 	} else if (S_ISLNK(old_mode)) {
 		args.symlink.parent = new_lower_parent_dentry->d_inode;
 		args.symlink.dentry = new_lower_dentry;
+		args.symlink.mnt = new_lower_mnt;
 		args.symlink.symbuf = symbuf;
 		args.symlink.mode = old_mode;
 
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -452,6 +452,7 @@ static int unionfs_symlink(struct inode 
 	 */
 	for (bindex = bstart; bindex >= 0; bindex--) {
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		lower_mnt = unionfs_lower_mnt_idx(dentry, bindex);
 		if (!lower_dentry) {
 			/*
 			 * if lower_dentry is NULL, create the entire
@@ -482,7 +483,8 @@ static int unionfs_symlink(struct inode 
 		if (!err) {
 			mode = S_IALLUGO;
 			err = vfs_symlink(lower_dir_dentry->d_inode,
-					  lower_dentry, symname, mode);
+					  lower_dentry, lower_mnt, symname,
+					  mode);
 		}
 		unlock_dir(lower_dir_dentry);
 
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -87,7 +87,8 @@ void __unionfs_symlink(struct work_struc
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct symlink_args *s = &args->symlink;
 
-	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf, s->mode);
+	args->err = vfs_symlink(s->parent, s->dentry, s->mnt, s->symbuf,
+				s->mode);
 	complete(&args->comp);
 }
 
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -50,6 +50,7 @@ struct mknod_args {
 struct symlink_args {
 	struct inode *parent;
 	struct dentry *dentry;
+	struct vfsmount *mnt;
 	char *symbuf;
 	umode_t mode;
 };
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1072,7 +1072,7 @@ extern int vfs_permission(struct nameida
 extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
 extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
-extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
+extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);

-- 

