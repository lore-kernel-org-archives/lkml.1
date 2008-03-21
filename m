Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYCUGT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYCUGT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYCUGSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:18:55 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48951 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753404AbYCUGSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:18:53 -0400
Message-Id: <20080321061724.515504935@sgi.com>
References: <20080321061703.921169367@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Mar 2008 23:17:05 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [02/14] vcompound: pageflags: Add PageVcompound()
Content-Disposition: inline; filename=0004-vcompound-Pageflags-Add-PageVcompound.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a another page flag that can be used to figure out if a compound
page is virtually mapped. The mark is necessary since we have to know
when freeing pages if we have to destroy a virtual mapping.

No additional flag is needed. We use PG_swapcache together with PG_compound
(similar to PageHead() and PageTail()) to signal that a compound
page is virtually mapped. PG_swapcache is not used at this point since
compound pages cannot be put onto the LRU (yet).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/page-flags.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: linux-2.6.25-rc5-mm1/include/linux/page-flags.h
===================================================================
--- linux-2.6.25-rc5-mm1.orig/include/linux/page-flags.h	2008-03-20 17:40:16.141487362 -0700
+++ linux-2.6.25-rc5-mm1/include/linux/page-flags.h	2008-03-20 17:41:58.768233703 -0700
@@ -196,6 +196,24 @@ static inline int PageHighMem(struct pag
 }
 #endif
 
+/*
+ * PG_swapcache is used in combination with PG_compound to indicate
+ * that a compound page was allocated via vmalloc.
+ */
+#define PG_vcompound_mask ((1L << PG_compound) | (1L << PG_swapcache))
+#define PageVcompound(page)	((page->flags & PG_vcompound_mask) \
+					== PG_vcompound_mask)
+
+static inline void __SetPageVcompound(struct page *page)
+{
+	page->flags |= PG_vcompound_mask;
+}
+
+static inline void __ClearPageVcompound(struct page *page)
+{
+	page->flags &= ~PG_vcompound_mask;
+}
+
 #ifdef CONFIG_SWAP
 PAGEFLAG(SwapCache, swapcache)
 #else

-- 
