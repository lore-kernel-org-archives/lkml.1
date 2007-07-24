Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbXGXThS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbXGXThS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbXGXThE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:37:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50106 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756841AbXGXThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:37:03 -0400
Date: Tue, 24 Jul 2007 12:36:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERO to GFP_LEVEL_MASK
In-Reply-To: <20070724122542.d4ac734a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707241234460.13653@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins> <20070723112143.GB19437@skynet.ie>
 <1185190711.8197.15.camel@twins> <Pine.LNX.4.64.0707231615310.427@schroedinger.engr.sgi.com>
 <1185256869.8197.27.camel@twins> <Pine.LNX.4.64.0707240007100.3128@schroedinger.engr.sgi.com>
 <1185261894.8197.33.camel@twins> <Pine.LNX.4.64.0707240030110.3295@schroedinger.engr.sgi.com>
 <20070724120751.401bcbcb@schroedinger.engr.sgi.com>
 <20070724122542.d4ac734a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Andrew Morton wrote:

> > __GFP_MOVABLE	The movability of a slab is determined by the
> > 		options specified at kmem_cache_create time. If this is
> > 		specified at kmalloc time then we will have some random
> > 		slabs movable and others not. 
> 
> Yes, they seem inappropriate.  Especially the first two.

The third one would randomize __GFP_MOVABLE allocs from the page allocator 
since one __GFP_MOVABLE alloc may allocate a slab that is then used for 
!__GFP_MOVABLE allocs.

Maybe something like this? Note that we may get into some churn here 
since slab allocations that any of these flags will BUG.



GFP_LEVEL_MASK: Remove __GFP_COLD, __GFP_COMP and __GFPMOVABLE

Add an explanation for the GFP_LEVEL_MASK and remove the flags
that should not be passed through derived allocators.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/include/linux/gfp.h
===================================================================
--- linux-2.6.orig/include/linux/gfp.h	2007-07-24 12:31:04.000000000 -0700
+++ linux-2.6/include/linux/gfp.h	2007-07-24 12:32:50.000000000 -0700
@@ -53,12 +53,15 @@ struct vm_area_struct;
 #define __GFP_BITS_SHIFT 20	/* Room for 20 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
-/* if you forget to add the bitmask here kernel will crash, period */
+/*
+ * GFP_LEVEL_MASK is used to filter out flags to be passed on to the
+ * page allocator in derived allocators such as slab allocators and
+ * vmalloc. It should not contain flags that are to be handled by the
+ * derived allocators themselves.
+ */
 #define GFP_LEVEL_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS| \
-			__GFP_COLD|__GFP_NOWARN|__GFP_REPEAT| \
-			__GFP_NOFAIL|__GFP_NORETRY|__GFP_COMP| \
-			__GFP_NOMEMALLOC|__GFP_HARDWALL|__GFP_THISNODE| \
-			__GFP_MOVABLE)
+		__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|__GFP_NORETRY| \
+		__GFP_NOMEMALLOC|__GFP_HARDWALL|__GFP_THISNODE| __GFP_MOVABLE)
 
 /* This equals 0, but use constants in case they ever change */
 #define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
