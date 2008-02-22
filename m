Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbYBVQ1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbYBVQ1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbYBVQ0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:26:51 -0500
Received: from mail26.svc.cra.dublin.eircom.net ([159.134.118.55]:31938 "HELO
	mail26.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756260AbYBVQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:26:49 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, xen-devel@lists.xensource.com, jeremy@goop.org,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] xen: Module autoprobing support for frontend drivers
Date: Fri, 22 Feb 2008 16:20:17 +0000
Message-Id: <1203697218-32064-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add module aliases to support autoprobing modules
for xen frontend devices.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/block/xen-blkfront.c      |    1 +
 drivers/net/xen-netfront.c        |    1 +
 drivers/xen/xenbus/xenbus_probe.c |   27 +++++++++++++++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9c6f3f9..d0d5a02 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -998,3 +998,4 @@ module_exit(xlblk_exit);
 MODULE_DESCRIPTION("Xen virtual block device frontend");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(XENVBD_MAJOR);
+MODULE_ALIAS("xen:vbd");
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 7483d45..b3fa27e 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1809,3 +1809,4 @@ module_exit(netif_exit);
 
 MODULE_DESCRIPTION("Xen virtual network device frontend");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("xen:vif");
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 4750de3..336363c 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -88,6 +88,16 @@ int xenbus_match(struct device *_dev, struct device_driver *_drv)
 	return match_device(drv->ids, to_xenbus_device(_dev)) != NULL;
 }
 
+static int xenbus_uevent(struct device *_dev, struct kobj_uevent_env *env)
+{
+	struct xenbus_device *dev = to_xenbus_device(_dev);
+
+	if (add_uevent_var(env, "MODALIAS=xen:%s", dev->devicetype))
+		return -ENOMEM;
+
+	return 0;
+}
+
 /* device/<type>/<id> => <type>-<id> */
 static int frontend_bus_id(char bus_id[BUS_ID_SIZE], const char *nodename)
 {
@@ -166,6 +176,7 @@ static struct xen_bus_type xenbus_frontend = {
 	.bus = {
 		.name     = "xen",
 		.match    = xenbus_match,
+		.uevent   = xenbus_uevent,
 		.probe    = xenbus_dev_probe,
 		.remove   = xenbus_dev_remove,
 		.shutdown = xenbus_dev_shutdown,
@@ -438,6 +449,12 @@ static ssize_t xendev_show_devtype(struct device *dev,
 }
 DEVICE_ATTR(devtype, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_devtype, NULL);
 
+static ssize_t xendev_show_modalias(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "xen:%s\n", to_xenbus_device(dev)->devicetype);
+}
+DEVICE_ATTR(modalias, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_modalias, NULL);
 
 int xenbus_probe_node(struct xen_bus_type *bus,
 		      const char *type,
@@ -492,10 +509,16 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 
 	err = device_create_file(&xendev->dev, &dev_attr_devtype);
 	if (err)
-		goto fail_remove_file;
+		goto fail_remove_nodename;
+
+	err = device_create_file(&xendev->dev, &dev_attr_modalias);
+	if (err)
+		goto fail_remove_devtype;
 
 	return 0;
-fail_remove_file:
+fail_remove_devtype:
+	device_remove_file(&xendev->dev, &dev_attr_devtype);
+fail_remove_nodename:
 	device_remove_file(&xendev->dev, &dev_attr_nodename);
 fail_unregister:
 	device_unregister(&xendev->dev);
-- 
1.5.4.2

