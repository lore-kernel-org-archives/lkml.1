Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZGXDBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZGXDBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZGXDBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:01:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:12219 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZGXDBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:01:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,259,1246863600"; 
   d="scan'208";a="168406376"
Subject: [PATCH V2 2/4] introduce the device async action mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, dtor@mail.ru,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 11:02:04 +0800
Message-Id: <1248404524.2670.110.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce Device Async Action Mechanism

In order to speed up Linux suspend/resume/shutdown process,
we introduce the device async action mechanism that allow devices
to suspend/resume/shutdown asynchronously.

The basic idea is that,
if the suspend/resume/shutdown process of a device group,
including a root device and its child devices, are independent of
other devices, we create an async domain for this device group,
and make them suspend/resume/shutdown asynchronously.    

Note that DEV_ASYNC_RESUME is different from DEV_ASYNC_SUSPEND and
DEV_ASYNC_SHUTDOWN.
In resume case, all the parents are resumed first.
deferred resuming of the child devices won't break anything.
So it's easy to find out a device group that supports DEV_ASYNC_RESUME.

In suspend/shutdown case, child devices should be suspended/shutdown
before the parents. But deferred suspend/shutdown may break this rule.
so for a device groups that supports DEV_ASYNC_SUSPEND&DEV_ASYNC_SHUTDOWN,
the root device of this device async group must NOT depend on its parents.
i.e. it's fully functional without its parents.
e.g. I create a device async group for i8042 controller in patch 4,
and the parent of i8042 controller device is the "platform" device under
sysfs root device.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/base/Makefile     |    3 
 drivers/base/async_dev.c  |  199 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/base/core.c       |   35 ++++++--
 drivers/base/power/main.c |   24 +++++
 include/linux/async_dev.h |   47 ++++++++++
 include/linux/device.h    |    2 
 6 files changed, 298 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/base/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/Makefile
+++ linux-2.6/drivers/base/Makefile
@@ -3,7 +3,8 @@
 obj-y			:= core.o sys.o bus.o dd.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
-			   attribute_container.o transport_class.o
+			   attribute_container.o transport_class.o \
+			   async_dev.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_ISA)	+= isa.o
Index: linux-2.6/drivers/base/async_dev.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/async_dev.c
@@ -0,0 +1,199 @@
+/*
+ * async_dev.c: Device asynchronous functions
+ *
+ * (C) Copyright 2009 Intel Corporation
+ * Author: Zhang Rui <rui.zhang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/device.h>
+#include <linux/async.h>
+#include <linux/async_dev.h>
+
+static LIST_HEAD(dev_async_list);
+static int dev_async_enabled;
+
+struct dev_async_context {
+	struct device *dev;
+	void *data;
+	void *func;
+};
+
+static int dev_action(struct device *dev, dev_async_func func,
+			void *data)
+{
+	int error = 0;
+
+	if (!func || !dev)
+		return -EINVAL;
+
+	error = func(dev, data);
+
+	return error;
+}
+
+static void dev_async_action(void *data, async_cookie_t cookie)
+{
+	int error;
+	struct dev_async_context *context = data;
+
+	context->dev->dev_async->cookie = cookie;
+	async_synchronize_cookie_domain(cookie,
+					 &context->dev->dev_async->domain);
+
+	error =	dev_action(context->dev, context->func, context->data);
+	if (error)
+		printk(KERN_ERR "PM: Device %s async action failed: error %d\n",
+			dev_name(context->dev), error);
+
+	kfree(context);
+}
+
+/**
+ * dev_async_schedule - async execution of device actions.
+ * @dev: Device.
+ * @func: device callback function.
+ * @data: data.
+ * @type: the type of device async actions.
+ */
+int dev_async_schedule(struct device *dev, dev_async_func func,
+			void *data, int type)
+{
+	struct dev_async_context *context;
+
+	if (!func || !dev)
+		return -EINVAL;
+
+	if (!(type & DEV_ASYNC_ACTIONS_ALL))
+		return -EINVAL;
+
+	if (!dev_async_enabled || !dev->dev_async)
+		return dev_action(dev, func, data);
+
+	/* device doesn't support the current async action */
+	if (!(dev->dev_async->type & type))
+		return dev_action(dev, func, data);
+
+	context = kzalloc(sizeof(struct dev_async_context), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	context->dev = dev;
+	context->data = data;
+	context->func = func;
+	async_schedule_domain(dev_async_action, context,
+			       &dev->dev_async->domain);
+	return 0;
+}
+
+/**
+ * device_async_synchronization - sync point for all the async actions
+ * @dev: Device.
+ *
+ * wait until all the async actions are done.
+ */
+void dev_async_synchronization(void)
+{
+	struct dev_async_struct *pos;
+
+	list_for_each_entry(pos, &dev_async_list, node)
+	    async_synchronize_full_domain(&pos->domain);
+
+	return;
+}
+
+static int dev_match(struct device *dev, void *data)
+{
+	dev_err(dev->parent, "Child device %s is registered before "
+		"dev->dev_async being initialized", dev_name(dev));
+	return 1;
+}
+
+/**
+ * device_async_register - register a device that supports async actions
+ * @dev: Device.
+ * @type: the kind of dev async actions that supported
+ *
+ * Register a device that supports a certain kind of dev async actions.
+ * Create a synchrolization Domain for this device and share with all its
+ * child devices.
+ */
+int dev_async_register(struct device *dev, int type)
+{
+	if (!dev_async_enabled)
+		return 0;
+
+	if (!dev)
+		return -EINVAL;
+
+	if (dev->dev_async) {
+		/* multiple async domains for a single device not supported */
+		dev_err(dev, "async domain already registered\n");
+		return -EEXIST;
+	}
+
+	/*
+	 * dev_async_register must be called before any of its child devices
+	 * being registered to the driver model.
+	 */
+	if (dev->p)
+		if (device_find_child(dev, NULL, dev_match)) {
+			dev_err(dev, "Can not register device async domain\n");
+			return -EINVAL;
+		}
+
+	/* check for unsupported async actions */
+	if (!(type & DEV_ASYNC_ACTIONS_ALL)) {
+		dev_err(dev, "unsupported async action %x registered\n", type);
+		return -EINVAL;
+	}
+
+	dev->dev_async = kzalloc(sizeof(struct dev_async_struct), GFP_KERNEL);
+	if (!dev->dev_async)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&dev->dev_async->domain);
+	dev->dev_async->dev = dev;
+	dev->dev_async->type = type;
+	list_add_tail(&dev->dev_async->node, &dev_async_list);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dev_async_register);
+
+/**
+ * device_async_unregister - unregister a device that supports async actions
+ * @dev: Device.
+ *
+ * Unregister a device that supports async actions.
+ * And delete async action Domain at the same time.
+ */
+void dev_async_unregister(struct device *dev)
+{
+	if (!dev_async_enabled)
+		return;
+
+	if (!dev->dev_async)
+		return;
+
+	if (dev->dev_async->dev != dev)
+		return;
+
+	list_del(&dev->dev_async->node);
+	kfree(dev->dev_async);
+	dev->dev_async = NULL;
+	return;
+}
+EXPORT_SYMBOL_GPL(dev_async_unregister);
+
+/* To enable the device async actions, boot with "dev_async_action" */
+static int __init enable_dev_async(char *arg)
+{
+	dev_async_enabled = 1;
+	return 0;
+}
+
+early_param("dev_async_action", enable_dev_async);
Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -899,6 +899,13 @@ int device_add(struct device *dev)
 	if (parent)
 		set_dev_node(dev, dev_to_node(parent));
 
+	/* inherit parent's async domain */
+	if (parent && parent->dev_async)
+		if (!dev->dev_async)
+			dev->dev_async = parent->dev_async;
+		else
+			dev_err(dev, "multiple dev async actions registered\n");
+
 	/* first, register with generic layer. */
 	/* we require the name to be set before, and pass NULL */
 	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
@@ -984,6 +991,7 @@ done:
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	kobject_del(&dev->kobj);
  Error:
+	dev->dev_async = NULL;
 	cleanup_device_parent(dev);
 	if (parent)
 		put_device(parent);
@@ -1100,6 +1108,7 @@ void device_del(struct device *dev)
 	if (platform_notify_remove)
 		platform_notify_remove(dev);
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
+	dev->dev_async = NULL;
 	cleanup_device_parent(dev);
 	kobject_del(&dev->kobj);
 	put_device(parent);
@@ -1695,6 +1704,18 @@ out:
 }
 EXPORT_SYMBOL_GPL(device_move);
 
+static int dev_async_shutdown(struct device *dev, void *data)
+{
+	if (dev->bus && dev->bus->shutdown) {
+		dev_dbg(dev, "shutdown\n");
+		dev->bus->shutdown(dev);
+	} else if (dev->driver && dev->driver->shutdown) {
+		dev_dbg(dev, "shutdown\n");
+		dev->driver->shutdown(dev);
+	}
+	return 0;
+}
+
 /**
  * device_shutdown - call ->shutdown() on each device to shutdown.
  */
@@ -1703,17 +1724,13 @@ void device_shutdown(void)
 	struct device *dev, *devn;
 
 	list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
-				kobj.entry) {
-		if (dev->bus && dev->bus->shutdown) {
-			dev_dbg(dev, "shutdown\n");
-			dev->bus->shutdown(dev);
-		} else if (dev->driver && dev->driver->shutdown) {
-			dev_dbg(dev, "shutdown\n");
-			dev->driver->shutdown(dev);
-		}
-	}
+				kobj.entry)
+		dev_async_schedule(dev, dev_async_shutdown, NULL,
+					DEV_ASYNC_SHUTDOWN);
+
 	kobject_put(sysfs_dev_char_kobj);
 	kobject_put(sysfs_dev_block_kobj);
 	kobject_put(dev_kobj);
+	dev_async_synchronization();
 	async_synchronize_full();
 }
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -24,6 +24,7 @@
 #include <linux/resume-trace.h>
 #include <linux/rwsem.h>
 #include <linux/interrupt.h>
+#include <linux/async_dev.h>
 
 #include "../base.h"
 #include "power.h"
@@ -420,6 +421,13 @@ static int device_resume(struct device *
 	return error;
 }
 
+static int device_async_resume(struct device *dev, void *data)
+{
+	pm_message_t *state = data;
+
+	return device_resume(dev, *state);
+}
+
 /**
  *	dpm_resume - Resume every device.
  *	@state: PM transition of the system being carried out.
@@ -444,7 +452,8 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = dev_async_schedule(dev, device_async_resume,
+						&state, DEV_ASYNC_RESUME);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -459,6 +468,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	dev_async_synchronization();
 }
 
 /**
@@ -659,6 +669,13 @@ static int device_suspend(struct device 
 	return error;
 }
 
+static int device_async_suspend(struct device *dev, void *data)
+{
+	pm_message_t *state = data;
+
+	return device_suspend(dev, *state);
+}
+
 /**
  *	dpm_suspend - Suspend every device.
  *	@state: PM transition of the system being carried out.
@@ -678,7 +695,8 @@ static int dpm_suspend(pm_message_t stat
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_suspend(dev, state);
+		error = dev_async_schedule(dev, device_async_suspend,
+					&state, DEV_ASYNC_SUSPEND);
 
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
@@ -693,6 +711,8 @@ static int dpm_suspend(pm_message_t stat
 	}
 	list_splice(&list, dpm_list.prev);
 	mutex_unlock(&dpm_list_mtx);
+
+	dev_async_synchronization();
 	return error;
 }
 
Index: linux-2.6/include/linux/async_dev.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/async_dev.h
@@ -0,0 +1,47 @@
+/*
+ * async_dev.h: function calls for device async actions
+ *
+ * (C) Copyright 2009 Intel Corporation
+ * Author: Zhang Rui <rui.zhang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#ifndef _ASYNC_DEV_H_
+#define _ASYNC_DEV_H_
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/async.h>
+#include <linux/device.h>
+#include <linux/pm.h>
+
+struct dev_async_struct {
+	struct device *dev;
+	int type;
+	/* Synchronization Domain for device async actions */
+	struct list_head domain;
+	struct list_head node;
+	async_cookie_t cookie;
+};
+
+typedef int (*dev_async_func) (struct device *dev, void *data);
+
+#define DEV_ASYNC_SUSPEND	1
+#define DEV_ASYNC_RESUME	2
+#define DEV_ASYNC_SHUTDOWN	4
+#define DEV_ASYNC_ACTIONS_ALL	(DEV_ASYNC_SUSPEND |	\
+				DEV_ASYNC_RESUME |	\
+				DEV_ASYNC_SHUTDOWN)
+
+extern int dev_async_schedule(struct device *, dev_async_func,
+			void *, int);
+extern void dev_async_synchronization(void);
+
+extern int dev_async_register(struct device *, int);
+extern void dev_async_unregister(struct device *);
+
+#endif /* _ASYNC_DEV_H_ */
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/pm.h>
 #include <linux/semaphore.h>
+#include <linux/async_dev.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
 
@@ -414,6 +415,7 @@ struct device {
 	struct attribute_group	**groups;	/* optional groups */
 
 	void	(*release)(struct device *dev);
+	struct dev_async_struct	*dev_async;	/* device async actions */
 };
 
 /* Get the wakeup routines, which depend on struct device */


