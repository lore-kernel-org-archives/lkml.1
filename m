Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbXICCco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbXICCco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbXICCZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:52 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57676 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbXICCY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:56 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 28/32] Unionfs: use file f_path field
Date: Sun,  2 Sep 2007 22:20:51 -0400
Message-Id: <1188786059953-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Start using file->f_path.dentry instead of file->f_dentry

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   42 ++++++++++++++++++++----------------------
 fs/unionfs/dirfops.c    |    6 +++---
 fs/unionfs/mmap.c       |    5 ++---
 fs/unionfs/rdstate.c    |    2 +-
 4 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index eee68b8..341b6f2 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -158,7 +158,7 @@ static int open_all_files(struct file *file)
 	int bindex, bstart, bend, err = 0;
 	struct file *lower_file;
 	struct dentry *lower_dentry;
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct super_block *sb = dentry->d_sb;
 
 	bstart = dbstart(dentry);
@@ -193,8 +193,7 @@ static int open_highest_file(struct file *file, int willwrite)
 	int bindex, bstart, bend, err = 0;
 	struct file *lower_file;
 	struct dentry *lower_dentry;
-
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *parent_inode = dentry->d_parent->d_inode;
 	struct super_block *sb = dentry->d_sb;
 	size_t inode_size = dentry->d_inode->i_size;
@@ -302,10 +301,9 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 	int sbgen, fgen, dgen;
 	int bstart, bend;
 	int size;
-
 	int err = 0;
 
-	dentry = file->f_dentry;
+	dentry = file->f_path.dentry;
 	unionfs_lock_dentry(dentry);
 	sb = dentry->d_sb;
 
@@ -412,20 +410,20 @@ static int __open_dir(struct inode *inode, struct file *file)
 	struct file *lower_file;
 	int bindex, bstart, bend;
 
-	bstart = fbstart(file) = dbstart(file->f_dentry);
-	bend = fbend(file) = dbend(file->f_dentry);
+	bstart = fbstart(file) = dbstart(file->f_path.dentry);
+	bend = fbend(file) = dbend(file->f_path.dentry);
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
 		lower_dentry =
-			unionfs_lower_dentry_idx(file->f_dentry, bindex);
+			unionfs_lower_dentry_idx(file->f_path.dentry, bindex);
 		if (!lower_dentry)
 			continue;
 
 		dget(lower_dentry);
-		unionfs_mntget(file->f_dentry, bindex);
+		unionfs_mntget(file->f_path.dentry, bindex);
 		lower_file = dentry_open(lower_dentry,
-					 unionfs_lower_mnt_idx(file->f_dentry,
-								bindex),
+					 unionfs_lower_mnt_idx(file->f_path.dentry,
+							       bindex),
 					 file->f_flags);
 		if (IS_ERR(lower_file))
 			return PTR_ERR(lower_file);
@@ -450,17 +448,17 @@ static int __open_file(struct inode *inode, struct file *file)
 	int lower_flags;
 	int bindex, bstart, bend;
 
-	lower_dentry = unionfs_lower_dentry(file->f_dentry);
+	lower_dentry = unionfs_lower_dentry(file->f_path.dentry);
 	lower_flags = file->f_flags;
 
-	bstart = fbstart(file) = dbstart(file->f_dentry);
-	bend = fbend(file) = dbend(file->f_dentry);
+	bstart = fbstart(file) = dbstart(file->f_path.dentry);
+	bend = fbend(file) = dbend(file->f_path.dentry);
 
 	/*
 	 * check for the permission for lower file.  If the error is
 	 * COPYUP_ERR, copyup the file.
 	 */
-	if (lower_dentry->d_inode && is_robranch(file->f_dentry)) {
+	if (lower_dentry->d_inode && is_robranch(file->f_path.dentry)) {
 		/*
 		 * if the open will change the file, copy it up otherwise
 		 * defer it.
@@ -472,7 +470,7 @@ static int __open_file(struct inode *inode, struct file *file)
 			/* copyup the file */
 			for (bindex = bstart - 1; bindex >= 0; bindex--) {
 				err = copyup_file(
-					file->f_dentry->d_parent->d_inode,
+					file->f_path.dentry->d_parent->d_inode,
 					file, bstart, bindex, size);
 				if (!err)
 					break;
@@ -488,10 +486,10 @@ static int __open_file(struct inode *inode, struct file *file)
 	 * dentry_open will decrement mnt refcnt if err.
 	 * otherwise fput() will do an mntput() for us upon file close.
 	 */
-	unionfs_mntget(file->f_dentry, bstart);
+	unionfs_mntget(file->f_path.dentry, bstart);
 	lower_file =
 		dentry_open(lower_dentry,
-			    unionfs_lower_mnt_idx(file->f_dentry, bstart),
+			    unionfs_lower_mnt_idx(file->f_path.dentry, bstart),
 			    lower_flags);
 	if (IS_ERR(lower_file))
 		return PTR_ERR(lower_file);
@@ -536,7 +534,7 @@ int unionfs_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	dentry = file->f_dentry;
+	dentry = file->f_path.dentry;
 	unionfs_lock_dentry(dentry);
 
 	bstart = fbstart(file) = dbstart(dentry);
@@ -562,7 +560,7 @@ int unionfs_open(struct inode *inode, struct file *file)
 			if (!lower_file)
 				continue;
 
-			branchput(file->f_dentry->d_sb, bindex);
+			branchput(file->f_path.dentry->d_sb, bindex);
 			/* fput calls dput for lower_dentry */
 			fput(lower_file);
 		}
@@ -604,7 +602,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
 	fileinfo = UNIONFS_F(file);
-	BUG_ON(file->f_dentry->d_inode != inode);
+	BUG_ON(file->f_path.dentry->d_inode != inode);
 	inodeinfo = UNIONFS_I(inode);
 
 	/* fput all the lower files */
@@ -664,7 +662,7 @@ static long do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		err = lower_file->f_op->unlocked_ioctl(lower_file, cmd, arg);
 	} else if (lower_file->f_op->ioctl) {
 		lock_kernel();
-		err = lower_file->f_op->ioctl(lower_file->f_dentry->d_inode,
+		err = lower_file->f_op->ioctl(lower_file->f_path.dentry->d_inode,
 					      lower_file, cmd, arg);
 		unlock_kernel();
 	}
diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index 0e93bd7..980f125 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -102,7 +102,7 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
 
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 
 	uds = UNIONFS_F(file)->rdstate;
 	if (!uds) {
@@ -156,7 +156,7 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		uds->dirpos = offset;
 
 		/* Copy the atime. */
-		fsstack_copy_attr_atime(inode, lower_file->f_dentry->d_inode);
+		fsstack_copy_attr_atime(inode, lower_file->f_path.dentry->d_inode);
 
 		if (err < 0)
 			goto out;
@@ -239,7 +239,7 @@ static loff_t unionfs_dir_llseek(struct file *file, loff_t offset, int origin)
 				else
 					err = -EINVAL;
 			} else {
-				rdstate = find_rdstate(file->f_dentry->d_inode,
+				rdstate = find_rdstate(file->f_path.dentry->d_inode,
 						       offset);
 				if (rdstate) {
 					UNIONFS_F(file)->rdstate = rdstate;
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index d26b572..e05e6a2 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -229,7 +229,7 @@ static int unionfs_readpage(struct file *file, struct page *page)
 	 */
 out:
 	unlock_page(page);
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 
 	return err;
 }
@@ -271,8 +271,7 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 
 	BUG_ON(file == NULL);
 
-	unionfs_read_lock(file->f_dentry->d_sb);
-
+	unionfs_read_lock(file->f_path.dentry->d_sb);
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
 
diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index 5fc242e..0a18d5c 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -91,7 +91,7 @@ int init_rdstate(struct file *file)
 	       (sizeof(unsigned int) + sizeof(unsigned int)));
 	BUG_ON(UNIONFS_F(file)->rdstate != NULL);
 
-	UNIONFS_F(file)->rdstate = alloc_rdstate(file->f_dentry->d_inode,
+	UNIONFS_F(file)->rdstate = alloc_rdstate(file->f_path.dentry->d_inode,
 						 fbstart(file));
 
 	return (UNIONFS_F(file)->rdstate ? 0 : -ENOMEM);
-- 
1.5.2.2.238.g7cbf2f2

