Return-Path: <linux-kernel-owner+w=401wt.eu-S1761116AbXKAAER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761116AbXKAAER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbXKAADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:03:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40555 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754373AbXKAADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:03:11 -0400
Message-Id: <20071101000309.984890202@sgi.com>
References: <20071101000211.970501947@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 17:02:13 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 2/7] allocpercpu: Remove functions that are rarely used.
Content-Disposition: inline; filename=rm_old_function
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Population and depopulation is no longer needed since newly created
per cpu areas will have all the fields needed. Teardown of per cpu
areas will remove objects no longer needed.

This basically reverts the API to the way it was before the population and
depopulation went in. There is only a single user in the kernel that uses these
functions in net/iucv/iucv.c which is S/390 specific.

Remove the useless population and depopulation functions there. In that driver
we have the single occurrence of a per cpu allocations that uses GFP flags.
The allocation from the DMA zone is required in order to have memory below 2G. But
it seems that the per cpu areas are also under 2G so we are fine there.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/percpu.h |   42 +------------------
 mm/allocpercpu.c       |  104 +++++--------------------------------------------
 net/iucv/iucv.c        |   31 +++-----------
 3 files changed, 21 insertions(+), 156 deletions(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2007-10-31 16:40:04.831371052 -0700
+++ linux-2.6/include/linux/percpu.h	2007-10-31 16:40:14.892121256 -0700
@@ -47,41 +47,16 @@
     	(__typeof__(ptr))(p + q);			\
 })
 
-extern void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu);
-extern void percpu_depopulate(void *__pdata, int cpu);
-extern int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-				  cpumask_t *mask);
-extern void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask);
-extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask);
+extern void *__alloc_percpu(size_t size);
 extern void percpu_free(void *__pdata);
 
 #else /* CONFIG_SMP */
 
 #define percpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
-static inline void percpu_depopulate(void *__pdata, int cpu)
+static __always_inline void *__alloc_percpu(size_t size)
 {
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
+	return kzalloc(size, GFP_KERNEL);
 }
 
 static inline void percpu_free(void *__pdata)
@@ -91,19 +66,8 @@ static inline void percpu_free(void *__p
 
 #endif /* CONFIG_SMP */
 
-#define percpu_populate_mask(__pdata, size, gfp, mask) \
-	__percpu_populate_mask((__pdata), (size), (gfp), &(mask))
-#define percpu_depopulate_mask(__pdata, mask) \
-	__percpu_depopulate_mask((__pdata), &(mask))
-#define percpu_alloc_mask(size, gfp, mask) \
-	__percpu_alloc_mask((size), (gfp), &(mask))
-
-#define percpu_alloc(size, gfp) percpu_alloc_mask((size), (gfp), cpu_online_map)
-
 /* (legacy) interface for use without CPU hotplug handling */
 
-#define __alloc_percpu(size)	percpu_alloc_mask((size), GFP_KERNEL, \
-						  cpu_possible_map)
 #define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type))
 #define free_percpu(ptr)	percpu_free((ptr))
 #define per_cpu_ptr(ptr, cpu)	percpu_ptr((ptr), (cpu))
Index: linux-2.6/mm/allocpercpu.c
===================================================================
--- linux-2.6.orig/mm/allocpercpu.c	2007-10-31 16:39:15.924121250 -0700
+++ linux-2.6/mm/allocpercpu.c	2007-10-31 16:40:14.892121256 -0700
@@ -136,111 +136,29 @@ static inline void cpu_free(void *pcpu)
 	spin_unlock(&cpu_alloc_map_lock);
 }
 
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
-	/*
-	 * Nothing to do here. Removal can only be effected for all
-	 * per cpu areas of a cpu at once.
-	 */
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
-	/*
-	 * Nothing to do
-	 */
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
+/*
+ * Allocate a per cpu array and zero all the per cpu objects.
+ * This is the externally visible function.
  */
-void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu)
-{
-	int pdata = (unsigned long)__percpu_disguise(__pdata);
-	void *p = (void *)per_cpu_offset(cpu) + pdata;
-
-	memset(p, 0, size);
-	return p;
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
+void *__alloc_percpu(size_t size)
 {
 	void *pdata = cpu_alloc(size);
 	void *__pdata = __percpu_disguise(pdata);
+	int cpu;
 
 	if (unlikely(!pdata))
 		return NULL;
-	if (likely(!__percpu_populate_mask(__pdata, size, gfp, mask)))
-		return __pdata;
-	return NULL;
+
+	for_each_possible_cpu(cpu)
+		memset(per_cpu_ptr(__pdata, cpu) , 0, size);
+
+	return __pdata;
 }
-EXPORT_SYMBOL_GPL(__percpu_alloc_mask);
+EXPORT_SYMBOL_GPL(__alloc_percpu);
 
 /**
  * percpu_free - final cleanup of per-cpu data
  * @__pdata: object to clean up
- *
- * We simply clean up any per-cpu object left. No need for the client to
- * track and specify through a bis mask which per-cpu objects are to free.
  */
 void percpu_free(void *__pdata)
 {
Index: linux-2.6/net/iucv/iucv.c
===================================================================
--- linux-2.6.orig/net/iucv/iucv.c	2007-10-31 16:39:13.001121287 -0700
+++ linux-2.6/net/iucv/iucv.c	2007-10-31 16:40:14.892121256 -0700
@@ -556,25 +556,6 @@ static int __cpuinit iucv_cpu_notify(str
 	long cpu = (long) hcpu;
 
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		if (!percpu_populate(iucv_irq_data,
-				     sizeof(struct iucv_irq_data),
-				     GFP_KERNEL|GFP_DMA, cpu))
-			return NOTIFY_BAD;
-		if (!percpu_populate(iucv_param, sizeof(union iucv_param),
-				     GFP_KERNEL|GFP_DMA, cpu)) {
-			percpu_depopulate(iucv_irq_data, cpu);
-			return NOTIFY_BAD;
-		}
-		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		percpu_depopulate(iucv_param, cpu);
-		percpu_depopulate(iucv_irq_data, cpu);
-		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
@@ -1617,16 +1598,18 @@ static int __init iucv_init(void)
 		rc = PTR_ERR(iucv_root);
 		goto out_bus;
 	}
-	/* Note: GFP_DMA used to get memory below 2G */
-	iucv_irq_data = percpu_alloc(sizeof(struct iucv_irq_data),
-				     GFP_KERNEL|GFP_DMA);
+	/*
+	 * Note: GFP_DMA used to get memory below 2G.
+	 *
+	 * The percpu data is below 2G right ? So this should work too -cl?
+	 */
+	iucv_irq_data = percpu_alloc(struct iucv_irq_data);
 	if (!iucv_irq_data) {
 		rc = -ENOMEM;
 		goto out_root;
 	}
 	/* Allocate parameter blocks. */
-	iucv_param = percpu_alloc(sizeof(union iucv_param),
-				  GFP_KERNEL|GFP_DMA);
+	iucv_param = percpu_alloc(union iucv_param);
 	if (!iucv_param) {
 		rc = -ENOMEM;
 		goto out_extint;

-- 
