Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYJYOXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYJYOXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYJYOX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:23:29 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40196 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbYJYOX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:23:28 -0400
Date: Sat, 25 Oct 2008 07:23:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timers: Handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly
	from softirq context
Message-ID: <20081025142325.GB8446@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081023215003.GC1480@in.ibm.com> <20081025023303.GD6248@linux.vnet.ibm.com> <20081025045238.GA27934@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025045238.GA27934@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 10:22:38AM +0530, Gautham R Shenoy wrote:
> On Fri, Oct 24, 2008 at 07:33:03PM -0700, Paul E. McKenney wrote:
> > On Fri, Oct 24, 2008 at 03:20:03AM +0530, Gautham R Shenoy wrote:
> > > timers: Handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly from softirq context
> > > 
> > > From: Gautham R Shenoy <ego@in.ibm.com>
> > > 
> > > While migrating the the CB_IRQSAFE_UNLOCKED timers during a cpu-offline,
> > > we queue them on the cb_pending list, so that they won't go
> > > stale.
> > > 
> > > Thus, when the callbacks of the timers run from the softirq context,
> > > they could run into potential deadlocks, since these callbacks
> > > assume that they're running with irq's disabled, thereby annoying
> > > lockdep (see below)!
> > > 
> > > Fix this by emulating hardirq context while running these callbacks from
> > > the hrtimer softirq.
> > 
> > Good catch!!!  One confusion (probably on my part) below.
> 
> Hmm.. Let's see...

Gah!!!

I am so used to seeing sequences of code that disable irqs and then
re-enable them that I misread the original, failing to see that you
were -enabling- irqs and then re-disabling them.  :-/

Never mind!!!  Sorry for the noise...

							Thanx, Paul

> > > diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> > > index cdec83e..60aaad6 100644
> > > --- a/kernel/hrtimer.c
> > > +++ b/kernel/hrtimer.c
> > > @@ -1188,6 +1188,7 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
> > >  		enum hrtimer_restart (*fn)(struct hrtimer *);
> > >  		struct hrtimer *timer;
> > >  		int restart;
> > > +		int emulate_hardirq_ctx = 0;
> > > 
> > >  		timer = list_entry(cpu_base->cb_pending.next,
> > >  				   struct hrtimer, cb_entry);
> > > @@ -1196,12 +1197,26 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
> > >  		timer_stats_account_hrtimer(timer);
> > > 
> > >  		fn = timer->function;
> > > +		/*
> > > +		 * A timer might have been added to the cb_pending list
> > > +		 * when it was migrated during a cpu-offline operation.
> > > +		 * Emulate hardirq context for such timers.
> > > +		 */
> > > +		if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU ||
> > > +		    timer->cb_mode == HRTIMER_CB_IRQSAFE_UNLOCKED)
> > > +			emulate_hardirq_ctx = 1;
> > 
> > Is this the case where we need to emulate a hardirq context?
> Indeed it is.
> 
> > 
> > > +
> > >  		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
> > > -		spin_unlock_irq(&cpu_base->lock); 
>                      ^^^^^^^^^^ ----------------------------------------(A)
> > > +		spin_unlock(&cpu_base->lock);
> > > 
> > > -		restart = fn(timer);
> > > +		if (likely(!emulate_hardirq_ctx)) {
> > 
> > If so, why the "!" above?
> 
> Since this function runs from the HRTIMER_SOFTIRQ, it enables interrupts
> before calling the hrtimer-callback function. This has been the original
> behaviour (see A above)
> 
> We would like to retain this behavior for the normal cases where we
> don't want to emulate hard-irq context.
> So if you see below, all we're doing in the normal case is enabling the
> interrupts before calling the callback in the normal case, and
> keeping the interrupts disabled when we want to emulate the hard-irq case.
> Because HRTIMER_CB_IRQSAFE_UNLOCKED callbacks assume that they run with
> interrupts disabled.
> 
> > 
> > Or am I misinterpreting the name of the variable?
> > 
> > 							Thanx, Paul
> > 
> > > +			local_irq_enable();
> 				  ^^^^^^^^ ----------------------- (B)
> > > +			restart = fn(timer);
> > > +			local_irq_disable();
> > > +		} else
> > > +			restart = fn(timer);
> > > 
> 
> 
> Probably it may appear as though we're doing something special
> for the "!" case, but infact it's the opposite.
> 
> Hmmm, how about the following instead ?
> 
> Thanks and Regards
> gautham.
> 
> --------->
> timers: Handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly from softirq context
> 
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> While migrating the the CB_IRQSAFE_UNLOCKED timers during a cpu-offline,
> we queue them on the cb_pending list, so that they won't go
> stale.
> 
> Thus, when the callbacks of the timers run from the softirq context,
> they could run into potential deadlocks, since these callbacks
> assume that they're running with irq's disabled, thereby annoying
> lockdep!
> 
> Fix this by emulating hardirq context while running these callbacks from
> the hrtimer softirq.
> 
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.27 #2
> --------------------------------
> inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> ksoftirqd/0/4 [HC0[0]:SC1[1]:HE1:SE0] takes:
>  (&rq->lock){++..}, at: [<c011db84>] sched_rt_period_timer+0x9e/0x1fc
> {in-hardirq-W} state was registered at:
>   [<c014103c>] __lock_acquire+0x549/0x121e
>   [<c0107890>] native_sched_clock+0x88/0x99
>   [<c013aa12>] clocksource_get_next+0x39/0x3f
>   [<c0139abc>] update_wall_time+0x616/0x7df
>   [<c0141d6b>] lock_acquire+0x5a/0x74
>   [<c0121724>] scheduler_tick+0x3a/0x18d
>   [<c047ed45>] _spin_lock+0x1c/0x45
>   [<c0121724>] scheduler_tick+0x3a/0x18d
>   [<c0121724>] scheduler_tick+0x3a/0x18d
>   [<c012c436>] update_process_times+0x3a/0x44
>   [<c013c044>] tick_periodic+0x63/0x6d
>   [<c013c062>] tick_handle_periodic+0x14/0x5e
>   [<c010568c>] timer_interrupt+0x44/0x4a
>   [<c0150c9f>] handle_IRQ_event+0x13/0x3d
>   [<c0151c14>] handle_level_irq+0x79/0xbd
>   [<c0105634>] do_IRQ+0x69/0x7d
>   [<c01041e4>] common_interrupt+0x28/0x30
>   [<c047007b>] aac_probe_one+0x1a3/0x3f3
>   [<c047ec2d>] _spin_unlock_irqrestore+0x36/0x39
>   [<c01512b4>] setup_irq+0x1be/0x1f9
>   [<c065d70b>] start_kernel+0x259/0x2c5
>   [<ffffffff>] 0xffffffff
> irq event stamp: 50102
> hardirqs last  enabled at (50102): [<c047ebf4>] _spin_unlock_irq+0x20/0x23
> hardirqs last disabled at (50101): [<c047edc2>] _spin_lock_irq+0xa/0x4b
> softirqs last  enabled at (50088): [<c0128ba6>] do_softirq+0x37/0x4d
> softirqs last disabled at (50099): [<c0128ba6>] do_softirq+0x37/0x4d
> 
> other info that might help us debug this:
> no locks held by ksoftirqd/0/4.
> 
> stack backtrace:
> Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.27 #2
>  [<c013f6cb>] print_usage_bug+0x13e/0x147
>  [<c013fef5>] mark_lock+0x493/0x797
>  [<c01410b1>] __lock_acquire+0x5be/0x121e
>  [<c0141d6b>] lock_acquire+0x5a/0x74
>  [<c011db84>] sched_rt_period_timer+0x9e/0x1fc
>  [<c047ed45>] _spin_lock+0x1c/0x45
>  [<c011db84>] sched_rt_period_timer+0x9e/0x1fc
>  [<c011db84>] sched_rt_period_timer+0x9e/0x1fc
>  [<c01210fd>] finish_task_switch+0x41/0xbd
>  [<c0107890>] native_sched_clock+0x88/0x99
>  [<c011dae6>] sched_rt_period_timer+0x0/0x1fc
>  [<c0136dda>] run_hrtimer_pending+0x54/0xe5
>  [<c011dae6>] sched_rt_period_timer+0x0/0x1fc
>  [<c0128afb>] __do_softirq+0x7b/0xef
>  [<c0128ba6>] do_softirq+0x37/0x4d
>  [<c0128c12>] ksoftirqd+0x56/0xc5
>  [<c0128bbc>] ksoftirqd+0x0/0xc5
>  [<c0134649>] kthread+0x38/0x5d
>  [<c0134611>] kthread+0x0/0x5d
>  [<c0104477>] kernel_thread_helper+0x7/0x10
>  =======================
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> 
>  kernel/hrtimer.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index cdec83e..f49bc14 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1188,6 +1188,7 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
>  		enum hrtimer_restart (*fn)(struct hrtimer *);
>  		struct hrtimer *timer;
>  		int restart;
> +		int emulate_hardirq_ctx = 0;
> 
>  		timer = list_entry(cpu_base->cb_pending.next,
>  				   struct hrtimer, cb_entry);
> @@ -1196,10 +1197,24 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
>  		timer_stats_account_hrtimer(timer);
> 
>  		fn = timer->function;
> +		/*
> +		 * A timer might have been added to the cb_pending list
> +		 * when it was migrated during a cpu-offline operation.
> +		 * Emulate hardirq context for such timers.
> +		 */
> +		if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU ||
> +		    timer->cb_mode == HRTIMER_CB_IRQSAFE_UNLOCKED)
> +			emulate_hardirq_ctx = 1;
> +
>  		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
>  		spin_unlock_irq(&cpu_base->lock);
> 
> -		restart = fn(timer);
> +		if (unlikely(emulate_hardirq_ctx)) {
> +			local_irq_disable();
> +			restart = fn(timer);
> +			local_irq_enable();
> +		} else
> +			restart = fn(timer);
> 
>  		spin_lock_irq(&cpu_base->lock);
> 
> 
> 
> -- 
> Thanks and Regards
> gautham
