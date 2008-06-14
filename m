Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYFNH4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYFNH4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 03:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYFNHzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 03:55:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:28424 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYFNHzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 03:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Z9sr8a+H4n7b1xmyr5hXg/azEQ4gV4ZCft/zgLz9vRFaVRIOOJHhS94cVLRJKyAF5Y
         5xBOXj0atF68bNersYWxrPOTONvAXUV9HUgeaQMK0umY3WrYtWwxmLX2ue9H/FPfufzU
         LBOPAZLr16megias/yIIgz0dSvY/XUvWPVoXw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ying Huang <ying.huang@intel.com>
Subject: [PATCH] x86: use add_highpages_with_active_regions for high pages init
Date: Sat, 14 Jun 2008 00:56:32 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806132005.45836.yhlu.kernel@gmail.com>
In-Reply-To: <200806132005.45836.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806140056.32601.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use early_node_map to init high pages, so can remove page_is_ram and
page_is_reserved_early in the big loop with add_one_highpage

also remove the page_is_reserved_early that is not needed.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 4f2cd5d..a87843b 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -612,17 +612,6 @@ void __init free_early(u64 start, u64 end)
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
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index c6ce6a5..5444be2 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -100,7 +100,6 @@ unsigned long node_memmap_size_bytes(int nid, unsigned long start_pfn,
 #endif
 
 extern unsigned long find_max_low_pfn(void);
-extern void add_one_highpage_init(struct page *, int, int);
 extern unsigned long highend_pfn, highstart_pfn;
 
 #define LARGE_PAGE_BYTES (PTRS_PER_PTE * PAGE_SIZE)
@@ -407,10 +406,10 @@ void __init set_highmem_pages_init(int bad_ppro)
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
@@ -418,16 +417,12 @@ void __init set_highmem_pages_init(int bad_ppro)
 		zone_start_pfn = zone->zone_start_pfn;
 		zone_end_pfn = zone_start_pfn + zone->spanned_pages;
 
+		nid = zone_to_nid(zone);
 		printk("Initializing %s for node %d (%08lx:%08lx)\n",
-				zone->name, zone_to_nid(zone),
-				zone_start_pfn, zone_end_pfn);
-
-		for (node_pfn = zone_start_pfn; node_pfn < zone_end_pfn; node_pfn++) {
-			if (!pfn_valid(node_pfn))
-				continue;
-			page = pfn_to_page(node_pfn);
-			add_one_highpage_init(page, node_pfn, bad_ppro);
-		}
+				zone->name, nid, zone_start_pfn, zone_end_pfn);
+
+		add_highpages_with_active_regions(nid, zone_start_pfn,
+				 zone_end_pfn, bad_ppro);
 	}
 	totalram_pages += totalhigh_pages;
 #endif
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 4f308fa..502b2a9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -294,8 +294,7 @@ static void __init permanent_kmaps_init(pgd_t *pgd_base)
 
 void __init add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
 {
-	if (page_is_ram(pfn) && !(bad_ppro && page_kills_ppro(pfn)) &&
-	    !page_is_reserved_early(pfn)) {
+	if (!(bad_ppro && page_kills_ppro(pfn))) {
 		ClearPageReserved(page);
 		init_page_count(page);
 		__free_page(page);
@@ -307,15 +306,9 @@ void __init add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
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
diff --git a/include/asm-x86/e820.h b/include/asm-x86/e820.h
index a5959e3..b336666 100644
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -86,7 +86,6 @@ extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
 extern void reserve_early(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
 extern void early_res_to_bootmem(u64 start, u64 end);
-extern int page_is_reserved_early(unsigned long pagenr);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 
 extern unsigned long e820_end_of_ram(void);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77b5ec6..df4c0fa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1010,6 +1010,8 @@ extern unsigned long find_min_pfn_with_active_regions(void);
 extern unsigned long find_max_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
+extern void add_highpages_with_active_regions(int nid, unsigned long start_pfn,
+					unsigned long end_pfn, int bad_ppro);
 extern void sparse_memory_present_with_active_regions(int nid);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 17ef776..5cd82a6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2939,6 +2939,30 @@ void __init free_bootmem_with_active_regions(int nid,
 	}
 }
 
+extern void add_one_highpage_init(struct page *, int, int);
+void __init add_highpages_with_active_regions(int nid, unsigned long start_pfn,
+					unsigned long end_pfn, int bad_ppro)
+{
+	int i;
+	int node_pfn;
+	struct page *page;
+	unsigned long final_start_pfn, final_end_pfn;
+
+	for_each_active_range_index_in_nid(i, nid){
+		final_start_pfn = max(start_pfn, early_node_map[i].start_pfn);
+		final_end_pfn = min(end_pfn, early_node_map[i].end_pfn);
+		if (final_start_pfn >= final_end_pfn)
+			continue;
+
+		for (node_pfn = final_start_pfn; node_pfn < final_end_pfn;
+		     node_pfn++) {
+			if (!pfn_valid(node_pfn))
+				continue;
+			page = pfn_to_page(node_pfn);
+			add_one_highpage_init(page, node_pfn, bad_ppro);
+		}
+	}
+}
 /**
  * sparse_memory_present_with_active_regions - Call memory_present for each active range
  * @nid: The node to call memory_present for. If MAX_NUMNODES, all nodes will be used.
