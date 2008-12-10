Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYLJQ0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYLJQ0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYLJQ0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:26:32 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36207 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbYLJQ0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:26:31 -0500
Date: Wed, 10 Dec 2008 17:26:26 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/28] drivers/base/platform.c: Drop return value from
 platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The return value of the remove function of a driver structure, and thus of
a platform_driver structure, is ultimately ignored, and is thus
unnecessary.  The goal of this patch is to make it possible to convert the
platform_driver functions stored in the remove field such that they return
void.  This patch introduces a temporary field remove_new with return type
void into the platform_driver structure, and updates the only place that
the remove function is called to call the function in the remove_new field,
if one is available.  The subsequent patches update some drivers to use the
remove_new field.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/base/platform.c         |   16 ++++++++++++++--
 include/linux/platform_device.h |    1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 4b8cc6a..4800110 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -50,6 +50,7 @@ extern void platform_device_put(struct platform_device *pdev);
 struct platform_driver {
 	int (*probe)(struct platform_device *);
 	int (*remove)(struct platform_device *);
+	void (*remove_new)(struct platform_device *);
 	void (*shutdown)(struct platform_device *);
 	int (*suspend)(struct platform_device *, pm_message_t state);
 	int (*suspend_late)(struct platform_device *, pm_message_t state);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index dfcbfe5..2d7b26a 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -459,7 +459,12 @@ static int platform_drv_remove(struct device *_dev)
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
 	struct platform_device *dev = to_platform_device(_dev);
 
-	return drv->remove(dev);
+	if (drv->remove)
+		drv->remove(dev);
+	else
+		drv->remove_new(dev);
+
+	return 0;
 }
 
 static void platform_drv_shutdown(struct device *_dev)
@@ -492,10 +497,17 @@ static int platform_drv_resume(struct device *_dev)
  */
 int platform_driver_register(struct platform_driver *drv)
 {
+	if (drv->remove && drv->remove_new) {
+		printk(KERN_ERR "only one of remove() and "
+				"remove_new() callbacks can be defined, "
+				"aborting...\n");
+		return -EINVAL;
+	}
+
 	drv->driver.bus = &platform_bus_type;
 	if (drv->probe)
 		drv->driver.probe = platform_drv_probe;
-	if (drv->remove)
+	if (drv->remove || drv->remove_new)
 		drv->driver.remove = platform_drv_remove;
 	if (drv->shutdown)
 		drv->driver.shutdown = platform_drv_shutdown;
