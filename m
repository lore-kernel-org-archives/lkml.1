Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZCENLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZCENLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbZCENIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:08:45 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:39746 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbZCENIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:08:40 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/17] x86: move init_memory_mapping() to common mm/init.c
Date: Thu,  5 Mar 2009 14:55:05 +0200
Message-Id: <1236257708-27269-14-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

This patch moves the init_memory_mapping() function to common mm/init.c.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init.c    |  328 +++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_32.c |  308 +---------------------------------------------
 arch/x86/mm/init_64.c |  314 +---------------------------------------------
 3 files changed, 342 insertions(+), 608 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index cc7fe66..3a21b13 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -2,10 +2,338 @@
 #include <linux/swap.h>
 
 #include <asm/cacheflush.h>
+#include <asm/e820.h>
 #include <asm/page.h>
 #include <asm/page_types.h>
 #include <asm/sections.h>
 #include <asm/system.h>
+#include <asm/tlbflush.h>
+
+#ifdef CONFIG_X86_32
+extern void __init early_ioremap_page_table_range_init(void);
+extern void __init kernel_physical_mapping_init(unsigned long start_pfn,
+						unsigned long end_pfn,
+						int use_pse);
+#endif
+
+#ifdef CONFIG_X86_64
+extern unsigned long __meminit
+kernel_physical_mapping_init(unsigned long start,
+			     unsigned long end,
+			     unsigned long page_size_mask);
+#endif
+
+unsigned long __initdata table_start;
+unsigned long __meminitdata table_end;
+unsigned long __meminitdata table_top;
+
+int after_bootmem;
+
+int direct_gbpages
+#ifdef CONFIG_DIRECT_GBPAGES
+				= 1
+#endif
+;
+
+static void __init find_early_table_space(unsigned long end, int use_pse,
+					  int use_gbpages)
+{
+	unsigned long puds, pmds, ptes, tables, start;
+
+	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+
+	if (use_gbpages) {
+		unsigned long extra;
+
+		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
+		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+	} else
+		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+
+	if (use_pse) {
+		unsigned long extra;
+
+		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+#ifdef CONFIG_X86_32
+		extra += PMD_SIZE;
+#endif
+		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	} else
+		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
+	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
+
+#ifdef CONFIG_X86_32
+	/* for fixmap */
+	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+#endif
+
+	/*
+	 * RED-PEN putting page tables only on node 0 could
+	 * cause a hotspot and fill up ZONE_DMA. The page tables
+	 * need roughly 0.5KB per GB.
+	 */
+#ifdef CONFIG_X86_32
+	start = 0x7000;
+	table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
+					tables, PAGE_SIZE);
+#else /* CONFIG_X86_64 */
+	start = 0x8000;
+	table_start = find_e820_area(start, end, tables, PAGE_SIZE);
+#endif
+	if (table_start == -1UL)
+		panic("Cannot find space for the kernel page tables");
+
+	table_start >>= PAGE_SHIFT;
+	table_end = table_start;
+	table_top = table_start + (tables >> PAGE_SHIFT);
+
+	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
+		end, table_start << PAGE_SHIFT, table_top << PAGE_SHIFT);
+}
+
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+#ifdef CONFIG_X86_32
+#define NR_RANGE_MR 3
+#else /* CONFIG_X86_64 */
+#define NR_RANGE_MR 5
+#endif
+
+static int save_mr(struct map_range *mr, int nr_range,
+		   unsigned long start_pfn, unsigned long end_pfn,
+		   unsigned long page_size_mask)
+{
+	if (start_pfn < end_pfn) {
+		if (nr_range >= NR_RANGE_MR)
+			panic("run out of range for init_memory_mapping\n");
+		mr[nr_range].start = start_pfn<<PAGE_SHIFT;
+		mr[nr_range].end   = end_pfn<<PAGE_SHIFT;
+		mr[nr_range].page_size_mask = page_size_mask;
+		nr_range++;
+	}
+
+	return nr_range;
+}
+
+#ifdef CONFIG_X86_64
+static void __init init_gbpages(void)
+{
+	if (direct_gbpages && cpu_has_gbpages)
+		printk(KERN_INFO "Using GB pages for direct mapping\n");
+	else
+		direct_gbpages = 0;
+}
+#else
+static inline void init_gbpages(void)
+{
+}
+#endif
+
+/*
+ * Setup the direct mapping of the physical memory at PAGE_OFFSET.
+ * This runs before bootmem is initialized and gets pages directly from
+ * the physical memory. To access them they are temporarily mapped.
+ */
+unsigned long __init_refok init_memory_mapping(unsigned long start,
+					       unsigned long end)
+{
+	unsigned long page_size_mask = 0;
+	unsigned long start_pfn, end_pfn;
+	unsigned long pos;
+	unsigned long ret;
+
+	struct map_range mr[NR_RANGE_MR];
+	int nr_range, i;
+	int use_pse, use_gbpages;
+
+	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
+
+	if (!after_bootmem)
+		init_gbpages();
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/*
+	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * This will simplify cpa(), which otherwise needs to support splitting
+	 * large pages into small in interrupt context, etc.
+	 */
+	use_pse = use_gbpages = 0;
+#else
+	use_pse = cpu_has_pse;
+	use_gbpages = direct_gbpages;
+#endif
+
+#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_PAE
+	set_nx();
+	if (nx_enabled)
+		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
+#endif
+
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+#endif
+
+	if (use_gbpages)
+		page_size_mask |= 1 << PG_LEVEL_1G;
+	if (use_pse)
+		page_size_mask |= 1 << PG_LEVEL_2M;
+
+	memset(mr, 0, sizeof(mr));
+	nr_range = 0;
+
+	/* head if not big page alignment ? */
+	start_pfn = start >> PAGE_SHIFT;
+	pos = start_pfn << PAGE_SHIFT;
+#ifdef CONFIG_X86_32
+	/*
+	 * Don't use a large page for the first 2/4MB of memory
+	 * because there are often fixed size MTRRs in there
+	 * and overlapping MTRRs into large pages can cause
+	 * slowdowns.
+	 */
+	if (pos == 0)
+		end_pfn = 1<<(PMD_SHIFT - PAGE_SHIFT);
+	else
+		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
+				 << (PMD_SHIFT - PAGE_SHIFT);
+#else /* CONFIG_X86_64 */
+	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
+			<< (PMD_SHIFT - PAGE_SHIFT);
+#endif
+	if (end_pfn > (end >> PAGE_SHIFT))
+		end_pfn = end >> PAGE_SHIFT;
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+		pos = end_pfn << PAGE_SHIFT;
+	}
+
+	/* big page (2M) range */
+	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
+			 << (PMD_SHIFT - PAGE_SHIFT);
+#ifdef CONFIG_X86_32
+	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+#else /* CONFIG_X86_64 */
+	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
+			 << (PUD_SHIFT - PAGE_SHIFT);
+	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
+		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
+#endif
+
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+		pos = end_pfn << PAGE_SHIFT;
+	}
+
+#ifdef CONFIG_X86_64
+	/* big page (1G) range */
+	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
+			 << (PUD_SHIFT - PAGE_SHIFT);
+	end_pfn = (end >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask &
+				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
+		pos = end_pfn << PAGE_SHIFT;
+	}
+
+	/* tail is not big page (1G) alignment */
+	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
+			 << (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = (end >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+		pos = end_pfn << PAGE_SHIFT;
+	}
+#endif
+
+	/* tail is not big page (2M) alignment */
+	start_pfn = pos>>PAGE_SHIFT;
+	end_pfn = end>>PAGE_SHIFT;
+	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+
+	/* try to merge same page size and continuous */
+	for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
+		unsigned long old_start;
+		if (mr[i].end != mr[i+1].start ||
+		    mr[i].page_size_mask != mr[i+1].page_size_mask)
+			continue;
+		/* move it */
+		old_start = mr[i].start;
+		memmove(&mr[i], &mr[i+1],
+			(nr_range - 1 - i) * sizeof(struct map_range));
+		mr[i--].start = old_start;
+		nr_range--;
+	}
+
+	for (i = 0; i < nr_range; i++)
+		printk(KERN_DEBUG " %010lx - %010lx page %s\n",
+				mr[i].start, mr[i].end,
+			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
+			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
+
+	/*
+	 * Find space for the kernel direct mapping tables.
+	 *
+	 * Later we should allocate these tables in the local node of the
+	 * memory mapped. Unfortunately this is done currently before the
+	 * nodes are discovered.
+	 */
+	if (!after_bootmem)
+		find_early_table_space(end, use_pse, use_gbpages);
+
+#ifdef CONFIG_X86_32
+	for (i = 0; i < nr_range; i++)
+		kernel_physical_mapping_init(
+				mr[i].start >> PAGE_SHIFT,
+				mr[i].end >> PAGE_SHIFT,
+				mr[i].page_size_mask == (1<<PG_LEVEL_2M));
+	ret = end;
+#else /* CONFIG_X86_64 */
+	for (i = 0; i < nr_range; i++)
+		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
+						   mr[i].page_size_mask);
+#endif
+
+#ifdef CONFIG_X86_32
+	early_ioremap_page_table_range_init();
+
+	load_cr3(swapper_pg_dir);
+#endif
+
+#ifdef CONFIG_X86_64
+	if (!after_bootmem)
+		mmu_cr4_features = read_cr4();
+#endif
+	__flush_tlb_all();
+
+	if (!after_bootmem && table_end > table_start)
+		reserve_early(table_start << PAGE_SHIFT,
+				 table_end << PAGE_SHIFT, "PGTABLE");
+
+	if (!after_bootmem)
+		early_memtest(start, end);
+
+	return ret >> PAGE_SHIFT;
+}
+
 
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index cd3c24b..187522a 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -59,13 +59,9 @@ unsigned long highstart_pfn, highend_pfn;
 static noinline int do_test_wp_bit(void);
 
 
-static unsigned long __initdata table_start;
-static unsigned long __meminitdata table_end;
-static unsigned long __meminitdata table_top;
-
-int after_bootmem;
-
-int direct_gbpages;
+extern unsigned long __initdata table_start;
+extern unsigned long __meminitdata table_end;
+extern unsigned long __meminitdata table_top;
 
 static __init void *alloc_low_page(void)
 {
@@ -227,9 +223,9 @@ static inline int is_kernel_text(unsigned long addr)
  * of max_low_pfn pages, by creating page tables starting from address
  * PAGE_OFFSET:
  */
-static void __init kernel_physical_mapping_init(unsigned long start_pfn,
-						unsigned long end_pfn,
-						int use_pse)
+void __init kernel_physical_mapping_init(unsigned long start_pfn,
+					 unsigned long end_pfn,
+					 int use_pse)
 {
 	pgd_t *pgd_base = swapper_pg_dir;
 	int pgd_idx, pmd_idx, pte_ofs;
@@ -509,7 +505,7 @@ void __init native_pagetable_setup_done(pgd_t *base)
  * be partially populated, and so it avoids stomping on any existing
  * mappings.
  */
-static void __init early_ioremap_page_table_range_init(void)
+void __init early_ioremap_page_table_range_init(void)
 {
 	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long vaddr, end;
@@ -834,296 +830,6 @@ void __init setup_bootmem_allocator(void)
 	after_bootmem = 1;
 }
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
-{
-	unsigned long puds, pmds, ptes, tables, start;
-
-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
-
-	if (use_gbpages) {
-		unsigned long extra;
-
-		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
-		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-
-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
-
-	if (use_pse) {
-		unsigned long extra;
-
-		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
-#ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
-#endif
-		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	} else
-		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
-
-	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
-
-#ifdef CONFIG_X86_32
-	/* for fixmap */
-	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
-
-	/*
-	 * RED-PEN putting page tables only on node 0 could
-	 * cause a hotspot and fill up ZONE_DMA. The page tables
-	 * need roughly 0.5KB per GB.
-	 */
-#ifdef CONFIG_X86_32
-	start = 0x7000;
-	table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
-					tables, PAGE_SIZE);
-#else /* CONFIG_X86_64 */
-	start = 0x8000;
-	table_start = find_e820_area(start, end, tables, PAGE_SIZE);
-#endif
-	if (table_start == -1UL)
-		panic("Cannot find space for the kernel page tables");
-
-	table_start >>= PAGE_SHIFT;
-	table_end = table_start;
-	table_top = table_start + (tables >> PAGE_SHIFT);
-
-	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, table_start << PAGE_SHIFT, table_top << PAGE_SHIFT);
-}
-
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
-
-#ifdef CONFIG_X86_32
-#define NR_RANGE_MR 3
-#else /* CONFIG_X86_64 */
-#define NR_RANGE_MR 5
-#endif
-
-static int save_mr(struct map_range *mr, int nr_range,
-		   unsigned long start_pfn, unsigned long end_pfn,
-		   unsigned long page_size_mask)
-{
-	if (start_pfn < end_pfn) {
-		if (nr_range >= NR_RANGE_MR)
-			panic("run out of range for init_memory_mapping\n");
-		mr[nr_range].start = start_pfn<<PAGE_SHIFT;
-		mr[nr_range].end   = end_pfn<<PAGE_SHIFT;
-		mr[nr_range].page_size_mask = page_size_mask;
-		nr_range++;
-	}
-
-	return nr_range;
-}
-
-static inline void init_gbpages(void)
-{
-}
-
-/*
- * Setup the direct mapping of the physical memory at PAGE_OFFSET.
- * This runs before bootmem is initialized and gets pages directly from
- * the physical memory. To access them they are temporarily mapped.
- */
-unsigned long __init_refok init_memory_mapping(unsigned long start,
-					       unsigned long end)
-{
-	unsigned long page_size_mask = 0;
-	unsigned long start_pfn, end_pfn;
-	unsigned long pos;
-	unsigned long ret;
-
-	struct map_range mr[NR_RANGE_MR];
-	int nr_range, i;
-	int use_pse, use_gbpages;
-
-	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
-
-	if (!after_bootmem)
-		init_gbpages();
-
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	/*
-	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
-	 * This will simplify cpa(), which otherwise needs to support splitting
-	 * large pages into small in interrupt context, etc.
-	 */
-	use_pse = use_gbpages = 0;
-#else
-	use_pse = cpu_has_pse;
-	use_gbpages = direct_gbpages;
-#endif
-
-#ifdef CONFIG_X86_32
-#ifdef CONFIG_X86_PAE
-	set_nx();
-	if (nx_enabled)
-		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
-#endif
-
-	/* Enable PSE if available */
-	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
-
-	/* Enable PGE if available */
-	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
-		__supported_pte_mask |= _PAGE_GLOBAL;
-	}
-#endif
-
-	if (use_gbpages)
-		page_size_mask |= 1 << PG_LEVEL_1G;
-	if (use_pse)
-		page_size_mask |= 1 << PG_LEVEL_2M;
-
-	memset(mr, 0, sizeof(mr));
-	nr_range = 0;
-
-	/* head if not big page alignment ? */
-	start_pfn = start >> PAGE_SHIFT;
-	pos = start_pfn << PAGE_SHIFT;
-#ifdef CONFIG_X86_32
-	/*
-	 * Don't use a large page for the first 2/4MB of memory
-	 * because there are often fixed size MTRRs in there
-	 * and overlapping MTRRs into large pages can cause
-	 * slowdowns.
-	 */
-	if (pos == 0)
-		end_pfn = 1<<(PMD_SHIFT - PAGE_SHIFT);
-	else
-		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-				 << (PMD_SHIFT - PAGE_SHIFT);
-#else /* CONFIG_X86_64 */
-	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
-			<< (PMD_SHIFT - PAGE_SHIFT);
-#endif
-	if (end_pfn > (end >> PAGE_SHIFT))
-		end_pfn = end >> PAGE_SHIFT;
-	if (start_pfn < end_pfn) {
-		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
-		pos = end_pfn << PAGE_SHIFT;
-	}
-
-	/* big page (2M) range */
-	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-			 << (PMD_SHIFT - PAGE_SHIFT);
-#ifdef CONFIG_X86_32
-	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
-#else /* CONFIG_X86_64 */
-	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
-			 << (PUD_SHIFT - PAGE_SHIFT);
-	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
-		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
-#endif
-
-	if (start_pfn < end_pfn) {
-		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = end_pfn << PAGE_SHIFT;
-	}
-
-#ifdef CONFIG_X86_64
-	/* big page (1G) range */
-	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
-			 << (PUD_SHIFT - PAGE_SHIFT);
-	end_pfn = (end >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
-	if (start_pfn < end_pfn) {
-		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-				page_size_mask &
-				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
-		pos = end_pfn << PAGE_SHIFT;
-	}
-
-	/* tail is not big page (1G) alignment */
-	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-			 << (PMD_SHIFT - PAGE_SHIFT);
-	end_pfn = (end >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
-	if (start_pfn < end_pfn) {
-		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = end_pfn << PAGE_SHIFT;
-	}
-#endif
-
-	/* tail is not big page (2M) alignment */
-	start_pfn = pos>>PAGE_SHIFT;
-	end_pfn = end>>PAGE_SHIFT;
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
-
-	/* try to merge same page size and continuous */
-	for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
-		unsigned long old_start;
-		if (mr[i].end != mr[i+1].start ||
-		    mr[i].page_size_mask != mr[i+1].page_size_mask)
-			continue;
-		/* move it */
-		old_start = mr[i].start;
-		memmove(&mr[i], &mr[i+1],
-			(nr_range - 1 - i) * sizeof(struct map_range));
-		mr[i--].start = old_start;
-		nr_range--;
-	}
-
-	for (i = 0; i < nr_range; i++)
-		printk(KERN_DEBUG " %010lx - %010lx page %s\n",
-				mr[i].start, mr[i].end,
-			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
-			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
-
-	/*
-	 * Find space for the kernel direct mapping tables.
-	 *
-	 * Later we should allocate these tables in the local node of the
-	 * memory mapped. Unfortunately this is done currently before the
-	 * nodes are discovered.
-	 */
-	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
-
-#ifdef CONFIG_X86_32
-	for (i = 0; i < nr_range; i++)
-		kernel_physical_mapping_init(
-				mr[i].start >> PAGE_SHIFT,
-				mr[i].end >> PAGE_SHIFT,
-				mr[i].page_size_mask == (1<<PG_LEVEL_2M));
-	ret = end;
-#else /* CONFIG_X86_64 */
-	for (i = 0; i < nr_range; i++)
-		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
-						   mr[i].page_size_mask);
-#endif
-
-#ifdef CONFIG_X86_32
-	early_ioremap_page_table_range_init();
-
-	load_cr3(swapper_pg_dir);
-#endif
-
-#ifdef CONFIG_X86_64
-	if (!after_bootmem)
-		mmu_cr4_features = read_cr4();
-#endif
-	__flush_tlb_all();
-
-	if (!after_bootmem && table_end > table_start)
-		reserve_early(table_start << PAGE_SHIFT,
-				 table_end << PAGE_SHIFT, "PGTABLE");
-
-	if (!after_bootmem)
-		early_memtest(start, end);
-
-	return ret >> PAGE_SHIFT;
-}
-
-
 /*
  * paging_init() sets up the page tables - note that the first 8MB are
  * already mapped by head.S.
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d101990..a32fe07 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -61,12 +61,6 @@ static unsigned long dma_reserve __initdata;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-int direct_gbpages
-#ifdef CONFIG_DIRECT_GBPAGES
-				= 1
-#endif
-;
-
 static int __init parse_direct_gbpages_off(char *arg)
 {
 	direct_gbpages = 0;
@@ -87,8 +81,6 @@ early_param("gbpages", parse_direct_gbpages_on);
  * around without checking the pgd every time.
  */
 
-int after_bootmem;
-
 pteval_t __supported_pte_mask __read_mostly = ~_PAGE_IOMAP;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
@@ -291,9 +283,9 @@ void __init cleanup_highmap(void)
 	}
 }
 
-static unsigned long __initdata table_start;
-static unsigned long __meminitdata table_end;
-static unsigned long __meminitdata table_top;
+extern unsigned long __initdata table_start;
+extern unsigned long __meminitdata table_end;
+extern unsigned long __meminitdata table_top;
 
 static __ref void *alloc_low_page(unsigned long *phys)
 {
@@ -547,77 +539,10 @@ phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end,
 	return phys_pud_init(pud, addr, end, page_size_mask);
 }
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
-{
-	unsigned long puds, pmds, ptes, tables, start;
-
-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
-
-	if (use_gbpages) {
-		unsigned long extra;
-
-		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
-		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-
-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
-
-	if (use_pse) {
-		unsigned long extra;
-
-		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
-#ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
-#endif
-		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	} else
-		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
-
-	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
-
-#ifdef CONFIG_X86_32
-	/* for fixmap */
-	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
-
-	/*
-	 * RED-PEN putting page tables only on node 0 could
-	 * cause a hotspot and fill up ZONE_DMA. The page tables
-	 * need roughly 0.5KB per GB.
-	 */
-#ifdef CONFIG_X86_32
-	start = 0x7000;
-	table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
-					tables, PAGE_SIZE);
-#else /* CONFIG_X86_64 */
-	start = 0x8000;
-	table_start = find_e820_area(start, end, tables, PAGE_SIZE);
-#endif
-	if (table_start == -1UL)
-		panic("Cannot find space for the kernel page tables");
-
-	table_start >>= PAGE_SHIFT;
-	table_end = table_start;
-	table_top = table_start + (tables >> PAGE_SHIFT);
-
-	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, table_start << PAGE_SHIFT, table_top << PAGE_SHIFT);
-}
-
-static void __init init_gbpages(void)
-{
-	if (direct_gbpages && cpu_has_gbpages)
-		printk(KERN_INFO "Using GB pages for direct mapping\n");
-	else
-		direct_gbpages = 0;
-}
-
-static unsigned long __meminit kernel_physical_mapping_init(unsigned long start,
-						unsigned long end,
-						unsigned long page_size_mask)
+unsigned long __meminit
+kernel_physical_mapping_init(unsigned long start,
+			     unsigned long end,
+			     unsigned long page_size_mask)
 {
 
 	unsigned long next, last_map_addr = end;
@@ -654,231 +579,6 @@ static unsigned long __meminit kernel_physical_mapping_init(unsigned long start,
 	return last_map_addr;
 }
 
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
-
-#ifdef CONFIG_X86_32
-#define NR_RANGE_MR 3
-#else /* CONFIG_X86_64 */
-#define NR_RANGE_MR 5
-#endif
-
-static int save_mr(struct map_range *mr, int nr_range,
-		   unsigned long start_pfn, unsigned long end_pfn,
-		   unsigned long page_size_mask)
-{
-	if (start_pfn < end_pfn) {
-		if (nr_range >= NR_RANGE_MR)
-			panic("run out of range for init_memory_mapping\n");
-		mr[nr_range].start = start_pfn<<PAGE_SHIFT;
-		mr[nr_range].end   = end_pfn<<PAGE_SHIFT;
-		mr[nr_range].page_size_mask = page_size_mask;
-		nr_range++;
-	}
-
-	return nr_range;
-}
-
-/*
- * Setup the direct mapping of the physical memory at PAGE_OFFSET.
- * This runs before bootmem is initialized and gets pages directly from
- * the physical memory. To access them they are temporarily mapped.
- */
-unsigned long __init_refok init_memory_mapping(unsigned long start,
-					       unsigned long end)
-{
-	unsigned long page_size_mask = 0;
-	unsigned long start_pfn, end_pfn;
-	unsigned long pos;
-	unsigned long ret;
-
-	struct map_range mr[NR_RANGE_MR];
-	int nr_range, i;
-	int use_pse, use_gbpages;
-
-	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
-
-	if (!after_bootmem)
-		init_gbpages();
-
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	/*
-	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
-	 * This will simplify cpa(), which otherwise needs to support splitting
-	 * large pages into small in interrupt context, etc.
-	 */
-	use_pse = use_gbpages = 0;
-#else
-	use_pse = cpu_has_pse;
-	use_gbpages = direct_gbpages;
-#endif
-
-#ifdef CONFIG_X86_32
-#ifdef CONFIG_X86_PAE
-	set_nx();
-	if (nx_enabled)
-		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
-#endif
-
-	/* Enable PSE if available */
-	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
-
-	/* Enable PGE if available */
-	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
-		__supported_pte_mask |= _PAGE_GLOBAL;
-	}
-#endif
-
-	if (use_gbpages)
-		page_size_mask |= 1 << PG_LEVEL_1G;
-	if (use_pse)
-		page_size_mask |= 1 << PG_LEVEL_2M;
-
-	memset(mr, 0, sizeof(mr));
-	nr_range = 0;
-
-	/* head if not big page alignment ? */
-	start_pfn = start >> PAGE_SHIFT;
-	pos = start_pfn << PAGE_SHIFT;
-#ifdef CONFIG_X86_32
-	/*
-	 * Don't use a large page for the first 2/4MB of memory
-	 * because there are often fixed size MTRRs in there
-	 * and overlapping MTRRs into large pages can cause
-	 * slowdowns.
-	 */
-	if (pos == 0)
-		end_pfn = 1<<(PMD_SHIFT - PAGE_SHIFT);
-	else
-		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-				 << (PMD_SHIFT - PAGE_SHIFT);
-#else /* CONFIG_X86_64 */
-	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
-			<< (PMD_SHIFT - PAGE_SHIFT);
-#endif
-	if (end_pfn > (end >> PAGE_SHIFT))
-		end_pfn = end >> PAGE_SHIFT;
-	if (start_pfn < end_pfn) {
-		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
-		pos = end_pfn << PAGE_SHIFT;
-	}
-
-	/* big page (2M) range */
-	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-			 << (PMD_SHIFT - PAGE_SHIFT);
-#ifdef CONFIG_X86_32
-	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
-#else /* CONFIG_X86_64 */
-	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
-			 << (PUD_SHIFT - PAGE_SHIFT);
-	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
-		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
-#endif
-
-	if (start_pfn < end_pfn) {
-		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = end_pfn << PAGE_SHIFT;
-	}
-
-#ifdef CONFIG_X86_64
-	/* big page (1G) range */
-	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
-			 << (PUD_SHIFT - PAGE_SHIFT);
-	end_pfn = (end >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
-	if (start_pfn < end_pfn) {
-		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-				page_size_mask &
-				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
-		pos = end_pfn << PAGE_SHIFT;
-	}
-
-	/* tail is not big page (1G) alignment */
-	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-			 << (PMD_SHIFT - PAGE_SHIFT);
-	end_pfn = (end >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
-	if (start_pfn < end_pfn) {
-		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = end_pfn << PAGE_SHIFT;
-	}
-#endif
-
-	/* tail is not big page (2M) alignment */
-	start_pfn = pos>>PAGE_SHIFT;
-	end_pfn = end>>PAGE_SHIFT;
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
-
-	/* try to merge same page size and continuous */
-	for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
-		unsigned long old_start;
-		if (mr[i].end != mr[i+1].start ||
-		    mr[i].page_size_mask != mr[i+1].page_size_mask)
-			continue;
-		/* move it */
-		old_start = mr[i].start;
-		memmove(&mr[i], &mr[i+1],
-			(nr_range - 1 - i) * sizeof(struct map_range));
-		mr[i--].start = old_start;
-		nr_range--;
-	}
-
-	for (i = 0; i < nr_range; i++)
-		printk(KERN_DEBUG " %010lx - %010lx page %s\n",
-				mr[i].start, mr[i].end,
-			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
-			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
-
-	/*
-	 * Find space for the kernel direct mapping tables.
-	 *
-	 * Later we should allocate these tables in the local node of the
-	 * memory mapped. Unfortunately this is done currently before the
-	 * nodes are discovered.
-	 */
-	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
-
-#ifdef CONFIG_X86_32
-	for (i = 0; i < nr_range; i++)
-		kernel_physical_mapping_init(
-				mr[i].start >> PAGE_SHIFT,
-				mr[i].end >> PAGE_SHIFT,
-				mr[i].page_size_mask == (1<<PG_LEVEL_2M));
-	ret = end;
-#else /* CONFIG_X86_64 */
-	for (i = 0; i < nr_range; i++)
-		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
-						   mr[i].page_size_mask);
-#endif
-
-#ifdef CONFIG_X86_32
-	early_ioremap_page_table_range_init();
-
-	load_cr3(swapper_pg_dir);
-#endif
-
-#ifdef CONFIG_X86_64
-	if (!after_bootmem)
-		mmu_cr4_features = read_cr4();
-#endif
-	__flush_tlb_all();
-
-	if (!after_bootmem && table_end > table_start)
-		reserve_early(table_start << PAGE_SHIFT,
-				 table_end << PAGE_SHIFT, "PGTABLE");
-
-	if (!after_bootmem)
-		early_memtest(start, end);
-
-	return ret >> PAGE_SHIFT;
-}
-
 #ifndef CONFIG_NUMA
 void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 {
-- 
1.5.4.3

