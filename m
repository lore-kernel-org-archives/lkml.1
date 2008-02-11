Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbYBKUaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbYBKUaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbYBKUaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:30:05 -0500
Received: from lixom.net ([66.141.50.11]:41705 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbYBKUaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:30:03 -0500
Date: Mon, 11 Feb 2008 14:31:59 -0600
From: Olof Johansson <olof@lixom.net>
To: Mike Galbraith <efault@gmx.de>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
Message-ID: <20080211203159.GA11161@lixom.net>
References: <1202554705.10287.12.camel@homer.simson.net> <20080209114009.GP8953@1wt.eu> <1202564259.4035.18.camel@homer.simson.net> <20080209161957.GA3364@1wt.eu> <20080210052941.GA4731@lixom.net> <20080210061558.GC22137@1wt.eu> <20080210070056.GA6401@lixom.net> <1202717755.21339.65.camel@homer.simson.net> <20080211172648.GA7962@lixom.net> <1202759926.4165.31.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202759926.4165.31.camel@homer.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 08:58:46PM +0100, Mike Galbraith wrote:
> 
> On Mon, 2008-02-11 at 11:26 -0600, Olof Johansson wrote: 
> > On Mon, Feb 11, 2008 at 09:15:55AM +0100, Mike Galbraith wrote:
> > > Piddling around with your testcase, it still looks to me like things
> > > improved considerably in latest greatest git.  Hopefully that means
> > > happiness is in the pipe for the real workload... synthetic load is
> > > definitely happier here as burst is shortened.
> > 
> > The real workload doesn't see much of an improvement. The changes I did
> > when tinkering yesterday seem like they're better at modelling just
> > what's going on with that one.
> 
> So the real application is trying to yield?  If so, you could try
> prodding /proc/sys/kernel/sched_compat_yield.

The real application wasn't using yield, but it also didn't get hung up
on the busy-wait loop, that was a mistake by me on Friday. Practically
all the time of that application was spent in the actual workload
loop. I tried adding a yield at the bottom loop, but it didn't make a
significant difference.

> It shouldn't matter if you yield or not really, that should reduce the
> number of non-work spin cycles wasted awaiting preemption as threads
> execute in series (the problem), and should improve your performance
> numbers, but not beyond single threaded.
> 
> If I plugged a yield into the busy wait, I would expect to see a large
> behavioral difference due to yield implementation changes, but that
> would only be a symptom in this case, no?  Yield should be a noop.

Exactly. It made a big impact on the first testcase from Friday, where
the spin-off thread spent the bulk of the time in the busy-wait loop,
with a very small initial workload loop. Thus the yield passed the cpu
over to the other thread who got a chance to run the small workload,
followed by a quick finish by both of them. The better model spends the
bulk of the time in the first workload loop, so yielding doesn't gain
at all the same amount.

I still added it to rule out that it was a factor in the time
differences.


-Olof
