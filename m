Return-Path: <linux-kernel-owner+w=401wt.eu-S933494AbZKXQlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494AbZKXQlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933407AbZKXQlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:41:11 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:5334 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933403AbZKXQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:41:10 -0500
X-Trace: 296036742/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBAO6bC0tPRTgw/2dsb2JhbAAI1iOCNYIEBIFw
X-IronPort-AV: E=Sophos;i="4.47,280,1257120000"; 
   d="scan'208";a="296036742"
Date: Tue, 24 Nov 2009 16:40:55 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/9] ksm: fix mlockfreed to munlocked
In-Reply-To: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
Message-ID: <Pine.LNX.4.64.0911241638130.25288@sister.anvils>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When KSM merges an mlocked page, it has been forgetting to munlock it:
that's been left to free_page_mlock(), which reports it in /proc/vmstat
as unevictable_pgs_mlockfreed instead of unevictable_pgs_munlocked (and
whinges "Page flag mlocked set for process" in mmotm, whereas mainline
is silently forgiving).  Call munlock_vma_page() to fix that.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
Is this a fix that I ought to backport to 2.6.32?  It does rely on part of
an earlier patch (moved unlock_page down), so does not apply cleanly as is.

 mm/internal.h |    3 ++-
 mm/ksm.c      |    4 ++++
 mm/mlock.c    |    4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

--- ksm0/mm/internal.h	2009-11-14 10:17:02.000000000 +0000
+++ ksm1/mm/internal.h	2009-11-22 20:39:56.000000000 +0000
@@ -105,9 +105,10 @@ static inline int is_mlocked_vma(struct
 }
 
 /*
- * must be called with vma's mmap_sem held for read, and page locked.
+ * must be called with vma's mmap_sem held for read or write, and page locked.
  */
 extern void mlock_vma_page(struct page *page);
+extern void munlock_vma_page(struct page *page);
 
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
--- ksm0/mm/ksm.c	2009-11-14 10:17:02.000000000 +0000
+++ ksm1/mm/ksm.c	2009-11-22 20:39:56.000000000 +0000
@@ -34,6 +34,7 @@
 #include <linux/ksm.h>
 
 #include <asm/tlbflush.h>
+#include "internal.h"
 
 /*
  * A few notes about the KSM scanning process,
@@ -762,6 +763,9 @@ static int try_to_merge_one_page(struct
 	    pages_identical(page, kpage))
 		err = replace_page(vma, page, kpage, orig_pte);
 
+	if ((vma->vm_flags & VM_LOCKED) && !err)
+		munlock_vma_page(page);
+
 	unlock_page(page);
 out:
 	return err;
--- ksm0/mm/mlock.c	2009-11-14 10:17:02.000000000 +0000
+++ ksm1/mm/mlock.c	2009-11-22 20:39:56.000000000 +0000
@@ -99,14 +99,14 @@ void mlock_vma_page(struct page *page)
  * not get another chance to clear PageMlocked.  If we successfully
  * isolate the page and try_to_munlock() detects other VM_LOCKED vmas
  * mapping the page, it will restore the PageMlocked state, unless the page
- * is mapped in a non-linear vma.  So, we go ahead and SetPageMlocked(),
+ * is mapped in a non-linear vma.  So, we go ahead and ClearPageMlocked(),
  * perhaps redundantly.
  * If we lose the isolation race, and the page is mapped by other VM_LOCKED
  * vmas, we'll detect this in vmscan--via try_to_munlock() or try_to_unmap()
  * either of which will restore the PageMlocked state by calling
  * mlock_vma_page() above, if it can grab the vma's mmap sem.
  */
-static void munlock_vma_page(struct page *page)
+void munlock_vma_page(struct page *page)
 {
 	BUG_ON(!PageLocked(page));
 
