Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbYAYHkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbYAYHkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbYAYHSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:40 -0500
Received: from mx1.suse.de ([195.135.220.2]:52957 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759496AbYAYHSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:39 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 071/196] kset: convert struct bus_device->devices to use kset_create
Date: Thu, 24 Jan 2008 23:10:09 -0800
Message-Id: <1201245134-4876-71-git-send-email-gregkh@suse.de>
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
 drivers/base/bus.c     |   19 ++++++++++---------
 include/linux/device.h |    2 +-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index e3b1010..b23eeb2 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -449,7 +449,7 @@ int bus_add_device(struct device * dev)
 		error = device_add_attrs(bus, dev);
 		if (error)
 			goto out_put;
-		error = sysfs_create_link(&bus->devices.kobj,
+		error = sysfs_create_link(&bus->devices_kset->kobj,
 						&dev->kobj, dev->bus_id);
 		if (error)
 			goto out_id;
@@ -466,7 +466,7 @@ int bus_add_device(struct device * dev)
 out_deprecated:
 	sysfs_remove_link(&dev->kobj, "subsystem");
 out_subsys:
-	sysfs_remove_link(&bus->devices.kobj, dev->bus_id);
+	sysfs_remove_link(&bus->devices_kset->kobj, dev->bus_id);
 out_id:
 	device_remove_attrs(bus, dev);
 out_put:
@@ -512,7 +512,7 @@ void bus_remove_device(struct device * dev)
 	if (dev->bus) {
 		sysfs_remove_link(&dev->kobj, "subsystem");
 		remove_deprecated_bus_links(dev);
-		sysfs_remove_link(&dev->bus->devices.kobj, dev->bus_id);
+		sysfs_remove_link(&dev->bus->devices_kset->kobj, dev->bus_id);
 		device_remove_attrs(dev->bus, dev);
 		if (dev->is_registered) {
 			dev->is_registered = 0;
@@ -862,11 +862,12 @@ int bus_register(struct bus_type * bus)
 	if (retval)
 		goto bus_uevent_fail;
 
-	kobject_set_name(&bus->devices.kobj, "devices");
-	bus->devices.kobj.parent = &bus->subsys.kobj;
-	retval = kset_register(&bus->devices);
-	if (retval)
+	bus->devices_kset = kset_create_and_add("devices", NULL,
+						&bus->subsys.kobj);
+	if (!bus->devices_kset) {
+		retval = -ENOMEM;
 		goto bus_devices_fail;
+	}
 
 	kobject_set_name(&bus->drivers.kobj, "drivers");
 	bus->drivers.kobj.parent = &bus->subsys.kobj;
@@ -894,7 +895,7 @@ bus_attrs_fail:
 bus_probe_files_fail:
 	kset_unregister(&bus->drivers);
 bus_drivers_fail:
-	kset_unregister(&bus->devices);
+	kset_unregister(bus->devices_kset);
 bus_devices_fail:
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
@@ -916,7 +917,7 @@ void bus_unregister(struct bus_type * bus)
 	bus_remove_attrs(bus);
 	remove_probe_files(bus);
 	kset_unregister(&bus->drivers);
-	kset_unregister(&bus->devices);
+	kset_unregister(bus->devices_kset);
 	bus_remove_file(bus, &bus_attr_uevent);
 	subsystem_unregister(&bus->subsys);
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index dbbbe89..82c2777 100644
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
1.5.3.8

