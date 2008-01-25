Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbYAYHjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbYAYHjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbYAYHSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598AbYAYHSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 069/196] kset: convert /sys/module to use kset_create
Date: Thu, 24 Jan 2008 23:10:07 -0800
Message-Id: <1201245134-4876-69-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.  We also
rename module_subsys to module_kset to catch all users of the variable.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/module.h |    4 +++-
 kernel/module.c        |    7 +++----
 kernel/params.c        |   29 +++++++++--------------------
 3 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 2cbc0b8..fbe930b 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -574,7 +574,9 @@ struct device_driver;
 #ifdef CONFIG_SYSFS
 struct module;
 
-extern struct kset module_subsys;
+extern struct kset *module_kset;
+extern struct kobj_type module_ktype;
+extern int module_sysfs_initialized;
 
 int mod_sysfs_init(struct module *mod);
 int mod_sysfs_setup(struct module *mod,
diff --git a/kernel/module.c b/kernel/module.c
index 5514277..d03fcd9 100644
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
@@ -1223,7 +1221,8 @@ int mod_sysfs_init(struct module *mod)
 	err = kobject_set_name(&mod->mkobj.kobj, "%s", mod->name);
 	if (err)
 		goto out;
-	mod->mkobj.kobj.kset = &module_subsys;
+	mod->mkobj.kobj.kset = module_kset;
+	mod->mkobj.kobj.ktype = &module_ktype;
 	mod->mkobj.mod = mod;
 
 	kobject_init(&mod->mkobj.kobj);
@@ -2539,7 +2538,7 @@ void module_add_driver(struct module *mod, struct device_driver *drv)
 		struct kobject *mkobj;
 
 		/* Lookup built-in module entry in /sys/modules */
-		mkobj = kset_find_obj(&module_subsys, drv->mod_name);
+		mkobj = kset_find_obj(module_kset, drv->mod_name);
 		if (mkobj) {
 			mk = container_of(mkobj, struct module_kobject, kobj);
 			/* remember our module structure */
diff --git a/kernel/params.c b/kernel/params.c
index 9f05182..97e0923 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -30,8 +30,6 @@
 #define DEBUGP(fmt, a...)
 #endif
 
-static struct kobj_type module_ktype;
-
 static inline char dash2underscore(char c)
 {
 	if (c == '-')
@@ -562,7 +560,7 @@ static void __init kernel_param_sysfs_setup(const char *name,
 	BUG_ON(!mk);
 
 	mk->mod = THIS_MODULE;
-	mk->kobj.kset = &module_subsys;
+	mk->kobj.kset = module_kset;
 	mk->kobj.ktype = &module_ktype;
 	kobject_set_name(&mk->kobj, name);
 	kobject_init(&mk->kobj);
@@ -695,7 +693,7 @@ static struct kset_uevent_ops module_uevent_ops = {
 	.filter = uevent_filter,
 };
 
-decl_subsys(module, &module_uevent_ops);
+struct kset *module_kset;
 int module_sysfs_initialized;
 
 static void module_release(struct kobject *kobj)
@@ -707,7 +705,7 @@ static void module_release(struct kobject *kobj)
 	 */
 }
 
-static struct kobj_type module_ktype = {
+struct kobj_type module_ktype = {
 	.sysfs_ops =	&module_sysfs_ops,
 	.release =	module_release,
 };
@@ -717,13 +715,11 @@ static struct kobj_type module_ktype = {
  */
 static int __init param_sysfs_init(void)
 {
-	int ret;
-
-	ret = subsystem_register(&module_subsys);
-	if (ret < 0) {
-		printk(KERN_WARNING "%s (%d): subsystem_register error: %d\n",
-			__FILE__, __LINE__, ret);
-		return ret;
+	module_kset = kset_create_and_add("module", &module_uevent_ops, NULL);
+	if (!module_kset) {
+		printk(KERN_WARNING "%s (%d): error creating kset\n",
+			__FILE__, __LINE__);
+		return -ENOMEM;
 	}
 	module_sysfs_initialized = 1;
 
@@ -733,14 +729,7 @@ static int __init param_sysfs_init(void)
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
1.5.3.8

