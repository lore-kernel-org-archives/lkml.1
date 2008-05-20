Return-Path: <linux-kernel-owner+w=401wt.eu-S935041AbYETWiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935041AbYETWiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935001AbYETWf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:35:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:39756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935010AbYETWfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:35:53 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH 05/13] IB: fix race in device_create
Date: Tue, 20 May 2008 15:34:52 -0700
Message-Id: <1211322900-12705-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520223237.GA12383@suse.de>
References: <20080520223237.GA12383@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race from when a device is created with device_create() and
then the drvdata is set with a call to dev_set_drvdata() in which a
sysfs file could be open, yet the drvdata will be NULL, causing all
sorts of bad things to happen.

This patch fixes the problem by using the new function,
device_create_drvdata().

Cc: Kay Sievers <kay.sievers@vrfy.org>
Reviewed-by: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/core/user_mad.c    |   14 ++++++--------
 drivers/infiniband/core/uverbs_main.c |   11 ++++++-----
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 3aa2db5..840ede9 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1005,8 +1005,9 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (cdev_add(port->cdev, base_dev + port->dev_num, 1))
 		goto err_cdev;
 
-	port->dev = device_create(umad_class, device->dma_device,
-				  port->cdev->dev, "umad%d", port->dev_num);
+	port->dev = device_create_drvdata(umad_class, device->dma_device,
+					  port->cdev->dev, port,
+					  "umad%d", port->dev_num);
 	if (IS_ERR(port->dev))
 		goto err_cdev;
 
@@ -1024,15 +1025,12 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (cdev_add(port->sm_cdev, base_dev + port->dev_num + IB_UMAD_MAX_PORTS, 1))
 		goto err_sm_cdev;
 
-	port->sm_dev = device_create(umad_class, device->dma_device,
-				     port->sm_cdev->dev,
-				     "issm%d", port->dev_num);
+	port->sm_dev = device_create_drvdata(umad_class, device->dma_device,
+					     port->sm_cdev->dev, port,
+					     "issm%d", port->dev_num);
 	if (IS_ERR(port->sm_dev))
 		goto err_sm_cdev;
 
-	dev_set_drvdata(port->dev,    port);
-	dev_set_drvdata(port->sm_dev, port);
-
 	if (device_create_file(port->sm_dev, &dev_attr_ibdev))
 		goto err_sm_dev;
 	if (device_create_file(port->sm_dev, &dev_attr_port))
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index cc1afa2..f806da1 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -755,14 +755,15 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	if (cdev_add(uverbs_dev->cdev, IB_UVERBS_BASE_DEV + uverbs_dev->devnum, 1))
 		goto err_cdev;
 
-	uverbs_dev->dev = device_create(uverbs_class, device->dma_device,
-					uverbs_dev->cdev->dev,
-					"uverbs%d", uverbs_dev->devnum);
+	uverbs_dev->dev = device_create_drvdata(uverbs_class,
+						device->dma_device,
+						uverbs_dev->cdev->dev,
+						uverbs_dev,
+						"uverbs%d",
+						uverbs_dev->devnum);
 	if (IS_ERR(uverbs_dev->dev))
 		goto err_cdev;
 
-	dev_set_drvdata(uverbs_dev->dev, uverbs_dev);
-
 	if (device_create_file(uverbs_dev->dev, &dev_attr_ibdev))
 		goto err_class;
 	if (device_create_file(uverbs_dev->dev, &dev_attr_abi_version))
-- 
1.5.5.1

