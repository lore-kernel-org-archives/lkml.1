Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbYCDLF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbYCDLF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbYCDLFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:05:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54102 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYCDLFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:05:12 -0500
Date: Tue, 04 Mar 2008 20:04:05 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 03/21] use an array for the LRU pagevecs
Cc: kosaki.motohiro@jp.fujitsu.com, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
In-Reply-To: <20080301153941.528A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080229154056.GF28849@shadowen.org> <20080301153941.528A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080304200209.1EAB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik

this is fixed patch of Andy Whitcroft's point out.
(at least, I hope it)



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 include/linux/mmzone.h |    4 +---
 mm/swap.c              |   15 +++++++++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

Index: b/include/linux/mmzone.h
===================================================================
--- a/include/linux/mmzone.h	2008-03-04 19:07:11.000000000 +0900
+++ b/include/linux/mmzone.h	2008-03-04 19:09:06.000000000 +0900
@@ -116,9 +116,7 @@ enum lru_list {
 
 static inline int is_active_lru(enum lru_list l)
 {
-	if (l == LRU_ACTIVE)
-		return 1;
-	return 0;
+	return (l == LRU_ACTIVE);
 }
 
 enum lru_list page_lru(struct page *page);
Index: b/mm/swap.c
===================================================================
--- a/mm/swap.c	2008-03-04 19:07:11.000000000 +0900
+++ b/mm/swap.c	2008-03-04 20:01:48.000000000 +0900
@@ -96,8 +96,9 @@ void put_pages_list(struct list_head *pa
 }
 EXPORT_SYMBOL(put_pages_list);
 
-/*
+/**
  * Returns the LRU list a page should be on.
+ * @page: the page we're checking.
  */
 enum lru_list page_lru(struct page *page)
 {
@@ -222,11 +223,15 @@ void __lru_cache_add(struct page *page, 
 	put_cpu_var(lru_add_pvecs);
 }
 
+/**
+ * lru_cache_add_lru: add a page to the page lists
+ * @page: the page to be added to LRU.
+ * @lru:  the lru to which the page is added.
+ */
 void lru_cache_add_lru(struct page *page, enum lru_list lru)
 {
-	if (PageActive(page)) {
+	if (PageActive(page))
 		ClearPageActive(page);
-	}
 
 	VM_BUG_ON(PageLRU(page) || PageActive(page));
 	__lru_cache_add(page, lru);
@@ -397,9 +402,11 @@ void __pagevec_release_nonlru(struct pag
 	pagevec_reinit(pvec);
 }
 
-/*
+/**
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
+ * @pvec: the pagevec of pages to be added to LRU.
+ * @lru:  the lru to which pages are added.
  */
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
 {


