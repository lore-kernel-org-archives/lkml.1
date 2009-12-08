Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZLHPKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZLHPKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbZLHPKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:10:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733AbZLHPKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:10:03 -0500
Date: Tue, 8 Dec 2009 16:04:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091208150417.GA11883@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop> <20091201220847.GA25400@redhat.com> <1260210877.3935.594.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260210877.3935.594.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07, Peter Zijlstra wrote:
>
> On Tue, 2009-12-01 at 23:08 +0100, Oleg Nesterov wrote:
>
> > > > @@ -560,6 +625,20 @@ static inline void tracehook_report_deat
> > > >  					  int signal, void *death_cookie,
> > > >  					  int group_dead)
> > > >  {
> > > > +	/*
> > > > +	 * This barrier ensures that our caller's setting of
> > > > +	 * @task->exit_state precedes checking @task->utrace_flags here.
> > > > +	 * If utrace_set_events() was just called to enable
> > > > +	 * UTRACE_EVENT(DEATH), then we are obliged to call
> > > > +	 * utrace_report_death() and not miss it.  utrace_set_events()
> > > > +	 * uses tasklist_lock to synchronize enabling the bit with the
> > > > +	 * actual change to @task->exit_state, but we need this barrier
> > > > +	 * to be sure we see a flags change made just before our caller
> > > > +	 * took the tasklist_lock.
> > > > +	 */
> > > > +	smp_mb();
> > > > +	if (task_utrace_flags(task) & _UTRACE_DEATH_EVENTS)
> > > > +		utrace_report_death(task, death_cookie, group_dead, signal);
> > > >  }
> > >
> > > I don't think its allowed to pair a mb with a lock-barrier, since the
> > > lock barriers are semi-permeable.
> >
> > Could you clarify?
>
> According to memory-barriers.txt a mb can be paired with mb,wmb,rmb
> depending on the situation.
>
> For LOCK it states:
>
> (1) LOCK operation implication:
>
>      Memory operations issued after the LOCK will be completed after the LOCK
>      operation has completed.
>
>      Memory operations issued before the LOCK may be completed after the LOCK
>      operation has completed.
>
> Which is not something I can see making sense to pair with an mb.
>
> So either the comment is confusing and its again referring to an UNLOCK
> +LOCK pair, or there's something fishy

Ah. I missed your point because I didn't read the comment.

Hmm. And since I didn't read the comment I misunderstood this code. Now
I think the comment is wrong, and this mb() is not needed.

If utrace utrace_set_events() adds _UTRACE_DEATH_EVENTS bits, it does
this under read_lock(tasklist). This means tracehook_report_death()
must always see the flags change, the caller took write_lock(tasklist).

IOW, in _UTRACE_DEATH_EVENTS case

	utrace_set_events:

		read_lock(tasklist);
		if (!target->exit_state)
			target->utrace_flags |= UTRACE_EVENT(DEATH);
		read_unlock(tasklist);

	exit_notify:

		write_lock(tasklist);
		task->exit_state = EXIT_XXX;
		write_unlock(tasklist);

		if (target->utrace_flags & _UTRACE_DEATH_EVENTS)
			utrace_report_death();

It doesn't matter if the reading of ->utrace_flags can be reordered with
the setting of ->exit_state, in no way this LOAD can happen _before_ we
take tasklist for writing. And, if ->utrace_flags was already changed
before we take tasklist, since utrace_set_events() does this under the
same lock, we must see the change after write_unlock(tasklist).

Roland?

> > > >  static inline void tracehook_notify_resume(struct pt_regs *regs)
> > > >  {
> > > > +	struct task_struct *task = current;
> > > > +	/*
> > > > +	 * This pairs with the barrier implicit in set_notify_resume().
> > > > +	 * It ensures that we read the nonzero utrace_flags set before
> > > > +	 * set_notify_resume() was called by utrace setup.
> > > > +	 */
> > > > +	smp_rmb();
> > > > +	if (task_utrace_flags(task))
> > > > +		utrace_resume(task, regs);
> > > >  }
> > >
> > > Sending an IPI implies the mb?
> >
> > Yes, but this has nothing to do with IPI. The caller, do_notify_resume(),
> > does:
> > 	clear_thread_flag(TIF_NOTIFY_RESUME);
> > 	tracehook_notify_resume:
> > 		if (task_utrace_flags(task))
> > 			utrace_resume();
> >
> > We should not read task_utrace_flags() before we clear TIF_NOTIFY_RESUME.
>
> Then this comment needs an update.. that wasn't at all clear to me.

OK.

> > > > +static inline struct utrace *task_utrace_struct(struct task_struct *task)
> > > > +{
> > > > +	struct utrace *utrace;
> > > > +
> > > > +	/*
> > > > +	 * This barrier ensures that any prior load of task->utrace_flags
> > > > +	 * is ordered before this load of task->utrace.  We use those
> > > > +	 * utrace_flags checks in the hot path to decide to call into
> > > > +	 * the utrace code.  The first attach installs task->utrace before
> > > > +	 * setting task->utrace_flags nonzero, with a barrier between.
> > > > +	 * See utrace_task_alloc().
> > > > +	 */
> > > > +	smp_rmb();
> > > > +	utrace = task->utrace;
> > > > +
> > > > +	smp_read_barrier_depends(); /* See utrace_task_alloc().  */
> > > > +	return utrace;
> > > > +}
> > >
> > > I spot two barriers here, but only 1 over in utrace_task_alloc(), hmm?
> >
> > smp_read_barrier_depends() pairs with utrace_task_alloc()->wmb().
> >
> > smp_rmb() is needed for another reason. Suppose the code does:
> >
> > 	if (task_utrace_flags() & SOMETHING)
> > 		do_something_with(task->utrace);
> >
> > if we race with utrace_attach_task(), we can see ->utrace_flags != 0
> > but task->utrace == NULL without rmb().
>
> Still not clear what we pair with.. There is no obvious barrier in
> utrace_attach_task() nor a comment referring to this site.

Yes, agreed, we should move (and improve) the comment from
utrace_task_alloc() to utrace_attach_task() or utrace_add_engine()
which changed ->utrace_flags, see below.

> > > > +static bool utrace_task_alloc(struct task_struct *task)
> > > > +{
> > > > +	struct utrace *utrace = kmem_cache_zalloc(utrace_cachep, GFP_KERNEL);
> > > > +	if (unlikely(!utrace))
> > > > +		return false;
> > > > +	spin_lock_init(&utrace->lock);
> > > > +	INIT_LIST_HEAD(&utrace->attached);
> > > > +	INIT_LIST_HEAD(&utrace->attaching);
> > > > +	utrace->resume = UTRACE_RESUME;
> > > > +	task_lock(task);
> > > > +	if (likely(!task->utrace)) {
> > > > +		/*
> > > > +		 * This barrier makes sure the initialization of the struct
> > > > +		 * precedes the installation of the pointer.  This pairs
> > > > +		 * with smp_read_barrier_depends() in task_utrace_struct().
> > > > +		 */
> > > > +		smp_wmb();
> > > > +		task->utrace = utrace;
> > > > +	}
> > > > +	task_unlock(task);
> > > > +	/*
> > > > +	 * That unlock after storing task->utrace acts as a memory barrier
> > > > +	 * ordering any subsequent task->utrace_flags store afterwards.
> > > > +	 * This pairs with smp_rmb() in task_utrace_struct().
> > > > +	 */
> > > > +	if (unlikely(task->utrace != utrace))
> > > > +		kmem_cache_free(utrace_cachep, utrace);
> > > > +	return true;
> > > > +}
> > >
> > > Again, not sure we can pair an UNLOCK-barrier with a RMB. In fact, both
> > > are NOPs on x86.
> >
> > We can't. I think the comment is confusing. We need the barrier
> > between setting "task->utrace = utrace" and changing ->utrace_flags.
> > We have unlock+lock in between, this implies mb().
>
> So this is the task_unlock() in utrace_task_alloc() and the
> spin_lock(&utrace->lock) in utrace_add_engine() ?

Yes, and see above. This UNLOCK+LOCK provides the necessary barrier.

> Talk about non-obvious.

Well, agreed. We should fix the comment, or just add the explicit mb().
I personally think the "good" comment is enough.

> > > > +struct utrace_engine_ops {
> > >
> > > > +	u32 (*report_signal)(u32 action,
> > > > +			     struct utrace_engine *engine,
> > > > +			     struct task_struct *task,
> > > > +			     struct pt_regs *regs,
> > > > +			     siginfo_t *info,
> > > > +			     const struct k_sigaction *orig_ka,
> > > > +			     struct k_sigaction *return_ka);
> > >
> > > > +	u32 (*report_clone)(enum utrace_resume_action action,
> > > > +			    struct utrace_engine *engine,
> > > > +			    struct task_struct *parent,
> > > > +			    unsigned long clone_flags,
> > > > +			    struct task_struct *child);
> > >
> > > > +};
> > >
> > > Seems inconsistent on u32 vs enum utrace_resume_action.
> >
> > Well, this u32 can hold utrace_resume_action | utrace_signal_action,
> > for example.
>
> Sure, but then make all of them u32, or unsigned int, as that gets mixed
> in below.

Not sure I understand, but if you meant all these callbacks should
return int/long then I'd personally agree.

> > > > +static inline int utrace_attach_delay(struct task_struct *target)
> > > > +{
> > > > +	if ((target->flags & PF_STARTING) &&
> > > > +	    task_utrace_struct(current) &&
> > > > +	    task_utrace_struct(current)->cloning != target)
> > > > +		do {
> > > > +			schedule_timeout_interruptible(1);
> > > > +			if (signal_pending(current))
> > > > +				return -ERESTARTNOINTR;
> > > > +		} while (target->flags & PF_STARTING);
> > > > +
> > > > +	return 0;
> > > > +}
> > >
> > > Quite gross this.. can't we key off the
> > > tracehoook_report_clone_complete() and use a wakeup there?
> >
> > Yes, it would be very nice to avoid this schedule_timeout_interruptible().
> > But currently we don't see a simple solution, on the TODO list. But, to
> > clarify, this case is very unlikely.
>
> Use a global wait-queue and put a wakeup_all in
> tracehook_report_clone_complete() or wherever that ends up in utrace?

- First of all, can't resist, I think a global wait-queue for
  this is just "ugly by definition". OK, please ignore, this
  is non-technical and subjective.

- If we change tracehook_report_clone_complete() to do the wakeup,
  this wakeup must be unconditional, it should be done even if the
  forking thread is not traced.

The current code is extremly simple and works. Yes, yes, yes, any
schedule_timeout(1) in a loop asks for the better solution. I don't
know what Roland thinks, but as for me this problem is low priority,
currently I didn't really try to think how to make this code "better".
This case is very unlikely, and it is not a hot-path. This happens
when the unrelated process tries to attach to the new thread in the
middle of do_fork().

But there is another reason why personally I think we should improve
this code later (and the similar code in utrace_barrier). A few lines
below you wrote:

> > > Also, I'm not quite sure on why we play so many barrier games, looking
> > > at start_callback() we have 2 barriers in the callback loop, why not a
> > > per engine lock?
> >
> > Exactly to avoid the lock, I guess ;)
>
> I'm really thinking this code ought to get simplified a lot, there's too
> much non-obvious barriers.
>
> Then, and only if performance numbers show it, add back some of these
> optimizations, in simple small steps, that way its much easier to review
> as well.

and above you suggest to complicate utrace_attach_delay() before merging.

As for "in simple small steps", I agree, it would be much better. The
problem is, this code was developed out-of-tree. That is why we would
like to merge it asap, then do other changes which could be easily
reviewed.

Now, do you really mean we should throw out the working code, rewrite
it avoiding these barriers, and resubmit? Sure, everything is possible.
But this means another round of out-of-tree development with unclear
results.

Some barriers are easy, we can simply take utrace->lock. Some are not.
In no way (imho) we should use spinlocks in tracehooks. OK, we can
embed "struct utrace" back into task_struct, then it would be easy
to eliminate more barriers, not sure this would be a good change though.

> > > > +	/*
> > > > +	 * In theory spin_lock() doesn't imply rcu_read_lock().
> > > > +	 * Once we clear ->utrace_flags this task_struct can go away
> > > > +	 * because tracehook_prepare_release_task() path does not take
> > > > +	 * utrace->lock when ->utrace_flags == 0.
> > > > +	 */
> > > > +	rcu_read_lock();
> > > > +	task->utrace_flags = flags;
> > > > +	spin_unlock(&utrace->lock);
> > > > +	rcu_read_unlock();
> > >
> > > yuck!
> > >
> > > why not simply keep a task reference over the utrace_reset call?
> >
> > Yes, we could use get_task_struct() instead. Not sure this would
> > be more clean, though.
>
> For one it would allow getting rid of that insane assymetric locking.

Well, this is subjective, but I don't agree that

	get_task_struct(task);
	task->utrace_flags = flags;
	spin_unlock(&utrace->lock);
	put_task_struct(task);

looks better. We can move get_task_struct (or rcu_read_lock) up, but
then the code becomes less obvious. This get/lock is only needed for
spin_unlock(&utrace->lock).

I'd wish we had rcu_read_lock_in_atomic (or whatever) which could be
used under spinlocks...

That said, if you think get_task_struct() can help to merge utrace
I personally do not care much.

> > > > +static inline void finish_callback_report(struct task_struct *task,
> > > > +					  struct utrace *utrace,
> > > > +					  struct utrace_report *report,
> > > > +					  struct utrace_engine *engine,
> > > > +					  enum utrace_resume_action action)
> > > > +{
> > > > +	/*
> > > > +	 * If utrace_control() was used, treat that like UTRACE_DETACH here.
> > > > +	 */
> > > > +	if (action == UTRACE_DETACH || engine->ops == &utrace_detached_ops) {
> > > > +		engine->ops = &utrace_detached_ops;
> > > > +		report->detaches = true;
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	if (action < report->action)
> > > > +		report->action = action;
> > > > +
> > > > +	if (action != UTRACE_STOP) {
> > > > +		if (action < report->resume_action)
> > > > +			report->resume_action = action;
> > > > +
> > > > +		if (engine_wants_stop(engine)) {
> > > > +			spin_lock(&utrace->lock);
> > > > +			clear_engine_wants_stop(engine);
> > > > +			spin_unlock(&utrace->lock);
> > > > +		}
> > >
> > > Reads funny, but I guess it can only race the right way round?
> >
> > Not sure I understand... could you explain?
>
> It can only race with another thread also clearing the bit, not with one
> setting the bit? Otherwise there's no guarantee its not set after that
> if stmt.

We do not care if another thread (the owner of this engine) sets or clears
ENGINE_STOP in engine->flags. This can happen if the tracer is "insane" and
races with itself. Nothing bad can happen, the last change wins.

Oleg.

