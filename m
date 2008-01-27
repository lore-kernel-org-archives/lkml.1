Return-Path: <linux-kernel-owner+w=401wt.eu-S1760429AbYA0XlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429AbYA0XlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760184AbYA0Xk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:40:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:35722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760132AbYA0XkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:40:25 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/5] Driver core: add bus_find_device_by_name function
Date: Sun, 27 Jan 2008 15:38:41 -0800
Message-Id: <1201477122-4541-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080127233751.GA4524@kroah.com>
References: <20080127233751.GA4524@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core, and some other parts of the kernel just want to find a
device based on a name for a specific bus.  Give them a simple wrapper
to prevent them from having to always roll their own.

This will be used in the PPC patch later in this series.

Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c     |   41 +++++++++++++++++++++++++++++------------
 include/linux/device.h |    3 +++
 2 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index f484495..055989e 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -163,15 +163,6 @@ static struct kset *bus_kset;
 
 #ifdef CONFIG_HOTPLUG
 /* Manually detach a device from its associated driver. */
-static int driver_helper(struct device *dev, void *data)
-{
-	const char *name = data;
-
-	if (strcmp(name, dev->bus_id) == 0)
-		return 1;
-	return 0;
-}
-
 static ssize_t driver_unbind(struct device_driver *drv,
 			     const char *buf, size_t count)
 {
@@ -179,7 +170,7 @@ static ssize_t driver_unbind(struct device_driver *drv,
 	struct device *dev;
 	int err = -ENODEV;
 
-	dev = bus_find_device(bus, NULL, (void *)buf, driver_helper);
+	dev = bus_find_device_by_name(bus, NULL, buf);
 	if (dev && dev->driver == drv) {
 		if (dev->parent)	/* Needed for USB */
 			down(&dev->parent->sem);
@@ -206,7 +197,7 @@ static ssize_t driver_bind(struct device_driver *drv,
 	struct device *dev;
 	int err = -ENODEV;
 
-	dev = bus_find_device(bus, NULL, (void *)buf, driver_helper);
+	dev = bus_find_device_by_name(bus, NULL, buf);
 	if (dev && dev->driver == NULL) {
 		if (dev->parent)	/* Needed for USB */
 			down(&dev->parent->sem);
@@ -250,7 +241,7 @@ static ssize_t store_drivers_probe(struct bus_type *bus,
 {
 	struct device *dev;
 
-	dev = bus_find_device(bus, NULL, (void *)buf, driver_helper);
+	dev = bus_find_device_by_name(bus, NULL, buf);
 	if (!dev)
 		return -ENODEV;
 	if (bus_rescan_devices_helper(dev, NULL) != 0)
@@ -338,6 +329,32 @@ struct device *bus_find_device(struct bus_type *bus,
 }
 EXPORT_SYMBOL_GPL(bus_find_device);
 
+static int match_name(struct device *dev, void *data)
+{
+	const char *name = data;
+
+	if (strcmp(name, dev->bus_id) == 0)
+		return 1;
+	return 0;
+}
+
+/**
+ * bus_find_device_by_name - device iterator for locating a particular device of a specific name
+ * @bus: bus type
+ * @start: Device to begin with
+ * @name: name of the device to match
+ *
+ * This is similar to the bus_find_device() function above, but it handles
+ * searching by a name automatically, no need to write another strcmp matching
+ * function.
+ */
+struct device *bus_find_device_by_name(struct bus_type *bus,
+				       struct device *start, const char *name)
+{
+	return bus_find_device(bus, start, (void *)name, match_name);
+}
+EXPORT_SYMBOL_GPL(bus_find_device_by_name);
+
 static struct device_driver *next_driver(struct klist_iter *i)
 {
 	struct klist_node *n = klist_next(i);
diff --git a/include/linux/device.h b/include/linux/device.h
index 1880208..db375be 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -84,6 +84,9 @@ int bus_for_each_dev(struct bus_type *bus, struct device *start, void *data,
 struct device *bus_find_device(struct bus_type *bus, struct device *start,
 			       void *data,
 			       int (*match)(struct device *dev, void *data));
+struct device *bus_find_device_by_name(struct bus_type *bus,
+				       struct device *start,
+				       const char *name);
 
 int __must_check bus_for_each_drv(struct bus_type *bus,
 				  struct device_driver *start, void *data,
-- 
1.5.3.8

