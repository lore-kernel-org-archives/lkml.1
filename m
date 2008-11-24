Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYKXWrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYKXWrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYKXWrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:47:35 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52370 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbYKXWre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:47:34 -0500
Date: Tue, 25 Nov 2008 00:47:33 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-mm@kvack.org, cl@linux-foundation.org, david@fromorbit.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slab: __GFP_NOWARN not being propagated from
 mempool_alloc()
In-Reply-To: <E1L4jMt-0006OW-5J@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0811250038030.11825@melkki.cs.Helsinki.FI>
References: <E1L4jMt-0006OW-5J@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Miklos Szeredi wrote:
> We see page allocation failure warnings on the mempool_alloc() path.
> See this lkml posting for example:
> 
> http://lkml.org/lkml/2008/10/27/100
> 
> The cause is that on NUMA, alloc_slabmgmt() clears __GFP_NOWARN,
> together with __GFP_THISNODE and __GFP_NORETRY.  But AFAICS it really
> only wants to clear __GFP_THISNODE.
> 
> Does this patch looks good?

Yes, it does but looking at mm/slab.c history I think we want something 
like the following instead. Christoph?

P.S. First one to test it gets a fabulous prize of a Tested-by tag in the 
patch description! How cool is that?

		Pekka

>From 717b2d7bd2398e948d1dfbd2e83bd6a8403b68da Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Tue, 25 Nov 2008 00:33:28 +0200
Subject: [PATCH] slab: remove GFP_THISNODE clearing from alloc_slabmgmt()

Commit 6cb062296f73e74768cca2f3eaf90deac54de02d ("Categorize GFP flags")
left one call-site in alloc_slabmgmt() to clear GFP_THISNODE instead of
GFP_CONSTRAINT_MASK. Unfortunately, that ends up clearing __GFP_NOWARN
and __GFP_NORETRY as well which is not what we want. As the only caller
of alloc_slabmgmt() already clears GFP_CONSTRAINT_MASK before passing
local_flags to it, we can just remove the clearing of GFP_THISNODE.

This patch should fix spurious page allocation failure warnings on the
mempool_alloc() path. See the following URL for an example:

  http://lkml.org/lkml/2008/10/27/100

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 918f04f..98d3024 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2608,7 +2608,7 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
 	if (OFF_SLAB(cachep)) {
 		/* Slab management obj is off-slab. */
 		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
-					      local_flags & ~GFP_THISNODE, nodeid);
+					      local_flags, nodeid);
 		if (!slabp)
 			return NULL;
 	} else {
-- 
1.5.6.4

