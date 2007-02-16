Return-Path: <linux-kernel-owner+w=401wt.eu-S1423189AbXBPEsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423189AbXBPEsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422749AbXBPEsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:48:16 -0500
Received: from dsl092-017-127.sfo4.dsl.speakeasy.net ([66.92.17.127]:36052
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423185AbXBPEpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:45:25 -0500
Message-Id: <20070216022530.657670466@goop.org>
References: <20070216022449.739760547@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Feb 2007 18:24:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: [patch 03/21] Xen-paravirt: Add pagetable accessors to pack and unpack pagetable entries
Content-Disposition: inline; filename=paravirt-pte-accessors.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a set of accessors to pack, unpack and modify page table entries
(at all levels).  This allows a paravirt implementation to control the
contents of pgd/pmd/pte entries.  For example, Xen uses this to
convert the (pseudo-)physical address into a machine address when
populating a pagetable entry, and converting back to pphys address
when an entry is read.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

--
 arch/i386/kernel/paravirt.c       |  113 ++++++++++++++++++++++++++++++++----
 arch/i386/kernel/vmlinux.lds.S    |    3
 include/asm-i386/page.h           |   18 ++++-
 include/asm-i386/paravirt.h       |   68 +++++++++++++++++++++
 include/asm-i386/pgtable-2level.h |    5 -
 include/asm-i386/pgtable-3level.h |   27 ++++----
 6 files changed, 199 insertions(+), 35 deletions(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -34,7 +34,7 @@
 #include <asm/tlbflush.h>
 
 /* nop stub */
-static void native_nop(void)
+void native_nop(void)
 {
 }
 
@@ -400,38 +400,76 @@ static void native_flush_tlb_single(u32 
 }
 
 #ifndef CONFIG_X86_PAE
-static void native_set_pte(pte_t *ptep, pte_t pteval)
+void native_set_pte(pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
 }
 
-static void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval)
+void native_set_pte_at(struct mm_struct *mm, u32 addr,
+		       pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
 }
 
-static void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	*pmdp = pmdval;
 }
 
+unsigned long native_pte_val(pte_t pte)
+{
+	return pte.pte_low;
+}
+
+unsigned long native_pmd_val(pmd_t pmd)
+{
+	BUG();
+	return 0;
+}
+
+unsigned long native_pgd_val(pgd_t pgd)
+{
+	return pgd.pgd;
+}
+
+pte_t native_make_pte(unsigned long pte)
+{
+	return (pte_t){ pte };
+}
+
+pmd_t native_make_pmd(unsigned long pmd)
+{
+	BUG();
+}
+
+pgd_t native_make_pgd(unsigned long pgd)
+{
+	return (pgd_t){ pgd };
+}
+
+pte_t native_ptep_get_and_clear(pte_t *ptep)
+{
+	return __pte(xchg(&(ptep)->pte_low, 0));
+}
+
 #else /* CONFIG_X86_PAE */
 
-static void native_set_pte(pte_t *ptep, pte_t pte)
+void native_set_pte(pte_t *ptep, pte_t pte)
 {
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
 }
 
-static void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
+void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
 {
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
 }
 
-static void native_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
+void native_set_pte_present(struct mm_struct *mm, u32 addr,
+			    pte_t *ptep, pte_t pte)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
@@ -440,35 +478,78 @@ static void native_set_pte_present(struc
 	ptep->pte_low = pte.pte_low;
 }
 
-static void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
+void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
 {
 	set_64bit((unsigned long long *)ptep,pte_val(pteval));
 }
 
-static void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	set_64bit((unsigned long long *)pmdp,pmd_val(pmdval));
 }
 
-static void native_set_pud(pud_t *pudp, pud_t pudval)
+void native_set_pud(pud_t *pudp, pud_t pudval)
 {
 	*pudp = pudval;
 }
 
-static void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+void native_pte_clear(struct mm_struct *mm, u32 addr, pte_t *ptep)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
 	ptep->pte_high = 0;
 }
 
-static void native_pmd_clear(pmd_t *pmd)
+void native_pmd_clear(pmd_t *pmd)
 {
 	u32 *tmp = (u32 *)pmd;
 	*tmp = 0;
 	smp_wmb();
 	*(tmp + 1) = 0;
 }
+
+unsigned long long native_pte_val(pte_t pte)
+{
+	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
+}
+
+unsigned long long native_pmd_val(pmd_t pmd)
+{
+	return pmd.pmd;
+}
+
+unsigned long long native_pgd_val(pgd_t pgd)
+{
+	return pgd.pgd;
+}
+
+pte_t native_make_pte(unsigned long long pte)
+{
+	return (pte_t){ pte };
+}
+
+pmd_t native_make_pmd(unsigned long long pmd)
+{
+	return (pmd_t){ pmd };
+}
+
+pgd_t native_make_pgd(unsigned long long pgd)
+{
+	return (pgd_t){ pgd };
+}
+
+pte_t native_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res;
+
+	/* xchg acts as a barrier before the setting of the high bits */
+	res.pte_low = xchg(&ptep->pte_low, 0);
+	res.pte_high = ptep->pte_high;
+	ptep->pte_high = 0;
+
+	return res;
+}
+
 #endif /* CONFIG_X86_PAE */
 
 /* These are in entry.S */
@@ -561,6 +642,9 @@ struct paravirt_ops paravirt_ops = {
 	.set_pmd = native_set_pmd,
 	.pte_update = (void *)native_nop,
 	.pte_update_defer = (void *)native_nop,
+
+	.ptep_get_and_clear = native_ptep_get_and_clear,
+
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.set_pte_present = native_set_pte_present,
@@ -569,6 +653,14 @@ struct paravirt_ops paravirt_ops = {
 	.pmd_clear = native_pmd_clear,
 #endif
 
+	.pte_val = native_pte_val,
+	.pmd_val = native_pmd_val,
+	.pgd_val = native_pgd_val,
+
+	.make_pte = native_make_pte,
+	.make_pmd = native_make_pmd,
+	.make_pgd = native_make_pgd,
+
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
===================================================================
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -21,6 +21,9 @@
 #include <asm/page.h>
 #include <asm/cache.h>
 #include <asm/boot.h>
+
+#undef ENTRY
+#undef ALIGN
 
 OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
 OUTPUT_ARCH(i386)
===================================================================
--- a/include/asm-i386/page.h
+++ b/include/asm-i386/page.h
@@ -11,7 +11,6 @@
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
-
 
 #ifdef CONFIG_X86_USE_3DNOW
 
@@ -48,9 +47,11 @@ typedef struct { unsigned long long pmd;
 typedef struct { unsigned long long pmd; } pmd_t;
 typedef struct { unsigned long long pgd; } pgd_t;
 typedef struct { unsigned long long pgprot; } pgprot_t;
+#ifndef CONFIG_PARAVIRT
 #define pmd_val(x)	((x).pmd)
 #define pte_val(x)	((x).pte_low | ((unsigned long long)(x).pte_high << 32))
 #define __pmd(x) ((pmd_t) { (x) } )
+#endif	/* CONFIG_PARAVIRT */
 #define HPAGE_SHIFT	21
 #include <asm-generic/pgtable-nopud.h>
 #else
@@ -58,7 +59,9 @@ typedef struct { unsigned long pgd; } pg
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
 #define boot_pte_t pte_t /* or would you rather have a typedef */
+#ifndef CONFIG_PARAVIRT
 #define pte_val(x)	((x).pte_low)
+#endif
 #define HPAGE_SHIFT	22
 #include <asm-generic/pgtable-nopmd.h>
 #endif
@@ -71,12 +74,14 @@ typedef struct { unsigned long pgprot; }
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
 
+#define pgprot_val(x)	((x).pgprot)
+#define __pgprot(x)	((pgprot_t) { (x) } )
+
+#ifndef CONFIG_PARAVIRT
 #define pgd_val(x)	((x).pgd)
-#define pgprot_val(x)	((x).pgprot)
-
 #define __pte(x) ((pte_t) { (x) } )
 #define __pgd(x) ((pgd_t) { (x) } )
-#define __pgprot(x)	((pgprot_t) { (x) } )
+#endif
 
 #endif /* !__ASSEMBLY__ */
 
@@ -143,6 +148,11 @@ extern int page_is_ram(unsigned long pag
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
+#ifdef CONFIG_PARAVIRT
+/* After pte_t, etc, have been defined */
+#include <asm/paravirt.h>
+#endif
+
 #ifndef CONFIG_COMPAT_VDSO
 #define __HAVE_ARCH_GATE_AREA 1
 #endif
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -25,6 +25,8 @@
 #define CLBR_ANY 0x7
 
 #ifndef __ASSEMBLY__
+#include <linux/types.h>
+
 struct thread_struct;
 struct Xgt_desc_struct;
 struct tss_struct;
@@ -140,12 +142,31 @@ struct paravirt_ops
 	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
 	void (*pte_update)(struct mm_struct *mm, u32 addr, pte_t *ptep);
 	void (*pte_update_defer)(struct mm_struct *mm, u32 addr, pte_t *ptep);
+
+ 	pte_t (*ptep_get_and_clear)(pte_t *ptep);
+
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
-	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
+ 	void (*set_pte_present)(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte);
 	void (*set_pud)(pud_t *pudp, pud_t pudval);
-	void (*pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+ 	void (*pte_clear)(struct mm_struct *mm, u32 addr, pte_t *ptep);
 	void (*pmd_clear)(pmd_t *pmdp);
+
+	unsigned long long (*pte_val)(pte_t);
+	unsigned long long (*pmd_val)(pmd_t);
+	unsigned long long (*pgd_val)(pgd_t);
+
+	pte_t (*make_pte)(unsigned long long pte);
+	pmd_t (*make_pmd)(unsigned long long pmd);
+	pgd_t (*make_pgd)(unsigned long long pgd);
+#else
+	unsigned long (*pte_val)(pte_t);
+	unsigned long (*pmd_val)(pmd_t);
+	unsigned long (*pgd_val)(pgd_t);
+
+	pte_t (*make_pte)(unsigned long pte);
+	pmd_t (*make_pmd)(unsigned long pmd);
+	pgd_t (*make_pgd)(unsigned long pgd);
 #endif
 
 	void (*set_lazy_mode)(int mode);
@@ -163,6 +184,24 @@ struct paravirt_ops
 		__attribute__((__section__(".paravirtprobe"))) = fn
 
 extern struct paravirt_ops paravirt_ops;
+
+#ifdef CONFIG_X86_PAE
+unsigned long long native_pte_val(pte_t);
+unsigned long long native_pmd_val(pmd_t);
+unsigned long long native_pgd_val(pgd_t);
+
+pte_t native_make_pte(unsigned long long pte);
+pmd_t native_make_pmd(unsigned long long pmd);
+pgd_t native_make_pgd(unsigned long long pgd);
+#else
+unsigned long native_pte_val(pte_t);
+unsigned long native_pmd_val(pmd_t);
+unsigned long native_pgd_val(pgd_t);
+
+pte_t native_make_pte(unsigned long pte);
+pmd_t native_make_pmd(unsigned long pmd);
+pgd_t native_make_pgd(unsigned long pgd);
+#endif
 
 #define paravirt_enabled() (paravirt_ops.paravirt_enabled)
 
@@ -215,6 +254,8 @@ static inline void __cpuid(unsigned int 
 #define read_cr4() paravirt_ops.read_cr4()
 #define read_cr4_safe(x) paravirt_ops.read_cr4_safe()
 #define write_cr4(x) paravirt_ops.write_cr4(x)
+
+#define raw_ptep_get_and_clear(xp)	(paravirt_ops.ptep_get_and_clear(xp))
 
 static inline void raw_safe_halt(void)
 {
@@ -297,6 +338,17 @@ static inline void halt(void)
 	(paravirt_ops.write_idt_entry((dt), (entry), (low), (high)))
 #define set_iopl_mask(mask) (paravirt_ops.set_iopl_mask(mask))
 
+#define __pte(x)	paravirt_ops.make_pte(x)
+#define __pgd(x)	paravirt_ops.make_pgd(x)
+
+#define pte_val(x)	paravirt_ops.pte_val(x)
+#define pgd_val(x)	paravirt_ops.pgd_val(x)
+
+#ifdef CONFIG_X86_PAE
+#define __pmd(x)	paravirt_ops.make_pmd(x)
+#define pmd_val(x)	paravirt_ops.pmd_val(x)
+#endif
+
 /* The paravirtualized I/O functions */
 static inline void slow_down_io(void) {
 	paravirt_ops.io_delay();
@@ -336,6 +388,18 @@ static inline void setup_secondary_clock
 	paravirt_ops.setup_secondary_clock();
 }
 #endif
+
+
+void native_set_pte(pte_t *ptep, pte_t pteval);
+void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval);
+void native_set_pmd(pmd_t *pmdp, pmd_t pmdval);
+void native_set_pte_present(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte);
+void native_set_pte_atomic(pte_t *ptep, pte_t pteval);
+void native_set_pud(pud_t *pudp, pud_t pudval);
+void native_pte_clear(struct mm_struct *mm, u32 addr, pte_t *ptep);
+void native_pmd_clear(pmd_t *pmd);
+pte_t native_ptep_get_and_clear(pte_t *ptep);
+void native_nop(void);
 
 #ifdef CONFIG_SMP
 static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
===================================================================
--- a/include/asm-i386/pgtable-2level.h
+++ b/include/asm-i386/pgtable-2level.h
@@ -15,6 +15,7 @@
 #define set_pte(pteptr, pteval) (*(pteptr) = pteval)
 #define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 #define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
+#define raw_ptep_get_and_clear(xp)	__pte(xchg(&(xp)->pte_low, 0))
 #endif
 
 #define set_pte_atomic(pteptr, pteval) set_pte(pteptr,pteval)
@@ -23,11 +24,9 @@
 #define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 
-#define raw_ptep_get_and_clear(xp)	__pte(xchg(&(xp)->pte_low, 0))
-
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
 #define pte_none(x)		(!(x).pte_low)
-#define pte_pfn(x)		((unsigned long)(((x).pte_low >> PAGE_SHIFT)))
+#define pte_pfn(x)		(pte_val(x) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
===================================================================
--- a/include/asm-i386/pgtable-3level.h
+++ b/include/asm-i386/pgtable-3level.h
@@ -98,6 +98,18 @@ static inline void pmd_clear(pmd_t *pmd)
 	smp_wmb();
 	*(tmp + 1) = 0;
 }
+
+static inline pte_t raw_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res;
+
+	/* xchg acts as a barrier before the setting of the high bits */
+	res.pte_low = xchg(&ptep->pte_low, 0);
+	res.pte_high = ptep->pte_high;
+	ptep->pte_high = 0;
+
+	return res;
+}
 #endif
 
 /*
@@ -119,18 +131,6 @@ static inline void pud_clear (pud_t * pu
 #define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
 			pmd_index(address))
 
-static inline pte_t raw_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res;
-
-	/* xchg acts as a barrier before the setting of the high bits */
-	res.pte_low = xchg(&ptep->pte_low, 0);
-	res.pte_high = ptep->pte_high;
-	ptep->pte_high = 0;
-
-	return res;
-}
-
 #define __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t a, pte_t b)
 {
@@ -146,8 +146,7 @@ static inline int pte_none(pte_t pte)
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
-	return (pte.pte_low >> PAGE_SHIFT) |
-		(pte.pte_high << (32 - PAGE_SHIFT));
+	return pte_val(pte) >> PAGE_SHIFT;
 }
 
 extern unsigned long long __supported_pte_mask;

-- 

