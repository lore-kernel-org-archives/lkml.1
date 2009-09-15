Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbZIOUcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbZIOUcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZIOUcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:32:32 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:42396 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbZIOUcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:32:31 -0400
X-Trace: 259122849/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.84.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.84.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgFAJ6Wr0pPRVRK/2dsb2JhbACBU953giSBcwU
X-IronPort-AV: E=Sophos;i="4.44,391,1249254000"; 
   d="scan'208";a="259122849"
Date: Tue, 15 Sep 2009 21:31:49 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/4] mm: m(un)lock avoid ZERO_PAGE
In-Reply-To: <Pine.LNX.4.64.0909152127240.22199@sister.anvils>
Message-ID: <Pine.LNX.4.64.0909152130260.22199@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
 <Pine.LNX.4.64.0909152127240.22199@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still reluctant to clutter __get_user_pages() with another flag,
just to avoid touching ZERO_PAGE count in mlock(); though we can add
that later if it shows up as an issue in practice.

But when mlocking, we can test page->mapping slightly earlier, to avoid
the potentially bouncy rescheduling of lock_page on ZERO_PAGE - mlock
didn't lock_page in olden ZERO_PAGE days, so we might have regressed.

And when munlocking, it turns out that FOLL_DUMP coincidentally does
what's needed to avoid all updates to ZERO_PAGE, so use that here also.
Plus add comment suggested by KAMEZAWA Hiroyuki.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/mlock.c |   49 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 13 deletions(-)

--- mm0/mm/mlock.c	2009-09-14 16:34:37.000000000 +0100
+++ mm1/mm/mlock.c	2009-09-15 17:32:03.000000000 +0100
@@ -198,17 +198,26 @@ static long __mlock_vma_pages_range(stru
 		for (i = 0; i < ret; i++) {
 			struct page *page = pages[i];
 
-			lock_page(page);
-			/*
-			 * Because we lock page here and migration is blocked
-			 * by the elevated reference, we need only check for
-			 * file-cache page truncation.  This page->mapping
-			 * check also neatly skips over the ZERO_PAGE(),
-			 * though if that's common we'd prefer not to lock it.
-			 */
-			if (page->mapping)
-				mlock_vma_page(page);
-			unlock_page(page);
+			if (page->mapping) {
+				/*
+				 * That preliminary check is mainly to avoid
+				 * the pointless overhead of lock_page on the
+				 * ZERO_PAGE: which might bounce very badly if
+				 * there is contention.  However, we're still
+				 * dirtying its cacheline with get/put_page:
+				 * we'll add another __get_user_pages flag to
+				 * avoid it if that case turns out to matter.
+				 */
+				lock_page(page);
+				/*
+				 * Because we lock page here and migration is
+				 * blocked by the elevated reference, we need
+				 * only check for file-cache page truncation.
+				 */
+				if (page->mapping)
+					mlock_vma_page(page);
+				unlock_page(page);
+			}
 			put_page(page);	/* ref from get_user_pages() */
 		}
 
@@ -309,9 +318,23 @@ void munlock_vma_pages_range(struct vm_a
 	vma->vm_flags &= ~VM_LOCKED;
 
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		struct page *page = follow_page(vma, addr, FOLL_GET);
-		if (page) {
+		struct page *page;
+		/*
+		 * Although FOLL_DUMP is intended for get_dump_page(),
+		 * it just so happens that its special treatment of the
+		 * ZERO_PAGE (returning an error instead of doing get_page)
+		 * suits munlock very well (and if somehow an abnormal page
+		 * has sneaked into the range, we won't oops here: great).
+		 */
+		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
+		if (page && !IS_ERR(page)) {
 			lock_page(page);
+			/*
+			 * Like in __mlock_vma_pages_range(),
+			 * because we lock page here and migration is
+			 * blocked by the elevated reference, we need
+			 * only check for file-cache page truncation.
+			 */
 			if (page->mapping)
 				munlock_vma_page(page);
 			unlock_page(page);
