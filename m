Return-Path: <linux-kernel-owner+w=401wt.eu-S1761967AbXJDLll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967AbXJDLll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbXJDL32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:29:28 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:58196 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbXJDL2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:25 -0400
Message-Id: <20071004112827.021050079@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:15 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 09/34] cio: Introduce ccw_bus_type.shutdown.
Content-Disposition: inline; filename=009-cio-shutdown.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Introduce a shutdown method for the ccw bus that calls the driver
specific shutdown method in struct ccw_driver.
Switch zfcp to the new ccw_driver shutdown method.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c    |   10 ++++++++++
 drivers/s390/scsi/zfcp_ccw.c |   10 ++++------
 include/asm-s390/ccwdev.h    |    2 ++
 3 files changed, 16 insertions(+), 6 deletions(-)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c
+++ quilt-2.6/drivers/s390/cio/device.c
@@ -1433,12 +1433,22 @@ ccw_device_remove (struct device *dev)
 	return 0;
 }
 
+static void ccw_device_shutdown(struct device *dev)
+{
+	struct ccw_device *cdev;
+
+	cdev = to_ccwdev(dev);
+	if (cdev->drv && cdev->drv->shutdown)
+		cdev->drv->shutdown(cdev);
+}
+
 struct bus_type ccw_bus_type = {
 	.name   = "ccw",
 	.match  = ccw_bus_match,
 	.uevent = ccw_uevent,
 	.probe  = ccw_device_probe,
 	.remove = ccw_device_remove,
+	.shutdown = ccw_device_shutdown,
 };
 
 /**
Index: quilt-2.6/drivers/s390/scsi/zfcp_ccw.c
===================================================================
--- quilt-2.6.orig/drivers/s390/scsi/zfcp_ccw.c
+++ quilt-2.6/drivers/s390/scsi/zfcp_ccw.c
@@ -28,7 +28,7 @@ static void zfcp_ccw_remove(struct ccw_d
 static int zfcp_ccw_set_online(struct ccw_device *);
 static int zfcp_ccw_set_offline(struct ccw_device *);
 static int zfcp_ccw_notify(struct ccw_device *, int);
-static void zfcp_ccw_shutdown(struct device *);
+static void zfcp_ccw_shutdown(struct ccw_device *);
 
 static struct ccw_device_id zfcp_ccw_device_id[] = {
 	{CCW_DEVICE_DEVTYPE(ZFCP_CONTROL_UNIT_TYPE,
@@ -51,9 +51,7 @@ static struct ccw_driver zfcp_ccw_driver
 	.set_online  = zfcp_ccw_set_online,
 	.set_offline = zfcp_ccw_set_offline,
 	.notify      = zfcp_ccw_notify,
-	.driver      = {
-		.shutdown = zfcp_ccw_shutdown,
-	},
+	.shutdown    = zfcp_ccw_shutdown,
 };
 
 MODULE_DEVICE_TABLE(ccw, zfcp_ccw_device_id);
@@ -277,12 +275,12 @@ zfcp_ccw_register(void)
  * Makes sure that QDIO queues are down when the system gets stopped.
  */
 static void
-zfcp_ccw_shutdown(struct device *dev)
+zfcp_ccw_shutdown(struct ccw_device *cdev)
 {
 	struct zfcp_adapter *adapter;
 
 	down(&zfcp_data.config_sema);
-	adapter = dev_get_drvdata(dev);
+	adapter = dev_get_drvdata(&cdev->dev);
 	zfcp_erp_adapter_shutdown(adapter, 0);
 	zfcp_erp_wait(adapter);
 	up(&zfcp_data.config_sema);
Index: quilt-2.6/include/asm-s390/ccwdev.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/ccwdev.h
+++ quilt-2.6/include/asm-s390/ccwdev.h
@@ -102,6 +102,7 @@ struct ccw_device {
  * @set_online: called when setting device online
  * @set_offline: called when setting device offline
  * @notify: notify driver of device state changes
+ * @shutdown: called at device shutdown
  * @driver: embedded device driver structure
  * @name: device driver name
  */
@@ -113,6 +114,7 @@ struct ccw_driver {
 	int (*set_online) (struct ccw_device *);
 	int (*set_offline) (struct ccw_device *);
 	int (*notify) (struct ccw_device *, int);
+	void (*shutdown) (struct ccw_device *);
 	struct device_driver driver;
 	char *name;
 };

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

