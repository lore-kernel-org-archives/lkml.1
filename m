Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbXLTOT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbXLTOT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbXLTOLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:40759 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934AbXLTOLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:45 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:44 2007
Message-Id: <20071220140944.069627598@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:27 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 17/47] Add a struct vfsmount parameter to vfs_unlink()
Content-Disposition: inline; filename=vfs-unlink.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c     |    3 ++-
 fs/namei.c              |    5 +++--
 fs/nfsd/nfs4recover.c   |    2 +-
 fs/nfsd/vfs.c           |    2 +-
 fs/unionfs/commonfops.c |    4 +++-
 fs/unionfs/copyup.c     |    3 ++-
 fs/unionfs/dirhelper.c  |    5 ++++-
 fs/unionfs/inode.c      |   22 ++++++++++++++++------
 fs/unionfs/rename.c     |    8 ++++++--
 fs/unionfs/sioq.c       |    2 +-
 fs/unionfs/sioq.h       |    1 +
 fs/unionfs/unlink.c     |    5 ++++-
 include/linux/fs.h      |    2 +-
 ipc/mqueue.c            |    2 +-
 14 files changed, 46 insertions(+), 20 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -443,10 +443,11 @@ static int ecryptfs_unlink(struct inode 
 {
 	int rc = 0;
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
 
 	lock_parent(lower_dentry);
-	rc = vfs_unlink(lower_dir_inode, lower_dentry);
+	rc = vfs_unlink(lower_dir_inode, lower_dentry, lower_mnt);
 	if (rc) {
 		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
 		goto out_unlock;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2288,7 +2288,7 @@ asmlinkage long sys_rmdir(const char __u
 	return do_rmdir(AT_FDCWD, pathname);
 }
 
-int vfs_unlink(struct inode *dir, struct dentry *dentry)
+int vfs_unlink(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt)
 {
 	int error = may_delete(dir, dentry, 0);
 
@@ -2356,7 +2356,8 @@ static long do_unlinkat(int dfd, const c
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
-		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
+		error = vfs_unlink(nd.path.dentry->d_inode, dentry,
+				   nd.path.mnt);
 		mnt_drop_write(nd.path.mnt);
 	exit2:
 		dput(dentry);
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -264,7 +264,7 @@ nfsd4_remove_clid_file(struct dentry *di
 		return -EINVAL;
 	}
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
-	status = vfs_unlink(dir->d_inode, dentry);
+	status = vfs_unlink(dir->d_inode, dentry, rec_dir.path.mnt);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	return status;
 }
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1772,7 +1772,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 			host_err = -EPERM;
 		} else
 #endif
-		host_err = vfs_unlink(dirp, rdentry);
+		host_err = vfs_unlink(dirp, rdentry, exp->ex_path.mnt);
 	} else { /* It's RMDIR */
 		host_err = vfs_rmdir(dirp, rdentry, exp->ex_path.mnt);
 	}
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -34,6 +34,7 @@ static int copyup_deleted_file(struct fi
 	int err;
 	struct dentry *tmp_dentry = NULL;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry = NULL;
 
 	lower_dentry = unionfs_lower_dentry_idx(dentry, bstart);
@@ -82,13 +83,14 @@ retry:
 
 	/* bring it to the same state as an unlinked file */
 	lower_dentry = unionfs_lower_dentry_idx(dentry, dbstart(dentry));
+	lower_mnt = unionfs_lower_mnt_idx(dentry, dbstart(dentry));
 	if (!unionfs_lower_inode_idx(dentry->d_inode, bindex)) {
 		atomic_inc(&lower_dentry->d_inode->i_count);
 		unionfs_set_lower_inode_idx(dentry->d_inode, bindex,
 					    lower_dentry->d_inode);
 	}
 	lower_dir_dentry = lock_parent(lower_dentry);
-	err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
+	err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry, lower_mnt);
 	unlock_dir(lower_dir_dentry);
 
 out:
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -491,7 +491,8 @@ out_unlink:
 	 * quota, or something else happened so let's unlink; we don't
 	 * really care about the return value of vfs_unlink
 	 */
-	vfs_unlink(new_lower_parent_dentry->d_inode, new_lower_dentry);
+	vfs_unlink(new_lower_parent_dentry->d_inode, new_lower_dentry,
+		   new_lower_mnt);
 
 	if (copyup_file) {
 		/* need to close the file */
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -29,6 +29,7 @@ int do_delete_whiteouts(struct dentry *d
 	int err = 0;
 	struct dentry *lower_dir_dentry = NULL;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	char *name = NULL, *p;
 	struct inode *lower_dir;
 	int i;
@@ -37,6 +38,7 @@ int do_delete_whiteouts(struct dentry *d
 
 	/* Find out lower parent dentry */
 	lower_dir_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+	lower_mnt = unionfs_lower_mnt_idx(dentry, bindex);
 	BUG_ON(!S_ISDIR(lower_dir_dentry->d_inode->i_mode));
 	lower_dir = lower_dir_dentry->d_inode;
 	BUG_ON(!S_ISDIR(lower_dir->i_mode));
@@ -70,7 +72,8 @@ int do_delete_whiteouts(struct dentry *d
 				break;
 			}
 			if (lower_dentry->d_inode)
-				err = vfs_unlink(lower_dir, lower_dentry);
+				err = vfs_unlink(lower_dir, lower_dentry,
+						 lower_mnt);
 			dput(lower_dentry);
 			if (err)
 				break;
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -25,6 +25,7 @@ static int unionfs_create(struct inode *
 	struct dentry *lower_dentry = NULL;
 	struct vfsmount *lower_mnt = NULL;
 	struct dentry *wh_dentry = NULL;
+	struct vfsmount *wh_mnt = NULL;
 	struct dentry *lower_parent_dentry = NULL;
 	char *name = NULL;
 	int valid = 0;
@@ -75,6 +76,7 @@ static int unionfs_create(struct inode *
 
 		wh_dentry = lookup_one_len(name, lower_dentry->d_parent,
 					   dentry->d_name.len + UNIONFS_WHLEN);
+		wh_mnt = unionfs_lower_mnt(dentry);
 		if (IS_ERR(wh_dentry)) {
 			err = PTR_ERR(wh_dentry);
 			wh_dentry = NULL;
@@ -88,7 +90,8 @@ static int unionfs_create(struct inode *
 			struct dentry *lower_dir_dentry;
 
 			lower_dir_dentry = lock_parent(wh_dentry);
-			err = vfs_unlink(lower_dir_dentry->d_inode, wh_dentry);
+			err = vfs_unlink(lower_dir_dentry->d_inode, wh_dentry,
+					 wh_mnt);
 			unlock_dir(lower_dir_dentry);
 
 			/*
@@ -227,6 +230,7 @@ static int unionfs_link(struct dentry *o
 	struct vfsmount *lower_new_mnt = NULL;
 	struct dentry *lower_dir_dentry = NULL;
 	struct dentry *whiteout_dentry;
+	struct vfsmount *whiteout_mnt;
 	char *name = NULL;
 
 	unionfs_read_lock(old_dentry->d_sb);
@@ -257,6 +261,7 @@ static int unionfs_link(struct dentry *o
 	whiteout_dentry = lookup_one_len(name, lower_new_dentry->d_parent,
 					 new_dentry->d_name.len +
 					 UNIONFS_WHLEN);
+	whiteout_mnt = unionfs_lower_mnt(new_dentry);
 	if (IS_ERR(whiteout_dentry)) {
 		err = PTR_ERR(whiteout_dentry);
 		goto out;
@@ -271,7 +276,7 @@ static int unionfs_link(struct dentry *o
 		err = is_robranch_super(new_dentry->d_sb, dbstart(new_dentry));
 		if (!err)
 			err = vfs_unlink(lower_dir_dentry->d_inode,
-					 whiteout_dentry);
+					 whiteout_dentry, whiteout_mnt);
 
 		fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 		dir->i_nlink = unionfs_get_nlinks(dir);
@@ -383,6 +388,7 @@ static int unionfs_symlink(struct inode 
 	struct dentry *lower_dentry = NULL;
 	struct vfsmount *lower_mnt = NULL;
 	struct dentry *whiteout_dentry = NULL;
+	struct vfsmount *whiteout_mnt = NULL;
 	struct dentry *lower_dir_dentry = NULL;
 	umode_t mode;
 	int bindex = 0, bstart;
@@ -428,12 +434,13 @@ static int unionfs_symlink(struct inode 
 		 * found a .wh.foo entry, unlink it and then call
 		 * vfs_symlink().
 		 */
+		whiteout_mnt = unionfs_lower_mnt(dentry);
 		lower_dir_dentry = lock_parent(whiteout_dentry);
 
 		err = is_robranch_super(dentry->d_sb, bstart);
 		if (!err)
 			err = vfs_unlink(lower_dir_dentry->d_inode,
-					 whiteout_dentry);
+					 whiteout_dentry, whiteout_mnt);
 		dput(whiteout_dentry);
 
 		fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
@@ -547,7 +554,7 @@ static int unionfs_mkdir(struct inode *p
 {
 	int err = 0;
 	struct dentry *lower_dentry = NULL, *whiteout_dentry = NULL;
-	struct vfsmount *lower_mnt = NULL;
+	struct vfsmount *lower_mnt = NULL, *whiteout_mnt = NULL;
 	struct dentry *lower_parent_dentry = NULL;
 	int bindex = 0, bstart;
 	char *name = NULL;
@@ -588,6 +595,7 @@ static int unionfs_mkdir(struct inode *p
 		dput(whiteout_dentry);
 		whiteout_dentry = NULL;
 	} else {
+		whiteout_mnt = unionfs_lower_mnt(dentry);
 		lower_parent_dentry = lock_parent(whiteout_dentry);
 
 		/* found a.wh.foo entry, remove it then do vfs_mkdir */
@@ -595,6 +603,7 @@ static int unionfs_mkdir(struct inode *p
 		if (!err) {
 			args.unlink.parent = lower_parent_dentry->d_inode;
 			args.unlink.dentry = whiteout_dentry;
+			args.unlink.mnt = whiteout_mnt;
 			run_sioq(__unionfs_unlink, &args);
 			err = args.err;
 		}
@@ -704,7 +713,7 @@ static int unionfs_mknod(struct inode *d
 {
 	int err = 0;
 	struct dentry *lower_dentry = NULL, *whiteout_dentry = NULL;
-	struct vfsmount *lower_mnt = NULL;
+	struct vfsmount *lower_mnt = NULL, *whiteout_mnt = NULL;
 	struct dentry *lower_parent_dentry = NULL;
 	int bindex = 0, bstart;
 	char *name = NULL;
@@ -745,13 +754,14 @@ static int unionfs_mknod(struct inode *d
 		whiteout_dentry = NULL;
 	} else {
 		/* found .wh.foo, unlink it */
+		whiteout_mnt = unionfs_lower_mnt(dentry);
 		lower_parent_dentry = lock_parent(whiteout_dentry);
 
 		/* found a.wh.foo entry, remove it then do vfs_mkdir */
 		err = is_robranch_super(dentry->d_sb, bstart);
 		if (!err)
 			err = vfs_unlink(lower_parent_dentry->d_inode,
-					 whiteout_dentry);
+					 whiteout_dentry, whiteout_mnt);
 		dput(whiteout_dentry);
 
 		unlock_dir(lower_parent_dentry);
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -29,6 +29,7 @@ static int __unionfs_rename(struct inode
 	struct dentry *lower_old_dir_dentry;
 	struct dentry *lower_new_dir_dentry;
 	struct dentry *lower_wh_dentry;
+	struct vfsmount *lower_wh_mnt;
 	struct dentry *lower_wh_dir_dentry;
 	char *wh_name = NULL;
 
@@ -61,6 +62,7 @@ static int __unionfs_rename(struct inode
 	lower_wh_dentry = lookup_one_len(wh_name, lower_new_dentry->d_parent,
 					 new_dentry->d_name.len +
 					 UNIONFS_WHLEN);
+	lower_wh_mnt = lower_new_mnt;
 	if (IS_ERR(lower_wh_dentry)) {
 		err = PTR_ERR(lower_wh_dentry);
 		goto out;
@@ -81,7 +83,7 @@ static int __unionfs_rename(struct inode
 		err = is_robranch_super(old_dentry->d_sb, bindex);
 		if (!err)
 			err = vfs_unlink(lower_wh_dir_dentry->d_inode,
-					 lower_wh_dentry);
+					 lower_wh_dentry, lower_wh_mnt);
 
 		dput(lower_wh_dentry);
 		unlock_dir(lower_wh_dir_dentry);
@@ -194,16 +196,18 @@ static int do_unionfs_rename(struct inod
 	for (bindex = old_bstart - 1; bindex >= new_bstart; bindex--) {
 		struct dentry *unlink_dentry;
 		struct dentry *unlink_dir_dentry;
+		struct vfsmount *unlink_mnt;
 
 		unlink_dentry = unionfs_lower_dentry_idx(new_dentry, bindex);
 		if (!unlink_dentry)
 			continue;
 
+		unlink_mnt = unionfs_lower_mnt_idx(new_dentry, bindex);
 		unlink_dir_dentry = lock_parent(unlink_dentry);
 		err = is_robranch_super(old_dir->i_sb, bindex);
 		if (!err)
 			err = vfs_unlink(unlink_dir_dentry->d_inode,
-					 unlink_dentry);
+					 unlink_dentry, unlink_mnt);
 
 		fsstack_copy_attr_times(new_dentry->d_parent->d_inode,
 					unlink_dir_dentry->d_inode);
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -97,7 +97,7 @@ void __unionfs_unlink(struct work_struct
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct unlink_args *u = &args->unlink;
 
-	args->err = vfs_unlink(u->parent, u->dentry);
+	args->err = vfs_unlink(u->parent, u->dentry, u->mnt);
 	complete(&args->comp);
 }
 
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -58,6 +58,7 @@ struct symlink_args {
 struct unlink_args {
 	struct inode *parent;
 	struct dentry *dentry;
+	struct vfsmount *mnt;
 };
 
 
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -22,6 +22,7 @@
 static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry;
 	int bindex;
 	int err = 0;
@@ -36,13 +37,15 @@ static int unionfs_unlink_whiteout(struc
 	if (!lower_dentry)
 		goto out;
 
+	lower_mnt = unionfs_lower_mnt_idx(dentry, bindex);
 	lower_dir_dentry = lock_parent(lower_dentry);
 
 	/* avoid destroying the lower inode if the file is in use */
 	dget(lower_dentry);
 	err = is_robranch_super(dentry->d_sb, bindex);
 	if (!err)
-		err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
+		err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry,
+				 lower_mnt);
 	/* if vfs_unlink succeeded, update our inode's times */
 	if (!err)
 		unionfs_copy_attr_times(dentry->d_inode);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1075,7 +1075,7 @@ extern int vfs_mknod(struct inode *, str
 extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
 extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rmdir(struct inode *, struct dentry *, struct vfsmount *);
-extern int vfs_unlink(struct inode *, struct dentry *);
+extern int vfs_unlink(struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 
 /*
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -749,7 +749,7 @@ asmlinkage long sys_mq_unlink(const char
 	err = mnt_want_write(mqueue_mnt);
 	if (err)
 		goto out_err;
-	err = vfs_unlink(dentry->d_parent->d_inode, dentry);
+	err = vfs_unlink(dentry->d_parent->d_inode, dentry, mqueue_mnt);
 	mnt_drop_write(mqueue_mnt);
 out_err:
 	dput(dentry);

-- 

