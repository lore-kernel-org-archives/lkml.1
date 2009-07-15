Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZGOHhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZGOHhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZGOHhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:37:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:50176 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbZGOHhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:37:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,403,1243839600"; 
   d="scan'208";a="165149370"
Subject: [PATCH 2/8] introduce the device async action mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 15:38:36 +0800
Message-Id: <1247643516.26272.77.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the device async action mechanism.

In order to speed up Linux suspend/resume/shutdown process,
we introduce the device async action mechanism that allow devices
to suspend/resume/shutdown asynchronously.

The basic idea is that,
if the suspend/resume/shutdown process of a device set,
including a root device and its child devices, are independent of
other devices, we create an async domain for this device set,
and make them suspend/resume/shutdown asynchronously.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/base/Makefile     |    3 
 drivers/base/async_dev.c  |  180 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/async_dev.h |   40 ++++++++++
 include/linux/device.h    |    2 
 4 files changed, 224 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/async_dev.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/async_dev.h
@@ -0,0 +1,40 @@
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
+#define DEV_ASYNC_ACTIONS_ALL	0
+
+extern int dev_async_schedule(struct device *, void *,
+			void *, int);
+extern void dev_async_synchronization(void);
+
+extern int dev_async_register(struct device *, int);
+extern void dev_async_unregister(struct device *);
+
+#endif /* _ASYNC_DEV_H_ */
Index: linux-2.6/drivers/base/async_dev.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/async_dev.c
@@ -0,0 +1,180 @@
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
+	int type;
+};
+
+static int dev_action(struct device *dev, void *func,
+			void *data, int type)
+{
+	if (!func)
+		return -EINVAL;
+
+	return 0;
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
+	error =	dev_action(context->dev, context->func, context->data,
+							context->type);
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
+int dev_async_schedule(struct device *dev, void *func,
+			void *data, int type)
+{
+	struct dev_async_context *context;
+
+	if (!dev_async_enabled || !dev->dev_async)
+		return dev_action(dev, func, data, type);
+
+	/* the current dev async action is not supported */
+	if (!(dev->dev_async->type & type))
+		return dev_action(dev, func, data, type);
+
+	if (!func)
+		return -EINVAL;
+
+	if (type > DEV_ASYNC_ACTIONS_ALL)
+		return -EINVAL;
+
+	context = kzalloc(sizeof(struct dev_async_context), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	context->dev = dev;
+	context->data = data;
+	context->func = func;
+	context->type = type;
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
+		if (dev->dev_async->dev == dev) {
+			printk(KERN_ERR "device already registered\n");
+			return -EEXIST;
+		}
+	}
+
+	if (!(DEV_ASYNC_ACTIONS_ALL & type))
+	/* check for unsupported async actions */
+		return -EINVAL;
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
+		return ;
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
 
@@ -416,6 +417,7 @@ struct device {
 	struct attribute_group	**groups;	/* optional groups */
 
 	void	(*release)(struct device *dev);
+	struct dev_async_struct	*dev_async;	/* device async actions */
 };
 
 /* Get the wakeup routines, which depend on struct device */
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


