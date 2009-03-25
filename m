Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbZCYAkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbZCYAkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZCYAaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:09 -0400
Received: from kroah.org ([198.145.64.141]:54113 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756839AbZCYAaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/61] driver core: get rid of struct device's bus_id string array
Date: Tue, 24 Mar 2009 17:26:33 -0700
Message-Id: <1237940825-22904-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Now that all users of bus_id is gone, we can remove it from struct
device.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c     |   39 +++++++++++++++++++--------------------
 include/linux/device.h  |    4 +---
 include/linux/kobject.h |    2 ++
 lib/kobject.c           |    2 +-
 4 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f3eae63..059966b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -777,17 +777,12 @@ static void device_remove_class_symlinks(struct device *dev)
 int dev_set_name(struct device *dev, const char *fmt, ...)
 {
 	va_list vargs;
-	char *s;
+	int err;
 
 	va_start(vargs, fmt);
-	vsnprintf(dev->bus_id, sizeof(dev->bus_id), fmt, vargs);
+	err = kobject_set_name_vargs(&dev->kobj, fmt, vargs);
 	va_end(vargs);
-
-	/* ewww... some of these buggers have / in the name... */
-	while ((s = strchr(dev->bus_id, '/')))
-		*s = '!';
-
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(dev_set_name);
 
@@ -864,12 +859,17 @@ int device_add(struct device *dev)
 	if (!dev)
 		goto done;
 
-	/* Temporarily support init_name if it is set.
-	 * It will override bus_id for now */
-	if (dev->init_name)
-		dev_set_name(dev, "%s", dev->init_name);
+	/*
+	 * for statically allocated devices, which should all be converted
+	 * some day, we need to initialize the name. We prevent reading back
+	 * the name, and force the use of dev_name()
+	 */
+	if (dev->init_name) {
+		dev_set_name(dev, dev->init_name);
+		dev->init_name = NULL;
+	}
 
-	if (!strlen(dev->bus_id))
+	if (!dev_name(dev))
 		goto done;
 
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
@@ -1348,7 +1348,10 @@ struct device *device_create_vargs(struct class *class, struct device *parent,
 	dev->release = device_create_release;
 	dev_set_drvdata(dev, drvdata);
 
-	vsnprintf(dev->bus_id, BUS_ID_SIZE, fmt, args);
+	retval = kobject_set_name_vargs(&dev->kobj, fmt, args);
+	if (retval)
+		goto error;
+
 	retval = device_register(dev);
 	if (retval)
 		goto error;
@@ -1452,19 +1455,15 @@ int device_rename(struct device *dev, char *new_name)
 		old_class_name = make_class_name(dev->class->name, &dev->kobj);
 #endif
 
-	old_device_name = kmalloc(BUS_ID_SIZE, GFP_KERNEL);
+	old_device_name = kstrdup(dev_name(dev), GFP_KERNEL);
 	if (!old_device_name) {
 		error = -ENOMEM;
 		goto out;
 	}
-	strlcpy(old_device_name, dev->bus_id, BUS_ID_SIZE);
-	strlcpy(dev->bus_id, new_name, BUS_ID_SIZE);
 
 	error = kobject_rename(&dev->kobj, new_name);
-	if (error) {
-		strlcpy(dev->bus_id, old_device_name, BUS_ID_SIZE);
+	if (error)
 		goto out;
-	}
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	if (old_class_name) {
diff --git a/include/linux/device.h b/include/linux/device.h
index 47f343c..d5706c4 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -374,7 +374,6 @@ struct device {
 	struct device		*parent;
 
 	struct kobject kobj;
-	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	unsigned		uevent_suppress:1;
 	const char		*init_name; /* initial name of the device */
 	struct device_type	*type;
@@ -427,8 +426,7 @@ struct device {
 
 static inline const char *dev_name(const struct device *dev)
 {
-	/* will be changed into kobject_name(&dev->kobj) in the near future */
-	return dev->bus_id;
+	return kobject_name(&dev->kobj);
 }
 
 extern int dev_set_name(struct device *dev, const char *name, ...)
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 5437ac0..c9c214d 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -72,6 +72,8 @@ struct kobject {
 
 extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
 			    __attribute__((format(printf, 2, 3)));
+extern int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
+				  va_list vargs);
 
 static inline const char *kobject_name(const struct kobject *kobj)
 {
diff --git a/lib/kobject.c b/lib/kobject.c
index 0487d1f..a6dec32 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -212,7 +212,7 @@ static int kobject_add_internal(struct kobject *kobj)
  * @fmt: format string used to build the name
  * @vargs: vargs to format the string.
  */
-static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
+int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs)
 {
 	const char *old_name = kobj->name;
-- 
1.6.2

