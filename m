Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZBPWvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZBPWvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZBPWvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:51:11 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50052 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbZBPWvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:51:10 -0500
Date: Mon, 16 Feb 2009 14:51:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Damien Wyart <damien.wyart@free.fr>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090216225108.GA15904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090216084223.GA2641@localhost.localdomain> <20090216095059.GL6182@elte.hu> <87hc2u61e9.fsf@free.fr> <20090216122632.GA3158@elte.hu> <87ljs6pmao.fsf@free.fr> <20090216132151.GA17996@elte.hu> <20090216160613.GA6785@linux.vnet.ibm.com> <20090216185616.GB6785@linux.vnet.ibm.com> <20090216200923.GA28938@elte.hu> <20090216223944.GF6785@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216223944.GF6785@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 02:39:44PM -0800, Paul E. McKenney wrote:
> On Mon, Feb 16, 2009 at 09:09:23PM +0100, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Here the calls to rcu_process_callbacks() are only 75 
> > > microseconds apart, so that this function is consuming more 
> > > than 10% of a CPU.  The strange thing is that I don't see a 
> > > raise_softirq() in between, though perhaps it gets inlined or 
> > > something that makes it invisible to ftrace.
> > 
> > look at the latest trace please, that has even the most inline 
> > raise-softirq method instrumented, so all the raising is 
> > visible.
> 
> Ah, my apologies!  This time looking at:
> 
> http://damien.wyart.free.fr/ksoftirqd_pb/trace_tip_2009.02.16_ksoftirqd_pb_abstime_proc.txt.gz
> 
> 
>   799.521187 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.521371 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.521555 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.521738 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.521934 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.522068 |   1)  ksoftir-2324  |               |                rcu_check_callbacks() {
>   799.522208 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.522392 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.522575 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.522759 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.522956 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.523074 |   1)  ksoftir-2324  |               |                  rcu_check_callbacks() {
>   799.523214 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.523397 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.523579 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.523762 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.523960 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.524079 |   1)  ksoftir-2324  |               |                  rcu_check_callbacks() {
>   799.524220 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.524403 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.524587 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
>   799.524770 |   1)    <idle>-0    |               |  rcu_check_callbacks() {
> [ . . . ]
> 
> Yikes!!!
> 
> Why is rcu_check_callbacks() being invoked so often?  It should be called
> but once per jiffy, and here it is called no less than 22 times in about
> 3.5 milliseconds, meaning one call every 160 microseconds or so.

BTW, the other question I have is "why do we need to call rcu_pending()
and rcu_check_callbacks() from the idle loop of 32-bit x86, especially
given that no other architecture does this?".  Don't get me wrong, it
would be good to get rcutree's rcu_pending() to avoid spuriously saying
that rcu_check_callbacks() should be invoked, so I would still like the
trace with my patch, but...

							Thanx, Paul

> Hmmm...
> 
> Looks like we never return from:
> 
>   799.521142 |   1)    <idle>-0    |          | tick_nohz_stop_sched_tick() {
> 
> Perhaps we are taking an interrupt immediately after the
> local_irq_restore()?  And at 799.521209 deciding to exit nohz mode.
> And then deciding to go back into nohz mode at 799.521326, 117
> microseconds later, after which we re-invoke rcu_check_callbacks(),
> which again raises RCU's softirq.
> 
> And the reason we are invoking rcu_check_callbacks() so often appears
> to be in in arch/x86/kernel/process_32.c cpu_idle() near line 107,
> which explains my failure to reproduce on a 64-bit system:
> 
> 	void cpu_idle(void)
> 	{
> 		int cpu = smp_processor_id();
> 
> 		current_thread_info()->status |= TS_POLLING;
> 
> 		/* endless idle loop with no priority at all */
> 		while (1) {
> 			tick_nohz_stop_sched_tick(1);
> 			while (!need_resched()) {
> 
> 				check_pgt_cache();
> 				rmb();
> 
> 				if (rcu_pending(cpu))
> 					rcu_check_callbacks(cpu, 0);
> 
> 				if (cpu_is_offline(cpu))
> 					play_dead();
> 
> 				local_irq_disable();
> 				__get_cpu_var(irq_stat).idle_timestamp = jiffies;
> 				/* Don't trace irqs off for idle */
> 				stop_critical_timings();
> 				pm_idle();
> 				start_critical_timings();
> 			}
> 			tick_nohz_restart_sched_tick();
> 			preempt_enable_no_resched();
> 			schedule();
> 			preempt_disable();
> 		}
> 	}
> 
> If we go in and out of nohz mode quickly, we will invoke rcu_pending()
> each time.  I would expect rcu_pending() to return 0 most of the time,
> but that apparently isn't the case with treercu...
> 
> What is the easiest way for me to make it easy to trace the return path
> from __rcu_pending()?  Make each return path call an empty function
> located off where the compiler cannot see it, I guess...  Diagnostic
> patch along these lines below.  Frederic, Damien, could you please give
> it a go?  (And of course please let me know if something else is
> needed.)
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  rcupdate.c |   23 +++++++++++++++++++++++
>  rcutree.c  |   31 +++++++++++++++++++++++++------
>  2 files changed, 48 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index d92a76a..42bbf03 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -175,3 +175,26 @@ void __init rcu_init(void)
>  	__rcu_init();
>  }
>  
> +void __rcu_pending_qs_pending(void)
> +{
> +}
> +
> +void __rcu_pending_callbacks_ready(void)
> +{
> +}
> +
> +void __rcu_pending_needs_gp(void)
> +{
> +}
> +
> +void __rcu_pending_new_completed(void)
> +{
> +}
> +
> +void __rcu_pending_new_gp(void)
> +{
> +}
> +
> +void __rcu_pending_fqs(void)
> +{
> +}
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index b2fd602..e2d72c3 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1234,6 +1234,13 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
>  }
>  EXPORT_SYMBOL_GPL(call_rcu_bh);
>  
> +extern void __rcu_pending_qs_pending(void);
> +extern void __rcu_pending_callbacks_ready(void);
> +extern void __rcu_pending_needs_gp(void);
> +extern void __rcu_pending_new_completed(void);
> +extern void __rcu_pending_new_gp(void);
> +extern void __rcu_pending_fqs(void);
> +
>  /*
>   * Check to see if there is any immediate RCU-related work to be done
>   * by the current CPU, for the specified type of RCU, returning 1 if so.
> @@ -1249,30 +1256,42 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
>  	check_cpu_stall(rsp, rdp);
>  
>  	/* Is the RCU core waiting for a quiescent state from this CPU? */
> -	if (rdp->qs_pending)
> +	if (rdp->qs_pending) {
> +		__rcu_pending_qs_pending();
>  		return 1;
> +	}
>  
>  	/* Does this CPU have callbacks ready to invoke? */
> -	if (cpu_has_callbacks_ready_to_invoke(rdp))
> +	if (cpu_has_callbacks_ready_to_invoke(rdp)) {
> +		__rcu_pending_callbacks_ready();
>  		return 1;
> +	}
>  
>  	/* Has RCU gone idle with this CPU needing another grace period? */
> -	if (cpu_needs_another_gp(rsp, rdp))
> +	if (cpu_needs_another_gp(rsp, rdp)) {
> +		__rcu_pending_needs_gp();
>  		return 1;
> +	}
>  
>  	/* Has another RCU grace period completed?  */
> -	if (ACCESS_ONCE(rsp->completed) != rdp->completed) /* outside of lock */
> +	if (ACCESS_ONCE(rsp->completed) != rdp->completed) /* outside of lock */ {
> +		__rcu_pending_new_completed();
>  		return 1;
> +	}
>  
>  	/* Has a new RCU grace period started? */
> -	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) /* outside of lock */
> +	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) /* outside of lock */ {
> +		__rcu_pending_new_gp();
>  		return 1;
> +	}
>  
>  	/* Has an RCU GP gone long enough to send resched IPIs &c? */
>  	if (ACCESS_ONCE(rsp->completed) != ACCESS_ONCE(rsp->gpnum) &&
>  	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0 ||
> -	     (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0))
> +	     (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0)) {
> +		__rcu_pending_fqs();
>  		return 1;
> +	}
>  
>  	/* nothing to do */
>  	return 0;
