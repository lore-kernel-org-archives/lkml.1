Return-Path: <linux-kernel-owner+w=401wt.eu-S933375AbZJHX1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbZJHX1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbZJHX1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:27:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:43310 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760095AbZJHX0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:26:55 -0400
Message-Id: <20091008232528.365592989@chello.nl>
References: <20091008232226.768382977@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 09 Oct 2009 01:22:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/4] mm: stack based kmap_atomic
Content-Disposition: inline; filename=kmap-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep the current interface but ignore the KM_type and use a stack
based approach.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/arm/mm/highmem.c              |    8 +++++-
 arch/frv/include/asm/highmem.h     |    3 +-
 arch/mips/mm/highmem.c             |   11 ++++++--
 arch/mn10300/include/asm/highmem.h |   10 ++++++-
 arch/powerpc/mm/highmem.c          |   10 ++++++-
 arch/sparc/mm/highmem.c            |    9 +++++-
 arch/x86/mm/highmem_32.c           |   24 +++++++++++++++---
 arch/x86/mm/iomap_32.c             |   16 ------------
 include/linux/highmem.h            |   32 +++++++++++++++---------
 mm/highmem.c                       |   49 +++----------------------------------
 10 files changed, 85 insertions(+), 87 deletions(-)

Index: linux-2.6/arch/arm/mm/highmem.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/highmem.c
+++ linux-2.6/arch/arm/mm/highmem.c
@@ -50,6 +50,8 @@ void *kmap_atomic(struct page *page, enu
 	if (kmap)
 		return kmap;
 
+	type = kmap_atomic_idx_push();
+
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
@@ -74,7 +76,10 @@ EXPORT_SYMBOL(kmap_atomic);
 void kunmap_atomic(void *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	unsigned int idx = type + KM_TYPE_NR * smp_processor_id();
+	unsigned int idx;
+
+	type = kmap_atomic_idx_pop();
+	idx = type + KM_TYPE_NR * smp_processor_id();
 
 	if (kvaddr >= (void *)FIXADDR_START) {
 		__cpuc_flush_dcache_page((void *)vaddr);
@@ -100,6 +105,7 @@ void *kmap_atomic_pfn(unsigned long pfn,
 
 	pagefault_disable();
 
+	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
Index: linux-2.6/arch/frv/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/highmem.h
+++ linux-2.6/arch/frv/include/asm/highmem.h
@@ -117,7 +117,7 @@ static inline void *kmap_atomic(struct p
 	unsigned long paddr;
 
 	pagefault_disable();
-	debug_kmap_atomic(type);
+	type = kmap_atomic_idx_push();
 	paddr = page_to_phys(page);
 
 	switch (type) {
@@ -154,6 +154,7 @@ do {									\
 
 static inline void kunmap_atomic(void *kvaddr, enum km_type type)
 {
+	type = kmap_atomic_idx_pop();
 	switch (type) {
         case 0:		__kunmap_atomic_primary(0, 2);	break;
         case 1:		__kunmap_atomic_primary(1, 3);	break;
Index: linux-2.6/arch/mips/mm/highmem.c
===================================================================
--- linux-2.6.orig/arch/mips/mm/highmem.c
+++ linux-2.6/arch/mips/mm/highmem.c
@@ -50,7 +50,7 @@ void *__kmap_atomic(struct page *page, e
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic(type);
+	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
@@ -63,7 +63,7 @@ void *__kmap_atomic(struct page *page, e
 }
 EXPORT_SYMBOL(__kmap_atomic);
 
-void __kunmap_atomic(void *kvaddr, enum km_type type)
+static void __debug_kunmap_atomic(void *kvaddr, enum km_type type)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
@@ -83,7 +83,12 @@ void __kunmap_atomic(void *kvaddr, enum 
 	pte_clear(&init_mm, vaddr, kmap_pte-idx);
 	local_flush_tlb_one(vaddr);
 #endif
+}
 
+void __kunmap_atomic(void *kvaddr, enum km_type type)
+{
+	type = kmap_atomic_idx_pop();
+	__debug_kunmap_atomic(kvaddr, type);
 	pagefault_enable();
 }
 EXPORT_SYMBOL(__kunmap_atomic);
@@ -99,7 +104,7 @@ void *kmap_atomic_pfn(unsigned long pfn,
 
 	pagefault_disable();
 
-	debug_kmap_atomic(type);
+	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, PAGE_KERNEL));
Index: linux-2.6/arch/mn10300/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/highmem.h
+++ linux-2.6/arch/mn10300/include/asm/highmem.h
@@ -78,7 +78,7 @@ static inline unsigned long kmap_atomic(
 	if (page < highmem_start_page)
 		return page_address(page);
 
-	debug_kmap_atomic(type);
+	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #if HIGHMEM_DEBUG
@@ -91,7 +91,7 @@ static inline unsigned long kmap_atomic(
 	return vaddr;
 }
 
-static inline void kunmap_atomic(unsigned long vaddr, enum km_type type)
+static inline void debug_kunmap_atomic(unsigned long vaddr, enum km_type type)
 {
 #if HIGHMEM_DEBUG
 	enum fixed_addresses idx = type + KM_TYPE_NR * smp_processor_id();
@@ -111,6 +111,12 @@ static inline void kunmap_atomic(unsigne
 #endif
 }
 
+static inline void kunmap_atomic(unsigned long vaddr, enum km_type type)
+{
+	type = kmap_atomic_idx_pop();
+	debug_kunmap_atomic(vaddr, type);
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_HIGHMEM_H */
Index: linux-2.6/arch/powerpc/mm/highmem.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/highmem.c
+++ linux-2.6/arch/powerpc/mm/highmem.c
@@ -39,7 +39,7 @@ void *kmap_atomic_prot(struct page *page
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic(type);
+	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
@@ -52,7 +52,7 @@ void *kmap_atomic_prot(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_prot);
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+static void debug_kunmap_atomic(void *kvaddr, enum km_type type)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
@@ -72,6 +72,12 @@ void kunmap_atomic(void *kvaddr, enum km
 	pte_clear(&init_mm, vaddr, kmap_pte-idx);
 	local_flush_tlb_page(NULL, vaddr);
 #endif
+}
+
+void kunmap_atomic(void *kvaddr, enum km_type type)
+{
+	type = kmap_atomic_idx_pop();
+	debug_kunmap_atomic(kvaddr, type);
 	pagefault_enable();
 }
 EXPORT_SYMBOL(kunmap_atomic);
Index: linux-2.6/arch/sparc/mm/highmem.c
===================================================================
--- linux-2.6.orig/arch/sparc/mm/highmem.c
+++ linux-2.6/arch/sparc/mm/highmem.c
@@ -39,7 +39,7 @@ void *kmap_atomic(struct page *page, enu
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic(type);
+	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 
@@ -65,7 +65,7 @@ void *kmap_atomic(struct page *page, enu
 }
 EXPORT_SYMBOL(kmap_atomic);
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+static void debug_kunmap_atomic(void *kvaddr, enum km_type type)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
@@ -97,7 +97,12 @@ void kunmap_atomic(void *kvaddr, enum km
 	flush_tlb_all();
 #endif
 #endif
+}
 
+void kunmap_atomic(void *kvaddr, enum km_type type)
+{
+	type = kmap_atomic_idx_pop();
+	debug_kunmap_atomic(kvaddr, type);
 	pagefault_enable();
 }
 EXPORT_SYMBOL(kunmap_atomic);
Index: linux-2.6/arch/x86/mm/highmem_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/highmem_32.c
+++ linux-2.6/arch/x86/mm/highmem_32.c
@@ -38,8 +38,7 @@ void *kmap_atomic_prot(struct page *page
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic(type);
-
+	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
@@ -56,7 +55,10 @@ void *kmap_atomic(struct page *page, enu
 void kunmap_atomic(void *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
-	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
+	enum fixed_addresses idx;
+
+	type = kmap_atomic_idx_pop();
+	idx = type + KM_TYPE_NR*smp_processor_id();
 
 	/*
 	 * Force other mappings to Oops if they'll try to access this pte
@@ -80,6 +82,22 @@ void kunmap_atomic(void *kvaddr, enum km
  * This is the same as kmap_atomic() but can map memory that doesn't
  * have a struct page associated with it.
  */
+void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
+{
+	enum fixed_addresses idx;
+	unsigned long vaddr;
+
+	pagefault_disable();
+
+	type = kmap_atomic_idx_push();
+	idx = type + KM_TYPE_NR * smp_processor_id();
+	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
+	arch_flush_lazy_mmu_mode();
+
+	return (void *)vaddr;
+}
+
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
 {
 	return kmap_atomic_prot_pfn(pfn, type, kmap_prot);
Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h
+++ linux-2.6/include/linux/highmem.h
@@ -21,18 +21,6 @@ static inline void flush_kernel_dcache_p
 
 #include <asm/kmap_types.h>
 
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
-
-void debug_kmap_atomic(enum km_type type);
-
-#else
-
-static inline void debug_kmap_atomic(enum km_type type)
-{
-}
-
-#endif
-
 #ifdef CONFIG_HIGHMEM
 #include <asm/highmem.h>
 
@@ -42,6 +30,26 @@ extern unsigned long totalhigh_pages;
 
 void kmap_flush_unused(void);
 
+DECLARE_PER_CPU(int, __kmap_atomic_idx);
+
+static inline int kmap_atomic_idx_push(void)
+{
+	int idx = __get_cpu_var(__kmap_atomic_idx)++;
+#ifdef CONFIG_DEBUG_HIGHMEM
+	BUG_ON(idx > KM_TYPE_NR);
+#endif
+	return idx;
+}
+
+static inline int kmap_atomic_idx_pop(void)
+{
+	int idx = --__get_cpu_var(__kmap_atomic_idx);
+#ifdef CONFIG_DEBUG_HIGHMEM
+	BUG_ON(idx < 0);
+#endif
+	return idx;
+}
+
 #else /* CONFIG_HIGHMEM */
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
Index: linux-2.6/mm/highmem.c
===================================================================
--- linux-2.6.orig/mm/highmem.c
+++ linux-2.6/mm/highmem.c
@@ -41,6 +41,10 @@
 unsigned long totalhigh_pages __read_mostly;
 EXPORT_SYMBOL(totalhigh_pages);
 
+
+DEFINE_PER_CPU(int, __kmap_atomic_idx);
+EXPORT_PER_CPU_SYMBOL_GPL(__kmap_atomic_idx);
+
 unsigned int nr_free_highpages (void)
 {
 	pg_data_t *pgdat;
@@ -421,48 +425,3 @@ void __init page_address_init(void)
 }
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
-
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
-
-void debug_kmap_atomic(enum km_type type)
-{
-	static unsigned warn_count = 10;
-
-	if (unlikely(warn_count == 0))
-		return;
-
-	if (unlikely(in_interrupt())) {
-		if (in_irq()) {
-			if (type != KM_IRQ0 && type != KM_IRQ1 &&
-			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
-			    type != KM_BOUNCE_READ) {
-				WARN_ON(1);
-				warn_count--;
-			}
-		} else if (!irqs_disabled()) {	/* softirq */
-			if (type != KM_IRQ0 && type != KM_IRQ1 &&
-			    type != KM_SOFTIRQ0 && type != KM_SOFTIRQ1 &&
-			    type != KM_SKB_SUNRPC_DATA &&
-			    type != KM_SKB_DATA_SOFTIRQ &&
-			    type != KM_BOUNCE_READ) {
-				WARN_ON(1);
-				warn_count--;
-			}
-		}
-	}
-
-	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
-			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
-		if (!irqs_disabled()) {
-			WARN_ON(1);
-			warn_count--;
-		}
-	} else if (type == KM_SOFTIRQ0 || type == KM_SOFTIRQ1) {
-		if (irq_count() == 0 && !irqs_disabled()) {
-			WARN_ON(1);
-			warn_count--;
-		}
-	}
-}
-
-#endif
Index: linux-2.6/arch/x86/mm/iomap_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/iomap_32.c
+++ linux-2.6/arch/x86/mm/iomap_32.c
@@ -55,22 +55,6 @@ iomap_free(resource_size_t base, unsigne
 }
 EXPORT_SYMBOL_GPL(iomap_free);
 
-void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
-{
-	enum fixed_addresses idx;
-	unsigned long vaddr;
-
-	pagefault_disable();
-
-	debug_kmap_atomic(type);
-	idx = type + KM_TYPE_NR * smp_processor_id();
-	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
-	arch_flush_lazy_mmu_mode();
-
-	return (void *)vaddr;
-}
-
 /*
  * Map 'pfn' using fixed map 'type' and protections 'prot'
  */

-- 

