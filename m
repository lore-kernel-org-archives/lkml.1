Return-Path: <linux-kernel-owner+w=401wt.eu-S1763189AbZE0UNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763189AbZE0UNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbZE0UMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:12:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35905 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbZE0UMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:12:30 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200905271012.668777061@firstfloor.org>
In-Reply-To: <200905271012.668777061@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [3/16] HWPOISON: Export some rmap vma locking to outside world
Message-Id: <20090527201229.152961D028F@basil.firstfloor.org>
Date: Wed, 27 May 2009 22:12:28 +0200 (CEST)
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
--- linux.orig/include/linux/rmap.h	2009-05-27 21:13:54.000000000 +0200
+++ linux/include/linux/rmap.h	2009-05-27 21:19:19.000000000 +0200
@@ -118,6 +118,12 @@
 }
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
--- linux.orig/mm/rmap.c	2009-05-26 22:15:37.000000000 +0200
+++ linux/mm/rmap.c	2009-05-27 21:19:19.000000000 +0200
@@ -191,7 +191,7 @@
  * Getting a lock on a stable anon_vma from a page off the LRU is
  * tricky: page_lock_anon_vma rely on RCU to guard against the races.
  */
-static struct anon_vma *page_lock_anon_vma(struct page *page)
+struct anon_vma *page_lock_anon_vma(struct page *page)
 {
 	struct anon_vma *anon_vma;
 	unsigned long anon_mapping;
@@ -211,7 +211,7 @@
 	return NULL;
 }
 
-static void page_unlock_anon_vma(struct anon_vma *anon_vma)
+void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
 	spin_unlock(&anon_vma->lock);
 	rcu_read_unlock();
