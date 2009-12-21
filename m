Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZLUH5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZLUH5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZLUH5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:57:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:33576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbZLUH5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:57:05 -0500
Message-ID: <4B2F2AE8.7060507@kernel.org>
Date: Mon, 21 Dec 2009 16:59:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [this_cpu_xx V8 07/16] Module handling: Use this_cpu_xx to dynamically
 allocate counters
References: <20091218222617.384355422@quilx.com> <20091218222651.319887863@quilx.com> <4B2F2820.5030904@kernel.org>
In-Reply-To: <4B2F2820.5030904@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the version I committed to percpu branch.

Thanks.

>From 8af47ddd01364ae3c663c0bc92415c06fe887ba1 Mon Sep 17 00:00:00 2001
From: Christoph Lameter <cl@linux-foundation.org>
Date: Fri, 18 Dec 2009 16:26:24 -0600
Subject: [PATCH] module: Use this_cpu_xx to dynamically allocate counters

Use cpu ops to deal with the per cpu data instead of a local_t. Reduces memory
requirements, cache footprint and decreases cycle counts.

The this_cpu_xx operations are also used for !SMP mode. Otherwise we could
not drop the use of __module_ref_addr() which would make per cpu data handling
complicated. this_cpu_xx operations have their own fallback for !SMP.

The last hold out of users of local_t is the tracing ringbuffer after this patch
has been applied.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/module.h |   38 ++++++++++++++------------------------
 kernel/module.c        |   30 ++++++++++++++++--------------
 2 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 482efc8..9350577 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
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
 
@@ -479,15 +467,17 @@ static inline int try_module_get(struct module *module)
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
diff --git a/kernel/module.c b/kernel/module.c
index 64787cd..9bc04de 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -474,9 +474,10 @@ static void module_unload_init(struct module *mod)
 
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
@@ -555,6 +556,7 @@ static void module_unload_free(struct module *mod)
 				kfree(use);
 				sysfs_remove_link(i->holders_dir, mod->name);
 				/* There can be at most one match. */
+				free_percpu(i->refptr);
 				break;
 			}
 		}
@@ -619,7 +621,7 @@ unsigned int module_refcount(struct module *mod)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		total += local_read(__module_ref_addr(mod, cpu));
+		total += per_cpu_ptr(mod->refptr, cpu)->count;
 	return total;
 }
 EXPORT_SYMBOL(module_refcount);
@@ -796,14 +798,15 @@ static struct module_attribute refcnt = {
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
@@ -1377,9 +1380,9 @@ static void free_module(struct module *mod)
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
@@ -2145,9 +2148,8 @@ static noinline struct module *load_module(void __user *umod,
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
@@ -2373,8 +2375,8 @@ static noinline struct module *load_module(void __user *umod,
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
1.6.4.2

