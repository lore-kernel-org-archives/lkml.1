Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZCGGEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZCGGEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 01:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbZCGGEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 01:04:22 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33623 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZCGGEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 01:04:20 -0500
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [TIP][RFC 6/7] futex: add requeue_pi calls
Date: Sat, 7 Mar 2009 11:33:45 +0530
User-Agent: KMail/1.9.9
Cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
References: <49AC73A9.4040804@us.ibm.com> <49B00302.5000607@us.ibm.com> <49B07F87.2020808@us.ibm.com>
In-Reply-To: <49B07F87.2020808@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903071133.45672.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009, Darren Hart wrote:
> Darren Hart wrote:
> > Darren Hart wrote:
> >> Darren Hart wrote:
> >>> From: Darren Hart <dvhltc@us.ibm.com>
> >>>
> >>> PI Futexes must have an owner at all times, so the standard
> >>> requeue commands
> >>> aren't sufficient.  The new commands properly manage pi futex
> >>> ownership by
> >>> ensuring a futex with waiters has an owner at all times.  Once
> >>> complete these
> >>> patches will allow glibc to properly handle pi mutexes with
> >>> pthread_condvars.
> >>>
> >>> The approach taken here is to create two new futex op codes:
> >>>
> >>> FUTEX_WAIT_REQUEUE_PI:
> >>> Threads will use this op code to wait on a futex (such as a
> >>> non-pi waitqueue)
> >>> and wake after they have been requeued to a pi futex.  Prior to
> >>> returning to
> >>> userspace, they will take this pi futex (and the underlying
> >>> rt_mutex).
> >>>
> >>> futex_wait_requeue_pi() is currently the result of a high speed
> >>> collision
> >>> between futex_wait and futex_lock_pi (with the first part of
> >>> futex_lock_pi
> >>> being done by futex_requeue_pi_init() on behalf of the waiter).
> >>>
> >>> FUTEX_REQUEUE_PI:
> >>> This call must be used to wake threads waiting with
> >>> FUTEX_WAIT_REQUEUE_PI,
> >>> regardless of how many threads the caller intends to wake or
> >>> requeue. pthread_cond_broadcast should call this with nr_wake=1
> >>> and nr_requeue=-1 (all).
> >>> pthread_cond_signal should call this with nr_wake=1 and
> >>> nr_requeue=0.  The
> >>> reason being we need both callers to get the benefit of the
> >>> futex_requeue_pi_init() routine which will prepare the top_waiter
> >>> (the thread
> >>> to be woken) to take possesion of the pi futex by setting
> >>> FUTEX_WAITERS and
> >>> preparing the futex_q.pi_state.  futex_requeue() also enqueues
> >>> the top_waiter
> >>> on the rt_mutex via rt_mutex_start_proxy_lock(). If
> >>> pthread_cond_signal used
> >>> FUTEX_WAKE, we would have a similar race window where the caller
> >>> can return and
> >>> release the mutex before the waiters can fully wake, potentially
> >>> leaving the
> >>> rt_mutex with waiters but no owner.
> >>>
> >>> We hit a failed paging request running the testcase (7/7) in a
> >>> loop (only takes a few minutes at most to hit on my 8way x86_64
> >>> test machine).  It appears to be the result of splitting
> >>> rt_mutex_slowlock() across two execution contexts by means of
> >>> rt_mutex_start_proxy_lock() and rt_mutex_finish_proxy_lock(). 
> >>> The former calls
> >>> task_blocks_on_rt_mutex() on behalf of the waiting task prior to
> >>> requeuing and waking it by the requeueing thread.  The latter is
> >>> executed upon wakeup by the waiting thread which somehow manages
> >>> to call the new __rt_mutex_slowlock() with waiter->task != NULL
> >>> and still succeed with try_to_take_lock(), this leads to
> >>> corruption of the plists and an eventual failed paging request. 
> >>> See 7/7 for the rather crude testcase that causes this.  Any tips
> >>> on where this race might be occuring are welcome.
>
> <snip>
>
> > I've updated my tracing and can show that
> > rt_mutex_start_proxy_lock() is not setting RT_MUTEX_HAS_WAITERS
> > like it should be:
> >
> > ------------[ cut here ]------------
> > kernel BUG at kernel/rtmutex.c:646!
> > invalid opcode: 0000 [#1] PREEMPT SMP
> > last sysfs file:
> > /sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host0/port-0:
> > 0/end_device-0:0/target0:0:0/0:0:0:0/vendor
> > Dumping ftrace buffer:
> > ---------------------------------
> >   <...>-3793    1d..3 558351872us : lookup_pi_state: allocating a
> > new pi state
> >   <...>-3793    1d..3 558351876us : lookup_pi_state: initial
> > rt_mutex owner: ffff88023d9486c0
> >   <...>-3793    1...2 558351877us : futex_requeue:
> > futex_lock_pi_atomic returned: 0
> >   <...>-3793    1...2 558351877us : futex_requeue:
> > futex_requeue_pi_init returned: 0
> >   <...>-3793    1...3 558351879us : rt_mutex_start_proxy_lock:
> > task_blocks_on_rt_mutex returned 0
> >   <...>-3793    1...3 558351880us : rt_mutex_start_proxy_lock: lock
> > has waiterflag: 0
> >   <...>-3793    1...1 558351888us : rt_mutex_unlock: unlocking
> > ffff88023b5f6950
> >   <...>-3793    1...1 558351888us : rt_mutex_unlock: lock waiter
> > flag: 0 <...>-3793    1...1 558351889us : rt_mutex_unlock: unlocked
> > ffff88023b5f6950
> >   <...>-3783    0...1 558351893us : __rt_mutex_slowlock:
> > waiter->task is ffff88023c872440
> >   <...>-3783    0...1 558351897us : try_to_take_rt_mutex: assigned
> > rt_mutex (ffff88023b5f6950) owner to current ffff88023c872440
> >   <...>-3783    0...1 558351897us : __rt_mutex_slowlock: got the
> > lock ---------------------------------
> >
> > I'll start digging into why that's happening, but I wanted to share
> > the trace output.
>
> As it turns out I missed setting RT_MUTEX_HAS_WAITERS on the rt_mutex
> in rt_mutex_start_proxy_lock() - seems awfully silly in retrospect -
> but a little non-obvious while writing it.  I added
> mark_rt_mutex_waiters() after the call to task_blocks_on_rt_mutex()
> and the test has completed more than 400 iterations successfully (it
> would fail after no more than 2 most of the time before).
>
> Steven, there are several ways to set RT_MUTEX_HAS_WAITERS - but this
> seemed like a reasonable approach, would you agree?  Since I'm
> holding the wait_lock I don't technically need the atomic cmpxchg and
> could probably just set it explicity - do you have a preference?
>
>
> RFC: rt_mutex: add proxy lock routines

I have been testing this with my own minimal prototype glibc 
implementation. While testing Darren's kernel at this level (including 
the fix below) I have hit the following BUG:

BUG: unable to handle kernel NULL pointer dereference at 
0000000000000048
IP: [<ffffffff8105c236>] futex_requeue+0x403/0x5c6
PGD 1de5bf067 PUD 1de5be067 PMD 0 
Oops: 0002 [#1] PREEMPT SMP 
last sysfs file:
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/vendor
Dumping ftrace buffer:
   (ftrace buffer empty)
CPU 3 
Modules linked in: ipv6 autofs4 hidp rfcomm l2cap bluetooth 
cpufreq_ondemand
acpi_cpufreq dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod 
video
output sbs sbshc battery ac parport_pc lp parport floppy snd_hda_intel
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
e1000 sg
snd_pcm_oss snd_mixer_oss snd_pcm snd_timer tg3 sr_mod snd_page_alloc 
snd_hwdep
cdrom libphy snd serio_raw iTCO_wdt pata_acpi i5000_edac i2c_i801 button 
shpchp
iTCO_vendor_support edac_core i2c_core ata_generic soundcore pcspkr 
ata_piix
libata mptsas mptscsih scsi_transport_sas mptbase sd_mod scsi_mod ext3 
jbd
mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 21264, comm: test_requeue_pi Not tainted 2.6.28-rc6-dvh04 #12
RIP: 0010:[<ffffffff8105c236>]  [<ffffffff8105c236>] 
futex_requeue+0x403/0x5c6
RSP: 0018:ffff8801de89dd38  EFLAGS: 00010206
RAX: 0000000000000048 RBX: 000000003fff8802 RCX: 0000000000005306
RDX: ffff8801de94a100 RSI: ffffffff8142c540 RDI: ffff88023e40a640
RBP: ffff8801de89de08 R08: ffff8801de8b6440 R09: 00000000f7a1335f
R10: 0000000000000005 R11: ffff8801de89dce8 R12: ffff8801de529c58
R13: ffffffff8160c840 R14: ffffffff8160c5c0 R15: 0000000000000000
FS:  000000004669c940(0063) GS:ffff88023eb3cac0(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000048 CR3: 00000001de843000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process test_requeue_pi (pid: 21264, threadinfo ffff8801de89c000, task
ffff8801de942340)
Stack:
 ffff8800280687e0 ffff8801de89def8 000000017fffffff 00000000006017c0
 00000001de89dd88 0000000000601784 ffffffff8160c5c8 ffff8801de8c7c58
 00000000de942340 0000000000000000 0000000000601000 ffff8801de94a100
Call Trace:
 [<ffffffff811b796a>] ? pty_write+0x3e/0x48
 [<ffffffff8105cc25>] do_futex+0x82c/0x878
 [<ffffffff8102f556>] ? __wake_up+0x43/0x4f
 [<ffffffff811b6936>] ? tty_ldisc_deref+0x6e/0x73
 [<ffffffff811b1d08>] ? tty_write+0x211/0x22c
 [<ffffffff8105cd8c>] sys_futex+0x11b/0x139
 [<ffffffff8100c0db>] system_call_fastpath+0x16/0x1b
Code: 7d 10 00 74 59 49 8b 44 24 68 8b 5d cc 48 8b b8 a8 02 00 00 81 e3 
ff ff
ff 3f e8 83 0b ff ff 39 c3 74 3b 48 8b 45 c0 48 83 c0 48 <f0> ff 00 48 
8b 45 c0
49 8b 54 24 68 b9 01 00 00 00 49 8b 74 24 
RIP  [<ffffffff8105c236>] futex_requeue+0x403/0x5c6
 RSP <ffff8801de89dd38>
CR2: 0000000000000048
---[ end trace 2376de034cbbad6b ]---

Thanks,
Sripathi.


>
> From: Darren Hart <dvhltc@us.ibm.com>
>
> This patch is required for the first half of requeue_pi to function. 
> It basically splits rt_mutex_slowlock() right down the middle, just
> before the first call to schedule().
>
> This patch uses a new futex_q field, rt_waiter, for now.  I think
> I should be able to use task->pi_blocked_on in a future versino of
> this patch.
>
> V6: -add mark_rt_mutex_waiters() to rt_mutex_start_procy_lock() to
> avoid the race condition evident in previous versions
> V5: -remove EXPORT_SYMBOL_GPL from the new routines
>     -minor cleanups
> V4: -made detect_deadlock a parameter to rt_mutex_enqueue_task
>     -refactored rt_mutex_slowlock to share code with new functions
>     -renamed rt_mutex_enqueue_task and rt_mutex_handle_wakeup to
>      rt_mutex_start_proxy_lock and rt_mutex_finish_proxy_lock,
> respectively
>
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sripathi Kodi <sripathik@in.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>
>  kernel/rtmutex.c        |  193
> +++++++++++++++++++++++++++++++++++++----------
> kernel/rtmutex_common.h |    8 ++
>  2 files changed, 161 insertions(+), 40 deletions(-)
>
>
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index 69d9cb9..f438362 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -411,6 +411,7 @@ static int try_to_take_rt_mutex(struct rt_mutex
> *lock) */
>  static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>  				   struct rt_mutex_waiter *waiter,
> +				   struct task_struct *task,
>  				   int detect_deadlock)
>  {
>  	struct task_struct *owner = rt_mutex_owner(lock);
> @@ -418,21 +419,21 @@ static int task_blocks_on_rt_mutex(struct
> rt_mutex *lock, unsigned long flags;
>  	int chain_walk = 0, res;
>
> -	spin_lock_irqsave(&current->pi_lock, flags);
> -	__rt_mutex_adjust_prio(current);
> -	waiter->task = current;
> +	spin_lock_irqsave(&task->pi_lock, flags);
> +	__rt_mutex_adjust_prio(task);
> +	waiter->task = task;
>  	waiter->lock = lock;
> -	plist_node_init(&waiter->list_entry, current->prio);
> -	plist_node_init(&waiter->pi_list_entry, current->prio);
> +	plist_node_init(&waiter->list_entry, task->prio);
> +	plist_node_init(&waiter->pi_list_entry, task->prio);
>
>  	/* Get the top priority waiter on the lock */
>  	if (rt_mutex_has_waiters(lock))
>  		top_waiter = rt_mutex_top_waiter(lock);
>  	plist_add(&waiter->list_entry, &lock->wait_list);
>
> -	current->pi_blocked_on = waiter;
> +	task->pi_blocked_on = waiter;
>
> -	spin_unlock_irqrestore(&current->pi_lock, flags);
> +	spin_unlock_irqrestore(&task->pi_lock, flags);
>
>  	if (waiter == rt_mutex_top_waiter(lock)) {
>  		spin_lock_irqsave(&owner->pi_lock, flags);
> @@ -460,7 +461,7 @@ static int task_blocks_on_rt_mutex(struct
> rt_mutex *lock, spin_unlock(&lock->wait_lock);
>
>  	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock,
> waiter, -					 current);
> +					 task);
>
>  	spin_lock(&lock->wait_lock);
>
> @@ -605,37 +606,25 @@ void rt_mutex_adjust_pi(struct task_struct
> *task) rt_mutex_adjust_prio_chain(task, 0, NULL, NULL, task);
>  }
>
> -/*
> - * Slow path lock function:
> +/**
> + * __rt_mutex_slowlock - perform the wait-wake-try-to-take loop
> + * @lock		 the rt_mutex to take
> + * @state:		 the state the task should block in (TASK_INTERRUPTIBLE
> + * 			 or TASK_UNINTERRUPTIBLE)
> + * @timeout:		 the pre-initialized and started timer, or NULL for
> none + * @waiter:		 the pre-initialized rt_mutex_waiter
> + * @detect_deadlock:	 passed to task_blocks_on_rt_mutex
> + *
> + * lock->wait_lock must be held by the caller.
>   */
>  static int __sched
> -rt_mutex_slowlock(struct rt_mutex *lock, int state,
> -		  struct hrtimer_sleeper *timeout,
> -		  int detect_deadlock)
> +__rt_mutex_slowlock(struct rt_mutex *lock, int state,
> +		    struct hrtimer_sleeper *timeout,
> +		    struct rt_mutex_waiter *waiter,
> +		    int detect_deadlock)
>  {
> -	struct rt_mutex_waiter waiter;
>  	int ret = 0;
>
> -	debug_rt_mutex_init_waiter(&waiter);
> -	waiter.task = NULL;
> -
> -	spin_lock(&lock->wait_lock);
> -
> -	/* Try to acquire the lock again: */
> -	if (try_to_take_rt_mutex(lock)) {
> -		spin_unlock(&lock->wait_lock);
> -		return 0;
> -	}
> -
> -	set_current_state(state);
> -
> -	/* Setup the timer, when timeout != NULL */
> -	if (unlikely(timeout)) {
> -		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
> -		if (!hrtimer_active(&timeout->timer))
> -			timeout->task = NULL;
> -	}
> -
>  	for (;;) {
>  		/* Try to acquire the lock: */
>  		if (try_to_take_rt_mutex(lock))
> @@ -656,19 +645,19 @@ rt_mutex_slowlock(struct rt_mutex *lock, int
> state, }
>
>  		/*
> -		 * waiter.task is NULL the first time we come here and
> +		 * waiter->task is NULL the first time we come here and
>  		 * when we have been woken up by the previous owner
>  		 * but the lock got stolen by a higher prio task.
>  		 */
> -		if (!waiter.task) {
> -			ret = task_blocks_on_rt_mutex(lock, &waiter,
> +		if (!waiter->task) {
> +			ret = task_blocks_on_rt_mutex(lock, waiter, current,
>  						      detect_deadlock);
>  			/*
>  			 * If we got woken up by the owner then start loop
>  			 * all over without going into schedule to try
>  			 * to get the lock now:
>  			 */
> -			if (unlikely(!waiter.task)) {
> +			if (unlikely(!waiter->task)) {
>  				/*
>  				 * Reset the return value. We might
>  				 * have returned with -EDEADLK and the
> @@ -684,15 +673,52 @@ rt_mutex_slowlock(struct rt_mutex *lock, int
> state,
>
>  		spin_unlock(&lock->wait_lock);
>
> -		debug_rt_mutex_print_deadlock(&waiter);
> +		debug_rt_mutex_print_deadlock(waiter);
>
> -		if (waiter.task)
> +		if (waiter->task)
>  			schedule_rt_mutex(lock);
>
>  		spin_lock(&lock->wait_lock);
>  		set_current_state(state);
>  	}
>
> +	return ret;
> +}
> +
> +/*
> + * Slow path lock function:
> + */
> +static int __sched
> +rt_mutex_slowlock(struct rt_mutex *lock, int state,
> +		  struct hrtimer_sleeper *timeout,
> +		  int detect_deadlock)
> +{
> +	struct rt_mutex_waiter waiter;
> +	int ret = 0;
> +
> +	debug_rt_mutex_init_waiter(&waiter);
> +	waiter.task = NULL;
> +
> +	spin_lock(&lock->wait_lock);
> +
> +	/* Try to acquire the lock again: */
> +	if (try_to_take_rt_mutex(lock)) {
> +		spin_unlock(&lock->wait_lock);
> +		return 0;
> +	}
> +
> +	set_current_state(state);
> +
> +	/* Setup the timer, when timeout != NULL */
> +	if (unlikely(timeout)) {
> +		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
> +		if (!hrtimer_active(&timeout->timer))
> +			timeout->task = NULL;
> +	}
> +
> +	ret = __rt_mutex_slowlock(lock, state, timeout, &waiter,
> +				  detect_deadlock);
> +
>  	set_current_state(TASK_RUNNING);
>
>  	if (unlikely(waiter.task))
> @@ -986,6 +1012,42 @@ void rt_mutex_proxy_unlock(struct rt_mutex
> *lock, }
>
>  /**
> + * rt_mutex_start_proxy_lock - prepare another task to take the lock
> + *
> + * @lock:		the rt_mutex to take
> + * @waiter:		the rt_mutex_waiter initialized by the waiter
> + * @task:		the task to prepare
> + * @detext_deadlock:	passed to task_blocks_on_rt_mutex
> + *
> + * The lock should have an owner, and it should not be task.
> + * Special API call for FUTEX_REQUEUE_PI support.
> + */
> +int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
> +			      struct rt_mutex_waiter *waiter,
> +			      struct task_struct *task, int detect_deadlock)
> +{
> +	int ret;
> +
> +	spin_lock(&lock->wait_lock);
> +	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
> +	mark_rt_mutex_waiters(lock);
> +	if (ret && !waiter->task) {
> +		/*
> +		 * Reset the return value. We might have
> +		 * returned with -EDEADLK and the owner
> +		 * released the lock while we were walking the
> +		 * pi chain.  Let the waiter sort it out.
> +		 */
> +		ret = 0;
> +	}
> +	spin_unlock(&lock->wait_lock);
> +
> +	debug_rt_mutex_print_deadlock(waiter);
> +
> +	return ret;
> +}
> +
> +/**
>   * rt_mutex_next_owner - return the next owner of the lock
>   *
>   * @lock: the rt lock query
> @@ -1004,3 +1066,54 @@ struct task_struct *rt_mutex_next_owner(struct
> rt_mutex *lock)
>
>  	return rt_mutex_top_waiter(lock)->task;
>  }
> +
> +/**
> + * rt_mutex_finish_proxy_lock - Complete the taking of the lock
> initialized on + *                              our behalf by another
> thread. + * @lock: the rt_mutex we were woken on
> + * @to: the timeout, null if none. hrtimer should already have been
> started. + * @waiter: the pre-initialized rt_mutex_waiter
> + * @detect_deadlock: for use by __rt_mutex_slowlock
> + *
> + * Special API call for PI-futex requeue support
> + */
> +int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
> +			       struct hrtimer_sleeper *to,
> +			       struct rt_mutex_waiter *waiter,
> +			       int detect_deadlock)
> +{
> +	int ret;
> +
> +	if (waiter->task)
> +		schedule_rt_mutex(lock);
> +
> +	spin_lock(&lock->wait_lock);
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +
> +	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
> +				  detect_deadlock);
> +
> +	set_current_state(TASK_RUNNING);
> +
> +	if (unlikely(waiter->task))
> +		remove_waiter(lock, waiter);
> +
> +	/*
> +	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We
> might +	 * have to fix that up.
> +	 */
> +	fixup_rt_mutex_waiters(lock);
> +
> +	spin_unlock(&lock->wait_lock);
> +
> +	/*
> +	 * Readjust priority, when we did not get the lock. We might have
> been +	 * the pending owner and boosted. Since we did not take the
> lock, the +	 * PI boost has to go.
> +	 */
> +	if (unlikely(ret))
> +		rt_mutex_adjust_prio(current);
> +
> +	return ret;
> +}
> diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
> index e124bf5..97a2f81 100644
> --- a/kernel/rtmutex_common.h
> +++ b/kernel/rtmutex_common.h
> @@ -120,6 +120,14 @@ extern void rt_mutex_init_proxy_locked(struct
> rt_mutex *lock, struct task_struct *proxy_owner);
>  extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
>  				  struct task_struct *proxy_owner);
> +extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
> +				     struct rt_mutex_waiter *waiter,
> +				     struct task_struct *task,
> +				     int detect_deadlock);
> +extern int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
> +				      struct hrtimer_sleeper *to,
> +				      struct rt_mutex_waiter *waiter,
> +				      int detect_deadlock);
>
>  #ifdef CONFIG_DEBUG_RT_MUTEXES
>  # include "rtmutex-debug.h"


