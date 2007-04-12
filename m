Return-Path: <linux-kernel-owner+w=401wt.eu-S1946024AbXDLJmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946024AbXDLJmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945982AbXDLJlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:41:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:56751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946024AbXDLJkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:37 -0400
Message-Id: <20070412090841.432714000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:25 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 16/41] Add a struct vfsmount parameter to vfs_rmdir()
Content-Disposition: inline; filename=vfs-rmdir.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c   |    4 +++-
 fs/namei.c            |    4 ++--
 fs/nfsd/nfs4recover.c |    2 +-
 fs/nfsd/vfs.c         |    2 +-
 fs/reiserfs/xattr.c   |    2 +-
 include/linux/fs.h    |    2 +-
 6 files changed, 9 insertions(+), 7 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -542,14 +542,16 @@ out:
 static int ecryptfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry;
 	int rc;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	dget(dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
 	dget(lower_dentry);
-	rc = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry);
+	rc = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry, lower_mnt);
 	dput(lower_dentry);
 	if (!rc)
 		d_delete(lower_dentry);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2006,7 +2006,7 @@ void dentry_unhash(struct dentry *dentry
 	spin_unlock(&dcache_lock);
 }
 
-int vfs_rmdir(struct inode *dir, struct dentry *dentry)
+int vfs_rmdir(struct inode *dir, struct dentry *dentry,struct vfsmount *mnt)
 {
 	int error = may_delete(dir, dentry, 1);
 
@@ -2070,7 +2070,7 @@ static long do_rmdir(int dfd, const char
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
-	error = vfs_rmdir(nd.dentry->d_inode, dentry);
+	error = vfs_rmdir(nd.dentry->d_inode, dentry, nd.mnt);
 	dput(dentry);
 exit2:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -276,7 +276,7 @@ nfsd4_clear_clid_dir(struct dentry *dir,
 	 * a kernel from the future.... */
 	nfsd4_list_rec_dir(dentry, nfsd4_remove_clid_file);
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
-	status = vfs_rmdir(dir->d_inode, dentry);
+	status = vfs_rmdir(dir->d_inode, dentry, rec_dir.mnt);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	return status;
 }
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1702,7 +1702,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 #endif
 		host_err = vfs_unlink(dirp, rdentry);
 	} else { /* It's RMDIR */
-		host_err = vfs_rmdir(dirp, rdentry);
+		host_err = vfs_rmdir(dirp, rdentry, fhp->fh_export->ex_mnt);
 	}
 
 	dput(rdentry);
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -823,7 +823,7 @@ int reiserfs_delete_xattrs(struct inode 
 	if (dir->d_inode->i_nlink <= 2) {
 		root = get_xa_root(inode->i_sb);
 		reiserfs_write_lock_xattrs(inode->i_sb);
-		err = vfs_rmdir(root->d_inode, dir);
+		err = vfs_rmdir(root->d_inode, dir, NULL);
 		reiserfs_write_unlock_xattrs(inode->i_sb);
 		dput(root);
 	} else {
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -984,7 +984,7 @@ extern int vfs_mkdir(struct inode *, str
 extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
 extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
-extern int vfs_rmdir(struct inode *, struct dentry *);
+extern int vfs_rmdir(struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 

-- 
