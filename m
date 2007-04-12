Return-Path: <linux-kernel-owner+w=401wt.eu-S1946007AbXDLJrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946007AbXDLJrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946088AbXDLJpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:45:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946007AbXDLJkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:36 -0400
Message-Id: <20070412090839.731485000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:20 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 11/41] Add a struct vfsmount parameter to vfs_symlink()
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
 fs/nfsd/vfs.c       |    7 +++++--
 include/linux/fs.h  |    2 +-
 4 files changed, 13 insertions(+), 6 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -470,6 +470,7 @@ static int ecryptfs_symlink(struct inode
 {
 	int rc;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry;
 	umode_t mode;
 	char *encoded_symname;
@@ -478,6 +479,7 @@ static int ecryptfs_symlink(struct inode
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	dget(lower_dentry);
+	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
 	mode = S_IALLUGO;
 	encoded_symlen = ecryptfs_encode_filename(crypt_stat, symname,
@@ -487,7 +489,7 @@ static int ecryptfs_symlink(struct inode
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
@@ -2185,7 +2185,8 @@ asmlinkage long sys_unlink(const char __
 	return do_unlinkat(AT_FDCWD, pathname);
 }
 
-int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, int mode)
+int vfs_symlink(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt,
+		const char *oldname, int mode)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2231,7 +2232,8 @@ asmlinkage long sys_symlinkat(const char
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	error = vfs_symlink(nd.dentry->d_inode, dentry, from, S_IALLUGO);
+	error = vfs_symlink(nd.dentry->d_inode, dentry, nd.mnt, from,
+			    S_IALLUGO);
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1435,6 +1435,7 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 				struct iattr *iap)
 {
 	struct dentry	*dentry, *dnew;
+	struct vfsmount *mnt;
 	__be32		err, cerr;
 	int		host_err;
 	umode_t		mode;
@@ -1461,6 +1462,7 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	if (iap && (iap->ia_valid & ATTR_MODE))
 		mode = iap->ia_mode & S_IALLUGO;
 
+	mnt = fhp->fh_export->ex_mnt;
 	if (unlikely(path[plen] != 0)) {
 		char *path_alloced = kmalloc(plen+1, GFP_KERNEL);
 		if (path_alloced == NULL)
@@ -1468,11 +1470,12 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 		else {
 			strncpy(path_alloced, path, plen);
 			path_alloced[plen] = 0;
-			host_err = vfs_symlink(dentry->d_inode, dnew, path_alloced, mode);
+			host_err = vfs_symlink(dentry->d_inode, dnew, mnt,
+					       path_alloced, mode);
 			kfree(path_alloced);
 		}
 	} else
-		host_err = vfs_symlink(dentry->d_inode, dnew, path, mode);
+		host_err = vfs_symlink(dentry->d_inode, dnew, mnt, path, mode);
 
 	if (!host_err) {
 		if (EX_ISSYNC(fhp->fh_export))
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -982,7 +982,7 @@ extern int vfs_permission(struct nameida
 extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
 extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
-extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
+extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);

-- 
