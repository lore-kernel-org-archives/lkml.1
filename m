Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbYBFWyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbYBFWyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbYBFWyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:54:11 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:34757 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761168AbYBFWyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:54:08 -0500
X-Trace: 662764907/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAFfJqUdRAVlC/2dsb2JhbACBWatNgXY
Subject: [PATCH 2/2] - SH/Dreamcast - fix maple bus bugs
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>,
       Greg KH <greg@kroah.com>
In-Reply-To: <1202337981.6162.8.camel@localhost.localdomain>
References: <1202337981.6162.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 22:53:51 +0000
Message-Id: <1202338431.6162.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes up memory leaks and, by delaying initialisation, makes
device detection more robust.

It also makes clearer the difference between struct maple_device and
struct device, as well as cleaning up the interrupt request code
(without changing its function in any way).

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
----

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 3f341dc..60eeb92 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -30,6 +30,7 @@
 #include <asm/mach/dma.h>
 #include <asm/mach/sysasic.h>
 #include <asm/mach/maple.h>
+#include <linux/delay.h>
 
 MODULE_AUTHOR("Yaegshi Takeshi, Paul Mundt, M.R. Brown, Adrian McMenamin");
 MODULE_DESCRIPTION("Maple bus driver for Dreamcast");
@@ -52,7 +53,7 @@ static struct device maple_bus;
 static int subdevice_map[MAPLE_PORTS];
 static unsigned long *maple_sendbuf, *maple_sendptr, *maple_lastptr;
 static unsigned long maple_pnp_time;
-static int started, scanning, liststatus;
+static int started, scanning, liststatus, realscan;
 static struct kmem_cache *maple_queue_cache;
 
 struct maple_device_specify {
@@ -72,7 +73,6 @@ int maple_driver_register(struct device_driver *drv)
 	drv->bus = &maple_bus_type;
 	return driver_register(drv);
 }
-
 EXPORT_SYMBOL_GPL(maple_driver_register);
 
 /* set hardware registers to enable next round of dma */
@@ -94,15 +94,14 @@ static void maplebus_dma_reset(void)
  * @function: the function code for the device
  */
 void maple_getcond_callback(struct maple_device *dev,
-			    void (*callback) (struct mapleq * mq),
-			    unsigned long interval, unsigned long function)
+			void (*callback) (struct mapleq *mq),
+			unsigned long interval, unsigned long function)
 {
 	dev->callback = callback;
 	dev->interval = interval;
 	dev->function = cpu_to_be32(function);
 	dev->when = jiffies;
 }
-
 EXPORT_SYMBOL_GPL(maple_getcond_callback);
 
 static int maple_dma_done(void)
@@ -112,10 +111,19 @@ static int maple_dma_done(void)
 
 static void maple_release_device(struct device *dev)
 {
-	if (dev->type) {
-		kfree(dev->type->name);
-		kfree(dev->type);
+	struct maple_device *mdev;
+	struct mapleq *mq;
+	if (!dev)
+		return;
+	mdev = to_maple_dev(dev);
+	mq = mdev->mq;
+	if (mq) {
+		if (mq->recvbufdcsp)
+			kmem_cache_free(maple_queue_cache, mq->recvbufdcsp);
+		kfree(mq);
+		mq = NULL;
 	}
+	kfree(mdev);
 }
 
 /**
@@ -128,10 +136,9 @@ void maple_add_packet(struct mapleq *mq)
 	list_add(&mq->list, &maple_waitq);
 	mutex_unlock(&maple_list_lock);
 }
-
 EXPORT_SYMBOL_GPL(maple_add_packet);
 
-static struct mapleq *maple_allocq(struct maple_device *dev)
+static struct mapleq *maple_allocq(struct maple_device *mdev)
 {
 	struct mapleq *mq;
 
@@ -139,7 +146,7 @@ static struct mapleq *maple_allocq(struct maple_device *dev)
 	if (!mq)
 		return NULL;
 
-	mq->dev = dev;
+	mq->dev = mdev;
 	mq->recvbufdcsp = kmem_cache_zalloc(maple_queue_cache, GFP_KERNEL);
 	mq->recvbuf = (void *) P2SEGADDR(mq->recvbufdcsp);
 	if (!mq->recvbuf) {
@@ -152,22 +159,24 @@ static struct mapleq *maple_allocq(struct maple_device *dev)
 
 static struct maple_device *maple_alloc_dev(int port, int unit)
 {
-	struct maple_device *dev;
+	struct maple_device *mdev;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev)
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
 		return NULL;
 
-	dev->port = port;
-	dev->unit = unit;
-	dev->mq = maple_allocq(dev);
+	mdev->port = port;
+	mdev->unit = unit;
+	mdev->mq = maple_allocq(mdev);
 
-	if (!dev->mq) {
-		kfree(dev);
+	if (!mdev->mq) {
+		kfree(mdev);
 		return NULL;
 	}
-
-	return dev;
+	mdev->dev.bus = &maple_bus_type;
+	mdev->dev.parent = &maple_bus;
+	mdev->function = 0;
+	return mdev;
 }
 
 static void maple_free_dev(struct maple_device *mdev)
@@ -175,7 +184,9 @@ static void maple_free_dev(struct maple_device *mdev)
 	if (!mdev)
 		return;
 	if (mdev->mq) {
-		kmem_cache_free(maple_queue_cache, mdev->mq->recvbufdcsp);
+		if (mdev->mq->recvbufdcsp)
+			kmem_cache_free(maple_queue_cache,
+				mdev->mq->recvbufdcsp);
 		kfree(mdev->mq);
 	}
 	kfree(mdev);
@@ -259,80 +270,93 @@ static void maple_detach_driver(struct maple_device *mdev)
 			mdev->driver->disconnect(mdev);
 	}
 	mdev->driver = NULL;
-	if (mdev->registered) {
-		maple_release_device(&mdev->dev);
+	if (mdev->registered)
 		device_unregister(&mdev->dev);
-	}
-	mdev->registered = 0;
-	maple_free_dev(mdev);
+	mdev = NULL;
 }
 
 /* process initial MAPLE_COMMAND_DEVINFO for each device or port */
-static void maple_attach_driver(struct maple_device *dev)
+static void maple_attach_driver(struct maple_device *mdev)
 {
-	char *p;
-
-	char *recvbuf;
+	char *p, *recvbuf;
 	unsigned long function;
 	int matched, retval;
 
-	recvbuf = dev->mq->recvbuf;
-	memcpy(&dev->devinfo, recvbuf + 4, sizeof(dev->devinfo));
-	memcpy(dev->product_name, dev->devinfo.product_name, 30);
-	memcpy(dev->product_licence, dev->devinfo.product_licence, 60);
-	dev->product_name[30] = '\0';
-	dev->product_licence[60] = '\0';
-
-	for (p = dev->product_name + 29; dev->product_name <= p; p--)
+	recvbuf = mdev->mq->recvbuf;
+	/* copy the data as individual elements in
+	* case of memory optimisation */
+	memcpy(&mdev->devinfo.function, recvbuf + 4, 4);
+	memcpy(&mdev->devinfo.function_data[0], recvbuf + 8, 12);
+	memcpy(&mdev->devinfo.area_code, recvbuf + 20, 1);
+	memcpy(&mdev->devinfo.connector_direction, recvbuf + 21, 1);
+	memcpy(&mdev->devinfo.product_name[0], recvbuf + 22, 30);
+	memcpy(&mdev->devinfo.product_licence[0], recvbuf + 52, 60);
+	memcpy(&mdev->devinfo.standby_power, recvbuf + 112, 2);
+	memcpy(&mdev->devinfo.max_power, recvbuf + 114, 2);
+	memcpy(mdev->product_name, mdev->devinfo.product_name, 30);
+	mdev->product_name[30] = '\0';
+	memcpy(mdev->product_licence, mdev->devinfo.product_licence, 60);
+	mdev->product_licence[60] = '\0';
+
+	for (p = mdev->product_name + 29; mdev->product_name <= p; p--)
 		if (*p == ' ')
 			*p = '\0';
 		else
 			break;
-
-	for (p = dev->product_licence + 59; dev->product_licence <= p; p--)
+	for (p = mdev->product_licence + 59; mdev->product_licence <= p; p--)
 		if (*p == ' ')
 			*p = '\0';
 		else
 			break;
 
-	function = be32_to_cpu(dev->devinfo.function);
+	if (realscan) {
+		printk(KERN_INFO "Maple device detected: %s\n",
+			mdev->product_name);
+		printk(KERN_INFO "Maple device: %s\n", mdev->product_licence);
+	}
+
+	function = be32_to_cpu(mdev->devinfo.function);
 
 	if (function > 0x200) {
 		/* Do this silently - as not a real device */
 		function = 0;
-		dev->driver = &maple_dummy_driver;
-		sprintf(dev->dev.bus_id, "%d:0.port", dev->port);
+		mdev->driver = &maple_dummy_driver;
+		sprintf(mdev->dev.bus_id, "%d:0.port", mdev->port);
 	} else {
-		printk(KERN_INFO
-		       "Maple bus at (%d, %d): Connected function 0x%lX\n",
-		       dev->port, dev->unit, function);
+		if (realscan)
+			printk(KERN_INFO
+				"Maple bus at (%d, %d): Function 0x%lX\n",
+				mdev->port, mdev->unit, function);
 
 		matched =
-		    bus_for_each_drv(&maple_bus_type, NULL, dev,
+		    bus_for_each_drv(&maple_bus_type, NULL, mdev,
 				     attach_matching_maple_driver);
 
 		if (matched == 0) {
 			/* Driver does not exist yet */
-			printk(KERN_INFO
-			       "No maple driver found for this device\n");
-			dev->driver = &maple_dummy_driver;
+			if (realscan)
+				printk(KERN_INFO
+					"No maple driver found.\n");
+			mdev->driver = &maple_dummy_driver;
 		}
-
-		sprintf(dev->dev.bus_id, "%d:0%d.%lX", dev->port,
-			dev->unit, function);
+		sprintf(mdev->dev.bus_id, "%d:0%d.%lX", mdev->port,
+			mdev->unit, function);
 	}
-	dev->function = function;
-	dev->dev.bus = &maple_bus_type;
-	dev->dev.parent = &maple_bus;
-	dev->dev.release = &maple_release_device;
-	retval = device_register(&dev->dev);
-	if (retval) {
-		printk(KERN_INFO
-		       "Maple bus: Attempt to register device (%x, %x) failed.\n",
-		       dev->port, dev->unit);
-		maple_free_dev(dev);
+	mdev->function = function;
+	mdev->dev.release = &maple_release_device;
+	if (mdev->registered == 0) {
+		retval = device_register(&mdev->dev);
+		if (retval) {
+			printk(KERN_INFO
+			"Maple bus: Attempt to register device"
+			" (%x, %x) failed.\n",
+			mdev->port, mdev->unit);
+			maple_free_dev(mdev);
+			mdev = NULL;
+			return;
+		}
+		mdev->registered = 1;
 	}
-	dev->registered = 1;
 }
 
 /*
@@ -518,7 +542,8 @@ static void maple_dma_handler(struct work_struct *work)
 
 			case MAPLE_RESPONSE_ALLINFO:
 				printk(KERN_DEBUG
-				       "Maple - extended device information not supported\n");
+				       "Maple - extended device information"
+					" not supported\n");
 				break;
 
 			case MAPLE_RESPONSE_OK:
@@ -554,26 +579,16 @@ static irqreturn_t maplebus_vblank_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction maple_dma_irq = {
-	.name = "maple bus DMA handler",
-	.handler = maplebus_dma_interrupt,
-	.flags = IRQF_SHARED,
-};
-
-static struct irqaction maple_vblank_irq = {
-	.name = "maple bus VBLANK handler",
-	.handler = maplebus_vblank_interrupt,
-	.flags = IRQF_SHARED,
-};
-
 static int maple_set_dma_interrupt_handler(void)
 {
-	return setup_irq(HW_EVENT_MAPLE_DMA, &maple_dma_irq);
+	return request_irq(HW_EVENT_MAPLE_DMA, maplebus_dma_interrupt,
+		IRQF_SHARED, "maple bus DMA", &maple_dummy_driver);
 }
 
 static int maple_set_vblank_interrupt_handler(void)
 {
-	return setup_irq(HW_EVENT_VSYNC, &maple_vblank_irq);
+	return request_irq(HW_EVENT_VSYNC, maplebus_vblank_interrupt,
+		IRQF_SHARED, "maple bus VBLANK", &maple_dummy_driver);
 }
 
 static int maple_get_dma_buffer(void)
@@ -617,7 +632,7 @@ static struct maple_driver maple_dummy_driver = {
 	.drv = {
 		.name = "maple_dummy_driver",
 		.bus = &maple_bus_type,
-		},
+	},
 };
 
 struct bus_type maple_bus_type = {
@@ -625,7 +640,6 @@ struct bus_type maple_bus_type = {
 	.match = match_maple_bus_driver,
 	.uevent = maple_bus_uevent,
 };
-
 EXPORT_SYMBOL_GPL(maple_bus_type);
 
 static struct device maple_bus = {
@@ -677,7 +691,7 @@ static int __init maple_bus_init(void)
 
 	maple_queue_cache =
 	    kmem_cache_create("maple_queue_cache", 0x400, 0,
-			      SLAB_HWCACHE_ALIGN, NULL);
+			      SLAB_POISON|SLAB_HWCACHE_ALIGN, NULL);
 
 	if (!maple_queue_cache)
 		goto cleanup_bothirqs;
@@ -693,47 +707,46 @@ static int __init maple_bus_init(void)
 		mdev[i]->registered = 0;
 		mdev[i]->mq->command = MAPLE_COMMAND_DEVINFO;
 		mdev[i]->mq->length = 0;
-		maple_attach_driver(mdev[i]);
 		maple_add_packet(mdev[i]->mq);
+		/* delay aids hardware detection */
+		udelay(20);
 		subdevice_map[i] = 0;
 	}
 
+	realscan = 1;
 	/* setup maplebus hardware */
 	maplebus_dma_reset();
-
 	/* initial detection */
 	maple_send();
-
 	maple_pnp_time = jiffies;
-
 	printk(KERN_INFO "Maple bus core now registered.\n");
 
 	return 0;
 
-      cleanup_cache:
+cleanup_cache:
 	kmem_cache_destroy(maple_queue_cache);
 
-      cleanup_bothirqs:
+cleanup_bothirqs:
 	free_irq(HW_EVENT_VSYNC, 0);
 
-      cleanup_irq:
+cleanup_irq:
 	free_irq(HW_EVENT_MAPLE_DMA, 0);
 
-      cleanup_dma:
+cleanup_dma:
 	free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
 
-      cleanup_basic:
+cleanup_basic:
 	driver_unregister(&maple_dummy_driver.drv);
 
-      cleanup_bus:
+cleanup_bus:
 	bus_unregister(&maple_bus_type);
 
-      cleanup_device:
+cleanup_device:
 	device_unregister(&maple_bus);
 
-      cleanup:
+cleanup:
 	printk(KERN_INFO "Maple bus registration failed\n");
 	return retval;
 }
-
-subsys_initcall(maple_bus_init);
+/* Push init to later to ensure hardware gets detected */
+fs_initcall(maple_bus_init);

