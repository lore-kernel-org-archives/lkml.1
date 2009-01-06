Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbZAFWVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbZAFWVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZAFWNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:44 -0500
Received: from kroah.org ([198.145.64.141]:51239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755937AbZAFWNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:41 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/60] xen: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:43 -0800
Message-Id: <1231279939-32728-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

CC: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/xen/xenbus/xenbus_probe.c |   27 +++++++++++++++------------
 drivers/xen/xenbus/xenbus_probe.h |    4 +++-
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 7f24a98..b2a0318 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -99,15 +99,15 @@ static int xenbus_uevent(struct device *_dev, struct kobj_uevent_env *env)
 }
 
 /* device/<type>/<id> => <type>-<id> */
-static int frontend_bus_id(char bus_id[BUS_ID_SIZE], const char *nodename)
+static int frontend_bus_id(char bus_id[XEN_BUS_ID_SIZE], const char *nodename)
 {
 	nodename = strchr(nodename, '/');
-	if (!nodename || strlen(nodename + 1) >= BUS_ID_SIZE) {
+	if (!nodename || strlen(nodename + 1) >= XEN_BUS_ID_SIZE) {
 		printk(KERN_WARNING "XENBUS: bad frontend %s\n", nodename);
 		return -EINVAL;
 	}
 
-	strlcpy(bus_id, nodename + 1, BUS_ID_SIZE);
+	strlcpy(bus_id, nodename + 1, XEN_BUS_ID_SIZE);
 	if (!strchr(bus_id, '/')) {
 		printk(KERN_WARNING "XENBUS: bus_id %s no slash\n", bus_id);
 		return -EINVAL;
@@ -460,6 +460,7 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 		      const char *type,
 		      const char *nodename)
 {
+	char devname[XEN_BUS_ID_SIZE];
 	int err;
 	struct xenbus_device *xendev;
 	size_t stringlen;
@@ -494,10 +495,12 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 	xendev->dev.bus = &bus->bus;
 	xendev->dev.release = xenbus_dev_release;
 
-	err = bus->get_bus_id(xendev->dev.bus_id, xendev->nodename);
+	err = bus->get_bus_id(devname, xendev->nodename);
 	if (err)
 		goto fail;
 
+	dev_set_name(&xendev->dev, devname);
+
 	/* Register with generic device framework. */
 	err = device_register(&xendev->dev);
 	if (err)
@@ -611,7 +614,7 @@ void xenbus_dev_changed(const char *node, struct xen_bus_type *bus)
 {
 	int exists, rootlen;
 	struct xenbus_device *dev;
-	char type[BUS_ID_SIZE];
+	char type[XEN_BUS_ID_SIZE];
 	const char *p, *root;
 
 	if (char_count(node, '/') < 2)
@@ -625,8 +628,8 @@ void xenbus_dev_changed(const char *node, struct xen_bus_type *bus)
 
 	/* backend/<type>/... or device/<type>/... */
 	p = strchr(node, '/') + 1;
-	snprintf(type, BUS_ID_SIZE, "%.*s", (int)strcspn(p, "/"), p);
-	type[BUS_ID_SIZE-1] = '\0';
+	snprintf(type, XEN_BUS_ID_SIZE, "%.*s", (int)strcspn(p, "/"), p);
+	type[XEN_BUS_ID_SIZE-1] = '\0';
 
 	rootlen = strsep_len(node, '/', bus->levels);
 	if (rootlen < 0)
@@ -674,7 +677,7 @@ static int suspend_dev(struct device *dev, void *data)
 		err = drv->suspend(xdev);
 	if (err)
 		printk(KERN_WARNING
-		       "xenbus: suspend %s failed: %i\n", dev->bus_id, err);
+		       "xenbus: suspend %s failed: %i\n", dev_name(dev), err);
 	return 0;
 }
 
@@ -695,7 +698,7 @@ static int suspend_cancel_dev(struct device *dev, void *data)
 	if (err)
 		printk(KERN_WARNING
 		       "xenbus: suspend_cancel %s failed: %i\n",
-		       dev->bus_id, err);
+		       dev_name(dev), err);
 	return 0;
 }
 
@@ -717,7 +720,7 @@ static int resume_dev(struct device *dev, void *data)
 	if (err) {
 		printk(KERN_WARNING
 		       "xenbus: resume (talk_to_otherend) %s failed: %i\n",
-		       dev->bus_id, err);
+		       dev_name(dev), err);
 		return err;
 	}
 
@@ -728,7 +731,7 @@ static int resume_dev(struct device *dev, void *data)
 		if (err) {
 			printk(KERN_WARNING
 			       "xenbus: resume %s failed: %i\n",
-			       dev->bus_id, err);
+			       dev_name(dev), err);
 			return err;
 		}
 	}
@@ -737,7 +740,7 @@ static int resume_dev(struct device *dev, void *data)
 	if (err) {
 		printk(KERN_WARNING
 		       "xenbus_probe: resume (watch_otherend) %s failed: "
-		       "%d.\n", dev->bus_id, err);
+		       "%d.\n", dev_name(dev), err);
 		return err;
 	}
 
diff --git a/drivers/xen/xenbus/xenbus_probe.h b/drivers/xen/xenbus/xenbus_probe.h
index e09b194..6c5e318 100644
--- a/drivers/xen/xenbus/xenbus_probe.h
+++ b/drivers/xen/xenbus/xenbus_probe.h
@@ -34,6 +34,8 @@
 #ifndef _XENBUS_PROBE_H
 #define _XENBUS_PROBE_H
 
+#define XEN_BUS_ID_SIZE			20
+
 #ifdef CONFIG_XEN_BACKEND
 extern void xenbus_backend_suspend(int (*fn)(struct device *, void *));
 extern void xenbus_backend_resume(int (*fn)(struct device *, void *));
@@ -52,7 +54,7 @@ struct xen_bus_type
 {
 	char *root;
 	unsigned int levels;
-	int (*get_bus_id)(char bus_id[BUS_ID_SIZE], const char *nodename);
+	int (*get_bus_id)(char bus_id[XEN_BUS_ID_SIZE], const char *nodename);
 	int (*probe)(const char *type, const char *dir);
 	struct bus_type bus;
 };
-- 
1.6.0.4

