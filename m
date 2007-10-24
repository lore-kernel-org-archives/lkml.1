Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbXJXJGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbXJXJGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbXJXJE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:04:57 -0400
Received: from ns.suse.de ([195.135.220.2]:47317 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbXJXJEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:04:54 -0400
Message-Id: <20071024081405.419672000@nick.local0.net>
References: <20071024081305.906617000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 24 Oct 2007 18:13:09 +1000
From: npiggin@nick.local0.net
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 4/5] mm: use lock bitops for page lock
Content-Disposition: inline; filename=page_lock-use-lock-bitops2.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert page lock to new locking bitops. Mark it likely to succeed.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 include/linux/pagemap.h |    2 +-
 mm/filemap.c            |   13 +++++--------
 mm/swapfile.c           |    2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -528,17 +528,14 @@ EXPORT_SYMBOL(wait_on_page_bit);
  * mechananism between PageLocked pages and PageWriteback pages is shared.
  * But that's OK - sleepers in wait_on_page_writeback() just go back to sleep.
  *
- * The first mb is necessary to safely close the critical section opened by the
- * TestSetPageLocked(), the second mb is necessary to enforce ordering between
- * the clear_bit and the read of the waitqueue (to avoid SMP races with a
- * parallel wait_on_page_locked()).
+ * The mb is necessary to enforce ordering between the clear_bit and the read
+ * of the waitqueue (to avoid SMP races with a parallel wait_on_page_locked()).
  */
 void fastcall unlock_page(struct page *page)
 {
-	smp_mb__before_clear_bit();
-	if (!test_and_clear_bit(PG_locked, &page->flags))
-		BUG();
-	smp_mb__after_clear_bit(); 
+	VM_BUG_ON(!PageLocked(page));
+	clear_bit_unlock(PG_locked, &page->flags);
+	smp_mb__after_clear_bit();
 	wake_up_page(page, PG_locked);
 }
 EXPORT_SYMBOL(unlock_page);
Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -172,7 +172,7 @@ static inline void clear_page_locked(str
 
 static inline int trylock_page(struct page *page)
 {
-	return !test_and_set_bit(PG_locked, &page->flags);
+	return (likely(!test_and_set_bit_lock(PG_locked, &page->flags)));
 }
 
 /*
Index: linux-2.6/mm/swapfile.c
===================================================================
--- linux-2.6.orig/mm/swapfile.c
+++ linux-2.6/mm/swapfile.c
@@ -401,7 +401,7 @@ void free_swap_and_cache(swp_entry_t ent
 	if (p) {
 		if (swap_entry_free(p, swp_offset(entry)) == 1) {
 			page = find_get_page(&swapper_space, entry.val);
-			if (page && unlikely(!trylock_page(page))) {
+			if (page && !trylock_page(page)) {
 				page_cache_release(page);
 				page = NULL;
 			}

-- 

