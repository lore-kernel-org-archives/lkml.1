Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbZFDQZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbZFDQZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbZFDQTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:19:43 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57263 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbZFDQT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:19:28 -0400
Message-Id: <20090604161901.134194989@de.ibm.com>
References: <20090604161847.513682672@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 18:18:54 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sebastian Ott <sebott@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 07/38] pm: ccwgroup bus power management callbacks
Content-Disposition: inline; filename=pm_ccwgroup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/include/asm/ccwgroup.h |   10 +++++
 drivers/s390/cio/ccwgroup.c      |   78 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 83 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/s390/cio/ccwgroup.c
===================================================================
--- linux-2.6.orig/drivers/s390/cio/ccwgroup.c
+++ linux-2.6/drivers/s390/cio/ccwgroup.c
@@ -1,11 +1,10 @@
 /*
- *  drivers/s390/cio/ccwgroup.c
  *  bus driver for ccwgroup
  *
- *    Copyright (C) 2002 IBM Deutschland Entwicklung GmbH,
- *                       IBM Corporation
- *    Author(s): Arnd Bergmann (arndb@de.ibm.com)
- *               Cornelia Huck (cornelia.huck@de.ibm.com)
+ *  Copyright IBM Corp. 2002, 2009
+ *
+ *  Author(s): Arnd Bergmann (arndb@de.ibm.com)
+ *             Cornelia Huck (cornelia.huck@de.ibm.com)
  */
 #include <linux/module.h>
 #include <linux/errno.h>
@@ -501,6 +500,74 @@ static void ccwgroup_shutdown(struct dev
 		gdrv->shutdown(gdev);
 }
 
+static int ccwgroup_pm_prepare(struct device *dev)
+{
+	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
+	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(gdev->dev.driver);
+
+	/* Fail while device is being set online/offline. */
+	if (atomic_read(&gdev->onoff))
+		return -EAGAIN;
+
+	if (!gdev->dev.driver || gdev->state != CCWGROUP_ONLINE)
+		return 0;
+
+	return gdrv->prepare ? gdrv->prepare(gdev) : 0;
+}
+
+static void ccwgroup_pm_complete(struct device *dev)
+{
+	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
+	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(dev->driver);
+
+	if (!gdev->dev.driver || gdev->state != CCWGROUP_ONLINE)
+		return;
+
+	if (gdrv->complete)
+		gdrv->complete(gdev);
+}
+
+static int ccwgroup_pm_freeze(struct device *dev)
+{
+	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
+	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(gdev->dev.driver);
+
+	if (!gdev->dev.driver || gdev->state != CCWGROUP_ONLINE)
+		return 0;
+
+	return gdrv->freeze ? gdrv->freeze(gdev) : 0;
+}
+
+static int ccwgroup_pm_thaw(struct device *dev)
+{
+	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
+	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(gdev->dev.driver);
+
+	if (!gdev->dev.driver || gdev->state != CCWGROUP_ONLINE)
+		return 0;
+
+	return gdrv->thaw ? gdrv->thaw(gdev) : 0;
+}
+
+static int ccwgroup_pm_restore(struct device *dev)
+{
+	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
+	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(gdev->dev.driver);
+
+	if (!gdev->dev.driver || gdev->state != CCWGROUP_ONLINE)
+		return 0;
+
+	return gdrv->restore ? gdrv->restore(gdev) : 0;
+}
+
+static struct dev_pm_ops ccwgroup_pm_ops = {
+	.prepare = ccwgroup_pm_prepare,
+	.complete = ccwgroup_pm_complete,
+	.freeze = ccwgroup_pm_freeze,
+	.thaw = ccwgroup_pm_thaw,
+	.restore = ccwgroup_pm_restore,
+};
+
 static struct bus_type ccwgroup_bus_type = {
 	.name   = "ccwgroup",
 	.match  = ccwgroup_bus_match,
@@ -508,6 +575,7 @@ static struct bus_type ccwgroup_bus_type
 	.probe  = ccwgroup_probe,
 	.remove = ccwgroup_remove,
 	.shutdown = ccwgroup_shutdown,
+	.pm = &ccwgroup_pm_ops,
 };
 
 
Index: linux-2.6/arch/s390/include/asm/ccwgroup.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/ccwgroup.h
+++ linux-2.6/arch/s390/include/asm/ccwgroup.h
@@ -38,6 +38,11 @@ struct ccwgroup_device {
  * @set_online: function called when device is set online
  * @set_offline: function called when device is set offline
  * @shutdown: function called when device is shut down
+ * @prepare: prepare for pm state transition
+ * @complete: undo work done in @prepare
+ * @freeze: callback for freezing during hibernation snapshotting
+ * @thaw: undo work done in @freeze
+ * @restore: callback for restoring after hibernation
  * @driver: embedded driver structure
  */
 struct ccwgroup_driver {
@@ -51,6 +56,11 @@ struct ccwgroup_driver {
 	int (*set_online) (struct ccwgroup_device *);
 	int (*set_offline) (struct ccwgroup_device *);
 	void (*shutdown)(struct ccwgroup_device *);
+	int (*prepare) (struct ccwgroup_device *);
+	void (*complete) (struct ccwgroup_device *);
+	int (*freeze)(struct ccwgroup_device *);
+	int (*thaw) (struct ccwgroup_device *);
+	int (*restore)(struct ccwgroup_device *);
 
 	struct device_driver driver;
 };

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

