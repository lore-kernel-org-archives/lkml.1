Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbXD0S46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbXD0S46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbXD0S45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:56:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:35217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042AbXD0S4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:56:53 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/46] driver core: don't fail attaching the device if it cannot be bound
Date: Fri, 27 Apr 2007 11:53:24 -0700
Message-Id: <1177700074272-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1177700070961-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Don't fail bus_attach_device() if the device cannot be bound.

If dev->driver has been specified, reset it to NULL if device_bind_driver()
failed and add the device as an unbound device.  As a result,
bus_attach_device() now cannot fail, and we can remove some checking from
device_add().

Also remove an unneeded check in bus_rescan_devices_helper().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h |    2 +-
 drivers/base/bus.c  |   11 ++++-------
 drivers/base/core.c |    5 +----
 drivers/base/dd.c   |    6 +++++-
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index de7e144..d597f26 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -16,7 +16,7 @@ extern int cpu_dev_init(void);
 extern int attribute_container_init(void);
 
 extern int bus_add_device(struct device * dev);
-extern int bus_attach_device(struct device * dev);
+extern void bus_attach_device(struct device * dev);
 extern void bus_remove_device(struct device * dev);
 extern struct bus_type *get_bus(struct bus_type * bus);
 extern void put_bus(struct bus_type * bus);
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 9df2e6d..20b6dc8 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -447,7 +447,7 @@ out_put:
  *	- Add device to bus's list of devices.
  *	- Try to attach to driver.
  */
-int bus_attach_device(struct device * dev)
+void bus_attach_device(struct device * dev)
 {
 	struct bus_type *bus = dev->bus;
 	int ret = 0;
@@ -456,13 +456,12 @@ int bus_attach_device(struct device * dev)
 		dev->is_registered = 1;
 		if (bus->drivers_autoprobe)
 			ret = device_attach(dev);
-		if (ret >= 0) {
+		WARN_ON(ret < 0);
+		if (ret >= 0)
 			klist_add_tail(&dev->knode_bus, &bus->klist_devices);
-			ret = 0;
-		} else
+		else
 			dev->is_registered = 0;
 	}
-	return ret;
 }
 
 /**
@@ -669,8 +668,6 @@ static int __must_check bus_rescan_devices_helper(struct device *dev,
 		ret = device_attach(dev);
 		if (dev->parent)
 			up(&dev->parent->sem);
-		if (ret > 0)
-			ret = 0;
 	}
 	return ret < 0 ? ret : 0;
 }
diff --git a/drivers/base/core.c b/drivers/base/core.c
index bffb69e..be6aeb4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -677,8 +677,7 @@ int device_add(struct device *dev)
 		goto BusError;
 	if (!dev->uevent_suppress)
 		kobject_uevent(&dev->kobj, KOBJ_ADD);
-	if ((error = bus_attach_device(dev)))
-		goto AttachError;
+	bus_attach_device(dev);
 	if (parent)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
@@ -697,8 +696,6 @@ int device_add(struct device *dev)
 	kfree(class_name);
 	put_device(dev);
 	return error;
- AttachError:
-	bus_remove_device(dev);
  BusError:
 	device_pm_remove(dev);
  PMError:
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 616b4bb..18dba8e 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -232,7 +232,7 @@ static int device_probe_drivers(void *data)
  *
  *	Returns 1 if the device was bound to a driver;
  *	0 if no matching device was found or multithreaded probing is done;
- *	error code otherwise.
+ *	-ENODEV if the device is not registered.
  *
  *	When called for a USB interface, @dev->parent->sem must be held.
  */
@@ -246,6 +246,10 @@ int device_attach(struct device * dev)
 		ret = device_bind_driver(dev);
 		if (ret == 0)
 			ret = 1;
+		else {
+			dev->driver = NULL;
+			ret = 0;
+		}
 	} else {
 		if (dev->bus->multithread_probe)
 			probe_task = kthread_run(device_probe_drivers, dev,
-- 
1.5.1.2

