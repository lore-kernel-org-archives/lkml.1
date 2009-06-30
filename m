Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZF3INo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZF3INo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZF3INS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:13:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:1657 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZF3INM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:13:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GOh0yCnm5Gt9sONh8QT5r47+WYUx4RuCRgdSHqTujfbUnDg1uECOeF3EF8cjTMb9W
	44HU8hA2h2tL5+O1/HFQQ==
Date: Tue, 30 Jun 2009 01:13:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090630074717.GA11980@wotan.suse.de>
Message-ID: <alpine.DEB.2.00.0906300050530.11018@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org> <20090629153007.GD5065@csn.ul.ie>
 <alpine.DEB.2.00.0906291625580.17663@chino.kir.corp.google.com> <20090630074717.GA11980@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Nick Piggin wrote:

> > That's not the expected behavior for TIF_MEMDIE, although your patch 
> > certainly changes that.
> > 
> > Your patch is simply doing
> > 
> > 	if (test_thread_flag(TIF_MEMDIE))
> > 		gfp_mask |= __GFP_NORETRY;
> > 
> > in the slowpath.
> > 
> > TIF_MEMDIE is supposed to allow allocations to succeed, not automatically 
> > fail, so that it can quickly handle its SIGKILL without getting blocked in 
> > the exit path seeking more memory.
> 
> Yes, it need to just ignore all watermarks, do not reclaim (we've
> already decided reclaim will not work at this point), and return a
> page if we have one otherwise NULL (unless GFP_NOFAIL is set).
> 

Right, there's no sense in looping endlessly for ~__GFP_NOFAIL if 
allocations continue to fail for a thread with TIF_MEMDIE set.

TIF_MEMDIE doesn't check any watermarks as opposed to GFP_ATOMIC, which 
only reduces the min watermark by half, so we can access more memory 
reserves with TIF_MEMDIE.  Instead of immediately failing an oom killed 
task's allocation as in Mel's patch, there is a higher liklihood that it 
will succeed on the next attempt.

I'd agree with Mel's added check for TIF_MEMDIE upon returning from the 
oom killer, but only for __GFP_NOMEMALLOC.

> > All __GFP_NOFAIL allocations should ensure that alloc_pages() never 
> > returns NULL.  Although it's unfortunate, that's the requirement that 
> > callers have been guaranteed and until they are fixed, the page allocator 
> > should respect it.
> 
> Yes.
> 
> Interesting thing is what to do when we have 0 pages left, we are
> TIF_MEMDIE, and GFP_NOFAIL is set. Looping will most likely just
> deadlock the system. Returning NULL will probably oops caller with
> various locks held and then deadlock the system. It really needs to
> punt back to the OOM killer so it can select another task. Until
> then, maybe a simple panic would be reasonable? (it's *never* going
> to hit anyone in practice I'd say, but if it does then a panic
> would be better than lockup at least we know what the problem was).
> 

The oom killer currently is a no-op if any eligible task has TIF_MEMDIE, 
so this would require adding an oom killer timeout so that if a task fails 
to exit after a predefined period, TIF_MEMDIE is cleared and the task is 
marked to no longer be selected (which would require an addition to 
task_struct) although it may have already completely depleted memory 
reserves.

The best alternative is just to increase min_free_kbytes to ensure that 
adequate memory reserves (and its partial exemptions allowed by 
GFP_ATOMIC, ALLOC_HARDER, and PF_MEMALLOC) are sustained for an oom killed 
task to exit and that we try hard to avoid getting stuck in 
TASK_UNINTERRUPTIBLE.

> > I disagree with this change because it unconditionally fails allocations 
> > when a task has been oom killed, a scenario which should be the _highest_ 
> > priority for allocations to succeed since it leads to future memory 
> 
> That's another interesting point. I do agree with you because that
> would restore previous behaviour which got broken. But I wonder if
> possibly it would be a better idea to fail all allocations? That
> would a) protect reserves more, and b) probably quite likely to
> exit the syscall *sooner* than if we try to satisfy all allocations.
> 

You could only fail the single allocation where you triggered the oom 
killer and you were the task chosen to die, which is what Mel's patch 
implemented in the first half.  I agree that would protect the memory 
reserves more.
