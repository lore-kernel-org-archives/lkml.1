Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXDPRei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXDPRei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 13:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXDPReh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:34:37 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:17378 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbXDPRdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:33:54 -0400
Date: Mon, 16 Apr 2007 19:36:24 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [Patch -mm 2/3] RFC: Expose module->mkobj reference count.
Message-ID: <20070416193624.6f7a8e44@gondolin.boeblingen.de.ibm.com>
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

Expose module->mkobj.kobj refcounting to drivers. Wait with deleting
the module until the refcount has dropped to 0.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 include/linux/module.h |    4 ++++
 kernel/module.c        |   30 +++++++++++++++++++++++++++++-
 kernel/params.c        |    8 ++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

--- linux-2.6.orig/include/linux/module.h
+++ linux-2.6/include/linux/module.h
@@ -59,6 +59,7 @@ struct module_kobject
 	struct kobject kobj;
 	struct module *mod;
 	struct kobject *drivers_dir;
+	struct completion completion;
 };
 
 /* These are either module local, or the kernel's dummy ones. */
@@ -591,6 +592,9 @@ int mod_sysfs_init(struct module *mod);
 int mod_sysfs_setup(struct module *mod,
 			   struct kernel_param *kparam,
 			   unsigned int num_params);
+struct kobject * mod_kobject_get(struct module *);
+void mod_kobject_put(struct module *);
+
 #ifdef CONFIG_SYSFS
 int module_add_modinfo_attrs(struct module *mod);
 void module_remove_modinfo_attrs(struct module *mod);
--- linux-2.6.orig/kernel/module.c
+++ linux-2.6/kernel/module.c
@@ -1403,7 +1403,7 @@ int mod_sysfs_init(struct module *mod)
 		goto out;
 	kobj_set_kset_s(&mod->mkobj, module_subsys);
 	mod->mkobj.mod = mod;
-
+	init_completion(&mod->mkobj.completion);
 	kobject_init(&mod->mkobj.kobj);
 
 out:
@@ -1456,6 +1456,32 @@ static void mod_kobject_remove(struct mo
 	kobject_unregister(&mod->mkobj.kobj);
 }
 
+/**
+ * mod_kobject_get - get reference on a module's kobject
+ * @mod: module to work on
+ *
+ * Returns a pointer to the kobject embedded in @mod if a reference
+ * could be taken; %NULL else.
+ */
+struct kobject * mod_kobject_get(struct module *mod)
+{
+	if (!mod)
+		return NULL;
+	return kobject_get(&mod->mkobj.kobj);
+}
+EXPORT_SYMBOL_GPL(mod_kobject_get);
+
+/**
+ * mod_kobject_put - give up reference on a module's kobject
+ * @mod: module to work on
+ */
+void mod_kobject_put(struct module *mod)
+{
+	if (mod)
+		kobject_put(&mod->mkobj.kobj);
+}
+EXPORT_SYMBOL_GPL(mod_kobject_put);
+
 /*
  * unlink the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
@@ -1483,6 +1509,8 @@ static void free_module(struct module *m
 	/* Module unload stuff */
 	module_unload_free(mod);
 
+	wait_for_completion(&mod->mkobj.completion);
+
 	/* This may be NULL, but that's OK */
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
--- linux-2.6.orig/kernel/params.c
+++ linux-2.6/kernel/params.c
@@ -692,8 +692,16 @@ static struct kset_uevent_ops module_uev
 
 decl_subsys(module, &module_ktype, &module_uevent_ops);
 
+static void module_kobj_release(struct kobject *kobj)
+{
+	struct module_kobject *mkobj = container_of(kobj, struct module_kobject,
+						    kobj);
+	complete(&mkobj->completion);
+}
+
 static struct kobj_type module_ktype = {
 	.sysfs_ops =	&module_sysfs_ops,
+	.release = module_kobj_release,
 };
 
 /*
