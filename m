Return-Path: <linux-kernel-owner+w=401wt.eu-S934881AbYETWgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbYETWgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbYETWfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:35:40 -0400
Received: from ns1.suse.de ([195.135.220.2]:53175 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934811AbYETWfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:35:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 01/13] Driver core: add device_create_vargs and device_create_drvdata
Date: Tue, 20 May 2008 15:34:48 -0700
Message-Id: <1211322900-12705-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520223237.GA12383@suse.de>
References: <20080520223237.GA12383@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to have the drvdata field set properly when creating the device
as sysfs callbacks can assume it is present and it can race the later
setting of this field.

So, create two new functions, deviec_create_vargs() and
device_create_drvdata() that take this new field.

device_create_drvdata() will go away in 2.6.27 as the drvdata field will
just be moved to the device_create() call as it should be.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |   85 ++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/device.h |   12 +++++++
 2 files changed, 91 insertions(+), 6 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index be288b5..f861c2b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1084,11 +1084,13 @@ static void device_create_release(struct device *dev)
 }
 
 /**
- * device_create - creates a device and registers it with sysfs
+ * device_create_vargs - creates a device and registers it with sysfs
  * @class: pointer to the struct class that this device should be registered to
  * @parent: pointer to the parent struct device of this new device, if any
  * @devt: the dev_t for the char device to be added
+ * @drvdata: the data to be added to the device for callbacks
  * @fmt: string for the device's name
+ * @args: va_list for the device's name
  *
  * This function can be used by char device classes.  A struct device
  * will be created in sysfs, registered to the specified class.
@@ -1104,10 +1106,10 @@ static void device_create_release(struct device *dev)
  * Note: the struct class passed to this function must have previously
  * been created with a call to class_create().
  */
-struct device *device_create(struct class *class, struct device *parent,
-			     dev_t devt, const char *fmt, ...)
+struct device *device_create_vargs(struct class *class, struct device *parent,
+				   dev_t devt, void *drvdata, const char *fmt,
+				   va_list args)
 {
-	va_list args;
 	struct device *dev = NULL;
 	int retval = -ENODEV;
 
@@ -1124,10 +1126,9 @@ struct device *device_create(struct class *class, struct device *parent,
 	dev->class = class;
 	dev->parent = parent;
 	dev->release = device_create_release;
+	dev_set_drvdata(dev, drvdata);
 
-	va_start(args, fmt);
 	vsnprintf(dev->bus_id, BUS_ID_SIZE, fmt, args);
-	va_end(args);
 	retval = device_register(dev);
 	if (retval)
 		goto error;
@@ -1138,6 +1139,78 @@ error:
 	kfree(dev);
 	return ERR_PTR(retval);
 }
+EXPORT_SYMBOL_GPL(device_create_vargs);
+
+/**
+ * device_create_drvdata - creates a device and registers it with sysfs
+ * @class: pointer to the struct class that this device should be registered to
+ * @parent: pointer to the parent struct device of this new device, if any
+ * @devt: the dev_t for the char device to be added
+ * @drvdata: the data to be added to the device for callbacks
+ * @fmt: string for the device's name
+ *
+ * This function can be used by char device classes.  A struct device
+ * will be created in sysfs, registered to the specified class.
+ *
+ * A "dev" file will be created, showing the dev_t for the device, if
+ * the dev_t is not 0,0.
+ * If a pointer to a parent struct device is passed in, the newly created
+ * struct device will be a child of that device in sysfs.
+ * The pointer to the struct device will be returned from the call.
+ * Any further sysfs files that might be required can be created using this
+ * pointer.
+ *
+ * Note: the struct class passed to this function must have previously
+ * been created with a call to class_create().
+ */
+struct device *device_create_drvdata(struct class *class,
+				     struct device *parent,
+				     dev_t devt,
+				     void *drvdata,
+				     const char *fmt, ...)
+{
+	va_list vargs;
+	struct device *dev;
+
+	va_start(vargs, fmt);
+	dev = device_create_vargs(class, parent, devt, drvdata, fmt, vargs);
+	va_end(vargs);
+	return dev;
+}
+EXPORT_SYMBOL_GPL(device_create_drvdata);
+
+/**
+ * device_create - creates a device and registers it with sysfs
+ * @class: pointer to the struct class that this device should be registered to
+ * @parent: pointer to the parent struct device of this new device, if any
+ * @devt: the dev_t for the char device to be added
+ * @fmt: string for the device's name
+ *
+ * This function can be used by char device classes.  A struct device
+ * will be created in sysfs, registered to the specified class.
+ *
+ * A "dev" file will be created, showing the dev_t for the device, if
+ * the dev_t is not 0,0.
+ * If a pointer to a parent struct device is passed in, the newly created
+ * struct device will be a child of that device in sysfs.
+ * The pointer to the struct device will be returned from the call.
+ * Any further sysfs files that might be required can be created using this
+ * pointer.
+ *
+ * Note: the struct class passed to this function must have previously
+ * been created with a call to class_create().
+ */
+struct device *device_create(struct class *class, struct device *parent,
+			     dev_t devt, const char *fmt, ...)
+{
+	va_list vargs;
+	struct device *dev;
+
+	va_start(vargs, fmt);
+	dev = device_create_vargs(class, parent, devt, NULL, fmt, vargs);
+	va_end(vargs);
+	return dev;
+}
 EXPORT_SYMBOL_GPL(device_create);
 
 static int __match_devt(struct device *dev, void *data)
diff --git a/include/linux/device.h b/include/linux/device.h
index 15e9fa3..14616e8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -449,9 +449,21 @@ extern int __must_check device_reprobe(struct device *dev);
 /*
  * Easy functions for dynamically creating devices on the fly
  */
+extern struct device *device_create_vargs(struct class *cls,
+					  struct device *parent,
+					  dev_t devt,
+					  void *drvdata,
+					  const char *fmt,
+					  va_list vargs);
 extern struct device *device_create(struct class *cls, struct device *parent,
 				    dev_t devt, const char *fmt, ...)
 				    __attribute__((format(printf, 4, 5)));
+extern struct device *device_create_drvdata(struct class *cls,
+					    struct device *parent,
+					    dev_t devt,
+					    void *drvdata,
+					    const char *fmt, ...)
+				    __attribute__((format(printf, 5, 6)));
 extern void device_destroy(struct class *cls, dev_t devt);
 
 /*
-- 
1.5.5.1

