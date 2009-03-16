Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbZCPHZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbZCPHZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbZCPHXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:23:04 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:35642 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbZCPHWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:22:55 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #2 17/28] aufs file
Date: Mon, 16 Mar 2009 16:20:29 +0900
Message-Id: <1237188040-11404-18-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
private data, file operations, vm operations, and address_space
operations.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/f_op.c  |  551 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/file.c  |  552 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/file.h  |  148 +++++++++++++++
 fs/aufs/finfo.c |  126 +++++++++++++
 4 files changed, 1377 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/f_op.c
 create mode 100644 fs/aufs/file.c
 create mode 100644 fs/aufs/file.h
 create mode 100644 fs/aufs/finfo.c

diff --git a/fs/aufs/f_op.c b/fs/aufs/f_op.c
new file mode 100644
index 0000000..04cb948
--- /dev/null
+++ b/fs/aufs/f_op.c
@@ -0,0 +1,551 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * file and vm operations
+ */
+
+#include <linux/fs_stack.h>
+#include <linux/poll.h>
+#include "aufs.h"
+
+/* common function to regular file and dir */
+int aufs_flush(struct file *file, fl_owner_t id)
+{
+	int err;
+	aufs_bindex_t bindex, bend;
+	struct dentry *dentry;
+	struct file *h_file;
+
+	dentry = file->f_dentry;
+	si_noflush_read_lock(dentry->d_sb);
+	fi_read_lock(file);
+	di_read_lock_child(dentry, AuLock_IW);
+
+	err = 0;
+	bend = au_fbend(file);
+	for (bindex = au_fbstart(file); !err && bindex <= bend; bindex++) {
+		h_file = au_h_fptr(file, bindex);
+		if (!h_file || !h_file->f_op || !h_file->f_op->flush)
+			continue;
+
+		err = h_file->f_op->flush(h_file, id);
+		if (!err)
+			vfsub_update_h_iattr(&h_file->f_path, /*did*/NULL);
+		/*ignore*/
+	}
+	au_cpup_attr_timesizes(dentry->d_inode);
+
+	di_read_unlock(dentry, AuLock_IW);
+	fi_read_unlock(file);
+	si_read_unlock(dentry->d_sb);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int do_open_nondir(struct file *file, int flags)
+{
+	int err;
+	aufs_bindex_t bindex;
+	struct file *h_file;
+	struct dentry *dentry;
+
+	err = 0;
+	dentry = file->f_dentry;
+	au_fi(file)->fi_h_vm_ops = NULL;
+	bindex = au_dbstart(dentry);
+	/* O_TRUNC is processed already */
+	BUG_ON(au_test_ro(dentry->d_sb, bindex, dentry->d_inode)
+	       && (flags & O_TRUNC));
+
+	h_file = au_h_open(dentry, bindex, flags, file);
+	if (IS_ERR(h_file))
+		err = PTR_ERR(h_file);
+	else {
+		au_set_fbstart(file, bindex);
+		au_set_fbend(file, bindex);
+		au_set_h_fptr(file, bindex, h_file);
+		au_update_figen(file);
+		/* todo: necessary? */
+		/* file->f_ra = h_file->f_ra; */
+	}
+	return err;
+}
+
+static int aufs_open_nondir(struct inode *inode __maybe_unused,
+			    struct file *file)
+{
+	return au_do_open(file, do_open_nondir);
+}
+
+static int aufs_release_nondir(struct inode *inode __maybe_unused,
+			       struct file *file)
+{
+	struct super_block *sb = file->f_dentry->d_sb;
+
+	si_noflush_read_lock(sb);
+	au_finfo_fin(file);
+	si_read_unlock(sb);
+	return 0;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static ssize_t aufs_read(struct file *file, char __user *buf, size_t count,
+			 loff_t *ppos)
+{
+	ssize_t err;
+	struct dentry *dentry;
+	struct file *h_file;
+	struct super_block *sb;
+
+	dentry = file->f_dentry;
+	sb = dentry->d_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+	err = au_reval_and_lock_fdi(file, au_reopen_nondir, /*wlock*/0);
+	if (unlikely(err))
+		goto out;
+
+	h_file = au_h_fptr(file, au_fbstart(file));
+	err = vfsub_read_u(h_file, buf, count, ppos);
+	/* todo: necessary? */
+	/* file->f_ra = h_file->f_ra; */
+	fsstack_copy_attr_atime(dentry->d_inode, h_file->f_dentry->d_inode);
+
+	di_read_unlock(dentry, AuLock_IR);
+	fi_read_unlock(file);
+ out:
+	si_read_unlock(sb);
+	return err;
+}
+
+static ssize_t aufs_write(struct file *file, const char __user *ubuf,
+			  size_t count, loff_t *ppos)
+{
+	ssize_t err;
+	aufs_bindex_t bstart;
+	struct au_pin pin;
+	struct dentry *dentry;
+	struct inode *inode;
+	struct super_block *sb;
+	struct file *h_file;
+	char __user *buf = (char __user *)ubuf;
+
+	dentry = file->f_dentry;
+	sb = dentry->d_sb;
+	inode = dentry->d_inode;
+	mutex_lock(&inode->i_mutex);
+	si_read_lock(sb, AuLock_FLUSH);
+
+	err = au_reval_and_lock_fdi(file, au_reopen_nondir, /*wlock*/1);
+	if (unlikely(err))
+		goto out;
+
+	err = au_ready_to_write(file, -1, &pin);
+	di_downgrade_lock(dentry, AuLock_IR);
+	if (unlikely(err))
+		goto out_unlock;
+
+	bstart = au_fbstart(file);
+	h_file = au_h_fptr(file, bstart);
+	au_unpin(&pin);
+	err = vfsub_write_u(h_file, buf, count, ppos);
+	au_cpup_attr_timesizes(inode);
+	inode->i_mode = h_file->f_dentry->d_inode->i_mode;
+
+ out_unlock:
+	di_read_unlock(dentry, AuLock_IR);
+	fi_write_unlock(file);
+ out:
+	si_read_unlock(sb);
+	mutex_unlock(&inode->i_mutex);
+	return err;
+}
+
+static ssize_t aufs_splice_read(struct file *file, loff_t *ppos,
+				struct pipe_inode_info *pipe, size_t len,
+				unsigned int flags)
+{
+	ssize_t err;
+	struct file *h_file;
+	struct dentry *dentry;
+	struct super_block *sb;
+
+	dentry = file->f_dentry;
+	sb = dentry->d_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+	err = au_reval_and_lock_fdi(file, au_reopen_nondir, /*wlock*/0);
+	if (unlikely(err))
+		goto out;
+
+	err = -EINVAL;
+	h_file = au_h_fptr(file, au_fbstart(file));
+	if (au_test_loopback_kthread()) {
+		file->f_mapping = h_file->f_mapping;
+		smp_mb(); /* unnecessary? */
+	}
+	err = vfsub_splice_to(h_file, ppos, pipe, len, flags);
+	/* todo: necessasry? */
+	/* file->f_ra = h_file->f_ra; */
+	fsstack_copy_attr_atime(dentry->d_inode, h_file->f_dentry->d_inode);
+
+	di_read_unlock(dentry, AuLock_IR);
+	fi_read_unlock(file);
+
+ out:
+	si_read_unlock(sb);
+	return err;
+}
+
+static ssize_t
+aufs_splice_write(struct pipe_inode_info *pipe, struct file *file, loff_t *ppos,
+		  size_t len, unsigned int flags)
+{
+	ssize_t err;
+	struct au_pin pin;
+	struct dentry *dentry;
+	struct inode *inode;
+	struct super_block *sb;
+	struct file *h_file;
+
+	dentry = file->f_dentry;
+	inode = dentry->d_inode;
+	mutex_lock(&inode->i_mutex);
+	sb = dentry->d_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+
+	err = au_reval_and_lock_fdi(file, au_reopen_nondir, /*wlock*/1);
+	if (unlikely(err))
+		goto out;
+
+	err = au_ready_to_write(file, -1, &pin);
+	di_downgrade_lock(dentry, AuLock_IR);
+	if (unlikely(err))
+		goto out_unlock;
+
+	h_file = au_h_fptr(file, au_fbstart(file));
+	au_unpin(&pin);
+	err = vfsub_splice_from(pipe, h_file, ppos, len, flags);
+	au_cpup_attr_timesizes(inode);
+	inode->i_mode = h_file->f_dentry->d_inode->i_mode;
+
+ out_unlock:
+	di_read_unlock(dentry, AuLock_IR);
+	fi_write_unlock(file);
+ out:
+	si_read_unlock(sb);
+	mutex_unlock(&inode->i_mutex);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static struct file *au_safe_file(struct vm_area_struct *vma)
+{
+	struct file *file;
+
+	file = vma->vm_file;
+	if (file->private_data && au_test_aufs(file->f_dentry->d_sb))
+		return file;
+	return NULL;
+}
+
+static void au_reset_file(struct vm_area_struct *vma, struct file *file)
+{
+	vma->vm_file = file;
+	/* smp_mb(); */ /* flush vm_file */
+}
+
+static int aufs_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	int err;
+	static DECLARE_WAIT_QUEUE_HEAD(wq);
+	struct file *file, *h_file;
+	struct au_finfo *finfo;
+
+	/* todo: non-robr mode, user vm_file as it is? */
+	wait_event(wq, (file = au_safe_file(vma)));
+
+	/* do not revalidate, no si lock */
+	finfo = au_fi(file);
+	h_file = finfo->fi_hfile[0 + finfo->fi_bstart].hf_file;
+	AuDebugOn(!h_file || !au_test_mmapped(file));
+
+	fi_write_lock(file);
+	vma->vm_file = h_file;
+	err = finfo->fi_h_vm_ops->fault(vma, vmf);
+	/* todo: necessary? */
+	/* file->f_ra = h_file->f_ra; */
+	au_reset_file(vma, file);
+	fi_write_unlock(file);
+#if 0 /* def CONFIG_SMP */
+	/* wake_up_nr(&wq, online_cpu - 1); */
+	wake_up_all(&wq);
+#else
+	wake_up(&wq);
+#endif
+
+	return err;
+}
+
+static struct vm_operations_struct aufs_vm_ops = {
+	.fault		= aufs_fault
+};
+
+/* ---------------------------------------------------------------------- */
+
+static struct vm_operations_struct *au_vm_ops(struct file *h_file,
+					      struct vm_area_struct *vma)
+{
+	struct vm_operations_struct *vm_ops;
+	int err;
+
+	err = h_file->f_op->mmap(h_file, vma);
+	vm_ops = ERR_PTR(err);
+	if (unlikely(err))
+		goto out;
+	vm_ops = vma->vm_ops;
+	err = do_munmap(current->mm, vma->vm_start,
+			vma->vm_end - vma->vm_start);
+	if (unlikely(err)) {
+		AuIOErr("failed internal unmapping %.*s, %d\n",
+			AuDLNPair(h_file->f_dentry), err);
+		vm_ops = ERR_PTR(-EIO);
+	}
+
+ out:
+	return vm_ops;
+}
+
+static int aufs_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int err;
+	unsigned char wlock, mmapped;
+	struct dentry *dentry;
+	struct super_block *sb;
+	struct file *h_file;
+	struct vm_operations_struct *vm_ops;
+
+	dentry = file->f_dentry;
+	mmapped = !!au_test_mmapped(file); /* can be harmless race condition */
+	wlock = !!(file->f_mode & FMODE_WRITE);
+	sb = dentry->d_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+	err = au_reval_and_lock_fdi(file, au_reopen_nondir, wlock | !mmapped);
+	if (unlikely(err))
+		goto out;
+
+	if (wlock) {
+		struct au_pin pin;
+
+		err = au_ready_to_write(file, -1, &pin);
+		di_downgrade_lock(dentry, AuLock_IR);
+		if (unlikely(err))
+			goto out_unlock;
+		au_unpin(&pin);
+	} else if (!mmapped)
+		di_downgrade_lock(dentry, AuLock_IR);
+
+	h_file = au_h_fptr(file, au_fbstart(file));
+	if (au_test_fs_bad_mapping(h_file->f_dentry->d_sb)) {
+		/*
+		 * by this assignment, f_mapping will differs from aufs inode
+		 * i_mapping.
+		 * if someone else mixes the use of f_dentry->d_inode and
+		 * f_mapping->host, then a problem may arise.
+		 */
+		file->f_mapping = h_file->f_mapping;
+	}
+
+	vm_ops = NULL;
+	if (!mmapped) {
+		vm_ops = au_vm_ops(h_file, vma);
+		err = PTR_ERR(vm_ops);
+		if (IS_ERR(vm_ops))
+			goto out_unlock;
+	}
+
+	/*
+	 * unnecessary to handle MAP_DENYWRITE and deny_write_access()?
+	 * currently MAP_DENYWRITE from userspace is ignored, but elf loader
+	 * sets it. when FMODE_EXEC is set (by open_exec() or sys_uselib()),
+	 * both of the aufs file and the lower file is deny_write_access()-ed.
+	 * finally I hope we can skip handlling MAP_DENYWRITE here.
+	 */
+	err = generic_file_mmap(file, vma);
+	if (unlikely(err))
+		goto out_unlock;
+	vma->vm_ops = &aufs_vm_ops;
+	/* test again */
+	if (!au_test_mmapped(file))
+		au_fi(file)->fi_h_vm_ops = vm_ops;
+
+	vfsub_file_accessed(h_file);
+	fsstack_copy_attr_atime(dentry->d_inode, h_file->f_dentry->d_inode);
+
+ out_unlock:
+	di_read_unlock(dentry, AuLock_IR);
+	if (!wlock && mmapped)
+		fi_read_unlock(file);
+	else
+		fi_write_unlock(file);
+ out:
+	si_read_unlock(sb);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static unsigned int aufs_poll(struct file *file, poll_table *wait)
+{
+	unsigned int mask;
+	int err;
+	struct file *h_file;
+	struct dentry *dentry;
+	struct super_block *sb;
+
+	/* We should pretend an error happened. */
+	mask = POLLERR /* | POLLIN | POLLOUT */;
+	dentry = file->f_dentry;
+	sb = dentry->d_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+	err = au_reval_and_lock_fdi(file, au_reopen_nondir, /*wlock*/0);
+	if (unlikely(err))
+		goto out;
+
+	/* it is not an error if h_file has no operation */
+	mask = DEFAULT_POLLMASK;
+	h_file = au_h_fptr(file, au_fbstart(file));
+	if (h_file->f_op && h_file->f_op->poll)
+		mask = h_file->f_op->poll(h_file, wait);
+
+	di_read_unlock(dentry, AuLock_IR);
+	fi_read_unlock(file);
+
+ out:
+	si_read_unlock(sb);
+	AuTraceErr((int)mask);
+	return mask;
+}
+
+static int aufs_fsync_nondir(struct file *file, struct dentry *dentry,
+			     int datasync)
+{
+	int err;
+	struct au_pin pin;
+	struct inode *inode;
+	struct file *h_file;
+	struct super_block *sb;
+
+	inode = dentry->d_inode;
+	IMustLock(file->f_mapping->host);
+	if (inode != file->f_mapping->host) {
+		mutex_unlock(&file->f_mapping->host->i_mutex);
+		mutex_lock(&inode->i_mutex);
+	}
+	IMustLock(inode);
+
+	sb = dentry->d_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+
+	err = 0; /* -EBADF; */ /* posix? */
+	if (unlikely(!(file->f_mode & FMODE_WRITE)))
+		goto out;
+	err = au_reval_and_lock_fdi(file, au_reopen_nondir, /*wlock*/1);
+	if (unlikely(err))
+		goto out;
+
+	err = au_ready_to_write(file, -1, &pin);
+	di_downgrade_lock(dentry, AuLock_IR);
+	if (unlikely(err))
+		goto out_unlock;
+	au_unpin(&pin);
+
+	err = -EINVAL;
+	h_file = au_h_fptr(file, au_fbstart(file));
+	if (h_file->f_op && h_file->f_op->fsync) {
+		struct dentry *h_d;
+		struct mutex *h_mtx;
+
+		/*
+		 * no filemap_fdatawrite() since aufs file has no its own
+		 * mapping, but dir.
+		 */
+		h_d = h_file->f_dentry;
+		h_mtx = &h_d->d_inode->i_mutex;
+		mutex_lock_nested(h_mtx, AuLsc_I_CHILD);
+		err = h_file->f_op->fsync(h_file, h_d, datasync);
+		if (!err)
+			vfsub_update_h_iattr(&h_file->f_path, /*did*/NULL);
+		/*ignore*/
+		au_cpup_attr_timesizes(inode);
+		mutex_unlock(h_mtx);
+	}
+
+ out_unlock:
+	di_read_unlock(dentry, AuLock_IR);
+	fi_write_unlock(file);
+ out:
+	si_read_unlock(sb);
+	if (inode != file->f_mapping->host) {
+		mutex_unlock(&inode->i_mutex);
+		mutex_lock(&file->f_mapping->host->i_mutex);
+	}
+	return err;
+}
+
+static int aufs_fasync(int fd, struct file *file, int flag)
+{
+	int err;
+	struct file *h_file;
+	struct dentry *dentry;
+	struct super_block *sb;
+
+	dentry = file->f_dentry;
+	sb = dentry->d_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+	err = au_reval_and_lock_fdi(file, au_reopen_nondir, /*wlock*/0);
+	if (unlikely(err))
+		goto out;
+
+	h_file = au_h_fptr(file, au_fbstart(file));
+	if (h_file->f_op && h_file->f_op->fasync)
+		err = h_file->f_op->fasync(fd, h_file, flag);
+
+	di_read_unlock(dentry, AuLock_IR);
+	fi_read_unlock(file);
+
+ out:
+	si_read_unlock(sb);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct file_operations aufs_file_fop = {
+	/*
+	 * while generic_file_llseek/_unlocked() don't use BKL,
+	 * don't use it since it operates file->f_mapping->host.
+	 * in aufs, it may be a real file and may confuse users by UDBA.
+	 */
+	/* .llseek		= generic_file_llseek, */
+
+	.read		= aufs_read,
+	.write		= aufs_write,
+	.poll		= aufs_poll,
+	.mmap		= aufs_mmap,
+	.open		= aufs_open_nondir,
+	.flush		= aufs_flush,
+	.release	= aufs_release_nondir,
+	.fsync		= aufs_fsync_nondir,
+	.fasync		= aufs_fasync,
+	.splice_write	= aufs_splice_write,
+	.splice_read	= aufs_splice_read
+};
diff --git a/fs/aufs/file.c b/fs/aufs/file.c
new file mode 100644
index 0000000..470281b
--- /dev/null
+++ b/fs/aufs/file.c
@@ -0,0 +1,552 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * handling file/dir, and address_space operation
+ */
+
+#include <linux/fsnotify.h>
+#include <linux/pagemap.h>
+#include "aufs.h"
+
+/*
+ * a dirty trick for handling deny_write_access().
+ * because FMODE_EXEC flag is not passed to f_op->open(),
+ * set it to file->private_data temporary.
+ */
+void au_store_oflag(struct nameidata *nd)
+{
+	if (nd
+	    && !(nd->flags & LOOKUP_CONTINUE)
+	    && (nd->flags & LOOKUP_OPEN))
+		nd->intent.open.file->private_data
+			= (void *)nd->intent.open.flags;
+	/* smp_mb(); */
+}
+
+/* drop flags for writing */
+unsigned int au_file_roflags(unsigned int flags)
+{
+	flags &= ~(O_WRONLY | O_RDWR | O_APPEND | O_CREAT | O_TRUNC);
+	flags |= O_RDONLY | O_NOATIME;
+	return flags;
+}
+
+/* common functions to regular file and dir */
+struct file *au_h_open(struct dentry *dentry, aufs_bindex_t bindex, int flags,
+		       struct file *file)
+{
+	struct file *h_file;
+	struct dentry *h_dentry;
+	struct inode *h_inode;
+	struct super_block *sb;
+	struct au_branch *br;
+	int err;
+
+	h_dentry = au_h_dptr(dentry, bindex);
+	h_inode = h_dentry->d_inode;
+	/* a race condition can happen between open and unlink/rmdir */
+	h_file = ERR_PTR(-ENOENT);
+	if (unlikely((!d_unhashed(dentry) && d_unhashed(h_dentry))
+		     || !h_inode))
+		goto out;
+
+	sb = dentry->d_sb;
+	br = au_sbr(sb, bindex);
+	h_file = ERR_PTR(-EACCES);
+	if (file && (file->f_mode & FMODE_EXEC)
+	    && (br->br_mnt->mnt_flags & MNT_NOEXEC))
+		goto out;
+
+	/* drop flags for writing */
+	if (au_test_ro(sb, bindex, dentry->d_inode))
+		flags = au_file_roflags(flags);
+	flags &= ~O_CREAT;
+	atomic_inc(&br->br_count);
+	h_file = dentry_open(dget(h_dentry), mntget(br->br_mnt), flags,
+			     current_cred());
+	if (IS_ERR(h_file))
+		goto out_br;
+
+	if (file && (file->f_mode & FMODE_EXEC)) {
+		h_file->f_mode |= FMODE_EXEC;
+		err = deny_write_access(h_file);
+		if (unlikely(err)) {
+			fput(h_file);
+			h_file = ERR_PTR(err);
+			goto out_br;
+		}
+	}
+	fsnotify_open(h_dentry);
+	goto out; /* success */
+
+ out_br:
+	atomic_dec(&br->br_count);
+ out:
+	return h_file;
+}
+
+int au_do_open(struct file *file, int (*open)(struct file *file, int flags))
+{
+	int err;
+	struct dentry *dentry;
+	struct super_block *sb;
+
+	dentry = file->f_dentry;
+	sb = dentry->d_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+	err = au_finfo_init(file);
+	if (unlikely(err))
+		goto out;
+
+	di_read_lock_child(dentry, AuLock_IR);
+	err = open(file, file->f_flags);
+	di_read_unlock(dentry, AuLock_IR);
+
+	fi_write_unlock(file);
+	if (unlikely(err))
+		au_finfo_fin(file);
+ out:
+	si_read_unlock(sb);
+	return err;
+}
+
+int au_reopen_nondir(struct file *file)
+{
+	int err;
+	aufs_bindex_t bstart, bindex, bend;
+	struct dentry *dentry;
+	struct file *h_file, *h_file_tmp;
+
+	dentry = file->f_dentry;
+	bstart = au_dbstart(dentry);
+	h_file_tmp = NULL;
+	if (au_fbstart(file) == bstart) {
+		h_file = au_h_fptr(file, bstart);
+		if (file->f_mode == h_file->f_mode)
+			return 0; /* success */
+		h_file_tmp = h_file;
+		get_file(h_file_tmp);
+		au_set_h_fptr(file, bstart, NULL);
+	}
+	AuDebugOn(au_fbstart(file) < bstart
+		  || au_fi(file)->fi_hfile[0 + bstart].hf_file);
+
+	h_file = au_h_open(dentry, bstart, file->f_flags & ~O_TRUNC, file);
+	err = PTR_ERR(h_file);
+	if (IS_ERR(h_file))
+		goto out; /* todo: close all? */
+
+	err = 0;
+	au_set_fbstart(file, bstart);
+	au_set_h_fptr(file, bstart, h_file);
+	au_update_figen(file);
+	/* todo: necessary? */
+	/* file->f_ra = h_file->f_ra; */
+
+	/* close lower files */
+	bend = au_fbend(file);
+	for (bindex = bstart + 1; bindex <= bend; bindex++)
+		au_set_h_fptr(file, bindex, NULL);
+	au_set_fbend(file, bstart);
+
+ out:
+	if (h_file_tmp)
+		fput(h_file_tmp);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int au_reopen_wh(struct file *file, aufs_bindex_t btgt,
+			struct dentry *hi_wh)
+{
+	int err;
+	aufs_bindex_t bstart;
+	struct au_dinfo *dinfo;
+	struct dentry *h_dentry;
+
+	dinfo = au_di(file->f_dentry);
+	bstart = dinfo->di_bstart;
+	dinfo->di_bstart = btgt;
+	h_dentry = dinfo->di_hdentry[0 + btgt].hd_dentry;
+	dinfo->di_hdentry[0 + btgt].hd_dentry = hi_wh;
+	err = au_reopen_nondir(file);
+	dinfo->di_hdentry[0 + btgt].hd_dentry = h_dentry;
+	dinfo->di_bstart = bstart;
+
+	return err;
+}
+
+static int au_ready_to_write_wh(struct file *file, loff_t len,
+				aufs_bindex_t bcpup)
+{
+	int err;
+	struct inode *inode;
+	struct dentry *dentry, *hi_wh;
+	struct super_block *sb;
+
+	dentry = file->f_dentry;
+	inode = dentry->d_inode;
+	hi_wh = au_hi_wh(inode, bcpup);
+	if (!hi_wh)
+		err = au_sio_cpup_wh(dentry, bcpup, len, file);
+	else
+		/* already copied-up after unlink */
+		err = au_reopen_wh(file, bcpup, hi_wh);
+
+	sb = dentry->d_sb;
+	if (!err && inode->i_nlink > 1 && au_opt_test(au_mntflags(sb), PLINK))
+		au_plink_append(inode, bcpup, au_h_dptr(dentry, bcpup));
+
+	return err;
+}
+
+/*
+ * prepare the @file for writing.
+ */
+int au_ready_to_write(struct file *file, loff_t len, struct au_pin *pin)
+{
+	int err;
+	aufs_bindex_t bstart, bcpup;
+	struct dentry *dentry, *parent, *h_dentry;
+	struct inode *h_inode, *inode;
+	struct super_block *sb;
+
+	dentry = file->f_dentry;
+	sb = dentry->d_sb;
+	bstart = au_fbstart(file);
+	inode = dentry->d_inode;
+	err = au_test_ro(sb, bstart, inode);
+	if (!err && (au_h_fptr(file, bstart)->f_mode & FMODE_WRITE)) {
+		err = au_pin(pin, dentry, bstart, AuOpt_UDBA_NONE, /*flags*/0);
+		goto out;
+	}
+
+	/* need to cpup */
+	parent = dget_parent(dentry);
+	di_write_lock_parent(parent);
+	err = AuWbrCopyup(au_sbi(sb), dentry);
+	bcpup = err;
+	if (unlikely(err < 0))
+		goto out_dgrade;
+	err = 0;
+
+	if (!au_h_dptr(parent, bcpup)) {
+		err = au_cpup_dirs(dentry, bcpup);
+		if (unlikely(err))
+			goto out_dgrade;
+	}
+
+	err = au_pin(pin, dentry, bcpup, AuOpt_UDBA_NONE,
+		     AuPin_DI_LOCKED | AuPin_MNT_WRITE);
+	if (unlikely(err))
+		goto out_dgrade;
+
+	h_dentry = au_h_fptr(file, bstart)->f_dentry;
+	h_inode = h_dentry->d_inode;
+	mutex_lock_nested(&h_inode->i_mutex, AuLsc_I_CHILD);
+	if (d_unhashed(dentry) /* || d_unhashed(h_dentry) */
+	    /* || !h_inode->i_nlink */) {
+		err = au_ready_to_write_wh(file, len, bcpup);
+		di_downgrade_lock(parent, AuLock_IR);
+	} else {
+		di_downgrade_lock(parent, AuLock_IR);
+		if (!au_h_dptr(dentry, bcpup))
+			err = au_sio_cpup_simple(dentry, bcpup, len,
+						 AuCpup_DTIME);
+		if (!err)
+			err = au_reopen_nondir(file);
+	}
+	mutex_unlock(&h_inode->i_mutex);
+
+	if (!err) {
+		au_pin_set_parent_lflag(pin, /*lflag*/0);
+		goto out_dput; /* success */
+	}
+	au_unpin(pin);
+	goto out_unlock;
+
+ out_dgrade:
+	di_downgrade_lock(parent, AuLock_IR);
+ out_unlock:
+	di_read_unlock(parent, AuLock_IR);
+ out_dput:
+	dput(parent);
+ out:
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int au_file_refresh_by_inode(struct file *file, int *need_reopen)
+{
+	int err;
+	aufs_bindex_t bstart;
+	struct au_pin pin;
+	struct au_finfo *finfo;
+	struct dentry *dentry, *parent, *hi_wh;
+	struct inode *inode;
+	struct super_block *sb;
+
+	err = 0;
+	finfo = au_fi(file);
+	dentry = file->f_dentry;
+	sb = dentry->d_sb;
+	inode = dentry->d_inode;
+	bstart = au_ibstart(inode);
+	if (bstart == finfo->fi_bstart)
+		goto out;
+
+	parent = dget_parent(dentry);
+	if (au_test_ro(sb, bstart, inode)) {
+		di_read_lock_parent(parent, !AuLock_IR);
+		err = AuWbrCopyup(au_sbi(sb), dentry);
+		bstart = err;
+		di_read_unlock(parent, !AuLock_IR);
+		if (unlikely(err < 0))
+			goto out_parent;
+		err = 0;
+	}
+
+	di_read_lock_parent(parent, AuLock_IR);
+	hi_wh = au_hi_wh(inode, bstart);
+	if (au_opt_test(au_mntflags(sb), PLINK)
+	    && au_plink_test(inode)
+	    && !d_unhashed(dentry)) {
+		err = au_test_and_cpup_dirs(dentry, bstart);
+		if (unlikely(err))
+			goto out_unlock;
+
+		/* always superio. */
+		err = au_pin(&pin, dentry, bstart, AuOpt_UDBA_NONE,
+			     AuPin_DI_LOCKED | AuPin_MNT_WRITE);
+		if (!err)
+			err = au_sio_cpup_simple(dentry, bstart, -1,
+						 AuCpup_DTIME);
+		au_unpin(&pin);
+	} else if (hi_wh) {
+		/* already copied-up after unlink */
+		err = au_reopen_wh(file, bstart, hi_wh);
+		*need_reopen = 0;
+	}
+
+ out_unlock:
+	di_read_unlock(parent, AuLock_IR);
+ out_parent:
+	dput(parent);
+ out:
+	return err;
+}
+
+static void au_do_refresh_file(struct file *file)
+{
+	aufs_bindex_t bindex, bend, new_bindex, brid;
+	struct au_hfile *p, tmp, *q;
+	struct au_finfo *finfo;
+	struct super_block *sb;
+
+	sb = file->f_dentry->d_sb;
+	finfo = au_fi(file);
+	p = finfo->fi_hfile + finfo->fi_bstart;
+	brid = p->hf_br->br_id;
+	bend = finfo->fi_bend;
+	for (bindex = finfo->fi_bstart; bindex <= bend; bindex++, p++) {
+		if (!p->hf_file)
+			continue;
+
+		new_bindex = au_br_index(sb, p->hf_br->br_id);
+		if (new_bindex == bindex)
+			continue;
+		if (new_bindex < 0) {
+			au_set_h_fptr(file, bindex, NULL);
+			continue;
+		}
+
+		/* swap two lower inode, and loop again */
+		q = finfo->fi_hfile + new_bindex;
+		tmp = *q;
+		*q = *p;
+		*p = tmp;
+		if (tmp.hf_file) {
+			bindex--;
+			p--;
+		}
+	}
+
+	p = finfo->fi_hfile;
+	if (!au_test_mmapped(file) && !d_unhashed(file->f_dentry)) {
+		bend = au_sbend(sb);
+		for (finfo->fi_bstart = 0; finfo->fi_bstart <= bend;
+		     finfo->fi_bstart++, p++)
+			if (p->hf_file) {
+				if (p->hf_file->f_dentry
+				    && p->hf_file->f_dentry->d_inode)
+					break;
+				else
+					au_hfput(p, file);
+			}
+	} else {
+		bend = au_br_index(sb, brid);
+		for (finfo->fi_bstart = 0; finfo->fi_bstart < bend;
+		     finfo->fi_bstart++, p++)
+			if (p->hf_file)
+				au_hfput(p, file);
+		bend = au_sbend(sb);
+	}
+
+	p = finfo->fi_hfile + bend;
+	for (finfo->fi_bend = bend; finfo->fi_bend >= finfo->fi_bstart;
+	     finfo->fi_bend--, p--)
+		if (p->hf_file) {
+			if (p->hf_file->f_dentry
+			    && p->hf_file->f_dentry->d_inode)
+				break;
+			else
+				au_hfput(p, file);
+		}
+	AuDebugOn(finfo->fi_bend < finfo->fi_bstart);
+}
+
+/*
+ * after branch manipulating, refresh the file.
+ */
+static int refresh_file(struct file *file, int (*reopen)(struct file *file))
+{
+	int err, need_reopen;
+	struct dentry *dentry;
+	aufs_bindex_t bend, bindex;
+
+	dentry = file->f_dentry;
+	err = au_fi_realloc(au_fi(file), au_sbend(dentry->d_sb) + 1);
+	if (unlikely(err))
+		goto out;
+	au_do_refresh_file(file);
+
+	err = 0;
+	need_reopen = 1;
+	if (!au_test_mmapped(file))
+		err = au_file_refresh_by_inode(file, &need_reopen);
+	if (!err && need_reopen && !d_unhashed(dentry))
+		err = reopen(file);
+	if (!err) {
+		au_update_figen(file);
+		return 0; /* success */
+	}
+
+	/* error, close all lower files */
+	bend = au_fbend(file);
+	for (bindex = au_fbstart(file); bindex <= bend; bindex++)
+		au_set_h_fptr(file, bindex, NULL);
+
+ out:
+	return err;
+}
+
+/* common function to regular file and dir */
+int au_reval_and_lock_fdi(struct file *file, int (*reopen)(struct file *file),
+			  int wlock)
+{
+	int err;
+	unsigned int sigen, figen;
+	aufs_bindex_t bstart;
+	unsigned char pseudo_link;
+	struct dentry *dentry;
+
+	err = 0;
+	dentry = file->f_dentry;
+	sigen = au_sigen(dentry->d_sb);
+	fi_write_lock(file);
+	figen = au_figen(file);
+	di_write_lock_child(dentry);
+	bstart = au_dbstart(dentry);
+	pseudo_link = (bstart != au_ibstart(dentry->d_inode));
+	if (sigen == figen && !pseudo_link && au_fbstart(file) == bstart) {
+		if (!wlock) {
+			di_downgrade_lock(dentry, AuLock_IR);
+			fi_downgrade_lock(file);
+		}
+		goto out; /* success */
+	}
+
+	AuDbg("sigen %d, figen %d\n", sigen, figen);
+	if (sigen != au_digen(dentry)
+	    || sigen != au_iigen(dentry->d_inode)) {
+		err = au_reval_dpath(dentry, sigen);
+		if (unlikely(err < 0))
+			goto out;
+		AuDebugOn(au_digen(dentry) != sigen
+			  || au_iigen(dentry->d_inode) != sigen);
+	}
+
+	err = refresh_file(file, reopen);
+	if (!err) {
+		if (!wlock) {
+			di_downgrade_lock(dentry, AuLock_IR);
+			fi_downgrade_lock(file);
+		}
+	} else {
+		di_write_unlock(dentry);
+		fi_write_unlock(file);
+	}
+
+ out:
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* cf. aufs_nopage() */
+/* for madvise(2) */
+static int aufs_readpage(struct file *file __maybe_unused, struct page *page)
+{
+	unlock_page(page);
+	return 0;
+}
+
+/* they will never be called. */
+#ifdef CONFIG_AUFS_DEBUG
+static int aufs_write_begin(struct file *file, struct address_space *mapping,
+			    loff_t pos, unsigned len, unsigned flags,
+			    struct page **pagep, void **fsdata)
+{ AuUnsupport(); return 0; }
+static int aufs_write_end(struct file *file, struct address_space *mapping,
+			  loff_t pos, unsigned len, unsigned copied,
+			  struct page *page, void *fsdata)
+{ AuUnsupport(); return 0; }
+static int aufs_writepage(struct page *page, struct writeback_control *wbc)
+{ AuUnsupport(); return 0; }
+static void aufs_sync_page(struct page *page)
+{ AuUnsupport(); }
+
+static int aufs_set_page_dirty(struct page *page)
+{ AuUnsupport(); return 0; }
+static void aufs_invalidatepage(struct page *page, unsigned long offset)
+{ AuUnsupport(); }
+static int aufs_releasepage(struct page *page, gfp_t gfp)
+{ AuUnsupport(); return 0; }
+static ssize_t aufs_direct_IO(int rw, struct kiocb *iocb,
+			      const struct iovec *iov, loff_t offset,
+			      unsigned long nr_segs)
+{ AuUnsupport(); return 0; }
+#endif /* CONFIG_AUFS_DEBUG */
+
+struct address_space_operations aufs_aop = {
+	.readpage	= aufs_readpage,
+#ifdef CONFIG_AUFS_DEBUG
+	.writepage	= aufs_writepage,
+	.sync_page	= aufs_sync_page,
+	.set_page_dirty	= aufs_set_page_dirty,
+	.write_begin	= aufs_write_begin,
+	.write_end	= aufs_write_end,
+	.invalidatepage	= aufs_invalidatepage,
+	.releasepage	= aufs_releasepage,
+	.direct_IO	= aufs_direct_IO,
+#endif /* CONFIG_AUFS_DEBUG */
+};
diff --git a/fs/aufs/file.h b/fs/aufs/file.h
new file mode 100644
index 0000000..3004054
--- /dev/null
+++ b/fs/aufs/file.h
@@ -0,0 +1,148 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * file operations
+ */
+
+#ifndef __AUFS_FILE_H__
+#define __AUFS_FILE_H__
+
+#ifdef __KERNEL__
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/aufs_type.h>
+#include "rwsem.h"
+
+struct au_branch;
+struct au_hfile {
+	struct file		*hf_file;
+	struct au_branch	*hf_br;
+};
+
+struct au_vdir;
+struct au_finfo {
+	atomic_t		fi_generation;
+
+	struct rw_semaphore	fi_rwsem;
+	struct au_hfile		*fi_hfile;
+	aufs_bindex_t		fi_bstart, fi_bend;
+
+	union {
+		/* non-dir only */
+		struct vm_operations_struct	*fi_h_vm_ops;
+
+		/* dir only */
+		struct {
+			struct au_vdir		*fi_vdir_cache;
+			int			fi_maintain_plink;
+		};
+	};
+};
+
+/* ---------------------------------------------------------------------- */
+
+/* file.c */
+extern struct address_space_operations aufs_aop;
+void au_store_oflag(struct nameidata *nd);
+unsigned int au_file_roflags(unsigned int flags);
+struct file *au_h_open(struct dentry *dentry, aufs_bindex_t bindex, int flags,
+		       struct file *file);
+int au_do_open(struct file *file, int (*open)(struct file *file, int flags));
+int au_reopen_nondir(struct file *file);
+struct au_pin;
+int au_ready_to_write(struct file *file, loff_t len, struct au_pin *pin);
+int au_reval_and_lock_fdi(struct file *file, int (*reopen)(struct file *file),
+			  int wlock);
+
+/* f_op.c */
+extern struct file_operations aufs_file_fop;
+int aufs_flush(struct file *file, fl_owner_t id);
+
+/* finfo.c */
+void au_hfput(struct au_hfile *hf, struct file *file);
+void au_set_h_fptr(struct file *file, aufs_bindex_t bindex,
+		   struct file *h_file);
+
+void au_update_figen(struct file *file);
+
+void au_finfo_fin(struct file *file);
+int au_finfo_init(struct file *file);
+int au_fi_realloc(struct au_finfo *finfo, int nbr);
+
+/* ---------------------------------------------------------------------- */
+
+static inline struct au_finfo *au_fi(struct file *file)
+{
+	return file->private_data;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * fi_read_lock, fi_write_lock,
+ * fi_read_unlock, fi_write_unlock, fi_downgrade_lock
+ */
+AuSimpleRwsemFuncs(fi, struct file *f, &au_fi(f)->fi_rwsem);
+
+#define FiMustNoWaiters(f)	AuRwMustNoWaiters(&au_fi(f)->fi_rwsem)
+
+/* ---------------------------------------------------------------------- */
+
+/* todo: hard/soft set? */
+static inline aufs_bindex_t au_fbstart(struct file *file)
+{
+	return au_fi(file)->fi_bstart;
+}
+
+static inline aufs_bindex_t au_fbend(struct file *file)
+{
+	return au_fi(file)->fi_bend;
+}
+
+static inline struct au_vdir *au_fvdir_cache(struct file *file)
+{
+	return au_fi(file)->fi_vdir_cache;
+}
+
+static inline void au_set_fbstart(struct file *file, aufs_bindex_t bindex)
+{
+	au_fi(file)->fi_bstart = bindex;
+}
+
+static inline void au_set_fbend(struct file *file, aufs_bindex_t bindex)
+{
+	au_fi(file)->fi_bend = bindex;
+}
+
+static inline void au_set_fvdir_cache(struct file *file,
+				      struct au_vdir *vdir_cache)
+{
+	au_fi(file)->fi_vdir_cache = vdir_cache;
+}
+
+static inline struct file *au_h_fptr(struct file *file, aufs_bindex_t bindex)
+{
+	return au_fi(file)->fi_hfile[0 + bindex].hf_file;
+}
+
+/* todo: memory barrier? */
+static inline unsigned int au_figen(struct file *f)
+{
+	return atomic_read(&au_fi(f)->fi_generation);
+}
+
+static inline int au_test_mmapped(struct file *f)
+{
+	return !!(au_fi(f)->fi_h_vm_ops);
+}
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_FILE_H__ */
diff --git a/fs/aufs/finfo.c b/fs/aufs/finfo.c
new file mode 100644
index 0000000..49c4934
--- /dev/null
+++ b/fs/aufs/finfo.c
@@ -0,0 +1,126 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * file private data
+ */
+
+#include "aufs.h"
+
+void au_hfput(struct au_hfile *hf, struct file *file)
+{
+	if (file->f_mode & FMODE_EXEC)
+		allow_write_access(hf->hf_file);
+	fput(hf->hf_file);
+	hf->hf_file = NULL;
+	atomic_dec(&hf->hf_br->br_count);
+	hf->hf_br = NULL;
+}
+
+void au_set_h_fptr(struct file *file, aufs_bindex_t bindex, struct file *val)
+{
+	struct au_finfo *finfo = au_fi(file);
+	struct au_hfile *hf;
+
+	hf = finfo->fi_hfile + bindex;
+	if (hf->hf_file)
+		au_hfput(hf, file);
+	if (val) {
+		hf->hf_file = val;
+		hf->hf_br = au_sbr(file->f_dentry->d_sb, bindex);
+	}
+}
+
+void au_update_figen(struct file *file)
+{
+	atomic_set(&au_fi(file)->fi_generation, au_digen(file->f_dentry));
+	/* smp_mb(); */ /* atomic_set */
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_finfo_fin(struct file *file)
+{
+	struct au_finfo *finfo;
+	aufs_bindex_t bindex, bend;
+
+	fi_write_lock(file);
+	bend = au_fbend(file);
+	bindex = au_fbstart(file);
+	if (bindex >= 0)
+		/*
+		 * calls fput() instead of filp_close(),
+		 * since no dnotify or lock for the lower file.
+		 */
+		for (; bindex <= bend; bindex++)
+			au_set_h_fptr(file, bindex, NULL);
+
+	finfo = au_fi(file);
+	au_dbg_verify_hf(finfo);
+	kfree(finfo->fi_hfile);
+	fi_write_unlock(file);
+	au_rwsem_destroy(&finfo->fi_rwsem);
+	au_cache_free_finfo(finfo);
+}
+
+int au_finfo_init(struct file *file)
+{
+	struct au_finfo *finfo;
+	struct dentry *dentry;
+	union {
+		unsigned int u;
+		fmode_t m;
+	} u;
+
+	dentry = file->f_dentry;
+	finfo = au_cache_alloc_finfo();
+	if (unlikely(!finfo))
+		goto out;
+
+	finfo->fi_hfile = kcalloc(au_sbend(dentry->d_sb) + 1,
+				  sizeof(*finfo->fi_hfile), GFP_NOFS);
+	if (unlikely(!finfo->fi_hfile))
+		goto out_finfo;
+
+	init_rwsem(&finfo->fi_rwsem);
+	down_write(&finfo->fi_rwsem);
+	finfo->fi_bstart = -1;
+	finfo->fi_bend = -1;
+	atomic_set(&finfo->fi_generation, au_digen(dentry));
+	/* smp_mb(); */ /* atomic_set */
+
+	/* cf. au_store_oflag() */
+	u.u = (unsigned int)file->private_data;
+	file->f_mode |= (u.m & FMODE_EXEC);
+	file->private_data = finfo;
+	return 0; /* success */
+
+ out_finfo:
+	au_cache_free_finfo(finfo);
+ out:
+	return -ENOMEM;
+}
+
+int au_fi_realloc(struct au_finfo *finfo, int nbr)
+{
+	int err, sz;
+	struct au_hfile *hfp;
+
+	err = -ENOMEM;
+	sz = sizeof(*hfp) * (finfo->fi_bend + 1);
+	if (!sz)
+		sz = sizeof(*hfp);
+	hfp = au_kzrealloc(finfo->fi_hfile, sz, sizeof(*hfp) * nbr, GFP_NOFS);
+	if (hfp) {
+		finfo->fi_hfile = hfp;
+		err = 0;
+	}
+
+	return err;
+}
-- 
1.6.1.284.g5dc13

