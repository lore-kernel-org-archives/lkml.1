Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbXGLAYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbXGLAYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765926AbXGLARv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:17:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54214 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964862AbXGLARo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:44 -0400
Subject: [PATCH 21/23] sys_mknodat(): elevate write count for vfs_mknod/create()
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:38 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001738.3AF8A5F4@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This takes care of all of the direct callers of vfs_mknod().
Since a few of these cases also handle normal file creation
as well, this also covers some calls to vfs_create().

So that we don't have to make three mnt_want/drop_write()
calls inside of the switch statement, we move some of its
logic outside of the switch.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c         |   32 +++++++++++++++++++++-----------
 lxc-dave/fs/nfsd/vfs.c      |    4 ++++
 lxc-dave/net/unix/af_unix.c |    4 ++++
 3 files changed, 29 insertions(+), 11 deletions(-)

diff -puN fs/namei.c~sys-mknodat-elevate-write-count-for-vfs-mknod-create fs/namei.c
--- lxc/fs/namei.c~sys-mknodat-elevate-write-count-for-vfs-mknod-create	2007-07-10 12:46:15.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-07-11 10:10:55.000000000 -0700
@@ -1912,12 +1912,25 @@ asmlinkage long sys_mknodat(int dfd, con
 	if (error)
 		goto out;
 	dentry = lookup_create(&nd, 0);
-	error = PTR_ERR(dentry);
-
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out_unlock;
+	}
 	if (!IS_POSIXACL(nd.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	if (!IS_ERR(dentry)) {
-		switch (mode & S_IFMT) {
+	if (S_ISDIR(mode)) {
+		error = -EPERM;
+		goto out_dput;
+	}
+	if (!S_ISREG(mode)  && !S_ISCHR(mode)  && !S_ISBLK(mode) &&
+	    !S_ISFIFO(mode) && !S_ISSOCK(mode) && mode != 0) {
+		error = -EINVAL;
+		goto out_dput;
+	}
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_dput;
+	switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
 			error = vfs_create(nd.dentry->d_inode,dentry,mode,&nd);
 			break;
@@ -1928,14 +1941,11 @@ asmlinkage long sys_mknodat(int dfd, con
 		case S_IFIFO: case S_IFSOCK:
 			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,0);
 			break;
-		case S_IFDIR:
-			error = -EPERM;
-			break;
-		default:
-			error = -EINVAL;
-		}
-		dput(dentry);
 	}
+	mnt_drop_write(nd.mnt);
+out_dput:
+	dput(dentry);
+out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out:
diff -puN fs/nfsd/vfs.c~sys-mknodat-elevate-write-count-for-vfs-mknod-create fs/nfsd/vfs.c
--- lxc/fs/nfsd/vfs.c~sys-mknodat-elevate-write-count-for-vfs-mknod-create	2007-07-10 12:46:15.000000000 -0700
+++ lxc-dave/fs/nfsd/vfs.c	2007-07-10 12:46:15.000000000 -0700
@@ -1199,7 +1199,11 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	case S_IFBLK:
 	case S_IFIFO:
 	case S_IFSOCK:
+		host_err = mnt_want_write(fhp->fh_export->ex_mnt);
+		if (host_err)
+			break;
 		host_err = vfs_mknod(dirp, dchild, iap->ia_mode, rdev);
+		mnt_drop_write(fhp->fh_export->ex_mnt);
 		break;
 	default:
 	        printk("nfsd: bad file type %o in nfsd_create\n", type);
diff -puN net/unix/af_unix.c~sys-mknodat-elevate-write-count-for-vfs-mknod-create net/unix/af_unix.c
--- lxc/net/unix/af_unix.c~sys-mknodat-elevate-write-count-for-vfs-mknod-create	2007-07-10 12:46:15.000000000 -0700
+++ lxc-dave/net/unix/af_unix.c	2007-07-10 12:46:15.000000000 -0700
@@ -815,7 +815,11 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
+		err = mnt_want_write(nd.mnt);
+		if (err)
+			goto out_mknod_dput;
 		err = vfs_mknod(nd.dentry->d_inode, dentry, mode, 0);
+		mnt_drop_write(nd.mnt);
 		if (err)
 			goto out_mknod_dput;
 		mutex_unlock(&nd.dentry->d_inode->i_mutex);
_
