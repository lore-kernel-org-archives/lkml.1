Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbYCCNTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbYCCNTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYCCNS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:18:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42338 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYCCNSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:18:55 -0500
Date: Mon, 3 Mar 2008 14:18:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080303131833.GA29977@elte.hu>
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


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

it reverts two recently introduced commits that slipped through and 
caused boot regressions.

Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86: revert "x86: fix pmd_bad and pud_bad to support huge pages"

Rafael J. Wysocki (1):
      x86: revert "x86: CPA: avoid split of alias mappings"

 arch/x86/mm/pageattr.c       |   21 ++++++++++-----------
 include/asm-x86/pgtable_32.h |    4 +---
 include/asm-x86/pgtable_64.h |    6 ++----
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 7049294..14e48b5 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -26,7 +26,6 @@ struct cpa_data {
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
 	int		numpages;
-	int		processed;
 	int		flushtlb;
 	unsigned long	pfn;
 };
@@ -291,8 +290,8 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 */
 	nextpage_addr = (address + psize) & pmask;
 	numpages = (nextpage_addr - address) >> PAGE_SHIFT;
-	if (numpages < cpa->processed)
-		cpa->processed = numpages;
+	if (numpages < cpa->numpages)
+		cpa->numpages = numpages;
 
 	/*
 	 * We are safe now. Check whether the new pgprot is the same:
@@ -319,7 +318,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 */
 	addr = address + PAGE_SIZE;
 	pfn++;
-	for (i = 1; i < cpa->processed; i++, addr += PAGE_SIZE, pfn++) {
+	for (i = 1; i < cpa->numpages; i++, addr += PAGE_SIZE, pfn++) {
 		pgprot_t chk_prot = static_protections(new_prot, addr, pfn);
 
 		if (pgprot_val(chk_prot) != pgprot_val(new_prot))
@@ -343,7 +342,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * that we limited the number of possible pages already to
 	 * the number of pages in the large page.
 	 */
-	if (address == (nextpage_addr - psize) && cpa->processed == numpages) {
+	if (address == (nextpage_addr - psize) && cpa->numpages == numpages) {
 		/*
 		 * The address is aligned and the number of pages
 		 * covers the full page.
@@ -573,7 +572,7 @@ repeat:
 			set_pte_atomic(kpte, new_pte);
 			cpa->flushtlb = 1;
 		}
-		cpa->processed = 1;
+		cpa->numpages = 1;
 		return 0;
 	}
 
@@ -584,7 +583,7 @@ repeat:
 	do_split = try_preserve_large_page(kpte, address, cpa);
 	/*
 	 * When the range fits into the existing large page,
-	 * return. cp->processed and cpa->tlbflush have been updated in
+	 * return. cp->numpages and cpa->tlbflush have been updated in
 	 * try_large_page:
 	 */
 	if (do_split <= 0)
@@ -663,7 +662,7 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		 * Store the remaining nr of pages for the large page
 		 * preservation check.
 		 */
-		cpa->numpages = cpa->processed = numpages;
+		cpa->numpages = numpages;
 
 		ret = __change_page_attr(cpa, checkalias);
 		if (ret)
@@ -680,9 +679,9 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		 * CPA operation. Either a large page has been
 		 * preserved or a single page update happened.
 		 */
-		BUG_ON(cpa->processed > numpages);
-		numpages -= cpa->processed;
-		cpa->vaddr += cpa->processed * PAGE_SIZE;
+		BUG_ON(cpa->numpages > numpages);
+		numpages -= cpa->numpages;
+		cpa->vaddr += cpa->numpages * PAGE_SIZE;
 	}
 	return 0;
 }
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index b478efa..a842c72 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -91,9 +91,7 @@ extern unsigned long pg0[];
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define	pmd_bad(x)	((pmd_val(x) \
-			  & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)) \
-			 != _KERNPG_TABLE)
+#define	pmd_bad(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
 
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 0a92583..0a0b77b 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -153,14 +153,12 @@ static inline unsigned long pgd_bad(pgd_t pgd)
 
 static inline unsigned long pud_bad(pud_t pud)
 {
-	return pud_val(pud) &
-		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
+	return pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
 }
 
 static inline unsigned long pmd_bad(pmd_t pmd)
 {
-	return pmd_val(pmd) &
-		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
+	return pmd_val(pmd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
 }
 
 #define pte_none(x)	(!pte_val(x))
