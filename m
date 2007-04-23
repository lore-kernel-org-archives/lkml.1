Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXDWVL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXDWVL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXDWVL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:11:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37127 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753170AbXDWVL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:11:58 -0400
Date: Mon, 23 Apr 2007 14:11:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: linux-kernel@vger.kernel.org, pj@sgi.com, akpm@linux-foundation.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Pagecache: find_or_create_page does not call a proper page allocator
 function
Message-ID: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The find_or_create function calls alloc_page with a local gfp mask instead
of using page_cache_alloc. This means that the page allocation will not
obey cpuset memory spreading and page allocation will not properly use the
gfp flags in the address space. Highmem is not set correctly.

It turns out that there is no function to allocate a page for the page cache
with a gfp mask. So we create one ORing the context gfp flags with the gfp flags
from the mapping.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/pagemap.h |   10 ++++++++--
 mm/filemap.c            |    3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc7/include/linux/pagemap.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/pagemap.h	2007-04-23 13:52:20.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/pagemap.h	2007-04-23 14:01:09.000000000 -0700
@@ -60,14 +60,20 @@ static inline struct page *__page_cache_
 }
 #endif
 
+static inline struct page *page_cache_alloc_mask(struct address_space *x,
+			gfp_t gfp)
+{
+	return __page_cache_alloc(mapping_gfp_mask(x) | gfp);
+}
+
 static inline struct page *page_cache_alloc(struct address_space *x)
 {
-	return __page_cache_alloc(mapping_gfp_mask(x));
+	return page_cache_alloc_mask(x, 0);
 }
 
 static inline struct page *page_cache_alloc_cold(struct address_space *x)
 {
-	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
+	return page_cache_alloc_mask(x, __GFP_COLD);
 }
 
 typedef int filler_t(void *, struct page *);
Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-23 13:50:24.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-23 13:52:14.000000000 -0700
@@ -670,7 +670,8 @@ repeat:
 	page = find_lock_page(mapping, index);
 	if (!page) {
 		if (!cached_page) {
-			cached_page = alloc_page(gfp_mask);
+			cached_page =
+				page_cache_alloc_mask(mapping, gfp_mask);
 			if (!cached_page)
 				return NULL;
 		}
