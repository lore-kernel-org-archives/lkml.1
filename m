Return-Path: <linux-kernel-owner+w=401wt.eu-S1762498AbXKPQ5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762498AbXKPQ5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbXKPQ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:57:30 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47193 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755914AbXKPQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:57:28 -0500
Date: Fri, 16 Nov 2007 11:57:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>
cc: USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Driver core: fix race in __device_release_driver
Message-ID: <Pine.LNX.4.44L0.0711161151340.3268-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1013) was suggested by David Woodhouse; it fixes a race
in the driver core.  If a device is unregistered at the same time as
its driver is unloaded, the driver's code pages may be unmapped while
the remove method is still running.  The calls to get_driver() and
put_driver() were intended to prevent this, but they don't work if the
driver's module count has already dropped to 0.

Instead, the patch keeps the device on the driver's list until after
the remove method has returned.  This forces the necessary
synchronization to occur.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: David Woodhouse <dwmw2@infradead.org>

---

This should be considered for 2.6.24.


Index: usb-2.6/drivers/base/dd.c
===================================================================
--- usb-2.6.orig/drivers/base/dd.c
+++ usb-2.6/drivers/base/dd.c
@@ -289,11 +289,10 @@ static void __device_release_driver(stru
 {
 	struct device_driver * drv;
 
-	drv = get_driver(dev->driver);
+	drv = dev->driver;
 	if (drv) {
 		driver_sysfs_remove(dev);
 		sysfs_remove_link(&dev->kobj, "driver");
-		klist_remove(&dev->knode_driver);
 
 		if (dev->bus)
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
@@ -306,7 +305,7 @@ static void __device_release_driver(stru
 			drv->remove(dev);
 		devres_release_all(dev);
 		dev->driver = NULL;
-		put_driver(drv);
+		klist_remove(&dev->knode_driver);
 	}
 }
 

