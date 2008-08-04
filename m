Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbYHDPpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbYHDPpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYHDPpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:45:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41169 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753520AbYHDPpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:45:03 -0400
Date: Mon, 4 Aug 2008 11:45:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Dasgupta, Romit" <romit@ti.com>, David Engraf <david.engraf@netcom.eu>,
       Greg KH <greg@kroah.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] [PM] Fixes missing PM entries in sysfs without
 CONFIG_PM_SLEEP
In-Reply-To: <200808041724.24016.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0808041143350.3818-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008, Rafael J. Wysocki wrote:

> > Do you think we will want to make device_pm_add() return an error at 
> > some point in the future?
> 
> Well, maybe, but not any time soon. :-)

Okay, here's the updated patch.  Awaiting comments from the testers...

Alan Stern



Index: usb-2.6/drivers/base/power/power.h
===================================================================
--- usb-2.6.orig/drivers/base/power/power.h
+++ usb-2.6/drivers/base/power/power.h
@@ -1,3 +1,8 @@
+static inline void device_pm_init(struct device *dev)
+{
+	dev->power.status = DPM_ON;
+}
+
 #ifdef CONFIG_PM_SLEEP
 
 /*
@@ -11,12 +16,12 @@ static inline struct device *to_device(s
 	return container_of(entry, struct device, power.entry);
 }
 
-extern int device_pm_add(struct device *);
+extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
 
 #else /* CONFIG_PM_SLEEP */
 
-static inline int device_pm_add(struct device *dev) { return 0; }
+static inline void device_pm_add(struct device *dev) {}
 static inline void device_pm_remove(struct device *dev) {}
 
 #endif
Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -542,6 +542,7 @@ void device_initialize(struct device *de
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_init_wakeup(dev, 0);
+	device_pm_init(dev);
 	set_dev_node(dev, -1);
 }
 
@@ -898,9 +899,10 @@ int device_add(struct device *dev)
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
-	error = device_pm_add(dev);
+	error = dpm_sysfs_add(dev);
 	if (error)
 		goto PMError;
+	device_pm_add(dev);
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
@@ -1008,6 +1010,7 @@ void device_del(struct device *dev)
 	struct class_interface *class_intf;
 
 	device_pm_remove(dev);
+	dpm_sysfs_remove(dev);
 	if (parent)
 		klist_del(&dev->knode_parent);
 	if (MAJOR(dev->devt)) {
Index: usb-2.6/drivers/base/power/main.c
===================================================================
--- usb-2.6.orig/drivers/base/power/main.c
+++ usb-2.6/drivers/base/power/main.c
@@ -67,10 +67,8 @@ void device_pm_unlock(void)
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
  */
-int device_pm_add(struct device *dev)
+void device_pm_add(struct device *dev)
 {
-	int error;
-
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
@@ -89,13 +87,9 @@ int device_pm_add(struct device *dev)
 		 */
 		WARN_ON(true);
 	}
-	error = dpm_sysfs_add(dev);
-	if (!error) {
-		dev->power.status = DPM_ON;
-		list_add_tail(&dev->power.entry, &dpm_list);
-	}
+
+	list_add_tail(&dev->power.entry, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
-	return error;
 }
 
 /**
@@ -110,7 +104,6 @@ void device_pm_remove(struct device *dev
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
-	dpm_sysfs_remove(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
 }

