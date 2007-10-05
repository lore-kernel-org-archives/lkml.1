Return-Path: <linux-kernel-owner+w=401wt.eu-S1762510AbXJETbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762510AbXJETbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXJETbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:31:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35305 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751293AbXJETbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:31:23 -0400
Date: Fri, 5 Oct 2007 12:31:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       David Chinner <dgc@sgi.com>, David Miller <davem@davemloft.net>,
       cebbert@redhat.com, willy@linux.intel.com, nickpiggin@yahoo.com.au,
       hch@lst.de, mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
In-Reply-To: <20071005123953.GS5711@kernel.dk>
Message-ID: <Pine.LNX.4.64.0710051229570.17562@schroedinger.engr.sgi.com>
References: <470554D9.2050505@redhat.com> <20071004.141113.08322956.davem@davemloft.net>
 <47055F84.109@redhat.com> <20071004.150718.95506800.davem@davemloft.net>
 <20071004222356.GH23367404@sgi.com> <20071005064853.GI5711@kernel.dk>
 <84144f020710050219k2460631cjfd556d6eae645887@mail.gmail.com>
 <20071005092822.GL5711@kernel.dk> <p73bqbd6cip.fsf@bingen.suse.de>
 <20071005123953.GS5711@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Jens Axboe wrote:

> It might not, it might. The point is trying to isolate the problem and
> making a simple test case that could be used to reproduce it, so that
> Christoph (or someone else) can easily fix it.

In case there is someone who wants to hack on it: Here is what I got so 
far for batching the frees. I will try to come up with a test next week if 
nothing else happens before:

Patch 1/2 on top of mm:

SLUB: Keep counter of remaining objects on the per cpu list

Add a counter to keep track of how many objects are on the per cpu list.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |    1 +
 mm/slub.c                |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6.23-rc8-mm2/include/linux/slub_def.h
===================================================================
--- linux-2.6.23-rc8-mm2.orig/include/linux/slub_def.h	2007-10-04 22:41:58.000000000 -0700
+++ linux-2.6.23-rc8-mm2/include/linux/slub_def.h	2007-10-04 22:42:08.000000000 -0700
@@ -15,6 +15,7 @@ struct kmem_cache_cpu {
 	void **freelist;
 	struct page *page;
 	int node;
+	int remaining;
 	unsigned int offset;
 	unsigned int objsize;
 };
Index: linux-2.6.23-rc8-mm2/mm/slub.c
===================================================================
--- linux-2.6.23-rc8-mm2.orig/mm/slub.c	2007-10-04 22:41:58.000000000 -0700
+++ linux-2.6.23-rc8-mm2/mm/slub.c	2007-10-04 22:42:08.000000000 -0700
@@ -1386,12 +1386,13 @@ static void deactivate_slab(struct kmem_
 	 * because both freelists are empty. So this is unlikely
 	 * to occur.
 	 */
-	while (unlikely(c->freelist)) {
+	while (unlikely(c->remaining)) {
 		void **object;
 
 		/* Retrieve object from cpu_freelist */
 		object = c->freelist;
 		c->freelist = c->freelist[c->offset];
+		c->remaining--;
 
 		/* And put onto the regular freelist */
 		object[c->offset] = page->freelist;
@@ -1491,6 +1492,7 @@ load_freelist:
 
 	object = c->page->freelist;
 	c->freelist = object[c->offset];
+	c->remaining = s->objects - c->page->inuse - 1;
 	c->page->inuse = s->objects;
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
@@ -1574,13 +1576,14 @@ static void __always_inline *slab_alloc(
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->freelist || !node_match(c, node)))
+	if (unlikely(!c->remaining || !node_match(c, node)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
 		object = c->freelist;
 		c->freelist = object[c->offset];
+		c->remaining--;
 	}
 	local_irq_restore(flags);
 
@@ -1686,6 +1689,7 @@ static void __always_inline slab_free(st
 	if (likely(page == c->page && c->node >= 0)) {
 		object[c->offset] = c->freelist;
 		c->freelist = object;
+		c->remaining++;
 	} else
 		__slab_free(s, page, x, addr, c->offset);
 


