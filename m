Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYBXObX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYBXObX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 09:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYBXObH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 09:31:07 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:7881 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755199AbYBXOan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 09:30:43 -0500
X-Trace: 687407291/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPsNwUdRAVlC/2dsb2JhbACBVagqgXo
Subject: [PATCH] maple: fix device detection
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>, Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 14:30:23 +0000
Message-Id: <1203863423.6474.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maple bus driver that went into the kernel mainline in September 2007 contained some bugs which were revealed by the update of the kobj code for the current release series. Unfortunately those bugs also helped ensure maple devices were properly detected. This patch (against the current git) now ensures that devices are properly detected again.

(A previous attempt to fix this by delaying initialisation only partially fixed this - as became apparent when the bus was fully loaded)

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---



diff -ruN ./a/drivers/sh/maple/maple.c ./b/drivers/sh/maple/maple.c
--- ./a/drivers/sh/maple/maple.c	2008-02-21 20:42:17.000000000 +0000
+++ ./b/drivers/sh/maple/maple.c	2008-02-24 13:59:09.000000000 +0000
@@ -1,7 +1,7 @@
 /*
  * Core maple bus functionality
  *
- *  Copyright (C) 2007 Adrian McMenamin
+ *  Copyright (C) 2007, 2008 Adrian McMenamin
  *
  * Based on 2.4 code by:
  *
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
-#include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/io.h>
@@ -54,7 +53,7 @@
 static int subdevice_map[MAPLE_PORTS];
 static unsigned long *maple_sendbuf, *maple_sendptr, *maple_lastptr;
 static unsigned long maple_pnp_time;
-static int started, scanning, liststatus, realscan;
+static int started, scanning, liststatus, fullscan;
 static struct kmem_cache *maple_queue_cache;
 
 struct maple_device_specify {
@@ -62,6 +61,9 @@
 	int unit;
 };
 
+static bool checked[4];
+static struct maple_device *baseunits[4];
+
 /**
  *  maple_driver_register - register a device driver
  *  automatically makes the driver bus a maple bus
@@ -309,11 +311,9 @@
 		else
 			break;
 
-	if (realscan) {
-		printk(KERN_INFO "Maple device detected: %s\n",
-			mdev->product_name);
-		printk(KERN_INFO "Maple device: %s\n", mdev->product_licence);
-	}
+	printk(KERN_INFO "Maple device detected: %s\n",
+		mdev->product_name);
+	printk(KERN_INFO "Maple device: %s\n", mdev->product_licence);
 
 	function = be32_to_cpu(mdev->devinfo.function);
 
@@ -323,10 +323,9 @@
 		mdev->driver = &maple_dummy_driver;
 		sprintf(mdev->dev.bus_id, "%d:0.port", mdev->port);
 	} else {
-		if (realscan)
-			printk(KERN_INFO
-				"Maple bus at (%d, %d): Function 0x%lX\n",
-				mdev->port, mdev->unit, function);
+		printk(KERN_INFO
+			"Maple bus at (%d, %d): Function 0x%lX\n",
+			mdev->port, mdev->unit, function);
 
 		matched =
 		    bus_for_each_drv(&maple_bus_type, NULL, mdev,
@@ -334,9 +333,8 @@
 
 		if (matched == 0) {
 			/* Driver does not exist yet */
-			if (realscan)
-				printk(KERN_INFO
-					"No maple driver found.\n");
+			printk(KERN_INFO
+				"No maple driver found.\n");
 			mdev->driver = &maple_dummy_driver;
 		}
 		sprintf(mdev->dev.bus_id, "%d:0%d.%lX", mdev->port,
@@ -472,9 +470,12 @@
 		maple_detach_driver(mdev);
 		return;
 	}
-	if (!started) {
-		printk(KERN_INFO "No maple devices attached to port %d\n",
-		       mdev->port);
+	if (!started || !fullscan) {
+		if (checked[mdev->port] == false) {
+			checked[mdev->port] = true;
+			printk(KERN_INFO "No maple devices attached"
+				" to port %d\n", mdev->port);
+		}
 		return;
 	}
 	maple_clean_submap(mdev);
@@ -485,8 +486,14 @@
 				   char *recvbuf)
 {
 	char submask;
-	if ((!started) || (scanning == 2)) {
-		maple_attach_driver(mdev);
+	if (!started || (scanning == 2) || !fullscan) {
+		if ((mdev->unit == 0) && (checked[mdev->port] == false)) {
+			checked[mdev->port] = true;
+			maple_attach_driver(mdev);
+		} else {
+			if (mdev->unit != 0)
+				maple_attach_driver(mdev);
+		}
 		return;
 	}
 	if (mdev->unit == 0) {
@@ -505,6 +512,7 @@
 	struct maple_device *dev;
 	char *recvbuf;
 	enum maple_code code;
+	int i;
 
 	if (!maple_dma_done())
 		return;
@@ -557,6 +565,19 @@
 		} else
 			scanning = 0;
 
+		if (!fullscan) {
+			fullscan = 1;
+			for (i = 0; i < MAPLE_PORTS; i++) {
+				if (checked[i] == false) {
+					fullscan = 0;
+					dev = baseunits[i];
+					dev->mq->command =
+						MAPLE_COMMAND_DEVINFO;
+					dev->mq->length = 0;
+					maple_add_packet(dev->mq);
+				}
+			}
+		}
 		if (started == 0)
 			started = 1;
 	}
@@ -694,7 +715,9 @@
 
 	/* setup maple ports */
 	for (i = 0; i < MAPLE_PORTS; i++) {
+		checked[i] = false;
 		mdev[i] = maple_alloc_dev(i, 0);
+		baseunits[i] = mdev[i];
 		if (!mdev[i]) {
 			while (i-- > 0)
 				maple_free_dev(mdev[i]);
@@ -703,12 +726,9 @@
 		mdev[i]->mq->command = MAPLE_COMMAND_DEVINFO;
 		mdev[i]->mq->length = 0;
 		maple_add_packet(mdev[i]->mq);
-		/* delay aids hardware detection */
-		mdelay(5);
 		subdevice_map[i] = 0;
 	}
 
-	realscan = 1;
 	/* setup maplebus hardware */
 	maplebus_dma_reset();
 	/* initial detection */


