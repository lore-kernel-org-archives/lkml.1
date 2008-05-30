Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYE3EDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYE3EDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYE3EA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40483 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927AbYE3EAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:14 -0400
Message-Id: <20080530040011.084909898@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:22 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 02/41] cpu alloc: The allocator
Content-Disposition: inline; filename=cpu_alloc_base
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per cpu allocator allows dynamic allocation of memory on all
processors simultaneously. A bitmap is used to track used areas.
The allocator implements tight packing to reduce the cache footprint
and increase speed since cacheline contention is typically not a concern
for memory mainly used by a single cpu. Small objects will fill up gaps
left by larger allocations that required alignments.

The size of the cpu_alloc area can be changed via make menuconfig.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/percpu.h |   46 +++++++++++++
 include/linux/vmstat.h |    2 
 mm/Kconfig             |    6 +
 mm/Makefile            |    2 
 mm/cpu_alloc.c         |  167 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmstat.c            |    1 
 6 files changed, 222 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2008-05-29 19:41:21.000000000 -0700
+++ linux-2.6/include/linux/vmstat.h	2008-05-29 20:15:37.000000000 -0700
@@ -37,7 +37,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		PAGEOUTRUN, ALLOCSTALL, PGROTATED, CPU_BYTES,
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig	2008-05-29 19:41:21.000000000 -0700
+++ linux-2.6/mm/Kconfig	2008-05-29 20:13:39.000000000 -0700
@@ -205,3 +205,9 @@ config NR_QUICK
 config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
+
+config CPU_ALLOC_SIZE
+	int "Size of cpu alloc area"
+	default "30000"
+	help
+	  Sets the maximum amount of memory that can be allocated via cpu_alloc
Index: linux-2.6/mm/Makefile
===================================================================
--- linux-2.6.orig/mm/Makefile	2008-05-29 19:41:21.000000000 -0700
+++ linux-2.6/mm/Makefile	2008-05-29 20:15:41.000000000 -0700
@@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   maccess.o page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o $(mmu-y)
+			   page_isolation.o cpu_alloc.o $(mmu-y)
 
 obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
Index: linux-2.6/mm/cpu_alloc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/mm/cpu_alloc.c	2008-05-29 20:13:39.000000000 -0700
@@ -0,0 +1,167 @@
+/*
+ * Cpu allocator - Manage objects allocated for each processor
+ *
+ * (C) 2008 SGI, Christoph Lameter <clameter@sgi.com>
+ * 	Basic implementation with allocation and free from a dedicated per
+ * 	cpu area.
+ *
+ * The per cpu allocator allows dynamic allocation of memory on all
+ * processor simultaneously. A bitmap is used to track used areas.
+ * The allocator implements tight packing to reduce the cache footprint
+ * and increase speed since cacheline contention is typically not a concern
+ * for memory mainly used by a single cpu. Small objects will fill up gaps
+ * left by larger allocations that required alignments.
+ */
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/bitmap.h>
+#include <asm/sections.h>
+
+/*
+ * Basic allocation unit. A bit map is created to track the use of each
+ * UNIT_SIZE element in the cpu area.
+ */
+#define UNIT_TYPE int
+#define UNIT_SIZE sizeof(UNIT_TYPE)
+#define UNITS (CONFIG_CPU_ALLOC_SIZE / UNIT_SIZE)
+
+static DEFINE_PER_CPU(UNIT_TYPE, area[UNITS]);
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
+ * Lock to protect the bitmap and the meta data for the cpu allocator.
+ */
+static DEFINE_SPINLOCK(cpu_alloc_map_lock);
+static DECLARE_BITMAP(cpu_alloc_map, UNITS);
+static int first_free;		/* First known free unit */
+
+/*
+ * Mark an object as used in the cpu_alloc_map
+ *
+ * Must hold cpu_alloc_map_lock
+ */
+static void set_map(int start, int length)
+{
+	while (length-- > 0)
+		__set_bit(start++, cpu_alloc_map);
+}
+
+/*
+ * Mark an area as freed.
+ *
+ * Must hold cpu_alloc_map_lock
+ */
+static void clear_map(int start, int length)
+{
+	while (length-- > 0)
+		__clear_bit(start++, cpu_alloc_map);
+}
+
+/*
+ * Allocate an object of a certain size
+ *
+ * Returns a special pointer that can be used with CPU_PTR to find the
+ * address of the object for a certain cpu.
+ */
+void *cpu_alloc(unsigned long size, gfp_t gfpflags, unsigned long align)
+{
+	unsigned long start;
+	int units = size_to_units(size);
+	void *ptr;
+	int first;
+	unsigned long flags;
+
+	if (!size)
+		return ZERO_SIZE_PTR;
+
+	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
+
+	first = 1;
+	start = first_free;
+
+	for ( ; ; ) {
+
+		start = find_next_zero_bit(cpu_alloc_map, UNITS, start);
+		if (start >= UNITS)
+			goto out_of_memory;
+
+		if (first)
+			first_free = start;
+
+		/*
+		 * Check alignment and that there is enough space after
+		 * the starting unit.
+		 */
+		if (start % (align / UNIT_SIZE) == 0 &&
+			find_next_bit(cpu_alloc_map, UNITS, start + 1)
+							>= start + units)
+				break;
+		start++;
+		first = 0;
+	}
+
+	if (first)
+		first_free = start + units;
+
+	if (start + units > UNITS)
+		goto out_of_memory;
+
+	set_map(start, units);
+	__count_vm_events(CPU_BYTES, units * UNIT_SIZE);
+
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
+
+	ptr = per_cpu_var(area) + start;
+
+	if (gfpflags & __GFP_ZERO) {
+		int cpu;
+
+		for_each_possible_cpu(cpu)
+			memset(CPU_PTR(ptr, cpu), 0, size);
+	}
+
+	return ptr;
+
+out_of_memory:
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
+	return NULL;
+}
+EXPORT_SYMBOL(cpu_alloc);
+
+/*
+ * Free an object. The pointer must be a cpu pointer allocated
+ * via cpu_alloc.
+ */
+void cpu_free(void *start, unsigned long size)
+{
+	unsigned long units = size_to_units(size);
+	unsigned long index = (int *)start - per_cpu_var(area);
+	unsigned long flags;
+
+	if (!start || start == ZERO_SIZE_PTR)
+		return;
+
+	BUG_ON(index >= UNITS ||
+		!test_bit(index, cpu_alloc_map) ||
+		!test_bit(index + units - 1, cpu_alloc_map));
+
+	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
+
+	clear_map(index, units);
+	__count_vm_events(CPU_BYTES, -units * UNIT_SIZE);
+
+	if (index < first_free)
+		first_free = index;
+
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
+}
+EXPORT_SYMBOL(cpu_free);
Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2008-05-29 19:41:21.000000000 -0700
+++ linux-2.6/mm/vmstat.c	2008-05-29 20:13:39.000000000 -0700
@@ -653,6 +653,7 @@ static const char * const vmstat_text[] 
 	"allocstall",
 
 	"pgrotated",
+	"cpu_bytes",
 #ifdef CONFIG_HUGETLB_PAGE
 	"htlb_buddy_alloc_success",
 	"htlb_buddy_alloc_fail",
Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2008-05-29 19:41:21.000000000 -0700
+++ linux-2.6/include/linux/percpu.h	2008-05-29 20:29:12.000000000 -0700
@@ -135,4 +135,50 @@ static inline void percpu_free(void *__p
 #define free_percpu(ptr)	percpu_free((ptr))
 #define per_cpu_ptr(ptr, cpu)	percpu_ptr((ptr), (cpu))
 
+
+/*
+ * cpu allocator definitions
+ *
+ * The cpu allocator allows allocating an instance of an object for each
+ * processor and the use of a single pointer to access all instances
+ * of the object. cpu_alloc provides optimized means for accessing the
+ * instance of the object belonging to the currently executing processor
+ * as well as special atomic operations on fields of objects of the
+ * currently executing processor.
+ *
+ * Cpu objects are typically small. The allocator packs them tightly
+ * to increase the chance on each access that a per cpu object is already
+ * cached. Alignments may be specified but the intent is to align the data
+ * properly due to cpu alignment constraints and not to avoid cacheline
+ * contention. Any holes left by aligning objects are filled up with smaller
+ * objects that are allocated later.
+ *
+ * Cpu data can be allocated using CPU_ALLOC. The resulting pointer is
+ * pointing to the instance of the variable in the per cpu area provided
+ * by the loader. It is generally an error to use the pointer directly
+ * unless we are booting the system.
+ *
+ * __GFP_ZERO may be passed as a flag to zero the allocated memory.
+ */
+
+/* Return a pointer to the instance of a object for a particular processor */
+#define CPU_PTR(__p, __cpu)	SHIFT_PERCPU_PTR((__p), per_cpu_offset(__cpu))
+
+/*
+ * Return a pointer to the instance of the object belonging to the processor
+ * running the current code.
+ */
+#define THIS_CPU(__p)	SHIFT_PERCPU_PTR((__p), my_cpu_offset)
+#define __THIS_CPU(__p)	SHIFT_PERCPU_PTR((__p), __my_cpu_offset)
+
+#define CPU_ALLOC(type, flags)	((typeof(type) *)cpu_alloc(sizeof(type), \
+					(flags), __alignof__(type)))
+#define CPU_FREE(pointer)	cpu_free((pointer), sizeof(*(pointer)))
+
+/*
+ * Raw calls
+ */
+void *cpu_alloc(unsigned long size, gfp_t flags, unsigned long align);
+void cpu_free(void *cpu_pointer, unsigned long size);
+
 #endif /* __LINUX_PERCPU_H */

-- 
