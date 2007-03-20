Return-Path: <linux-kernel-owner+w=401wt.eu-S965583AbXCTSiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583AbXCTSiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965555AbXCTSiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:38:00 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51420 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbXCTSh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:37:57 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
Date: Tue, 20 Mar 2007 11:37:14 -0700
Subject: [patch 1/13] signal/timer/event fds v8 - anonymous inode source ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.28743.1174415834.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add an anonymous inode source, to be used for files that need 
and inode only in order to create a file*. We do not care of having an 
inode for each file, and we do not even care of having different names in 
the associated dentries (dentry names will be same for classes of file*).
This allow code reuse, and will be used by epoll, signalfd and timerfd 
(and whatever else there'll be).



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



Index: linux-2.6.21-rc3.quilt/fs/anon_inodes.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc3.quilt/fs/anon_inodes.c	2007-03-19 19:01:27.000000000 -0700
@@ -0,0 +1,204 @@
+/*
+ *  fs/anon_inodes.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ *  Thanks to Arnd Bergmann for code review and suggestions.
+ *  More changes for Thomas Gleixner suggestions.
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
+
+static int ainofs_delete_dentry(struct dentry *dentry);
+static struct inode *aino_mkinode(void);
+static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
+			 const char *dev_name, void *data, struct vfsmount *mnt);
+
+
+
+static struct vfsmount *aino_mnt __read_mostly;
+static struct inode *aino_inode;
+static const struct file_operations aino_fops = { };
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
+	       char const *name, const struct file_operations *fops, void *priv)
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
+/*
+ * A single inode exist for all aino files. On the contrary of pipes,
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
+static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
+			 const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "aino:", NULL, AINOFS_MAGIC, mnt);
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
+	printk(KERN_ERR "aino_init() failed (%d)\n", error);
+	return error;
+}
+
+fs_initcall(aino_init);
+
Index: linux-2.6.21-rc3.quilt/include/linux/anon_inodes.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc3.quilt/include/linux/anon_inodes.h	2007-03-15 15:32:33.000000000 -0700
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
+	       char const *name, const struct file_operations *fops, void *priv);
+
+#endif /* _LINUX_ANON_INODES_H */
+
Index: linux-2.6.21-rc3.quilt/fs/Makefile
===================================================================
--- linux-2.6.21-rc3.quilt.orig/fs/Makefile	2007-03-15 15:19:22.000000000 -0700
+++ linux-2.6.21-rc3.quilt/fs/Makefile	2007-03-19 19:01:01.000000000 -0700
@@ -11,7 +11,7 @@
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o
+		stack.o anon_inodes.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
Index: linux-2.6.21-rc3.quilt/include/linux/magic.h
===================================================================
--- linux-2.6.21-rc3.quilt.orig/include/linux/magic.h	2007-03-15 15:19:22.000000000 -0700
+++ linux-2.6.21-rc3.quilt/include/linux/magic.h	2007-03-15 15:33:16.000000000 -0700
@@ -14,6 +14,7 @@
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
 #define KVMFS_SUPER_MAGIC	0x19700426
+#define AINOFS_MAGIC		0x09041934
 
 #define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix fs, 30 char names */

