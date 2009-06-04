Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZFDV2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZFDV2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZFDV2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:28:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40832 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbZFDV2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:28:15 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200906041128.112757038@firstfloor.org>
In-Reply-To: <200906041128.112757038@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [2/15] HWPOISON: Export some rmap vma locking to outside world
Message-Id: <20090604212812.D86311D028F@basil.firstfloor.org>
Date: Thu,  4 Jun 2009 23:28:12 +0200 (CEST)
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
@@ -115,6 +115,12 @@ int try_to_munlock(struct page *);
 int page_wrprotect(struct page *page, int *odirect_sync, int count_offset);
 #endif
 
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
