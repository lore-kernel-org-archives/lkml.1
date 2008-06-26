Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYFZPuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYFZPuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYFZPtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:49:52 -0400
Received: from gw.goop.org ([64.81.55.164]:48467 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbYFZPtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:49:51 -0400
Message-ID: <4863BA91.2060402@goop.org>
Date: Thu, 26 Jun 2008 08:49:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>	 <20080507073017.GJ32195@elte.hu>	 <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>	 <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>	 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>	 <1214241561.19392.21.camel@elijah.suse.cz>	 <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>	 <1214253593.11254.30.camel@twins>	 <Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com>	 <1214254730.11254.34.camel@twins>  <48630420.1090102@goop.org> <1214463060.3035.12.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1214463060.3035.12.camel@twins.programming.kicks-ass.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Paravirt spinlocks sounds like a good idea anyway, that way you can make
> them scheduling locks (from the host's POV) when the lock owner (vcpu)
> isn't running.
>
> Burning time spinning on !running vcpus seems like a waste to me.
>   

In theory.  But in practice Linux locks are so low-contention that not 
much time seems to get wasted.  I've been doing experiments with 
spin-a-while-then-block locks, but they never got to the -then-block 
part in my test.  The burning cycles spinning only gets expensive if the 
lock-holder vcpu gets preempted, and there's other cpus spinning on that 
lock; but if locks are held only briefly, then there's little chance 
being preempted while holding the lock.

At least that's at the scale I've been testing, with only two cores.  I 
expect things look different with 8 or 16 cores and similarly scaled guests.

> As for the scheduler solving the unfairness that ticket locks solve,
>   

No, I never said scheduler would the problem, merely mitigate it.

> that cannot be done. The ticket lock solves intra-cpu fairness for a
> resource other than time. The cpu scheduler only cares about fairness in
> time, and its intra-cpu fairness is on a larger scale than most spinlock
> hold times - so even if time and the locked resource would overlap it
> wouldn't work.
>
> The simple scenario is running N tasks on N cpus that all pound the same
> lock, cache issues will make it unlikely the lock would migrate away
> from whatever cpu its on, essentially starving all the other N-1 cpus.
>   

Yep.  But in practice, the scheduler will steal the real cpu from under 
the vcpu dominating the lock and upset the pathalogical pattern.  I'm 
not saying its ideal, but the starvation case that ticketlocks solve is 
pretty rare in the large scheme of things.

Also, ticket locks don't help either, if the lock is always 
transitioning between locked->unlocked->locked on all cpus.  It only 
helps in the case of one cpu doing rapid lock->unlock transitions while 
others wait on the lock.

> Ticket locks solve that exact issue, all the scheduler can do is ensure
> they're all spending an equal amount of time on the cpu, whether that is
> spinning for lock acquisition or getting actual work done is beyond its
> scope.
>   

Yes.  But the problem with ticket locks is that they dictate a 
scheduling order, and if you fail to schedule in that order vast amounts 
of time are wasted.  You can get into this state:

   1. vcpu A takes a lock
   2. vcpu A is preempted, effectively making a 5us lock be held for 30ms
   3. vcpus E,D,C,B try to take the lock in that order
   4. they all spin, wasting time.  bad, but no worse than the old lock
      algorithm
   5. vcpu A eventually runs again and releases the lock
   6. vcpu B runs, spinning until preempted
   7. vcpu C runs, spinning until preempted
   8. vcpu D runs, spinning until preempted
   9. vcpu E runs, and takes the lock and releases it
  10. (repeat spinning on B,C,D until D gets the lock)
  11. (repeat spinning on B,C until C gets the lock)
  12. B finally gets the lock

Steps 6-12 are all caused by ticket locks, and the situation is 
exacerbated by vcpus F-Z trying to get the lock in the meantime while 
its all tangled up handing out tickets in the right order.

The problem is that the old lock-byte locks made no fairness guarantees, 
and interacted badly with the hardware causing severe starvation in some 
cases.  Ticket locks are too fair, and absolutely dictate the order in 
which the lock is taken.  Really, all that's needed is the weaker 
assertion that "when I release the lock, any current spinner should get 
the lock".

    J

