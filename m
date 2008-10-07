Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbYJGAwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbYJGAwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbYJGAoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:60647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003AbYJGAoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:44:19 -0400
Date: Mon, 6 Oct 2008 17:38:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>,
       Jared Hulbert <jaredeh@gmail.com>, Carsten Otte <cotte@freenet.de>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 33/71] mm: dirty page tracking race fix
Message-ID: <20081007003850.GH3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-dirty-page-tracking-race-fix.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Nick Piggin <npiggin@suse.de>

commit 479db0bf408e65baa14d2a9821abfcbc0804b847 upstream

There is a race with dirty page accounting where a page may not properly
be accounted for.

clear_page_dirty_for_io() calls page_mkclean; then TestClearPageDirty.

page_mkclean walks the rmaps for that page, and for each one it cleans and
write protects the pte if it was dirty.  It uses page_check_address to
find the pte.  That function has a shortcut to avoid the ptl if the pte is
not present.  Unfortunately, the pte can be switched to not-present then
back to present by other code while holding the page table lock -- this
should not be a signal for page_mkclean to ignore that pte, because it may
be dirty.

For example, powerpc64's set_pte_at will clear a previously present pte
before setting it to the desired value.  There may also be other code in
core mm or in arch which do similar things.

The consequence of the bug is loss of data integrity due to msync, and
loss of dirty page accounting accuracy.  XIP's __xip_unmap could easily
also be unreliable (depending on the exact XIP locking scheme), which can
lead to data corruption.

Fix this by having an option to always take ptl to check the pte in
page_check_address.

It's possible to retain this optimization for page_referenced and
try_to_unmap.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jared Hulbert <jaredeh@gmail.com>
Cc: Carsten Otte <cotte@freenet.de>
Cc: Hugh Dickins <hugh@veritas.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/rmap.h |    2 +-
 mm/filemap_xip.c     |    2 +-
 mm/rmap.c            |   14 +++++++++-----
 3 files changed, 11 insertions(+), 7 deletions(-)

--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -94,7 +94,7 @@ int try_to_unmap(struct page *, int igno
  * Called from mm/filemap_xip.c to unmap empty zero page
  */
 pte_t *page_check_address(struct page *, struct mm_struct *,
-				unsigned long, spinlock_t **);
+				unsigned long, spinlock_t **, int);
 
 /*
  * Used by swapoff to help locate where page is expected in vma.
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -184,7 +184,7 @@ __xip_unmap (struct address_space * mapp
 		address = vma->vm_start +
 			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 		BUG_ON(address < vma->vm_start || address >= vma->vm_end);
-		pte = page_check_address(page, mm, address, &ptl);
+		pte = page_check_address(page, mm, address, &ptl, 1);
 		if (pte) {
 			/* Nuke the page table entry. */
 			flush_cache_page(vma, address, pte_pfn(*pte));
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -223,10 +223,14 @@ unsigned long page_address_in_vma(struct
 /*
  * Check that @page is mapped at @address into @mm.
  *
+ * If @sync is false, page_check_address may perform a racy check to avoid
+ * the page table lock when the pte is not present (helpful when reclaiming
+ * highly shared pages).
+ *
  * On success returns with pte mapped and locked.
  */
 pte_t *page_check_address(struct page *page, struct mm_struct *mm,
-			  unsigned long address, spinlock_t **ptlp)
+			  unsigned long address, spinlock_t **ptlp, int sync)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -248,7 +252,7 @@ pte_t *page_check_address(struct page *p
 
 	pte = pte_offset_map(pmd, address);
 	/* Make a quick check before getting the lock */
-	if (!pte_present(*pte)) {
+	if (!sync && !pte_present(*pte)) {
 		pte_unmap(pte);
 		return NULL;
 	}
@@ -280,7 +284,7 @@ static int page_referenced_one(struct pa
 	if (address == -EFAULT)
 		goto out;
 
-	pte = page_check_address(page, mm, address, &ptl);
+	pte = page_check_address(page, mm, address, &ptl, 0);
 	if (!pte)
 		goto out;
 
@@ -449,7 +453,7 @@ static int page_mkclean_one(struct page 
 	if (address == -EFAULT)
 		goto out;
 
-	pte = page_check_address(page, mm, address, &ptl);
+	pte = page_check_address(page, mm, address, &ptl, 1);
 	if (!pte)
 		goto out;
 
@@ -707,7 +711,7 @@ static int try_to_unmap_one(struct page 
 	if (address == -EFAULT)
 		goto out;
 
-	pte = page_check_address(page, mm, address, &ptl);
+	pte = page_check_address(page, mm, address, &ptl, 0);
 	if (!pte)
 		goto out;
 

-- 
