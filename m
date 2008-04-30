Return-Path: <linux-kernel-owner+w=401wt.eu-S1763953AbYD3Rxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763953AbYD3Rxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763797AbYD3RxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:53:10 -0400
Received: from saeurebad.de ([85.214.36.134]:60195 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763188AbYD3RxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:53:08 -0400
X-Mailbox-Line: From hannes@symbol.fehenstaub.lan Wed Apr 30 19:08:39 2008
Message-Id: <20080430170839.566764928@symbol.fehenstaub.lan>
References: <20080430170521.246745395@symbol.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Wed, 30 Apr 2008 19:05:23 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 2/4] mm: Fix free_all_bootmem_core alignment check
Content-Disposition: inline; filename=mm-fix-free_all_bootmem_core-alignment-check.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for node_boot_start is bogus because we start freeing at the
corresponding pfn.  So check if the pfn is properly aligned instead in
a more readable way and adjust the documentation.

Also remove an unneeded accounting variable.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>
---

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -376,7 +376,7 @@ static unsigned long __init free_all_boo
 	struct page *page;
 	unsigned long pfn;
 	bootmem_data_t *bdata = pgdat->bdata;
-	unsigned long i, count, total = 0;
+	unsigned long i, count;
 	unsigned long idx;
 	unsigned long *map; 
 	int gofast = 0;
@@ -388,10 +388,13 @@ static unsigned long __init free_all_boo
 	pfn = PFN_DOWN(bdata->node_boot_start);
 	idx = bdata->node_low_pfn - pfn;
 	map = bdata->node_bootmem_map;
-	/* Check physaddr is O(LOG2(BITS_PER_LONG)) page aligned */
-	if (bdata->node_boot_start == 0 ||
-	    ffs(bdata->node_boot_start) - PAGE_SHIFT > ffs(BITS_PER_LONG))
+	/*
+	 * Check if we are aligned to BITS_PER_LONG pages.  If so, we might
+	 * be able to free page orders of that size at once.
+	 */
+	if (!(pfn & (BITS_PER_LONG-1)))
 		gofast = 1;
+
 	for (i = 0; i < idx; ) {
 		unsigned long v = ~map[i / BITS_PER_LONG];
 
@@ -419,23 +422,19 @@ static unsigned long __init free_all_boo
 		}
 		pfn += BITS_PER_LONG;
 	}
-	total += count;
 
 	/*
 	 * Now free the allocator bitmap itself, it's not
 	 * needed anymore:
 	 */
 	page = virt_to_page(bdata->node_bootmem_map);
-	count = 0;
 	idx = (get_mapsize(bdata) + PAGE_SIZE-1) >> PAGE_SHIFT;
-	for (i = 0; i < idx; i++, page++) {
+	for (i = 0; i < idx; i++, page++)
 		__free_pages_bootmem(page, 0);
-		count++;
-	}
-	total += count;
+	count += i;
 	bdata->node_bootmem_map = NULL;
 
-	return total;
+	return count;
 }
 
 unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,

-- 

