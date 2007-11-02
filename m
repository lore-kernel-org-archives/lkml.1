Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbXKCAIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbXKCAIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762058AbXKCABq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:34859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762051AbXKCABp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 25/54] kset: convert /sys/module to use kset_create
Date: Fri,  2 Nov 2007 16:59:03 -0700
Message-Id: <1194047972-9850-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.  We also
rename module_subsys to module_kset to catch all users of the variable.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/module.h |    3 ++-
 kernel/module.c        |    6 ++----
 kernel/params.c        |   21 ++++++++-------------
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 2cbc0b8..aa9f254 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -574,7 +574,8 @@ struct device_driver;
 #ifdef CONFIG_SYSFS
 struct module;
 
-extern struct kset module_subsys;
+extern struct kset *module_kset;
+extern int module_sysfs_initialized;
 
 int mod_sysfs_init(struct module *mod);
 int mod_sysfs_setup(struct module *mod,
diff --git a/kernel/module.c b/kernel/module.c
index 8240939..0aa8f6b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -47,8 +47,6 @@
 #include <asm/cacheflush.h>
 #include <linux/license.h>
 
-extern int module_sysfs_initialized;
-
 #if 0
 #define DEBUGP printk
 #else
@@ -1221,7 +1219,7 @@ int mod_sysfs_init(struct module *mod)
 	err = kobject_set_name(&mod->mkobj.kobj, "%s", mod->name);
 	if (err)
 		goto out;
-	mod->mkobj.kobj.kset = &module_subsys;
+	mod->mkobj.kobj.kset = module_kset;
 	mod->mkobj.mod = mod;
 
 	kobject_init(&mod->mkobj.kobj);
@@ -2530,7 +2528,7 @@ void module_add_driver(struct module *mod, struct device_driver *drv)
 		struct kobject *mkobj;
 
 		/* Lookup built-in module entry in /sys/modules */
-		mkobj = kset_find_obj(&module_subsys, drv->mod_name);
+		mkobj = kset_find_obj(module_kset, drv->mod_name);
 		if (mkobj) {
 			mk = container_of(mkobj, struct module_kobject, kobj);
 			/* remember our module structure */
diff --git a/kernel/params.c b/kernel/params.c
index d4304b3..1a3a8d7 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -562,7 +562,7 @@ static void __init kernel_param_sysfs_setup(const char *name,
 	BUG_ON(!mk);
 
 	mk->mod = THIS_MODULE;
-	mk->kobj.kset = &module_subsys;
+	mk->kobj.kset = module_kset;
 	mk->kobj.ktype = &module_ktype;
 	kobject_set_name(&mk->kobj, name);
 	kobject_init(&mk->kobj);
@@ -698,7 +698,7 @@ static struct kset_uevent_ops module_uevent_ops = {
 	.filter = uevent_filter,
 };
 
-decl_subsys(module, &module_uevent_ops);
+struct kset *module_kset;
 int module_sysfs_initialized;
 
 static struct kobj_type module_ktype = {
@@ -712,9 +712,11 @@ static int __init param_sysfs_init(void)
 {
 	int ret;
 
-	ret = subsystem_register(&module_subsys);
-	if (ret < 0) {
-		printk(KERN_WARNING "%s (%d): subsystem_register error: %d\n",
+	module_kset = kset_create_and_register("module", &module_uevent_ops,
+					       NULL, NULL);
+	if (IS_ERR(module_kset)) {
+		ret = PTR_ERR(module_kset);
+		printk(KERN_WARNING "%s (%d): error creating kset: %d\n",
 			__FILE__, __LINE__, ret);
 		return ret;
 	}
@@ -726,14 +728,7 @@ static int __init param_sysfs_init(void)
 }
 subsys_initcall(param_sysfs_init);
 
-#else
-#if 0
-static struct sysfs_ops module_sysfs_ops = {
-	.show = NULL,
-	.store = NULL,
-};
-#endif
-#endif
+#endif /* CONFIG_SYSFS */
 
 EXPORT_SYMBOL(param_set_byte);
 EXPORT_SYMBOL(param_get_byte);
-- 
1.5.3.4

