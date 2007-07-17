Return-Path: <linux-kernel-owner+w=401wt.eu-S934540AbXGQPkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934540AbXGQPkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933047AbXGQPkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:40:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbXGQPkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:40:31 -0400
Message-Id: <20070717173758.525668000@chello.nl>
References: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:36 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 08/12] lockdep: lock_page: recursion
Content-Disposition: inline; filename=lockdep-page-recursion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

avoid the need to annotate lock_page nestings (which are abundant)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/pagemap.h |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -357,13 +357,23 @@ extern void FASTCALL(unlock_page_nocheck
 
 extern struct lockdep_map page_lockdep_map;
 
+static inline void __lock_page_acquire(int try, unsigned long ip)
+{
+	lock_acquire(&page_lockdep_map, 0, try, 0, 2, ip);
+}
+
+static inline void __unlock_page_release(unsigned long ip)
+{
+	lock_release(&page_lockdep_map, 1, ip);
+}
+
 /*
  * lock_page may only be called if we have the page's inode pinned.
  */
 static inline void lock_page(struct page *page)
 {
 	might_sleep();
-	spin_acquire(&page_lockdep_map, 0, 0, _RET_IP_);
+	__lock_page_acquire(0, _RET_IP_);
 	if (TestSetPageLocked(page))
 		__lock_page(page);
 }
@@ -372,13 +382,13 @@ static inline int trylock_page(struct pa
 {
 	int ret = !TestSetPageLocked(page);
 	if (ret)
-		spin_acquire(&page_lockdep_map, 0, 1, _RET_IP_);
+		__lock_page_acquire(1, _RET_IP_);
 	return ret;
 }
 
 static inline void __unlock_page_check(struct page *page)
 {
-	spin_release(&page_lockdep_map, 1, _RET_IP_);
+	__unlock_page_release(_RET_IP_);
 }
 
 static inline void unlock_page(struct page *page)
@@ -394,7 +404,7 @@ static inline void unlock_page(struct pa
 static inline void lock_page_nosync(struct page *page)
 {
 	might_sleep();
-	spin_acquire(&page_lockdep_map, 0, 0, _RET_IP_);
+	__lock_page_acquire(0, _RET_IP_);
 	if (TestSetPageLocked(page))
 		__lock_page_nosync(page);
 }
@@ -414,10 +424,10 @@ extern void FASTCALL(wait_on_page_bit(st
  */
 static inline void wait_on_page_locked(struct page *page)
 {
-	spin_acquire(&page_lockdep_map, 0, 0, _RET_IP_);
+	__lock_page_acquire(0, _RET_IP_);
 	if (PageLocked(page))
 		wait_on_page_bit(page, PG_locked);
-	spin_release(&page_lockdep_map, 1, _RET_IP_);
+	__unlock_page_release(_RET_IP_);
 }
 
 /* 

--

