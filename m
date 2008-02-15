Return-Path: <linux-kernel-owner+w=401wt.eu-S1761108AbYBOWwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761108AbYBOWwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbYBOWiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:38:11 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39731 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbYBOWiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:38:01 -0500
Subject: [PATCH 27/30] r/o bind mounts: get callers of vfs_mknod/create()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:57 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223757.26182C0D@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This takes care of all of the direct callers of vfs_mknod().
Since a few of these cases also handle normal file creation
as well, this also covers some calls to vfs_create().

So that we don't have to make three mnt_want/drop_write()
calls inside of the switch statement, we move some of its
logic outside of the switch and into a helper function
suggested by Christoph.

This also encapsulates a fix for mknod(S_IFREG) that Miklos
found.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/namei.c         |   43 +++++++++++++++++++++++++---------
 linux-2.6.git-dave/fs/nfsd/vfs.c      |    4 +++
 linux-2.6.git-dave/net/unix/af_unix.c |    4 +++
 3 files changed, 40 insertions(+), 11 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create	2008-02-15 13:25:58.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-15 13:25:58.000000000 -0800
@@ -2038,6 +2038,23 @@ int vfs_mknod(struct inode *dir, struct 
 	return error;
 }
 
+static int may_mknod(mode_t mode)
+{
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
+	case 0: /* zero mode translates to S_IFREG */
+		return 0;
+	case S_IFDIR:
+		return -EPERM;
+	default:
+		return -EINVAL;
+	}
+}
+
 asmlinkage long sys_mknodat(int dfd, const char __user *filename, int mode,
 				unsigned dev)
 {
@@ -2056,12 +2073,19 @@ asmlinkage long sys_mknodat(int dfd, con
 	if (error)
 		goto out;
 	dentry = lookup_create(&nd, 0);
-	error = PTR_ERR(dentry);
-
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out_unlock;
+	}
 	if (!IS_POSIXACL(nd.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	if (!IS_ERR(dentry)) {
-		switch (mode & S_IFMT) {
+	error = may_mknod(mode);
+	if (error)
+		goto out_dput;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
+	switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
 			error = vfs_create(nd.path.dentry->d_inode,dentry,mode,&nd);
 			break;
@@ -2072,14 +2096,11 @@ asmlinkage long sys_mknodat(int dfd, con
 		case S_IFIFO: case S_IFSOCK:
 			error = vfs_mknod(nd.path.dentry->d_inode,dentry,mode,0);
 			break;
-		case S_IFDIR:
-			error = -EPERM;
-			break;
-		default:
-			error = -EINVAL;
-		}
-		dput(dentry);
 	}
+	mnt_drop_write(nd.path.mnt);
+out_dput:
+	dput(dentry);
+out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	path_put(&nd.path);
 out:
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create fs/nfsd/vfs.c
--- linux-2.6.git/fs/nfsd/vfs.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create	2008-02-15 13:25:58.000000000 -0800
+++ linux-2.6.git-dave/fs/nfsd/vfs.c	2008-02-15 13:25:58.000000000 -0800
@@ -1264,7 +1264,11 @@ nfsd_create(struct svc_rqst *rqstp, stru
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
diff -puN net/unix/af_unix.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create net/unix/af_unix.c
--- linux-2.6.git/net/unix/af_unix.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create	2008-02-15 13:25:58.000000000 -0800
+++ linux-2.6.git-dave/net/unix/af_unix.c	2008-02-15 13:25:58.000000000 -0800
@@ -819,7 +819,11 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
+		err = mnt_want_write(nd.path.mnt);
+		if (err)
+			goto out_mknod_dput;
 		err = vfs_mknod(nd.path.dentry->d_inode, dentry, mode, 0);
+		mnt_drop_write(nd.path.mnt);
 		if (err)
 			goto out_mknod_dput;
 		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
_
