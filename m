Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYKQN1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYKQN1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKQN0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:26:33 -0500
Received: from ozlabs.org ([203.10.76.45]:39446 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbYKQN0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:26:32 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon Nov 17 23:48:27 CST 2008
CC: akpm@linux-foundation.org
Subject: [PATCH 4/7] Improve alloc_percpu: switch over to (renamed) percpu_modfree.
Cc: Christoph Lameter <cl@linux-foundation.org>
Message-Id: <20081117132630.E2265DDE00@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now the switch: rename percpu_modalloc to __alloc_percpu, and
percpu_modfree to free_percpu and export them.

We delete the old ones, including the unused percpu_alloc,
percpu_alloc_mask and percpu_ptr.

per_cpu_ptr now uses RELOC_HIDE on per_cpu_offset, just like static
per-cpu variables (not SHIFT_PERCPU_PTR: this has side effects on
S/390 and Alpha).

The Alpha changes are untested.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 arch/alpha/include/asm/percpu.h |    3
 include/asm-generic/percpu.h    |    4 +
 include/linux/percpu.h          |   58 +---------------
 kernel/module.c                 |    8 +-
 mm/allocpercpu.c                |  143 +---------------------------------------
 5 files changed, 23 insertions(+), 193 deletions(-)

diff -r d3616007bee1 arch/alpha/include/asm/percpu.h
--- a/arch/alpha/include/asm/percpu.h	Mon Nov 17 23:40:12 2008 +1030
+++ b/arch/alpha/include/asm/percpu.h	Mon Nov 17 23:42:18 2008 +1030
@@ -62,12 +62,15 @@
 	(*SHIFT_PERCPU_PTR(var, my_cpu_offset))
 #define __raw_get_cpu_var(var) \
 	(*SHIFT_PERCPU_PTR(var, __my_cpu_offset))
+#define per_cpu_ptr(ptr, cpu) \
+	RELOC_HIDE((ptr), (per_cpu_offset(cpu)))
 
 #else /* ! SMP */
 
 #define per_cpu(var, cpu)		(*((void)(cpu), &per_cpu_var(var)))
 #define __get_cpu_var(var)		per_cpu_var(var)
 #define __raw_get_cpu_var(var)		per_cpu_var(var)
+#define per_cpu_ptr(ptr, cpu)		(ptr)
 
 #define PER_CPU_ATTRIBUTES
 
diff -r d3616007bee1 include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h	Mon Nov 17 23:40:12 2008 +1030
+++ b/include/asm-generic/percpu.h	Mon Nov 17 23:42:18 2008 +1030
@@ -60,6 +60,9 @@
 #define __raw_get_cpu_var(var) \
 	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
 
+/* Use RELOC_HIDE: some arch's SHIFT_PERCPU_PTR really want an identifier. */
+#define per_cpu_ptr(ptr, cpu) \
+	RELOC_HIDE((ptr), (per_cpu_offset(cpu)))
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
@@ -70,6 +73,7 @@
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
 #define __get_cpu_var(var)			per_cpu_var(var)
 #define __raw_get_cpu_var(var)			per_cpu_var(var)
+#define per_cpu_ptr(ptr, cpu)			(ptr)
 
 #endif	/* SMP */
 
diff -r d3616007bee1 include/linux/percpu.h
--- a/include/linux/percpu.h	Mon Nov 17 23:40:12 2008 +1030
+++ b/include/linux/percpu.h	Mon Nov 17 23:42:18 2008 +1030
@@ -58,66 +58,22 @@
 #define put_cpu_var(var) preempt_enable()
 
 #ifdef CONFIG_SMP
-
-struct percpu_data {
-	void *ptrs[1];
-};
-
-#define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)
-/* 
- * Use this to get to a cpu's version of the per-cpu object dynamically
- * allocated. Non-atomic access to the current CPU's version should
- * probably be combined with get_cpu()/put_cpu().
- */ 
-#define percpu_ptr(ptr, cpu)                              \
-({                                                        \
-        struct percpu_data *__p = __percpu_disguise(ptr); \
-        (__typeof__(ptr))__p->ptrs[(cpu)];	          \
-})
-
-extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask);
-extern void percpu_free(void *__pdata);
-
-void *percpu_modalloc(unsigned long size, unsigned long align);
-void percpu_modfree(void *pcpuptr);
-#else /* CONFIG_SMP */
-
-#define percpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
-
-static __always_inline void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
-{
-	return kzalloc(size, gfp);
-}
-
-static inline void percpu_free(void *__pdata)
-{
-	kfree(__pdata);
-}
-
-static inline void *percpu_modalloc(unsigned long size, unsigned long align)
+void *__alloc_percpu(unsigned long size, unsigned long align);
+void free_percpu(void *pcpuptr);
+#else
+static inline void *__alloc_percpu(unsigned long size, unsigned long align)
 {
 	return kzalloc(size);
 }
 
-static inline void percpu_modfree(void *pcpuptr)
+static inline void free_percpu(void *pcpuptr)
 {
 	kfree(pcpuptr);
 }
 #endif /* CONFIG_SMP */
 
-#define percpu_alloc_mask(size, gfp, mask) \
-	__percpu_alloc_mask((size), (gfp), &(mask))
-
-#define percpu_alloc(size, gfp) percpu_alloc_mask((size), (gfp), cpu_online_map)
-
-/* (legacy) interface for use without CPU hotplug handling */
-
-#define __alloc_percpu(size, align)	percpu_alloc_mask((size), GFP_KERNEL, \
-						  cpu_possible_map)
-#define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
-						       __alignof__(type))
-#define free_percpu(ptr)	percpu_free((ptr))
-#define per_cpu_ptr(ptr, cpu)	percpu_ptr((ptr), (cpu))
+#define alloc_percpu(type) \
+	(type *)__alloc_percpu(sizeof(type), __alignof__(type))
 
 void percpu_alloc_init(void);
 
diff -r d3616007bee1 kernel/module.c
--- a/kernel/module.c	Mon Nov 17 23:40:12 2008 +1030
+++ b/kernel/module.c	Mon Nov 17 23:42:18 2008 +1030
@@ -1312,7 +1312,7 @@
 	/* This may be NULL, but that's OK */
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
-	percpu_modfree(mod->percpu);
+	free_percpu(mod->percpu);
 
 	/* Free lock-classes: */
 	lockdep_free_key_range(mod->module_core, mod->core_size);
@@ -1851,8 +1851,8 @@
 
 	if (pcpuindex) {
 		/* We have a special allocation for this section. */
-		percpu = percpu_modalloc(sechdrs[pcpuindex].sh_size,
-					 sechdrs[pcpuindex].sh_addralign);
+		percpu = __alloc_percpu(sechdrs[pcpuindex].sh_size,
+					sechdrs[pcpuindex].sh_addralign);
 		if (!percpu) {
 			err = -ENOMEM;
 			goto free_mod;
@@ -2130,7 +2130,7 @@
  free_core:
 	module_free(mod, mod->module_core);
  free_percpu:
-	percpu_modfree(percpu);
+	free_percpu(percpu);
  free_mod:
 	kfree(args);
  free_hdr:
diff -r d3616007bee1 mm/allocpercpu.c
--- a/mm/allocpercpu.c	Mon Nov 17 23:40:12 2008 +1030
+++ b/mm/allocpercpu.c	Mon Nov 17 23:42:18 2008 +1030
@@ -2,146 +2,11 @@
  * linux/mm/allocpercpu.c
  *
  * Separated from slab.c August 11, 2006 Christoph Lameter
+ * Replaced by code stolen from module.c Late 2008 Rusty Russell
  */
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <asm/sections.h>
-
-#ifndef cache_line_size
-#define cache_line_size()	L1_CACHE_BYTES
-#endif
-
-/**
- * percpu_depopulate - depopulate per-cpu data for given cpu
- * @__pdata: per-cpu data to depopulate
- * @cpu: depopulate per-cpu data for this cpu
- *
- * Depopulating per-cpu data for a cpu going offline would be a typical
- * use case. You need to register a cpu hotplug handler for that purpose.
- */
-static void percpu_depopulate(void *__pdata, int cpu)
-{
-	struct percpu_data *pdata = __percpu_disguise(__pdata);
-
-	kfree(pdata->ptrs[cpu]);
-	pdata->ptrs[cpu] = NULL;
-}
-
-/**
- * percpu_depopulate_mask - depopulate per-cpu data for some cpu's
- * @__pdata: per-cpu data to depopulate
- * @mask: depopulate per-cpu data for cpu's selected through mask bits
- */
-static void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
-{
-	int cpu;
-	for_each_cpu_mask_nr(cpu, *mask)
-		percpu_depopulate(__pdata, cpu);
-}
-
-#define percpu_depopulate_mask(__pdata, mask) \
-	__percpu_depopulate_mask((__pdata), &(mask))
-
-/**
- * percpu_populate - populate per-cpu data for given cpu
- * @__pdata: per-cpu data to populate further
- * @size: size of per-cpu object
- * @gfp: may sleep or not etc.
- * @cpu: populate per-data for this cpu
- *
- * Populating per-cpu data for a cpu coming online would be a typical
- * use case. You need to register a cpu hotplug handler for that purpose.
- * Per-cpu object is populated with zeroed buffer.
- */
-static void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu)
-{
-	struct percpu_data *pdata = __percpu_disguise(__pdata);
-	int node = cpu_to_node(cpu);
-
-	/*
-	 * We should make sure each CPU gets private memory.
-	 */
-	size = roundup(size, cache_line_size());
-
-	BUG_ON(pdata->ptrs[cpu]);
-	if (node_online(node))
-		pdata->ptrs[cpu] = kmalloc_node(size, gfp|__GFP_ZERO, node);
-	else
-		pdata->ptrs[cpu] = kzalloc(size, gfp);
-	return pdata->ptrs[cpu];
-}
-
-/**
- * percpu_populate_mask - populate per-cpu data for more cpu's
- * @__pdata: per-cpu data to populate further
- * @size: size of per-cpu object
- * @gfp: may sleep or not etc.
- * @mask: populate per-cpu data for cpu's selected through mask bits
- *
- * Per-cpu objects are populated with zeroed buffers.
- */
-static int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-				  cpumask_t *mask)
-{
-	cpumask_t populated;
-	int cpu;
-
-	cpus_clear(populated);
-	for_each_cpu_mask_nr(cpu, *mask)
-		if (unlikely(!percpu_populate(__pdata, size, gfp, cpu))) {
-			__percpu_depopulate_mask(__pdata, &populated);
-			return -ENOMEM;
-		} else
-			cpu_set(cpu, populated);
-	return 0;
-}
-
-#define percpu_populate_mask(__pdata, size, gfp, mask) \
-	__percpu_populate_mask((__pdata), (size), (gfp), &(mask))
-
-/**
- * percpu_alloc_mask - initial setup of per-cpu data
- * @size: size of per-cpu object
- * @gfp: may sleep or not etc.
- * @mask: populate per-data for cpu's selected through mask bits
- *
- * Populating per-cpu data for all online cpu's would be a typical use case,
- * which is simplified by the percpu_alloc() wrapper.
- * Per-cpu objects are populated with zeroed buffers.
- */
-void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
-{
-	/*
-	 * We allocate whole cache lines to avoid false sharing
-	 */
-	size_t sz = roundup(nr_cpu_ids * sizeof(void *), cache_line_size());
-	void *pdata = kzalloc(sz, gfp);
-	void *__pdata = __percpu_disguise(pdata);
-
-	if (unlikely(!pdata))
-		return NULL;
-	if (likely(!__percpu_populate_mask(__pdata, size, gfp, mask)))
-		return __pdata;
-	kfree(pdata);
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(__percpu_alloc_mask);
-
-/**
- * percpu_free - final cleanup of per-cpu data
- * @__pdata: object to clean up
- *
- * We simply clean up any per-cpu object left. No need for the client to
- * track and specify through a bis mask which per-cpu objects are to free.
- */
-void percpu_free(void *__pdata)
-{
-	if (unlikely(!__pdata))
-		return;
-	__percpu_depopulate_mask(__pdata, &cpu_possible_map);
-	kfree(__percpu_disguise(__pdata));
-}
-EXPORT_SYMBOL_GPL(percpu_free);
 
 /* Number of blocks used and allocated. */
 static unsigned int pcpu_num_used, pcpu_num_allocated;
@@ -180,7 +45,7 @@
 	return val;
 }
 
-void *percpu_modalloc(unsigned long size, unsigned long align)
+void *__alloc_percpu(unsigned long size, unsigned long align)
 {
 	unsigned long extra;
 	unsigned int i;
@@ -224,8 +89,9 @@
 	       size);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(__alloc_percpu);
 
-void percpu_modfree(void *freeme)
+void free_percpu(void *freeme)
 {
 	unsigned int i;
 	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
@@ -259,6 +125,7 @@
 			(pcpu_num_used - (i+1)) * sizeof(pcpu_size[0]));
 	}
 }
+EXPORT_SYMBOL_GPL(free_percpu);
 
 void __init percpu_alloc_init(void)
 {

