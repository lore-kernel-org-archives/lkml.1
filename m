Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZISVgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZISVgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZISVgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:36:48 -0400
Received: from kroah.org ([198.145.64.141]:50870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbZISVgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:36:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] Driver-Core: extend devnode callbacks to provide permissions
Date: Sat, 19 Sep 2009 14:36:20 -0700
Message-Id: <1253396180-7829-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213332.GA7668@kroah.com>
References: <20090919213332.GA7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This allows subsytems to provide devtmpfs with non-default permissions
for the device node. Instead of the default mode of 0600, null, zero,
random, urandom, full, tty, ptmx now have a mode of 0666, which allows
non-privileged processes to access standard device nodes in case no
other userspace process applies the expected permissions.

This also fixes a wrong assignment in pktcdvd and a checkpatch.pl complain.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpuid.c             |    4 ++--
 arch/x86/kernel/microcode_core.c    |    2 +-
 arch/x86/kernel/msr.c               |    4 ++--
 block/bsg.c                         |    4 ++--
 block/genhd.c                       |    8 ++++----
 drivers/base/core.c                 |   19 ++++++++++++-------
 drivers/base/devtmpfs.c             |   24 ++++++++++++++++--------
 drivers/block/aoe/aoechr.c          |    4 ++--
 drivers/block/pktcdvd.c             |    6 +++---
 drivers/char/hw_random/core.c       |    2 +-
 drivers/char/mem.c                  |   29 +++++++++++++++++++----------
 drivers/char/misc.c                 |   10 ++++++----
 drivers/char/raw.c                  |    4 ++--
 drivers/char/tty_io.c               |   11 +++++++++++
 drivers/gpu/drm/drm_sysfs.c         |    4 ++--
 drivers/hid/usbhid/hiddev.c         |    4 ++--
 drivers/input/input.c               |    4 ++--
 drivers/md/dm-ioctl.c               |    2 +-
 drivers/media/dvb/dvb-core/dvbdev.c |    4 ++--
 drivers/net/tun.c                   |    2 +-
 drivers/usb/class/usblp.c           |    4 ++--
 drivers/usb/core/file.c             |    8 ++++----
 drivers/usb/core/usb.c              |    4 ++--
 drivers/usb/misc/iowarrior.c        |    4 ++--
 drivers/usb/misc/legousbtower.c     |    4 ++--
 include/linux/device.h              |    7 ++++---
 include/linux/genhd.h               |    2 +-
 include/linux/miscdevice.h          |    3 ++-
 include/linux/usb.h                 |    4 ++--
 sound/sound_core.c                  |    4 ++--
 30 files changed, 116 insertions(+), 79 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index b07af88..6a52d4b 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -182,7 +182,7 @@ static struct notifier_block __refdata cpuid_class_cpu_notifier =
 	.notifier_call = cpuid_class_cpu_callback,
 };
 
-static char *cpuid_nodename(struct device *dev)
+static char *cpuid_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "cpu/%u/cpuid", MINOR(dev->devt));
 }
@@ -203,7 +203,7 @@ static int __init cpuid_init(void)
 		err = PTR_ERR(cpuid_class);
 		goto out_chrdev;
 	}
-	cpuid_class->nodename = cpuid_nodename;
+	cpuid_class->devnode = cpuid_devnode;
 	for_each_online_cpu(i) {
 		err = cpuid_device_create(i);
 		if (err != 0)
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 9371448..0db7969 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -236,7 +236,7 @@ static const struct file_operations microcode_fops = {
 static struct miscdevice microcode_dev = {
 	.minor			= MICROCODE_MINOR,
 	.name			= "microcode",
-	.devnode		= "cpu/microcode",
+	.nodename		= "cpu/microcode",
 	.fops			= &microcode_fops,
 };
 
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7dd9500..6a3cefc 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -241,7 +241,7 @@ static struct notifier_block __refdata msr_class_cpu_notifier = {
 	.notifier_call = msr_class_cpu_callback,
 };
 
-static char *msr_nodename(struct device *dev)
+static char *msr_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "cpu/%u/msr", MINOR(dev->devt));
 }
@@ -262,7 +262,7 @@ static int __init msr_init(void)
 		err = PTR_ERR(msr_class);
 		goto out_chrdev;
 	}
-	msr_class->nodename = msr_nodename;
+	msr_class->devnode = msr_devnode;
 	for_each_online_cpu(i) {
 		err = msr_device_create(i);
 		if (err != 0)
diff --git a/block/bsg.c b/block/bsg.c
index 5f184bb..0676301 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1062,7 +1062,7 @@ EXPORT_SYMBOL_GPL(bsg_register_queue);
 
 static struct cdev bsg_cdev;
 
-static char *bsg_nodename(struct device *dev)
+static char *bsg_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "bsg/%s", dev_name(dev));
 }
@@ -1087,7 +1087,7 @@ static int __init bsg_init(void)
 		ret = PTR_ERR(bsg_class);
 		goto destroy_kmemcache;
 	}
-	bsg_class->nodename = bsg_nodename;
+	bsg_class->devnode = bsg_devnode;
 
 	ret = alloc_chrdev_region(&devid, 0, BSG_MAX_DEVS, "bsg");
 	if (ret)
diff --git a/block/genhd.c b/block/genhd.c
index 2ad91dd..517e433 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -998,12 +998,12 @@ struct class block_class = {
 	.name		= "block",
 };
 
-static char *block_nodename(struct device *dev)
+static char *block_devnode(struct device *dev, mode_t *mode)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	if (disk->nodename)
-		return disk->nodename(disk);
+	if (disk->devnode)
+		return disk->devnode(disk, mode);
 	return NULL;
 }
 
@@ -1011,7 +1011,7 @@ static struct device_type disk_type = {
 	.name		= "disk",
 	.groups		= disk_attr_groups,
 	.release	= disk_release,
-	.nodename	= block_nodename,
+	.devnode	= block_devnode,
 };
 
 #ifdef CONFIG_PROC_FS
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 390e664..6bee6af 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -166,13 +166,16 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 	if (MAJOR(dev->devt)) {
 		const char *tmp;
 		const char *name;
+		mode_t mode = 0;
 
 		add_uevent_var(env, "MAJOR=%u", MAJOR(dev->devt));
 		add_uevent_var(env, "MINOR=%u", MINOR(dev->devt));
-		name = device_get_nodename(dev, &tmp);
+		name = device_get_devnode(dev, &mode, &tmp);
 		if (name) {
 			add_uevent_var(env, "DEVNAME=%s", name);
 			kfree(tmp);
+			if (mode)
+				add_uevent_var(env, "DEVMODE=%#o", mode & 0777);
 		}
 	}
 
@@ -1148,8 +1151,9 @@ static struct device *next_device(struct klist_iter *i)
 }
 
 /**
- * device_get_nodename - path of device node file
+ * device_get_devnode - path of device node file
  * @dev: device
+ * @mode: returned file access mode
  * @tmp: possibly allocated string
  *
  * Return the relative path of a possible device node.
@@ -1157,21 +1161,22 @@ static struct device *next_device(struct klist_iter *i)
  * a name. This memory is returned in tmp and needs to be
  * freed by the caller.
  */
-const char *device_get_nodename(struct device *dev, const char **tmp)
+const char *device_get_devnode(struct device *dev,
+			       mode_t *mode, const char **tmp)
 {
 	char *s;
 
 	*tmp = NULL;
 
 	/* the device type may provide a specific name */
-	if (dev->type && dev->type->nodename)
-		*tmp = dev->type->nodename(dev);
+	if (dev->type && dev->type->devnode)
+		*tmp = dev->type->devnode(dev, mode);
 	if (*tmp)
 		return *tmp;
 
 	/* the class may provide a specific name */
-	if (dev->class && dev->class->nodename)
-		*tmp = dev->class->nodename(dev);
+	if (dev->class && dev->class->devnode)
+		*tmp = dev->class->devnode(dev, mode);
 	if (*tmp)
 		return *tmp;
 
diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index fd488ad..a1cb5af 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -6,9 +6,10 @@
  * During bootup, before any driver core device is registered,
  * devtmpfs, a tmpfs-based filesystem is created. Every driver-core
  * device which requests a device node, will add a node in this
- * filesystem. The node is named after the the name of the device,
- * or the susbsytem can provide a custom name. All devices are
- * owned by root and have a mode of 0600.
+ * filesystem.
+ * By default, all devices are named after the the name of the
+ * device, owned by root and have a default mode of 0600. Subsystems
+ * can overwrite the default setting if needed.
  */
 
 #include <linux/kernel.h>
@@ -20,6 +21,7 @@
 #include <linux/fs.h>
 #include <linux/shmem_fs.h>
 #include <linux/cred.h>
+#include <linux/sched.h>
 #include <linux/init_task.h>
 
 static struct vfsmount *dev_mnt;
@@ -134,7 +136,7 @@ int devtmpfs_create_node(struct device *dev)
 	const char *tmp = NULL;
 	const char *nodename;
 	const struct cred *curr_cred;
-	mode_t mode;
+	mode_t mode = 0;
 	struct nameidata nd;
 	struct dentry *dentry;
 	int err;
@@ -142,14 +144,16 @@ int devtmpfs_create_node(struct device *dev)
 	if (!dev_mnt)
 		return 0;
 
-	nodename = device_get_nodename(dev, &tmp);
+	nodename = device_get_devnode(dev, &mode, &tmp);
 	if (!nodename)
 		return -ENOMEM;
 
+	if (mode == 0)
+		mode = 0600;
 	if (is_blockdev(dev))
-		mode = S_IFBLK|0600;
+		mode |= S_IFBLK;
 	else
-		mode = S_IFCHR|0600;
+		mode |= S_IFCHR;
 
 	curr_cred = override_creds(&init_cred);
 	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
@@ -165,8 +169,12 @@ int devtmpfs_create_node(struct device *dev)
 
 	dentry = lookup_create(&nd, 0);
 	if (!IS_ERR(dentry)) {
+		int umask;
+
+		umask = sys_umask(0000);
 		err = vfs_mknod(nd.path.dentry->d_inode,
 				dentry, mode, dev->devt);
+		sys_umask(umask);
 		/* mark as kernel created inode */
 		if (!err)
 			dentry->d_inode->i_private = &dev_mnt;
@@ -271,7 +279,7 @@ int devtmpfs_delete_node(struct device *dev)
 	if (!dev_mnt)
 		return 0;
 
-	nodename = device_get_nodename(dev, &tmp);
+	nodename = device_get_devnode(dev, NULL, &tmp);
 	if (!nodename)
 		return -ENOMEM;
 
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 1988835..62141ec 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -266,7 +266,7 @@ static const struct file_operations aoe_fops = {
 	.owner = THIS_MODULE,
 };
 
-static char *aoe_nodename(struct device *dev)
+static char *aoe_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "etherd/%s", dev_name(dev));
 }
@@ -288,7 +288,7 @@ aoechr_init(void)
 		unregister_chrdev(AOE_MAJOR, "aoechr");
 		return PTR_ERR(aoe_class);
 	}
-	aoe_class->nodename = aoe_nodename;
+	aoe_class->devnode = aoe_devnode;
 
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
 		device_create(aoe_class, NULL,
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 95f11cd..fd5bb8a 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2857,7 +2857,7 @@ static struct block_device_operations pktcdvd_ops = {
 	.media_changed =	pkt_media_changed,
 };
 
-static char *pktcdvd_nodename(struct gendisk *gd)
+static char *pktcdvd_devnode(struct gendisk *gd, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "pktcdvd/%s", gd->disk_name);
 }
@@ -2914,7 +2914,7 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	disk->fops = &pktcdvd_ops;
 	disk->flags = GENHD_FL_REMOVABLE;
 	strcpy(disk->disk_name, pd->name);
-	disk->nodename = pktcdvd_nodename;
+	disk->devnode = pktcdvd_devnode;
 	disk->private_data = pd;
 	disk->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!disk->queue)
@@ -3070,7 +3070,7 @@ static const struct file_operations pkt_ctl_fops = {
 static struct miscdevice pkt_misc = {
 	.minor 		= MISC_DYNAMIC_MINOR,
 	.name  		= DRIVER_NAME,
-	.name  		= "pktcdvd/control",
+	.nodename	= "pktcdvd/control",
 	.fops  		= &pkt_ctl_fops
 };
 
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index fc93e2f..1573aeb 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -153,7 +153,7 @@ static const struct file_operations rng_chrdev_ops = {
 static struct miscdevice rng_miscdev = {
 	.minor		= RNG_MISCDEV_MINOR,
 	.name		= RNG_MODULE_NAME,
-	.devnode	= "hwrng",
+	.nodename	= "hwrng",
 	.fops		= &rng_chrdev_ops,
 };
 
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 0491cdf..0aede1d 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -866,24 +866,25 @@ static const struct file_operations kmsg_fops = {
 
 static const struct memdev {
 	const char *name;
+	mode_t mode;
 	const struct file_operations *fops;
 	struct backing_dev_info *dev_info;
 } devlist[] = {
-	[ 1] = { "mem", &mem_fops, &directly_mappable_cdev_bdi },
+	 [1] = { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi },
 #ifdef CONFIG_DEVKMEM
-	[ 2] = { "kmem", &kmem_fops, &directly_mappable_cdev_bdi },
+	 [2] = { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi },
 #endif
-	[ 3] = {"null", &null_fops, NULL },
+	 [3] = { "null", 0666, &null_fops, NULL },
 #ifdef CONFIG_DEVPORT
-	[ 4] = { "port", &port_fops, NULL },
+	 [4] = { "port", 0, &port_fops, NULL },
 #endif
-	[ 5] = { "zero", &zero_fops, &zero_bdi },
-	[ 7] = { "full", &full_fops, NULL },
-	[ 8] = { "random", &random_fops, NULL },
-	[ 9] = { "urandom", &urandom_fops, NULL },
-	[11] = { "kmsg", &kmsg_fops, NULL },
+	 [5] = { "zero", 0666, &zero_fops, &zero_bdi },
+	 [7] = { "full", 0666, &full_fops, NULL },
+	 [8] = { "random", 0666, &random_fops, NULL },
+	 [9] = { "urandom", 0666, &urandom_fops, NULL },
+	[11] = { "kmsg", 0, &kmsg_fops, NULL },
 #ifdef CONFIG_CRASH_DUMP
-	[12] = { "oldmem", &oldmem_fops, NULL },
+	[12] = { "oldmem", 0, &oldmem_fops, NULL },
 #endif
 };
 
@@ -920,6 +921,13 @@ static const struct file_operations memory_fops = {
 	.open		= memory_open,
 };
 
+static char *mem_devnode(struct device *dev, mode_t *mode)
+{
+	if (mode && devlist[MINOR(dev->devt)].mode)
+		*mode = devlist[MINOR(dev->devt)].mode;
+	return NULL;
+}
+
 static struct class *mem_class;
 
 static int __init chr_dev_init(void)
@@ -935,6 +943,7 @@ static int __init chr_dev_init(void)
 		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
 
 	mem_class = class_create(THIS_MODULE, "mem");
+	mem_class->devnode = mem_devnode;
 	for (minor = 1; minor < ARRAY_SIZE(devlist); minor++) {
 		if (!devlist[minor].name)
 			continue;
diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 62c99fa..1ee27cc 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -263,12 +263,14 @@ int misc_deregister(struct miscdevice *misc)
 EXPORT_SYMBOL(misc_register);
 EXPORT_SYMBOL(misc_deregister);
 
-static char *misc_nodename(struct device *dev)
+static char *misc_devnode(struct device *dev, mode_t *mode)
 {
 	struct miscdevice *c = dev_get_drvdata(dev);
 
-	if (c->devnode)
-		return kstrdup(c->devnode, GFP_KERNEL);
+	if (mode && c->mode)
+		*mode = c->mode;
+	if (c->nodename)
+		return kstrdup(c->nodename, GFP_KERNEL);
 	return NULL;
 }
 
@@ -287,7 +289,7 @@ static int __init misc_init(void)
 	err = -EIO;
 	if (register_chrdev(MISC_MAJOR,"misc",&misc_fops))
 		goto fail_printk;
-	misc_class->nodename = misc_nodename;
+	misc_class->devnode = misc_devnode;
 	return 0;
 
 fail_printk:
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 40268db..64acd05 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -261,7 +261,7 @@ static const struct file_operations raw_ctl_fops = {
 
 static struct cdev raw_cdev;
 
-static char *raw_nodename(struct device *dev)
+static char *raw_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "raw/%s", dev_name(dev));
 }
@@ -289,7 +289,7 @@ static int __init raw_init(void)
 		ret = PTR_ERR(raw_class);
 		goto error_region;
 	}
-	raw_class->nodename = raw_nodename;
+	raw_class->devnode = raw_devnode;
 	device_create(raw_class, NULL, MKDEV(RAW_MAJOR, 0), NULL, "rawctl");
 
 	return 0;
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a3afa0c..c70d9da 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3056,11 +3056,22 @@ void __init console_init(void)
 	}
 }
 
+static char *tty_devnode(struct device *dev, mode_t *mode)
+{
+	if (!mode)
+		return NULL;
+	if (dev->devt == MKDEV(TTYAUX_MAJOR, 0) ||
+	    dev->devt == MKDEV(TTYAUX_MAJOR, 2))
+		*mode = 0666;
+	return NULL;
+}
+
 static int __init tty_class_init(void)
 {
 	tty_class = class_create(THIS_MODULE, "tty");
 	if (IS_ERR(tty_class))
 		return PTR_ERR(tty_class);
+	tty_class->devnode = tty_devnode;
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index f7a615b..5301f22 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -76,7 +76,7 @@ static ssize_t version_show(struct class *dev, char *buf)
 		       CORE_MINOR, CORE_PATCHLEVEL, CORE_DATE);
 }
 
-static char *drm_nodename(struct device *dev)
+static char *drm_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "dri/%s", dev_name(dev));
 }
@@ -112,7 +112,7 @@ struct class *drm_sysfs_create(struct module *owner, char *name)
 	if (err)
 		goto err_out_class;
 
-	class->nodename = drm_nodename;
+	class->devnode = drm_devnode;
 
 	return class;
 
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 4d1dc0c..8b6ee24 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -852,14 +852,14 @@ static const struct file_operations hiddev_fops = {
 #endif
 };
 
-static char *hiddev_nodename(struct device *dev)
+static char *hiddev_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
 }
 
 static struct usb_class_driver hiddev_class = {
 	.name =		"hiddev%d",
-	.nodename =	hiddev_nodename,
+	.devnode =	hiddev_devnode,
 	.fops =		&hiddev_fops,
 	.minor_base =	HIDDEV_MINOR_BASE,
 };
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 851791d..556539d 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1265,14 +1265,14 @@ static struct device_type input_dev_type = {
 	.uevent		= input_dev_uevent,
 };
 
-static char *input_nodename(struct device *dev)
+static char *input_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "input/%s", dev_name(dev));
 }
 
 struct class input_class = {
 	.name		= "input",
-	.nodename	= input_nodename,
+	.devnode	= input_devnode,
 };
 EXPORT_SYMBOL_GPL(input_class);
 
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 7f77f18..a679429 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1532,7 +1532,7 @@ static const struct file_operations _ctl_fops = {
 static struct miscdevice _dm_misc = {
 	.minor 		= MISC_DYNAMIC_MINOR,
 	.name  		= DM_NAME,
-	.devnode	= "mapper/control",
+	.nodename	= "mapper/control",
 	.fops  		= &_ctl_fops
 };
 
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 479dd05..94159b9 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -447,7 +447,7 @@ static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
-static char *dvb_nodename(struct device *dev)
+static char *dvb_devnode(struct device *dev, mode_t *mode)
 {
 	struct dvb_device *dvbdev = dev_get_drvdata(dev);
 
@@ -478,7 +478,7 @@ static int __init init_dvbdev(void)
 		goto error;
 	}
 	dvb_class->dev_uevent = dvb_uevent;
-	dvb_class->nodename = dvb_nodename;
+	dvb_class->devnode = dvb_devnode;
 	return 0;
 
 error:
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3f5d288..d3ee199 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1370,7 +1370,7 @@ static const struct file_operations tun_fops = {
 static struct miscdevice tun_miscdev = {
 	.minor = TUN_MINOR,
 	.name = "tun",
-	.devnode = "net/tun",
+	.nodename = "net/tun",
 	.fops = &tun_fops,
 };
 
diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 26c09f0..9bc112e 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1057,14 +1057,14 @@ static const struct file_operations usblp_fops = {
 	.release =	usblp_release,
 };
 
-static char *usblp_nodename(struct device *dev)
+static char *usblp_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
 }
 
 static struct usb_class_driver usblp_class = {
 	.name =		"lp%d",
-	.nodename =	usblp_nodename,
+	.devnode =	usblp_devnode,
 	.fops =		&usblp_fops,
 	.minor_base =	USBLP_MINOR_BASE,
 };
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 5cef889..222ee07 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -67,14 +67,14 @@ static struct usb_class {
 	struct class *class;
 } *usb_class;
 
-static char *usb_nodename(struct device *dev)
+static char *usb_devnode(struct device *dev, mode_t *mode)
 {
 	struct usb_class_driver *drv;
 
 	drv = dev_get_drvdata(dev);
-	if (!drv || !drv->nodename)
+	if (!drv || !drv->devnode)
 		return NULL;
-	return drv->nodename(dev);
+	return drv->devnode(dev, mode);
 }
 
 static int init_usb_class(void)
@@ -100,7 +100,7 @@ static int init_usb_class(void)
 		kfree(usb_class);
 		usb_class = NULL;
 	}
-	usb_class->class->nodename = usb_nodename;
+	usb_class->class->devnode = usb_devnode;
 
 exit:
 	return result;
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index a26f738..43ee943 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -311,7 +311,7 @@ static struct dev_pm_ops usb_device_pm_ops = {
 #endif	/* CONFIG_PM */
 
 
-static char *usb_nodename(struct device *dev)
+static char *usb_devnode(struct device *dev, mode_t *mode)
 {
 	struct usb_device *usb_dev;
 
@@ -324,7 +324,7 @@ struct device_type usb_device_type = {
 	.name =		"usb_device",
 	.release =	usb_release_dev,
 	.uevent =	usb_dev_uevent,
-	.nodename = 	usb_nodename,
+	.devnode = 	usb_devnode,
 	.pm =		&usb_device_pm_ops,
 };
 
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 90e1a8d..e75bb87 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -727,7 +727,7 @@ static const struct file_operations iowarrior_fops = {
 	.poll = iowarrior_poll,
 };
 
-static char *iowarrior_nodename(struct device *dev)
+static char *iowarrior_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
 }
@@ -738,7 +738,7 @@ static char *iowarrior_nodename(struct device *dev)
  */
 static struct usb_class_driver iowarrior_class = {
 	.name = "iowarrior%d",
-	.nodename = iowarrior_nodename,
+	.devnode = iowarrior_devnode,
 	.fops = &iowarrior_fops,
 	.minor_base = IOWARRIOR_MINOR_BASE,
 };
diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index c1e2433..97efeae 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -266,7 +266,7 @@ static const struct file_operations tower_fops = {
 	.llseek =	tower_llseek,
 };
 
-static char *legousbtower_nodename(struct device *dev)
+static char *legousbtower_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
 }
@@ -277,7 +277,7 @@ static char *legousbtower_nodename(struct device *dev)
  */
 static struct usb_class_driver tower_class = {
 	.name =		"legousbtower%d",
-	.nodename = 	legousbtower_nodename,
+	.devnode = 	legousbtower_devnode,
 	.fops =		&tower_fops,
 	.minor_base =	LEGO_USB_TOWER_MINOR_BASE,
 };
diff --git a/include/linux/device.h b/include/linux/device.h
index 847b763..aca31bf 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -193,7 +193,7 @@ struct class {
 	struct kobject			*dev_kobj;
 
 	int (*dev_uevent)(struct device *dev, struct kobj_uevent_env *env);
-	char *(*nodename)(struct device *dev);
+	char *(*devnode)(struct device *dev, mode_t *mode);
 
 	void (*class_release)(struct class *class);
 	void (*dev_release)(struct device *dev);
@@ -298,7 +298,7 @@ struct device_type {
 	const char *name;
 	const struct attribute_group **groups;
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
-	char *(*nodename)(struct device *dev);
+	char *(*devnode)(struct device *dev, mode_t *mode);
 	void (*release)(struct device *dev);
 
 	const struct dev_pm_ops *pm;
@@ -487,7 +487,8 @@ extern struct device *device_find_child(struct device *dev, void *data,
 extern int device_rename(struct device *dev, char *new_name);
 extern int device_move(struct device *dev, struct device *new_parent,
 		       enum dpm_order dpm_order);
-extern const char *device_get_nodename(struct device *dev, const char **tmp);
+extern const char *device_get_devnode(struct device *dev,
+				      mode_t *mode, const char **tmp);
 extern void *dev_get_drvdata(const struct device *dev);
 extern void dev_set_drvdata(struct device *dev, void *data);
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 44263cb..109d179 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -142,7 +142,7 @@ struct gendisk {
                                          * disks that can't be partitioned. */
 
 	char disk_name[DISK_NAME_LEN];	/* name of major driver */
-	char *(*nodename)(struct gendisk *gd);
+	char *(*devnode)(struct gendisk *gd, mode_t *mode);
 	/* Array of pointers to partitions indexed by partno.
 	 * Protected with matching bdev lock but stat and other
 	 * non-critical accesses use RCU.  Always access through
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 0521177..adaf3c1 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -41,7 +41,8 @@ struct miscdevice  {
 	struct list_head list;
 	struct device *parent;
 	struct device *this_device;
-	const char *devnode;
+	const char *nodename;
+	mode_t mode;
 };
 
 extern int misc_register(struct miscdevice * misc);
diff --git a/include/linux/usb.h b/include/linux/usb.h
index b1e3c2f..a8fe05f 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -922,7 +922,7 @@ extern struct bus_type usb_bus_type;
 /**
  * struct usb_class_driver - identifies a USB driver that wants to use the USB major number
  * @name: the usb class device name for this driver.  Will show up in sysfs.
- * @nodename: Callback to provide a naming hint for a possible
+ * @devnode: Callback to provide a naming hint for a possible
  *	device node to create.
  * @fops: pointer to the struct file_operations of this driver.
  * @minor_base: the start of the minor range for this driver.
@@ -933,7 +933,7 @@ extern struct bus_type usb_bus_type;
  */
 struct usb_class_driver {
 	char *name;
-	char *(*nodename)(struct device *dev);
+	char *(*devnode)(struct device *dev, mode_t *mode);
 	const struct file_operations *fops;
 	int minor_base;
 };
diff --git a/sound/sound_core.c b/sound/sound_core.c
index bb4b88e..49c9981 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -29,7 +29,7 @@ MODULE_DESCRIPTION("Core sound module");
 MODULE_AUTHOR("Alan Cox");
 MODULE_LICENSE("GPL");
 
-static char *sound_nodename(struct device *dev)
+static char *sound_devnode(struct device *dev, mode_t *mode)
 {
 	if (MAJOR(dev->devt) == SOUND_MAJOR)
 		return NULL;
@@ -50,7 +50,7 @@ static int __init init_soundcore(void)
 		return PTR_ERR(sound_class);
 	}
 
-	sound_class->nodename = sound_nodename;
+	sound_class->devnode = sound_devnode;
 
 	return 0;
 }
-- 
1.6.4.2

