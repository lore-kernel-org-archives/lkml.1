Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYACP0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYACP0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYACPY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:29 -0500
Received: from mail.suse.de ([195.135.220.2]:46749 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbYACPY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:28 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [12/28] CPA: CLFLUSH support in change_page_attr()
Message-Id: <20080103152426.B8CA514E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Queue individual data pages for flushing with CLFLUSH in change_page_attr(),
instead of doing global WBINVDs. WBINVDs is a very painful operation
for the CPU and quite slow too.  Worse it is not interruptible and
can cause long latencies on hypervisors on older Intel VT systems.

CLFLUSH on the other hand only flushes the cache lines that actually need to be 
flushed and since it works in smaller chunks is more preemeptible.

To do this c_p_a needs to save the address to be flush for global_tlb_flush()
later.  This is done using a separate data structure, not struct page, 
because page->lru is often used or not there for memory holes.

Also the flushes are done in FIFO order now, not LIFO. 

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   78 ++++++++++++++++++++++++++++++++++------------
 arch/x86/mm/pageattr_64.c |   77 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 118 insertions(+), 37 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -13,6 +13,11 @@
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 
+struct flush {
+	struct list_head l;
+	unsigned long addr;
+};
+
 pte_t *lookup_address(unsigned long address, int *level)
 { 
 	pgd_t *pgd = pgd_offset_k(address);
@@ -63,6 +68,11 @@ static struct page *split_large_page(uns
 	return base;
 } 
 
+struct flush_arg {
+	int full_flush;
+	struct list_head l;
+};
+
 void clflush_cache_range(void *adr, int size)
 {
 	int i;
@@ -72,27 +82,27 @@ void clflush_cache_range(void *adr, int 
 
 static void flush_kernel_map(void *arg)
 {
-	struct list_head *l = (struct list_head *)arg;
-	struct page *pg;
+	struct flush_arg *a = (struct flush_arg *)arg;
+	struct flush *f;
+
+	if (!cpu_has_clflush)
+		a->full_flush = 1;
 
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
-	/* clflush is still broken. Disable for now. */
-	if (1 || !cpu_has_clflush)
+	if (a->full_flush)
 		asm volatile("wbinvd" ::: "memory");
-	else list_for_each_entry(pg, l, lru) {
-		void *adr = page_address(pg);
-		clflush_cache_range(adr, PAGE_SIZE);
+	list_for_each_entry(f, &a->l, l) {
+		if (!a->full_flush)
+			clflush_cache_range((void *)f->addr, PAGE_SIZE);
 	}
 	__flush_tlb_all();
 }
 
-static inline void flush_map(struct list_head *l)
-{	
-	on_each_cpu(flush_kernel_map, l, 1, 1);
-}
-
-static LIST_HEAD(deferred_pages); /* protected by init_mm.mmap_sem */
+/* both protected by init_mm.mmap_sem */
+static int full_flush;
+static LIST_HEAD(deferred_pages);
+static LIST_HEAD(flush_pages);
 
 static inline void save_page(struct page *fpage)
 {
@@ -124,6 +134,25 @@ static void revert_page(unsigned long ad
 	set_pte((pte_t *)pmd, large_pte);
 }      
 
+/*
+ * Mark the address for flushing later in global_tlb_flush().
+ *
+ * Other parts of the kernel are already in a feeding frenzy over the various
+ * struct page fields. Instead of trying to compete allocate a separate
+ * data structure to keep track of the flush. This has the added bonus that it will
+ * work for MMIO holes without mem_map too.
+ */
+static void set_tlb_flush(unsigned long address)
+{
+	struct flush *f = kmalloc(sizeof(struct flush), GFP_KERNEL);
+	if (!f) {
+		full_flush = 1;
+		return;
+	}
+	f->addr = address;
+	list_add_tail(&f->l, &flush_pages);
+}
+
 static int
 __change_page_attr(unsigned long address, unsigned long pfn, pgprot_t prot,
 				   pgprot_t ref_prot)
@@ -136,8 +165,11 @@ __change_page_attr(unsigned long address
 	kpte = lookup_address(address, &level);
 	if (!kpte) return 0;
 	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
-	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
+	BUG_ON(PageLRU(kpte_page));
+
+	set_tlb_flush(address);
+
 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
 		if (!pte_huge(*kpte)) {
 			set_pte(kpte, pfn_pte(pfn, prot));
@@ -231,7 +263,9 @@ int change_page_attr(struct page *page, 
 void global_flush_tlb(void)
 { 
 	struct page *pg, *next;
-	struct list_head l;
+	struct flush *f, *fnext;
+	struct flush_arg arg;
+	struct list_head free_pages;
 
 	/*
 	 * Write-protect the semaphore, to exclude two contexts
@@ -239,12 +273,19 @@ void global_flush_tlb(void)
 	 * exclude new additions to the deferred_pages list:
 	 */
 	down_write(&init_mm.mmap_sem);
-	list_replace_init(&deferred_pages, &l);
+	arg.full_flush = full_flush;
+	full_flush = 0;
+	list_replace_init(&flush_pages, &arg.l);
+	list_replace_init(&deferred_pages, &free_pages);
 	up_write(&init_mm.mmap_sem);
 
-	flush_map(&l);
+	on_each_cpu(flush_kernel_map, &arg, 1, 1);
+
+	list_for_each_entry_safe(f, fnext, &arg.l, l) {
+		kfree(f);
+	}
 
-	list_for_each_entry_safe(pg, next, &l, lru) {
+	list_for_each_entry_safe(pg, next, &free_pages, lru) {
 		list_del(&pg->lru);
 		clear_bit(PG_arch_1, &pg->flags);
 		if (page_private(pg) != 0)
Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -15,8 +15,15 @@
 #include <asm/sections.h>
 
 /* Protected by init_mm.mmap_sem */
+/* Variables protected by cpa_lock */
+static int full_flush;
 static struct list_head df_list = LIST_HEAD_INIT(df_list);
+static LIST_HEAD(flush_pages);
 
+struct flush {
+	struct list_head l;
+	unsigned long addr;
+};
 pte_t *lookup_address(unsigned long address, int *level)
 { 
 	pgd_t *pgd = pgd_offset_k(address);
@@ -67,25 +74,31 @@ static struct page *split_large_page(uns
 	return base;
 } 
 
-static void cache_flush_page(struct page *p)
+struct flush_arg {
+	int full_flush;
+	struct list_head l;
+};
+
+void clflush_cache_range(void *adr, int size)
 { 
-	void *adr = page_address(p);
 	int i;
-	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
+	for (i = 0; i < size; i += boot_cpu_data.x86_clflush_size)
 		clflush(adr+i);
 }
 
 static void flush_kernel_map(void *arg)
 {
-	struct list_head *lh = (struct list_head *)arg;
-	struct page *p;
+	struct flush_arg *a = (struct flush_arg *)arg;
+	struct flush *f;
 
-	/* High level code is not ready for clflush yet */
-	if (0 && cpu_has_clflush) {
-		list_for_each_entry (p, lh, lru)
-			cache_flush_page(p);
-	} else if (boot_cpu_data.x86_model >= 4)
+	if (!cpu_has_clflush)
+		a->full_flush = 1;
+	if (a->full_flush && boot_cpu_data.x86_model >= 4)
 		wbinvd();
+	list_for_each_entry(f, &a->l, l) {
+		if (!a->full_flush)
+			clflush_cache_range((void *)f->addr, PAGE_SIZE);
+	}
 
 	/* Flush all to work around Errata in early athlons regarding 
 	 * large page flushing. 
@@ -141,6 +154,25 @@ static inline void save_page(struct page
 		list_add(&kpte_page->lru, &df_list);
 }
 
+/*
+ * Mark the address for flushing later in global_tlb_flush().
+ *
+ * Other parts of the kernel are already in a feeding frenzy over the various
+ * struct page fields. Instead of trying to compete allocate a separate
+ * data structure to keep track of the flush. This has the added bonus that it will
+ * work for MMIO holes without mem_map too.
+ */
+static void set_tlb_flush(unsigned long address)
+{
+	struct flush *f = kmalloc(sizeof(struct flush), GFP_KERNEL);
+	if (!f) {
+		full_flush = 1;
+		return;
+	}
+	f->addr = address;
+	list_add_tail(&f->l, &flush_pages);
+}
+
 static int
 __change_page_attr(struct page *page, pgprot_t prot)
 { 
@@ -159,6 +191,8 @@ __change_page_attr(struct page *page, pg
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
 
+	set_tlb_flush(address);
+
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
 		if (!pte_huge(*kpte)) {
 			set_pte_atomic(kpte, mk_pte(page, prot)); 
@@ -199,11 +233,6 @@ __change_page_attr(struct page *page, pg
 	return 0;
 } 
 
-static inline void flush_map(struct list_head *l)
-{
-	on_each_cpu(flush_kernel_map, l, 1, 1);
-}
-
 /*
  * Change the page attributes of an page in the linear mapping.
  *
@@ -234,16 +263,27 @@ int change_page_attr(struct page *page, 
 
 void global_flush_tlb(void)
 {
-	struct list_head l;
+	struct flush_arg arg;
 	struct page *pg, *next;
+	struct flush *f, *fnext;
+	struct list_head free_pages;
 
 	BUG_ON(irqs_disabled());
 
 	down_write(&init_mm.mmap_sem);
-	list_replace_init(&df_list, &l);
+	arg.full_flush = full_flush;
+	full_flush = 0;
+	list_replace_init(&flush_pages, &arg.l);
+	list_replace_init(&df_list, &free_pages);
 	up_write(&init_mm.mmap_sem);
-	flush_map(&l);
-	list_for_each_entry_safe(pg, next, &l, lru) {
+
+	on_each_cpu(flush_kernel_map, &arg, 1, 1);
+
+	list_for_each_entry_safe(f, fnext, &arg.l, l) {
+		kfree(f);
+	}
+
+	list_for_each_entry_safe(pg, next, &free_pages, lru) {
 		list_del(&pg->lru);
 		clear_bit(PG_arch_1, &pg->flags);
 		if (PageReserved(pg) || !cpu_has_pse || page_private(pg) != 0)
