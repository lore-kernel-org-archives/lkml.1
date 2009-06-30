Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZF3HrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZF3HrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZF3HrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:47:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:50350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbZF3HrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:47:17 -0400
Date: Tue, 30 Jun 2009 09:47:17 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090630074717.GA11980@wotan.suse.de>
References: <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org> <20090629153007.GD5065@csn.ul.ie> <alpine.DEB.2.00.0906291625580.17663@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906291625580.17663@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 04:35:26PM -0700, David Rientjes wrote:
> On Mon, 29 Jun 2009, Mel Gorman wrote:
> 
> > page-allocator: Ensure that processes that have been OOM killed exit the page allocator
> > 
> > Processes that have been OOM killed set the thread flag TIF_MEMDIE. A
> > process such as this is expected to exit the page allocator but in the
> > event it happens to have set __GFP_NOFAIL, it potentially loops forever.
> > 
> 
> That's not the expected behavior for TIF_MEMDIE, although your patch 
> certainly changes that.
> 
> Your patch is simply doing
> 
> 	if (test_thread_flag(TIF_MEMDIE))
> 		gfp_mask |= __GFP_NORETRY;
> 
> in the slowpath.
> 
> TIF_MEMDIE is supposed to allow allocations to succeed, not automatically 
> fail, so that it can quickly handle its SIGKILL without getting blocked in 
> the exit path seeking more memory.

Yes, it need to just ignore all watermarks, do not reclaim (we've
already decided reclaim will not work at this point), and return a
page if we have one otherwise NULL (unless GFP_NOFAIL is set).

 
> > This patch checks TIF_MEMDIE when deciding whether to loop again in the
> > page allocator. Such a process will now return NULL after direct reclaim
> > and OOM killing have both been considered as options. The potential
> > problem is that a __GFP_NOFAIL allocation can still return failure so
> > callers must still handle getting returned NULL.
> > 
> 
> All __GFP_NOFAIL allocations should ensure that alloc_pages() never 
> returns NULL.  Although it's unfortunate, that's the requirement that 
> callers have been guaranteed and until they are fixed, the page allocator 
> should respect it.

Yes.

Interesting thing is what to do when we have 0 pages left, we are
TIF_MEMDIE, and GFP_NOFAIL is set. Looping will most likely just
deadlock the system. Returning NULL will probably oops caller with
various locks held and then deadlock the system. It really needs to
punt back to the OOM killer so it can select another task. Until
then, maybe a simple panic would be reasonable? (it's *never* going
to hit anyone in practice I'd say, but if it does then a panic
would be better than lockup at least we know what the problem was).

 
> I disagree with this change because it unconditionally fails allocations 
> when a task has been oom killed, a scenario which should be the _highest_ 
> priority for allocations to succeed since it leads to future memory 

That's another interesting point. I do agree with you because that
would restore previous behaviour which got broken. But I wonder if
possibly it would be a better idea to fail all allocations? That
would a) protect reserves more, and b) probably quite likely to
exit the syscall *sooner* than if we try to satisfy all allocations.



