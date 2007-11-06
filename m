Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbXKFTyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbXKFTyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbXKFTwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:15 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45360 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755428AbXKFTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:00 -0500
Message-Id: <20071106195157.878563669@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:45 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 01/28] cpu alloc: The allocator
Content-Disposition: inline; filename=cpu_alloc_core
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The core portion of the cpu allocator.

The per cpu allocator allows dynamic allocation of memory on all
processor simultaneously. A bitmap is used to track used areas.
The allocator implements tight packing to reduce the cache footprint
and increase speed since cacheline contention is typically not a concern
for memory mainly used by a single cpu. Small objects will fill up gaps
left by larger allocations that required alignments.

Signed-off-by: Christoph Lameter <clameter@sgi.com>


---
 include/linux/cpu_alloc.h |   56 ++++++
 include/linux/mm.h        |   13 +
 include/linux/vmstat.h    |    2 
 mm/Kconfig                |   33 +++
 mm/Makefile               |    3 
 mm/cpu_alloc.c            |  407 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmstat.c               |    1 
 7 files changed, 512 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/cpu_alloc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/mm/cpu_alloc.c	2007-11-06 06:05:06.000000000 +0000
@@ -0,0 +1,407 @@
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
+#include <linux/cpu_alloc.h>
+#include <linux/bitmap.h>
+#include <linux/vmalloc.h>
+#include <linux/bootmem.h>
+#include <linux/sched.h>	/* i386 definition of init_mm */
+#include <linux/highmem.h>	/* i386 dependency on highmem config */
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+
+/*
+ * Basic allocation unit. A bit map is created to track the use of each
+ * UNIT_SIZE element in the cpu area.
+ */
+
+#define UNIT_SIZE sizeof(int)
+#define UNITS_PER_BLOCK (ALLOC_SIZE / UNIT_SIZE)
+
+/*
+ * Lock to protect the bitmap and the meta data for the cpu allocator.
+ */
+static DEFINE_SPINLOCK(cpu_alloc_map_lock);
+
+#ifdef CONFIG_CPU_AREA_VIRTUAL
+
+/*
+ * Virtualized cpu area. The cpu area can be extended if more space is needed.
+ */
+
+#define cpu_area ((u8 *)(CPU_AREA_BASE))
+#define ALLOC_SIZE (1UL << (CONFIG_CPU_AREA_ALLOC_ORDER + PAGE_SHIFT))
+
+/*
+ * The maximum number of blocks is the maximum size of the
+ * cpu area for one processor divided by the size of an allocation
+ * block.
+ */
+#define MAX_BLOCKS (1UL << (CONFIG_CPU_AREA_ORDER - \
+				CONFIG_CPU_AREA_ALLOC_ORDER))
+
+
+static unsigned long *cpu_alloc_map = NULL;
+static int cpu_alloc_map_order = -1;	/* Size of the bitmap in page order */
+static unsigned long active_blocks;	/* Number of block allocated on each cpu */
+static unsigned long units_free;	/* Number of available units */
+static unsigned long units_total;	/* Total units that are managed */
+
+/*
+ * Allocate a block of memory to be used to provide cpu area memory
+ * or to extend the bitmap for the cpu map.
+ */
+void *cpu_area_alloc_block(unsigned long size, gfp_t flags, int node)
+{
+	struct page *page = alloc_pages_node(node,
+			flags, get_order(size));
+	if (page)
+		return page_address(page);
+	return NULL;
+}
+
+pte_t *cpu_area_pte_populate(pmd_t *pmd, unsigned long addr,
+						gfp_t flags, int node)
+{
+	pte_t *pte = pte_offset_kernel(pmd, addr);
+	if (pte_none(*pte)) {
+		pte_t entry;
+		void *p = cpu_area_alloc_block(PAGE_SIZE, flags, node);
+		if (!p)
+			return 0;
+		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+		set_pte_at(&init_mm, addr, pte, entry);
+	}
+	return pte;
+}
+
+pmd_t *cpu_area_pmd_populate(pud_t *pud, unsigned long addr,
+						gfp_t flags, int node)
+{
+	pmd_t *pmd = pmd_offset(pud, addr);
+	if (pmd_none(*pmd)) {
+		void *p = cpu_area_alloc_block(PAGE_SIZE, flags, node);
+		if (!p)
+			return 0;
+		pmd_populate_kernel(&init_mm, pmd, p);
+	}
+	return pmd;
+}
+
+pud_t *cpu_area_pud_populate(pgd_t *pgd, unsigned long addr,
+						gfp_t flags, int node)
+{
+	pud_t *pud = pud_offset(pgd, addr);
+	if (pud_none(*pud)) {
+		void *p = cpu_area_alloc_block(PAGE_SIZE, flags, node);
+		if (!p)
+			return 0;
+		pud_populate(&init_mm, pud, p);
+	}
+	return pud;
+}
+
+pgd_t *cpu_area_pgd_populate(unsigned long addr, gfp_t flags, int node)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	if (pgd_none(*pgd)) {
+		void *p = cpu_area_alloc_block(PAGE_SIZE, flags, node);
+		if (!p)
+			return 0;
+		pgd_populate(&init_mm, pgd, p);
+	}
+	return pgd;
+}
+
+int cpu_area_populate_basepages(void *start, unsigned long size,
+						gfp_t flags, int node)
+{
+	unsigned long addr = (unsigned long)start;
+	unsigned long end = addr + size;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	for (; addr < end; addr += PAGE_SIZE) {
+		pgd = cpu_area_pgd_populate(addr, flags, node);
+		if (!pgd)
+			return -ENOMEM;
+		pud = cpu_area_pud_populate(pgd, addr, flags, node);
+		if (!pud)
+			return -ENOMEM;
+		pmd = cpu_area_pmd_populate(pud, addr, flags, node);
+		if (!pmd)
+			return -ENOMEM;
+		pte = cpu_area_pte_populate(pmd, addr, flags, node);
+		if (!pte)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/*
+ * If no other population function is defined then this function will stand
+ * in and provide the capability to map PAGE_SIZE pages into the cpu area.
+ */
+int __attribute__((weak)) cpu_area_populate(void *start, unsigned long size,
+					gfp_t flags, int node)
+{
+	return cpu_area_populate_basepages(start, size, flags, node);
+}
+
+/*
+ * Extend the areas on all processors. This function may be called repeatedly
+ * until we have enough space to accomodate a newly allocated object.
+ *
+ * Must hold the cpu_alloc_map_lock on entry. Will drop the lock and then
+ * regain it.
+ */
+static int expand_cpu_area(gfp_t flags)
+{
+	unsigned long blocks = active_blocks;
+	unsigned long bits;
+	int cpu;
+	int err = -ENOMEM;
+	int map_order;
+	unsigned long *new_map = NULL;
+	void *start;
+
+	if (active_blocks == MAX_BLOCKS)
+		goto out;
+
+	spin_unlock(&cpu_alloc_map_lock);
+
+	/*
+	 * Determine the size of the bit map needed
+	 */
+	bits = (blocks + 1) * UNITS_PER_BLOCK;
+	map_order = get_order(DIV_ROUND_UP(bits, 8));
+	start = cpu_area + \
+		(blocks << (PAGE_SHIFT + CONFIG_CPU_AREA_ALLOC_ORDER));
+
+	for_each_possible_cpu(cpu) {
+		err = cpu_area_populate(CPU_PTR(start, cpu), ALLOC_SIZE,
+			flags, cpu_to_node(cpu));
+
+		if (err) {
+			spin_lock(&cpu_alloc_map_lock);
+			goto out;
+		}
+	}
+
+	if (map_order > cpu_alloc_map_order) {
+		new_map = cpu_area_alloc_block(PAGE_SIZE << map_order,
+						flags | __GFP_ZERO, 0);
+		if (!new_map)
+			goto out;
+	}
+
+	spin_lock(&cpu_alloc_map_lock);
+
+	/*
+	 * We dropped the lock. Another processor may have already extended
+	 * the cpu area size as needed.
+	 */
+	if (blocks != active_blocks) {
+		if (new_map)
+			free_pages((unsigned long)new_map,
+						map_order);
+		err = 0;
+		goto out;
+	}
+
+	if (new_map) {
+		/*
+		 * Need to extend the bitmap
+		 */
+		if (cpu_alloc_map)
+			memcpy(new_map, cpu_alloc_map,
+				PAGE_SIZE << cpu_alloc_map_order);
+		cpu_alloc_map = new_map;
+		cpu_alloc_map_order = map_order;
+	}
+
+	active_blocks++;
+	units_total += UNITS_PER_BLOCK;
+	units_free += UNITS_PER_BLOCK;
+	err = 0;
+out:
+	return err;
+}
+
+#else
+
+/*
+ * Static fallback configuration. The cpu areas are of a fixed size and
+ * cannot be extended. Such configurations are mainly useful on
+ * machines that do not have MMU support.
+ */
+#define MAX_BLOCKS 1
+#define ALLOC_SIZE (1UL << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT))
+
+static u8 cpu_area[NR_CPUS * ALLOC_SIZE];
+static DECLARE_BITMAP(cpu_alloc_map, UNITS_PER_BLOCK);
+static int units_free = UNITS_PER_BLOCK;
+#define cpu_alloc_map_order CONFIG_CPU_AREA_ORDER
+#define units_total UNITS_PER_BLOCK
+
+static inline int expand_cpu_area(gfp_t flags)
+{
+	return -ENOSYS;
+}
+#endif
+
+static int first_free;		/* First known free unit */
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
+	unsigned long map_size;
+
+	BUG_ON(gfpflags & ~(GFP_RECLAIM_MASK | __GFP_ZERO));
+
+	spin_lock(&cpu_alloc_map_lock);
+
+restart:
+	map_size = PAGE_SIZE << cpu_alloc_map_order;
+	first = 1;
+	start = first_free;
+
+	for ( ; ; ) {
+
+		start = find_next_zero_bit(cpu_alloc_map, map_size, start);
+		if (first)
+			first_free = start;
+
+		if (start >= units_total) {
+			if (expand_cpu_area(gfpflags))
+				goto out_of_memory;
+			goto restart;
+		}
+
+		/*
+		 * Check alignment and that there is enough space after
+		 * the starting unit.
+		 */
+		if (start % (align / UNIT_SIZE) == 0 &&
+			find_next_bit(cpu_alloc_map, map_size, start + 1)
+							>= start + units)
+				break;
+		start++;
+		first = 0;
+	}
+
+	if (first)
+		first_free = start + units;
+
+	while (start + units > units_total) {
+		if (expand_cpu_area(gfpflags))
+			goto out_of_memory;
+	}
+
+	set_map(start, units);
+	units_free -= units;
+	__count_vm_events(CPU_BYTES, units * UNIT_SIZE);
+
+	spin_unlock(&cpu_alloc_map_lock);
+
+	ptr = cpu_area + start * UNIT_SIZE;
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
+	spin_unlock(&cpu_alloc_map_lock);
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
+	u8 *p = start;
+
+	BUG_ON(p < cpu_area);
+	index = (p - cpu_area) / UNIT_SIZE;
+	BUG_ON(!test_bit(index, cpu_alloc_map) ||
+			index >= units_total);
+
+	spin_lock(&cpu_alloc_map_lock);
+
+	clear_map(index, units);
+	units_free += units;
+	__count_vm_events(CPU_BYTES, -units * UNIT_SIZE);
+	if (index < first_free)
+		first_free = index;
+
+	spin_unlock(&cpu_alloc_map_lock);
+}
+EXPORT_SYMBOL(cpu_free);
+
+
Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2007-11-06 06:05:02.000000000 +0000
+++ linux-2.6/include/linux/vmstat.h	2007-11-06 06:05:06.000000000 +0000
@@ -36,7 +36,7 @@
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		PAGEOUTRUN, ALLOCSTALL, PGROTATED, CPU_BYTES,
 		NR_VM_EVENT_ITEMS
 };
 
Index: linux-2.6/mm/Makefile
===================================================================
--- linux-2.6.orig/mm/Makefile	2007-11-06 06:05:02.000000000 +0000
+++ linux-2.6/mm/Makefile	2007-11-06 06:05:06.000000000 +0000
@@ -11,7 +11,7 @@
 			   page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o $(mmu-y)
+			   page_isolation.o cpu_alloc.o $(mmu-y)
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
@@ -30,4 +30,3 @@
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
-
Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2007-11-06 06:05:02.000000000 +0000
+++ linux-2.6/mm/vmstat.c	2007-11-06 06:05:06.000000000 +0000
@@ -642,6 +642,7 @@
 	"allocstall",
 
 	"pgrotated",
+	"cpu_bytes",
 #endif
 };
 
Index: linux-2.6/include/linux/cpu_alloc.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/cpu_alloc.h	2007-11-06 06:05:06.000000000 +0000
@@ -0,0 +1,56 @@
+/*
+ * include/linux/cpu_alloc.h - cpu allocator definitions
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
+#ifndef _LINUX_CPU_ALLOC_H_
+#define _LINUX_CPU_ALLOC_H_
+
+#define CPU_OFFSET(__cpu) \
+	((unsigned long)(__cpu) << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT))
+
+#define CPU_PTR(__p, __cpu) ((__typeof__(__p))((void *)(__p) + \
+							CPU_OFFSET(__cpu)))
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
+#endif /* _LINUX_CPU_ALLOC_H_ */
+
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig	2007-11-06 06:05:02.000000000 +0000
+++ linux-2.6/mm/Kconfig	2007-11-06 06:06:01.000000000 +0000
@@ -194,3 +194,15 @@
 config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
+
+config CPU_AREA_ORDER
+	int "Maximum order of CPU area"
+	default "16" if CPU_AREA_VIRTUAL
+	default "4" if !CPU_AREA_VIRTUAL
+	help
+	  Sets the maximum amount of memory that can be allocated via cpu_alloc
+	  The size is set in page order. The size set (times the maximum
+	  number of processors) determines the amount of virtual memory that
+	  is set aside for the per cpu areas.
+
+
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-11-06 06:05:02.000000000 +0000
+++ linux-2.6/include/linux/mm.h	2007-11-06 06:05:06.000000000 +0000
@@ -1141,5 +1141,18 @@
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 
+pgd_t *cpu_area_pgd_populate(unsigned long addr, gfp_t flags, int node);
+pud_t *cpu_area_pud_populate(pgd_t *pgd, unsigned long addr,
+						gfp_t flags, int node);
+pmd_t *cpu_area_pmd_populate(pud_t *pud, unsigned long addr,
+						gfp_t flags, int node);
+pte_t *cpu_area_pte_populate(pmd_t *pmd, unsigned long addr,
+						gfp_t flags, int node);
+void *cpu_area_alloc_block(unsigned long size, gfp_t flags, int node);
+int cpu_area_populate_basepages(void *start, unsigned long size,
+						gfp_t flags, int node);
+int cpu_area_populate(void *start, unsigned long size,
+						gfp_t flags, int node);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */

-- 
