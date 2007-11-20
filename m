Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbXKTBOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbXKTBOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbXKTBNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:37 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36842 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752676AbXKTBNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:33 -0500
Message-Id: <20071120011332.182511436@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:34 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 02/45] cpu alloc: Simple version of the allocator (static allocations)
Content-Disposition: inline; filename=cpu_alloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The core portion of the cpu allocator.

The per cpu allocator allows dynamic allocation of memory on all
processor simultaneously. A bitmap is used to track used areas.
The allocator implements tight packing to reduce the cache footprint
and increase speed since cacheline contention is typically not a concern
for memory mainly used by a single cpu. Small objects will fill up gaps
left by larger allocations that required alignments.

This is a limited version of the cpu allocator that only performs a
static allocation of a single page for each processor. This is enough
for the use of the cpu allocator in the slab and page allocator for most
of the common configurations. The configuration will be useful for
embedded systems to reduce memory requirements. However, there is a hard limit
of the size of the per cpu structures and so the default configuration of an
order 0 allocation can only support up to 150 slab caches (most systems that
I got use 70) and probably not more than 16 or so NUMA nodes. The size of the
statically configured area can be changed via make menuconfig etc.

The cpu allocator virtualization patch is needed in order to support the dynamically
extending per cpu areas.

V1->V2:
- Split off the dynamic extendable cpu area feature to make it clear that it exists.\
- Remove useless variables.
- Add boot_cpu_alloc for bootime cpu area reservations (allows the folding in of
  per cpu areas and other arch specific per cpu stuff during boot).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/percpu.h |   78 +++++++++++++++++++
 include/linux/vmstat.h |    2 
 mm/Kconfig             |    7 +
 mm/Makefile            |    2 
 mm/cpu_alloc.c         |  192 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmstat.c            |    1 
 6 files changed, 280 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/cpu_alloc.h
 create mode 100644 mm/cpu_alloc.c

Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2007-11-18 22:07:35.588274285 -0800
+++ linux-2.6/include/linux/vmstat.h	2007-11-18 22:07:49.864273686 -0800
@@ -36,7 +36,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		PAGEOUTRUN, ALLOCSTALL, PGROTATED, CPU_BYTES,
 		NR_VM_EVENT_ITEMS
 };
 
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig	2007-11-18 22:07:35.600273725 -0800
+++ linux-2.6/mm/Kconfig	2007-11-18 22:13:51.405773802 -0800
@@ -194,3 +194,10 @@ config NR_QUICK
 config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
+
+config CPU_AREA_ORDER
+	int "Maximum size (order) of CPU area"
+	default "3"
+	help
+	  Sets the maximum amount of memory that can be allocated via cpu_alloc
+	  The size is set in page order, so 0 = PAGE_SIZE, 1 = PAGE_SIZE << 1 etc.
Index: linux-2.6/mm/Makefile
===================================================================
--- linux-2.6.orig/mm/Makefile	2007-11-18 22:07:35.608273792 -0800
+++ linux-2.6/mm/Makefile	2007-11-18 22:13:44.924523941 -0800
@@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o $(mmu-y)
+			   page_isolation.o cpu_alloc.o $(mmu-y)
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
Index: linux-2.6/mm/cpu_alloc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/mm/cpu_alloc.c	2007-11-18 22:15:04.453743317 -0800
@@ -0,0 +1,192 @@
+/*
+ * Cpu allocator - Manage objects allocated for each processor
+ *
+ * (C) 2007 SGI, Christoph Lameter <clameter@sgi.com>
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
+
+/*
+ * Basic allocation unit. A bit map is created to track the use of each
+ * UNIT_SIZE element in the cpu area.
+ */
+
+#define UNIT_SIZE sizeof(int)
+#define UNITS (ALLOC_SIZE / UNIT_SIZE)
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
+static unsigned long units_reserved;	/* Units reserved by boot allocations */
+
+/*
+ * Static configuration. The cpu areas are of a fixed size and
+ * cannot be extended. Such configurations are mainly useful on
+ * machines that do not have MMU support. Note that we have to use
+ * bss space for the static declarations. The combination of a large number
+ * of processors and a large cpu area may cause problems with the size
+ * of the bss segment.
+ */
+#define ALLOC_SIZE (1UL << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT))
+
+char cpu_area[NR_CPUS * ALLOC_SIZE];
+static DECLARE_BITMAP(cpu_alloc_map, UNITS);
+
+void * __init boot_cpu_alloc(unsigned long size)
+{
+	unsigned long x = units_reserved;
+
+	units_reserved += size_to_units(size);
+	BUG_ON(units_reserved > UNITS);
+	return (void *)(x * UNIT_SIZE);
+}
+
+static int first_free;		/* First known free unit */
+EXPORT_SYMBOL(cpu_area);
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
+	BUG_ON(gfpflags & ~(GFP_RECLAIM_MASK | __GFP_ZERO));
+
+	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
+
+	if (!units_reserved)
+		/*
+		 * No boot time allocations. Must have at least one
+		 * reserved unit to avoid returning a NULL pointer
+		 */
+		units_reserved = 1;
+
+	first = 1;
+	start = first_free;
+
+	for ( ; ; ) {
+
+		start = find_next_zero_bit(cpu_alloc_map, ALLOC_SIZE, start);
+		if (start >= UNITS - units_reserved)
+			goto out_of_memory;
+
+		if (first)
+			first_free = start;
+
+		/*
+		 * Check alignment and that there is enough space after
+		 * the starting unit.
+		 */
+		if ((start + units_reserved) % (align / UNIT_SIZE) == 0 &&
+			find_next_bit(cpu_alloc_map, ALLOC_SIZE, start + 1)
+							>= start + units)
+				break;
+		start++;
+		first = 0;
+	}
+
+	if (first)
+		first_free = start + units;
+
+	if (start + units > UNITS - units_reserved)
+		goto out_of_memory;
+
+	set_map(start, units);
+	__count_vm_events(CPU_BYTES, units * UNIT_SIZE);
+
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
+
+	ptr =  (void *)((start + units_reserved) * UNIT_SIZE);
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
+	int units = size_to_units(size);
+	int index;
+	unsigned long p = (unsigned long)start;
+	unsigned long flags;
+
+	BUG_ON(p < units_reserved * UNIT_SIZE);
+	index = p / UNIT_SIZE - units_reserved;
+	BUG_ON(!test_bit(index, cpu_alloc_map) ||
+			index >= UNITS - units_reserved);
+
+	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
+
+	clear_map(index, units);
+	__count_vm_events(CPU_BYTES, -units * UNIT_SIZE);
+	if (index < first_free)
+		first_free = index;
+
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
+}
+EXPORT_SYMBOL(cpu_free);
Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2007-11-18 22:07:49.784273594 -0800
+++ linux-2.6/mm/vmstat.c	2007-11-18 22:13:51.538023840 -0800
@@ -639,6 +639,7 @@ static const char * const vmstat_text[] 
 	"allocstall",
 
 	"pgrotated",
+	"cpu_bytes",
 #endif
 };
 
Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2007-11-18 22:07:49.729023738 -0800
+++ linux-2.6/include/linux/percpu.h	2007-11-18 22:13:51.773274119 -0800
@@ -112,4 +112,82 @@ static inline void percpu_free(void *__p
 #define free_percpu(ptr)	percpu_free((ptr))
 #define per_cpu_ptr(ptr, cpu)	percpu_ptr((ptr), (cpu))
 
+
+/*
+ * cpu allocator definitions
+ *
+ * The cpu allocator allows allocating an array of objects on all processors.
+ * A single pointer can then be used to access the instance of the object
+ * on a particular processor.
+ *
+ * Cpu objects are typically small. The allocator packs them tightly
+ * to increase the chance on each access that a per cpu object is already
+ * cached. Alignments may be specified but the intent is to align the data
+ * properly due to cpu alignment constraints and not to avoid cacheline
+ * contention. Any holes left by aligning objects are filled up with smaller
+ * objects that are allocated later.
+ *
+ * Cpu data can be allocated using CPU_ALLOC. The resulting pointer is
+ * pointing to the instance of the variable on cpu 0. It is generally an
+ * error to use the pointer directly unless we are running on cpu 0. So
+ * the use is valid during boot for example.
+ *
+ * The GFP flags have their usual function: __GFP_ZERO zeroes the object
+ * and other flags may be used to control reclaim behavior if the cpu
+ * areas have to be extended. However, zones cannot be selected nor
+ * can locality constraint flags be used.
+ *
+ * CPU_PTR() may be used to calculate the pointer for a specific processor.
+ * CPU_PTR is highly scalable since it simply adds the shifted value of
+ * smp_processor_id() to the base.
+ *
+ * Note: Synchronization is up to caller. If preemption is disabled then
+ * it is generally safe to access cpu variables (unless they are also
+ * handled from an interrupt context).
+ */
+
+#define SHIFT_PTR(__p, __offset) ((__typeof__(__p))((void *)(__p) \
+						+ (__offset)))
+extern char cpu_area[];
+
+static inline unsigned long __cpu_offset(unsigned long cpu)
+{
+	int shift = CONFIG_CPU_AREA_ORDER + PAGE_SHIFT;
+
+	return (unsigned long)cpu_area + (cpu << shift);
+}
+
+static inline unsigned long cpu_offset(unsigned long cpu)
+{
+#ifdef CONFIG_DEBUG_VM
+	if (system_state == SYSTEM_RUNNING) {
+		BUG_ON(!cpu_isset(cpu, cpu_possible_map));
+		WARN_ON(!cpu_isset(cpu, cpu_online_map));
+	}
+#endif
+	return __cpu_offset(cpu);
+}
+
+#define CPU_PTR(__p, __cpu) SHIFT_PTR(__p, cpu_offset(__cpu))
+#define __CPU_PTR(__p, __cpu) SHIFT_PTR(__p, __cpu_offset(__cpu))
+
+#define CPU_ALLOC(type, flags)	cpu_alloc(sizeof(type), flags, \
+					__alignof__(type))
+#define CPU_FREE(pointer)	cpu_free(pointer, sizeof(*(pointer)))
+
+#define THIS_CPU(__p)	CPU_PTR(__p, smp_processor_id())
+#define __THIS_CPU(__p)	CPU_PTR(__p, raw_smp_processor_id())
+
+/*
+ * Raw calls
+ */
+void *cpu_alloc(unsigned long size, gfp_t gfp, unsigned long align);
+void cpu_free(void *cpu_pointer, unsigned long size);
+
+/*
+ * Early boot allocator for per_cpu variables and special per cpu areas.
+ * Allocations are not tracked and cannot be freed.
+ */
+void *boot_cpu_alloc(unsigned long size);
+
 #endif /* __LINUX_PERCPU_H */

-- 
