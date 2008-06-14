Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbYFNIud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbYFNIud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 04:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYFNIuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 04:50:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48711 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbYFNIuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 04:50:23 -0400
Date: Sat, 14 Jun 2008 10:50:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ying Huang <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use add_highpages_with_active_regions for high
	pages init
Message-ID: <20080614085008.GA28867@elte.hu>
References: <200806132005.45836.yhlu.kernel@gmail.com> <200806140056.32601.yhlu.kernel@gmail.com> <20080614082343.GB11277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614082343.GB11277@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > use early_node_map to init high pages, so can remove page_is_ram and 
> > page_is_reserved_early in the big loop with add_one_highpage
> > 
> > also remove the page_is_reserved_early that is not needed.
> 
> applied to tip/x86/mpparse for testing, thanks.
> 
> Andrew: mm/page_alloc.c modification.

i ended up doing the change below.

'bad_ppro' looked quite ugly in mm/page_alloc.c, and there was also a 
64-bit build failure, so i moved the function out of page_alloc.c, into 
the 32-bit x86 code.

	Ingo

------------->
commit 30847a7f5650248cd8435b7646eef0b9cfd66095
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Jun 14 10:41:09 2008 +0200

    x86: move add_highpages_with_active_regions() to 32-bit
    
    this is an x86 32-bit highmem-only function, so move it out of
    mm/page_alloc.c.
    
    this also solves this 64-bit build failure:
    
    mm/built-in.o: In function `add_highpages_with_active_regions':
    (.init.text+0x1833): undefined reference to `add_one_highpage_init'

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 6652f14..3400289 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -287,7 +287,8 @@ static void __init permanent_kmaps_init(pgd_t *pgd_base)
 	pkmap_page_table = pte;
 }
 
-void __init add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
+static void __init
+add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
 {
 	if (!(bad_ppro && page_kills_ppro(pfn))) {
 		ClearPageReserved(page);
@@ -298,6 +299,30 @@ void __init add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
 		SetPageReserved(page);
 }
 
+void __init add_highpages_with_active_regions(int nid, unsigned long start_pfn,
+					unsigned long end_pfn, int bad_ppro)
+{
+	int i;
+	int node_pfn;
+	struct page *page;
+	unsigned long final_start_pfn, final_end_pfn;
+
+	for_each_active_range_index_in_nid(i, nid) {
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
+
 #ifndef CONFIG_NUMA
 static void __init set_highmem_pages_init(int bad_ppro)
 {
diff --git a/include/asm-x86/highmem.h b/include/asm-x86/highmem.h
index e153f3b..85c4fea 100644
--- a/include/asm-x86/highmem.h
+++ b/include/asm-x86/highmem.h
@@ -74,6 +74,9 @@ struct page *kmap_atomic_to_page(void *ptr);
 
 #define flush_cache_kmaps()	do { } while (0)
 
+extern void add_highpages_with_active_regions(int nid, unsigned long start_pfn,
+					unsigned long end_pfn, int bad_ppro);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_HIGHMEM_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4a5d33f..c4f6553 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1010,8 +1010,6 @@ extern unsigned long find_min_pfn_with_active_regions(void);
 extern unsigned long find_max_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
-extern void add_highpages_with_active_regions(int nid, unsigned long start_pfn,
-					unsigned long end_pfn, int bad_ppro);
 extern void sparse_memory_present_with_active_regions(int nid);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ad1b684..26a028c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2955,30 +2955,6 @@ void __init free_bootmem_with_active_regions(int nid,
 	}
 }
 
-extern void add_one_highpage_init(struct page *, int, int);
-void __init add_highpages_with_active_regions(int nid, unsigned long start_pfn,
-					unsigned long end_pfn, int bad_ppro)
-{
-	int i;
-	int node_pfn;
-	struct page *page;
-	unsigned long final_start_pfn, final_end_pfn;
-
-	for_each_active_range_index_in_nid(i, nid) {
-		final_start_pfn = max(start_pfn, early_node_map[i].start_pfn);
-		final_end_pfn = min(end_pfn, early_node_map[i].end_pfn);
-		if (final_start_pfn >= final_end_pfn)
-			continue;
-
-		for (node_pfn = final_start_pfn; node_pfn < final_end_pfn;
-		     node_pfn++) {
-			if (!pfn_valid(node_pfn))
-				continue;
-			page = pfn_to_page(node_pfn);
-			add_one_highpage_init(page, node_pfn, bad_ppro);
-		}
-	}
-}
 /**
  * sparse_memory_present_with_active_regions - Call memory_present for each active range
  * @nid: The node to call memory_present for. If MAX_NUMNODES, all nodes will be used.
