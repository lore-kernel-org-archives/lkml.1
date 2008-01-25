Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbYAYHgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbYAYHgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758905AbYAYHSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:09 -0500
Received: from mail.suse.de ([195.135.220.2]:52854 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759394AbYAYHSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:07 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 063/196] kset: convert /sys/devices to use kset_create
Date: Thu, 24 Jan 2008 23:10:01 -0800
Message-Id: <1201245134-4876-63-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.  We also
rename devices_subsys to devices_kset to catch all users of the
variable.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h           |    2 +-
 drivers/base/core.c           |   16 ++++++++--------
 drivers/base/power/shutdown.c |    2 +-
 drivers/base/sys.c            |    4 +---
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 10b2fb6..7e309a4 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -44,4 +44,4 @@ extern char *make_class_name(const char *name, struct kobject *kobj);
 
 extern int devres_release_all(struct device *dev);
 
-extern struct kset devices_subsys;
+extern struct kset *devices_kset;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7762ee8..d2de2d5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -401,11 +401,8 @@ static ssize_t show_dev(struct device *dev, struct device_attribute *attr,
 static struct device_attribute devt_attr =
 	__ATTR(dev, S_IRUGO, show_dev, NULL);
 
-/*
- *	devices_subsys - structure to be registered with kobject core.
- */
-
-decl_subsys(devices, &device_uevent_ops);
+/* kset to create /sys/devices/  */
+struct kset *devices_kset;
 
 
 /**
@@ -525,7 +522,7 @@ static void klist_children_put(struct klist_node *n)
 
 void device_initialize(struct device *dev)
 {
-	dev->kobj.kset = &devices_subsys;
+	dev->kobj.kset = devices_kset;
 	dev->kobj.ktype = &device_ktype;
 	kobject_init(&dev->kobj);
 	klist_init(&dev->klist_children, klist_children_get,
@@ -563,7 +560,7 @@ static struct kobject *virtual_device_parent(struct device *dev)
 
 	if (!virtual_dir)
 		virtual_dir = kobject_create_and_add("virtual",
-						     &devices_subsys.kobj);
+						     &devices_kset->kobj);
 
 	return virtual_dir;
 }
@@ -1097,7 +1094,10 @@ struct device * device_find_child(struct device *parent, void *data,
 
 int __init devices_init(void)
 {
-	return subsystem_register(&devices_subsys);
+	devices_kset = kset_create_and_add("devices", &device_uevent_ops, NULL);
+	if (!devices_kset)
+		return -ENOMEM;
+	return 0;
 }
 
 EXPORT_SYMBOL_GPL(device_for_each_child);
diff --git a/drivers/base/power/shutdown.c b/drivers/base/power/shutdown.c
index 56e8eaa..f51cbc1 100644
--- a/drivers/base/power/shutdown.c
+++ b/drivers/base/power/shutdown.c
@@ -34,7 +34,7 @@ void device_shutdown(void)
 {
 	struct device * dev, *devn;
 
-	list_for_each_entry_safe_reverse(dev, devn, &devices_subsys.list,
+	list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
 				kobj.entry) {
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 7cf19fc..7693c95 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -25,8 +25,6 @@
 
 #include "base.h"
 
-extern struct kset devices_subsys;
-
 #define to_sysdev(k) container_of(k, struct sys_device, kobj)
 #define to_sysdev_attr(a) container_of(a, struct sysdev_attribute, attr)
 
@@ -459,7 +457,7 @@ int sysdev_resume(void)
 
 int __init system_bus_init(void)
 {
-	system_subsys.kobj.parent = &devices_subsys.kobj;
+	system_subsys.kobj.parent = &devices_kset->kobj;
 	return subsystem_register(&system_subsys);
 }
 
-- 
1.5.3.8

