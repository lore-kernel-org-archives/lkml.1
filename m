Return-Path: <linux-kernel-owner+w=401wt.eu-S1161502AbXBHAkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161502AbXBHAkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161503AbXBHAjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:39:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422855AbXBHAb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:31:58 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/28] MODULES: add the module name for built in kernel drivers
Date: Wed,  7 Feb 2007 16:29:55 -0800
Message-Id: <11708946432920-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946391465-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    1 +
 include/linux/module.h |    2 +-
 kernel/module.c        |   33 ++++++++++++++++++++++++---------
 kernel/params.c        |   12 +++++-------
 4 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index f44247f..da72219 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -126,6 +126,7 @@ struct device_driver {
 	struct klist_node	knode_bus;
 
 	struct module		* owner;
+	const char 		* mod_name;	/* used for built-in modules */
 
 	int	(*probe)	(struct device * dev);
 	int	(*remove)	(struct device * dev);
diff --git a/include/linux/module.h b/include/linux/module.h
index 10f771a..90dc254 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -58,6 +58,7 @@ struct module_kobject
 {
 	struct kobject kobj;
 	struct module *mod;
+	struct kobject *drivers_dir;
 };
 
 /* These are either module local, or the kernel's dummy ones. */
@@ -263,7 +264,6 @@ struct module
 	struct module_attribute *modinfo_attrs;
 	const char *version;
 	const char *srcversion;
-	struct kobject *drivers_dir;
 
 	/* Exported symbols */
 	const struct kernel_symbol *syms;
diff --git a/kernel/module.c b/kernel/module.c
index d0f2260..0f4489a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1131,8 +1131,8 @@ static int mod_sysfs_setup(struct module *mod,
 	if (err)
 		goto out;
 
-	mod->drivers_dir = kobject_add_dir(&mod->mkobj.kobj, "drivers");
-	if (!mod->drivers_dir) {
+	mod->mkobj.drivers_dir = kobject_add_dir(&mod->mkobj.kobj, "drivers");
+	if (!mod->mkobj.drivers_dir) {
 		err = -ENOMEM;
 		goto out_unreg;
 	}
@@ -1151,7 +1151,7 @@ static int mod_sysfs_setup(struct module *mod,
 out_unreg_param:
 	module_param_sysfs_remove(mod);
 out_unreg_drivers:
-	kobject_unregister(mod->drivers_dir);
+	kobject_unregister(mod->mkobj.drivers_dir);
 out_unreg:
 	kobject_del(&mod->mkobj.kobj);
 	kobject_put(&mod->mkobj.kobj);
@@ -1163,7 +1163,7 @@ static void mod_kobject_remove(struct module *mod)
 {
 	module_remove_modinfo_attrs(mod);
 	module_param_sysfs_remove(mod);
-	kobject_unregister(mod->drivers_dir);
+	kobject_unregister(mod->mkobj.drivers_dir);
 
 	kobject_unregister(&mod->mkobj.kobj);
 }
@@ -2344,15 +2344,30 @@ void module_add_driver(struct module *mod, struct device_driver *drv)
 {
 	char *driver_name;
 	int no_warn;
+	struct module_kobject *mk = NULL;
 
-	if (!mod || !drv)
+	if (!drv)
+		return;
+
+	if (mod)
+		mk = &mod->mkobj;
+	else if (drv->mod_name) {
+		struct kobject *mkobj;
+
+		/* Lookup built-in module entry in /sys/modules */
+		mkobj = kset_find_obj(&module_subsys.kset, drv->mod_name);
+		if (mkobj)
+			mk = container_of(mkobj, struct module_kobject, kobj);
+	}
+
+	if (!mk)
 		return;
 
 	/* Don't check return codes; these calls are idempotent */
-	no_warn = sysfs_create_link(&drv->kobj, &mod->mkobj.kobj, "module");
+	no_warn = sysfs_create_link(&drv->kobj, &mk->kobj, "module");
 	driver_name = make_driver_name(drv);
 	if (driver_name) {
-		no_warn = sysfs_create_link(mod->drivers_dir, &drv->kobj,
+		no_warn = sysfs_create_link(mk->drivers_dir, &drv->kobj,
 					    driver_name);
 		kfree(driver_name);
 	}
@@ -2367,10 +2382,10 @@ void module_remove_driver(struct device_driver *drv)
 		return;
 
 	sysfs_remove_link(&drv->kobj, "module");
-	if (drv->owner && drv->owner->drivers_dir) {
+	if (drv->owner && drv->owner->mkobj.drivers_dir) {
 		driver_name = make_driver_name(drv);
 		if (driver_name) {
-			sysfs_remove_link(drv->owner->drivers_dir,
+			sysfs_remove_link(drv->owner->mkobj.drivers_dir,
 					  driver_name);
 			kfree(driver_name);
 		}
diff --git a/kernel/params.c b/kernel/params.c
index 718945d..737b7c5 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -561,14 +561,12 @@ static void __init kernel_param_sysfs_setup(const char *name,
 	mk->mod = THIS_MODULE;
 	kobj_set_kset_s(mk, module_subsys);
 	kobject_set_name(&mk->kobj, name);
-	ret = kobject_register(&mk->kobj);
+	kobject_init(&mk->kobj);
+	ret = kobject_add(&mk->kobj);
 	BUG_ON(ret < 0);
-
-	/* no need to keep the kobject if no parameter is exported */
-	if (!param_sysfs_setup(mk, kparam, num_params, name_skip)) {
-		kobject_unregister(&mk->kobj);
-		kfree(mk);
-	}
+	param_sysfs_setup(mk, kparam, num_params, name_skip);
+	mk->drivers_dir = kobject_add_dir(&mk->kobj, "drivers");
+	kobject_uevent(&mk->kobj, KOBJ_ADD);
 }
 
 /*
-- 
1.4.4.4

