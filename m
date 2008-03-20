Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYCTJaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYCTJaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 05:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYCTJ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 05:29:46 -0400
Received: from mail05.svc.cra.dublin.eircom.net ([159.134.118.21]:42170 "HELO
	mail05.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753719AbYCTJ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 05:29:42 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christian Limpach <Christian.Limpach@xensource.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] xen blkfront: Delay wait for block devices until after the disk is added.
Date: Thu, 20 Mar 2008 09:29:50 +0000
Message-Id: <1206005390-18306-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Limpach <Christian.Limpach@xensource.com>

When the xen block frontend driver is built as a module the module load
is only synchronous up to the point where the frontend and the backend
become connected rather than when the disk is added.

This means that there can be a race on boot between loading the module and
loading the dm-* modules and doing the scan for LVM physical volumes (all
in the initrd). In the failure case the disk is not present until after the
scan for physical volumes is complete.

Taken from:

  http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/11483a00c017

Signed-off-by: Christian Limpach <Christian.Limpach@xensource.com>
Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/block/xen-blkfront.c      |   11 +++++++++++
 drivers/xen/xenbus/xenbus_probe.c |    5 ++++-
 include/xen/xenbus.h              |    1 +
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9c6f3f9..9d20f54 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -88,6 +88,7 @@ struct blkfront_info
 	struct blk_shadow shadow[BLK_RING_SIZE];
 	unsigned long shadow_free;
 	int feature_barrier;
+	int is_ready;
 
 	/**
 	 * The number of people holding this device open.  We won't allow a
@@ -833,6 +834,8 @@ static void blkfront_connect(struct blkfront_info *info)
 	spin_unlock_irq(&blkif_io_lock);
 
 	add_disk(info->gd);
+
+	info->is_ready = 1;
 }
 
 /**
@@ -925,6 +928,13 @@ static int blkfront_remove(struct xenbus_device *dev)
 	return 0;
 }
 
+static int blkfront_is_ready(struct xenbus_device *dev)
+{
+	struct blkfront_info *info = dev->dev.driver_data;
+
+	return info->is_ready;
+}
+
 static int blkif_open(struct inode *inode, struct file *filep)
 {
 	struct blkfront_info *info = inode->i_bdev->bd_disk->private_data;
@@ -971,6 +981,7 @@ static struct xenbus_driver blkfront = {
 	.remove = blkfront_remove,
 	.resume = blkfront_resume,
 	.otherend_changed = backend_changed,
+	.is_ready = blkfront_is_ready,
 };
 
 static int __init xlblk_init(void)
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 4750de3..88fc5ec 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -846,6 +846,7 @@ static int is_disconnected_device(struct device *dev, void *data)
 {
 	struct xenbus_device *xendev = to_xenbus_device(dev);
 	struct device_driver *drv = data;
+	struct xenbus_driver *xendrv;
 
 	/*
 	 * A device with no driver will never connect. We care only about
@@ -858,7 +859,9 @@ static int is_disconnected_device(struct device *dev, void *data)
 	if (drv && (dev->driver != drv))
 		return 0;
 
-	return (xendev->state != XenbusStateConnected);
+	xendrv = to_xenbus_driver(dev->driver);
+	return (xendev->state != XenbusStateConnected ||
+		(xendrv->is_ready && !xendrv->is_ready(xendev)));
 }
 
 static int exists_disconnected_device(struct device_driver *drv)
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 6f7c290..6369d89 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -97,6 +97,7 @@ struct xenbus_driver {
 	int (*uevent)(struct xenbus_device *, char **, int, char *, int);
 	struct device_driver driver;
 	int (*read_otherend_details)(struct xenbus_device *dev);
+	int (*is_ready)(struct xenbus_device *dev);
 };
 
 static inline struct xenbus_driver *to_xenbus_driver(struct device_driver *drv)
-- 
1.5.4.2

