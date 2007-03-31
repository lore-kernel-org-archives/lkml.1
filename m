Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXCaUJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXCaUJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXCaUJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:09:33 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48172 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXCaUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:09:31 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
Date: Sat, 31 Mar 2007 13:09:29 -0700
Subject: [patch 1/13] signal/timer/event fds v9 - anonymous inode source ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.16816.1175371769.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add an anonymous inode source, to be used for files that need 
and inode only in order to create a file*. We do not care of having an 
inode for each file, and we do not even care of having different names in 
the associated dentries (dentry names will be same for classes of file*).
This allow code reuse, and will be used by epoll, signalfd and timerfd 
(and whatever else there'll be).
Andrew, those two patches should be removed from you -mm and replaced with
this one:

add-an-anonymous-inode-source-tidy.patch
add-an-anonymous-inode-source.patch



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



Index: linux-2.6.21-rc5.fds/fs/anon_inodes.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc5.fds/fs/anon_inodes.c	2007-03-30 18:22:49.000000000 -0700
@@ -0,0 +1,198 @@
+/*
+ *  fs/anon_inodes.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ *  Thanks to Arnd Bergmann for code review and suggestions.
+ *  More changes for Thomas Gleixner suggestions.
+ *
+ */
+
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/magic.h>
+#include <linux/anon_inodes.h>
+
+#include <asm/uaccess.h>
+
+
+static struct vfsmount *aino_mnt __read_mostly;
+static struct inode *aino_inode;
+static const struct file_operations aino_fops;
+
+
+static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
+			 const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "aino:", NULL, AINOFS_MAGIC, mnt);
+}
+
+static int ainofs_delete_dentry(struct dentry *dentry)
+{
+	/*
+	 * We faked vfs to believe the dentry was hashed when we created it.
+	 * Now we restore the flag so that dput() will work correctly.
+	 */
+	dentry->d_flags |= DCACHE_UNHASHED;
+	return 1;
+}
+
+
+static struct file_system_type aino_fs_type = {
+	.name		= "ainofs",
+	.get_sb		= ainofs_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+static struct dentry_operations ainofs_dentry_operations = {
+	.d_delete	= ainofs_delete_dentry,
+};
+
+
+/**
+ * aino_getfd - creates a new file instance by hooking it up to and anonymous
+ *              inode, and a dentry that describe the "class" of the file
+ * @pfd:     [out]   pointer to the file descriptor
+ * @dpinode: [out]   pointer to the inode
+ * @pfile:   [out]   pointer to the file struct
+ * @name:    [in]    name of the "class" of the new file
+ * @fops     [in]    file operations for the new file
+ * @priv     [in]    private data for the new file (will be file's private_data)
+ *
+ * Creates a new file by hooking it on a single inode. This is useful for files
+ * that do not need to have a full-fledged inode in order to operate correctly.
+ * All the files created with aino_getfd() will share a single inode, by hence
+ * saving memory and avoiding code duplication for the file/inode/dentry setup.
+ */
+int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
+	       const char *name, const struct file_operations *fops, void *priv)
+{
+	struct qstr this;
+	struct dentry *dentry;
+	struct inode *inode;
+	struct file *file;
+	int error, fd;
+
+	if (IS_ERR(aino_inode))
+		return -ENODEV;
+	file = get_empty_filp();
+	if (!file)
+		return -ENFILE;
+
+	inode = igrab(aino_inode);
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
+		goto err_put_filp;
+	}
+
+	error = get_unused_fd();
+	if (error < 0)
+		goto err_iput;
+	fd = error;
+
+	/*
+	 * Link the inode to a directory entry by creating a unique name
+	 * using the inode sequence number.
+	 */
+	error = -ENOMEM;
+	this.name = name;
+	this.len = strlen(name);
+	this.hash = 0;
+	dentry = d_alloc(aino_mnt->mnt_sb->s_root, &this);
+	if (!dentry)
+		goto err_put_unused_fd;
+	dentry->d_op = &ainofs_dentry_operations;
+	/* Do not publish this dentry inside the global dentry hash table */
+	dentry->d_flags &= ~DCACHE_UNHASHED;
+	d_instantiate(dentry, inode);
+
+	file->f_path.mnt = mntget(aino_mnt);
+	file->f_path.dentry = dentry;
+	file->f_mapping = inode->i_mapping;
+
+	file->f_pos = 0;
+	file->f_flags = O_RDWR;
+	file->f_op = fops;
+	file->f_mode = FMODE_READ | FMODE_WRITE;
+	file->f_version = 0;
+	file->private_data = priv;
+
+	fd_install(fd, file);
+
+	*pfd = fd;
+	*pinode = inode;
+	*pfile = file;
+	return 0;
+
+err_put_unused_fd:
+	put_unused_fd(fd);
+err_iput:
+	iput(inode);
+err_put_filp:
+	put_filp(file);
+	return error;
+}
+
+/*
+ * A single inode exist for all aino files. Contrary to pipes,
+ * aino inodes has no per-instance data associated, so we can avoid
+ * the allocation of multiple of them.
+ */
+static struct inode *aino_mkinode(void)
+{
+	struct inode *inode = new_inode(aino_mnt->mnt_sb);
+
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	inode->i_fop = &aino_fops;
+
+	/*
+	 * Mark the inode dirty from the very beginning,
+	 * that way it will never be moved to the dirty
+	 * list because mark_inode_dirty() will think
+	 * that it already _is_ on the dirty list.
+	 */
+	inode->i_state = I_DIRTY;
+	inode->i_mode = S_IRUSR | S_IWUSR;
+	inode->i_uid = current->fsuid;
+	inode->i_gid = current->fsgid;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	return inode;
+}
+
+static int __init aino_init(void)
+{
+	int error;
+
+	error = register_filesystem(&aino_fs_type);
+	if (error)
+		goto err_exit;
+	aino_mnt = kern_mount(&aino_fs_type);
+	if (IS_ERR(aino_mnt)) {
+		error = PTR_ERR(aino_mnt);
+		goto err_unregister_filesystem;
+	}
+	aino_inode = aino_mkinode();
+	if (IS_ERR(aino_inode)) {
+		error = PTR_ERR(aino_inode);
+		goto err_mntput;
+	}
+
+	return 0;
+
+err_mntput:
+	mntput(aino_mnt);
+err_unregister_filesystem:
+	unregister_filesystem(&aino_fs_type);
+err_exit:
+	panic(KERN_ERR "aino_init() failed (%d)\n", error);
+}
+
+fs_initcall(aino_init);
+
Index: linux-2.6.21-rc5.fds/include/linux/anon_inodes.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc5.fds/include/linux/anon_inodes.h	2007-03-30 15:31:10.000000000 -0700
@@ -0,0 +1,15 @@
+/*
+ *  include/linux/anon_inodes.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_ANON_INODES_H
+#define _LINUX_ANON_INODES_H
+
+int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
+	       const char *name, const struct file_operations *fops, void *priv);
+
+#endif /* _LINUX_ANON_INODES_H */
+
Index: linux-2.6.21-rc5.fds/fs/Makefile
===================================================================
--- linux-2.6.21-rc5.fds.orig/fs/Makefile	2007-03-26 13:11:52.000000000 -0700
+++ linux-2.6.21-rc5.fds/fs/Makefile	2007-03-31 12:28:39.000000000 -0700
@@ -22,6 +22,7 @@
 obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
+obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
Index: linux-2.6.21-rc5.fds/include/linux/magic.h
===================================================================
--- linux-2.6.21-rc5.fds.orig/include/linux/magic.h	2007-03-26 13:11:53.000000000 -0700
+++ linux-2.6.21-rc5.fds/include/linux/magic.h	2007-03-26 13:21:40.000000000 -0700
@@ -14,6 +14,7 @@
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
 #define KVMFS_SUPER_MAGIC	0x19700426
+#define AINOFS_MAGIC		0x09041934
 
 #define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix fs, 30 char names */
Index: linux-2.6.21-rc5.fds/init/Kconfig
===================================================================
--- linux-2.6.21-rc5.fds.orig/init/Kconfig	2007-03-30 19:24:08.000000000 -0700
+++ linux-2.6.21-rc5.fds/init/Kconfig	2007-03-31 12:29:21.000000000 -0700
@@ -456,9 +456,19 @@
 	  support for "fast userspace mutexes".  The resulting kernel may not
 	  run glibc-based applications correctly.
 
+config ANON_INODES
+	bool "Enable anynimous inode source" if EMBEDDED
+	default y
+	help
+	  Anonymous inode source for pseudo-files like epoll, signalfd,
+	  timerfd and eventfd.
+
+	  If unsure, say Y.
+
 config EPOLL
 	bool "Enable eventpoll support" if EMBEDDED
 	default y
+	depends on ANON_INODES
 	help
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.

