Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZGOHjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZGOHjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZGOHjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:39:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:15075 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbZGOHhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:37:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,403,1243839600"; 
   d="scan'208";a="474968445"
Subject: [PATCH 3/8] hook device async mechanism in device core
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 15:38:37 +0800
Message-Id: <1247643517.26272.78.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hook the device async mechanism in driver core.
A device inherits its parent's async domain when it's created.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/base/async_dev.c |   22 ++++++++++++++++++----
 drivers/base/core.c      |    9 +++++++++
 2 files changed, 27 insertions(+), 4 deletions(-)

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
Index: linux-2.6/drivers/base/async_dev.c
===================================================================
--- linux-2.6.orig/drivers/base/async_dev.c
+++ linux-2.6/drivers/base/async_dev.c
@@ -105,6 +105,13 @@ void dev_async_synchronization(void)
 	return;
 }
 
+static int dev_match(struct device *dev, void *data)
+{
+	dev_err(dev->parent, "Child device %s is registered before "
+		"dev->dev_async being initialized", dev_name(dev));
+	return 1;
+}
+
 /**
  * device_async_register - register a device that supports async actions
  * @dev: Device.
@@ -123,12 +130,19 @@ int dev_async_register(struct device *de
 		return -EINVAL;
 
 	if (dev->dev_async) {
-		if (dev->dev_async->dev == dev) {
-			printk(KERN_ERR "device already registered\n");
-			return -EEXIST;
-		}
+		/* multiple async domains for a single device not supported */
+		dev_err(dev, "async domain already registered\n");
+		return -EEXIST;
 	}
 
+	/*
+	 * dev_async_register must be called before any of its child devices
+	 * being registered to the driver model.
+	 */
+	if (dev->p)
+		if (device_find_child(dev, NULL, dev_match))
+			return -EINVAL;
+
 	if (!(DEV_ASYNC_ACTIONS_ALL & type))
 	/* check for unsupported async actions */
 		return -EINVAL;


