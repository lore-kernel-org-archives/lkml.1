Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbYAYHkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbYAYHkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758579AbYAYHSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:48 -0500
Received: from mail.suse.de ([195.135.220.2]:52964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223AbYAYHSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 072/196] kset: convert struct bus_device->drivers to use kset_create
Date: Thu, 24 Jan 2008 23:10:10 -0800
Message-Id: <1201245134-4876-72-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Having 3 static kobjects in one structure is not only foolish, but ripe
for nasty race conditions if handled improperly.  We also rename the
field to catch any potential users of it (not that there should be
outside of the driver core...)

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c     |   15 ++++++++-------
 drivers/base/driver.c  |    2 +-
 include/linux/device.h |    2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index b23eeb2..6796d3e 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -638,7 +638,7 @@ int bus_add_driver(struct device_driver *drv)
 	error = kobject_set_name(&drv->kobj, "%s", drv->name);
 	if (error)
 		goto out_put_bus;
-	drv->kobj.kset = &bus->drivers;
+	drv->kobj.kset = bus->drivers_kset;
 	drv->kobj.ktype = &driver_ktype;
 	error = kobject_register(&drv->kobj);
 	if (error)
@@ -869,11 +869,12 @@ int bus_register(struct bus_type * bus)
 		goto bus_devices_fail;
 	}
 
-	kobject_set_name(&bus->drivers.kobj, "drivers");
-	bus->drivers.kobj.parent = &bus->subsys.kobj;
-	retval = kset_register(&bus->drivers);
-	if (retval)
+	bus->drivers_kset = kset_create_and_add("drivers", NULL,
+						&bus->subsys.kobj);
+	if (!bus->drivers_kset) {
+		retval = -ENOMEM;
 		goto bus_drivers_fail;
+	}
 
 	klist_init(&bus->klist_devices, klist_devices_get, klist_devices_put);
 	klist_init(&bus->klist_drivers, NULL, NULL);
@@ -893,7 +894,7 @@ int bus_register(struct bus_type * bus)
 bus_attrs_fail:
 	remove_probe_files(bus);
 bus_probe_files_fail:
-	kset_unregister(&bus->drivers);
+	kset_unregister(bus->drivers_kset);
 bus_drivers_fail:
 	kset_unregister(bus->devices_kset);
 bus_devices_fail:
@@ -916,7 +917,7 @@ void bus_unregister(struct bus_type * bus)
 	pr_debug("bus %s: unregistering\n", bus->name);
 	bus_remove_attrs(bus);
 	remove_probe_files(bus);
-	kset_unregister(&bus->drivers);
+	kset_unregister(bus->drivers_kset);
 	kset_unregister(bus->devices_kset);
 	bus_remove_file(bus, &bus_attr_uevent);
 	subsystem_unregister(&bus->subsys);
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index eb11475..1c9770d 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -185,7 +185,7 @@ void driver_unregister(struct device_driver * drv)
  */
 struct device_driver *driver_find(const char *name, struct bus_type *bus)
 {
-	struct kobject *k = kset_find_obj(&bus->drivers, name);
+	struct kobject *k = kset_find_obj(bus->drivers_kset, name);
 	if (k)
 		return to_drv(k);
 	return NULL;
diff --git a/include/linux/device.h b/include/linux/device.h
index 82c2777..110ace0 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -54,7 +54,7 @@ struct bus_type {
 	struct module		* owner;
 
 	struct kset		subsys;
-	struct kset		drivers;
+	struct kset		*drivers_kset;
 	struct kset		*devices_kset;
 	struct klist		klist_devices;
 	struct klist		klist_drivers;
-- 
1.5.3.8

