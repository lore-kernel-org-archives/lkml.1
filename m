Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZFYIWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZFYIWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZFYIVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:21:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZFYIVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:21:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nX42vZ+1h1c9W6ErhibZVKXBy8OfD2wHFpafzRgwWVXWsEVyqgaxWSDTQtni5Y3ni
	cNdnqa87Wimmj9/MKLe/Q==
Date: Thu, 25 Jun 2009 01:21:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de, Mel Gorman <mel@csn.ul.ie>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090624145615.2ff9e56e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0906250043150.29330@chino.kir.corp.google.com>
References: <20090624080753.4f677847@infradead.org> <20090624094622.d0b0fd82.akpm@linux-foundation.org> <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> <20090624105517.904f93da.akpm@linux-foundation.org> <4A426825.80905@cs.helsinki.fi>
 <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Andrew Morton wrote:

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

It's a justification for the looping for small-order allocations.

We shouldn't actually need to free any pages to oom kill tasks since 
TIF_MEMDIE allows its allocations to ignore each zone's watermarks (and it 
also allows allocations to happen anywhere regardless of cpuset 
restrictions just like GFP_ATOMIC), which will provide more than a "few 
pages" that are already available for the oom killed task to use if each 
zone's min watermark is sanely defined by min_free_kbytes, and that will 
always still be above SWAP_CLUSTER_MAX for highmem.

Those memory reserves are also available for reclaimers, but PF_MEMALLOC 
tasks will never loop in the page allocator because __GFP_NOFAIL is 
ignored in the reclaim path (and understandably so).

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

This would cause the oom killed task to repeatedly call the oom killer to 
free more memory, and it would refuse to act because a task (current) is 
found to have TIF_MEMDIE set in the tasklist scan.  So this would be a 
livelock when there is no memory left (and nothing can be reclaimed), but 
that shouldn't occur with sane watermarks.  The oom killed task will 
immediately enter buffered_rmqueue() for each zone in the zonelist to 
satisy the allocation; it would require this to return NULL every time for 
it to loop endlessly.  As you mentioned, this behavior has changed 
recently so that TIF_MEMDIE threads loop endlessly instead of fail the 
allocation attempt when get_page_from_freelist() fails with no watermarks.  
The old behavior needs to be reinstated.

> - The oom-killed process might be holding locks (typically fs locks).
>   This can cause an arbitrary number of other processes to be blocked.
>   So to get the system unstuck we need the oom-killed process to
>   immediately exit the page allocator, to handle the NULL return and to
>   drop those locks.
> 

There's no advantage to that over allowing the allocation to succeed since 
current now has TIF_MEMDIE, and this is a better result than returning 
NULL for ~__GFP_FS.  When the old behavior of failing allocations when 
ALLOC_NO_WATERMARKS has failed is restored, as you mentioned, this 
livelock will be closed.

> A long time ago, the Suse kernel shipped with a largely (or
> completely?) disabled oom-killer.  It removed the
> retry-small-allocations-for-ever logic and simply returned NULL to the
> caller.  I never really understood what problem/thinking led Andrea to
> do that.
> 

If you disable retries for allocations at or under 
PAGE_ALLOC_COSTLY_ORDER, then the oom killer would have to be disabled 
for ~__GFP_NOFAIL and ~__GFP_REPEAT as well, otherwise it would serve no 
purpose for the benefit of the current context.

If the order is under PAGE_ALLOC_COSTLY_ORDER and try_to_free_pages() 
returned something positive, there's a probability that we'll succeed in 
the subsequent allocation attempts.  If reclaim failed to free anything, 
the oom killer was called (only if the order is at or under 
PAGE_ALLOC_COSTLY_ORDER, the same condition we automatically loop in, and 
there's again a probability that we'll succeed in subsequent allocation 
attempts when that memory is freed as the result of the chosen task 
exiting.

In other words, the only time we wouldn't want to loop in such a case is 
when the oom killer fails to kill any task, which happens when:

 - another task has already been oom killed and hasn't yet exited (if
   this persists, it's an indication of the problem you mentioned earlier
   which should be solved by the min watermark), or

 - there are no eligible tasks left to kill, in which case the machine
   panics (there are only kthreads or everything else is set to
   OOM_DISABLE).
 
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

Right, the allocation should fail if test_thread_flag(TIF_MEMDIE) and 
__alloc_pages_high_priority() has failed.  There's no need to enter 
reclaim since it has already failed to free memory (the only reason it was 
oom killed to begin with) and memory reserves have been fully depleted.
