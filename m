Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZFYWZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZFYWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 18:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZFYWZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 18:25:41 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39117 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbZFYWZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 18:25:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZHRZIKnYacCfeih1j7Xu9Nyw+ICDLwPyiCjOg3vsZ7o8KsSBFgs7UwcPquq7GC5cj
	tnDi8VBMczetSZPtBoB5Q==
Date: Thu, 25 Jun 2009 15:25:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, arjan@infradead.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <alpine.LFD.2.01.0906251339190.3605@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0906251501110.9974@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
 <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.LFD.2.01.0906251259430.3605@localhost.localdomain> <alpine.LFD.2.01.0906251317570.3605@localhost.localdomain> <alpine.DEB.2.00.0906251332060.3086@chino.kir.corp.google.com>
 <alpine.LFD.2.01.0906251339190.3605@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Linus Torvalds wrote:

> So the reason I tend to like the kind of "incrementally try harder" 
> approaches is two-fold:
> 
>  - it works well for balancing different choices against each other (like 
>    on the freeing path, trying to see which kind of memory is most easily 
>    freed by trying them all first in a "don't try very hard" mode)
> 

If we passed alloc_flags into direct reclaim, we'd be able to know that 
priority in increasing severity: ALLOC_HARDER, ALLOC_HIGH, 
ALLOC_NO_WATERMARKS.  We already know if reclaim should be targeted only 
to the set of allowable nodes with the gfp_mask, so ALLOC_CPUSET is 
already implicitly handled.

The problem with such an approach is that if we were to, as suggested, set 
ALLOC_HARDER for __GFP_WAIT when looping is that we'd soon deplete memory 
reserves for potentially long-lived allocations and each zone's min 
watermark would simply become min / 2.

Setting ALLOC_HARDER when __GFP_WAIT loops would imply that we'd also 
defer the oom killer until we've tried with the lower watermark and that 
would result in less memory being available for the TIF_MEMDIE thread when 
subsequent allocations still fail.

>  - it's great for forcing _everybody_ to do part of the work (ie when some 
>    new thread comes in and tries to allocate, the new thread starts off 
>    with the lower priority, and as such won't steal a page that an older 
>    allocator just freed)
> 

So you're seeing the space between the zone's min watermark, min, and min 
/ 4 (ALLOC_HARDER) as the pool of memory available to older allocators 
that have already done reclaim?  It wouldn't necessarily prevent rt tasks 
from stealing the memory freed by the older allocators, but would stop all 
others.

> And I think that second case is true even for the oom killer case, and 
> even for __GFP_FS.
> 

The oom killer is serialized only on the zonelist and right before it's 
called, we try an allocation with the high watermark to catch parallel oom 
killings.  The oom killer's heuristic for killing preference is one that 
should satisfy all concurrent page allocations on that zonelist, so we 
probably don't need to worry about it.

> So if people worry about oom, I would suggest that we should not think so 
> hard about the GFP_NOFAIL cases (which are relatively small and rare),

If __GFP_NOFAIL is used in the reclaim path, it will loop forever for 
~__GFP_NOMEMALLOC allocations (and the same goes for oom killed tasks).

> or 
> about things like the above "try harder" when repeating model, but instead 
> think about what actually happens during oom: the most common allocations 
> will remain to the page allocations for user faults and/or page cache. In 
> fact, they get *more* common as you near OOM situation, because you get 
> into the whole swap/filemap thrashing situation where you have to re-read 
> the same pages over and over again.
> 
> So don't worry about NOFS. Instead, look at what GFP_USER and GFP_HIGHUSER 
> do. They set the __GFP_HARDWALL bit, and they _always_ check the end 
> result and fail gracefully and quickly when the allocation fails.
> 

Yeah, and the oom killer prefers to kill tasks that share a set of 
allowable __GFP_HARDWALL nodes with current.

> End result? Realistically, I suspect the _best_ thing we can do is to just 
> couple that bit with "we're out of memory", and just do something like
> 
> 	if (!did_some_progress && (gfp_flags & __GFP_HARDWALL))
> 		goto nopage;
> 
> rather than anything else. And I suspect that if we do this, we can then 
> afford to retry very aggressively for the allocation cases that aren't 
> GFP_USER - and that may well be needed in order to make progress.
> 

Agreed.
