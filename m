Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZLWTxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZLWTxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZLWTxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:53:14 -0500
Received: from kroah.org ([198.145.64.141]:52945 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbZLWTxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:53:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/10] Driver core: device_attribute parameters can often be const*
Date: Wed, 23 Dec 2009 11:52:37 -0800
Message-Id: <1261597963-18323-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.6
In-Reply-To: <20091223194955.GB18101@kroah.com>
References: <20091223194955.GB18101@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Most device_attributes are const, and are begging to be
put in a ro section. However, the create and remove
file interfaces were failing to propagate the const promise
which the only functions they call offer.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
index f1290cb..2fd9e61 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -446,7 +446,8 @@ struct kset *devices_kset;
  * @dev: device.
  * @attr: device attribute descriptor.
  */
-int device_create_file(struct device *dev, struct device_attribute *attr)
+int device_create_file(struct device *dev,
+		       const struct device_attribute *attr)
 {
 	int error = 0;
 	if (dev)
@@ -459,7 +460,8 @@ int device_create_file(struct device *dev, struct device_attribute *attr)
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
index 2a73d9b..aa5b3e6 100644
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
1.6.5.7

