Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbXJZG6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbXJZG6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXJZG47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:56:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:34727 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbXJZG45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:56:57 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:47 2007
Message-Id: <20071026064047.538921766@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:29 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 05/45] Add struct vfsmount parameter to vfs_mkdir()
Content-Disposition: inline; filename=vfs-mkdir.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c   |    5 ++++-
 fs/namei.c            |    5 +++--
 fs/nfsd/nfs4recover.c |    3 ++-
 fs/nfsd/vfs.c         |    8 +++++---
 include/linux/fs.h    |    2 +-
 5 files changed, 15 insertions(+), 8 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -500,11 +500,14 @@ static int ecryptfs_mkdir(struct inode *
 {
 	int rc;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
-	rc = vfs_mkdir(lower_dir_dentry->d_inode, lower_dentry, mode);
+	rc = vfs_mkdir(lower_dir_dentry->d_inode, lower_dentry, lower_mnt,
+		       mode);
 	if (rc || !lower_dentry->d_inode)
 		goto out;
 	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2020,7 +2020,8 @@ asmlinkage long sys_mknod(const char __u
 	return sys_mknodat(AT_FDCWD, filename, mode, dev);
 }
 
-int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+int vfs_mkdir(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt,
+	      int mode)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2067,7 +2068,7 @@ asmlinkage long sys_mkdirat(int dfd, con
 	error = mnt_want_write(nd.mnt);
 	if (error)
 		goto out_dput;
-	error = vfs_mkdir(nd.dentry->d_inode, dentry, mode);
+	error = vfs_mkdir(nd.dentry->d_inode, dentry, nd.mnt, mode);
 	mnt_drop_write(nd.mnt);
 out_dput:
 	dput(dentry);
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -159,7 +159,8 @@ nfsd4_create_clid_dir(struct nfs4_client
 	status = mnt_want_write(rec_dir.mnt);
 	if (status)
 		goto out_put;
-	status = vfs_mkdir(rec_dir.dentry->d_inode, dentry, S_IRWXU);
+	status = vfs_mkdir(rec_dir.dentry->d_inode, dentry, rec_dir.mnt,
+			   S_IRWXU);
 	mnt_drop_write(rec_dir.mnt);
 out_put:
 	dput(dentry);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1165,6 +1165,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		int type, dev_t rdev, struct svc_fh *resfhp)
 {
 	struct dentry	*dentry, *dchild = NULL;
+	struct svc_export *exp;
 	struct inode	*dirp;
 	__be32		err;
 	int		host_err;
@@ -1181,6 +1182,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		goto out;
 
 	dentry = fhp->fh_dentry;
+	exp = fhp->fh_export;
 	dirp = dentry->d_inode;
 
 	err = nfserr_notdir;
@@ -1197,7 +1199,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		host_err = PTR_ERR(dchild);
 		if (IS_ERR(dchild))
 			goto out_nfserr;
-		err = fh_compose(resfhp, fhp->fh_export, dchild, fhp);
+		err = fh_compose(resfhp, exp, dchild, fhp);
 		if (err)
 			goto out;
 	} else {
@@ -1236,7 +1238,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
 		break;
 	case S_IFDIR:
-		host_err = vfs_mkdir(dirp, dchild, iap->ia_mode);
+		host_err = vfs_mkdir(dirp, dchild, exp->ex_mnt, iap->ia_mode);
 		break;
 	case S_IFCHR:
 	case S_IFBLK:
@@ -1255,7 +1257,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	if (host_err < 0)
 		goto out_nfserr;
 
-	if (EX_ISSYNC(fhp->fh_export)) {
+	if (EX_ISSYNC(exp)) {
 		err = nfserrno(nfsd_sync_dir(dentry));
 		write_inode_now(dchild->d_inode, 1);
 	}
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1074,7 +1074,7 @@ extern void unlock_super(struct super_bl
  */
 extern int vfs_permission(struct nameidata *, int);
 extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
-extern int vfs_mkdir(struct inode *, struct dentry *, int);
+extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);

-- 

