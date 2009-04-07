Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbZDGB2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbZDGB2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759591AbZDGB1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:27:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33453 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759624AbZDGB1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:27:48 -0400
Date: Mon, 6 Apr 2009 18:27:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
	when not tracing
Message-ID: <20090407012746.GS6988@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1238916865.7989.212.camel@tropicana> <20090405171146.GK6893@linux.vnet.ibm.com> <alpine.DEB.2.00.0904061155120.4317@gandalf.stny.rr.com> <20090406161527.GD6988@linux.vnet.ibm.com> <alpine.DEB.2.00.0904061529370.4317@gandalf.stny.rr.com> <20090406194417.GA5936@nowhere> <alpine.DEB.2.00.0904061552260.23509@gandalf.stny.rr.com> <20090406201524.GF6988@linux.vnet.ibm.com> <20090406235850.GA20273@linux.vnet.ibm.com> <alpine.DEB.2.00.0904062032160.24008@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904062032160.24008@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 08:34:20PM -0400, Steven Rostedt wrote:
> 
> 
> On Mon, 6 Apr 2009, Paul E. McKenney wrote:
> > 
> > Hmmm...  Do the start_critical_timings() and stop_critical_timings()
> > functions have anything to do with ftrace()?
> 
> Yep.
> 
> > It does not look like I can just bury RCU-idle controls in these
> > functions, given that they are also invoked around call_console_drivers(),
> > but if all the idle loops are surrounded by stop_critical_timings() and
> > start_critical_timings(), that would ease location of all the idle
> > loops.  ;-)
> 
> They are for the irqsoff tracer. Several archs will disable interrupts and 
> call an assembly "halt" type instruction that can be woken up by 
> interrupts. But this skips the irqs off check, and we end up with irqsoff 
> showing the idle loop with huge interrupts off latencies.
> 
> I'm not sure they are included in all archs. They may be.

Not a chance!  :-(

Looks like one can poke into cpu_idle() on all arches, but looks like
I cannot even assume that I can leverage CONFIG_NO_HZ due to the
rcu_needs_cpu() case.  See below for my rough (and almost certainly
erroneous) notes thus far.

Thoughts?

						Thanx, Paul

------------------------------------------------------------------------

o	Have rcu_idle() call from spinning idle loops.  This would
	invoke rcu_qsctr_inc() and rcu_bh_qsctr_inc().

	In this case, rcu_check_callbacks() need only check for
	interrupt from user-level code.

o	But this won't work for idle loops that yield to a hypervisor
	without being in nohz node.  For these, do rcu_idle_start()
	before the yield and rcu_idle_end() after the yield.  These
	would manipulate a per-CPU variable.

	In this case, rcu_check_callbacks() needs to check for:

	a.	interrupt from user-level code

	b.	unnested interrupt while under the influence of
		rcu_idle_start().

o	Put rcu_idle_start() after stop_critical_timings() and put
	rcu_idle_end() before start_critical_timings() in each arch's
	idle loop.  But maybe pick less confusing names...

	o	powerpc: looks OK.

	o	s390: looks OK -- always dyntick.

	o	Super-H: Looks OK -- always dyntick.

	o	x86 32-bit: Looks OK.  This is cpu_idle() in
		arch/x86/kernel/process_32.c.

	o	x86 64-bit: Looks OK.

	o	ACPI: Looks OK.

	o	x86 APM: invokes system default idle, so OK if that is OK.

	o	x86: default_idle() in arch/x86/kernel/process.c
		need rcu_idle_start() and rcu_idle_end(), or ensure
		that caller always does the right thing???

	o	cpuidle_idle_call() in drivers/cpuidle/cpuidle.c
		needs rcu_idle_start() and rcu_idle_end()???

	o	ARM: Looks OK -- always dyntick.  See cpu_idle() in
		arch/arm/kernel/process.c.

	o	Blackfin: Looks OK -- always dyntick. see cpu_idle() in
		arch/blackfin/kernel/process.c.

	o	Cris:  ???  cpu_idle() in arch/cris/kernel/process.c
		has strange comment:

			* Mark this as an RCU critical section so that
			* synchronize_kernel() in the unload path waits
			* for our completion.

		Ain't gonna happen...

		But looks like we need an rcu_start_idle() and an
		rcu_stop_idle() around the call to idle().

	o	H8300: cpu_idle() in arch/h8300/kernel/process.c.

		Need an rcu_start_idle() and an rcu_stop_idle() around
		the call to idle().  Hopefully not messing too much with
		the exit latency.

	o	IA64: cpu_idle() in arch/ia64/kernel/process.c.

		Need an rcu_start_idle() and an rcu_stop_idle() around
		the call to idle().  Not sure how far around...

	o	M68k: cpu_idle() in arch/m68k/kernel/process.c.

		Need an rcu_start_idle() and an rcu_stop_idle() around
		the call to idle().  Hopefully not messing too much with
		the exit latency.

	o	M68Knommu: Ditto, but arch/m68knommu/kernel/process.c.

	o	UM: Looks OK -- always nohz.

	o	M32r: cpu_idle() in arch/m32r/kernel/process.c.

		Need an rcu_start_idle() and an rcu_stop_idle() around
		the call to idle().  Hopefully not messing too much with
		the exit latency.

	o	MN10300: cpu_idle() in arch/mn10300/kernel/process.c.

		Need an rcu_start_idle() and an rcu_stop_idle() around
		the call to idle().  Hopefully not messing too much with
		the exit latency.

	@@@ Need to recheck the "nohz OK" assumption -- might have disabled it.
	Maybe make rcu_idle_start() and rcu_idle_stop() no-ops in case
	of CONFIG_NO_HZ -- but still need rcu_needs_cpu() case to work.
	So follow up on cpu_idle() cases.

o	Idle loops (for posterity's sake):

	o	Generic: default_idle() gets rcu_idle().

	o	Power:  All invoked from cpu_idle(), which already contains
		stop_critical_timings() and start_critical_timings().

		o	44x: ppc44x_idle() absolutely unclear.

		o	powermac: power4_idle() is assembly code???

			Appears to need a call to rcu_idle() in
			the loop headed by label 1b:.

		o	maple: same as powermac.

		o	pseries: pSeries_setup_arch()

			o	pseries_shared_idle_sleep()
				needs rcu_idle_start() and
				rcu_idle_end() surrounding
				the cede_processor() call.

			o	pseries_dedicated_idle_sleep()
				needs rcu_idle_start() and
				rcu_idle_end() surrounding
				the cede_processor() call.
				Might also need rcu_idle() in
				the "while" loop...

		o	iseries: iSeries_setup_arch()

			o	iseries_shared_idle() seems to need
				rcu_idle_start() and rcu_idle_end()
				surrounding yield_shared_processor()
				call.

			o	iseries_dedicated_idle() needs no
				action, as it forces nohz.  ;-)

		o	pasemi: modes[] array in platforms/pasemi/idle.c

			o	idle_spin() assembly function, need
				call to rcu_idle() in loop headed by
				label 1:.
