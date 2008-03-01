Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYCAEJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYCAEJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 23:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbYCAEGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 23:06:54 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46591 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751781AbYCAEGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 23:06:24 -0500
Message-Id: <20080301040620.994846388@sgi.com>
References: <20080301040534.797979115@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Feb 2008 20:05:39 -0800
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@shadowen.org
Cc: linux-mm@kback.org
Subject: [rfc 05/10] Sparsemem: Vmemmap does not need section bits
Content-Disposition: inline; filename=sparsemem_vmemmap_does_not_need_section_flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparsemem vmemmap does not need any section bits. This patch has
the effect of reducing the number of bits used in page->flags
by at least 6.

Add an #error in sparse.c to avoid trouble if the page flags use
becomes so large that no node number fits in there anymore. We can then
no longer fallback from the use of the node to the use of the sectionID
for sparsemem vmemmap. The node width is always smaller than the width
of the section. So one would never want to fallback this way for
vmemmap.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |    8 ++++----
 mm/sparse.c        |    4 ++++
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-02-29 16:09:13.000000000 -0800
+++ linux-2.6/include/linux/mm.h	2008-02-29 16:11:28.000000000 -0800
@@ -390,11 +390,11 @@ static inline void set_compound_order(st
  * we have run out of space and have to fall back to an
  * alternate (slower) way of determining the node.
  *
- *        No sparsemem: |       NODE     | ZONE | ... | FLAGS |
- * with space for node: | SECTION | NODE | ZONE | ... | FLAGS |
- *   no space for node: | SECTION |     ZONE    | ... | FLAGS |
+ * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE | ... | FLAGS |
+ * classic sparse with space for node:| SECTION | NODE | ZONE | ... | FLAGS |
+ * classic sparse no space for node:  | SECTION |     ZONE    | ... | FLAGS |
  */
-#ifdef CONFIG_SPARSEMEM
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTIONS_WIDTH		SECTIONS_SHIFT
 #else
 #define SECTIONS_WIDTH		0
Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c	2008-02-29 16:11:32.000000000 -0800
+++ linux-2.6/mm/sparse.c	2008-02-29 16:12:28.000000000 -0800
@@ -27,6 +27,10 @@ struct mem_section mem_section[NR_SECTIO
 EXPORT_SYMBOL(mem_section);
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#error SPARSEMEM_VMEMMAP must have the node in page flags
+#endif
+
 /*
  * If we did not store the node number in the page then we have to
  * do a lookup in the section_to_node_table in order to find which

-- 
