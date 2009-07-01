Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZGAKWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZGAKWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZGAKWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:22:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45245 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbZGAKWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:22:17 -0400
Date: Wed, 1 Jul 2009 11:22:18 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, arjan@infradead.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090701102218.GB16355@csn.ul.ie>
References: <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org> <20090629153007.GD5065@csn.ul.ie> <20090629122029.93cdcc39.akpm@linux-foundation.org> <20090630110011.GB17561@csn.ul.ie> <alpine.DEB.2.00.0906301216180.16312@chino.kir.corp.google.com> <20090630203249.GC6689@csn.ul.ie> <alpine.DEB.2.00.0906301339290.22084@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906301339290.22084@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 01:51:07PM -0700, David Rientjes wrote:
> On Tue, 30 Jun 2009, Mel Gorman wrote:
> 
> > > This will panic the machine if current is the only user thread running or 
> > > eligible for oom kill (all others could have mm's with OOM_DISABLE set).  
> > > Currently, such tasks can exit or kthreads can free memory so that the oom 
> > > is recoverable.
> > > 
> > 
> > Good point, would the following be ok instead?
> > 
> > +           if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
> > +                   if (p == current) {
> > +			    chosen = ERR_PTR(-1UL);
> > +                           continue;
> > +                   } else
> > +                           return ERR_PTR(-1UL);
> > 
> 
> Yes, if you wanted to allow multiple threads to have TIF_MEMDIE set.
> 

While it would be possible, I'm thinking that it would be unlikely for
multiple TIF_MEMDIE processes to exist like this unless they were all
__GFP_NOFAIL. For a second thread to be set TIF_MEMDIE, one process
needs to OOM-kill, select itself, fail the next allocation and OOM-kill
again. For it to be looping, each thread would also need __GFP_NOFAIL so
while it's possible for multiple threads to get TIF_MEMDIE, it's
exceedingly difficult and the system needs to be in a bad state.

Do you agree that the following hunk makes sense at least?

+       /* Do not loop if OOM-killed unless __GFP_NOFAIL is specified */
+       if (test_thread_flag(TIF_MEMDIE)) {
+               if (gfp_mask & __GFP_NOFAIL)
+                       WARN(1, "Potential infinite loop with __GFP_NOFAIL");
+               else
+                       return 0;
+       }

With that on its own, TIF_MEMDIE processes will exit the page allocator unless
__GFP_NOFAIL set and warn when the potential infinite loop is happening.
In combination with your patch to recalculate alloc_flags after the OOM
killer, I think TIF_MEMDIE would be much closer to behaving sensibly.

Then a patch that addresses potential-infinite-loop-TIF_MEMDIE-__GFP_NOFAIL
can be considered.

> > > The problem with this approach is that it increases the liklihood that 
> > > memory reserves will be totally depleted when several threads are 
> > > competing for them.
> > > 
> > 
> > How so? 
> > 
> 
> We automatically oom kill current if it's PF_EXITING to give it TIF_MEMDIE 
> because we know it's on the exit path, this avoids allowing them to 
> allocate below the min watermark for the allocation that triggered the 
> oom, which could be significant.
> 

Ok, your patch is important for this situation.

> If several threads are ooming at the same time, which happens quite often 
> for non-cpuset and non-memcg constrained ooms (and those not restricted to 
> lowmem), we could now potentially have nr_cpus threads with TIF_MEMDIE set 
> simultaneously, which increases the liklihood that memory reserves will be 
> fully depleted after each allocation that triggered the oom killer now 
> succeeds because of ALLOC_NO_WATERMARKS.  This is somewhat mitigated by 
> the oom killer serialization done on the zonelist, but nothing guarantees 
> that reserves aren't empty before one of the threads has detached its 
> ->mm.
> 

While I think this situation is exceedingly unlikely to occur because of
the required combination of GFP flags and memory pressure, I see your point.

> oom_kill_task() SIGKILLs threads sharing ->mm with different tgid's 
> instead of giving them access to memory reserves specifically to avoid 
> this.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
