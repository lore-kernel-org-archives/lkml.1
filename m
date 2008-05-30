Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbYE3EJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbYE3EJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbYE3EBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40543 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752957AbYE3EAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:23 -0400
Message-Id: <20080530040020.139375468@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:47 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 27/41] cpu alloc: Remove the allocpercpu functionality
Content-Disposition: inline; filename=cpu_alloc_remove_allocpercpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no user of allocpercpu left after all the earlier patches were
applied. Remove the allocpercpu code.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/percpu.h |   80 ------------------------------
 mm/Makefile            |    1 
 mm/allocpercpu.c       |  127 -------------------------------------------------
 3 files changed, 208 deletions(-)
 delete mode 100644 mm/allocpercpu.c

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2008-05-21 21:42:55.000000000 -0700
+++ linux-2.6/include/linux/percpu.h	2008-05-21 22:03:19.000000000 -0700
@@ -53,86 +53,6 @@
 	&__get_cpu_var(var); }))
 #define put_cpu_var(var) preempt_enable()
 
-#ifdef CONFIG_SMP
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
--- linux-2.6.orig/mm/Makefile	2008-05-21 21:35:21.000000000 -0700
+++ linux-2.6/mm/Makefile	2008-05-21 22:02:05.000000000 -0700
@@ -30,7 +30,6 @@
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
-obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
 
Index: linux-2.6/mm/allocpercpu.c
===================================================================
--- linux-2.6.orig/mm/allocpercpu.c	2008-04-29 14:55:55.000000000 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,141 +0,0 @@
-/*
- * linux/mm/allocpercpu.c
- *
- * Separated from slab.c August 11, 2006 Christoph Lameter <clameter@sgi.com>
- */
-#include <linux/mm.h>
-#include <linux/module.h>
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
-	cpumask_t populated;
-	int cpu;
-
-	cpus_clear(populated);
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

-- 
