Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYBZD0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYBZD0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYBZD0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:26:36 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35507 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737AbYBZD0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:26:33 -0500
X-Sasl-enc: RuO3UIsOiWsGdYXriVv7yqB47H8rVorxfbMfeCtsLrST 1203996390
Date: Tue, 26 Feb 2008 12:23:55 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
In-Reply-To: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
Message-ID: <Pine.LNX.4.64.0802261218230.8490@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Patch to add miscellaneous device to autofs4 module for
ioctls.

Signed-off-by: Ian Kent < raven@themaw.net>

Ian

---
diff -up linux-2.6.25-rc2-mm1/fs/autofs4/expire.c.device-node-ioctl linux-2.6.25-rc2-mm1/fs/autofs4/expire.c
--- linux-2.6.25-rc2-mm1/fs/autofs4/expire.c.device-node-ioctl	2008-01-25 07:58:37.000000000 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/expire.c	2008-02-22 11:51:41.000000000 +0900
@@ -244,10 +244,10 @@ cont:
 }
 
 /* Check if we can expire a direct mount (possibly a tree) */
-static struct dentry *autofs4_expire_direct(struct super_block *sb,
-					    struct vfsmount *mnt,
-					    struct autofs_sb_info *sbi,
-					    int how)
+struct dentry *autofs4_expire_direct(struct super_block *sb,
+				     struct vfsmount *mnt,
+				     struct autofs_sb_info *sbi,
+				     int how)
 {
 	unsigned long timeout;
 	struct dentry *root = dget(sb->s_root);
@@ -281,10 +281,10 @@ static struct dentry *autofs4_expire_dir
  *  - it is unused by any user process
  *  - it has been unused for exp_timeout time
  */
-static struct dentry *autofs4_expire_indirect(struct super_block *sb,
-					      struct vfsmount *mnt,
-					      struct autofs_sb_info *sbi,
-					      int how)
+struct dentry *autofs4_expire_indirect(struct super_block *sb,
+				       struct vfsmount *mnt,
+				       struct autofs_sb_info *sbi,
+				       int how)
 {
 	unsigned long timeout;
 	struct dentry *root = sb->s_root;
diff -up linux-2.6.25-rc2-mm1/fs/autofs4/init.c.device-node-ioctl linux-2.6.25-rc2-mm1/fs/autofs4/init.c
--- linux-2.6.25-rc2-mm1/fs/autofs4/init.c.device-node-ioctl	2008-01-25 07:58:37.000000000 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/init.c	2008-02-22 11:51:41.000000000 +0900
@@ -29,11 +29,20 @@ static struct file_system_type autofs_fs
 
 static int __init init_autofs4_fs(void)
 {
-	return register_filesystem(&autofs_fs_type);
+	int err;
+
+	err = register_filesystem(&autofs_fs_type);
+	if (err)
+		return err;
+
+	err = autofs_dev_ioctl_init();
+
+	return err;
 }
 
 static void __exit exit_autofs4_fs(void)
 {
+	autofs_dev_ioctl_exit();
 	unregister_filesystem(&autofs_fs_type);
 }
 
diff -up linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h.device-node-ioctl linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h
--- linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h.device-node-ioctl	2008-02-22 11:51:41.000000000 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h	2008-02-22 11:51:41.000000000 +0900
@@ -14,6 +14,7 @@
 /* Internal header file for autofs */
 
 #include <linux/auto_fs4.h>
+#include <linux/auto_dev-ioctl.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
 
@@ -40,6 +41,16 @@
 #define DPRINTK(fmt,args...) do {} while(0)
 #endif
 
+#define WARN(fmt,args...) \
+do {			  \
+	printk("KERN_WARNING pid %d: %s: " fmt "\n" , current->pid , __FUNCTION__ , ##args); \
+} while(0)
+
+#define ERROR(fmt,args...) \
+do {			  \
+	printk("KERN_ERR pid %d: %s: " fmt "\n" , current->pid , __FUNCTION__ , ##args); \
+} while(0)
+
 /* Unified info structure.  This is pointed to by both the dentry and
    inode structures.  Each file in the filesystem has an instance of this
    structure.  It holds a reference to the dentry, so dentries are never
@@ -172,6 +183,17 @@ int autofs4_expire_run(struct super_bloc
 			struct autofs_packet_expire __user *);
 int autofs4_expire_multi(struct super_block *, struct vfsmount *,
 			struct autofs_sb_info *, int __user *);
+struct dentry *autofs4_expire_direct(struct super_block *sb,
+				     struct vfsmount *mnt,
+				     struct autofs_sb_info *sbi, int how);
+struct dentry *autofs4_expire_indirect(struct super_block *sb,
+				       struct vfsmount *mnt,
+				       struct autofs_sb_info *sbi, int how);
+
+/* Device node initialization */
+
+int autofs_dev_ioctl_init(void);
+void autofs_dev_ioctl_exit(void);
 
 /* Operations structures */
 
diff -up linux-2.6.25-rc2-mm1/fs/autofs4/Makefile.device-node-ioctl linux-2.6.25-rc2-mm1/fs/autofs4/Makefile
--- linux-2.6.25-rc2-mm1/fs/autofs4/Makefile.device-node-ioctl	2008-01-25 07:58:37.000000000 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/Makefile	2008-02-22 11:51:41.000000000 +0900
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_AUTOFS4_FS) += autofs4.o
 
-autofs4-objs := init.o inode.o root.o symlink.o waitq.o expire.o
+autofs4-objs := init.o inode.o root.o symlink.o waitq.o expire.o dev-ioctl.o
diff -up /dev/null linux-2.6.25-rc2-mm1/fs/autofs4/dev-ioctl.c
--- /dev/null	2008-02-22 18:55:57.149000956 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/dev-ioctl.c	2008-02-22 11:53:33.000000000 +0900
@@ -0,0 +1,788 @@
+/*
+ * linux/fs/autofs4/dev-ioctl.c
+ *
+ * Copyright 2008 Red Hat, Inc. All rights reserved.
+ * Copyright 2008 Ian Kent <raven@themaw.net>
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ */
+
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/miscdevice.h>
+#include <linux/init.h>
+#include <linux/wait.h>
+#include <linux/namei.h>
+#include <linux/fcntl.h>
+#include <linux/file.h>
+#include <linux/sched.h>
+#include <linux/compat.h>
+#include <linux/syscalls.h>
+#include <linux/smp_lock.h>
+#include <linux/magic.h>
+#include <linux/dcache.h>
+#include <asm/uaccess.h>
+
+#include "autofs_i.h"
+
+/*
+ * This module implements an interface for routing autofs ioctl control
+ * commands via a miscellaneous device file.
+ *
+ * The alternate interface is needed because we need to be able open
+ * an ioctl file descriptor on an autofs mount that may be covered by
+ * another mount. This situation arises when starting automount(8)
+ * or other user space daemon which uses direct mounts or offset
+ * mounts (used for autofs lazy mount/umount of nested mount trees),
+ * which have been left busy at at service shutdown.
+ */
+
+#define AUTOFS_DEVICE_NAME	"autofs"
+
+#define AUTOFS_DEV_IOCTL_IOC_FIRST AUTOFS_DEV_IOCTL_VERSION
+#define AUTOFS_DEV_IOCTL_IOC_COUNT AUTOFS_IOC_COUNT - 11
+
+#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
+
+typedef int (*ioctl_fn)(struct file *, struct autofs_sb_info *, struct autofs_dev_ioctl *);
+
+static int check_name(const char *name)
+{
+	if (!strchr(name, '/'))
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * Check a string doesn't overrun the chunk of
+ * memory we copied from user land.
+ */
+static int invalid_str(char *str, void *end)
+{
+	while ((void *) str <= end)
+		if (!*str++)
+			return 0;
+	return -EINVAL;
+}
+
+/*
+ * Check that the user compiled against correct version of autofs
+ * misc device code.
+ *
+ * As well as checking the version compatibility this always copies
+ * the kernel interface version out.
+ */
+static int check_dev_ioctl_version(int cmd, struct autofs_dev_ioctl *param)
+{
+	int err = 0;
+
+	if ((AUTOFS_DEV_IOCTL_VERSION_MAJOR != param->ver_major) ||
+	    (AUTOFS_DEV_IOCTL_VERSION_MINOR < param->ver_minor)) {
+		WARN("ioctl control interface version mismatch: "
+		     "kernel(%u.%u), user(%u.%u), cmd(%d)",
+		     AUTOFS_DEV_IOCTL_VERSION_MAJOR,
+		     AUTOFS_DEV_IOCTL_VERSION_MINOR,
+		     param->ver_major, param->ver_minor, cmd);
+		err = -EINVAL;
+	}
+
+	/* Fill in the kernel version. */
+	param->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
+	param->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
+
+	return err;
+}
+
+/*
+ * Copy parameter control struct, including a possible path allocated
+ * at the end of the struct.
+ */
+static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
+{
+	struct autofs_dev_ioctl tmp, *ads;
+
+	if (copy_from_user(&tmp, in, sizeof(tmp)))
+		return ERR_PTR(-EFAULT);
+
+	if (tmp.size < sizeof(tmp))
+		return ERR_PTR(-EINVAL);
+
+	ads = kmalloc(tmp.size, GFP_KERNEL);
+	if (!ads)
+		return ERR_PTR(-ENOMEM);
+
+	if (copy_from_user(ads, in, tmp.size)) {
+		vfree(ads);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return ads;
+}
+
+static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
+{
+	kfree(param);
+	return;
+}
+
+/*
+ * Check sanity of parameter control fields and if a path is present
+ * check that it has a "/" and is terminated.
+ */
+static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
+{
+	int err = -EINVAL;
+
+	if (check_dev_ioctl_version(cmd, param)) {
+		WARN("invalid device control module version "
+		     "supplied for cmd(0x%08x)", cmd);
+		goto out;
+	}
+
+	if (param->size > sizeof(*param)) {
+		err = check_name(param->path);
+		if (err) {
+			WARN("invalid path supplied for cmd(0x%08x)", cmd);
+			goto out;
+		}
+
+		err = invalid_str(param->path,
+				 (void *) ((size_t) param + param->size));
+		if (err) {
+			WARN("invalid path supplied for cmd(0x%08x)", cmd);
+			goto out;
+		}
+	}
+
+	err = 0;
+out:
+	return err;
+}
+
+/*
+ * Get the autofs super block info struct from the file opened on
+ * the autofs mount point.
+ */
+static struct autofs_sb_info *autofs_dev_ioctl_sbi(struct file *f)
+{
+	struct autofs_sb_info *sbi = NULL;
+	struct inode *inode;
+
+	if (f) {
+		inode = f->f_path.dentry->d_inode;
+		sbi = autofs4_sbi(inode->i_sb);
+	}
+
+	return sbi;
+}
+
+/* Return autofs module protocol version */
+static inline int autofs_dev_ioctl_protover(struct file *fp,
+					    struct autofs_sb_info *sbi,
+					    struct autofs_dev_ioctl *param)
+{
+	param->arg1 = sbi->version;
+	return 0;
+}
+
+/* Return autofs module protocol sub version */
+static inline int autofs_dev_ioctl_protosubver(struct file *fp,
+					       struct autofs_sb_info *sbi,
+					       struct autofs_dev_ioctl *param)
+{
+	param->arg1 = sbi->sub_version;
+	return 0;
+}
+
+/*
+ * Walk down the mount stack looking for an autofs mount that
+ * has the requested device number (aka. new_encode_dev(sb->s_dev).
+ */
+static int autofs_dev_ioctl_find_super(struct nameidata *nd, dev_t devno)
+{
+	struct dentry *dentry;
+	struct inode *inode;
+	struct super_block *sb;
+	dev_t s_dev;
+	unsigned int err;
+
+	err = -ENOENT;
+
+	/* Lookup the dentry name at the base of our mount point */
+	dentry = d_lookup(nd->path.dentry, &nd->last);
+	if (!dentry)
+		goto out;
+
+	dput(nd->path.dentry);
+	nd->path.dentry = dentry;
+
+	/* And follow the mount stack looking for our autofs mount */
+	while (1) {
+		inode = nd->path.dentry->d_inode;
+		if (!inode)
+			continue;
+
+		sb = inode->i_sb;
+		s_dev = new_encode_dev(sb->s_dev);
+		if (devno == s_dev) {
+			if (sb->s_magic == AUTOFS_SUPER_MAGIC) {
+				err = 0;
+				break;
+			}
+		}
+
+		if (!follow_down(&nd->path.mnt, &nd->path.dentry))
+			goto out;
+	}
+
+out:
+	return err;
+}
+
+/*
+ * Install the file opened for autofs mount point control functions
+ * and set close on exec.
+ */
+static void autofs_dev_ioctl_fd_install(unsigned int fd, struct file *file)
+{
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+	BUG_ON(fdt->fd[fd] != NULL);
+	rcu_assign_pointer(fdt->fd[fd], file);
+	FD_SET(fd, fdt->close_on_exec);
+	spin_unlock(&files->file_lock);
+}
+
+/*
+ * Open a file descriptor on the autofs mount point corresponding
+ * to the given path and device number (aka. new_encode_dev(sb->s_dev)).
+ */
+static int autofs_dev_ioctl_open_mountpoint(const char *path, dev_t devid)
+{
+	struct file *filp;
+	struct nameidata nd;
+	int err, fd;
+
+	fd = get_unused_fd();
+	if (fd >= 0) {
+		/* Get nameidata of the parent directory */
+		err = path_lookup(path, LOOKUP_PARENT, &nd);
+		if (err)
+			goto out;
+
+		/*
+		 * Search down, within the parent, looking for an
+		 * autofs super block that has the device number
+		 * corresponding to the autofs fs we want to open.
+		 */
+		err = autofs_dev_ioctl_find_super(&nd, devid);
+		if (err)
+			goto out_put;
+	
+		filp = dentry_open(nd.path.dentry, nd.path.mnt, O_RDONLY);
+		if (IS_ERR(filp)) {
+			err = PTR_ERR(filp);
+			goto out_put;
+		}
+
+		autofs_dev_ioctl_fd_install(fd, filp);
+	}
+
+	return fd;
+
+out_put:
+	path_put(&nd.path);
+out:
+	put_unused_fd(fd);
+	return err;
+}
+
+/* Open a file descriptor on an autofs mount point */
+static int autofs_dev_ioctl_openmount(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	const char *path;
+	dev_t devid;
+	int err, fd;
+
+	/* param->path has already been checked */
+	if (!param->arg1)
+		return -EINVAL;
+
+	err = 0;
+
+	devid = param->arg1;
+	path = param->path;
+
+	fd = autofs_dev_ioctl_open_mountpoint(path, devid);
+	if (fd < 0) {
+		err = fd;
+		goto out;
+	}
+
+	param->ioctlfd = fd;
+out:
+	return err;
+}
+
+/* Close file descriptor allocated above (user can also use close(2)). */
+static inline int autofs_dev_ioctl_closemount(struct file *fp,
+					      struct autofs_sb_info *sbi,
+					      struct autofs_dev_ioctl *param)
+{
+	return sys_close(param->ioctlfd);
+}
+
+/*
+ * Send "ready" status for an existing wait (either a mount or an expire
+ * request).
+ */
+static inline int autofs_dev_ioctl_ready(struct file *fp,
+					 struct autofs_sb_info *sbi,
+					 struct autofs_dev_ioctl *param)
+{
+	autofs_wqt_t token;
+
+	token = (autofs_wqt_t) param->arg1;
+	return autofs4_wait_release(sbi, token, 0);
+}
+
+/*
+ * Send "fail" status for an existing wait (either a mount or an expire
+ * request).
+ */
+static inline int autofs_dev_ioctl_fail(struct file *fp,
+					struct autofs_sb_info *sbi,
+					struct autofs_dev_ioctl *param)
+{
+	autofs_wqt_t token;
+	int status;
+
+	token = (autofs_wqt_t) param->arg1;
+	status = param->arg2 ? param->arg2 : -ENOENT;
+	return autofs4_wait_release(sbi, token, status);
+}
+
+/*
+ * Set the pipe fd for kernel communication to the daemon.
+ *
+ * Normally this is set at mount using an option but if we
+ * are reconnecting to a busy mount then we need to use this
+ * to tell the autofs mount about the new kernel pipe fd. In
+ * order to protect mounts against incorrectly setting the
+ * pipefd we also require that the autofs mount be catatonic.
+ *
+ * This also sets the process group id used to identify the
+ * controlling process (eg. the owning automount(8) daemon).
+ */
+static int autofs_dev_ioctl_setpipefd(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	int pipefd;
+	int err = 0;
+
+	if (param->arg1 == -1)
+		return -EINVAL;
+
+	pipefd = param->arg1;
+
+	if (!sbi->catatonic)
+		return -EBUSY;
+	else {
+		struct file *pipe = fget(pipefd);
+		if (!pipe->f_op || !pipe->f_op->write) {
+			err = -EPIPE;
+			fput(pipe);
+			goto out;
+		}
+		sbi->oz_pgrp = task_pgrp_nr(current);
+		sbi->pipefd = pipefd;
+		sbi->pipe = pipe;
+		sbi->catatonic = 0;
+	}
+out:
+	return err;
+}
+
+/*
+ * Make the autofs mount point catatonic, no longer responsive to
+ * mount requests. Also closes the kernel pipe file descriptor.
+ */
+static inline int autofs_dev_ioctl_catatonic(struct file *fp,
+					     struct autofs_sb_info *sbi,
+					     struct autofs_dev_ioctl *param)
+{
+	if (!sbi->catatonic)
+		autofs4_catatonic_mode(sbi);
+	return 0;
+}
+
+/* Set the autofs mount timeout */
+static inline int autofs_dev_ioctl_timeout(struct file *fp,
+					   struct autofs_sb_info *sbi,
+					   struct autofs_dev_ioctl *param)
+{
+	unsigned long timeout;
+
+	timeout = param->arg1;
+	param->arg1 = sbi->exp_timeout / HZ;
+	sbi->exp_timeout = timeout * HZ;
+	return 0;
+}
+
+/*
+ * Return the uid and gid of the last request for the mount
+ *
+ * When reconstructing an autofs mount tree with active mounts
+ * we need to re-connect to mounts that may have used the original
+ * process uid and gid (or string variations of them) for mount
+ * lookups within the map entry.
+ */
+static inline int autofs_dev_ioctl_requestor(struct file *fp,
+					     struct autofs_sb_info *sbi,
+					     struct autofs_dev_ioctl *param)
+{
+	struct autofs_info *ino;
+	struct nameidata nd;
+	const char *path;
+	dev_t devid;
+	int err = -ENOENT;
+
+	if (param->size <= sizeof(*param)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	path = param->path;
+	devid = sbi->sb->s_dev;
+
+	param->arg1 = param->arg2 = -1;
+
+	/* Get nameidata of the parent directory */
+	err = path_lookup(path, LOOKUP_PARENT, &nd);
+	if (err)
+		goto out;
+
+	err = autofs_dev_ioctl_find_super(&nd, devid);
+	if (err)
+		goto out_release;
+	
+	ino = autofs4_dentry_ino(nd.path.dentry);
+	if (ino) {
+		err = 0;
+		param->arg1 = ino->uid;
+		param->arg2 = ino->gid;
+	}
+
+out_release:
+	path_put(&nd.path);
+out:
+	return err;
+}
+
+/*
+ * Call repeatedly until it returns -EAGAIN, meaning there's nothing
+ * more that can be done.
+ */
+static int autofs_dev_ioctl_expire(struct file *fp,
+				   struct autofs_sb_info *sbi,
+				   struct autofs_dev_ioctl *param)
+{
+	struct dentry *dentry;
+	struct vfsmount *mnt;
+	int err = -EAGAIN;
+	int when;
+
+	when = param->arg1;
+	mnt = fp->f_path.mnt;
+
+	if (sbi->type & AUTOFS_TYPE_DIRECT)
+		dentry = autofs4_expire_direct(sbi->sb, mnt, sbi, when);
+	else
+		dentry = autofs4_expire_indirect(sbi->sb, mnt, sbi, when);
+
+	if (dentry) {
+		struct autofs_info *ino = autofs4_dentry_ino(dentry);
+
+		/*
+		 * This is synchronous because it makes the daemon a
+		 * little easier
+		*/
+		ino->flags |= AUTOFS_INF_EXPIRING;
+		err = autofs4_wait(sbi, dentry, NFY_EXPIRE);
+		ino->flags &= ~AUTOFS_INF_EXPIRING;
+		dput(dentry);
+	}
+
+	return err;
+}
+
+/* Check if autofs mount point is in use */
+static inline int autofs_dev_ioctl_askumount(struct file *fp,
+					     struct autofs_sb_info *sbi,
+					     struct autofs_dev_ioctl *param)
+{
+	param->arg1 = 0;
+	if (may_umount(fp->f_path.mnt))
+		param->arg1 = 1;
+	return 0;
+}
+
+/*
+ * Check if the given path is a mountpoint.
+ *
+ * If we are supplied with the file descriptor of the autofs
+ * mount we're looking for a specific mount. In this case
+ * the path is considered a mountpoint if it is itself a
+ * mountpoint or contains a mount, such as a multi-mount
+ * without a root mount.
+ *
+ * If we aren't supplied with a file descriptor then we lookup
+ * the nameidata of the path and check if is a mounted autofs
+ * filesystem or a filesystem mounted within an autofs filesystem.
+ *
+ * In both cases we return an indication of whether the path
+ * is a mount point and the super magic of the covering mount.
+ */
+static inline int autofs_dev_ioctl_ismountpoint(struct file *fp,
+						struct autofs_sb_info *sbi,
+						struct autofs_dev_ioctl *param)
+{
+	struct nameidata nd;
+	const char *path;
+	int err = -ENOENT;
+
+	if (param->size <= sizeof(*param)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	path = param->path;
+
+	param->arg1 = param->arg2 = 0;
+
+	if (param->ioctlfd == -1) {
+		unsigned long magic;
+
+		err = path_lookup(path, LOOKUP_FOLLOW, &nd);
+		if (err)
+			goto out;
+
+		magic = nd.path.dentry->d_inode->i_sb->s_magic;
+
+		if (follow_up(&nd.path.mnt, &nd.path.dentry)) {
+			struct inode *inode = nd.path.dentry->d_inode;
+			if (magic == AUTOFS_SUPER_MAGIC ||
+			    inode->i_sb->s_magic == AUTOFS_SUPER_MAGIC) {
+				param->arg1 = 1;
+				param->arg2 = magic;
+			}
+		}
+	} else {
+		dev_t devid = sbi->sb->s_dev;
+
+		err = path_lookup(path, LOOKUP_PARENT, &nd);
+		if (err)
+			goto out;
+
+		err = autofs_dev_ioctl_find_super(&nd, devid);
+		if (err)
+			goto out_release;
+	
+		param->arg1 = have_submounts(nd.path.dentry);
+
+		if (d_mountpoint(nd.path.dentry)) {
+			if (follow_down(&nd.path.mnt, &nd.path.dentry)) {
+				struct inode *inode = nd.path.dentry->d_inode;
+				param->arg2 = inode->i_sb->s_magic;
+			}
+		}
+	}
+
+out_release:
+	path_put(&nd.path);
+out:
+	return err;
+}
+
+/*
+ * Our range of ioctl numbers isn't 0 based so we need to shift
+ * the array index by _IOC_NR(AUTOFS_CTL_IOC_FIRST) for the table
+ * lookup.
+ */
+#define cmd_idx(cmd)	(cmd - _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST))
+
+static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
+{
+	static struct {
+		int cmd;
+		ioctl_fn fn;
+	} _ioctls[] = {
+		{cmd_idx(AUTOFS_DEV_IOCTL_VERSION_CMD), NULL},
+		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOVER_CMD), autofs_dev_ioctl_protover},
+		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD), autofs_dev_ioctl_protosubver},
+		{cmd_idx(AUTOFS_DEV_IOCTL_OPENMOUNT_CMD), autofs_dev_ioctl_openmount},
+		{cmd_idx(AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD), autofs_dev_ioctl_closemount},
+		{cmd_idx(AUTOFS_DEV_IOCTL_READY_CMD), autofs_dev_ioctl_ready},
+		{cmd_idx(AUTOFS_DEV_IOCTL_FAIL_CMD), autofs_dev_ioctl_fail},
+		{cmd_idx(AUTOFS_DEV_IOCTL_SETPIPEFD_CMD), autofs_dev_ioctl_setpipefd},
+		{cmd_idx(AUTOFS_DEV_IOCTL_CATATONIC_CMD), autofs_dev_ioctl_catatonic},
+		{cmd_idx(AUTOFS_DEV_IOCTL_TIMEOUT_CMD), autofs_dev_ioctl_timeout},
+		{cmd_idx(AUTOFS_DEV_IOCTL_REQUESTOR_CMD), autofs_dev_ioctl_requestor},
+		{cmd_idx(AUTOFS_DEV_IOCTL_EXPIRE_CMD), autofs_dev_ioctl_expire},
+		{cmd_idx(AUTOFS_DEV_IOCTL_ASKUMOUNT_CMD), autofs_dev_ioctl_askumount},
+		{cmd_idx(AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD), autofs_dev_ioctl_ismountpoint}
+	};
+	int idx = cmd_idx(cmd);
+
+	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx].fn;
+}
+
+/* ioctl dispatcher */
+static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
+{
+	struct autofs_dev_ioctl *param;
+	struct file *fp;
+	struct autofs_sb_info *sbi;
+	unsigned int cmd;
+	ioctl_fn fn = NULL;
+	int err = 0;
+
+	/* only root can play with this */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	cmd = _IOC_NR(command);
+
+	if (_IOC_TYPE(command) != _IOC_TYPE(AUTOFS_DEV_IOCTL_IOC_FIRST) ||
+	    cmd - _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST) >= AUTOFS_DEV_IOCTL_IOC_COUNT) {
+		return -ENOTTY;
+	}
+
+	fn = lookup_dev_ioctl(cmd);
+	if (!fn) {
+		WARN("unknown command 0x%08x", command);
+		return -ENOTTY;
+	}
+
+	/*
+	 * Trying to avoid low memory issues when a device is
+	 * suspended.
+	 */
+	current->flags |= PF_MEMALLOC;
+
+	/* Copy the parameters into kernel space. */
+	param = copy_dev_ioctl(user);
+
+	current->flags &= ~PF_MEMALLOC;
+
+	if (IS_ERR(param))
+		return PTR_ERR(param);
+
+	err = validate_dev_ioctl(command, param);
+	if (err)
+		goto out;
+
+	/* The validate routine above always sets the version */
+	if (cmd == AUTOFS_DEV_IOCTL_VERSION_CMD)
+		goto done;
+
+	fp = NULL;
+	sbi = NULL;
+
+	/*
+	 * For obvious reasons the openmount can't have a file
+	 * descriptor yet. We don't take a reference to the
+	 * file during close to allow for immediate release.
+	 */
+	if (cmd != AUTOFS_DEV_IOCTL_OPENMOUNT_CMD &&
+	    cmd != AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD) {
+		fp = fget(param->ioctlfd);
+		if (!fp) {
+			if (cmd == AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD)
+				goto cont;
+			err = -EBADF;
+			goto out;
+		}
+
+		if (!fp->f_op) {
+			err = -ENOTTY;
+			fput(fp);
+			goto out;
+		}
+
+		sbi = autofs_dev_ioctl_sbi(fp);
+		if (!sbi) {
+			err = -EINVAL;
+			fput(fp);
+			goto out;
+		}
+	}
+cont:
+	err = fn(fp, sbi, param);
+
+	if (fp)
+		fput(fp);
+done:
+	if (!err && copy_to_user(user, param, AUTOFS_DEV_IOCTL_SIZE))
+		err = -EFAULT;
+out:
+	free_dev_ioctl(param);
+	return err;
+}
+
+static long autofs_dev_ioctl(struct file *file, uint command, ulong u)
+{
+	return (long) _autofs_dev_ioctl(command, (struct autofs_dev_ioctl __user *) u);
+}
+
+#ifdef CONFIG_COMPAT
+static long autofs_dev_ioctl_compat(struct file *file, uint command, ulong u)
+{
+	return (long) autofs_dev_ioctl(file, command, (ulong) compat_ptr(u));
+}
+#else
+#define autofs_dev_ioctl_compat NULL
+#endif
+
+static const struct file_operations _dev_ioctl_fops = {
+	.unlocked_ioctl	 = autofs_dev_ioctl,
+	.compat_ioctl = autofs_dev_ioctl_compat,
+	.owner	 = THIS_MODULE,
+};
+
+static struct miscdevice _autofs_dev_ioctl_misc = {
+	.minor 		= MISC_DYNAMIC_MINOR,
+	.name  		= AUTOFS_DEVICE_NAME,
+	.fops  		= &_dev_ioctl_fops
+};
+
+/* Register/deregister misc character device */
+int autofs_dev_ioctl_init(void)
+{
+	int r;
+
+	r = misc_register(&_autofs_dev_ioctl_misc);
+	if (r) {
+		ERROR("misc_register failed for control device");
+		return r;
+	}
+
+	return 0;
+}
+
+void autofs_dev_ioctl_exit(void)
+{
+	if (misc_deregister(&_autofs_dev_ioctl_misc) < 0)
+		ERROR("misc_deregister failed for control device");
+
+	return;
+}
+
diff -up linux-2.6.25-rc2-mm1/include/linux/auto_fs4.h.device-node-ioctl linux-2.6.25-rc2-mm1/include/linux/auto_fs4.h
--- linux-2.6.25-rc2-mm1/include/linux/auto_fs4.h.device-node-ioctl	2008-01-25 07:58:37.000000000 +0900
+++ linux-2.6.25-rc2-mm1/include/linux/auto_fs4.h	2008-02-22 11:51:41.000000000 +0900
@@ -23,7 +23,7 @@
 #define AUTOFS_MIN_PROTO_VERSION	3
 #define AUTOFS_MAX_PROTO_VERSION	5
 
-#define AUTOFS_PROTO_SUBVERSION		0
+#define AUTOFS_PROTO_SUBVERSION		1
 
 /* Mask for expire behaviour */
 #define AUTOFS_EXP_IMMEDIATE		1
diff -up /dev/null linux-2.6.25-rc2-mm1/include/linux/auto_dev-ioctl.h
--- /dev/null	2008-02-22 18:55:57.149000956 +0900
+++ linux-2.6.25-rc2-mm1/include/linux/auto_dev-ioctl.h	2008-02-22 11:51:41.000000000 +0900
@@ -0,0 +1,114 @@
+/*
+ * linux/include/linux/auto_dev-ioctl.h
+ *
+ * Copyright 2008 Red Hat, Inc. All rights reserved.
+ * Copyright 2008 Ian Kent <raven@themaw.net>
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ */
+
+#ifndef _LINUX_AUTO_DEV_IOCTL_H
+#define _LINUX_AUTO_DEV_IOCTL_H
+
+#include <linux/types.h>
+
+#define AUTOFS_DEV_IOCTL_VERSION_MAJOR	1
+#define AUTOFS_DEV_IOCTL_VERSION_MINOR	0
+
+#define AUTOFS_DEVID_LEN		16
+
+/*
+ * An ioctl interface for autofs mount point control.
+ */
+
+/*
+ * All the ioctls use this structure.
+ * When sending a path size must account for the total length
+ * of the chunk of memory otherwise is is the size of the
+ * structure.
+ */
+
+struct autofs_dev_ioctl {
+	__u32 ver_major;
+	__u32 ver_minor;
+	__u32 size;		/* total size of data passed in
+				 * including this struct */
+	__s32 ioctlfd;		/* automount command fd */
+
+	__u32 arg1;		/* Command parameters */
+	__u32 arg2;
+
+	char path[0];
+};
+
+static inline void init_autofs_dev_ioctl(struct autofs_dev_ioctl *in)
+{
+	in->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
+	in->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
+	in->size = sizeof(struct autofs_dev_ioctl);
+	in->ioctlfd = -1;
+	in->arg1 = 0;
+	in->arg2 = 0;
+	return;
+}
+
+/*
+ * If you change this make sure you make the corresponding change
+ * to autofs-dev-ioctl.c:lookup_ioctl()
+ */
+enum {
+	/* Get various version info */
+	AUTOFS_DEV_IOCTL_VERSION_CMD = 0x71,
+	AUTOFS_DEV_IOCTL_PROTOVER_CMD,
+	AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD,
+
+	/* Open mount ioctl fd */
+	AUTOFS_DEV_IOCTL_OPENMOUNT_CMD,
+
+	/* Close mount ioctl fd */
+	AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD,
+
+	/* Mount/expire status returns */
+	AUTOFS_DEV_IOCTL_READY_CMD,
+	AUTOFS_DEV_IOCTL_FAIL_CMD,
+
+	/* Activate/deactivate autofs mount */
+	AUTOFS_DEV_IOCTL_SETPIPEFD_CMD,
+	AUTOFS_DEV_IOCTL_CATATONIC_CMD,
+
+	/* Expiry timeout */
+	AUTOFS_DEV_IOCTL_TIMEOUT_CMD,
+
+	/* Get mount last requesting uid and gid */
+	AUTOFS_DEV_IOCTL_REQUESTOR_CMD,
+
+	/* Check for eligible expire candidates */
+	AUTOFS_DEV_IOCTL_EXPIRE_CMD,
+
+	/* Request busy status */
+	AUTOFS_DEV_IOCTL_ASKUMOUNT_CMD,
+
+	/* Check if path is a mountpoint */
+	AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD,
+};
+
+#define AUTOFS_IOCTL 0x93
+
+#define AUTOFS_DEV_IOCTL_VERSION	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_VERSION_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_PROTOVER	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_PROTOVER_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_PROTOSUBVER	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_OPENMOUNT	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_OPENMOUNT_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_CLOSEMOUNT	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_READY		_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_READY_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_FAIL		_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_FAIL_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_SETPIPEFD	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_SETPIPEFD_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_CATATONIC	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_CATATONIC_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_TIMEOUT	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_TIMEOUT_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_REQUESTOR	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_REQUESTOR_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_EXPIRE		_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_EXPIRE_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_ASKUMOUNT	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_ASKUMOUNT_CMD, struct autofs_dev_ioctl)
+#define AUTOFS_DEV_IOCTL_ISMOUNTPOINT	_IOWR(AUTOFS_IOCTL, AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD, struct autofs_dev_ioctl)
+
+#endif	/* _LINUX_AUTO_DEV_IOCTL_H */
