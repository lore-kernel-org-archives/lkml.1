Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbXI3W7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbXI3W7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbXI3W6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:58:17 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:6619 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbXI3W6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:58:15 -0400
Date: Sun, 30 Sep 2007 16:57:09 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 2/6] Sysace: Use the established platform bus api
In-reply-to: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       axboe@kernel.dk
Message-id: <20070930225707.2476.24080.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

SystemACE uses the platform bus binding, but it doesn't use the
platform bus API.  Move to using the correct API for consistency
sake and future proofing against platform bus changes.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/block/xsysace.c |   48 +++++++++++++++++++++++++++++------------------
 1 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 3ede0b6..b104476 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1060,13 +1060,12 @@ static void __devexit ace_teardown(struct ace_device *ace)
  * Platform Bus Support
  */
 
-static int __devinit ace_probe(struct device *device)
+static int __devinit ace_probe(struct platform_device *dev)
 {
-	struct platform_device *dev = to_platform_device(device);
 	struct ace_device *ace;
 	int i;
 
-	dev_dbg(device, "ace_probe(%p)\n", device);
+	dev_dbg(&dev->dev, "ace_probe(%p)\n", dev);
 
 	/*
 	 * Allocate the ace device structure
@@ -1075,7 +1074,7 @@ static int __devinit ace_probe(struct device *device)
 	if (!ace)
 		goto err_alloc;
 
-	ace->dev = device;
+	ace->dev = &dev->dev;
 	ace->id = dev->id;
 	ace->irq = NO_IRQ;
 
@@ -1089,7 +1088,7 @@ static int __devinit ace_probe(struct device *device)
 	/* FIXME: Should get bus_width from the platform_device struct */
 	ace->bus_width = 1;
 
-	dev_set_drvdata(&dev->dev, ace);
+	platform_set_drvdata(dev, ace);
 
 	/* Call the bus-independant setup code */
 	if (ace_setup(ace) != 0)
@@ -1098,7 +1097,7 @@ static int __devinit ace_probe(struct device *device)
 	return 0;
 
       err_setup:
-	dev_set_drvdata(&dev->dev, NULL);
+	platform_set_drvdata(dev, NULL);
 	kfree(ace);
       err_alloc:
 	printk(KERN_ERR "xsysace: could not initialize device\n");
@@ -1108,25 +1107,27 @@ static int __devinit ace_probe(struct device *device)
 /*
  * Platform bus remove() method
  */
-static int __devexit ace_remove(struct device *device)
+static int __devexit ace_remove(struct platform_device *dev)
 {
-	struct ace_device *ace = dev_get_drvdata(device);
-
-	dev_dbg(device, "ace_remove(%p)\n", device);
+	struct ace_device *ace =  platform_get_drvdata(dev);
+	dev_dbg(&dev->dev, "ace_remove(%p)\n", dev);
 
 	if (ace) {
 		ace_teardown(ace);
+		platform_set_drvdata(dev, NULL);
 		kfree(ace);
 	}
 
 	return 0;
 }
 
-static struct device_driver ace_driver = {
-	.name = "xsysace",
-	.bus = &platform_bus_type,
+static struct platform_driver ace_platform_driver = {
 	.probe = ace_probe,
 	.remove = __devexit_p(ace_remove),
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "xsysace",
+	},
 };
 
 /* ---------------------------------------------------------------------
@@ -1134,20 +1135,31 @@ static struct device_driver ace_driver = {
  */
 static int __init ace_init(void)
 {
+	int rc;
+
 	ace_major = register_blkdev(ace_major, "xsysace");
 	if (ace_major <= 0) {
-		printk(KERN_WARNING "xsysace: register_blkdev() failed\n");
-		return ace_major;
+		rc = -ENOMEM;
+		goto err_blk;
 	}
 
-	pr_debug("Registering Xilinx SystemACE driver, major=%i\n", ace_major);
-	return driver_register(&ace_driver);
+	if ((rc = platform_driver_register(&ace_platform_driver)) != 0)
+		goto err_plat;
+
+	pr_info("Xilinx SystemACE device driver, major=%i\n", ace_major);
+	return 0;
+
+      err_plat:
+	unregister_blkdev(ace_major, "xsysace");
+      err_blk:
+	printk(KERN_ERR "xsysace: registration failed; err=%i\n", rc);
+	return rc;
 }
 
 static void __exit ace_exit(void)
 {
 	pr_debug("Unregistering Xilinx SystemACE driver\n");
-	driver_unregister(&ace_driver);
+	platform_driver_unregister(&ace_platform_driver);
 	unregister_blkdev(ace_major, "xsysace");
 }
 

