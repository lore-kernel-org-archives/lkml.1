Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZIQIXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZIQIXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZIQIXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:23:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51050 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZIQIXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:23:43 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 17 Sep 2009 01:23:39 -0700
Message-ID: <m1y6oef08k.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: ; 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      []
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH] Remove broken by design and by implementation devtmpfs maintenance disaster
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


devtmpfs has numerous problems.  The once I see from a quick review.
- devtmpfs steals i_private from tmpfs (a layering/maintenance horror)
- devtmpfs is missing calls to mnt_want_write.
- device_add does not clean up it's devtmpfs node on error
- The filesystem does not live under fs/ where it can be found.
- The Kconfig entry is not under Filesystems.

- The fundamental justification for devtmpfs is bogus.
  devtmpfs is not faster nor does it solve the hotplug problem.
  * A static dev is faster.
  * Dynamically creating dev entries (in userspace) is not slow.
    Fundamentally it should be the same amount of time as it is the
    same amount of work.
  * People actively write/depend on udev rules to the file names in /dev.
    Perhaps they are just for the creation of symlink to the filenames
    specified in Documentation/devices.txt but regardless device names
    not documented in Documentation/devices.txt are used in the real
    world. (i.e. udev still handles naming).
  * If you are truly dealing with hotplug events in userspace
    it is necessary to listen to uevents and react which
    last I checked is role of udev.

- Once everyone starts using devtmpfs it will be a serious technical
  problem for containers.

- Reportedly devtmpfs is mandatory in the latest version of Suse
  so claiming it is experimental and if unsure say N seems like
  the wrong advice, and a serious misnomer.

The process by which devtmpfs was written designed and merged was
horrible.  Any suggestion for solving the problem in another way
better has been dismissed, ignored, or met with lies.

One might say on the face of it that devtmpfs has gone through the
proper kernel process. It has been post for review several times and
it has been been in linux-next.  There is little point in a code
review if all dissenting opinions are ignored.  Every time the code
was posted there were NACKS from significant kernel developers talking
about significant technical problems with devtmpfs.  I had thought
that devtmpfs was not scheduled for 2.6.32 as it was not in fs/ in
linux-next.  Who places a filesystem in drivers/core/ and not even
in the filesystem Kconfig menu?

Additionally Greg KH and Kay Sievers have a bad track record of fixing
filesystem bugs in sysfs, which I see no reason will not continue with
devtmpfs.  Last year about this time Greg persuaded Al Viro to review
sysfs (as I had some changes pending).  Al found numerous serious bugs
that almost exclusively were in the exiting sysfs and not my patches.
My patches are routinely not acceppted into Gregs sysfs development
branch for the smallest of excuses, after giant time lags.

Given that devfs incarnations including sysfs routinely have nasty vfs
problems.  Given that Greg and Kay demonstrated no interest in fixing
vfs problems in sysfs.  Please accept this patch to remove the devtmpfs
filesystem disaster from the upcoming linux 2.6.32.  If we are going
to have broken code let's keep it in user space where it can do less
harm.

This reverts commit 2b2af54a5bb6f7e80ccf78f20084b93c398c3a8b.
 Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
---
 drivers/base/Kconfig     |   25 ---
 drivers/base/Makefile    |    1 -
 drivers/base/base.h      |    6 -
 drivers/base/core.c      |    3 -
 drivers/base/devtmpfs.c  |  367 ----------------------------------------------
 drivers/base/init.c      |    1 -
 include/linux/device.h   |   10 --
 include/linux/shmem_fs.h |    3 -
 init/do_mounts.c         |    2 +-
 init/main.c              |    2 -
 mm/shmem.c               |    9 +-
 11 files changed, 7 insertions(+), 422 deletions(-)
 delete mode 100644 drivers/base/devtmpfs.c

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index ee37727..8f006f9 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -8,31 +8,6 @@ config UEVENT_HELPER_PATH
 	  Path to uevent helper program forked by the kernel for
 	  every uevent.
 
-config DEVTMPFS
-	bool "Create a kernel maintained /dev tmpfs (EXPERIMENTAL)"
-	depends on HOTPLUG && SHMEM && TMPFS
-	help
-	  This creates a tmpfs filesystem, and mounts it at bootup
-	  and mounts it at /dev. The kernel driver core creates device
-	  nodes for all registered devices in that filesystem. All device
-	  nodes are owned by root and have the default mode of 0600.
-	  Userspace can add and delete the nodes as needed. This is
-	  intended to simplify bootup, and make it possible to delay
-	  the initial coldplug at bootup done by udev in userspace.
-	  It should also provide a simpler way for rescue systems
-	  to bring up a kernel with dynamic major/minor numbers.
-	  Meaningful symlinks, permissions and device ownership must
-	  still be handled by userspace.
-	  If unsure, say N here.
-
-config DEVTMPFS_MOUNT
-	bool "Automount devtmpfs at /dev"
-	depends on DEVTMPFS
-	help
-	  This will mount devtmpfs at /dev if the kernel mounts the root
-	  filesystem. It will not affect initramfs based mounting.
-	  If unsure, say N here.
-
 config STANDALONE
 	bool "Select only drivers that don't need compile-time external firmware" if EXPERIMENTAL
 	default y
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index c12c7f2..1b2640c 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -4,7 +4,6 @@ obj-y			:= core.o sys.o bus.o dd.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o
-obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
diff --git a/drivers/base/base.h b/drivers/base/base.h
index 2ca7f5b..503d59c 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -139,9 +139,3 @@ static inline void module_add_driver(struct module *mod,
 				     struct device_driver *drv) { }
 static inline void module_remove_driver(struct device_driver *drv) { }
 #endif
-
-#ifdef CONFIG_DEVTMPFS
-extern int devtmpfs_init(void);
-#else
-static inline int devtmpfs_init(void) { return 0; }
-#endif
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 390e664..a992985 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -929,8 +929,6 @@ int device_add(struct device *dev)
 		error = device_create_sys_dev_entry(dev);
 		if (error)
 			goto devtattrError;
-
-		devtmpfs_create_node(dev);
 	}
 
 	error = device_add_class_symlinks(dev);
@@ -1077,7 +1075,6 @@ void device_del(struct device *dev)
 	if (parent)
 		klist_del(&dev->p->knode_parent);
 	if (MAJOR(dev->devt)) {
-		devtmpfs_delete_node(dev);
 		device_remove_sys_dev_entry(dev);
 		device_remove_file(dev, &devt_attr);
 	}
diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
deleted file mode 100644
index fd488ad..0000000
--- a/drivers/base/devtmpfs.c
+++ /dev/null
@@ -1,367 +0,0 @@
-/*
- * devtmpfs - kernel-maintained tmpfs-based /dev
- *
- * Copyright (C) 2009, Kay Sievers <kay.sievers@vrfy.org>
- *
- * During bootup, before any driver core device is registered,
- * devtmpfs, a tmpfs-based filesystem is created. Every driver-core
- * device which requests a device node, will add a node in this
- * filesystem. The node is named after the the name of the device,
- * or the susbsytem can provide a custom name. All devices are
- * owned by root and have a mode of 0600.
- */
-
-#include <linux/kernel.h>
-#include <linux/syscalls.h>
-#include <linux/mount.h>
-#include <linux/device.h>
-#include <linux/genhd.h>
-#include <linux/namei.h>
-#include <linux/fs.h>
-#include <linux/shmem_fs.h>
-#include <linux/cred.h>
-#include <linux/init_task.h>
-
-static struct vfsmount *dev_mnt;
-
-#if defined CONFIG_DEVTMPFS_MOUNT
-static int dev_mount = 1;
-#else
-static int dev_mount;
-#endif
-
-static int __init mount_param(char *str)
-{
-	dev_mount = simple_strtoul(str, NULL, 0);
-	return 1;
-}
-__setup("devtmpfs.mount=", mount_param);
-
-static int dev_get_sb(struct file_system_type *fs_type, int flags,
-		      const char *dev_name, void *data, struct vfsmount *mnt)
-{
-	return get_sb_single(fs_type, flags, data, shmem_fill_super, mnt);
-}
-
-static struct file_system_type dev_fs_type = {
-	.name = "devtmpfs",
-	.get_sb = dev_get_sb,
-	.kill_sb = kill_litter_super,
-};
-
-#ifdef CONFIG_BLOCK
-static inline int is_blockdev(struct device *dev)
-{
-	return dev->class == &block_class;
-}
-#else
-static inline int is_blockdev(struct device *dev) { return 0; }
-#endif
-
-static int dev_mkdir(const char *name, mode_t mode)
-{
-	struct nameidata nd;
-	struct dentry *dentry;
-	int err;
-
-	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
-			      name, LOOKUP_PARENT, &nd);
-	if (err)
-		return err;
-
-	dentry = lookup_create(&nd, 1);
-	if (!IS_ERR(dentry)) {
-		err = vfs_mkdir(nd.path.dentry->d_inode, dentry, mode);
-		dput(dentry);
-	} else {
-		err = PTR_ERR(dentry);
-	}
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-
-	path_put(&nd.path);
-	return err;
-}
-
-static int create_path(const char *nodepath)
-{
-	char *path;
-	struct nameidata nd;
-	int err = 0;
-
-	path = kstrdup(nodepath, GFP_KERNEL);
-	if (!path)
-		return -ENOMEM;
-
-	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
-			      path, LOOKUP_PARENT, &nd);
-	if (err == 0) {
-		struct dentry *dentry;
-
-		/* create directory right away */
-		dentry = lookup_create(&nd, 1);
-		if (!IS_ERR(dentry)) {
-			err = vfs_mkdir(nd.path.dentry->d_inode,
-					dentry, 0755);
-			dput(dentry);
-		}
-		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-
-		path_put(&nd.path);
-	} else if (err == -ENOENT) {
-		char *s;
-
-		/* parent directories do not exist, create them */
-		s = path;
-		while (1) {
-			s = strchr(s, '/');
-			if (!s)
-				break;
-			s[0] = '\0';
-			err = dev_mkdir(path, 0755);
-			if (err && err != -EEXIST)
-				break;
-			s[0] = '/';
-			s++;
-		}
-	}
-
-	kfree(path);
-	return err;
-}
-
-int devtmpfs_create_node(struct device *dev)
-{
-	const char *tmp = NULL;
-	const char *nodename;
-	const struct cred *curr_cred;
-	mode_t mode;
-	struct nameidata nd;
-	struct dentry *dentry;
-	int err;
-
-	if (!dev_mnt)
-		return 0;
-
-	nodename = device_get_nodename(dev, &tmp);
-	if (!nodename)
-		return -ENOMEM;
-
-	if (is_blockdev(dev))
-		mode = S_IFBLK|0600;
-	else
-		mode = S_IFCHR|0600;
-
-	curr_cred = override_creds(&init_cred);
-	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
-			      nodename, LOOKUP_PARENT, &nd);
-	if (err == -ENOENT) {
-		/* create missing parent directories */
-		create_path(nodename);
-		err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
-				      nodename, LOOKUP_PARENT, &nd);
-		if (err)
-			goto out;
-	}
-
-	dentry = lookup_create(&nd, 0);
-	if (!IS_ERR(dentry)) {
-		err = vfs_mknod(nd.path.dentry->d_inode,
-				dentry, mode, dev->devt);
-		/* mark as kernel created inode */
-		if (!err)
-			dentry->d_inode->i_private = &dev_mnt;
-		dput(dentry);
-	} else {
-		err = PTR_ERR(dentry);
-	}
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-
-	path_put(&nd.path);
-out:
-	kfree(tmp);
-	revert_creds(curr_cred);
-	return err;
-}
-
-static int dev_rmdir(const char *name)
-{
-	struct nameidata nd;
-	struct dentry *dentry;
-	int err;
-
-	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
-			      name, LOOKUP_PARENT, &nd);
-	if (err)
-		return err;
-
-	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_one_len(nd.last.name, nd.path.dentry, nd.last.len);
-	if (!IS_ERR(dentry)) {
-		if (dentry->d_inode)
-			err = vfs_rmdir(nd.path.dentry->d_inode, dentry);
-		else
-			err = -ENOENT;
-		dput(dentry);
-	} else {
-		err = PTR_ERR(dentry);
-	}
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-
-	path_put(&nd.path);
-	return err;
-}
-
-static int delete_path(const char *nodepath)
-{
-	const char *path;
-	int err = 0;
-
-	path = kstrdup(nodepath, GFP_KERNEL);
-	if (!path)
-		return -ENOMEM;
-
-	while (1) {
-		char *base;
-
-		base = strrchr(path, '/');
-		if (!base)
-			break;
-		base[0] = '\0';
-		err = dev_rmdir(path);
-		if (err)
-			break;
-	}
-
-	kfree(path);
-	return err;
-}
-
-static int dev_mynode(struct device *dev, struct inode *inode, struct kstat *stat)
-{
-	/* did we create it */
-	if (inode->i_private != &dev_mnt)
-		return 0;
-
-	/* does the dev_t match */
-	if (is_blockdev(dev)) {
-		if (!S_ISBLK(stat->mode))
-			return 0;
-	} else {
-		if (!S_ISCHR(stat->mode))
-			return 0;
-	}
-	if (stat->rdev != dev->devt)
-		return 0;
-
-	/* ours */
-	return 1;
-}
-
-int devtmpfs_delete_node(struct device *dev)
-{
-	const char *tmp = NULL;
-	const char *nodename;
-	const struct cred *curr_cred;
-	struct nameidata nd;
-	struct dentry *dentry;
-	struct kstat stat;
-	int deleted = 1;
-	int err;
-
-	if (!dev_mnt)
-		return 0;
-
-	nodename = device_get_nodename(dev, &tmp);
-	if (!nodename)
-		return -ENOMEM;
-
-	curr_cred = override_creds(&init_cred);
-	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
-			      nodename, LOOKUP_PARENT, &nd);
-	if (err)
-		goto out;
-
-	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_one_len(nd.last.name, nd.path.dentry, nd.last.len);
-	if (!IS_ERR(dentry)) {
-		if (dentry->d_inode) {
-			err = vfs_getattr(nd.path.mnt, dentry, &stat);
-			if (!err && dev_mynode(dev, dentry->d_inode, &stat)) {
-				err = vfs_unlink(nd.path.dentry->d_inode,
-						 dentry);
-				if (!err || err == -ENOENT)
-					deleted = 1;
-			}
-		} else {
-			err = -ENOENT;
-		}
-		dput(dentry);
-	} else {
-		err = PTR_ERR(dentry);
-	}
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-
-	path_put(&nd.path);
-	if (deleted && strchr(nodename, '/'))
-		delete_path(nodename);
-out:
-	kfree(tmp);
-	revert_creds(curr_cred);
-	return err;
-}
-
-/*
- * If configured, or requested by the commandline, devtmpfs will be
- * auto-mounted after the kernel mounted the root filesystem.
- */
-int devtmpfs_mount(const char *mountpoint)
-{
-	struct path path;
-	int err;
-
-	if (!dev_mount)
-		return 0;
-
-	if (!dev_mnt)
-		return 0;
-
-	err = kern_path(mountpoint, LOOKUP_FOLLOW, &path);
-	if (err)
-		return err;
-	err = do_add_mount(dev_mnt, &path, 0, NULL);
-	if (err)
-		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
-	else
-		printk(KERN_INFO "devtmpfs: mounted\n");
-	path_put(&path);
-	return err;
-}
-
-/*
- * Create devtmpfs instance, driver-core devices will add their device
- * nodes here.
- */
-int __init devtmpfs_init(void)
-{
-	int err;
-	struct vfsmount *mnt;
-
-	err = register_filesystem(&dev_fs_type);
-	if (err) {
-		printk(KERN_ERR "devtmpfs: unable to register devtmpfs "
-		       "type %i\n", err);
-		return err;
-	}
-
-	mnt = kern_mount(&dev_fs_type);
-	if (IS_ERR(mnt)) {
-		err = PTR_ERR(mnt);
-		printk(KERN_ERR "devtmpfs: unable to create devtmpfs %i\n", err);
-		unregister_filesystem(&dev_fs_type);
-		return err;
-	}
-	dev_mnt = mnt;
-
-	printk(KERN_INFO "devtmpfs: initialized\n");
-	return 0;
-}
diff --git a/drivers/base/init.c b/drivers/base/init.c
index c8a934e..7bd9b6a 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -20,7 +20,6 @@
 void __init driver_init(void)
 {
 	/* These are the core pieces */
-	devtmpfs_init();
 	devices_init();
 	buses_init();
 	classes_init();
diff --git a/include/linux/device.h b/include/linux/device.h
index 847b763..62ff53a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -552,16 +552,6 @@ extern void put_device(struct device *dev);
 
 extern void wait_for_device_probe(void);
 
-#ifdef CONFIG_DEVTMPFS
-extern int devtmpfs_create_node(struct device *dev);
-extern int devtmpfs_delete_node(struct device *dev);
-extern int devtmpfs_mount(const char *mountpoint);
-#else
-static inline int devtmpfs_create_node(struct device *dev) { return 0; }
-static inline int devtmpfs_delete_node(struct device *dev) { return 0; }
-static inline int devtmpfs_mount(const char *mountpoint) { return 0; }
-#endif
-
 /* drivers/base/power/shutdown.c */
 extern void device_shutdown(void);
 
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index deee7af..6d3f2f4 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -38,9 +38,6 @@ static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
 	return container_of(inode, struct shmem_inode_info, vfs_inode);
 }
 
-extern int init_tmpfs(void);
-extern int shmem_fill_super(struct super_block *sb, void *data, int silent);
-
 #ifdef CONFIG_TMPFS_POSIX_ACL
 int shmem_check_acl(struct inode *, int);
 int shmem_acl_init(struct inode *, struct inode *);
diff --git a/init/do_mounts.c b/init/do_mounts.c
index bb008d0..093f659 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -415,7 +415,7 @@ void __init prepare_namespace(void)
 
 	mount_root();
 out:
-	devtmpfs_mount("dev");
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
 }
+
diff --git a/init/main.c b/init/main.c
index 34971be..63904bb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -68,7 +68,6 @@
 #include <linux/async.h>
 #include <linux/kmemcheck.h>
 #include <linux/kmemtrace.h>
-#include <linux/shmem_fs.h>
 #include <trace/boot.h>
 
 #include <asm/io.h>
@@ -786,7 +785,6 @@ static void __init do_basic_setup(void)
 	init_workqueues();
 	cpuset_init_smp();
 	usermodehelper_init();
-	init_tmpfs();
 	driver_init();
 	init_irq_proc();
 	do_ctors();
diff --git a/mm/shmem.c b/mm/shmem.c
index bd20f8b..5a0b3d4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2298,7 +2298,8 @@ static void shmem_put_super(struct super_block *sb)
 	sb->s_fs_info = NULL;
 }
 
-int shmem_fill_super(struct super_block *sb, void *data, int silent)
+static int shmem_fill_super(struct super_block *sb,
+			    void *data, int silent)
 {
 	struct inode *inode;
 	struct dentry *root;
@@ -2518,7 +2519,7 @@ static struct file_system_type tmpfs_fs_type = {
 	.kill_sb	= kill_litter_super,
 };
 
-int __init init_tmpfs(void)
+static int __init init_tmpfs(void)
 {
 	int error;
 
@@ -2575,7 +2576,7 @@ static struct file_system_type tmpfs_fs_type = {
 	.kill_sb	= kill_litter_super,
 };
 
-int __init init_tmpfs(void)
+static int __init init_tmpfs(void)
 {
 	BUG_ON(register_filesystem(&tmpfs_fs_type) != 0);
 
@@ -2686,3 +2687,5 @@ int shmem_zero_setup(struct vm_area_struct *vma)
 	vma->vm_ops = &shmem_vm_ops;
 	return 0;
 }
+
+module_init(init_tmpfs)
-- 
1.6.2.5

