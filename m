Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbZCBQ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbZCBQ7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbZCBQ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:58:05 -0500
Received: from mx1.emlix.com ([193.175.82.87]:36350 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824AbZCBQ6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:58:01 -0500
References: <20090302164257.477296438@emlix.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 17:43:04 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 7/7] xtensa: cope with ram beginning at higher addresses
Content-Disposition: inline; filename=xtensa-cope-with-ram-beginning-at-higher-addresses.patch
Message-Id: <E1LeBSp-0003ZA-Gr@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current assumption of the memory code is that the first RAM PFN in
the system is 0.

Adjust the relevant code to play well with setups where memory starts
at higher addresses, indicated by PLATFORM_DEFAULT_MEM_START.

The new memory model looks like this:

+----------+--+----------------------+----------------+
|          |  |                      |                |
|          |  |         RAM          |                |
|          |  |                      |                |
+----------+--+----------------------+----------------+
|          |  |                      |                |
+- PFN 0   |  +- min_low_pfn         +- max_low_pfn   +- max_pfn
           |
           +- ARCH_PFN_OFFSET
           +- PLATFORM_DEFAULT_MEM_START >> PAGE_SIZE

The memory map contains pages starting from pfn ARCH_PFN_OFFSET up to
max_low_pfn.  The only zone used right now will span exactly the same
region.

Usually, ARCH_PFN_OFFSET and min_low_pfn are the same value.  Handle
them separately for robustness.  Gapping pages will be in the memory
map but marked as reserved and won't be touched.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/include/asm/page.h |    5 ++++-
 arch/xtensa/mm/init.c          |   10 +++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/arch/xtensa/include/asm/page.h
+++ b/arch/xtensa/include/asm/page.h
@@ -14,6 +14,7 @@
 #include <asm/processor.h>
 #include <asm/types.h>
 #include <asm/cache.h>
+#include <platform/hardware.h>
 
 /*
  * Fixed TLB translations in the processor.
@@ -150,9 +151,11 @@ extern void copy_user_page(void*, void*,
  * addresses.
  */
 
+#define ARCH_PFN_OFFSET		(PLATFORM_DEFAULT_MEM_START >> PAGE_SHIFT)
+
 #define __pa(x)			((unsigned long) (x) - PAGE_OFFSET)
 #define __va(x)			((void *)((unsigned long) (x) + PAGE_OFFSET))
-#define pfn_valid(pfn)		((unsigned long)pfn < max_mapnr)
+#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && ((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
 #ifdef CONFIG_DISCONTIGMEM
 # error CONFIG_DISCONTIGMEM not supported
 #endif
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -167,7 +167,7 @@ void __init paging_init(void)
 
 	/* All pages are DMA-able, so we put them all in the DMA zone. */
 
-	zones_size[ZONE_DMA] = max_low_pfn;
+	zones_size[ZONE_DMA] = max_low_pfn - ARCH_PFN_OFFSET;
 	for (i = 1; i < MAX_NR_ZONES; i++)
 		zones_size[i] = 0;
 
@@ -179,7 +179,7 @@ void __init paging_init(void)
 
 	memset(swapper_pg_dir, 0, PAGE_SIZE);
 
-	free_area_init(zones_size);
+	free_area_init_node(0, zones_size, ARCH_PFN_OFFSET, NULL);
 }
 
 /*
@@ -220,8 +220,8 @@ void __init mem_init(void)
 	unsigned long codesize, reservedpages, datasize, initsize;
 	unsigned long highmemsize, tmp, ram;
 
-	max_mapnr = num_physpages = max_low_pfn;
-	high_memory = (void *) __va(max_mapnr << PAGE_SHIFT);
+	max_mapnr = num_physpages = max_low_pfn - ARCH_PFN_OFFSET;
+	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 	highmemsize = 0;
 
 #ifdef CONFIG_HIGHMEM
@@ -231,7 +231,7 @@ void __init mem_init(void)
 	totalram_pages += free_all_bootmem();
 
 	reservedpages = ram = 0;
-	for (tmp = 0; tmp < max_low_pfn; tmp++) {
+	for (tmp = 0; tmp < max_mapnr; tmp++) {
 		ram++;
 		if (PageReserved(mem_map+tmp))
 			reservedpages++;

-- 

