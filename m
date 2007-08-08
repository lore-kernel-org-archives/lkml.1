Return-Path: <linux-kernel-owner+w=401wt.eu-S935097AbXHHFdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935097AbXHHFdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 01:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762419AbXHHFcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 01:32:08 -0400
Received: from ns.suse.de ([195.135.220.2]:48544 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761648AbXHHFbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 01:31:53 -0400
Message-Id: <20070808053022.519538000@suse.de>
References: <20070808052842.451400000@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 07 Aug 2007 22:28:45 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Kay Sievers <kay.sievers@vrfy.org>
Subject: [patch 3/6] Convert from class_device to device for hwmon
Content-Disposition: inline; filename=hwmon.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from class_device to device for hwmon_device_register/unregister

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

---
 drivers/hwmon/hwmon.c |   27 +++++++++++++--------------
 include/linux/hwmon.h |    4 ++--
 2 files changed, 15 insertions(+), 16 deletions(-)

--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -28,17 +28,17 @@ static DEFINE_IDR(hwmon_idr);
 static DEFINE_SPINLOCK(idr_lock);
 
 /**
- * hwmon_device_register - register w/ hwmon sysfs class
+ * hwmon_device_register - register w/ hwmon
  * @dev: the device to register
  *
- * hwmon_device_unregister() must be called when the class device is no
+ * hwmon_device_unregister() must be called when the device is no
  * longer needed.
  *
- * Returns the pointer to the new struct class device.
+ * Returns the pointer to the new device.
  */
-struct class_device *hwmon_device_register(struct device *dev)
+struct device *hwmon_device_register(struct device *dev)
 {
-	struct class_device *cdev;
+	struct device *hwdev;
 	int id, err;
 
 again:
@@ -55,34 +55,33 @@ again:
 		return ERR_PTR(err);
 
 	id = id & MAX_ID_MASK;
-	cdev = class_device_create(hwmon_class, NULL, MKDEV(0,0), dev,
-					HWMON_ID_FORMAT, id);
+	hwdev = device_create(hwmon_class, dev, MKDEV(0,0), HWMON_ID_FORMAT, id);
 
-	if (IS_ERR(cdev)) {
+	if (IS_ERR(hwdev)) {
 		spin_lock(&idr_lock);
 		idr_remove(&hwmon_idr, id);
 		spin_unlock(&idr_lock);
 	}
 
-	return cdev;
+	return hwdev;
 }
 
 /**
  * hwmon_device_unregister - removes the previously registered class device
  *
- * @cdev: the class device to destroy
+ * @dev: the class device to destroy
  */
-void hwmon_device_unregister(struct class_device *cdev)
+void hwmon_device_unregister(struct device *dev)
 {
 	int id;
 
-	if (likely(sscanf(cdev->class_id, HWMON_ID_FORMAT, &id) == 1)) {
-		class_device_unregister(cdev);
+	if (likely(sscanf(dev->bus_id, HWMON_ID_FORMAT, &id) == 1)) {
+		device_unregister(dev);
 		spin_lock(&idr_lock);
 		idr_remove(&hwmon_idr, id);
 		spin_unlock(&idr_lock);
 	} else
-		dev_dbg(cdev->dev,
+		dev_dbg(dev->parent,
 			"hwmon_device_unregister() failed: bad class ID!\n");
 }
 
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -16,9 +16,9 @@
 
 #include <linux/device.h>
 
-struct class_device *hwmon_device_register(struct device *dev);
+struct device *hwmon_device_register(struct device *dev);
 
-void hwmon_device_unregister(struct class_device *cdev);
+void hwmon_device_unregister(struct device *dev);
 
 /* Scale user input to sensible values */
 static inline int SENSORS_LIMIT(long value, long low, long high)

-- 
