Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbYAJPEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbYAJPEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbYAJPAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:00:50 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57021 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbYAJPAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:00:41 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 08/29] Unionfs: basic file operations
Date: Thu, 10 Jan 2008 09:59:27 -0500
Message-Id: <11999771922373-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Includes read, write, mmap, fsync, and fasync.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/file.c |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 184 insertions(+), 0 deletions(-)
 create mode 100644 fs/unionfs/file.c

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
new file mode 100644
index 0000000..0c424f6
--- /dev/null
+++ b/fs/unionfs/file.c
@@ -0,0 +1,184 @@
+/*
+ * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2006 Charles P. Wright
+ * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2005-2006 Junjiro Okajima
+ * Copyright (c) 2005      Arun M. Krishnakumar
+ * Copyright (c) 2004-2006 David P. Quigley
+ * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
+ * Copyright (c) 2003      Puja Gupta
+ * Copyright (c) 2003      Harikesavan Krishnan
+ * Copyright (c) 2003-2007 Stony Brook University
+ * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "union.h"
+
+static int unionfs_file_readdir(struct file *file, void *dirent,
+				filldir_t filldir)
+{
+	return -ENOTDIR;
+}
+
+static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int err = 0;
+	bool willwrite;
+	struct file *lower_file;
+
+	unionfs_read_lock(file->f_path.dentry->d_sb, UNIONFS_SMUTEX_PARENT);
+
+	/* This might be deferred to mmap's writepage */
+	willwrite = ((vma->vm_flags | VM_SHARED | VM_WRITE) == vma->vm_flags);
+	err = unionfs_file_revalidate(file, willwrite);
+	if (unlikely(err))
+		goto out;
+	unionfs_check_file(file);
+
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
+		printk(KERN_ERR "unionfs: branch %d file system does not "
+		       "support writeable mmap\n", fbstart(file));
+	} else {
+		err = generic_file_mmap(file, vma);
+		if (err)
+			printk(KERN_ERR
+			       "unionfs: generic_file_mmap failed %d\n", err);
+	}
+
+out:
+	if (!err) {
+		/* copyup could cause parent dir times to change */
+		unionfs_copy_attr_times(file->f_path.dentry->d_parent->d_inode);
+		unionfs_check_file(file);
+	}
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	return err;
+}
+
+int unionfs_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	int bindex, bstart, bend;
+	struct file *lower_file;
+	struct dentry *lower_dentry;
+	struct inode *lower_inode, *inode;
+	int err = -EINVAL;
+
+	unionfs_read_lock(file->f_path.dentry->d_sb, UNIONFS_SMUTEX_PARENT);
+	err = unionfs_file_revalidate(file, true);
+	if (unlikely(err))
+		goto out;
+	unionfs_check_file(file);
+
+	bstart = fbstart(file);
+	bend = fbend(file);
+	if (bstart < 0 || bend < 0)
+		goto out;
+
+	inode = dentry->d_inode;
+	if (unlikely(!inode)) {
+		printk(KERN_ERR
+		       "unionfs: null lower inode in unionfs_fsync\n");
+		goto out;
+	}
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (!lower_inode || !lower_inode->i_fop->fsync)
+			continue;
+		lower_file = unionfs_lower_file_idx(file, bindex);
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		mutex_lock(&lower_inode->i_mutex);
+		err = lower_inode->i_fop->fsync(lower_file,
+						lower_dentry,
+						datasync);
+		mutex_unlock(&lower_inode->i_mutex);
+		if (err)
+			goto out;
+	}
+
+	unionfs_copy_attr_times(inode);
+
+out:
+	unionfs_check_file(file);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	return err;
+}
+
+int unionfs_fasync(int fd, struct file *file, int flag)
+{
+	int bindex, bstart, bend;
+	struct file *lower_file;
+	struct dentry *dentry;
+	struct inode *lower_inode, *inode;
+	int err = 0;
+
+	unionfs_read_lock(file->f_path.dentry->d_sb, UNIONFS_SMUTEX_PARENT);
+	err = unionfs_file_revalidate(file, true);
+	if (unlikely(err))
+		goto out;
+	unionfs_check_file(file);
+
+	bstart = fbstart(file);
+	bend = fbend(file);
+	if (bstart < 0 || bend < 0)
+		goto out;
+
+	dentry = file->f_path.dentry;
+	inode = dentry->d_inode;
+	if (unlikely(!inode)) {
+		printk(KERN_ERR
+		       "unionfs: null lower inode in unionfs_fasync\n");
+		goto out;
+	}
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (!lower_inode || !lower_inode->i_fop->fasync)
+			continue;
+		lower_file = unionfs_lower_file_idx(file, bindex);
+		mutex_lock(&lower_inode->i_mutex);
+		err = lower_inode->i_fop->fasync(fd, lower_file, flag);
+		mutex_unlock(&lower_inode->i_mutex);
+		if (err)
+			goto out;
+	}
+
+	unionfs_copy_attr_times(inode);
+
+out:
+	unionfs_check_file(file);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	return err;
+}
+
+struct file_operations unionfs_main_fops = {
+	.llseek		= generic_file_llseek,
+	.read		= do_sync_read,
+	.aio_read	= generic_file_aio_read,
+	.write		= do_sync_write,
+	.aio_write	= generic_file_aio_write,
+	.readdir	= unionfs_file_readdir,
+	.unlocked_ioctl	= unionfs_ioctl,
+	.mmap		= unionfs_mmap,
+	.open		= unionfs_open,
+	.flush		= unionfs_flush,
+	.release	= unionfs_file_release,
+	.fsync		= unionfs_fsync,
+	.fasync		= unionfs_fasync,
+	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
+};
-- 
1.5.2.2

