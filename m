Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbXKIVFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbXKIVFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbXKIVFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:05:20 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33370 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbXKIVFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:05:18 -0500
Subject: [PATCH 2/2] fix up new filp allocators
To: ezk@cs.sunysb.edu
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 09 Nov 2007 13:04:40 -0800
References: <20071109210439.122065A3@kernel>
In-Reply-To: <20071109210439.122065A3@kernel>
Message-Id: <20071109210440.497630FB@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Some new uses of get_empty_filp() have crept in, and are
not properly taking mnt_want_write()s.  This fixes them
up.

We really need to kill get_empty_filp().

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/anon_inodes.c    |   16 ++++++----------
 linux-2.6.git-dave/fs/file_table.c     |    6 ++++++
 linux-2.6.git-dave/fs/nfsd/nfs4state.c |    3 ++-
 linux-2.6.git-dave/fs/pipe.c           |   17 +++++++----------
 4 files changed, 21 insertions(+), 21 deletions(-)

diff -puN fs/anon_inodes.c~fix-idmapd-bug fs/anon_inodes.c
--- linux-2.6.git/fs/anon_inodes.c~fix-idmapd-bug	2007-11-09 12:13:15.000000000 -0800
+++ linux-2.6.git-dave/fs/anon_inodes.c	2007-11-09 12:13:15.000000000 -0800
@@ -81,13 +81,10 @@ int anon_inode_getfd(int *pfd, struct in
 
 	if (IS_ERR(anon_inode_inode))
 		return -ENODEV;
-	file = get_empty_filp();
-	if (!file)
-		return -ENFILE;
 
 	error = get_unused_fd();
 	if (error < 0)
-		goto err_put_filp;
+		return error;
 	fd = error;
 
 	/*
@@ -114,14 +111,15 @@ int anon_inode_getfd(int *pfd, struct in
 	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, anon_inode_inode);
 
-	file->f_path.mnt = mntget(anon_inode_mnt);
-	file->f_path.dentry = dentry;
+	error = -ENFILE;
+	file = alloc_file(anon_inode_mnt, dentry,
+			  FMODE_READ | FMODE_WRITE, fops);
+	if (!file)
+		goto err_put_unused_fd;
 	file->f_mapping = anon_inode_inode->i_mapping;
 
 	file->f_pos = 0;
 	file->f_flags = O_RDWR;
-	file->f_op = fops;
-	file->f_mode = FMODE_READ | FMODE_WRITE;
 	file->f_version = 0;
 	file->private_data = priv;
 
@@ -134,8 +132,6 @@ int anon_inode_getfd(int *pfd, struct in
 
 err_put_unused_fd:
 	put_unused_fd(fd);
-err_put_filp:
-	put_filp(file);
 	return error;
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
diff -puN fs/file_table.c~fix-idmapd-bug fs/file_table.c
--- linux-2.6.git/fs/file_table.c~fix-idmapd-bug	2007-11-09 12:13:15.000000000 -0800
+++ linux-2.6.git-dave/fs/file_table.c	2007-11-09 12:13:15.000000000 -0800
@@ -89,6 +89,12 @@ int proc_nr_files(ctl_table *table, int 
 /* Find an unused file structure and return a pointer to it.
  * Returns NULL, if there are no more free file structures or
  * we run out of memory.
+ *
+ * Be very careful using this.  You are responsible for
+ * getting write access to any mount that you might assign
+ * to this filp, if it is opened for write.  If this is not
+ * done, you will imbalance int the mount's writer count
+ * and a warning at __fput() time.
  */
 struct file *get_empty_filp(void)
 {
diff -puN fs/nfsd/nfs4state.c~fix-idmapd-bug fs/nfsd/nfs4state.c
--- linux-2.6.git/fs/nfsd/nfs4state.c~fix-idmapd-bug	2007-11-09 12:13:15.000000000 -0800
+++ linux-2.6.git-dave/fs/nfsd/nfs4state.c	2007-11-09 12:13:15.000000000 -0800
@@ -41,6 +41,7 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/cache.h>
+#include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/workqueue.h>
 #include <linux/smp_lock.h>
@@ -1303,7 +1304,7 @@ static inline void
 nfs4_file_downgrade(struct file *filp, unsigned int share_access)
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
-		put_write_access(filp->f_path.dentry->d_inode);
+		drop_file_write_access(filp);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
 	}
 }
diff -puN fs/pipe.c~fix-idmapd-bug fs/pipe.c
--- linux-2.6.git/fs/pipe.c~fix-idmapd-bug	2007-11-09 12:13:15.000000000 -0800
+++ linux-2.6.git-dave/fs/pipe.c	2007-11-09 12:13:15.000000000 -0800
@@ -959,13 +959,10 @@ struct file *create_write_pipe(void)
 	struct dentry *dentry;
 	struct qstr name = { .name = "" };
 
-	f = get_empty_filp();
-	if (!f)
-		return ERR_PTR(-ENFILE);
 	err = -ENFILE;
 	inode = get_pipe_inode();
 	if (!inode)
-		goto err_file;
+		goto err;
 
 	err = -ENOMEM;
 	dentry = d_alloc(pipe_mnt->mnt_sb->s_root, &name);
@@ -980,13 +977,14 @@ struct file *create_write_pipe(void)
 	 */
 	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, inode);
-	f->f_path.mnt = mntget(pipe_mnt);
-	f->f_path.dentry = dentry;
+
+	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_pipe_fops);
+	err = -ENFILE;
+	if (!f)
+		goto err_inode;
 	f->f_mapping = inode->i_mapping;
 
 	f->f_flags = O_WRONLY;
-	f->f_op = &write_pipe_fops;
-	f->f_mode = FMODE_WRITE;
 	f->f_version = 0;
 
 	return f;
@@ -994,8 +992,7 @@ struct file *create_write_pipe(void)
  err_inode:
 	free_pipe_info(inode);
 	iput(inode);
- err_file:
-	put_filp(f);
+ err:
 	return ERR_PTR(err);
 }
 
_
