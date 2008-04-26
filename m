Return-Path: <linux-kernel-owner+w=401wt.eu-S1762385AbYDZUIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762385AbYDZUIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760380AbYDZUIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:08:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59848 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757810AbYDZUIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:08:45 -0400
Date: Sat, 26 Apr 2008 22:08:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: [git pull] "big box" x86 changes, bootmem/sparsemem, #2
Message-ID: <20080426200829.GB14223@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426194143.GA8366@elte.hu> <alpine.LFD.1.10.0804261247020.2813@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804261247020.2813@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


here's the updated tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-bootmem-v2.git for-linus

	Ingo

------------------>
Yinghai Lu (7):
      mm: make mem_map allocation continuous
      mm: fix alloc_bootmem_core to use fast searching for all nodes
      mm: offset align in alloc_bootmem()
      mm: allow reserve_bootmem() cross nodes
      x86_64: make reserve_bootmem_generic() use new reserve_bootmem()
      x86_64: fix setup_node_bootmem to support big mem excluding with memmap
      x86_64/mm: check and print vmemmap allocation continuous

 arch/x86/kernel/e820_64.c  |   13 +++-
 arch/x86/kernel/setup_64.c |    3 +-
 arch/x86/mm/init_64.c      |   38 +++++++++-
 arch/x86/mm/numa_64.c      |   42 ++++++++++--
 include/asm-x86/e820_64.h  |    2 +-
 include/linux/mm.h         |    1 +
 mm/bootmem.c               |  164 ++++++++++++++++++++++++++++++--------------
 mm/sparse.c                |   37 +++++++++-
 8 files changed, 228 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index cbd42e5..f95fdab 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -84,14 +84,19 @@ void __init reserve_early(unsigned long start, unsigned long end, char *name)
 		strncpy(r->name, name, sizeof(r->name) - 1);
 }
 
-void __init early_res_to_bootmem(void)
+void __init early_res_to_bootmem(unsigned long start, unsigned long end)
 {
 	int i;
+	unsigned long final_start, final_end;
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 		struct early_res *r = &early_res[i];
-		printk(KERN_INFO "early res: %d [%lx-%lx] %s\n", i,
-			r->start, r->end - 1, r->name);
-		reserve_bootmem_generic(r->start, r->end - r->start);
+		final_start = max(start, r->start);
+		final_end = min(end, r->end);
+		if (final_start >= final_end)
+			continue;
+		printk(KERN_INFO "  early res: %d [%lx-%lx] %s\n", i,
+			final_start, final_end - 1, r->name);
+		reserve_bootmem_generic(final_start, final_end - final_start);
 	}
 }
 
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 17bdf23..de9c870 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -190,6 +190,7 @@ contig_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
 	e820_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
+	early_res_to_bootmem(0, end_pfn<<PAGE_SHIFT);
 	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 }
 #endif
@@ -397,8 +398,6 @@ void __init setup_arch(char **cmdline_p)
 	contig_initmem_init(0, end_pfn);
 #endif
 
-	early_res_to_bootmem();
-
 	dma32_reserve_bootmem();
 
 #ifdef CONFIG_ACPI_SLEEP
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0cca626..5fbb865 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -810,7 +810,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 {
 #ifdef CONFIG_NUMA
-	int nid = phys_to_nid(phys);
+	int nid, next_nid;
 #endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
 
@@ -829,10 +829,16 @@ void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 
 	/* Should check here against the e820 map to avoid double free */
 #ifdef CONFIG_NUMA
-	reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
+	nid = phys_to_nid(phys);
+	next_nid = phys_to_nid(phys + len - 1);
+	if (nid == next_nid)
+		reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
+	else
+		reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
 #else
 	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
 #endif
+
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
 		dma_reserve += len / PAGE_SIZE;
 		set_dma_reserve(dma_reserve);
@@ -926,6 +932,10 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
  */
+static long __meminitdata addr_start, addr_end;
+static void __meminitdata *p_start, *p_end;
+static int __meminitdata node_start;
+
 int __meminit
 vmemmap_populate(struct page *start_page, unsigned long size, int node)
 {
@@ -960,12 +970,32 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 							PAGE_KERNEL_LARGE);
 			set_pmd(pmd, __pmd(pte_val(entry)));
 
-			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
-				addr, addr + PMD_SIZE - 1, p, node);
+			/* check to see if we have contiguous blocks */
+			if (p_end != p || node_start != node) {
+				if (p_start)
+					printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+						addr_start, addr_end-1, p_start, p_end-1, node_start);
+				addr_start = addr;
+				node_start = node;
+				p_start = p;
+			}
+			addr_end = addr + PMD_SIZE;
+			p_end = p + PMD_SIZE;
 		} else {
 			vmemmap_verify((pte_t *)pmd, node, addr, next);
 		}
 	}
 	return 0;
 }
+
+void __meminit vmemmap_populate_print_last(void)
+{
+	if (p_start) {
+		printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+			addr_start, addr_end-1, p_start, p_end-1, node_start);
+		p_start = NULL;
+		p_end = NULL;
+		node_start = 0;
+	}
+}
 #endif
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 9a68922..c5066d5 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -196,6 +196,7 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	unsigned long bootmap_start, nodedata_phys;
 	void *bootmap;
 	const int pgdat_size = round_up(sizeof(pg_data_t), PAGE_SIZE);
+	int nid;
 
 	start = round_up(start, ZONE_ALIGN);
 
@@ -218,9 +219,19 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	NODE_DATA(nodeid)->node_start_pfn = start_pfn;
 	NODE_DATA(nodeid)->node_spanned_pages = end_pfn - start_pfn;
 
-	/* Find a place for the bootmem map */
+	/*
+	 * Find a place for the bootmem map
+	 * nodedata_phys could be on other nodes by alloc_bootmem,
+	 * so need to sure bootmap_start not to be small, otherwise
+	 * early_node_mem will get that with find_e820_area instead
+	 * of alloc_bootmem, that could clash with reserved range
+	 */
 	bootmap_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
-	bootmap_start = round_up(nodedata_phys + pgdat_size, PAGE_SIZE);
+	nid = phys_to_nid(nodedata_phys);
+	if (nid == nodeid)
+		bootmap_start = round_up(nodedata_phys + pgdat_size, PAGE_SIZE);
+	else
+		bootmap_start = round_up(start, PAGE_SIZE);
 	/*
 	 * SMP_CAHCE_BYTES could be enough, but init_bootmem_node like
 	 * to use that to align to PAGE_SIZE
@@ -245,10 +256,29 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 
 	free_bootmem_with_active_regions(nodeid, end);
 
-	reserve_bootmem_node(NODE_DATA(nodeid), nodedata_phys, pgdat_size,
-			BOOTMEM_DEFAULT);
-	reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
-			bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
+	/*
+	 * convert early reserve to bootmem reserve earlier
+	 * otherwise early_node_mem could use early reserved mem
+	 * on previous node
+	 */
+	early_res_to_bootmem(start, end);
+
+	/*
+	 * in some case early_node_mem could use alloc_bootmem
+	 * to get range on other node, don't reserve that again
+	 */
+	if (nid != nodeid)
+		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nodeid, nid);
+	else
+		reserve_bootmem_node(NODE_DATA(nodeid), nodedata_phys,
+					pgdat_size, BOOTMEM_DEFAULT);
+	nid = phys_to_nid(bootmap_start);
+	if (nid != nodeid)
+		printk(KERN_INFO "    bootmap(%d) on node %d\n", nodeid, nid);
+	else
+		reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
+				 bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
+
 #ifdef CONFIG_ACPI_NUMA
 	srat_reserve_add_area(nodeid);
 #endif
diff --git a/include/asm-x86/e820_64.h b/include/asm-x86/e820_64.h
index f478c57..4c6ad98 100644
--- a/include/asm-x86/e820_64.h
+++ b/include/asm-x86/e820_64.h
@@ -48,7 +48,7 @@ extern struct e820map e820;
 extern void update_e820(void);
 
 extern void reserve_early(unsigned long start, unsigned long end, char *name);
-extern void early_res_to_bootmem(void);
+extern void early_res_to_bootmem(unsigned long start, unsigned long end);
 
 #endif/*!__ASSEMBLY__*/
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b695875..286d315 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1229,6 +1229,7 @@ void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 int vmemmap_populate_basepages(struct page *start_page,
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
+void vmemmap_populate_print_last(void);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 2ccea70..b679164 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -111,44 +111,74 @@ static unsigned long __init init_bootmem_core(pg_data_t *pgdat,
  * might be used for boot-time allocations - or it might get added
  * to the free page pool later on.
  */
-static int __init reserve_bootmem_core(bootmem_data_t *bdata,
+static int __init can_reserve_bootmem_core(bootmem_data_t *bdata,
 			unsigned long addr, unsigned long size, int flags)
 {
 	unsigned long sidx, eidx;
 	unsigned long i;
-	int ret;
+
+	BUG_ON(!size);
+
+	/* out of range, don't hold other */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return 0;
 
 	/*
-	 * round up, partially reserved pages are considered
-	 * fully reserved.
+	 * Round up to index to the range.
 	 */
+	if (addr > bdata->node_boot_start)
+		sidx= PFN_DOWN(addr - bdata->node_boot_start);
+	else
+		sidx = 0;
+
+	eidx = PFN_UP(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+
+	for (i = sidx; i < eidx; i++) {
+		if (test_bit(i, bdata->node_bootmem_map)) {
+			if (flags & BOOTMEM_EXCLUSIVE)
+				return -EBUSY;
+		}
+	}
+
+	return 0;
+
+}
+
+static void __init reserve_bootmem_core(bootmem_data_t *bdata,
+			unsigned long addr, unsigned long size, int flags)
+{
+	unsigned long sidx, eidx;
+	unsigned long i;
+
 	BUG_ON(!size);
-	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
-	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
-	BUG_ON(addr < bdata->node_boot_start);
 
-	sidx = PFN_DOWN(addr - bdata->node_boot_start);
+	/* out of range */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return;
+
+	/*
+	 * Round up to index to the range.
+	 */
+	if (addr > bdata->node_boot_start)
+		sidx= PFN_DOWN(addr - bdata->node_boot_start);
+	else
+		sidx = 0;
+
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
-	for (i = sidx; i < eidx; i++)
+	for (i = sidx; i < eidx; i++) {
 		if (test_and_set_bit(i, bdata->node_bootmem_map)) {
 #ifdef CONFIG_DEBUG_BOOTMEM
 			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
 #endif
-			if (flags & BOOTMEM_EXCLUSIVE) {
-				ret = -EBUSY;
-				goto err;
-			}
 		}
-
-	return 0;
-
-err:
-	/* unreserve memory we accidentally reserved */
-	for (i--; i >= sidx; i--)
-		clear_bit(i, bdata->node_bootmem_map);
-
-	return ret;
+	}
 }
 
 static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
@@ -206,9 +236,11 @@ void * __init
 __alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
 	      unsigned long align, unsigned long goal, unsigned long limit)
 {
-	unsigned long offset, remaining_size, areasize, preferred;
+	unsigned long areasize, preferred;
 	unsigned long i, start = 0, incr, eidx, end_pfn;
 	void *ret;
+	unsigned long node_boot_start;
+	void *node_bootmem_map;
 
 	if (!size) {
 		printk("__alloc_bootmem_core(): zero-sized request\n");
@@ -216,70 +248,83 @@ __alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
 	}
 	BUG_ON(align & (align-1));
 
-	if (limit && bdata->node_boot_start >= limit)
-		return NULL;
-
 	/* on nodes without memory - bootmem_map is NULL */
 	if (!bdata->node_bootmem_map)
 		return NULL;
 
+	/* bdata->node_boot_start is supposed to be (12+6)bits alignment on x86_64 ? */
+	node_boot_start = bdata->node_boot_start;
+	node_bootmem_map = bdata->node_bootmem_map;
+	if (align) {
+		node_boot_start = ALIGN(bdata->node_boot_start, align);
+		if (node_boot_start > bdata->node_boot_start)
+			node_bootmem_map = (unsigned long *)bdata->node_bootmem_map +
+			    PFN_DOWN(node_boot_start - bdata->node_boot_start)/BITS_PER_LONG;
+	}
+
+	if (limit && node_boot_start >= limit)
+		return NULL;
+
 	end_pfn = bdata->node_low_pfn;
 	limit = PFN_DOWN(limit);
 	if (limit && end_pfn > limit)
 		end_pfn = limit;
 
-	eidx = end_pfn - PFN_DOWN(bdata->node_boot_start);
-	offset = 0;
-	if (align && (bdata->node_boot_start & (align - 1UL)) != 0)
-		offset = align - (bdata->node_boot_start & (align - 1UL));
-	offset = PFN_DOWN(offset);
+	eidx = end_pfn - PFN_DOWN(node_boot_start);
 
 	/*
 	 * We try to allocate bootmem pages above 'goal'
 	 * first, then we try to allocate lower pages.
 	 */
-	if (goal && goal >= bdata->node_boot_start && PFN_DOWN(goal) < end_pfn) {
-		preferred = goal - bdata->node_boot_start;
+	preferred = 0;
+	if (goal && PFN_DOWN(goal) < end_pfn) {
+		if (goal > node_boot_start)
+			preferred = goal - node_boot_start;
 
-		if (bdata->last_success >= preferred)
+		if (bdata->last_success > node_boot_start &&
+			bdata->last_success - node_boot_start >= preferred)
 			if (!limit || (limit && limit > bdata->last_success))
-				preferred = bdata->last_success;
-	} else
-		preferred = 0;
+				preferred = bdata->last_success - node_boot_start;
+	}
 
-	preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
+	preferred = PFN_DOWN(ALIGN(preferred, align));
 	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
 	incr = align >> PAGE_SHIFT ? : 1;
 
 restart_scan:
-	for (i = preferred; i < eidx; i += incr) {
+	for (i = preferred; i < eidx;) {
 		unsigned long j;
-		i = find_next_zero_bit(bdata->node_bootmem_map, eidx, i);
+
+		i = find_next_zero_bit(node_bootmem_map, eidx, i);
 		i = ALIGN(i, incr);
 		if (i >= eidx)
 			break;
-		if (test_bit(i, bdata->node_bootmem_map))
+		if (test_bit(i, node_bootmem_map)) {
+			i += incr;
 			continue;
+		}
 		for (j = i + 1; j < i + areasize; ++j) {
 			if (j >= eidx)
 				goto fail_block;
-			if (test_bit(j, bdata->node_bootmem_map))
+			if (test_bit(j, node_bootmem_map))
 				goto fail_block;
 		}
 		start = i;
 		goto found;
 	fail_block:
 		i = ALIGN(j, incr);
+		if (i == j)
+			i += incr;
 	}
 
-	if (preferred > offset) {
-		preferred = offset;
+	if (preferred > 0) {
+		preferred = 0;
 		goto restart_scan;
 	}
 	return NULL;
 
 found:
-	bdata->last_success = PFN_PHYS(start);
+	bdata->last_success = PFN_PHYS(start) + node_boot_start;
 	BUG_ON(start >= eidx);
 
 	/*
@@ -289,6 +334,7 @@ found:
 	 */
 	if (align < PAGE_SIZE &&
 	    bdata->last_offset && bdata->last_pos+1 == start) {
+		unsigned long offset, remaining_size;
 		offset = ALIGN(bdata->last_offset, align);
 		BUG_ON(offset > PAGE_SIZE);
 		remaining_size = PAGE_SIZE - offset;
@@ -297,14 +343,12 @@ found:
 			/* last_pos unchanged */
 			bdata->last_offset = offset + size;
 			ret = phys_to_virt(bdata->last_pos * PAGE_SIZE +
-					   offset +
-					   bdata->node_boot_start);
+					   offset + node_boot_start);
 		} else {
 			remaining_size = size - remaining_size;
 			areasize = (remaining_size + PAGE_SIZE-1) / PAGE_SIZE;
 			ret = phys_to_virt(bdata->last_pos * PAGE_SIZE +
-					   offset +
-					   bdata->node_boot_start);
+					   offset + node_boot_start);
 			bdata->last_pos = start + areasize - 1;
 			bdata->last_offset = remaining_size;
 		}
@@ -312,14 +356,14 @@ found:
 	} else {
 		bdata->last_pos = start + areasize - 1;
 		bdata->last_offset = size & ~PAGE_MASK;
-		ret = phys_to_virt(start * PAGE_SIZE + bdata->node_boot_start);
+		ret = phys_to_virt(start * PAGE_SIZE + node_boot_start);
 	}
 
 	/*
 	 * Reserve the area now:
 	 */
 	for (i = start; i < start + areasize; i++)
-		if (unlikely(test_and_set_bit(i, bdata->node_bootmem_map)))
+		if (unlikely(test_and_set_bit(i, node_bootmem_map)))
 			BUG();
 	memset(ret, 0, size);
 	return ret;
@@ -401,6 +445,11 @@ unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
+	int ret;
+
+	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+	if (ret < 0)
+		return;
 	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
 }
 
@@ -426,7 +475,18 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 int __init reserve_bootmem(unsigned long addr, unsigned long size,
 			    int flags)
 {
-	return reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size, flags);
+	bootmem_data_t *bdata;
+	int ret;
+
+	list_for_each_entry(bdata, &bdata_list, list) {
+		ret = can_reserve_bootmem_core(bdata, addr, size, flags);
+		if (ret < 0)
+			return ret;
+	}
+	list_for_each_entry(bdata, &bdata_list, list)
+		reserve_bootmem_core(bdata, addr, size, flags);
+
+	return 0;
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 98d6b39..7e91913 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -295,6 +295,9 @@ struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 	return NULL;
 }
 
+void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)
+{
+}
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -304,22 +307,50 @@ void __init sparse_init(void)
 	unsigned long pnum;
 	struct page *map;
 	unsigned long *usemap;
+	unsigned long **usemap_map;
+	int size;
+
+	/*
+	 * map is using big page (aka 2M in x86 64 bit)
+	 * usemap is less one page (aka 24 bytes)
+	 * so alloc 2M (with 2M align) and 24 bytes in turn will
+	 * make next 2M slip to one more 2M later.
+	 * then in big system, the memory will have a lot of holes...
+	 * here try to allocate 2M pages continously.
+	 *
+	 * powerpc need to call sparse_init_one_section right after each
+	 * sparse_early_mem_map_alloc, so allocate usemap_map at first.
+	 */
+	size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
+	usemap_map = alloc_bootmem(size);
+	if (!usemap_map)
+		panic("can not allocate usemap_map\n");
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
+		usemap_map[pnum] = sparse_early_usemap_alloc(pnum);
+	}
 
-		map = sparse_early_mem_map_alloc(pnum);
-		if (!map)
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		if (!present_section_nr(pnum))
 			continue;
 
-		usemap = sparse_early_usemap_alloc(pnum);
+		usemap = usemap_map[pnum];
 		if (!usemap)
 			continue;
 
+		map = sparse_early_mem_map_alloc(pnum);
+		if (!map)
+			continue;
+
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
 								usemap);
 	}
+
+	vmemmap_populate_print_last();
+
+	free_bootmem(__pa(usemap_map), size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG



