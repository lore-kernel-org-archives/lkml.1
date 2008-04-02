Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbYDBShm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbYDBShm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbYDBSfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:39 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38410 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756874AbYDBSfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:36 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 15 of 24] xen blkfront: Delay wait for block devices until
	after the disk is added
X-Mercurial-Node: a44c031b8520b271479bbd5219719074755234e4
Message-Id: <a44c031b8520b271479b.1207158844@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
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
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c      |   11 +++++++++++
 drivers/xen/xenbus/xenbus_probe.c |    5 ++++-
 include/xen/xenbus.h              |    2 +-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -88,6 +88,7 @@
 	struct blk_shadow shadow[BLK_RING_SIZE];
 	unsigned long shadow_free;
 	int feature_barrier;
+	int is_ready;
 
 	/**
 	 * The number of people holding this device open.  We won't allow a
@@ -839,6 +840,8 @@
 	spin_unlock_irq(&blkif_io_lock);
 
 	add_disk(info->gd);
+
+	info->is_ready = 1;
 }
 
 /**
@@ -931,6 +934,13 @@
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
@@ -977,6 +987,7 @@
 	.remove = blkfront_remove,
 	.resume = blkfront_resume,
 	.otherend_changed = backend_changed,
+	.is_ready = blkfront_is_ready,
 };
 
 static int __init xlblk_init(void)
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -846,6 +846,7 @@
 {
 	struct xenbus_device *xendev = to_xenbus_device(dev);
 	struct device_driver *drv = data;
+	struct xenbus_driver *xendrv;
 
 	/*
 	 * A device with no driver will never connect. We care only about
@@ -858,7 +859,9 @@
 	if (drv && (dev->driver != drv))
 		return 0;
 
-	return (xendev->state != XenbusStateConnected);
+	xendrv = to_xenbus_driver(dev->driver);
+	return (xendev->state != XenbusStateConnected ||
+		(xendrv->is_ready && !xendrv->is_ready(xendev)));
 }
 
 static int exists_disconnected_device(struct device_driver *drv)
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -97,6 +97,7 @@
 	int (*uevent)(struct xenbus_device *, char **, int, char *, int);
 	struct device_driver driver;
 	int (*read_otherend_details)(struct xenbus_device *dev);
+	int (*is_ready)(struct xenbus_device *dev);
 };
 
 static inline struct xenbus_driver *to_xenbus_driver(struct device_driver *drv)


