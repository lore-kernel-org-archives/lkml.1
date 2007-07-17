Return-Path: <linux-kernel-owner+w=401wt.eu-S934594AbXGQPlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbXGQPlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759244AbXGQPkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:40:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933748AbXGQPkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:40:35 -0400
Message-Id: <20070717173757.755618000@chello.nl>
References: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:33 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 05/12] lockdep: add initial lockdep support for lock_page
Content-Disposition: inline; filename=lockdep-page.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use a global lockdep_map instance for all pages.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h  |    7 +++++++
 include/linux/mm_types.h |    1 +
 include/linux/pagemap.h  |   11 ++++++++++-
 mm/filemap.c             |    7 +++++++
 4 files changed, 25 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -251,6 +251,13 @@ extern void lockdep_init_map(struct lock
 			     struct lock_class_key *key, int subclass);
 
 /*
+ * To initialize a lockdep_map statically use this macro.
+ * Note that _name must not be NULL.
+ */
+#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
+	{ .name = (_name), .key = (void *)(_key), }
+
+/*
  * Reinitialize a lock key - for cases where there is special locking or
  * special initialization of locks so that the validator gets the scope
  * of dependencies wrong: they are either too broad (they need a class-split)
Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h
+++ linux-2.6/include/linux/mm_types.h
@@ -5,6 +5,7 @@
 #include <linux/threads.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/lockdep.h>
 
 struct address_space;
 
Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -355,19 +355,25 @@ extern void FASTCALL(__lock_page(struct 
 extern void FASTCALL(__lock_page_nosync(struct page *page));
 extern void FASTCALL(unlock_page(struct page *page));
 
+extern struct lockdep_map page_lockdep_map;
+
 /*
  * lock_page may only be called if we have the page's inode pinned.
  */
 static inline void lock_page(struct page *page)
 {
 	might_sleep();
+	spin_acquire(&page_lockdep_map, 0, 0, _RET_IP_);
 	if (TestSetPageLocked(page))
 		__lock_page(page);
 }
 
 static inline int trylock_page(struct page *page)
 {
-	return !TestSetPageLocked(page);
+	int ret = !TestSetPageLocked(page);
+	if (ret)
+		spin_acquire(&page_lockdep_map, 0, 1, _RET_IP_);
+	return ret;
 }
 
 /*
@@ -377,6 +383,7 @@ static inline int trylock_page(struct pa
 static inline void lock_page_nosync(struct page *page)
 {
 	might_sleep();
+	spin_acquire(&page_lockdep_map, 0, 0, _RET_IP_);
 	if (TestSetPageLocked(page))
 		__lock_page_nosync(page);
 }
@@ -396,8 +403,10 @@ extern void FASTCALL(wait_on_page_bit(st
  */
 static inline void wait_on_page_locked(struct page *page)
 {
+	spin_acquire(&page_lockdep_map, 0, 0, _RET_IP_);
 	if (PageLocked(page))
 		wait_on_page_bit(page, PG_locked);
+	spin_release(&page_lockdep_map, 1, _RET_IP_);
 }
 
 /* 
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -524,8 +524,15 @@ EXPORT_SYMBOL(wait_on_page_bit);
  * the clear_bit and the read of the waitqueue (to avoid SMP races with a
  * parallel wait_on_page_locked()).
  */
+struct lock_class_key page_lock_key;
+struct lockdep_map page_lockdep_map =
+	STATIC_LOCKDEP_MAP_INIT("lock_page", &page_lock_key);
+
+EXPORT_SYMBOL(page_lockdep_map);
+
 void fastcall unlock_page(struct page *page)
 {
+	spin_release(&page_lockdep_map, 1, _RET_IP_);
 	smp_mb__before_clear_bit();
 	if (!TestClearPageLocked(page))
 		BUG();

--

