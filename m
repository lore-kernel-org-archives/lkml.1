Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbXFZXSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbXFZXSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758221AbXFZXLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:11:03 -0400
Received: from ns1.suse.de ([195.135.220.2]:42928 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760005AbXFZXKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:10:55 -0400
Message-Id: <20070626231011.023065737@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:15 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 19/44] Add struct vfsmount parameters to vfs_rename()
Content-Disposition: inline; filename=vfs-rename.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c |    7 ++++++-
 fs/namei.c          |   19 ++++++++++++-------
 fs/nfsd/vfs.c       |    3 ++-
 include/linux/fs.h  |    2 +-
 4 files changed, 21 insertions(+), 10 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -598,19 +598,24 @@ ecryptfs_rename(struct inode *old_dir, s
 {
 	int rc;
 	struct dentry *lower_old_dentry;
+	struct vfsmount *lower_old_mnt;
 	struct dentry *lower_new_dentry;
+	struct vfsmount *lower_new_mnt;
 	struct dentry *lower_old_dir_dentry;
 	struct dentry *lower_new_dir_dentry;
 
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
+	lower_old_mnt = ecryptfs_dentry_to_lower_mnt(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
+	lower_new_mnt = ecryptfs_dentry_to_lower_mnt(new_dentry);
 	dget(lower_old_dentry);
 	dget(lower_new_dentry);
 	lower_old_dir_dentry = dget_parent(lower_old_dentry);
 	lower_new_dir_dentry = dget_parent(lower_new_dentry);
 	lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	rc = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
-			lower_new_dir_dentry->d_inode, lower_new_dentry);
+			lower_old_mnt, lower_new_dir_dentry->d_inode,
+			lower_new_dentry, lower_new_mnt);
 	if (rc)
 		goto out_lock;
 	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode, NULL);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2401,7 +2401,8 @@ asmlinkage long sys_link(const char __us
  *	   locking].
  */
 static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
-			  struct inode *new_dir, struct dentry *new_dentry)
+			  struct vfsmount *old_mnt, struct inode *new_dir,
+			  struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	int error = 0;
 	struct inode *target;
@@ -2444,7 +2445,8 @@ static int vfs_rename_dir(struct inode *
 }
 
 static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
-			    struct inode *new_dir, struct dentry *new_dentry)
+			    struct vfsmount *old_mnt, struct inode *new_dir,
+			    struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	struct inode *target;
 	int error;
@@ -2472,7 +2474,8 @@ static int vfs_rename_other(struct inode
 }
 
 int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-	       struct inode *new_dir, struct dentry *new_dentry)
+	        struct vfsmount *old_mnt, struct inode *new_dir,
+	        struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	int error;
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
@@ -2501,9 +2504,11 @@ int vfs_rename(struct inode *old_dir, st
 	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
 
 	if (is_dir)
-		error = vfs_rename_dir(old_dir,old_dentry,new_dir,new_dentry);
+		error = vfs_rename_dir(old_dir, old_dentry, old_mnt,
+				       new_dir, new_dentry, new_mnt);
 	else
-		error = vfs_rename_other(old_dir,old_dentry,new_dir,new_dentry);
+		error = vfs_rename_other(old_dir, old_dentry, old_mnt,
+					 new_dir, new_dentry, new_mnt);
 	if (!error) {
 		const char *new_name = old_dentry->d_name.name;
 		fsnotify_move(old_dir, new_dir, old_name, new_name, is_dir,
@@ -2575,8 +2580,8 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
-	error = vfs_rename(old_dir->d_inode, old_dentry,
-				   new_dir->d_inode, new_dentry);
+	error = vfs_rename(old_dir->d_inode, old_dentry, oldnd.mnt,
+			   new_dir->d_inode, new_dentry, newnd.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1630,7 +1630,8 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 			host_err = -EPERM;
 	} else
 #endif
-	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
+	host_err = vfs_rename(fdir, odentry, ffhp->fh_export->ex_mnt,
+			      tdir, ndentry, tfhp->fh_export->ex_mnt);
 	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
 		host_err = nfsd_sync_dir(tdentry);
 		if (!host_err)
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -999,7 +999,7 @@ extern int vfs_symlink(struct inode *, s
 extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rmdir(struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_unlink(struct inode *, struct dentry *, struct vfsmount *);
-extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int vfs_rename(struct inode *, struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 
 /*
  * VFS dentry helper functions.

-- 
