Return-Path: <linux-kernel-owner+w=401wt.eu-S932488AbYEGHcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbYEGHcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761888AbYEGHcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:32:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59303 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761741AbYEGHcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:32:20 -0400
Date: Wed, 7 May 2008 16:36:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       tonyb@cybernetics.com, mika.penttila@kolumbus.fi
Subject: [PATCH] more ZERO_PAGE handling in follow_page()
Message-Id: <20080507163643.d4da0ed0.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrote the description of patch. (no changes in the logic.)

Thank you for all help.
-Kame
==
follow_page() is called from get_user_pages(), which returns specified user page.
follow_page() can return 1) a page or 2) NULL or 3)ZERO_PAGE.
If NULL, handle_mm_fault() is called.

Now, follow_page() to unused pte returns NULL if page table exists. As a result
get_user_pages() calls handle_mm_fault() and allocate new memory.
This behavior increases memory consumption at coredump, which does
read-once-but-never-written page fault.
By returning ZERO_PAGE() against READ/ANON request, we can avoid it.

(Because exec's arguments copy needs to call handle_mm_fault at WRITE/ANON
 request, we just handle READ/ANON case here.)

Change log:
  - Rewrote patch description and Added comments.
  - fixed to check pte_present()/pte_none() in proper way.


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Nick Piggin <npiggin@suse.de>

---
 mm/memory.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6.25/mm/memory.c
===================================================================
--- linux-2.6.25.orig/mm/memory.c
+++ linux-2.6.25/mm/memory.c
@@ -926,15 +926,15 @@ struct page *follow_page(struct vm_area_
 	page = NULL;
 	pgd = pgd_offset(mm, address);
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		goto no_page_table;
+		goto null_or_zeropage;
 
 	pud = pud_offset(pgd, address);
 	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
-		goto no_page_table;
+		goto null_or_zeropage;
 	
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		goto no_page_table;
+		goto null_or_zeropage;
 
 	if (pmd_huge(*pmd)) {
 		BUG_ON(flags & FOLL_GET);
@@ -947,8 +947,14 @@ struct page *follow_page(struct vm_area_
 		goto out;
 
 	pte = *ptep;
-	if (!pte_present(pte))
+	if (!pte_present(pte)) {
+		/* Read fault to empty pte can return ZERO_PAGE */
+		if (!(flags & FOLL_WRITE) && pte_none(pte)) {
+			pte_unmap_unlock(ptep, ptl);
+			goto null_or_zeropage;
+		}
 		goto unlock;
+	}
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
 		goto unlock;
 	page = vm_normal_page(vma, address, pte);
@@ -968,7 +974,7 @@ unlock:
 out:
 	return page;
 
-no_page_table:
+null_or_zeropage:
 	/*
 	 * When core dumping an enormous anonymous area that nobody
 	 * has touched so far, we don't want to allocate page tables.

