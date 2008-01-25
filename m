Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYAYIhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYAYIhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764157AbYAYIBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764090AbYAYH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 145/196] driver core: Introduce default attribute groups.
Date: Thu, 24 Jan 2008 23:32:54 -0800
Message-Id: <1201246425-5058-66-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

This is lot like default attributes for devices (and indeed,
a lot of the code is lifted from there).

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/driver.c  |   42 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/device.h |    1 +
 2 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index f94be40..e3b5840 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -142,6 +142,37 @@ void put_driver(struct device_driver * drv)
 	kobject_put(&drv->kobj);
 }
 
+static int driver_add_groups(struct device_driver *drv,
+			     struct attribute_group **groups)
+{
+	int error = 0;
+	int i;
+
+	if (groups) {
+		for (i = 0; groups[i]; i++) {
+			error = sysfs_create_group(&drv->kobj, groups[i]);
+			if (error) {
+				while (--i >= 0)
+					sysfs_remove_group(&drv->kobj,
+							   groups[i]);
+				break;
+			}
+		}
+	}
+	return error;
+}
+
+static void driver_remove_groups(struct device_driver *drv,
+				 struct attribute_group **groups)
+{
+	int i;
+
+	if (groups)
+		for (i = 0; groups[i]; i++)
+			sysfs_remove_group(&drv->kobj, groups[i]);
+}
+
+
 /**
  *	driver_register - register driver with bus
  *	@drv:	driver to register
@@ -152,13 +183,21 @@ void put_driver(struct device_driver * drv)
  */
 int driver_register(struct device_driver * drv)
 {
+	int ret;
+
 	if ((drv->bus->probe && drv->probe) ||
 	    (drv->bus->remove && drv->remove) ||
 	    (drv->bus->shutdown && drv->shutdown)) {
 		printk(KERN_WARNING "Driver '%s' needs updating - please use bus_type methods\n", drv->name);
 	}
 	klist_init(&drv->klist_devices, NULL, NULL);
-	return bus_add_driver(drv);
+	ret = bus_add_driver(drv);
+	if (ret)
+		return ret;
+	ret = driver_add_groups(drv, drv->groups);
+	if (ret)
+		bus_remove_driver(drv);
+	return ret;
 }
 
 /**
@@ -170,6 +209,7 @@ int driver_register(struct device_driver * drv)
 
 void driver_unregister(struct device_driver * drv)
 {
+	driver_remove_groups(drv, drv->groups);
 	bus_remove_driver(drv);
 }
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 3f24bf4..d974dda 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -129,6 +129,7 @@ struct device_driver {
 	void	(*shutdown)	(struct device * dev);
 	int	(*suspend)	(struct device * dev, pm_message_t state);
 	int	(*resume)	(struct device * dev);
+	struct attribute_group **groups;
 };
 
 
-- 
1.5.3.8

