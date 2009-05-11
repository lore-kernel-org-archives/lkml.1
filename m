Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbZEKVyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbZEKVyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZEKVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:53:58 -0400
Received: from kroah.org ([198.145.64.141]:43336 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbZEKVx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:53:57 -0400
Date: Mon, 11 May 2009 14:50:15 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>
Subject: [PATCH] Driver core: move dev_get/set_drvdata to drivers/base/dd.c
Message-ID: <20090511215015.GA15078@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my driver-core tree, I've cleaned up all direct accesses of the
driver_data field in struct device.  So here's a final patch I've also
added that renames the field so that no one uses it again in the future.
It will show up in linux-next tomorrow.

thanks,

greg k-h

----------------------

No one should directly access the driver_data field, so change the
variable to hopefully state this.  Then move the get/set functions into
dd.c so that we can properly handle the changes that will be needed to
these functions in the future when we add the multiple device/driver
logic to the driver core.

Also update the copyright notices on these files while we are there.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/dd.c      |   20 ++++++++++++++++++--
 include/linux/device.h |   20 ++++++++------------
 2 files changed, 26 insertions(+), 14 deletions(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -11,8 +11,8 @@
  *
  * Copyright (c) 2002-5 Patrick Mochel
  * Copyright (c) 2002-3 Open Source Development Labs
- * Copyright (c) 2007 Greg Kroah-Hartman <gregkh@suse.de>
- * Copyright (c) 2007 Novell Inc.
+ * Copyright (c) 2007-2009 Greg Kroah-Hartman <gregkh@suse.de>
+ * Copyright (c) 2007-2009 Novell Inc.
  *
  * This file is released under the GPLv2
  */
@@ -380,3 +380,19 @@ void driver_detach(struct device_driver 
 		put_device(dev);
 	}
 }
+
+/*
+ * These exports can't be _GPL due to .h files using this within them, and it
+ * might break something that was previously working...
+ */
+void *dev_get_drvdata(const struct device *dev)
+{
+	return dev->dd_DO_NOT_USE;
+}
+EXPORT_SYMBOL(dev_get_drvdata);
+
+void dev_set_drvdata(struct device *dev, void *data)
+{
+	dev->dd_DO_NOT_USE = data;
+}
+EXPORT_SYMBOL(dev_set_drvdata);
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -2,7 +2,8 @@
  * device.h - generic, centralized driver model
  *
  * Copyright (c) 2001-2003 Patrick Mochel <mochel@osdl.org>
- * Copyright (c) 2004-2007 Greg Kroah-Hartman <gregkh@suse.de>
+ * Copyright (c) 2004-2009 Greg Kroah-Hartman <gregkh@suse.de>
+ * Copyright (c) 2008-2009 Novell Inc.
  *
  * This file is released under the GPLv2
  *
@@ -387,7 +388,10 @@ struct device {
 	struct bus_type	*bus;		/* type of bus device is on */
 	struct device_driver *driver;	/* which driver has allocated this
 					   device */
-	void		*driver_data;	/* data private to the driver */
+	void		*dd_DO_NOT_USE;	/* data private to the driver, do
+					 * not directly touch this field,
+					 * use the dev_get/set_drvdata()
+					 * functions instead. */
 	void		*platform_data;	/* Platform specific data, device
 					   core doesn't touch it */
 	struct dev_pm_info	power;
@@ -453,16 +457,6 @@ static inline void set_dev_node(struct d
 }
 #endif
 
-static inline void *dev_get_drvdata(const struct device *dev)
-{
-	return dev->driver_data;
-}
-
-static inline void dev_set_drvdata(struct device *dev, void *data)
-{
-	dev->driver_data = data;
-}
-
 static inline unsigned int dev_get_uevent_suppress(const struct device *dev)
 {
 	return dev->kobj.uevent_suppress;
@@ -496,6 +490,8 @@ extern int device_rename(struct device *
 extern int device_move(struct device *dev, struct device *new_parent,
 		       enum dpm_order dpm_order);
 extern const char *device_get_nodename(struct device *dev, const char **tmp);
+extern void *dev_get_drvdata(const struct device *dev);
+extern void dev_set_drvdata(struct device *dev, void *data);
 
 /*
  * Root device objects for grouping under /sys/devices
