Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbXGCQbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbXGCQbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbXGCQbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:31:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39581 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756013AbXGCQbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:31:06 -0400
Date: Tue, 3 Jul 2007 09:31:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andre Noll <maan@systemlinux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.22-rc7
In-Reply-To: <alpine.LFD.0.98.0707030908390.9434@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707030921400.4810@schroedinger.engr.sgi.com>
References: <alpine.LFD.0.98.0707011427380.1172@woody.linux-foundation.org>
 <20070703155519.GY22589@skl-net.de> <alpine.LFD.0.98.0707030908390.9434@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Linus Torvalds wrote:

> > There seems to be a locking problem:
> 
> Ok, I _think_ this is actually ok, and the lock validator is unhappy just 
> because we don't disable irq's when initializing the slab, so the fact 
> that we take the list_lock with interrupts enabled looks scary.

Yes it is okay since no one else can use the slab at this point.

> But the reason it seems to be ok is that it doesn't matter if interrupts 
> are enabled or not, because nobody can *get* to the list_lock, since the 
> thing hasn't been fully set up yet. So no interrupts will try to take the 
> lock (and cause any deadlocks) anyway.

Right.

> However, it might be worth avoiding the warning, even if it seems bogus in 
> this case. Christoph? Do you agree with the analysis? And the patch might 
> be as simple as changing early_kmem_cache_node_alloc() to enable 
> interrupts at the _end_ of the function, rather than immediately after 
> calling new_slab().

new_slab() enables and disables interrupts during usual operations. During 
bootstrap interrupts are enabled and so new_slab() falsely disables 
interrupts when we do the alloc by hand thing in early_kmem_cache_node_alloc
for NUMA. We need to enable interrupts there since otherwise boot will 
continue with interrupts disabled.

> Andre, does that simple change fix it for you (move the 
> "local_irq_enable()" to the end of early_kmem_cache_node_alloc)?

Yes that should make the lock checker happy since interrupts are disabled 
when calling add_partial(). local_irq_enable can be called later without a 
problem. Useless longer interrupt hold off though.



SLUB: Make lockdep happy by not calling add_partial with interrupts 
enabled during bootstrap

If we move the local_irq_enable() to the end of the function then
add_partial() in early_kmem_cache_node_alloc() will be called
with interrupts disabled like during regular operations.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-07-03 09:27:00.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-07-03 09:27:45.000000000 -0700
@@ -1798,8 +1798,6 @@ static struct kmem_cache_node * __init e
 	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
 
 	page = new_slab(kmalloc_caches, gfpflags | GFP_THISNODE, node);
-	/* new_slab() disables interupts */
-	local_irq_enable();
 
 	BUG_ON(!page);
 	n = page->freelist;
@@ -1811,6 +1809,12 @@ static struct kmem_cache_node * __init e
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
 	add_partial(n, page);
+
+	/*
+	 * new_slab() disables interupts. If we do not reenable interrupts here
+	 * then bootup would continue with interrupts disabled.
+	 */
+	local_irq_enable();
 	return n;
 }
 



