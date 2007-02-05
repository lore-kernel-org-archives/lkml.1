Return-Path: <linux-kernel-owner+w=401wt.eu-S933301AbXBESbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbXBESbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933298AbXBESaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:30:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173AbXBES0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:26:09 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:25:11 -0800
Message-Id: <20070205182511.12164.62940.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 19/28] Add struct vfsmount parameters to vfs_rename()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add struct vfsmount parameters to vfs_rename()

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c
+++ linux-2.6/fs/ecryptfs/inode.c
@@ -590,19 +590,24 @@ ecryptfs_rename(struct inode *old_dir, s
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
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2382,7 +2382,8 @@ asmlinkage long sys_link(const char __us
  *	   locking].
  */
 static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
-			  struct inode *new_dir, struct dentry *new_dentry)
+			  struct vfsmount *old_mnt, struct inode *new_dir,
+			  struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	int error = 0;
 	struct inode *target;
@@ -2425,7 +2426,8 @@ static int vfs_rename_dir(struct inode *
 }
 
 static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
-			    struct inode *new_dir, struct dentry *new_dentry)
+			    struct vfsmount *old_mnt, struct inode *new_dir,
+			    struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	struct inode *target;
 	int error;
@@ -2453,7 +2455,8 @@ static int vfs_rename_other(struct inode
 }
 
 int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-	       struct inode *new_dir, struct dentry *new_dentry)
+	        struct vfsmount *old_mnt, struct inode *new_dir,
+	        struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	int error;
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
@@ -2482,9 +2485,11 @@ int vfs_rename(struct inode *old_dir, st
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
@@ -2556,8 +2561,8 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
-	error = vfs_rename(old_dir->d_inode, old_dentry,
-				   new_dir->d_inode, new_dentry);
+	error = vfs_rename(old_dir->d_inode, old_dentry, oldnd.mnt,
+			   new_dir->d_inode, new_dentry, newnd.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c
+++ linux-2.6/fs/nfsd/vfs.c
@@ -1620,7 +1620,7 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 			host_err = -EPERM;
 	} else
 #endif
-	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
+	host_err = vfs_rename(fdir, odentry, NULL, tdir, ndentry, NULL);
 	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
 		host_err = nfsd_sync_dir(tdentry);
 		if (!host_err)
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -985,7 +985,7 @@ extern int vfs_symlink(struct inode *, s
 extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rmdir(struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_unlink(struct inode *, struct dentry *, struct vfsmount *);
-extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int vfs_rename(struct inode *, struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 
 /*
  * VFS dentry helper functions.
