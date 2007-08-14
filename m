Return-Path: <linux-kernel-owner+w=401wt.eu-S1765442AbXHNDXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765442AbXHNDXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 23:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXHNDXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 23:23:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:58012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbXHNDXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 23:23:04 -0400
Date: Tue, 14 Aug 2007 05:23:00 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lmbench ctxsw regression with CFS
Message-ID: <20070814032259.GA2908@wotan.suse.de>
References: <alpine.LFD.0.999.0708011922500.3582@woody.linux-foundation.org> <20070802024132.GD15595@wotan.suse.de> <20070802071956.GA23300@elte.hu> <20070802073123.GB16744@wotan.suse.de> <20070802154447.GA13725@elte.hu> <20070803001447.GA14775@wotan.suse.de> <20070804065037.GA30816@elte.hu> <20070806032949.GA16401@wotan.suse.de> <20070813123031.GS23758@kernel.dk> <20070813200038.7fc8a9e6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813200038.7fc8a9e6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 08:00:38PM -0700, Andrew Morton wrote:
> On Mon, 13 Aug 2007 14:30:31 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Mon, Aug 06 2007, Nick Piggin wrote:
> > > > > What CPU did you get these numbers on? Do the indirect calls hurt much 
> > > > > on those without an indirect predictor? (I'll try running some tests).
> > > > 
> > > > it was on an older Athlon64 X2. I never saw indirect calls really 
> > > > hurting on modern x86 CPUs - dont both CPU makers optimize them pretty 
> > > > efficiently? (as long as the target function is always the same - which 
> > > > it is here.)
> > > 
> > > I think a lot of CPUs do. I think ia64 does not. It predicts
> > > based on the contents of a branch target register which has to
> > > be loaded I presume before instructoin fetch reaches the branch.
> > > I don't know if this would hurt or not.
> > 
> > Testing on ia64 showed that the indirect calls in the io scheduler hurt
> > quite a bit, so I'd be surprised if the impact here wasn't an issue
> > there.
> 
> With what workload?  lmbench ctxsw?  Who cares?
> 
> Look, if you're doing 100,000 context switches per second per then *that*
> is your problem.  You suck, and making context switches a bit faster
> doesn't stop you from sucking.  And ten microseconds is a very long time
> indeed.
> 
> Put it this way: if a 50% slowdown in context switch times yields a 5%
> improvement in, say, balancing decisions then it's probably a net win.
> 
> Guys, repeat after me: "context switch is not a fast path".  Take that
> benchmark and set fire to it.

It definitely can be. For workloads that are inherently asynchronous, high
speed networking or disk IO (ie. with event generation significantly outside
the control of the kernel or app), then it can be. Sure, you may just be
switching between the main working thread and idle thread, but in that case a
slowdown in the scheduler will be _more_ pronounced because you don't have to
do as much work to actually switch contexts.

If there was a performance tradeoff involved, then we could think about it,
and you might be right. But this is just a case of "write code to do direct
calls or do indirect calls".

Ken Chen's last ia64 database benchmark I could find says schedule takes
6.5% of the clock cycles, the second highest consumer. Considering the
lengths he was going to shave cycles off other paths, I'd call schedule()
a fastpath. Would be really interesting to rerun that benchmark with CFS.
Is anyone at Intel still doing those tests?

