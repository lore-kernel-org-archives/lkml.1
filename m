Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbXIDQOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbXIDQOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbXIDQOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:14:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47444 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbXIDQOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:14:21 -0400
Date: Tue, 4 Sep 2007 09:14:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       josh@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Make rcutorture RNG use temporal entropy
Message-ID: <20070904161419.GA11417@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070816024904.GA5312@linux.vnet.ibm.com> <alpine.LFD.0.999.0709041047070.13651@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709041047070.13651@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 11:16:50AM +0530, Satyam Sharma wrote:
> Hi Paul,
> 
> 
> On Wed, 15 Aug 2007, Paul E. McKenney wrote:
> > 
> > The locking used by get_random_bytes() can conflict with the
> > preempt_disable() and synchronize_sched() form of RCU.  This patch changes
> > rcutorture's RNG to gather entropy from the new cpu_clock() interface
> > (relying on interrupts, preemption, daemons, and rcutorture's reader
> > thread's rock-bottom scheduling priority to provide useful entropy),
> > and also adds and EXPORT_SYMBOL_GPL() to make that interface available
> > to GPLed kernel modules such as rcutorture.
> 
> Honestly, rcutorture goes to some amazing lengths just to have this
> randomizing-the-delays-that-read/write-test-threads-spend-inside-or-
> outside-the-critical-sections thing :-) Especially, seeing that
> synchro-test, the other "comparable" module, just doesn't bother with
> all this at all. (especially check out its load == interval == do_sched
> == 0 case! :-)

Yep.  The need for that level of randomization in rcutorture has been made
painfully clear to me over a period of more than a decade.  Of course,
the overhead of the re-seeding does get diluted by a factor of 10,000 or
100,000, depending on what version you are using.  So, from a throughput
standpoint, the overhead is essentially that of a linear congruential
random-number generator.  This is critically important given the low
overhead of rcu_read_lock() and rcu_read_unlock().

Still, this is indeed not what you want on a fastpath of a realtime
system, where average performance means nothing -- only the worst case
counts.  And this is why I am -not- putting the rcutorture RNG forward
for general-purpose use.  So we are at least in agreement on that piece!

And, as you hint below, anyone running rcutorture while also running
a production realtime workload needs to seriously rethink their design.  ;-)
(If you are instead running it to provide a test load for your realtime
testing, fine and good.)

> So IMHO, considering that rcutorture isn't a "serious" user of randomness
> in the first place (of even a "fast-and-loose version" for that matter),
> you could consider a solution where you gather all the randomness you need
> at module_init time itself and save it somewhere, and then use it wherever
> you're calling into rcu_random()->cpu_clock() [ or get_random_bytes() ]
> in the current code. You could even make some trivial updates to those
> random numbers after every RCU_RANDOM_REFRESH uses, like present.

Well, assuming that the Linux kernel really needs a central implementation
of a "pretty fast" and "pretty good" RNG, one could imagine all sorts of
designs:

1.	Use an LCRNG feeding into an array, as the old Berkeley random()
	does (or see Knuth for an earlier citation), but make it per-CPU.
	When pulling out randomness, do an MDn hash on the array
	along with a per-task counter and the per-CPU preempt counter.
	Increment the per-task counter on each use.  Do an LCRNG step
	on each use.  Since this is a fixed array, the collisions in
	CONFIG_PREEMPT due to preemption can be permitted to happen
	without penalty.

	This approach avoids all locking, all interrupt disabling, and
	all preemption disabling.  But the MD hashes aren't the fastest
	things in the kernel, from what I understand.

	Question: will this be fast enough?  If so, which of the MD
	hashes should be used?

2.	As in #1 above, but use some simpler hash, such as addition or
	XOR.  Maybe CRC.  (Benchmark for speed.)

3.	Just use a simple LCRNG with per-task state.  Perturb from some
	statistical counter (the per-CPU RCU grace-period counter might
	be appropriate).  Or don't even bother doing that.

	This would be -much- faster than any of the above, and would
	be deterministic, hence good for realtime use.	LCRNG might not
	satisfy more-demanding users, especially the paranoid ones.

	(This is what you are proposing above, correct?)

4.	Just use LCRNG into a array like Berkeley random(), but replicate
	on a per-CPU basis.  Maybe or maybe not perturb occasionally
	from some statistical counter as in #3 above.

	This would be reasonably fast, and should satisfy most users.
	People needing cryptographically secure RNGs should of course
	stick with get_random_bytes().

	[If I had some blazing reason to implement this -right- -now-,
	this would be the approach I would take.]

5.	Stick with the current situation where people needing fast
	and dirty RNGs roll their own.

> Agreed, anybody running rcutorture isn't really looking for performance,
> but why call get_random_bytes() or cpu_clock() (and the smp_processor_id()
> + irq_save/restore + export_symbol() that goes with it) when it isn't
> _really_ "required" as such ...

Well, that would in fact be why the high-overhead path is taken only
very rarely.

And again, I am -not- putting the rcutorture RNG forward for general use,
as it is a no-go for realtime fastpath use.

Votes for #5 above?  Given the total lack of any sort of response to
Stephan Eranian's proposal last year, might be optimal.  ;-)

							Thanx, Paul
