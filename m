Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbZBYRP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbZBYRP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZBYRPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:15:50 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40488 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZBYRPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:15:49 -0500
Date: Wed, 25 Feb 2009 09:08:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, vegard.nossum@gmail.com, stable@kernel.org,
       akpm@linux-foundation.org, npiggin@suse.de, penberg@cs.helsinki.fi
Subject: Re: [PATCH] v4 Teach RCU that idle task is not quiscent state at
	boot
Message-ID: <20090225170825.GC6797@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com> <20090225002937.GA23733@linux.vnet.ibm.com> <20090225141945.GA28455@linux.vnet.ibm.com> <20090225160024.GB12732@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225160024.GB12732@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 05:00:24PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > +/* Internal to kernel, but needed by rcupreempt.h. */
> > +extern int rcu_idle_cpu_truthful;
> 
> The name sucks a bit ;-) 'truthful' is an emotionally laden 
> statement and distracts from the technical purpose when reading 
> it ;)
> 
> Same for:
> 
> > +extern void rcu_idle_now_means_idle(void);

I must confess that I was in fact a bit annoyed to learn that idle_cpu()
telling me that a decidedly active CPU was idle.  And if you think -these-
names are emotionally laden, you should have seen my first choices.  ;-)

Nevertheless, point well taken.  How about the following names instead?

	extern int rcu_scheduler_active;
	extern void rcu_scheduler_starting(void);

> Also, i'm wondering, is there really no way to avoid this quirk. 
> We almost got away without it for a long time.

A bit scary, isn't it?  ;-)

Looks to me that some RCU usage finally found its way into the early
boot code path -- until that happened, no one needed to care what RCU
mistakenly thought was happening with grace periods at early boot.

I list some alternatives below.

> This one:
> 
> >  void rcu_check_callbacks(int cpu, int user)
> >  {
> >  	if (user ||
> > -	    (idle_cpu(cpu) && !in_softirq() &&
> > -				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> > +	    (idle_cpu(cpu) && rcu_idle_cpu_truthful &&
> > +	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> 
> Is a hotpath called very often ...

The "if" statement is indeed on the hotpath, but the additional check
of rcu_idle_cpu_truthful is reached only if we didn't interrupt from
user-mode execution and if the CPU is idle.  So the only time anything
is delayed by this extra check is when we take an interrupt from idle
state, and then that interrupt handler is itself interrupted by the
scheduling-clock interrupt.

And of course, in the CONFIG_NO_HZ case, this code path is normally
disabled entirely for an idle CPU.

This therefore will not result in significant overhead, despite being
in a hotpath.

OK, alternatives...

o	Reverse the roles of the idle and init threads during startup,
	so that there is initially no idle thread.

	However, there appears to be a fair amount of code that assumes
	that there is always an idle thread.

o	As above, but create both the init and idle threads early so
	that there always is an idle thread that happens not to be
	running during boot.

	This would work, but seems to me to be uglier than the flag.

o	Stop using idle_cpu() in rcu_check_callbacks(), instead keeping
	a per-CPU "cpu_is_idle" variable that is set upon entry to the
	various idle() loops and cleared upon exit.  It would be OK to
	take interrupts while "cpu_is_idle" is set.

	The disadvantage here is that there are quite a few idle loops,
	and it would be necessary to change them all.  Missing one or
	two could result in indefinite grace periods on the affected
	systems.

o	Drop idle as a quiescent state, as is already the case for
	rcupreempt.

	This would result in indefinite grace-period delays for
	rcuclassic, but would actually work for rcutree.  Except that
	it would cause rcutree to IPI each and every idle CPU for
	every grace period if !CONFIG_NO_HZ.  I expect that this
	overhead would far exceed that of the extra flag check in
	rcu_check_callbacks().

So I still like the flag check.  Any alternatives that I am missing?

							Thanx, Paul
