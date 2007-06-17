Return-Path: <linux-kernel-owner+w=401wt.eu-S1762217AbXFQTP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217AbXFQTP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbXFQTLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:11:16 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36930 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760788AbXFQTLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:11:11 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Yiannis Pericleous <yiannos@fsl.cs.sunysb.edu>,
       Shaya Potter <spotter@cs.columbia.edu>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 09/16] Unionfs: mmap implementation
Date: Sun, 17 Jun 2007 15:09:16 -0400
Message-Id: <1182107364706-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yiannis Pericleous <yiannos@fsl.cs.sunysb.edu>

Signed-off-by: Shaya Potter <spotter@cs.columbia.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Yiannis Pericleous <yiannos@fsl.cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/Makefile     |    2 +-
 fs/unionfs/commonfops.c |   19 ++-
 fs/unionfs/copyup.c     |    5 +
 fs/unionfs/file.c       |  214 +++++++----------------------
 fs/unionfs/inode.c      |    9 ++
 fs/unionfs/main.c       |    6 -
 fs/unionfs/mmap.c       |  348 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/unionfs/super.c      |    8 +-
 fs/unionfs/union.h      |    1 +
 9 files changed, 438 insertions(+), 174 deletions(-)
 create mode 100644 fs/unionfs/mmap.c

diff --git a/fs/unionfs/Makefile b/fs/unionfs/Makefile
index 6986d79..78be3e7 100644
--- a/fs/unionfs/Makefile
+++ b/fs/unionfs/Makefile
@@ -2,6 +2,6 @@ obj-$(CONFIG_UNION_FS) += unionfs.o
 
 unionfs-y := subr.o dentry.o file.o inode.o main.o super.o \
 	rdstate.o copyup.o dirhelper.o rename.o unlink.o \
-	lookup.o commonfops.o dirfops.o sioq.o
+	lookup.o commonfops.o dirfops.o sioq.o mmap.o
 
 unionfs-$(CONFIG_UNION_FS_XATTR) += xattr.o
diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index db8c334..0222393 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -571,12 +571,25 @@ out_nofree:
 int unionfs_file_release(struct inode *inode, struct file *file)
 {
 	struct file *hidden_file = NULL;
-	struct unionfs_file_info *fileinfo = UNIONFS_F(file);
-	struct unionfs_inode_info *inodeinfo = UNIONFS_I(inode);
+	struct unionfs_file_info *fileinfo;
+	struct unionfs_inode_info *inodeinfo;
+	struct super_block *sb = inode->i_sb;
 	int bindex, bstart, bend;
 	int fgen;
+	int err;
+
+	unionfs_read_lock(sb);
+	/*
+	 * Yes, we have to revalidate this file even if it's being released.
+	 * This is important for open-but-unlinked files, as well as mmap
+	 * support.
+	 */
+	if ((err = unionfs_file_revalidate(file, 1)))
+		return err;
+	fileinfo = UNIONFS_F(file);
+	BUG_ON(file->f_dentry->d_inode != inode);
+	inodeinfo = UNIONFS_I(inode);
 
-	unionfs_read_lock(inode->i_sb);
 	/* fput all the hidden files */
 	fgen = atomic_read(&fileinfo->generation);
 	bstart = fbstart(file);
diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index a80ece6..dff4f1c 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -291,8 +291,13 @@ static int __copyup_reg_data(struct dentry *dentry,
 
 	kfree(buf);
 
+	if (!err)
+		err = output_file->f_op->fsync(output_file,
+					       new_hidden_dentry, 0);
+
 	if (err)
 		goto out_close_out;
+
 	if (copyup_file) {
 		*copyup_file = output_file;
 		goto out_close_in;
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 2e5ec42..afffe59 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -22,219 +22,110 @@
  * File Operations *
  *******************/
 
-static loff_t unionfs_llseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t err;
-	struct file *hidden_file = NULL;
-
-	unionfs_read_lock(file->f_dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 0)))
-		goto out;
-
-	hidden_file = unionfs_lower_file(file);
-	/* always set hidden position to this one */
-	hidden_file->f_pos = file->f_pos;
-
-	memcpy(&hidden_file->f_ra, &file->f_ra, sizeof(struct file_ra_state));
-
-	if (hidden_file->f_op && hidden_file->f_op->llseek)
-		err = hidden_file->f_op->llseek(hidden_file, offset, origin);
-	else
-		err = generic_file_llseek(hidden_file, offset, origin);
-
-	if (err < 0)
-		goto out;
-	if (err != file->f_pos) {
-		file->f_pos = err;
-		file->f_version++;
-	}
-out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
-	return err;
-}
-
 static ssize_t unionfs_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-	struct file *hidden_file;
-	loff_t pos = *ppos;
 	int err;
 
 	unionfs_read_lock(file->f_dentry->d_sb);
+
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
 
-	err = -EINVAL;
-	hidden_file = unionfs_lower_file(file);
-	if (!hidden_file->f_op || !hidden_file->f_op->read)
-		goto out;
+	err = do_sync_read(file, buf, count, ppos);
 
-	err = hidden_file->f_op->read(hidden_file, buf, count, &pos);
-	*ppos = pos;
+	if (err >= 0)
+		touch_atime(unionfs_lower_mnt(file->f_path.dentry),
+			    unionfs_lower_dentry(file->f_path.dentry));
 
 out:
 	unionfs_read_unlock(file->f_dentry->d_sb);
 	return err;
 }
 
-static ssize_t unionfs_write(struct file *file, const char __user *buf,
-			     size_t count, loff_t *ppos)
+static ssize_t unionfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
+				unsigned long nr_segs, loff_t pos)
 {
-	int err;
-	struct file *hidden_file = NULL;
-	struct inode *inode;
-	struct inode *hidden_inode;
-	loff_t pos = *ppos;
-	int bstart, bend;
+	int err = 0;
+	struct file *file = iocb->ki_filp;
 
 	unionfs_read_lock(file->f_dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 1)))
-		goto out;
-
-	inode = file->f_dentry->d_inode;
-
-	bstart = fbstart(file);
-	bend = fbend(file);
 
-	BUG_ON(bstart == -1);
-
-	hidden_file = unionfs_lower_file(file);
-	hidden_inode = hidden_file->f_dentry->d_inode;
-
-	if (!hidden_file->f_op || !hidden_file->f_op->write) {
-		err = -EINVAL;
+	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
-	}
 
-	/* adjust for append -- seek to the end of the file */
-	if (file->f_flags & O_APPEND)
-		pos = inode->i_size;
+	err = generic_file_aio_read(iocb, iov, nr_segs, pos);
 
-	err = hidden_file->f_op->write(hidden_file, buf, count, &pos);
+	if (err == -EIOCBQUEUED)
+		err = wait_on_sync_kiocb(iocb);
 
-	/*
-	 * copy ctime and mtime from lower layer attributes
-	 * atime is unchanged for both layers
-	 */
 	if (err >= 0)
-		fsstack_copy_attr_times(inode, hidden_inode);
-
-	*ppos = pos;
+		touch_atime(unionfs_lower_mnt(file->f_path.dentry),
+			    unionfs_lower_dentry(file->f_path.dentry));
 
-	/* update this inode's size */
-	if (pos > inode->i_size)
-		inode->i_size = pos;
 out:
 	unionfs_read_unlock(file->f_dentry->d_sb);
 	return err;
 }
-
-static int unionfs_file_readdir(struct file *file, void *dirent,
-				filldir_t filldir)
-{
-	return -ENOTDIR;
-}
-
-static unsigned int unionfs_poll(struct file *file, poll_table *wait)
+static ssize_t unionfs_write(struct file * file, const char __user * buf,
+			     size_t count, loff_t *ppos)
 {
-	unsigned int mask = DEFAULT_POLLMASK;
-	struct file *hidden_file = NULL;
+	int err = 0;
 
 	unionfs_read_lock(file->f_dentry->d_sb);
-	if (unionfs_file_revalidate(file, 0)) {
-		/* We should pretend an error happened. */
-		mask = POLLERR | POLLIN | POLLOUT;
-		goto out;
-	}
-
-	hidden_file = unionfs_lower_file(file);
 
-	if (!hidden_file->f_op || !hidden_file->f_op->poll)
+	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
 
-	mask = hidden_file->f_op->poll(hidden_file, wait);
+	err = do_sync_write(file, buf, count, ppos);
 
 out:
 	unionfs_read_unlock(file->f_dentry->d_sb);
-	return mask;
+	return err;
 }
 
-static int __do_mmap(struct file *file, struct vm_area_struct *vma)
+static int unionfs_file_readdir(struct file *file, void *dirent,
+				filldir_t filldir)
 {
-	int err;
-	struct file *hidden_file;
-
-	hidden_file = unionfs_lower_file(file);
-
-	err = -ENODEV;
-	if (!hidden_file->f_op || !hidden_file->f_op->mmap)
-		goto out;
-
-	vma->vm_file = hidden_file;
-	err = hidden_file->f_op->mmap(hidden_file, vma);
-	get_file(hidden_file);	/* make sure it doesn't get freed on us */
-	fput(file);		/* no need to keep extra ref on ours */
-out:
-	return err;
+	return -ENOTDIR;
 }
 
 static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int err = 0;
 	int willwrite;
+	struct file *lower_file;
 
 	unionfs_read_lock(file->f_dentry->d_sb);
-	/* This might could be deferred to mmap's writepage. */
-	willwrite = ((vma->vm_flags | VM_SHARED | VM_WRITE) == vma->vm_flags);
-	if ((err = unionfs_file_revalidate(file, willwrite)))
-		goto out;
-
-	err = __do_mmap(file, vma);
-
-out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
-	return err;
-}
-
-static int unionfs_fsync(struct file *file, struct dentry *dentry,
-			 int datasync)
-{
-	int err;
-	struct file *hidden_file = NULL;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
 
-	hidden_file = unionfs_lower_file(file);
-
-	err = -EINVAL;
-	if (!hidden_file->f_op || !hidden_file->f_op->fsync)
-		goto out;
-
-	mutex_lock(&hidden_file->f_dentry->d_inode->i_mutex);
-	err = hidden_file->f_op->fsync(hidden_file, hidden_file->f_dentry,
-				       datasync);
-	mutex_unlock(&hidden_file->f_dentry->d_inode->i_mutex);
-
-out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
-	return err;
-}
-
-static int unionfs_fasync(int fd, struct file *file, int flag)
-{
-	int err = 0;
-	struct file *hidden_file = NULL;
-
-	unionfs_read_lock(file->f_dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 1)))
+	/* This might be deferred to mmap's writepage */
+	willwrite = ((vma->vm_flags | VM_SHARED | VM_WRITE) == vma->vm_flags);
+	if ((err = unionfs_file_revalidate(file, willwrite)))
 		goto out;
 
-	hidden_file = unionfs_lower_file(file);
-
-	if (hidden_file->f_op && hidden_file->f_op->fasync)
-		err = hidden_file->f_op->fasync(fd, hidden_file, flag);
+	/*
+	 * File systems which do not implement ->writepage may use
+	 * generic_file_readonly_mmap as their ->mmap op.  If you call
+	 * generic_file_readonly_mmap with VM_WRITE, you'd get an -EINVAL.
+	 * But we cannot call the lower ->mmap op, so we can't tell that
+	 * writeable mappings won't work.  Therefore, our only choice is to
+	 * check if the lower file system supports the ->writepage, and if
+	 * not, return EINVAL (the same error that
+	 * generic_file_readonly_mmap returns in that case).
+	 */
+	lower_file = unionfs_lower_file(file);
+	if (willwrite && !lower_file->f_mapping->a_ops->writepage) {
+		err = -EINVAL;
+		printk("unionfs: branch %d file system does not support "
+		       "writeable mmap\n", fbstart(file));
+	} else {
+		err = generic_file_mmap(file, vma);
+		if (err)
+			printk("unionfs: generic_file_mmap failed %d\n", err);
+	}
 
 out:
 	unionfs_read_unlock(file->f_dentry->d_sb);
@@ -242,16 +133,17 @@ out:
 }
 
 struct file_operations unionfs_main_fops = {
-	.llseek		= unionfs_llseek,
+	.llseek		= generic_file_llseek,
 	.read		= unionfs_read,
+	.aio_read       = unionfs_aio_read,
 	.write		= unionfs_write,
+	.aio_write      = generic_file_aio_write,
 	.readdir	= unionfs_file_readdir,
-	.poll		= unionfs_poll,
 	.unlocked_ioctl	= unionfs_ioctl,
 	.mmap		= unionfs_mmap,
 	.open		= unionfs_open,
 	.flush		= unionfs_flush,
 	.release	= unionfs_file_release,
-	.fsync		= unionfs_fsync,
-	.fasync		= unionfs_fasync,
+	.fsync		= file_fsync,
+	.sendfile	= generic_file_sendfile,
 };
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 627c2a7..9f1acc4 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -1018,6 +1018,15 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 		break;
 	}
 
+	/* for mmap */
+	if (ia->ia_valid & ATTR_SIZE) {
+		if (ia->ia_size != i_size_read(inode)) {
+			err = vmtruncate(inode, ia->ia_size);
+			if (err)
+				printk("unionfs_setattr: vmtruncate failed\n");
+		}
+	}
+
 	/* get the size from the first hidden inode */
 	hidden_inode = unionfs_lower_inode(dentry->d_inode);
 	fsstack_copy_attr_all(inode, hidden_inode, unionfs_get_nlinks);
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index a9ad445..2bcc84c 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -121,12 +121,6 @@ int unionfs_interpose(struct dentry *dentry, struct super_block *sb, int flag)
 	    S_ISFIFO(hidden_inode->i_mode) || S_ISSOCK(hidden_inode->i_mode))
 		init_special_inode(inode, hidden_inode->i_mode,
 				   hidden_inode->i_rdev);
-	/*
-	 * Fix our inode's address operations to that of the lower inode
-	 * (Unionfs is FiST-Lite)
-	 */
-	if (inode->i_mapping->a_ops != hidden_inode->i_mapping->a_ops)
-		inode->i_mapping->a_ops = hidden_inode->i_mapping->a_ops;
 
 	/* all well, copy inode attributes */
 	fsstack_copy_attr_all(inode, hidden_inode, unionfs_get_nlinks);
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
new file mode 100644
index 0000000..997b619
--- /dev/null
+++ b/fs/unionfs/mmap.c
@@ -0,0 +1,348 @@
+/*
+ * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2006 Charles P. Wright
+ * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2005-2006 Junjiro Okajima
+ * Copyright (c) 2006      Shaya Potter
+ * Copyright (c) 2005      Arun M. Krishnakumar
+ * Copyright (c) 2004-2006 David P. Quigley
+ * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
+ * Copyright (c) 2003      Puja Gupta
+ * Copyright (c) 2003      Harikesavan Krishnan
+ * Copyright (c) 2003-2007 Stony Brook University
+ * Copyright (c) 2003-2007 The Research Foundation of State University of New York
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "union.h"
+
+/*
+ * Unionfs doesn't implement ->writepages, which is OK with the VFS and
+ * nkeeps our code simpler and smaller.  Nevertheless, somehow, our own
+ * ->writepage must be called so we can sync the upper pages with the lower
+ * pages: otherwise data changed at the upper layer won't get written to the
+ * lower layer.
+ *
+ * Some lower file systems (e.g., NFS) expect the VFS to call its writepages
+ * only, which in turn will call generic_writepages and invoke each of the
+ * lower file system's ->writepage.  NFS in particular uses the
+ * wbc->fs_private field in its nfs_writepage, which is set in its
+ * nfs_writepages.  So if we don't call the lower nfs_writepages first, then
+ * NFS's nfs_writepage will dereference a NULL wbc->fs_private and cause an
+ * OOPS.  If, however, we implement a unionfs_writepages and then we do call
+ * the lower nfs_writepages, then we "lose control" over the pages we're
+ * trying to write to the lower file system: we won't be writing our own
+ * new/modified data from the upper pages to the lower pages, and any
+ * mmap-based changes are lost.
+ *
+ * This is a fundamental cache-coherency problem in Linux.  The kernel isn't
+ * able to support such stacking abstractions cleanly.  One possible clean
+ * way would be that a lower file system's ->writepage method have some sort
+ * of a callback to validate if any upper pages for the same file+offset
+ * exist and have newer content in them.
+ *
+ * This whole NULL ptr dereference is triggered at the lower file system
+ * (NFS) because the wbc->for_writepages is set to 1.  Therefore, to avoid
+ * this NULL pointer dereference, we set this flag to 0 and restore it upon
+ * exit.  This probably means that we're slightly less efficient in writing
+ * pages out, doing them one at a time, but at least we avoid the oops until
+ * such day as Linux can better support address_space_ops in a stackable
+ * fashion.
+ */
+int unionfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	int err = -EIO;
+	struct inode *inode;
+	struct inode *lower_inode;
+	struct page *lower_page;
+	char *kaddr, *lower_kaddr;
+	int saved_for_writepages = wbc->for_writepages;
+
+	inode = page->mapping->host;
+	lower_inode = unionfs_lower_inode(inode);
+
+	/* find lower page (returns a locked page) */
+	lower_page = grab_cache_page(lower_inode->i_mapping, page->index);
+	if (!lower_page)
+		goto out;
+
+	/* get page address, and encode it */
+	kaddr = kmap(page);
+	lower_kaddr = kmap(lower_page);
+
+	memcpy(lower_kaddr, kaddr, PAGE_CACHE_SIZE);
+
+	kunmap(page);
+	kunmap(lower_page);
+
+	BUG_ON(!lower_inode->i_mapping->a_ops->writepage);
+
+	/* workaround for some lower file systems: see big comment on top */
+	if (wbc->for_writepages && !wbc->fs_private)
+		wbc->for_writepages = 0;
+
+	/* call lower writepage (expects locked page) */
+	err = lower_inode->i_mapping->a_ops->writepage(lower_page, wbc);
+	wbc->for_writepages = saved_for_writepages; /* restore value */
+
+	/*
+	 * update mtime and ctime of lower level file system
+	 * unionfs' mtime and ctime are updated by generic_file_write
+	 */
+	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
+
+	page_cache_release(lower_page);	/* b/c grab_cache_page increased refcnt */
+
+	if (err)
+		ClearPageUptodate(page);
+	else
+		SetPageUptodate(page);
+
+out:
+	unlock_page(page);
+	return err;
+}
+
+/*
+ * readpage is called from generic_page_read and the fault handler.
+ * If your file system uses generic_page_read for the read op, it
+ * must implement readpage.
+ *
+ * Readpage expects a locked page, and must unlock it.
+ */
+static int unionfs_do_readpage(struct file *file, struct page *page)
+{
+	int err = -EIO;
+	struct dentry *dentry;
+	struct file *lower_file = NULL;
+	struct inode *inode, *lower_inode;
+	char *page_data;
+	struct page *lower_page;
+	char *lower_page_data;
+
+	dentry = file->f_dentry;
+	if (UNIONFS_F(file) == NULL) {
+		err = -ENOENT;
+		goto out_err;
+	}
+
+	lower_file = unionfs_lower_file(file);
+	inode = dentry->d_inode;
+	lower_inode = unionfs_lower_inode(inode);
+
+	lower_page = NULL;
+
+	/* find lower page (returns a locked page) */
+	lower_page = read_cache_page(lower_inode->i_mapping,
+				     page->index,
+				     (filler_t *) lower_inode->i_mapping->
+				     a_ops->readpage, (void *)lower_file);
+
+	if (IS_ERR(lower_page)) {
+		err = PTR_ERR(lower_page);
+		lower_page = NULL;
+		goto out_release;
+	}
+
+	/*
+	 * wait for the page data to show up
+	 * (signaled by readpage as unlocking the page)
+	 */
+	wait_on_page_locked(lower_page);
+	if (!PageUptodate(lower_page)) {
+		/*
+		 * call readpage() again if we returned from wait_on_page
+		 * with a page that's not up-to-date; that can happen when a
+		 * partial page has a few buffers which are ok, but not the
+		 * whole page.
+		 */
+		lock_page(lower_page);
+		err = lower_inode->i_mapping->a_ops->readpage(lower_file,
+							      lower_page);
+		if (err) {
+			lower_page = NULL;
+			goto out_release;
+		}
+
+		wait_on_page_locked(lower_page);
+		if (!PageUptodate(lower_page)) {
+			err = -EIO;
+			goto out_release;
+		}
+	}
+
+	/* map pages, get their addresses */
+	page_data = (char *)kmap(page);
+	lower_page_data = (char *)kmap(lower_page);
+
+	memcpy(page_data, lower_page_data, PAGE_CACHE_SIZE);
+
+	err = 0;
+
+	kunmap(lower_page);
+	kunmap(page);
+
+out_release:
+	if (lower_page)
+		page_cache_release(lower_page);	/* undo read_cache_page */
+
+	if (err == 0)
+		SetPageUptodate(page);
+	else
+		ClearPageUptodate(page);
+
+out_err:
+	return err;
+}
+
+int unionfs_readpage(struct file *file, struct page *page)
+{
+	int err;
+
+	unionfs_read_lock(file->f_dentry->d_sb);
+
+	if ((err = unionfs_file_revalidate(file, 0)))
+		goto out;
+
+	err = unionfs_do_readpage(file, page);
+
+	if (!err)
+		touch_atime(unionfs_lower_mnt(file->f_path.dentry),
+			    unionfs_lower_dentry(file->f_path.dentry));
+
+	/*
+	 * we have to unlock our page, b/c we _might_ have gotten a locked
+	 * page.  but we no longer have to wakeup on our page here, b/c
+	 * UnlockPage does it
+	 */
+out:
+	unlock_page(page);
+	unionfs_read_unlock(file->f_dentry->d_sb);
+
+	return err;
+}
+
+int unionfs_prepare_write(struct file *file, struct page *page, unsigned from,
+			  unsigned to)
+{
+	int err;
+
+	unionfs_read_lock(file->f_dentry->d_sb);
+
+	err = unionfs_file_revalidate(file, 1);
+
+	unionfs_read_unlock(file->f_dentry->d_sb);
+
+	return err;
+}
+
+int unionfs_commit_write(struct file *file, struct page *page, unsigned from,
+			 unsigned to)
+{
+	int err = -ENOMEM;
+	struct inode *inode, *lower_inode;
+	struct file *lower_file = NULL;
+	loff_t pos;
+	unsigned bytes = to - from;
+	char *page_data = NULL;
+	mm_segment_t old_fs;
+
+	BUG_ON(file == NULL);
+
+	unionfs_read_lock(file->f_dentry->d_sb);
+
+	if ((err = unionfs_file_revalidate(file, 1)))
+		goto out;
+
+	inode = page->mapping->host;
+	lower_inode = unionfs_lower_inode(inode);
+
+	if (UNIONFS_F(file) != NULL)
+		lower_file = unionfs_lower_file(file);
+
+	/* FIXME: is this assertion right here? */
+	BUG_ON(lower_file == NULL);
+
+	page_data = (char *)kmap(page);
+	lower_file->f_pos = (page->index << PAGE_CACHE_SHIFT) + from;
+
+	/* SP: I use vfs_write instead of copying page data and the
+	 * prepare_write/commit_write combo because file system's like
+	 * GFS/OCFS2 don't like things touching those directly,
+	 * calling the underlying write op, while a little bit slower, will
+	 * call all the FS specific code as well
+	 */
+	old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	err = vfs_write(lower_file, page_data + from, bytes,
+			&lower_file->f_pos);
+	set_fs(old_fs);
+
+	kunmap(page);
+
+	if (err < 0)
+		goto out;
+
+	inode->i_blocks = lower_inode->i_blocks;
+	/* we may have to update i_size */
+	pos = ((loff_t) page->index << PAGE_CACHE_SHIFT) + to;
+	if (pos > i_size_read(inode))
+		i_size_write(inode, pos);
+
+	/*
+	 * update mtime and ctime of lower level file system
+	 * unionfs' mtime and ctime are updated by generic_file_write
+	 */
+	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
+
+	mark_inode_dirty_sync(inode);
+
+out:
+	if (err < 0)
+		ClearPageUptodate(page);
+
+	unionfs_read_unlock(file->f_dentry->d_sb);
+	return err;		/* assume all is ok */
+}
+
+void unionfs_sync_page(struct page *page)
+{
+	struct inode *inode;
+	struct inode *lower_inode;
+	struct page *lower_page;
+	struct address_space *mapping;
+
+	inode = page->mapping->host;
+	lower_inode = unionfs_lower_inode(inode);
+
+	/* find lower page (returns a locked page) */
+	lower_page = grab_cache_page(lower_inode->i_mapping, page->index);
+	if (!lower_page)
+		goto out;
+
+	/* do the actual sync */
+	mapping = lower_page->mapping;
+	/*
+	 * XXX: can we optimize ala RAIF and set the lower page to be
+	 * discarded after a successful sync_page?
+	 */
+	if (mapping && mapping->a_ops && mapping->a_ops->sync_page)
+		mapping->a_ops->sync_page(lower_page);
+
+	unlock_page(lower_page);	/* b/c grab_cache_page locked it */
+	page_cache_release(lower_page);	/* b/c grab_cache_page increased refcnt */
+
+out:
+	return;
+}
+
+struct address_space_operations unionfs_aops = {
+	.writepage	= unionfs_writepage,
+	.readpage	= unionfs_readpage,
+	.prepare_write	= unionfs_prepare_write,
+	.commit_write	= unionfs_commit_write,
+	.sync_page	= unionfs_sync_page,
+};
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index a7ff06c..196ff12 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -26,7 +26,7 @@ static struct kmem_cache *unionfs_inode_cachep;
 
 static void unionfs_read_inode(struct inode *inode)
 {
-	static struct address_space_operations unionfs_empty_aops;
+	extern struct address_space_operations unionfs_aops;
 	int size;
 	struct unionfs_inode_info *info = UNIONFS_I(inode);
 
@@ -58,8 +58,7 @@ static void unionfs_read_inode(struct inode *inode)
 	inode->i_op = &unionfs_main_iops;
 	inode->i_fop = &unionfs_main_fops;
 
-	/* I don't think ->a_ops is ever allowed to be NULL */
-	inode->i_mapping->a_ops = &unionfs_empty_aops;
+	inode->i_mapping->a_ops = &unionfs_aops;
 }
 
 /*
@@ -73,6 +72,9 @@ static void unionfs_delete_inode(struct inode *inode)
 {
 	inode->i_size = 0;	/* every f/s seems to do that */
 
+	if (inode->i_data.nrpages)
+		truncate_inode_pages(&inode->i_data, 0);
+
 	clear_inode(inode);
 }
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 01e29f3..480b8ee 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -38,6 +38,7 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/writeback.h>
+#include <linux/buffer_head.h>
 #include <linux/xattr.h>
 #include <linux/fs_stack.h>
 #include <linux/magic.h>
-- 
1.5.2.rc1.165.gaf9b

