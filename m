Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbZJNMXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbZJNMXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbZJNMXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:23:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41106 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755656AbZJNMXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:23:46 -0400
Subject: Re: [2.6.32-rc3 kmemleak] WARNING:
	atkernel/lockdep.c:3161check_flags+0xbe/0x180()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <200910142055.HJH56741.FLOFSJOQHtFVMO@I-love.SAKURA.ne.jp>
References: <200910082134.EJD35962.HLFSQVFOOFMJOt@I-love.SAKURA.ne.jp>
	 <1255005738.6715.6.camel@pc1117.cambridge.arm.com>
	 <200910130317.n9D3HTOH055400@www262.sakura.ne.jp>
	 <1255435201.9987.22.camel@pc1117.cambridge.arm.com>
	 <200910140025.CAJ82820.MOtOFOLVFFSHJQ@I-love.SAKURA.ne.jp>
	 <200910142055.HJH56741.FLOFSJOQHtFVMO@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 14 Oct 2009 13:22:52 +0100
Message-Id: <1255522972.15103.8.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2009 12:22:54.0004 (UTC) FILETIME=[0DF8FF40:01CA4CC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 20:55 +0900, Tetsuo Handa wrote:
> Tetsuo Handa wrote:
> > > This is the "DEBUG_LOCKS_WARN_ON(current->softirqs_enabled)" warning.
> > > I'm not sure why this happens but from the trace it seems that kmemleak
> > > is being called recursively via alloc_slabmgmt() which is caused by
> > > kmem_cache_alloc() called from create_object() in kmemleak.c.
> > If what my guess shown below is correct,
> > (object_cache->slabp_cache->flags & SLAB_NOLEAKTRACE) == 0
> > is triggering recursive calls.
> 
> I applied below patch
> 
> --- linux-2.6.32-rc4/mm/slab.c	2009-10-14 16:22:44.962007072 +0900
> +++ linux-2.6.32-rc4-ccs/mm/slab.c	2009-10-14 16:08:14.000000000 +0900
> @@ -2573,6 +2573,8 @@
>  	struct slab *slabp;
>  
>  	if (OFF_SLAB(cachep)) {
> +		BUG_ON((cachep->flags & SLAB_NOLEAKTRACE) &&
> +		       !(cachep->slabp_cache->flags & SLAB_NOLEAKTRACE));
>  		/* Slab management obj is off-slab. */
>  		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
>  					      local_flags, nodeid);
> 
> and verified that (cachep->slabp_cache->flags & SLAB_NOLEAKTRACE) == 0 is
> triggering recursive call.
> This is not locking related problem. This is stack overflow problem

I was looking at the same code but in my platform, OFF_SLAB(cachep) for
the kmemleak caches is always 0. I only added:

	BUG_ON(cachep->flags & SLAB_NOLEAKTRACE);

and it never triggered but I need to enable more debugging features as
in your .config and re-run.

I assume you haven't modified the kmemleak.c file to increase the
MAX_TRACE size.

I don't think we should add SLAB_NOLEAKTRACE to slabmgmt since in theory
it should work. Is there a slabmgmt allocated for each
kmem_cache_alloc()? If yes, it will indeed get into infinite recursive
calls. If not, kmemleak should be able to cope though in some situations
it may still overflow.

Until I manage to reproduce the problem, could you please try the patch
below:

diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..f8f671b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2263,7 +2263,8 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	 * (bootstrapping cannot cope with offslab caches so don't do
 	 * it too early on.)
 	 */
-	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init)
+	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init &&
+	    !(cachep->flags & SLAB_NOLEAKTRACE))
 		/*
 		 * Size is large, assume best to place the slab management obj
 		 * off-slab (should allow better packing of objs).


Thanks.

-- 
Catalin

