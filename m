Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbYDBSh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbYDBSh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbYDBSfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:40 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38411 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756915AbYDBSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 16 of 24] xen: Module autoprobing support for frontend drivers
X-Mercurial-Node: fa75e5f029963721e1d79cba06b3bcd6547085c2
Message-Id: <fa75e5f029963721e1d7.1207158845@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Add module aliases to support autoprobing modules
for xen frontend devices.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/block/xen-blkfront.c      |    1 +
 drivers/net/xen-netfront.c        |    1 +
 drivers/xen/xenbus/xenbus_probe.c |   28 +++++++++++++++++++++++++---
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1015,3 +1015,4 @@
 MODULE_DESCRIPTION("Xen virtual block device frontend");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(XENVBD_MAJOR);
+MODULE_ALIAS("xen:vbd");
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1809,3 +1809,4 @@
 
 MODULE_DESCRIPTION("Xen virtual network device frontend");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("xen:vif");
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -88,6 +88,16 @@
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
@@ -166,6 +176,7 @@
 	.bus = {
 		.name     = "xen",
 		.match    = xenbus_match,
+		.uevent   = xenbus_uevent,
 		.probe    = xenbus_dev_probe,
 		.remove   = xenbus_dev_remove,
 		.shutdown = xenbus_dev_shutdown,
@@ -438,6 +449,12 @@
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
@@ -492,10 +509,16 @@
 
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


