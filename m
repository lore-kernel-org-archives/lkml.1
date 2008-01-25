Return-Path: <linux-kernel-owner+w=401wt.eu-S1763190AbYAYIbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763190AbYAYIbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764123AbYAYIBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:24 -0500
Received: from ns2.suse.de ([195.135.220.15]:53734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759500AbYAYIAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:00:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 150/196] Driver core: move the driver specific module code into the driver core
Date: Thu, 24 Jan 2008 23:32:59 -0800
Message-Id: <1201246425-5058-71-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module driver specific code should belong in the driver core, not in
the kernel/ directory.  So move this code.  This is done in preparation
for some struct device_driver rework that should be confined to the
driver core code only.

This also lets us keep from exporting these functions, as no external
code should ever be calling it.

Thanks to Andrew Morton for the !CONFIG_MODULES fix.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Makefile  |    1 +
 drivers/base/base.h    |    9 +++++
 drivers/base/module.c  |   94 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/module.h |   15 --------
 kernel/module.c        |   87 --------------------------------------------
 5 files changed, 104 insertions(+), 102 deletions(-)
 create mode 100644 drivers/base/module.c

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index b39ea3f..ff26968 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 obj-$(CONFIG_SMP)	+= topology.o
+obj-$(CONFIG_MODULES)	+= module.o
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
diff --git a/drivers/base/base.h b/drivers/base/base.h
index ca6d273..0547236 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -73,3 +73,12 @@ extern char *make_class_name(const char *name, struct kobject *kobj);
 extern int devres_release_all(struct device *dev);
 
 extern struct kset *devices_kset;
+
+#ifdef CONFIG_MODULES
+extern void module_add_driver(struct module *mod, struct device_driver *drv);
+extern void module_remove_driver(struct device_driver *drv);
+#else
+static inline void module_add_driver(struct module *mod,
+				     struct device_driver *drv) { }
+static inline void module_remove_driver(struct device_driver *drv) { }
+#endif
diff --git a/drivers/base/module.c b/drivers/base/module.c
new file mode 100644
index 0000000..cad07be
--- /dev/null
+++ b/drivers/base/module.c
@@ -0,0 +1,94 @@
+/*
+ * module.c - module sysfs fun for drivers
+ *
+ * This file is released under the GPLv2
+ *
+ */
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include "base.h"
+
+static char *make_driver_name(struct device_driver *drv)
+{
+	char *driver_name;
+
+	driver_name = kmalloc(strlen(drv->name) + strlen(drv->bus->name) + 2,
+			      GFP_KERNEL);
+	if (!driver_name)
+		return NULL;
+
+	sprintf(driver_name, "%s:%s", drv->bus->name, drv->name);
+	return driver_name;
+}
+
+static void module_create_drivers_dir(struct module_kobject *mk)
+{
+	if (!mk || mk->drivers_dir)
+		return;
+
+	mk->drivers_dir = kobject_create_and_add("drivers", &mk->kobj);
+}
+
+void module_add_driver(struct module *mod, struct device_driver *drv)
+{
+	char *driver_name;
+	int no_warn;
+	struct module_kobject *mk = NULL;
+
+	if (!drv)
+		return;
+
+	if (mod)
+		mk = &mod->mkobj;
+	else if (drv->mod_name) {
+		struct kobject *mkobj;
+
+		/* Lookup built-in module entry in /sys/modules */
+		mkobj = kset_find_obj(module_kset, drv->mod_name);
+		if (mkobj) {
+			mk = container_of(mkobj, struct module_kobject, kobj);
+			/* remember our module structure */
+			drv->mkobj = mk;
+			/* kset_find_obj took a reference */
+			kobject_put(mkobj);
+		}
+	}
+
+	if (!mk)
+		return;
+
+	/* Don't check return codes; these calls are idempotent */
+	no_warn = sysfs_create_link(&drv->kobj, &mk->kobj, "module");
+	driver_name = make_driver_name(drv);
+	if (driver_name) {
+		module_create_drivers_dir(mk);
+		no_warn = sysfs_create_link(mk->drivers_dir, &drv->kobj,
+					    driver_name);
+		kfree(driver_name);
+	}
+}
+
+void module_remove_driver(struct device_driver *drv)
+{
+	struct module_kobject *mk = NULL;
+	char *driver_name;
+
+	if (!drv)
+		return;
+
+	sysfs_remove_link(&drv->kobj, "module");
+
+	if (drv->owner)
+		mk = &drv->owner->mkobj;
+	else if (drv->mkobj)
+		mk = drv->mkobj;
+	if (mk && mk->drivers_dir) {
+		driver_name = make_driver_name(drv);
+		if (driver_name) {
+			sysfs_remove_link(mk->drivers_dir, driver_name);
+			kfree(driver_name);
+		}
+	}
+}
diff --git a/include/linux/module.h b/include/linux/module.h
index fbe930b..c97bdb7 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -609,21 +609,6 @@ static inline void module_remove_modinfo_attrs(struct module *mod)
 
 #endif /* CONFIG_SYSFS */
 
-#if defined(CONFIG_SYSFS) && defined(CONFIG_MODULES)
-
-void module_add_driver(struct module *mod, struct device_driver *drv);
-void module_remove_driver(struct device_driver *drv);
-
-#else /* not both CONFIG_SYSFS && CONFIG_MODULES */
-
-static inline void module_add_driver(struct module *mod, struct device_driver *drv)
-{ }
-
-static inline void module_remove_driver(struct device_driver *drv)
-{ }
-
-#endif
-
 #define symbol_request(x) try_then_request_module(symbol_get(x), "symbol:" #x)
 
 /* BELOW HERE ALL THESE ARE OBSOLETE AND WILL VANISH */
diff --git a/kernel/module.c b/kernel/module.c
index d03fcd9..dc4d3f5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2501,93 +2501,6 @@ void print_modules(void)
 	printk("\n");
 }
 
-#ifdef CONFIG_SYSFS
-static char *make_driver_name(struct device_driver *drv)
-{
-	char *driver_name;
-
-	driver_name = kmalloc(strlen(drv->name) + strlen(drv->bus->name) + 2,
-			      GFP_KERNEL);
-	if (!driver_name)
-		return NULL;
-
-	sprintf(driver_name, "%s:%s", drv->bus->name, drv->name);
-	return driver_name;
-}
-
-static void module_create_drivers_dir(struct module_kobject *mk)
-{
-	if (!mk || mk->drivers_dir)
-		return;
-
-	mk->drivers_dir = kobject_create_and_add("drivers", &mk->kobj);
-}
-
-void module_add_driver(struct module *mod, struct device_driver *drv)
-{
-	char *driver_name;
-	int no_warn;
-	struct module_kobject *mk = NULL;
-
-	if (!drv)
-		return;
-
-	if (mod)
-		mk = &mod->mkobj;
-	else if (drv->mod_name) {
-		struct kobject *mkobj;
-
-		/* Lookup built-in module entry in /sys/modules */
-		mkobj = kset_find_obj(module_kset, drv->mod_name);
-		if (mkobj) {
-			mk = container_of(mkobj, struct module_kobject, kobj);
-			/* remember our module structure */
-			drv->mkobj = mk;
-			/* kset_find_obj took a reference */
-			kobject_put(mkobj);
-		}
-	}
-
-	if (!mk)
-		return;
-
-	/* Don't check return codes; these calls are idempotent */
-	no_warn = sysfs_create_link(&drv->kobj, &mk->kobj, "module");
-	driver_name = make_driver_name(drv);
-	if (driver_name) {
-		module_create_drivers_dir(mk);
-		no_warn = sysfs_create_link(mk->drivers_dir, &drv->kobj,
-					    driver_name);
-		kfree(driver_name);
-	}
-}
-EXPORT_SYMBOL(module_add_driver);
-
-void module_remove_driver(struct device_driver *drv)
-{
-	struct module_kobject *mk = NULL;
-	char *driver_name;
-
-	if (!drv)
-		return;
-
-	sysfs_remove_link(&drv->kobj, "module");
-
-	if (drv->owner)
-		mk = &drv->owner->mkobj;
-	else if (drv->mkobj)
-		mk = drv->mkobj;
-	if (mk && mk->drivers_dir) {
-		driver_name = make_driver_name(drv);
-		if (driver_name) {
-			sysfs_remove_link(mk->drivers_dir, driver_name);
-			kfree(driver_name);
-		}
-	}
-}
-EXPORT_SYMBOL(module_remove_driver);
-#endif
-
 #ifdef CONFIG_MODVERSIONS
 /* Generate the signature for struct module here, too, for modversions. */
 void struct_module(struct module *mod) { return; }
-- 
1.5.3.8

