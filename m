Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbXI1IGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbXI1IGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757120AbXI1IBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:01:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659AbXI1IBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:01:46 -0400
Message-Id: <20070928080042.146800000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/12] lockdep: page lock hooks
Content-Disposition: inline; filename=lockdep-page_lock-hooks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rework the now complete page lock API to provide acquisition and release hooks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/pagemap.h |   40 +++++++++++++++++++++++++++++++---------
 mm/filemap.c            |   13 +++++++------
 2 files changed, 38 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -153,23 +153,45 @@ static inline pgoff_t linear_page_index(
 	return pgoff >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 }
 
-extern void FASTCALL(__lock_page(struct page *page));
-extern void FASTCALL(__lock_page_nosync(struct page *page));
-extern void FASTCALL(unlock_page(struct page *page));
+extern void FASTCALL(__lock_page(struct page *page, unsigned long ip));
+extern void FASTCALL(__lock_page_nosync(struct page *page, unsigned long ip));
+extern void FASTCALL(unlock_page_nocheck(struct page *page));
+
+static inline void __lock_page_check(struct page *page, int try, unsigned long ip)
+{
+}
+
+static inline void __unlock_page_check(struct page *page, unsigned long ip)
+{
+}
 
 /*
  * lock_page may only be called if we have the page's inode pinned.
  */
+static inline int __trylock_page(struct page *page, int try)
+{
+	int ret = !TestSetPageLocked(page);
+	if (ret)
+		__lock_page_check(page, try, _RET_IP_);
+	return ret;
+}
+
+static inline int trylock_page(struct page *page)
+{
+	return __trylock_page(page, 1);
+}
+
 static inline void lock_page(struct page *page)
 {
 	might_sleep();
-	if (TestSetPageLocked(page))
-		__lock_page(page);
+	if (!__trylock_page(page, 0))
+		__lock_page(page, _RET_IP_);
 }
 
-static inline int trylock_page(struct page *page)
+static inline void unlock_page(struct page *page)
 {
-	return !TestSetPageLocked(page);
+	__unlock_page_check(page, _RET_IP_);
+	unlock_page_nocheck(page);
 }
 
 /*
@@ -179,8 +201,8 @@ static inline int trylock_page(struct pa
 static inline void lock_page_nosync(struct page *page)
 {
 	might_sleep();
-	if (TestSetPageLocked(page))
-		__lock_page_nosync(page);
+	if (!__trylock_page(page, 0))
+		__lock_page_nosync(page, _RET_IP_);
 }
 	
 /*
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -531,7 +531,7 @@ EXPORT_SYMBOL(wait_on_page_bit);
  * the clear_bit and the read of the waitqueue (to avoid SMP races with a
  * parallel wait_on_page_locked()).
  */
-void fastcall unlock_page(struct page *page)
+void fastcall unlock_page_nocheck(struct page *page)
 {
 	smp_mb__before_clear_bit();
 	if (!TestClearPageLocked(page))
@@ -539,7 +539,7 @@ void fastcall unlock_page(struct page *p
 	smp_mb__after_clear_bit(); 
 	wake_up_page(page, PG_locked);
 }
-EXPORT_SYMBOL(unlock_page);
+EXPORT_SYMBOL(unlock_page_nocheck);
 
 /**
  * end_page_writeback - end writeback against a page
@@ -565,12 +565,12 @@ EXPORT_SYMBOL(end_page_writeback);
  * chances are that on the second loop, the block layer's plug list is empty,
  * so sync_page() will then return in state TASK_UNINTERRUPTIBLE.
  */
-void fastcall __lock_page(struct page *page)
+void fastcall __lock_page(struct page *page, unsigned long ip)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
-
 	__wait_on_bit_lock(page_waitqueue(page), &wait, sync_page,
 							TASK_UNINTERRUPTIBLE);
+	__lock_page_check(page, 0, ip);
 }
 EXPORT_SYMBOL(__lock_page);
 
@@ -578,11 +578,12 @@ EXPORT_SYMBOL(__lock_page);
  * Variant of lock_page that does not require the caller to hold a reference
  * on the page's mapping.
  */
-void fastcall __lock_page_nosync(struct page *page)
+void fastcall __lock_page_nosync(struct page *page, unsigned long ip)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 	__wait_on_bit_lock(page_waitqueue(page), &wait, __sleep_on_page_lock,
 							TASK_UNINTERRUPTIBLE);
+	__lock_page_check(page, 0, ip);
 }
 
 /**
@@ -628,7 +629,7 @@ repeat:
 		page_cache_get(page);
 		if (!trylock_page(page)) {
 			read_unlock_irq(&mapping->tree_lock);
-			__lock_page(page);
+			__lock_page(page, _THIS_IP_);
 			read_lock_irq(&mapping->tree_lock);
 
 			/* Has the page been truncated while we slept? */

--

