Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbYKFHh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbYKFHh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYKFHhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:37:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58952 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYKFHhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:37:15 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH] mm: get rid of pagevec_release_nonlru()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081106162839.0D3A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  6 Nov 2008 16:37:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

speculative page references patch (commit: e286781d5f2e9c846e012a39653a166e9d31777d)
removed last pagevec_release_nonlru() caller.

So, its function can be removed now.

this patch doesn't have any functional change.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Nick Piggin <npiggin@suse.de>

---
 include/linux/pagevec.h |    7 -------
 mm/swap.c               |   22 ----------------------
 2 files changed, 29 deletions(-)

Index: b/include/linux/pagevec.h
===================================================================
--- a/include/linux/pagevec.h
+++ b/include/linux/pagevec.h
@@ -21,7 +21,6 @@ struct pagevec {
 };
 
 void __pagevec_release(struct pagevec *pvec);
-void __pagevec_release_nonlru(struct pagevec *pvec);
 void __pagevec_free(struct pagevec *pvec);
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 void pagevec_strip(struct pagevec *pvec);
@@ -69,12 +68,6 @@ static inline void pagevec_release(struc
 		__pagevec_release(pvec);
 }
 
-static inline void pagevec_release_nonlru(struct pagevec *pvec)
-{
-	if (pagevec_count(pvec))
-		__pagevec_release_nonlru(pvec);
-}
-
 static inline void pagevec_free(struct pagevec *pvec)
 {
 	if (pagevec_count(pvec))
Index: b/mm/swap.c
===================================================================
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -411,28 +411,6 @@ void __pagevec_release(struct pagevec *p
 EXPORT_SYMBOL(__pagevec_release);
 
 /*
- * pagevec_release() for pages which are known to not be on the LRU
- *
- * This function reinitialises the caller's pagevec.
- */
-void __pagevec_release_nonlru(struct pagevec *pvec)
-{
-	int i;
-	struct pagevec pages_to_free;
-
-	pagevec_init(&pages_to_free, pvec->cold);
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
-
-		VM_BUG_ON(PageLRU(page));
-		if (put_page_testzero(page))
-			pagevec_add(&pages_to_free, page);
-	}
-	pagevec_free(&pages_to_free);
-	pagevec_reinit(pvec);
-}
-
-/*
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */


