Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbXHVPDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbXHVPDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760748AbXHVPCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:02:52 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:33846 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760541AbXHVPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:02:51 -0400
Date: Wed, 22 Aug 2007 11:02:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: [PATCH] SLUB: use have_arch_cmpxchg()
Message-ID: <20070822150248.GB8504@Krystal>
References: <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com> <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com> <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com> <20070822000323.GG29691@Krystal> <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com> <20070822002616.GA1400@Krystal> <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:00:44 up 23 days, 15:19,  4 users,  load average: 0.09, 0.22, 0.30
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB: use have_arch_cmpxchg()

* Christoph Lameter (clameter@sgi.com) wrote:
> If we really want to do this then the implementation of all of these 
> components need to result in competitive performance on all platforms.
> 

Patch 2 of 2

Use have_arch_cmpxchg() to select between irq disable and cmpxchg_local.

Pro:
- Should provide the same performances on architectures that does not provide
  fast local_cmpxchg.
- Improved performances on architectures that provide fast local_cmpxchg.

Cons:
- Does not help code readability, i.e.:

if (have_arch_cmpxchg())
	preempt_disable();
else
	local_irq_save(flags);

It applies on top of the cmpxchg_local() slub patch.
It depends on the Add have_arch_cmpxchg() patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 mm/slub.c |   65 +++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 19 deletions(-)

Index: slab/mm/slub.c
===================================================================
--- slab.orig/mm/slub.c	2007-08-22 10:28:22.000000000 -0400
+++ slab/mm/slub.c	2007-08-22 10:51:53.000000000 -0400
@@ -1450,7 +1450,8 @@ static void *__slab_alloc(struct kmem_ca
 	void **freelist = NULL;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	if (have_arch_cmpxchg())
+		local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	if (!c->page)
 		/* Slab was flushed */
@@ -1482,7 +1483,8 @@ out_object:
 	c->freelist = object[c->offset];
 out:
 	slab_unlock(c->page);
-	local_irq_restore(flags);
+	if (have_arch_cmpxchg())
+		local_irq_restore(flags);
 	if (unlikely((gfpflags & __GFP_ZERO)))
 		memset(object, 0, c->objsize);
 	return object;
@@ -1525,7 +1527,8 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
-	local_irq_restore(flags);
+	if (have_arch_cmpxchg())
+		local_irq_restore(flags);
 	return NULL;
 debug:
 	object = c->page->freelist;
@@ -1553,8 +1556,12 @@ static void __always_inline *slab_alloc(
 {
 	void **object;
 	struct kmem_cache_cpu *c;
+	unsigned long flags;
 
-	preempt_disable();
+	if (have_arch_cmpxchg())
+		preempt_disable();
+	else
+		local_irq_save(flags);
 	c = get_cpu_slab(s, raw_smp_processor_id());
 	if (unlikely(!node_match(c, node)))
 		goto slow;
@@ -1564,15 +1571,21 @@ redo:
 	if (unlikely(!object))
 		goto slow;
 
-	if (unlikely(cmpxchg_local(&c->freelist, object,
-			object[c->offset]) != object))
-		goto redo;
-	preempt_enable();
+	if (have_arch_cmpxchg()) {
+		if (unlikely(cmpxchg_local(&c->freelist, object,
+				object[c->offset]) != object))
+			goto redo;
+		preempt_enable();
+	} else {
+		c->freelist = object[c->offset];
+		local_irq_restore(flags);
+	}
 	if (unlikely((gfpflags & __GFP_ZERO)))
 		memset(object, 0, c->objsize);
 	return object;
 slow:
-	preempt_enable();
+	if (have_arch_cmpxchg())
+		preempt_enable();
 	return __slab_alloc(s, gfpflags, node, addr);
 }
 
@@ -1605,7 +1618,8 @@ static void __slab_free(struct kmem_cach
 	void **object = (void *)x;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	if (have_arch_cmpxchg())
+		local_irq_save(flags);
 	slab_lock(page);
 
 	if (unlikely(SlabDebug(page)))
@@ -1631,7 +1645,8 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
-	local_irq_restore(flags);
+	if (have_arch_cmpxchg())
+		local_irq_restore(flags);
 	return;
 
 slab_empty:
@@ -1642,7 +1657,8 @@ slab_empty:
 		remove_partial(s, page);
 
 	slab_unlock(page);
-	local_irq_restore(flags);
+	if (have_arch_cmpxchg())
+		local_irq_restore(flags);
 	discard_slab(s, page);
 	return;
 
@@ -1669,27 +1685,38 @@ static void __always_inline slab_free(st
 	void **object = (void *)x;
 	void **freelist;
 	struct kmem_cache_cpu *c;
+	unsigned long flags;
 
-	preempt_disable();
+	if (have_arch_cmpxchg())
+		preempt_disable();
+	else
+		local_irq_save(flags);
 	c = get_cpu_slab(s, raw_smp_processor_id());
 	if (unlikely(c->node < 0))
 		goto slow;
 
 redo:
 	freelist = c->freelist;
-	barrier();	/* Read freelist before page, wrt local interrupts */
+	if (have_arch_cmpxchg())
+		barrier(); /* Read freelist before page, wrt local interrupts */
 	if (unlikely(page != c->page))
 		goto slow;
 
 	object[c->offset] = freelist;
 
-	if (unlikely(cmpxchg_local(&c->freelist,
-			freelist, object) != freelist))
-		goto redo;
-	preempt_enable();
+	if (have_arch_cmpxchg()) {
+		if (unlikely(cmpxchg_local(&c->freelist,
+				freelist, object) != freelist))
+			goto redo;
+		preempt_enable();
+	} else {
+		c->freelist = object;
+		local_irq_restore(flags);
+	}
 	return;
 slow:
-	preempt_enable();
+	if (have_arch_cmpxchg())
+		preempt_enable();
 	__slab_free(s, page, x, addr, c->offset);
 }
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
