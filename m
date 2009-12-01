Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbZLAWOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbZLAWOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 17:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZLAWOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 17:14:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZLAWOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 17:14:37 -0500
Date: Tue, 1 Dec 2009 23:08:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091201220847.GA25400@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259697242.1697.1075.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Peter Zijlstra wrote:
>
> On Tue, 2009-11-24 at 21:02 +0100, Oleg Nesterov wrote:
>
> > +  <para>
> > +    There is nothing a kernel module can do to keep a <structname>struct
> > +    task_struct</structname> alive outside of
> > +    <function>rcu_read_lock</function>.
>
> Sure there is, get_task_struct() comes to mind.

it is not exported ;)

Peter, I skipped other comments about the documentation, I never read
it myself. Update: I skipped a lot more for today ;)

> > @@ -351,6 +394,10 @@ static inline void tracehook_report_vfor
> >   */
> >  static inline void tracehook_prepare_release_task(struct task_struct *task)
> >  {
> > +	/* see utrace_add_engine() about this barrier */
> > +	smp_mb();
> > +	if (task_utrace_flags(task))
> > +		utrace_release_task(task);
> >  }
>
> OK, that seems to properly order ->exit_state vs ->utrace_flags,
>
> This site does:
>
>  assign ->state
>  mb
>  observe ->utrace_flags
>
> and the other site does:
>
>  assign ->utrace_flags
>  mb
>  observe ->exit_state

Yes, we hope.

> > @@ -560,6 +625,20 @@ static inline void tracehook_report_deat
> >  					  int signal, void *death_cookie,
> >  					  int group_dead)
> >  {
> > +	/*
> > +	 * This barrier ensures that our caller's setting of
> > +	 * @task->exit_state precedes checking @task->utrace_flags here.
> > +	 * If utrace_set_events() was just called to enable
> > +	 * UTRACE_EVENT(DEATH), then we are obliged to call
> > +	 * utrace_report_death() and not miss it.  utrace_set_events()
> > +	 * uses tasklist_lock to synchronize enabling the bit with the
> > +	 * actual change to @task->exit_state, but we need this barrier
> > +	 * to be sure we see a flags change made just before our caller
> > +	 * took the tasklist_lock.
> > +	 */
> > +	smp_mb();
> > +	if (task_utrace_flags(task) & _UTRACE_DEATH_EVENTS)
> > +		utrace_report_death(task, death_cookie, group_dead, signal);
> >  }
>
> I don't think its allowed to pair a mb with a lock-barrier, since the
> lock barriers are semi-permeable.

Could you clarify?

> > @@ -589,10 +668,20 @@ static inline void set_notify_resume(str
> >   * asynchronously, this will be called again before we return to
> >   * user mode.
> >   *
> > - * Called without locks.
> > + * Called without locks.  However, on some machines this may be
> > + * called with interrupts disabled.
> >   */
> >  static inline void tracehook_notify_resume(struct pt_regs *regs)
> >  {
> > +	struct task_struct *task = current;
> > +	/*
> > +	 * This pairs with the barrier implicit in set_notify_resume().
> > +	 * It ensures that we read the nonzero utrace_flags set before
> > +	 * set_notify_resume() was called by utrace setup.
> > +	 */
> > +	smp_rmb();
> > +	if (task_utrace_flags(task))
> > +		utrace_resume(task, regs);
> >  }
>
> Sending an IPI implies the mb?

Yes, but this has nothing to do with IPI. The caller, do_notify_resume(),
does:
	clear_thread_flag(TIF_NOTIFY_RESUME);
	tracehook_notify_resume:
		if (task_utrace_flags(task))
			utrace_resume();

We should not read task_utrace_flags() before we clear TIF_NOTIFY_RESUME.

> > +static inline struct utrace *task_utrace_struct(struct task_struct *task)
> > +{
> > +	struct utrace *utrace;
> > +
> > +	/*
> > +	 * This barrier ensures that any prior load of task->utrace_flags
> > +	 * is ordered before this load of task->utrace.  We use those
> > +	 * utrace_flags checks in the hot path to decide to call into
> > +	 * the utrace code.  The first attach installs task->utrace before
> > +	 * setting task->utrace_flags nonzero, with a barrier between.
> > +	 * See utrace_task_alloc().
> > +	 */
> > +	smp_rmb();
> > +	utrace = task->utrace;
> > +
> > +	smp_read_barrier_depends(); /* See utrace_task_alloc().  */
> > +	return utrace;
> > +}
>
> I spot two barriers here, but only 1 over in utrace_task_alloc(), hmm?

smp_read_barrier_depends() pairs with utrace_task_alloc()->wmb().

smp_rmb() is needed for another reason. Suppose the code does:

	if (task_utrace_flags() & SOMETHING)
		do_something_with(task->utrace);

if we race with utrace_attach_task(), we can see ->utrace_flags != 0
but task->utrace == NULL without rmb().

> > +struct utrace_engine {
> > +/* private: */
> > +	struct kref kref;
> > +	void (*release)(void *);
> > +	struct list_head entry;
> > +
> > +/* public: */
> > +	const struct utrace_engine_ops *ops;
> > +	void *data;
> > +
> > +	unsigned long flags;
> > +};
>
> Sorry, the kernel is written in C, not C++.

Hmm. I almost never read the comments, but these 2 look very clear
to me ;)

> > + * Most callbacks take an @action argument, giving the resume action
> > + * chosen by other tracing engines.  All callbacks take an @engine
> > + * argument, and a @task argument, which is always equal to @current.
>
> Given that some functions have a lot of arguments (depleting regparam),
> isn't it more expensive to push current on the stack than it is to
> simply read it again?

Yes, perhaps. Only ->report_reap() really needs @task, it may be
!current.

> > +struct utrace_engine_ops {
>
> > +	u32 (*report_signal)(u32 action,
> > +			     struct utrace_engine *engine,
> > +			     struct task_struct *task,
> > +			     struct pt_regs *regs,
> > +			     siginfo_t *info,
> > +			     const struct k_sigaction *orig_ka,
> > +			     struct k_sigaction *return_ka);
>
> > +	u32 (*report_clone)(enum utrace_resume_action action,
> > +			    struct utrace_engine *engine,
> > +			    struct task_struct *parent,
> > +			    unsigned long clone_flags,
> > +			    struct task_struct *child);
>
> > +};
>
> Seems inconsistent on u32 vs enum utrace_resume_action.

Well, this u32 can hold utrace_resume_action | utrace_signal_action,
for example.

> > +struct utrace_examiner {
> > +/* private: */
> > +	long state;
> > +	unsigned long ncsw;
> > +};
>
> Again, its not C++, if you want a private state like that, use an opaque
> type, like:
>
> struct utrace_examiner;
>
> and only define the thing in utrace.c or something.

Then the caller of utrace_prepare_examine() has to alloc utrace_examiner
somehow. I disagree here. But of course we can remove this comment.

> > +static inline __must_check int utrace_control_pid(
> > +	struct pid *pid, struct utrace_engine *engine,
> > +	enum utrace_resume_action action)
> > +{
> > +	/*
> > +	 * We don't bother with rcu_read_lock() here to protect the
> > +	 * task_struct pointer, because utrace_control will return
> > +	 * -ESRCH without looking at that pointer if the engine is
> > +	 * already detached.  A task_struct pointer can't die before
> > +	 * all the engines are detached in release_task() first.
> > +	 */
> > +	struct task_struct *task = pid_task(pid, PIDTYPE_PID);
> > +	return unlikely(!task) ? -ESRCH : utrace_control(task, engine, action);
> > +}
>
> Is that comment correct? Without rcu_read_lock() the pidhash can change
> under our feet and maybe cause funny things?

If pid itself can't go away, it is always safe to use pid_task(). Yes,
we can't trust the returned value, that is why utrace_control() verifies
this task_struct* is still valid.

> Does pid_task() in generaly rely on havin rcu_read_lock() called?

See above. pid_task() itself doesn't need rcu_read_lock(), but without
rcu lock around you can't simply use the result.

> > +static bool utrace_task_alloc(struct task_struct *task)
> > +{
> > +	struct utrace *utrace = kmem_cache_zalloc(utrace_cachep, GFP_KERNEL);
> > +	if (unlikely(!utrace))
> > +		return false;
> > +	spin_lock_init(&utrace->lock);
> > +	INIT_LIST_HEAD(&utrace->attached);
> > +	INIT_LIST_HEAD(&utrace->attaching);
> > +	utrace->resume = UTRACE_RESUME;
> > +	task_lock(task);
> > +	if (likely(!task->utrace)) {
> > +		/*
> > +		 * This barrier makes sure the initialization of the struct
> > +		 * precedes the installation of the pointer.  This pairs
> > +		 * with smp_read_barrier_depends() in task_utrace_struct().
> > +		 */
> > +		smp_wmb();
> > +		task->utrace = utrace;
> > +	}
> > +	task_unlock(task);
> > +	/*
> > +	 * That unlock after storing task->utrace acts as a memory barrier
> > +	 * ordering any subsequent task->utrace_flags store afterwards.
> > +	 * This pairs with smp_rmb() in task_utrace_struct().
> > +	 */
> > +	if (unlikely(task->utrace != utrace))
> > +		kmem_cache_free(utrace_cachep, utrace);
> > +	return true;
> > +}
>
> Again, not sure we can pair an UNLOCK-barrier with a RMB. In fact, both
> are NOPs on x86.

We can't. I think the comment is confusing. We need the barrier
between setting "task->utrace = utrace" and changing ->utrace_flags.
We have unlock+lock in between, this implies mb().

> > +static inline int utrace_attach_delay(struct task_struct *target)
> > +{
> > +	if ((target->flags & PF_STARTING) &&
> > +	    task_utrace_struct(current) &&
> > +	    task_utrace_struct(current)->cloning != target)
> > +		do {
> > +			schedule_timeout_interruptible(1);
> > +			if (signal_pending(current))
> > +				return -ERESTARTNOINTR;
> > +		} while (target->flags & PF_STARTING);
> > +
> > +	return 0;
> > +}
>
> Quite gross this.. can't we key off the
> tracehoook_report_clone_complete() and use a wakeup there?

Yes, it would be very nice to avoid this schedule_timeout_interruptible().
But currently we don't see a simple solution, on the TODO list. But, to
clarify, this case is very unlikely.

> Furthermore I'd add a function like:
>
> static struct utrace_engine_ops *
> get_utrace_ops(struct utrace_engine *engine, unsigned long *flags)
> {
> 	*flags = engine->flags;
> 	/*
> 	 * This pairs with the barrier in mark_engine_detached().
> 	 * It makes sure that we never see the old ops vector with
> 	 * the new flags, in case the original vector had no
> 	 * report_quiesce.
> 	 */
> 	smp_rmb();
> 	return engine->ops;
> }
>
> to take out and explicitly comment that common bit.
>
> Also, I'm not quite sure on why we play so many barrier games, looking
> at start_callback() we have 2 barriers in the callback loop, why not a
> per engine lock?

Exactly to avoid the lock, I guess ;)

> > +	/*
> > +	 * In theory spin_lock() doesn't imply rcu_read_lock().
> > +	 * Once we clear ->utrace_flags this task_struct can go away
> > +	 * because tracehook_prepare_release_task() path does not take
> > +	 * utrace->lock when ->utrace_flags == 0.
> > +	 */
> > +	rcu_read_lock();
> > +	task->utrace_flags = flags;
> > +	spin_unlock(&utrace->lock);
> > +	rcu_read_unlock();
>
> yuck!
>
> why not simply keep a task reference over the utrace_reset call?

Yes, we could use get_task_struct() instead. Not sure this would
be more clean, though.

> > +static void utrace_stop(struct task_struct *task, struct utrace *utrace,
> > +			enum utrace_resume_action action)
> > ...
> > +	/*
> > +	 * If ptrace is among the reasons for this stop, do its
> > +	 * notification now.  This could not just be done in
> > +	 * ptrace's own event report callbacks because it has to
> > +	 * be done after we are in TASK_TRACED.  This makes the
> > +	 * synchronization with ptrace_do_wait() work right.
> > +	 */
> > +	ptrace_notify_stop(task);
>
> Well, this is a bit disappointing isn't it? So we cannot implement
> ptrace on utrace without special purpose hooks?

Yes, currently we need the special hook for ptrace. Because ptrace
is really special, no other engine should cooperate with do_wait/etc.

That said, I agree. We need something more general which could be
used by other engines too.

> > +static enum utrace_resume_action start_report(struct utrace *utrace)
> > +{
> > +	enum utrace_resume_action resume = utrace->resume;
> > +	if (utrace->pending_attach ||
> > +	    (resume > UTRACE_INTERRUPT && resume < UTRACE_RESUME)) {
> > +		spin_lock(&utrace->lock);
> > +		splice_attaching(utrace);
> > +		resume = utrace->resume;
> > +		if (resume > UTRACE_INTERRUPT)
> > +			utrace->resume = UTRACE_RESUME;
> > +		spin_unlock(&utrace->lock);
> > +	}
> > +	return resume;
> > +}
>
> Its not entirely clear why we can check pending_attach outside of the
> utrace->lock and not be racy.

We can safely miss utrace->pending_attach here, or even read the "stale"
utrace->resume. Both can be changed after start_report().

> > +static inline void finish_callback_report(struct task_struct *task,
> > +					  struct utrace *utrace,
> > +					  struct utrace_report *report,
> > +					  struct utrace_engine *engine,
> > +					  enum utrace_resume_action action)
> > +{
> > +	/*
> > +	 * If utrace_control() was used, treat that like UTRACE_DETACH here.
> > +	 */
> > +	if (action == UTRACE_DETACH || engine->ops == &utrace_detached_ops) {
> > +		engine->ops = &utrace_detached_ops;
> > +		report->detaches = true;
> > +		return;
> > +	}
> > +
> > +	if (action < report->action)
> > +		report->action = action;
> > +
> > +	if (action != UTRACE_STOP) {
> > +		if (action < report->resume_action)
> > +			report->resume_action = action;
> > +
> > +		if (engine_wants_stop(engine)) {
> > +			spin_lock(&utrace->lock);
> > +			clear_engine_wants_stop(engine);
> > +			spin_unlock(&utrace->lock);
> > +		}
>
> Reads funny, but I guess it can only race the right way round?

Not sure I understand... could you explain?

> > +	/*
> > +	 * This is a good place to make sure tracing engines don't
> > +	 * introduce too much latency under voluntary preemption.
> > +	 */
> > +	if (need_resched())
> > +		cond_resched();
>
> Simply cond_resched() is sufficient, but that comment sucks, as it
> doesn't mention _why_ it is a good place.

Hmm, I agree.

> > +	/*
> > +	 * For a vfork, we will go into an uninterruptible block waiting
> > +	 * for the child.  We need UTRACE_STOP to happen before this, not
> > +	 * after.  For CLONE_VFORK, utrace_finish_vfork() will be called.
> > +	 */
> > +	if (report.action == UTRACE_STOP && (clone_flags & CLONE_VFORK)) {
> > +		spin_lock(&utrace->lock);
> > +		utrace->vfork_stop = 1;
> > +		spin_unlock(&utrace->lock);
> > +	}
>
> So much optimization, weird locking, barriers and here you didn't use
> atomic bit ops?

The point is, the state of the tracee must be "stable" under utrace->lock.
As for ->vfork_stop in particular, it should die (imho) but we need further
cleanups outside of utrace.c.

> > +void utrace_finish_vfork(struct task_struct *task)
> > +{
> > +	struct utrace *utrace = task_utrace_struct(task);
> > +
> > +	if (utrace->vfork_stop) {
> > +		spin_lock(&utrace->lock);
> > +		utrace->vfork_stop = 0;
> > +		spin_unlock(&utrace->lock);
> > +		utrace_stop(task, utrace, UTRACE_RESUME); /* XXX */
> > +	}
> > +}
>
> I'm sure that XXX means something,... again that vfork_stop stuff can
> only race the right way about, right?

UTRACE_RESUME is not exactly right, we have the pending patches but
need more discussion.

> > +void utrace_report_jctl(int notify, int what)
> > +{
> > +	struct task_struct *task = current;
> > +	struct utrace *utrace = task_utrace_struct(task);
> > +	INIT_REPORT(report);
> > +
> > +	spin_unlock_irq(&task->sighand->siglock);
> > +
> > +	REPORT(task, utrace, &report, UTRACE_EVENT(JCTL),
> > +	       report_jctl, what, notify);
> > +
> > +	spin_lock_irq(&task->sighand->siglock);
> > +}
>
> So much documentation, and non of it says that the JCTL (funny name btw)
> callback is done holding siglock... tskk.

Not sure I understand, but we unlock ->siglock before REPORT(). If you mean
that utrace_report_jctl() is called under ->siglock, then yes.

Oleg.

