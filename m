Return-Path: <linux-kernel-owner+w=401wt.eu-S1763719AbYALLVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763719AbYALLVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762306AbYALLU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:20:57 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61000 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762211AbYALLU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:20:56 -0500
Date: Sat, 12 Jan 2008 03:26:25 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_64: cleanup setup_node_zones called by paging_init v2
In-reply-to: <Pine.LNX.4.64.0801091117430.11317@schroedinger.engr.sgi.com>
To: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200801120326.25688.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801081934.33964.yinghai.lu@sun.com>
 <200801091030.40545.yinghai.lu@sun.com>
 <Pine.LNX.4.64.0801091117430.11317@schroedinger.engr.sgi.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 11:19:01 am Christoph Lameter wrote:
> On Wed, 9 Jan 2008, Yinghai Lu wrote:
> 

Christoph's

x86: 64-bit, make sparsemem vmemmap the only memory model

is in x86.git mm

so we could remove setup_node_zones because it is not needed by SPARSEMEM

please check the following patch.

YH

[PATCH] x86_84: only support sparsemem fix
sparsemem is only one supported, so could remove FLAT_NODE_MEM related code, that is
only needed !SPARSEMEM

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 8482314..4c286b7 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -233,32 +233,6 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	node_set_online(nodeid);
 }
 
-/* Initialize final allocator for a zone */
-void __init setup_node_zones(int nodeid)
-{
-	unsigned long start_pfn, end_pfn, memmapsize, limit;
-
-	start_pfn = node_start_pfn(nodeid);
-	end_pfn = node_end_pfn(nodeid);
-
-	Dprintk(KERN_INFO "Setting up memmap for node %d %lx-%lx\n",
-		nodeid, start_pfn, end_pfn);
-
-	/*
-	 * Try to allocate mem_map at end to not fill up precious <4GB
-	 * memory.
-	 */
-	memmapsize = sizeof(struct page) * (end_pfn-start_pfn);
-	limit = end_pfn << PAGE_SHIFT;
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
-	NODE_DATA(nodeid)->node_mem_map =
-		__alloc_bootmem_core(NODE_DATA(nodeid)->bdata,
-				     memmapsize, SMP_CACHE_BYTES,
-				     round_down(limit - memmapsize, PAGE_SIZE),
-				     limit);
-#endif
-}
-
 /*
  * There are unfortunately some poorly designed mainboards around that
  * only connect memory to a single CPU. This breaks the 1:1 cpu->node
@@ -580,9 +554,6 @@ void __init paging_init(void)
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 
-	for_each_online_node(i)
-		setup_node_zones(i);
-
 	free_area_init_nodes(max_zone_pfns);
 }
 
