Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYEYW2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYEYW2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 18:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYEYW2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 18:28:38 -0400
Received: from saeurebad.de ([85.214.36.134]:38000 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbYEYW2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 18:28:36 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Drop unneeded pgdat argument from free_area_init_node()
CC: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 26 May 2008 00:28:03 +0200
Message-ID: <87y75yvx1o.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_area_init_node() gets passed in the node id as well as the node
descriptor.  This is redundant as the function can trivially get the
node descriptor itself by means of NODE_DATA() and the node's id.

Signed-off-by: Johannes Weiner <hannes@saeurebad.d>
---

I checked all the users and NODE_DATA() seems to be usable everywhere
from where this function is called.

Compile- and runtime-tested on X86_32.

 arch/alpha/mm/numa.c             |    2 +-
 arch/arm/mm/init.c               |    2 +-
 arch/avr32/mm/init.c             |    2 +-
 arch/cris/arch-v10/mm/init.c     |    2 +-
 arch/cris/arch-v32/mm/init.c     |    2 +-
 arch/m32r/mm/discontig.c         |    3 +--
 arch/m32r/mm/init.c              |    2 +-
 arch/m68k/mm/motorola.c          |    2 +-
 arch/m68k/mm/sun3mmu.c           |    2 +-
 arch/mips/sgi-ip27/ip27-memory.c |    3 +--
 arch/parisc/mm/init.c            |    2 +-
 arch/sparc/mm/srmmu.c            |    3 +--
 arch/sparc/mm/sun4c.c            |    3 +--
 arch/v850/kernel/setup.c         |    3 +--
 include/linux/mm.h               |    5 ++---
 mm/memory_hotplug.c              |    2 +-
 mm/page_alloc.c                  |   11 ++++++-----
 17 files changed, 23 insertions(+), 28 deletions(-)

--- a/arch/alpha/mm/numa.c
+++ b/arch/alpha/mm/numa.c
@@ -313,7 +313,7 @@ void __init paging_init(void)
 			zones_size[ZONE_DMA] = dma_local_pfn;
 			zones_size[ZONE_NORMAL] = (end_pfn - start_pfn) - dma_local_pfn;
 		}
-		free_area_init_node(nid, NODE_DATA(nid), zones_size, start_pfn, NULL);
+		free_area_init_node(nid, zones_size, start_pfn, NULL);
 	}
 
 	/* Initialize the kernel's ZERO_PGE. */
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -284,7 +284,7 @@ bootmem_init_node(int node, int initrd_n
 	 */
 	arch_adjust_zones(node, zone_size, zhole_size);
 
-	free_area_init_node(node, pgdat, zone_size, start_pfn, zhole_size);
+	free_area_init_node(node, zone_size, start_pfn, zhole_size);
 
 	return end_pfn;
 }
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -135,7 +135,7 @@ void __init paging_init(void)
 		printk("Node %u: start_pfn = 0x%lx, low = 0x%lx\n",
 		       nid, start_pfn, low);
 
-		free_area_init_node(nid, pgdat, zones_size, start_pfn, NULL);
+		free_area_init_node(nid, zones_size, start_pfn, NULL);
 
 		printk("Node %u: mem_map starts at %p\n",
 		       pgdat->node_id, pgdat->node_mem_map);
--- a/arch/cris/arch-v10/mm/init.c
+++ b/arch/cris/arch-v10/mm/init.c
@@ -182,7 +182,7 @@ paging_init(void)
 	 * mem_map page array.
 	 */
 
-	free_area_init_node(0, &contig_page_data, zones_size, PAGE_OFFSET >> PAGE_SHIFT, 0);
+	free_area_init_node(0, zones_size, PAGE_OFFSET >> PAGE_SHIFT, 0);
 }
 
 /* Initialize remaps of some I/O-ports. It is important that this
--- a/arch/cris/arch-v32/mm/init.c
+++ b/arch/cris/arch-v32/mm/init.c
@@ -162,7 +162,7 @@ paging_init(void)
 	 * substantially higher than 0, like us (we start at PAGE_OFFSET). This
 	 * saves space in the mem_map page array.
 	 */
-	free_area_init_node(0, &contig_page_data, zones_size, PAGE_OFFSET >> PAGE_SHIFT, 0);
+	free_area_init_node(0, zones_size, PAGE_OFFSET >> PAGE_SHIFT, 0);
 
 	mem_map = contig_page_data.node_mem_map;
 }
--- a/arch/m32r/mm/discontig.c
+++ b/arch/m32r/mm/discontig.c
@@ -148,8 +148,7 @@ unsigned long __init zone_sizes_init(voi
 		zholes_size[ZONE_DMA] = mp->holes;
 		holes += zholes_size[ZONE_DMA];
 
-		free_area_init_node(nid, NODE_DATA(nid), zones_size,
-			start_pfn, zholes_size);
+		free_area_init_node(nid, zones_size, start_pfn, zholes_size);
 	}
 
 	/*
--- a/arch/m32r/mm/init.c
+++ b/arch/m32r/mm/init.c
@@ -123,7 +123,7 @@ unsigned long __init zone_sizes_init(voi
 	start_pfn = __MEMORY_START >> PAGE_SHIFT;
 #endif /* CONFIG_MMU */
 
-	free_area_init_node(0, NODE_DATA(0), zones_size, start_pfn, 0);
+	free_area_init_node(0, zones_size, start_pfn, 0);
 
 	return 0;
 }
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -297,7 +297,7 @@ void __init paging_init(void)
 #endif
 	for (i = 0; i < m68k_num_memory; i++) {
 		zones_size[ZONE_DMA] = m68k_memory[i].size >> PAGE_SHIFT;
-		free_area_init_node(i, pg_data_map + i, zones_size,
+		free_area_init_node(i, zones_size,
 				    m68k_memory[i].addr >> PAGE_SHIFT, NULL);
 	}
 }
--- a/arch/m68k/mm/sun3mmu.c
+++ b/arch/m68k/mm/sun3mmu.c
@@ -95,7 +95,7 @@ void __init paging_init(void)
 
 	/* I really wish I knew why the following change made things better...  -- Sam */
 /*	free_area_init(zones_size); */
-	free_area_init_node(0, NODE_DATA(0), zones_size,
+	free_area_init_node(0, zones_size,
 			    (__pa(PAGE_OFFSET) >> PAGE_SHIFT) + 1, NULL);
 
 
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -519,8 +519,7 @@ void __init paging_init(void)
 		pfn_t end_pfn = node_getmaxclick(node) + 1;
 
 		zones_size[ZONE_NORMAL] = end_pfn - start_pfn;
-		free_area_init_node(node, NODE_DATA(node),
-				zones_size, start_pfn, NULL);
+		free_area_init_node(node, zones_size, start_pfn, NULL);
 
 		if (end_pfn > max_low_pfn)
 			max_low_pfn = end_pfn;
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -887,7 +887,7 @@ void __init paging_init(void)
 		}
 #endif
 
-		free_area_init_node(i, NODE_DATA(i), zones_size,
+		free_area_init_node(i, zones_size,
 				pmem_ranges[i].start_pfn, NULL);
 	}
 }
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -1348,8 +1348,7 @@ void __init srmmu_paging_init(void)
 		zones_size[ZONE_HIGHMEM] = npages;
 		zholes_size[ZONE_HIGHMEM] = npages - calc_highpages();
 
-		free_area_init_node(0, &contig_page_data, zones_size,
-				    pfn_base, zholes_size);
+		free_area_init_node(0, zones_size, pfn_base, zholes_size);
 	}
 }
 
--- a/arch/sparc/mm/sun4c.c
+++ b/arch/sparc/mm/sun4c.c
@@ -2123,8 +2123,7 @@ void __init sun4c_paging_init(void)
 		zones_size[ZONE_HIGHMEM] = npages;
 		zholes_size[ZONE_HIGHMEM] = npages - calc_highpages();
 
-		free_area_init_node(0, &contig_page_data, zones_size,
-				    pfn_base, zholes_size);
+		free_area_init_node(0, zones_size, pfn_base, zholes_size);
 	}
 
 	cnt = 0;
--- a/arch/v850/kernel/setup.c
+++ b/arch/v850/kernel/setup.c
@@ -295,8 +295,7 @@ init_mem_alloc (unsigned long ram_start,
 #error MAX_ORDER is too large for given PAGE_OFFSET (use CONFIG_FORCE_MAX_ZONEORDER to change it)
 #endif
 	NODE_DATA(0)->node_mem_map = NULL;
-	free_area_init_node (0, NODE_DATA(0), zones_size,
-			     ADDR_TO_PAGE (PAGE_OFFSET), 0);
+	free_area_init_node(0, zones_size, ADDR_TO_PAGE (PAGE_OFFSET), 0);
 }
 
 
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -455,7 +455,7 @@ static pg_data_t *hotadd_new_pgdat(int n
 	/* we can use NODE_DATA(nid) from here */
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
-	free_area_init_node(nid, pgdat, zones_size, start_pfn, zholes_size);
+	free_area_init_node(nid, zones_size, start_pfn, zholes_size);
 
 	return pgdat;
 }
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3477,10 +3477,11 @@ static void __init_refok alloc_node_mem_
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
 }
 
-void __paginginit free_area_init_node(int nid, struct pglist_data *pgdat,
-		unsigned long *zones_size, unsigned long node_start_pfn,
-		unsigned long *zholes_size)
+void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
+		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
+	pg_data_t *pgdat = NODE_DATA(nid);
+
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
@@ -3927,7 +3928,7 @@ void __init free_area_init_nodes(unsigne
 	setup_nr_node_ids();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
-		free_area_init_node(nid, pgdat, NULL,
+		free_area_init_node(nid, NULL,
 				find_min_pfn_for_node(nid), NULL);
 
 		/* Any memory on that node */
@@ -4000,7 +4001,7 @@ EXPORT_SYMBOL(contig_page_data);
 
 void __init free_area_init(unsigned long *zones_size)
 {
-	free_area_init_node(0, NODE_DATA(0), zones_size,
+	free_area_init_node(0, zones_size,
 			__pa(PAGE_OFFSET) >> PAGE_SHIFT, NULL);
 }
 
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -963,9 +963,8 @@ static inline void pgtable_page_dtor(str
 		NULL: pte_offset_kernel(pmd, address))
 
 extern void free_area_init(unsigned long * zones_size);
-extern void free_area_init_node(int nid, pg_data_t *pgdat,
-	unsigned long * zones_size, unsigned long zone_start_pfn, 
-	unsigned long *zholes_size);
+extern void free_area_init_node(int nid, unsigned long * zones_size,
+		unsigned long zone_start_pfn, unsigned long *zholes_size);
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
 /*
  * With CONFIG_ARCH_POPULATES_NODE_MAP set, an architecture may initialise its
