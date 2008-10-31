Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbYJaSWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbYJaSWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYJaSWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:22:22 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:58465 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYJaSWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:22:21 -0400
Subject: Re: driver core: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081031180522.GA30195@kroah.com>
References: <1225327008.5970.27.camel@nga.site>
	 <20081031170227.GC24826@kroah.com>
	 <ac3eb2510810311057j6069aa99j4f46c6f563b5740@mail.gmail.com>
	 <20081031180522.GA30195@kroah.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 31 Oct 2008 19:16:38 +0100
Message-Id: <1225476998.5305.1.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 11:05 -0700, Greg KH wrote:
> On Fri, Oct 31, 2008 at 06:57:52PM +0100, Kay Sievers wrote:
> > On Fri, Oct 31, 2008 at 18:02, Greg KH <greg@kroah.com> wrote:
> > > On Thu, Oct 30, 2008 at 01:36:48AM +0100, Kay Sievers wrote: index 5437ac0..c9c214d 100644
> > >> --- a/include/linux/kobject.h
> > >> +++ b/include/linux/kobject.h
> > >> @@ -72,6 +72,8 @@ struct kobject {
> > >>
> > >>  extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
> > >>                           __attribute__((format(printf, 2, 3)));
> > >> +extern int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
> > >> +                               va_list vargs);
> > >>
> > >>  static inline const char *kobject_name(const struct kobject *kobj)
> > >>  {
> > >> diff --git a/lib/kobject.c b/lib/kobject.c
> > >> index 0487d1f..a6dec32 100644
> > >> --- a/lib/kobject.c
> > >> +++ b/lib/kobject.c
> > >> @@ -212,7 +212,7 @@ static int kobject_add_internal(struct kobject *kobj)
> > >>   * @fmt: format string used to build the name
> > >>   * @vargs: vargs to format the string.
> > >>   */
> > >> -static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
> > >> +int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
> > >>                                 va_list vargs)
> > >>  {
> > >>       const char *old_name = kobj->name;
> > >>
> > >
> > > I cut this part out of this patch, as it's not needed here, and applied
> > > the rest.
> > 
> > Ah, yeah, this hunk belongs to "driver core: get rid of bus_id" which
> > I sent you, and which should be locally in your tree to catch new
> > instances of bus_id in staging. We will push to -next when we got most
> > of it converted and want to fix the remaining pieces.
> 
> Ok, that makes more sense.
> 
> Care to respin that patch with these chunks added to it so that it will
> work properly?

Here we go.

Thanks,
Kay



From: Kay Sievers <kay.sievers@vrfy.org>
Subject: driver core: get rid of bus_id and ﻿BUS_ID_SIZE

Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8c2cc26..4e22175 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -777,11 +777,12 @@ static void device_remove_class_symlinks(struct device *dev)
 int dev_set_name(struct device *dev, const char *fmt, ...)
 {
 	va_list vargs;
+	int err;
 
 	va_start(vargs, fmt);
-	vsnprintf(dev->bus_id, sizeof(dev->bus_id), fmt, vargs);
+	err = kobject_set_name_vargs(&dev->kobj, fmt, vargs);
 	va_end(vargs);
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(dev_set_name);
 
@@ -858,12 +859,17 @@ int device_add(struct device *dev)
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
 
 	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
@@ -1248,7 +1254,10 @@ struct device *device_create_vargs(struct class *class, struct device *parent,
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
@@ -1352,19 +1361,15 @@ int device_rename(struct device *dev, char *new_name)
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
index 1a3686d..836fa99 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -25,8 +25,6 @@
 #include <asm/atomic.h>
 #include <asm/device.h>
 
-#define BUS_ID_SIZE		20
-
 struct device;
 struct device_driver;
 struct driver_private;
@@ -372,7 +370,6 @@ struct device {
 	struct device		*parent;
 
 	struct kobject kobj;
-	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	const char		*init_name; /* initial name of the device */
 	struct device_type	*type;
 	unsigned		uevent_suppress:1;
@@ -424,8 +421,7 @@ struct device {
 
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


