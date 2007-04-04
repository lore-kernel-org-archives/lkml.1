Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXDEAVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXDEAVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXDEARm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:17:42 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36889 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932183AbXDEARA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:17:00 -0400
Message-Id: <20070404191206.379769851@goop.org>
References: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:12:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
Subject: [patch 17/20] add kmap_atomic_pte for mapping highpte pages
Content-Disposition: inline; filename=paravirt-kmap_atomic_pte.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/paravirt.c |    7 +++++++
 arch/i386/mm/highmem.c      |    9 +++++++--
 include/asm-i386/highmem.h  |   11 +++++++++++
 include/asm-i386/paravirt.h |   13 ++++++++++++-
 include/asm-i386/pgtable.h  |    4 ++--
 include/linux/highmem.h     |    6 ++++++
 mm/highmem.c                |    9 +++++++++
 7 files changed, 54 insertions(+), 5 deletions(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -20,6 +20,7 @@
 #include <linux/efi.h>
 #include <linux/bcd.h>
 #include <linux/start_kernel.h>
+#include <linux/highmem.h>
 
 #include <asm/bug.h>
 #include <asm/paravirt.h>
@@ -318,6 +319,12 @@ struct paravirt_ops paravirt_ops = {
 
 	.ptep_get_and_clear = native_ptep_get_and_clear,
 
+#ifdef CONFIG_HIGHPTE
+	.kmap_atomic_pte = native_kmap_atomic_pte,
+#else
+	.kmap_atomic_pte = paravirt_nop,
+#endif
+
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.set_pte_present = native_set_pte_present,
===================================================================
--- a/arch/i386/mm/highmem.c
+++ b/arch/i386/mm/highmem.c
@@ -26,7 +26,7 @@ void kunmap(struct page *page)
  * However when holding an atomic kmap is is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  */
-void *kmap_atomic(struct page *page, enum km_type type)
+void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
@@ -41,9 +41,14 @@ void *kmap_atomic(struct page *page, enu
 		return page_address(page);
 
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
+	set_pte(kmap_pte-idx, mk_pte(page, prot));
 
 	return (void*) vaddr;
+}
+
+void *kmap_atomic(struct page *page, enum km_type type)
+{
+	return kmap_atomic_prot(page, type, kmap_prot);
 }
 
 void kunmap_atomic(void *kvaddr, enum km_type type)
===================================================================
--- a/include/asm-i386/highmem.h
+++ b/include/asm-i386/highmem.h
@@ -24,6 +24,7 @@
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
+#include <asm/paravirt.h>
 
 /* declarations for highmem.c */
 extern unsigned long highstart_pfn, highend_pfn;
@@ -67,10 +68,20 @@ extern void FASTCALL(kunmap_high(struct 
 
 void *kmap(struct page *page);
 void kunmap(struct page *page);
+void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot);
 void *kmap_atomic(struct page *page, enum km_type type);
 void kunmap_atomic(void *kvaddr, enum km_type type);
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 struct page *kmap_atomic_to_page(void *ptr);
+
+static inline void *native_kmap_atomic_pte(struct page *page, enum km_type type)
+{
+	return kmap_atomic(page, type);
+}
+
+#ifndef CONFIG_PARAVIRT
+#define kmap_atomic_pte(page, type)	kmap_atomic(page, type)
+#endif
 
 #define flush_cache_kmaps()	do { } while (0)
 
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -16,7 +16,9 @@
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/cpumask.h>
-
+#include <asm/kmap_types.h>
+
+struct page;
 struct thread_struct;
 struct Xgt_desc_struct;
 struct tss_struct;
@@ -143,6 +145,8 @@ struct paravirt_ops
 	void (*pte_update_defer)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 
  	pte_t (*ptep_get_and_clear)(pte_t *ptep);
+
+	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
 
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
@@ -768,6 +772,13 @@ static inline void paravirt_release_pd(u
 	PVOP_VCALL1(release_pd, pfn);
 }
 
+static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
+{
+	unsigned long ret;
+	ret = PVOP_CALL2(unsigned long, kmap_atomic_pte, page, type);
+	return (void *)ret;
+}
+
 static inline void pte_update(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)
 {
===================================================================
--- a/include/asm-i386/pgtable.h
+++ b/include/asm-i386/pgtable.h
@@ -481,9 +481,9 @@ extern pte_t *lookup_address(unsigned lo
 
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
===================================================================
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -27,6 +27,8 @@ unsigned int nr_free_highpages(void);
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
===================================================================
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -97,6 +97,15 @@ static void flush_all_zero_pkmaps(void)
 		set_page_address(page, NULL);
 	}
 	flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
+}
+
+/* Flush all unused kmap mappings in order to remove stray
+   mappings. */
+void kmap_flush_unused(void)
+{
+	spin_lock(&kmap_lock);
+	flush_all_zero_pkmaps();
+	spin_unlock(&kmap_lock);
 }
 
 static inline unsigned long map_new_virtual(struct page *page)

-- 

