Return-Path: <linux-kernel-owner+w=401wt.eu-S1762620AbXHURoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762620AbXHURoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761069AbXHURn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:43:56 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:59691 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761061AbXHURnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:43:55 -0400
Date: Tue, 21 Aug 2007 13:38:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070821173849.GA8360@Krystal>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca> <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:04:23 up 22 days, 15:23,  3 users,  load average: 0.57, 0.39, 0.40
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I played with your patch a bit, and the results are quite
interesting:

SLUB use cmpxchg_local

my changes:
- Fixed an erroneous test in slab_free() (logic was flipped from the 
  original code when testing for slow path. It explains the wrong 
  numbers you have with big free).
- Use cmpxchg_local
- Changed smp_rmb() for barrier(). We are not interested in read order
  across cpus, what we want is to be ordered wrt local interrupts only.
  barrier() is much cheaper than a rmb().

It applies on top of the 
"SLUB Use cmpxchg() everywhere" patch.

Summary:

(tests repeated 10000 times on a 3GHz Pentium 4)
(kernel DEBUG menuconfig options are turned off)
results are in cycles per iteration
I did 2 runs of the slab.git HEAD to have an idea of errors associated
to the measurements:

             |     slab.git HEAD slub (min-max)    |  cmpxchg_local slub
kmalloc(8)   |         190 - 201                   |         83
kfree(8)     |         351 - 351                   |        363
kmalloc(64)  |         224 - 245                   |        115
kfree(64)    |         389 - 394                   |        397
kmalloc(16384)|        713 - 741                   |        724
kfree(16384) |         843 - 856                   |        843

Therefore, there seems to be a repeatable gain on the kmalloc fast path
(more than twice faster). No significant performance hit for the kfree
case, but no gain neither, same for large kmalloc, as expected.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 mm/slub.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

Index: slab/mm/slub.c
===================================================================
--- slab.orig/mm/slub.c	2007-08-21 12:59:38.000000000 -0400
+++ slab/mm/slub.c	2007-08-21 13:16:31.000000000 -0400
@@ -1554,26 +1554,26 @@ static void __always_inline *slab_alloc(
 	void **object;
 	struct kmem_cache_cpu *c;
 
-redo:
+	preempt_disable();
 	c = get_cpu_slab(s, raw_smp_processor_id());
-	object = c->freelist;
-	if (unlikely(!object))
-		goto slow;
-
 	if (unlikely(!node_match(c, node)))
 		goto slow;
 
-	if (unlikely(cmpxchg(&c->freelist, object,
-		object[c->offset]) != object))
-			goto redo;
+redo:
+	object = c->freelist;
+	if (unlikely(!object))
+		goto slow;
 
+	if (unlikely(cmpxchg_local(&c->freelist, object,
+			object[c->offset]) != object))
+		goto redo;
+	preempt_enable();
 	if (unlikely((gfpflags & __GFP_ZERO)))
 		memset(object, 0, c->objsize);
-
 	return object;
 slow:
+	preempt_enable();
 	return __slab_alloc(s, gfpflags, node, addr);
-
 }
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
@@ -1670,22 +1670,26 @@ static void __always_inline slab_free(st
 	void **freelist;
 	struct kmem_cache_cpu *c;
 
+	preempt_disable();
 	c = get_cpu_slab(s, raw_smp_processor_id());
-	if (unlikely(c->node >= 0))
+	if (unlikely(c->node < 0))
 		goto slow;
 
 redo:
 	freelist = c->freelist;
-	smp_rmb();
+	barrier();	/* Read freelist before page, wrt local interrupts */
 	if (unlikely(page != c->page))
 		goto slow;
 
 	object[c->offset] = freelist;
 
-	if (unlikely(cmpxchg(&c->freelist, freelist, object) != freelist))
+	if (unlikely(cmpxchg_local(&c->freelist,
+			freelist, object) != freelist))
 		goto redo;
+	preempt_enable();
 	return;
 slow:
+	preempt_enable();
 	__slab_free(s, page, x, addr, c->offset);
 }
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
