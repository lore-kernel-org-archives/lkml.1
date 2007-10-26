Return-Path: <linux-kernel-owner+w=401wt.eu-S1764094AbXJZHDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764094AbXJZHDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760700AbXJZG5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:57:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:36885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895AbXJZG5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:57:44 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:49 2007
Message-Id: <20071026064049.251161668@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:41 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 17/45] Add a struct vfsmount parameter to vfs_unlink()
Content-Disposition: inline; filename=vfs-unlink.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c   |    3 ++-
 fs/namei.c            |    4 ++--
 fs/nfsd/nfs4recover.c |    2 +-
 fs/nfsd/vfs.c         |    2 +-
 include/linux/fs.h    |    2 +-
 ipc/mqueue.c          |    2 +-
 6 files changed, 8 insertions(+), 7 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -444,10 +444,11 @@ static int ecryptfs_unlink(struct inode 
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
@@ -2201,7 +2201,7 @@ asmlinkage long sys_rmdir(const char __u
 	return do_rmdir(AT_FDCWD, pathname);
 }
 
-int vfs_unlink(struct inode *dir, struct dentry *dentry)
+int vfs_unlink(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt)
 {
 	int error = may_delete(dir, dentry, 0);
 
@@ -2268,7 +2268,7 @@ static long do_unlinkat(int dfd, const c
 		error = mnt_want_write(nd.mnt);
 		if (error)
 			goto exit2;
-		error = vfs_unlink(nd.dentry->d_inode, dentry);
+		error = vfs_unlink(nd.dentry->d_inode, dentry, nd.mnt);
 		mnt_drop_write(nd.mnt);
 	exit2:
 		dput(dentry);
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -265,7 +265,7 @@ nfsd4_remove_clid_file(struct dentry *di
 		return -EINVAL;
 	}
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
-	status = vfs_unlink(dir->d_inode, dentry);
+	status = vfs_unlink(dir->d_inode, dentry, rec_dir.mnt);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	return status;
 }
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1768,7 +1768,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 			host_err = -EPERM;
 		} else
 #endif
-		host_err = vfs_unlink(dirp, rdentry);
+		host_err = vfs_unlink(dirp, rdentry, exp->ex_mnt);
 	} else { /* It's RMDIR */
 		host_err = vfs_rmdir(dirp, rdentry, exp->ex_mnt);
 	}
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1079,7 +1079,7 @@ extern int vfs_mknod(struct inode *, str
 extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
 extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rmdir(struct inode *, struct dentry *, struct vfsmount *);
-extern int vfs_unlink(struct inode *, struct dentry *);
+extern int vfs_unlink(struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 
 /*
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -750,7 +750,7 @@ asmlinkage long sys_mq_unlink(const char
 	err = mnt_want_write(mqueue_mnt);
 	if (err)
 		goto out_err;
-	err = vfs_unlink(dentry->d_parent->d_inode, dentry);
+	err = vfs_unlink(dentry->d_parent->d_inode, dentry, mqueue_mnt);
 	mnt_drop_write(mqueue_mnt);
 out_err:
 	dput(dentry);

-- 

