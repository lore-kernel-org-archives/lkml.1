Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYJ3TOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYJ3TOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYJ3TOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:14:11 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:29432 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782AbYJ3TOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:14:09 -0400
Subject: xen: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 20:14:05 +0100
Message-Id: <1225394045.21973.44.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: xen: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Jeremy Fitzhardinge <jeremy@goop.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


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


