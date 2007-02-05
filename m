Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbXBES0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbXBES0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933170AbXBES0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:26:03 -0500
Received: from mx1.suse.de ([195.135.220.2]:43350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168AbXBESZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:25:52 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:24:54 -0800
Message-Id: <20070205182454.12164.33929.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 17/28] Add a struct vfsmount parameter to vfs_unlink()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a struct vfsmount parameter to vfs_unlink()

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c
+++ linux-2.6/fs/ecryptfs/inode.c
@@ -445,10 +445,11 @@ static int ecryptfs_unlink(struct inode 
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
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2086,7 +2086,7 @@ asmlinkage long sys_rmdir(const char __u
 	return do_rmdir(AT_FDCWD, pathname);
 }
 
-int vfs_unlink(struct inode *dir, struct dentry *dentry)
+int vfs_unlink(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt)
 {
 	int error = may_delete(dir, dentry, 0);
 
@@ -2150,7 +2150,7 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
-		error = vfs_unlink(nd.dentry->d_inode, dentry);
+		error = vfs_unlink(nd.dentry->d_inode, dentry, nd.mnt);
 	exit2:
 		dput(dentry);
 	}
Index: linux-2.6/fs/nfsd/nfs4recover.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs4recover.c
+++ linux-2.6/fs/nfsd/nfs4recover.c
@@ -260,7 +260,7 @@ nfsd4_remove_clid_file(struct dentry *di
 		return -EINVAL;
 	}
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
-	status = vfs_unlink(dir->d_inode, dentry);
+	status = vfs_unlink(dir->d_inode, dentry, NULL);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	return status;
 }
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c
+++ linux-2.6/fs/nfsd/vfs.c
@@ -1692,7 +1692,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 			host_err = -EPERM;
 		} else
 #endif
-		host_err = vfs_unlink(dirp, rdentry);
+		host_err = vfs_unlink(dirp, rdentry, NULL);
 	} else { /* It's RMDIR */
 		host_err = vfs_rmdir(dirp, rdentry, NULL);
 	}
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -984,7 +984,7 @@ extern int vfs_mknod(struct inode *, str
 extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
 extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rmdir(struct inode *, struct dentry *, struct vfsmount *);
-extern int vfs_unlink(struct inode *, struct dentry *);
+extern int vfs_unlink(struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 
 /*
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c
+++ linux-2.6/ipc/mqueue.c
@@ -747,7 +747,7 @@ asmlinkage long sys_mq_unlink(const char
 	if (inode)
 		atomic_inc(&inode->i_count);
 
-	err = vfs_unlink(dentry->d_parent->d_inode, dentry);
+	err = vfs_unlink(dentry->d_parent->d_inode, dentry, mqueue_mnt);
 out_err:
 	dput(dentry);
 
