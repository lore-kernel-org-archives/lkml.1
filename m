Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZBNUGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZBNUGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZBNUGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:06:05 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:61905 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059AbZBNUGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:06:00 -0500
X-Trace: 149424441/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.250/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.250
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgEADKzlklQLLD6/2dsb2JhbACBbMFojieEHAY
X-IronPort-AV: E=Sophos;i="4.38,207,1233532800"; 
   d="scan'208";a="149424441"
Subject: [PATCH] sh: maple: Update the maple bus driver to support block
 reads and writes
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>
Cc: Paul Mundt <lethal@users.sourceforge.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 20:05:48 +0000
Message-Id: <1234641948.6609.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

This patch updates the maple bus to support asynchronous block reads and
writes as well as generally improving the quality of the code and
supporting concurrency (all needed to support the Dreamcast visual
memory unit - a driver will also be posted for that).

I have posted versions of this before but am here following the patch
grouping suggested and have also tested this code and unlike earlier
versions it shows no signs of suffering from race conditions - so I hope
you will be happy to queue it for inclusion.

Changes in the bus driver necessitate some changes in the two maple bus
input drivers that are currently in mainline.

(Maple is SEGA's proprietary serial bus for the Dreamcast. It is capable
of comm speeds of up to 2Mbs.)

As well as supporting block reads and writes this code clean up removes
some poor handling of locks, uses an atomic status variable to serialise
access to devices and more robusly handles the general performance
problems of the bus.



Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---
diff --git a/drivers/input/joystick/maplecontrol.c b/drivers/input/joystick/maplecontrol.c
index e50047b..77cfde5 100644
--- a/drivers/input/joystick/maplecontrol.c
+++ b/drivers/input/joystick/maplecontrol.c
@@ -3,7 +3,7 @@
  *	Based on drivers/usb/iforce.c
  *
  *	Copyright Yaegashi Takeshi, 2001
- *	Adrian McMenamin, 2008
+ *	Adrian McMenamin, 2008 - 2009
  */
 
 #include <linux/kernel.h>
@@ -29,7 +29,7 @@ static void dc_pad_callback(struct mapleq *mq)
 	struct maple_device *mapledev = mq->dev;
 	struct dc_pad *pad = maple_get_drvdata(mapledev);
 	struct input_dev *dev = pad->dev;
-	unsigned char *res = mq->recvbuf;
+	unsigned char *res = mq->recvbuf->buf;
 
 	buttons = ~le16_to_cpup((__le16 *)(res + 8));
 
diff --git a/drivers/input/keyboard/maple_keyb.c b/drivers/input/keyboard/maple_keyb.c
index 22f17a5..5aa2361 100644
--- a/drivers/input/keyboard/maple_keyb.c
+++ b/drivers/input/keyboard/maple_keyb.c
@@ -1,8 +1,8 @@
 /*
  * SEGA Dreamcast keyboard driver
  * Based on drivers/usb/usbkbd.c
- * Copyright YAEGASHI Takeshi, 2001
- * Porting to 2.6 Copyright Adrian McMenamin, 2007, 2008
+ * Copyright (c) YAEGASHI Takeshi, 2001
+ * Porting to 2.6 Copyright (c) Adrian McMenamin, 2007 - 2009
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -33,7 +33,7 @@ static DEFINE_MUTEX(maple_keyb_mutex);
 
 #define NR_SCANCODES 256
 
-MODULE_AUTHOR("YAEGASHI Takeshi, Adrian McMenamin");
+MODULE_AUTHOR("Adrian McMenamin <adrian@mcmen.demon.co.uk");
 MODULE_DESCRIPTION("SEGA Dreamcast keyboard driver");
 MODULE_LICENSE("GPL");
 
@@ -115,7 +115,7 @@ static void dc_scan_kbd(struct dc_kbd *kbd)
 				input_event(dev, EV_MSC, MSC_SCAN, code);
 				input_report_key(dev, keycode, 0);
 			} else
-				printk(KERN_DEBUG "maple_keyb: "
+				dev_dbg(&dev->dev,
 					"Unknown key (scancode %#x) released.",
 					code);
 		}
@@ -127,7 +127,7 @@ static void dc_scan_kbd(struct dc_kbd *kbd)
 				input_event(dev, EV_MSC, MSC_SCAN, code);
 				input_report_key(dev, keycode, 1);
 			} else
-				printk(KERN_DEBUG "maple_keyb: "
+				dev_dbg(&dev->dev,
 					"Unknown key (scancode %#x) pressed.",
 					code);
 		}
@@ -140,7 +140,7 @@ static void dc_kbd_callback(struct mapleq *mq)
 {
 	struct maple_device *mapledev = mq->dev;
 	struct dc_kbd *kbd = maple_get_drvdata(mapledev);
-	unsigned long *buf = mq->recvbuf;
+	unsigned long *buf = (unsigned long *)(mq->recvbuf->buf);
 
 	/*
 	 * We should always get the lock because the only
@@ -159,22 +159,27 @@ static void dc_kbd_callback(struct mapleq *mq)
 
 static int probe_maple_kbd(struct device *dev)
 {
-	struct maple_device *mdev = to_maple_dev(dev);
-	struct maple_driver *mdrv = to_maple_driver(dev->driver);
+	struct maple_device *mdev;
+	struct maple_driver *mdrv;
 	int i, error;
 	struct dc_kbd *kbd;
 	struct input_dev *idev;
 
-	if (!(mdev->function & MAPLE_FUNC_KEYBOARD))
-		return -EINVAL;
+	mdev = to_maple_dev(dev);
+	mdrv = to_maple_driver(dev->driver);
 
 	kbd = kzalloc(sizeof(struct dc_kbd), GFP_KERNEL);
-	idev = input_allocate_device();
-	if (!kbd || !idev) {
+	if (!kbd) {
 		error = -ENOMEM;
 		goto fail;
 	}
 
+	idev = input_allocate_device();
+	if (!idev) {
+		error = -ENOMEM;
+		goto fail_idev_alloc;
+	}
+
 	kbd->dev = idev;
 	memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode));
 
@@ -195,7 +200,7 @@ static int probe_maple_kbd(struct device *dev)
 
 	error = input_register_device(idev);
 	if (error)
-		goto fail;
+		goto fail_register;
 
 	/* Maple polling is locked to VBLANK - which may be just 50/s */
 	maple_getcond_callback(mdev, dc_kbd_callback, HZ/50,
@@ -207,10 +212,12 @@ static int probe_maple_kbd(struct device *dev)
 
 	return error;
 
-fail:
+fail_register:
+	maple_set_drvdata(mdev, NULL);
 	input_free_device(idev);
+fail_idev_alloc:
 	kfree(kbd);
-	maple_set_drvdata(mdev, NULL);
+fail:
 	return error;
 }
 
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 0225cbb..9b3e564 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -551,5 +551,15 @@ config MTD_PLATRAM
 
 	  This selection automatically selects the map_ram driver.
 
-endmenu
+config MTD_VMU
+	tristate "Map driver for Dreamcast VMU"
+	depends on MAPLE
+	help
+	  This driver enables access to the Dreamcast Visual Memory Unit (VMU).
+
+	  Most Dreamcast users will want to say Y here.
 
+	  To build this as a module select M here, the module will be called
+	  vmu-flash.
+
+endmenu
diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 63f0de2..4054fe9 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -1,16 +1,10 @@
 /*
  * Core maple bus functionality
  *
- *  Copyright (C) 2007, 2008 Adrian McMenamin
+ *  Copyright (C) 2007 - 2009 Adrian McMenamin
  *  Copyright (C) 2001 - 2008 Paul Mundt
- *
- * Based on 2.4 code by:
- *
- *  Copyright (C) 2000-2001 YAEGASHI Takeshi
+ *  Copyright (C) 2000 - 2001 YAEGASHI Takeshi
  *  Copyright (C) 2001 M. R. Brown
- *  Copyright (C) 2001 Paul Mundt
- *
- * and others.
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
@@ -32,7 +26,7 @@
 #include <mach/dma.h>
 #include <mach/sysasic.h>
 
-MODULE_AUTHOR("Yaegashi Takeshi, Paul Mundt, M. R. Brown, Adrian McMenamin");
+MODULE_AUTHOR("Adrian McMenamin <adrian@mcmen.demon.co.uk>");
 MODULE_DESCRIPTION("Maple bus driver for Dreamcast");
 MODULE_LICENSE("GPL v2");
 MODULE_SUPPORTED_DEVICE("{{SEGA, Dreamcast/Maple}}");
@@ -49,7 +43,7 @@ static LIST_HEAD(maple_sentq);
 /* mutex to protect queue of waiting packets */
 static DEFINE_MUTEX(maple_wlist_lock);
 
-static struct maple_driver maple_dummy_driver;
+static struct maple_driver maple_unsupported_device;
 static struct device maple_bus;
 static int subdevice_map[MAPLE_PORTS];
 static unsigned long *maple_sendbuf, *maple_sendptr, *maple_lastptr;
@@ -62,8 +56,9 @@ struct maple_device_specify {
 	int unit;
 };
 
-static bool checked[4];
-static struct maple_device *baseunits[4];
+static bool checked[MAPLE_PORTS];
+static bool empty[MAPLE_PORTS];
+static struct maple_device *baseunits[MAPLE_PORTS];
 
 /**
  * maple_driver_register - register a maple driver
@@ -97,12 +92,20 @@ void maple_driver_unregister(struct maple_driver *drv)
 EXPORT_SYMBOL_GPL(maple_driver_unregister);
 
 /* set hardware registers to enable next round of dma */
-static void maplebus_dma_reset(void)
+static void maple_dma_reset(void)
 {
 	ctrl_outl(MAPLE_MAGIC, MAPLE_RESET);
 	/* set trig type to 0 for software trigger, 1 for hardware (VBLANK) */
 	ctrl_outl(1, MAPLE_TRIGTYPE);
-	ctrl_outl(MAPLE_2MBPS | MAPLE_TIMEOUT(50000), MAPLE_SPEED);
+	/*
+	* Maple system register
+	* bits 31 - 16	timeout in units of 20nsec
+	* bit 12	hard trigger - set 0 to keep responding to VBLANK
+	* bits 9 - 8	set 00 for 2 Mbps, 01 for 1 Mbps
+	* bits 3 - 0	delay (in 1.3ms) between VBLANK and start of DMA
+	* max delay is 11
+	*/
+	ctrl_outl(MAPLE_2MBPS | MAPLE_TIMEOUT(0xFFFF), MAPLE_SPEED);
 	ctrl_outl(PHYSADDR(maple_sendbuf), MAPLE_DMAADDR);
 	ctrl_outl(1, MAPLE_ENABLE);
 }
@@ -134,21 +137,16 @@ static void maple_release_device(struct device *dev)
 {
 	struct maple_device *mdev;
 	struct mapleq *mq;
-	if (!dev)
-		return;
+
 	mdev = to_maple_dev(dev);
 	mq = mdev->mq;
-	if (mq) {
-		if (mq->recvbufdcsp)
-			kmem_cache_free(maple_queue_cache, mq->recvbufdcsp);
-		kfree(mq);
-		mq = NULL;
-	}
+	kmem_cache_free(maple_queue_cache, mq->recvbuf);
+	kfree(mq);
 	kfree(mdev);
 }
 
 /**
- * maple_add_packet - add a single instruction to the queue
+ * maple_add_packet - add a single instruction to the maple bus queue
  * @mdev: maple device
  * @function: function on device being queried
  * @command: maple command to add
@@ -158,68 +156,12 @@ static void maple_release_device(struct device *dev)
 int maple_add_packet(struct maple_device *mdev, u32 function, u32 command,
 	size_t length, void *data)
 {
-	int locking, ret = 0;
+	int ret = 0;
 	void *sendbuf = NULL;
 
-	mutex_lock(&maple_wlist_lock);
-	/* bounce if device already locked */
-	locking = mutex_is_locked(&mdev->mq->mutex);
-	if (locking) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	mutex_lock(&mdev->mq->mutex);
-
 	if (length) {
-		sendbuf = kmalloc(length * 4, GFP_KERNEL);
+		sendbuf = kzalloc(length * 4, GFP_KERNEL);
 		if (!sendbuf) {
-			mutex_unlock(&mdev->mq->mutex);
-			ret = -ENOMEM;
-			goto out;
-		}
-		((__be32 *)sendbuf)[0] = cpu_to_be32(function);
-	}
-
-	mdev->mq->command = command;
-	mdev->mq->length = length;
-	if (length > 1)
-		memcpy(sendbuf + 4, data, (length - 1) * 4);
-	mdev->mq->sendbuf = sendbuf;
-
-	list_add(&mdev->mq->list, &maple_waitq);
-out:
-	mutex_unlock(&maple_wlist_lock);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(maple_add_packet);
-
-/**
- * maple_add_packet_sleeps - add a single instruction to the queue
- * @mdev: maple device
- * @function: function on device being queried
- * @command: maple command to add
- * @length: length of command string (in 32 bit words)
- * @data: remainder of command string
- *
- * Same as maple_add_packet(), but waits for the lock to become free.
- */
-int maple_add_packet_sleeps(struct maple_device *mdev, u32 function,
-	u32 command, size_t length, void *data)
-{
-	int locking, ret = 0;
-	void *sendbuf = NULL;
-
-	locking = mutex_lock_interruptible(&mdev->mq->mutex);
-	if (locking) {
-		ret = -EIO;
-		goto out;
-	}
-
-	if (length) {
-		sendbuf = kmalloc(length * 4, GFP_KERNEL);
-		if (!sendbuf) {
-			mutex_unlock(&mdev->mq->mutex);
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -233,38 +175,35 @@ int maple_add_packet_sleeps(struct maple_device *mdev, u32 function,
 	mdev->mq->sendbuf = sendbuf;
 
 	mutex_lock(&maple_wlist_lock);
-	list_add(&mdev->mq->list, &maple_waitq);
+	list_add_tail(&mdev->mq->list, &maple_waitq);
 	mutex_unlock(&maple_wlist_lock);
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(maple_add_packet_sleeps);
+EXPORT_SYMBOL_GPL(maple_add_packet);
 
 static struct mapleq *maple_allocq(struct maple_device *mdev)
 {
 	struct mapleq *mq;
 
-	mq = kmalloc(sizeof(*mq), GFP_KERNEL);
+	mq = kzalloc(sizeof(*mq), GFP_KERNEL);
 	if (!mq)
 		goto failed_nomem;
 
+	INIT_LIST_HEAD(&mq->list);
 	mq->dev = mdev;
-	mq->recvbufdcsp = kmem_cache_zalloc(maple_queue_cache, GFP_KERNEL);
-	mq->recvbuf = (void *) P2SEGADDR(mq->recvbufdcsp);
+	mq->recvbuf = kmem_cache_zalloc(maple_queue_cache, GFP_KERNEL);
 	if (!mq->recvbuf)
 		goto failed_p2;
-	/*
-	 * most devices do not need the mutex - but
-	 * anything that injects block reads or writes
-	 * will rely on it
-	 */
-	mutex_init(&mq->mutex);
+	mq->recvbuf->buf = &((mq->recvbuf->bufx)[0]);
 
 	return mq;
 
 failed_p2:
 	kfree(mq);
 failed_nomem:
+	dev_err(&mdev->dev, "could not allocate memory for device (%d, %d)\n",
+		mdev->port, mdev->unit);
 	return NULL;
 }
 
@@ -272,12 +211,16 @@ static struct maple_device *maple_alloc_dev(int port, int unit)
 {
 	struct maple_device *mdev;
 
+	/* zero this out to avoid kobj subsystem
+	* thinking it has already been registered */
+
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return NULL;
 
 	mdev->port = port;
 	mdev->unit = unit;
+
 	mdev->mq = maple_allocq(mdev);
 
 	if (!mdev->mq) {
@@ -286,19 +229,14 @@ static struct maple_device *maple_alloc_dev(int port, int unit)
 	}
 	mdev->dev.bus = &maple_bus_type;
 	mdev->dev.parent = &maple_bus;
+	init_waitqueue_head(&mdev->maple_wait);
 	return mdev;
 }
 
 static void maple_free_dev(struct maple_device *mdev)
 {
-	if (!mdev)
-		return;
-	if (mdev->mq) {
-		if (mdev->mq->recvbufdcsp)
-			kmem_cache_free(maple_queue_cache,
-				mdev->mq->recvbufdcsp);
-		kfree(mdev->mq);
-	}
+	kmem_cache_free(maple_queue_cache, mdev->mq->recvbuf);
+	kfree(mdev->mq);
 	kfree(mdev);
 }
 
@@ -320,7 +258,7 @@ static void maple_build_block(struct mapleq *mq)
 	maple_lastptr = maple_sendptr;
 
 	*maple_sendptr++ = (port << 16) | len | 0x80000000;
-	*maple_sendptr++ = PHYSADDR(mq->recvbuf);
+	*maple_sendptr++ = PHYSADDR(mq->recvbuf->buf);
 	*maple_sendptr++ =
 	    mq->command | (to << 8) | (from << 16) | (len << 24);
 	while (len-- > 0)
@@ -333,20 +271,28 @@ static void maple_send(void)
 	int i, maple_packets = 0;
 	struct mapleq *mq, *nmq;
 
-	if (!list_empty(&maple_sentq))
+	if (!maple_dma_done())
 		return;
+
+	/* disable DMA */
+	ctrl_outl(0, MAPLE_ENABLE);
+
+	if (!list_empty(&maple_sentq))
+		goto finish;
+
 	mutex_lock(&maple_wlist_lock);
-	if (list_empty(&maple_waitq) || !maple_dma_done()) {
+	if (list_empty(&maple_waitq)) {
 		mutex_unlock(&maple_wlist_lock);
-		return;
+		goto finish;
 	}
-	mutex_unlock(&maple_wlist_lock);
+
 	maple_lastptr = maple_sendbuf;
 	maple_sendptr = maple_sendbuf;
-	mutex_lock(&maple_wlist_lock);
+
 	list_for_each_entry_safe(mq, nmq, &maple_waitq, list) {
 		maple_build_block(mq);
-		list_move(&mq->list, &maple_sentq);
+		list_del_init(&mq->list);
+		list_add_tail(&mq->list, &maple_sentq);
 		if (maple_packets++ > MAPLE_MAXPACKETS)
 			break;
 	}
@@ -356,10 +302,13 @@ static void maple_send(void)
 			dma_cache_sync(0, maple_sendbuf + i * PAGE_SIZE,
 				       PAGE_SIZE, DMA_BIDIRECTIONAL);
 	}
+
+finish:
+	maple_dma_reset();
 }
 
 /* check if there is a driver registered likely to match this device */
-static int check_matching_maple_driver(struct device_driver *driver,
+static int maple_check_matching_driver(struct device_driver *driver,
 					void *devptr)
 {
 	struct maple_driver *maple_drv;
@@ -374,10 +323,7 @@ static int check_matching_maple_driver(struct device_driver *driver,
 
 static void maple_detach_driver(struct maple_device *mdev)
 {
-	if (!mdev)
-		return;
 	device_unregister(&mdev->dev);
-	mdev = NULL;
 }
 
 /* process initial MAPLE_COMMAND_DEVINFO for each device or port */
@@ -385,9 +331,9 @@ static void maple_attach_driver(struct maple_device *mdev)
 {
 	char *p, *recvbuf;
 	unsigned long function;
-	int matched, retval;
+	int matched, error;
 
-	recvbuf = mdev->mq->recvbuf;
+	recvbuf = mdev->mq->recvbuf->buf;
 	/* copy the data as individual elements in
 	* case of memory optimisation */
 	memcpy(&mdev->devinfo.function, recvbuf + 4, 4);
@@ -395,7 +341,6 @@ static void maple_attach_driver(struct maple_device *mdev)
 	memcpy(&mdev->devinfo.area_code, recvbuf + 20, 1);
 	memcpy(&mdev->devinfo.connector_direction, recvbuf + 21, 1);
 	memcpy(&mdev->devinfo.product_name[0], recvbuf + 22, 30);
-	memcpy(&mdev->devinfo.product_licence[0], recvbuf + 52, 60);
 	memcpy(&mdev->devinfo.standby_power, recvbuf + 112, 2);
 	memcpy(&mdev->devinfo.max_power, recvbuf + 114, 2);
 	memcpy(mdev->product_name, mdev->devinfo.product_name, 30);
@@ -414,43 +359,41 @@ static void maple_attach_driver(struct maple_device *mdev)
 		else
 			break;
 
-	printk(KERN_INFO "Maple device detected: %s\n",
-		mdev->product_name);
-	printk(KERN_INFO "Maple device: %s\n", mdev->product_licence);
-
 	function = be32_to_cpu(mdev->devinfo.function);
 
+	dev_info(&mdev->dev, "detected %s: function 0x%lX: at (%d, %d)\n",
+		mdev->product_name, function, mdev->port, mdev->unit);
+
 	if (function > 0x200) {
 		/* Do this silently - as not a real device */
 		function = 0;
-		mdev->driver = &maple_dummy_driver;
+		mdev->driver = &maple_unsupported_device;
 		sprintf(mdev->dev.bus_id, "%d:0.port", mdev->port);
+
 	} else {
-		printk(KERN_INFO
-			"Maple bus at (%d, %d): Function 0x%lX\n",
-			mdev->port, mdev->unit, function);
 
 		matched =
 			bus_for_each_drv(&maple_bus_type, NULL, mdev,
-				check_matching_maple_driver);
+				maple_check_matching_driver);
 
 		if (matched == 0) {
 			/* Driver does not exist yet */
-			printk(KERN_INFO
-				"No maple driver found.\n");
-			mdev->driver = &maple_dummy_driver;
+			dev_info(&mdev->dev, "no driver found\n");
+			mdev->driver = &maple_unsupported_device;
 		}
 		sprintf(mdev->dev.bus_id, "%d:0%d.%lX", mdev->port,
 			mdev->unit, function);
 	}
+
 	mdev->function = function;
 	mdev->dev.release = &maple_release_device;
-	retval = device_register(&mdev->dev);
-	if (retval) {
-		printk(KERN_INFO
-		"Maple bus: Attempt to register device"
-		" (%x, %x) failed.\n",
-		mdev->port, mdev->unit);
+
+	atomic_set(&mdev->busy, 0);
+	error = device_register(&mdev->dev);
+	if (error) {
+		dev_warn(&mdev->dev, "could not register device at"
+			" (%d, %d), with error 0x%X\n", mdev->unit,
+			mdev->port, error);
 		maple_free_dev(mdev);
 		mdev = NULL;
 		return;
@@ -462,7 +405,7 @@ static void maple_attach_driver(struct maple_device *mdev)
  * port and unit then return 1 - allows identification
  * of which devices need to be attached or detached
  */
-static int detach_maple_device(struct device *device, void *portptr)
+static int check_maple_device(struct device *device, void *portptr)
 {
 	struct maple_device_specify *ds;
 	struct maple_device *mdev;
@@ -477,21 +420,25 @@ static int detach_maple_device(struct device *device, void *portptr)
 static int setup_maple_commands(struct device *device, void *ignored)
 {
 	int add;
-	struct maple_device *maple_dev = to_maple_dev(device);
-
-	if ((maple_dev->interval > 0)
-	    && time_after(jiffies, maple_dev->when)) {
-		/* bounce if we cannot lock */
-		add = maple_add_packet(maple_dev,
-			be32_to_cpu(maple_dev->devinfo.function),
+	struct maple_device *mdev = to_maple_dev(device);
+	if (mdev->interval > 0 && atomic_read(&mdev->busy) == 0 &&
+		time_after(jiffies, mdev->when)) {
+		/* bounce if we cannot add */
+		add = maple_add_packet(mdev,
+			be32_to_cpu(mdev->devinfo.function),
 			MAPLE_COMMAND_GETCOND, 1, NULL);
 		if (!add)
-			maple_dev->when = jiffies + maple_dev->interval;
+			mdev->when = jiffies + mdev->interval;
 	} else {
 		if (time_after(jiffies, maple_pnp_time))
-			/* This will also bounce */
-			maple_add_packet(maple_dev, 0,
-				MAPLE_COMMAND_DEVINFO, 0, NULL);
+			/* Ensure we don't have block reads and devinfo
+			* calls interfering with one another - so flag the
+			* device as busy */
+			if (atomic_read(&mdev->busy) == 0) {
+				atomic_set(&mdev->busy, 1);
+				maple_add_packet(mdev, 0,
+					MAPLE_COMMAND_DEVINFO, 0, NULL);
+			}
 	}
 	return 0;
 }
@@ -499,29 +446,50 @@ static int setup_maple_commands(struct device *device, void *ignored)
 /* VBLANK bottom half - implemented via workqueue */
 static void maple_vblank_handler(struct work_struct *work)
 {
-	if (!list_empty(&maple_sentq) || !maple_dma_done())
+	int x, locking;
+	struct maple_device *mdev;
+
+	if (!maple_dma_done())
 		return;
 
 	ctrl_outl(0, MAPLE_ENABLE);
 
+	if (!list_empty(&maple_sentq))
+		goto finish;
+
+	/*
+	* Set up essential commands - to fetch data and
+	* check devices are still present
+	*/
 	bus_for_each_dev(&maple_bus_type, NULL, NULL,
-			 setup_maple_commands);
+		setup_maple_commands);
+
+	if (time_after(jiffies, maple_pnp_time)) {
+		/*
+		* Scan the empty ports - bus is flakey and may have
+		* mis-reported emptyness
+		*/
+		for (x = 0; x < MAPLE_PORTS; x++) {
+			if (checked[x] && empty[x]) {
+				mdev = baseunits[x];
+				if (!mdev)
+					break;
+				atomic_set(&mdev->busy, 1);
+				locking = maple_add_packet(mdev, 0,
+					MAPLE_COMMAND_DEVINFO, 0, NULL);
+				if (!locking)
+					break;
+				}
+			}
 
-	if (time_after(jiffies, maple_pnp_time))
 		maple_pnp_time = jiffies + MAPLE_PNP_INTERVAL;
-
-	mutex_lock(&maple_wlist_lock);
-	if (!list_empty(&maple_waitq) && list_empty(&maple_sentq)) {
-		mutex_unlock(&maple_wlist_lock);
-		maple_send();
-	} else {
-		mutex_unlock(&maple_wlist_lock);
 	}
 
-	maplebus_dma_reset();
+finish:
+	maple_send();
 }
 
-/* handle devices added via hotplugs - placing them on queue for DEVINFO*/
+/* handle devices added via hotplugs - placing them on queue for DEVINFO */
 static void maple_map_subunits(struct maple_device *mdev, int submask)
 {
 	int retval, k, devcheck;
@@ -533,7 +501,7 @@ static void maple_map_subunits(struct maple_device *mdev, int submask)
 		ds.unit = k + 1;
 		retval =
 		    bus_for_each_dev(&maple_bus_type, NULL, &ds,
-				     detach_maple_device);
+				     check_maple_device);
 		if (retval) {
 			submask = submask >> 1;
 			continue;
@@ -543,6 +511,7 @@ static void maple_map_subunits(struct maple_device *mdev, int submask)
 			mdev_add = maple_alloc_dev(mdev->port, k + 1);
 			if (!mdev_add)
 				return;
+			atomic_set(&mdev_add->busy, 1);
 			maple_add_packet(mdev_add, 0, MAPLE_COMMAND_DEVINFO,
 				0, NULL);
 			/* mark that we are checking sub devices */
@@ -564,27 +533,45 @@ static void maple_clean_submap(struct maple_device *mdev)
 }
 
 /* handle empty port or hotplug removal */
-static void maple_response_none(struct maple_device *mdev,
-				struct mapleq *mq)
-{
-	if (mdev->unit != 0) {
-		list_del(&mq->list);
-		maple_clean_submap(mdev);
-		printk(KERN_INFO
-		       "Maple bus device detaching at (%d, %d)\n",
-		       mdev->port, mdev->unit);
+static void maple_response_none(struct maple_device *mdev)
+{
+	maple_clean_submap(mdev);
+
+	if (likely(mdev->unit != 0)) {
+		/*
+		* Block devices play up
+		* and give the impression they have
+		* been removed even when still in place or
+		* trip the mtd layer when they have
+		* really gone - this code traps that eventuality
+		* and ensures we aren't overloaded with useless
+		* error messages
+		*/
+		if (mdev->can_unload) {
+			if (!mdev->can_unload(mdev)) {
+				atomic_set(&mdev->busy, 2);
+				wake_up(&mdev->maple_wait);
+				return;
+			}
+		}
+
+		dev_info(&mdev->dev, "detaching device at (%d, %d)\n",
+			mdev->port, mdev->unit);
 		maple_detach_driver(mdev);
 		return;
-	}
-	if (!started || !fullscan) {
-		if (checked[mdev->port] == false) {
-			checked[mdev->port] = true;
-			printk(KERN_INFO "No maple devices attached"
-				" to port %d\n", mdev->port);
+	} else {
+		if (!started || !fullscan) {
+			if (checked[mdev->port] == false) {
+				checked[mdev->port] = true;
+				empty[mdev->port] = true;
+				dev_info(&mdev->dev, "no devices"
+					" to port %d\n", mdev->port);
+			}
+			return;
 		}
-		return;
 	}
-	maple_clean_submap(mdev);
+	/* Some hardware devices generate false detach messages on unit 0 */
+	atomic_set(&mdev->busy, 0);
 }
 
 /* preprocess hotplugs or scans */
@@ -599,8 +586,11 @@ static void maple_response_devinfo(struct maple_device *mdev,
 		} else {
 			if (mdev->unit != 0)
 				maple_attach_driver(mdev);
+			if (mdev->unit == 0) {
+				empty[mdev->port] = false;
+				maple_attach_driver(mdev);
+			}
 		}
-		return;
 	}
 	if (mdev->unit == 0) {
 		submask = recvbuf[2] & 0x1F;
@@ -611,6 +601,17 @@ static void maple_response_devinfo(struct maple_device *mdev,
 	}
 }
 
+static void maple_response_fileerr(struct maple_device *mdev, void *recvbuf)
+{
+	if (mdev->fileerr_handler) {
+		mdev->fileerr_handler(mdev, recvbuf);
+		return;
+	} else
+		dev_warn(&mdev->dev, "device at (%d, %d) reports"
+			"file error 0x%X\n", mdev->port, mdev->unit,
+			((int *)recvbuf)[1]);
+}
+
 static void maple_port_rescan(void)
 {
 	int i;
@@ -621,12 +622,6 @@ static void maple_port_rescan(void)
 		if (checked[i] == false) {
 			fullscan = 0;
 			mdev = baseunits[i];
-			/*
-			 *  test lock in case scan has failed
-			 *  but device is still locked
-			 */
-			if (mutex_is_locked(&mdev->mq->mutex))
-				mutex_unlock(&mdev->mq->mutex);
 			maple_add_packet(mdev, 0, MAPLE_COMMAND_DEVINFO,
 				0, NULL);
 		}
@@ -637,7 +632,7 @@ static void maple_port_rescan(void)
 static void maple_dma_handler(struct work_struct *work)
 {
 	struct mapleq *mq, *nmq;
-	struct maple_device *dev;
+	struct maple_device *mdev;
 	char *recvbuf;
 	enum maple_code code;
 
@@ -646,43 +641,56 @@ static void maple_dma_handler(struct work_struct *work)
 	ctrl_outl(0, MAPLE_ENABLE);
 	if (!list_empty(&maple_sentq)) {
 		list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
-			recvbuf = mq->recvbuf;
+			mdev = mq->dev;
+			recvbuf = mq->recvbuf->buf;
+			dma_cache_sync(&mdev->dev, recvbuf, 0x400,
+				DMA_FROM_DEVICE);
 			code = recvbuf[0];
-			dev = mq->dev;
 			kfree(mq->sendbuf);
-			mutex_unlock(&mq->mutex);
 			list_del_init(&mq->list);
-
 			switch (code) {
 			case MAPLE_RESPONSE_NONE:
-				maple_response_none(dev, mq);
+				maple_response_none(mdev);
 				break;
 
 			case MAPLE_RESPONSE_DEVINFO:
-				maple_response_devinfo(dev, recvbuf);
+				maple_response_devinfo(mdev, recvbuf);
+				atomic_set(&mdev->busy, 0);
 				break;
 
 			case MAPLE_RESPONSE_DATATRF:
-				if (dev->callback)
-					dev->callback(mq);
+				if (mdev->callback)
+					mdev->callback(mq);
+				atomic_set(&mdev->busy, 0);
+				wake_up(&mdev->maple_wait);
 				break;
 
 			case MAPLE_RESPONSE_FILEERR:
+				maple_response_fileerr(mdev, recvbuf);
+				atomic_set(&mdev->busy, 0);
+				wake_up(&mdev->maple_wait);
+				break;
+
 			case MAPLE_RESPONSE_AGAIN:
 			case MAPLE_RESPONSE_BADCMD:
 			case MAPLE_RESPONSE_BADFUNC:
-				printk(KERN_DEBUG
-				       "Maple non-fatal error 0x%X\n",
-				       code);
+				dev_warn(&mdev->dev, "non-fatal error"
+					" 0x%X at (%d, %d)\n", code,
+					mdev->port, mdev->unit);
+				atomic_set(&mdev->busy, 0);
 				break;
 
 			case MAPLE_RESPONSE_ALLINFO:
-				printk(KERN_DEBUG
-				       "Maple - extended device information"
-					" not supported\n");
+				dev_notice(&mdev->dev, "extended"
+				" device information request for (%d, %d)"
+				" but call is not supported\n", mdev->port,
+				mdev->unit);
+				atomic_set(&mdev->busy, 0);
 				break;
 
 			case MAPLE_RESPONSE_OK:
+				atomic_set(&mdev->busy, 0);
+				wake_up(&mdev->maple_wait);
 				break;
 
 			default:
@@ -699,20 +707,19 @@ static void maple_dma_handler(struct work_struct *work)
 		if (!fullscan)
 			maple_port_rescan();
 		/* mark that we have been through the first scan */
-		if (started == 0)
-			started = 1;
+		started = 1;
 	}
-	maplebus_dma_reset();
+	maple_send();
 }
 
-static irqreturn_t maplebus_dma_interrupt(int irq, void *dev_id)
+static irqreturn_t maple_dma_interrupt(int irq, void *dev_id)
 {
 	/* Load everything into the bottom half */
 	schedule_work(&maple_dma_process);
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t maplebus_vblank_interrupt(int irq, void *dev_id)
+static irqreturn_t maple_vblank_interrupt(int irq, void *dev_id)
 {
 	schedule_work(&maple_vblank_process);
 	return IRQ_HANDLED;
@@ -720,14 +727,14 @@ static irqreturn_t maplebus_vblank_interrupt(int irq, void *dev_id)
 
 static int maple_set_dma_interrupt_handler(void)
 {
-	return request_irq(HW_EVENT_MAPLE_DMA, maplebus_dma_interrupt,
-		IRQF_SHARED, "maple bus DMA", &maple_dummy_driver);
+	return request_irq(HW_EVENT_MAPLE_DMA, maple_dma_interrupt,
+		IRQF_SHARED, "maple bus DMA", &maple_unsupported_device);
 }
 
 static int maple_set_vblank_interrupt_handler(void)
 {
-	return request_irq(HW_EVENT_VSYNC, maplebus_vblank_interrupt,
-		IRQF_SHARED, "maple bus VBLANK", &maple_dummy_driver);
+	return request_irq(HW_EVENT_VSYNC, maple_vblank_interrupt,
+		IRQF_SHARED, "maple bus VBLANK", &maple_unsupported_device);
 }
 
 static int maple_get_dma_buffer(void)
@@ -740,7 +747,7 @@ static int maple_get_dma_buffer(void)
 	return 0;
 }
 
-static int match_maple_bus_driver(struct device *devptr,
+static int maple_match_bus_driver(struct device *devptr,
 				  struct device_driver *drvptr)
 {
 	struct maple_driver *maple_drv = to_maple_driver(drvptr);
@@ -765,16 +772,18 @@ static void maple_bus_release(struct device *dev)
 {
 }
 
-static struct maple_driver maple_dummy_driver = {
+static struct maple_driver maple_unsupported_device = {
 	.drv = {
-		.name = "maple_dummy_driver",
+		.name = "maple_unsupported_device",
 		.bus = &maple_bus_type,
 	},
 };
-
+/**
+ * maple_bus_type - core maple bus structure
+ */
 struct bus_type maple_bus_type = {
 	.name = "maple",
-	.match = match_maple_bus_driver,
+	.match = maple_match_bus_driver,
 	.uevent = maple_bus_uevent,
 };
 EXPORT_SYMBOL_GPL(maple_bus_type);
@@ -788,7 +797,8 @@ static int __init maple_bus_init(void)
 {
 	int retval, i;
 	struct maple_device *mdev[MAPLE_PORTS];
-	ctrl_outl(0, MAPLE_STATE);
+
+	ctrl_outl(0, MAPLE_ENABLE);
 
 	retval = device_register(&maple_bus);
 	if (retval)
@@ -798,36 +808,33 @@ static int __init maple_bus_init(void)
 	if (retval)
 		goto cleanup_device;
 
-	retval = driver_register(&maple_dummy_driver.drv);
+	retval = driver_register(&maple_unsupported_device.drv);
 	if (retval)
 		goto cleanup_bus;
 
 	/* allocate memory for maple bus dma */
 	retval = maple_get_dma_buffer();
 	if (retval) {
-		printk(KERN_INFO
-		       "Maple bus: Failed to allocate Maple DMA buffers\n");
+		dev_err(&maple_bus, "failed to allocate DMA buffers\n");
 		goto cleanup_basic;
 	}
 
 	/* set up DMA interrupt handler */
 	retval = maple_set_dma_interrupt_handler();
 	if (retval) {
-		printk(KERN_INFO
-		       "Maple bus: Failed to grab maple DMA IRQ\n");
+		dev_err(&maple_bus, "bus failed to grab maple "
+			"DMA IRQ\n");
 		goto cleanup_dma;
 	}
 
 	/* set up VBLANK interrupt handler */
 	retval = maple_set_vblank_interrupt_handler();
 	if (retval) {
-		printk(KERN_INFO "Maple bus: Failed to grab VBLANK IRQ\n");
+		dev_err(&maple_bus, "bus failed to grab VBLANK IRQ\n");
 		goto cleanup_irq;
 	}
 
-	maple_queue_cache =
-	    kmem_cache_create("maple_queue_cache", 0x400, 0,
-			      SLAB_HWCACHE_ALIGN, NULL);
+	maple_queue_cache = KMEM_CACHE(maple_buffer, SLAB_HWCACHE_ALIGN);
 
 	if (!maple_queue_cache)
 		goto cleanup_bothirqs;
@@ -838,23 +845,23 @@ static int __init maple_bus_init(void)
 	/* setup maple ports */
 	for (i = 0; i < MAPLE_PORTS; i++) {
 		checked[i] = false;
+		empty[i] = false;
 		mdev[i] = maple_alloc_dev(i, 0);
-		baseunits[i] = mdev[i];
 		if (!mdev[i]) {
 			while (i-- > 0)
 				maple_free_dev(mdev[i]);
 			goto cleanup_cache;
 		}
+		baseunits[i] = mdev[i];
+		atomic_set(&mdev[i]->busy, 1);
 		maple_add_packet(mdev[i], 0, MAPLE_COMMAND_DEVINFO, 0, NULL);
 		subdevice_map[i] = 0;
 	}
 
-	/* setup maplebus hardware */
-	maplebus_dma_reset();
-	/* initial detection */
+	maple_pnp_time = jiffies + HZ;
+	/* prepare initial queue */
 	maple_send();
-	maple_pnp_time = jiffies;
-	printk(KERN_INFO "Maple bus core now registered.\n");
+	dev_info(&maple_bus, "bus core now registered\n");
 
 	return 0;
 
@@ -871,7 +878,7 @@ cleanup_dma:
 	free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
 
 cleanup_basic:
-	driver_unregister(&maple_dummy_driver.drv);
+	driver_unregister(&maple_unsupported_device.drv);
 
 cleanup_bus:
 	bus_unregister(&maple_bus_type);
@@ -880,7 +887,7 @@ cleanup_device:
 	device_unregister(&maple_bus);
 
 cleanup:
-	printk(KERN_INFO "Maple bus registration failed\n");
+	printk(KERN_ERR "Maple bus registration failed\n");
 	return retval;
 }
 /* Push init to later to ensure hardware gets detected */
diff --git a/include/linux/maple.h b/include/linux/maple.h
index c23d3f5..d9a51b9 100644
--- a/include/linux/maple.h
+++ b/include/linux/maple.h
@@ -8,33 +8,49 @@ extern struct bus_type maple_bus_type;
 
 /* Maple Bus command and response codes */
 enum maple_code {
-	MAPLE_RESPONSE_FILEERR = -5,
-	MAPLE_RESPONSE_AGAIN = -4,	/* request should be retransmitted */
-	MAPLE_RESPONSE_BADCMD = -3,
-	MAPLE_RESPONSE_BADFUNC = -2,
-	MAPLE_RESPONSE_NONE = -1,	/* unit didn't respond at all */
-	MAPLE_COMMAND_DEVINFO = 1,
-	MAPLE_COMMAND_ALLINFO = 2,
-	MAPLE_COMMAND_RESET = 3,
-	MAPLE_COMMAND_KILL = 4,
-	MAPLE_RESPONSE_DEVINFO = 5,
-	MAPLE_RESPONSE_ALLINFO = 6,
-	MAPLE_RESPONSE_OK = 7,
-	MAPLE_RESPONSE_DATATRF = 8,
-	MAPLE_COMMAND_GETCOND = 9,
-	MAPLE_COMMAND_GETMINFO = 10,
-	MAPLE_COMMAND_BREAD = 11,
-	MAPLE_COMMAND_BWRITE = 12,
-	MAPLE_COMMAND_SETCOND = 14
+	MAPLE_RESPONSE_FILEERR =	-5,
+	MAPLE_RESPONSE_AGAIN,	/* retransmit */
+	MAPLE_RESPONSE_BADCMD,
+	MAPLE_RESPONSE_BADFUNC,
+	MAPLE_RESPONSE_NONE,	/* unit didn't respond*/
+	MAPLE_COMMAND_DEVINFO =		1,
+	MAPLE_COMMAND_ALLINFO,
+	MAPLE_COMMAND_RESET,
+	MAPLE_COMMAND_KILL,
+	MAPLE_RESPONSE_DEVINFO,
+	MAPLE_RESPONSE_ALLINFO,
+	MAPLE_RESPONSE_OK,
+	MAPLE_RESPONSE_DATATRF,
+	MAPLE_COMMAND_GETCOND,
+	MAPLE_COMMAND_GETMINFO,
+	MAPLE_COMMAND_BREAD,
+	MAPLE_COMMAND_BWRITE,
+	MAPLE_COMMAND_BSYNC,
+	MAPLE_COMMAND_SETCOND,
+	MAPLE_COMMAND_MICCONTROL
+};
+
+enum maple_file_errors {
+	MAPLE_FILEERR_INVALID_PARTITION =	0x01000000,
+	MAPLE_FILEERR_PHASE_ERROR =		0x02000000,
+	MAPLE_FILEERR_INVALID_BLOCK =		0x04000000,
+	MAPLE_FILEERR_WRITE_ERROR =		0x08000000,
+	MAPLE_FILEERR_INVALID_WRITE_LENGTH =	0x10000000,
+	MAPLE_FILEERR_BAD_CRC = 		0x20000000
+};
+
+struct maple_buffer {
+	char bufx[0x400];
+	void *buf;
 };
 
 struct mapleq {
 	struct list_head list;
 	struct maple_device *dev;
-	void *sendbuf, *recvbuf, *recvbufdcsp;
+	struct maple_buffer *recvbuf;
+	void *sendbuf, *recvbuf_p2;
 	unsigned char length;
 	enum maple_code command;
-	struct mutex mutex;
 };
 
 struct maple_devinfo {
@@ -52,11 +68,15 @@ struct maple_device {
 	struct maple_driver *driver;
 	struct mapleq *mq;
 	void (*callback) (struct mapleq * mq);
+	void (*fileerr_handler)(struct maple_device *mdev, void *recvbuf);
+	int (*can_unload)(struct maple_device *mdev);
 	unsigned long when, interval, function;
 	struct maple_devinfo devinfo;
 	unsigned char port, unit;
 	char product_name[32];
 	char product_licence[64];
+	atomic_t busy;
+	wait_queue_head_t maple_wait;
 	struct device dev;
 };
 
@@ -72,7 +92,7 @@ void maple_getcond_callback(struct maple_device *dev,
 int maple_driver_register(struct maple_driver *);
 void maple_driver_unregister(struct maple_driver *);
 
-int maple_add_packet_sleeps(struct maple_device *mdev, u32 function,
+int maple_add_packet(struct maple_device *mdev, u32 function,
 	u32 command, u32 length, void *data);
 void maple_clear_dev(struct maple_device *mdev);
 


