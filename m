Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYJPRRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYJPRRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbYJPROL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:11 -0400
Received: from kroah.org ([198.145.64.141]:46929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756098AbYJPROJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH 06/46] device create: infiniband: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:07 -0700
Message-Id: <1224177047-11859-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/core/cm.c                 |    6 +++---
 drivers/infiniband/core/user_mad.c           |   12 ++++++------
 drivers/infiniband/core/uverbs_main.c        |    9 +++------
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 3cab0ce..a78d35a 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3691,9 +3691,9 @@ static void cm_add_one(struct ib_device *ib_device)
 	cm_dev->ib_device = ib_device;
 	cm_get_ack_delay(cm_dev);
 
-	cm_dev->device = device_create_drvdata(&cm_class, &ib_device->dev,
-					       MKDEV(0, 0), NULL,
-					       "%s", ib_device->name);
+	cm_dev->device = device_create(&cm_class, &ib_device->dev,
+				       MKDEV(0, 0), NULL,
+				       "%s", ib_device->name);
 	if (!cm_dev->device) {
 		kfree(cm_dev);
 		return;
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 268a2d2..8c46f22 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1016,9 +1016,9 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (cdev_add(port->cdev, base_dev + port->dev_num, 1))
 		goto err_cdev;
 
-	port->dev = device_create_drvdata(umad_class, device->dma_device,
-					  port->cdev->dev, port,
-					  "umad%d", port->dev_num);
+	port->dev = device_create(umad_class, device->dma_device,
+				  port->cdev->dev, port,
+				  "umad%d", port->dev_num);
 	if (IS_ERR(port->dev))
 		goto err_cdev;
 
@@ -1036,9 +1036,9 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (cdev_add(port->sm_cdev, base_dev + port->dev_num + IB_UMAD_MAX_PORTS, 1))
 		goto err_sm_cdev;
 
-	port->sm_dev = device_create_drvdata(umad_class, device->dma_device,
-					     port->sm_cdev->dev, port,
-					     "issm%d", port->dev_num);
+	port->sm_dev = device_create(umad_class, device->dma_device,
+				     port->sm_cdev->dev, port,
+				     "issm%d", port->dev_num);
 	if (IS_ERR(port->sm_dev))
 		goto err_sm_cdev;
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index aeee856..d85af1b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -764,12 +764,9 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	if (cdev_add(uverbs_dev->cdev, IB_UVERBS_BASE_DEV + uverbs_dev->devnum, 1))
 		goto err_cdev;
 
-	uverbs_dev->dev = device_create_drvdata(uverbs_class,
-						device->dma_device,
-						uverbs_dev->cdev->dev,
-						uverbs_dev,
-						"uverbs%d",
-						uverbs_dev->devnum);
+	uverbs_dev->dev = device_create(uverbs_class, device->dma_device,
+					uverbs_dev->cdev->dev, uverbs_dev,
+					"uverbs%d", uverbs_dev->devnum);
 	if (IS_ERR(uverbs_dev->dev))
 		goto err_cdev;
 
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 56c0eda..1af1f3a 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -2455,7 +2455,7 @@ static int init_cdev(int minor, char *name, const struct file_operations *fops,
 		goto err_cdev;
 	}
 
-	device = device_create_drvdata(ipath_class, NULL, dev, NULL, name);
+	device = device_create(ipath_class, NULL, dev, NULL, name);
 
 	if (IS_ERR(device)) {
 		ret = PTR_ERR(device);
-- 
1.6.0.2

