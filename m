Return-Path: <linux-kernel-owner+w=401wt.eu-S1946300AbXBPXk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946300AbXBPXk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946305AbXBPXjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:39:31 -0500
Received: from ns2.suse.de ([195.135.220.15]:51881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946310AbXBPXj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:39:26 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/10] sysfs: fix build errors: uevent with CONFIG_SYSFS=n
Date: Fri, 16 Feb 2007 15:37:36 -0800
Message-Id: <117166908669-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0
In-Reply-To: <11716690833227-git-send-email-gregkh@suse.de>
References: <20070216233553.GC14708@kroah.com> <11716690562249-git-send-email-gregkh@suse.de> <11716690591400-git-send-email-gregkh@suse.de> <11716690633694-git-send-email-gregkh@suse.de> <11716690662679-git-send-email-gregkh@suse.de> <11716690692008-git-send-email-gregkh@suse.de> <1171669073246-git-send-email-gregkh@suse.de> <1171669076436-git-send-email-gregkh@suse.de> <11716690802025-git-send-email-gregkh@suse.de> <11716690833227-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix source files to build with CONFIG_SYSFS=n.
module_subsys is not available.

SYSFS=n, MODULES=y:	T:y
SYSFS=n, MODULES=n:	T:y

SYSFS=y, MODULES=y:	T:y
SYSFS=y, MODULES=n:	T:y

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/module.h      |   53 +++++++++++++++++++++++++++++++++++-------
 include/linux/moduleparam.h |   12 +++++++++
 kernel/module.c             |   14 ++++++++---
 kernel/params.c             |   28 ++++++++++++----------
 4 files changed, 81 insertions(+), 26 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 419d3ef..95679eb 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -76,8 +76,6 @@ void sort_extable(struct exception_table_entry *start,
 		  struct exception_table_entry *finish);
 void sort_main_extable(void);
 
-extern struct subsystem module_subsys;
-
 #ifdef MODULE
 #define MODULE_GENERIC_TABLE(gtype,name)			\
 extern const struct gtype##_id __mod_##gtype##_table		\
@@ -467,10 +465,6 @@ int unregister_module_notifier(struct notifier_block * nb);
 
 extern void print_modules(void);
 
-struct device_driver;
-void module_add_driver(struct module *, struct device_driver *);
-void module_remove_driver(struct device_driver *);
-
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -568,18 +562,59 @@ static inline void print_modules(void)
 {
 }
 
+#endif /* CONFIG_MODULES */
+
 struct device_driver;
+#ifdef CONFIG_SYSFS
 struct module;
 
-static inline void module_add_driver(struct module *module, struct device_driver *driver)
+extern struct subsystem module_subsys;
+
+int mod_sysfs_init(struct module *mod);
+int mod_sysfs_setup(struct module *mod,
+			   struct kernel_param *kparam,
+			   unsigned int num_params);
+int module_add_modinfo_attrs(struct module *mod);
+void module_remove_modinfo_attrs(struct module *mod);
+
+#else /* !CONFIG_SYSFS */
+
+static inline int mod_sysfs_init(struct module *mod)
 {
+	return 0;
 }
 
-static inline void module_remove_driver(struct device_driver *driver)
+static inline int mod_sysfs_setup(struct module *mod,
+			   struct kernel_param *kparam,
+			   unsigned int num_params)
 {
+	return 0;
 }
 
-#endif /* CONFIG_MODULES */
+static inline int module_add_modinfo_attrs(struct module *mod)
+{
+	return 0;
+}
+
+static inline void module_remove_modinfo_attrs(struct module *mod)
+{ }
+
+#endif /* CONFIG_SYSFS */
+
+#if defined(CONFIG_SYSFS) && defined(CONFIG_MODULES)
+
+void module_add_driver(struct module *mod, struct device_driver *drv);
+void module_remove_driver(struct device_driver *drv);
+
+#else /* not both CONFIG_SYSFS && CONFIG_MODULES */
+
+static inline void module_add_driver(struct module *mod, struct device_driver *drv)
+{ }
+
+static inline void module_remove_driver(struct device_driver *drv)
+{ }
+
+#endif
 
 #define symbol_request(x) try_then_request_module(symbol_get(x), "symbol:" #x)
 
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 4a189da..b26b2e5 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -169,10 +169,22 @@ extern int param_get_string(char *buffer, struct kernel_param *kp);
 
 struct module;
 
+#if defined(CONFIG_SYSFS) && defined(CONFIG_MODULES)
 extern int module_param_sysfs_setup(struct module *mod,
 				    struct kernel_param *kparam,
 				    unsigned int num_params);
 
 extern void module_param_sysfs_remove(struct module *mod);
+#else
+static inline int module_param_sysfs_setup(struct module *mod,
+			     struct kernel_param *kparam,
+			     unsigned int num_params)
+{
+	return 0;
+}
+
+static inline void module_param_sysfs_remove(struct module *mod)
+{ }
+#endif
 
 #endif /* _LINUX_MODULE_PARAMS_H */
diff --git a/kernel/module.c b/kernel/module.c
index e06b77a..8c25b1a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1074,7 +1074,8 @@ static inline void remove_sect_attrs(struct module *mod)
 }
 #endif /* CONFIG_KALLSYMS */
 
-static int module_add_modinfo_attrs(struct module *mod)
+#ifdef CONFIG_SYSFS
+int module_add_modinfo_attrs(struct module *mod)
 {
 	struct module_attribute *attr;
 	struct module_attribute *temp_attr;
@@ -1100,7 +1101,7 @@ static int module_add_modinfo_attrs(struct module *mod)
 	return error;
 }
 
-static void module_remove_modinfo_attrs(struct module *mod)
+void module_remove_modinfo_attrs(struct module *mod)
 {
 	struct module_attribute *attr;
 	int i;
@@ -1115,8 +1116,10 @@ static void module_remove_modinfo_attrs(struct module *mod)
 	}
 	kfree(mod->modinfo_attrs);
 }
+#endif
 
-static int mod_sysfs_init(struct module *mod)
+#ifdef CONFIG_SYSFS
+int mod_sysfs_init(struct module *mod)
 {
 	int err;
 
@@ -1139,7 +1142,7 @@ out:
 	return err;
 }
 
-static int mod_sysfs_setup(struct module *mod,
+int mod_sysfs_setup(struct module *mod,
 			   struct kernel_param *kparam,
 			   unsigned int num_params)
 {
@@ -1175,6 +1178,7 @@ out_unreg:
 out:
 	return err;
 }
+#endif
 
 static void mod_kobject_remove(struct module *mod)
 {
@@ -2348,6 +2352,7 @@ void print_modules(void)
 	printk("\n");
 }
 
+#ifdef CONFIG_SYSFS
 static char *make_driver_name(struct device_driver *drv)
 {
 	char *driver_name;
@@ -2422,6 +2427,7 @@ void module_remove_driver(struct device_driver *drv)
 	}
 }
 EXPORT_SYMBOL(module_remove_driver);
+#endif
 
 #ifdef CONFIG_MODVERSIONS
 /* Generate the signature for struct module here, too, for modversions. */
diff --git a/kernel/params.c b/kernel/params.c
index 7d231c6..7a75157 100644
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
@@ -391,6 +389,7 @@ struct module_param_attrs
 	struct param_attribute attrs[0];
 };
 
+#ifdef CONFIG_SYSFS
 #define to_param_attr(n) container_of(n, struct param_attribute, mattr);
 
 static ssize_t param_attr_show(struct module_attribute *mattr,
@@ -426,6 +425,7 @@ static ssize_t param_attr_store(struct module_attribute *mattr,
 		return len;
 	return err;
 }
+#endif
 
 #ifdef CONFIG_MODULES
 #define __modinit
@@ -433,6 +433,7 @@ static ssize_t param_attr_store(struct module_attribute *mattr,
 #define __modinit __init
 #endif
 
+#ifdef CONFIG_SYSFS
 /*
  * param_sysfs_setup - setup sysfs support for one module or KBUILD_MODNAME
  * @mk: struct module_kobject (contains parent kobject)
@@ -500,9 +501,7 @@ param_sysfs_setup(struct module_kobject *mk,
 	return mp;
 }
 
-
 #ifdef CONFIG_MODULES
-
 /*
  * module_param_sysfs_setup - setup sysfs support for one module
  * @mod: module
@@ -625,7 +624,6 @@ static void __init param_sysfs_builtin(void)
 
 
 /* module-related sysfs stuff */
-#ifdef CONFIG_SYSFS
 
 #define to_module_attr(n) container_of(n, struct module_attribute, attr);
 #define to_module_kobject(n) container_of(n, struct module_kobject, kobj);
@@ -673,6 +671,8 @@ static struct sysfs_ops module_sysfs_ops = {
 	.store = module_attr_store,
 };
 
+static struct kobj_type module_ktype;
+
 static int uevent_filter(struct kset *kset, struct kobject *kobj)
 {
 	struct kobj_type *ktype = get_ktype(kobj);
@@ -686,19 +686,12 @@ static struct kset_uevent_ops module_uevent_ops = {
 	.filter = uevent_filter,
 };
 
-#else
-static struct sysfs_ops module_sysfs_ops = {
-	.show = NULL,
-	.store = NULL,
-};
-#endif
+decl_subsys(module, &module_ktype, &module_uevent_ops);
 
 static struct kobj_type module_ktype = {
 	.sysfs_ops =	&module_sysfs_ops,
 };
 
-decl_subsys(module, &module_ktype, &module_uevent_ops);
-
 /*
  * param_sysfs_init - wrapper for built-in params support
  */
@@ -720,6 +713,15 @@ static int __init param_sysfs_init(void)
 }
 subsys_initcall(param_sysfs_init);
 
+#else
+#if 0
+static struct sysfs_ops module_sysfs_ops = {
+	.show = NULL,
+	.store = NULL,
+};
+#endif
+#endif
+
 EXPORT_SYMBOL(param_set_byte);
 EXPORT_SYMBOL(param_get_byte);
 EXPORT_SYMBOL(param_set_short);
-- 
1.5.0

