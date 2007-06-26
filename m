Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbXFZXRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbXFZXRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759968AbXFZXKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:10:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759948AbXFZXKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:10:48 -0400
Message-Id: <20070626231002.641179447@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:13 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 17/44] Add a struct vfsmount parameter to vfs_unlink()
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
@@ -453,10 +453,11 @@ static int ecryptfs_unlink(struct inode 
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
@@ -2105,7 +2105,7 @@ asmlinkage long sys_rmdir(const char __u
 	return do_rmdir(AT_FDCWD, pathname);
 }
 
-int vfs_unlink(struct inode *dir, struct dentry *dentry)
+int vfs_unlink(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt)
 {
 	int error = may_delete(dir, dentry, 0);
 
@@ -2169,7 +2169,7 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
-		error = vfs_unlink(nd.dentry->d_inode, dentry);
+		error = vfs_unlink(nd.dentry->d_inode, dentry, nd.mnt);
 	exit2:
 		dput(dentry);
 	}
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -261,7 +261,7 @@ nfsd4_remove_clid_file(struct dentry *di
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
@@ -1704,7 +1704,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
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
@@ -998,7 +998,7 @@ extern int vfs_mknod(struct inode *, str
 extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
 extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rmdir(struct inode *, struct dentry *, struct vfsmount *);
-extern int vfs_unlink(struct inode *, struct dentry *);
+extern int vfs_unlink(struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 
 /*
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -748,7 +748,7 @@ asmlinkage long sys_mq_unlink(const char
 	if (inode)
 		atomic_inc(&inode->i_count);
 
-	err = vfs_unlink(dentry->d_parent->d_inode, dentry);
+	err = vfs_unlink(dentry->d_parent->d_inode, dentry, mqueue_mnt);
 out_err:
 	dput(dentry);
 

-- 
