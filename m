Return-Path: <linux-kernel-owner+w=401wt.eu-S965766AbXCPR05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965766AbXCPR05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965707AbXCPR05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:26:57 -0400
Received: from gw.goop.org ([64.81.55.164]:39118 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965766AbXCPR0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:26:55 -0400
Message-ID: <45FAD35F.8040404@goop.org>
Date: Fri, 16 Mar 2007 10:26:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/26] Xen-paravirt_ops: Xen guest implementation for
 paravirt_ops interface
References: <20070301232443.195603797@goop.org> <20070316092137.GL23174@elte.hu>
In-Reply-To: <20070316092137.GL23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This patch series implements the Linux Xen guest as a paravirt_ops 
>> backend. [...]
>>     
>
> 19/26 seems to be missing (lkml size limit?) so i couldnt review it.
>   

Shouldn't think so; its a fairly small patch.  Here it is.

    J

Subject: add kmap_atomic_pte for mapping highpte pages

Xen and VMI both have special requirements when mapping a highmem pte
page into the kernel address space.  These can be dealt with by adding
a new kmap_atomic_pte() function for mapping highptes, and hooking it
into the paravirt_ops infrastructure.

Xen specifically wants to map the pte page RO, so this patch exposes a
helper function, _kmap_atomic, which maps the page with the specified
page protections.

This also adds a kmap_flush_unused() function to clear out the cached
kmap mappings.  Xen needs this to clear out any potential stray RW
mappings of pages which will become part of a pagetable.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/paravirt.c |    7 +++++++
 arch/i386/mm/highmem.c      |    9 +++++++--
 include/asm-i386/highmem.h  |   11 +++++++++++
 include/asm-i386/paravirt.h |   14 +++++++++++++-
 include/asm-i386/pgtable.h  |    4 ++--
 include/linux/highmem.h     |    6 ++++++
 mm/highmem.c                |    9 +++++++++
 7 files changed, 55 insertions(+), 5 deletions(-)

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
@@ -600,6 +601,12 @@ struct paravirt_ops paravirt_ops = {
 
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
+void *_kmap_atomic(struct page *page, enum km_type type, pgprot_t prot)
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
+	return _kmap_atomic(page, type, kmap_prot);
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
+void *_kmap_atomic(struct page *page, enum km_type type, pgprot_t prot);
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
@@ -16,11 +16,14 @@
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
 struct mm_struct;
+
 struct paravirt_ops
 {
 	unsigned int kernel_rpl;
@@ -138,6 +141,8 @@ struct paravirt_ops
 	void (*pte_update_defer)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 
  	pte_t (*ptep_get_and_clear)(pte_t *ptep);
+
+	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
 
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
@@ -667,6 +672,13 @@ static inline void flush_tlb_others(cpum
 	PVOP_VCALL4(alloc_pd_clone, pfn, clonepfn, start, count)
 #define paravirt_release_pd(pfn) PVOP_VCALL1(release_pd, pfn)
 
+static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
+{
+	unsigned long ret;
+	ret = PVOP_CALL2(unsigned long, kmap_atomic_pte, page, type);
+	return (void *)ret;
+}
+
 static inline void pte_update(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	PVOP_VCALL3(pte_update, mm, addr, ptep);
===================================================================
--- a/include/asm-i386/pgtable.h
+++ b/include/asm-i386/pgtable.h
@@ -479,9 +479,9 @@ extern pte_t *lookup_address(unsigned lo
 
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
+#define _kmap_atomic(page, idx, prot)	kmap_atomic(page, idx)
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


