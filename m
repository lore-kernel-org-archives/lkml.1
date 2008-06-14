Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYFNDHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYFNDHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 23:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbYFNDGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 23:06:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:40693 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbYFNDGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 23:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=IHF0o8y6ZH8Ym0ZUiGTdlh23T0Z8Vsgt37jMtEUSvJifNg4+vBxRNWZw/p/lPIOWR2
         k3xnXnliAVOzUYvtUB4GV1SQyxzcs+bzJcYwLckVHE8Vs2e88QARuPt3mc+lOLqn8qAT
         4s+X90gEwCoXhSSr+Wbo7/vvY9ZW9zYwEoOBA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: replace shrink pages with remove_active_ranges v2
Date: Fri, 13 Jun 2008 20:05:45 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806132005.45836.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in case we have kva before ramdisk on node, we still need to use
those ranges.

v2: reserve_early kva ram area, in case there are holes in highmem, to avoid
    those area could be treat as free high pages.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -227,8 +227,8 @@ static unsigned long calculate_numa_rema
 	unsigned long size, reserve_pages = 0;
 
 	for_each_online_node(nid) {
-		u64 node_end_target;
-		u64 node_end_final;
+		u64 node_kva_target;
+		u64 node_kva_final;
 
 		/*
 		 * The acpi/srat node info can show hot-add memroy zones
@@ -251,42 +251,45 @@ static unsigned long calculate_numa_rema
 		/* now the roundup is correct, convert to PAGE_SIZE pages */
 		size = size * PTRS_PER_PTE;
 
-		node_end_target = round_down(node_end_pfn[nid] - size,
+		node_kva_target = round_down(node_end_pfn[nid] - size,
 						 PTRS_PER_PTE);
-		node_end_target <<= PAGE_SHIFT;
+		node_kva_target <<= PAGE_SHIFT;
 		do {
-			node_end_final = find_e820_area(node_end_target,
+			node_kva_final = find_e820_area(node_kva_target,
 					((u64)node_end_pfn[nid])<<PAGE_SHIFT,
 						((u64)size)<<PAGE_SHIFT,
 						LARGE_PAGE_BYTES);
-			node_end_target -= LARGE_PAGE_BYTES;
-		} while (node_end_final == -1ULL &&
-			 (node_end_target>>PAGE_SHIFT) > (node_start_pfn[nid]));
+			node_kva_target -= LARGE_PAGE_BYTES;
+		} while (node_kva_final == -1ULL &&
+			 (node_kva_target>>PAGE_SHIFT) > (node_start_pfn[nid]));
 
-		if (node_end_final == -1ULL)
+		if (node_kva_final == -1ULL)
 			panic("Can not get kva ram\n");
 
-		printk("Reserving %ld pages of KVA for lmem_map of node %d\n",
-				size, nid);
 		node_remap_size[nid] = size;
 		node_remap_offset[nid] = reserve_pages;
 		reserve_pages += size;
-		printk("Shrinking node %d from %ld pages to %lld pages\n",
-			nid, node_end_pfn[nid], node_end_final>>PAGE_SHIFT);
+		printk("Reserving %ld pages of KVA for lmem_map of node %d at %llx\n",
+				size, nid, node_kva_final>>PAGE_SHIFT);
 
 		/*
 		 *  prevent kva address below max_low_pfn want it on system
 		 *  with less memory later.
 		 *  layout will be: KVA address , KVA RAM
+		 *
+		 *  we are supposed to only record the one less then max_low_pfn
+		 *  but we could have some hole in high memory, and it will only
+		 *  check page_is_ram(pfn) && !page_is_reserved_early(pfn) to decide
+		 *  to use it as free.
+		 *  So reserve_early here, hope we don't run out of that array
 		 */
-		if ((node_end_final>>PAGE_SHIFT) < max_low_pfn)
-			reserve_early(node_end_final,
-				      node_end_final+(((u64)size)<<PAGE_SHIFT),
-				      "KVA RAM");
-
-		node_end_pfn[nid] = node_end_final>>PAGE_SHIFT;
-		node_remap_start_pfn[nid] = node_end_pfn[nid];
-		shrink_active_range(nid, node_end_pfn[nid]);
+		reserve_early(node_kva_final,
+			      node_kva_final+(((u64)size)<<PAGE_SHIFT),
+			      "KVA RAM");
+
+		node_remap_start_pfn[nid] = node_kva_final>>PAGE_SHIFT;
+		remove_active_range(nid, node_remap_start_pfn[nid],
+					 node_remap_start_pfn[nid] + size);
 	}
 	printk("Reserving total of %ld pages for numa KVA remap\n",
 			reserve_pages);
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -998,7 +998,8 @@ extern void free_area_init_node(int nid,
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
 extern void add_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
-extern void shrink_active_range(unsigned int nid, unsigned long new_end_pfn);
+extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
+					unsigned long end_pfn);
 extern void push_node_boundaries(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3562,30 +3562,47 @@ void __init add_active_range(unsigned in
 }
 
 /**
- * shrink_active_range - Shrink an existing registered range of PFNs
+ * remove_active_range - Shrink an existing registered range of PFNs
  * @nid: The node id the range is on that should be shrunk
- * @new_end_pfn: The new PFN of the range
+ * @start_pfn: The new PFN of the range
+ * @end_pfn: The new PFN of the range
  *
  * i386 with NUMA use alloc_remap() to store a node_mem_map on a local node.
  * The map is kept near the end physical page range that has already been
  * registered. This function allows an arch to shrink an existing registered
  * range.
  */
-void __init shrink_active_range(unsigned int nid, unsigned long new_end_pfn)
+void __init remove_active_range(unsigned int nid, unsigned long start_pfn,
+				unsigned long end_pfn)
 {
 	int i, j;
 	int removed = 0;
 
+	printk(KERN_DEBUG "remove_active_range (%d, %lu, %lu)\n",
+			  nid, start_pfn, end_pfn);
+
 	/* Find the old active region end and shrink */
 	for_each_active_range_index_in_nid(i, nid) {
-		if (early_node_map[i].start_pfn >= new_end_pfn) {
+		if (early_node_map[i].start_pfn >= start_pfn &&
+		    early_node_map[i].end_pfn <= end_pfn) {
 			/* clear it */
+			early_node_map[i].start_pfn = 0;
 			early_node_map[i].end_pfn = 0;
 			removed = 1;
 			continue;
 		}
-		if (early_node_map[i].end_pfn > new_end_pfn) {
-			early_node_map[i].end_pfn = new_end_pfn;
+		if (early_node_map[i].start_pfn < start_pfn &&
+		    early_node_map[i].end_pfn > start_pfn) {
+			unsigned long temp_end_pfn = early_node_map[i].end_pfn;
+			early_node_map[i].end_pfn = start_pfn;
+			if (temp_end_pfn > end_pfn)
+				add_active_range(nid, end_pfn, temp_end_pfn);
+			continue;
+		}
+		if (early_node_map[i].start_pfn >= start_pfn &&
+		    early_node_map[i].end_pfn > end_pfn &&
+		    early_node_map[i].start_pfn < end_pfn) {
+			early_node_map[i].start_pfn = end_pfn;
 			continue;
 		}
 	}
