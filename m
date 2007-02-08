Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbXBHP2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbXBHP2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXBHP2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:28:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48233 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423005AbXBHP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:28:41 -0500
Date: Thu, 8 Feb 2007 15:28:39 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>
cc: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Marcin Juszkiewicz <openembedded@hrw.one.pl>
Subject: Re: Git backlight subsystem tree
In-Reply-To: <1170901826.5859.2.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702081520110.824@pentafluge.infradead.org>
References: <1170901826.5859.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I have some patches that move the backlight away from using the class 
stuff. The only problem is the patch requires all backlight devices 
to be linked to a real struct device. Right now the acpi backligths are 
not.

Signed-Off: James Simmons <jsimmons@infradead.org>

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 9601bfe..b56fc33 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -14,6 +14,8 @@
 #include <linux/err.h>
 #include <linux/fb.h>
 
+struct class *backlight_class;
+static int index;
 
 #if defined(CONFIG_FB) || (defined(CONFIG_FB_MODULE) && \
 			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
@@ -67,10 +69,11 @@ static inline void backlight_unregister_fb(struct backlight_device *bd)
 }
 #endif /* CONFIG_FB */
 
-static ssize_t backlight_show_power(struct class_device *cdev, char *buf)
+static ssize_t backlight_show_power(struct device *dev, struct device_attribute *attr,
+					char *buf)
 {
 	int rc = -ENXIO;
-	struct backlight_device *bd = to_backlight_device(cdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	down(&bd->sem);
 	if (likely(bd->props))
@@ -80,11 +83,12 @@ static ssize_t backlight_show_power(struct class_device *cdev, char *buf)
 	return rc;
 }
 
-static ssize_t backlight_store_power(struct class_device *cdev, const char *buf, size_t count)
+static ssize_t backlight_store_power(struct device *dev, struct device_attribute *attr,
+					const char *buf, size_t count)
 {
 	int rc = -ENXIO;
 	char *endp;
-	struct backlight_device *bd = to_backlight_device(cdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 	int power = simple_strtoul(buf, &endp, 0);
 	size_t size = endp - buf;
 
@@ -106,10 +110,11 @@ static ssize_t backlight_store_power(struct class_device *cdev, const char *buf,
 	return rc;
 }
 
-static ssize_t backlight_show_brightness(struct class_device *cdev, char *buf)
+static ssize_t backlight_show_brightness(struct device *dev, struct device_attribute *attr,
+						char *buf)
 {
 	int rc = -ENXIO;
-	struct backlight_device *bd = to_backlight_device(cdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	down(&bd->sem);
 	if (likely(bd->props))
@@ -119,11 +124,12 @@ static ssize_t backlight_show_brightness(struct class_device *cdev, char *buf)
 	return rc;
 }
 
-static ssize_t backlight_store_brightness(struct class_device *cdev, const char *buf, size_t count)
+static ssize_t backlight_store_brightness(struct device *dev, struct device_attribute *attr,
+						const char *buf, size_t count)
 {
 	int rc = -ENXIO;
 	char *endp;
-	struct backlight_device *bd = to_backlight_device(cdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 	int brightness = simple_strtoul(buf, &endp, 0);
 	size_t size = endp - buf;
 
@@ -150,10 +156,11 @@ static ssize_t backlight_store_brightness(struct class_device *cdev, const char
 	return rc;
 }
 
-static ssize_t backlight_show_max_brightness(struct class_device *cdev, char *buf)
+static ssize_t backlight_show_max_brightness(struct device *dev, struct device_attribute *attr,
+						char *buf)
 {
 	int rc = -ENXIO;
-	struct backlight_device *bd = to_backlight_device(cdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	down(&bd->sem);
 	if (likely(bd->props))
@@ -163,11 +170,11 @@ static ssize_t backlight_show_max_brightness(struct class_device *cdev, char *bu
 	return rc;
 }
 
-static ssize_t backlight_show_actual_brightness(struct class_device *cdev,
+static ssize_t backlight_show_actual_brightness(struct device *dev, struct device_attribute *attr,
 						char *buf)
 {
+	struct backlight_device *bd = dev_get_drvdata(dev);
 	int rc = -ENXIO;
-	struct backlight_device *bd = to_backlight_device(cdev);
 
 	down(&bd->sem);
 	if (likely(bd->props && bd->props->get_brightness))
@@ -177,31 +184,12 @@ static ssize_t backlight_show_actual_brightness(struct class_device *cdev,
 	return rc;
 }
 
-static void backlight_class_release(struct class_device *dev)
-{
-	struct backlight_device *bd = to_backlight_device(dev);
-	kfree(bd);
-}
-
-static struct class backlight_class = {
-	.name = "backlight",
-	.release = backlight_class_release,
-};
-
-#define DECLARE_ATTR(_name,_mode,_show,_store)			\
-{							 	\
-	.attr	= { .name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE },	\
-	.show	= _show,					\
-	.store	= _store,					\
-}
-
-static const struct class_device_attribute bl_class_device_attributes[] = {
-	DECLARE_ATTR(power, 0644, backlight_show_power, backlight_store_power),
-	DECLARE_ATTR(brightness, 0644, backlight_show_brightness,
-		     backlight_store_brightness),
-	DECLARE_ATTR(actual_brightness, 0444, backlight_show_actual_brightness,
-		     NULL),
-	DECLARE_ATTR(max_brightness, 0444, backlight_show_max_brightness, NULL),
+static struct device_attribute bl_class_device_attributes[] = {
+	__ATTR(power, S_IRUGO | S_IWUSR, backlight_show_power, backlight_store_power),
+	__ATTR(brightness, S_IRUGO | S_IWUSR, backlight_show_brightness,
+		backlight_store_brightness),
+	__ATTR(actual_brightness, S_IRUGO, backlight_show_actual_brightness, NULL),
+	__ATTR(max_brightness, S_IRUGO, backlight_show_max_brightness, NULL),
 };
 
 /**
@@ -217,12 +205,11 @@ static const struct class_device_attribute bl_class_device_attributes[] = {
  * ERR_PTR() or a pointer to the newly allocated device.
  */
 struct backlight_device *backlight_device_register(const char *name,
-	struct device *dev,
-	void *devdata,
+	struct device *parent, void *devdata,
 	struct backlight_properties *bp)
 {
-	int i, rc;
 	struct backlight_device *new_bd;
+	int rc;
 
 	pr_debug("backlight_device_alloc: name=%s\n", name);
 
@@ -230,37 +217,21 @@ struct backlight_device *backlight_device_register(const char *name,
 	if (unlikely(!new_bd))
 		return ERR_PTR(-ENOMEM);
 
+	new_bd->device = device_create(backlight_class, parent, 0,
+					name, index++);
+	if (IS_ERR(new_bd->device)) {
+		new_bd->device = NULL;
+		return ERR_PTR(-EINVAL);
+	}
+
 	init_MUTEX(&new_bd->sem);
+	dev_set_drvdata(new_bd->device, devdata);
 	new_bd->props = bp;
-	memset(&new_bd->class_dev, 0, sizeof(new_bd->class_dev));
-	new_bd->class_dev.class = &backlight_class;
-	new_bd->class_dev.dev = dev;
-	strlcpy(new_bd->class_dev.class_id, name, KOBJ_NAME_LEN);
-	class_set_devdata(&new_bd->class_dev, devdata);
 
-	rc = class_device_register(&new_bd->class_dev);
+	rc = backlight_register_fb(new_bd);
 	if (unlikely(rc)) {
-error:		kfree(new_bd);
-		return ERR_PTR(rc);
-	}
 
-	rc = backlight_register_fb(new_bd);
-	if (unlikely(rc))
-		goto error;
-
-	for (i = 0; i < ARRAY_SIZE(bl_class_device_attributes); i++) {
-		rc = class_device_create_file(&new_bd->class_dev,
-					      &bl_class_device_attributes[i]);
-		if (unlikely(rc)) {
-			while (--i >= 0)
-				class_device_remove_file(&new_bd->class_dev,
-							 &bl_class_device_attributes[i]);
-			class_device_unregister(&new_bd->class_dev);
-			/* No need to kfree(new_bd) since release() method was called */
-			return ERR_PTR(rc);
-		}
 	}
-
 	return new_bd;
 }
 EXPORT_SYMBOL(backlight_device_register);
@@ -273,35 +244,36 @@ EXPORT_SYMBOL(backlight_device_register);
  */
 void backlight_device_unregister(struct backlight_device *bd)
 {
-	int i;
-
 	if (!bd)
 		return;
 
-	pr_debug("backlight_device_unregister: name=%s\n", bd->class_dev.class_id);
-
-	for (i = 0; i < ARRAY_SIZE(bl_class_device_attributes); i++)
-		class_device_remove_file(&bd->class_dev,
-					 &bl_class_device_attributes[i]);
+	pr_debug("backlight_device_unregister\n");
 
 	down(&bd->sem);
 	bd->props = NULL;
 	up(&bd->sem);
 
 	backlight_unregister_fb(bd);
-
-	class_device_unregister(&bd->class_dev);
+	dev_set_drvdata(bd->device, NULL);
+	device_unregister(bd->device);
 }
 EXPORT_SYMBOL(backlight_device_unregister);
 
 static void __exit backlight_class_exit(void)
 {
-	class_unregister(&backlight_class);
+	class_destroy(backlight_class);
 }
 
 static int __init backlight_class_init(void)
 {
-	return class_register(&backlight_class);
+	backlight_class = class_create(THIS_MODULE, "backlight");
+	if (IS_ERR(backlight_class)) {
+		printk(KERN_WARNING "Unable to create backlight class; errno = %ld\n",
+			PTR_ERR(backlight_class));
+		backlight_class = NULL;
+	} else
+		backlight_class->dev_attrs = bl_class_device_attributes;
+	return 0;
 }
 
 /*
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index a5cf1be..d593266 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -49,8 +49,10 @@ struct backlight_device {
 	struct backlight_properties *props;
 	/* The framebuffer notifier block */
 	struct notifier_block fb_notif;
-	/* The class device structure */
-	struct class_device class_dev;
+	/* Parent device */
+	struct device *parent;
+	/* The device structure */
+	struct device *device;
 };
 
 extern struct backlight_device *backlight_device_register(const char *name,
