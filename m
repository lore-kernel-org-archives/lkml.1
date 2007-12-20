Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbXLTOOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbXLTOOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760306AbXLTOLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:56520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856AbXLTOLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:03 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:42 2007
Message-Id: <20071220140942.457459819@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:17 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 07/47] Add a struct vfsmount parameter to vfs_mknod()
Content-Disposition: inline; filename=vfs-mknod.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c |    5 ++++-
 fs/namei.c          |   10 ++++++----
 fs/nfsd/vfs.c       |    3 ++-
 fs/unionfs/copyup.c |    1 +
 fs/unionfs/inode.c  |    3 ++-
 fs/unionfs/sioq.c   |    2 +-
 fs/unionfs/sioq.h   |    1 +
 include/linux/fs.h  |    2 +-
 net/unix/af_unix.c  |    3 ++-
 9 files changed, 20 insertions(+), 10 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -550,11 +550,14 @@ ecryptfs_mknod(struct inode *dir, struct
 {
 	int rc;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
-	rc = vfs_mknod(lower_dir_dentry->d_inode, lower_dentry, mode, dev);
+	rc = vfs_mknod(lower_dir_dentry->d_inode, lower_dentry, lower_mnt, mode,
+		       dev);
 	if (rc || !lower_dentry->d_inode)
 		goto out;
 	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2005,7 +2005,8 @@ fail:
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
-int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+int vfs_mknod(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt,
+	      int mode, dev_t dev)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2082,12 +2083,13 @@ asmlinkage long sys_mknodat(int dfd, con
 						mode, &nd);
 			break;
 		case S_IFCHR: case S_IFBLK:
-			error = vfs_mknod(nd.path.dentry->d_inode, dentry, mode,
-					new_decode_dev(dev));
+			error = vfs_mknod(nd.path.dentry->d_inode, dentry,
+					  nd.path.mnt, mode,
+					  new_decode_dev(dev));
 			break;
 		case S_IFIFO: case S_IFSOCK:
 			error = vfs_mknod(nd.path.dentry->d_inode, dentry,
-						mode, 0);
+					  nd.path.mnt, mode, 0);
 			break;
 	}
 	mnt_drop_write(nd.path.mnt);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1249,7 +1249,8 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
 		if (host_err)
 			break;
-		host_err = vfs_mknod(dirp, dchild, iap->ia_mode, rdev);
+		host_err = vfs_mknod(dirp, dchild, exp->ex_path.mnt,
+				     iap->ia_mode, rdev);
 		mnt_drop_write(fhp->fh_export->ex_path.mnt);
 		break;
 	default:
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -193,6 +193,7 @@ static int __copyup_ndentry(struct dentr
 		   S_ISFIFO(old_mode) || S_ISSOCK(old_mode)) {
 		args.mknod.parent = new_lower_parent_dentry->d_inode;
 		args.mknod.dentry = new_lower_dentry;
+		args.mknod.mnt = new_lower_mnt;
 		args.mknod.mode = old_mode;
 		args.mknod.dev = old_lower_dentry->d_inode->i_rdev;
 
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -760,6 +760,7 @@ static int unionfs_mknod(struct inode *d
 			continue;
 
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		lower_mnt = unionfs_lower_mnt_idx(dentry, bindex);
 		if (!lower_dentry) {
 			lower_dentry = create_parents(dir, dentry,
 						      dentry->d_name.name,
@@ -779,7 +780,7 @@ static int unionfs_mknod(struct inode *d
 		}
 
 		err = vfs_mknod(lower_parent_dentry->d_inode,
-				lower_dentry, mode, dev);
+				lower_dentry, lower_mnt, mode, dev);
 
 		if (err) {
 			unlock_dir(lower_parent_dentry);
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -78,7 +78,7 @@ void __unionfs_mknod(struct work_struct 
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct mknod_args *m = &args->mknod;
 
-	args->err = vfs_mknod(m->parent, m->dentry, m->mode, m->dev);
+	args->err = vfs_mknod(m->parent, m->dentry, m->mnt, m->mode, m->dev);
 	complete(&args->comp);
 }
 
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -42,6 +42,7 @@ struct mkdir_args {
 struct mknod_args {
 	struct inode *parent;
 	struct dentry *dentry;
+	struct vfsmount *mnt;
 	umode_t mode;
 	dev_t dev;
 };
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1071,7 +1071,7 @@ extern void unlock_super(struct super_bl
 extern int vfs_permission(struct nameidata *, int);
 extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
 extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
-extern int vfs_mknod(struct inode *, struct dentry *, int, dev_t);
+extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -822,7 +822,8 @@ static int unix_bind(struct socket *sock
 		err = mnt_want_write(nd.path.mnt);
 		if (err)
 			goto out_mknod_dput;
-		err = vfs_mknod(nd.path.dentry->d_inode, dentry, mode, 0);
+		err = vfs_mknod(nd.path.dentry->d_inode, dentry, nd.path.mnt,
+				mode, 0);
 		mnt_drop_write(nd.path.mnt);
 		if (err)
 			goto out_mknod_dput;

-- 

