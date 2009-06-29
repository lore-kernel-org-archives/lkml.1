Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbZF2Pan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbZF2Pan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760104AbZF2PaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:30:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46091 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760088AbZF2PaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:30:06 -0400
Date: Mon, 29 Jun 2009 16:30:07 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de,
       David Rientjes <rientjes@google.com>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090629153007.GD5065@csn.ul.ie>
References: <4A426825.80905@cs.helsinki.fi> <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090624145615.2ff9e56e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 02:56:15PM -0700, Andrew Morton wrote:
> On Wed, 24 Jun 2009 13:13:48 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > On Wed, 24 Jun 2009, Andrew Morton wrote:
> > > 
> > > If the caller gets oom-killed, the allocation attempt fails.  Callers need
> > > to handle that.
> > 
> > I actually disagree. I think we should just admit that we can always free 
> > up enough space to get a few pages, in order to then oom-kill things.
> 
> I'm unclear on precisely what you're proposing here?
> 

As order <= PAGE_ALLOC_COSTLY_ORDER implies __GFP_NOFAIL, prehaps it
makes sense to change the check to

WARN_ON_ONCE(order > PAGE_ALLOC_COSTLY_ORDER)

? The temptation might be there to remove __GFP_NOFAIL for smaller orders but
it makes sense to have it available in case CONFIG_FAULT_INJECTION_DEBUG_FS
is set and randomly failing allocations that have serious consequences even
if handled.

> > This is not a new concept. oom has never been "immediately kill".
> 
> Well, it has been immediate for a long time.  A couple of reasons which
> I can recall:
> 
> - A page-allocating process will oom-kill another process in the
>   expectation that the killing will free up some memory.  If the
>   oom-killed process remains stuck in the page allocator, that doesn't
>   work.
> 
> - The oom-killed process might be holding locks (typically fs locks).
>   This can cause an arbitrary number of other processes to be blocked.
>   So to get the system unstuck we need the oom-killed process to
>   immediately exit the page allocator, to handle the NULL return and to
>   drop those locks.
> 
> There may be other reasons - it was all a long time ago, and I've never
> personally hacked on the oom-killer much and I never get oom-killed. 
> But given the amount of development work which goes on in there, some
> people must be getting massacred.
> 
> 
> A long time ago, the Suse kernel shipped with a largely (or
> completely?) disabled oom-killer.  It removed the
> retry-small-allocations-for-ever logic and simply returned NULL to the
> caller.  I never really understood what problem/thinking led Andrea to
> do that.
> 
> 
> But it's all a bit moot at present, as we seem to have removed the
> return-NULL-if-TIF_MEMDIE logic in Mel's post-2.6.30 merges.  I think
> that was an accident:
> 
> -	/* This allocation should allow future memory freeing. */
> -
>  rebalance:
> -	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
> -			&& !in_interrupt()) {
> -		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
> -nofail_alloc:
> -			/* go through the zonelist yet again, ignoring mins */
> -			page = get_page_from_freelist(gfp_mask, nodemask, order,
> -				zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
> -			if (page)
> -				goto got_pg;
> -			if (gfp_mask & __GFP_NOFAIL) {
> -				congestion_wait(WRITE, HZ/50);
> -				goto nofail_alloc;
> -			}
> -		}
> -		goto nopage;
> +	/* Allocate without watermarks if the context allows */
> +	if (alloc_flags & ALLOC_NO_WATERMARKS) {
> +		page = __alloc_pages_high_priority(gfp_mask, order,
> +				zonelist, high_zoneidx, nodemask,
> +				preferred_zone, migratetype);
> +		if (page)
> +			goto got_pg;
>  	}
> 
> Offending commit 341ce06 handled the PF_MEMALLOC case but forgot about
> the TIF_MEMDIE case.
> 
> Mel is having a bit of downtime at present.

I'm getting back online now and playing catch-up. You're right in that
TIF_MEMDIE returning NULL has been broken and it's possible in theory for an
OOM-killed process to loop forever. But maybe TIF_MEMDIE looping potentially
forever is expected in the case __GFP_NOFAIL is specified. Fixing this to allow
an OOM-killed process to exit does mean that callers using __GFP_NOFAIL must
still handle NULL being returned which might be very unexpected to the caller.

In 2.6.30, TIF_MEMDIE could cause a request to exit without ever entering
direct reclaim but chances are this didn't happen as it would have been
looping during an OOM-kill. To duplicate this, a check for TIF_MEMDIE would
happen after

	/* Avoid recursion of direct reclaim */
        if (p->flags & PF_MEMALLOC)
                goto nopage;

But as failing __GFP_NOFAIL is potentially serious, even for processes that
have been OOM killed, I think it makes more sense to check for TIF_MEMDIE
after direct reclaim and OOM killing have already been considered as options
with a patch such as the following?

==== CUT HERE ====
page-allocator: Ensure that processes that have been OOM killed exit the page allocator

Processes that have been OOM killed set the thread flag TIF_MEMDIE. A
process such as this is expected to exit the page allocator but in the
event it happens to have set __GFP_NOFAIL, it potentially loops forever.

This patch checks TIF_MEMDIE when deciding whether to loop again in the
page allocator. Such a process will now return NULL after direct reclaim
and OOM killing have both been considered as options. The potential
problem is that a __GFP_NOFAIL allocation can still return failure so
callers must still handle getting returned NULL.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5d714f8..8449cf9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1539,6 +1539,10 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 	if (gfp_mask & __GFP_NORETRY)
 		return 0;
 
+	/* Do not loop if this process has been OOM-killed */
+	if (test_thread_flag(TIF_MEMDIE))
+		return 0;
+
 	/*
 	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
 	 * means __GFP_NOFAIL, but that may not be true in other
@@ -1823,6 +1827,10 @@ rebalance:
 						!(gfp_mask & __GFP_NOFAIL))
 				goto nopage;
 
+			/* Do not loop if this process has been OOM-killed */
+			if (test_thread_flag(TIF_MEMDIE))
+				goto nopage;
+
 			goto restart;
 		}
 	}
