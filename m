Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbZJHSE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbZJHSE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759123AbZJHSE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:04:56 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52428 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752245AbZJHSEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:04:55 -0400
Date: Thu, 8 Oct 2009 13:57:53 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Tejun Heo <tj@kernel.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [Patchs vs. percpu-next] Use this_cpu_xx to dynamically allocate
 counters
In-Reply-To: <200910062034.40864.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0910081355530.7735@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091002093453.GA21427@elte.hu> <alpine.DEB.1.10.0910021311440.26189@gentwo.org> <200910062034.40864.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Rusty Russell wrote:

> Does this mean we can kill local.h soon?

Can we remove local.h from modules?



Subject: Module handling: Use this_cpu_xx to dynamically allocate counters

Use cpu ops to deal with the per cpu data instead of a local_t. Reduces memory
requirements, cache footprint and decreases cycle counts.

The this_cpu_xx operations are also used for !SMP mode. Otherwise we could
not drop the use of __module_ref_addr() which would make per cpu data handling
complicated. this_cpu_xx operations have their own fallback for !SMP.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/module.h     |   36 ++++++++++++------------------------
 kernel/module.c            |   30 ++++++++++++++++--------------
 kernel/trace/ring_buffer.c |    1 +
 3 files changed, 29 insertions(+), 38 deletions(-)

Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h	2009-10-08 11:36:05.000000000 -0500
+++ linux-2.6/include/linux/module.h	2009-10-08 11:40:57.000000000 -0500
@@ -16,8 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/tracepoint.h>
-
-#include <asm/local.h>
+#include <linux/percpu.h>
 #include <asm/module.h>

 #include <trace/events/module.h>
@@ -361,11 +360,9 @@ struct module
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
@@ -452,25 +449,16 @@ void __symbol_put(const char *symbol);
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

@@ -479,15 +467,15 @@ static inline int try_module_get(struct
 	int ret = 1;

 	if (module) {
-		unsigned int cpu = get_cpu();
 		if (likely(module_is_live(module))) {
-			local_inc(__module_ref_addr(module, cpu));
+			preempt_disable();
+			__this_cpu_inc(module->refptr->count);
 			trace_module_get(module, _THIS_IP_,
-				local_read(__module_ref_addr(module, cpu)));
+				__this_cpu_read(module->refptr->count));
+			preempt_enable();
 		}
 		else
 			ret = 0;
-		put_cpu();
 	}
 	return ret;
 }
Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2009-10-08 11:36:05.000000000 -0500
+++ linux-2.6/kernel/module.c	2009-10-08 11:42:05.000000000 -0500
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
@@ -555,6 +556,7 @@ static void module_unload_free(struct mo
 				kfree(use);
 				sysfs_remove_link(i->holders_dir, mod->name);
 				/* There can be at most one match. */
+				free_percpu(i->refptr);
 				break;
 			}
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
@@ -1377,9 +1380,9 @@ static void free_module(struct module *m
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
@@ -2145,9 +2148,8 @@ static noinline struct module *load_modu
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
@@ -2373,8 +2375,8 @@ static noinline struct module *load_modu
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
Index: linux-2.6/kernel/trace/ring_buffer.c
===================================================================
--- linux-2.6.orig/kernel/trace/ring_buffer.c	2009-10-08 12:46:29.000000000 -0500
+++ linux-2.6/kernel/trace/ring_buffer.c	2009-10-08 12:46:46.000000000 -0500
@@ -12,6 +12,7 @@
 #include <linux/hardirq.h>
 #include <linux/kmemcheck.h>
 #include <linux/module.h>
+#include <asm/local.h>
 #include <linux/percpu.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
