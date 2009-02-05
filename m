Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZBELQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZBELQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 06:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZBELQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 06:16:06 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36834 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbZBELQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 06:16:05 -0500
Date: Thu, 5 Feb 2009 20:14:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: David Miller <davem@davemloft.net>, heiko.carstens@de.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: [BUGFIX][PATCH] fix memmap init to initialize  valid memmap for
 memory hole. (Was Re: HOLES_IN_ZONE...
Message-Id: <20090205201448.3a0f4182.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090205103925.GE26878@csn.ul.ie>
References: <20090204.222651.26527737.davem@davemloft.net>
	<20090205180617.8ee3dfb5.kamezawa.hiroyu@jp.fujitsu.com>
	<20090205.012123.141238531.davem@davemloft.net>
	<20090205183409.1a12c23b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090205103925.GE26878@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 10:39:25 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> ====
> If a PFN is not in early_node_map[] then the struct page for it is not
> initialised. If there are holes within a MAX_ORDER_NR_PAGES range of
> pages, then PG_reserved will not be set. Code that walks PFNs within
> MAX_ORDER_NR_PAGES will then use uninitialised struct pages.
> 
> To avoid any problems, this patch initialises holes within a MAX_ORDER_NR_PAGES
> that valid memmap exists but is otherwise unused.
> ====
> 
Thank you, I use this text.
==
If PFN is not in early_node_map[] then struct page for it is not initialized.
If there are holes within a MAX_ORDER_NE_PAGES range of pages, then PG_reserved
will not be set. Code that walks PFNs within MAX_ORDER_NR_PAGES will the use
uninitialized struct pages.

To avoid any problems, this patch initializes holes within a MAX_ORDER_NR_PAGES
that valid memmap exists but is otherwise unused.

Changelog:
  - renamed variable from "tmp" to "actual_nid"

Reported-by: David Miller <davem@davemlloft.net>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mmzone.h |    6 ------
 mm/page_alloc.c        |   13 +++++++++++--
 2 files changed, 11 insertions(+), 8 deletions(-)

Index: linux-2.6.28-rc3/mm/page_alloc.c
===================================================================
--- linux-2.6.28-rc3.orig/mm/page_alloc.c
+++ linux-2.6.28-rc3/mm/page_alloc.c
@@ -2632,9 +2632,18 @@ void __meminit memmap_init_zone(unsigned
 		 * exist on hotplugged memory.
 		 */
 		if (context == MEMMAP_EARLY) {
+			int nid_from_node_memory_map;
+
 			if (!early_pfn_valid(pfn))
 				continue;
-			if (!early_pfn_in_nid(pfn, nid))
+			/*
+			 * early_pfn_to_nid() returns -1 if the page doesn't
+			 * exist in early_node_map[]. Initialize it in force
+			 * and set PG_reserved at el.
+			 */
+			nid_from_node_memory_map = early_pfn_to_nid(pfn);
+			if (nid_from_node_memory_map > -1 &&
+				nid_from_node_memory_map != nid)
 				continue;
 		}
 		page = pfn_to_page(pfn);
@@ -3001,7 +3010,7 @@ int __meminit early_pfn_to_nid(unsigned 
 			return early_node_map[i].nid;
 	}
 
-	return 0;
+	return -1;
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
Index: linux-2.6.28-rc3/include/linux/mmzone.h
===================================================================
--- linux-2.6.28-rc3.orig/include/linux/mmzone.h
+++ linux-2.6.28-rc3/include/linux/mmzone.h
@@ -1070,12 +1070,6 @@ void sparse_init(void);
 #define sparse_index_init(_sec, _nid)  do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
-#ifdef CONFIG_NODES_SPAN_OTHER_NODES
-#define early_pfn_in_nid(pfn, nid)	(early_pfn_to_nid(pfn) == (nid))
-#else
-#define early_pfn_in_nid(pfn, nid)	(1)
-#endif
-
 #ifndef early_pfn_valid
 #define early_pfn_valid(pfn)	(1)
 #endif

