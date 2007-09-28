Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbXI1XB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbXI1XB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbXI1XBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:01:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57745 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbXI1XBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:01:20 -0400
Subject: [RFC][PATCH] make module refcounts use percpu_counters
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 28 Sep 2007 16:00:58 -0700
Message-Id: <20070928230057.2712A579@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Module refcounts currently use a percpu counter stored
in the 'struct module'.  However, we also have a more
generic implementation that does stuff like handle
hotplug cpus.

I'm not actually all that convinced that this refcount
actually does a lot of good, with cpus racing bumping
the counters at the same time that they're being
summed up.  But, it certainly isn't any worse than
what was there before.  We also get any hotplug-cpu
compatible changes that happen to percpu_counters for
free.


Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/include/linux/module.h |   10 ++++------
 lxc-dave/kernel/module.c        |   17 ++++-------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff -puN lib/percpu_counter.c~make-module-refcounts-use-percpu_counters lib/percpu_counter.c
diff -puN include/linux/percpu_counter.h~make-module-refcounts-use-percpu_counters include/linux/percpu_counter.h
diff -puN kernel/module.c~make-module-refcounts-use-percpu_counters kernel/module.c
--- lxc/kernel/module.c~make-module-refcounts-use-percpu_counters	2007-09-28 15:48:57.000000000 -0700
+++ lxc-dave/kernel/module.c	2007-09-28 15:48:57.000000000 -0700
@@ -502,13 +502,9 @@ MODINFO_ATTR(srcversion);
 /* Init the unload section of the module. */
 static void module_unload_init(struct module *mod)
 {
-	unsigned int i;
-
 	INIT_LIST_HEAD(&mod->modules_which_use_me);
-	for (i = 0; i < NR_CPUS; i++)
-		local_set(&mod->ref[i].count, 0);
 	/* Hold reference count during initialization. */
-	local_set(&mod->ref[raw_smp_processor_id()].count, 1);
+	percpu_counter_init(&mod->ref, 1);
 	/* Backwards compatibility macros put refcount during init. */
 	mod->waiter = current;
 }
@@ -629,11 +625,7 @@ static int try_stop_module(struct module
 
 unsigned int module_refcount(struct module *mod)
 {
-	unsigned int i, total = 0;
-
-	for (i = 0; i < NR_CPUS; i++)
-		total += local_read(&mod->ref[i].count);
-	return total;
+	return percpu_counter_sum(&mod->ref);
 }
 EXPORT_SYMBOL(module_refcount);
 
@@ -720,6 +712,7 @@ sys_delete_module(const char __user *nam
 	/* Never wait if forced. */
 	if (!forced && module_refcount(mod) != 0)
 		wait_for_zero_refcount(mod);
+	percpu_counter_destroy(&mod->ref);
 
 	/* Final destruction now noone is using it. */
 	if (mod->exit != NULL) {
@@ -802,12 +795,10 @@ static struct module_attribute refcnt = 
 void module_put(struct module *module)
 {
 	if (module) {
-		unsigned int cpu = get_cpu();
-		local_dec(&module->ref[cpu].count);
+		percpu_counter_dec(&module->ref);
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
-		put_cpu();
 	}
 }
 EXPORT_SYMBOL(module_put);
diff -puN include/asm-alpha/local.h~make-module-refcounts-use-percpu_counters include/asm-alpha/local.h
diff -puN include/asm-generic/local.h~make-module-refcounts-use-percpu_counters include/asm-generic/local.h
diff -puN include/asm-i386/local.h~make-module-refcounts-use-percpu_counters include/asm-i386/local.h
diff -puN include/asm-mips/local.h~make-module-refcounts-use-percpu_counters include/asm-mips/local.h
diff -puN include/asm-powerpc/local.h~make-module-refcounts-use-percpu_counters include/asm-powerpc/local.h
diff -puN fs/file_table.c~make-module-refcounts-use-percpu_counters fs/file_table.c
diff -puN include/linux/module.h~make-module-refcounts-use-percpu_counters include/linux/module.h
--- lxc/include/linux/module.h~make-module-refcounts-use-percpu_counters	2007-09-28 15:48:57.000000000 -0700
+++ lxc-dave/include/linux/module.h	2007-09-28 15:48:57.000000000 -0700
@@ -15,6 +15,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
+#include <linux/percpu_counter.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -339,7 +340,7 @@ struct module
 
 #ifdef CONFIG_MODULE_UNLOAD
 	/* Reference counts */
-	struct module_ref ref[NR_CPUS];
+	struct percpu_counter ref;
 
 	/* What modules depend on me? */
 	struct list_head modules_which_use_me;
@@ -412,8 +413,7 @@ static inline void __module_get(struct m
 {
 	if (module) {
 		BUG_ON(module_refcount(module) == 0);
-		local_inc(&module->ref[get_cpu()].count);
-		put_cpu();
+		percpu_counter_inc(&module->ref);
 	}
 }
 
@@ -422,12 +422,10 @@ static inline int try_module_get(struct 
 	int ret = 1;
 
 	if (module) {
-		unsigned int cpu = get_cpu();
 		if (likely(module_is_live(module)))
-			local_inc(&module->ref[cpu].count);
+			percpu_counter_inc(&module->ref);
 		else
 			ret = 0;
-		put_cpu();
 	}
 	return ret;
 }
_
