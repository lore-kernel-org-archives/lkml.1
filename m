Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbXIYXsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbXIYXsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbXIYXnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57664 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752196AbXIYXmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:52 -0400
Message-Id: <20070925234251.517563592@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:14 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [10/17] Use GFP_VFALLBACK for sparsemem.
Content-Disposition: inline; filename=vcompound_sparse_gfp_vfallback
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sparsemem currently attempts first to do a physically contiguous mapping
and then falls back to vmalloc. The same thing can now be accomplished
using GFP_VFALLBACK.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/sparse.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c	2007-09-19 18:05:34.000000000 -0700
+++ linux-2.6/mm/sparse.c	2007-09-19 18:27:25.000000000 -0700
@@ -269,32 +269,15 @@ void __init sparse_init(void)
 #ifdef CONFIG_MEMORY_HOTPLUG
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
 {
-	struct page *page, *ret;
 	unsigned long memmap_size = sizeof(struct page) * nr_pages;
 
-	page = alloc_pages(GFP_KERNEL|__GFP_NOWARN, get_order(memmap_size));
-	if (page)
-		goto got_map_page;
-
-	ret = vmalloc(memmap_size);
-	if (ret)
-		goto got_map_ptr;
-
-	return NULL;
-got_map_page:
-	ret = (struct page *)pfn_to_kaddr(page_to_pfn(page));
-got_map_ptr:
-	memset(ret, 0, memmap_size);
-
-	return ret;
+	return (struct page *)__get_free_pages(GFP_VFALLBACK,
+		get_order(memmap_size));
 }
 
 static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 {
-	if (is_vmalloc_addr(memmap))
-		vfree(memmap);
-	else
-		free_pages((unsigned long)memmap,
+	free_pages((unsigned long)memmap,
 			   get_order(sizeof(struct page) * nr_pages));
 }
 

-- 
