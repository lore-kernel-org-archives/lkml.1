Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYGVOEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYGVOEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYGVOEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:04:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44162 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbYGVOEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:04:11 -0400
Date: Tue, 22 Jul 2008 16:03:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [git pull] x86 fixes
Message-ID: <20080722140348.GA26267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
Jan Kratochvil (1):
      x86: fix crash due to missing debugctlmsr on AMD K6-3

Jeremy Fitzhardinge (2):
      x86: rename PTE_MASK to PTE_PFN_MASK
      x86: add PTE_FLAGS_MASK

Rusty Russell (1):
      x86: fix pte_flags() to only return flags, fix lguest (updated)

Thomas Gleixner (1):
      x86: move the last Dprintk instance to pr_debug()

Yinghai Lu (1):
      x86: use setup_clear_cpu_cap with disable_apic, fix


 arch/x86/Kconfig.cpu              |    2 +-
 arch/x86/kernel/paravirt.c        |    2 +-
 arch/x86/kernel/setup.c           |    2 +-
 arch/x86/mach-es7000/es7000plat.c |    8 ++++----
 arch/x86/mm/dump_pagetables.c     |   10 +++++-----
 arch/x86/xen/enlighten.c          |    2 +-
 arch/x86/xen/mmu.c                |    8 ++++----
 include/asm-x86/page.h            |   14 +++++++++++---
 include/asm-x86/paravirt.h        |    3 +++
 include/asm-x86/pgtable-3level.h  |    8 ++++----
 include/asm-x86/pgtable.h         |    4 ++--
 include/asm-x86/pgtable_32.h      |    4 ++--
 include/asm-x86/pgtable_64.h      |   10 +++++-----
 include/asm-x86/xen/page.h        |    2 +-
 14 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 54b8c02..2c518fb 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -414,4 +414,4 @@ config X86_MINIMUM_CPU_FAMILY
 
 config X86_DEBUGCTLMSR
 	def_bool y
-	depends on !(M586MMX || M586TSC || M586 || M486 || M386)
+	depends on !(MK6 || MWINCHIPC6 || MWINCHIP2 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 097d8a6..94da4d5 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -443,7 +443,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 #endif /* PAGETABLE_LEVELS >= 3 */
 
 	.pte_val = native_pte_val,
-	.pte_flags = native_pte_val,
+	.pte_flags = native_pte_flags,
 	.pgd_val = native_pgd_val,
 
 	.make_pte = native_make_pte,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ec952aa..b4aacb9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -680,7 +680,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_LOCAL_APIC
 		disable_apic = 1;
 #endif
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+		setup_clear_cpu_cap(X86_FEATURE_APIC);
 	}
 
 #ifdef CONFIG_PCI
diff --git a/arch/x86/mach-es7000/es7000plat.c b/arch/x86/mach-es7000/es7000plat.c
index 4354ce8..50189af 100644
--- a/arch/x86/mach-es7000/es7000plat.c
+++ b/arch/x86/mach-es7000/es7000plat.c
@@ -130,10 +130,10 @@ parse_unisys_oem (char *oemptr)
 			mip_addr = val;
 			mip = (struct mip_reg *)val;
 			mip_reg = __va(mip);
-			Dprintk("es7000_mipcfg: host_reg = 0x%lx \n",
-				(unsigned long)host_reg);
-			Dprintk("es7000_mipcfg: mip_reg = 0x%lx \n",
-				(unsigned long)mip_reg);
+			pr_debug("es7000_mipcfg: host_reg = 0x%lx \n",
+				 (unsigned long)host_reg);
+			pr_debug("es7000_mipcfg: mip_reg = 0x%lx \n",
+				 (unsigned long)mip_reg);
 			success++;
 			break;
 		case MIP_PSAI_REG:
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 0bb0cae..a20d1fa 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -148,8 +148,8 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 	 * we have now. "break" is either changing perms, levels or
 	 * address space marker.
 	 */
-	prot = pgprot_val(new_prot) & ~(PTE_MASK);
-	cur = pgprot_val(st->current_prot) & ~(PTE_MASK);
+	prot = pgprot_val(new_prot) & ~(PTE_PFN_MASK);
+	cur = pgprot_val(st->current_prot) & ~(PTE_PFN_MASK);
 
 	if (!st->level) {
 		/* First entry */
@@ -221,7 +221,7 @@ static void walk_pmd_level(struct seq_file *m, struct pg_state *st, pud_t addr,
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		st->current_address = normalize_addr(P + i * PMD_LEVEL_MULT);
 		if (!pmd_none(*start)) {
-			pgprotval_t prot = pmd_val(*start) & ~PTE_MASK;
+			pgprotval_t prot = pmd_val(*start) & PTE_FLAGS_MASK;
 
 			if (pmd_large(*start) || !pmd_present(*start))
 				note_page(m, st, __pgprot(prot), 3);
@@ -253,7 +253,7 @@ static void walk_pud_level(struct seq_file *m, struct pg_state *st, pgd_t addr,
 	for (i = 0; i < PTRS_PER_PUD; i++) {
 		st->current_address = normalize_addr(P + i * PUD_LEVEL_MULT);
 		if (!pud_none(*start)) {
-			pgprotval_t prot = pud_val(*start) & ~PTE_MASK;
+			pgprotval_t prot = pud_val(*start) & PTE_FLAGS_MASK;
 
 			if (pud_large(*start) || !pud_present(*start))
 				note_page(m, st, __pgprot(prot), 2);
@@ -288,7 +288,7 @@ static void walk_pgd_level(struct seq_file *m)
 	for (i = 0; i < PTRS_PER_PGD; i++) {
 		st.current_address = normalize_addr(i * PGD_LEVEL_MULT);
 		if (!pgd_none(*start)) {
-			pgprotval_t prot = pgd_val(*start) & ~PTE_MASK;
+			pgprotval_t prot = pgd_val(*start) & PTE_FLAGS_MASK;
 
 			if (pgd_large(*start) || !pgd_present(*start))
 				note_page(m, &st, __pgprot(prot), 1);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 194bbd6..9ff6e3c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1435,7 +1435,7 @@ static unsigned long m2p(phys_addr_t maddr)
 {
 	phys_addr_t paddr;
 
-	maddr &= PTE_MASK;
+	maddr &= PTE_PFN_MASK;
 	paddr = mfn_to_pfn(maddr >> PAGE_SHIFT) << PAGE_SHIFT;
 
 	return paddr;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a44d56e..aa37469 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -343,8 +343,8 @@ void xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 static pteval_t pte_mfn_to_pfn(pteval_t val)
 {
 	if (val & _PAGE_PRESENT) {
-		unsigned long mfn = (val & PTE_MASK) >> PAGE_SHIFT;
-		pteval_t flags = val & ~PTE_MASK;
+		unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
+		pteval_t flags = val & PTE_FLAGS_MASK;
 		val = ((pteval_t)mfn_to_pfn(mfn) << PAGE_SHIFT) | flags;
 	}
 
@@ -354,8 +354,8 @@ static pteval_t pte_mfn_to_pfn(pteval_t val)
 static pteval_t pte_pfn_to_mfn(pteval_t val)
 {
 	if (val & _PAGE_PRESENT) {
-		unsigned long pfn = (val & PTE_MASK) >> PAGE_SHIFT;
-		pteval_t flags = val & ~PTE_MASK;
+		unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
+		pteval_t flags = val & PTE_FLAGS_MASK;
 		val = ((pteval_t)pfn_to_mfn(pfn) << PAGE_SHIFT) | flags;
 	}
 
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index 28d7b45..6c84622 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -18,8 +18,11 @@
    (ie, 32-bit PAE). */
 #define PHYSICAL_PAGE_MASK	(((signed long)PAGE_MASK) & __PHYSICAL_MASK)
 
-/* PTE_MASK extracts the PFN from a (pte|pmd|pud|pgd)val_t */
-#define PTE_MASK		((pteval_t)PHYSICAL_PAGE_MASK)
+/* PTE_PFN_MASK extracts the PFN from a (pte|pmd|pud|pgd)val_t */
+#define PTE_PFN_MASK		((pteval_t)PHYSICAL_PAGE_MASK)
+
+/* PTE_FLAGS_MASK extracts the flags from a (pte|pmd|pud|pgd)val_t */
+#define PTE_FLAGS_MASK		(~PTE_PFN_MASK)
 
 #define PMD_PAGE_SIZE		(_AC(1, UL) << PMD_SHIFT)
 #define PMD_PAGE_MASK		(~(PMD_PAGE_SIZE-1))
@@ -144,6 +147,11 @@ static inline pteval_t native_pte_val(pte_t pte)
 	return pte.pte;
 }
 
+static inline pteval_t native_pte_flags(pte_t pte)
+{
+	return native_pte_val(pte) & PTE_FLAGS_MASK;
+}
+
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
@@ -165,7 +173,7 @@ static inline pteval_t native_pte_val(pte_t pte)
 #endif
 
 #define pte_val(x)	native_pte_val(x)
-#define pte_flags(x)	native_pte_val(x)
+#define pte_flags(x)	native_pte_flags(x)
 #define __pte(x)	native_make_pte(x)
 
 #endif	/* CONFIG_PARAVIRT */
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index aec9767..fbbde93 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1088,6 +1088,9 @@ static inline pteval_t pte_flags(pte_t pte)
 		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.pte_flags,
 				 pte.pte);
 
+#ifdef CONFIG_PARAVIRT_DEBUG
+	BUG_ON(ret & PTE_PFN_MASK);
+#endif
 	return ret;
 }
 
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
index c93dbb6..105057f 100644
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -25,7 +25,7 @@ static inline int pud_none(pud_t pud)
 
 static inline int pud_bad(pud_t pud)
 {
-	return (pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
+	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
 }
 
 static inline int pud_present(pud_t pud)
@@ -120,9 +120,9 @@ static inline void pud_clear(pud_t *pudp)
 		write_cr3(pgd);
 }
 
-#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_MASK))
+#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_PFN_MASK))
 
-#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PTE_MASK))
+#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PTE_PFN_MASK))
 
 
 /* Find an entry in the second-level page table.. */
@@ -160,7 +160,7 @@ static inline int pte_none(pte_t pte)
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
-	return (pte_val(pte) & PTE_MASK) >> PAGE_SHIFT;
+	return (pte_val(pte) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
 /*
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 96aa76e..3e5dbc4 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -53,7 +53,7 @@
 			 _PAGE_DIRTY)
 
 /* Set of bits not changed in pte_modify */
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PCD | _PAGE_PWT |		\
+#define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
 			 _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
@@ -286,7 +286,7 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 	return __pgprot(preservebits | addbits);
 }
 
-#define pte_pgprot(x) __pgprot(pte_flags(x) & ~PTE_MASK)
+#define pte_pgprot(x) __pgprot(pte_flags(x) & PTE_FLAGS_MASK)
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index 0611abf..5c3b265 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -88,7 +88,7 @@ extern unsigned long pg0[];
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
-#define pmd_bad(x) ((pmd_val(x) & (~PTE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
+#define pmd_bad(x) ((pmd_val(x) & (PTE_FLAGS_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
 
@@ -139,7 +139,7 @@ static inline int pud_large(pud_t pud) { return 0; }
 #define pmd_page(pmd) (pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
 
 #define pmd_page_vaddr(pmd)					\
-	((unsigned long)__va(pmd_val((pmd)) & PTE_MASK))
+	((unsigned long)__va(pmd_val((pmd)) & PTE_PFN_MASK))
 
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address)					\
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 805d312..ac5fff4 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -158,17 +158,17 @@ static inline void native_pgd_clear(pgd_t *pgd)
 
 static inline int pgd_bad(pgd_t pgd)
 {
-	return (pgd_val(pgd) & ~(PTE_MASK | _PAGE_USER)) != _KERNPG_TABLE;
+	return (pgd_val(pgd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
 static inline int pud_bad(pud_t pud)
 {
-	return (pud_val(pud) & ~(PTE_MASK | _PAGE_USER)) != _KERNPG_TABLE;
+	return (pud_val(pud) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
 static inline int pmd_bad(pmd_t pmd)
 {
-	return (pmd_val(pmd) & ~(PTE_MASK | _PAGE_USER)) != _KERNPG_TABLE;
+	return (pmd_val(pmd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
 #define pte_none(x)	(!pte_val((x)))
@@ -193,7 +193,7 @@ static inline int pmd_bad(pmd_t pmd)
  * Level 4 access.
  */
 #define pgd_page_vaddr(pgd)						\
-	((unsigned long)__va((unsigned long)pgd_val((pgd)) & PTE_MASK))
+	((unsigned long)__va((unsigned long)pgd_val((pgd)) & PTE_PFN_MASK))
 #define pgd_page(pgd)		(pfn_to_page(pgd_val((pgd)) >> PAGE_SHIFT))
 #define pgd_present(pgd) (pgd_val(pgd) & _PAGE_PRESENT)
 static inline int pgd_large(pgd_t pgd) { return 0; }
@@ -216,7 +216,7 @@ static inline int pud_large(pud_t pte)
 }
 
 /* PMD  - Level 2 access */
-#define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val((pmd)) & PTE_MASK))
+#define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val((pmd)) & PTE_PFN_MASK))
 #define pmd_page(pmd)		(pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
 
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
index 05e678a..7b3835d 100644
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -124,7 +124,7 @@ static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 
 static inline unsigned long pte_mfn(pte_t pte)
 {
-	return (pte.pte & PTE_MASK) >> PAGE_SHIFT;
+	return (pte.pte & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
 static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)
