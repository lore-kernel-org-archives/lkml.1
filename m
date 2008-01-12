Return-Path: <linux-kernel-owner+w=401wt.eu-S1759001AbYALQzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001AbYALQzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 11:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYALQza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 11:55:30 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36685 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYALQz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 11:55:29 -0500
Date: Sat, 12 Jan 2008 08:55:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin LaHaise <bcrl@kvack.org>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH/RFC] synchronize_rcu(): high latency on idle system
Message-ID: <20080112165526.GB9741@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080112012626.GI28570@kvack.org> <1200129791.7999.5.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200129791.7999.5.camel@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 10:23:11AM +0100, Peter Zijlstra wrote:
> 
> On Fri, 2008-01-11 at 20:26 -0500, Benjamin LaHaise wrote:
> > Hello folks,
> > 
> > I'd like to put the patch below out for comments to see if folks think the 
> > approach is a valid fix to reduce the latency of synchronize_rcu().  The 
> > motivation is that an otherwise idle system takes about 3 ticks per network 
> > interface in unregister_netdev() due to multiple calls to synchronize_rcu(), 
> > which adds up to quite a few seconds for tearing down thousands of 
> > interfaces.  By flushing pending rcu callbacks in the idle loop, the system 
> > makes progress hundreds of times faster.  If this is indeed a sane thing to, 
> > it probably needs to be done for other architectures than x86.  And yes, the 
> > network stack shouldn't call synchronize_rcu() quite so much, but fixing that 
> > is a little more involved.
> 
> So, instead of only relying on the tick to drive the RCU state machine,
> you add the idle loop to it. This seems to make sense, esp because nohz
> is held off until rcu is idle too.
>
> Even though Andi is right in that its not the proper solution to your
> problem, I think its worth doing anyway for the general benefit of RCU.
> 
> But lets ask Paul, he is Mr RCU after all :-)

;-)

At first glance, looks workable!

One concern is how often it gets invoked.  If rcu_check_callbacks()
is invoked too often on lots of idle CPUs, it could degrade system
performance due to contention on the RCU internal locks and due to
cacheline bouncing.  Now, my guess is that the rcu_pending() call
should throttle things nicely, but it would be good to test.  All the
testing ideas thus far have been involved and unlikely to test it well,
for example:

CPU 0: lots of synchronize_rcu() calls.

CPU 1: lots of synchronize_rcu() calls.

CPU 2: idle.

CPU 3: CPU-bound workload.

Compare the rate of progress made by CPU 3 with CPUs 0 and 1 active
or not.  But this would not test much -- the load that CPUs 0, 1, and
2 might be placing on the bus/cache/RCU-locks would not be visible to
CPU 3.  One could cache-thrash between CPU 3 and 4, but this requires
a >=5-CPU system.

Will think on it some more.

> > diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> > index 9663c2a..592f6e4 100644
> > --- a/arch/x86/kernel/process_32.c
> > +++ b/arch/x86/kernel/process_32.c
> > @@ -188,6 +188,9 @@ void cpu_idle(void)
> >  			rmb();
> >  			idle = pm_idle;
> >  
> > +			if (rcu_pending(cpu))
> > +				rcu_check_callbacks(cpu, 0);

Given that it is not legal to have RCU read-side critical sections in
the idle loop, how about the following?

+				rcu_check_callbacks(cpu, 1);

Perhaps also changing the name of rcu_check_callbacks()'s second
parameter from "user" to something like "in_quiescent_state".  Might
speed up grace-period recognition in some cases -- wouldn't need to
wait for the next trip through the scheduler in some cases.

						Thanx, Paul

> > +
> >  			if (!idle)
> >  				idle = default_idle;
> >  
> 
