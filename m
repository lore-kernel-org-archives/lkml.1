Return-Path: <linux-kernel-owner+w=401wt.eu-S1763166AbXKCAJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763166AbXKCAJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761612AbXKCAB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:59 -0400
Received: from mx1.suse.de ([195.135.220.2]:41161 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761709AbXKCAB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 28/54] kset: convert struct bus_device->devices to use kset_create
Date: Fri,  2 Nov 2007 16:59:06 -0700
Message-Id: <1194047972-9850-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Having 3 static kobjects in one structure is not only foolish, but ripe
for nasty race conditions if handled improperly.  We also rename the
field to catch any potential users of it (not that there should be
outside of the driver core...)

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c     |   19 ++++++++++---------
 include/linux/device.h |    2 +-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 8b65694..67b8ca2 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -450,7 +450,7 @@ int bus_add_device(struct device * dev)
 		error = device_add_attrs(bus, dev);
 		if (error)
 			goto out_put;
-		error = sysfs_create_link(&bus->devices.kobj,
+		error = sysfs_create_link(&bus->devices_kset->kobj,
 						&dev->kobj, dev->bus_id);
 		if (error)
 			goto out_id;
@@ -467,7 +467,7 @@ int bus_add_device(struct device * dev)
 out_deprecated:
 	sysfs_remove_link(&dev->kobj, "subsystem");
 out_subsys:
-	sysfs_remove_link(&bus->devices.kobj, dev->bus_id);
+	sysfs_remove_link(&bus->devices_kset->kobj, dev->bus_id);
 out_id:
 	device_remove_attrs(bus, dev);
 out_put:
@@ -513,7 +513,7 @@ void bus_remove_device(struct device * dev)
 	if (dev->bus) {
 		sysfs_remove_link(&dev->kobj, "subsystem");
 		remove_deprecated_bus_links(dev);
-		sysfs_remove_link(&dev->bus->devices.kobj, dev->bus_id);
+		sysfs_remove_link(&dev->bus->devices_kset->kobj, dev->bus_id);
 		device_remove_attrs(dev->bus, dev);
 		if (dev->is_registered) {
 			dev->is_registered = 0;
@@ -863,11 +863,12 @@ int bus_register(struct bus_type * bus)
 	if (retval)
 		goto bus_uevent_fail;
 
-	kobject_set_name(&bus->devices.kobj, "devices");
-	bus->devices.kobj.parent = &bus->subsys.kobj;
-	retval = kset_register(&bus->devices);
-	if (retval)
+	bus->devices_kset = kset_create_and_register("devices", NULL,
+						     &bus->subsys.kobj, NULL);
+	if (IS_ERR(bus->devices_kset)) {
+		retval = PTR_ERR(bus->devices_kset);
 		goto bus_devices_fail;
+	}
 
 	kobject_set_name(&bus->drivers.kobj, "drivers");
 	bus->drivers.kobj.parent = &bus->subsys.kobj;
@@ -895,7 +896,7 @@ bus_attrs_fail:
 bus_probe_files_fail:
 	kset_unregister(&bus->drivers);
 bus_drivers_fail:
-	kset_unregister(&bus->devices);
+	kset_unregister(bus->devices_kset);
 bus_devices_fail:
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
@@ -917,7 +918,7 @@ void bus_unregister(struct bus_type * bus)
 	bus_remove_attrs(bus);
 	remove_probe_files(bus);
 	kset_unregister(&bus->drivers);
-	kset_unregister(&bus->devices);
+	kset_unregister(bus->devices_kset);
 	bus_remove_file(bus, &bus_attr_uevent);
 	subsystem_unregister(&bus->subsys);
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index 2e15822..094d71d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -55,7 +55,7 @@ struct bus_type {
 
 	struct kset		subsys;
 	struct kset		drivers;
-	struct kset		devices;
+	struct kset		*devices_kset;
 	struct klist		klist_devices;
 	struct klist		klist_drivers;
 
-- 
1.5.3.4

