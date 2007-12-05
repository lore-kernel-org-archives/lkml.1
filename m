Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbXLELuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbXLELuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 06:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXLELu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 06:50:26 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:32018 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbXLELuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 06:50:25 -0500
Date: Wed, 5 Dec 2007 12:50:23 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [patch 1/3] driver core: Introduce default attribute groups.
Message-ID: <20071205125023.50f4c478@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071205114119.905238262@de.ibm.com>
References: <20071205114119.905238262@de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is lot like default attributes for devices (and indeed,
a lot of the code is lifted from there).

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/driver.c  |   44 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/device.h |    2 ++
 2 files changed, 45 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/driver.c
===================================================================
--- linux-2.6.orig/drivers/base/driver.c	2007-12-05 09:53:15.000000000 +0100
+++ linux-2.6/drivers/base/driver.c	2007-12-05 12:41:02.000000000 +0100
@@ -151,6 +151,39 @@ void put_driver(struct device_driver * d
 	kobject_put(&drv->p->kobj);
 }
 
+static int driver_add_groups(struct device_driver *drv,
+			     struct attribute_group **groups)
+{
+	int error = 0;
+	int i;
+	struct driver_private *priv = drv->p;
+
+	if (groups) {
+		for (i = 0; groups[i]; i++) {
+			error = sysfs_create_group(&priv->kobj, groups[i]);
+			if (error) {
+				while (--i >= 0)
+					sysfs_remove_group(&priv->kobj,
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
+	struct driver_private *priv = drv->p;
+
+	if (groups)
+		for (i = 0; groups[i]; i++)
+			sysfs_remove_group(&priv->kobj, groups[i]);
+}
+
+
 /**
  *	driver_register - register driver with bus
  *	@drv:	driver to register
@@ -161,12 +194,20 @@ void put_driver(struct device_driver * d
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
@@ -178,6 +219,7 @@ int driver_register(struct device_driver
 
 void driver_unregister(struct device_driver * drv)
 {
+	driver_remove_groups(drv, drv->groups);
 	bus_remove_driver(drv);
 }
 
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h	2007-12-05 09:53:15.000000000 +0100
+++ linux-2.6/include/linux/device.h	2007-12-05 12:25:36.000000000 +0100
@@ -126,6 +126,8 @@ struct device_driver {
 	int	(*suspend)	(struct device * dev, pm_message_t state);
 	int	(*resume)	(struct device * dev);
 
+	struct attribute_group **groups;
+
 	struct driver_private *p;
 };
 

