Return-Path: <linux-kernel-owner+w=401wt.eu-S1946150AbXBIWzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946150AbXBIWzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946149AbXBIWyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:23 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42467 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423369AbXBIWxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:44 -0500
Subject: [PATCH 16/22] sys_mknodat(): elevate write count for vfs_mknod/create()
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:40 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225340.765CBDFD@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This takes care of all of the direct callers of vfs_mknod().
Since a few of these cases also handle normal file creation
as well, this also covers some calls to vfs_create().

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c         |   12 ++++++++++++
 lxc-dave/fs/nfsd/vfs.c      |    4 ++++
 lxc-dave/net/unix/af_unix.c |    4 ++++
 3 files changed, 20 insertions(+)

diff -puN fs/namei.c~18-24-sys-mknodat-elevate-write-count-for-vfs-mknod-create fs/namei.c
--- lxc/fs/namei.c~18-24-sys-mknodat-elevate-write-count-for-vfs-mknod-create	2007-02-09 14:26:57.000000000 -0800
+++ lxc-dave/fs/namei.c	2007-02-09 14:26:57.000000000 -0800
@@ -1903,14 +1903,26 @@ asmlinkage long sys_mknodat(int dfd, con
 	if (!IS_ERR(dentry)) {
 		switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
+			error = mnt_want_write(nd.mnt);
+			if (error)
+				break;
 			error = vfs_create(nd.dentry->d_inode,dentry,mode,&nd);
+			mnt_drop_write(nd.mnt);
 			break;
 		case S_IFCHR: case S_IFBLK:
+			error = mnt_want_write(nd.mnt);
+			if (error)
+				break;
 			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,
 					new_decode_dev(dev));
+			mnt_drop_write(nd.mnt);
 			break;
 		case S_IFIFO: case S_IFSOCK:
+			error = mnt_want_write(nd.mnt);
+			if (error)
+				break;
 			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,0);
+			mnt_drop_write(nd.mnt);
 			break;
 		case S_IFDIR:
 			error = -EPERM;
diff -puN fs/nfsd/vfs.c~18-24-sys-mknodat-elevate-write-count-for-vfs-mknod-create fs/nfsd/vfs.c
--- lxc/fs/nfsd/vfs.c~18-24-sys-mknodat-elevate-write-count-for-vfs-mknod-create	2007-02-09 14:26:57.000000000 -0800
+++ lxc-dave/fs/nfsd/vfs.c	2007-02-09 14:26:57.000000000 -0800
@@ -664,6 +664,9 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	/* Disallow write access to files with the append-only bit set
 	 * or any access when mandatory locking enabled
 	 */
+	err = mnt_want_write(fhp->fh_export->ex_mnt);
+	if (err)
+		goto out_nfserr;
 	err = nfserr_perm;
 	if (IS_APPEND(inode) && (access & MAY_WRITE))
 		goto out;
@@ -1199,6 +1202,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	        printk("nfsd: bad file type %o in nfsd_create\n", type);
 		host_err = -EINVAL;
 	}
+	mnt_drop_write(fhp->fh_export->ex_mnt);
 	if (host_err < 0)
 		goto out_nfserr;
 
diff -puN net/unix/af_unix.c~18-24-sys-mknodat-elevate-write-count-for-vfs-mknod-create net/unix/af_unix.c
--- lxc/net/unix/af_unix.c~18-24-sys-mknodat-elevate-write-count-for-vfs-mknod-create	2007-02-09 14:26:57.000000000 -0800
+++ lxc-dave/net/unix/af_unix.c	2007-02-09 14:26:57.000000000 -0800
@@ -816,7 +816,11 @@ static int unix_bind(struct socket *sock
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
