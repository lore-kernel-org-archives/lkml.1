Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbXCABGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbXCABGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 20:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932881AbXCABGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 20:06:21 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52914 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932879AbXCABGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 20:06:21 -0500
Date: Wed, 28 Feb 2007 17:06:19 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] SLUB The unqueued slab allocator V3
In-Reply-To: <20070228.140022.74750199.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0702281656450.1488@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702281120110.27828@schroedinger.engr.sgi.com>
 <20070228.140022.74750199.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, David Miller wrote:

> Maybe if you managed your individual changes in GIT or similar
> this could be debugged very quickly. :-)

I think once things calm down and the changes become smaller its going 
to be easier. Likely the case with after V4.

> Meanwhile I noticed that your alignment algorithm is different
> than SLAB's.  And I think this is important for the page table
> SLABs that some platforms use.

Ok.
 
> No matter what flags are specified, SLAB gives at least the
> passed in alignment specified in kmem_cache_create().  That
> logic in slab is here:
> 
> 	/* 3) caller mandated alignment */
> 	if (ralign < align) {
> 		ralign = align;
> 	}

Hmmm... Right.
 
> Whereas SLUB uses the CPU cacheline size when the MUSTALIGN
> flag is set.  Architectures do things like:
> 
> 	pgtable_cache = kmem_cache_create("pgtable_cache",
> 					  PAGE_SIZE, PAGE_SIZE,
> 					  SLAB_HWCACHE_ALIGN |
> 					  SLAB_MUST_HWCACHE_ALIGN,
> 					  zero_ctor,
> 					  NULL);
> 
> to get a PAGE_SIZE aligned slab, SLUB doesn't give the same
> behavior SLAB does in this case.

SLUB only supports this by passing through allocations to the page 
allocator since it does not maintain queues. So the above will cause the 
pgtable_cache to use the caches of the page allocator. The queueing effect 
that you get from SLAB is not present in SLUB since it does not provide 
them. If SLUB is to be used this way then we need to have higher order 
page sizes and allocate chunks from the higher order page for the 
pgtable_cache.

There are other ways of doing it. IA64 f.e. uses a linked list to 
accomplish the same avoiding SLAB overhead.

> Arguably SLAB_HWCACHE_ALIGN and SLAB_MUST_HWCACHE_ALIGN should
> not be set here, but SLUBs change in semantics in this area
> could cause similar grief in other areas, an audit is probably
> in order.
> 
> The above example was from sparc64, but x86 does the same thing
> as probably do other platforms which use SLAB for pagetables.

Maybe this will address these concerns?

Index: linux-2.6.21-rc2/mm/slub.c
===================================================================
--- linux-2.6.21-rc2.orig/mm/slub.c	2007-02-28 16:54:23.000000000 -0800
+++ linux-2.6.21-rc2/mm/slub.c	2007-02-28 17:03:54.000000000 -0800
@@ -1229,8 +1229,10 @@ static int calculate_order(int size)
 static unsigned long calculate_alignment(unsigned long flags,
 		unsigned long align)
 {
-	if (flags & (SLAB_MUST_HWCACHE_ALIGN|SLAB_HWCACHE_ALIGN))
+	if (flags & SLAB_HWCACHE_ALIGN)
 		return L1_CACHE_BYTES;
+	if (flags & SLAB_MUST_HWCACHE_ALIGN)
+		return max(align, (unsigned long)L1_CACHE_BYTES);
 
 	if (align < ARCH_SLAB_MINALIGN)
 		return ARCH_SLAB_MINALIGN;
