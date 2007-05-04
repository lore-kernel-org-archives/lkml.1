Return-Path: <linux-kernel-owner+w=401wt.eu-S1031289AbXEDXDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031289AbXEDXDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031442AbXEDXDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:03:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34325 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031289AbXEDXDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:03:44 -0400
Date: Fri, 4 May 2007 16:03:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: linux-kernel@vger.kernel.org
cc: linux-mm@kvack.org, dgc@sgi.com, Eric Dumazet <dada1@cosmosbay.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 2/3] SLUB: Implement targeted reclaim and partial list
 defragmentation
In-Reply-To: <20070504221708.596112123@sgi.com>
Message-ID: <Pine.LNX.4.64.0705041603150.27790@schroedinger.engr.sgi.com>
References: <20070504221555.642061626@sgi.com> <20070504221708.596112123@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes suggested by Andrew

---
 include/linux/slab.h |   12 ++++++++++++
 mm/slub.c            |   32 +++++++++++++++++++++-----------
 2 files changed, 33 insertions(+), 11 deletions(-)

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-05-04 15:52:54.000000000 -0700
+++ slub/mm/slub.c	2007-05-04 15:53:11.000000000 -0700
@@ -2142,42 +2142,46 @@ EXPORT_SYMBOL(kfree);
  *
  * Return error code or number of remaining objects
  */
-static int __kmem_cache_vacate(struct kmem_cache *s, struct page *page)
+static int __kmem_cache_vacate(struct kmem_cache *s,
+		struct page *page, unsigned long flags)
 {
 	void *p;
 	void *addr = page_address(page);
-	unsigned long map[BITS_TO_LONGS(s->objects)];
+	DECLARE_BITMAP(map, s->objects);
 	int leftover;
 
 	if (!page->inuse)
 		return 0;
 
 	/* Determine free objects */
-	bitmap_zero(map, s->objects);
-	for(p = page->freelist; p; p = get_freepointer(s, p))
-		set_bit((p - addr) / s->size, map);
+	bitmap_fill(map, s->objects);
+	for (p = page->freelist; p; p = get_freepointer(s, p))
+		__clear_bit((p - addr) / s->size, map);
 
 	/*
 	 * Get a refcount for all used objects. If that fails then
 	 * no KICK callback can be performed.
 	 */
-	for(p = addr; p < addr + s->objects * s->size; p += s->size)
-		if (!test_bit((p - addr) / s->size, map))
+	for (p = addr; p < addr + s->objects * s->size; p += s->size)
+		if (test_bit((p - addr) / s->size, map))
 			if (!s->slab_ops->get_reference(p))
-				set_bit((p - addr) / s->size, map);
+				__clear_bit((p - addr) / s->size, map);
 
 	/* Got all the references we need. Now we can drop the slab lock */
 	slab_unlock(page);
+	local_irq_restore(flags);
 
 	/* Perform the KICK callbacks to remove the objects */
 	for(p = addr; p < addr + s->objects * s->size; p += s->size)
-		if (!test_bit((p - addr) / s->size, map))
+		if (test_bit((p - addr) / s->size, map))
 			s->slab_ops->kick_object(p);
 
+	local_irq_save(flags);
 	slab_lock(page);
 	leftover = page->inuse;
 	ClearPageActive(page);
 	putback_slab(s, page);
+	local_irq_restore(flags);
 	return leftover;
 }
 
@@ -2197,6 +2201,7 @@ static void remove_from_lists(struct kme
  */
 int kmem_cache_vacate(struct page *page)
 {
+	unsigned long flags;
 	struct kmem_cache *s;
 	int rc = 0;
 
@@ -2208,6 +2213,7 @@ int kmem_cache_vacate(struct page *page)
 	if (!PageSlab(page))
 		goto out;
 
+	local_irq_save(flags);
 	slab_lock(page);
 
 	/*
@@ -2221,6 +2227,7 @@ int kmem_cache_vacate(struct page *page)
 	 */
 	if (!PageSlab(page) || PageActive(page) || !page->inuse) {
 		slab_unlock(page);
+		local_irq_restore(flags);
 		goto out;
 	}
 
@@ -2231,7 +2238,7 @@ int kmem_cache_vacate(struct page *page)
 	s = page->slab;
 	remove_from_lists(s, page);
 	SetPageActive(page);
-	rc = __kmem_cache_vacate(s, page) == 0;
+	rc = __kmem_cache_vacate(s, page, flags) == 0;
 out:
 	put_page(page);
 	return rc;
@@ -2336,8 +2343,11 @@ int kmem_cache_shrink(struct kmem_cache 
 
 		/* Now we can free objects in the slabs on the zaplist */
 		list_for_each_entry_safe(page, page2, &zaplist, lru) {
+			unsigned long flags;
+
+			local_irq_save(flags);
 			slab_lock(page);
-			__kmem_cache_vacate(s, page);
+			__kmem_cache_vacate(s, page, flags);
 		}
 	}
 
Index: slub/include/linux/slab.h
===================================================================
--- slub.orig/include/linux/slab.h	2007-05-04 15:53:06.000000000 -0700
+++ slub/include/linux/slab.h	2007-05-04 15:53:17.000000000 -0700
@@ -42,7 +42,19 @@ struct slab_ops {
 	void (*ctor)(void *, struct kmem_cache *, unsigned long);
 	/* FIXME: Remove all destructors ? */
 	void (*dtor)(void *, struct kmem_cache *, unsigned long);
+	/*
+	 * Called with slab lock held and interrupts disabled.
+	 * No slab operations may be performed in get_reference
+	 *
+	 * Must return 1 if a reference was obtained.
+	 * 0 if we failed to obtain the reference (f.e.
+	 * the object is concurrently freed).
+	 */
 	int (*get_reference)(void *);
+	/*
+	 * Called with no locks held and interrupts enabled.
+	 * Any operation may be performed in kick_object.
+	 */
 	void (*kick_object)(void *);
 };
 
