Return-Path: <linux-kernel-owner+w=401wt.eu-S1761621AbYEOUk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621AbYEOUk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYEOUku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:40:50 -0400
Received: from smtp23.orange.fr ([193.252.22.30]:65521 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbYEOUkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:40:49 -0400
X-ME-UUID: 20080515204047351.55BBE1C00084@mwinf2336.orange.fr
Message-ID: <482C9FC5.2070508@cosmosbay.com>
Date: Thu, 15 May 2008 22:40:37 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
Subject: [PATCH] modules: Use a better scheme for refcounting
Content-Type: multipart/mixed;
 boundary="------------050906020109040509020701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050906020109040509020701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Current refcounting for modules (done if CONFIG_MODULE_UNLOAD=y)
is using a lot of memory.

Each 'struct module' contains an [NR_CPUS] array of full cache lines.

This patch uses existing infrastructure (percpu_modalloc() & 
percpu_modfree())
to allocate percpu space for the refcount storage.

Instead of wasting NR_CPUS*128 bytes (on i386), we now use
num_possible_cpus*sizeof(local_t) bytes.

On a typical distro, where NR_CPUS=8, shiping 2000 modules, we reduce
size of module files by about 2 Mbytes. (1Kb per module)

Instead of having all refcounters in the same memory node - with TLB misses
because of vmalloc() - this new implementation permits to have better
NUMA properties, since each  CPU will use storage on its preferred node,
thanks to percpu storage.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/module.h |   25 ++++++++++++++++---------
 kernel/module.c        |   37 +++++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 19 deletions(-)


--------------050906020109040509020701
Content-Type: text/plain;
 name="module.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="module.patch"

diff --git a/include/linux/module.h b/include/linux/module.h
index 3e03b1a..72db614 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -217,11 +217,6 @@ void *__symbol_get_gpl(const char *symbol);
 
 #endif
 
-struct module_ref
-{
-	local_t count;
-} ____cacheline_aligned;
-
 enum module_state
 {
 	MODULE_STATE_LIVE,
@@ -307,8 +302,11 @@ struct module
 
 #ifdef CONFIG_MODULE_UNLOAD
 	/* Reference counts */
-	struct module_ref ref[NR_CPUS];
-
+#ifdef CONFIG_SMP
+	char *refptr;
+#else
+	local_t ref;
+#endif
 	/* What modules depend on me? */
 	struct list_head modules_which_use_me;
 
@@ -378,13 +376,22 @@ void __symbol_put(const char *symbol);
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
@@ -396,7 +403,7 @@ static inline int try_module_get(struct module *module)
 	if (module) {
 		unsigned int cpu = get_cpu();
 		if (likely(module_is_live(module)))
-			local_inc(&module->ref[cpu].count);
+			local_inc(__module_ref_addr(module, cpu));
 		else
 			ret = 0;
 		put_cpu();
diff --git a/kernel/module.c b/kernel/module.c
index f5e9491..e0e8712 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -522,13 +522,13 @@ static char last_unloaded_module[MODULE_NAME_LEN+1];
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
@@ -659,10 +659,11 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
 
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
@@ -824,7 +825,7 @@ void module_put(struct module *module)
 {
 	if (module) {
 		unsigned int cpu = get_cpu();
-		local_dec(&module->ref[cpu].count);
+		local_dec(__module_ref_addr(module, cpu));
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
@@ -1392,7 +1393,10 @@ static void free_module(struct module *mod)
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
 
@@ -1760,6 +1764,9 @@ static struct module *load_module(void __user *umod,
 	unsigned int markersstringsindex;
 	struct module *mod;
 	long err = 0;
+#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+	void *refptr = NULL;
+#endif
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
 	struct exception_table_entry *extable;
 	mm_segment_t old_fs;
@@ -1904,6 +1911,12 @@ static struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto free_mod;
 
+#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+	refptr = percpu_modalloc(sizeof(local_t), sizeof(local_t), mod->name);
+	if (!refptr)
+		goto free_mod;
+	mod->refptr = refptr;
+#endif
 	if (pcpuindex) {
 		/* We have a special allocation for this section. */
 		percpu = percpu_modalloc(sechdrs[pcpuindex].sh_size,
@@ -1911,7 +1924,7 @@ static struct module *load_module(void __user *umod,
 					 mod->name);
 		if (!percpu) {
 			err = -ENOMEM;
-			goto free_mod;
+			goto free_percpu;
 		}
 		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 		mod->percpu = percpu;
@@ -2164,6 +2177,10 @@ static struct module *load_module(void __user *umod,
  free_percpu:
 	if (percpu)
 		percpu_modfree(percpu);
+#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+	if (refptr)
+		percpu_modfree(refptr);
+#endif
  free_mod:
 	kfree(args);
  free_hdr:

--------------050906020109040509020701--


