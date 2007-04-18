Return-Path: <linux-kernel-owner+w=401wt.eu-S2992432AbXDRNGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992432AbXDRNGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992436AbXDRNGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:06:35 -0400
Received: from gw.goop.org ([64.81.55.164]:50570 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422991AbXDRNG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:06:29 -0400
Message-ID: <462617B7.7090800@goop.org>
Date: Wed, 18 Apr 2007 09:05:59 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 1/4] Pte drop ptep_get_and_clear paravirt op.patch
References: <200704120530.l3C5Ubs0022821@zach-dev.vmware.com> <4624CC7C.6040107@goop.org> <4624AD08.3030006@vmware.com>
In-Reply-To: <4624AD08.3030006@vmware.com>
Content-Type: multipart/mixed;
 boundary="------------040307080506020904020800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040307080506020904020800
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Zachary Amsden wrote:
> Are you sure that it still wins even with these patches?  I can't see
> ptep_get_and_clear getting much faster than a pure non-emulated, and
> the stress case which wins 25-30% is fork/exit being able to drop the
> pte updates in zap_pte_range from trapping and / or going into a pte
> update queue.  That is what my patches addressed for shadow paging
> performance - the call to pte_update can be dropped - but you should
> already be getting this benefit for Xen, since there pte_update is a
> nop.  Are you sure you are unpinning the page tables and mapping them
> back as writable pages prior to address space destruction?

I'll ask Jan for more details later today, but he did this work on
xen-unstable.  The specific change is that it only bothers to update the
pte if it wasn't already not-present.  I guess that's a generally
applicable optimisation, though it wouldn't do much for native.

> Maybe the best strategy is to just re-add ptep_get_and_clear as a
> paravirt-op after the whole set of patches and before Jan's speedup
> patch? 

Yes, I'm happy with native_ptep_get_and_clear to be a direct pagetable
write for pulldown, and then use ptep_get_and_clear as a hook for
manipulating a live pagetable.  I don't see any particular need to put
Jan's patch into the pvops Xen right now, but it would be nice to have
the option.

    J

--------------040307080506020904020800
Content-Type: text/x-patch;
 name="jan.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="jan.patch"

changeset:   14731:14c25e48a557
user:        kfraser@localhost.localdomain
date:        Thu Apr 05 09:10:33 2007 +0100
files:       linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable-2level.h linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable-3level.h linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable.h linux-2.6-xen-sparse/include/asm-x86_64/mach-xen/asm/pgtable.h
description:
linux: improve x86 page table handling performance

Where possible,
- use hypercalls instead of writing to read-only pages
- fold TLB flushes into page table update hypercalls
- on PAE, use single-access updates instead of two-access ones

The single change to PAE pte_clear() yields a 25-30% boost for kernel
builds on a 4x2x2 CPUs, 8Gb box; the other changes together yield
improvements of 2-5%.

Also, adjust backward compatibility handling in a few more places.

Signed-off-by: Jan Beulich <jbeulich@novell.com>


diff -r 07d3208c0ca3 -r 14c25e48a557 linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable-2level.h
--- a/linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable-2level.h	Thu Apr 05 08:59:12 2007 +0100
+++ b/linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable-2level.h	Thu Apr 05 09:10:33 2007 +0100
@@ -36,8 +36,37 @@
 #define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 
-#define ptep_get_and_clear(mm,addr,xp)	__pte_ma(xchg(&(xp)->pte_low, 0))
+#define pte_none(x) (!(x).pte_low)
+
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	pte_t pte = *ptep;
+	if (!pte_none(pte)) {
+		if (mm != &init_mm)
+			pte = __pte_ma(xchg(&ptep->pte_low, 0));
+		else
+			HYPERVISOR_update_va_mapping(addr, __pte(0), 0);
+	}
+	return pte;
+}
+
+#define ptep_clear_flush(vma, addr, ptep)			\
+({								\
+	pte_t *__ptep = (ptep);					\
+	pte_t __res = *__ptep;					\
+	if (!pte_none(__res) &&					\
+	    ((vma)->vm_mm != current->mm ||			\
+	     HYPERVISOR_update_va_mapping(addr, __pte(0),	\
+			(unsigned long)(vma)->vm_mm->cpu_vm_mask.bits| \
+				UVMF_INVLPG|UVMF_MULTI))) {	\
+		__ptep->pte_low = 0;				\
+		flush_tlb_page(vma, addr);			\
+	}							\
+	__res;							\
+})
+
 #define pte_same(a, b)		((a).pte_low == (b).pte_low)
+
 #define __pte_mfn(_pte) ((_pte).pte_low >> PAGE_SHIFT)
 #define pte_mfn(_pte) ((_pte).pte_low & _PAGE_PRESENT ? \
 	__pte_mfn(_pte) : pfn_to_mfn(__pte_mfn(_pte)))
@@ -46,7 +75,6 @@
 
 #define pte_page(_pte) pfn_to_page(pte_pfn(_pte))
 
-#define pte_none(x)		(!(x).pte_low)
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
diff -r 07d3208c0ca3 -r 14c25e48a557 linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable-3level.h
--- a/linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable-3level.h	Thu Apr 05 08:59:12 2007 +0100
+++ b/linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable-3level.h	Thu Apr 05 09:10:33 2007 +0100
@@ -99,6 +99,11 @@ static inline void pud_clear (pud_t * pu
 #define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
 			pmd_index(address))
 
+static inline int pte_none(pte_t pte)
+{
+	return !(pte.pte_low | pte.pte_high);
+}
+
 /*
  * For PTEs and PDEs, we must clear the P-bit first when clearing a page table
  * entry, so clear the bottom half first and enforce ordering with a compiler
@@ -106,24 +111,50 @@ static inline void pud_clear (pud_t * pu
  */
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	ptep->pte_low = 0;
-	smp_wmb();
-	ptep->pte_high = 0;
+	if ((mm != current->mm && mm != &init_mm)
+	    || HYPERVISOR_update_va_mapping(addr, __pte(0), 0)) {
+		ptep->pte_low = 0;
+		smp_wmb();
+		ptep->pte_high = 0;
+	}
 }
 
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	pte_t res;
-
-	/* xchg acts as a barrier before the setting of the high bits */
-	res.pte_low = xchg(&ptep->pte_low, 0);
-	res.pte_high = ptep->pte_high;
-	ptep->pte_high = 0;
-
-	return res;
-}
+	pte_t pte = *ptep;
+	if (!pte_none(pte)) {
+		if (mm != &init_mm) {
+			uint64_t val = pte_val_ma(pte);
+			if (__cmpxchg64(ptep, val, 0) != val) {
+				/* xchg acts as a barrier before the setting of the high bits */
+				pte.pte_low = xchg(&ptep->pte_low, 0);
+				pte.pte_high = ptep->pte_high;
+				ptep->pte_high = 0;
+			}
+		} else
+			HYPERVISOR_update_va_mapping(addr, __pte(0), 0);
+	}
+	return pte;
+}
+
+#define ptep_clear_flush(vma, addr, ptep)			\
+({								\
+	pte_t *__ptep = (ptep);					\
+	pte_t __res = *__ptep;					\
+	if (!pte_none(__res) &&					\
+	    ((vma)->vm_mm != current->mm ||			\
+	     HYPERVISOR_update_va_mapping(addr,	__pte(0),	\
+			(unsigned long)(vma)->vm_mm->cpu_vm_mask.bits| \
+				UVMF_INVLPG|UVMF_MULTI))) {	\
+		__ptep->pte_low = 0;				\
+		smp_wmb();					\
+		__ptep->pte_high = 0;				\
+		flush_tlb_page(vma, addr);			\
+	}							\
+	__res;							\
+})
 
 static inline int pte_same(pte_t a, pte_t b)
 {
@@ -131,11 +162,6 @@ static inline int pte_same(pte_t a, pte_
 }
 
 #define pte_page(x)	pfn_to_page(pte_pfn(x))
-
-static inline int pte_none(pte_t pte)
-{
-	return !pte.pte_low && !pte.pte_high;
-}
 
 #define __pte_mfn(_pte) (((_pte).pte_low >> PAGE_SHIFT) | \
 			 ((_pte).pte_high << (32-PAGE_SHIFT)))
diff -r 07d3208c0ca3 -r 14c25e48a557 linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable.h
--- a/linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable.h	Thu Apr 05 08:59:12 2007 +0100
+++ b/linux-2.6-xen-sparse/include/asm-i386/mach-xen/asm/pgtable.h	Thu Apr 05 09:10:33 2007 +0100
@@ -210,9 +210,13 @@ extern unsigned long pg0[];
 
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val(x))
+#ifdef CONFIG_XEN_COMPAT_030002
 /* pmd_present doesn't just test the _PAGE_PRESENT bit since wr.p.t.
    can temporarily clear it. */
 #define pmd_present(x)	(pmd_val(x))
+#else
+#define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
+#endif
 #define pmd_bad(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER & ~_PAGE_PRESENT)) != (_KERNPG_TABLE & ~_PAGE_PRESENT))
 
 
@@ -252,36 +256,47 @@ static inline pte_t pte_mkhuge(pte_t pte
 # include <asm/pgtable-2level.h>
 #endif
 
-static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	if (!pte_dirty(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
-}
-
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	if (!pte_young(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
-}
-
-static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
-{
-	pte_t pte;
-	if (full) {
-		pte = *ptep;
-		pte_clear(mm, addr, ptep);
-	} else {
-		pte = ptep_get_and_clear(mm, addr, ptep);
-	}
-	return pte;
-}
+#define ptep_test_and_clear_dirty(vma, addr, ptep)			\
+({									\
+	pte_t __pte = *(ptep);						\
+	int __ret = pte_dirty(__pte);					\
+	if (__ret) {							\
+		__pte = pte_mkclean(__pte);				\
+		if ((vma)->vm_mm != current->mm ||			\
+		    HYPERVISOR_update_va_mapping(addr, __pte, 0))	\
+			(ptep)->pte_low = __pte.pte_low;		\
+	}								\
+	__ret;								\
+})
+
+#define ptep_test_and_clear_young(vma, addr, ptep)			\
+({									\
+	pte_t __pte = *(ptep);						\
+	int __ret = pte_young(__pte);					\
+	if (__ret)							\
+		__pte = pte_mkold(__pte);				\
+		if ((vma)->vm_mm != current->mm ||			\
+		    HYPERVISOR_update_va_mapping(addr, __pte, 0))	\
+			(ptep)->pte_low = __pte.pte_low;		\
+	__ret;								\
+})
+
+#define ptep_get_and_clear_full(mm, addr, ptep, full)			\
+	((full) ? ({							\
+		pte_t __res = *(ptep);					\
+		if (test_bit(PG_pinned, &virt_to_page((mm)->pgd)->flags)) \
+			xen_l1_entry_update(ptep, __pte(0));		\
+		else							\
+			*(ptep) = __pte(0);				\
+		__res;							\
+	 }) :								\
+	 ptep_get_and_clear(mm, addr, ptep))
 
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	if (pte_write(*ptep))
-		clear_bit(_PAGE_BIT_RW, &ptep->pte_low);
+	pte_t pte = *ptep;
+	if (pte_write(pte))
+		set_pte_at(mm, addr, ptep, pte_wrprotect(pte));
 }
 
 /*
@@ -418,6 +433,20 @@ extern void noexec_setup(const char *str
 #define pte_unmap_nested(pte) do { } while (0)
 #endif
 
+#define __HAVE_ARCH_PTEP_ESTABLISH
+#define ptep_establish(vma, address, ptep, pteval)			\
+	do {								\
+		if ( likely((vma)->vm_mm == current->mm) ) {		\
+			BUG_ON(HYPERVISOR_update_va_mapping(address,	\
+				pteval,					\
+				(unsigned long)(vma)->vm_mm->cpu_vm_mask.bits| \
+					UVMF_INVLPG|UVMF_MULTI));	\
+		} else {						\
+			xen_l1_entry_update(ptep, pteval);		\
+			flush_tlb_page(vma, address);			\
+		}							\
+	} while (0)
+
 /*
  * The i386 doesn't have any external MMU info: the kernel page
  * tables contain all the necessary information.
@@ -430,26 +459,11 @@ extern void noexec_setup(const char *str
  */
 #define update_mmu_cache(vma,address,pte) do { } while (0)
 #define  __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-#define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-	do {								  \
-		if (__dirty) {						  \
-			if ( likely((__vma)->vm_mm == current->mm) ) {	  \
-				BUG_ON(HYPERVISOR_update_va_mapping(__address, \
-					__entry,			  \
-					(unsigned long)(__vma)->vm_mm->cpu_vm_mask.bits| \
-					UVMF_INVLPG|UVMF_MULTI));	  \
-			} else {					  \
-				xen_l1_entry_update(__ptep, __entry);	  \
-				flush_tlb_page(__vma, __address);	  \
-			}						  \
-		}							  \
+#define ptep_set_access_flags(vma, address, ptep, entry, dirty)		\
+	do {								\
+		if (dirty)						\
+			ptep_establish(vma, address, ptep, entry);	\
 	} while (0)
-
-#define __HAVE_ARCH_PTEP_ESTABLISH
-#define ptep_establish(__vma, __address, __ptep, __entry)		\
-do {				  					\
-	ptep_set_access_flags(__vma, __address, __ptep, __entry, 1);	\
-} while (0)
 
 #include <xen/features.h>
 void make_lowmem_page_readonly(void *va, unsigned int feature);
@@ -508,6 +522,7 @@ direct_remap_pfn_range(vma,from,pfn,size
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
+#define __HAVE_ARCH_PTEP_CLEAR_FLUSH
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
 #include <asm-generic/pgtable.h>
diff -r 07d3208c0ca3 -r 14c25e48a557 linux-2.6-xen-sparse/include/asm-x86_64/mach-xen/asm/pgtable.h
--- a/linux-2.6-xen-sparse/include/asm-x86_64/mach-xen/asm/pgtable.h	Thu Apr 05 08:59:12 2007 +0100
+++ b/linux-2.6-xen-sparse/include/asm-x86_64/mach-xen/asm/pgtable.h	Thu Apr 05 09:10:33 2007 +0100
@@ -93,11 +93,6 @@ extern unsigned long empty_zero_page[PAG
 #define pgd_none(x)	(!pgd_val(x))
 #define pud_none(x)	(!pud_val(x))
 
-#define set_pte_batched(pteptr, pteval) \
-	queue_l1_entry_update(pteptr, (pteval))
-
-extern inline int pud_present(pud_t pud)	{ return !pud_none(pud); }
-
 static inline void set_pte(pte_t *dst, pte_t val)
 {
 	*dst = val;
@@ -122,41 +117,6 @@ static inline void pgd_clear (pgd_t * pg
 
 #define pud_page(pud) \
     ((unsigned long) __va(pud_val(pud) & PHYSICAL_PAGE_MASK))
-
-/*
- * A note on implementation of this atomic 'get-and-clear' operation.
- * This is actually very simple because Xen Linux can only run on a single
- * processor. Therefore, we cannot race other processors setting the 'accessed'
- * or 'dirty' bits on a page-table entry.
- * Even if pages are shared between domains, that is not a problem because
- * each domain will have separate page tables, with their own versions of
- * accessed & dirty state.
- */
-#define ptep_get_and_clear(mm,addr,xp)	__pte_ma(xchg(&(xp)->pte, 0))
-
-#if 0
-static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
-{
-        pte_t pte = *xp;
-        if (pte.pte)
-                set_pte(xp, __pte_ma(0));
-        return pte;
-}
-#endif
-
-struct mm_struct;
-
-static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
-{
-	pte_t pte;
-	if (full) {
-		pte = *ptep;
-		*ptep = __pte(0);
-	} else {
-		pte = ptep_get_and_clear(mm, addr, ptep);
-	}
-	return pte;
-}
 
 #define pte_same(a, b)		((a).pte == (b).pte)
 
@@ -318,6 +278,46 @@ static inline pte_t pfn_pte(unsigned lon
 	return __pte(pte);
 }
 
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	pte_t pte = *ptep;
+	if (!pte_none(pte)) {
+		if (mm != &init_mm)
+			pte = __pte_ma(xchg(&ptep->pte, 0));
+		else
+			HYPERVISOR_update_va_mapping(addr, __pte(0), 0);
+	}
+	return pte;
+}
+
+static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
+{
+	if (full) {
+		pte_t pte = *ptep;
+		if (mm->context.pinned)
+			xen_l1_entry_update(ptep, __pte(0));
+		else
+			*ptep = __pte(0);
+		return pte;
+	}
+	return ptep_get_and_clear(mm, addr, ptep);
+}
+
+#define ptep_clear_flush(vma, addr, ptep)			\
+({								\
+	pte_t *__ptep = (ptep);					\
+	pte_t __res = *__ptep;					\
+	if (!pte_none(__res) &&					\
+	    ((vma)->vm_mm != current->mm ||			\
+	     HYPERVISOR_update_va_mapping(addr,	__pte(0), 	\
+			(unsigned long)(vma)->vm_mm->cpu_vm_mask.bits| \
+				UVMF_INVLPG|UVMF_MULTI))) {	\
+		__ptep->pte = 0;				\
+		flush_tlb_page(vma, addr);			\
+	}							\
+	__res;							\
+})
+
 /*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
@@ -346,31 +346,29 @@ static inline pte_t pte_mkwrite(pte_t pt
 static inline pte_t pte_mkwrite(pte_t pte)	{ __pte_val(pte) |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkhuge(pte_t pte)	{ __pte_val(pte) |= _PAGE_PSE; return pte; }
 
-struct vm_area_struct;
-
-static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	pte_t pte = *ptep;
-	int ret = pte_dirty(pte);
-	if (ret)
-		set_pte(ptep, pte_mkclean(pte));
-	return ret;
-}
-
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	pte_t pte = *ptep;
-	int ret = pte_young(pte);
-	if (ret)
-		set_pte(ptep, pte_mkold(pte));
-	return ret;
-}
+#define ptep_test_and_clear_dirty(vma, addr, ptep)			\
+({									\
+	pte_t __pte = *(ptep);						\
+	int __ret = pte_dirty(__pte);					\
+	if (__ret)							\
+		set_pte_at((vma)->vm_mm, addr, ptep, pte_mkclean(__pte)); \
+	__ret;								\
+})
+
+#define ptep_test_and_clear_young(vma, addr, ptep)			\
+({									\
+	pte_t __pte = *(ptep);						\
+	int __ret = pte_young(__pte);					\
+	if (__ret)							\
+		set_pte_at((vma)->vm_mm, addr, ptep, pte_mkold(__pte)); \
+	__ret;								\
+})
 
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = *ptep;
 	if (pte_write(pte))
-		set_pte(ptep, pte_wrprotect(pte));
+		set_pte_at(mm, addr, ptep, pte_wrprotect(pte));
 }
 
 /*
@@ -403,6 +401,7 @@ static inline int pmd_large(pmd_t pte) {
 /* to find an entry in a page-table-directory. */
 #define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
 #define pud_offset(pgd, address) ((pud_t *) pgd_page(*(pgd)) + pud_index(address))
+#define pud_present(pud) (pud_val(pud) & _PAGE_PRESENT)
 
 /* PMD  - Level 2 access */
 #define pmd_page_kernel(pmd) ((unsigned long) __va(pmd_val(pmd) & PTE_MASK))
@@ -412,9 +411,13 @@ static inline int pmd_large(pmd_t pte) {
 #define pmd_offset(dir, address) ((pmd_t *) pud_page(*(dir)) + \
                                   pmd_index(address))
 #define pmd_none(x)	(!pmd_val(x))
+#ifdef CONFIG_XEN_COMPAT_030002
 /* pmd_present doesn't just test the _PAGE_PRESENT bit since wr.p.t.
    can temporarily clear it. */
 #define pmd_present(x)	(pmd_val(x))
+#else
+#define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
+#endif
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 #define pmd_bad(x) ((pmd_val(x) & ~(PTE_MASK | _PAGE_USER | _PAGE_PRESENT)) \
 		    != (_KERNPG_TABLE & ~(_PAGE_USER | _PAGE_PRESENT)))
@@ -468,25 +471,34 @@ static inline pte_t pte_modify(pte_t pte
 
 #define update_mmu_cache(vma,address,pte) do { } while (0)
 
+/*
+ * Rules for using ptep_establish: the pte MUST be a user pte, and
+ * must be a present->present transition.
+ */
+#define __HAVE_ARCH_PTEP_ESTABLISH
+#define ptep_establish(vma, address, ptep, pteval)			\
+	do {								\
+		if ( likely((vma)->vm_mm == current->mm) ) {		\
+			BUG_ON(HYPERVISOR_update_va_mapping(address,	\
+				pteval,					\
+				(unsigned long)(vma)->vm_mm->cpu_vm_mask.bits| \
+					UVMF_INVLPG|UVMF_MULTI));	\
+		} else {						\
+			xen_l1_entry_update(ptep, pteval);		\
+			flush_tlb_page(vma, address);			\
+		}							\
+	} while (0)
+
 /* We only update the dirty/accessed state if we set
  * the dirty bit by hand in the kernel, since the hardware
  * will do the accessed bit for us, and we don't want to
  * race with other CPU's that might be updating the dirty
  * bit at the same time. */
 #define  __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-#define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-	do {								  \
-		if (__dirty) {						  \
-			if ( likely((__vma)->vm_mm == current->mm) ) {	  \
-				BUG_ON(HYPERVISOR_update_va_mapping(__address, \
-					__entry,			  \
-					(unsigned long)(__vma)->vm_mm->cpu_vm_mask.bits| \
-						UVMF_INVLPG|UVMF_MULTI)); \
-			} else {					  \
-				xen_l1_entry_update(__ptep, __entry);	  \
-				flush_tlb_page(__vma, __address);	  \
-			}						  \
-		}							  \
+#define ptep_set_access_flags(vma, address, ptep, entry, dirty)		\
+	do {								\
+		if (dirty)						\
+			ptep_establish(vma, address, ptep, entry);	\
 	} while (0)
 
 /* Encode and de-code a swap entry */
@@ -506,6 +518,8 @@ extern int kern_addr_valid(unsigned long
 
 #define DOMID_LOCAL (0xFFFFU)
 
+struct vm_area_struct;
+
 int direct_remap_pfn_range(struct vm_area_struct *vma,
                             unsigned long address,
                             unsigned long mfn,
@@ -551,6 +565,7 @@ int touch_pte_range(struct mm_struct *mm
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
+#define __HAVE_ARCH_PTEP_CLEAR_FLUSH
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
 #include <asm-generic/pgtable.h>


--------------040307080506020904020800--
