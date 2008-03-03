Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbYCCAUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbYCCAUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbYCCATD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:19:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41107 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761454AbYCCATA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:19:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] x86: Revert commit 8be8f54bae3453588011cad06363813a5293af53
Date: Mon, 3 Mar 2008 01:17:37 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803030117.38344.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Revert

commit 8be8f54bae3453588011cad06363813a5293af53
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Feb 23 20:43:21 2008 +0100

    x86: CPA: avoid split of alias mappings

because it clearly mishandles the case when __change_page_attr(), called
from __change_page_attr_set_clr(), changes cpa->processed to 1 and
cpa_process_alias(cpa) is executed right after that.

This crashes my x86-64 test box early in the boot process
(ref. http://bugzilla.kernel.org/show_bug.cgi?id=10140#c4).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/pageattr.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pageattr.c
+++ linux-2.6/arch/x86/mm/pageattr.c
@@ -26,7 +26,6 @@ struct cpa_data {
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
 	int		numpages;
-	int		processed;
 	int		flushtlb;
 	unsigned long	pfn;
 };
@@ -291,8 +290,8 @@ try_preserve_large_page(pte_t *kpte, uns
 	 */
 	nextpage_addr = (address + psize) & pmask;
 	numpages = (nextpage_addr - address) >> PAGE_SHIFT;
-	if (numpages < cpa->processed)
-		cpa->processed = numpages;
+	if (numpages < cpa->numpages)
+		cpa->numpages = numpages;
 
 	/*
 	 * We are safe now. Check whether the new pgprot is the same:
@@ -319,7 +318,7 @@ try_preserve_large_page(pte_t *kpte, uns
 	 */
 	addr = address + PAGE_SIZE;
 	pfn++;
-	for (i = 1; i < cpa->processed; i++, addr += PAGE_SIZE, pfn++) {
+	for (i = 1; i < cpa->numpages; i++, addr += PAGE_SIZE, pfn++) {
 		pgprot_t chk_prot = static_protections(new_prot, addr, pfn);
 
 		if (pgprot_val(chk_prot) != pgprot_val(new_prot))
@@ -343,7 +342,7 @@ try_preserve_large_page(pte_t *kpte, uns
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
@@ -663,7 +662,7 @@ static int __change_page_attr_set_clr(st
 		 * Store the remaining nr of pages for the large page
 		 * preservation check.
 		 */
-		cpa->numpages = cpa->processed = numpages;
+		cpa->numpages = numpages;
 
 		ret = __change_page_attr(cpa, checkalias);
 		if (ret)
@@ -680,9 +679,9 @@ static int __change_page_attr_set_clr(st
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
