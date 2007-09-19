Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbXISV03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbXISV03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXISVZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:25:09 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52803 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbXISVZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:25:01 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 1/6] Unionfs: use bool type in dentry and file revalidation code
Date: Wed, 19 Sep 2007 17:24:35 -0400
Message-Id: <11902370813936-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
References: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   12 ++++++------
 fs/unionfs/dentry.c     |    2 +-
 fs/unionfs/dirfops.c    |    4 ++--
 fs/unionfs/file.c       |   12 ++++++------
 fs/unionfs/mmap.c       |    6 +++---
 fs/unionfs/union.h      |    2 +-
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 724128d..87cbb09 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -190,7 +190,7 @@ out:
 }
 
 /* open the highest priority file for a given upper file */
-static int open_highest_file(struct file *file, int willwrite)
+static int open_highest_file(struct file *file, bool willwrite)
 {
 	int bindex, bstart, bend, err = 0;
 	struct file *lower_file;
@@ -298,9 +298,9 @@ out:
 /*
  * Revalidate the struct file
  * @file: file to revalidate
- * @willwrite: 1 if caller may cause changes to the file; 0 otherwise.
+ * @willwrite: true if caller may cause changes to the file; false otherwise.
  */
-int unionfs_file_revalidate(struct file *file, int willwrite)
+int unionfs_file_revalidate(struct file *file, bool willwrite)
 {
 	struct super_block *sb;
 	struct dentry *dentry;
@@ -612,7 +612,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 	 * This is important for open-but-unlinked files, as well as mmap
 	 * support.
 	 */
-	if ((err = unionfs_file_revalidate(file, 1)))
+	if ((err = unionfs_file_revalidate(file, true)))
 		goto out;
 	unionfs_check_file(file);
 	fileinfo = UNIONFS_F(file);
@@ -753,7 +753,7 @@ long unionfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 
-	if ((err = unionfs_file_revalidate(file, 1)))
+	if ((err = unionfs_file_revalidate(file, true)))
 		goto out;
 
 	/* check if asked for local commands */
@@ -791,7 +791,7 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 
 	unionfs_read_lock(dentry->d_sb);
 
-	if ((err = unionfs_file_revalidate(file, 1)))
+	if ((err = unionfs_file_revalidate(file, true)))
 		goto out;
 	unionfs_check_file(file);
 
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index e46a53e..f32922e 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -262,7 +262,7 @@ static inline void purge_inode_data(struct inode *inode)
  * Revalidate a parent chain of dentries, then the actual node.
  * Assumes that dentry is locked, but will lock all parents if/when needed.
  *
- * If 'willwrite' is 1, and the lower inode times are not in sync, then
+ * If 'willwrite' is true, and the lower inode times are not in sync, then
  * *don't* purge_inode_data, as it could deadlock if ->write calls us and we
  * try to truncate a locked page.  Besides, if unionfs is about to write
  * data to a file, then there's the data unionfs is about to write is more
diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index 980f125..c923e58 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -99,7 +99,7 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 
-	if ((err = unionfs_file_revalidate(file, 0)))
+	if ((err = unionfs_file_revalidate(file, false)))
 		goto out;
 
 	inode = file->f_path.dentry->d_inode;
@@ -201,7 +201,7 @@ static loff_t unionfs_dir_llseek(struct file *file, loff_t offset, int origin)
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 
-	if ((err = unionfs_file_revalidate(file, 0)))
+	if ((err = unionfs_file_revalidate(file, false)))
 		goto out;
 
 	rdstate = UNIONFS_F(file)->rdstate;
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index e9e63b7..d8eaaa5 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -24,7 +24,7 @@ static ssize_t unionfs_read(struct file *file, char __user *buf,
 	int err;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 0)))
+	if ((err = unionfs_file_revalidate(file, false)))
 		goto out;
 	unionfs_check_file(file);
 
@@ -47,7 +47,7 @@ static ssize_t unionfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	struct file *file = iocb->ki_filp;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 0)))
+	if ((err = unionfs_file_revalidate(file, false)))
 		goto out;
 	unionfs_check_file(file);
 
@@ -72,7 +72,7 @@ static ssize_t unionfs_write(struct file *file, const char __user *buf,
 	int err = 0;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 1)))
+	if ((err = unionfs_file_revalidate(file, true)))
 		goto out;
 	unionfs_check_file(file);
 
@@ -97,7 +97,7 @@ static int unionfs_file_readdir(struct file *file, void *dirent,
 static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int err = 0;
-	int willwrite;
+	bool willwrite;
 	struct file *lower_file;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
@@ -149,7 +149,7 @@ int unionfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 	int err = -EINVAL;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 1)))
+	if ((err = unionfs_file_revalidate(file, true)))
 		goto out;
 	unionfs_check_file(file);
 
@@ -196,7 +196,7 @@ int unionfs_fasync(int fd, struct file *file, int flag)
 	int err = 0;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 1)))
+	if ((err = unionfs_file_revalidate(file, true)))
 		goto out;
 	unionfs_check_file(file);
 
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 6ef19af..88ef6a6 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -211,7 +211,7 @@ static int unionfs_readpage(struct file *file, struct page *page)
 	int err;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 0)))
+	if ((err = unionfs_file_revalidate(file, false)))
 		goto out;
 	unionfs_check_file(file);
 
@@ -254,7 +254,7 @@ static int unionfs_prepare_write(struct file *file, struct page *page,
 	 * is here, in ->prepare_write.
 	 */
 	unionfs_copy_attr_times(file->f_path.dentry->d_inode);
-	err = unionfs_file_revalidate(file, 1);
+	err = unionfs_file_revalidate(file, true);
 	unionfs_check_file(file);
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
 
@@ -275,7 +275,7 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	BUG_ON(file == NULL);
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 1)))
+	if ((err = unionfs_file_revalidate(file, true)))
 		goto out;
 	unionfs_check_file(file);
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 97da8f9..1cb2e1d 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -311,7 +311,7 @@ extern int unionfs_setlk(struct file *file, int cmd, struct file_lock *fl);
 extern int unionfs_getlk(struct file *file, struct file_lock *fl);
 
 /* Common file operations. */
-extern int unionfs_file_revalidate(struct file *file, int willwrite);
+extern int unionfs_file_revalidate(struct file *file, bool willwrite);
 extern int unionfs_open(struct inode *inode, struct file *file);
 extern int unionfs_file_release(struct inode *inode, struct file *file);
 extern int unionfs_flush(struct file *file, fl_owner_t id);
-- 
1.5.2.2

