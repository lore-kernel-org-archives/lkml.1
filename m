Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYEIOaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYEIOaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 10:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYEIO36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 10:29:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:48798 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYEIO35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 10:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=qHWmAbQBE0+o9oRXk+7H9/w7hzHaal1RxOBX0bGf65CYPb7rmOuHFFFZ4fXLsNmClggRZYbS4+TVJZAxV9+qz8DCyFsCg++qrHGphjTuAYw67lh4KjNksR6z5Z7bRYIY1Z95HE82IC+pwffU3dmfat7gGg2u5stpJVeFFICWbSk=
Date: Fri, 9 May 2008 16:29:43 +0200
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: store shadow-memory pointers in each page
Message-ID: <20080509142943.GA1614@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This was tested and boots fine on my real hw. Please apply :-)

Vegard


>From c12a6327951d278b8b28931323f67fe65698f343 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 9 May 2008 16:14:10 +0200
Subject: [PATCH] kmemcheck: store shadow-memory pointers in each page

Prior to this patch, the pointer to the shadow-memory area was stored only in
the head page of each (compound) allocation.

This patch is a prerequisite for SLAB support, since SLAB does not use
__GFP_COMP.

For this reason, we need to store one shadow-memory pointer per page. Note
that the shadow memory must still be allocated in a single block, since
mark_shadow() and friends assume that shadow memory is contiguous across page
boundaries.

Also remove some useless code.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/kmemcheck.c |    6 +++---
 mm/slub_kmemcheck.c         |   26 ++++++++++----------------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
index ebdbe20..f03024a 100644
--- a/arch/x86/kernel/kmemcheck.c
+++ b/arch/x86/kernel/kmemcheck.c
@@ -280,7 +280,6 @@ address_get_shadow(unsigned long address)
 {
 	pte_t *pte;
 	struct page *page;
-	struct page *head;
 
 	if (!virt_addr_valid(address))
 		return NULL;
@@ -290,8 +289,9 @@ address_get_shadow(unsigned long address)
 		return NULL;
 
 	page = virt_to_page(address);
-	head = compound_head(page);
-	return head->shadow + ((void *) address - page_address(head));
+	if (!page->shadow)
+		return NULL;
+	return page->shadow + (address & (PAGE_SIZE - 1));
 }
 
 static int
diff --git a/mm/slub_kmemcheck.c b/mm/slub_kmemcheck.c
index 1fa8168..2fe33ab 100644
--- a/mm/slub_kmemcheck.c
+++ b/mm/slub_kmemcheck.c
@@ -9,6 +9,7 @@ void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
 {
 	struct page *shadow;
 	int order, pages;
+	int i;
 
 	order = compound_order(page);
 	pages = 1 << order;
@@ -17,9 +18,6 @@ void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
 	 * With kmemcheck enabled, we need to allocate a memory area for the
 	 * shadow bits as well.
 	 */
-
-	flags |= __GFP_COMP;
-
 	shadow = alloc_pages_node(node, flags, order);
 	if (!shadow) {
 		if (printk_ratelimit())
@@ -28,7 +26,8 @@ void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
 		return;
 	}
 
-	page->shadow = page_address(shadow);
+	for(i = 0; i < pages; ++i)
+		page[i].shadow = page_address(&shadow[i]);
 
 	/*
 	 * Mark it as non-present for the MMU so that our accesses to
@@ -45,29 +44,24 @@ void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
 		kmemcheck_mark_uninitialized_pages(page, pages);
 	else
 		kmemcheck_mark_unallocated_pages(page, pages);
-
-	mod_zone_page_state(page_zone(shadow),
-		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-		pages);
 }
 
 void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page)
 {
-	struct page *shadow = virt_to_page(page->shadow);
+	struct page *shadow;
 	int order, pages;
+	int i;
 
 	order = compound_order(page);
 	pages = 1 << order;
 
 	kmemcheck_show_pages(page, pages);
 
-	__ClearPageSlab(shadow);
-	mod_zone_page_state(page_zone(shadow),
-		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-		-pages);
-	reset_page_mapcount(shadow);
+	shadow = virt_to_page(page[0].shadow);
+
+	for(i = 0; i < pages; ++i)
+		page[i].shadow = NULL;
+
 	__free_pages(shadow, order);
 }
 
-- 
1.5.4.1

