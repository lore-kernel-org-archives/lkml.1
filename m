Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbXKTBP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbXKTBP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbXKTBNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:43 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49833 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753354AbXKTBNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:34 -0500
Message-Id: <20071120011333.378125383@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:39 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 07/45] cpu_alloc: Implement dynamically extendable cpu areas
Content-Disposition: inline; filename=cpu_alloc_virtual
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Virtually map the cpu areas. This allows bigger maximum sizes and to only
populate the virtual mappings on demand.

In order to use the virtual mapping capability the arch must setup some
configuration variables in arch/xxx/Kconfig:

CONFIG_CPU_AREA_VIRTUAL to y

CONFIG_CPU_AREA_ORDER
	to the largest allowed size that the per cpu area can grow to.

CONFIG_CPU_AREA_ALLOC_ORDER
	to the allocation size when the cpu area needs to grow. Use 0
	here to guarantee order 0 allocations.

The address to use must be defined in CPU_AREA_BASE. This is typically done
in include/asm-xxx/pgtable.h. 

The maximum space used by the cpu are is

	NR_CPUS * (PAGE_SIZE << CONFIG_CPU_AREA_ORDER)

An arch may provide its own population function for the virtual mappings
(in order to exploit huge page mappings and other frills of the MMU of an
architecture). The default populate function uses single page mappings.


int cpu_area_populate(void *start, unsigned long size, gfp_t flags, int node)

The list of cpu_area_xx functions exported in include/linux/mm.h may be used
as helpers to generate the mapping that the arch needs.

In the simplest form the arch code calls:

	cpu_area_populate_basepages(start, size, flags, node);

The arch code must call

	cpu_area_alloc_block(unsigned long size, gfp_t flags, int node)

for all its memory needs during the construction of the custom page table.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |   13 ++
 mm/Kconfig         |   10 +
 mm/cpu_alloc.c     |  288 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 300 insertions(+), 11 deletions(-)

Index: linux-2.6/mm/cpu_alloc.c
===================================================================
--- linux-2.6.orig/mm/cpu_alloc.c	2007-11-19 15:53:21.569140430 -0800
+++ linux-2.6/mm/cpu_alloc.c	2007-11-19 15:55:48.805640240 -0800
@@ -17,6 +17,12 @@
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/bitmap.h>
+#include <linux/vmalloc.h>
+#include <linux/bootmem.h>
+#include <linux/sched.h>	/* i386 definition of init_mm */
+#include <linux/highmem.h>	/* i386 dependency on highmem config */
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
 
 /*
  * Basic allocation unit. A bit map is created to track the use of each
@@ -24,7 +30,7 @@
  */
 
 #define UNIT_SIZE sizeof(int)
-#define UNITS (ALLOC_SIZE / UNIT_SIZE)
+#define UNITS_PER_BLOCK (ALLOC_SIZE / UNIT_SIZE)
 
 /*
  * How many units are needed for an object of a given size
@@ -40,6 +46,246 @@ static int size_to_units(unsigned long s
 static DEFINE_SPINLOCK(cpu_alloc_map_lock);
 static unsigned long units_reserved;	/* Units reserved by boot allocations */
 
+#ifdef CONFIG_CPU_AREA_VIRTUAL
+
+/*
+ * Virtualized cpu area. The cpu area can be extended if more space is needed.
+ */
+
+#define ALLOC_SIZE (1UL << (CONFIG_CPU_AREA_ALLOC_ORDER + PAGE_SHIFT))
+#define BOOT_ALLOC (1 << __GFP_BITS_SHIFT)
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
+static unsigned long units_total;	/* Total units that are managed */
+/*
+ * Allocate a block of memory to be used to provide cpu area memory
+ * or to extend the bitmap for the cpu map.
+ */
+void *cpu_area_alloc_block(unsigned long size, gfp_t flags, int node)
+{
+	if (!(flags & BOOT_ALLOC)) {
+		struct page *page = alloc_pages_node(node,
+			flags, get_order(size));
+
+		if (page)
+			return page_address(page);
+		return NULL;
+	} else
+		return __alloc_bootmem_node(NODE_DATA(node), size, size,
+				__pa(MAX_DMA_ADDRESS));
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
+	if (flags & __GFP_WAIT)
+		local_irq_enable();
+
+	/*
+	 * Determine the size of the bit map needed
+	 */
+	bits = (blocks + 1) * UNITS_PER_BLOCK - units_reserved;
+
+	map_order = get_order(DIV_ROUND_UP(bits, 8));
+	BUG_ON(map_order >= MAX_ORDER);
+	start = (void *)(blocks << (PAGE_SHIFT + CONFIG_CPU_AREA_ALLOC_ORDER));
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
+	if (flags & __GFP_WAIT)
+		local_irq_disable();
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
+	err = 0;
+out:
+	return err;
+}
+
+void * __init boot_cpu_alloc(unsigned long size)
+{
+	unsigned long flags;
+	unsigned long x = units_reserved;
+	unsigned long units = size_to_units(size);
+
+	/*
+	 * Locking is really not necessary during boot
+	 * but expand_cpu_area() unlocks and relocks.
+	 * If we do not perform locking here then
+	 *
+	 * 1. The cpu_alloc_map_lock is locked when
+	 *    we exit boot causing a hang on the next cpu_alloc().
+	 * 2. lockdep will get upset if we do not consistently
+	 *    handle things.
+	 */
+	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
+	while (units_reserved + units > units_total)
+		expand_cpu_area(BOOT_ALLOC);
+	units_reserved += units;
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
+	return (void *)(x * UNIT_SIZE);
+}
+#else
+
 /*
  * Static configuration. The cpu areas are of a fixed size and
  * cannot be extended. Such configurations are mainly useful on
@@ -51,7 +297,14 @@ static unsigned long units_reserved;	/* 
 #define ALLOC_SIZE (1UL << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT))
 
 char cpu_area[NR_CPUS * ALLOC_SIZE];
-static DECLARE_BITMAP(cpu_alloc_map, UNITS);
+static DECLARE_BITMAP(cpu_alloc_map, UNITS_PER_BLOCK);
+#define cpu_alloc_map_order CONFIG_CPU_AREA_ORDER
+#define units_total UNITS_PER_BLOCK
+
+static inline int expand_cpu_area(gfp_t flags)
+{
+	return -ENOSYS;
+}
 
 void * __init boot_cpu_alloc(unsigned long size)
 {
@@ -61,6 +314,7 @@ void * __init boot_cpu_alloc(unsigned lo
 	BUG_ON(units_reserved > UNITS);
 	return (void *)(x * UNIT_SIZE);
 }
+#endif
 
 static int first_free;		/* First known free unit */
 EXPORT_SYMBOL(cpu_area);
@@ -99,6 +353,7 @@ void *cpu_alloc(unsigned long size, gfp_
 	int units = size_to_units(size);
 	void *ptr;
 	int first;
+	unsigned long map_size;
 	unsigned long flags;
 
 	BUG_ON(gfpflags & ~(GFP_RECLAIM_MASK | __GFP_ZERO));
@@ -110,16 +365,26 @@ void *cpu_alloc(unsigned long size, gfp_
 		 * No boot time allocations. Must have at least one
 		 * reserved unit to avoid returning a NULL pointer
 		 */
-		units_reserved = 1;
+		units++;
+
+
+restart:
+	if (cpu_alloc_map_order >= 0)
+		map_size = PAGE_SIZE << cpu_alloc_map_order;
+	else
+		map_size = 0;
 
 	first = 1;
 	start = first_free;
 
 	for ( ; ; ) {
 
-		start = find_next_zero_bit(cpu_alloc_map, ALLOC_SIZE, start);
-		if (start >= UNITS - units_reserved)
+		start = find_next_zero_bit(cpu_alloc_map, map_size, start);
+		if (start >= units_total - units_reserved) {
+			if (!expand_cpu_area(gfpflags))
+				goto restart;
 			goto out_of_memory;
+		}
 
 		if (first)
 			first_free = start;
@@ -129,7 +394,7 @@ void *cpu_alloc(unsigned long size, gfp_
 		 * the starting unit.
 		 */
 		if ((start + units_reserved) % (align / UNIT_SIZE) == 0 &&
-			find_next_bit(cpu_alloc_map, ALLOC_SIZE, start + 1)
+			find_next_bit(cpu_alloc_map, map_size, start + 1)
 							>= start + units)
 				break;
 		start++;
@@ -139,14 +404,19 @@ void *cpu_alloc(unsigned long size, gfp_
 	if (first)
 		first_free = start + units;
 
-	if (start + units > UNITS - units_reserved)
-		goto out_of_memory;
+	while (start + units > units_total - units_reserved) {
+		if (expand_cpu_area(gfpflags))
+			goto out_of_memory;
+	}
 
 	set_map(start, units);
 	__count_vm_events(CPU_BYTES, units * UNIT_SIZE);
 
 	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
 
+	if (!units_reserved)
+		units_reserved = 1;
+
 	ptr =  (void *)((start + units_reserved) * UNIT_SIZE);
 
 	if (gfpflags & __GFP_ZERO) {
@@ -178,7 +448,7 @@ void cpu_free(void *start, unsigned long
 	BUG_ON(p < units_reserved * UNIT_SIZE);
 	index = p / UNIT_SIZE - units_reserved;
 	BUG_ON(!test_bit(index, cpu_alloc_map) ||
-			index >= UNITS - units_reserved);
+			index >= units_total - units_reserved);
 
 	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
 
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-11-19 15:55:47.293389911 -0800
+++ linux-2.6/include/linux/mm.h	2007-11-19 15:55:48.805640240 -0800
@@ -1137,5 +1137,18 @@ int vmemmap_populate_basepages(struct pa
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
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig	2007-11-19 15:53:21.569140430 -0800
+++ linux-2.6/mm/Kconfig	2007-11-19 15:55:48.805640240 -0800
@@ -197,7 +197,13 @@ config VIRT_TO_BUS
 
 config CPU_AREA_ORDER
 	int "Maximum size (order) of CPU area"
-	default "3"
+	default "10" if CPU_AREA_VIRTUAL
+	default "3" if !CPU_AREA_VIRTUAL
 	help
 	  Sets the maximum amount of memory that can be allocated via cpu_alloc
-	  The size is set in page order, so 0 = PAGE_SIZE, 1 = PAGE_SIZE << 1 etc.
+	  The size is set in page order. The size set (times the maximum
+	  number of processors) determines the amount of virtual memory that
+	  is set aside for the per cpu areas for virtualized cpu areas or the
+	  amount of memory allocated in the bss segment for non virtualized
+	  cpu areas.
+

-- 
