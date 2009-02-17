Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbZBQWsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbZBQWsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZBQWs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:48:29 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58131 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZBQWs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:48:28 -0500
Date: Tue, 17 Feb 2009 14:48:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Damien Wyart <damien.wyart@free.fr>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090217224826.GO6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090216122632.GA3158@elte.hu> <87ljs6pmao.fsf@free.fr> <20090216132151.GA17996@elte.hu> <20090216160613.GA6785@linux.vnet.ibm.com> <20090216185616.GB6785@linux.vnet.ibm.com> <20090216200923.GA28938@elte.hu> <20090216223944.GF6785@linux.vnet.ibm.com> <20090217043422.GA5836@nowhere> <20090217151046.GB6761@linux.vnet.ibm.com> <20090217223741.GC5194@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217223741.GC5194@nowhere>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 11:37:42PM +0100, Frederic Weisbecker wrote:
> On Tue, Feb 17, 2009 at 07:10:46AM -0800, Paul E. McKenney wrote:
> > On Tue, Feb 17, 2009 at 05:34:23AM +0100, Frederic Weisbecker wrote:
> > > On Mon, Feb 16, 2009 at 02:39:44PM -0800, Paul E. McKenney wrote:
> > > > On Mon, Feb 16, 2009 at 09:09:23PM +0100, Ingo Molnar wrote:
> > > > > 
> > > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > > > 
> > > > > > Here the calls to rcu_process_callbacks() are only 75 
> > > > > > microseconds apart, so that this function is consuming more 
> > > > > > than 10% of a CPU.  The strange thing is that I don't see a 
> > > > > > raise_softirq() in between, though perhaps it gets inlined or 
> > > > > > something that makes it invisible to ftrace.
> > > > > 
> > > > > look at the latest trace please, that has even the most inline 
> > > > > raise-softirq method instrumented, so all the raising is 
> > > > > visible.
> > > > 
> > > > Ah, my apologies!  This time looking at:
> > > > 
> > > > http://damien.wyart.free.fr/ksoftirqd_pb/trace_tip_2009.02.16_ksoftirqd_pb_abstime_proc.txt.gz
> > > > 
> > > > 
> > > >   799.521187 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.521371 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.521555 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.521738 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.521934 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.522068 |   1)  ksoftir-2324  |               |                rcu_check_callbacks() {
> > > >   799.522208 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.522392 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.522575 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.522759 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.522956 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.523074 |   1)  ksoftir-2324  |               |                  rcu_check_callbacks() {
> > > >   799.523214 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.523397 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.523579 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.523762 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.523960 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.524079 |   1)  ksoftir-2324  |               |                  rcu_check_callbacks() {
> > > >   799.524220 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.524403 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.524587 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > >   799.524770 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> > > > [ . . . ]
> > > > 
> > > > Yikes!!!
> > > > 
> > > > Why is rcu_check_callbacks() being invoked so often?  It should be called
> > > > but once per jiffy, and here it is called no less than 22 times in about
> > > > 3.5 milliseconds, meaning one call every 160 microseconds or so.
> > > > 
> > > > Hmmm...
> > > > 
> > > > Looks like we never return from:
> > > > 
> > > >   799.521142 |   1)    <idle>-0    |          | tick_nohz_stop_sched_tick() {
> > > > 
> > > > Perhaps we are taking an interrupt immediately after the
> > > > local_irq_restore()?  And at 799.521209 deciding to exit nohz mode.
> > > > And then deciding to go back into nohz mode at 799.521326, 117
> > > > microseconds later, after which we re-invoke rcu_check_callbacks(),
> > > > which again raises RCU's softirq.
> > > > 
> > > > And the reason we are invoking rcu_check_callbacks() so often appears
> > > > to be in in arch/x86/kernel/process_32.c cpu_idle() near line 107,
> > > > which explains my failure to reproduce on a 64-bit system:
> > > > 
> > > > 	void cpu_idle(void)
> > > > 	{
> > > > 		int cpu = smp_processor_id();
> > > > 
> > > > 		current_thread_info()->status |= TS_POLLING;
> > > > 
> > > > 		/* endless idle loop with no priority at all */
> > > > 		while (1) {
> > > > 			tick_nohz_stop_sched_tick(1);
> > > > 			while (!need_resched()) {
> > > > 
> > > > 				check_pgt_cache();
> > > > 				rmb();
> > > > 
> > > > 				if (rcu_pending(cpu))
> > > > 					rcu_check_callbacks(cpu, 0);
> > > > 
> > > > 				if (cpu_is_offline(cpu))
> > > > 					play_dead();
> > > > 
> > > > 				local_irq_disable();
> > > > 				__get_cpu_var(irq_stat).idle_timestamp = jiffies;
> > > > 				/* Don't trace irqs off for idle */
> > > > 				stop_critical_timings();
> > > > 				pm_idle();
> > > > 				start_critical_timings();
> > > > 			}
> > > > 			tick_nohz_restart_sched_tick();
> > > > 			preempt_enable_no_resched();
> > > > 			schedule();
> > > > 			preempt_disable();
> > > > 		}
> > > > 	}
> > > > 
> > > > If we go in and out of nohz mode quickly, we will invoke rcu_pending()
> > > > each time.  I would expect rcu_pending() to return 0 most of the time,
> > > > but that apparently isn't the case with treercu...
> > > > 
> > > > What is the easiest way for me to make it easy to trace the return path
> > > > from __rcu_pending()?  Make each return path call an empty function
> > > > located off where the compiler cannot see it, I guess...  Diagnostic
> > > > patch along these lines below.  Frederic, Damien, could you please give
> > > > it a go?  (And of course please let me know if something else is
> > > > needed.)
> > > 
> > > 
> > > No, you don't need that, you can use ftrace_printk, it will generate a C-comment like
> > > inside the functions, ie:
> > > 
> > > __rcu_pending() {
> > > 	 /* pending_qs */
> > > }
> > 
> > Ah!!!  So if I were to put ftrace_printk() calls at strategic points
> > in the RCU code, that would be a good thing?
> > 
> > > I've converted your below patch with ftrace_printks and tested it under an old P2
> > > with rcu_tree and 1000 Hz. I made a trace during an idle state, and well, looks like I'm
> > > lucky :-) 
> > > I guess I successfully reproduced the softirq/rcu overhead.
> > > Please find the below patch to trace the rcu_pending return path, as well as the trace I made.
> > > Sorry, the trace is a bit buggy with sometimes flying orphans C like comments.
> > > When I will have more time, I will fix that.
> > > 
> > > The trace is here http://dl.free.fr/uyWGgCbx4
> > > 
> > > It looks like it mostly returns 1 because of the waiting for quiescent state:
> > > 
> > > $ cat rcutrace | grep "/* pending_none" | wc -l
> > > 221
> > > $ cat rcutrace | grep "/* pending_qs" | wc -l
> > > 248
> > > $ cat rcutrace | grep "/* pending" | wc -l
> > > 469
> > 
> > Hmmm...  This looks like normal behavior.  Though I wonder if
> > rcu_check_callbacks() is recognizing that we are in the idle loop given
> > the large number of "pending_qs" entries.  To that end, would you be
> > willing to try the attached patch (on top of your ftrace_printk() patch)?
> > 
> > Add ftrace_printk() to rcu_check_callbacks() to allow ftrace to
> > determine when RCU has detected a quiescent state due to interrupting
> > from within it.
> 
> Do you still need this trace even if your solution were applied on -tip ?

No, it was my confusion -- I later realized that your data above meant
that the force-quiescent-state code path was not being heavily exercised.
So no need for this trace!

							Thanx, Paul
