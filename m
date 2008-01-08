Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYAHWVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYAHWVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYAHWUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:20:35 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:42344
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753148AbYAHWUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:20:33 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 10] x86: page.h: make pte_t a union to always include
	pte element
X-Mercurial-Node: bf215ce311f12f24f83513d28e12217fe486009c
Message-Id: <bf215ce311f12f24f835.1199829608@localhost>
In-Reply-To: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure pte_t, whatever its definition, has a pte element with type
pteval_t.  This allows common code to access it without needing to be
specifically parameterised on what pagetable mode we're compiling for.
For 32-bit, this means that pte_t becomes a union with "pte" and "{
pte_low, pte_high }" (PAE) or just "pte_low" (non-PAE).

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/xen/mmu.c               |    4 +---
 include/asm-x86/page.h           |   10 ++++++++++
 include/asm-x86/page_32.h        |   30 +++++++-----------------------
 include/asm-x86/page_64.h        |    3 ---
 include/asm-x86/paravirt.h       |    2 +-
 include/asm-x86/pgtable-2level.h |    4 ++--
 include/asm-x86/pgtable-3level.h |    4 ++--
 include/asm-x86/pgtable_64.h     |    6 +++---
 include/asm-x86/processor.h      |    1 -
 include/xen/page.h               |    6 +++---
 10 files changed, 29 insertions(+), 41 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -246,9 +246,7 @@ pte_t xen_make_pte(unsigned long long pt
 
 	pte &= ~_PAGE_PCD;
 
-	pte &= ~_PAGE_PCD;
-
-	return (pte_t){ pte, pte >> 32 };
+	return (pte_t){ .pte = pte };
 }
 
 pmd_t xen_make_pmd(unsigned long long pmd)
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -108,6 +108,16 @@ static inline pmdval_t native_pmd_val(pm
 #include <asm-generic/pgtable-nopmd.h>
 #endif	/* PAGETABLE_LEVELS >= 3 */
 
+static inline pte_t native_make_pte(pteval_t val)
+{
+	return (pte_t) { .pte = val };
+}
+
+static inline pteval_t native_pte_val(pte_t pte)
+{
+	return pte.pte;
+}
+
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -26,18 +26,12 @@ typedef u64	pgprotval_t;
 typedef u64	pgprotval_t;
 typedef u64	phys_addr_t;
 
-typedef struct { unsigned long pte_low, pte_high; } pte_t;
-
-static inline unsigned long long native_pte_val(pte_t pte)
-{
-	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
-}
-
-static inline pte_t native_make_pte(unsigned long long val)
-{
-	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
-}
-
+typedef union {
+	struct {
+		unsigned long pte_low, pte_high;
+	};
+	pteval_t pte;
+} pte_t;
 #endif	/* __ASSEMBLY__
  */
 #else  /* !CONFIG_X86_PAE */
@@ -53,18 +47,8 @@ typedef unsigned long	pgprotval_t;
 typedef unsigned long	pgprotval_t;
 typedef unsigned long	phys_addr_t;
 
-typedef struct { pteval_t pte_low; } pte_t;
+typedef union { pteval_t pte, pte_low; } pte_t;
 typedef pte_t boot_pte_t;
-
-static inline unsigned long native_pte_val(pte_t pte)
-{
-	return pte.pte_low;
-}
-
-static inline pte_t native_make_pte(unsigned long val)
-{
-	return (pte_t) { .pte_low = val };
-}
 
 #endif	/* __ASSEMBLY__ */
 #endif	/* CONFIG_X86_PAE */
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -70,9 +70,6 @@ typedef unsigned long	phys_addr_t;
 
 typedef struct { pteval_t pte; } pte_t;
 
-#define native_pte_val(x)	((x).pte)
-#define native_make_pte(x) ((pte_t) { (x) } )
-
 #define vmemmap ((struct page *)VMEMMAP_START)
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -922,7 +922,7 @@ static inline pte_t __pte(unsigned long 
 	unsigned long long ret = PVOP_CALL2(unsigned long long,
 					    pv_mmu_ops.make_pte,
 					    val, val >> 32);
-	return (pte_t) { ret, ret >> 32 };
+	return (pte_t) { .pte = ret };
 }
 
 static inline pmd_t __pmd(unsigned long long val)
diff --git a/include/asm-x86/pgtable-2level.h b/include/asm-x86/pgtable-2level.h
--- a/include/asm-x86/pgtable-2level.h
+++ b/include/asm-x86/pgtable-2level.h
@@ -72,13 +72,13 @@ static inline int pte_exec_kernel(pte_t 
 	((((pte).pte_low >> 1) & 0x1f ) + (((pte).pte_low >> 8) << 5 ))
 
 #define pgoff_to_pte(off) \
-	((pte_t) { (((off) & 0x1f) << 1) + (((off) >> 5) << 8) + _PAGE_FILE })
+	((pte_t) { .pte_low = (((off) & 0x1f) << 1) + (((off) >> 5) << 8) + _PAGE_FILE })
 
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x1f)
 #define __swp_offset(x)			((x).val >> 8)
 #define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_low })
-#define __swp_entry_to_pte(x)		((pte_t) { (x).val })
+#define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
 #endif /* _I386_PGTABLE_2LEVEL_H */
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -163,7 +163,7 @@ static inline unsigned long pte_pfn(pte_
  * put the 32 bits of offset into the high part.
  */
 #define pte_to_pgoff(pte) ((pte).pte_high)
-#define pgoff_to_pte(off) ((pte_t) { _PAGE_FILE, (off) })
+#define pgoff_to_pte(off) ((pte_t) { { .pte_low = _PAGE_FILE, .pte_high = (off) } })
 #define PTE_FILE_MAX_BITS       32
 
 /* Encode and de-code a swap entry */
@@ -171,7 +171,7 @@ static inline unsigned long pte_pfn(pte_
 #define __swp_offset(x)			((x).val >> 5)
 #define __swp_entry(type, offset)	((swp_entry_t){(type) | (offset) << 5})
 #define __pte_to_swp_entry(pte)		((swp_entry_t){ (pte).pte_high })
-#define __swp_entry_to_pte(x)		((pte_t){ 0, (x).val })
+#define __swp_entry_to_pte(x)		((pte_t){ { .pte_high = (x).val } })
 
 #define __pmd_free_tlb(tlb, x)		do { } while (0)
 
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -72,7 +72,7 @@ extern unsigned long empty_zero_page[PAG
 
 static inline void set_pte(pte_t *dst, pte_t val)
 {
-	pte_val(*dst) = pte_val(val);
+	*dst = val;
 } 
 #define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 
@@ -222,7 +222,7 @@ static inline void ptep_set_wrprotect(st
 #define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 
 #define pte_to_pgoff(pte) ((pte_val(pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
-#define pgoff_to_pte(off) ((pte_t) { ((off) << PAGE_SHIFT) | _PAGE_FILE })
+#define pgoff_to_pte(off) ((pte_t) { .pte = ((off) << PAGE_SHIFT) | _PAGE_FILE })
 #define PTE_FILE_MAX_BITS __PHYSICAL_MASK_SHIFT
 
 /* PTE - Level 1 access. */
@@ -264,7 +264,7 @@ static inline void ptep_set_wrprotect(st
 #define __swp_offset(x)			((x).val >> 8)
 #define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
-#define __swp_entry_to_pte(x)		((pte_t) { (x).val })
+#define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
 extern spinlock_t pgd_lock;
 extern struct list_head pgd_list;
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -10,7 +10,6 @@ struct mm_struct;
 #include <asm/vm86.h>
 #include <asm/math_emu.h>
 #include <asm/segment.h>
-#include <asm/page.h>
 #include <asm/types.h>
 #include <asm/sigcontext.h>
 #include <asm/current.h>
diff --git a/include/xen/page.h b/include/xen/page.h
--- a/include/xen/page.h
+++ b/include/xen/page.h
@@ -156,16 +156,16 @@ static inline pte_t mfn_pte(unsigned lon
 
 static inline unsigned long long pte_val_ma(pte_t x)
 {
-	return ((unsigned long long)x.pte_high << 32) | x.pte_low;
+	return x.pte;
 }
 #define pmd_val_ma(v) ((v).pmd)
 #define pud_val_ma(v) ((v).pgd.pgd)
-#define __pte_ma(x)	((pte_t) { .pte_low = (x), .pte_high = (x)>>32 } )
+#define __pte_ma(x)	((pte_t) { .pte = (x) })
 #define __pmd_ma(x)	((pmd_t) { (x) } )
 #else  /* !X86_PAE */
 #define pte_mfn(_pte) ((_pte).pte_low >> PAGE_SHIFT)
 #define mfn_pte(pfn, prot)	__pte_ma(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
-#define pte_val_ma(x)	((x).pte_low)
+#define pte_val_ma(x)	((x).pte)
 #define pmd_val_ma(v)	((v).pud.pgd.pgd)
 #define __pte_ma(x)	((pte_t) { (x) } )
 #endif	/* CONFIG_X86_PAE */


