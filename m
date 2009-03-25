Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbZCYAlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbZCYAlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbZCYAaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:11 -0400
Received: from kroah.org ([198.145.64.141]:54123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756874AbZCYAaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/61] driver core: check bus->match without holding device lock
Date: Tue, 24 Mar 2009 17:26:36 -0700
Message-Id: <1237940825-22904-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch moves bus->match out from driver_probe_device and
does not hold device lock to check the match between a device
and a driver.

The idea has been verified by the commit 6cd495860901,
which leads to a faster boot. But the commit 6cd495860901 has
the following drawbacks: 1),only does the quick check in
the path of __driver_attach->driver_probe_device, not in other
paths; 2),for a matched device and driver, check the same match
twice. It is a waste of cpu ,especially for some drivers with long
device id table (eg. usb-storage driver).

This patch adds a helper of driver_match_device to check the match
in all paths, and testes the match only once.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h |    5 +++++
 drivers/base/bus.c  |    2 +-
 drivers/base/dd.c   |   19 +++++++------------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 9f50f1b..ca2b037 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -86,6 +86,11 @@ extern void bus_remove_driver(struct device_driver *drv);
 
 extern void driver_detach(struct device_driver *drv);
 extern int driver_probe_device(struct device_driver *drv, struct device *dev);
+static inline int driver_match_device(struct device_driver *drv,
+				      struct device *dev)
+{
+	return drv->bus->match && drv->bus->match(dev, drv);
+}
 
 extern void sysdev_shutdown(void);
 
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 83f32b8..8547b78 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -198,7 +198,7 @@ static ssize_t driver_bind(struct device_driver *drv,
 	int err = -ENODEV;
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
-	if (dev && dev->driver == NULL) {
+	if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
 		if (dev->parent)	/* Needed for USB */
 			down(&dev->parent->sem);
 		down(&dev->sem);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 1352312..3f32df7 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -189,14 +189,8 @@ int wait_for_device_probe(void)
  * @drv: driver to bind a device to
  * @dev: device to try to bind to the driver
  *
- * First, we call the bus's match function, if one present, which should
- * compare the device IDs the driver supports with the device IDs of the
- * device. Note we don't do this ourselves because we don't know the
- * format of the ID structures, nor what is to be considered a match and
- * what is not.
- *
- * This function returns 1 if a match is found, -ENODEV if the device is
- * not registered, and 0 otherwise.
+ * This function returns -ENODEV if the device is not registered,
+ * 1 if the device is bound sucessfully and 0 otherwise.
  *
  * This function must be called with @dev->sem held.  When called for a
  * USB interface, @dev->parent->sem must be held as well.
@@ -207,21 +201,22 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 
 	if (!device_is_registered(dev))
 		return -ENODEV;
-	if (drv->bus->match && !drv->bus->match(dev, drv))
-		goto done;
 
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
 		 drv->bus->name, __func__, dev_name(dev), drv->name);
 
 	ret = really_probe(dev, drv);
 
-done:
 	return ret;
 }
 
 static int __device_attach(struct device_driver *drv, void *data)
 {
 	struct device *dev = data;
+
+	if (!driver_match_device(drv, dev))
+		return 0;
+
 	return driver_probe_device(drv, dev);
 }
 
@@ -274,7 +269,7 @@ static int __driver_attach(struct device *dev, void *data)
 	 * is an error.
 	 */
 
-	if (drv->bus->match && !drv->bus->match(dev, drv))
+	if (!driver_match_device(drv, dev))
 		return 0;
 
 	if (dev->parent)	/* Needed for USB */
-- 
1.6.2

