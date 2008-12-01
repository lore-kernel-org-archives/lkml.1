Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbYLAO3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbYLAO3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYLAO3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:29:16 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:50645 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYLAO3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:29:15 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F4B8.90208@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:29:12 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [4/13] RFC: IIO trigger support
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

The Industrial I/O core - trigger support

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
--
This patch adds supports for IIO triggers.  These are effectively
interrupt sources which are used to 'trigger' things to happen within
IIO device drivers. Currently this limited to sampling data and
pushing to a software ring buffers.

Current trigger drivers (found in next couple of patches) are
1) Periodic RTC  - this replacement for the timer elements of the IIO v2
2) GPIO - sample on raising an external pin (useful for synchronizing
   samples with external hardware over which you do not have full
   control) This one is very much a proof of concept.
3) Data ready signals from certain hardware (currently LIS3L02DQ
   accelerometer)

The various triggers highlight some of the complexities to be overcome
by any attempt to create a generic framework for handling these sort
of events.

 drivers/industrialio/Kconfig                |    9 +
 drivers/industrialio/Makefile               |    1 +
 drivers/industrialio/industrialio-trigger.c |  363 +++++++++++++++++++++++++++
 include/linux/industrialio/trigger.h        |  110 ++++++++
 4 files changed, 483 insertions(+), 0 deletions(-)

diff --git a/drivers/industrialio/Kconfig b/drivers/industrialio/Kconfig
index 73c5616..9bf6a36 100644
--- a/drivers/industrialio/Kconfig
+++ b/drivers/industrialio/Kconfig
@@ -9,6 +9,15 @@ menuconfig INDUSTRIALIO
 	  drivers for many different types of embedded sensors using a
 	  number of different physical interfaces (i2c, spi etc). See
 	  Documentation/industrialio for more information.
+config IIO_TRIGGERS
+       boolean "Enable triggered sampling support"
+       depends on INDUSTRIALIO
+       default y
+         help
+	   Provides IIO core support for triggers.  Currently these
+	   are used to initialize capture of samples to push into 
+	   ring buffers.  The triggers are effectively a 'capture
+	   data now' interrupt.
 
 config IIO_RING_BUFFER
        bool "Enable ring buffer support within iio"
diff --git a/drivers/industrialio/Makefile b/drivers/industrialio/Makefile
index 0fda138..15ef75f 100644
--- a/drivers/industrialio/Makefile
+++ b/drivers/industrialio/Makefile
@@ -5,5 +5,6 @@
 obj-$(CONFIG_INDUSTRIALIO)	+= industrialio.o
 industrialio-y := industrialio-core.o 
 industrialio-$(CONFIG_IIO_RING_BUFFER) += industrialio-ring.o
+industrialio-$(CONFIG_IIO_TRIGGERS) += industrialio-trigger.o
 
 obj-$(CONFIG_IIO_SW_RING) += ring_sw.o
diff --git a/drivers/industrialio/industrialio-trigger.c b/drivers/industrialio/industrialio-trigger.c
new file mode 100644
index 0000000..aa8dc01
--- /dev/null
+++ b/drivers/industrialio/industrialio-trigger.c
@@ -0,0 +1,363 @@
+/* The industrial I/O core, trigger handling functions
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/idr.h>
+#include <linux/err.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/platform_device.h>
+#include <linux/industrialio/iio.h>
+#include <linux/industrialio/trigger.h>
+
+/* RFC - Question of approach
+ * Make the common case (single sensor single trigger)
+ * simple by starting trigger capture from when first sensors
+ * is added.
+ *
+ * Complex simultaneous start requires use of 'hold' functionality
+ * of the trigger. (not implemented)
+ *
+ * Any other suggestions?
+ */
+
+
+static DEFINE_IDR(iio_trigger_idr);
+static DEFINE_SPINLOCK(iio_trigger_idr_lock);
+static LIST_HEAD(iio_trigger_list);
+static DEFINE_MUTEX(iio_trigger_list_lock);
+
+/**
+ * iio_trigger_register_sysfs() create a device for this trigger
+ * @trig_info:	the trigger
+ *
+ * Also adds any control attribute registered by the trigger driver
+ **/
+static int iio_trigger_register_sysfs(struct iio_trigger *trig_info)
+{
+	int ret = 0;
+
+	trig_info->sysfs_dev = device_create(&iio_class,
+					     trig_info->dev,
+					     0,
+					     trig_info,
+					     IIO_TRIGGER_ID_FORMAT,
+					     trig_info->id);
+	if (IS_ERR(trig_info->sysfs_dev)) {
+		ret = PTR_ERR(trig_info->sysfs_dev);
+		goto error_ret;
+	}
+
+	if (trig_info->control_attrs)
+		ret = sysfs_create_group(&trig_info->sysfs_dev->kobj,
+					 trig_info->control_attrs);
+
+error_ret:
+	return ret;
+}
+
+static void iio_trigger_unregister_sysfs(struct iio_trigger *trig_info)
+{
+	if (trig_info->control_attrs)
+		sysfs_remove_group(&trig_info->sysfs_dev->kobj,
+				   trig_info->control_attrs);
+	device_unregister(trig_info->sysfs_dev);
+}
+
+/**
+ * iio_trigger_register_id() get a unique id for this trigger
+ * @trig_info:	the trigger
+ **/
+static int iio_trigger_register_id(struct iio_trigger *trig_info)
+{
+	int ret = 0;
+
+idr_again:
+	if (unlikely(idr_pre_get(&iio_trigger_idr, GFP_KERNEL) == 0))
+		return -ENOMEM;
+
+	spin_lock(&iio_trigger_idr_lock);
+	ret = idr_get_new(&iio_trigger_idr, NULL, &trig_info->id);
+	spin_unlock(&iio_trigger_idr_lock);
+	if (unlikely(ret == -EAGAIN))
+		goto idr_again;
+	else if (likely(!ret))
+		trig_info->id = trig_info->id & MAX_ID_MASK;
+
+	return ret;
+}
+/**
+ * iio_trigger_unregister_id() free up unique id for use by another trigger
+ **/
+static void iio_trigger_unregister_id(struct iio_trigger *trig_info)
+{
+		spin_lock(&iio_trigger_idr_lock);
+		idr_remove(&iio_trigger_idr, trig_info->id);
+		spin_unlock(&iio_trigger_idr_lock);
+}
+
+int iio_trigger_register(struct iio_trigger *trig_info,
+			 struct device *parent,
+			 int id)
+{
+	int ret;
+	struct platform_device *subdev;
+
+	subdev = platform_device_alloc(trig_info->name, id);
+	if (!subdev) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	subdev->dev.parent = parent;
+	ret = platform_device_add(subdev);
+	if (ret)
+		goto error_free_platform_device;
+	trig_info->dev = &subdev->dev;
+	dev_set_drvdata(trig_info->dev, (void *)(trig_info));
+	ret = iio_trigger_register_id(trig_info);
+	if (ret)
+		goto error_free_platform_device;
+	ret = iio_trigger_register_sysfs(trig_info);
+	if (ret)
+		goto error_unregister_id;
+
+	mutex_lock(&iio_trigger_list_lock);
+	list_add_tail(&trig_info->list, &iio_trigger_list);
+	mutex_unlock(&iio_trigger_list_lock);
+
+	return 0;
+
+error_unregister_id:
+	iio_trigger_unregister_id(trig_info);
+error_free_platform_device:
+	platform_device_put(subdev);
+error_ret:
+	return ret;
+}
+EXPORT_SYMBOL(iio_trigger_register);
+
+void iio_trigger_unregister(struct iio_trigger *trig_info)
+{
+	struct iio_trigger *cursor;
+	struct platform_device *subdev;
+
+	mutex_lock(&iio_trigger_list_lock);
+	list_for_each_entry(cursor, &iio_trigger_list, list)
+		if (cursor == trig_info) {
+			list_del(&cursor->list);
+			break;
+		}
+	mutex_unlock(&iio_trigger_list_lock);
+
+	iio_trigger_unregister_sysfs(trig_info);
+	iio_trigger_unregister_id(trig_info);
+	subdev = to_platform_device(trig_info->dev);
+	platform_device_unregister(subdev);
+}
+EXPORT_SYMBOL(iio_trigger_unregister);
+
+struct iio_trigger *iio_trigger_find_by_name(const char *name, size_t len)
+{
+	struct iio_trigger *trig;
+	bool found = false;
+
+	mutex_lock(&iio_trigger_list_lock);
+	list_for_each_entry(trig, &iio_trigger_list, list) {
+		if (strncmp(trig->name, name, len) == 0) {
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&iio_trigger_list_lock);
+
+	return found ? trig : NULL;
+};
+EXPORT_SYMBOL(iio_trigger_find_by_name);
+
+void iio_trigger_poll(struct iio_trigger *trig)
+{
+	struct iio_poll_func *pf_cursor;
+
+	list_for_each_entry(pf_cursor, &trig->pollfunc_list, list) {
+		if (pf_cursor->poll_func_immediate) {
+			pf_cursor->poll_func_immediate(pf_cursor->private_data);
+			trig->use_count++;
+		}
+	}
+	list_for_each_entry(pf_cursor, &trig->pollfunc_list, list) {
+		if (pf_cursor->poll_func_main) {
+			pf_cursor->poll_func_main(pf_cursor->private_data);
+			trig->use_count++;
+		}
+	}
+}
+EXPORT_SYMBOL(iio_trigger_poll);
+
+void iio_trigger_notify_done(struct iio_trigger *trig)
+{
+	trig->use_count--;
+	if (trig->use_count == 0 && trig->try_reenable)
+		if (trig->try_reenable(trig)) {
+			/* Missed and interrupt so launch new poll now */
+			trig->timestamp = 0;
+			iio_trigger_poll(trig);
+		}
+}
+EXPORT_SYMBOL(iio_trigger_notify_done);
+
+ssize_t iio_trigger_read_name(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct iio_trigger *trig = dev_get_drvdata(dev);
+	return sprintf(buf, "%s\n", trig->name);
+}
+EXPORT_SYMBOL(iio_trigger_read_name);
+
+/* Trigger Consumer related functions */
+
+/* Complexity in here.  With certain triggers (datardy) an acknowledgement
+ * may be needed if the pollfuncs do not include the data read for the
+ * triggering device.
+ * This is not currently handled.  Alternative of not enabling trigger unless
+ * the relevant function is in there may be the best option.
+ */
+/* Worth protecting against double additions?*/
+int iio_trigger_attach_poll_func(struct iio_trigger *trig,
+				 struct iio_poll_func *pf)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&trig->pollfunc_list_lock, flags);
+	list_add_tail(&pf->list, &trig->pollfunc_list);
+	spin_unlock_irqrestore(&trig->pollfunc_list_lock, flags);
+
+	if (trig->set_trigger_state)
+		ret = trig->set_trigger_state(trig, true);
+
+	return ret;
+}
+EXPORT_SYMBOL(iio_trigger_attach_poll_func);
+
+int iio_trigger_dettach_poll_func(struct iio_trigger *trig,
+				  struct iio_poll_func *pf)
+{
+	struct iio_poll_func *pf_cursor;
+	unsigned long flags;
+	int succeeded = 0;
+
+	spin_lock_irqsave(&trig->pollfunc_list_lock, flags);
+	list_for_each_entry(pf_cursor, &trig->pollfunc_list, list)
+		if (pf_cursor == pf) {
+			succeeded = 1;
+			break;
+		}
+	if (list_is_singular(&trig->pollfunc_list) && trig->set_trigger_state) {
+		spin_unlock_irqrestore(&trig->pollfunc_list_lock, flags);
+		/* May require sleeping */
+		trig->set_trigger_state(trig, false);
+		spin_lock_irqsave(&trig->pollfunc_list_lock, flags);
+	}
+	/* Now we can delete safe in the knowledge that no interrupts
+	 * can be generated if nothing is there to handle them. */
+	if (succeeded)
+		list_del(&pf_cursor->list);
+	spin_unlock_irqrestore(&trig->pollfunc_list_lock, flags);
+
+	return succeeded ? 0 : -EINVAL;
+}
+EXPORT_SYMBOL(iio_trigger_dettach_poll_func);
+
+/**
+ * iio_trigger_read_currrent() trigger consumer sysfs query which trigger
+ *
+ * For trigger consumers the current_trigger interface allows the trigger
+ * used by the device to be queried.
+ **/
+static ssize_t iio_trigger_read_current(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	int len = 0;
+	if (dev_info->trig)
+		len = snprintf(buf,
+			       IIO_TRIGGER_NAME_LENGTH,
+			       "%s\n",
+			       dev_info->trig->name);
+	return len;
+}
+
+/**
+ * iio_trigger_write_current() trigger consumer sysfs set current trigger
+ *
+ * For trigger consumers the current_trigger interface allows the trigger
+ * used for this device to be specified at run time based on the triggers
+ * name.
+ * Latter part of this function is concerned with maintaining use counts
+ * for any modules providing triggers to prevent removal when in use.
+ **/
+static ssize_t iio_trigger_write_current(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf,
+					 size_t len)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct iio_trigger *oldtrig = dev_info->trig;
+	mutex_lock(&dev_info->mlock);
+	if (dev_info->currentmode == INDIO_RING_TRIGGERED) {
+		mutex_unlock(&dev_info->mlock);
+		return -EBUSY;
+	}
+	mutex_unlock(&dev_info->mlock);
+
+	len = len < IIO_TRIGGER_NAME_LENGTH ? len : IIO_TRIGGER_NAME_LENGTH;
+
+	dev_info->trig = iio_trigger_find_by_name(buf, len);
+	if (dev_info->trig != oldtrig)
+		module_put(oldtrig->owner);
+	else if (dev_info->trig)
+		try_module_get(dev_info->trig->owner);
+
+	return len;
+}
+
+DEVICE_ATTR(current_trigger, S_IRUGO | S_IWUSR,
+	    iio_trigger_read_current,
+	    iio_trigger_write_current);
+
+static struct attribute *iio_trigger_consumer_attrs[] = {
+	&dev_attr_current_trigger.attr,
+	NULL,
+};
+
+static const struct attribute_group iio_trigger_consumer_attr_group = {
+	.name = "trigger",
+	.attrs = iio_trigger_consumer_attrs,
+};
+
+int iio_device_register_trigger_consumer(struct iio_dev *dev_info)
+{
+	int ret;
+	ret = sysfs_create_group(&dev_info->sysfs_dev->kobj,
+				 &iio_trigger_consumer_attr_group);
+	return ret;
+}
+EXPORT_SYMBOL(iio_device_register_trigger_consumer);
+
+int iio_device_unregister_trigger_consumer(struct iio_dev *dev_info)
+{
+	sysfs_remove_group(&dev_info->sysfs_dev->kobj,
+			   &iio_trigger_consumer_attr_group);
+	return 0;
+}
+EXPORT_SYMBOL(iio_device_unregister_trigger_consumer);
diff --git a/include/linux/industrialio/trigger.h b/include/linux/industrialio/trigger.h
index 517213d..bca0678 100644
--- a/include/linux/industrialio/trigger.h
+++ b/include/linux/industrialio/trigger.h
@@ -13,6 +13,116 @@
 #define IIO_TRIGGER_ID_FORMAT IIO_TRIGGER_ID_PREFIX "%d"
 
 #ifdef CONFIG_IIO_TRIGGERS
+
+/**
+ * struct iio_trigger - industrial I/O trigger device
+ *
+ * @id:			[INTERN] unique id number
+ * @name:		[DRIVER] unique name
+ * @dev:		[DRIVER] associated device (if relevant)
+ * @sysfs_dev:		[INTERN] sysfs relevant device
+ * @private_data:	[DRIVER] device specific data
+ * @list:		[INTERN] used in maintenance of global trigger list
+ * @alloc_list:		[DRIVER] used for driver specific trigger list
+ * @poll_func_list_lock:[INTERN] protection of the polling function list
+ * @pollfunc_list:	[INTERN] list of functions to run on trigger.
+ * @control_attrs:	[DRIVER] sysfs attributes relevant to trigger type
+ * @set_trigger_state:	[DRIVER] switch on/off the trigger on demand
+ * @timestamp:		[INTERN] timestamp usesd by some trigs (e.g. datardy)
+ * @owner:		[DRIVER] used to monitor usage count of the trigger.
+ **/
+struct iio_trigger {
+	int				id;
+	const char			*name;
+	struct device			*dev;
+	struct device			*sysfs_dev;
+	void				*private_data;
+	struct list_head		list;
+	struct list_head		alloc_list;
+	spinlock_t			pollfunc_list_lock;
+	struct list_head		pollfunc_list;
+	const struct attribute_group	*control_attrs;
+	s64				timestamp;
+	struct module			*owner;
+	int use_count;
+
+	int (*set_trigger_state)(struct iio_trigger *trig, bool state);
+	int (*try_reenable)(struct iio_trigger *trig);
+};
+
+/**
+ * iio_trigger_read_name() - sysfs access function to get the trigger name
+ **/
+ssize_t iio_trigger_read_name(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf);
+
+#define IIO_TRIGGER_NAME_ATTR DEVICE_ATTR(name, S_IRUGO,		\
+					  iio_trigger_read_name,	\
+					  NULL);
+
+/**
+ * iio_trigger_find_by_name() - search global trigger list
+ **/
+struct iio_trigger *iio_trigger_find_by_name(const char *name, size_t len);
+
+/**
+ * iio_trigger_init() - initialize lists and spinlocks in iio_trigger struct
+ **/
+static inline void iio_trigger_init(struct iio_trigger *trig)
+{
+	spin_lock_init(&trig->pollfunc_list_lock);
+	INIT_LIST_HEAD(&trig->list);
+	INIT_LIST_HEAD(&trig->pollfunc_list);
+};
+
+/**
+ * iio_trigger_register() - register a trigger with the IIO core
+ * @trig_info:	trigger to be registered
+ * @parent:	the device with which the trigger is associated
+ * @id:		unique indentification
+ **/
+int iio_trigger_register(struct iio_trigger *trig_info,
+			 struct device *parent,
+			 int id);
+
+/**
+ * iio_trigger_unregister() - unregister a trigger from the core
+ **/
+void iio_trigger_unregister(struct iio_trigger *trig_info);
+
+/**
+ * iio_trigger_attach_poll_func() - add a function pair to be run on trigger
+ * @trig:	trigger to which the function pair are being added
+ * @pf:	poll function pair
+ **/
+int iio_trigger_attach_poll_func(struct iio_trigger *trig,
+				 struct iio_poll_func *pf);
+
+/**
+ * iio_trigger_dettach_poll_func() -	remove function pair from those to be
+ *					run on trigger.
+ * @trig:	trigger from which the function is being removed.
+ * @pf:		poll function pair
+ **/
+int iio_trigger_dettach_poll_func(struct iio_trigger *trig,
+				  struct iio_poll_func *pf);
+
+/**
+ * iio_device_register_trigger_consumer() - set up an iio_dev to use triggers.
+ **/
+int iio_device_register_trigger_consumer(struct iio_dev *dev_info);
+/**
+ * iio_device_unregister_trigger_consumer() - reverse the registration process.
+ **/
+int iio_device_unregister_trigger_consumer(struct iio_dev *dev_info);
+
+/**
+ * iio_trigger_poll() - called on a trigger occuring
+ * Typically called in relevant hardware interrupt handler.
+ **/
+void iio_trigger_poll(struct iio_trigger *);
+void iio_trigger_notify_done(struct iio_trigger *);
 #else
 struct iio_trigger{};
 static inline int iio_device_register_trigger_consumer(struct iio_dev *dev_info)
