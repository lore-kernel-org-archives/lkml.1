Return-Path: <linux-kernel-owner+w=401wt.eu-S934107AbYAaQri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107AbYAaQri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbYAaQrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:47:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36101 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933744AbYAaQrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:47:12 -0500
Date: Thu, 31 Jan 2008 17:46:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080131164653.GA24494@elte.hu>
References: <20080130011550.GA31853@elte.hu> <20080131155739.GA19700@cs181133002.pp.htv.fi> <20080131160033.GA11501@elte.hu> <20080131161235.GB19700@cs181133002.pp.htv.fi> <20080131161523.GA12347@elte.hu> <20080131162423.GD19700@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131162423.GD19700@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@stusta.de> wrote:

> > > What about the breakages caused by commit 
> > > a5a19c63f4e55e32dc0bc3d936d7f94793d8b380 (this commit broke the 
> > > defconfig compilation on at least avr32, blackfin, sh, sparc and uml)?
> > 
> > the patch below fixes that.
> 
> Is it safe, or why did Jeremy state in the commit
> "I removed this include to avoid an include cycle"?

that is an x86.git complication alone, and only affects 32-bit PAE: it 
is solved by the uninlining patch (that i've queued up to before the 
asm-generic/tlb.h revert/fix).

	Ingo

------------->
Subject: x86: uninline __pte_free_tlb() and __pmd_free_tlb()
From: Ingo Molnar <mingo@elte.hu>

this also removes an include file dependency.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pgtable_32.c     |   19 +++++++++++++++++++
 include/asm-x86/pgalloc_32.h |   19 ++-----------------
 2 files changed, 21 insertions(+), 17 deletions(-)

Index: linux/arch/x86/mm/pgtable_32.c
===================================================================
--- linux.orig/arch/x86/mm/pgtable_32.c
+++ linux/arch/x86/mm/pgtable_32.c
@@ -376,3 +376,22 @@ void check_pgt_cache(void)
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
Index: linux/include/asm-x86/pgalloc_32.h
===================================================================
--- linux.orig/include/asm-x86/pgalloc_32.h
+++ linux/include/asm-x86/pgalloc_32.h
@@ -51,11 +51,7 @@ static inline void pte_free(struct page 
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
