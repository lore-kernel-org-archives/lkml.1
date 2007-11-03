Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbXKCRYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbXKCRYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 13:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXKCRYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 13:24:20 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:36537 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbXKCRYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 13:24:18 -0400
Date: Sat, 3 Nov 2007 17:11:55 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] slub: fix Objects count
In-Reply-To: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0711031711080.10266@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The count of active Objects shown by Slub's slabinfo is too approximate,
because each cpu slab is counted as all in use, even when lots are free.
That makes tracing leaks harder than it need be.

Add a free count into kmem_cache_cpu (which doesn't enlarge it on 64-bit),
to keep that count in the hot and dirty per-cpu cacheline.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
I recommend this for 2.6.24-rc2, and 2.6.23-stable.  But perhaps you've
intentionally avoided this little extra overhead (which isn't necessary
for any functional correctness).  I do think it helps to see accurate
numbers there - which Slab gives, doesn't it?

I believe I've seen a futures patch go by in which you fit something
else into kmem_cache_cpu here; then another in which you remove more.
Not sure where you stand now!

 include/linux/slub_def.h |    1 +
 mm/slub.c                |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- 2.6.24-rc1+/include/linux/slub_def.h	2007-10-24 07:16:02.000000000 +0100
+++ linux/include/linux/slub_def.h	2007-11-03 13:22:48.000000000 +0000
@@ -14,6 +14,7 @@
 struct kmem_cache_cpu {
 	void **freelist;
 	struct page *page;
+	unsigned int free;
 	int node;
 	unsigned int offset;
 	unsigned int objsize;
--- 2.6.24-rc1+/mm/slub.c	2007-11-03 13:22:31.000000000 +0000
+++ linux/mm/slub.c	2007-11-03 13:22:48.000000000 +0000
@@ -1392,6 +1392,7 @@ static void deactivate_slab(struct kmem_
 		page->freelist = object;
 		page->inuse--;
 	}
+	c->free = 0;
 	c->page = NULL;
 	unfreeze_slab(s, page);
 }
@@ -1483,8 +1484,8 @@ load_freelist:
 	if (unlikely(SlabDebug(c->page)))
 		goto debug;
 
-	object = c->page->freelist;
 	c->freelist = object[c->offset];
+	c->free = s->objects - c->page->inuse - 1;
 	c->page->inuse = s->objects;
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
@@ -1528,6 +1529,7 @@ new_slab:
 				if (c->freelist) {
 					object = c->freelist;
 					c->freelist = object[c->offset];
+					c->free--;
 					return object;
 				}
 				slab_lock(c->page);
@@ -1580,6 +1582,7 @@ static void __always_inline *slab_alloc(
 	else {
 		object = c->freelist;
 		c->freelist = object[c->offset];
+		c->free--;
 	}
 	local_irq_restore(flags);
 
@@ -1685,6 +1688,7 @@ static void __always_inline slab_free(st
 	if (likely(page == c->page && c->node >= 0)) {
 		object[c->offset] = c->freelist;
 		c->freelist = object;
+		c->free++;
 	} else
 		__slab_free(s, page, x, addr, c->offset);
 
@@ -1866,6 +1870,7 @@ static void init_kmem_cache_cpu(struct k
 {
 	c->page = NULL;
 	c->freelist = NULL;
+	c->free = 0;
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
@@ -3534,7 +3539,7 @@ static unsigned long slab_objects(struct
 				int x = 0;
 
 				if (flags & SO_OBJECTS)
-					x = page->inuse;
+					x = page->inuse - c->free;
 				else
 					x = 1;
 				total += x;
