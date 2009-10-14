Return-Path: <linux-kernel-owner+w=401wt.eu-S934034AbZJNO4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbZJNO4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933259AbZJNO4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:56:08 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54666 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932979AbZJNO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:56:08 -0400
Subject: Re: [2.6.32-rc3 kmemleak]
	WARNING:atkernel/lockdep.c:3161check_flags+0xbe/0x180()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <200910142212.IEI69780.MOtQOJHVSLOFFF@I-love.SAKURA.ne.jp>
References: <200910130317.n9D3HTOH055400@www262.sakura.ne.jp>
	 <1255435201.9987.22.camel@pc1117.cambridge.arm.com>
	 <200910140025.CAJ82820.MOtOFOLVFFSHJQ@I-love.SAKURA.ne.jp>
	 <200910142055.HJH56741.FLOFSJOQHtFVMO@I-love.SAKURA.ne.jp>
	 <1255522972.15103.8.camel@pc1117.cambridge.arm.com>
	 <200910142212.IEI69780.MOtQOJHVSLOFFF@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 14 Oct 2009 15:55:13 +0100
Message-Id: <1255532113.15103.36.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2009 14:55:14.0348 (UTC) FILETIME=[560ACEC0:01CA4CDE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 22:12 +0900, Tetsuo Handa wrote:
> Catalin Marinas wrote:
> > Until I manage to reproduce the problem, could you please try the patch
> > below:
> > 
> > diff --git a/mm/slab.c b/mm/slab.c
> > index 7dfa481..f8f671b 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -2263,7 +2263,8 @@ kmem_cache_create (const char *name, size_t size, size_t align,
> >  	 * (bootstrapping cannot cope with offslab caches so don't do
> >  	 * it too early on.)
> >  	 */
> > -	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init)
> > +	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init &&
> > +	    !(cachep->flags & SLAB_NOLEAKTRACE))
> >  		/*
> >  		 * Size is large, assume best to place the slab management obj
> >  		 * off-slab (should allow better packing of objs).
> 
> It is "&& !(flags & SLAB_NOLEAKTRACE)" rather than
> "&& !(cachep->flags & SLAB_NOLEAKTRACE)" because "cachep->flags = flags;" is
> not yet done, isn't it?

Yes, thanks.

> After adding "&& !(flags & SLAB_NOLEAKTRACE)", I got out of memory error later.

Could you check the object_cache->obj_size/buffer_size and
scan_area_cache->obj_size/buffer_size in mm/kmemleak.c? The first
impression is that these somehow are too big when they shouldn't.

>From your .config, you have DEBUG_PAGEALLOC enabled which may set
buffer_size to a full PAGE_SIZE. This size also enables the off slab
mgmt data.

If that's the case, my patch is still correct to avoid the recursive
call but OOM is quite plausible (every object allocated needs another
page for the kmemleak metadata).

> > I don't think we should add SLAB_NOLEAKTRACE to slabmgmt since in theory
> > it should work. Is there a slabmgmt allocated for each
> > kmem_cache_alloc()? If yes, it will indeed get into infinite recursive
> > calls. If not, kmemleak should be able to cope though in some situations
> > it may still overflow.
> 
> Will you tell me how to check it? (Some /proc file?)

Looking at the code, it seems that with off slab mgmt data, it allocates
one slabmgmt object per kmem_cache_alloc() call. The slabp_cache is set
to one of the general cachep which are also used by kmalloc, so we can't
really set SLAB_NOLEAKTRACE on them.

Regards.

-- 
Catalin

