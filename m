Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbZF3JJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbZF3JJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbZF3JJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:09:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:53040 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZF3JJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:09:36 -0400
Date: Tue, 30 Jun 2009 11:09:36 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090630090936.GC1114@wotan.suse.de>
References: <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org> <20090629153007.GD5065@csn.ul.ie> <alpine.DEB.2.00.0906291625580.17663@chino.kir.corp.google.com> <20090630074717.GA11980@wotan.suse.de> <alpine.DEB.2.00.0906300050530.11018@chino.kir.corp.google.com> <20090630082415.GC11980@wotan.suse.de> <alpine.DEB.2.00.0906300128510.16291@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906300128510.16291@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 01:41:12AM -0700, David Rientjes wrote:
> On Tue, 30 Jun 2009, Nick Piggin wrote:
> 
> > > I'd agree with Mel's added check for TIF_MEMDIE upon returning from the 
> > > oom killer, but only for __GFP_NOMEMALLOC.
> > 
> > NOMEMALLOC indeed should always be kept away from memalloc/memdie
> > reserves. That's how it should have worked when I added it (but
> > I may have forgotten TIF_MEMDIE, I can't remember).
> > 
> 
> Yeah, so if test_thread_flag(TIF_MEMDIE) and __GFP_NOMEMALLOC, then it 
> makes sense to return NULL immediately following the call to the oom 
> killer for !__GFP_NOFAIL since retrying the allocation is pointless 
> (reclaim failed already and TIF_MEMDIE doesn't help us on the next 
> attempt) at that time.

I don't see the importance of calling the oom killer. If a thread
is TIF_MEMDIE, then we should not try to enter reclaim nor try to
call the oom killer. The oom killer has already been activated and
because it has been determined that nothing can be reclaimed...

 
> > > The oom killer currently is a no-op if any eligible task has TIF_MEMDIE, 
> > > so this would require adding an oom killer timeout so that if a task fails 
> > > to exit after a predefined period, TIF_MEMDIE is cleared and the task is 
> > > marked to no longer be selected (which would require an addition to 
> > > task_struct) although it may have already completely depleted memory 
> > > reserves.
> > 
> > It wouldn't have to be a timeout, it could be a call back to the
> > oom killer.
> > 
> 
> Calling the oom killer won't do anything since it will not kill another 
> task while another has TIF_MEMDIE to protect those memory reserves and 
> give the oom killed task a chance to exit.

I don't mean the normal oom-killer path, but another call to say
"this thread got stuck, un-kill me and look for someone else to kill"
or somesuch.

 
> Panicking when a thread with TIF_MEMDIE set cannot find any memory and the 
> allocation is __GFP_NOFAIL makes sense, but only for order 0.

Why only order-0? What would you do at order>0?

