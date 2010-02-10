Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab0BJJ0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:26:19 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39155 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab0BJJV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:21:57 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 10 Feb 2010 01:20:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 17/35] sparsemem: put usemap for one node together
In-reply-to: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265793639-15071-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could save some buf instead of applying one by one

could help that system that is going to use early_res instead of bootmem
less entries in early_res make search more faster on system with more memory.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/sparse.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 66 insertions(+), 18 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 6ce4aab..0cdaf0b 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -271,7 +271,8 @@ static unsigned long *__kmalloc_section_usemap(void)
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static unsigned long * __init
-sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
+sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
+					 unsigned long count)
 {
 	unsigned long section_nr;
 
@@ -286,7 +287,7 @@ sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
 	 * this problem.
 	 */
 	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
-	return alloc_bootmem_section(usemap_size(), section_nr);
+	return alloc_bootmem_section(usemap_size() * count, section_nr);
 }
 
 static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
@@ -329,7 +330,8 @@ static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
 }
 #else
 static unsigned long * __init
-sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
+sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
+					 unsigned long count)
 {
 	return NULL;
 }
@@ -339,27 +341,40 @@ static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
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
@@ -396,6 +411,7 @@ static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
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
 		if (!present_section_nr(pnum))
 			continue;
-		usemap_map[pnum] = sparse_early_usemap_alloc(pnum);
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
+		if (!present_section_nr(pnum))
+			continue;
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
-- 
1.6.4.2

