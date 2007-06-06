Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbXFFHJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbXFFHJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXFFHJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:09:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43649 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbXFFHJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:09:20 -0400
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
	globally
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@engr.sgi.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.99.0706052334280.30783@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
	 <1181110846.7348.154.camel@twins>
	 <alpine.DEB.0.99.0706052334280.30783@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 09:09:13 +0200
Message-Id: <1181113753.7348.164.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 23:42 -0700, David Rientjes wrote:
> On Wed, 6 Jun 2007, Peter Zijlstra wrote:
> 
> > > diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> > > --- a/kernel/cpuset.c
> > > +++ b/kernel/cpuset.c
> > > @@ -2431,12 +2431,6 @@ int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
> > >  	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
> > >  	if (node_isset(node, current->mems_allowed))
> > >  		return 1;
> > > -	/*
> > > -	 * Allow tasks that have access to memory reserves because they have
> > > -	 * been OOM killed to get memory anywhere.
> > > -	 */
> > > -	if (unlikely(test_thread_flag(TIF_MEMDIE)))
> > > -		return 1;
> > >  	if (gfp_mask & __GFP_HARDWALL)	/* If hardwall request, stop here */
> > >  		return 0;
> > >  
> > 
> > This seems a little pointless, since cpuset_zone_allowed_softwall() is
> > only effective with ALLOC_CPUSET, and the ALLOC_NO_WATERMARKS
> > allocations opened up by TIF_MEMDIE don't use that.
> > 
> 
> That's the change.  Memory reserves on a per-zone level would now be used 
> with respect to ALLOC_NO_WATERMARKS because TIF_MEMDIE tasks no longer 
> have an explicit bypass for them.  If the node is not in the task's 
> mems_allowed and it's a __GFP_HARDWALL allocation or if it's neither
> PF_EXITING or in the nearest_exclusive_ancestor() of that task's cpuset, 
> then we move on to the next zone in get_page_from_freelist().
> 
> The problem the patch addresses is that, as you mentioned, tasks with 
> TIF_MEMDIE have an explicit bypass over using any memory reserves and can 
> thus, depending on zonelist ordering, allocate first on nodes outside its 
> mems_allowed even in the case of an exclusive cpuset before exhausting its 
> own memory.  That behavior is wrong.

Right, I see your point; however considering that its a system
allocation, and all these constraints get violated by interrupts anyway,
its more of an application container than a strict allocation container.

Are you actually seeing the described behaviour, or just being pedantic
(nothing wrong with that per-se)?

I would actually be bold and make it worse by proposing something like
this, which has the benefit of making the reserve threshold system wide.

---

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1eef614..870a791 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1630,6 +1630,21 @@ rebalance:
 			&& !in_interrupt()) {
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 nofail_alloc:
+			/*
+			 * break out of mempolicy boundaries
+			 */
+			zonelist = NODE_DATA(numa_node_id())->node_zonelists +
+				gfp_zone(gfp_mask);
+
+			/*
+			 * Before going bare metal, try to get a page above the
+			 * critical threshold - ignoring CPU sets.
+			 */
+			page = get_page_from_freelist(gfp_mask, order, zonelist,
+					ALLOC_MIN|ALLOC_HIGH|ALLOC_HARDER);
+			if (page)
+				goto got_pg;
+
 			/* go through the zonelist yet again, ignoring mins */
 			page = get_page_from_freelist(gfp_mask, order,
 				zonelist, ALLOC_NO_WATERMARKS);


