Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbYL3K2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbYL3K2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 05:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYL3K2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 05:28:38 -0500
Received: from ns1.suse.de ([195.135.220.2]:43748 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbYL3K2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 05:28:37 -0500
Date: Tue, 30 Dec 2008 11:28:31 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, ijc@hellion.org.uk
Subject: Re: early fixmap causes kmap breakage
Message-ID: <20081230102831.GB3189@wotan.suse.de>
References: <20081218211543.GB10681@wotan.suse.de> <20081229151731.2a2c5a02.akpm@linux-foundation.org> <20081230040118.GA27679@wotan.suse.de> <20081230061344.GA28281@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230061344.GA28281@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 07:13:44AM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Mon, Dec 29, 2008 at 03:17:31PM -0800, Andrew Morton wrote:
> > > On Thu, 18 Dec 2008 22:15:43 +0100
> > > Nick Piggin <npiggin@suse.de> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > I've debugged a problem where i386+pae systems with more than a few CPUs
> > > > blow up at boot in the kmap_atomic code.
> > > 
> > > ping?
> > 
> > No further progress here, I'm waiting on input for how to fix this 
> > "nicely". Meantime, clearing the early fixmap pte I guess works, but you 
> > lose a page... is it possible to put it into .initdata or is there some 
> > issue with that? (I guess on a PAE kernel, 4K isn't a big deal).
> 
> yeah, 4K shouldnt be a big deal. Mind sending a patch for this?

How's this?
--

The early fixmap pmd entry inserted at the very top of the KVA is casing the
subsequent fixmap mapping code to not provide physically linear pte pages over
the kmap atomic portion of the fixmap (which relies on said property to calculate
pte address).

This has caused weird boot failures in kmap_atomic much later in the boot
process (initial userspace faults) on a 32-bit PAE system with a larger number
of CPUs (smaller CPU counts tend not to run over into the next page so don't
show up the problem).

Solve this by attempting to clear out the page table, and copy any of its
entries to the new one. Also, add a bug if a nonlinear condition is encounted
and can't be resolved, which might save some hours of debugging if this fragile
scheme ever breaks again...

Putting swapper_pg_fixmap into initdata is an exercise left for the reviewer...

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 arch/x86/mm/init_32.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -155,6 +155,7 @@ page_table_range_init(unsigned long star
 	unsigned long vaddr;
 	pgd_t *pgd;
 	pmd_t *pmd;
+	pte_t *lastpte = NULL;
 
 	vaddr = start;
 	pgd_idx = pgd_index(vaddr);
@@ -166,7 +167,30 @@ page_table_range_init(unsigned long star
 		pmd = pmd + pmd_index(vaddr);
 		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
 							pmd++, pmd_idx++) {
-			one_page_table_init(pmd);
+			pte_t *pte;
+
+			pte = one_page_table_init(pmd);
+			/*
+			 * Something (early fixmap) has already put a pte page
+			 * here, which causes the page table allocation to
+			 * become nonlinear. Attempt to fix it, and if it is
+			 * still nonlinear then we have to bug.
+			 */
+			if (lastpte && lastpte + PTRS_PER_PTE != pte) {
+				pte_t *newpte;
+				int i;
+
+				pmd_clear(pmd);
+				__flush_tlb_all();
+
+				newpte = one_page_table_init(pmd);
+				BUG_ON(lastpte + PTRS_PER_PTE != newpte);
+				for (i = 0; i < PTRS_PER_PTE; i++) {
+					set_pte(newpte + i, pte_val(*(pte + i)));
+				}
+				pte = lastpte;
+			}
+			lastpte = pte;
 
 			vaddr += PMD_SIZE;
 		}
