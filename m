Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbXJLWg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbXJLWg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760083AbXJLWUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:49738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932559AbXJLWUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/75] Driver core: add uevent file for bus and driver
Date: Fri, 12 Oct 2007 15:16:35 -0700
Message-Id: <11922275843236-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275781508-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This has been in the SuSE kernels for some time now.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 0a8d075..6768a01 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -610,6 +610,17 @@ static inline int add_probe_files(struct bus_type *bus) { return 0; }
 static inline void remove_probe_files(struct bus_type *bus) {}
 #endif
 
+static ssize_t driver_uevent_store(struct device_driver *drv,
+				   const char *buf, size_t count)
+{
+	enum kobject_action action;
+
+	if (kobject_action_type(buf, count, &action) == 0)
+		kobject_uevent(&drv->kobj, action);
+	return count;
+}
+static DRIVER_ATTR(uevent, S_IWUSR, NULL, driver_uevent_store);
+
 /**
  *	bus_add_driver - Add a driver to the bus.
  *	@drv:	driver.
@@ -640,6 +651,11 @@ int bus_add_driver(struct device_driver *drv)
 	klist_add_tail(&drv->knode_bus, &bus->klist_drivers);
 	module_add_driver(drv->owner, drv);
 
+	error = driver_create_file(drv, &driver_attr_uevent);
+	if (error) {
+		printk(KERN_ERR "%s: uevent attr (%s) failed\n",
+			__FUNCTION__, drv->name);
+	}
 	error = driver_add_attrs(bus, drv);
 	if (error) {
 		/* How the hell do we get out of this pickle? Give up */
@@ -677,6 +693,7 @@ void bus_remove_driver(struct device_driver * drv)
 
 	remove_bind_files(drv);
 	driver_remove_attrs(drv->bus, drv);
+	driver_remove_file(drv, &driver_attr_uevent);
 	klist_remove(&drv->knode_bus);
 	pr_debug("bus %s: remove driver %s\n", drv->bus->name, drv->name);
 	driver_detach(drv);
@@ -804,6 +821,17 @@ static void klist_devices_put(struct klist_node *n)
 	put_device(dev);
 }
 
+static ssize_t bus_uevent_store(struct bus_type *bus,
+				const char *buf, size_t count)
+{
+	enum kobject_action action;
+
+	if (kobject_action_type(buf, count, &action) == 0)
+		kobject_uevent(&bus->subsys.kobj, action);
+	return count;
+}
+static BUS_ATTR(uevent, S_IWUSR, NULL, bus_uevent_store);
+
 /**
  *	bus_register - register a bus with the system.
  *	@bus:	bus.
@@ -828,6 +856,10 @@ int bus_register(struct bus_type * bus)
 	if (retval)
 		goto out;
 
+	retval = bus_create_file(bus, &bus_attr_uevent);
+	if (retval)
+		goto bus_uevent_fail;
+
 	kobject_set_name(&bus->devices.kobj, "devices");
 	bus->devices.kobj.parent = &bus->subsys.kobj;
 	retval = kset_register(&bus->devices);
@@ -863,6 +895,8 @@ bus_probe_files_fail:
 bus_drivers_fail:
 	kset_unregister(&bus->devices);
 bus_devices_fail:
+	bus_remove_file(bus, &bus_attr_uevent);
+bus_uevent_fail:
 	subsystem_unregister(&bus->subsys);
 out:
 	return retval;
@@ -882,6 +916,7 @@ void bus_unregister(struct bus_type * bus)
 	remove_probe_files(bus);
 	kset_unregister(&bus->drivers);
 	kset_unregister(&bus->devices);
+	bus_remove_file(bus, &bus_attr_uevent);
 	subsystem_unregister(&bus->subsys);
 }
 
-- 
1.5.3.4

