Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbYIUVOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbYIUVOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYIUVOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:14:38 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45285 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYIUVOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:14:37 -0400
Date: Sun, 21 Sep 2008 14:14:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
Message-ID: <20080921211416.GA7091@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <48CFE466.8010200@colorfullife.com> <20080916173012.GC6717@linux.vnet.ibm.com> <48CFF150.8070400@colorfullife.com> <48D62B7F.10905@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D62B7F.10905@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 01:09:51PM +0200, Manfred Spraul wrote:
> Hi Paul,
>
> Some further thoughts about design differences between your and my 
> implementation:
>
> - rcutree's qsmaskinit  is the worst-case list of cpus that could be in rcu 
> read side critical sections.
> - rcustate's cpu_total is the accurate list of cpus that could be in rcu 
> read side critical sections.
>
> Both variables are read rarely: for rcu_state, twice per grace period.
>
> rcutree fixes up cpus that are "incorrectly" listed in qsmaskinit with 
> force_quiescent_state(). It forces rcutree to use a cpu bitmask for qsmask 
> and it forces rcutree to store the "done" information in a global 
> structure. Additionately, in the worst case force_quiescent_state() must 
> loop over all cpus.
> rcustate can use per-cpu structures and a global atomic_t. There is no loop 
> over all cpus. That's a big advantage, thus I think it's worth the effort 
> to maintain an accurate list.
> Unfortunately, I don't have an efficient implementation for the accurate 
> list.

That has been one of my biggest questions about your approach, that and
the need to hit holdouts with resched IPI.  (Though perhaps you have
worked out another way around this.)

> Some random ideas:
> - cpu_total is only read rarely. Thus it would be ok if the read operation 
> is expensive [e.g. collect data from multiple cachelines, acquire 
> spinlocks...]

Agreed.  I could use this approach as well, having each CPU set and clear
its qsmaskinit bit on every exit from and entry to dynticks idle state,
but see below...

In your case, you would need to carefully keep state so that a CPU
entering dynticks idle mode would know whether or not it needed to
respond to the current grace period -- but you need this in any case,
so no added complexity as far as I can see.

> - updates to cpu_total happen with every interrupt on an idle system with 
> no_hz.
>    Thus it must be very scalable, preferably per-cpu data.
>    And: Updates are far more frequent than grace periods.

Yep!  Hence my reluctance to add overhead to the dynticks side of the
algorithm.

> - updates to cpu_total happen nearly never without no_hz.
>   Especially: far less frequent than grace periods.

Indeed, this is the easy case for both of our approaches.

> What about adding an "invalid" flag to cpu_total? The "real" data is stored 
> in per-cpu structures.
> - when a cpu enters/leaves nohz, then it invalidates the global cpu_total 
> and updates a per-cpu structure
> - when the state machine needs the number of rcu-tracked cpus, then it 
> checks if the global cpu_total is valid.
> If it's valid, then cpu_total is used directly. Otherwise the per-cpu 
> structures are enumerated and the new value is stored as cpu_total.
>
> What do you think?

I use an analogous algorithm, as the qsinitmask values might change while
setting up for the next quiescent state.  The tough part of this was
correctly handling races between setting up for the quiescent state and
onlining/offlining CPUs (and, in your case, CPUs entering/leaving dynticks
idle mode).  I chose to use a global lock that excludes online/offline
and starting a quiescent state (except in the case where there are so
few CPUs that there is but one rcu_node structure, in which case that
structure's lock suffices, so that onofflock need not be acquired).

But although acquiring a global lock is reasonable for CPU online/offline
(as there can be but one such operation at a time), it would be quite
painful for the dynticks case.

Of course, I might be able to avoid the need for this global lock if I
were willing to acquire the interior-node rcu_node locks when setting
up for the next grace period.  But this would require me to put in a
cleanup step after grace-period setup, as some set of dyntick operations
might otherwise end the grace period before it is fully initialized.
This could potentially result in two different CPUs setting up grace
periods concurrently (yuck!).  Worse yet, the grace period could end
while the initialization was only halfway through the leaves, so that
the CPU doing the initialization would need to recognize this and stop
further initialization -- and, again, clean up (yuck^2!).

Your two-phase approach might (or might not) avoid this issue.

							Thanx, Paul
