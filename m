Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbXEBFnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbXEBFnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXEBFnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:43:31 -0400
Received: from haxent.com ([65.99.219.155]:2161 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbXEBFen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:43 -0400
Message-Id: <20070502053424.323964000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:37 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 02/22] pollfs: file system operations
Content-Disposition: inline; filename=pollfs-core.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The key feature of the pollfs file operations is to internally handle
pollable (waitable) resources as files without exporting complex and
bug-prone underlying (VFS) implementation details.

All resource handlers are required to implement the read, write, poll,
release operations and must not block.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 fs/Makefile        |    1 
 fs/pollfs/Makefile |    2 
 fs/pollfs/file.c   |  238 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig       |    6 +
 4 files changed, 247 insertions(+)

Index: linux-2.6/fs/pollfs/file.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/pollfs/file.c
@@ -0,0 +1,238 @@
+/*
+ * Copyright (C) 2007 Davi E. M. Arnaut
+ *
+ * Licensed under the GNU GPL. See the file COPYING for details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/wait.h>
+#include <asm/uaccess.h>
+#include <linux/poll.h>
+#include <linux/file.h>
+#include <linux/mount.h>
+#include <linux/pollfs_fs.h>
+
+#define POLLFS_MAGIC 0x9a6afcd
+
+MODULE_LICENSE("GPL");
+
+/* pollfs vfsmount entry */
+static struct vfsmount *pfs_mnt;
+
+/* pollfs file operations */
+static const struct file_operations pfs_fops;
+
+static inline ssize_t
+pfs_read_nonblock(const struct pfs_operations *fops, void *data,
+		  void __user *obj, size_t nr)
+{
+	ssize_t count = 0, res = 0;
+
+	do {
+		res = fops->read(data, obj);
+		if (res)
+			break;
+		count++;
+		obj += fops->rsize;
+	} while (--nr);
+
+	if (count)
+		return count * fops->rsize;
+	else if (res)
+		return res;
+	else
+		return -EAGAIN;
+}
+
+static inline ssize_t
+pfs_read_block(const struct pfs_operations *fops, void *data,
+	       wait_queue_head_t *wait, void __user *obj, size_t nr)
+{
+	ssize_t count;
+
+	do {
+		count = pfs_read_nonblock(fops, data, obj, nr);
+		if (count != -EAGAIN)
+			break;
+		count = wait_event_interruptible((*wait), fops->poll(data));
+	} while (!count);
+
+	return count;
+}
+
+static ssize_t pfs_read(struct file *filp, char __user *buf,
+			size_t count, loff_t * pos)
+{
+	size_t nevents = count;
+	struct pfs_file *pfs = filp->private_data;
+	const struct pfs_operations *fops = pfs->fops;
+
+	if (fops->rsize)
+		nevents /= fops->rsize;
+	else
+		nevents = 1;
+
+	if (!nevents)
+		return -EINVAL;
+
+	if (filp->f_flags & O_NONBLOCK)
+		return pfs_read_nonblock(fops, pfs->data, buf, nevents);
+	else
+		return pfs_read_block(fops, pfs->data, pfs->wait, buf, nevents);
+}
+
+static ssize_t pfs_write(struct file *filp, const char __user *buf,
+			 size_t count, loff_t * ppos)
+{
+	ssize_t res = 0;
+	size_t nevents = count;
+	struct pfs_file *pfs = filp->private_data;
+	const struct pfs_operations *fops = pfs->fops;
+
+	if (fops->wsize)
+		nevents /= fops->wsize;
+	else
+		nevents = 1;
+
+	if (!nevents)
+		return -EINVAL;
+
+	count = 0;
+
+	do {
+		res = fops->write(pfs->data, buf);
+		if (res)
+			break;
+		count++;
+		buf += fops->wsize;
+	} while (--nevents);
+
+	if (count)
+		return count * fops->wsize;
+	else if (res)
+		return res;
+	else
+		return 0;
+}
+
+static unsigned int pfs_poll(struct file *filp, struct poll_table_struct *wait)
+{
+	int ret = 0;
+	struct pfs_file *pfs = filp->private_data;
+
+	poll_wait(filp, pfs->wait, wait);
+
+	if (pfs->fops->poll)
+		ret = pfs->fops->poll(pfs->data);
+	else
+		ret = POLLIN;
+
+	return ret;
+}
+
+static int pfs_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct pfs_file *pfs = filp->private_data;
+
+	return (pfs->fops->mmap) ? pfs->fops->mmap(pfs->data, vma) : -ENODEV;
+}
+
+static int pfs_release(struct inode *inode, struct file *filp)
+{
+	struct pfs_file *pfs = filp->private_data;
+
+	return pfs->fops->release(pfs->data);
+}
+
+static const struct file_operations pfs_fops = {
+	.poll = pfs_poll,
+	.mmap = pfs_mmap,
+	.read = pfs_read,
+	.write = pfs_write,
+	.release = pfs_release
+};
+
+long pfs_open(struct pfs_file *pfs)
+{
+	int fd;
+	struct file *filp;
+	const struct pfs_operations *fops = pfs->fops;
+
+	if (IS_ERR(pfs_mnt))
+		return -ENOSYS;
+
+	if (!fops->poll || (!fops->read || !fops->write))
+		return -EINVAL;
+
+	fd = get_unused_fd();
+	if (fd < 0)
+		return -ENFILE;
+
+	filp = get_empty_filp();
+	if (!filp) {
+		put_unused_fd(fd);
+		return -ENFILE;
+	}
+
+	filp->f_op = &pfs_fops;
+	filp->f_path.mnt = mntget(pfs_mnt);
+	filp->f_path.dentry = dget(pfs_mnt->mnt_root);
+	filp->f_mapping = filp->f_path.dentry->d_inode->i_mapping;
+	filp->f_mode = 0;
+	filp->f_flags = 0;
+	filp->private_data = pfs;
+
+	if (fops->read) {
+		filp->f_flags = O_RDONLY;
+		filp->f_mode |= FMODE_READ;
+	}
+
+	if (fops->write) {
+		filp->f_flags = O_WRONLY;
+		filp->f_mode |= FMODE_WRITE;
+	}
+
+	if (fops->write && fops->read)
+		filp->f_flags = O_RDWR;
+
+	fd_install(fd, filp);
+
+	return fd;
+}
+
+EXPORT_SYMBOL(pfs_open);
+
+static int pfs_get_sb(struct file_system_type *fs_type, int flags,
+		      const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "pollfs", NULL, POLLFS_MAGIC, mnt);
+}
+
+static struct file_system_type pollfs_type = {
+	.name = "pollfs",
+	.get_sb = pfs_get_sb,
+	.kill_sb = kill_anon_super
+};
+
+static int __init pollfs_init(void)
+{
+	int ret;
+
+	ret = register_filesystem(&pollfs_type);
+	if (ret)
+		return ret;
+
+	pfs_mnt = kern_mount(&pollfs_type);
+	if (IS_ERR(pfs_mnt)) {
+		ret = PTR_ERR(pfs_mnt);
+		unregister_filesystem(&pollfs_type);
+	}
+
+	return ret;
+}
+
+__initcall(pollfs_init);
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -463,6 +463,12 @@ config EPOLL
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.
 
+config POLLFS
+	bool "Enable pollfs support" if EMBEDDED
+	default y
+	help
+	 Pollfs support
+
 config SHMEM
 	bool "Use full shmem filesystem" if EMBEDDED
 	default y
Index: linux-2.6/fs/Makefile
===================================================================
--- linux-2.6.orig/fs/Makefile
+++ linux-2.6/fs/Makefile
@@ -114,3 +114,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_POLLFS)		+= pollfs/
Index: linux-2.6/fs/pollfs/Makefile
===================================================================
--- /dev/null
+++ linux-2.6/fs/pollfs/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_POLLFS) += pollfs.o
+pollfs-y := file.o

--
