Return-Path: <linux-kernel-owner+w=401wt.eu-S1765576AbXIUWgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765576AbXIUWgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763580AbXIUWcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:19 -0400
Received: from ns1.suse.de ([195.135.220.2]:57044 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763395AbXIUWcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:13 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [13/50] x86: Fix and reenable CLFLUSH support in change_page_attr()
Message-Id: <20070921223211.BB50413DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Reenable CLFLUSH support in change_page_attr()

Mark pages that need to be cache flushed with a special bit
before putting them into the deferred list.
(PG_owner_priv_1).  Then only cache flush these pages
and don't free them.

Takes especial care to handle cases where the page's LRU
or owner_priv_1 bit is already used. Fall back to full cache
flushes then.

They probably do not happen right now, but this makes
it more future proof. 

TBD port to i386

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/pageattr.c      |   69 +++++++++++++++++++++++++++++++++--------
 arch/x86_64/mm/pageattr.c    |   72 +++++++++++++++++++++++++++++++++----------
 include/asm-i386/pgtable.h   |    2 +
 include/asm-x86_64/pgtable.h |    1 
 4 files changed, 115 insertions(+), 29 deletions(-)

Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -13,6 +13,10 @@
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 
+#define PageFlush(p) test_bit(PG_owner_priv_1, &(p)->flags)
+#define SetPageFlush(p) set_bit(PG_owner_priv_1, &(p)->flags)
+#define TestClearPageFlush(p) test_and_clear_bit(PG_owner_priv_1, &(p)->flags)
+
 pte_t *lookup_address(unsigned long address)
 { 
 	pgd_t *pgd = pgd_offset_k(address);
@@ -61,6 +65,11 @@ static struct page *split_large_page(uns
 	return base;
 } 
 
+struct flush_arg {
+	int full_flush;
+	struct list_head l;
+};
+
 static void cache_flush_page(void *adr)
 {
 	int i;
@@ -70,17 +79,16 @@ static void cache_flush_page(void *adr)
 
 static void flush_kernel_map(void *arg)
 {
-	struct list_head *l = (struct list_head *)arg;
+	struct flush_arg *a = (struct flush_arg *)arg;
 	struct page *pg;
 
-	/* When clflush is available always use it because it is
+	/* When clflush is available use it because it is
 	   much cheaper than WBINVD. */
-	/* clflush is still broken. Disable for now. */
-	if (1 || !cpu_has_clflush)
+	if (a->full_flush || !cpu_has_clflush)
 		asm volatile("wbinvd" ::: "memory");
-	else list_for_each_entry(pg, l, lru) {
-		void *adr = page_address(pg);
-		cache_flush_page(adr);
+	else list_for_each_entry(pg, &a->l, lru) {
+		if (PageFlush(pg))
+			cache_flush_page(page_address(pg));
 	}
 	__flush_tlb_all();
 }
@@ -90,11 +98,17 @@ static inline void flush_map(struct list
 	on_each_cpu(flush_kernel_map, l, 1, 1);
 }
 
-static LIST_HEAD(deferred_pages); /* protected by init_mm.mmap_sem */
+/* both protected by init_mm.mmap_sem */
+static int full_flush;
+static LIST_HEAD(deferred_pages);
 
-static inline void save_page(struct page *fpage)
+static inline void save_page(struct page *fpage, int data)
 {
-	if (!test_and_set_bit(PG_arch_1, &fpage->flags))
+	if (data && cpu_has_clflush)
+		SetPageFlush(fpage);
+	if (test_and_set_bit(PG_arch_1, &fpage->flags))
+		return;
+	if (cpu_has_clflush || !data)
 		list_add(&fpage->lru, &deferred_pages);
 }
 
@@ -122,6 +136,17 @@ static void revert_page(unsigned long ad
 	set_pte((pte_t *)pmd, large_pte);
 }      
 
+static struct page *flush_page(unsigned long address)
+{
+	struct page *p;
+	if (!(pfn_valid(__pa(address) >> PAGE_SHIFT)))
+		return NULL;
+	p = virt_to_page(address);
+	if ((PageFlush(p) || PageLRU(p)) && !test_bit(PG_arch_1, &p->flags))
+		return NULL;
+	return p;
+}
+
 static int
 __change_page_attr(unsigned long address, unsigned long pfn, pgprot_t prot,
 				   pgprot_t ref_prot)
@@ -133,8 +158,19 @@ __change_page_attr(unsigned long address
 	kpte = lookup_address(address);
 	if (!kpte) return 0;
 	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
-	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
+	BUG_ON(PageLRU(kpte_page));
+
+	/* Do caching attributes change?
+	   Note: this will need changes if the PAT bit is used (it isn't
+   	   currently) because that one varies between 2MB and 4K pages. */
+	if ((pte_val(*kpte)&_PAGE_CACHE) != (pgprot_val(prot)&_PAGE_CACHE)) {
+		struct page *p = flush_page(address);
+		if (!p)
+			full_flush = 1;
+		else
+			save_page(p, 1);
+	}
 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
 		if (!pte_huge(*kpte)) {
 			set_pte(kpte, pfn_pte(pfn, prot));
@@ -162,7 +198,7 @@ __change_page_attr(unsigned long address
 	/* on x86-64 the direct mapping set at boot is not using 4k pages */
  	BUG_ON(PageReserved(kpte_page));
 
-	save_page(kpte_page);
+	save_page(kpte_page, 0);
 	if (page_private(kpte_page) == 0)
 		revert_page(address, ref_prot);
 	return 0;
@@ -227,17 +263,21 @@ int change_page_attr(struct page *page, 
 void global_flush_tlb(void)
 { 
 	struct page *pg, *next;
-	struct list_head l;
+	struct flush_arg arg;
 
 	down_read(&init_mm.mmap_sem);
-	list_replace_init(&deferred_pages, &l);
+	arg.full_flush = full_flush;
+	full_flush = 0;
+	list_replace_init(&deferred_pages, &arg.l);
 	up_read(&init_mm.mmap_sem);
 
-	flush_map(&l);
+	flush_map(&arg);
 
-	list_for_each_entry_safe(pg, next, &l, lru) {
+	list_for_each_entry_safe(pg, next, &arg.l, lru) {
 		list_del(&pg->lru);
 		clear_bit(PG_arch_1, &pg->flags);
+		if (TestClearPageFlush(pg))
+			continue;
 		if (page_private(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
Index: linux/include/asm-x86_64/pgtable.h
===================================================================
--- linux.orig/include/asm-x86_64/pgtable.h
+++ linux/include/asm-x86_64/pgtable.h
@@ -165,6 +165,7 @@ static inline pte_t ptep_get_and_clear_f
 
 #define _PAGE_PROTNONE	0x080	/* If not present */
 #define _PAGE_NX        (_AC(1,UL)<<_PAGE_BIT_NX)
+#define _PAGE_CACHE	(_PAGE_PCD|_PAGE_PWT)
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
Index: linux/arch/i386/mm/pageattr.c
===================================================================
--- linux.orig/arch/i386/mm/pageattr.c
+++ linux/arch/i386/mm/pageattr.c
@@ -14,7 +14,13 @@
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
 
+#define PageFlush(p) test_bit(PG_owner_priv_1, &(p)->flags)
+#define SetPageFlush(p) set_bit(PG_owner_priv_1, &(p)->flags)
+#define TestClearPageFlush(p) test_and_clear_bit(PG_owner_priv_1, &(p)->flags)
+
 static DEFINE_SPINLOCK(cpa_lock);
+/* Both protected by cpa_lock */
+static int full_flush;
 static struct list_head df_list = LIST_HEAD_INIT(df_list);
 
 
@@ -68,6 +74,11 @@ static struct page *split_large_page(uns
 	return base;
 } 
 
+struct flush_arg {
+	int full_flush;
+	struct list_head l;
+};
+
 static void cache_flush_page(struct page *p)
 { 
 	void *adr = page_address(p);
@@ -78,13 +89,14 @@ static void cache_flush_page(struct page
 
 static void flush_kernel_map(void *arg)
 {
-	struct list_head *lh = (struct list_head *)arg;
+	struct flush_arg *a = (struct flush_arg *)arg;
 	struct page *p;
 
-	/* High level code is not ready for clflush yet */
-	if (0 && cpu_has_clflush) {
-		list_for_each_entry (p, lh, lru)
-			cache_flush_page(p);
+	if (!a->full_flush && cpu_has_clflush) {
+		list_for_each_entry (p, &a->l, lru) {
+			if (PageFlush(p))
+				cache_flush_page(p);
+		}
 	} else if (boot_cpu_data.x86_model >= 4)
 		wbinvd();
 
@@ -136,10 +148,25 @@ static inline void revert_page(struct pa
 			    ref_prot));
 }
 
-static inline void save_page(struct page *kpte_page)
+static inline void save_page(struct page *fpage, int data)
+{
+	if (data && cpu_has_clflush)
+		SetPageFlush(fpage);
+	if (test_and_set_bit(PG_arch_1, &fpage->flags))
+		return;
+	if (!data || cpu_has_clflush)
+		list_add(&fpage->lru, &df_list);
+}
+
+static struct page *flush_page(unsigned long address)
 {
-	if (!test_and_set_bit(PG_arch_1, &kpte_page->flags))
-		list_add(&kpte_page->lru, &df_list);
+	struct page *p;
+	if (!(pfn_valid(__pa(address) >> PAGE_SHIFT)))
+		return NULL;
+	p = virt_to_page(address);
+	if ((PageFlush(p) || PageLRU(p)) && !test_bit(PG_arch_1, &p->flags))
+		return NULL;
+	return p;
 }
 
 static int
@@ -158,6 +185,18 @@ __change_page_attr(struct page *page, pg
 	kpte_page = virt_to_page(kpte);
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
+	BUG_ON(PageLRU(kpte_page));
+
+	/* Do caching attributes change?
+	   Note: this will need changes if the PAT bit is used (it isn't
+   	   currently) because that one varies between 2MB and 4K pages. */
+	if ((pte_val(*kpte)&_PAGE_CACHE) != (pgprot_val(prot)&_PAGE_CACHE)) {
+		struct page *p = flush_page(address);
+		if (!p)
+			full_flush = 1;
+		else
+			save_page(p, 1);
+	}
 
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
 		if (!pte_huge(*kpte)) {
@@ -189,7 +228,7 @@ __change_page_attr(struct page *page, pg
 	 * replace it with a largepage.
 	 */
 
-	save_page(kpte_page);
+	save_page(kpte_page, 0);
 	if (!PageReserved(kpte_page)) {
 		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
 			paravirt_release_pt(page_to_pfn(kpte_page));
@@ -235,18 +274,22 @@ int change_page_attr(struct page *page, 
 
 void global_flush_tlb(void)
 {
-	struct list_head l;
+	struct flush_arg arg;
 	struct page *pg, *next;
 
 	BUG_ON(irqs_disabled());
 
 	spin_lock_irq(&cpa_lock);
-	list_replace_init(&df_list, &l);
+	arg.full_flush = full_flush;
+	full_flush = 0;
+	list_replace_init(&df_list, &arg.l);
 	spin_unlock_irq(&cpa_lock);
-	flush_map(&l);
-	list_for_each_entry_safe(pg, next, &l, lru) {
+	flush_map(&arg);
+	list_for_each_entry_safe(pg, next, &arg.l, lru) {
 		list_del(&pg->lru);
 		clear_bit(PG_arch_1, &pg->flags);
+		if (TestClearPageFlush(pg))
+			continue;
 		if (PageReserved(pg) || !cpu_has_pse || page_private(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
Index: linux/include/asm-i386/pgtable.h
===================================================================
--- linux.orig/include/asm-i386/pgtable.h
+++ linux/include/asm-i386/pgtable.h
@@ -128,6 +128,8 @@ void paging_init(void);
 #else
 #define _PAGE_NX	0
 #endif
+#define _PAGE_CACHE	(_PAGE_PCD|_PAGE_PWT)
+
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
