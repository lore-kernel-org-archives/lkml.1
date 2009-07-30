Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbZG3T1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbZG3T1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZG3T1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:27:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43855 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750967AbZG3T1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:27:17 -0400
Date: Thu, 30 Jul 2009 15:27:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Driver core: add new device to bus's list before probing
Message-ID: <Pine.LNX.4.44L0.0907301522570.6087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1271) affects when new devices get linked into their
bus's list of devices.  Currently this happens after probing, and it
doesn't happen at all if probing fails.  Clearly this is wrong,
because at that point quite a few symbolic links have already been
created in sysfs.  We are committed to adding the device, so it should
be linked into the bus's list regardless.

In addition, this needs to happen before the uevent announcing the new
device gets issued.  Otherwise user programs might try to access the
device before it has been added to the bus.

To fix both these problems, the patch moves the call to
klist_add_tail() forward from bus_attach_device() to bus_add_device().
Since bus_attach_device() now does nothing but probe for drivers, it
has been renamed to bus_probe_device().  And lastly, the kerneldoc is
updated.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Kay Sievers <kay.sievers@vrfy.org>

---

Kay, do you want this merged into 2.6.31 or are you okay with waiting
for 2.6.32-rc1?  It changes a major core routine.  On the other hand,
the problem it fixes does affect real users.



Index: usb-2.6/drivers/base/base.h
===================================================================
--- usb-2.6.orig/drivers/base/base.h
+++ usb-2.6/drivers/base/base.h
@@ -109,7 +109,7 @@ extern int system_bus_init(void);
 extern int cpu_dev_init(void);
 
 extern int bus_add_device(struct device *dev);
-extern void bus_attach_device(struct device *dev);
+extern void bus_probe_device(struct device *dev);
 extern void bus_remove_device(struct device *dev);
 
 extern int bus_add_driver(struct device_driver *drv);
Index: usb-2.6/drivers/base/bus.c
===================================================================
--- usb-2.6.orig/drivers/base/bus.c
+++ usb-2.6/drivers/base/bus.c
@@ -459,8 +459,9 @@ static inline void remove_deprecated_bus
  * bus_add_device - add device to bus
  * @dev: device being added
  *
+ * - Add device's bus attributes.
+ * - Create links to device's bus.
  * - Add the device to its bus's list of devices.
- * - Create link to device's bus.
  */
 int bus_add_device(struct device *dev)
 {
@@ -483,6 +484,7 @@ int bus_add_device(struct device *dev)
 		error = make_deprecated_bus_links(dev);
 		if (error)
 			goto out_deprecated;
+		klist_add_tail(&dev->p->knode_bus, &bus->p->klist_devices);
 	}
 	return 0;
 
@@ -498,24 +500,19 @@ out_put:
 }
 
 /**
- * bus_attach_device - add device to bus
- * @dev: device tried to attach to a driver
+ * bus_probe_device - probe drivers for a new device
+ * @dev: device to probe
  *
- * - Add device to bus's list of devices.
- * - Try to attach to driver.
+ * - Automatically probe for a driver if the bus allows it.
  */
-void bus_attach_device(struct device *dev)
+void bus_probe_device(struct device *dev)
 {
 	struct bus_type *bus = dev->bus;
-	int ret = 0;
+	int ret;
 
-	if (bus) {
-		if (bus->p->drivers_autoprobe)
-			ret = device_attach(dev);
+	if (bus && bus->p->drivers_autoprobe) {
+		ret = device_attach(dev);
 		WARN_ON(ret < 0);
-		if (ret >= 0)
-			klist_add_tail(&dev->p->knode_bus,
-				       &bus->p->klist_devices);
 	}
 }
 
Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -955,7 +955,7 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_ADD_DEVICE, dev);
 
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
-	bus_attach_device(dev);
+	bus_probe_device(dev);
 	if (parent)
 		klist_add_tail(&dev->p->knode_parent,
 			       &parent->p->klist_children);

