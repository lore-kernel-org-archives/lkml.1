Return-Path: <linux-kernel-owner+w=401wt.eu-S1030686AbXDWEGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030686AbXDWEGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 00:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030989AbXDWEGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 00:06:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030686AbXDWEGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 00:06:18 -0400
Date: Mon, 23 Apr 2007 06:06:00 +0200
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
Message-ID: <20070423040600.GD25162@wotan.suse.de>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423012509.GA25162@wotan.suse.de> <20070423025553.GA10407@elte.hu> <20070423032215.GC25162@wotan.suse.de> <20070423034310.GA19845@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423034310.GA19845@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 05:43:10AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > note that CFS's "granularity" value is not directly comparable to 
> > > "timeslice length":
> > 
> > Right, but it does introduce the kbuild regression, [...]
> 
> Note that i increased the granularity from 1msec to 5msecs after your 
> kbuild report, could you perhaps retest kbuild with the default settings 
> of -v5?

I'm looking at mysql again today, but I will try eventually. It was
just a simple kbuild.


> > [...] and as we discussed, this will be only worse on newer CPUs with 
> > bigger caches or less naturally context switchy workloads.
> 
> yeah - but they'll all be quad core, so the SMP timeslice multiplicator 
> should do the trick. Most of the CFS testers use single-CPU systems.

But desktop users could have have quad thread and even 8 thread CPUs
soon, so if the number doesn't work for both then you're in trouble.
It just smells like a hack to scale with CPU numbers.

 
> > > (in -v6 i'll scale the granularity up a bit with the number of CPUs, 
> > > like SD does. That should get the right result on larger SMP boxes 
> > > too.)
> > 
> > I don't really like the scaling with SMP thing. The cache effects are 
> > still going to be significant on small systems, and there are lots of 
> > non-desktop users of those (eg. clusters).
> 
> CFS using clusters will want to tune the granularity up drastically 
> anyway, to 1 second or more, to maximize throughput. I think a small 
> default with a scale-up-on-SMP rule is pretty sane. We'll gather some 
> more kbuild data and see what happens, ok?
> 
> > > while i agree it's a tad too finegrained still, I agree with Con's 
> > > choice: rather err on the side of being too finegrained and lose 
> > > some small amount of throughput on cache-intense workloads like 
> > > compile jobs, than err on the side of being visibly too choppy for 
> > > users on the desktop.
> > 
> > So cfs gets too choppy if you make the effective timeslice comparable 
> > to mainline?
> 
> it doesnt in any test i do, but again, i'm erring on the side of it 
> being more interactive.

I'd start by erring on the side of trying to ensure no obvious
performance regressions like this because that's the easy part. Suppose
everybody finds your scheduler wonderfully interactive, but you can't
make it so with a larger timeslice?

For _real_ desktop systems, sure, erring on the side of being more
interactive is fine. For RFC patches for testing, I really think you
could be taking advantage of the fact that people will give you feedback
on the issue.


