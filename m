Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbXGKSeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbXGKSeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXGKSdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:33:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48301 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751772AbXGKSdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:33:54 -0400
Date: Wed, 11 Jul 2007 11:33:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <Pine.LNX.4.64.0707112121130.17548@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0707111132520.17222@schroedinger.engr.sgi.com>
References: <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
 <20070709095116.c2ea700f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
 <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
 <4692E8B5.3030404@yahoo.com.au> <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
 <20070710083212.GG11115@waste.org> <Pine.LNX.4.64.0707101836280.7011@schroedinger.engr.sgi.com>
 <20070711020646.GZ11115@waste.org> <Pine.LNX.4.64.0707111104370.14730@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0707112121130.17548@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Pekka J Enberg wrote:

> Hi Christoph,
> 
> On Wed, 11 Jul 2007, Christoph Lameter wrote:
> > Of course you are the maintainer but you only authored a single patch 
> > which was the original submission in all the time that SLOB was in the 
> > tree. I keep having to clean up the allocator that has--according to 
> > Pekka--more memory requirements than SLUB. There is no point in keeping it 
> > around anymore it seems.
> 
> Well, it was a test setup with UML and busybox and didn't have all the 
> SLOB optimizations Nick mentioned, so we shouldn't draw any definite 
> conclusions from it. I couldn't get 2.6.22-rc6-mm1 to compile so I'll try 
> again after Andrew pushes a new release out.

But you did get 2.6.22 to compile it seems.

Here is the fix against 2.6.22-rc6-mm1 again.

---
 mm/slub.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.22-rc6-mm1/mm/slub.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/mm/slub.c	2007-07-06 13:28:57.000000000 -0700
+++ linux-2.6.22-rc6-mm1/mm/slub.c	2007-07-06 13:29:01.000000000 -0700
@@ -1868,7 +1868,9 @@ static void init_kmem_cache_node(struct 
 	atomic_long_set(&n->nr_slabs, 0);
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
+#ifdef CONFIG_SLUB_DEBUG
 	INIT_LIST_HEAD(&n->full);
+#endif
 }
 
 #ifdef CONFIG_NUMA
@@ -1898,8 +1900,10 @@ static struct kmem_cache_node * __init e
 	page->freelist = get_freepointer(kmalloc_caches, n);
 	page->inuse++;
 	kmalloc_caches->node[node] = n;
+#ifdef CONFIG_SLUB_DEBUG
 	init_object(kmalloc_caches, n, 1);
 	init_tracking(kmalloc_caches, n);
+#endif
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
 	add_partial(n, page);
