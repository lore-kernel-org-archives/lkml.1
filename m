Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbZF2Brx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbZF2Brx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbZF2Br0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:47:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:27242 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbZF2BrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:47:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,305,1243839600"; 
   d="scan'208";a="159422602"
Subject: [PATCH 4/5]memhp: alloc page from other node in memory online
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org,
       "yakui.zhao" <yakui.zhao@intel.com>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 09:47:26 +0800
Message-Id: <1246240046.26292.20.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To initialize hotadded node, some pages are allocated. At that time,
the node hasn't memory, this makes the allocation always fail.
In such case, let's allocate pages from other nodes.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Yakui Zhao <yakui.zhao@intel.com>
---
 mm/page_cgroup.c    |   12 +++++++++---
 mm/sparse-vmemmap.c |    8 +++++++-
 mm/sparse.c         |    9 ++++++---
 3 files changed, 22 insertions(+), 7 deletions(-)

Index: linux/mm/page_cgroup.c
===================================================================
--- linux.orig/mm/page_cgroup.c	2009-06-26 09:55:29.000000000 +0800
+++ linux/mm/page_cgroup.c	2009-06-26 09:55:36.000000000 +0800
@@ -116,10 +116,16 @@ static int __init_refok init_section_pag
 		nid = page_to_nid(pfn_to_page(pfn));
 		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
 		VM_BUG_ON(!slab_is_available());
-		base = kmalloc_node(table_size,
+		if (node_state(nid, N_HIGH_MEMORY)) {
+			base = kmalloc_node(table_size,
 				GFP_KERNEL | __GFP_NOWARN, nid);
-		if (!base)
-			base = vmalloc_node(table_size, nid);
+			if (!base)
+				base = vmalloc_node(table_size, nid);
+		} else {
+			base = kmalloc(table_size, GFP_KERNEL | __GFP_NOWARN);
+			if (!base)
+				base = vmalloc(table_size);
+		}
 	} else {
 		/*
  		 * We don't have to allocate page_cgroup again, but
Index: linux/mm/sparse-vmemmap.c
===================================================================
--- linux.orig/mm/sparse-vmemmap.c	2009-06-26 09:55:29.000000000 +0800
+++ linux/mm/sparse-vmemmap.c	2009-06-26 09:55:36.000000000 +0800
@@ -48,8 +48,14 @@ void * __meminit vmemmap_alloc_block(uns
 {
 	/* If the main allocator is up use that, fallback to bootmem. */
 	if (slab_is_available()) {
-		struct page *page = alloc_pages_node(node,
+		struct page *page;
+
+		if (node_state(node, N_HIGH_MEMORY))
+			page = alloc_pages_node(node,
 				GFP_KERNEL | __GFP_ZERO, get_order(size));
+		else
+			page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+				get_order(size));
 		if (page)
 			return page_address(page);
 		return NULL;
Index: linux/mm/sparse.c
===================================================================
--- linux.orig/mm/sparse.c	2009-06-26 09:55:29.000000000 +0800
+++ linux/mm/sparse.c	2009-06-26 09:55:36.000000000 +0800
@@ -62,9 +62,12 @@ static struct mem_section noinline __ini
 	unsigned long array_size = SECTIONS_PER_ROOT *
 				   sizeof(struct mem_section);
 
-	if (slab_is_available())
-		section = kmalloc_node(array_size, GFP_KERNEL, nid);
-	else
+	if (slab_is_available()) {
+		if (node_state(nid, N_HIGH_MEMORY))
+			section = kmalloc_node(array_size, GFP_KERNEL, nid);
+		else
+			section = kmalloc(array_size, GFP_KERNEL);
+	} else
 		section = alloc_bootmem_node(NODE_DATA(nid), array_size);
 
 	if (section)


