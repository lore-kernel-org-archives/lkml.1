Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbXD3Kay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbXD3Kay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965013AbXD3K2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:50 -0400
Received: from ns1.suse.de ([195.135.220.2]:51192 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbXD3K1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:52 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, zach@vmware.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [17/40] i386: add kmap_atomic_pte for mapping highpte pages
Message-Id: <20070430102750.D4C9B151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Xen and VMI both have special requirements when mapping a highmem pte
page into the kernel address space.  These can be dealt with by adding
a new kmap_atomic_pte() function for mapping highptes, and hooking it
into the paravirt_ops infrastructure.

Xen specifically wants to map the pte page RO, so this patch exposes a
helper function, kmap_atomic_prot, which maps the page with the
specified page protections.

This also adds a kmap_flush_unused() function to clear out the cached
kmap mappings.  Xen needs this to clear out any potential stray RW
mappings of pages which will become part of a pagetable.

[ Zach - vmi.c will need some attention after this patch.  It wasn't
  immediately obvious to me what needs to be done. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/paravirt.c |    5 +++++
 arch/i386/mm/highmem.c      |    9 +++++++--
 include/asm-i386/highmem.h  |    6 ++++++
 include/asm-i386/paravirt.h |   15 +++++++++++++++
 include/asm-i386/pgtable.h  |    4 ++--
 include/linux/highmem.h     |    6 ++++++
 mm/highmem.c                |    9 +++++++++
 7 files changed, 50 insertions(+), 4 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -20,6 +20,7 @@
 #include <linux/efi.h>
 #include <linux/bcd.h>
 #include <linux/start_kernel.h>
+#include <linux/highmem.h>
 
 #include <asm/bug.h>
 #include <asm/paravirt.h>
@@ -316,6 +317,10 @@ struct paravirt_ops paravirt_ops = {
 
 	.ptep_get_and_clear = native_ptep_get_and_clear,
 
+#ifdef CONFIG_HIGHPTE
+	.kmap_atomic_pte = kmap_atomic,
+#endif
+
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.set_pte_present = native_set_pte_present,
Index: linux/arch/i386/mm/highmem.c
===================================================================
--- linux.orig/arch/i386/mm/highmem.c
+++ linux/arch/i386/mm/highmem.c
@@ -26,7 +26,7 @@ void kunmap(struct page *page)
  * However when holding an atomic kmap is is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  */
-void *kmap_atomic(struct page *page, enum km_type type)
+void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
@@ -41,12 +41,17 @@ void *kmap_atomic(struct page *page, enu
 		return page_address(page);
 
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
+	set_pte(kmap_pte-idx, mk_pte(page, prot));
 	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
 
+void *kmap_atomic(struct page *page, enum km_type type)
+{
+	return kmap_atomic_prot(page, type, kmap_prot);
+}
+
 void kunmap_atomic(void *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
Index: linux/include/asm-i386/highmem.h
===================================================================
--- linux.orig/include/asm-i386/highmem.h
+++ linux/include/asm-i386/highmem.h
@@ -24,6 +24,7 @@
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
+#include <asm/paravirt.h>
 
 /* declarations for highmem.c */
 extern unsigned long highstart_pfn, highend_pfn;
@@ -67,11 +68,16 @@ extern void FASTCALL(kunmap_high(struct 
 
 void *kmap(struct page *page);
 void kunmap(struct page *page);
+void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot);
 void *kmap_atomic(struct page *page, enum km_type type);
 void kunmap_atomic(void *kvaddr, enum km_type type);
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 struct page *kmap_atomic_to_page(void *ptr);
 
+#ifndef CONFIG_PARAVIRT
+#define kmap_atomic_pte(page, type)	kmap_atomic(page, type)
+#endif
+
 #define flush_cache_kmaps()	do { } while (0)
 
 #endif /* __KERNEL__ */
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -16,7 +16,9 @@
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/cpumask.h>
+#include <asm/kmap_types.h>
 
+struct page;
 struct thread_struct;
 struct Xgt_desc_struct;
 struct tss_struct;
@@ -187,6 +189,10 @@ struct paravirt_ops
 
  	pte_t (*ptep_get_and_clear)(pte_t *ptep);
 
+#ifdef CONFIG_HIGHPTE
+	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
+#endif
+
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
  	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
@@ -884,6 +890,15 @@ static inline void paravirt_release_pd(u
 	PVOP_VCALL1(release_pd, pfn);
 }
 
+#ifdef CONFIG_HIGHPTE
+static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
+{
+	unsigned long ret;
+	ret = PVOP_CALL2(unsigned long, kmap_atomic_pte, page, type);
+	return (void *)ret;
+}
+#endif
+
 static inline void pte_update(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)
 {
Index: linux/include/asm-i386/pgtable.h
===================================================================
--- linux.orig/include/asm-i386/pgtable.h
+++ linux/include/asm-i386/pgtable.h
@@ -476,9 +476,9 @@ extern pte_t *lookup_address(unsigned lo
 
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
 #define pte_offset_map_nested(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
 #define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
 #define pte_unmap_nested(pte) kunmap_atomic(pte, KM_PTE1)
 #else
Index: linux/include/linux/highmem.h
===================================================================
--- linux.orig/include/linux/highmem.h
+++ linux/include/linux/highmem.h
@@ -27,6 +27,8 @@ static inline void flush_kernel_dcache_p
 unsigned int nr_free_highpages(void);
 extern unsigned long totalhigh_pages;
 
+void kmap_flush_unused(void);
+
 #else /* CONFIG_HIGHMEM */
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
@@ -44,9 +46,13 @@ static inline void *kmap(struct page *pa
 
 #define kmap_atomic(page, idx) \
 	({ pagefault_disable(); page_address(page); })
+#define kmap_atomic_prot(page, idx, prot)	kmap_atomic(page, idx)
+
 #define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
 #define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
+
+#define kmap_flush_unused()	do {} while(0)
 #endif
 
 #endif /* CONFIG_HIGHMEM */
Index: linux/mm/highmem.c
===================================================================
--- linux.orig/mm/highmem.c
+++ linux/mm/highmem.c
@@ -99,6 +99,15 @@ static void flush_all_zero_pkmaps(void)
 	flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
 }
 
+/* Flush all unused kmap mappings in order to remove stray
+   mappings. */
+void kmap_flush_unused(void)
+{
+	spin_lock(&kmap_lock);
+	flush_all_zero_pkmaps();
+	spin_unlock(&kmap_lock);
+}
+
 static inline unsigned long map_new_virtual(struct page *page)
 {
 	unsigned long vaddr;
