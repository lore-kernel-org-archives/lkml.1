Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZIGKdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZIGKdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZIGKdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:33:46 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:41148 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZIGKdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:33:45 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 06:33:45 EDT
Date: Mon, 7 Sep 2009 12:26:13 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Machine check exception in kmap_coherent()
Message-ID: <20090907102613.GA25295@linux-mips.org>
References: <197625223d8cb6ec3fc3e7da4501dd65@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <197625223d8cb6ec3fc3e7da4501dd65@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 05, 2009 at 02:38:41PM -0700, Kevin Cernekee wrote:

> On an SMP MIPS32 2.6.30 system with cache aliases, I am seeing the
> following sequence of events:
> 
> 1) copy_user_highpage() runs on CPU0, invoking kmap_coherent() to create
> a temporary mapping in the fixmap region
> 
> 2) copy_page() starts on CPU0
> 
> 3) CPU1 sends CPU0 an IPI asking CPU0 to run
> local_r4k_flush_cache_page()
> 
> 4) CPU0 takes the interrupt, interrupting copy_page()
> 
> 5) local_r4k_flush_cache_page() on CPU0 calls kmap_coherent() again
> 
> 6) The second invocation of kmap_coherent() on CPU0 tries to use the
> same fixmap virtual address that was being used by copy_user_highpage()
> 
> 7) CPU0 throws a machine check exception for the TLB address conflict

Nice analysis!

> Here is my proposed fix:
> 
> a) kmap_coherent() will maintain a flag for each CPU indicating whether
> there is an active mapping (kmap_coherent_inuse)
> 
> b) kmap_coherent() will return a NULL address in the unlikely case that
> it was called while another mapping was already outstanding
> 
> c) local_r4k_flush_cache_page() will check for a NULL return value from
> kmap_coherent(), and compensate by using indexed cacheops instead of hit
> cacheops

Too complicated.  The fault is happening because the non-SMTC code is trying
to be terribly clever and pre-loading the TLB with a new wired entry.  On
SMTC where multiple processors are sharing a single TLB are more careful
approach is needed so the code does a TLB probe and carefully and re-uses
an existing entry, if any.  Which happens to be just what we need.

So how about below - only compile tested - patch?

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/mm/init.c |   35 +----------------------------------
 1 files changed, 1 insertions(+), 34 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 0e82050..ab11582 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -105,8 +105,8 @@ unsigned long setup_zero_pages(void)
 	return 1UL << order;
 }
 
-#ifdef CONFIG_MIPS_MT_SMTC
 static pte_t *kmap_coherent_pte;
+
 static void __init kmap_coherent_init(void)
 {
 	unsigned long vaddr;
@@ -115,9 +115,6 @@ static void __init kmap_coherent_init(void)
 	vaddr = __fix_to_virt(FIX_CMAP_BEGIN);
 	kmap_coherent_pte = kmap_get_fixmap_pte(vaddr);
 }
-#else
-static inline void kmap_coherent_init(void) {}
-#endif
 
 void *kmap_coherent(struct page *page, unsigned long addr)
 {
@@ -131,9 +128,7 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 
 	inc_preempt_count();
 	idx = (addr >> PAGE_SHIFT) & (FIX_N_COLOURS - 1);
-#ifdef CONFIG_MIPS_MT_SMTC
 	idx += FIX_N_COLOURS * smp_processor_id();
-#endif
 	vaddr = __fix_to_virt(FIX_CMAP_END - idx);
 	pte = mk_pte(page, PAGE_KERNEL);
 #if defined(CONFIG_64BIT_PHYS_ADDR) && defined(CONFIG_CPU_MIPS32)
@@ -147,7 +142,6 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 	write_c0_entryhi(vaddr & (PAGE_MASK << 1));
 	write_c0_entrylo0(entrylo);
 	write_c0_entrylo1(entrylo);
-#ifdef CONFIG_MIPS_MT_SMTC
 	set_pte(kmap_coherent_pte - (FIX_CMAP_END - idx), pte);
 	/* preload TLB instead of local_flush_tlb_one() */
 	mtc0_tlbw_hazard();
@@ -159,13 +153,6 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 		tlb_write_random();
 	else
 		tlb_write_indexed();
-#else
-	tlbidx = read_c0_wired();
-	write_c0_wired(tlbidx + 1);
-	write_c0_index(tlbidx);
-	mtc0_tlbw_hazard();
-	tlb_write_indexed();
-#endif
 	tlbw_use_hazard();
 	write_c0_entryhi(old_ctx);
 	EXIT_CRITICAL(flags);
@@ -177,24 +164,6 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 
 void kunmap_coherent(void)
 {
-#ifndef CONFIG_MIPS_MT_SMTC
-	unsigned int wired;
-	unsigned long flags, old_ctx;
-
-	ENTER_CRITICAL(flags);
-	old_ctx = read_c0_entryhi();
-	wired = read_c0_wired() - 1;
-	write_c0_wired(wired);
-	write_c0_index(wired);
-	write_c0_entryhi(UNIQUE_ENTRYHI(wired));
-	write_c0_entrylo0(0);
-	write_c0_entrylo1(0);
-	mtc0_tlbw_hazard();
-	tlb_write_indexed();
-	tlbw_use_hazard();
-	write_c0_entryhi(old_ctx);
-	EXIT_CRITICAL(flags);
-#endif
 	dec_preempt_count();
 	preempt_check_resched();
 }
@@ -260,7 +229,6 @@ void copy_from_user_page(struct vm_area_struct *vma,
 void __init fixrange_init(unsigned long start, unsigned long end,
 	pgd_t *pgd_base)
 {
-#if defined(CONFIG_HIGHMEM) || defined(CONFIG_MIPS_MT_SMTC)
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
@@ -290,7 +258,6 @@ void __init fixrange_init(unsigned long start, unsigned long end,
 		}
 		j = 0;
 	}
-#endif
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
