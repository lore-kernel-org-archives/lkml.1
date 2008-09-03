Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYICPnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYICPnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYICPnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:43:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60902 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYICPnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:43:41 -0400
Date: Wed, 3 Sep 2008 08:42:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org, manfred@colorfullife.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] prevent sparc64 from invoking irq handlers on offline
	CPUs
Message-ID: <20080903154217.GA6807@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080831173349.GA15393@linux.vnet.ibm.com> <20080902.171630.193505044.davem@davemloft.net> <20080903004211.GD6748@linux.vnet.ibm.com> <20080903.022138.31681256.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903.022138.31681256.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 02:21:38AM -0700, David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Tue, 2 Sep 2008 17:42:11 -0700
> 
> > On Tue, Sep 02, 2008 at 05:16:30PM -0700, David Miller wrote:
> > > So I'd like to hold off on this patch until this locking issue is
> > > resolved.
> > 
> > OK, it is your architecture.  But in the meantime, sparc64 can take
> > interrupts on CPUs whose cpu_online_map bits have been cleared.
> 
> Paul, here is how I resolved this in my tree.
> 
> First, I applied a patch that killed that 'call_lock' and replaced
> the accesses with ipi_call_lock() and ipi_call_unlock().
> 
> Then I sed'd up your patch so that it applies properly after that
> change.
> 
> I still think there will be a problem here on sparc64.  I had the
> online map clearing there happening first because the fixup_irqs()
> thing doesn't drain interrupts.  It just makes sure that "device"
> interrupts no longer point at the cpu.  So all new device interrupts
> after fixup_irqs() will not go to the cpu.
> 
> Then we do the:
> 
> 	local_irq_enable();
> 	mdelay(1);
> 	local_irq_disable();
> 
> thing to process any interrupts which were sent while we were
> retargetting the device IRQs.
> 
> I also intended this to drain the cross-call interrupts too, that's
> why I cleared the cpu_online_map() bit before fixup_irqs() and
> the above "enable/disable" sequence runs.
> 
> With your change in there now, IPIs won't get drained and the system
> might get stuck as a result.
> 
> I wonder if it would work if we cleared the cpu_online_map right
> before the "enable/disable" sequence, but after fixup_irqs()?
> 
> Paul, what do you think?

Given that __cpu_disable runs in the context of __stop_machine(), the only
new IPIs will be from irqs being drained out of the current CPU, correct?

Here are the situations I can think of (no doubt betraying my ignorance
of modern processor irq hardware in general and of sparc64 in particular):

o	Pending device irq.  There should be a limited number of these,
	and the fixup_irqs() call prevents any more from appearing.

o	Pending scheduling-clock interrupts.  Does fixup_irqs() turn
	these off as well?  (It does if the scheduling-clock interrupt
	is one of the 0..NR_IRQS irqs.)  On the other hand, leaving
	one of these pending should not be a problem (famous last
	words).

o	Pending IPIs.  There should again be a limited number of these.
	Except that an IPI handler could possibly IPI this CPU, as could
	a device irq handler, I suppose.  (We cannot receive additional
	IPIs from other CPUs, as they are spinning with irqs disabled.)

o	Timer irqs.  Not sure what happens to add_timer() calls from
	a CPU that is going offline.  The hope would be that they get
	queued to some other CPU?

Now, an IPI handler cannot be allowed to send a synchronous IPI to
anyone, because the other CPUs are spinning with irqs disabled until
__cpu_disable() returns.  And in any context, a handler for a synchronous
IPI cannot be allowed to send a synchronous IPI to any set of CPUs that
might include the sender of the currently running handler, as doing so
would result in deadlock.

Therefore, one approach would be for the IPI subsystem to use a
cpu_ipi_map rather than the current cpu_online_map.  The cpu_ipi_map
could be cleared before re-enabling irqs, and then the cpu_online_map
could be cleared after the final disabling of irqs.  Yes, this would
mean that sending IPIs to an online CPU would be disallowed when that
CPU is going offline, but then again you have to be careful when sending
IPIs anyway, especially synchronous IPIs where you spin waiting for a
response.

Another approach would be to assume that any chain of IPI-myself
handlers is finite, and to assume that base-level execution will be
blocked by the resulting irqs until the chain terminates.  Given this
finite-IPI-myself-chain assumption, you by definition would have no IPI
irqs pending when the mdelay(1) returned.

Yes, I can imagine irq hardware that would have many nanoseconds of delay
built in, which would allow the loop to exit with IPIs still pending.
One way of resolving this would be to have a per-CPU IPI-received counter,
and to spin as follows:

	local_irq_enable();
	for (;;) {
		tmp = __get_cpu_var(ipi_received_counter);
		mdelay(1);
		if (tmp == __get_cpu_var(ipi_received_counter)
			break;
	}
	local_irq_disable();
	cpu_clear(cpu, cpu_online_map);

This assumes that the hardware IPI-pending latency is no longer than
however long mdelay(1) spins.

Seem reasonable, or are these cures worse than the disease?

							Thanx, Paul
