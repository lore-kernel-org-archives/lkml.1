Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYLETKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYLETKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 14:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYLETKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 14:10:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48329 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753644AbYLETKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 14:10:32 -0500
Date: Fri, 5 Dec 2008 14:10:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay.sievers@vrfy.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Driver core: move the bus notifier call points
Message-ID: <Pine.LNX.4.44L0.0812051407160.2262-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1184) changes the location of the notifications in
device_add() and device_del().  Now the BUS_NOTIFY_ADD_DEVICE message
is sent after dpm_sysfs_add(), which is necessary for clients that
want to add attributes to the power/ subdirectory.  The
BUS_NOTIFY_DEL_DEVICE message is correspondingly moved before
dpm_sysfs_remove().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -884,11 +884,6 @@ int device_add(struct device *dev)
 	if (platform_notify)
 		platform_notify(dev);
 
-	/* notify clients of device entry (new way) */
-	if (dev->bus)
-		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-					     BUS_NOTIFY_ADD_DEVICE, dev);
-
 	error = device_create_file(dev, &uevent_attr);
 	if (error)
 		goto attrError;
@@ -916,6 +911,14 @@ int device_add(struct device *dev)
 	if (error)
 		goto DPMError;
 	device_pm_add(dev);
+
+	/* Notify clients of device addition.  This call must come
+	 * after dpm_sysf_add() and before kobject_uevent().
+	 */
+	if (dev->bus)
+		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
+					     BUS_NOTIFY_ADD_DEVICE, dev);
+
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
@@ -940,9 +943,6 @@ done:
  DPMError:
 	bus_remove_device(dev);
  BusError:
-	if (dev->bus)
-		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_remove_attrs(dev);
  AttrsError:
 	device_remove_class_symlinks(dev);
@@ -1027,6 +1027,12 @@ void device_del(struct device *dev)
 	struct device *parent = dev->parent;
 	struct class_interface *class_intf;
 
+	/* Notify clients of device removal.  This call must come
+	 * before dpm_sysfs_remove().
+	 */
+	if (dev->bus)
+		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
+					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_pm_remove(dev);
 	dpm_sysfs_remove(dev);
 	if (parent)
@@ -1064,9 +1070,6 @@ void device_del(struct device *dev)
 	 */
 	if (platform_notify_remove)
 		platform_notify_remove(dev);
-	if (dev->bus)
-		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-					     BUS_NOTIFY_DEL_DEVICE, dev);
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	cleanup_device_parent(dev);
 	if (!list_empty(&dev->klist_children.k_list))


