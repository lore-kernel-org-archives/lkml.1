Return-Path: <linux-kernel-owner+w=401wt.eu-S934049AbZLOW0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049AbZLOW0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761385AbZLOW0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:26:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:60430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935AbZLOW0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:26:12 -0500
Message-ID: <4B280CBB.9090406@kernel.org>
Date: Tue, 15 Dec 2009 14:24:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: mingo@elte.hu, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Huang Ying <ying.huang@intel.com>, rientjes@google.com
Subject: Re: kexec boot regression
References: <20091215201909.GY28252@kernel.dk> <4B27EFC2.1000505@kernel.org> <20091215204221.GZ28252@kernel.dk> <20091215205512.GA28252@kernel.dk> <20091215210126.GB28252@kernel.dk> <4B27FEFB.30902@kernel.org> <20091215213032.GC28252@kernel.dk> <20091215214009.GD28252@kernel.dk> <4B2802E4.40404@kernel.org> <20091215214743.GE28252@kernel.dk> <20091215215214.GF28252@kernel.dk>
In-Reply-To: <20091215215214.GF28252@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Dec 15 2009, Jens Axboe wrote:
>>> oh, i post one patch last week, 
>>>
>>> can you check it?
>> Sure, let me try it. I already found out that commit 8716273c is the
>> guilty one (x86: Export srat physical topology).
> 
> Confirmed, -git with that patch works as well. So that's all of them I
> think, can we please get this expedited in so that -rc1 will work?
> Thanks!

updated version:

[PATCH] x86: fix checking of SRAT when node0 ram is not from 0 -v3

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

also fixs refression by 8716273c (x86: Export srat physical topology)

-v2: make it more solid to handle cross node case like node0 [0,4g), [8,12g) and node1 [4g, 8g), [12g, 16g)
-v3: update comments.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Jens Axboe <jens.axboe@oracle.com>

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
@@ -1037,6 +1037,9 @@ extern void add_active_range(unsigned in
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
@@ -3569,7 +3569,7 @@ static unsigned long __meminit zone_span
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-static unsigned long __meminit __absent_pages_in_range(int nid,
+unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
@@ -4098,7 +4098,7 @@ static int __init cmp_node_active_region
 }
 
 /* sort the node_map by start_pfn */
-static void __init sort_node_map(void)
+void __init sort_node_map(void)
 {
 	sort(early_node_map, (size_t)nr_nodemap_entries,
 			sizeof(struct node_active_region),
