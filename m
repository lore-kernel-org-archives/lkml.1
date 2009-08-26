Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZHZJyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZHZJyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbZHZJyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:54:25 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:29948 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536AbZHZJyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:54:24 -0400
X-Trace: 252804236/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.100.112/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.100.112
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAFAJ+ilEpPRWRw/2dsb2JhbACBU45BAcgnhBoF
X-IronPort-AV: E=Sophos;i="4.44,278,1249254000"; 
   d="scan'208";a="252804236"
Date: Wed, 26 Aug 2009 10:53:47 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH mmotm] mm: introduce page_lru_base_type fix
Message-ID: <Pine.LNX.4.64.0908261050080.18633@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My usual tmpfs swapping loads on recent mmotms have oddly
aroused the OOM killer after an hour or two.  Bisection led to
mm-return-boolean-from-page_is_file_cache.patch, but really it's
the prior mm-introduce-page_lru_base_type.patch that's at fault.

It converted page_lru() to use page_lru_base_type(), but forgot
to convert del_page_from_lru() - which then decremented the wrong
stats once page_is_file_cache() was changed to a boolean.

Fix that, move page_lru_base_type() before del_page_from_lru(),
and mark it "inline" like the other mm_inline.h functions.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 include/linux/mm_inline.h |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- mmotm/include/linux/mm_inline.h	2009-08-21 12:12:42.000000000 +0100
+++ linux/include/linux/mm_inline.h	2009-08-26 00:39:38.000000000 +0100
@@ -35,42 +35,42 @@ del_page_from_lru_list(struct zone *zone
 	mem_cgroup_del_lru_list(page, l);
 }
 
+/**
+ * page_lru_base_type - which LRU list type should a page be on?
+ * @page: the page to test
+ *
+ * Used for LRU list index arithmetic.
+ *
+ * Returns the base LRU type - file or anon - @page should be on.
+ */
+static inline enum lru_list page_lru_base_type(struct page *page)
+{
+	if (page_is_file_cache(page))
+		return LRU_INACTIVE_FILE;
+	return LRU_INACTIVE_ANON;
+}
+
 static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
-	enum lru_list l = LRU_BASE;
+	enum lru_list l;
 
 	list_del(&page->lru);
 	if (PageUnevictable(page)) {
 		__ClearPageUnevictable(page);
 		l = LRU_UNEVICTABLE;
 	} else {
+		l = page_lru_base_type(page);
 		if (PageActive(page)) {
 			__ClearPageActive(page);
 			l += LRU_ACTIVE;
 		}
-		l += page_is_file_cache(page);
 	}
 	__dec_zone_state(zone, NR_LRU_BASE + l);
 	mem_cgroup_del_lru_list(page, l);
 }
 
 /**
- * page_lru_base_type - which LRU list type should a page be on?
- * @page: the page to test
- *
- * Used for LRU list index arithmetic.
- *
- * Returns the base LRU type - file or anon - @page should be on.
- */
-static enum lru_list page_lru_base_type(struct page *page)
-{
-	if (page_is_file_cache(page))
-		return LRU_INACTIVE_FILE;
-	return LRU_INACTIVE_ANON;
-}
-
-/**
  * page_lru - which LRU list should a page be on?
  * @page: the page to test
  *
