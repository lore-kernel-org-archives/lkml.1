Return-Path: <linux-kernel-owner+w=401wt.eu-S936710AbYCSVyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936710AbYCSVyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbYCSUVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:21:25 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:40638 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932415AbYCSUVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:21:22 -0400
X-Greylist: delayed 2160 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 16:21:18 EDT
X-Trace: 679567827/mk-filter-1.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQFADPk30dRAVlC/2dsb2JhbACBWqdugg8
Subject: [PATCH] 1/2 Maple: Update bus driver to allow support of VMU device
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: dwmw2@infradead.org, Greg KH <greg@kroah.com>,
       Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>,
       linux-mtd@vger.kernel.org
In-Reply-To: <1205879413.6250.13.camel@localhost.localdomain>
References: <1205879413.6250.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 22:49:14 +0000
Message-Id: <1205880554.6250.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches update the maple bus driver with a semaphore to allow
other maple drivers to inject arbitrary packets (eg block reads and
writes) into the maple bus packet stream - so allowing support for the
VMU (and, eventually, other maple devices).

The patches also ensure that the maple bus driver properly supports the
device model through probing.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 617efb1..57a118a 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -47,13 +47,14 @@ static LIST_HEAD(maple_waitq);
 static LIST_HEAD(maple_sentq);
 
 static DEFINE_MUTEX(maple_list_lock);
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
@@ -135,9 +136,9 @@ static void maple_release_device(struct device *dev)
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
 
@@ -147,17 +148,21 @@ static struct mapleq *maple_allocq(struct maple_device *mdev)
 
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
+	init_MUTEX(&mq->sem);
 
 	return mq;
+
+failed_p2:
+	kfree(mq);
+failed_nomem:
+	return NULL;
 }
 
 static struct maple_device *maple_alloc_dev(int port, int unit)
@@ -178,7 +183,6 @@ static struct maple_device *maple_alloc_dev(int port, int unit)
 	}
 	mdev->dev.bus = &maple_bus_type;
 	mdev->dev.parent = &maple_bus;
-	mdev->function = 0;
 	return mdev;
 }
 
@@ -216,8 +220,7 @@ static void maple_build_block(struct mapleq *mq)
 	*maple_sendptr++ = PHYSADDR(mq->recvbuf);
 	*maple_sendptr++ =
 	    mq->command | (to << 8) | (from << 16) | (len << 24);
-
-	while (len-- > 0)
+	while (len-- > 0)
 		*maple_sendptr++ = *lsendbuf++;
 }
 
@@ -230,16 +233,24 @@ static void maple_send(void)
 
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
-	list_for_each_entry_safe(mq, nmq, &maple_waitq, list) {
+	mutex_lock(&maple_list_lock);
+	mutex_lock(&maple_wlist_lock);
+ 	list_for_each_entry_safe(mq, nmq, &maple_waitq, list) {
 		maple_build_block(mq);
 		list_move(&mq->list, &maple_sentq);
-		if (maple_packets++ > MAPLE_MAXPACKETS)
+		if (maple_packets++ > MAPLE_MAXPACKETS)
 			break;
 	}
+	mutex_unlock(&maple_wlist_lock);
+	mutex_unlock(&maple_list_lock);
 	if (maple_packets > 0) {
 		for (i = 0; i < (1 << MAPLE_DMA_PAGES); i++)
 			dma_cache_sync(0, maple_sendbuf + i * PAGE_SIZE,
@@ -247,7 +258,8 @@ static void maple_send(void)
 	}
 }
 
-static int attach_matching_maple_driver(struct device_driver *driver,
+/* check if there is a driver registered likely to match this device */
+static int check_matching_maple_driver(struct device_driver *driver,
 					void *devptr)
 {
 	struct maple_driver *maple_drv;
@@ -255,12 +267,8 @@ static int attach_matching_maple_driver(struct device_driver *driver,
 
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
 
@@ -268,11 +276,6 @@ static void maple_detach_driver(struct maple_device *mdev)
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
@@ -328,8 +331,8 @@ static void maple_attach_driver(struct maple_device *mdev)
 			mdev->port, mdev->unit, function);
 
 		matched =
-		    bus_for_each_drv(&maple_bus_type, NULL, mdev,
-				     attach_matching_maple_driver);
+			bus_for_each_drv(&maple_bus_type, NULL, mdev,
+				check_matching_maple_driver);
 
 		if (matched == 0) {
 			/* Driver does not exist yet */
@@ -342,7 +345,7 @@ static void maple_attach_driver(struct maple_device *mdev)
 	}
 	mdev->function = function;
 	mdev->dev.release = &maple_release_device;
-	retval = device_register(&mdev->dev);
+	retval = device_register(&mdev->dev);
 	if (retval) {
 		printk(KERN_INFO
 		"Maple bus: Attempt to register device"
@@ -377,18 +380,20 @@ static int setup_maple_commands(struct device *device, void *ignored)
 
 	if ((maple_dev->interval > 0)
 	    && time_after(jiffies, maple_dev->when)) {
+		if (down_trylock(&maple_dev->mq->sem))
+			return 0;
 		maple_dev->when = jiffies + maple_dev->interval;
 		maple_dev->mq->command = MAPLE_COMMAND_GETCOND;
 		maple_dev->mq->sendbuf = &maple_dev->function;
 		maple_dev->mq->length = 1;
 		maple_add_packet(maple_dev->mq);
-		liststatus++;
 	} else {
 		if (time_after(jiffies, maple_pnp_time)) {
+			if (down_trylock(&maple_dev->mq->sem))
+				return -1;
 			maple_dev->mq->command = MAPLE_COMMAND_DEVINFO;
 			maple_dev->mq->length = 0;
 			maple_add_packet(maple_dev->mq);
-			liststatus++;
 		}
 	}
 
@@ -398,32 +403,38 @@ static int setup_maple_commands(struct device *device, void *ignored)
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
+	mutex_lock(&maple_wlist_lock);
+	if (!list_empty(&maple_waitq) && list_empty(&maple_sentq)) {
+		mutex_unlock(&maple_wlist_lock);
+		mutex_lock(&maple_list_lock);
 		INIT_LIST_HEAD(&maple_sentq);
+		mutex_unlock(&maple_list_lock);
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
@@ -437,9 +448,15 @@ static void maple_map_subunits(struct maple_device *mdev, int submask)
 			mdev_add = maple_alloc_dev(mdev->port, k + 1);
 			if (!mdev_add)
 				return;
+			locking = down_trylock(&mdev_add->mq->sem);
+			if (locking) {
+				up(&mdev_add->mq->sem);
+				down_interruptible(&mdev_add->mq->sem);
+			}
 			mdev_add->mq->command = MAPLE_COMMAND_DEVINFO;
 			mdev_add->mq->length = 0;
 			maple_add_packet(mdev_add->mq);
+			/* mark that we are checking sub devices */
 			scanning = 1;
 		}
 		submask = submask >> 1;
@@ -512,15 +529,17 @@ static void maple_dma_handler(struct work_struct *work)
 	struct maple_device *dev;
 	char *recvbuf;
 	enum maple_code code;
-	int i;
+	int i, locking;
 
 	if (!maple_dma_done())
 		return;
 	ctrl_outl(0, MAPLE_ENABLE);
+	mutex_lock(&maple_list_lock);
 	if (!list_empty(&maple_sentq)) {
 		list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
 			recvbuf = mq->recvbuf;
 			code = recvbuf[0];
+			up(&mq->sem);
 			dev = mq->dev;
 			switch (code) {
 			case MAPLE_RESPONSE_NONE:
@@ -559,18 +578,26 @@ static void maple_dma_handler(struct work_struct *work)
 			}
 		}
 		INIT_LIST_HEAD(&maple_sentq);
+		mutex_unlock(&maple_list_lock);
+		/* if scanning is 1 then we have subdevices to check */
 		if (scanning == 1) {
 			maple_send();
 			scanning = 2;
 		} else
 			scanning = 0;
-
+		/*check if we have actually tested all ports yet */
 		if (!fullscan) {
 			fullscan = 1;
 			for (i = 0; i < MAPLE_PORTS; i++) {
 				if (checked[i] == false) {
 					fullscan = 0;
 					dev = baseunits[i];
+					locking = down_trylock(&dev->mq->sem);
+					if (locking) {
+						up(&dev->mq->sem);
+						down_interruptible
+							(&dev->mq->sem);
+					}
 					dev->mq->command =
 						MAPLE_COMMAND_DEVINFO;
 					dev->mq->length = 0;
@@ -578,8 +605,11 @@ static void maple_dma_handler(struct work_struct *work)
 				}
 			}
 		}
+		/* mark that we have been through the first scan */
 		if (started == 0)
 			started = 1;
+	} else {
+		mutex_unlock(&maple_list_lock);
 	}
 	maplebus_dma_reset();
 }
@@ -631,7 +661,7 @@ static int match_maple_bus_driver(struct device *devptr,
 	if (maple_dev->devinfo.function == 0xFFFFFFFF)
 		return 0;
 	else if (maple_dev->devinfo.function &
-		 be32_to_cpu(maple_drv->function))
+		 cpu_to_be32(maple_drv->function))
 		return 1;
 	return 0;
 }
@@ -713,6 +743,8 @@ static int __init maple_bus_init(void)
 	if (!maple_queue_cache)
 		goto cleanup_bothirqs;
 
+	INIT_LIST_HEAD(&maple_waitq);
+
 	/* setup maple ports */
 	for (i = 0; i < MAPLE_PORTS; i++) {
 		checked[i] = false;
@@ -723,6 +755,7 @@ static int __init maple_bus_init(void)
 				maple_free_dev(mdev[i]);
 			goto cleanup_cache;
 		}
+		down_interruptible(&mdev[i]->mq->sem);
 		mdev[i]->mq->command = MAPLE_COMMAND_DEVINFO;
 		mdev[i]->mq->length = 0;
 		maple_add_packet(mdev[i]->mq);
diff --git a/include/linux/maple.h b/include/linux/maple.h
index d31e36e..e40142e 100644
--- a/include/linux/maple.h
+++ b/include/linux/maple.h
@@ -33,6 +33,7 @@ struct mapleq {
 	void *sendbuf, *recvbuf, *recvbufdcsp;
 	unsigned char length;
 	enum maple_code command;
+	struct semaphore sem;
 };
 
 struct maple_devinfo {
@@ -73,6 +74,7 @@ void maple_getcond_callback(struct maple_device *dev,
 int maple_driver_register(struct device_driver *drv);
 void maple_add_packet(struct mapleq *mq);
 
+
 #define to_maple_dev(n) container_of(n, struct maple_device, dev)
 #define to_maple_driver(n) container_of(n, struct maple_driver, drv)
 

