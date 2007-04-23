Return-Path: <linux-kernel-owner+w=401wt.eu-S1030981AbXDWDWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030981AbXDWDWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030982AbXDWDWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:22:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:60305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030981AbXDWDWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:22:49 -0400
Date: Mon, 23 Apr 2007 05:22:15 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070423032215.GC25162@wotan.suse.de>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423012509.GA25162@wotan.suse.de> <20070423025553.GA10407@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423025553.GA10407@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 04:55:53AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > the biggest user-visible change in -v5 are various interactivity 
> > > improvements (especially under higher load) to fix reported 
> > > regressions, and an improved way of handling nice levels. There's 
> > > also a new sys_sched_yield_to() syscall implementation for i686 and 
> > > x86_64.
> > > 
> > > All known regressions have been fixed. (knock on wood)
> > 
> > I think the granularity is still much too low. Why not increase it to 
> > something more reasonable as a default?
> 
> note that CFS's "granularity" value is not directly comparable to 
> "timeslice length":

Right, but it does introduce the kbuild regression, and as we
discussed, this will be only worse on newer CPUs with bigger
caches or less naturally context switchy workloads.


> > [ Note: while CFS's default preemption granularity is currently set to
> >   5 msecs, this value does not directly transform into timeslices: for 
> >   example two CPU-intense tasks will have effective timeslices of 10 
> >   msecs with this setting. ]
> 
> also, i just checked SD: 0.46 defaults to 8 msecs rr_interval (on 1 CPU 
> systems), which is lower than the 10 msecs effective timeslice length 
> CVS-v5 achieves on two CPU-bound tasks.

This is about an order of magnitude more than the current scheduler, so
I still think it is too small.


> (in -v6 i'll scale the granularity up a bit with the number of CPUs, 
> like SD does. That should get the right result on larger SMP boxes too.)

I don't really like the scaling with SMP thing. The cache effects are
still going to be significant on small systems, and there are lots of
non-desktop users of those (eg. clusters).


> while i agree it's a tad too finegrained still, I agree with Con's 
> choice: rather err on the side of being too finegrained and lose some 
> small amount of throughput on cache-intense workloads like compile jobs, 
> than err on the side of being visibly too choppy for users on the 
> desktop.

So cfs gets too choppy if you make the effective timeslice comparable
to mainline?

My approach is completely the opposite. For testing, I prefer to make
the timeslice as large as possible so any problems or regressions are
really noticable and will be reported; it can be scaled back to be
smaller once those kinks are ironed out.
