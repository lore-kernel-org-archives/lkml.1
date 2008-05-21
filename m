Return-Path: <linux-kernel-owner+w=401wt.eu-S935849AbYEUS0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935849AbYEUS0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932826AbYEUS0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:26:20 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44138 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936804AbYEUS0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:26:19 -0400
Date: Wed, 21 May 2008 21:26:19 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
cc: clameter@sgi.com, mpm@selenic.com, lethal@linux-sh.org,
       dhowells@redhat.com
Subject: [RFC/PATCH 3/3] SLOB: make ksize() more strict for page allocator
 pass-through
Message-ID: <Pine.LNX.4.64.0805212125570.22291@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch re-uses the PG_slab flag for marking SLOB bigblock pages so we can
check that the pointer passed ksize() was really allocated by SLOB.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slob.c |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index a3ad667..4dc077e 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -144,6 +144,24 @@ static inline void clear_slob_page(struct slob_page *sp)
 }
 
 /*
+ * slob_bigpage: True for slob bigblock pages
+ */
+static inline int slob_bigpage(struct page *page)
+{
+	return test_bit(PG_slab, &page->flags);
+}
+
+static inline void set_slob_bigpage(struct page *page)
+{
+	__set_bit(PG_slab, &page->flags);
+}
+
+static inline void clear_slob_bigpage(struct page *page)
+{
+	__clear_bit(PG_slab, &page->flags);
+}
+
+/*
  * slob_page_free: true for pages on free_slob_pages list.
  */
 static inline int slob_page_free(struct slob_page *sp)
@@ -481,6 +499,7 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 			struct page *page;
 			page = virt_to_page(ret);
 			page->private = size;
+			set_slob_bigpage(page);
 		}
 		return ret;
 	}
@@ -499,8 +518,12 @@ void kfree(const void *block)
 		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 		unsigned int *m = (unsigned int *)(block - align);
 		slob_free(m, *m + align);
-	} else
-		put_page(&sp->page);
+	} else {
+		struct page *page = &sp->page;
+
+		clear_slob_bigpage(page);
+		put_page(page);
+	}
 }
 EXPORT_SYMBOL(kfree);
 
@@ -508,6 +531,7 @@ EXPORT_SYMBOL(kfree);
 size_t ksize(const void *block)
 {
 	struct slob_page *sp;
+	struct page *page;
 
 	BUG_ON(!block);
 	if (unlikely(block == ZERO_SIZE_PTR))
@@ -516,8 +540,10 @@ size_t ksize(const void *block)
 	sp = (struct slob_page *)virt_to_page(block);
 	if (slob_page(sp))
 		return ((slob_t *)block - 1)->units + SLOB_UNIT;
-	else
-		return sp->page.private;
+
+	page = &sp->page;
+	BUG_ON(!slob_bigpage(page));
+	return page->private;
 }
 EXPORT_SYMBOL(ksize);
 
-- 
1.5.2.5

