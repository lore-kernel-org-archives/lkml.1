Return-Path: <linux-kernel-owner+w=401wt.eu-S1762717AbYCDAJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762717AbYCDAJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYCDAHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:07:38 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40095 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752760AbYCDAHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:07:35 -0500
Message-Id: <20080304000733.487348652@sgi.com>
References: <20080304000452.514878384@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Mar 2008 16:04:58 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: apw@shadowen.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org
Subject: [rfc 06/10] Sparsemem: Vmemmap does not need section bits
Content-Disposition: inline; filename=sparsemem_vmemmap_does_not_need_section_flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparsemem vmemmap does not need any section bits. This patch has
the effect of reducing the number of bits used in page->flags
by at least 6.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-03-03 15:45:07.047305876 -0800
+++ linux-2.6/include/linux/mm.h	2008-03-03 15:49:04.686432973 -0800
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
@@ -405,6 +405,9 @@ static inline void set_compound_order(st
 #if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= FLAGS_RESERVED
 #define NODES_WIDTH		NODES_SHIFT
 #else
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#error "Vmemmap: No space for nodes field in page flags"
+#endif
 #define NODES_WIDTH		0
 #endif
 

-- 
