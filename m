Return-Path: <linux-kernel-owner+w=401wt.eu-S933680AbYAaRAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbYAaRAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758731AbYAaRAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:00:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453AbYAaRAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:00:18 -0500
Date: Thu, 31 Jan 2008 18:00:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86.git related fixes
Message-ID: <20080131170005.GA28219@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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

please pull:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

most importantly this fixes/reverts the include/asm-generic/tlb.h change 
from yesterday that broke the avr32, blackfin, sh and sparc build.

there are also x86 fixes: 3 CPA related fixes and 3 sparse warning 
fixes. Thanks!

Thanks!

	Ingo

------------------>
Harvey Harrison (3):
      x86: fix sparse warnings in intel_cacheinfo.c
      x86: fix sparse warning in kernel/scx200_32.c
      x86: fix small sparse warning

Huang, Ying (3):
      x86: change_page_attr_clear fix
      x86: c_p_a clflush_cache_range fix
      x86: early_ioremap_reset fix 2

Ingo Molnar (2):
      x86: uninline __pte_free_tlb() and __pmd_free_tlb()
      asm-generic/tlb.h: build fix

 arch/x86/kernel/cpu/common.c          |    5 ++++-
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 +++---
 arch/x86/kernel/ds.c                  |    2 +-
 arch/x86/kernel/scx200_32.c           |    2 +-
 arch/x86/mm/ioremap.c                 |    2 +-
 arch/x86/mm/pageattr.c                |    3 +--
 arch/x86/mm/pgtable_32.c              |   23 +++++++++++++++++++++++
 include/asm-generic/tlb.h             |    1 +
 include/asm-x86/pgalloc_32.h          |   19 ++-----------------
 9 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index db28aa9..d608c9e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -274,8 +274,10 @@ void __init cpu_detect(struct cpuinfo_x86 *c)
 		if (c->x86 >= 0x6)
 			c->x86_model += ((tfms >> 16) & 0xF) << 4;
 		c->x86_mask = tfms & 15;
-		if (cap0 & (1<<19))
+		if (cap0 & (1<<19)) {
 			c->x86_cache_alignment = ((misc >> 8) & 0xff) * 8;
+			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
+		}
 	}
 }
 static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
@@ -317,6 +319,7 @@ static void __init early_cpu_detect(void)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
 	c->x86_cache_alignment = 32;
+	c->x86_clflush_size = 32;
 
 	if (!have_cpuid_p())
 		return;
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 8b4507b..1b88986 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -352,8 +352,8 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	 */
 	if ((num_cache_leaves == 0 || c->x86 == 15) && c->cpuid_level > 1) {
 		/* supports eax=2  call */
-		int i, j, n;
-		int regs[4];
+		int j, n;
+		unsigned int regs[4];
 		unsigned char *dp = (unsigned char *)regs;
 		int only_trace = 0;
 
@@ -368,7 +368,7 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 			/* If bit 31 is set, this is an unknown format */
 			for ( j = 0 ; j < 3 ; j++ ) {
-				if ( regs[j] < 0 ) regs[j] = 0;
+				if (regs[j] & (1 << 31)) regs[j] = 0;
 			}
 
 			/* Byte 0 is level count, not a descriptor */
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 1c5ca4d..dcd918c 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -223,7 +223,7 @@ int ds_free(void **dsp)
 	if (*dsp)
 		kfree((void *)get_bts_buffer_base(*dsp));
 	kfree(*dsp);
-	*dsp = 0;
+	*dsp = NULL;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/scx200_32.c b/arch/x86/kernel/scx200_32.c
index 87bc159..7e004ac 100644
--- a/arch/x86/kernel/scx200_32.c
+++ b/arch/x86/kernel/scx200_32.c
@@ -65,7 +65,7 @@ static int __devinit scx200_probe(struct pci_dev *pdev, const struct pci_device_
 		base = pci_resource_start(pdev, 0);
 		printk(KERN_INFO NAME ": GPIO base 0x%x\n", base);
 
-		if (request_region(base, SCx200_GPIO_SIZE, "NatSemi SCx200 GPIO") == 0) {
+		if (!request_region(base, SCx200_GPIO_SIZE, "NatSemi SCx200 GPIO")) {
 			printk(KERN_ERR NAME ": can't allocate I/O for GPIOs\n");
 			return -EBUSY;
 		}
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ed79572..a177d76 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -340,7 +340,7 @@ void __init early_ioremap_reset(void)
 	for (idx = FIX_BTMAP_BEGIN; idx >= FIX_BTMAP_END; idx--) {
 		addr = fix_to_virt(idx);
 		pte = early_ioremap_pte(addr);
-		if (!*pte & _PAGE_PRESENT) {
+		if (*pte & _PAGE_PRESENT) {
 			phys = *pte & PAGE_MASK;
 			set_fixmap(idx, phys);
 		}
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1cc6607..e297bd6 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -399,8 +399,7 @@ static inline int change_page_attr_set(unsigned long addr, int numpages,
 static inline int change_page_attr_clear(unsigned long addr, int numpages,
 					 pgprot_t mask)
 {
-	return __change_page_attr_set_clr(addr, numpages, __pgprot(0), mask);
-
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask);
 }
 
 int set_memory_uc(unsigned long addr, int numpages)
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 2ae5999..cb3aa47 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -376,3 +376,26 @@ void check_pgt_cache(void)
 {
 	quicklist_trim(0, pgd_dtor, 25, 16);
 }
+
+void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
+{
+	paravirt_release_pt(page_to_pfn(pte));
+	tlb_remove_page(tlb, pte);
+}
+
+#ifdef CONFIG_X86_PAE
+
+void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
+{
+	/* This is called just after the pmd has been detached from
+	   the pgd, which requires a full tlb flush to be recognized
+	   by the CPU.  Rather than incurring multiple tlb flushes
+	   while the address space is being pulled down, make the tlb
+	   gathering machinery do a full flush when we're done. */
+	tlb->fullmm = 1;
+
+	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
+	tlb_remove_page(tlb, virt_to_page(pmd));
+}
+
+#endif
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 6ce9f3a..75f2bfa 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -15,6 +15,7 @@
 
 #include <linux/swap.h>
 #include <linux/quicklist.h>
+#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
 /*
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
index 10c2b45..ce6be08 100644
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -51,11 +51,7 @@ static inline void pte_free(struct page *pte)
 }
 
 
-static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
-{
-	paravirt_release_pt(page_to_pfn(pte));
-	tlb_remove_page(tlb, pte);
-}
+extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
 
 #ifdef CONFIG_X86_PAE
 /*
@@ -72,18 +68,7 @@ static inline void pmd_free(pmd_t *pmd)
 	free_page((unsigned long)pmd);
 }
 
-static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
-{
-	/* This is called just after the pmd has been detached from
-	   the pgd, which requires a full tlb flush to be recognized
-	   by the CPU.  Rather than incurring multiple tlb flushes
-	   while the address space is being pulled down, make the tlb
-	   gathering machinery do a full flush when we're done. */
-	tlb->fullmm = 1;
-
-	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-	tlb_remove_page(tlb, virt_to_page(pmd));
-}
+extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 {
