Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbXJLWXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbXJLWXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761049AbXJLWS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:29 -0400
Received: from ns.suse.de ([195.135.220.2]:53129 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759692AbXJLWS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/75] Driver core: remove get_bus()
Date: Fri, 12 Oct 2007 15:16:15 -0700
Message-Id: <11922274901810-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922274853108-git-send-email-gregkh@suse.de>
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

diff --git a/drivers/base/base.h b/drivers/base/base.h
index cebc7e7..10b2fb6 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -18,7 +18,6 @@ extern int attribute_container_init(void);
 extern int bus_add_device(struct device * dev);
 extern void bus_attach_device(struct device * dev);
 extern void bus_remove_device(struct device * dev);
-extern struct bus_type *get_bus(struct bus_type * bus);
 
 extern int bus_add_driver(struct device_driver *);
 extern void bus_remove_driver(struct device_driver *);
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 4f53b75..0a8d075 100644
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
@@ -127,7 +133,7 @@ static struct sysfs_ops bus_sysfs_ops = {
 int bus_create_file(struct bus_type * bus, struct bus_attribute * attr)
 {
 	int error;
-	if (get_bus(bus)) {
+	if (bus_get(bus)) {
 		error = sysfs_create_file(&bus->subsys.kobj, &attr->attr);
 		bus_put(bus);
 	} else
@@ -137,7 +143,7 @@ int bus_create_file(struct bus_type * bus, struct bus_attribute * attr)
 
 void bus_remove_file(struct bus_type * bus, struct bus_attribute * attr)
 {
-	if (get_bus(bus)) {
+	if (bus_get(bus)) {
 		sysfs_remove_file(&bus->subsys.kobj, &attr->attr);
 		bus_put(bus);
 	}
@@ -177,7 +183,7 @@ static int driver_helper(struct device *dev, void *data)
 static ssize_t driver_unbind(struct device_driver *drv,
 			     const char *buf, size_t count)
 {
-	struct bus_type *bus = get_bus(drv->bus);
+	struct bus_type *bus = bus_get(drv->bus);
 	struct device *dev;
 	int err = -ENODEV;
 
@@ -204,7 +210,7 @@ static DRIVER_ATTR(unbind, S_IWUSR, NULL, driver_unbind);
 static ssize_t driver_bind(struct device_driver *drv,
 			   const char *buf, size_t count)
 {
-	struct bus_type *bus = get_bus(drv->bus);
+	struct bus_type *bus = bus_get(drv->bus);
 	struct device *dev;
 	int err = -ENODEV;
 
@@ -435,7 +441,7 @@ static inline void remove_deprecated_bus_links(struct device *dev) { }
  */
 int bus_add_device(struct device * dev)
 {
-	struct bus_type * bus = get_bus(dev->bus);
+	struct bus_type * bus = bus_get(dev->bus);
 	int error = 0;
 
 	if (bus) {
@@ -611,7 +617,7 @@ static inline void remove_probe_files(struct bus_type *bus) {}
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
-- 
1.5.3.4

