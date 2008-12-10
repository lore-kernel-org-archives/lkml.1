Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYLJT71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYLJT71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbYLJT7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:59:02 -0500
Received: from waste.org ([66.93.16.53]:41337 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362AbYLJT7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:59:01 -0500
Subject: Re: [PATCH] Do not pass the SLAB flags as GFP in slob
	kmem_cache_create
From: Matt Mackall <mpm@selenic.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20081210193421.GA2215@localhost>
References: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com>
	 <20081210193421.GA2215@localhost>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 13:57:50 -0600
Message-Id: <1228939070.3726.134.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 22:34 +0300, Cyrill Gorcunov wrote:
> [Catalin Marinas - Wed, Dec 10, 2008 at 05:36:33PM +0000]
> | It looks like the kmem_cache_create() function in the slob allocator
> | passes the SLAB flags as GFP flags to the slob_alloc() function. The
> | patch changes this call to pass GFP_KERNEL as the other allocators seem
> | to do.
> | 
> | Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> | Cc: Matt Mackall <mpm@selenic.com>
> | ---
> |  mm/slob.c |    2 +-
> |  1 files changed, 1 insertions(+), 1 deletions(-)
> | 
> | diff --git a/mm/slob.c b/mm/slob.c
> | index ff5a98d..dce9258 100644
> | --- a/mm/slob.c
> | +++ b/mm/slob.c
> | @@ -538,7 +538,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
> |  	struct kmem_cache *c;
> |  
> |  	c = slob_alloc(sizeof(struct kmem_cache),
> | -		flags, ARCH_KMALLOC_MINALIGN, -1);
> | +		GFP_KERNEL, ARCH_KMALLOC_MINALIGN, -1);
> |  
> |  	if (c) {
> |  		c->name = name;
> |
> 
> Hi Catalin,
> 
> this would make the following line in slob_alloc
> 
> 	...
> 	if (unlikely((gfp & __GFP_ZERO) && b))
> 		memset(b, 0, size);
>  	...
> 
> useless. Not sure if it will be good :)

I think that's fine. Notice that this is not the allocation of an
object, but the allocation of a cache descriptor. We save the flags
inside the descriptor so that when the user calls kmem_cache_alloc, we
can pass them along to slob_alloc, where GFP_ZERO can take effect.

So, if we're comfortable with the idea that we can only create caches in
'normal' contexts, then I think the patch is fine.

-- 
Mathematics is the supreme nostalgia of our time.

