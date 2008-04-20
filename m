Return-Path: <linux-kernel-owner+w=401wt.eu-S1763285AbYDTKsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763285AbYDTKsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbYDTKkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56336 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192AbYDTKkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 24/36] Driver core: make device_is_registered() work for class devices
Date: Sun, 20 Apr 2008 03:45:54 -0700
Message-Id: <1208688366-9252-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_is_registered() can use the kobject value for this, so it will
now work with devices that are associated with only a class, not a bus
and a driver.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c     |    9 ++-------
 include/linux/device.h |    3 +--
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 2d207ad..450942a 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -505,14 +505,11 @@ void bus_attach_device(struct device *dev)
 	int ret = 0;
 
 	if (bus) {
-		dev->is_registered = 1;
 		if (bus->p->drivers_autoprobe)
 			ret = device_attach(dev);
 		WARN_ON(ret < 0);
 		if (ret >= 0)
 			klist_add_tail(&dev->knode_bus, &bus->p->klist_devices);
-		else
-			dev->is_registered = 0;
 	}
 }
 
@@ -533,10 +530,8 @@ void bus_remove_device(struct device *dev)
 		sysfs_remove_link(&dev->bus->p->devices_kset->kobj,
 				  dev->bus_id);
 		device_remove_attrs(dev->bus, dev);
-		if (dev->is_registered) {
-			dev->is_registered = 0;
-			klist_del(&dev->knode_bus);
-		}
+		klist_del(&dev->knode_bus);
+
 		pr_debug("bus: '%s': remove device %s\n",
 			 dev->bus->name, dev->bus_id);
 		device_release_driver(dev);
diff --git a/include/linux/device.h b/include/linux/device.h
index d7a1ae0..441461f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -429,7 +429,6 @@ struct device {
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	struct device_type	*type;
-	unsigned		is_registered:1;
 	unsigned		uevent_suppress:1;
 
 	struct semaphore	sem;	/* semaphore to synchronize calls to
@@ -509,7 +508,7 @@ static inline void dev_set_drvdata(struct device *dev, void *data)
 
 static inline int device_is_registered(struct device *dev)
 {
-	return dev->is_registered;
+	return dev->kobj.state_in_sysfs;
 }
 
 void driver_init(void);
-- 
1.5.4.5

