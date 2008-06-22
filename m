Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbYFVTGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbYFVTGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbYFVTEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:04:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:43534 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbYFVTEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:04:48 -0400
Date: Sun, 22 Jun 2008 12:01:40 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@tv-sign.ru>,
       Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
Subject: [patch 2/5] Reinstate ZERO_PAGE optimization in get_user_pages()
	and fix XIP
Message-ID: <20080622190140.GD20141@suse.de>
References: <20080622185327.348377223@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="reinstate-zero_page-optimization-in-get_user_pages-and-fix-xip.patch"
In-Reply-To: <20080622190111.GA20141@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 89f5b7da2a6bad2e84670422ab8192382a5aeb9f upstream

KAMEZAWA Hiroyuki and Oleg Nesterov point out that since the commit
557ed1fa2620dc119adb86b34c614e152a629a80 ("remove ZERO_PAGE") removed
the ZERO_PAGE from the VM mappings, any users of get_user_pages() will
generally now populate the VM with real empty pages needlessly.

We used to get the ZERO_PAGE when we did the "handle_mm_fault()", but
since fault handling no longer uses ZERO_PAGE for new anonymous pages,
we now need to handle that special case in follow_page() instead.

In particular, the removal of ZERO_PAGE effectively removed the core
file writing optimization where we would skip writing pages that had not
been populated at all, and increased memory pressure a lot by allocating
all those useless newly zeroed pages.

This reinstates the optimization by making the unmapped PTE case the
same as for a non-existent page table, which already did this correctly.

While at it, this also fixes the XIP case for follow_page(), where the
caller could not differentiate between the case of a page that simply
could not be used (because it had no "struct page" associated with it)
and a page that just wasn't mapped.

We do that by simply returning an error pointer for pages that could not
be turned into a "struct page *".  The error is arbitrarily picked to be
EFAULT, since that was what get_user_pages() already used for the
equivalent IO-mapped page case.

[ Also removed an impossible test for pte_offset_map_lock() failing:
  that's not how that function works ]

Acked-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/vdso.c |    2 +-
 mm/memory.c                |   17 +++++++++++++----
 mm/migrate.c               |   10 ++++++++++
 3 files changed, 24 insertions(+), 5 deletions(-)

--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -141,7 +141,7 @@ static void dump_one_vdso_page(struct pa
 	printk("kpg: %p (c:%d,f:%08lx)", __va(page_to_pfn(pg) << PAGE_SHIFT),
 	       page_count(pg),
 	       pg->flags);
-	if (upg/* && pg != upg*/) {
+	if (upg && !IS_ERR(upg) /* && pg != upg*/) {
 		printk(" upg: %p (c:%d,f:%08lx)", __va(page_to_pfn(upg)
 						       << PAGE_SHIFT),
 		       page_count(upg),
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -943,17 +943,15 @@ struct page *follow_page(struct vm_area_
 	}
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (!ptep)
-		goto out;
 
 	pte = *ptep;
 	if (!pte_present(pte))
-		goto unlock;
+		goto no_page;
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
 		goto unlock;
 	page = vm_normal_page(vma, address, pte);
 	if (unlikely(!page))
-		goto unlock;
+		goto bad_page;
 
 	if (flags & FOLL_GET)
 		get_page(page);
@@ -968,6 +966,15 @@ unlock:
 out:
 	return page;
 
+bad_page:
+	pte_unmap_unlock(ptep, ptl);
+	return ERR_PTR(-EFAULT);
+
+no_page:
+	pte_unmap_unlock(ptep, ptl);
+	if (!pte_none(pte))
+		return page;
+	/* Fall through to ZERO_PAGE handling */
 no_page_table:
 	/*
 	 * When core dumping an enormous anonymous area that nobody
@@ -1104,6 +1111,8 @@ int get_user_pages(struct task_struct *t
 
 				cond_resched();
 			}
+			if (IS_ERR(page))
+				return i ? i : PTR_ERR(page);
 			if (pages) {
 				pages[i] = page;
 
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -858,6 +858,11 @@ static int do_move_pages(struct mm_struc
 			goto set_status;
 
 		page = follow_page(vma, pp->addr, FOLL_GET);
+
+		err = PTR_ERR(page);
+		if (IS_ERR(page))
+			goto set_status;
+
 		err = -ENOENT;
 		if (!page)
 			goto set_status;
@@ -921,6 +926,11 @@ static int do_pages_stat(struct mm_struc
 			goto set_status;
 
 		page = follow_page(vma, pm->addr, 0);
+
+		err = PTR_ERR(page);
+		if (IS_ERR(page))
+			goto set_status;
+
 		err = -ENOENT;
 		/* Use PageReserved to check for zero page */
 		if (!page || PageReserved(page))

-- 
