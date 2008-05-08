Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbYEHJvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbYEHJvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYEHJvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:51:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34606 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbYEHJvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:51:31 -0400
Date: Thu, 8 May 2008 18:56:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au, tonyb@cybernetics.com,
       mika.penttila@kolumbus.fi
Subject: [PATCH] more ZERO_PAGE handling in follow_page() v2
Message-Id: <20080508185626.e14603d2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080508094057.48df4ce0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080507163643.d4da0ed0.kamezawa.hiroyu@jp.fujitsu.com>
	<20080507142539.758d30f6.akpm@linux-foundation.org>
	<20080508094057.48df4ce0.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

updated against 2.6.26-rc1-git6.
Tested on a x86-64 server. No troubles in generated coredump file.
It seems to work well.

Thanks,
-Kame
==
follow_page() is called from get_user_pages(), which returns specified user page
in the kernel context. follow_page() can return 1) a page or 2) NULL or
3)ZERO_PAGE.

Now, follow_page() to unused pte returns NULL if page table exists. As a result
get_user_pages() calls handle_mm_fault() and allocate new memory.
This behavior increases memory consumption at coredump, which does
read-once-but-never-written page fault.
By returning ZERO_PAGE() against READ/ANON request, we can avoid it.

(Because exec's arguments copy needs to call handle_mm_fault at WRITE/ANON
 request, we just handle READ/ANON case here.)

Change log:
  - Rebased agasinst 2.6.26-rc1-git6
  - Rewrote patch description and Added comments.
  - fixed to check pte_present()/pte_none() in proper way.


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memory.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6.26-rc1/mm/memory.c
===================================================================
--- linux-2.6.26-rc1.orig/mm/memory.c
+++ linux-2.6.26-rc1/mm/memory.c
@@ -962,15 +962,15 @@ struct page *follow_page(struct vm_area_
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
 	if (pmd_none(*pmd))
-		goto no_page_table;
+		goto null_or_zeropage;
 
 	if (pmd_huge(*pmd)) {
 		BUG_ON(flags & FOLL_GET);
@@ -979,15 +979,21 @@ struct page *follow_page(struct vm_area_
 	}
 
 	if (unlikely(pmd_bad(*pmd)))
-		goto no_page_table;
+		goto null_or_zeropage;
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!ptep)
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
@@ -1007,7 +1013,7 @@ unlock:
 out:
 	return page;
 
-no_page_table:
+null_or_zeropage:
 	/*
 	 * When core dumping an enormous anonymous area that nobody
 	 * has touched so far, we don't want to allocate page tables.

