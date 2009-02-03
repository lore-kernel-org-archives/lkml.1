Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZBCDBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZBCDBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZBCDBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:01:43 -0500
Received: from ozlabs.org ([203.10.76.45]:56393 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZBCDBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:01:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] modules: Use a better scheme for refcounting
Date: Tue, 3 Feb 2009 13:31:36 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-9-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031331.36336.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>

(Linus, please apply.  This has become critical with NR_CPUS 4096: we
currently use an astonishing 1GB additional space for 2000 modules.)

Current refcounting for modules (done if CONFIG_MODULE_UNLOAD=y)
is using a lot of memory.

Each 'struct module' contains an [NR_CPUS] array of full cache lines.

This patch uses existing infrastructure (percpu_modalloc() &
percpu_modfree()) to allocate percpu space for the refcount storage.

Instead of wasting NR_CPUS*128 bytes (on i386), we now use
nr_cpu_ids*sizeof(local_t) bytes.

On a typical distro, where NR_CPUS=8, shiping 2000 modules, we reduce
size of module files by about 2 Mbytes. (1Kb per module)

Instead of having all refcounters in the same memory node - with TLB misses
because of vmalloc() - this new implementation permits to have better
NUMA properties, since each  CPU will use storage on its preferred node,
thanks to percpu storage.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h |   25 ++++++++++++++++---------
 kernel/module.c        |   35 +++++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -219,11 +219,6 @@ void *__symbol_get_gpl(const char *symbo
 
 #endif
 
-struct module_ref
-{
-	local_t count;
-} ____cacheline_aligned;
-
 enum module_state
 {
 	MODULE_STATE_LIVE,
@@ -344,8 +339,11 @@ struct module
 	/* Destruction function. */
 	void (*exit)(void);
 
-	/* Reference counts */
-	struct module_ref ref[NR_CPUS];
+#ifdef CONFIG_SMP
+	char *refptr;
+#else
+	local_t ref;
+#endif
 #endif
 };
 #ifndef MODULE_ARCH_INIT
@@ -395,13 +393,22 @@ void __symbol_put(const char *symbol);
 #define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x)
 void symbol_put_addr(void *addr);
 
+static inline local_t *__module_ref_addr(struct module *mod, int cpu)
+{
+#ifdef CONFIG_SMP
+	return (local_t *) (mod->refptr + per_cpu_offset(cpu));
+#else
+	return &mod->ref;
+#endif
+}
+
 /* Sometimes we know we already have a refcount, and it's easier not
    to handle the error case (which only happens with rmmod --wait). */
 static inline void __module_get(struct module *module)
 {
 	if (module) {
 		BUG_ON(module_refcount(module) == 0);
-		local_inc(&module->ref[get_cpu()].count);
+		local_inc(__module_ref_addr(module, get_cpu()));
 		put_cpu();
 	}
 }
@@ -413,7 +420,7 @@ static inline int try_module_get(struct 
 	if (module) {
 		unsigned int cpu = get_cpu();
 		if (likely(module_is_live(module)))
-			local_inc(&module->ref[cpu].count);
+			local_inc(__module_ref_addr(module, cpu));
 		else
 			ret = 0;
 		put_cpu();
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -573,13 +573,13 @@ static char last_unloaded_module[MODULE_
 /* Init the unload section of the module. */
 static void module_unload_init(struct module *mod)
 {
-	unsigned int i;
+	int cpu;
 
 	INIT_LIST_HEAD(&mod->modules_which_use_me);
-	for (i = 0; i < NR_CPUS; i++)
-		local_set(&mod->ref[i].count, 0);
+	for_each_possible_cpu(cpu)
+		local_set(__module_ref_addr(mod, cpu), 0);
 	/* Hold reference count during initialization. */
-	local_set(&mod->ref[raw_smp_processor_id()].count, 1);
+	local_set(__module_ref_addr(mod, raw_smp_processor_id()), 1);
 	/* Backwards compatibility macros put refcount during init. */
 	mod->waiter = current;
 }
@@ -717,10 +717,11 @@ static int try_stop_module(struct module
 
 unsigned int module_refcount(struct module *mod)
 {
-	unsigned int i, total = 0;
+	unsigned int total = 0;
+	int cpu;
 
-	for (i = 0; i < NR_CPUS; i++)
-		total += local_read(&mod->ref[i].count);
+	for_each_possible_cpu(cpu)
+		total += local_read(__module_ref_addr(mod, cpu));
 	return total;
 }
 EXPORT_SYMBOL(module_refcount);
@@ -894,7 +895,7 @@ void module_put(struct module *module)
 {
 	if (module) {
 		unsigned int cpu = get_cpu();
-		local_dec(&module->ref[cpu].count);
+		local_dec(__module_ref_addr(module, cpu));
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
@@ -1464,7 +1465,10 @@ static void free_module(struct module *m
 	kfree(mod->args);
 	if (mod->percpu)
 		percpu_modfree(mod->percpu);
-
+#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+	if (mod->refptr)
+		percpu_modfree(mod->refptr);
+#endif
 	/* Free lock-classes: */
 	lockdep_free_key_range(mod->module_core, mod->core_size);
 
@@ -2011,6 +2015,14 @@ static noinline struct module *load_modu
 	if (err < 0)
 		goto free_mod;
 
+#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+	mod->refptr = percpu_modalloc(sizeof(local_t), __alignof__(local_t),
+				      mod->name);
+	if (!mod->refptr) {
+		err = -ENOMEM;
+		goto free_mod;
+	}
+#endif
 	if (pcpuindex) {
 		/* We have a special allocation for this section. */
 		percpu = percpu_modalloc(sechdrs[pcpuindex].sh_size,
@@ -2018,7 +2030,7 @@ static noinline struct module *load_modu
 					 mod->name);
 		if (!percpu) {
 			err = -ENOMEM;
-			goto free_mod;
+			goto free_percpu;
 		}
 		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 		mod->percpu = percpu;
@@ -2282,6 +2294,9 @@ static noinline struct module *load_modu
  free_percpu:
 	if (percpu)
 		percpu_modfree(percpu);
+#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+	percpu_modfree(mod->refptr);
+#endif
  free_mod:
 	kfree(args);
  free_hdr:
