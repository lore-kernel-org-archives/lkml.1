Return-Path: <linux-kernel-owner+w=401wt.eu-S964910AbZLQSOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964910AbZLQSOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935124AbZLQSOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:14:07 -0500
Received: from smtp.nokia.com ([192.100.122.233]:36415 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbZLQSN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:13:57 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 1/6] Driver core: device_attribute parameters can often be const*
Date: Thu, 17 Dec 2009 20:12:11 +0200
Message-Id: <1261073536-27396-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-OriginalArrivalTime: 17 Dec 2009 18:11:54.0062 (UTC) FILETIME=[69A846E0:01CA7F44]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most device_attributes are const, and are begging to be
put in a ro section. However, the create and remove
file interfaces were failing to propagate the const promise
which the only functions they call offer.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 Documentation/filesystems/sysfs.txt |    8 ++++----
 drivers/base/core.c                 |    6 ++++--
 include/linux/device.h              |    4 ++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index b245d52..a4ac2b9 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -91,8 +91,8 @@ struct device_attribute {
 			 const char *buf, size_t count);
 };
 
-int device_create_file(struct device *, struct device_attribute *);
-void device_remove_file(struct device *, struct device_attribute *);
+int device_create_file(struct device *, const struct device_attribute *);
+void device_remove_file(struct device *, const struct device_attribute *);
 
 It also defines this helper for defining device attributes: 
 
@@ -316,8 +316,8 @@ DEVICE_ATTR(_name, _mode, _show, _store);
 
 Creation/Removal:
 
-int device_create_file(struct device *device, struct device_attribute * attr);
-void device_remove_file(struct device * dev, struct device_attribute * attr);
+int device_create_file(struct device *dev, const struct device_attribute * attr);
+void device_remove_file(struct device *dev, const struct device_attribute * attr);
 
 
 - bus drivers (include/linux/device.h)
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6bee6af..c1e3cad 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -439,7 +439,8 @@ struct kset *devices_kset;
  * @dev: device.
  * @attr: device attribute descriptor.
  */
-int device_create_file(struct device *dev, struct device_attribute *attr)
+int device_create_file(struct device *dev,
+		       const struct device_attribute *attr)
 {
 	int error = 0;
 	if (dev)
@@ -452,7 +453,8 @@ int device_create_file(struct device *dev, struct device_attribute *attr)
  * @dev: device.
  * @attr: device attribute descriptor.
  */
-void device_remove_file(struct device *dev, struct device_attribute *attr)
+void device_remove_file(struct device *dev,
+			const struct device_attribute *attr)
 {
 	if (dev)
 		sysfs_remove_file(&dev->kobj, &attr->attr);
diff --git a/include/linux/device.h b/include/linux/device.h
index 2ea3e49..9ecd9b0 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -319,9 +319,9 @@ struct device_attribute {
 struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
 
 extern int __must_check device_create_file(struct device *device,
-					   struct device_attribute *entry);
+					   const struct device_attribute *entry);
 extern void device_remove_file(struct device *dev,
-			       struct device_attribute *attr);
+			       const struct device_attribute *attr);
 extern int __must_check device_create_bin_file(struct device *dev,
 					       struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
-- 
1.6.0.4

