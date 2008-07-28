Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYG1Xoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYG1Xoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYG1Xop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:44:45 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:2222 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbYG1Xoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:44:44 -0400
X-Trace: 50612474/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/81.1.72.79
X-SBRS: None
X-RemoteIP: 81.1.72.79
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAGT2jUhRAUhP/2dsb2JhbACBW65U
X-IronPort-AV: E=Sophos;i="4.31,268,1215385200"; 
   d="scan'208";a="50612474"
Subject: [PATCH] sh/maple: clean maple bus code
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>, linux-sh <linux-sh@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 00:44:16 +0100
Message-Id: <1217288656.6875.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the handling of the maple bus queue to remove
the risk of races when adding packets. It also removes references to the
redundant connect and disconnect functions.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff -ruNp a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
--- a/drivers/sh/maple/maple.c	2008-07-29 00:17:29.000000000 +0100
+++ b/drivers/sh/maple/maple.c	2008-07-28 22:18:36.000000000 +0100
@@ -46,14 +46,15 @@ static DECLARE_WORK(maple_vblank_process
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
@@ -129,35 +130,124 @@ static void maple_release_device(struct 
 	kfree(mdev);
 }
 
-/**
+/*
  * maple_add_packet - add a single instruction to the queue
- * @mq: instruction to add to waiting queue
+ * @mdev - maple device
+ * @function - function on device being queried
+ * @command - maple command to add
+ * @length - length of command string (in 32 bit words)
+ * @data - remainder of command string
  */
-void maple_add_packet(struct mapleq *mq)
+int maple_add_packet(struct maple_device *mdev, u32 function, u32 command,
+	size_t length, void *data)
 {
-	mutex_lock(&maple_list_lock);
-	list_add(&mq->list, &maple_waitq);
-	mutex_unlock(&maple_list_lock);
+	int locking, ret = 0;
+	void *sendbuf = NULL;
+
+	mutex_lock(&maple_wlist_lock);
+	/* bounce if device already locked */
+	locking = mutex_is_locked(&mdev->mq->mutex);
+	if (locking) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	mutex_lock(&mdev->mq->mutex);
+
+	if (length) {
+		sendbuf = kmalloc(length * 4, GFP_KERNEL);
+		if (!sendbuf) {
+			mutex_unlock(&mdev->mq->mutex);
+			ret = -ENOMEM;
+			goto out;
+		}
+		((__be32 *)sendbuf)[0] = cpu_to_be32(function);
+	}
+
+	mdev->mq->command = command;
+	mdev->mq->length = length;
+	if (length > 1)
+		memcpy(sendbuf + 4, data, (length - 1) * 4);
+	mdev->mq->sendbuf = sendbuf;
+
+	list_add(&mdev->mq->list, &maple_waitq);
+out:
+	mutex_unlock(&maple_wlist_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(maple_add_packet);
 
+/*
+ * maple_add_packet_sleeps - add a single instruction to the queue
+ *  - waits for lock to be free
+ * @mdev - maple device
+ * @function - function on device being queried
+ * @command - maple command to add
+ * @length - length of command string (in 32 bit words)
+ * @data - remainder of command string
+ */
+int maple_add_packet_sleeps(struct maple_device *mdev, u32 function,
+	u32 command, size_t length, void *data)
+{
+	int locking, ret = 0;
+	void *sendbuf = NULL;
+
+	locking = mutex_lock_interruptible(&mdev->mq->mutex);
+	if (locking) {
+		ret = -EIO;
+		goto out;
+	}
+
+	if (length) {
+		sendbuf = kmalloc(length * 4, GFP_KERNEL);
+		if (!sendbuf) {
+			mutex_unlock(&mdev->mq->mutex);
+			ret = -ENOMEM;
+			goto out;
+		}
+		((__be32 *)sendbuf)[0] = cpu_to_be32(function);
+	}
+
+	mdev->mq->command = command;
+	mdev->mq->length = length;
+	if (length > 1)
+		memcpy(sendbuf + 4, data, (length - 1) * 4);
+	mdev->mq->sendbuf = sendbuf;
+
+	mutex_lock(&maple_wlist_lock);
+	list_add(&mdev->mq->list, &maple_waitq);
+	mutex_unlock(&maple_wlist_lock);
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(maple_add_packet_sleeps);
+
 static struct mapleq *maple_allocq(struct maple_device *mdev)
 {
 	struct mapleq *mq;
 
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
+	/*
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
@@ -178,7 +268,6 @@ static struct maple_device *maple_alloc_
 	}
 	mdev->dev.bus = &maple_bus_type;
 	mdev->dev.parent = &maple_bus;
-	mdev->function = 0;
 	return mdev;
 }
 
@@ -216,7 +305,6 @@ static void maple_build_block(struct map
 	*maple_sendptr++ = PHYSADDR(mq->recvbuf);
 	*maple_sendptr++ =
 	    mq->command | (to << 8) | (from << 16) | (len << 24);
-
 	while (len-- > 0)
 		*maple_sendptr++ = *lsendbuf++;
 }
@@ -224,22 +312,27 @@ static void maple_build_block(struct map
 /* build up command queue */
 static void maple_send(void)
 {
-	int i;
-	int maple_packets;
+	int i, maple_packets = 0;
 	struct mapleq *mq, *nmq;
 
 	if (!list_empty(&maple_sentq))
 		return;
-	if (list_empty(&maple_waitq) || !maple_dma_done())
+	mutex_lock(&maple_wlist_lock);
+	if (list_empty(&maple_waitq) || !maple_dma_done()) {
+		mutex_unlock(&maple_wlist_lock);
 		return;
-	maple_packets = 0;
-	maple_sendptr = maple_lastptr = maple_sendbuf;
+	}
+	mutex_unlock(&maple_wlist_lock);
+	maple_lastptr = maple_sendbuf;
+	maple_sendptr = maple_sendbuf;
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
@@ -247,7 +340,8 @@ static void maple_send(void)
 	}
 }
 
-static int attach_matching_maple_driver(struct device_driver *driver,
+/* check if there is a driver registered likely to match this device */
+static int check_matching_maple_driver(struct device_driver *driver,
 					void *devptr)
 {
 	struct maple_driver *maple_drv;
@@ -255,12 +349,8 @@ static int attach_matching_maple_driver(
 
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
 
@@ -268,11 +358,6 @@ static void maple_detach_driver(struct m
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
@@ -328,8 +413,8 @@ static void maple_attach_driver(struct m
 			mdev->port, mdev->unit, function);
 
 		matched =
-		    bus_for_each_drv(&maple_bus_type, NULL, mdev,
-				     attach_matching_maple_driver);
+			bus_for_each_drv(&maple_bus_type, NULL, mdev,
+				check_matching_maple_driver);
 
 		if (matched == 0) {
 			/* Driver does not exist yet */
@@ -373,45 +458,48 @@ static int detach_maple_device(struct de
 
 static int setup_maple_commands(struct device *device, void *ignored)
 {
+	int add;
 	struct maple_device *maple_dev = to_maple_dev(device);
 
 	if ((maple_dev->interval > 0)
 	    && time_after(jiffies, maple_dev->when)) {
-		maple_dev->when = jiffies + maple_dev->interval;
-		maple_dev->mq->command = MAPLE_COMMAND_GETCOND;
-		maple_dev->mq->sendbuf = &maple_dev->function;
-		maple_dev->mq->length = 1;
-		maple_add_packet(maple_dev->mq);
-		liststatus++;
+		/* bounce if we cannot lock */
+		add = maple_add_packet(maple_dev,
+			be32_to_cpu(maple_dev->devinfo.function),
+			MAPLE_COMMAND_GETCOND, 1, NULL);
+		if (!add)
+			maple_dev->when = jiffies + maple_dev->interval;
 	} else {
-		if (time_after(jiffies, maple_pnp_time)) {
-			maple_dev->mq->command = MAPLE_COMMAND_DEVINFO;
-			maple_dev->mq->length = 0;
-			maple_add_packet(maple_dev->mq);
-			liststatus++;
-		}
+		if (time_after(jiffies, maple_pnp_time))
+			/* This will also bounce */
+			maple_add_packet(maple_dev, 0,
+				MAPLE_COMMAND_DEVINFO, 0, NULL);
 	}
-
 	return 0;
 }
 
 /* VBLANK bottom half - implemented via workqueue */
 static void maple_vblank_handler(struct work_struct *work)
 {
-	if (!maple_dma_done())
-		return;
-	if (!list_empty(&maple_sentq))
+	if (!list_empty(&maple_sentq) || !maple_dma_done())
 		return;
+
 	ctrl_outl(0, MAPLE_ENABLE);
-	liststatus = 0;
+
 	bus_for_each_dev(&maple_bus_type, NULL, NULL,
 			 setup_maple_commands);
+
 	if (time_after(jiffies, maple_pnp_time))
 		maple_pnp_time = jiffies + MAPLE_PNP_INTERVAL;
-	if (liststatus && list_empty(&maple_sentq)) {
-		INIT_LIST_HEAD(&maple_sentq);
+
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
 
@@ -422,8 +510,8 @@ static void maple_map_subunits(struct ma
 	struct maple_device *mdev_add;
 	struct maple_device_specify ds;
 
+	ds.port = mdev->port;
 	for (k = 0; k < 5; k++) {
-		ds.port = mdev->port;
 		ds.unit = k + 1;
 		retval =
 		    bus_for_each_dev(&maple_bus_type, NULL, &ds,
@@ -437,9 +525,9 @@ static void maple_map_subunits(struct ma
 			mdev_add = maple_alloc_dev(mdev->port, k + 1);
 			if (!mdev_add)
 				return;
-			mdev_add->mq->command = MAPLE_COMMAND_DEVINFO;
-			mdev_add->mq->length = 0;
-			maple_add_packet(mdev_add->mq);
+			maple_add_packet(mdev_add, 0, MAPLE_COMMAND_DEVINFO,
+				0, NULL);
+			/* mark that we are checking sub devices */
 			scanning = 1;
 		}
 		submask = submask >> 1;
@@ -505,6 +593,28 @@ static void maple_response_devinfo(struc
 	}
 }
 
+static void maple_port_rescan(void)
+{
+	int i;
+	struct maple_device *mdev;
+
+	fullscan = 1;
+	for (i = 0; i < MAPLE_PORTS; i++) {
+		if (checked[i] == false) {
+			fullscan = 0;
+			mdev = baseunits[i];
+			/*
+			 *  test lock in case scan has failed
+			 *  but device is still locked
+			 */
+			if (mutex_is_locked(&mdev->mq->mutex))
+				mutex_unlock(&mdev->mq->mutex);
+			maple_add_packet(mdev, 0, MAPLE_COMMAND_DEVINFO,
+				0, NULL);
+		}
+	}
+}
+
 /* maple dma end bottom half - implemented via workqueue */
 static void maple_dma_handler(struct work_struct *work)
 {
@@ -512,7 +622,6 @@ static void maple_dma_handler(struct wor
 	struct maple_device *dev;
 	char *recvbuf;
 	enum maple_code code;
-	int i;
 
 	if (!maple_dma_done())
 		return;
@@ -522,6 +631,10 @@ static void maple_dma_handler(struct wor
 			recvbuf = mq->recvbuf;
 			code = recvbuf[0];
 			dev = mq->dev;
+			kfree(mq->sendbuf);
+			mutex_unlock(&mq->mutex);
+			list_del_init(&mq->list);
+
 			switch (code) {
 			case MAPLE_RESPONSE_NONE:
 				maple_response_none(dev, mq);
@@ -558,26 +671,16 @@ static void maple_dma_handler(struct wor
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
@@ -631,7 +734,7 @@ static int match_maple_bus_driver(struct
 	if (maple_dev->devinfo.function == 0xFFFFFFFF)
 		return 0;
 	else if (maple_dev->devinfo.function &
-		 be32_to_cpu(maple_drv->function))
+		 cpu_to_be32(maple_drv->function))
 		return 1;
 	return 0;
 }
@@ -713,19 +816,20 @@ static int __init maple_bus_init(void)
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
 		if (!mdev[i]) {
-			while (i-- > 0)
+			while (i-- > 0)
 				maple_free_dev(mdev[i]);
 			goto cleanup_cache;
 		}
-		mdev[i]->mq->command = MAPLE_COMMAND_DEVINFO;
-		mdev[i]->mq->length = 0;
-		maple_add_packet(mdev[i]->mq);
+		maple_add_packet(mdev[i], 0, MAPLE_COMMAND_DEVINFO, 0, NULL);
 		subdevice_map[i] = 0;
 	}
 
diff -ruNp a/include/linux/maple.h b/include/linux/maple.h
--- a/include/linux/maple.h	2008-07-29 00:17:49.000000000 +0100
+++ b/include/linux/maple.h	2008-07-28 22:19:11.000000000 +0100
@@ -33,6 +33,7 @@ struct mapleq {
 	void *sendbuf, *recvbuf, *recvbufdcsp;
 	unsigned char length;
 	enum maple_code command;
+	struct mutex mutex;
 };
 
 struct maple_devinfo {
@@ -69,7 +70,9 @@ void maple_getcond_callback(struct maple
 			    unsigned long interval,
 			    unsigned long function);
 int maple_driver_register(struct device_driver *drv);
-void maple_add_packet(struct mapleq *mq);
+int maple_add_packet_sleeps(struct maple_device *mdev, u32 function,
+	u32 command, u32 length, void *data);
+void maple_clear_dev(struct maple_device *mdev);
 
 #define to_maple_dev(n) container_of(n, struct maple_device, dev)
 #define to_maple_driver(n) container_of(n, struct maple_driver, drv)




