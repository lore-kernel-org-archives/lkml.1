Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXKAAFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXKAAFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbXKAADZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:03:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40556 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754783AbXKAADO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:03:14 -0400
Message-Id: <20071101000309.765254518@sgi.com>
References: <20071101000211.970501947@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 17:02:12 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 1/7] allocpercpu: Make it a true per cpu allocator by allocating from a per cpu array
Content-Disposition: inline; filename=newallocpercpu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently each call to alloc_percpu allocates an array of pointer to objects.
For each operation on a percpu structure we need to follow a pointer from that
map. Usually a processor used only the entry for its own processor id in that
array. The rest of the bytes in the cacheline are not needed. This repeats
itself for each and every per cpu array in use.

Moreover the result of alloc_percpu is not a variable that can be handled like
a regular per cpu variable.

The approach here changes the way allocpercpu is done. Objects are placed
in preallocated per cpu areas that are indexed via the existing per cpu array
of pointers. So we have a single array of pointer to per cpu areas that
is used by all per cpu operations. The data is placed tightly next to each
other for each processor so that the likelyhood of a single cache line covering
data for multiple needs is increased. The cache footprint of the allocpercpu
operations sinks dramatically. Some processors have the ability to map the
per cpu area of the current processor in a special way so that variables in
that area can be reached very efficiently. It is rather typical that a processor
only uses its own per processor area. On many architectures the indexing via
the per cpu array can then be completely bypassed.

The size of the per cpu alloc area is defined to be 32k per processor for now.

Another advantage of this approach is that the onlining and offlining
of the per cpu items is handled in a global way. On onlining a cpu all
objects become present without callbacks. Similarly on offlining a cpu
all per cpu objects vanish without the need of callbacks. Callbacks
may still be needed to do preparation and cleanup of the data areas
but the freeing and allocation of the per cpu areas no longer needs to
be done by the subsystems.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/percpu.h |   14 +---
 include/linux/vmstat.h |    2 
 mm/allocpercpu.c       |  163 +++++++++++++++++++++++++++++++++++++++++++------
 mm/vmstat.c            |    1 
 4 files changed, 152 insertions(+), 28 deletions(-)

Index: linux-2.6/mm/allocpercpu.c
===================================================================
--- linux-2.6.orig/mm/allocpercpu.c	2007-10-31 16:39:13.584621383 -0700
+++ linux-2.6/mm/allocpercpu.c	2007-10-31 16:39:15.924121250 -0700
@@ -2,10 +2,140 @@
  * linux/mm/allocpercpu.c
  *
  * Separated from slab.c August 11, 2006 Christoph Lameter <clameter@sgi.com>
+ *
+ * (C) 2007 SGI, Christoph Lameter <clameter@sgi.com>
+ * 	Basic implementation with allocation and free from a dedicated per
+ * 	cpu area.
+ *
+ * The per cpu allocator allows allocation of memory from a statically
+ * allocated per cpu array and consists of cells of UNIT_SIZE. A byte array
+ * is used to describe the state of each of the available units that can be
+ * allocated via cpu_alloc() and freed via cpu_free(). The possible states are:
+ *
+ * FREE	= The per cpu unit is not allocated
+ * USED	= The per cpu unit is allocated and more units follow.
+ * END	= The last per cpu unit used for an allocation (needed to
+ * 	  establish the size of the allocation on free)
+ *
+ * The per cpu allocator is typically used to allocate small sized object from 8 to 32
+ * bytes and it is rarely used. Allocation is looking for the first available object
+ * in the cpu_alloc_map. If the allocator would be used frequently with varying sizes
+ * of objects then we may end up with fragmentation.
  */
 #include <linux/mm.h>
 #include <linux/module.h>
 
+/*
+ * Maximum allowed per cpu data per cpu
+ */
+#define PER_CPU_ALLOC_SIZE 32768
+
+#define UNIT_SIZE sizeof(unsigned long long)
+#define UNITS_PER_CPU (PER_CPU_ALLOC_SIZE / UNIT_SIZE)
+
+enum unit_type { FREE, END, USED };
+
+static u8 cpu_alloc_map[UNITS_PER_CPU] = { 1, };
+static DEFINE_SPINLOCK(cpu_alloc_map_lock);
+static DEFINE_PER_CPU(int, cpu_area)[UNITS_PER_CPU];
+
+#define CPU_DATA_OFFSET ((unsigned long)&per_cpu__cpu_area)
+
+/*
+ * How many units are needed for an object of a given size
+ */
+static int size_to_units(unsigned long size)
+{
+	return DIV_ROUND_UP(size, UNIT_SIZE);
+}
+
+/*
+ * Mark an object as used in the cpu_alloc_map
+ *
+ * Must hold cpu_alloc_map_lock
+ */
+static void set_map(int start, int length)
+{
+	cpu_alloc_map[start + length - 1] = END;
+	if (length > 1)
+		memset(cpu_alloc_map + start, USED, length - 1);
+}
+
+/*
+ * Mark an area as freed.
+ *
+ * Must hold cpu_alloc_map_lock
+ *
+ * Return the number of units taken up by the object freed.
+ */
+static int clear_map(int start)
+{
+	int units = 0;
+
+	while (cpu_alloc_map[start + units] == USED) {
+		cpu_alloc_map[start + units] = FREE;
+		units++;
+	}
+	BUG_ON(cpu_alloc_map[start] != END);
+	cpu_alloc_map[start] = FREE;
+	return units + 1;
+}
+
+/*
+ * Allocate an object of a certain size
+ *
+ * Returns a per cpu pointer that must not be directly used.
+ */
+static void *cpu_alloc(unsigned long size)
+{
+	unsigned long start = 0;
+	int units = size_to_units(size);
+	unsigned end;
+
+	spin_lock(&cpu_alloc_map_lock);
+	do {
+		while (start < UNITS_PER_CPU &&
+				cpu_alloc_map[start] != FREE)
+			start++;
+		if (start == UNITS_PER_CPU)
+			return NULL;
+
+		end = start + 1;
+		while (end < UNITS_PER_CPU && end - start < units &&
+				cpu_alloc_map[end] == FREE)
+			end++;
+		if (end - start == units)
+			break;
+		start = end;
+	} while (1);
+
+	set_map(start, units);
+	__count_vm_events(ALLOC_PERCPU, units * UNIT_SIZE);
+	spin_unlock(&cpu_alloc_map_lock);
+	return (void *)(start * UNIT_SIZE + CPU_DATA_OFFSET);
+}
+
+/*
+ * Free an object. The pointer must be a per cpu pointer allocated
+ * via cpu_alloc.
+ */
+static inline void cpu_free(void *pcpu)
+{
+	unsigned long start = (unsigned long)pcpu;
+	int index;
+	int units;
+
+	BUG_ON(start < CPU_DATA_OFFSET);
+	index = (start - CPU_DATA_OFFSET) / UNIT_SIZE;
+	BUG_ON(cpu_alloc_map[index] == FREE ||
+			index >= UNITS_PER_CPU);
+
+	spin_lock(&cpu_alloc_map_lock);
+	units = clear_map(index);
+	__count_vm_events(ALLOC_PERCPU, -units * UNIT_SIZE);
+	spin_unlock(&cpu_alloc_map_lock);
+}
+
 /**
  * percpu_depopulate - depopulate per-cpu data for given cpu
  * @__pdata: per-cpu data to depopulate
@@ -16,10 +146,10 @@
  */
 void percpu_depopulate(void *__pdata, int cpu)
 {
-	struct percpu_data *pdata = __percpu_disguise(__pdata);
-
-	kfree(pdata->ptrs[cpu]);
-	pdata->ptrs[cpu] = NULL;
+	/*
+	 * Nothing to do here. Removal can only be effected for all
+	 * per cpu areas of a cpu at once.
+	 */
 }
 EXPORT_SYMBOL_GPL(percpu_depopulate);
 
@@ -30,9 +160,9 @@ EXPORT_SYMBOL_GPL(percpu_depopulate);
  */
 void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
 {
-	int cpu;
-	for_each_cpu_mask(cpu, *mask)
-		percpu_depopulate(__pdata, cpu);
+	/*
+	 * Nothing to do
+	 */
 }
 EXPORT_SYMBOL_GPL(__percpu_depopulate_mask);
 
@@ -49,15 +179,11 @@ EXPORT_SYMBOL_GPL(__percpu_depopulate_ma
  */
 void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu)
 {
-	struct percpu_data *pdata = __percpu_disguise(__pdata);
-	int node = cpu_to_node(cpu);
+	int pdata = (unsigned long)__percpu_disguise(__pdata);
+	void *p = (void *)per_cpu_offset(cpu) + pdata;
 
-	BUG_ON(pdata->ptrs[cpu]);
-	if (node_online(node))
-		pdata->ptrs[cpu] = kmalloc_node(size, gfp|__GFP_ZERO, node);
-	else
-		pdata->ptrs[cpu] = kzalloc(size, gfp);
-	return pdata->ptrs[cpu];
+	memset(p, 0, size);
+	return p;
 }
 EXPORT_SYMBOL_GPL(percpu_populate);
 
@@ -98,14 +224,13 @@ EXPORT_SYMBOL_GPL(__percpu_populate_mask
  */
 void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
 {
-	void *pdata = kzalloc(sizeof(struct percpu_data), gfp);
+	void *pdata = cpu_alloc(size);
 	void *__pdata = __percpu_disguise(pdata);
 
 	if (unlikely(!pdata))
 		return NULL;
 	if (likely(!__percpu_populate_mask(__pdata, size, gfp, mask)))
 		return __pdata;
-	kfree(pdata);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(__percpu_alloc_mask);
@@ -121,7 +246,7 @@ void percpu_free(void *__pdata)
 {
 	if (unlikely(!__pdata))
 		return;
-	__percpu_depopulate_mask(__pdata, &cpu_possible_map);
-	kfree(__percpu_disguise(__pdata));
+	cpu_free(__percpu_disguise(__pdata));
 }
 EXPORT_SYMBOL_GPL(percpu_free);
+
Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2007-10-31 16:39:13.596621181 -0700
+++ linux-2.6/include/linux/percpu.h	2007-10-31 16:40:04.831371052 -0700
@@ -33,20 +33,18 @@
 
 #ifdef CONFIG_SMP
 
-struct percpu_data {
-	void *ptrs[NR_CPUS];
-};
+#define __percpu_disguise(pdata) ((void *)~(unsigned long)(pdata))
 
-#define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)
 /* 
  * Use this to get to a cpu's version of the per-cpu object dynamically
  * allocated. Non-atomic access to the current CPU's version should
  * probably be combined with get_cpu()/put_cpu().
  */ 
-#define percpu_ptr(ptr, cpu)                              \
-({                                                        \
-        struct percpu_data *__p = __percpu_disguise(ptr); \
-        (__typeof__(ptr))__p->ptrs[(cpu)];	          \
+#define percpu_ptr(ptr, cpu)           			\
+({							\
+	void *p = __percpu_disguise(ptr);		\
+	unsigned long q = per_cpu_offset(cpu);		\
+    	(__typeof__(ptr))(p + q);			\
 })
 
 extern void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu);
Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2007-10-31 16:39:13.604621189 -0700
+++ linux-2.6/include/linux/vmstat.h	2007-10-31 16:39:15.924121250 -0700
@@ -36,7 +36,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		PAGEOUTRUN, ALLOCSTALL, PGROTATED, ALLOC_PERCPU,
 		NR_VM_EVENT_ITEMS
 };
 
Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2007-10-31 16:39:13.592621141 -0700
+++ linux-2.6/mm/vmstat.c	2007-10-31 16:39:15.924121250 -0700
@@ -642,6 +642,7 @@ static const char * const vmstat_text[] 
 	"allocstall",
 
 	"pgrotated",
+	"alloc_percpu_bytes",
 #endif
 };
 

-- 
