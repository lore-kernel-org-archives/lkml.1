Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZGOLwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZGOLwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbZGOLwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:52:39 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:59495 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbZGOLwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:52:38 -0400
Date: Wed, 15 Jul 2009 13:52:35 +0200
From: Tobias Diedrich <ranma@tdiedrich.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Subject: block2mtd and ubi are initialized too early when compiled in on
	2.6.31-rc2
Message-ID: <20090715115235.GA21888@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.31-rc2 the block2mtd drivers module_init is called before any
block devices have been registered.
Also ubi is initialized pretty early and fails completely if an mtd
specified on the command line could not be found.
IMO ubi should at least complete initialization so that attaching
the mtd later with ubiattach would still work.
I'm working around this two hacky patches that create a kernel
thread and retry every second for 20 seconds when the first try
doesn't work.
(Obviously this means rootdelay=$somenumber is needed)
I tried using the async infrastructure, but apparently
async_synchronize_full is called somewhere between registering the
async probe thread and the target USB device being registered by the
USB subsystem, which halts boot until my 20 second timeout, and the
USB stick is only detected afterwards.

FWIW I want to use a erasesize aware FS on my USB stick (whose
builtin FTL has abysmal write performance if writes are less than
the erasesize) and also be able to use this as my root fs.
So my setup is usb_storage->block2mtd->ubi->ubifs

Index: linux-2.6.31-rc2/drivers/mtd/devices/block2mtd.c
===================================================================
--- linux-2.6.31-rc2.orig/drivers/mtd/devices/block2mtd.c	2009-07-11 22:22:34.318636261 +0200
+++ linux-2.6.31-rc2/drivers/mtd/devices/block2mtd.c	2009-07-12 00:05:45.937512203 +0200
@@ -17,6 +17,8 @@
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
 #include <linux/mount.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
 
 #define ERROR(fmt, args...) printk(KERN_ERR "block2mtd: " fmt "\n" , ## args)
 #define INFO(fmt, args...) printk(KERN_INFO "block2mtd: " fmt "\n" , ## args)
@@ -373,8 +375,30 @@
 static char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
 #endif
 
+struct block2mtd_setupasync_params {
+	char *name;
+	int erase_size;
+};
+
+static int block2mtd_setupasync(void *p)
+{
+	struct block2mtd_setupasync_params *params = p;
+	int i;
+
+	printk(KERN_WARNING "block2mtd: spawned kernel thread for async waiting on '%s'\n", params->name);
+	for (i=0; i<20; i++) {
+		msleep(1000);
+
+		if (add_device(params->name, params->erase_size) != NULL)
+			break;
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
@@ -382,6 +406,7 @@
 	char *name;
 	size_t erase_size = PAGE_SIZE;
 	int i, ret;
+	struct block2mtd_setupasync_params *params;
 
 	if (strnlen(val, sizeof(buf)) >= sizeof(buf))
 		parse_err("parameter too long");
@@ -409,16 +434,32 @@
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
@@ -426,7 +467,7 @@
 	   we can parse the argument now. */
 
 	if (block2mtd_init_called)
-		return block2mtd_setup2(val);
+		return block2mtd_setup2(val, 0);
 
 	/* During early boot stage, we only save the parameters
 	   here. We must parse them later: if the param passed
@@ -451,7 +492,7 @@
 
 #ifndef MODULE
 	if (strlen(block2mtd_paramline))
-		ret = block2mtd_setup2(block2mtd_paramline);
+		ret = block2mtd_setup2(block2mtd_paramline, 1);
 	block2mtd_init_called = 1;
 #endif
 
Index: linux-2.6.31-rc2/drivers/mtd/ubi/build.c
===================================================================
--- linux-2.6.31-rc2.orig/drivers/mtd/ubi/build.c	2009-07-11 23:18:58.839398443 +0200
+++ linux-2.6.31-rc2/drivers/mtd/ubi/build.c	2009-07-12 00:04:28.721126461 +0200
@@ -42,6 +42,7 @@
 #include <linux/log2.h>
 #include <linux/kthread.h>
 #include <linux/reboot.h>
+#include <linux/delay.h>
 #include "ubi.h"
 
 /* Maximum length of the 'mtd=' parameter */
@@ -1136,6 +1137,40 @@
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
@@ -1176,28 +1211,8 @@
 		goto out_dev_unreg;
 
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
 
 	return 0;
 

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
