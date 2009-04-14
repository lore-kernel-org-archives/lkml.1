Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbZDNB6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbZDNB6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZDNB4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:56:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:56161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZDNB4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:56:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] CUSE: implement CUSE - Character device in Userspace
Date: Tue, 14 Apr 2009 10:54:54 +0900
Message-Id: <1239674094-30894-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239674094-30894-1-git-send-email-tj@kernel.org>
References: <1239674094-30894-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 01:55:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CUSE enables implementing character devices in userspace.  With recent
additions of ioctl and poll support, FUSE already has most of what's
necessary to implement character devices.  All CUSE has to do is
bonding all those components - FUSE, chardev and the driver model -
nicely.

When client opens /dev/cuse, kernel starts conversation with
CUSE_INIT.  The client tells CUSE which device it wants to create.  As
the previous patch made fuse_file usable without associated
fuse_inode, CUSE doesn't create super block or inodes.  It attaches
fuse_file to cdev file->private_data during open and set ff->fi to
NULL.  The rest of the operation is almost identical to FUSE direct IO
case.

Each CUSE device has a corresponding directory /sys/class/cuse/DEVNAME
(which is symlink to /sys/devices/virtual/class/DEVNAME if
SYSFS_DEPRECATED is turned off) which hosts "waiting" and "abort"
among other things.  Those two files have the same meaning as the FUSE
control files.

The only notable lacking feature compared to in-kernel implementation
is mmap support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/Kconfig            |   10 +
 fs/fuse/Makefile      |    1 +
 fs/fuse/cuse.c        |  675 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c        |    4 +-
 include/linux/cuse.h  |   49 ++++
 include/linux/fuse.h  |    2 +
 include/linux/magic.h |    5 +-
 7 files changed, 743 insertions(+), 3 deletions(-)
 create mode 100644 fs/fuse/cuse.c
 create mode 100644 include/linux/cuse.h

diff --git a/fs/Kconfig b/fs/Kconfig
index 9f7270f..525da2e 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -62,6 +62,16 @@ source "fs/autofs/Kconfig"
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
 
+config CUSE
+	tristate "Character device in Userpace support"
+	depends on FUSE_FS
+	help
+	  This FUSE extension allows character devices to be
+	  implemented in userspace.
+
+	  If you want to develop or use userspace character device
+	  based on CUSE, answer Y or M.
+
 config GENERIC_ACL
 	bool
 	select FS_POSIX_ACL
diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index 7243706..e95eeb4 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -3,5 +3,6 @@
 #
 
 obj-$(CONFIG_FUSE_FS) += fuse.o
+obj-$(CONFIG_CUSE) += cuse.o
 
 fuse-objs := dev.o dir.o file.o inode.o control.o
diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
new file mode 100644
index 0000000..2238016
--- /dev/null
+++ b/fs/fuse/cuse.c
@@ -0,0 +1,675 @@
+/*
+ * CUSE: Character device in Userspace
+ *
+ * Copyright (C) 2008-2009  SUSE Linux Products GmbH
+ * Copyright (C) 2008-2009  Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ *
+ * CUSE enables character devices to be implemented from userland much
+ * like FUSE allows filesystems.  On initialization /dev/cuse is
+ * created.  By opening the file and replying to the CUSE_INIT request
+ * userland CUSE server can create a character device.  After that the
+ * operation is very similar to FUSE.
+ *
+ * A CUSE instance involves the following objects.
+ *
+ * cuse_conn	: contains fuse_conn and serves as bonding structure
+ * channel	: file handle connected to the userland CUSE server
+ * cdev		: the implemented character device
+ * dev		: generic device for cdev
+ *
+ * Note that 'channel' is what 'dev' is in FUSE.  As CUSE deals with
+ * devices, it's called 'channel' to reduce confusion.
+ *
+ * channel determines when the character device dies.  When channel is
+ * closed, everything begins to destruct.  The cuse_conn is taken off
+ * the lookup table preventing further access from cdev, cdev and
+ * generic device are removed and the base reference of cuse_conn is
+ * put.
+ *
+ * On each open, the matching cuse_conn is looked up and if found an
+ * additional reference is taken which is released when the file is
+ * closed.
+ */
+
+#include <linux/cuse.h>
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/kdev_t.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/magic.h>
+#include <linux/miscdevice.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/stat.h>
+
+#include "fuse_i.h"
+
+#define CUSE_CONNTBL_LEN	64
+
+struct cuse_conn {
+	struct list_head	list;	/* linked on cuse_conntbl */
+	struct fuse_conn	fc;	/* fuse connection */
+	struct cdev		*cdev;	/* associated character device */
+	struct device		*dev;	/* device representing @cdev */
+
+	/* init parameters, set once during initialization */
+	bool			unrestricted_ioctl;
+
+	/* the following field is protected by cuse_disconnect_mutex */
+	bool			disconnected;	/* channel disconnected */
+};
+
+static DEFINE_SPINLOCK(cuse_lock);		/* protects cuse_conntbl */
+static DEFINE_MUTEX(cuse_disconnect_mutex);	/* protects cc->disconnected */
+static struct list_head cuse_conntbl[CUSE_CONNTBL_LEN];
+static struct class *cuse_class;
+
+static struct cuse_conn *fc_to_cc(struct fuse_conn *fc)
+{
+	return container_of(fc, struct cuse_conn, fc);
+}
+
+static struct list_head *cuse_conntbl_head(dev_t devt)
+{
+	return &cuse_conntbl[(MAJOR(devt) + MINOR(devt)) % CUSE_CONNTBL_LEN];
+}
+
+
+/**************************************************************************
+ * CUSE frontend operations
+ *
+ * These are file operations for the character device.
+ *
+ * On open, CUSE opens a file from the FUSE mnt and stores it to
+ * private_data of the open file.  All other ops call FUSE ops on the
+ * FUSE file.
+ */
+
+static ssize_t cuse_direct_write(struct file *file, const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	struct fuse_file *ff = file->private_data;
+
+	/*
+	 * No locking or generic_write_checks(), the server is
+	 * responsible for locking and sanity checks.
+	 */
+	return fuse_direct_io(ff, buf, count, ppos, 1);
+}
+
+static int cuse_open(struct inode *inode, struct file *file)
+{
+	dev_t devt = inode->i_cdev->dev;
+	struct cuse_conn *cc = NULL, *pos;
+	int rc;
+
+	/* look up and get the connection */
+	spin_lock(&cuse_lock);
+	list_for_each_entry(pos, cuse_conntbl_head(devt), list)
+		if (pos->dev->devt == devt) {
+			fuse_conn_get(&pos->fc);
+			cc = pos;
+			break;
+		}
+	spin_unlock(&cuse_lock);
+
+	/* dead? */
+	if (!cc)
+		return -ENODEV;
+
+	/*
+	 * Generic permission check is already done against the chrdev
+	 * file, proceed to open.
+	 */
+	rc = fuse_open_common(&cc->fc, NULL, inode, file, 0);
+	if (rc)
+		fuse_conn_put(&cc->fc);
+	return rc;
+}
+
+static int cuse_release(struct inode *inode, struct file *file)
+{
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
+
+	fuse_release_common(ff, 0);
+	fuse_conn_put(fc);
+	return 0;
+}
+
+static long cuse_file_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct fuse_file *ff = file->private_data;
+	struct cuse_conn *cc = fc_to_cc(ff->fc);
+	unsigned int flags = 0;
+
+	if (cc->unrestricted_ioctl)
+		flags |= FUSE_IOCTL_UNRESTRICTED;
+
+	return fuse_file_ioctl_common(ff, cmd, arg, flags);
+}
+
+static long cuse_file_compat_ioctl(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	struct fuse_file *ff = file->private_data;
+	struct cuse_conn *cc = fc_to_cc(ff->fc);
+	unsigned int flags = FUSE_IOCTL_COMPAT;
+
+	if (cc->unrestricted_ioctl)
+		flags |= FUSE_IOCTL_UNRESTRICTED;
+
+	return fuse_file_ioctl_common(ff, cmd, arg, flags);
+}
+
+static const struct file_operations cuse_frontend_fops = {
+	.owner			= THIS_MODULE,
+	.read			= fuse_direct_read,
+	.write			= cuse_direct_write,
+	.open			= cuse_open,
+	.flush			= fuse_flush,
+	.release		= cuse_release,
+	.fsync			= fuse_fsync,
+	.unlocked_ioctl		= cuse_file_ioctl,
+	.compat_ioctl		= cuse_file_compat_ioctl,
+	.poll			= fuse_file_poll,
+};
+
+
+/**************************************************************************
+ * CUSE channel initialization and destruction
+ */
+
+struct cuse_devinfo {
+	const char		*name;
+};
+
+/**
+ * cuse_parse_one - parse one key=value pair
+ * @pp: i/o parameter for the current position
+ * @end: points to one past the end of the packed string
+ * @keyp: out parameter for key
+ * @valp: out parameter for value
+ *
+ * *@pp points to packed strings - "key0=val0\0key1=val1\0" which ends
+ * at @end - 1.  This function parses one pair and set *@keyp to the
+ * start of the key and *@valp to the start of the value.  Note that
+ * the original string is modified such that the key string is
+ * terminated with '\0'.  *@pp is updated to point to the next string.
+ *
+ * RETURNS:
+ * 1 on successful parse, 0 on EOF, -errno on failure.
+ */
+static int cuse_parse_one(char **pp, char *end, char **keyp, char **valp)
+{
+	char *p = *pp;
+	char *key, *val;
+
+	while (p < end && *p == '\0')
+		p++;
+	if (p == end)
+		return 0;
+
+	if (end[-1] != '\0') {
+		printk(KERN_ERR "CUSE: info not properly terminated\n");
+		return -EINVAL;
+	}
+
+	key = val = p;
+	p += strlen(p);
+
+	if (valp) {
+		strsep(&val, "=");
+		if (!val)
+			val = key + strlen(key);
+		key = strstrip(key);
+		val = strstrip(val);
+	} else
+		key = strstrip(key);
+
+	if (!strlen(key)) {
+		printk(KERN_ERR "CUSE: zero length info key specified\n");
+		return -EINVAL;
+	}
+
+	*pp = p;
+	*keyp = key;
+	if (valp)
+		*valp = val;
+
+	return 1;
+}
+
+/**
+ * cuse_parse_dev_info - parse device info
+ * @p: device info string
+ * @len: length of device info string
+ * @devinfo: out parameter for parsed device info
+ *
+ * Parse @p to extract device info and store it into @devinfo.  String
+ * pointed to by @p is modified by parsing and @devinfo points into
+ * them, so @p shouldn't be freed while @devinfo is in use.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+static int cuse_parse_devinfo(char *p, size_t len, struct cuse_devinfo *devinfo)
+{
+	char *end = p + len;
+	char *key, *val;
+	int rc;
+
+	while (true) {
+		rc = cuse_parse_one(&p, end, &key, &val);
+		if (rc < 0)
+			return rc;
+		if (!rc)
+			break;
+		if (strcmp(key, "DEVNAME") == 0)
+			devinfo->name = val;
+		else
+			printk(KERN_WARNING "CUSE: unknown device info \"%s\"\n",
+			       key);
+	}
+
+	if (!devinfo->name || !strlen(devinfo->name)) {
+		printk(KERN_ERR "CUSE: DEVNAME unspecified\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void cuse_gendev_release(struct device *dev)
+{
+	kfree(dev);
+}
+
+/**
+ * cuse_init_worker - worker to finish initializing CUSE channel
+ * @data: cuse_conn to initialize
+ *
+ * CUSE channel is created by opening /dev/cuse but the open itself
+ * can't do much of initialization as it must return to the userland
+ * so that CUSE server and kernel can talk via the open file, so
+ * cuse_channel_open() performs minimal initialization and schedules
+ * this function on a kthread to finish up initialization.
+ *
+ * This function queries userland CUSE server which character device
+ * it wants to create and creates the character device and sets up all
+ * the required data structures for it.  Please read the comment at
+ * the top of this file for high level overview.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+static int cuse_init_worker(void *data)
+{
+	struct cuse_conn *cc = data;
+	struct cuse_init_in iin = { };
+	struct cuse_init_out iout = { };
+	struct cuse_devinfo devinfo = { };
+	struct fuse_req *req = NULL;
+	struct page *page = NULL;
+	struct device *dev;
+	struct cdev *cdev;
+	bool disconnected;
+	dev_t devt;
+	int rc;
+
+	BUILD_BUG_ON(CUSE_INIT_INFO_MAX > PAGE_SIZE);
+
+	/* identify ourself and query what the CUSE server wants */
+	req = fuse_get_req(&cc->fc);
+	if (IS_ERR(req)) {
+		rc = PTR_ERR(req);
+		goto out;
+	}
+
+	rc = -ENOMEM;
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	if (!page)
+		goto out;
+
+	req->pages[0] = nth_page(page, 0);
+	req->pages[1] = nth_page(page, 1);
+	req->num_pages = 2;
+
+	req->in.h.opcode = CUSE_INIT;
+	req->in.h.nodeid = 0;
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(iin);
+	req->in.args[0].value = &iin;
+
+	iin.ver_major = CUSE_KERNEL_VERSION;
+	iin.ver_minor = CUSE_KERNEL_MINOR_VERSION;
+
+	req->out.numargs = 2;
+	req->out.args[0].size = sizeof(iout);
+	req->out.args[0].value = &iout;
+	req->out.args[1].size = CUSE_INIT_INFO_MAX;
+	req->out.argpages = 1;
+	req->out.argvar = 1;
+
+	fuse_request_send(&cc->fc, req);
+	rc = req->out.h.error;
+	if (rc)
+		goto out;
+
+	/* parse init reply */
+	cc->unrestricted_ioctl = iout.flags & CUSE_UNRESTRICTED_IOCTL;
+
+	rc = cuse_parse_devinfo(page_address(page), req->out.args[1].size,
+				&devinfo);
+	if (rc)
+		goto out;
+
+	/* determine and reserve devt */
+	devt = MKDEV(iout.dev_major, iout.dev_minor);
+	if (!MAJOR(devt))
+		rc = alloc_chrdev_region(&devt, MINOR(devt), 1, devinfo.name);
+	else
+		rc = register_chrdev_region(devt, 1, devinfo.name);
+	if (rc) {
+		printk(KERN_ERR "CUSE: failed to register chrdev region\n");
+		goto out;
+	}
+
+	/* devt determined, create device */
+	rc = -ENOMEM;
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		goto out_region;
+
+	device_initialize(dev);
+	dev_set_uevent_suppress(dev, 1);
+	dev->class = cuse_class;
+	dev->devt = devt;
+	dev->release = cuse_gendev_release;
+	dev_set_drvdata(dev, cc);
+	dev_set_name(dev, "%s", devinfo.name);
+
+	rc = device_add(dev);
+	if (rc)
+		goto out_device;
+
+	/* register cdev */
+	rc = -ENOMEM;
+	cdev = cdev_alloc();
+	if (!cdev)
+		goto out_device;
+
+	cdev->owner = THIS_MODULE;
+	cdev->ops = &cuse_frontend_fops;
+
+	rc = cdev_add(cdev, devt, 1);
+	if (rc)
+		goto out_cdev;
+
+	/* transfer objects to the connection and register it */
+	mutex_lock(&cuse_disconnect_mutex);
+
+	/* did we lose to channel release? */
+	disconnected = cc->disconnected;
+	if (!disconnected) {
+		cc->dev = dev;
+		cc->cdev = cdev;
+
+		/* make the device available */
+		spin_lock(&cuse_lock);
+		list_add(&cc->list, cuse_conntbl_head(devt));
+		spin_unlock(&cuse_lock);
+
+		/* announce device availability */
+		dev_set_uevent_suppress(dev, 0);
+		kobject_uevent(&dev->kobj, KOBJ_ADD);
+	}
+
+	mutex_unlock(&cuse_disconnect_mutex);
+
+	rc = -ENODEV;
+	if (disconnected)
+		goto out_cdev;
+
+	/* okay, everything is good, notify init completion */
+	fuse_put_request(&cc->fc, req);
+	req = fuse_get_req(&cc->fc);
+	if (IS_ERR(req)) {
+		rc = PTR_ERR(req);
+		goto out_cdev;
+	}
+
+	req->in.h.opcode = CUSE_INIT_DONE;
+	req->in.h.nodeid = 0;
+
+	fuse_request_send(&cc->fc, req);
+	rc = req->out.h.error;
+	goto out;
+
+out_cdev:
+	cdev_del(cdev);
+out_device:
+	put_device(dev);
+out_region:
+	unregister_chrdev_region(devt, 1);
+out:
+	if (req && !IS_ERR(req))
+		fuse_put_request(&cc->fc, req);
+	if (page)
+		__free_pages(page, 1);
+
+	if (rc)
+		fuse_abort_conn(&cc->fc);
+
+	fuse_conn_put(&cc->fc);
+	return rc;
+}
+
+static void cuse_fc_release(struct fuse_conn *fc)
+{
+	struct cuse_conn *cc = fc_to_cc(fc);
+
+	kfree(cc);
+}
+
+/**
+ * cuse_channel_open - open method for /dev/cuse
+ * @inode: inode for /dev/cuse
+ * @file: file struct being opened
+ *
+ * Userland CUSE server can create a CUSE device by opening /dev/cuse
+ * and replying to the initilaization request kernel sends.  This
+ * function is responsible for handling CUSE device initialization.
+ * Because the fd opened by this function is used during
+ * initialization, this function only creates cuse_conn and sends
+ * init.  The rest is delegated to a kthread.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+static int cuse_channel_open(struct inode *inode, struct file *file)
+{
+	struct cuse_conn *cc;
+	struct fuse_req *init_req;
+	struct task_struct *worker;
+	int rc;
+
+	/* set up cuse_conn */
+	cc = kzalloc(sizeof(*cc), GFP_KERNEL);
+	if (!cc)
+		return -ENOMEM;
+
+	rc = fuse_conn_init(&cc->fc, 0, NULL);
+	if (rc) {
+		kfree(cc);
+		return rc;
+	}
+
+	/* cuse isn't accessible to mortal users, give it some latitude */
+	INIT_LIST_HEAD(&cc->list);
+	cc->fc.flags = FUSE_ALLOW_OTHER;
+	cc->fc.user_id = current_euid();
+	cc->fc.group_id = current_egid();
+	cc->fc.max_read = FUSE_MAX_PAGES_PER_REQ * PAGE_SIZE;
+	cc->fc.release = cuse_fc_release;
+
+	/* let's send fuse init request */
+	rc = -ENOMEM;
+	init_req = fuse_request_alloc();
+	if (!init_req)
+		goto err_put;
+
+	cc->fc.connected = 1;
+	file->private_data = &cc->fc;	/* channel owns base reference to cc */
+	fuse_send_init(&cc->fc, init_req);
+
+	/*
+	 * Okay, FUSE part of initialization is complete.  The rest of
+	 * the initialization is a bit more involved and requires
+	 * conversing with userland.  Start a kthread.
+	 */
+	fuse_conn_get(&cc->fc);
+	worker = kthread_run(cuse_init_worker, cc, "cuse-init-pid%d",
+			     current->pid);
+	if (IS_ERR(worker)) {
+		fuse_conn_put(&cc->fc);
+		rc = PTR_ERR(worker);
+		goto err_put;
+	}
+	return 0;
+
+err_put:
+	fuse_conn_put(&cc->fc);
+	return rc;
+}
+
+/**
+ * cuse_channel_release - release method for /dev/cuse
+ * @inode: inode for /dev/cuse
+ * @file: file struct being closed
+ *
+ * Disconnect the channel, deregister CUSE device and initiate
+ * destruction by putting the default reference.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+static int cuse_channel_release(struct inode *inode, struct file *file)
+{
+	struct cuse_conn *cc = fc_to_cc(file->private_data);
+	int rc;
+
+	mutex_lock(&cuse_disconnect_mutex);
+
+	/* remove from the conntbl, no more access from this point on */
+	spin_lock(&cuse_lock);
+	list_del_init(&cc->list);
+	spin_unlock(&cuse_lock);
+
+	/* remove device */
+	if (cc->dev)
+		device_unregister(cc->dev);
+	if (cc->cdev) {
+		unregister_chrdev_region(cc->cdev->dev, 1);
+		cdev_del(cc->cdev);
+	}
+
+	/* in case init isn't done yet, mark that the conn is already dead */
+	cc->disconnected = true;
+
+	/* kill connection and shutdown channel */
+	fuse_conn_kill(&cc->fc);
+	rc = fuse_dev_release(inode, file);	/* puts the base reference */
+
+	mutex_unlock(&cuse_disconnect_mutex);
+
+	return rc;
+}
+
+static struct file_operations cuse_channel_fops; /* initialized during init */
+
+
+/**************************************************************************
+ * Misc stuff and module initializatiion
+ *
+ * CUSE exports the same set of attributes to sysfs as fusectl.
+ */
+
+ssize_t cuse_class_waiting_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct cuse_conn *cc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", atomic_read(&cc->fc.num_waiting));
+}
+
+ssize_t cuse_class_abort_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct cuse_conn *cc = dev_get_drvdata(dev);
+
+	fuse_abort_conn(&cc->fc);
+	return count;
+}
+
+static struct device_attribute cuse_class_dev_attrs[] = {
+	__ATTR(waiting, S_IFREG | 0400, cuse_class_waiting_show, NULL),
+	__ATTR(abort, S_IFREG | 0200, NULL, cuse_class_abort_store),
+	{ }
+};
+
+static struct miscdevice cuse_miscdev = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "cuse",
+	.fops		= &cuse_channel_fops,
+};
+
+static int __init cuse_init(void)
+{
+	int i, rc;
+
+	/* init conntbl */
+	for (i = 0; i < CUSE_CONNTBL_LEN; i++)
+		INIT_LIST_HEAD(&cuse_conntbl[i]);
+
+	/* inherit and extend fuse_dev_operations */
+	cuse_channel_fops		= fuse_dev_operations;
+	cuse_channel_fops.owner		= THIS_MODULE;
+	cuse_channel_fops.open		= cuse_channel_open;
+	cuse_channel_fops.release	= cuse_channel_release;
+
+	cuse_class = class_create(THIS_MODULE, "cuse");
+	if (IS_ERR(cuse_class))
+		return PTR_ERR(cuse_class);
+
+	cuse_class->dev_attrs = cuse_class_dev_attrs;
+
+	rc = misc_register(&cuse_miscdev);
+	if (rc) {
+		class_destroy(cuse_class);
+		return rc;
+	}
+
+	return 0;
+}
+
+static void __exit cuse_exit(void)
+{
+	misc_deregister(&cuse_miscdev);
+	class_destroy(cuse_class);
+}
+
+module_init(cuse_init);
+module_exit(cuse_exit);
+
+MODULE_AUTHOR("Tejun Heo <tj@kernel.org>");
+MODULE_DESCRIPTION("Character device in Userspace");
+MODULE_LICENSE("GPL");
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 700cdf9..7492577 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 
+static const struct file_operations fuse_file_operations;
 static const struct file_operations fuse_direct_io_file_operations;
 
 static int fuse_send_open(struct fuse_file *ff, int isdir,
@@ -110,7 +111,8 @@ void fuse_finish_open(struct fuse_file *ff, struct fuse_open_out *outarg)
 {
 	struct inode *vfs_inode = fuse_file_vfs_inode(ff);
 
-	if (outarg->open_flags & FOPEN_DIRECT_IO)
+	if (outarg->open_flags & FOPEN_DIRECT_IO &&
+	    ff->file->f_op == &fuse_file_operations)
 		ff->file->f_op = &fuse_direct_io_file_operations;
 	if (!(outarg->open_flags & FOPEN_KEEP_CACHE))
 		invalidate_inode_pages2(vfs_inode->i_mapping);
diff --git a/include/linux/cuse.h b/include/linux/cuse.h
new file mode 100644
index 0000000..17926e3
--- /dev/null
+++ b/include/linux/cuse.h
@@ -0,0 +1,49 @@
+/*
+ * CUSE: Character device in Userspace
+ *
+ * Copyright (C) 2008-2009  SUSE Linux Products GmbH
+ * Copyright (C) 2008-2009  Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef _CUSE_H_
+#define _CUSE_H_
+
+#include <linux/major.h>
+#include <linux/miscdevice.h>
+#include <linux/fuse.h>
+
+#define CUSE_KERNEL_VERSION		0
+#define CUSE_KERNEL_MINOR_VERSION	1
+
+#define CUSE_KERNEL_MAJOR		MISC_MAJOR
+#define CUSE_KERNEL_MINOR		MISC_DYNAMIC_MINOR
+
+#define CUSE_INIT_INFO_MAX		4096
+
+/*
+ * CUSE INIT request/reply flags
+ */
+#define CUSE_UNRESTRICTED_IOCTL		(1 << 0) /* use unrestricted ioctl */
+
+enum cuse_opcode {
+	CUSE_INIT	= CUSE_BASE,
+	CUSE_INIT_DONE,
+};
+
+struct cuse_init_in {
+	__u32	ver_major;
+	__u32	ver_minor;
+	__u32	flags;
+	__u32	padding;
+};
+
+struct cuse_init_out {
+	__u32	dev_major;		/* chardev major */
+	__u32	dev_minor;		/* chardev minor */
+	__u32	flags;
+	__u32	padding;
+};
+
+#endif /*_CUSE_H_*/
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 162e5de..cc51548 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -210,6 +210,8 @@ enum fuse_opcode {
 	FUSE_DESTROY       = 38,
 	FUSE_IOCTL         = 39,
 	FUSE_POLL          = 40,
+
+	CUSE_BASE          = 4096,
 };
 
 enum fuse_notify_code {
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 5b4e28b..4596c9e 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -3,10 +3,11 @@
 
 #define ADFS_SUPER_MAGIC	0xadf5
 #define AFFS_SUPER_MAGIC	0xadff
-#define AFS_SUPER_MAGIC                0x5346414F
+#define AFS_SUPER_MAGIC		0x5346414F
 #define AUTOFS_SUPER_MAGIC	0x0187
 #define CODA_SUPER_MAGIC	0x73757245
-#define DEBUGFS_MAGIC          0x64626720
+#define CUSE_SUPER_MAGIC	0x43555345
+#define DEBUGFS_MAGIC		0x64626720
 #define SYSFS_MAGIC		0x62656572
 #define SECURITYFS_MAGIC	0x73636673
 #define TMPFS_MAGIC		0x01021994
-- 
1.6.0.2

