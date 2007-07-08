Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbXGHDwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbXGHDwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 23:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbXGHDud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 23:50:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49260 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755915AbXGHDuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 23:50:19 -0400
Message-Id: <20070708035017.867780265@sgi.com>
References: <20070708034952.022985379@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jul 2007 20:50:00 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org
Cc: suresh.b.siddha@intel.com
Cc: corey.d.gough@intel.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Subject: [patch 08/10] SLUB: Single atomic instruction alloc/free using cmpxchg
Content-Disposition: inline; filename=slub_cmpxchg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A cmpxchg allows us to avoid disabling and enabling interrupts. The cmpxchg
is optimal to allow operations on per cpu freelist even if we may be moved
to other processors while getting to the cmpxchg. So we do not need to be
pinned to a cpu. This may be particularly useful for the RT kernel
where we currently seem to have major SLAB issues with the per cpu structures.
But the constant interrupt disable / enable of slab operations also increases
the performance in general.

The hard binding to per cpu structures only comes into play when we enter
the slow path (__slab_alloc and __slab_free). At that point we have to disable
interrupts like before.

We have a problem of determining the page struct in slab_free due the
issue that the freelist pointer is the only data value that we can reliably
operate on. So we need to do a virt_to_page() on the freelist. This makes it
impossible to use the fastpath for a full slab and increases overhead
through a second virt_to_page for each slab_free(). We really need the
virtual memmap patchset to get slab_free to good performance for this one.

Pro:

        - Dirty single cacheline with a single instruction in
          slab_alloc to accomplish allocation.
        - Critical section is also a single instruction in slab_free.
          (but we need to write to the cacheline of the object too)

Con:
        - Complex freelist management. __slab_alloc has to deal
	  with results of race conditions.
        - Recalculation of per cpu structure address is necessary
          in __slab_alloc since process may be rescheduled while
          executing in slab_alloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

Index: linux-2.6.22-rc6-mm1/mm/slub.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/mm/slub.c	2007-07-07 18:40:10.000000000 -0700
+++ linux-2.6.22-rc6-mm1/mm/slub.c	2007-07-07 18:46:04.000000000 -0700
@@ -1370,34 +1370,38 @@ static void unfreeze_slab(struct kmem_ca
 /*
  * Remove the cpu slab
  */
-static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
+static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
+			void **freelist)
 {
 	struct page *page = c->page;
+
+	c->page = NULL;
 	/*
 	 * Merge cpu freelist into freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
 	 * to occur.
 	 */
-	while (unlikely(c->freelist)) {
+	while (unlikely(freelist)) {
 		void **object;
 
 		/* Retrieve object from cpu_freelist */
-		object = c->freelist;
-		c->freelist = c->freelist[c->offset];
+		object = freelist;
+		freelist = freelist[c->offset];
 
 		/* And put onto the regular freelist */
 		object[c->offset] = page->freelist;
 		page->freelist = object;
 		page->inuse--;
 	}
-	c->page = NULL;
 	unfreeze_slab(s, page);
 }
 
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
+	void **freelist = xchg(&c->freelist, NULL);
+
 	slab_lock(c->page);
-	deactivate_slab(s, c);
+	deactivate_slab(s, c, freelist);
 }
 
 /*
@@ -1467,10 +1471,13 @@ static void *__slab_alloc(struct kmem_ca
 {
 	void **object;
 	struct page *new;
+	void **freelist = NULL;
 
 	if (!c->page)
 		goto new_slab;
 
+	freelist = xchg(&c->freelist, NULL);
+
 	slab_lock(c->page);
 	if (unlikely(!node_match(c, node)))
 		goto another_slab;
@@ -1490,7 +1497,7 @@ load_freelist:
 	return object;
 
 another_slab:
-	deactivate_slab(s, c);
+	deactivate_slab(s, c, freelist);
 
 new_slab:
 	new = get_partial(s, gfpflags, node);

-- 
