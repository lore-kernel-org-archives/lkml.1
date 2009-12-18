Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbZLRNej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbZLRNej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZLRNeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:34:18 -0500
Received: from smtp.nokia.com ([192.100.122.233]:53476 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZLRNeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:34:15 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Driver core: bin_attribute parameters can often be const*
Date: Fri, 18 Dec 2009 15:34:20 +0200
Message-Id: <1261143261-399-3-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261143261-399-2-git-send-email-ext-phil.2.carmody@nokia.com>
References: <20091218042007.GA6314@suse.de>
 <1261143261-399-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261143261-399-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-OriginalArrivalTime: 18 Dec 2009 13:33:53.0930 (UTC) FILETIME=[BDEFDEA0:01CA7FE6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many struct bin_attribute descriptors are purely read-only
structures, and there's no need to change them. Therefore
make the promise not to, which will let those descriptors
be put in a ro section.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 drivers/base/core.c    |    6 ++++--
 fs/sysfs/bin.c         |    6 ++++--
 include/linux/device.h |    6 +++---
 include/linux/sysfs.h  |    9 +++++----
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index c1e3cad..d0b2116 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -465,7 +465,8 @@ void device_remove_file(struct device *dev,
  * @dev: device.
  * @attr: device binary attribute descriptor.
  */
-int device_create_bin_file(struct device *dev, struct bin_attribute *attr)
+int device_create_bin_file(struct device *dev,
+			   const struct bin_attribute *attr)
 {
 	int error = -EINVAL;
 	if (dev)
@@ -479,7 +480,8 @@ EXPORT_SYMBOL_GPL(device_create_bin_file);
  * @dev: device.
  * @attr: device binary attribute descriptor.
  */
-void device_remove_bin_file(struct device *dev, struct bin_attribute *attr)
+void device_remove_bin_file(struct device *dev,
+			    const struct bin_attribute *attr)
 {
 	if (dev)
 		sysfs_remove_bin_file(&dev->kobj, attr);
diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 60c702b..a0a500a 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -483,7 +483,8 @@ void unmap_bin_file(struct sysfs_dirent *attr_sd)
  *	@attr:	attribute descriptor.
  */
 
-int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr)
+int sysfs_create_bin_file(struct kobject *kobj,
+			  const struct bin_attribute *attr)
 {
 	BUG_ON(!kobj || !kobj->sd || !attr);
 
@@ -497,7 +498,8 @@ int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr)
  *	@attr:	attribute descriptor.
  */
 
-void sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr)
+void sysfs_remove_bin_file(struct kobject *kobj,
+			   const struct bin_attribute *attr)
 {
 	sysfs_hash_and_remove(kobj->sd, attr->attr.name);
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index 9ecd9b0..0823a29 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -319,13 +319,13 @@ struct device_attribute {
 struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
 
 extern int __must_check device_create_file(struct device *device,
-					   const struct device_attribute *entry);
+					const struct device_attribute *entry);
 extern void device_remove_file(struct device *dev,
 			       const struct device_attribute *attr);
 extern int __must_check device_create_bin_file(struct device *dev,
-					       struct bin_attribute *attr);
+					const struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
-				   struct bin_attribute *attr);
+				   const struct bin_attribute *attr);
 extern int device_schedule_callback_owner(struct device *dev,
 		void (*func)(struct device *dev), struct module *owner);
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 9d68fed..cfa8308 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -99,8 +99,9 @@ int __must_check sysfs_chmod_file(struct kobject *kobj, struct attribute *attr,
 void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
 
 int __must_check sysfs_create_bin_file(struct kobject *kobj,
-				       struct bin_attribute *attr);
-void sysfs_remove_bin_file(struct kobject *kobj, struct bin_attribute *attr);
+				       const struct bin_attribute *attr);
+void sysfs_remove_bin_file(struct kobject *kobj,
+			   const struct bin_attribute *attr);
 
 int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
 				   const char *name);
@@ -175,13 +176,13 @@ static inline void sysfs_remove_file(struct kobject *kobj,
 }
 
 static inline int sysfs_create_bin_file(struct kobject *kobj,
-					struct bin_attribute *attr)
+					const struct bin_attribute *attr)
 {
 	return 0;
 }
 
 static inline void sysfs_remove_bin_file(struct kobject *kobj,
-					 struct bin_attribute *attr)
+					 const struct bin_attribute *attr)
 {
 }
 
-- 
1.6.0.4

