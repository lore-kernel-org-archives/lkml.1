Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbZBLHZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbZBLHZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 02:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZBLHZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 02:25:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46928 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbZBLHZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 02:25:41 -0500
Date: Thu, 12 Feb 2009 16:24:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       davem@davemlloft.net, heiko.carstens@de.ibm.com
Subject: [PATCH 2/2] fix memmap init for handling memory hole
Message-Id: <20090212162421.65bb7aa2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090212161920.deedea35.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090212161920.deedea35.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, early_pfn_in_nid(PFN, NID) may returns false if PFN is a hole.
and memmap initialization was not done. This was a trouble for
sparc boot.

To fix this, the PFN should be initialized and marked as PG_reserved.
This patch changes early_pfn_in_nid() return true if PFN is a hole.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 arch/ia64/mm/numa.c    |    2 +-
 include/linux/mmzone.h |    2 +-
 mm/page_alloc.c        |   23 ++++++++++++++++++++---
 3 files changed, 22 insertions(+), 5 deletions(-)

Index: mmotm-2.6.29-Feb11/mm/page_alloc.c
===================================================================
--- mmotm-2.6.29-Feb11.orig/mm/page_alloc.c
+++ mmotm-2.6.29-Feb11/mm/page_alloc.c
@@ -2985,16 +2985,33 @@ int __meminit __early_pfn_to_nid(unsigne
 		if (start_pfn <= pfn && pfn < end_pfn)
 			return early_node_map[i].nid;
 	}
-
-	return 0;
+	/* This is a memory hole */
+	return -1;
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
 int __meminit early_pfn_to_nid(unsigned long pfn)
 {
-	return __early_pfn_to_nid(pfn);
+	int nid;
+
+	nid = __early_pfn_to_nid(pfn);
+	if (nid >= 0)
+		return nid;
+	/* just returns 0 */
+	return 0;
 }
 
+#ifdef CONFIG_NODES_SPAN_OTHER_NODES
+bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
+{
+	int nid;
+
+	nid = __early_pfn_to_nid(pfn);
+	if (nid >= 0 && nid != node)
+		return false;
+	return true;
+}
+#endif
 
 /* Basic iterator support to walk early_node_map[] */
 #define for_each_active_range_index_in_nid(i, nid) \
Index: mmotm-2.6.29-Feb11/include/linux/mmzone.h
===================================================================
--- mmotm-2.6.29-Feb11.orig/include/linux/mmzone.h
+++ mmotm-2.6.29-Feb11/include/linux/mmzone.h
@@ -1079,7 +1079,7 @@ void sparse_init(void);
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_NODES_SPAN_OTHER_NODES
-#define early_pfn_in_nid(pfn, nid)	(early_pfn_to_nid(pfn) == (nid))
+bool early_pfn_in_nid(unsigned long pfn, int nid);
 #else
 #define early_pfn_in_nid(pfn, nid)	(1)
 #endif
Index: mmotm-2.6.29-Feb11/arch/ia64/mm/numa.c
===================================================================
--- mmotm-2.6.29-Feb11.orig/arch/ia64/mm/numa.c
+++ mmotm-2.6.29-Feb11/arch/ia64/mm/numa.c
@@ -70,7 +70,7 @@ int __meminit __early_pfn_to_nid(unsigne
 			return node_memblk[i].nid;
 	}
 
-	return 0;
+	return -1;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG

