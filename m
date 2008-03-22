Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbYCVSQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbYCVSQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYCVSQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:16:46 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:33277 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbYCVSQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:16:44 -0400
X-Trace: 681631438/mk-filter-1.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApAFAM/p5EdRAVlC/2dsb2JhbACBW6Y+
Subject: Re: [PATCH] 3/3 maple: update bus driver to support Dreamcast VMU
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>
Cc: dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       Paul Mundt <lethal@users.sourceforge.net>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <1206207805.6324.13.camel@localhost.localdomain>
References: <1206207805.6324.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 18:16:26 +0000
Message-Id: <1206209786.6324.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to allow support of the VMU as well as clean up some of the
horrors that got imported in with the rewrite of the 2.4 driver.

- Adds a mutex to allow packets (eg block reads and writes) to be
injected into the waiting queue with any risk of data corruption.

- Removes unneeded locking of queue of processed packets while properly
locking access to the queue of waiting packets

- Allows proper probing and removal of device drivers rather than
force majure approach based on function supported

- Separate out "rescan" function to make the code easier to read
and maintain.

- properly initialise and clean up waiting and sent queues

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>


---
diff -ruN a/include/linux/maple.h b/include/linux/maple.h
--- a/include/linux/maple.h	2008-03-22 17:26:48.000000000 +0000
+++ b/include/linux/maple.h	2008-03-22 17:21:03.000000000 +0000
@@ -33,6 +33,7 @@
 	void *sendbuf, *recvbuf, *recvbufdcsp;
 	unsigned char length;
 	enum maple_code command;
+	struct mutex mutex;
 };
 
 struct maple_devinfo {
diff -ruN a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
--- a/drivers/sh/maple/maple.c	2008-03-22 17:26:31.000000000 +0000
+++ b/drivers/sh/maple/maple.c	2008-03-22 17:53:50.000000000 +0000
@@ -46,14 +46,15 @@
 static LIST_HEAD(maple_waitq);
 static LIST_HEAD(maple_sentq);
 
-static DEFINE_MUTEX(maple_list_lock);
+/* mutex to protect queue of waiting packets */
+static DEFINE_MUTEX(maple_wlist_lock);
 
 static struct maple_driver maple_dummy_driver;
 static struct device maple_bus;
 static int subdevice_map[MAPLE_PORTS];
 static unsigned long *maple_sendbuf, *maple_sendptr, *maple_lastptr;
 static unsigned long maple_pnp_time;
-static int started, scanning, liststatus, fullscan;
+static int started, scanning, fullscan;
 static struct kmem_cache *maple_queue_cache;
 
 struct maple_device_specify {
@@ -135,9 +136,9 @@
  */
 void maple_add_packet(struct mapleq *mq)
 {
-	mutex_lock(&maple_list_lock);
+	mutex_lock(&maple_wlist_lock);
 	list_add(&mq->list, &maple_waitq);
-	mutex_unlock(&maple_list_lock);
+	mutex_unlock(&maple_wlist_lock);
 }
 EXPORT_SYMBOL_GPL(maple_add_packet);
 
@@ -147,17 +148,26 @@
 
 	mq = kmalloc(sizeof(*mq), GFP_KERNEL);
 	if (!mq)
-		return NULL;
+		goto failed_nomem;
 
 	mq->dev = mdev;
 	mq->recvbufdcsp = kmem_cache_zalloc(maple_queue_cache, GFP_KERNEL);
 	mq->recvbuf = (void *) P2SEGADDR(mq->recvbufdcsp);
-	if (!mq->recvbuf) {
-		kfree(mq);
-		return NULL;
-	}
+	if (!mq->recvbuf)
+		goto failed_p2;
+	/***
+	 * most devices do not need the mutex - but
+	 * anything that injects block reads or writes
+	 * will rely on it
+	 */
+	mutex_init(&mq->mutex);
 
 	return mq;
+
+failed_p2:
+	kfree(mq);
+failed_nomem:
+	return NULL;
 }
 
 static struct maple_device *maple_alloc_dev(int port, int unit)
@@ -178,7 +188,6 @@
 	}
 	mdev->dev.bus = &maple_bus_type;
 	mdev->dev.parent = &maple_bus;
-	mdev->function = 0;
 	return mdev;
 }
 
@@ -216,7 +225,6 @@
 	*maple_sendptr++ = PHYSADDR(mq->recvbuf);
 	*maple_sendptr++ =
 	    mq->command | (to << 8) | (from << 16) | (len << 24);
-
 	while (len-- > 0)
 		*maple_sendptr++ = *lsendbuf++;
 }
@@ -230,16 +238,22 @@
 
 	if (!list_empty(&maple_sentq))
 		return;
-	if (list_empty(&maple_waitq) || !maple_dma_done())
+	mutex_lock(&maple_wlist_lock);
+	if (list_empty(&maple_waitq) || !maple_dma_done()) {
+		mutex_unlock(&maple_wlist_lock);
 		return;
+	}
+	mutex_unlock(&maple_wlist_lock);
 	maple_packets = 0;
 	maple_sendptr = maple_lastptr = maple_sendbuf;
+	mutex_lock(&maple_wlist_lock);
 	list_for_each_entry_safe(mq, nmq, &maple_waitq, list) {
 		maple_build_block(mq);
 		list_move(&mq->list, &maple_sentq);
 		if (maple_packets++ > MAPLE_MAXPACKETS)
 			break;
 	}
+	mutex_unlock(&maple_wlist_lock);
 	if (maple_packets > 0) {
 		for (i = 0; i < (1 << MAPLE_DMA_PAGES); i++)
 			dma_cache_sync(0, maple_sendbuf + i * PAGE_SIZE,
@@ -247,7 +261,8 @@
 	}
 }
 
-static int attach_matching_maple_driver(struct device_driver *driver,
+/* check if there is a driver registered likely to match this device */
+static int check_matching_maple_driver(struct device_driver *driver,
 					void *devptr)
 {
 	struct maple_driver *maple_drv;
@@ -255,12 +270,8 @@
 
 	mdev = devptr;
 	maple_drv = to_maple_driver(driver);
-	if (mdev->devinfo.function & be32_to_cpu(maple_drv->function)) {
-		if (maple_drv->connect(mdev) == 0) {
-			mdev->driver = maple_drv;
-			return 1;
-		}
-	}
+	if (mdev->devinfo.function & cpu_to_be32(maple_drv->function))
+		return 1;
 	return 0;
 }
 
@@ -268,11 +279,6 @@
 {
 	if (!mdev)
 		return;
-	if (mdev->driver) {
-		if (mdev->driver->disconnect)
-			mdev->driver->disconnect(mdev);
-	}
-	mdev->driver = NULL;
 	device_unregister(&mdev->dev);
 	mdev = NULL;
 }
@@ -328,8 +334,8 @@
 			mdev->port, mdev->unit, function);
 
 		matched =
-		    bus_for_each_drv(&maple_bus_type, NULL, mdev,
-				     attach_matching_maple_driver);
+			bus_for_each_drv(&maple_bus_type, NULL, mdev,
+				check_matching_maple_driver);
 
 		if (matched == 0) {
 			/* Driver does not exist yet */
@@ -377,53 +383,62 @@
 
 	if ((maple_dev->interval > 0)
 	    && time_after(jiffies, maple_dev->when)) {
+		/***
+		* Can only queue one command per device at a time
+		* so if cannot aquire the mutex, just return
+		*/
+		if (!mutex_trylock(&maple_dev->mq->mutex))
+			goto setup_finished;
 		maple_dev->when = jiffies + maple_dev->interval;
 		maple_dev->mq->command = MAPLE_COMMAND_GETCOND;
 		maple_dev->mq->sendbuf = &maple_dev->function;
 		maple_dev->mq->length = 1;
 		maple_add_packet(maple_dev->mq);
-		liststatus++;
 	} else {
 		if (time_after(jiffies, maple_pnp_time)) {
+			if (!mutex_trylock(&maple_dev->mq->mutex))
+				goto setup_finished;
 			maple_dev->mq->command = MAPLE_COMMAND_DEVINFO;
 			maple_dev->mq->length = 0;
 			maple_add_packet(maple_dev->mq);
-			liststatus++;
 		}
 	}
-
+setup_finished:
 	return 0;
 }
 
 /* VBLANK bottom half - implemented via workqueue */
 static void maple_vblank_handler(struct work_struct *work)
 {
-	if (!maple_dma_done())
-		return;
 	if (!list_empty(&maple_sentq))
 		return;
+	if (!maple_dma_done())
+		return;
 	ctrl_outl(0, MAPLE_ENABLE);
-	liststatus = 0;
 	bus_for_each_dev(&maple_bus_type, NULL, NULL,
 			 setup_maple_commands);
 	if (time_after(jiffies, maple_pnp_time))
 		maple_pnp_time = jiffies + MAPLE_PNP_INTERVAL;
-	if (liststatus && list_empty(&maple_sentq)) {
-		INIT_LIST_HEAD(&maple_sentq);
+	mutex_lock(&maple_wlist_lock);
+	if (!list_empty(&maple_waitq) && list_empty(&maple_sentq)) {
+		mutex_unlock(&maple_wlist_lock);
 		maple_send();
+	} else {
+		mutex_unlock(&maple_wlist_lock);
 	}
+
 	maplebus_dma_reset();
 }
 
 /* handle devices added via hotplugs - placing them on queue for DEVINFO*/
 static void maple_map_subunits(struct maple_device *mdev, int submask)
 {
-	int retval, k, devcheck;
+	int retval, k, devcheck, locking;
 	struct maple_device *mdev_add;
 	struct maple_device_specify ds;
 
+	ds.port = mdev->port;
 	for (k = 0; k < 5; k++) {
-		ds.port = mdev->port;
 		ds.unit = k + 1;
 		retval =
 		    bus_for_each_dev(&maple_bus_type, NULL, &ds,
@@ -437,9 +452,15 @@
 			mdev_add = maple_alloc_dev(mdev->port, k + 1);
 			if (!mdev_add)
 				return;
+			/* Use trylock again to avoid corrupting
+			* any already queued commands */
+			locking = mutex_trylock(&mdev_add->mq->mutex);
+			if (locking == 0)
+				return;
 			mdev_add->mq->command = MAPLE_COMMAND_DEVINFO;
 			mdev_add->mq->length = 0;
 			maple_add_packet(mdev_add->mq);
+			/* mark that we are checking sub devices */
 			scanning = 1;
 		}
 		submask = submask >> 1;
@@ -505,6 +526,35 @@
 	}
 }
 
+static void maple_port_rescan(void)
+{
+	int i, locking;
+	struct maple_device *mdev;
+
+	fullscan = 1;
+	for (i = 0; i < MAPLE_PORTS; i++) {
+		if (checked[i] == false) {
+			fullscan = 0;
+			mdev = baseunits[i];
+			/**
+			*  Use trylock in case scan has failed
+			*  but device is still locked
+			*/
+			locking = mutex_trylock(&mdev->mq->mutex);
+			if (locking == 0) {
+				mutex_unlock(&mdev->mq->mutex);
+				locking = mutex_lock_interruptible
+					(&mdev->mq->mutex);
+				if (locking)
+					continue;
+			}
+			mdev->mq->command = MAPLE_COMMAND_DEVINFO;
+			mdev->mq->length = 0;
+			maple_add_packet(mdev->mq);
+		}
+	}
+}
+
 /* maple dma end bottom half - implemented via workqueue */
 static void maple_dma_handler(struct work_struct *work)
 {
@@ -512,7 +562,6 @@
 	struct maple_device *dev;
 	char *recvbuf;
 	enum maple_code code;
-	int i;
 
 	if (!maple_dma_done())
 		return;
@@ -521,7 +570,10 @@
 		list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
 			recvbuf = mq->recvbuf;
 			code = recvbuf[0];
+			if (mutex_is_locked(&mq->mutex))
+				mutex_unlock(&mq->mutex);
 			dev = mq->dev;
+			list_del_init(&mq->list);
 			switch (code) {
 			case MAPLE_RESPONSE_NONE:
 				maple_response_none(dev, mq);
@@ -558,26 +610,16 @@
 				break;
 			}
 		}
-		INIT_LIST_HEAD(&maple_sentq);
+		/* if scanning is 1 then we have subdevices to check */
 		if (scanning == 1) {
 			maple_send();
 			scanning = 2;
 		} else
 			scanning = 0;
-
-		if (!fullscan) {
-			fullscan = 1;
-			for (i = 0; i < MAPLE_PORTS; i++) {
-				if (checked[i] == false) {
-					fullscan = 0;
-					dev = baseunits[i];
-					dev->mq->command =
-						MAPLE_COMMAND_DEVINFO;
-					dev->mq->length = 0;
-					maple_add_packet(dev->mq);
-				}
-			}
-		}
+		/*check if we have actually tested all ports yet */
+		if (!fullscan)
+			maple_port_rescan();
+		/* mark that we have been through the first scan */
 		if (started == 0)
 			started = 1;
 	}
@@ -631,7 +673,7 @@
 	if (maple_dev->devinfo.function == 0xFFFFFFFF)
 		return 0;
 	else if (maple_dev->devinfo.function &
-		 be32_to_cpu(maple_drv->function))
+		 cpu_to_be32(maple_drv->function))
 		return 1;
 	return 0;
 }
@@ -713,14 +755,19 @@
 	if (!maple_queue_cache)
 		goto cleanup_bothirqs;
 
+	INIT_LIST_HEAD(&maple_waitq);
+	INIT_LIST_HEAD(&maple_sentq);
+
 	/* setup maple ports */
 	for (i = 0; i < MAPLE_PORTS; i++) {
 		checked[i] = false;
 		mdev[i] = maple_alloc_dev(i, 0);
 		baseunits[i] = mdev[i];
-		if (!mdev[i]) {
-			while (i-- > 0)
+		if (!mdev[i] || mutex_lock_interruptible(&mdev[i]->mq->mutex)) {
+			while (i-- > 0) {
+				mutex_unlock(&mdev[i]->mq->mutex);
 				maple_free_dev(mdev[i]);
+			}
 			goto cleanup_cache;
 		}
 		mdev[i]->mq->command = MAPLE_COMMAND_DEVINFO;


