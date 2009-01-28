Return-Path: <linux-kernel-owner+w=401wt.eu-S1765587AbZA2AdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765587AbZA2AdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbZA2AAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:00:54 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:41909 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759984AbZA2AAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:00:49 -0500
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2009 19:00:46 EST
X-Trace: 135314522/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAPJ/gElQLLDG/2dsb2JhbACBbsl8hUcG
X-IronPort-AV: E=Sophos;i="4.37,340,1231113600"; 
   d="scan'208";a="135314522"
Subject: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and
 clean up maple bus driver (1/3)
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       linux-mtd <linux-mtd@vger.kernel.org>
In-Reply-To: <1233186456.6734.16.camel@localhost.localdomain>
References: <1233186456.6734.16.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 23:57:49 +0000
Message-Id: <1233187069.6734.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the maple bus driver to support block reads and writes, while
also cleaning up the code and aiming for a consistent namespace for
functions.

Changes to the maple.h header file to support block reads and writes.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 63f0de2..4d9b8b3 100644
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
@@ -97,7 +92,7 @@ void maple_driver_unregister(struct maple_driver *drv)
 EXPORT_SYMBOL_GPL(maple_driver_unregister);
 
 /* set hardware registers to enable next round of dma */
-static void maplebus_dma_reset(void)
+static void maple_dma_reset(void)
 {
 	ctrl_outl(MAPLE_MAGIC, MAPLE_RESET);
 	/* set trig type to 0 for software trigger, 1 for hardware (VBLANK) */
@@ -134,21 +129,16 @@ static void maple_release_device(struct device *dev)
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
@@ -158,68 +148,12 @@ static void maple_release_device(struct device *dev)
 int maple_add_packet(struct maple_device *mdev, u32 function, u32 command,
 	size_t length, void *data)
 {
-	int locking, ret = 0;
-	void *sendbuf = NULL;
-
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
-	if (length) {
-		sendbuf = kmalloc(length * 4, GFP_KERNEL);
-		if (!sendbuf) {
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
+	int ret = 0;
+	void *sendbuf;
 
+	sendbuf = kzalloc(length * 4, GFP_KERNEL);
 	if (length) {
-		sendbuf = kmalloc(length * 4, GFP_KERNEL);
 		if (!sendbuf) {
-			mutex_unlock(&mdev->mq->mutex);
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -233,38 +167,33 @@ int maple_add_packet_sleeps(struct maple_device *mdev, u32 function,
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
+	mq->recvbuf->buf = (void *)P2SEGADDR(&((mq->recvbuf->bufx)[0]));
 
 	return mq;
 
 failed_p2:
 	kfree(mq);
 failed_nomem:
+	printk(KERN_INFO "maple: could not allocate memory\n");
 	return NULL;
 }
 
@@ -272,12 +201,16 @@ static struct maple_device *maple_alloc_dev(int port, int unit)
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
@@ -286,19 +219,18 @@ static struct maple_device *maple_alloc_dev(int port, int unit)
 	}
 	mdev->dev.bus = &maple_bus_type;
 	mdev->dev.parent = &maple_bus;
+	init_waitqueue_head(&mdev->maple_wait);
+	mdev->busy = 0;
+	mdev->callback = NULL;
+	mdev->canunload = NULL;
+	mdev->fileerrhandler = NULL;
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
 
@@ -320,7 +252,7 @@ static void maple_build_block(struct mapleq *mq)
 	maple_lastptr = maple_sendptr;
 
 	*maple_sendptr++ = (port << 16) | len | 0x80000000;
-	*maple_sendptr++ = PHYSADDR(mq->recvbuf);
+	*maple_sendptr++ = PHYSADDR(mq->recvbuf->buf);
 	*maple_sendptr++ =
 	    mq->command | (to << 8) | (from << 16) | (len << 24);
 	while (len-- > 0)
@@ -333,20 +265,28 @@ static void maple_send(void)
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
@@ -356,10 +296,13 @@ static void maple_send(void)
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
@@ -374,10 +317,7 @@ static int check_matching_maple_driver(struct device_driver *driver,
 
 static void maple_detach_driver(struct maple_device *mdev)
 {
-	if (!mdev)
-		return;
 	device_unregister(&mdev->dev);
-	mdev = NULL;
 }
 
 /* process initial MAPLE_COMMAND_DEVINFO for each device or port */
@@ -385,9 +325,9 @@ static void maple_attach_driver(struct maple_device *mdev)
 {
 	char *p, *recvbuf;
 	unsigned long function;
-	int matched, retval;
+	int matched;
 
-	recvbuf = mdev->mq->recvbuf;
+	recvbuf = mdev->mq->recvbuf->buf;
 	/* copy the data as individual elements in
 	* case of memory optimisation */
 	memcpy(&mdev->devinfo.function, recvbuf + 4, 4);
@@ -423,7 +363,7 @@ static void maple_attach_driver(struct maple_device *mdev)
 	if (function > 0x200) {
 		/* Do this silently - as not a real device */
 		function = 0;
-		mdev->driver = &maple_dummy_driver;
+		mdev->driver = &maple_unsupported_device;
 		sprintf(mdev->dev.bus_id, "%d:0.port", mdev->port);
 	} else {
 		printk(KERN_INFO
@@ -432,24 +372,25 @@ static void maple_attach_driver(struct maple_device *mdev)
 
 		matched =
 			bus_for_each_drv(&maple_bus_type, NULL, mdev,
-				check_matching_maple_driver);
+				maple_check_matching_driver);
 
 		if (matched == 0) {
 			/* Driver does not exist yet */
 			printk(KERN_INFO
 				"No maple driver found.\n");
-			mdev->driver = &maple_dummy_driver;
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
+
+	if (device_register(&mdev->dev)) {
 		printk(KERN_INFO
-		"Maple bus: Attempt to register device"
-		" (%x, %x) failed.\n",
+			"Maple bus: Attempt to register device"
+			" (%x, %x) failed.\n",
 		mdev->port, mdev->unit);
 		maple_free_dev(mdev);
 		mdev = NULL;
@@ -462,7 +403,7 @@ static void maple_attach_driver(struct maple_device *mdev)
  * port and unit then return 1 - allows identification
  * of which devices need to be attached or detached
  */
-static int detach_maple_device(struct device *device, void *portptr)
+static int check_maple_device(struct device *device, void *portptr)
 {
 	struct maple_device_specify *ds;
 	struct maple_device *mdev;
@@ -477,21 +418,25 @@ static int detach_maple_device(struct device *device, void *portptr)
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
+	if ((mdev->interval > 0)
+	    && time_after(jiffies, mdev->when)) {
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
+			if (mdev->busy == 0) {
+				mdev->busy = 1;
+				maple_add_packet(mdev, 0,
+					MAPLE_COMMAND_DEVINFO, 0, NULL);
+			}
 	}
 	return 0;
 }
@@ -499,29 +444,50 @@ static int setup_maple_commands(struct device *device, void *ignored)
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
+				mdev->busy = 1;
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
@@ -533,7 +499,7 @@ static void maple_map_subunits(struct maple_device *mdev, int submask)
 		ds.unit = k + 1;
 		retval =
 		    bus_for_each_dev(&maple_bus_type, NULL, &ds,
-				     detach_maple_device);
+				     check_maple_device);
 		if (retval) {
 			submask = submask >> 1;
 			continue;
@@ -543,6 +509,7 @@ static void maple_map_subunits(struct maple_device *mdev, int submask)
 			mdev_add = maple_alloc_dev(mdev->port, k + 1);
 			if (!mdev_add)
 				return;
+			mdev_add->busy = 1;
 			maple_add_packet(mdev_add, 0, MAPLE_COMMAND_DEVINFO,
 				0, NULL);
 			/* mark that we are checking sub devices */
@@ -564,27 +531,46 @@ static void maple_clean_submap(struct maple_device *mdev)
 }
 
 /* handle empty port or hotplug removal */
-static void maple_response_none(struct maple_device *mdev,
-				struct mapleq *mq)
+static void maple_response_none(struct maple_device *mdev)
 {
-	if (mdev->unit != 0) {
-		list_del(&mq->list);
-		maple_clean_submap(mdev);
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
+		if (mdev->canunload) {
+			if (!mdev->canunload(mdev)) {
+				mdev->busy = 2;
+				wake_up(&mdev->maple_wait);
+				return;
+			}
+		}
+
 		printk(KERN_INFO
-		       "Maple bus device detaching at (%d, %d)\n",
-		       mdev->port, mdev->unit);
+			"Maple bus device detaching at (%d, %d)\n",
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
+				printk(KERN_INFO "No maple devices attached"
+					" to port %d\n", mdev->port);
+			}
+			return;
 		}
-		return;
 	}
-	maple_clean_submap(mdev);
+	/* Some hardware devices generate false detach messages on unit 0 */
+	mdev->busy = 0;
 }
 
 /* preprocess hotplugs or scans */
@@ -599,8 +585,11 @@ static void maple_response_devinfo(struct maple_device *mdev,
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
@@ -611,6 +600,16 @@ static void maple_response_devinfo(struct maple_device *mdev,
 	}
 }
 
+static void maple_response_fileerr(struct maple_device *mdev, void *recvbuf)
+{
+	if (mdev->fileerrhandler) {
+		mdev->fileerrhandler(mdev, recvbuf);
+		return;
+	} else
+		printk(KERN_INFO "maple: device (%d, %d) reports file error %d\n",
+			mdev->port, mdev->unit, ((int *)recvbuf)[1]);
+}
+
 static void maple_port_rescan(void)
 {
 	int i;
@@ -621,12 +620,6 @@ static void maple_port_rescan(void)
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
@@ -637,7 +630,7 @@ static void maple_port_rescan(void)
 static void maple_dma_handler(struct work_struct *work)
 {
 	struct mapleq *mq, *nmq;
-	struct maple_device *dev;
+	struct maple_device *mdev;
 	char *recvbuf;
 	enum maple_code code;
 
@@ -646,43 +639,53 @@ static void maple_dma_handler(struct work_struct *work)
 	ctrl_outl(0, MAPLE_ENABLE);
 	if (!list_empty(&maple_sentq)) {
 		list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
-			recvbuf = mq->recvbuf;
+			recvbuf = mq->recvbuf->buf;
 			code = recvbuf[0];
-			dev = mq->dev;
+			mdev = mq->dev;
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
+				mdev->busy = 0;
 				break;
 
 			case MAPLE_RESPONSE_DATATRF:
-				if (dev->callback)
-					dev->callback(mq);
+				if (mdev->callback)
+					mdev->callback(mq);
+				mdev->busy = 0;
+				wake_up(&mdev->maple_wait);
 				break;
 
 			case MAPLE_RESPONSE_FILEERR:
+				maple_response_fileerr(mdev, recvbuf);
+				mdev->busy = 0;
+				wake_up(&mdev->maple_wait);
+				break;
+
 			case MAPLE_RESPONSE_AGAIN:
 			case MAPLE_RESPONSE_BADCMD:
 			case MAPLE_RESPONSE_BADFUNC:
-				printk(KERN_DEBUG
+				printk(KERN_INFO
 				       "Maple non-fatal error 0x%X\n",
 				       code);
+				mdev->busy = 0;
 				break;
 
 			case MAPLE_RESPONSE_ALLINFO:
-				printk(KERN_DEBUG
+				printk(KERN_INFO
 				       "Maple - extended device information"
 					" not supported\n");
+				mdev->busy = 0;
 				break;
 
 			case MAPLE_RESPONSE_OK:
+				mdev->busy = 0;
+				wake_up(&mdev->maple_wait);
 				break;
 
 			default:
@@ -699,20 +702,19 @@ static void maple_dma_handler(struct work_struct *work)
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
@@ -720,14 +722,14 @@ static irqreturn_t maplebus_vblank_interrupt(int irq, void *dev_id)
 
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
@@ -740,7 +742,7 @@ static int maple_get_dma_buffer(void)
 	return 0;
 }
 
-static int match_maple_bus_driver(struct device *devptr,
+static int maple_match_bus_driver(struct device *devptr,
 				  struct device_driver *drvptr)
 {
 	struct maple_driver *maple_drv = to_maple_driver(drvptr);
@@ -765,16 +767,18 @@ static void maple_bus_release(struct device *dev)
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
@@ -788,7 +792,8 @@ static int __init maple_bus_init(void)
 {
 	int retval, i;
 	struct maple_device *mdev[MAPLE_PORTS];
-	ctrl_outl(0, MAPLE_STATE);
+
+	ctrl_outl(0, MAPLE_ENABLE);
 
 	retval = device_register(&maple_bus);
 	if (retval)
@@ -798,7 +803,7 @@ static int __init maple_bus_init(void)
 	if (retval)
 		goto cleanup_device;
 
-	retval = driver_register(&maple_dummy_driver.drv);
+	retval = driver_register(&maple_unsupported_device.drv);
 	if (retval)
 		goto cleanup_bus;
 
@@ -825,9 +830,7 @@ static int __init maple_bus_init(void)
 		goto cleanup_irq;
 	}
 
-	maple_queue_cache =
-	    kmem_cache_create("maple_queue_cache", 0x400, 0,
-			      SLAB_HWCACHE_ALIGN, NULL);
+	maple_queue_cache = KMEM_CACHE(maple_buffer, SLAB_HWCACHE_ALIGN);
 
 	if (!maple_queue_cache)
 		goto cleanup_bothirqs;
@@ -838,6 +841,7 @@ static int __init maple_bus_init(void)
 	/* setup maple ports */
 	for (i = 0; i < MAPLE_PORTS; i++) {
 		checked[i] = false;
+		empty[i] = false;
 		mdev[i] = maple_alloc_dev(i, 0);
 		baseunits[i] = mdev[i];
 		if (!mdev[i]) {
@@ -845,15 +849,14 @@ static int __init maple_bus_init(void)
 				maple_free_dev(mdev[i]);
 			goto cleanup_cache;
 		}
+		mdev[i]->busy = 1;
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
 	printk(KERN_INFO "Maple bus core now registered.\n");
 
 	return 0;
@@ -871,7 +874,7 @@ cleanup_dma:
 	free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
 
 cleanup_basic:
-	driver_unregister(&maple_dummy_driver.drv);
+	driver_unregister(&maple_unsupported_device.drv);
 
 cleanup_bus:
 	bus_unregister(&maple_bus_type);
diff --git a/include/linux/maple.h b/include/linux/maple.h
index c23d3f5..7852e8e 100644
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
+	MAPLE_RESPONSE_AGAIN =		-4,	/* retransmit */
+	MAPLE_RESPONSE_BADCMD =		-3,
+	MAPLE_RESPONSE_BADFUNC =	-2,
+	MAPLE_RESPONSE_NONE =		-1,	/* unit didn't respond*/
+	MAPLE_COMMAND_DEVINFO =		1,
+	MAPLE_COMMAND_ALLINFO =		2,
+	MAPLE_COMMAND_RESET =		3,
+	MAPLE_COMMAND_KILL =		4,
+	MAPLE_RESPONSE_DEVINFO =	5,
+	MAPLE_RESPONSE_ALLINFO =	6,
+	MAPLE_RESPONSE_OK =		7,
+	MAPLE_RESPONSE_DATATRF =	8,
+	MAPLE_COMMAND_GETCOND =		9,
+	MAPLE_COMMAND_GETMINFO = 	10,
+	MAPLE_COMMAND_BREAD = 		11,
+	MAPLE_COMMAND_BWRITE =		12,
+	MAPLE_COMMAND_BSYNC =		13,
+	MAPLE_COMMAND_SETCOND = 	14,
+	MAPLE_COMMAND_MICCONTROL =	15
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
+	void (*fileerrhandler)(struct maple_device * mdev, void * recvbuf);
+	int (*canunload)(struct maple_device * mdev);
 	unsigned long when, interval, function;
 	struct maple_devinfo devinfo;
 	unsigned char port, unit;
 	char product_name[32];
 	char product_licence[64];
+	int busy;
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
 


