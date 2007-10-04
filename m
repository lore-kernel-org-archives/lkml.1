Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbXJDEB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbXJDEB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbXJDEAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:00:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53755 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753912AbXJDEAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:00:05 -0400
Message-Id: <20071004040002.622421554@sgi.com>
References: <20071004035935.042951211@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Oct 2007 20:59:39 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [04/18] Vcompound: Smart up virt_to_head_page()
Content-Disposition: inline; filename=vcompound_virt_to_head_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The determination of a page struct for an address in a compound page
will need some more smarts in order to deal with virtual addresses.

We need to use the evil constants VMALLOC_START and VMALLOC_END for this
and they are notoriously for referencing various arch header files or may
even be variables. Uninline the function to avoid trouble.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |    6 +-----
 mm/page_alloc.c    |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-10-03 19:21:50.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-10-03 19:23:08.000000000 -0700
@@ -315,11 +315,7 @@ static inline void get_page(struct page 
 	atomic_inc(&page->_count);
 }
 
-static inline struct page *virt_to_head_page(const void *x)
-{
-	struct page *page = virt_to_page(x);
-	return compound_head(page);
-}
+struct page *virt_to_head_page(const void *x);
 
 /*
  * Setup the page count before being freed into the page allocator for
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-10-03 19:21:50.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-10-03 19:23:08.000000000 -0700
@@ -150,6 +150,29 @@ int nr_node_ids __read_mostly = MAX_NUMN
 EXPORT_SYMBOL(nr_node_ids);
 #endif
 
+/*
+ * Determine the appropriate page struct given a virtual address
+ * (including vmalloced areas).
+ *
+ * Return the head page if this is a compound page.
+ *
+ * Cannot be inlined since VMALLOC_START and VMALLOC_END may contain
+ * complex calculations that depend on multiple arch includes or
+ * even variables.
+ */
+struct page *virt_to_head_page(const void *x)
+{
+	unsigned long addr = (unsigned long)x;
+	struct page *page;
+
+	if (unlikely(addr >= VMALLOC_START && addr < VMALLOC_END))
+		page = vmalloc_to_page((void *)addr);
+	else
+		page = virt_to_page(addr);
+
+	return compound_head(page);
+}
+
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {

-- 
