Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbZABKq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbZABKq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbZABKl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:56 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:34159 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbZABKll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:41 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Philip Blundell <philb@gnu.org>
Subject: [PATCH] m68k: dio - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:27 +0100
Message-Id: <1230892892-25751-15-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-14-git-send-email-geert@linux-m68k.org>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'device_register', declared with attribute
warn_unused_result
warning: ignoring return value of 'device_create_file', declared with
attribute warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Philip Blundell <philb@gnu.org>
---
 drivers/dio/dio-sysfs.c |   16 ++++++++++------
 drivers/dio/dio.c       |   18 +++++++++++++++---
 include/linux/dio.h     |    2 +-
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/dio/dio-sysfs.c b/drivers/dio/dio-sysfs.c
index f464630..91d5f4d 100644
--- a/drivers/dio/dio-sysfs.c
+++ b/drivers/dio/dio-sysfs.c
@@ -63,15 +63,19 @@ static ssize_t dio_show_resource(struct device *dev, struct device_attribute *at
 }
 static DEVICE_ATTR(resource, S_IRUGO, dio_show_resource, NULL);
 
-void dio_create_sysfs_dev_files(struct dio_dev *d)
+int dio_create_sysfs_dev_files(struct dio_dev *d)
 {
 	struct device *dev = &d->dev;
+	int error;
 
 	/* current configuration's attributes */
-	device_create_file(dev, &dev_attr_id);
-	device_create_file(dev, &dev_attr_ipl);
-	device_create_file(dev, &dev_attr_secid);
-	device_create_file(dev, &dev_attr_name);
-	device_create_file(dev, &dev_attr_resource);
+	if ((error = device_create_file(dev, &dev_attr_id)) ||
+	    (error = device_create_file(dev, &dev_attr_ipl)) ||
+	    (error = device_create_file(dev, &dev_attr_secid)) ||
+	    (error = device_create_file(dev, &dev_attr_name)) ||
+	    (error = device_create_file(dev, &dev_attr_resource)))
+		return error;
+
+	return 0;
 }
 
diff --git a/drivers/dio/dio.c b/drivers/dio/dio.c
index 07f274f..10c3c49 100644
--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -173,6 +173,7 @@ static int __init dio_init(void)
 	mm_segment_t fs;
 	int i;
 	struct dio_dev *dev;
+	int error;
 
 	if (!MACH_IS_HP300)
 		return 0;
@@ -182,7 +183,11 @@ static int __init dio_init(void)
 	/* Initialize the DIO bus */ 
 	INIT_LIST_HEAD(&dio_bus.devices);
 	strcpy(dio_bus.dev.bus_id, "dio");
-	device_register(&dio_bus.dev);
+	error = device_register(&dio_bus.dev);
+	if (error) {
+		pr_err("DIO: Error registering dio_bus\n");
+		return error;
+	}
 
 	/* Request all resources */
 	dio_bus.num_resources = (hp300_model == HP_320 ? 1 : 2);
@@ -252,8 +257,15 @@ static int __init dio_init(void)
 
 		if (scode >= DIOII_SCBASE)
 			iounmap(va);
-		device_register(&dev->dev);
-		dio_create_sysfs_dev_files(dev);
+		error = device_register(&dev->dev);
+		if (error) {
+			pr_err("DIO: Error registering device %s\n",
+			       dev->name);
+			continue;
+		}
+		error = dio_create_sysfs_dev_files(dev);
+		if (error)
+			dev_err(&dev->dev, "Error creating sysfs files\n");
         }
 	return 0;
 }
diff --git a/include/linux/dio.h b/include/linux/dio.h
index 1e65ebc..b2dd31c 100644
--- a/include/linux/dio.h
+++ b/include/linux/dio.h
@@ -241,7 +241,7 @@ struct dio_driver {
 
 extern int dio_find(int deviceid);
 extern unsigned long dio_scodetophysaddr(int scode);
-extern void dio_create_sysfs_dev_files(struct dio_dev *);
+extern int dio_create_sysfs_dev_files(struct dio_dev *);
 
 /* New-style probing */
 extern int dio_register_driver(struct dio_driver *);
-- 
1.5.6.5

