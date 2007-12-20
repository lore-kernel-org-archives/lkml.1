Return-Path: <linux-kernel-owner+w=401wt.eu-S1763997AbXLTOU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763997AbXLTOU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932973AbXLTOLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:40778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955AbXLTOLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:52 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:44 2007
Message-Id: <20071220140944.349794673@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:29 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 19/47] Add struct vfsmount parameters to vfs_rename()
Content-Disposition: inline; filename=vfs-rename.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
 fs/unionfs/rename.c |    6 +++++-
 include/linux/fs.h  |    2 +-
 5 files changed, 26 insertions(+), 11 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -588,19 +588,24 @@ ecryptfs_rename(struct inode *old_dir, s
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
 	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2600,7 +2600,8 @@ asmlinkage long sys_link(const char __us
  *	   locking].
  */
 static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
-			  struct inode *new_dir, struct dentry *new_dentry)
+			  struct vfsmount *old_mnt, struct inode *new_dir,
+			  struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	int error = 0;
 	struct inode *target;
@@ -2643,7 +2644,8 @@ static int vfs_rename_dir(struct inode *
 }
 
 static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
-			    struct inode *new_dir, struct dentry *new_dentry)
+			    struct vfsmount *old_mnt, struct inode *new_dir,
+			    struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	struct inode *target;
 	int error;
@@ -2671,7 +2673,8 @@ static int vfs_rename_other(struct inode
 }
 
 int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-	       struct inode *new_dir, struct dentry *new_dentry)
+	        struct vfsmount *old_mnt, struct inode *new_dir,
+	        struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	int error;
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
@@ -2700,9 +2703,11 @@ int vfs_rename(struct inode *old_dir, st
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
@@ -2777,8 +2782,8 @@ static int do_rename(int olddfd, const c
 	error = mnt_want_write(oldnd.path.mnt);
 	if (error)
 		goto exit5;
-	error = vfs_rename(old_dir->d_inode, old_dentry,
-				   new_dir->d_inode, new_dentry);
+	error = vfs_rename(old_dir->d_inode, old_dentry, oldnd.path.mnt,
+			   new_dir->d_inode, new_dentry, newnd.path.mnt);
 	mnt_drop_write(oldnd.path.mnt);
 exit5:
 	dput(new_dentry);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1697,7 +1697,8 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 	if (host_err)
 		goto out_dput_new;
 
-	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
+	host_err = vfs_rename(fdir, odentry, ffhp->fh_export->ex_path.mnt,
+			      tdir, ndentry, tfhp->fh_export->ex_path.mnt);
 	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
 		host_err = nfsd_sync_dir(tdentry);
 		if (!host_err)
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -24,6 +24,7 @@ static int __unionfs_rename(struct inode
 {
 	int err = 0;
 	struct dentry *lower_old_dentry;
+	struct vfsmount *lower_old_mnt;
 	struct dentry *lower_new_dentry;
 	struct vfsmount *lower_new_mnt;
 	struct dentry *lower_old_dir_dentry;
@@ -34,7 +35,9 @@ static int __unionfs_rename(struct inode
 	char *wh_name = NULL;
 
 	lower_new_dentry = unionfs_lower_dentry_idx(new_dentry, bindex);
+	lower_new_mnt = unionfs_lower_mnt_idx(new_dentry, bindex);
 	lower_old_dentry = unionfs_lower_dentry_idx(old_dentry, bindex);
+	lower_old_mnt = unionfs_lower_mnt_idx(old_dentry, bindex);
 
 	if (!lower_new_dentry) {
 		lower_new_dentry =
@@ -126,7 +129,8 @@ static int __unionfs_rename(struct inode
 	}
 
 	err = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
-			 lower_new_dir_dentry->d_inode, lower_new_dentry);
+			 lower_old_mnt, lower_new_dir_dentry->d_inode,
+			 lower_new_dentry, lower_new_mnt);
 
 out_unlock:
 	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1076,7 +1076,7 @@ extern int vfs_symlink(struct inode *, s
 extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rmdir(struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_unlink(struct inode *, struct dentry *, struct vfsmount *);
-extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int vfs_rename(struct inode *, struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 
 /*
  * VFS dentry helper functions.

-- 

