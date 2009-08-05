Return-Path: <linux-kernel-owner+w=401wt.eu-S934087AbZHEJj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087AbZHEJj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933963AbZHEJgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:36:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49059 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950AbZHEJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:36:29 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200908051136.682859934@firstfloor.org>
In-Reply-To: <200908051136.682859934@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com,
       hidehiro.kawai.ez@hitachi.com
Subject: [PATCH] [2/19] HWPOISON: Export some rmap vma locking to outside world
Message-Id: <20090805093629.BBAAEB15D8@basil.firstfloor.org>
Date: Wed,  5 Aug 2009 11:36:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Needed for later patch that walks rmap entries on its own.

This used to be very frowned upon, but memory-failure.c does
some rather specialized rmap walking and rmap has been stable
for quite some time, so I think it's ok now to export it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/rmap.h |    6 ++++++
 mm/rmap.c            |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

Index: linux/include/linux/rmap.h
===================================================================
--- linux.orig/include/linux/rmap.h
+++ linux/include/linux/rmap.h
@@ -112,6 +112,12 @@ int page_mkclean(struct page *);
  */
 int try_to_munlock(struct page *);
 
+/*
+ * Called by memory-failure.c to kill processes.
+ */
+struct anon_vma *page_lock_anon_vma(struct page *page);
+void page_unlock_anon_vma(struct anon_vma *anon_vma);
+
 #else	/* !CONFIG_MMU */
 
 #define anon_vma_init()		do {} while (0)
Index: linux/mm/rmap.c
===================================================================
--- linux.orig/mm/rmap.c
+++ linux/mm/rmap.c
@@ -191,7 +191,7 @@ void __init anon_vma_init(void)
  * Getting a lock on a stable anon_vma from a page off the LRU is
  * tricky: page_lock_anon_vma rely on RCU to guard against the races.
  */
-static struct anon_vma *page_lock_anon_vma(struct page *page)
+struct anon_vma *page_lock_anon_vma(struct page *page)
 {
 	struct anon_vma *anon_vma;
 	unsigned long anon_mapping;
@@ -211,7 +211,7 @@ out:
 	return NULL;
 }
 
-static void page_unlock_anon_vma(struct anon_vma *anon_vma)
+void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
 	spin_unlock(&anon_vma->lock);
 	rcu_read_unlock();
