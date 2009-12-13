Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZLMXf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZLMXf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZLMXf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:35:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:34742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbZLMXf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:35:27 -0500
Message-ID: <4B2579D2.3010201@kernel.org>
Date: Sun, 13 Dec 2009 15:33:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix checking of SRAT when node0 ram is not from 0 -v2
References: <4B249143.5050300@kernel.org>
In-Reply-To: <4B249143.5050300@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Found one system that boot from socket1 instead of socket0, SRAT get rejected...

[    0.000000] SRAT: Node 1 PXM 0 0-a0000
[    0.000000] SRAT: Node 1 PXM 0 100000-80000000
[    0.000000] SRAT: Node 1 PXM 0 100000000-2080000000
[    0.000000] SRAT: Node 0 PXM 1 2080000000-4080000000
[    0.000000] SRAT: Node 2 PXM 2 4080000000-6080000000
[    0.000000] SRAT: Node 3 PXM 3 6080000000-8080000000
[    0.000000] SRAT: Node 4 PXM 4 8080000000-a080000000
[    0.000000] SRAT: Node 5 PXM 5 a080000000-c080000000
[    0.000000] SRAT: Node 6 PXM 6 c080000000-e080000000
[    0.000000] SRAT: Node 7 PXM 7 e080000000-10080000000
...
[    0.000000] NUMA: Allocated memnodemap from 500000 - 701040
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Adding active range (0, 0x2080000, 0x4080000) 0 entries of 3200 used
[    0.000000] Adding active range (1, 0x0, 0x96) 1 entries of 3200 used
[    0.000000] Adding active range (1, 0x100, 0x7f750) 2 entries of 3200 used
[    0.000000] Adding active range (1, 0x100000, 0x2080000) 3 entries of 3200 used
[    0.000000] Adding active range (2, 0x4080000, 0x6080000) 4 entries of 3200 used
[    0.000000] Adding active range (3, 0x6080000, 0x8080000) 5 entries of 3200 used
[    0.000000] Adding active range (4, 0x8080000, 0xa080000) 6 entries of 3200 used
[    0.000000] Adding active range (5, 0xa080000, 0xc080000) 7 entries of 3200 used
[    0.000000] Adding active range (6, 0xc080000, 0xe080000) 8 entries of 3200 used
[    0.000000] Adding active range (7, 0xe080000, 0x10080000) 9 entries of 3200 used
[    0.000000] SRAT: PXMs only cover 917504MB of your 1048566MB e820 RAM. Not used.
[    0.000000] SRAT: SRAT not used.

the early_node_map is not sorted because node0 with non zero start come first.

so try to sort it right away after all regions are registered.

-v2: make it more solid to handle cross node case like node0 [0,4g), [8,12g) and node1 [4g, 8g), [12g, 16g)

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/srat_32.c |    2 ++
 arch/x86/mm/srat_64.c |    4 +++-
 include/linux/mm.h    |    3 +++
 mm/page_alloc.c       |    4 ++--
 4 files changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_32.c
+++ linux-2.6/arch/x86/mm/srat_32.c
@@ -267,6 +267,8 @@ int __init get_memcfg_from_srat(void)
 		e820_register_active_regions(chunk->nid, chunk->start_pfn,
 					     min(chunk->end_pfn, max_pfn));
 	}
+	/* for out of order entries in SRAT */
+	sort_node_map();
 
 	for_each_online_node(nid) {
 		unsigned long start = node_start_pfn[nid];
Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -317,7 +317,7 @@ static int __init nodes_cover_memory(con
 		unsigned long s = nodes[i].start >> PAGE_SHIFT;
 		unsigned long e = nodes[i].end >> PAGE_SHIFT;
 		pxmram += e - s;
-		pxmram -= absent_pages_in_range(s, e);
+		pxmram -= __absent_pages_in_range(i, s, e);
 		if ((long)pxmram < 0)
 			pxmram = 0;
 	}
@@ -373,6 +373,8 @@ int __init acpi_scan_nodes(unsigned long
 	for_each_node_mask(i, nodes_parsed)
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
+	/* for out of order entries in SRAT */
+	sort_node_map();
 	if (!nodes_cover_memory(nodes)) {
 		bad_srat();
 		return -1;
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1022,6 +1022,9 @@ extern void add_active_range(unsigned in
 extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
+void sort_node_map(void);
+unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
+						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3573,7 +3573,7 @@ static unsigned long __meminit zone_span
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-static unsigned long __meminit __absent_pages_in_range(int nid,
+unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
@@ -4102,7 +4102,7 @@ static int __init cmp_node_active_region
 }
 
 /* sort the node_map by start_pfn */
-static void __init sort_node_map(void)
+void __init sort_node_map(void)
 {
 	sort(early_node_map, (size_t)nr_nodemap_entries,
 			sizeof(struct node_active_region),
