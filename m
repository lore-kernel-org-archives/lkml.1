Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbXHXQ2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbXHXQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbXHXQ2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:28:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48782 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXHXQ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:28:17 -0400
Date: Fri, 24 Aug 2007 17:28:15 +0100
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: [PATCH] x86 Boot NUMA kernels on non-NUMA hardware with DISCONTIG memory model
Message-ID: <20070824162814.GD26374@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently NUMA kernels generally do not boot on non-NUMA machines in some
situations. This patch addresses one such boot problem on x86 machines
running a NUMA kernel with the DISCONTIG memory model.

On 32-bit NUMA, the memmap representing struct pages on each node is allocated
from node-local memory. As only node-0 has memory from ZONE_NORMAL, the memmap
must be mapped into low memory. This is done by reserving space in the Kernel
Virtual Area (KVA) for the memmap belonging to other nodes by taking pages
from the end of ZONE_NORMAL and remapping the other nodes memmap into those
virtual addresses. The node boundaries are then adjusted so that the region
of pages is not used and it is marked as reserved in the bootmem allocator.

This reserved portion of the KVA must be PMD aligned. The problem is that
when aligned, there may be a portion of ZONE_NORMAL at the end that is not
used for memmap and does not have an initialised memmap nor is it marked
reserved in the bootmem allocator. Later in the boot process, these pages
are freed and a storm of Bad page state messages result.

This patch marks these pages reserved that are wasted due to alignment
in the bootmem allocator so they are not accidently freed. It is worth
noting that memory from node-0 is wasted where it could have been put into
ZONE_HIGHMEM on NUMA machines. Worse, the KVA is always reserved from the
location of real memory even when there is plenty of spare virtual address
space. It's likely not worth fixing this up as SPARSEMEM will hopefully
replace DISCONTIG some time in the future.

This patch also makes sure that reserve_bootmem() is not called with a
0-length size in numa_kva_reserve().  When this happens, it usually means
that a kernel built for Summit is being booted on a normal machine. The
resulting BUG_ON() is misleading so it's caught here.

This patch allows the following NUMA configuration to boot on normal hardware
and qemu;

Processor type: Generic architecture (Summit, bigsmp, ES7000, default)
Memory model:   DISCONTIG
High memory:    64GB
NUMA support:   on

SPARSEMEM memory model is already working.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>

--- 
 discontig.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc3-mm1-clean/arch/i386/mm/discontig.c linux-2.6.23-rc3-mm1-numaboot/arch/i386/mm/discontig.c
--- linux-2.6.23-rc3-mm1-clean/arch/i386/mm/discontig.c	2007-08-22 11:32:10.000000000 +0100
+++ linux-2.6.23-rc3-mm1-numaboot/arch/i386/mm/discontig.c	2007-08-24 17:00:54.000000000 +0100
@@ -198,11 +198,12 @@ void __init remap_numa_kva(void)
 	}
 }
 
-static unsigned long calculate_numa_remap_pages(void)
+static unsigned long calculate_numa_remap_pages(unsigned long *wasted_pages)
 {
 	int nid;
 	unsigned long size, reserve_pages = 0;
 	unsigned long pfn;
+	*wasted_pages = 0;
 
 	for_each_online_node(nid) {
 		unsigned old_end_pfn = node_end_pfn[nid];
@@ -252,6 +253,15 @@ static unsigned long calculate_numa_rema
 			printk("Shrinking node %d further by %ld pages for proper alignment\n",
 				nid, node_end_pfn[nid] & (PTRS_PER_PTE-1));
 			size +=  node_end_pfn[nid] & (PTRS_PER_PTE-1);
+
+			/*
+			 * We are going to end up wasting pages past
+			 * the KVA for no good reason other than how
+			 * the KVA is located. This is bad.
+			 */
+			if (nid == 0)
+				*wasted_pages = node_end_pfn[nid] &
+							(PTRS_PER_PTE - 1);
 		}
 
 		node_end_pfn[nid] -= size;
@@ -268,6 +278,7 @@ unsigned long __init setup_memory(void)
 {
 	int nid;
 	unsigned long system_start_pfn, system_max_low_pfn;
+	unsigned long wasted_pages;
 
 	/*
 	 * When mapping a NUMA machine we allocate the node_mem_map arrays
@@ -279,7 +290,7 @@ unsigned long __init setup_memory(void)
 	find_max_pfn();
 	get_memcfg_numa();
 
-	kva_pages = calculate_numa_remap_pages();
+	kva_pages = calculate_numa_remap_pages(&wasted_pages);
 
 	/* partially used pages are not usable - thus round upwards */
 	system_start_pfn = min_low_pfn = PFN_UP(init_pg_tables_end);
@@ -340,12 +351,18 @@ unsigned long __init setup_memory(void)
 	memset(NODE_DATA(0), 0, sizeof(struct pglist_data));
 	NODE_DATA(0)->bdata = &node0_bdata;
 	setup_bootmem_allocator();
+
+	if (wasted_pages)
+		reserve_bootmem(
+			PFN_PHYS(node_remap_start_pfn[0] + node_remap_size[0]),
+			PFN_PHYS(wasted_pages));
 	return max_low_pfn;
 }
 
 void __init numa_kva_reserve(void)
 {
-	reserve_bootmem(PFN_PHYS(kva_start_pfn),PFN_PHYS(kva_pages));
+	if (kva_pages)
+		reserve_bootmem(PFN_PHYS(kva_start_pfn), PFN_PHYS(kva_pages));
 }
 
 void __init zone_sizes_init(void)
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
