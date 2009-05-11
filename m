Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZEKTCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZEKTCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZEKTCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:02:12 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:47676 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbZEKTCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=reExUcj1ryQZmwefpq4lCfgwk8LSfgckyXLcw7n0DyBbiqP/iFD2vJuC+RWv+AYkoo
         94ACvHePnyPnXLarIvVf7aPYRJCNQhF/s0Ck9YSePJRq6f2oJ2O7n73zNIEGTjlQC33Z
         BcMmLzUSLoNa3KlmbtZ0zFRnhU/NnxS/CUDJw=
Message-ID: <4A087630.30802@gmail.com>
Date: Mon, 11 May 2009 21:02:08 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: jeremy@xensource.com
CC: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/blkfront: remove driver_data direct access of struct
 device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid direct access to the driver_data pointer in struct device, the
functions dev_get_drvdata() and dev_set_drvdata() should be used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 8f90508..ff09809 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -755,12 +755,12 @@ static int blkfront_probe(struct xenbus_device *dev,
 
 	/* Front end dir is a number, which is used as the id. */
 	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
-	dev->dev.driver_data = info;
+	dev_set_drvdata(&dev->dev, info);
 
 	err = talk_to_backend(dev, info);
 	if (err) {
 		kfree(info);
-		dev->dev.driver_data = NULL;
+		dev_set_drvdata(&dev->dev, NULL);
 		return err;
 	}
 
@@ -845,7 +845,7 @@ static int blkif_recover(struct blkfront_info *info)
  */
 static int blkfront_resume(struct xenbus_device *dev)
 {
-	struct blkfront_info *info = dev->dev.driver_data;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 	int err;
 
 	dev_dbg(&dev->dev, "blkfront_resume: %s\n", dev->nodename);
@@ -924,7 +924,7 @@ static void blkfront_connect(struct blkfront_info *info)
  */
 static void blkfront_closing(struct xenbus_device *dev)
 {
-	struct blkfront_info *info = dev->dev.driver_data;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 	unsigned long flags;
 
 	dev_dbg(&dev->dev, "blkfront_closing: %s removed\n", dev->nodename);
@@ -959,7 +959,7 @@ static void blkfront_closing(struct xenbus_device *dev)
 static void backend_changed(struct xenbus_device *dev,
 			    enum xenbus_state backend_state)
 {
-	struct blkfront_info *info = dev->dev.driver_data;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 	struct block_device *bd;
 
 	dev_dbg(&dev->dev, "blkfront:backend_changed.\n");
@@ -997,7 +997,7 @@ static void backend_changed(struct xenbus_device *dev,
 
 static int blkfront_remove(struct xenbus_device *dev)
 {
-	struct blkfront_info *info = dev->dev.driver_data;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 
 	dev_dbg(&dev->dev, "blkfront_remove: %s removed\n", dev->nodename);
 
@@ -1010,7 +1010,7 @@ static int blkfront_remove(struct xenbus_device *dev)
 
 static int blkfront_is_ready(struct xenbus_device *dev)
 {
-	struct blkfront_info *info = dev->dev.driver_data;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 
 	return info->is_ready;
 }
