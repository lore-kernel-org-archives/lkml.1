Return-Path: <linux-kernel-owner+w=401wt.eu-S965757AbXCHBVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965757AbXCHBVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965758AbXCHBVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:21:32 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42804 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965757AbXCHBVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:21:31 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Mar 2007 17:21:19 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 1/5] signalfd v2 - anonymous inode source ...
Message-ID: <Pine.LNX.4.64.0703071718030.3672@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add an anonymous inode source, to be used for files that need 
and inode only in order to create a file*. We do not care of having an 
inode for each file, and we do not even care of having different names in 
the associated dentries (dentry names will be same for classes of file*).
This allow code reuse, and will be used by epoll, signalfd and timerfd 
(and whatever else there'll be).

(Andrew already has this in -mm)


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



Index: linux-2.6.20.ep2/fs/anon_inodes.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20.ep2/fs/anon_inodes.c	2007-03-07 15:58:01.000000000 -0800
@@ -0,0 +1,203 @@
+/*
+ *  fs/anon_inodes.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
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
+
+static int ainofs_delete_dentry(struct dentry *dentry);
+static struct inode *aino_getinode(void);
+static struct inode *aino_mkinode(void);
+static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
+			 const char *dev_name, void *data, struct vfsmount *mnt);
+
+
+
+static struct vfsmount *aino_mnt __read_mostly;
+static struct inode *aino_inode;
+static struct file_operations aino_fops = { };
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
+int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
+	       char const *name, const struct file_operations *fops, void *priv)
+{
+	struct qstr this;
+	struct dentry *dentry;
+	struct inode *inode;
+	struct file *file;
+	int error, fd;
+
+	error = -ENFILE;
+	file = get_empty_filp();
+	if (!file)
+		goto eexit_1;
+
+	inode = aino_getinode();
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
+		goto eexit_2;
+	}
+
+	error = get_unused_fd();
+	if (error < 0)
+		goto eexit_3;
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
+		goto eexit_4;
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
+	file->f_flags = O_RDONLY;
+	file->f_op = fops;
+	file->f_mode = FMODE_READ;
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
+eexit_4:
+	put_unused_fd(fd);
+eexit_3:
+	iput(inode);
+eexit_2:
+	put_filp(file);
+eexit_1:
+	return error;
+}
+
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
+static struct inode *aino_getinode(void)
+{
+	return igrab(aino_inode);
+}
+
+
+/*
+ * A single inode exist for all aino files. On the contrary of pipes,
+ * aino inodes has no per-instance data associated, so we can avoid
+ * the allocation of multiple of them.
+ */
+static struct inode *aino_mkinode(void)
+{
+	int error = -ENOMEM;
+	struct inode *inode = new_inode(aino_mnt->mnt_sb);
+
+	if (!inode)
+		goto eexit_1;
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
+
+eexit_1:
+	return ERR_PTR(error);
+}
+
+
+static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
+			 const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "aino:", NULL, AINOFS_MAGIC, mnt);
+}
+
+
+static int __init aino_init(void)
+{
+
+	if (register_filesystem(&aino_fs_type))
+		goto epanic;
+
+	aino_mnt = kern_mount(&aino_fs_type);
+	if (IS_ERR(aino_mnt))
+		goto epanic;
+
+	aino_inode = aino_mkinode();
+	if (IS_ERR(aino_inode))
+		goto epanic;
+
+	return 0;
+
+epanic:
+	panic("aino_init() failed\n");
+}
+
+
+static void __exit aino_exit(void)
+{
+	iput(aino_inode);
+	unregister_filesystem(&aino_fs_type);
+	mntput(aino_mnt);
+}
+
+module_init(aino_init);
+module_exit(aino_exit);
+
+MODULE_LICENSE("GPL");
Index: linux-2.6.20.ep2/include/linux/anon_inodes.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20.ep2/include/linux/anon_inodes.h	2007-03-06 11:12:23.000000000 -0800
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
Index: linux-2.6.20.ep2/fs/Makefile
===================================================================
--- linux-2.6.20.ep2.orig/fs/Makefile	2007-03-06 11:09:00.000000000 -0800
+++ linux-2.6.20.ep2/fs/Makefile	2007-03-07 15:55:43.000000000 -0800
@@ -11,7 +11,7 @@
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o
+		stack.o anon_inodes.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
Index: linux-2.6.20.ep2/include/linux/magic.h
===================================================================
--- linux-2.6.20.ep2.orig/include/linux/magic.h	2007-03-07 15:57:01.000000000 -0800
+++ linux-2.6.20.ep2/include/linux/magic.h	2007-03-07 15:57:27.000000000 -0800
@@ -13,6 +13,7 @@
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
+#define AINOFS_MAGIC		0x09041934
 
 #define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix fs, 30 char names */
