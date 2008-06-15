Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYFOBcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYFOBcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 21:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbYFOBcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 21:32:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:14655 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbYFOBcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 21:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=lnN6fccg4NSiVYwqrBU6byirzHK2D2aDjReN3qc1dC3Y7oRhAKQjBpAULHC+vsDR1A
         M5FpNYaOaYhfEeInUcM3/EU9xnCNrGKX4EPArmhY2SQgF1pOwGVcYJlnuJdt9tLIJLg5
         h4DUzKjgQms7wQ81sBFUC8m7cwp+2snVAfjfU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ying Huang <ying.huang@intel.com>
Subject: [PATCH] x86: use add_highpages_with_active_regions for high pages init v2
Date: Sat, 14 Jun 2008 18:32:52 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806132005.45836.yhlu.kernel@gmail.com> <200806140056.32601.yhlu.kernel@gmail.com>
In-Reply-To: <200806140056.32601.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806141832.53668.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use early_node_map to init high pages, so can remove page_is_ram and
page_is_reserved_early in the big loop with add_one_highpage

also remove the page_is_reserved_early that is not needed.

v2: fix other platform compiling

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -612,17 +612,6 @@ void __init free_early(u64 start, u64 en
 	early_res[j - 1].end = 0;
 }
 
-int __init page_is_reserved_early(unsigned long pagenr)
-{
-	u64 start = (u64)pagenr << PAGE_SHIFT;
-	int i;
-	struct early_res *r;
-
-	i = find_overlapped_early(start, start + PAGE_SIZE);
-	r = &early_res[i];
-	return (i < MAX_EARLY_RES && r->end);
-}
-
 void __init early_res_to_bootmem(u64 start, u64 end)
 {
 	int i;
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -100,7 +100,6 @@ unsigned long node_memmap_size_bytes(int
 #endif
 
 extern unsigned long find_max_low_pfn(void);
-extern void add_one_highpage_init(struct page *, int, int);
 extern unsigned long highend_pfn, highstart_pfn;
 
 #define LARGE_PAGE_BYTES (PTRS_PER_PTE * PAGE_SIZE)
@@ -410,10 +409,10 @@ void __init set_highmem_pages_init(int b
 {
 #ifdef CONFIG_HIGHMEM
 	struct zone *zone;
-	struct page *page;
+	int nid;
 
 	for_each_zone(zone) {
-		unsigned long node_pfn, zone_start_pfn, zone_end_pfn;
+		unsigned long zone_start_pfn, zone_end_pfn;
 
 		if (!is_highmem(zone))
 			continue;
@@ -421,16 +420,12 @@ void __init set_highmem_pages_init(int b
 		zone_start_pfn = zone->zone_start_pfn;
 		zone_end_pfn = zone_start_pfn + zone->spanned_pages;
 
+		nid = zone_to_nid(zone);
 		printk("Initializing %s for node %d (%08lx:%08lx)\n",
-				zone->name, zone_to_nid(zone),
-				zone_start_pfn, zone_end_pfn);
+				zone->name, nid, zone_start_pfn, zone_end_pfn);
 
-		for (node_pfn = zone_start_pfn; node_pfn < zone_end_pfn; node_pfn++) {
-			if (!pfn_valid(node_pfn))
-				continue;
-			page = pfn_to_page(node_pfn);
-			add_one_highpage_init(page, node_pfn, bad_ppro);
-		}
+		add_highpages_with_active_regions(nid, zone_start_pfn,
+				 zone_end_pfn, bad_ppro);
 	}
 	totalram_pages += totalhigh_pages;
 #endif
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -292,10 +292,10 @@ static void __init permanent_kmaps_init(
 	pkmap_page_table = pte;
 }
 
-void __init add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
+static void __init
+add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
 {
-	if (page_is_ram(pfn) && !(bad_ppro && page_kills_ppro(pfn)) &&
-	    !page_is_reserved_early(pfn)) {
+	if (!(bad_ppro && page_kills_ppro(pfn))) {
 		ClearPageReserved(page);
 		init_page_count(page);
 		__free_page(page);
@@ -304,18 +304,58 @@ void __init add_one_highpage_init(struct
 		SetPageReserved(page);
 }
 
+struct add_highpages_data {
+	unsigned long start_pfn;
+	unsigned long end_pfn;
+	int bad_ppro;
+};
+
+static void __init add_highpages_work_fn(unsigned long start_pfn,
+					 unsigned long end_pfn, void *datax)
+{
+	int node_pfn;
+	struct page *page;
+	unsigned long final_start_pfn, final_end_pfn;
+	struct add_highpages_data *data;
+	int bad_ppro;
+
+	data = (struct add_highpages_data *)datax;
+	bad_ppro = data->bad_ppro;
+
+	final_start_pfn = max(start_pfn, data->start_pfn);
+	final_end_pfn = min(end_pfn, data->end_pfn);
+	if (final_start_pfn >= final_end_pfn)
+		return;
+
+	for (node_pfn = final_start_pfn; node_pfn < final_end_pfn;
+	     node_pfn++) {
+		if (!pfn_valid(node_pfn))
+			continue;
+		page = pfn_to_page(node_pfn);
+		add_one_highpage_init(page, node_pfn, bad_ppro);
+	}
+
+}
+
+void __init add_highpages_with_active_regions(int nid, unsigned long start_pfn,
+					      unsigned long end_pfn,
+					      int bad_ppro)
+{
+	struct add_highpages_data data;
+
+	data.start_pfn = start_pfn;
+	data.end_pfn = end_pfn;
+	data.bad_ppro = bad_ppro;
+
+	work_with_active_regions(nid, add_highpages_work_fn, &data);
+}
+
 #ifndef CONFIG_NUMA
 static void __init set_highmem_pages_init(int bad_ppro)
 {
-	int pfn;
+	add_highpages_with_active_regions(0, highstart_pfn, highend_pfn,
+						bad_ppro);
 
-	for (pfn = highstart_pfn; pfn < highend_pfn; pfn++) {
-		/*
-		 * Holes under sparsemem might not have no mem_map[]:
-		 */
-		if (pfn_valid(pfn))
-			add_one_highpage_init(pfn_to_page(pfn), pfn, bad_ppro);
-	}
 	totalram_pages += totalhigh_pages;
 }
 #endif /* !CONFIG_NUMA */
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -86,7 +86,6 @@ extern u64 find_e820_area_size(u64 start
 extern void reserve_early(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
 extern void early_res_to_bootmem(u64 start, u64 end);
-extern int page_is_reserved_early(unsigned long pagenr);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 
 extern unsigned long e820_end_of_ram(void);
Index: linux-2.6/include/asm-x86/highmem.h
===================================================================
--- linux-2.6.orig/include/asm-x86/highmem.h
+++ linux-2.6/include/asm-x86/highmem.h
@@ -74,6 +74,9 @@ struct page *kmap_atomic_to_page(void *p
 
 #define flush_cache_kmaps()	do { } while (0)
 
+extern void add_highpages_with_active_regions(int nid, unsigned long start_pfn,
+					unsigned long end_pfn, int bad_ppro);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_HIGHMEM_H */
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1011,6 +1011,8 @@ extern unsigned long find_min_pfn_with_a
 extern unsigned long find_max_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
+typedef void (*work_fn_t)(unsigned long, unsigned long, void *);
+extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -2939,6 +2939,14 @@ void __init free_bootmem_with_active_reg
 	}
 }
 
+void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
+{
+	int i;
+
+	for_each_active_range_index_in_nid(i, nid)
+		work_fn(early_node_map[i].start_pfn, early_node_map[i].end_pfn,
+			data);
+}
 /**
  * sparse_memory_present_with_active_regions - Call memory_present for each active range
  * @nid: The node to call memory_present for. If MAX_NUMNODES, all nodes will be used.
