Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab0BJJ0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:26:23 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39151 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0BJJV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:21:56 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 10 Feb 2010 01:20:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 16/35] x86: make 64 bit use early_res instead of bootmem before
 slab
In-reply-to: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265793639-15071-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

finally we can use early_res to replace bootmem for x86_64 now.

still can use CONFIG_NO_BOOTMEM to enable it or not

-v2: fix 32bit compiling about MAX_DMA32_PFN

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig            |   13 +++
 arch/x86/include/asm/e820.h |    6 ++
 arch/x86/kernel/e820.c      |  159 ++++++++++++++++++++++++++++++++---
 arch/x86/kernel/setup.c     |    2 +
 arch/x86/mm/init_64.c       |    5 +-
 arch/x86/mm/numa_64.c       |   20 ++++-
 include/linux/bootmem.h     |    7 ++
 include/linux/mm.h          |    5 +
 include/linux/mmzone.h      |    2 +
 mm/bootmem.c                |  195 ++++++++++++++++++++++++++++++++++++++++++-
 mm/page_alloc.c             |   59 +++++++++++++-
 mm/percpu.c                 |    3 +
 mm/sparse-vmemmap.c         |    2 +-
 13 files changed, 454 insertions(+), 24 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb40925..9543984 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -568,6 +568,19 @@ config PARAVIRT_DEBUG
 	  Enable to debug paravirt_ops internals.  Specifically, BUG if
 	  a paravirt_op is missing when it is called.
 
+config NO_BOOTMEM
+	default y
+	bool "Disable Bootmem code"
+	depends on X86_64
+	---help---
+	  Use early_res directly instead of bootmem before slab is ready.
+		- allocator (buddy) [generic]
+		- early allocator (bootmem) [generic]
+		- very early allocator (reserve_early*()) [x86]
+		- very very early allocator (early brk model) [x86]
+	  So reduce one layer between early allocator to final allocator
+
+
 config MEMTEST
 	bool "Memtest"
 	---help---
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 761249e..7d72e5f 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -117,6 +117,12 @@ extern void free_early(u64 start, u64 end);
 extern void early_res_to_bootmem(u64 start, u64 end);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 
+void reserve_early_without_check(u64 start, u64 end, char *name);
+u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+			 u64 size, u64 align);
+#include <linux/range.h>
+int get_free_all_memory_range(struct range **rangep, int nodeid);
+
 extern unsigned long e820_end_of_ram_pfn(void);
 extern unsigned long e820_end_of_low_ram_pfn(void);
 extern int e820_find_active_region(const struct e820entry *ei,
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index e09c18c..90a8529 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -977,6 +977,25 @@ void __init reserve_early(u64 start, u64 end, char *name)
 	__reserve_early(start, end, name, 0);
 }
 
+void __init reserve_early_without_check(u64 start, u64 end, char *name)
+{
+	struct early_res *r;
+
+	if (start >= end)
+		return;
+
+	__check_and_double_early_res(end);
+
+	r = &early_res[early_res_count];
+
+	r->start = start;
+	r->end = end;
+	r->overlap_ok = 0;
+	if (name)
+		strncpy(r->name, name, sizeof(r->name) - 1);
+	early_res_count++;
+}
+
 void __init free_early(u64 start, u64 end)
 {
 	struct early_res *r;
@@ -991,6 +1010,94 @@ void __init free_early(u64 start, u64 end)
 	drop_range(i);
 }
 
+#ifdef CONFIG_NO_BOOTMEM
+static void __init subtract_early_res(struct range *range, int az)
+{
+	int i, count;
+	u64 final_start, final_end;
+	int idx = 0;
+
+	count  = 0;
+	for (i = 0; i < max_early_res && early_res[i].end; i++)
+		count++;
+
+	/* need to skip first one ?*/
+	if (early_res != early_res_x)
+		idx = 1;
+
+#if 1
+	printk(KERN_INFO "Subtract (%d early reservations)\n", count);
+#endif
+	for (i = idx; i < count; i++) {
+		struct early_res *r = &early_res[i];
+#if 0
+		printk(KERN_INFO "  #%d [%010llx - %010llx] %15s", i,
+			r->start, r->end, r->name);
+#endif
+		final_start = PFN_DOWN(r->start);
+		final_end = PFN_UP(r->end);
+		if (final_start >= final_end) {
+#if 0
+			printk(KERN_CONT "\n");
+#endif
+			continue;
+		}
+#if 0
+		printk(KERN_CONT " subtract pfn [%010llx - %010llx]\n",
+			final_start, final_end);
+#endif
+		subtract_range(range, az, final_start, final_end);
+	}
+
+}
+
+int __init get_free_all_memory_range(struct range **rangep, int nodeid)
+{
+	int i, count;
+	u64 start = 0, end;
+	u64 size;
+	u64 mem;
+	struct range *range;
+	int nr_range;
+
+	count  = 0;
+	for (i = 0; i < max_early_res && early_res[i].end; i++)
+		count++;
+
+	count *= 2;
+
+	size = sizeof(struct range) * count;
+#ifdef MAX_DMA32_PFN
+	if (max_pfn_mapped > MAX_DMA32_PFN)
+		start = MAX_DMA32_PFN << PAGE_SHIFT;
+#endif
+	end = max_pfn_mapped << PAGE_SHIFT;
+	mem = find_e820_area(start, end, size, sizeof(struct range));
+	if (mem == -1ULL)
+		panic("can not find more space for range free");
+
+	range = __va(mem);
+	/* use early_node_map[] and early_res to get range array at first */
+	memset(range, 0, size);
+	nr_range = 0;
+
+	/* need to go over early_node_map to find out good range for node */
+	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
+	subtract_early_res(range, count);
+	nr_range = clean_sort_range(range, count);
+
+	/* need to clear it ? */
+	if (nodeid == MAX_NUMNODES) {
+		memset(&early_res[0], 0,
+			 sizeof(struct early_res) * max_early_res);
+		early_res = NULL;
+		max_early_res = 0;
+	}
+
+	*rangep = range;
+	return nr_range;
+}
+#else
 void __init early_res_to_bootmem(u64 start, u64 end)
 {
 	int i, count;
@@ -1028,6 +1135,7 @@ void __init early_res_to_bootmem(u64 start, u64 end)
 	max_early_res = 0;
 	early_res_count = 0;
 }
+#endif
 
 /* Check for already reserved areas */
 static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
@@ -1083,6 +1191,35 @@ again:
 
 /*
  * Find a free area with specified alignment in a specific range.
+ * only with the area.between start to end is active range from early_node_map
+ * so they are good as RAM
+ */
+u64 __init find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+			 u64 size, u64 align)
+{
+	u64 addr, last;
+
+	addr = round_up(ei_start, align);
+	if (addr < start)
+		addr = round_up(start, align);
+	if (addr >= ei_last)
+		goto out;
+	while (bad_addr(&addr, size, align) && addr+size <= ei_last)
+		;
+	last = addr + size;
+	if (last > ei_last)
+		goto out;
+	if (last > end)
+		goto out;
+
+	return addr;
+
+out:
+	return -1ULL;
+}
+
+/*
+ * Find a free area with specified alignment in a specific range.
  */
 u64 __init find_e820_area(u64 start, u64 end, u64 size, u64 align)
 {
@@ -1090,24 +1227,20 @@ u64 __init find_e820_area(u64 start, u64 end, u64 size, u64 align)
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
-		u64 addr, last;
-		u64 ei_last;
+		u64 addr;
+		u64 ei_start, ei_last;
 
 		if (ei->type != E820_RAM)
 			continue;
-		addr = round_up(ei->addr, align);
+
 		ei_last = ei->addr + ei->size;
-		if (addr < start)
-			addr = round_up(start, align);
-		if (addr >= ei_last)
-			continue;
-		while (bad_addr(&addr, size, align) && addr+size <= ei_last)
-			;
-		last = addr + size;
-		if (last > ei_last)
-			continue;
-		if (last > end)
+		ei_start = ei->addr;
+		addr = find_early_area(ei_start, ei_last, start, end,
+					 size, align);
+
+		if (addr == -1ULL)
 			continue;
+
 		return addr;
 	}
 	return -1ULL;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ea4141b..d49e168 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -967,7 +967,9 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	initmem_init(0, max_pfn, acpi, k8);
+#ifndef CONFIG_NO_BOOTMEM
 	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
+#endif
 
 	dma32_reserve_bootmem();
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a15abaa..fd9a004 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -572,6 +572,7 @@ kernel_physical_mapping_init(unsigned long start,
 void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 				int acpi, int k8)
 {
+#ifndef CONFIG_NO_BOOTMEM
 	unsigned long bootmap_size, bootmap;
 
 	bootmap_size = bootmem_bootmap_pages(end_pfn)<<PAGE_SHIFT;
@@ -583,8 +584,10 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	/* don't touch min_low_pfn */
 	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
 					 0, end_pfn);
-	e820_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
+#else
+	e820_register_active_regions(0, start_pfn, end_pfn);
+#endif
 }
 #endif
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 02f13cb..a20e170 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -198,11 +198,13 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 void __init
 setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 {
-	unsigned long start_pfn, last_pfn, bootmap_pages, bootmap_size;
+	unsigned long start_pfn, last_pfn, nodedata_phys;
 	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
-	unsigned long bootmap_start, nodedata_phys;
-	void *bootmap;
 	int nid;
+#ifndef CONFIG_NO_BOOTMEM
+	unsigned long bootmap_start, bootmap_pages, bootmap_size;
+	void *bootmap;
+#endif
 
 	if (!end)
 		return;
@@ -216,7 +218,7 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 
 	start = roundup(start, ZONE_ALIGN);
 
-	printk(KERN_INFO "Bootmem setup node %d %016lx-%016lx\n", nodeid,
+	printk(KERN_INFO "Initmem setup node %d %016lx-%016lx\n", nodeid,
 	       start, end);
 
 	start_pfn = start >> PAGE_SHIFT;
@@ -235,10 +237,13 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nodeid, nid);
 
 	memset(NODE_DATA(nodeid), 0, sizeof(pg_data_t));
-	NODE_DATA(nodeid)->bdata = &bootmem_node_data[nodeid];
+	NODE_DATA(nodeid)->node_id = nodeid;
 	NODE_DATA(nodeid)->node_start_pfn = start_pfn;
 	NODE_DATA(nodeid)->node_spanned_pages = last_pfn - start_pfn;
 
+#ifndef CONFIG_NO_BOOTMEM
+	NODE_DATA(nodeid)->bdata = &bootmem_node_data[nodeid];
+
 	/*
 	 * Find a place for the bootmem map
 	 * nodedata_phys could be on other nodes by alloc_bootmem,
@@ -275,6 +280,7 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 		printk(KERN_INFO "    bootmap(%d) on node %d\n", nodeid, nid);
 
 	free_bootmem_with_active_regions(nodeid, end);
+#endif
 
 	node_set_online(nodeid);
 }
@@ -733,6 +739,10 @@ unsigned long __init numa_free_all_bootmem(void)
 	for_each_online_node(i)
 		pages += free_all_bootmem_node(NODE_DATA(i));
 
+#ifdef CONFIG_NO_BOOTMEM
+	pages += free_all_memory_core_early(MAX_NUMNODES);
+#endif
+
 	return pages;
 }
 
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index b10ec49..266ab92 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -23,6 +23,7 @@ extern unsigned long max_pfn;
 extern unsigned long saved_max_pfn;
 #endif
 
+#ifndef CONFIG_NO_BOOTMEM
 /*
  * node_bootmem_map is a map pointer - the bits represent all physical 
  * memory pages (including holes) on the node.
@@ -37,6 +38,7 @@ typedef struct bootmem_data {
 } bootmem_data_t;
 
 extern bootmem_data_t bootmem_node_data[];
+#endif
 
 extern unsigned long bootmem_bootmap_pages(unsigned long);
 
@@ -46,6 +48,7 @@ extern unsigned long init_bootmem_node(pg_data_t *pgdat,
 				       unsigned long endpfn);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 
+unsigned long free_all_memory_core_early(int nodeid);
 extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
 extern unsigned long free_all_bootmem(void);
 
@@ -84,6 +87,10 @@ extern void *__alloc_bootmem_node(pg_data_t *pgdat,
 				  unsigned long size,
 				  unsigned long align,
 				  unsigned long goal);
+void *__alloc_bootmem_node_high(pg_data_t *pgdat,
+				  unsigned long size,
+				  unsigned long align,
+				  unsigned long goal);
 extern void *__alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 				  unsigned long size,
 				  unsigned long align,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8b2fa85..f2c5b3c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -12,6 +12,7 @@
 #include <linux/prio_tree.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
+#include <linux/range.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1049,6 +1050,10 @@ extern void get_pfn_range_for_nid(unsigned int nid,
 extern unsigned long find_min_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
+int add_from_early_node_map(struct range *range, int az,
+				   int nr_range, int nid);
+void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
+				 u64 goal, u64 limit);
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
 extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 30fe668..eae8387 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -620,7 +620,9 @@ typedef struct pglist_data {
 	struct page_cgroup *node_page_cgroup;
 #endif
 #endif
+#ifndef CONFIG_NO_BOOTMEM
 	struct bootmem_data *bdata;
+#endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/*
 	 * Must be held any time you expect node_start_pfn, node_present_pages
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 7d14868..d7c791e 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -13,6 +13,7 @@
 #include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/kmemleak.h>
+#include <linux/range.h>
 
 #include <asm/bug.h>
 #include <asm/io.h>
@@ -32,6 +33,7 @@ unsigned long max_pfn;
 unsigned long saved_max_pfn;
 #endif
 
+#ifndef CONFIG_NO_BOOTMEM
 bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
 
 static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
@@ -142,7 +144,7 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 	min_low_pfn = start;
 	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
 }
-
+#endif
 /*
  * free_bootmem_late - free bootmem pages directly to page allocator
  * @addr: starting address of the range
@@ -167,6 +169,60 @@ void __init free_bootmem_late(unsigned long addr, unsigned long size)
 	}
 }
 
+#ifdef CONFIG_NO_BOOTMEM
+static void __init __free_pages_memory(unsigned long start, unsigned long end)
+{
+	int i;
+	unsigned long start_aligned, end_aligned;
+	int order = ilog2(BITS_PER_LONG);
+
+	start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);
+	end_aligned = end & ~(BITS_PER_LONG - 1);
+
+	if (end_aligned <= start_aligned) {
+#if 1
+		printk(KERN_DEBUG " %lx - %lx\n", start, end);
+#endif
+		for (i = start; i < end; i++)
+			__free_pages_bootmem(pfn_to_page(i), 0);
+
+		return;
+	}
+
+#if 1
+	printk(KERN_DEBUG " %lx %lx - %lx %lx\n",
+		 start, start_aligned, end_aligned, end);
+#endif
+	for (i = start; i < start_aligned; i++)
+		__free_pages_bootmem(pfn_to_page(i), 0);
+
+	for (i = start_aligned; i < end_aligned; i += BITS_PER_LONG)
+		__free_pages_bootmem(pfn_to_page(i), order);
+
+	for (i = end_aligned; i < end; i++)
+		__free_pages_bootmem(pfn_to_page(i), 0);
+}
+
+unsigned long __init free_all_memory_core_early(int nodeid)
+{
+	int i;
+	u64 start, end;
+	unsigned long count = 0;
+	struct range *range = NULL;
+	int nr_range;
+
+	nr_range = get_free_all_memory_range(&range, nodeid);
+
+	for (i = 0; i < nr_range; i++) {
+		start = range[i].start;
+		end = range[i].end;
+		count += end - start;
+		__free_pages_memory(start, end);
+	}
+
+	return count;
+}
+#else
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	int aligned;
@@ -227,6 +283,7 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 
 	return count;
 }
+#endif
 
 /**
  * free_all_bootmem_node - release a node's free pages to the buddy allocator
@@ -237,7 +294,12 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
+#ifdef CONFIG_NO_BOOTMEM
+	/* free_all_memory_core_early(MAX_NUMNODES) will be called later */
+	return 0;
+#else
 	return free_all_bootmem_core(pgdat->bdata);
+#endif
 }
 
 /**
@@ -247,9 +309,14 @@ unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
  */
 unsigned long __init free_all_bootmem(void)
 {
+#ifdef CONFIG_NO_BOOTMEM
+	return free_all_memory_core_early(NODE_DATA(0)->node_id);
+#else
 	return free_all_bootmem_core(NODE_DATA(0)->bdata);
+#endif
 }
 
+#ifndef CONFIG_NO_BOOTMEM
 static void __init __free(bootmem_data_t *bdata,
 			unsigned long sidx, unsigned long eidx)
 {
@@ -344,6 +411,7 @@ static int __init mark_bootmem(unsigned long start, unsigned long end,
 	}
 	BUG();
 }
+#endif
 
 /**
  * free_bootmem_node - mark a page range as usable
@@ -358,6 +426,12 @@ static int __init mark_bootmem(unsigned long start, unsigned long end,
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
+#ifdef CONFIG_NO_BOOTMEM
+	free_early(physaddr, physaddr + size);
+#if 0
+	printk(KERN_DEBUG "free %lx %lx\n", physaddr, size);
+#endif
+#else
 	unsigned long start, end;
 
 	kmemleak_free_part(__va(physaddr), size);
@@ -366,6 +440,7 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 	end = PFN_DOWN(physaddr + size);
 
 	mark_bootmem_node(pgdat->bdata, start, end, 0, 0);
+#endif
 }
 
 /**
@@ -379,6 +454,12 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
  */
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
+#ifdef CONFIG_NO_BOOTMEM
+	free_early(addr, addr + size);
+#if 0
+	printk(KERN_DEBUG "free %lx %lx\n", addr, size);
+#endif
+#else
 	unsigned long start, end;
 
 	kmemleak_free_part(__va(addr), size);
@@ -387,6 +468,7 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 	end = PFN_DOWN(addr + size);
 
 	mark_bootmem(start, end, 0, 0);
+#endif
 }
 
 /**
@@ -403,12 +485,17 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
+#ifdef CONFIG_NO_BOOTMEM
+	panic("no bootmem");
+	return 0;
+#else
 	unsigned long start, end;
 
 	start = PFN_DOWN(physaddr);
 	end = PFN_UP(physaddr + size);
 
 	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
+#endif
 }
 
 /**
@@ -424,14 +511,20 @@ int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 int __init reserve_bootmem(unsigned long addr, unsigned long size,
 			    int flags)
 {
+#ifdef CONFIG_NO_BOOTMEM
+	panic("no bootmem");
+	return 0;
+#else
 	unsigned long start, end;
 
 	start = PFN_DOWN(addr);
 	end = PFN_UP(addr + size);
 
 	return mark_bootmem(start, end, 1, flags);
+#endif
 }
 
+#ifndef CONFIG_NO_BOOTMEM
 static unsigned long __init align_idx(struct bootmem_data *bdata,
 				      unsigned long idx, unsigned long step)
 {
@@ -582,12 +675,33 @@ static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
 #endif
 	return NULL;
 }
+#endif
 
 static void * __init ___alloc_bootmem_nopanic(unsigned long size,
 					unsigned long align,
 					unsigned long goal,
 					unsigned long limit)
 {
+#ifdef CONFIG_NO_BOOTMEM
+	void *ptr;
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc(size, GFP_NOWAIT);
+
+restart:
+
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align, goal, limit);
+
+	if (ptr)
+		return ptr;
+
+	if (goal != 0) {
+		goal = 0;
+		goto restart;
+	}
+
+	return NULL;
+#else
 	bootmem_data_t *bdata;
 	void *region;
 
@@ -613,6 +727,7 @@ restart:
 	}
 
 	return NULL;
+#endif
 }
 
 /**
@@ -631,7 +746,13 @@ restart:
 void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
 					unsigned long goal)
 {
-	return ___alloc_bootmem_nopanic(size, align, goal, 0);
+	unsigned long limit = 0;
+
+#ifdef CONFIG_NO_BOOTMEM
+	limit = -1UL;
+#endif
+
+	return ___alloc_bootmem_nopanic(size, align, goal, limit);
 }
 
 static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
@@ -665,9 +786,16 @@ static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
 void * __init __alloc_bootmem(unsigned long size, unsigned long align,
 			      unsigned long goal)
 {
-	return ___alloc_bootmem(size, align, goal, 0);
+	unsigned long limit = 0;
+
+#ifdef CONFIG_NO_BOOTMEM
+	limit = -1UL;
+#endif
+
+	return ___alloc_bootmem(size, align, goal, limit);
 }
 
+#ifndef CONFIG_NO_BOOTMEM
 static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
@@ -684,6 +812,7 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 
 	return ___alloc_bootmem(size, align, goal, limit);
 }
+#endif
 
 /**
  * __alloc_bootmem_node - allocate boot memory from a specific node
@@ -706,7 +835,46 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
+#ifdef CONFIG_NO_BOOTMEM
+	return __alloc_memory_core_early(pgdat->node_id, size, align,
+					 goal, -1ULL);
+#else
 	return ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
+#endif
+}
+
+void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+#ifdef MAX_DMA32_PFN
+	unsigned long end_pfn;
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	/* update goal according ...MAX_DMA32_PFN */
+	end_pfn = pgdat->node_start_pfn + pgdat->node_spanned_pages;
+
+	if (end_pfn > MAX_DMA32_PFN + (128 >> (20 - PAGE_SHIFT)) &&
+	    (goal >> PAGE_SHIFT) < MAX_DMA32_PFN) {
+		void *ptr;
+		unsigned long new_goal;
+
+		new_goal = MAX_DMA32_PFN << PAGE_SHIFT;
+#ifdef CONFIG_NO_BOOTMEM
+		ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
+						 new_goal, -1ULL);
+#else
+		ptr = alloc_bootmem_core(pgdat->bdata, size, align,
+						 new_goal, 0);
+#endif
+		if (ptr)
+			return ptr;
+	}
+#endif
+
+	return __alloc_bootmem_node(pgdat, size, align, goal);
+
 }
 
 #ifdef CONFIG_SPARSEMEM
@@ -720,6 +888,16 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 void * __init alloc_bootmem_section(unsigned long size,
 				    unsigned long section_nr)
 {
+#ifdef CONFIG_NO_BOOTMEM
+	unsigned long pfn, goal, limit;
+
+	pfn = section_nr_to_pfn(section_nr);
+	goal = pfn << PAGE_SHIFT;
+	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
+
+	return __alloc_memory_core_early(early_pfn_to_nid(pfn), size,
+					 SMP_CACHE_BYTES, goal, limit);
+#else
 	bootmem_data_t *bdata;
 	unsigned long pfn, goal, limit;
 
@@ -729,6 +907,7 @@ void * __init alloc_bootmem_section(unsigned long size,
 	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
 	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
+#endif
 }
 #endif
 
@@ -740,11 +919,16 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
+#ifdef CONFIG_NO_BOOTMEM
+	ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
+						 goal, -1ULL);
+#else
 	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
 	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+#endif
 	if (ptr)
 		return ptr;
 
@@ -795,6 +979,11 @@ void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
+#ifdef CONFIG_NO_BOOTMEM
+	return __alloc_memory_core_early(pgdat->node_id, size, align,
+				goal, ARCH_LOW_ADDRESS_LIMIT);
+#else
 	return ___alloc_bootmem_node(pgdat->bdata, size, align,
 				goal, ARCH_LOW_ADDRESS_LIMIT);
+#endif
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8deb9d0..78821a2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3435,6 +3435,59 @@ void __init free_bootmem_with_active_regions(int nid,
 	}
 }
 
+int __init add_from_early_node_map(struct range *range, int az,
+				   int nr_range, int nid)
+{
+	int i;
+	u64 start, end;
+
+	/* need to go over early_node_map to find out good range for node */
+	for_each_active_range_index_in_nid(i, nid) {
+		start = early_node_map[i].start_pfn;
+		end = early_node_map[i].end_pfn;
+		nr_range = add_range(range, az, nr_range, start, end);
+	}
+	return nr_range;
+}
+
+void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit)
+{
+	int i;
+	void *ptr;
+
+	/* need to go over early_node_map to find out good range for node */
+	for_each_active_range_index_in_nid(i, nid) {
+		u64 addr;
+		u64 ei_start, ei_last;
+
+		ei_last = early_node_map[i].end_pfn;
+		ei_last <<= PAGE_SHIFT;
+		ei_start = early_node_map[i].start_pfn;
+		ei_start <<= PAGE_SHIFT;
+		addr = find_early_area(ei_start, ei_last,
+					 goal, limit, size, align);
+
+		if (addr == -1ULL)
+			continue;
+
+#if 0
+		printk(KERN_DEBUG "alloc (nid=%d %llx - %llx) (%llx - %llx) %llx %llx => %llx\n",
+				nid,
+				ei_start, ei_last, goal, limit, size,
+				align, addr);
+#endif
+
+		ptr = phys_to_virt(addr);
+		memset(ptr, 0, size);
+		reserve_early_without_check(addr, addr + size, "BOOTMEM");
+		return ptr;
+	}
+
+	return NULL;
+}
+
+
 void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
 {
 	int i;
@@ -4467,7 +4520,11 @@ void __init set_dma_reserve(unsigned long new_dma_reserve)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-struct pglist_data __refdata contig_page_data = { .bdata = &bootmem_node_data[0] };
+struct pglist_data __refdata contig_page_data = {
+#ifndef CONFIG_NO_BOOTMEM
+ .bdata = &bootmem_node_data[0]
+#endif
+ };
 EXPORT_SYMBOL(contig_page_data);
 #endif
 
diff --git a/mm/percpu.c b/mm/percpu.c
index 083e7c9..841defe 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1929,7 +1929,10 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,
 			}
 			/* copy and return the unused part */
 			memcpy(ptr, __per_cpu_load, ai->static_size);
+#ifndef CONFIG_NO_BOOTMEM
+			/* fix partial free ! */
 			free_fn(ptr + size_sum, ai->unit_size - size_sum);
+#endif
 		}
 	}
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index d9714bd..9506c39 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -40,7 +40,7 @@ static void * __init_refok __earlyonly_bootmem_alloc(int node,
 				unsigned long align,
 				unsigned long goal)
 {
-	return __alloc_bootmem_node(NODE_DATA(node), size, align, goal);
+	return __alloc_bootmem_node_high(NODE_DATA(node), size, align, goal);
 }
 
 
-- 
1.6.4.2

