Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYG3Ej7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYG3Ej7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYG3Ejt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:39:49 -0400
Received: from ozlabs.org ([203.10.76.45]:34539 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbYG3Ejs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:39:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: lguest <lguest@ozlabs.org>
Subject: [PATCH 2/2] lguest: use get_user_pages_fast() instead of get_user_pages()
Date: Wed, 30 Jul 2008 14:39:47 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
References: <200807301438.55941.rusty@rustcorp.com.au>
In-Reply-To: <200807301438.55941.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301439.47856.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a simple page table thrashing program I measure a slight
improvement.  The program creates five processes.  Each touches 1000
pages then schedules the next process.  We repeat this 1000 times.  As
lguest only caches 4 cr3 values, this rebuilds a lot of shadow page
tables requiring virt->phys mappings.

	Before: 5.93 seconds
	After: 5.40 seconds

(Counts of slow vs fastpath in this usage are 6092 and 2852462 respectively.)

And more importantly for lguest, the code is simpler.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/page_tables.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff -r cb465381f6d5 drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c	Wed Jul 30 10:18:44 2008 +1000
+++ b/drivers/lguest/page_tables.c	Wed Jul 30 12:11:42 2008 +1000
@@ -108,9 +108,8 @@ static unsigned long gpte_addr(pgd_t gpg
 }
 /*:*/
 
-/*M:014 get_pfn is slow; it takes the mmap sem and calls get_user_pages.  We
- * could probably try to grab batches of pages here as an optimization
- * (ie. pre-faulting). :*/
+/*M:014 get_pfn is slow: we could probably try to grab batches of pages here as
+ * an optimization (ie. pre-faulting). :*/
 
 /*H:350 This routine takes a page number given by the Guest and converts it to
  * an actual, physical page number.  It can fail for several reasons: the
@@ -123,19 +122,13 @@ static unsigned long get_pfn(unsigned lo
 static unsigned long get_pfn(unsigned long virtpfn, int write)
 {
 	struct page *page;
+
+	/* gup me one page at this address please! */
+	if (get_user_pages_fast(virtpfn << PAGE_SHIFT, 1, write, &page) == 1)
+		return page_to_pfn(page);
+
 	/* This value indicates failure. */
-	unsigned long ret = -1UL;
-
-	/* get_user_pages() is a complex interface: it gets the "struct
-	 * vm_area_struct" and "struct page" assocated with a range of pages.
-	 * It also needs the task's mmap_sem held, and is not very quick.
-	 * It returns the number of pages it got. */
-	down_read(&current->mm->mmap_sem);
-	if (get_user_pages(current, current->mm, virtpfn << PAGE_SHIFT,
-			   1, write, 1, &page, NULL) == 1)
-		ret = page_to_pfn(page);
-	up_read(&current->mm->mmap_sem);
-	return ret;
+	return -1UL;
 }
 
 /*H:340 Converting a Guest page table entry to a shadow (ie. real) page table
@@ -174,7 +167,7 @@ static pte_t gpte_to_spte(struct lg_cpu 
 /*H:460 And to complete the chain, release_pte() looks like this: */
 static void release_pte(pte_t pte)
 {
-	/* Remember that get_user_pages() took a reference to the page, in
+	/* Remember that get_user_pages_fast() took a reference to the page, in
 	 * get_pfn()?  We have to put it back now. */
 	if (pte_flags(pte) & _PAGE_PRESENT)
 		put_page(pfn_to_page(pte_pfn(pte)));
