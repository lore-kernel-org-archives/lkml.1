Return-Path: <linux-kernel-owner+w=401wt.eu-S1422847AbXCBEUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422847AbXCBEUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422849AbXCBEUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:20:08 -0500
Received: from gw.goop.org ([64.81.55.164]:54594 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422847AbXCBEUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:20:05 -0500
Message-ID: <45E79C72.4000806@goop.org>
Date: Thu, 01 Mar 2007 19:39:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@muc.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] Vmi fix highpte
References: <200703020254.l222smBB009668@zach-dev.vmware.com> <45E79529.9000305@goop.org>
In-Reply-To: <45E79529.9000305@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Hm, I don't think this interface will work for Xen.  In Xen, whenever a
> pagetable page gets mapped, it must be mapped RO.  map_pt_hook gets
> called after the mapping has already been created, so its too late for Xen.
>
> I was planning on adding kmap_atomic_pte() for use in pte_offset_map*(),
> which would be wired through to paravirt_ops to allow Xen to make this a
> RO mapping.  Would this be sufficient for you to do your vmi thing?
>   

Something like this (compiled, untested).

    J

diff -r 972e84c265cf arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Thu Mar 01 19:12:49 2007 -0800
+++ b/arch/i386/kernel/paravirt.c	Thu Mar 01 19:38:42 2007 -0800
@@ -32,6 +32,7 @@
 #include <asm/fixmap.h>
 #include <asm/apic.h>
 #include <asm/tlbflush.h>
+#include <asm/highmem.h>
 
 /* nop stub */
 void _paravirt_nop(void)
@@ -605,6 +606,8 @@ struct paravirt_ops paravirt_ops = {
 
 	.kpte_clear_flush = native_kpte_clear_flush,
 
+	.kmap_atomic_pte = native_kmap_atomic_pte,
+
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.set_pte_present = native_set_pte_present,
diff -r 972e84c265cf arch/i386/mm/highmem.c
--- a/arch/i386/mm/highmem.c	Thu Mar 01 19:12:49 2007 -0800
+++ b/arch/i386/mm/highmem.c	Thu Mar 01 19:38:42 2007 -0800
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
diff -r 972e84c265cf arch/i386/xen/enlighten.c
--- a/arch/i386/xen/enlighten.c	Thu Mar 01 19:12:49 2007 -0800
+++ b/arch/i386/xen/enlighten.c	Thu Mar 01 19:38:42 2007 -0800
@@ -24,6 +24,7 @@
 #include <asm/setup.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
+#include <asm/highmem.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -499,6 +500,11 @@ static void xen_release_pt(u32 pfn)
 		ClearPagePinned(page);
 		make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 	}
+}
+
+static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
+{
+	return _kmap_atomic(page, type, PAGE_KERNEL_RO);
 }
 
 static __init void xen_pagetable_setup_start(pgd_t *base)
@@ -688,6 +694,8 @@ static const struct paravirt_ops xen_par
 
 	.kpte_clear_flush = xen_kpte_clear_flush,
 
+	.kmap_atomic_pte = xen_kmap_atomic_pte,
+
 	.pte_val = xen_pte_val,
 	.pgd_val = xen_pgd_val,
 
diff -r 972e84c265cf include/asm-i386/highmem.h
--- a/include/asm-i386/highmem.h	Thu Mar 01 19:12:49 2007 -0800
+++ b/include/asm-i386/highmem.h	Thu Mar 01 19:38:42 2007 -0800
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
+#define kmap_atomic_pte(page, type)	native_kmap_atomic_pte(page, type)
+#endif
 
 #define flush_cache_kmaps()	do { } while (0)
 
diff -r 972e84c265cf include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Thu Mar 01 19:12:49 2007 -0800
+++ b/include/asm-i386/paravirt.h	Thu Mar 01 19:38:42 2007 -0800
@@ -15,6 +15,9 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
+#include <asm/kmap_types.h>
+
+struct page;
 
 #define paravirt_type(type)		[paravirt_typenum] "i" (type)
 #define paravirt_clobber(clobber)	[paravirt_clobber] "i" (clobber)
@@ -372,6 +375,8 @@ struct paravirt_ops
 
  	pte_t (*ptep_get_and_clear)(pte_t *ptep);
 
+	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
+
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
  	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
@@ -695,6 +700,13 @@ static inline void paravirt_init_pda(str
 #define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) \
 	PVOP_VCALL4(alloc_pd_clone, pfn, clonepfn, start, count)
 #define paravirt_release_pd(pfn) PVOP_VCALL1(release_pd, pfn)
+
+static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
+{
+	unsigned long ret;
+	ret = PVOP_CALL2(unsigned long, kmap_atomic_pte, page, type);
+	return (void *)ret;
+}
 
 static inline void kpte_clear_flush(pte_t *ptep, unsigned long vaddr)
 {
diff -r 972e84c265cf include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h	Thu Mar 01 19:12:49 2007 -0800
+++ b/include/asm-i386/pgtable.h	Thu Mar 01 19:38:42 2007 -0800
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


