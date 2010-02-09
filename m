Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0BITjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:39:36 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54628 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0BITdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 17/35] sparsemem: put mem map for one node together.
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add vmemmap_alloc_block_buf for mem map only.

it will fallback old wayif can not get that big.

before this patch, when node have 128g ram installed, memmap are split into
 two parts or more.
[    0.000000]  [ffffea0000000000-ffffea003fffffff] PMD -> [ffff880100600000-ffff88013e9fffff] on node 1
[    0.000000]  [ffffea0040000000-ffffea006fffffff] PMD -> [ffff88013ec00000-ffff88016ebfffff] on node 1
[    0.000000]  [ffffea0070000000-ffffea007fffffff] PMD -> [ffff882000600000-ffff8820105fffff] on node 0
[    0.000000]  [ffffea0080000000-ffffea00bfffffff] PMD -> [ffff882010800000-ffff8820507fffff] on node 0
[    0.000000]  [ffffea00c0000000-ffffea00dfffffff] PMD -> [ffff882050a00000-ffff8820709fffff] on node 0
[    0.000000]  [ffffea00e0000000-ffffea00ffffffff] PMD -> [ffff884000600000-ffff8840205fffff] on node 2
[    0.000000]  [ffffea0100000000-ffffea013fffffff] PMD -> [ffff884020800000-ffff8840607fffff] on node 2
[    0.000000]  [ffffea0140000000-ffffea014fffffff] PMD -> [ffff884060a00000-ffff8840709fffff] on node 2
[    0.000000]  [ffffea0150000000-ffffea017fffffff] PMD -> [ffff886000600000-ffff8860305fffff] on node 3
[    0.000000]  [ffffea0180000000-ffffea01bfffffff] PMD -> [ffff886030800000-ffff8860707fffff] on node 3
[    0.000000]  [ffffea01c0000000-ffffea01ffffffff] PMD -> [ffff888000600000-ffff8880405fffff] on node 4
[    0.000000]  [ffffea0200000000-ffffea022fffffff] PMD -> [ffff888040800000-ffff8880707fffff] on node 4
[    0.000000]  [ffffea0230000000-ffffea023fffffff] PMD -> [ffff88a000600000-ffff88a0105fffff] on node 5
[    0.000000]  [ffffea0240000000-ffffea027fffffff] PMD -> [ffff88a010800000-ffff88a0507fffff] on node 5
[    0.000000]  [ffffea0280000000-ffffea029fffffff] PMD -> [ffff88a050a00000-ffff88a0709fffff] on node 5
[    0.000000]  [ffffea02a0000000-ffffea02bfffffff] PMD -> [ffff88c000600000-ffff88c0205fffff] on node 6
[    0.000000]  [ffffea02c0000000-ffffea02ffffffff] PMD -> [ffff88c020800000-ffff88c0607fffff] on node 6
[    0.000000]  [ffffea0300000000-ffffea030fffffff] PMD -> [ffff88c060a00000-ffff88c0709fffff] on node 6
[    0.000000]  [ffffea0310000000-ffffea033fffffff] PMD -> [ffff88e000600000-ffff88e0305fffff] on node 7
[    0.000000]  [ffffea0340000000-ffffea037fffffff] PMD -> [ffff88e030800000-ffff88e0707fffff] on node 7

after patch will get
[    0.000000]  [ffffea0000000000-ffffea006fffffff] PMD -> [ffff880100200000-ffff88016e5fffff] on node 0
[    0.000000]  [ffffea0070000000-ffffea00dfffffff] PMD -> [ffff882000200000-ffff8820701fffff] on node 1
[    0.000000]  [ffffea00e0000000-ffffea014fffffff] PMD -> [ffff884000200000-ffff8840701fffff] on node 2
[    0.000000]  [ffffea0150000000-ffffea01bfffffff] PMD -> [ffff886000200000-ffff8860701fffff] on node 3
[    0.000000]  [ffffea01c0000000-ffffea022fffffff] PMD -> [ffff888000200000-ffff8880701fffff] on node 4
[    0.000000]  [ffffea0230000000-ffffea029fffffff] PMD -> [ffff88a000200000-ffff88a0701fffff] on node 5
[    0.000000]  [ffffea02a0000000-ffffea030fffffff] PMD -> [ffff88c000200000-ffff88c0701fffff] on node 6
[    0.000000]  [ffffea0310000000-ffffea037fffffff] PMD -> [ffff88e000200000-ffff88e0701fffff] on node 7


-v2: change buf to vmemmap_buf instead according to Ingo
     also add CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER according to Ingo

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
---
 arch/x86/mm/init_64.c |    2 +-
 include/linux/mm.h    |    7 +++
 mm/Kconfig            |    4 ++
 mm/sparse-vmemmap.c   |   75 ++++++++++++++++++++++++++++++++-
 mm/sparse.c           |  111 ++++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 196 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index fd9a004..8f197ce 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -976,7 +976,7 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 			if (pmd_none(*pmd)) {
 				pte_t entry;
 
-				p = vmemmap_alloc_block(PMD_SIZE, node);
+				p = vmemmap_alloc_block_buf(PMD_SIZE, node);
 				if (!p)
 					return -ENOMEM;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f2c5b3c..f6002e5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1326,12 +1326,19 @@ extern int randomize_va_space;
 const char * arch_vma_name(struct vm_area_struct *vma);
 void print_vma_addr(char *prefix, unsigned long rip);
 
+void sparse_mem_maps_populate_node(struct page **map_map,
+				   unsigned long pnum_begin,
+				   unsigned long pnum_end,
+				   unsigned long map_count,
+				   int nodeid);
+
 struct page *sparse_mem_map_populate(unsigned long pnum, int nid);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(pgd_t *pgd, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node);
 void *vmemmap_alloc_block(unsigned long size, int node);
+void *vmemmap_alloc_block_buf(unsigned long size, int node);
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 int vmemmap_populate_basepages(struct page *start_page,
 						unsigned long pages, int node);
diff --git a/mm/Kconfig b/mm/Kconfig
index 28212b8..d84cdab 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -115,6 +115,10 @@ config SPARSEMEM_EXTREME
 config SPARSEMEM_VMEMMAP_ENABLE
 	bool
 
+config SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
+	def_bool y
+	depends on SPARSEMEM && X86_64
+
 config SPARSEMEM_VMEMMAP
 	bool "Sparse Memory virtual memmap"
 	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 9506c39..6b4be75 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -43,6 +43,8 @@ static void * __init_refok __earlyonly_bootmem_alloc(int node,
 	return __alloc_bootmem_node_high(NODE_DATA(node), size, align, goal);
 }
 
+static void *vmemmap_buf;
+static void *vmemmap_buf_end;
 
 void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 {
@@ -64,6 +66,24 @@ void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 				__pa(MAX_DMA_ADDRESS));
 }
 
+/* need to make sure size is all the same during early stage */
+void * __meminit vmemmap_alloc_block_buf(unsigned long size, int node)
+{
+	void *ptr;
+
+	if (!vmemmap_buf)
+		return vmemmap_alloc_block(size, node);
+
+	/* take the from buf */
+	ptr = (void *)ALIGN((unsigned long)vmemmap_buf, size);
+	if (ptr + size > vmemmap_buf_end)
+		return vmemmap_alloc_block(size, node);
+
+	vmemmap_buf = ptr + size;
+
+	return ptr;
+}
+
 void __meminit vmemmap_verify(pte_t *pte, int node,
 				unsigned long start, unsigned long end)
 {
@@ -80,7 +100,7 @@ pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node)
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
-		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
@@ -163,3 +183,56 @@ struct page * __meminit sparse_mem_map_populate(unsigned long pnum, int nid)
 
 	return map;
 }
+
+void __init sparse_mem_maps_populate_node(struct page **map_map,
+					  unsigned long pnum_begin,
+					  unsigned long pnum_end,
+					  unsigned long map_count, int nodeid)
+{
+	unsigned long pnum;
+	unsigned long size = sizeof(struct page) * PAGES_PER_SECTION;
+	void *vmemmap_buf_start;
+
+	size = ALIGN(size, PMD_SIZE);
+	vmemmap_buf_start = __earlyonly_bootmem_alloc(nodeid, size * map_count,
+			 PMD_SIZE, __pa(MAX_DMA_ADDRESS));
+
+	if (vmemmap_buf_start) {
+		vmemmap_buf = vmemmap_buf_start;
+		vmemmap_buf_end = vmemmap_buf_start + size * map_count;
+	}
+
+	for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
+		struct mem_section *ms;
+
+		if (!present_section_nr(pnum))
+			continue;
+
+		map_map[pnum] = sparse_mem_map_populate(pnum, nodeid);
+		if (map_map[pnum])
+			continue;
+		ms = __nr_to_section(pnum);
+		printk(KERN_ERR "%s: sparsemem memory map backing failed "
+			"some memory will not be available.\n", __func__);
+		ms->section_mem_map = 0;
+	}
+
+	if (vmemmap_buf_start) {
+		/* need to free left buf */
+#ifdef CONFIG_NO_BOOTMEM
+		free_early(__pa(vmemmap_buf_start), __pa(vmemmap_buf_end));
+		if (vmemmap_buf_start < vmemmap_buf) {
+			char name[15];
+
+			memset(name, 0, sizeof(name));
+			snprintf(name, 15, "MEMMAP %d", nodeid);
+			reserve_early_without_check(__pa(vmemmap_buf_start),
+						    __pa(vmemmap_buf), name);
+		}
+#else
+		free_bootmem(__pa(vmemmap_buf), vmemmap_buf_end - vmemmap_buf);
+#endif
+		vmemmap_buf = NULL;
+		vmemmap_buf_end = NULL;
+	}
+}
diff --git a/mm/sparse.c b/mm/sparse.c
index 0cdaf0b..9b6b93a 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -390,8 +390,65 @@ struct page __init *sparse_mem_map_populate(unsigned long pnum, int nid)
 		       PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION));
 	return map;
 }
+void __init sparse_mem_maps_populate_node(struct page **map_map,
+					  unsigned long pnum_begin,
+					  unsigned long pnum_end,
+					  unsigned long map_count, int nodeid)
+{
+	void *map;
+	unsigned long pnum;
+	unsigned long size = sizeof(struct page) * PAGES_PER_SECTION;
+
+	map = alloc_remap(nodeid, size * map_count);
+	if (map) {
+		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
+			if (!present_section_nr(pnum))
+				continue;
+			map_map[pnum] = map;
+			map += size;
+		}
+		return;
+	}
+
+	size = PAGE_ALIGN(size);
+	map = alloc_bootmem_pages_node(NODE_DATA(nodeid), size * map_count);
+	if (map) {
+		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
+			if (!present_section_nr(pnum))
+				continue;
+			map_map[pnum] = map;
+			map += size;
+		}
+		return;
+	}
+
+	/* fallback */
+	for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
+		struct mem_section *ms;
+
+		if (!present_section_nr(pnum))
+			continue;
+		map_map[pnum] = sparse_mem_map_populate(pnum, nodeid);
+		if (map_map[pnum])
+			continue;
+		ms = __nr_to_section(pnum);
+		printk(KERN_ERR "%s: sparsemem memory map backing failed "
+			"some memory will not be available.\n", __func__);
+		ms->section_mem_map = 0;
+	}
+}
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
+static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
+				 unsigned long pnum_begin,
+				 unsigned long pnum_end,
+				 unsigned long map_count, int nodeid)
+{
+	sparse_mem_maps_populate_node(map_map, pnum_begin, pnum_end,
+					 map_count, nodeid);
+}
+
+#ifndef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -407,6 +464,7 @@ static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 	ms->section_mem_map = 0;
 	return NULL;
 }
+#endif
 
 void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)
 {
@@ -420,12 +478,14 @@ void __init sparse_init(void)
 {
 	unsigned long pnum;
 	struct page *map;
+	struct page **map_map;
 	unsigned long *usemap;
 	unsigned long **usemap_map;
-	int size;
+	int size, size2;
 	int nodeid_begin = 0;
 	unsigned long pnum_begin = 0;
 	unsigned long usemap_count;
+	unsigned long map_count;
 
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
@@ -478,6 +538,48 @@ void __init sparse_init(void)
 	sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, NR_MEM_SECTIONS,
 					 usemap_count, nodeid_begin);
 
+#ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
+	size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
+	map_map = alloc_bootmem(size2);
+	if (!map_map)
+		panic("can not allocate map_map\n");
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		nodeid_begin = sparse_early_nid(ms);
+		pnum_begin = pnum;
+		break;
+	}
+	map_count = 1;
+	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+		int nodeid;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		nodeid = sparse_early_nid(ms);
+		if (nodeid == nodeid_begin) {
+			map_count++;
+			continue;
+		}
+		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
+		sparse_early_mem_maps_alloc_node(map_map, pnum_begin, pnum,
+						 map_count, nodeid_begin);
+		/* new start, update count etc*/
+		nodeid_begin = nodeid;
+		pnum_begin = pnum;
+		map_count = 1;
+	}
+	/* ok, last chunk */
+	sparse_early_mem_maps_alloc_node(map_map, pnum_begin, NR_MEM_SECTIONS,
+					 map_count, nodeid_begin);
+#endif
+
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
@@ -486,7 +588,11 @@ void __init sparse_init(void)
 		if (!usemap)
 			continue;
 
+#ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
+		map = map_map[pnum];
+#else
 		map = sparse_early_mem_map_alloc(pnum);
+#endif
 		if (!map)
 			continue;
 
@@ -496,6 +602,9 @@ void __init sparse_init(void)
 
 	vmemmap_populate_print_last();
 
+#ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
+	free_bootmem(__pa(map_map), size2);
+#endif
 	free_bootmem(__pa(usemap_map), size);
 }
 
-- 
1.6.4.2

