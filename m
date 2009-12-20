Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbZLTJU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbZLTJU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZLTJU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:20:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:56795 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZLTJUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:20:24 -0500
Message-ID: <4B2DEBDA.7090204@kernel.org>
Date: Sun, 20 Dec 2009 01:18:18 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] sparsemem: put usemap for one node together
References: <4B2B4C19.6010402@kernel.org> <4B2B4FF9.3090806@kernel.org>
In-Reply-To: <4B2B4FF9.3090806@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



could save some buf instead of applying one by one

could help that system that is going to use early_res instead of bootmem
less entries in early_res make search more faster on system with more memory.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/sparse.c |   84 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 66 insertions(+), 18 deletions(-)

Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c
+++ linux-2.6/mm/sparse.c
@@ -271,7 +271,8 @@ static unsigned long *__kmalloc_section_
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static unsigned long * __init
-sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
+sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
+					 unsigned long count)
 {
 	unsigned long section_nr;
 
@@ -286,7 +287,7 @@ sparse_early_usemap_alloc_pgdat_section(
 	 * this problem.
 	 */
 	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
-	return alloc_bootmem_section(usemap_size(), section_nr);
+	return alloc_bootmem_section(usemap_size() * count, section_nr);
 }
 
 static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
@@ -329,7 +330,8 @@ static void __init check_usemap_section_
 }
 #else
 static unsigned long * __init
-sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
+sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
+					 unsigned long count)
 {
 	return NULL;
 }
@@ -339,27 +341,40 @@ static void __init check_usemap_section_
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
+static void __init sparse_early_usemaps_alloc_node(unsigned long**usemap_map,
+				 unsigned long pnum_begin,
+				 unsigned long pnum_end,
+				 unsigned long usemap_count, int nodeid)
 {
-	unsigned long *usemap;
-	struct mem_section *ms = __nr_to_section(pnum);
-	int nid = sparse_early_nid(ms);
-
-	usemap = sparse_early_usemap_alloc_pgdat_section(NODE_DATA(nid));
-	if (usemap)
-		return usemap;
+	void *usemap;
+	unsigned long pnum;
+	int size = usemap_size();
 
-	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	usemap = sparse_early_usemaps_alloc_pgdat_section(NODE_DATA(nodeid),
+								 usemap_count);
 	if (usemap) {
-		check_usemap_section_nr(nid, usemap);
-		return usemap;
+		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
+			if (!present_section_nr(pnum))
+				continue;
+			usemap_map[pnum] = usemap;
+			usemap += size;
+		}
+		return;
 	}
 
-	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
-	nid = 0;
+	usemap = alloc_bootmem_node(NODE_DATA(nodeid), size * usemap_count);
+	if (usemap) {
+		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
+			if (!present_section_nr(pnum))
+				continue;
+			usemap_map[pnum] = usemap;
+			usemap += size;
+			check_usemap_section_nr(nodeid, usemap_map[pnum]);
+		}
+		return;
+	}
 
 	printk(KERN_WARNING "%s: allocation failed\n", __func__);
-	return NULL;
 }
 
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
@@ -396,6 +411,7 @@ static struct page __init *sparse_early_
 void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)
 {
 }
+
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -407,6 +423,9 @@ void __init sparse_init(void)
 	unsigned long *usemap;
 	unsigned long **usemap_map;
 	int size;
+	int nodeid_begin = 0;
+	unsigned long pnum_begin = 0;
+	unsigned long usemap_count;
 
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
@@ -425,10 +444,39 @@ void __init sparse_init(void)
 		panic("can not allocate usemap_map\n");
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		nodeid_begin = sparse_early_nid(ms);
+		pnum_begin = pnum;
+		break;
+	}
+	usemap_count = 1;
+	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+		int nodeid;
+
 		if (!present_section_nr(pnum))
 			continue;
-		usemap_map[pnum] = sparse_early_usemap_alloc(pnum);
+		ms = __nr_to_section(pnum);
+		nodeid = sparse_early_nid(ms);
+		if (nodeid == nodeid_begin) {
+			usemap_count++;
+			continue;
+		}
+		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
+		sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, pnum,
+						 usemap_count, nodeid_begin);
+		/* new start, update count etc*/
+		nodeid_begin = nodeid;
+		pnum_begin = pnum;
+		usemap_count = 1;
 	}
+	/* ok, last chunk */
+	sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, NR_MEM_SECTIONS,
+					 usemap_count, nodeid_begin);
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
