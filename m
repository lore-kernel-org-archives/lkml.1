Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbZGPO2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbZGPO2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbZGPO2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:28:20 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:35480 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425AbZGPO2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:28:19 -0400
Date: Thu, 16 Jul 2009 16:28:16 +0200
From: Tobias Diedrich <ranma@tdiedrich.de>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: block2mtd and ubi are initialized too early when compiled in
	on 2.6.31-rc2
Message-ID: <20090716142816.GA19523@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	Artem Bityutskiy <dedekind@infradead.org>,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
References: <20090715115235.GA21888@yamamaya.is-a-geek.org> <1247746844.11353.152.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247746844.11353.152.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> Hi,
> 
> On Wed, 2009-07-15 at 13:52 +0200, Tobias Diedrich wrote:
> > On 2.6.31-rc2 the block2mtd drivers module_init is called before any
> > block devices have been registered.
> 
> Hmm, ok. Is this because block devices are registered asynchronously?
> Could you please point to the code where it is done, just for reference.

AFAICS yes.
All module_init()s are called asynchronously from init/main.c:do_initcalls()

> > Also ubi is initialized pretty early and fails completely if an mtd
> > specified on the command line could not be found.
> 
> Hmm...

> > IMO ubi should at least complete initialization so that attaching
> > the mtd later with ubiattach would still work.
> > I'm working around this two hacky patches that create a kernel
> > thread and retry every second for 20 seconds when the first try
> > doesn't work.
> > (Obviously this means rootdelay=$somenumber is needed)
> > I tried using the async infrastructure, but apparently

> > async_synchronize_full is called somewhere between registering the
> > async probe thread and the target USB device being registered by the
> > USB subsystem, which halts boot until my 20 second timeout, and the
> > USB stick is only detected afterwards.
> > 
> > FWIW I want to use a erasesize aware FS on my USB stick (whose
> > builtin FTL has abysmal write performance if writes are less than
> > the erasesize) and also be able to use this as my root fs.
> > So my setup is usb_storage->block2mtd->ubi->ubifs
> 
> Hmm, how other subsystems solve this problem? Any pointer to the code?

At least for mtd I've found there is a hooking mechanism:
You can use register_mtd_user() to register a callback which gets
called for each new mtd device.
I've modified my workaround patch to use that instead of a polling
thread.

AFAICS there is nothing directly comparable for block devices.
However there is drivers/base/dd.c:wait_for_device_probe() which is
used by init/do_mounts.c and also by drivers/scsi/scsi_wait_scan.c
to wait for device probing to finish.
I did not get around to try using it though.

Index: linux-2.6.31-rc3/drivers/mtd/devices/block2mtd.c
===================================================================
--- linux-2.6.31-rc3.orig/drivers/mtd/devices/block2mtd.c	2009-07-15 14:35:22.184277464 +0200
+++ linux-2.6.31-rc3/drivers/mtd/devices/block2mtd.c	2009-07-16 00:01:57.905961095 +0200
@@ -17,6 +17,9 @@
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
 #include <linux/mount.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/async.h>
 
 #define ERROR(fmt, args...) printk(KERN_ERR "block2mtd: " fmt "\n" , ## args)
 #define INFO(fmt, args...) printk(KERN_INFO "block2mtd: " fmt "\n" , ## args)
@@ -373,8 +376,51 @@
 static char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
 #endif
 
+struct block2mtd_setupasync_params {
+	char *name;
+	int erase_size;
+	int attached;
+	int locked;
+	struct mutex lock;
+};
+
+static void block2mtd_setupasync_tryadd(void *data, async_cookie_t cookie)
+{
+	struct block2mtd_setupasync_params *params = data;
+
+	mutex_lock(&params->lock);
+	if (add_device(params->name, params->erase_size) != NULL)
+		params->attached = 1;
+	mutex_unlock(&params->lock);
+}
+
+static int block2mtd_setupasync(void *p)
+{
+	struct block2mtd_setupasync_params *params = p;
+	int i;
+
+	printk(KERN_WARNING "block2mtd: spawned kernel thread for async waiting on '%s'\n", params->name);
+	mutex_init(&params->lock);
+	for (i=0; i<20 && params->attached == 0; i++) {
+		int attached = 0;
+		msleep(1000);
+
+		/* Use mutex to synchronize with async thread */
+		mutex_lock(&params->lock);
+		attached = params->attached;
+		mutex_unlock(&params->lock);
+		/* HACK: Call add_device from async_schedule()ed task
+		   so mounting rootfs will wait for ubi scan to complete */
+		if (attached == 0)
+			async_schedule(block2mtd_setupasync_tryadd, p);
+	}
+	kfree(params->name);
+	kfree(params);
+
+	return 0;
+}
 
-static int block2mtd_setup2(const char *val)
+static int block2mtd_setup2(const char *val, int async)
 {
 	char buf[80 + 12]; /* 80 for device, 12 for erase size */
 	char *str = buf;
@@ -382,6 +428,7 @@
 	char *name;
 	size_t erase_size = PAGE_SIZE;
 	int i, ret;
+	struct block2mtd_setupasync_params *params;
 
 	if (strnlen(val, sizeof(buf)) >= sizeof(buf))
 		parse_err("parameter too long");
@@ -409,16 +456,32 @@
 		}
 	}
 
-	add_device(name, erase_size);
+	if (add_device(name, erase_size) != NULL)
+		return 0;
+
+	params = kzalloc(sizeof(struct block2mtd_setupasync_params), GFP_KERNEL);
+	if (!params)
+		return 0;
+
+	params->name = kmalloc(strlen(name)+1, GFP_KERNEL);
+	params->erase_size = erase_size;
+	if (!params->name) {
+		kfree(params);
+		return 0;
+	}
+
+	memcpy(params->name, name, strlen(name)+1);
+
+	if (async)
+		kthread_run(block2mtd_setupasync, params, "block2mtd/setupasync");
 
 	return 0;
 }
 
-
 static int block2mtd_setup(const char *val, struct kernel_param *kp)
 {
 #ifdef MODULE
-	return block2mtd_setup2(val);
+	return block2mtd_setup2(val, 0);
 #else
 	/* If more parameters are later passed in via
 	   /sys/module/block2mtd/parameters/block2mtd
@@ -426,7 +489,7 @@
 	   we can parse the argument now. */
 
 	if (block2mtd_init_called)
-		return block2mtd_setup2(val);
+		return block2mtd_setup2(val, 0);
 
 	/* During early boot stage, we only save the parameters
 	   here. We must parse them later: if the param passed
@@ -451,7 +514,7 @@
 
 #ifndef MODULE
 	if (strlen(block2mtd_paramline))
-		ret = block2mtd_setup2(block2mtd_paramline);
+		ret = block2mtd_setup2(block2mtd_paramline, 1);
 	block2mtd_init_called = 1;
 #endif
 
Index: linux-2.6.31-rc3/drivers/mtd/ubi/build.c
===================================================================
--- linux-2.6.31-rc3.orig/drivers/mtd/ubi/build.c	2009-07-15 14:46:41.094276489 +0200
+++ linux-2.6.31-rc3/drivers/mtd/ubi/build.c	2009-07-15 22:54:48.837303164 +0200
@@ -42,6 +42,7 @@
 #include <linux/log2.h>
 #include <linux/kthread.h>
 #include <linux/reboot.h>
+#include <linux/delay.h>
 #include "ubi.h"
 
 /* Maximum length of the 'mtd=' parameter */
@@ -122,6 +123,30 @@
 static struct device_attribute dev_mtd_num =
 	__ATTR(mtd_num, S_IRUGO, dev_attribute_show, NULL);
 
+static void ubi_notify_remove(struct mtd_info *mtd)
+{
+
+}
+
+static void ubi_notify_add(struct mtd_info *mtd)
+{
+	int err;
+
+	if (mtd->type == MTD_ABSENT)
+		return;
+
+	printk(KERN_WARNING "ubi_notify_add(%p [%s])\n", mtd, mtd->name);
+	err = ubi_attach_mtd_dev(mtd, UBI_DEV_NUM_AUTO, 0);
+	if (err < 0) {
+		printk(KERN_WARNING "ubi_attach failed on '%s': %d\n", mtd->name, err);
+	}
+}
+
+static struct mtd_notifier ubi_notifier = {
+	.add = ubi_notify_add,
+	.remove = ubi_notify_remove,
+};
+
 /**
  * ubi_volume_notify - send a volume change notification.
  * @ubi: UBI device description object
@@ -1142,6 +1167,40 @@
 	return mtd;
 }
 
+static int ubi_init_attach_mtd(void *data)
+{
+	struct mtd_dev_param *p = data;
+	struct mtd_info *mtd;
+	int err;
+	int retries = 200;
+
+	printk(KERN_WARNING "ubi_init_attach_mtd(%s): waiting async for device to appear\n", p->name);
+	do {
+		mtd = open_mtd_device(p->name);
+		if (IS_ERR(mtd)) {
+			if (retries-- > 0) {
+				msleep(100);
+				continue;
+			}
+			err = PTR_ERR(mtd);
+			ubi_err("cannot attach mtd %s: %d\n", p->name, err);
+			return 0;
+		}
+		break;
+	} while (1);
+
+	mutex_lock(&ubi_devices_mutex);
+	err = ubi_attach_mtd_dev(mtd, UBI_DEV_NUM_AUTO,
+				 p->vid_hdr_offs);
+	mutex_unlock(&ubi_devices_mutex);
+	if (err < 0) {
+		put_mtd_device(mtd);
+		ubi_err("cannot attach mtd%d: %d", mtd->index, err);
+	}
+
+	return 0;
+}
+
 static int __init ubi_init(void)
 {
 	int err, i, k;
@@ -1181,29 +1240,12 @@
 	if (!ubi_wl_entry_slab)
 		goto out_dev_unreg;
 
+	register_mtd_user(&ubi_notifier);
+#if 0
 	/* Attach MTD devices */
-	for (i = 0; i < mtd_devs; i++) {
-		struct mtd_dev_param *p = &mtd_dev_param[i];
-		struct mtd_info *mtd;
-
-		cond_resched();
-
-		mtd = open_mtd_device(p->name);
-		if (IS_ERR(mtd)) {
-			err = PTR_ERR(mtd);
-			goto out_detach;
-		}
-
-		mutex_lock(&ubi_devices_mutex);
-		err = ubi_attach_mtd_dev(mtd, UBI_DEV_NUM_AUTO,
-					 p->vid_hdr_offs);
-		mutex_unlock(&ubi_devices_mutex);
-		if (err < 0) {
-			put_mtd_device(mtd);
-			ubi_err("cannot attach mtd%d", mtd->index);
-			goto out_detach;
-		}
-	}
+	for (i = 0; i < mtd_devs; i++)
+		kthread_run(ubi_init_attach_mtd, &mtd_dev_param[i], "ubi/mtdprobe%d", i);
+#endif
 
 	return 0;
 
@@ -1231,6 +1273,7 @@
 {
 	int i;
 
+	unregister_mtd_user(&ubi_notifier);
 	for (i = 0; i < UBI_MAX_DEVICES; i++)
 		if (ubi_devices[i]) {
 			mutex_lock(&ubi_devices_mutex);

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
