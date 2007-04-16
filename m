Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbXDPRdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbXDPRdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 13:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXDPRdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:33:53 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:45406 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbXDPRdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:33:52 -0400
Date: Mon, 16 Apr 2007 19:36:22 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [Patch -mm 1/3] RFC: Use module->mkobj even if !CONFIG_SYSFS.
Message-ID: <20070416193622.2df5d6fd@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make module->mkobj.kobj useful for refcounting, even if sysfs is
not used.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 include/linux/module.h |   14 +-------------
 kernel/module.c        |    2 --
 kernel/params.c        |   14 +++++---------
 3 files changed, 6 insertions(+), 24 deletions(-)

--- linux-2.6.orig/include/linux/module.h
+++ linux-2.6/include/linux/module.h
@@ -583,7 +583,6 @@ static inline void print_modules(void)
 #endif /* CONFIG_MODULES */
 
 struct device_driver;
-#ifdef CONFIG_SYSFS
 struct module;
 
 extern struct subsystem module_subsys;
@@ -592,23 +591,12 @@ int mod_sysfs_init(struct module *mod);
 int mod_sysfs_setup(struct module *mod,
 			   struct kernel_param *kparam,
 			   unsigned int num_params);
+#ifdef CONFIG_SYSFS
 int module_add_modinfo_attrs(struct module *mod);
 void module_remove_modinfo_attrs(struct module *mod);
 
 #else /* !CONFIG_SYSFS */
 
-static inline int mod_sysfs_init(struct module *mod)
-{
-	return 0;
-}
-
-static inline int mod_sysfs_setup(struct module *mod,
-			   struct kernel_param *kparam,
-			   unsigned int num_params)
-{
-	return 0;
-}
-
 static inline int module_add_modinfo_attrs(struct module *mod)
 {
 	return 0;
--- linux-2.6.orig/kernel/module.c
+++ linux-2.6/kernel/module.c
@@ -1387,7 +1387,6 @@ void module_remove_modinfo_attrs(struct 
 }
 #endif
 
-#ifdef CONFIG_SYSFS
 int mod_sysfs_init(struct module *mod)
 {
 	int err;
@@ -1447,7 +1446,6 @@ out_unreg:
 out:
 	return err;
 }
-#endif
 
 static void mod_kobject_remove(struct module *mod)
 {
--- linux-2.6.orig/kernel/params.c
+++ linux-2.6/kernel/params.c
@@ -621,7 +621,11 @@ static void __init param_sysfs_builtin(v
 		kernel_param_sysfs_setup(modname, kp_begin, count,
 					 strlen(modname)+1);
 }
-
+#else
+static void __init param_sysfs_builtin(void)
+{
+}
+#endif
 
 /* module-related sysfs stuff */
 
@@ -712,14 +716,6 @@ static int __init param_sysfs_init(void)
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
 
 EXPORT_SYMBOL(param_set_byte);
 EXPORT_SYMBOL(param_get_byte);
