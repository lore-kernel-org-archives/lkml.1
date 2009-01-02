Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbZABKr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbZABKr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbZABKmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:42:06 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:37348 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127AbZABKlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:39 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: zorro - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:28 +0100
Message-Id: <1230892892-25751-16-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-15-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-9-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-10-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-11-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-12-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-13-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-14-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-15-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'device_register', declared with attribute
warn_unused_result
warning: ignoring return value of 'device_create_file', declared with
attribute warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/zorro-sysfs.c |   22 +++++++++++++---------
 drivers/zorro/zorro.c       |   17 ++++++++++++++---
 drivers/zorro/zorro.h       |    2 +-
 3 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/zorro/zorro-sysfs.c b/drivers/zorro/zorro-sysfs.c
index 7139ec2..eb924e0 100644
--- a/drivers/zorro/zorro-sysfs.c
+++ b/drivers/zorro/zorro-sysfs.c
@@ -87,18 +87,22 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(modalias, S_IRUGO, modalias_show, NULL);
 
-void zorro_create_sysfs_dev_files(struct zorro_dev *z)
+int zorro_create_sysfs_dev_files(struct zorro_dev *z)
 {
 	struct device *dev = &z->dev;
+	int error;
 
 	/* current configuration's attributes */
-	device_create_file(dev, &dev_attr_id);
-	device_create_file(dev, &dev_attr_type);
-	device_create_file(dev, &dev_attr_serial);
-	device_create_file(dev, &dev_attr_slotaddr);
-	device_create_file(dev, &dev_attr_slotsize);
-	device_create_file(dev, &dev_attr_resource);
-	device_create_file(dev, &dev_attr_modalias);
-	sysfs_create_bin_file(&dev->kobj, &zorro_config_attr);
+	if ((error = device_create_file(dev, &dev_attr_id)) ||
+	    (error = device_create_file(dev, &dev_attr_type)) ||
+	    (error = device_create_file(dev, &dev_attr_serial)) ||
+	    (error = device_create_file(dev, &dev_attr_slotaddr)) ||
+	    (error = device_create_file(dev, &dev_attr_slotsize)) ||
+	    (error = device_create_file(dev, &dev_attr_resource)) ||
+	    (error = device_create_file(dev, &dev_attr_modalias)) ||
+	    (error = sysfs_create_bin_file(&dev->kobj, &zorro_config_attr)))
+		return error;
+
+	return 0;
 }
 
diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index dff16d9..2dda20a 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -130,6 +130,7 @@ static int __init zorro_init(void)
 {
     struct zorro_dev *z;
     unsigned int i;
+    int error;
 
     if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(ZORRO))
 	return 0;
@@ -140,7 +141,11 @@ static int __init zorro_init(void)
     /* Initialize the Zorro bus */
     INIT_LIST_HEAD(&zorro_bus.devices);
     strcpy(zorro_bus.dev.bus_id, "zorro");
-    device_register(&zorro_bus.dev);
+    error = device_register(&zorro_bus.dev);
+    if (error) {
+	pr_err("Zorro: Error registering zorro_bus\n");
+	return error;
+    }
 
     /* Request the resources */
     zorro_bus.num_resources = AMIGAHW_PRESENT(ZORRO3) ? 4 : 2;
@@ -167,8 +172,14 @@ static int __init zorro_init(void)
 	sprintf(z->dev.bus_id, "%02x", i);
 	z->dev.parent = &zorro_bus.dev;
 	z->dev.bus = &zorro_bus_type;
-	device_register(&z->dev);
-	zorro_create_sysfs_dev_files(z);
+	error = device_register(&z->dev);
+	if (error) {
+	    pr_err("Zorro: Error registering device %s\n", z->name);
+	    continue;
+	}
+	error = zorro_create_sysfs_dev_files(z);
+	if (error)
+	    dev_err(&z->dev, "Error creating sysfs files\n");
     }
 
     /* Mark all available Zorro II memory */
diff --git a/drivers/zorro/zorro.h b/drivers/zorro/zorro.h
index 5c91ada..b682d5c 100644
--- a/drivers/zorro/zorro.h
+++ b/drivers/zorro/zorro.h
@@ -1,4 +1,4 @@
 
 extern void zorro_name_device(struct zorro_dev *z);
-extern void zorro_create_sysfs_dev_files(struct zorro_dev *z);
+extern int zorro_create_sysfs_dev_files(struct zorro_dev *z);
 
-- 
1.5.6.5

