Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXLTONV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXLTONV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932833AbXLTOK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:10:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:40645 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760008AbXLTOK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:10:56 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:42 2007
Message-Id: <20071220140942.125364890@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:15 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 05/47] Add struct vfsmount parameter to vfs_mkdir()
Content-Disposition: inline; filename=vfs-mkdir.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
 fs/nfsd/vfs.c         |    9 ++++++---
 fs/unionfs/copyup.c   |    5 ++++-
 fs/unionfs/inode.c    |    3 ++-
 fs/unionfs/sioq.c     |    2 +-
 fs/unionfs/sioq.h     |    1 +
 include/linux/fs.h    |    2 +-
 9 files changed, 24 insertions(+), 11 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -499,11 +499,14 @@ static int ecryptfs_mkdir(struct inode *
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
@@ -2107,7 +2107,8 @@ asmlinkage long sys_mknod(const char __u
 	return sys_mknodat(AT_FDCWD, filename, mode, dev);
 }
 
-int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+int vfs_mkdir(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt,
+	      int mode)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2154,7 +2155,7 @@ asmlinkage long sys_mkdirat(int dfd, con
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
-	error = vfs_mkdir(nd.path.dentry->d_inode, dentry, mode);
+	error = vfs_mkdir(nd.path.dentry->d_inode, dentry, nd.path.mnt, mode);
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(dentry);
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -158,7 +158,8 @@ nfsd4_create_clid_dir(struct nfs4_client
 	status = mnt_want_write(rec_dir.path.mnt);
 	if (status)
 		goto out_put;
-	status = vfs_mkdir(rec_dir.path.dentry->d_inode, dentry, S_IRWXU);
+	status = vfs_mkdir(rec_dir.path.dentry->d_inode, dentry,
+			   rec_dir.path.mnt, S_IRWXU);
 	mnt_drop_write(rec_dir.path.mnt);
 out_put:
 	dput(dentry);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1166,6 +1166,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		int type, dev_t rdev, struct svc_fh *resfhp)
 {
 	struct dentry	*dentry, *dchild = NULL;
+	struct svc_export *exp;
 	struct inode	*dirp;
 	__be32		err;
 	int		host_err;
@@ -1182,6 +1183,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		goto out;
 
 	dentry = fhp->fh_dentry;
+	exp = fhp->fh_export;
 	dirp = dentry->d_inode;
 
 	err = nfserr_notdir;
@@ -1198,7 +1200,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		host_err = PTR_ERR(dchild);
 		if (IS_ERR(dchild))
 			goto out_nfserr;
-		err = fh_compose(resfhp, fhp->fh_export, dchild, fhp);
+		err = fh_compose(resfhp, exp, dchild, fhp);
 		if (err)
 			goto out;
 	} else {
@@ -1237,7 +1239,8 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
 		break;
 	case S_IFDIR:
-		host_err = vfs_mkdir(dirp, dchild, iap->ia_mode);
+		host_err = vfs_mkdir(dirp, dchild, exp->ex_path.mnt,
+				     iap->ia_mode);
 		break;
 	case S_IFCHR:
 	case S_IFBLK:
@@ -1256,7 +1259,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	if (host_err < 0)
 		goto out_nfserr;
 
-	if (EX_ISSYNC(fhp->fh_export)) {
+	if (EX_ISSYNC(exp)) {
 		err = nfserrno(nfsd_sync_dir(dentry));
 		write_inode_now(dchild->d_inode, 1);
 	}
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -165,6 +165,7 @@ out:
  */
 static int __copyup_ndentry(struct dentry *old_lower_dentry,
 			    struct dentry *new_lower_dentry,
+			    struct vfsmount *new_lower_mnt,
 			    struct dentry *new_lower_parent_dentry,
 			    char *symbuf)
 {
@@ -175,6 +176,7 @@ static int __copyup_ndentry(struct dentr
 	if (S_ISDIR(old_mode)) {
 		args.mkdir.parent = new_lower_parent_dentry->d_inode;
 		args.mkdir.dentry = new_lower_dentry;
+		args.mkdir.mnt = new_lower_mnt;
 		args.mkdir.mode = old_mode;
 
 		run_sioq(__unionfs_mkdir, &args);
@@ -445,7 +447,7 @@ int copyup_dentry(struct inode *dir, str
 
 	/* create the new inode */
 	err = __copyup_ndentry(old_lower_dentry, new_lower_dentry,
-			       new_lower_parent_dentry, symbuf);
+			       new_lower_mnt, new_lower_parent_dentry, symbuf);
 
 	if (err) {
 		__clear(dentry, old_lower_dentry,
@@ -802,6 +804,7 @@ begin:
 
 		args.mkdir.parent = lower_parent_dentry->d_inode;
 		args.mkdir.dentry = lower_dentry;
+		args.mkdir.mnt = lower_mnt;
 		args.mkdir.mode = child_dentry->d_inode->i_mode;
 
 		run_sioq(__unionfs_mkdir, &args);
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -610,6 +610,7 @@ static int unionfs_mkdir(struct inode *p
 			continue;
 
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		lower_mnt = unionfs_lower_mnt_idx(dentry, bindex);
 		if (!lower_dentry) {
 			lower_dentry = create_parents(parent, dentry,
 						      dentry->d_name.name,
@@ -629,7 +630,7 @@ static int unionfs_mkdir(struct inode *p
 		}
 
 		err = vfs_mkdir(lower_parent_dentry->d_inode, lower_dentry,
-				mode);
+				lower_mnt, mode);
 
 		unlock_dir(lower_parent_dentry);
 
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -69,7 +69,7 @@ void __unionfs_mkdir(struct work_struct 
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct mkdir_args *m = &args->mkdir;
 
-	args->err = vfs_mkdir(m->parent, m->dentry, m->mode);
+	args->err = vfs_mkdir(m->parent, m->dentry, m->mnt, m->mode);
 	complete(&args->comp);
 }
 
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -35,6 +35,7 @@ struct create_args {
 struct mkdir_args {
 	struct inode *parent;
 	struct dentry *dentry;
+	struct vfsmount *mnt;
 	umode_t mode;
 };
 
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1070,7 +1070,7 @@ extern void unlock_super(struct super_bl
  */
 extern int vfs_permission(struct nameidata *, int);
 extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
-extern int vfs_mkdir(struct inode *, struct dentry *, int);
+extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);

-- 

