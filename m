Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbXIMXp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbXIMXp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766001AbXIMXoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:44:54 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41155 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765059AbXIMXox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:44:53 -0400
Date: Thu, 13 Sep 2007 16:38:50 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Driver core: remove get_bus()
Message-ID: <20070913233850.GB10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913233751.GA10856@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

get_bus() should not be globally visable as it is not used by anything
other than drivers/base/bus.c.  This patch removes the visability of it,
and renames it to match all of the other *_get() functions in the
kernel.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h |    1 -
 drivers/base/bus.c  |   24 ++++++++++++------------
 2 files changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -18,7 +18,6 @@ extern int attribute_container_init(void
 extern int bus_add_device(struct device * dev);
 extern void bus_attach_device(struct device * dev);
 extern void bus_remove_device(struct device * dev);
-extern struct bus_type *get_bus(struct bus_type * bus);
 
 extern int bus_add_driver(struct device_driver *);
 extern void bus_remove_driver(struct device_driver *);
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -30,6 +30,12 @@
 static int __must_check bus_rescan_devices_helper(struct device *dev,
 						void *data);
 
+static struct bus_type *bus_get(struct bus_type *bus)
+{
+	return bus ? container_of(kset_get(&bus->subsys),
+				struct bus_type, subsys) : NULL;
+}
+
 static void bus_put(struct bus_type *bus)
 {
 	kset_put(&bus->subsys);
@@ -127,7 +133,7 @@ static struct sysfs_ops bus_sysfs_ops = 
 int bus_create_file(struct bus_type * bus, struct bus_attribute * attr)
 {
 	int error;
-	if (get_bus(bus)) {
+	if (bus_get(bus)) {
 		error = sysfs_create_file(&bus->subsys.kobj, &attr->attr);
 		bus_put(bus);
 	} else
@@ -137,7 +143,7 @@ int bus_create_file(struct bus_type * bu
 
 void bus_remove_file(struct bus_type * bus, struct bus_attribute * attr)
 {
-	if (get_bus(bus)) {
+	if (bus_get(bus)) {
 		sysfs_remove_file(&bus->subsys.kobj, &attr->attr);
 		bus_put(bus);
 	}
@@ -177,7 +183,7 @@ static int driver_helper(struct device *
 static ssize_t driver_unbind(struct device_driver *drv,
 			     const char *buf, size_t count)
 {
-	struct bus_type *bus = get_bus(drv->bus);
+	struct bus_type *bus = bus_get(drv->bus);
 	struct device *dev;
 	int err = -ENODEV;
 
@@ -204,7 +210,7 @@ static DRIVER_ATTR(unbind, S_IWUSR, NULL
 static ssize_t driver_bind(struct device_driver *drv,
 			   const char *buf, size_t count)
 {
-	struct bus_type *bus = get_bus(drv->bus);
+	struct bus_type *bus = bus_get(drv->bus);
 	struct device *dev;
 	int err = -ENODEV;
 
@@ -435,7 +441,7 @@ static inline void remove_deprecated_bus
  */
 int bus_add_device(struct device * dev)
 {
-	struct bus_type * bus = get_bus(dev->bus);
+	struct bus_type * bus = bus_get(dev->bus);
 	int error = 0;
 
 	if (bus) {
@@ -611,7 +617,7 @@ static inline void remove_probe_files(st
  */
 int bus_add_driver(struct device_driver *drv)
 {
-	struct bus_type * bus = get_bus(drv->bus);
+	struct bus_type * bus = bus_get(drv->bus);
 	int error = 0;
 
 	if (!bus)
@@ -731,12 +737,6 @@ int device_reprobe(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(device_reprobe);
 
-struct bus_type *get_bus(struct bus_type *bus)
-{
-	return bus ? container_of(kset_get(&bus->subsys),
-				struct bus_type, subsys) : NULL;
-}
-
 /**
  *	find_bus - locate bus by name.
  *	@name:	name of bus.
