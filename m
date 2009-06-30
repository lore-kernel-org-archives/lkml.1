Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZF3Tr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZF3Tr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZF3Tru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:47:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZF3Trt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:47:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SRVdLGQfvv+5OFZg1PVFzBT7UmDFfPtZ2dxNS2Xdokqx2Dvt7Ik7KxyD9+DAwh2YY
	SXzN2chvnvyyd8NKsI5sQ==
Date: Tue, 30 Jun 2009 12:47:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090630090936.GC1114@wotan.suse.de>
Message-ID: <alpine.DEB.2.00.0906301236320.16312@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org> <20090629153007.GD5065@csn.ul.ie>
 <alpine.DEB.2.00.0906291625580.17663@chino.kir.corp.google.com> <20090630074717.GA11980@wotan.suse.de> <alpine.DEB.2.00.0906300050530.11018@chino.kir.corp.google.com> <20090630082415.GC11980@wotan.suse.de> <alpine.DEB.2.00.0906300128510.16291@chino.kir.corp.google.com>
 <20090630090936.GC1114@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Nick Piggin wrote:

> > Yeah, so if test_thread_flag(TIF_MEMDIE) and __GFP_NOMEMALLOC, then it 
> > makes sense to return NULL immediately following the call to the oom 
> > killer for !__GFP_NOFAIL since retrying the allocation is pointless 
> > (reclaim failed already and TIF_MEMDIE doesn't help us on the next 
> > attempt) at that time.
> 
> I don't see the importance of calling the oom killer. If a thread
> is TIF_MEMDIE, then we should not try to enter reclaim nor try to
> call the oom killer. The oom killer has already been activated and
> because it has been determined that nothing can be reclaimed...
> 

Right, there's no need to call it a second time.  I was referring to the 
initial call that set_tsk_thread_flag(current, TIF_MEMDIE).  When we 
return to the page allocator from the oom killer, there's no sense in 
retrying for __GFP_NOMEMALLOC and !__GFP_NOFAIL since it can't use memory 
reserves anyway.

That doesn't mean the oom killer shouldn't kill current when 
__GFP_NOMEMALLOC, though, because it can use memory reserves along the 
exit path.

> > Calling the oom killer won't do anything since it will not kill another 
> > task while another has TIF_MEMDIE to protect those memory reserves and 
> > give the oom killed task a chance to exit.
> 
> I don't mean the normal oom-killer path, but another call to say
> "this thread got stuck, un-kill me and look for someone else to kill"
> or somesuch.
> 

Right, and my suggestion for doing that was an oom killer timeout as the 
threshold for determining when a thread is "stuck," because usually that 
means it's blocked in TASK_UNINTERRUPTIBLE, not because memory reserves 
are empty.  I'd be interested in alternative approaches other than a 
timeout that determine when another task should be killed.

It's always possible that a "stuck" task has fully depleted memory 
reserves and no forward progress will be made by anybody, so this is a 
very bad situation to begin with.

> > Panicking when a thread with TIF_MEMDIE set cannot find any memory and the 
> > allocation is __GFP_NOFAIL makes sense, but only for order 0.
> 
> Why only order-0? What would you do at order>0?
> 

For order > 0, it'd need to loop forever like it currently does for 
__GFP_NOFAIL in __alloc_pages_high_priority().  It's possible that an 
allocation will eventually succeed if another task frees memory because 
its allocation succeeded (not as the result of memory being totally 
unavailable, but rather fragmented enough to prevent the TIF_MEMDIE task 
from succeeding for order > 0).

We'd also need to consider whether the allocation is constrained to 
lowmem, in which case the panic would be premature.
