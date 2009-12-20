Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZLTJWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZLTJWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZLTJWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:22:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:59913 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZLTJWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:22:15 -0500
Message-ID: <4B2DEC5C.8000108@kernel.org>
Date: Sun, 20 Dec 2009 01:20:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 2/2] sparsemem: put mem map for one node together.
References: <4B2B4C19.6010402@kernel.org> <4B2B4FF9.3090806@kernel.org>
In-Reply-To: <4B2B4FF9.3090806@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


add vmemmap_alloc_block_buf for mem map only.

it will fallback old wayif can not get that big.

it will help system with more memory that use early_res instead of bootmem
that can not handle too many entries

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c |    2 
 include/linux/mm.h    |    7 +++
 mm/sparse-vmemmap.c   |   70 +++++++++++++++++++++++++++++++
 mm/sparse.c           |  111 +++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 187 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -961,7 +961,7 @@ vmemmap_populate(struct page *start_page
 			if (pmd_none(*pmd)) {
 				pte_t entry;
 
-				p = vmemmap_alloc_block(PMD_SIZE, node);
+				p = vmemmap_alloc_block_buf(PMD_SIZE, node);
 				if (!p)
 					return -ENOMEM;
 
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1323,12 +1323,19 @@ extern int randomize_va_space;
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
Index: linux-2.6/mm/sparse-vmemmap.c
===================================================================
--- linux-2.6.orig/mm/sparse-vmemmap.c
+++ linux-2.6/mm/sparse-vmemmap.c
@@ -43,6 +43,8 @@ static void * __init_refok __earlyonly_b
 	return __alloc_bootmem_node_high(NODE_DATA(node), size, align, goal);
 }
 
+static void *buf;
+static void *buf_end;
 
 void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 {
@@ -64,6 +66,24 @@ void * __meminit vmemmap_alloc_block(uns
 				__pa(MAX_DMA_ADDRESS));
 }
 
+/* need to make sure size is all the same during early stage */
+void * __meminit vmemmap_alloc_block_buf(unsigned long size, int node)
+{
+	void *ptr;
+
+	if (!buf)
+		return vmemmap_alloc_block(size, node);
+
+	/* take the from buf */
+	ptr = (void *)ALIGN((unsigned long)buf, size);
+	if (ptr + size > buf_end)
+		return vmemmap_alloc_block(size, node);
+
+	buf = ptr + size;
+
+	return ptr;
+}
+
 void __meminit vmemmap_verify(pte_t *pte, int node,
 				unsigned long start, unsigned long end)
 {
@@ -80,7 +100,7 @@ pte_t * __meminit vmemmap_pte_populate(p
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
-		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
@@ -163,3 +183,51 @@ struct page * __meminit sparse_mem_map_p
 
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
+	void *buf_start;
+
+	size = ALIGN(size, PMD_SIZE);
+	buf_start = __earlyonly_bootmem_alloc(nodeid, size * map_count,
+			 PMD_SIZE, __pa(MAX_DMA_ADDRESS));
+
+	if (buf_start) {
+		buf = buf_start;
+		buf_end = buf_start + size * map_count;
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
+	if (buf_start) {
+		/* need to free left buf */
+#ifdef CONFIG_NO_BOOTMEM
+		free_early(__pa(buf_start), __pa(buf_end));
+		if (buf_start < buf)
+			reserve_early_without_check(__pa(buf_start), __pa(buf),
+							 "BOOTMAP");
+#else
+		free_bootmem(__pa(buf), buf_end - buf);
+#endif
+		buf = NULL;
+		buf_end = NULL;
+	}
+}
Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c
+++ linux-2.6/mm/sparse.c
@@ -390,8 +390,65 @@ struct page __init *sparse_mem_map_popul
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
+#ifndef CONFIG_X86_64
 static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -407,6 +464,7 @@ static struct page __init *sparse_early_
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
 
+#ifdef CONFIG_X86_64
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
 
+#ifdef CONFIG_X86_64
+		map = map_map[pnum];
+#else
 		map = sparse_early_mem_map_alloc(pnum);
+#endif
 		if (!map)
 			continue;
 
@@ -496,6 +602,9 @@ void __init sparse_init(void)
 
 	vmemmap_populate_print_last();
 
+#ifdef CONFIG_X86_64
+	free_bootmem(__pa(map_map), size2);
+#endif
 	free_bootmem(__pa(usemap_map), size);
 }
 
