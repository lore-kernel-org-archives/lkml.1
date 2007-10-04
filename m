Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbXJDEBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbXJDEBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXJDEAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:00:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37852 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753939AbXJDEAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:00:05 -0400
Message-Id: <20071004040002.849512773@sgi.com>
References: <20071004035935.042951211@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Oct 2007 20:59:40 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [05/18] Page flags: Add PageVcompound()
Content-Disposition: inline; filename=vcompound_pagevcompound
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a another page flag that can be used to figure out if a compound
page is virtually mapped. The mark is necessary since we have to know
when freeing pages if we have to destroy a virtual mapping. No additional
flag is consumed through the use of PG_swapcache together with PG_compound
(similar to PageHead() and PageTail()).

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/page-flags.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2007-10-03 19:31:51.000000000 -0700
+++ linux-2.6/include/linux/page-flags.h	2007-10-03 19:34:37.000000000 -0700
@@ -248,6 +248,24 @@ static inline void __ClearPageTail(struc
 #define __SetPageHead(page)	__SetPageCompound(page)
 #define __ClearPageHead(page)	__ClearPageCompound(page)
 
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
 #define PageSwapCache(page)	test_bit(PG_swapcache, &(page)->flags)
 #define SetPageSwapCache(page)	set_bit(PG_swapcache, &(page)->flags)

-- 
