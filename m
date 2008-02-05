Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYBEPos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYBEPos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbYBEPjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:39:47 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:3803 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYBEPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:39:17 -0500
Message-Id: <20080205153911.471667072@de.ibm.com>
References: <20080205153835.337897404@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 05 Feb 2008 16:38:39 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 04/18] cio: Add shutdown callback for ccwgroup.
Content-Disposition: inline; filename=004-cio-shutdown.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

This intendeds to make proper shutdown of qeth devices easier.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/ccwgroup.c |   12 ++++++++++++
 include/asm-s390/ccwgroup.h |    2 ++
 2 files changed, 14 insertions(+)

Index: quilt-2.6/drivers/s390/cio/ccwgroup.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/ccwgroup.c
+++ quilt-2.6/drivers/s390/cio/ccwgroup.c
@@ -391,12 +391,24 @@ ccwgroup_remove (struct device *dev)
 	return 0;
 }
 
+static void ccwgroup_shutdown(struct device *dev)
+{
+	struct ccwgroup_device *gdev;
+	struct ccwgroup_driver *gdrv;
+
+	gdev = to_ccwgroupdev(dev);
+	gdrv = to_ccwgroupdrv(dev->driver);
+	if (gdrv && gdrv->shutdown)
+		gdrv->shutdown(gdev);
+}
+
 static struct bus_type ccwgroup_bus_type = {
 	.name   = "ccwgroup",
 	.match  = ccwgroup_bus_match,
 	.uevent = ccwgroup_uevent,
 	.probe  = ccwgroup_probe,
 	.remove = ccwgroup_remove,
+	.shutdown = ccwgroup_shutdown,
 };
 
 /**
Index: quilt-2.6/include/asm-s390/ccwgroup.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/ccwgroup.h
+++ quilt-2.6/include/asm-s390/ccwgroup.h
@@ -37,6 +37,7 @@ struct ccwgroup_device {
  * @remove: function called on remove
  * @set_online: function called when device is set online
  * @set_offline: function called when device is set offline
+ * @shutdown: function called when device is shut down
  * @driver: embedded driver structure
  */
 struct ccwgroup_driver {
@@ -49,6 +50,7 @@ struct ccwgroup_driver {
 	void (*remove) (struct ccwgroup_device *);
 	int (*set_online) (struct ccwgroup_device *);
 	int (*set_offline) (struct ccwgroup_device *);
+	void (*shutdown)(struct ccwgroup_device *);
 
 	struct device_driver driver;
 };

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

