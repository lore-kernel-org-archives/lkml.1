Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907Ab0AEK04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0AEK04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 05:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612Ab0AEK0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 05:26:55 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:20299 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab0AEK0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 05:26:54 -0500
X-Trace: 321077175/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4BAEejQktPRRyw/2dsb2JhbAAI0x+CLoICBA
X-IronPort-AV: E=Sophos;i="4.47,504,1257120000"; 
   d="scan'208";a="321077175"
Date: Tue, 5 Jan 2010 10:26:44 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [00/97] 2.6.32.3 stable review
In-Reply-To: <20100105003133.GA7199@kroah.com>
Message-ID: <alpine.LSU.2.00.1001051021070.24967@sister.anvils>
References: <20100105003133.GA7199@kroah.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.32.3 release.
> There are 97 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.

I had hoped that the patch below would make it into 2.6.32.3:
but so long as it's not lost, I think it can wait until 2.6.32.4.

Thanks,
Hugh

>From hugh.dickins@tiscali.co.uk Wed Dec 30 23:00:31 2009
Date: Wed, 30 Dec 2009 23:00:30 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: stable@kernel.org
Cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, Chris Wright <chrisw@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2.6.32-stable] ksm: fix mlockfreed to munlocked

2.6.33-rc1 commit 73848b4684e84a84cfd1555af78d41158f31e16b, adjusted
to include 31e855ea7173bdb0520f9684580423a9560f66e0's movement of
the unlock_page(oldpage), but omit other intervening cleanups.

When KSM merges an mlocked page, it has been forgetting to munlock it:
that's been left to free_page_mlock(), which reports it in /proc/vmstat
as unevictable_pgs_mlockfreed instead of unevictable_pgs_munlocked,
which indicates that such pages _might_ be left unevictable for long
after they should be evictable.  Call munlock_vma_page() to fix that.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/internal.h |    3 ++-
 mm/ksm.c      |   14 +++++++-------
 mm/mlock.c    |    4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

--- 2.6.32.2/mm/internal.h	2009-12-03 03:51:21.000000000 +0000
+++ stable/mm/internal.h	2009-12-30 20:38:17.000000000 +0000
@@ -107,9 +107,10 @@ static inline int is_mlocked_vma(struct
 }
 
 /*
- * must be called with vma's mmap_sem held for read, and page locked.
+ * must be called with vma's mmap_sem held for read or write, and page locked.
  */
 extern void mlock_vma_page(struct page *page);
+extern void munlock_vma_page(struct page *page);
 
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
--- 2.6.32.2/mm/ksm.c	2009-12-03 03:51:21.000000000 +0000
+++ stable/mm/ksm.c	2009-12-30 20:38:17.000000000 +0000
@@ -34,6 +34,7 @@
 #include <linux/ksm.h>
 
 #include <asm/tlbflush.h>
+#include "internal.h"
 
 /*
  * A few notes about the KSM scanning process,
@@ -767,15 +768,14 @@ static int try_to_merge_one_page(struct
 	 * ptes are necessarily already write-protected.  But in either
 	 * case, we need to lock and check page_count is not raised.
 	 */
-	if (write_protect_page(vma, oldpage, &orig_pte)) {
-		unlock_page(oldpage);
-		goto out_putpage;
-	}
-	unlock_page(oldpage);
-
-	if (pages_identical(oldpage, newpage))
+	if (write_protect_page(vma, oldpage, &orig_pte) == 0 &&
+	    pages_identical(oldpage, newpage))
 		err = replace_page(vma, oldpage, newpage, orig_pte);
 
+	if ((vma->vm_flags & VM_LOCKED) && !err)
+		munlock_vma_page(oldpage);
+
+	unlock_page(oldpage);
 out_putpage:
 	put_page(oldpage);
 	put_page(newpage);
--- 2.6.32.2/mm/mlock.c	2009-12-03 03:51:21.000000000 +0000
+++ stable/mm/mlock.c	2009-12-30 20:38:17.000000000 +0000
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
 
