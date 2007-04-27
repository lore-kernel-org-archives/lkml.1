Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbXD0TMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbXD0TMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757031AbXD0S5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:35222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046AbXD0S45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:56:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 11/46] Driver core: remove unneeded completion from driver release path
Date: Fri, 27 Apr 2007 11:53:25 -0700
Message-Id: <11777000773819-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1177700074272-git-send-email-gregkh@suse.de>
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
 <1177700074272-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The completion in the driver release path is due to ancient history in
the _very_ early 2.5 days when we were not tracking the module reference
count of attributes.  It is not needed at all and can be removed.

Note, we now have an empty release function for the driver structure.
This is due to the fact that drivers are statically allocated in the
system at this point in time, something which I want to change in the
future.  But remember, drivers are really code, which is reference
counted by the module, unlike devices, which are data and _must_ be
reference counted properly in order to work correctly.


Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c     |   15 +++++++++++++--
 drivers/base/driver.c  |   20 --------------------
 include/linux/device.h |    1 -
 3 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 20b6dc8..1a5a350 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -63,8 +63,19 @@ static struct sysfs_ops driver_sysfs_ops = {
 
 static void driver_release(struct kobject * kobj)
 {
-	struct device_driver * drv = to_driver(kobj);
-	complete(&drv->unloaded);
+	/*
+	 * Yes this is an empty release function, it is this way because struct
+	 * device is always a static object, not a dynamic one.  Yes, this is
+	 * not nice and bad, but remember, drivers are code, reference counted
+	 * by the module count, not a device, which is really data.  And yes,
+	 * in the future I do want to have all drivers be created dynamically,
+	 * and am working toward that goal, but it will take a bit longer...
+	 *
+	 * But do not let this example give _anyone_ the idea that they can
+	 * create a release function without any code in it at all, to do that
+	 * is almost always wrong.  If you have any questions about this,
+	 * please send an email to <greg@kroah.com>
+	 */
 }
 
 static struct kobj_type ktype_driver = {
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 082bfde..eb11475 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -149,10 +149,6 @@ void put_driver(struct device_driver * drv)
  *	We pass off most of the work to the bus_add_driver() call,
  *	since most of the things we have to do deal with the bus
  *	structures.
- *
- *	The one interesting aspect is that we setup @drv->unloaded
- *	as a completion that gets complete when the driver reference
- *	count reaches 0.
  */
 int driver_register(struct device_driver * drv)
 {
@@ -162,35 +158,19 @@ int driver_register(struct device_driver * drv)
 		printk(KERN_WARNING "Driver '%s' needs updating - please use bus_type methods\n", drv->name);
 	}
 	klist_init(&drv->klist_devices, NULL, NULL);
-	init_completion(&drv->unloaded);
 	return bus_add_driver(drv);
 }
 
-
 /**
  *	driver_unregister - remove driver from system.
  *	@drv:	driver.
  *
  *	Again, we pass off most of the work to the bus-level call.
- *
- *	Though, once that is done, we wait until @drv->unloaded is completed.
- *	This will block until the driver refcount reaches 0, and it is
- *	released. Only modular drivers will call this function, and we
- *	have to guarantee that it won't complete, letting the driver
- *	unload until all references are gone.
  */
 
 void driver_unregister(struct device_driver * drv)
 {
 	bus_remove_driver(drv);
-	/*
-	 * If the driver is a module, we are probably in
-	 * the module unload path, and we want to wait
-	 * for everything to unload before we can actually
-	 * finish the unload.
-	 */
-	if (drv->owner)
-		wait_for_completion(&drv->unloaded);
 }
 
 /**
diff --git a/include/linux/device.h b/include/linux/device.h
index eb1fff0..c9dc458 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -126,7 +126,6 @@ struct device_driver {
 	const char		* name;
 	struct bus_type		* bus;
 
-	struct completion	unloaded;
 	struct kobject		kobj;
 	struct klist		klist_devices;
 	struct klist_node	knode_bus;
-- 
1.5.1.2

