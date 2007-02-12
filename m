Return-Path: <linux-kernel-owner+w=401wt.eu-S1750968AbXBLWea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968AbXBLWea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbXBLWea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:34:30 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:42171 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXBLWe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:34:29 -0500
Date: Mon, 12 Feb 2007 14:29:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm <akpm@osdl.org>
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: [PATCH] build errors: uevent with CONFIG_SYSFS=n
Message-Id: <20070212142919.5ce91086.randy.dunlap@oracle.com>
In-Reply-To: <20070212135021.27754603.randy.dunlap@oracle.com>
References: <20070212135021.27754603.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007 13:50:21 -0800 Randy Dunlap wrote:

> 
> in kernel/params.c:
> 
> kernel/params.c:700: error: 'module_uevent_ops' undeclared here (not in a function)
> 
> in kernel/module.c:
> 
> kernel/built-in.o: In function `module_add_driver':
> (.text+0x20c5b): undefined reference to `module_subsys'
> kernel/built-in.o: In function `sys_init_module':
> (.text+0x2177c): undefined reference to `module_subsys'
> kernel/built-in.o: In function `sys_init_module':
> (.text+0x21838): undefined reference to `module_subsys'
> kernel/built-in.o: In function `kernel_param_sysfs_setup':
> params.c:(.init.text+0x1492): undefined reference to `module_subsys'
> kernel/built-in.o: In function `param_sysfs_init':
> params.c:(.init.text+0x14f8): undefined reference to `module_subsys'
> 
> Are these already fixed?

Here's a patch, tested both ways (SYSFS=y, SYSFS=n).

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix source files to build with CONFIG_SYSFS=n.
module_subsys is not available.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/bus.c |    4 ++++
 kernel/module.c    |   10 ++++++++++
 kernel/params.c    |   20 ++++++++++----------
 3 files changed, 24 insertions(+), 10 deletions(-)

--- linux-2.6.20-git7.orig/kernel/params.c
+++ linux-2.6.20-git7/kernel/params.c
@@ -30,8 +30,6 @@
 #define DEBUGP(fmt, a...)
 #endif
 
-static struct kobj_type module_ktype;
-
 static inline char dash2underscore(char c)
 {
 	if (c == '-')
@@ -673,6 +671,8 @@ static struct sysfs_ops module_sysfs_ops
 	.store = module_attr_store,
 };
 
+static struct kobj_type module_ktype;
+
 static int uevent_filter(struct kset *kset, struct kobject *kobj)
 {
 	struct kobj_type *ktype = get_ktype(kobj);
@@ -686,19 +686,12 @@ static struct kset_uevent_ops module_uev
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
@@ -719,6 +712,13 @@ static int __init param_sysfs_init(void)
 }
 subsys_initcall(param_sysfs_init);
 
+#else
+static struct sysfs_ops module_sysfs_ops = {
+	.show = NULL,
+	.store = NULL,
+};
+#endif
+
 EXPORT_SYMBOL(param_set_byte);
 EXPORT_SYMBOL(param_get_byte);
 EXPORT_SYMBOL(param_set_short);
--- linux-2.6.20-git7.orig/kernel/module.c
+++ linux-2.6.20-git7/kernel/module.c
@@ -1110,6 +1110,7 @@ static void module_remove_modinfo_attrs(
 	kfree(mod->modinfo_attrs);
 }
 
+#ifdef CONFIG_SYSFS
 static int mod_sysfs_init(struct module *mod)
 {
 	int err;
@@ -1148,6 +1149,7 @@ static int mod_sysfs_setup(struct module
 	if (!mod->holders_dir)
 		goto out_unreg;
 
+#ifdef CONFIG_SYSFS
 	err = module_param_sysfs_setup(mod, kparam, num_params);
 	if (err)
 		goto out_unreg_holders;
@@ -1155,6 +1157,7 @@ static int mod_sysfs_setup(struct module
 	err = module_add_modinfo_attrs(mod);
 	if (err)
 		goto out_unreg_param;
+#endif
 
 	kobject_uevent(&mod->mkobj.kobj, KOBJ_ADD);
 	return 0;
@@ -1169,6 +1172,7 @@ out_unreg:
 out:
 	return err;
 }
+#endif
 
 static void mod_kobject_remove(struct module *mod)
 {
@@ -1782,9 +1786,11 @@ static struct module *load_module(void _
 	/* Now we've moved module, initialize linked lists, etc. */
 	module_unload_init(mod);
 
+#ifdef CONFIG_SYSFS
 	/* Initialize kobject, so we can reference it. */
 	if (mod_sysfs_init(mod) != 0)
 		goto cleanup;
+#endif
 
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
@@ -1917,6 +1923,7 @@ static struct module *load_module(void _
 	if (err < 0)
 		goto arch_cleanup;
 
+#ifdef CONFIG_SYSFS
 	err = mod_sysfs_setup(mod, 
 			      (struct kernel_param *)
 			      sechdrs[setupindex].sh_addr,
@@ -1924,6 +1931,7 @@ static struct module *load_module(void _
 			      / sizeof(struct kernel_param));
 	if (err < 0)
 		goto arch_cleanup;
+#endif
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
 	/* Size of section 0 is 0, so this works well if no unwind info. */
@@ -2366,6 +2374,7 @@ static void module_create_drivers_dir(st
 	mk->drivers_dir = kobject_add_dir(&mk->kobj, "drivers");
 }
 
+#ifdef CONFIG_SYSFS
 void module_add_driver(struct module *mod, struct device_driver *drv)
 {
 	char *driver_name;
@@ -2419,6 +2428,7 @@ void module_remove_driver(struct device_
 	}
 }
 EXPORT_SYMBOL(module_remove_driver);
+#endif
 
 #ifdef CONFIG_MODVERSIONS
 /* Generate the signature for struct module here, too, for modversions. */
--- linux-2.6.20-git7.orig/drivers/base/bus.c
+++ linux-2.6.20-git7/drivers/base/bus.c
@@ -547,7 +547,9 @@ int bus_add_driver(struct device_driver 
 	if (error)
 		goto out_unregister;
 	klist_add_tail(&drv->knode_bus, &bus->klist_drivers);
+#ifdef CONFIG_SYSFS
 	module_add_driver(drv->owner, drv);
+#endif
 
 	error = driver_add_attrs(bus, drv);
 	if (error) {
@@ -589,7 +591,9 @@ void bus_remove_driver(struct device_dri
 	klist_remove(&drv->knode_bus);
 	pr_debug("bus %s: remove driver %s\n", drv->bus->name, drv->name);
 	driver_detach(drv);
+#ifdef CONFIG_SYSFS
 	module_remove_driver(drv);
+#endif
 	kobject_unregister(&drv->kobj);
 	put_bus(drv->bus);
 }
