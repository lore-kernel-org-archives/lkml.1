Return-Path: <linux-kernel-owner+w=401wt.eu-S933093AbZJ3Wz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbZJ3Wz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933071AbZJ3Wzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:55:49 -0400
Received: from kroah.org ([198.145.64.141]:38965 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933013AbZJ3Wy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:54:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>,
       =?UTF-8?q?=C3=89ric=20Piel?= <eric.piel@tremplin-utc.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/9] Driver core: allow certain drivers prohibit bind/unbind via sysfs
Date: Fri, 30 Oct 2009 15:54:21 -0700
Message-Id: <1256943268-12164-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091030220930.GA11297@kroah.com>
References: <20091030220930.GA11297@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Platform drivers registered via platform_driver_probe() can be bound
to devices only once, upon registration, because discard their probe()
routines to save memory. Unbinding the driver through sysfs 'unbind'
leaves the device stranded and confuses users so let's not create
bind and unbind attributes for such drivers.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Éric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c      |   17 +++++++++++------
 drivers/base/platform.c |    6 +++++-
 include/linux/device.h  |    4 +++-
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 973bf2a..63c143e 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -689,15 +689,19 @@ int bus_add_driver(struct device_driver *drv)
 		printk(KERN_ERR "%s: driver_add_attrs(%s) failed\n",
 			__func__, drv->name);
 	}
-	error = add_bind_files(drv);
-	if (error) {
-		/* Ditto */
-		printk(KERN_ERR "%s: add_bind_files(%s) failed\n",
-			__func__, drv->name);
+
+	if (!drv->suppress_bind_attrs) {
+		error = add_bind_files(drv);
+		if (error) {
+			/* Ditto */
+			printk(KERN_ERR "%s: add_bind_files(%s) failed\n",
+				__func__, drv->name);
+		}
 	}
 
 	kobject_uevent(&priv->kobj, KOBJ_ADD);
 	return 0;
+
 out_unregister:
 	kfree(drv->p);
 	drv->p = NULL;
@@ -720,7 +724,8 @@ void bus_remove_driver(struct device_driver *drv)
 	if (!drv->bus)
 		return;
 
-	remove_bind_files(drv);
+	if (!drv->suppress_bind_attrs)
+		remove_bind_files(drv);
 	driver_remove_attrs(drv->bus, drv);
 	driver_remove_file(drv, &driver_attr_uevent);
 	klist_remove(&drv->p->knode_bus);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ed156a1..4fa954b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -521,11 +521,15 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
 {
 	int retval, code;
 
+	/* make sure driver won't have bind/unbind attributes */
+	drv->driver.suppress_bind_attrs = true;
+
 	/* temporary section violation during probe() */
 	drv->probe = probe;
 	retval = code = platform_driver_register(drv);
 
-	/* Fixup that section violation, being paranoid about code scanning
+	/*
+	 * Fixup that section violation, being paranoid about code scanning
 	 * the list of drivers in order to probe new devices.  Check to see
 	 * if the probe was successful, and make sure any forced probes of
 	 * new devices fail.
diff --git a/include/linux/device.h b/include/linux/device.h
index aca31bf..2ea3e49 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -124,7 +124,9 @@ struct device_driver {
 	struct bus_type		*bus;
 
 	struct module		*owner;
-	const char 		*mod_name;	/* used for built-in modules */
+	const char		*mod_name;	/* used for built-in modules */
+
+	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
 
 	int (*probe) (struct device *dev);
 	int (*remove) (struct device *dev);
-- 
1.6.4.2

