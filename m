Return-Path: <linux-kernel-owner+w=401wt.eu-S1761421AbYBHW3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421AbYBHW3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758328AbYBHW1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:27:01 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56350 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497AbYBHW05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:26:57 -0500
Subject: [RFC][PATCH 04/30] fix up new filp allocators
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:26:51 -0800
References: <20080208222641.6024A7CC@kernel>
In-Reply-To: <20080208222641.6024A7CC@kernel>
Message-Id: <20080208222651.285EE5A8@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some new uses of get_empty_filp() have crept in, and are
not properly taking mnt_want_write()s.  This fixes them
up.

We really need to kill get_empty_filp().

Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/anon_inodes.c |   16 ++++++----------
 linux-2.6.git-dave/fs/file_table.c  |    6 ++++++
 linux-2.6.git-dave/fs/pipe.c        |   19 +++++++++----------
 3 files changed, 21 insertions(+), 20 deletions(-)

diff -puN fs/anon_inodes.c~fix-up-new-filp-allocators fs/anon_inodes.c
--- linux-2.6.git/fs/anon_inodes.c~fix-up-new-filp-allocators	2008-02-08 13:04:45.000000000 -0800
+++ linux-2.6.git-dave/fs/anon_inodes.c	2008-02-08 13:04:45.000000000 -0800
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
diff -puN fs/file_table.c~fix-up-new-filp-allocators fs/file_table.c
--- linux-2.6.git/fs/file_table.c~fix-up-new-filp-allocators	2008-02-08 13:04:45.000000000 -0800
+++ linux-2.6.git-dave/fs/file_table.c	2008-02-08 13:04:45.000000000 -0800
@@ -83,6 +83,12 @@ int proc_nr_files(ctl_table *table, int 
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
diff -puN fs/pipe.c~fix-up-new-filp-allocators fs/pipe.c
--- linux-2.6.git/fs/pipe.c~fix-up-new-filp-allocators	2008-02-08 13:04:45.000000000 -0800
+++ linux-2.6.git-dave/fs/pipe.c	2008-02-08 13:04:45.000000000 -0800
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
@@ -980,22 +977,24 @@ struct file *create_write_pipe(void)
 	 */
 	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, inode);
-	f->f_path.mnt = mntget(pipe_mnt);
-	f->f_path.dentry = dentry;
+
+	err = -ENFILE;
+	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_pipe_fops);
+	if (!f)
+		goto err_dentry;
 	f->f_mapping = inode->i_mapping;
 
 	f->f_flags = O_WRONLY;
-	f->f_op = &write_pipe_fops;
-	f->f_mode = FMODE_WRITE;
 	f->f_version = 0;
 
 	return f;
 
+ err_dentry:
+	dput(dentry);
  err_inode:
 	free_pipe_info(inode);
 	iput(inode);
- err_file:
-	put_filp(f);
+ err:
 	return ERR_PTR(err);
 }
 
_
