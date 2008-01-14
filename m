Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYANWXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYANWXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbYANWRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:17:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:55009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbYANWQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:54 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [19/31] CPA: Limit cache flushing to pages that really change caching
Message-Id: <20080114221651.EDD3A14F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:16:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously change_page_attr always flushed caches even for 
pages that only change a non caching related attribute (like RO for
read/write protection).

This changes the flush code to only flush the cache when the
caching attributes actually change. 

I made some effort to already handle reprogrammed PAT bits, although this
is not strictly needed right now by the core kernel (but that will
probably change soon) 

This will only make a difference on AMD CPUs or older Intel CPUs,
because all newer Intel CPUs support "self-snoop" and do not require
this cache flushing anyways.

Another advantage of this patch is that it prevents recursive
slab calls with slab debugging.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   43 +++++++++++++++++++++++++++++++++----------
 arch/x86/mm/pageattr_64.c |   42 ++++++++++++++++++++++++++++++++++--------
 include/asm-x86/pgtable.h |    8 ++++++++
 3 files changed, 75 insertions(+), 18 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -13,7 +13,10 @@
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 
+enum flush_mode { FLUSH_NONE, FLUSH_CACHE, FLUSH_TLB };
+
 struct flush {
+	enum flush_mode mode;
 	struct list_head l;
 	unsigned long addr;
 };
@@ -76,7 +79,7 @@ static struct page *split_large_page(uns
 } 
 
 struct flush_arg {
-	int full_flush;
+	enum flush_mode full_flush;
 	struct list_head l;
 };
 
@@ -91,14 +94,19 @@ static void flush_kernel_map(void *arg)
 {
 	struct flush_arg *a = (struct flush_arg *)arg;
 	struct flush *f;
+	int cache_flush = a->full_flush == FLUSH_CACHE;
 
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
 	list_for_each_entry(f, &a->l, l) {
 		if (!a->full_flush)
 			__flush_tlb_one(f->addr);
-		if (!a->full_flush && !cpu_has_ss)
-			clflush_cache_range((void *)f->addr, PAGE_SIZE);
+		if (f->mode == FLUSH_CACHE && !cpu_has_ss) {
+			if (cpu_has_clflush)
+				clflush_cache_range((void *)f->addr, PAGE_SIZE);
+			else
+				cache_flush++;
+		}
 	}
 	if (a->full_flush)
 		__flush_tlb_all();
@@ -108,12 +116,12 @@ static void flush_kernel_map(void *arg)
 	 * here and in the loop. But it is moot on Self-Snoop CPUs anyways.
 	 */
 
-	if ((!cpu_has_clflush || a->full_flush) && !cpu_has_ss)
+	if (cache_flush > 0 && !cpu_has_ss)
 		wbinvd();
 }
 
 /* both protected by init_mm.mmap_sem */
-static int full_flush;
+static enum flush_mode full_flush;
 static LIST_HEAD(deferred_pages);
 static LIST_HEAD(flush_pages);
 
@@ -155,17 +163,35 @@ static void revert_page(unsigned long ad
  * data structure to keep track of the flush. This has the added bonus that
  * it will work for MMIO holes without mem_map too.
  */
-static void set_tlb_flush(unsigned long address)
+static void set_tlb_flush(unsigned long address, int cache)
 {
+	enum flush_mode mode = cache ? FLUSH_CACHE : FLUSH_TLB;
 	struct flush *f = kmalloc(sizeof(struct flush), GFP_KERNEL);
 	if (!f) {
-		full_flush = 1;
+		if (full_flush < mode)
+			full_flush = mode;
 		return;
 	}
+
 	f->addr = address;
+	f->mode = mode;
 	list_add_tail(&f->l, &flush_pages);
 }
 
+static unsigned short pat_bit[5] = {
+	[4] = _PAGE_PAT,
+	[3] = _PAGE_PAT_LARGE,
+};
+
+static int cache_attr_changed(pte_t pte, pgprot_t prot, int level)
+{
+	unsigned a = pte_val(pte) & (_PAGE_PCD|_PAGE_PWT);
+	/* Correct for PAT bit being in different position on large pages */
+	if (pte_val(pte) & pat_bit[level])
+		a |= _PAGE_PAT;
+	return a != (pgprot_val(prot) & _PAGE_CACHE);
+}
+
 static int
 __change_page_attr(unsigned long address, unsigned long pfn, pgprot_t prot,
 				   pgprot_t ref_prot)
@@ -181,7 +207,7 @@ __change_page_attr(unsigned long address
 	BUG_ON(PageCompound(kpte_page));
 	BUG_ON(PageLRU(kpte_page));
 
-	set_tlb_flush(address);
+	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level));
 
 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
 		if (level == 4) {
Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -21,12 +21,15 @@
 #define ClearPageDeferred(p) clear_bit(PG_deferred, &(p)->flags)
 #define TestSetPageDeferred(p) test_and_set_bit(PG_deferred, &(p)->flags)
 
+enum flush_mode { FLUSH_NONE, FLUSH_CACHE, FLUSH_TLB };
+
 /* Variables protected by init_mm.mmap_sem */
-static int full_flush;
+static enum flush_mode full_flush;
 static struct list_head df_list = LIST_HEAD_INIT(df_list);
 static LIST_HEAD(flush_pages);
 
 struct flush {
+	enum flush_mode mode;
 	struct list_head l;
 	unsigned long addr;
 };
@@ -81,7 +84,7 @@ static struct page *split_large_page(uns
 } 
 
 struct flush_arg {
-	int full_flush;
+	enum flush_mode full_flush;
 	struct list_head l;
 };
 
@@ -96,12 +99,17 @@ static void flush_kernel_map(void *arg)
 {
 	struct flush_arg *a = (struct flush_arg *)arg;
 	struct flush *f;
+	int cache_flush = a->full_flush == FLUSH_CACHE;
 
 	list_for_each_entry(f, &a->l, l) {
-		if (!a->full_flush && !cpu_has_ss)
-			clflush_cache_range((void *)f->addr, PAGE_SIZE);
 		if (!a->full_flush)
 			__flush_tlb_one(f->addr);
+		if (f->mode == FLUSH_CACHE && !cpu_has_ss) {
+			if (cpu_has_clflush)
+				clflush_cache_range((void *)f->addr, PAGE_SIZE);
+			else
+				cache_flush++;
+		}
 	}
 
 	/* Handle errata with flushing large pages in early Athlons */
@@ -115,10 +123,8 @@ static void flush_kernel_map(void *arg)
 	 * here and in the loop. But it is moot on Self-Snoop CPUs anyways.
 	 */
 
-	if ((!cpu_has_clflush || a->full_flush) &&
-	    !cpu_has_ss && boot_cpu_data.x86_model >= 4)
+	if (cache_flush > 0 && !cpu_has_ss && boot_cpu_data.x86_model >= 4)
 		wbinvd();
-
 }
 
 static void set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte) 
@@ -169,6 +175,20 @@ static inline void save_page(struct page
 		list_add(&kpte_page->lru, &df_list);
 }
 
+static unsigned short pat_bit[4] = {
+	[3] = _PAGE_PAT,
+	[2] = _PAGE_PAT_LARGE,
+};
+
+static int cache_attr_changed(pte_t pte, pgprot_t prot, int level)
+{
+	unsigned long a = pte_val(pte) & (_PAGE_PCD|_PAGE_PWT);
+	/* Correct for PAT bit being in different position on large pages */
+	if (pte_val(pte) & pat_bit[level])
+		a |= _PAGE_PAT;
+	return a != (pgprot_val(prot) & _PAGE_CACHE);
+}
+
 /*
  * Mark the address for flushing later in global_tlb_flush().
  *
@@ -177,14 +197,17 @@ static inline void save_page(struct page
  * data structure to keep track of the flush. This has the added bonus that
  * it will work for MMIO holes without mem_map too.
  */
-static void set_tlb_flush(unsigned long address)
+static void set_tlb_flush(unsigned long address, int cache)
 {
+	enum flush_mode mode = cache ? FLUSH_CACHE : FLUSH_TLB;
 	struct flush *f = kmalloc(sizeof(struct flush), GFP_KERNEL);
 	if (!f) {
-		full_flush = 1;
+		if (full_flush < mode)
+			full_flush = mode;
 		return;
 	}
 	f->addr = address;
+	f->mode = mode;
 	list_add_tail(&f->l, &flush_pages);
 }
 
@@ -206,7 +229,7 @@ __change_page_attr(struct page *page, pg
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
 
-	set_tlb_flush(address);
+	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level));
 
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
 		if (level == 3) {
Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -13,12 +13,17 @@
 #define _PAGE_BIT_DIRTY		6
 #define _PAGE_BIT_FILE		6
 #define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page */
+#define _PAGE_BIT_PAT		7	/* Only on 4kb pages */
+#define _PAGE_BIT_PAT_LARGE    12	/* Only on large pages */
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
 #define _PAGE_BIT_UNUSED2	10
 #define _PAGE_BIT_UNUSED3	11
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
+/* Needs special handling for large pages */
+#define _PAGE_CACHE	 (_PAGE_PCD|_PAGE_PWT|_PAGE_PAT)
+
 #define _PAGE_PRESENT	(_AC(1, UL)<<_PAGE_BIT_PRESENT)
 #define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
 #define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
@@ -32,6 +37,9 @@
 #define _PAGE_UNUSED2	(_AC(1, UL)<<_PAGE_BIT_UNUSED2)
 #define _PAGE_UNUSED3	(_AC(1, UL)<<_PAGE_BIT_UNUSED3)
 
+#define _PAGE_PAT	(_AC(1, UL) << _PAGE_BIT_PAT)
+#define _PAGE_PAT_LARGE (_AC(1, UL) << _PAGE_BIT_PAT_LARGE)
+
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)
 #else
