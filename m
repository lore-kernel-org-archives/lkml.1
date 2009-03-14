Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbZCNBYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbZCNBYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZCNBTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:53 -0400
Received: from kroah.org ([198.145.64.141]:34822 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751539AbZCNBTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:33 2009
Message-Id: <20090314011032.952425224@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 011/114] mm: fix memmap init for handling memory hole
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=mm-fix-memmap-init-for-handling-memory-hole.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit cc2559bccc72767cb446f79b071d96c30c26439b upstream.

Now, early_pfn_in_nid(PFN, NID) may returns false if PFN is a hole.
and memmap initialization was not done. This was a trouble for
sparc boot.

To fix this, the PFN should be initialized and marked as PG_reserved.
This patch changes early_pfn_in_nid() return true if PFN is a hole.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: David Miller <davem@davemlloft.net>
Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/mm/numa.c    |    2 +-
 include/linux/mmzone.h |    2 +-
 mm/page_alloc.c        |   23 ++++++++++++++++++++---
 3 files changed, 22 insertions(+), 5 deletions(-)

--- a/arch/ia64/mm/numa.c
+++ b/arch/ia64/mm/numa.c
@@ -70,7 +70,7 @@ int __meminit __early_pfn_to_nid(unsigne
 			return node_memblk[i].nid;
 	}
 
-	return 0;
+	return -1;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1067,7 +1067,7 @@ void sparse_init(void);
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_NODES_SPAN_OTHER_NODES
-#define early_pfn_in_nid(pfn, nid)	(early_pfn_to_nid(pfn) == (nid))
+bool early_pfn_in_nid(unsigned long pfn, int nid);
 #else
 #define early_pfn_in_nid(pfn, nid)	(1)
 #endif
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
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


