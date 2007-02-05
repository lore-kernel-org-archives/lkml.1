Return-Path: <linux-kernel-owner+w=401wt.eu-S933149AbXBESZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbXBESZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933160AbXBESZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:25:28 -0500
Received: from mail.suse.de ([195.135.220.2]:43302 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933141AbXBESZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:25:17 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:24:19 -0800
Message-Id: <20070205182419.12164.59012.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 13/28] Add struct vfsmount parameters to vfs_link()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add struct vfsmount parameters to vfs_link()

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2250,7 +2250,7 @@ asmlinkage long sys_symlink(const char _
 	return sys_symlinkat(oldname, AT_FDCWD, newname);
 }
 
-int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
+int vfs_link(struct dentry *old_dentry, struct vfsmount *old_mnt, struct inode *dir, struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	struct inode *inode = old_dentry->d_inode;
 	int error;
@@ -2328,7 +2328,8 @@ asmlinkage long sys_linkat(int olddfd, c
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out_unlock;
-	error = vfs_link(old_nd.dentry, nd.dentry->d_inode, new_dentry);
+	error = vfs_link(old_nd.dentry, old_nd.mnt, nd.dentry->d_inode,
+			 new_dentry, nd.mnt);
 	dput(new_dentry);
 out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -982,7 +982,7 @@ extern int vfs_create(struct inode *, st
 extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
-extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
+extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c
+++ linux-2.6/fs/ecryptfs/inode.c
@@ -403,19 +403,24 @@ static int ecryptfs_link(struct dentry *
 			 struct dentry *new_dentry)
 {
 	struct dentry *lower_old_dentry;
+	struct vfsmount *lower_old_mnt;
 	struct dentry *lower_new_dentry;
+	struct vfsmount *lower_new_mnt;
 	struct dentry *lower_dir_dentry;
 	u64 file_size_save;
 	int rc;
 
 	file_size_save = i_size_read(old_dentry->d_inode);
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
+	lower_old_mnt = ecryptfs_dentry_to_lower_mnt(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
+	lower_new_mnt = ecryptfs_dentry_to_lower_mnt(new_dentry);
 	dget(lower_old_dentry);
 	dget(lower_new_dentry);
 	lower_dir_dentry = lock_parent(lower_new_dentry);
-	rc = vfs_link(lower_old_dentry, lower_dir_dentry->d_inode,
-		      lower_new_dentry);
+	rc = vfs_link(lower_old_dentry, lower_old_mnt,
+		      lower_dir_dentry->d_inode, lower_new_dentry,
+		      lower_new_mnt);
 	if (rc || !lower_new_dentry->d_inode)
 		goto out_lock;
 	rc = ecryptfs_interpose(lower_new_dentry, new_dentry, dir->i_sb, 0);
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c
+++ linux-2.6/fs/nfsd/vfs.c
@@ -1527,7 +1527,7 @@ nfsd_link(struct svc_rqst *rqstp, struct
 	dold = tfhp->fh_dentry;
 	dest = dold->d_inode;
 
-	host_err = vfs_link(dold, dirp, dnew);
+	host_err = vfs_link(dold, NULL, dirp, dnew, NULL);
 	if (!host_err) {
 		if (EX_ISSYNC(ffhp->fh_export)) {
 			err = nfserrno(nfsd_sync_dir(ddir));
