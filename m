Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047Ab0ADWhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0ADWhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612Ab0ADWhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:37:12 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46095 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0ADWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:37:04 -0500
Message-Id: <20100104223555.030169676@quilx.com>
References: <20100104223439.228028923@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jan 2010 16:34:41 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V9 2/7] Module handling: Use this_cpu_xx to dynamically allocate counters
Content-Disposition: inline; filename=percpu_local_t_remove_modules
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu ops to deal with the per cpu data instead of a local_t. Reduces memory
requirements, cache footprint and decreases cycle counts.

The this_cpu_xx operations are also used for !SMP mode. Otherwise we could
not drop the use of __module_ref_addr() which would make per cpu data handling
complicated. this_cpu_xx operations have their own fallback for !SMP.

V8-V9:
- Leave include asm/module.h since ringbuffer.c depends on it. Nothing else
  does though. Another patch will deal with that.
- Remove spurious free.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/module.h |   36 ++++++++++++++----------------------
 kernel/module.c        |   30 ++++++++++++++++--------------
 2 files changed, 30 insertions(+), 36 deletions(-)

Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h	2010-01-04 14:46:25.000000000 -0600
+++ linux-2.6/include/linux/module.h	2010-01-04 14:47:49.000000000 -0600
@@ -18,6 +18,7 @@
 #include <linux/tracepoint.h>
 
 #include <asm/local.h>
+#include <linux/percpu.h>
 #include <asm/module.h>
 
 #include <trace/events/module.h>
@@ -363,11 +364,9 @@ struct module
 	/* Destruction function. */
 	void (*exit)(void);
 
-#ifdef CONFIG_SMP
-	char *refptr;
-#else
-	local_t ref;
-#endif
+	struct module_ref {
+		int count;
+	} *refptr;
 #endif
 
 #ifdef CONFIG_CONSTRUCTORS
@@ -454,25 +453,16 @@ void __symbol_put(const char *symbol);
 #define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x)
 void symbol_put_addr(void *addr);
 
-static inline local_t *__module_ref_addr(struct module *mod, int cpu)
-{
-#ifdef CONFIG_SMP
-	return (local_t *) (mod->refptr + per_cpu_offset(cpu));
-#else
-	return &mod->ref;
-#endif
-}
-
 /* Sometimes we know we already have a refcount, and it's easier not
    to handle the error case (which only happens with rmmod --wait). */
 static inline void __module_get(struct module *module)
 {
 	if (module) {
-		unsigned int cpu = get_cpu();
-		local_inc(__module_ref_addr(module, cpu));
+		preempt_disable();
+		__this_cpu_inc(module->refptr->count);
 		trace_module_get(module, _THIS_IP_,
-				 local_read(__module_ref_addr(module, cpu)));
-		put_cpu();
+				 __this_cpu_read(module->refptr->count));
+		preempt_enable();
 	}
 }
 
@@ -481,15 +471,17 @@ static inline int try_module_get(struct 
 	int ret = 1;
 
 	if (module) {
-		unsigned int cpu = get_cpu();
+		preempt_disable();
+
 		if (likely(module_is_live(module))) {
-			local_inc(__module_ref_addr(module, cpu));
+			__this_cpu_inc(module->refptr->count);
 			trace_module_get(module, _THIS_IP_,
-				local_read(__module_ref_addr(module, cpu)));
+				__this_cpu_read(module->refptr->count));
 		}
 		else
 			ret = 0;
-		put_cpu();
+
+		preempt_enable();
 	}
 	return ret;
 }
Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2010-01-04 14:46:25.000000000 -0600
+++ linux-2.6/kernel/module.c	2010-01-04 14:47:07.000000000 -0600
@@ -474,9 +474,10 @@ static void module_unload_init(struct mo
 
 	INIT_LIST_HEAD(&mod->modules_which_use_me);
 	for_each_possible_cpu(cpu)
-		local_set(__module_ref_addr(mod, cpu), 0);
+		per_cpu_ptr(mod->refptr, cpu)->count = 0;
+
 	/* Hold reference count during initialization. */
-	local_set(__module_ref_addr(mod, raw_smp_processor_id()), 1);
+	__this_cpu_write(mod->refptr->count, 1);
 	/* Backwards compatibility macros put refcount during init. */
 	mod->waiter = current;
 }
@@ -619,7 +621,7 @@ unsigned int module_refcount(struct modu
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		total += local_read(__module_ref_addr(mod, cpu));
+		total += per_cpu_ptr(mod->refptr, cpu)->count;
 	return total;
 }
 EXPORT_SYMBOL(module_refcount);
@@ -796,14 +798,15 @@ static struct module_attribute refcnt = 
 void module_put(struct module *module)
 {
 	if (module) {
-		unsigned int cpu = get_cpu();
-		local_dec(__module_ref_addr(module, cpu));
+		preempt_disable();
+		__this_cpu_dec(module->refptr->count);
+
 		trace_module_put(module, _RET_IP_,
-				 local_read(__module_ref_addr(module, cpu)));
+				 __this_cpu_read(module->refptr->count));
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
-		put_cpu();
+		preempt_enable();
 	}
 }
 EXPORT_SYMBOL(module_put);
@@ -1394,9 +1397,9 @@ static void free_module(struct module *m
 	kfree(mod->args);
 	if (mod->percpu)
 		percpu_modfree(mod->percpu);
-#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+#if defined(CONFIG_MODULE_UNLOAD)
 	if (mod->refptr)
-		percpu_modfree(mod->refptr);
+		free_percpu(mod->refptr);
 #endif
 	/* Free lock-classes: */
 	lockdep_free_key_range(mod->module_core, mod->core_size);
@@ -2159,9 +2162,8 @@ static noinline struct module *load_modu
 	mod = (void *)sechdrs[modindex].sh_addr;
 	kmemleak_load_module(mod, hdr, sechdrs, secstrings);
 
-#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
-	mod->refptr = percpu_modalloc(sizeof(local_t), __alignof__(local_t),
-				      mod->name);
+#if defined(CONFIG_MODULE_UNLOAD)
+	mod->refptr = alloc_percpu(struct module_ref);
 	if (!mod->refptr) {
 		err = -ENOMEM;
 		goto free_init;
@@ -2393,8 +2395,8 @@ static noinline struct module *load_modu
 	kobject_put(&mod->mkobj.kobj);
  free_unload:
 	module_unload_free(mod);
-#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
-	percpu_modfree(mod->refptr);
+#if defined(CONFIG_MODULE_UNLOAD)
+	free_percpu(mod->refptr);
  free_init:
 #endif
 	module_free(mod, mod->module_init);

-- 
