Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZF3IYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZF3IYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZF3IYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:24:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:51527 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZF3IYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:24:15 -0400
Date: Tue, 30 Jun 2009 10:24:15 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090630082415.GC11980@wotan.suse.de>
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org> <20090629153007.GD5065@csn.ul.ie> <alpine.DEB.2.00.0906291625580.17663@chino.kir.corp.google.com> <20090630074717.GA11980@wotan.suse.de> <alpine.DEB.2.00.0906300050530.11018@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906300050530.11018@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 01:13:08AM -0700, David Rientjes wrote:
> On Tue, 30 Jun 2009, Nick Piggin wrote:
> 
> > > That's not the expected behavior for TIF_MEMDIE, although your patch 
> > > certainly changes that.
> > > 
> > > Your patch is simply doing
> > > 
> > > 	if (test_thread_flag(TIF_MEMDIE))
> > > 		gfp_mask |= __GFP_NORETRY;
> > > 
> > > in the slowpath.
> > > 
> > > TIF_MEMDIE is supposed to allow allocations to succeed, not automatically 
> > > fail, so that it can quickly handle its SIGKILL without getting blocked in 
> > > the exit path seeking more memory.
> > 
> > Yes, it need to just ignore all watermarks, do not reclaim (we've
> > already decided reclaim will not work at this point), and return a
> > page if we have one otherwise NULL (unless GFP_NOFAIL is set).
> > 
> 
> Right, there's no sense in looping endlessly for ~__GFP_NOFAIL if 
> allocations continue to fail for a thread with TIF_MEMDIE set.
> 
> TIF_MEMDIE doesn't check any watermarks as opposed to GFP_ATOMIC, which 
> only reduces the min watermark by half, so we can access more memory 
> reserves with TIF_MEMDIE.  Instead of immediately failing an oom killed 
> task's allocation as in Mel's patch, there is a higher liklihood that it 
> will succeed on the next attempt.

Yes. This is how it should have worked prior to Mel's patches, so we
should aim to restore that.

 
> I'd agree with Mel's added check for TIF_MEMDIE upon returning from the 
> oom killer, but only for __GFP_NOMEMALLOC.

NOMEMALLOC indeed should always be kept away from memalloc/memdie
reserves. That's how it should have worked when I added it (but
I may have forgotten TIF_MEMDIE, I can't remember).

 
> > > All __GFP_NOFAIL allocations should ensure that alloc_pages() never 
> > > returns NULL.  Although it's unfortunate, that's the requirement that 
> > > callers have been guaranteed and until they are fixed, the page allocator 
> > > should respect it.
> > 
> > Yes.
> > 
> > Interesting thing is what to do when we have 0 pages left, we are
> > TIF_MEMDIE, and GFP_NOFAIL is set. Looping will most likely just
> > deadlock the system. Returning NULL will probably oops caller with
> > various locks held and then deadlock the system. It really needs to
> > punt back to the OOM killer so it can select another task. Until
> > then, maybe a simple panic would be reasonable? (it's *never* going
> > to hit anyone in practice I'd say, but if it does then a panic
> > would be better than lockup at least we know what the problem was).
> > 
> 
> The oom killer currently is a no-op if any eligible task has TIF_MEMDIE, 
> so this would require adding an oom killer timeout so that if a task fails 
> to exit after a predefined period, TIF_MEMDIE is cleared and the task is 
> marked to no longer be selected (which would require an addition to 
> task_struct) although it may have already completely depleted memory 
> reserves.

It wouldn't have to be a timeout, it could be a call back to the
oom killer.

 
> The best alternative is just to increase min_free_kbytes to ensure that 
> adequate memory reserves (and its partial exemptions allowed by 
> GFP_ATOMIC, ALLOC_HARDER, and PF_MEMALLOC) are sustained for an oom killed 
> task to exit and that we try hard to avoid getting stuck in 
> TASK_UNINTERRUPTIBLE.

Well we're discussing what to do when reserves run out and NOFAIL
is set. So increasing min_free_kbytes is not a valid alternative :)
My vote is a simple panic with a clear message.

 
> > > I disagree with this change because it unconditionally fails allocations 
> > > when a task has been oom killed, a scenario which should be the _highest_ 
> > > priority for allocations to succeed since it leads to future memory 
> > 
> > That's another interesting point. I do agree with you because that
> > would restore previous behaviour which got broken. But I wonder if
> > possibly it would be a better idea to fail all allocations? That
> > would a) protect reserves more, and b) probably quite likely to
> > exit the syscall *sooner* than if we try to satisfy all allocations.
> > 
> 
> You could only fail the single allocation where you triggered the oom 
> killer and you were the task chosen to die, which is what Mel's patch 
> implemented in the first half.  I agree that would protect the memory 
> reserves more.

