Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbXKTBXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbXKTBXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbXKTBOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:08 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49872 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755965AbXKTBNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:40 -0500
Message-Id: <20071120011339.083287623@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:03 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 31/45] cpu alloc: Remove the allocpercpu functionality
Content-Disposition: inline; filename=0040-cpu-alloc-Remove-the-allocpercpu-functionality.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is no user of allocpercpu left after all the earlier patches were
applied. Remove the code that realizes allocpercpu.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/percpu.h |   80 ------------------------------
 mm/Makefile            |    1 
 mm/allocpercpu.c       |  127 -------------------------------------------------
 3 files changed, 208 deletions(-)
 delete mode 100644 mm/allocpercpu.c

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2007-11-19 16:28:42.577389871 -0800
+++ linux-2.6/include/linux/percpu.h	2007-11-19 16:29:00.029140648 -0800
@@ -33,86 +33,6 @@ DECLARE_PER_CPU(cpumask_t, cpu_mask);
 	&__get_cpu_var(var); }))
 #define put_cpu_var(var) preempt_enable()
 
-#ifdef CONFIG_SMP
-
-struct percpu_data {
-	void *ptrs[NR_CPUS];
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
-extern void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu);
-extern void percpu_depopulate(void *__pdata, int cpu);
-extern int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-				  cpumask_t *mask);
-extern void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask);
-extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask);
-extern void percpu_free(void *__pdata);
-
-#else /* CONFIG_SMP */
-
-#define percpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
-
-static inline void percpu_depopulate(void *__pdata, int cpu)
-{
-}
-
-static inline void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
-{
-}
-
-static inline void *percpu_populate(void *__pdata, size_t size, gfp_t gfp,
-				    int cpu)
-{
-	return percpu_ptr(__pdata, cpu);
-}
-
-static inline int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-					 cpumask_t *mask)
-{
-	return 0;
-}
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
-#endif /* CONFIG_SMP */
-
-#define percpu_populate_mask(__pdata, size, gfp, mask) \
-	__percpu_populate_mask((__pdata), (size), (gfp), &(mask))
-#define percpu_depopulate_mask(__pdata, mask) \
-	__percpu_depopulate_mask((__pdata), &(mask))
-#define percpu_alloc_mask(size, gfp, mask) \
-	__percpu_alloc_mask((size), (gfp), &(mask))
-
-#define percpu_alloc(size, gfp) percpu_alloc_mask((size), (gfp), cpu_online_map)
-
-/* (legacy) interface for use without CPU hotplug handling */
-
-#define __alloc_percpu(size)	percpu_alloc_mask((size), GFP_KERNEL, \
-						  cpu_possible_map)
-#define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type))
-#define free_percpu(ptr)	percpu_free((ptr))
-#define per_cpu_ptr(ptr, cpu)	percpu_ptr((ptr), (cpu))
-
-
 /*
  * cpu allocator definitions
  *
Index: linux-2.6/mm/Makefile
===================================================================
--- linux-2.6.orig/mm/Makefile	2007-11-19 16:28:42.185140751 -0800
+++ linux-2.6/mm/Makefile	2007-11-19 16:29:00.029140648 -0800
@@ -28,6 +28,5 @@ obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
-obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 
Index: linux-2.6/mm/allocpercpu.c
===================================================================
--- linux-2.6.orig/mm/allocpercpu.c	2007-11-19 16:28:01.113890069 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,127 +0,0 @@
-/*
- * linux/mm/allocpercpu.c
- *
- * Separated from slab.c August 11, 2006 Christoph Lameter <clameter@sgi.com>
- */
-#include <linux/mm.h>
-#include <linux/module.h>
-
-/**
- * percpu_depopulate - depopulate per-cpu data for given cpu
- * @__pdata: per-cpu data to depopulate
- * @cpu: depopulate per-cpu data for this cpu
- *
- * Depopulating per-cpu data for a cpu going offline would be a typical
- * use case. You need to register a cpu hotplug handler for that purpose.
- */
-void percpu_depopulate(void *__pdata, int cpu)
-{
-	struct percpu_data *pdata = __percpu_disguise(__pdata);
-
-	kfree(pdata->ptrs[cpu]);
-	pdata->ptrs[cpu] = NULL;
-}
-EXPORT_SYMBOL_GPL(percpu_depopulate);
-
-/**
- * percpu_depopulate_mask - depopulate per-cpu data for some cpu's
- * @__pdata: per-cpu data to depopulate
- * @mask: depopulate per-cpu data for cpu's selected through mask bits
- */
-void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
-{
-	int cpu;
-	for_each_cpu_mask(cpu, *mask)
-		percpu_depopulate(__pdata, cpu);
-}
-EXPORT_SYMBOL_GPL(__percpu_depopulate_mask);
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
-void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu)
-{
-	struct percpu_data *pdata = __percpu_disguise(__pdata);
-	int node = cpu_to_node(cpu);
-
-	BUG_ON(pdata->ptrs[cpu]);
-	if (node_online(node))
-		pdata->ptrs[cpu] = kmalloc_node(size, gfp|__GFP_ZERO, node);
-	else
-		pdata->ptrs[cpu] = kzalloc(size, gfp);
-	return pdata->ptrs[cpu];
-}
-EXPORT_SYMBOL_GPL(percpu_populate);
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
-int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-			   cpumask_t *mask)
-{
-	cpumask_t populated = CPU_MASK_NONE;
-	int cpu;
-
-	for_each_cpu_mask(cpu, *mask)
-		if (unlikely(!percpu_populate(__pdata, size, gfp, cpu))) {
-			__percpu_depopulate_mask(__pdata, &populated);
-			return -ENOMEM;
-		} else
-			cpu_set(cpu, populated);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__percpu_populate_mask);
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
-	void *pdata = kzalloc(sizeof(struct percpu_data), gfp);
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

-- 
