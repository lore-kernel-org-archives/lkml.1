Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZLAUOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZLAUOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZLAUOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:14:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZLAUOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:14:35 -0500
Subject: Re: [RFC,PATCH 14/14] utrace core
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
In-Reply-To: <20091124200220.GA5828@redhat.com>
References: <20091124200220.GA5828@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 20:54:02 +0100
Message-ID: <1259697242.1697.1075.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 21:02 +0100, Oleg Nesterov wrote:

> +  <sect2 id="reap"><title>Final callbacks</title>
> +  <para>
> +    The <function>report_reap</function> callback is always the final event
> +    in the life cycle of a traced thread.  Tracing engines can use this as
> +    the trigger to clean up their own data structures.  The
> +    <function>report_death</function> callback is always the penultimate
> +    event a tracing engine might see; it's seen unless the thread was
> +    already in the midst of dying when the engine attached.  Many tracing
> +    engines will have no interest in when a parent reaps a dead process,
> +    and nothing they want to do with a zombie thread once it dies; for
> +    them, the <function>report_death</function> callback is the natural
> +    place to clean up data structures and detach.  To facilitate writing
> +    such engines robustly, given the asynchrony of
> +    <constant>SIGKILL</constant>, and without error-prone manual
> +    implementation of synchronization schemes, the
> +    <application>utrace</application> infrastructure provides some special
> +    guarantees about the <function>report_death</function> and
> +    <function>report_reap</function> callbacks.  It still takes some care
> +    to be sure your tracing engine is robust to tear-down races, but these
> +    rules make it reasonably straightforward and concise to handle a lot of
> +    corner cases correctly.
> +  </para>
> +  </sect2>

This above text seems inconsistent. First you say report_reap() is the
final callback and should be used for cleanup, then you say
report_death() is the penultimate callback but might not always happen
and people would normally use that as cleanup.

If we cannot rely on report_death() then I would suggest to simply
recommend report_reap() as cleanup callback and leave it at that.

> +  <para>
> +    There is nothing a kernel module can do to keep a <structname>struct
> +    task_struct</structname> alive outside of
> +    <function>rcu_read_lock</function>. 

Sure there is, get_task_struct() comes to mind.

>                                          When the task dies and is reaped
> +    by its parent (or itself), that structure can be freed so that any
> +    dangling pointers you have stored become invalid.
> +    <application>utrace</application> will not prevent this, but it can
> +    help you detect it safely.  By definition, a task that has been reaped
> +    has had all its engines detached.  All
> +    <application>utrace</application> calls can be safely called on a
> +    detached engine if the caller holds a reference on that engine pointer,
> +    even if the task pointer passed in the call is invalid.  All calls
> +    return <constant>-ESRCH</constant> for a detached engine, which tells
> +    you that the task pointer you passed could be invalid now.  Since
> +    <function>utrace_control</function> and
> +    <function>utrace_set_events</function> do not block, you can call those
> +    inside a <function>rcu_read_lock</function> section and be sure after
> +    they don't return <constant>-ESRCH</constant> that the task pointer is
> +    still valid until <function>rcu_read_unlock</function>.  The
> +    infrastructure never holds task references of its own.  

And here you imply its existence.

>                                                             Though neither
> +    <function>rcu_read_lock</function> nor any other lock is held while
> +    making a callback, it's always guaranteed that the <structname>struct
> +    task_struct</structname> and the <structname>struct
> +    utrace_engine</structname> passed as arguments remain valid
> +    until the callback function returns.
> +  </para>
> +
> +  <para>
> +    The common means for safely holding task pointers that is available to
> +    kernel modules is to use <structname>struct pid</structname>, which
> +    permits <function>put_pid</function> from kernel modules.  When using
> +    that, the calls <function>utrace_attach_pid</function>,
> +    <function>utrace_control_pid</function>,
> +    <function>utrace_set_events_pid</function>, and
> +    <function>utrace_barrier_pid</function> are available.
> +  </para>

The above seems weird to me at best... why hold a pid around when you
can keep a ref on the task struct? A pid might get reused leaving you
with a completely different task than you thought you had.

> +  </sect2>
> +
> +  <sect2 id="reap-after-death">
> +    <title>
> +      Serialization of <constant>DEATH</constant> and <constant>REAP</constant>
> +    </title>
> +    <para>
> +      The second guarantee is the serialization of
> +      <constant>DEATH</constant> and <constant>REAP</constant> event
> +      callbacks for a given thread.  The actual reaping by the parent
> +      (<function>release_task</function> call) can occur simultaneously
> +      while the thread is still doing the final steps of dying, including
> +      the <function>report_death</function> callback.  If a tracing engine
> +      has requested both <constant>DEATH</constant> and
> +      <constant>REAP</constant> event reports, it's guaranteed that the
> +      <function>report_reap</function> callback will not be made until
> +      after the <function>report_death</function> callback has returned.
> +      If the <function>report_death</function> callback itself detaches
> +      from the thread, then the <function>report_reap</function> callback
> +      will never be made.  Thus it is safe for a
> +      <function>report_death</function> callback to clean up data
> +      structures and detach.
> +    </para>
> +  </sect2>

Right, except you cannot generally rely on this report_death() thing, so
a trace engine needs to deal with the report_reap() thing anyway.

> +  <sect2 id="interlock"><title>Interlock with final callbacks</title>
> +  <para>
> +    The final sort of guarantee is that a tracing engine will know for sure
> +    whether or not the <function>report_death</function> and/or
> +    <function>report_reap</function> callbacks will be made for a certain
> +    thread.  These tear-down races are disambiguated by the error return
> +    values of <function>utrace_set_events</function> and
> +    <function>utrace_control</function>.  Normally
> +    <function>utrace_control</function> called with
> +    <constant>UTRACE_DETACH</constant> returns zero, and this means that no
> +    more callbacks will be made.  If the thread is in the midst of dying,
> +    it returns <constant>-EALREADY</constant> to indicate that the
> +    <constant>report_death</constant> callback may already be in progress;
> +    when you get this error, you know that any cleanup your
> +    <function>report_death</function> callback does is about to happen or
> +    has just happened--note that if the <function>report_death</function>
> +    callback does not detach, the engine remains attached until the thread
> +    gets reaped.  If the thread is in the midst of being reaped,
> +    <function>utrace_control</function> returns <constant>-ESRCH</constant>
> +    to indicate that the <function>report_reap</function> callback may
> +    already be in progress; this means the engine is implicitly detached
> +    when the callback completes.  This makes it possible for a tracing
> +    engine that has decided asynchronously to detach from a thread to
> +    safely clean up its data structures, knowing that no
> +    <function>report_death</function> or <function>report_reap</function>
> +    callback will try to do the same.  <constant>utrace_detach</constant>
> +    returns <constant>-ESRCH</constant> when the <structname>struct
> +    utrace_engine</structname> has already been detached, but is
> +    still a valid pointer because of its reference count.  A tracing engine
> +    can use this to safely synchronize its own independent multiple threads
> +    of control with each other and with its event callbacks that detach.
> +  </para>
> +
> +  <para>
> +    In the same vein, <function>utrace_set_events</function> normally
> +    returns zero; if the target thread was stopped before the call, then
> +    after a successful call, no event callbacks not requested in the new
> +    flags will be made.  It fails with <constant>-EALREADY</constant> if
> +    you try to clear <constant>UTRACE_EVENT(DEATH)</constant> when the
> +    <function>report_death</function> callback may already have begun, if
> +    you try to clear <constant>UTRACE_EVENT(REAP)</constant> when the
> +    <function>report_reap</function> callback may already have begun, or if
> +    you try to newly set <constant>UTRACE_EVENT(DEATH)</constant> or
> +    <constant>UTRACE_EVENT(QUIESCE)</constant> when the target is already
> +    dead or dying.  Like <function>utrace_control</function>, it returns
> +    <constant>-ESRCH</constant> when the thread has already been detached
> +    (including forcible detach on reaping).  This lets the tracing engine
> +    know for sure which event callbacks it will or won't see after
> +    <function>utrace_set_events</function> has returned.  By checking for
> +    errors, it can know whether to clean up its data structures immediately
> +    or to let its callbacks do the work.
> +  </para>
> +  </sect2>

Hrmm, better mention this earlier, or at least refer to this when
describing the above cleanup bits.


> +<para>
> +  One task can examine another only after a callback in the target task that
> +  returns <constant>UTRACE_STOP</constant> so that task will not return to user
> +  mode after the safe point.  This guarantees that the task will not resume
> +  until the same engine uses <function>utrace_control</function>, unless the
> +  task dies suddenly.  To examine safely, one must use a pair of calls to
> +  <function>utrace_prepare_examine</function> and
> +  <function>utrace_finish_examine</function> surrounding the calls to
> +  <structname>struct user_regset</structname> functions or direct examination
> +  of task data structures.  <function>utrace_prepare_examine</function> returns
> +  an error if the task is not properly stopped and not dead. 

'or' dead?

>                                                               After a
> +  successful examination, the paired <function>utrace_finish_examine</function>
> +  call returns an error if the task ever woke up during the examination.  If
> +  so, any data gathered may be scrambled and should be discarded.  This means
> +  there was a spurious wake-up (which should not happen), or a sudden death.
> +</para>


> @@ -351,6 +394,10 @@ static inline void tracehook_report_vfor
>   */
>  static inline void tracehook_prepare_release_task(struct task_struct *task)
>  {
> +	/* see utrace_add_engine() about this barrier */
> +	smp_mb();
> +	if (task_utrace_flags(task))
> +		utrace_release_task(task);
>  }

OK, that seems to properly order ->exit_state vs ->utrace_flags,

This site does:

 assign ->state
 mb
 observe ->utrace_flags

and the other site does:

 assign ->utrace_flags
 mb
 observe ->exit_state
 
> @@ -560,6 +625,20 @@ static inline void tracehook_report_deat
>  					  int signal, void *death_cookie,
>  					  int group_dead)
>  {
> +	/*
> +	 * This barrier ensures that our caller's setting of
> +	 * @task->exit_state precedes checking @task->utrace_flags here.
> +	 * If utrace_set_events() was just called to enable
> +	 * UTRACE_EVENT(DEATH), then we are obliged to call
> +	 * utrace_report_death() and not miss it.  utrace_set_events()
> +	 * uses tasklist_lock to synchronize enabling the bit with the
> +	 * actual change to @task->exit_state, but we need this barrier
> +	 * to be sure we see a flags change made just before our caller
> +	 * took the tasklist_lock.
> +	 */
> +	smp_mb();
> +	if (task_utrace_flags(task) & _UTRACE_DEATH_EVENTS)
> +		utrace_report_death(task, death_cookie, group_dead, signal);
>  }

I don't think its allowed to pair a mb with a lock-barrier, since the
lock barriers are semi-permeable.

> @@ -589,10 +668,20 @@ static inline void set_notify_resume(str
>   * asynchronously, this will be called again before we return to
>   * user mode.
>   *
> - * Called without locks.
> + * Called without locks.  However, on some machines this may be
> + * called with interrupts disabled.
>   */
>  static inline void tracehook_notify_resume(struct pt_regs *regs)
>  {
> +	struct task_struct *task = current;
> +	/*
> +	 * This pairs with the barrier implicit in set_notify_resume().
> +	 * It ensures that we read the nonzero utrace_flags set before
> +	 * set_notify_resume() was called by utrace setup.
> +	 */
> +	smp_rmb();
> +	if (task_utrace_flags(task))
> +		utrace_resume(task, regs);
>  }

Sending an IPI implies the mb? I seem to remember a discussion on that
subject a while back, maybe add that do
Documentation/memory-barriers.txt

> +/*
> + * Hooks in <linux/tracehook.h> call these entry points to the
> + * utrace dispatch.  They are weak references here only so
> + * tracehook.h doesn't need to #ifndef CONFIG_UTRACE them to
> + * avoid external references in case of unoptimized compilation.
> + */
> +void utrace_free_task(struct task_struct *)
> +	__attribute__((weak));
> +bool utrace_interrupt_pending(void)
> +	__attribute__((weak));
> +void utrace_resume(struct task_struct *, struct pt_regs *)
> +	__attribute__((weak));
> +void utrace_finish_stop(void)
> +	__attribute__((weak));
> +int utrace_get_signal(struct task_struct *, struct pt_regs *,
> +		      siginfo_t *, struct k_sigaction *)
> +	__attribute__((weak));
> +void utrace_report_clone(unsigned long, struct task_struct *)
> +	__attribute__((weak));
> +void utrace_finish_vfork(struct task_struct *)
> +	__attribute__((weak));
> +void utrace_report_exit(long *exit_code)
> +	__attribute__((weak));
> +void utrace_report_death(struct task_struct *, struct utrace *, bool, int)
> +	__attribute__((weak));
> +void utrace_report_jctl(int notify, int type)
> +	__attribute__((weak));
> +void utrace_report_exec(struct linux_binfmt *, struct linux_binprm *,
> +			struct pt_regs *regs)
> +	__attribute__((weak));
> +bool utrace_report_syscall_entry(struct pt_regs *)
> +	__attribute__((weak));
> +void utrace_report_syscall_exit(struct pt_regs *)
> +	__attribute__((weak));
> +void utrace_signal_handler(struct task_struct *, int)
> +	__attribute__((weak));

Can the compiler optimize away the callsite using weak functions like
this? If not I think the normal static inline stubs make more sense.

Also, what unoptimized compilation?

> +static inline struct utrace *task_utrace_struct(struct task_struct *task)
> +{
> +	struct utrace *utrace;
> +
> +	/*
> +	 * This barrier ensures that any prior load of task->utrace_flags
> +	 * is ordered before this load of task->utrace.  We use those
> +	 * utrace_flags checks in the hot path to decide to call into
> +	 * the utrace code.  The first attach installs task->utrace before
> +	 * setting task->utrace_flags nonzero, with a barrier between.
> +	 * See utrace_task_alloc().
> +	 */
> +	smp_rmb();
> +	utrace = task->utrace;
> +
> +	smp_read_barrier_depends(); /* See utrace_task_alloc().  */
> +	return utrace;
> +}

I spot two barriers here, but only 1 over in utrace_task_alloc(), hmm?

> +/*
> + * Version number of the API defined in this file.  This will change
> + * whenever a tracing engine's code would need some updates to keep
> + * working.  We maintain this here for the benefit of tracing engine code
> + * that is developed concurrently with utrace API improvements before they
> + * are merged into the kernel, making LINUX_VERSION_CODE checks unwieldy.
> + */
> +#define UTRACE_API_VERSION	20090421

I don't think this is desired. Out-of-tree stuff just doesn't exist,
plain pure and simple.

> +enum utrace_resume_action {
> +	UTRACE_STOP,
> +	UTRACE_INTERRUPT,
> +	UTRACE_REPORT,
> +	UTRACE_SINGLESTEP,
> +	UTRACE_BLOCKSTEP,
> +	UTRACE_RESUME,
> +	UTRACE_DETACH
> +};
> +#define	UTRACE_RESUME_MASK	0x07

> +enum utrace_signal_action {
> +	UTRACE_SIGNAL_DELIVER	= 0x00,
> +	UTRACE_SIGNAL_IGN	= 0x10,
> +	UTRACE_SIGNAL_TERM	= 0x20,
> +	UTRACE_SIGNAL_CORE	= 0x30,
> +	UTRACE_SIGNAL_STOP	= 0x40,
> +	UTRACE_SIGNAL_TSTP	= 0x50,
> +	UTRACE_SIGNAL_REPORT	= 0x60,
> +	UTRACE_SIGNAL_HANDLER	= 0x70
> +};
> +#define	UTRACE_SIGNAL_MASK	0xf0
> +#define UTRACE_SIGNAL_HOLD	0x100 /* Flag, push signal back on queue.  */

> +enum utrace_syscall_action {
> +	UTRACE_SYSCALL_RUN	= 0x00,
> +	UTRACE_SYSCALL_ABORT	= 0x10
> +};
> +#define	UTRACE_SYSCALL_MASK	0xf0
> +#define	UTRACE_SYSCALL_RESUMED	0x100 /* Flag, report_syscall_entry() repeats */

Right, so this lot doesn't seem very consistent.

At the very least I would put signal action and syscall action into
different ranges.

> +/*
> + * Flags for utrace_attach_task() and utrace_attach_pid().
> + */
> +#define UTRACE_ATTACH_CREATE		0x0010 /* Attach a new engine.  */
> +#define UTRACE_ATTACH_EXCLUSIVE		0x0020 /* Refuse if existing match.  */
> +#define UTRACE_ATTACH_MATCH_OPS		0x0001 /* Match engines on ops.  */
> +#define UTRACE_ATTACH_MATCH_DATA	0x0002 /* Match engines on data.  */
> +#define UTRACE_ATTACH_MATCH_MASK	0x000f

My OCD tells me these are ordered wrong :-)

> +/**
> + * struct utrace_engine - per-engine structure
> + * @ops:	&struct utrace_engine_ops pointer passed to utrace_attach_task()
> + * @data:	engine-private &void * passed to utrace_attach_task()
> + * @flags:	event mask set by utrace_set_events() plus internal flag bits
> + *
> + * The task itself never has to worry about engines detaching while
> + * it's doing event callbacks.  These structures are removed from the
> + * task's active list only when it's stopped, or by the task itself.
> + *
> + * utrace_engine_get() and utrace_engine_put() maintain a reference count.
> + * When it drops to zero, the structure is freed.  One reference is held
> + * implicitly while the engine is attached to its task.
> + */
> +struct utrace_engine {
> +/* private: */
> +	struct kref kref;
> +	void (*release)(void *);
> +	struct list_head entry;
> +
> +/* public: */
> +	const struct utrace_engine_ops *ops;
> +	void *data;
> +
> +	unsigned long flags;
> +};

Sorry, the kernel is written in C, not C++.

> +/**
> + * struct utrace_engine_ops - tracing engine callbacks
> + *
> + * Each @report_*() callback corresponds to an %UTRACE_EVENT(*) bit.
> + * utrace_set_events() calls on @engine choose which callbacks will be made
> + * to @engine from @task.
> + *
> + * Most callbacks take an @action argument, giving the resume action
> + * chosen by other tracing engines.  All callbacks take an @engine
> + * argument, and a @task argument, which is always equal to @current.

Given that some functions have a lot of arguments (depleting regparam),
isn't it more expensive to push current on the stack than it is to
simply read it again?

> + * For some calls, @action also includes bits specific to that event
> + * and utrace_resume_action() is used to extract the resume action.
> + * This shows what would happen if @engine wasn't there, or will if
> + * the callback's return value uses %UTRACE_RESUME.  This always
> + * starts as %UTRACE_RESUME when no other tracing is being done on
> + * this task.
> + *
> + * All return values contain &enum utrace_resume_action bits.  For
> + * some calls, other bits specific to that kind of event are added to
> + * the resume action bits with OR.  These are the same bits used in
> + * the @action argument. 

> + */
> +struct utrace_engine_ops {

> +	u32 (*report_signal)(u32 action,
> +			     struct utrace_engine *engine,
> +			     struct task_struct *task,
> +			     struct pt_regs *regs,
> +			     siginfo_t *info,
> +			     const struct k_sigaction *orig_ka,
> +			     struct k_sigaction *return_ka);

> +	u32 (*report_clone)(enum utrace_resume_action action,
> +			    struct utrace_engine *engine,
> +			    struct task_struct *parent,
> +			    unsigned long clone_flags,
> +			    struct task_struct *child);

> +};

Seems inconsistent on u32 vs enum utrace_resume_action.

Why force enum utrace_resume_action into a u32?

> +/**
> + * struct utrace_examiner - private state for using utrace_prepare_examine()
> + *
> + * The members of &struct utrace_examiner are private to the implementation.
> + * This data type holds the state from a call to utrace_prepare_examine()
> + * to be used by a call to utrace_finish_examine().
> + */
> +struct utrace_examiner {
> +/* private: */
> +	long state;
> +	unsigned long ncsw;
> +};

Again, its not C++, if you want a private state like that, use an opaque
type, like:

struct utrace_examiner;

and only define the thing in utrace.c or something.

> +static inline __must_check int utrace_control_pid(
> +	struct pid *pid, struct utrace_engine *engine,
> +	enum utrace_resume_action action)
> +{
> +	/*
> +	 * We don't bother with rcu_read_lock() here to protect the
> +	 * task_struct pointer, because utrace_control will return
> +	 * -ESRCH without looking at that pointer if the engine is
> +	 * already detached.  A task_struct pointer can't die before
> +	 * all the engines are detached in release_task() first.
> +	 */
> +	struct task_struct *task = pid_task(pid, PIDTYPE_PID);
> +	return unlikely(!task) ? -ESRCH : utrace_control(task, engine, action);
> +}

Is that comment correct? Without rcu_read_lock() the pidhash can change
under our feet and maybe cause funny things?

Same for utrace_*_pid() it seems.

Does pid_task() in generaly rely on havin rcu_read_lock() called? If so,
a change in the implementation could break the assumptions here.

> +/*
> + * Per-thread structure private to utrace implementation.

See, you do know how to do private in C ;-)

> + */
> +struct utrace {
> +	spinlock_t lock;
> +	struct list_head attached, attaching;
> +
> +	struct task_struct *cloning;
> +
> +	struct utrace_engine *reporting;
> +
> +	enum utrace_resume_action resume:3;
> +	unsigned int signal_handler:1;
> +	unsigned int vfork_stop:1; /* need utrace_stop() before vfork wait */
> +	unsigned int death:1;	/* in utrace_report_death() now */
> +	unsigned int reap:1;	/* release_task() has run */
> +	unsigned int pending_attach:1; /* need splice_attaching() */
> +};

Seems inconsistent in the bitfield type, also it feels like that 3 the 7
and the enum should be more tightly integrated, maybe add:

UTRACE_RESUME_MAX

#define UTRACE_RESUME_BITS (ilog2(UTRACE_RESUME_MAX))
#define UTRACE_RESUME_MASK ((1 << UTRACE_RESUME_BITS) - 1)

And pick something consistent: u32, unsigned int or enum
utrace_resume_action.

> +/*
> + * Set up @task.utrace for the first time.  We can have races
> + * between two utrace_attach_task() calls here.  The task_lock()
> + * governs installing the new pointer.  If another one got in first,
> + * we just punt the new one we allocated.
> + *
> + * This returns false only in case of a memory allocation failure.
> + */
> +static bool utrace_task_alloc(struct task_struct *task)
> +{
> +	struct utrace *utrace = kmem_cache_zalloc(utrace_cachep, GFP_KERNEL);
> +	if (unlikely(!utrace))
> +		return false;
> +	spin_lock_init(&utrace->lock);
> +	INIT_LIST_HEAD(&utrace->attached);
> +	INIT_LIST_HEAD(&utrace->attaching);
> +	utrace->resume = UTRACE_RESUME;
> +	task_lock(task);
> +	if (likely(!task->utrace)) {
> +		/*
> +		 * This barrier makes sure the initialization of the struct
> +		 * precedes the installation of the pointer.  This pairs
> +		 * with smp_read_barrier_depends() in task_utrace_struct().
> +		 */
> +		smp_wmb();
> +		task->utrace = utrace;
> +	}
> +	task_unlock(task);
> +	/*
> +	 * That unlock after storing task->utrace acts as a memory barrier
> +	 * ordering any subsequent task->utrace_flags store afterwards.
> +	 * This pairs with smp_rmb() in task_utrace_struct().
> +	 */
> +	if (unlikely(task->utrace != utrace))
> +		kmem_cache_free(utrace_cachep, utrace);
> +	return true;
> +}

Again, not sure we can pair an UNLOCK-barrier with a RMB. In fact, both
are NOPs on x86.

> +static struct utrace_engine *matching_engine(
> +	struct utrace *utrace, int flags,
> +	const struct utrace_engine_ops *ops, void *data)
> +{
> +	struct utrace_engine *engine;
> +	list_for_each_entry(engine, &utrace->attached, entry)
> +		if (engine_matches(engine, flags, ops, data))
> +			return engine;
> +	list_for_each_entry(engine, &utrace->attaching, entry)
> +		if (engine_matches(engine, flags, ops, data))
> +			return engine;
> +	return NULL;
> +}

The function does a search, suggesting the function name ought to have
something like find or search in it.

> +/*
> + * Called without locks, when we might be the first utrace engine to attach.
> + * If this is a newborn thread and we are not the creator, we have to wait
> + * for it.  The creator gets the first chance to attach.  The PF_STARTING
> + * flag is cleared after its report_clone hook has had a chance to run.
> + */
> +static inline int utrace_attach_delay(struct task_struct *target)
> +{
> +	if ((target->flags & PF_STARTING) &&
> +	    task_utrace_struct(current) &&
> +	    task_utrace_struct(current)->cloning != target)
> +		do {
> +			schedule_timeout_interruptible(1);
> +			if (signal_pending(current))
> +				return -ERESTARTNOINTR;
> +		} while (target->flags & PF_STARTING);
> +
> +	return 0;
> +}

Quite gross this.. can't we key off the
tracehoook_report_clone_complete() and use a wakeup there?

Does this really need the inline?

Also, that if stmt really wants brackets.

> +/*
> + * Called with utrace->lock held and utrace->reap set.
> + * Notify and clean up all engines, then free utrace.
> + */
> +static void utrace_reap(struct task_struct *target, struct utrace *utrace)
> +	__releases(utrace->lock)
> +{
> +	struct utrace_engine *engine, *next;
> +
> +	/* utrace_add_engine() checks ->utrace_flags != 0 */
> +	target->utrace_flags = 0;
> +	splice_attaching(utrace);
> +
> +	/*
> +	 * Since we were called with @utrace->reap set, nobody can
> +	 * set/clear UTRACE_EVENT(REAP) in @engine->flags or change
> +	 * @engine->ops, and nobody can change @utrace->attached.
> +	 */
> +	spin_unlock(&utrace->lock);
> +
> +	list_for_each_entry_safe(engine, next, &utrace->attached, entry) {
> +		if (engine->flags & UTRACE_EVENT(REAP))
> +			engine->ops->report_reap(engine, target);
> +
> +		engine->ops = NULL;
> +		engine->flags = 0;
> +		list_del_init(&engine->entry);
> +
> +		utrace_engine_put(engine);
> +	}
> +}

Asymmetric locking like this is really better not done, and looking at
the callsites its really no bother to clean that up, arguably even makes
them saner.


> +/*
> + * Asynchronously mark an engine as being detached.
> + *
> + * This must work while the target thread races with us doing
> + * start_callback(), defined below.  It uses smp_rmb() between checking
> + * @engine->flags and using @engine->ops.  Here we change @engine->ops
> + * first, then use smp_wmb() before changing @engine->flags.  This ensures
> + * it can check the old flags before using the old ops, or check the old
> + * flags before using the new ops, or check the new flags before using the
> + * new ops, but can never check the new flags before using the old ops.
> + * Hence, utrace_detached_ops might be used with any old flags in place.
> + * It has report_quiesce() and report_reap() callbacks to handle all cases.
> + */
> +static void mark_engine_detached(struct utrace_engine *engine)
> +{
> +	engine->ops = &utrace_detached_ops;
> +	smp_wmb();
> +	engine->flags = UTRACE_EVENT(QUIESCE);
> +}

It would be more readable to split that comment into two, one part going
near the wmb, and leaving the top part describing the function, not hte
implementation.

The comments in general tend to be too long and verbose, split them up
in to shorter 3-4 line paragraphs with clear subjects/points.

Furthermore I'd add a function like:

static struct utrace_engine_ops *
get_utrace_ops(struct utrace_engine *engine, unsigned long *flags)
{
	*flags = engine->flags;
	/*
	 * This pairs with the barrier in mark_engine_detached().
	 * It makes sure that we never see the old ops vector with
	 * the new flags, in case the original vector had no
	 * report_quiesce.
	 */
	smp_rmb();
	return engine->ops;
}

to take out and explicitly comment that common bit.

Also, I'm not quite sure on why we play so many barrier games, looking
at start_callback() we have 2 barriers in the callback loop, why not a
per engine lock?

> +/*
> + * Get @target to stop and return true if it is already stopped now.
> + * If we return false, it will make some event callback soonish.
> + * Called with @utrace locked.
> + */
> +static bool utrace_do_stop(struct task_struct *target, struct utrace *utrace)
> +{
> +	if (task_is_stopped(target)) {
> +		/*
> +		 * Stopped is considered quiescent; when it wakes up, it will
> +		 * go through utrace_finish_stop() before doing anything else.
> +		 */
> +		spin_lock_irq(&target->sighand->siglock);
> +		if (likely(task_is_stopped(target)))
> +			__set_task_state(target, TASK_TRACED);
> +		spin_unlock_irq(&target->sighand->siglock);
> +	} else if (utrace->resume > UTRACE_REPORT) {
> +		utrace->resume = UTRACE_REPORT;
> +		set_notify_resume(target);
> +	}
> +
> +	return task_is_traced(target);

You could codify locking assumptions like here using:

  lockdep_assert_held(&utrace->lock);

Saves a comment and actually validates the assumption.


> +/*
> + * This is called when there might be some detached engines on the list or
> + * some stale bits in @task->utrace_flags.  Clean them up and recompute the
> + * flags.  Returns true if we're now fully detached.
> + *
> + * Called with @utrace->lock held, returns with it released.
> + * After this returns, @utrace might be freed if everything detached.
> + */
> +static bool utrace_reset(struct task_struct *task, struct utrace *utrace)
> +	__releases(utrace->lock)
> +{
> +	struct utrace_engine *engine, *next;
> +	unsigned long flags = 0;
> +	LIST_HEAD(detached);
> +
> +	splice_attaching(utrace);
> +
> +	/*
> +	 * Update the set of events of interest from the union
> +	 * of the interests of the remaining tracing engines.
> +	 * For any engine marked detached, remove it from the list.
> +	 * We'll collect them on the detached list.
> +	 */
> +	list_for_each_entry_safe(engine, next, &utrace->attached, entry) {
> +		if (engine->ops == &utrace_detached_ops) {
> +			engine->ops = NULL;
> +			list_move(&engine->entry, &detached);
> +		} else {
> +			flags |= engine->flags | UTRACE_EVENT(REAP);
> +		}
> +	}
> +
> +	if (task->exit_state) {
> +		/*
> +		 * Once it's already dead, we never install any flags
> +		 * except REAP.  When ->exit_state is set and events
> +		 * like DEATH are not set, then they never can be set.
> +		 * This ensures that utrace_release_task() knows
> +		 * positively that utrace_report_death() can never run.
> +		 */
> +		BUG_ON(utrace->death);
> +		flags &= UTRACE_EVENT(REAP);
> +	} else if (!(flags & UTRACE_EVENT_SYSCALL) &&
> +		   test_tsk_thread_flag(task, TIF_SYSCALL_TRACE)) {
> +		clear_tsk_thread_flag(task, TIF_SYSCALL_TRACE);
> +	}
> +
> +	if (!flags) {
> +		/*
> +		 * No more engines, cleared out the utrace.
> +		 */
> +		utrace->resume = UTRACE_RESUME;
> +		utrace->signal_handler = 0;
> +	}
> +
> +	if (task_is_traced(task) && !(flags & ENGINE_STOP))
> +		/*
> +		 * No more engines want it stopped.  Wake it up.
> +		 */
> +		utrace_wakeup(task, utrace);

wants braces.

> +	/*
> +	 * In theory spin_lock() doesn't imply rcu_read_lock().
> +	 * Once we clear ->utrace_flags this task_struct can go away
> +	 * because tracehook_prepare_release_task() path does not take
> +	 * utrace->lock when ->utrace_flags == 0.
> +	 */
> +	rcu_read_lock();
> +	task->utrace_flags = flags;
> +	spin_unlock(&utrace->lock);
> +	rcu_read_unlock();

yuck!

why not simply keep a task reference over the utrace_reset call?

Also, that unlock really wants to be in the caller, things like:

 if (reset)
   utrace_reset()
 else
   spin_unlock(&utrace->lock)

are just vile.

> +	put_detached_list(&detached);
> +
> +	return !flags;
> +}


> +/*
> + * Perform %UTRACE_STOP, i.e. block in TASK_TRACED until woken up.
> + * @task == current, @utrace == current->utrace, which is not locked.
> + * Return true if we were woken up by SIGKILL even though some utrace
> + * engine may still want us to stay stopped.
> + */
> +static void utrace_stop(struct task_struct *task, struct utrace *utrace,
> +			enum utrace_resume_action action)
> +{
> +relock:
> +	spin_lock(&utrace->lock);
> +
> +	if (action < utrace->resume) {
> +		/*
> +		 * Ensure a reporting pass when we're resumed.
> +		 */
> +		utrace->resume = action;
> +		if (action == UTRACE_INTERRUPT)
> +			set_thread_flag(TIF_SIGPENDING);
> +		else
> +			set_thread_flag(TIF_NOTIFY_RESUME);
> +	}
> +
> +	/*
> +	 * If the ENGINE_STOP bit is clear in utrace_flags, that means
> +	 * utrace_reset() ran after we processed some UTRACE_STOP return
> +	 * values from callbacks to get here.  If all engines have detached
> +	 * or resumed us, we don't stop.  This check doesn't require
> +	 * siglock, but it should follow the interrupt/report bookkeeping
> +	 * steps (this can matter for UTRACE_RESUME but not UTRACE_DETACH).
> +	 */
> +	if (unlikely(!(task->utrace_flags & ENGINE_STOP))) {
> +		utrace_reset(task, utrace);
> +		if (task->utrace_flags & ENGINE_STOP)
> +			goto relock;
> +		return;
> +	}
> +
> +	/*
> +	 * The siglock protects us against signals.  As well as SIGKILL
> +	 * waking us up, we must synchronize with the signal bookkeeping
> +	 * for stop signals and SIGCONT.
> +	 */
> +	spin_lock_irq(&task->sighand->siglock);
> +
> +	if (unlikely(__fatal_signal_pending(task))) {
> +		spin_unlock_irq(&task->sighand->siglock);
> +		spin_unlock(&utrace->lock);
> +		return;
> +	}
> +
> +	__set_current_state(TASK_TRACED);
> +
> +	/*
> +	 * If there is a group stop in progress,
> +	 * we must participate in the bookkeeping.
> +	 */
> +	if (unlikely(task->signal->group_stop_count) &&
> +			!--task->signal->group_stop_count)
> +		task->signal->flags = SIGNAL_STOP_STOPPED;
> +
> +	spin_unlock_irq(&task->sighand->siglock);
> +	spin_unlock(&utrace->lock);
> +
> +	/*
> +	 * If ptrace is among the reasons for this stop, do its
> +	 * notification now.  This could not just be done in
> +	 * ptrace's own event report callbacks because it has to
> +	 * be done after we are in TASK_TRACED.  This makes the
> +	 * synchronization with ptrace_do_wait() work right.
> +	 */
> +	ptrace_notify_stop(task);

Well, this is a bit disappointing isn't it? So we cannot implement
ptrace on utrace without special purpose hooks?

> +	schedule();
> +
> +	utrace_finish_stop();
> +
> +	/*
> +	 * While in TASK_TRACED, we were considered "frozen enough".
> +	 * Now that we woke up, it's crucial if we're supposed to be
> +	 * frozen that we freeze now before running anything substantial.
> +	 */
> +	try_to_freeze();
> +
> +	/*
> +	 * While we were in TASK_TRACED, complete_signal() considered
> +	 * us "uninterested" in signal wakeups.  Now make sure our
> +	 * TIF_SIGPENDING state is correct for normal running.
> +	 */
> +	spin_lock_irq(&task->sighand->siglock);
> +	recalc_sigpending();
> +	spin_unlock_irq(&task->sighand->siglock);
> +}



> +/**

> + */
> +int utrace_control(struct task_struct *target,
> +		   struct utrace_engine *engine,
> +		   enum utrace_resume_action action)
> +{
> +	struct utrace *utrace;
> +	bool reset;
> +	int ret;
> +
> +	if (unlikely(action > UTRACE_DETACH))
> +		return -EINVAL;

If you'd have added UTRACE_RESUME_MAX, you could have avoided the
assumption DETACH is the last one.

> +	/*
> +	 * This is a sanity check for a programming error in the caller.
> +	 * Their request can only work properly in all cases by relying on
> +	 * a follow-up callback, but they didn't set one up!  This check
> +	 * doesn't do locking, but it shouldn't matter.  The caller has to
> +	 * be synchronously sure the callback is set up to be operating the
> +	 * interface properly.
> +	 */
> +	if (action >= UTRACE_REPORT && action < UTRACE_RESUME &&
> +	    unlikely(!(engine->flags & UTRACE_EVENT(QUIESCE))))
> +		return -EINVAL;

If its a programming error, WARN_ON might be appropriate, no point in
being nice about it.

> +	utrace = get_utrace_lock(target, engine, true);
> +	if (unlikely(IS_ERR(utrace)))
> +		return PTR_ERR(utrace);
> +
> +	reset = task_is_traced(target);
> +	ret = 0;
> +
> +	/*
> +	 * ->exit_state can change under us, this doesn't matter.
> +	 * We do not care about ->exit_state in fact, but we do
> +	 * care about ->reap and ->death. If either flag is set,
> +	 * we must also see ->exit_state != 0.
> +	 */
> +	if (unlikely(target->exit_state)) {
> +		ret = utrace_control_dead(target, utrace, action);
> +		if (ret) {
> +			spin_unlock(&utrace->lock);
> +			return ret;
> +		}
> +		reset = true;
> +	}
> +
> +	switch (action) {

> +	}
> +
> +	/*
> +	 * Let the thread resume running.  If it's not stopped now,
> +	 * there is nothing more we need to do.
> +	 */
> +	if (reset)
> +		utrace_reset(target, utrace);
> +	else
> +		spin_unlock(&utrace->lock);

yuckness..

> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(utrace_control);
> +
> +/**
> + * utrace_barrier - synchronize with simultaneous tracing callbacks
> + * @target:		thread to affect
> + * @engine:		engine to affect (can be detached)
> + *
> + * This blocks while @target might be in the midst of making a callback to
> + * @engine.  It can be interrupted by signals and will return -%ERESTARTSYS.
> + * A return value of zero means no callback from @target to @engine was
> + * in progress.  Any effect of its return value (such as %UTRACE_STOP) has
> + * already been applied to @engine.
> + *
> + * It's not necessary to keep the @target pointer alive for this call.
> + * It's only necessary to hold a ref on @engine.  This will return
> + * safely even if @target has been reaped and has no task refs.
> + *
> + * A successful return from utrace_barrier() guarantees its ordering
> + * with respect to utrace_set_events() and utrace_control() calls.  If
> + * @target was not properly stopped, event callbacks just disabled might
> + * still be in progress; utrace_barrier() waits until there is no chance
> + * an unwanted callback can be in progress.
> + */
> +int utrace_barrier(struct task_struct *target, struct utrace_engine *engine)
> +{
> +	struct utrace *utrace;
> +	int ret = -ERESTARTSYS;
> +
> +	if (unlikely(target == current))
> +		return 0;
> +
> +	do {
> +		utrace = get_utrace_lock(target, engine, false);
> +		if (unlikely(IS_ERR(utrace))) {
> +			ret = PTR_ERR(utrace);
> +			if (ret != -ERESTARTSYS)
> +				break;
> +		} else {
> +			/*
> +			 * All engine state changes are done while
> +			 * holding the lock, i.e. before we get here.
> +			 * Since we have the lock, we only need to
> +			 * worry about @target making a callback.
> +			 * When it has entered start_callback() but
> +			 * not yet gotten to finish_callback(), we
> +			 * will see utrace->reporting == @engine.
> +			 * When @target doesn't take the lock, it uses
> +			 * barriers to order setting utrace->reporting
> +			 * before it examines the engine state.
> +			 */
> +			if (utrace->reporting != engine)
> +				ret = 0;
> +			spin_unlock(&utrace->lock);
> +			if (!ret)
> +				break;
> +		}
> +		schedule_timeout_interruptible(1);
> +	} while (!signal_pending(current));

Seriously ugly, again. Use a wakeup where appropriate.

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(utrace_barrier);

> +/*
> + * We are now making the report, so clear the flag saying we need one.
> + * When there is a new attach, ->pending_attach is set just so we will
> + * know to do splice_attaching() here before the callback loop.
> + */
> +static enum utrace_resume_action start_report(struct utrace *utrace)
> +{
> +	enum utrace_resume_action resume = utrace->resume;
> +	if (utrace->pending_attach ||
> +	    (resume > UTRACE_INTERRUPT && resume < UTRACE_RESUME)) {
> +		spin_lock(&utrace->lock);
> +		splice_attaching(utrace);
> +		resume = utrace->resume;
> +		if (resume > UTRACE_INTERRUPT)
> +			utrace->resume = UTRACE_RESUME;
> +		spin_unlock(&utrace->lock);
> +	}
> +	return resume;
> +}

Its not entirely clear why we can check pending_attach outside of the
utrace->lock and not be racy.

> +static inline void finish_report_reset(struct task_struct *task,
> +				       struct utrace *utrace,
> +				       struct utrace_report *report)
> +{
> +	if (unlikely(report->spurious || report->detaches)) {
> +		spin_lock(&utrace->lock);
> +		if (utrace_reset(task, utrace))
> +			report->action = UTRACE_RESUME;
> +	}
> +}

More asymmetric locking...


> +static inline void finish_callback_report(struct task_struct *task,
> +					  struct utrace *utrace,
> +					  struct utrace_report *report,
> +					  struct utrace_engine *engine,
> +					  enum utrace_resume_action action)
> +{
> +	/*
> +	 * If utrace_control() was used, treat that like UTRACE_DETACH here.
> +	 */
> +	if (action == UTRACE_DETACH || engine->ops == &utrace_detached_ops) {
> +		engine->ops = &utrace_detached_ops;
> +		report->detaches = true;
> +		return;
> +	}
> +
> +	if (action < report->action)
> +		report->action = action;
> +
> +	if (action != UTRACE_STOP) {
> +		if (action < report->resume_action)
> +			report->resume_action = action;
> +
> +		if (engine_wants_stop(engine)) {
> +			spin_lock(&utrace->lock);
> +			clear_engine_wants_stop(engine);
> +			spin_unlock(&utrace->lock);
> +		}

Reads funny, but I guess it can only race the right way round?

> +		return;
> +	}
> +
> +	if (!engine_wants_stop(engine)) {
> +		spin_lock(&utrace->lock);
> +		/*
> +		 * If utrace_control() came in and detached us
> +		 * before we got the lock, we must not stop now.
> +		 */
> +		if (unlikely(engine->ops == &utrace_detached_ops))
> +			report->detaches = true;
> +		else
> +			mark_engine_wants_stop(task, engine);
> +		spin_unlock(&utrace->lock);
> +	}
> +}

I'm pretty sure that inline isn't really needed.

> +/*
> + * Apply the return value of one engine callback to @report.
> + * Returns true if @engine detached and should not get any more callbacks.
> + */
> +static bool finish_callback(struct task_struct *task, struct utrace *utrace,
> +			    struct utrace_report *report,
> +			    struct utrace_engine *engine,
> +			    u32 ret)
> +{
> +	report->result = ret & ~UTRACE_RESUME_MASK;
> +	finish_callback_report(task, utrace, report, engine,
> +			       utrace_resume_action(ret));
> +
> +	/*
> +	 * Now that we have applied the effect of the return value,
> +	 * clear this so that utrace_barrier() can stop waiting.
> +	 * A subsequent utrace_control() can stop or resume @engine
> +	 * and know this was ordered after its callback's action.
> +	 *
> +	 * We don't need any barriers here because utrace_barrier()
> +	 * takes utrace->lock.  If we touched engine->flags above,
> +	 * the lock guaranteed this change was before utrace_barrier()
> +	 * examined utrace->reporting.
> +	 */
> +	utrace->reporting = NULL;
> +
> +	/*
> +	 * This is a good place to make sure tracing engines don't
> +	 * introduce too much latency under voluntary preemption.
> +	 */
> +	if (need_resched())
> +		cond_resched();

Simply cond_resched() is sufficient, but that comment sucks, as it
doesn't mention _why_ it is a good place.

It seems to turn out that finish_callback() is always the last thing we
do in the engine iterations in REPORT_CALLBACKS() and
utrace_get_signal().

> +
> +	return engine->ops == &utrace_detached_ops;
> +}
> +
> +/*
> + * Start the callbacks for @engine to consider @event (a bit mask).
> + * This makes the report_quiesce() callback first.  If @engine wants
> + * a specific callback for @event, we return the ops vector to use.
> + * If not, we return NULL.  The return value from the ops->callback
> + * function called should be passed to finish_callback().
> + */
> +static const struct utrace_engine_ops *start_callback(
> +	struct utrace *utrace, struct utrace_report *report,
> +	struct utrace_engine *engine, struct task_struct *task,
> +	unsigned long event)
> +{
> +	const struct utrace_engine_ops *ops;
> +	unsigned long want;
> +
> +	/*
> +	 * This barrier ensures that we've set utrace->reporting before
> +	 * we examine engine->flags or engine->ops.  utrace_barrier()
> +	 * relies on this ordering to indicate that the effect of any
> +	 * utrace_control() and utrace_set_events() calls is in place
> +	 * by the time utrace->reporting can be seen to be NULL.
> +	 */
> +	utrace->reporting = engine;
> +	smp_mb();
> +
> +	/*
> +	 * This pairs with the barrier in mark_engine_detached().
> +	 * It makes sure that we never see the old ops vector with
> +	 * the new flags, in case the original vector had no report_quiesce.
> +	 */
> +	want = engine->flags;
> +	smp_rmb();
> +	ops = engine->ops;
> +
> +	if (want & UTRACE_EVENT(QUIESCE)) {
> +		if (finish_callback(task, utrace, report, engine,
> +				    (*ops->report_quiesce)(report->action,
> +							   engine, task,
> +							   event)))
> +			return NULL;
> +
> +		/*
> +		 * finish_callback() reset utrace->reporting after the
> +		 * quiesce callback.  Now we set it again (as above)
> +		 * before re-examining engine->flags, which could have
> +		 * been changed synchronously by ->report_quiesce or
> +		 * asynchronously by utrace_control() or utrace_set_events().
> +		 */
> +		utrace->reporting = engine;
> +		smp_mb();
> +		want = engine->flags;
> +	}
> +
> +	if (want & ENGINE_STOP)
> +		report->action = UTRACE_STOP;
> +
> +	if (want & event) {
> +		report->spurious = false;
> +		return ops;
> +	}
> +
> +	utrace->reporting = NULL;
> +	return NULL;
> +}

This function makes my head hurt... it would be very nice to see an
obvious version and a set of patches obfuscating it, with numbers
defending the obfuscation.

> +/*
> + * Do a normal reporting pass for engines interested in @event.
> + * @callback is the name of the member in the ops vector, and remaining
> + * args are the extras it takes after the standard three args.
> + */
> +#define REPORT(task, utrace, report, event, callback, ...)		      \
> +	do {								      \
> +		start_report(utrace);					      \
> +		REPORT_CALLBACKS(, task, utrace, report, event, callback,     \
> +				 (report)->action, engine, current,	      \
> +				 ## __VA_ARGS__);  	   		      \
> +		finish_report(task, utrace, report, true);		      \
> +	} while (0)
> +#define REPORT_CALLBACKS(rev, task, utrace, report, event, callback, ...)     \
> +	do {								      \
> +		struct utrace_engine *engine;				      \
> +		const struct utrace_engine_ops *ops;			      \
> +		list_for_each_entry##rev(engine, &utrace->attached, entry) {  \
> +			ops = start_callback(utrace, report, engine, task,    \
> +					     event);			      \
> +			if (!ops)					      \
> +				continue;				      \
> +			finish_callback(task, utrace, report, engine,	      \
> +					(*ops->callback)(__VA_ARGS__));	      \
> +		}							      \
> +	} while (0)

My OCD makes me tell you that these macros are defined in the wrong
order.

> +void utrace_report_clone(unsigned long clone_flags, struct task_struct *child)
> +{
> +	struct task_struct *task = current;
> +	struct utrace *utrace = task_utrace_struct(task);
> +	INIT_REPORT(report);
> +
> +	/*
> +	 * We don't use the REPORT() macro here, because we need
> +	 * to clear utrace->cloning before finish_report().
> +	 * After finish_report(), utrace can be a stale pointer
> +	 * in cases when report.action is still UTRACE_RESUME.
> +	 */
> +	start_report(utrace);
> +	utrace->cloning = child;
> +
> +	REPORT_CALLBACKS(, task, utrace, &report,
> +			 UTRACE_EVENT(CLONE), report_clone,
> +			 report.action, engine, task, clone_flags, child);
> +
> +	utrace->cloning = NULL;
> +	finish_report(task, utrace, &report, !(clone_flags & CLONE_VFORK));
> +
> +	/*
> +	 * For a vfork, we will go into an uninterruptible block waiting
> +	 * for the child.  We need UTRACE_STOP to happen before this, not
> +	 * after.  For CLONE_VFORK, utrace_finish_vfork() will be called.
> +	 */
> +	if (report.action == UTRACE_STOP && (clone_flags & CLONE_VFORK)) {
> +		spin_lock(&utrace->lock);
> +		utrace->vfork_stop = 1;
> +		spin_unlock(&utrace->lock);
> +	}

So much optimization, weird locking, barriers and here you didn't use
atomic bit ops?

> +}
> +
> +/*
> + * We're called after utrace_report_clone() for a CLONE_VFORK.
> + * If UTRACE_STOP was left from the clone report, we stop here.
> + * After this, we'll enter the uninterruptible wait_for_completion()
> + * waiting for the child.
> + */
> +void utrace_finish_vfork(struct task_struct *task)
> +{
> +	struct utrace *utrace = task_utrace_struct(task);
> +
> +	if (utrace->vfork_stop) {
> +		spin_lock(&utrace->lock);
> +		utrace->vfork_stop = 0;
> +		spin_unlock(&utrace->lock);
> +		utrace_stop(task, utrace, UTRACE_RESUME); /* XXX */
> +	}
> +}

I'm sure that XXX means something,... again that vfork_stop stuff can
only race the right way about, right?

> +
> +/*
> + * Called iff UTRACE_EVENT(JCTL) flag is set.
> + *
> + * Called with siglock held.
> + */
> +void utrace_report_jctl(int notify, int what)
> +{
> +	struct task_struct *task = current;
> +	struct utrace *utrace = task_utrace_struct(task);
> +	INIT_REPORT(report);
> +
> +	spin_unlock_irq(&task->sighand->siglock);
> +
> +	REPORT(task, utrace, &report, UTRACE_EVENT(JCTL),
> +	       report_jctl, what, notify);
> +
> +	spin_lock_irq(&task->sighand->siglock);
> +}

So much documentation, and non of it says that the JCTL (funny name btw)
callback is done holding siglock... tskk.

> +/*
> + * Finish the last reporting pass before returning to user mode.
> + */
> +static void finish_resume_report(struct task_struct *task,
> +				 struct utrace *utrace,
> +				 struct utrace_report *report)
> +{
> +	finish_report_reset(task, utrace, report);
> +
> +	switch (report->action) {
> +	case UTRACE_STOP:
> +		utrace_stop(task, utrace, report->resume_action);
> +		break;
> +
> +	case UTRACE_INTERRUPT:
> +		if (!signal_pending(task))
> +			set_tsk_thread_flag(task, TIF_SIGPENDING);
> +		break;
> +
> +	case UTRACE_BLOCKSTEP:
> +		if (likely(arch_has_block_step())) {
> +			user_enable_block_step(task);
> +			break;
> +		}
> +
> +		/*
> +		 * This means some callback is to blame for failing
> +		 * to check arch_has_block_step() itself.  Warn and
> +		 * then fall through to treat it as SINGLESTEP.
> +		 */
> +		WARN_ON(1);
> +
> +	case UTRACE_SINGLESTEP:
> +		if (likely(arch_has_single_step()))
> +			user_enable_single_step(task);
> +		else
> +			/*
> +			 * This means some callback is to blame for failing
> +			 * to check arch_has_single_step() itself.  Spew
> +			 * about it so the loser will fix his module.
> +			 */
> +			WARN_ON(1);

wants braces

> +		break;
> +
> +	case UTRACE_REPORT:
> +	case UTRACE_RESUME:
> +	default:
> +		user_disable_single_step(task);
> +		break;
> +	}
> +}
> +
> +/*
> + * This is called when TIF_NOTIFY_RESUME had been set (and is now clear).
> + * We are close to user mode, and this is the place to report or stop.
> + * When we return, we're going to user mode or into the signals code.
> + */
> +void utrace_resume(struct task_struct *task, struct pt_regs *regs)
> +{
> +	struct utrace *utrace = task_utrace_struct(task);
> +	INIT_REPORT(report);
> +	struct utrace_engine *engine;
> +
> +	/*
> +	 * Some machines get here with interrupts disabled.  The same arch
> +	 * code path leads to calling into get_signal_to_deliver(), which
> +	 * implicitly reenables them by virtue of spin_unlock_irq.
> +	 */
> +	local_irq_enable();

Hrmm, I would much prefer to fix up the calling conventions of
tracehook_notify_resume() than to bury something like this in the guts
of a tracehook user.

> +	/*
> +	 * If this flag is still set it's because there was a signal
> +	 * handler setup done but no report_signal following it.  Clear
> +	 * the flag before we get to user so it doesn't confuse us later.
> +	 */
> +	if (unlikely(utrace->signal_handler)) {
> +		spin_lock(&utrace->lock);
> +		utrace->signal_handler = 0;
> +		spin_unlock(&utrace->lock);
> +	}

OK, so maybe you get to explain why this works..

> +
> +	/*
> +	 * Update our bookkeeping even if there are no callbacks made here.
> +	 */
> +	report.action = start_report(utrace);
> +
> +	switch (report.action) {
> +	case UTRACE_RESUME:
> +		/*
> +		 * Anything we might have done was already handled by
> +		 * utrace_get_signal(), or this is an entirely spurious
> +		 * call.  (The arch might use TIF_NOTIFY_RESUME for other
> +		 * purposes as well as calling us.)
> +		 */
> +		return;
> +	case UTRACE_REPORT:
> +		if (unlikely(!(task->utrace_flags & UTRACE_EVENT(QUIESCE))))
> +			break;
> +		/*
> +		 * Do a simple reporting pass, with no specific
> +		 * callback after report_quiesce.
> +		 */
> +		report.action = UTRACE_RESUME;
> +		list_for_each_entry(engine, &utrace->attached, entry)
> +			start_callback(utrace, &report, engine, task, 0);
> +		break;
> +	default:
> +		/*
> +		 * Even if this report was truly spurious, there is no need
> +		 * for utrace_reset() now.  TIF_NOTIFY_RESUME was already
> +		 * cleared--it doesn't stay spuriously set.
> +		 */
> +		report.spurious = false;
> +		break;
> +	}
> +
> +	/*
> +	 * Finish the report and either stop or get ready to resume.
> +	 * If utrace->resume was not UTRACE_REPORT, this applies its
> +	 * effect now (i.e. step or interrupt).
> +	 */
> +	finish_resume_report(task, utrace, &report);
> +}


> +/*
> + * Take the siglock and push @info back on our queue.
> + * Returns with @task->sighand->siglock held.
> + */
> +static void push_back_signal(struct task_struct *task, siginfo_t *info)
> +	__acquires(task->sighand->siglock)
> +{
> +	struct sigqueue *q;
> +
> +	if (unlikely(!info->si_signo)) { /* Oh, a wise guy! */
> +		spin_lock_irq(&task->sighand->siglock);
> +		return;
> +	}
> +
> +	q = sigqueue_alloc();
> +	if (likely(q)) {
> +		q->flags = 0;
> +		copy_siginfo(&q->info, info);
> +	}
> +
> +	spin_lock_irq(&task->sighand->siglock);
> +
> +	sigaddset(&task->pending.signal, info->si_signo);
> +	if (likely(q))
> +		list_add(&q->list, &task->pending.list);
> +
> +	set_tsk_thread_flag(task, TIF_SIGPENDING);
> +}

Yes, exactly what we need, more funky locking.. 

/me gives up..

OK, so what this code needs is some serious restructuring and
de-obfuscation, after that we can maybe get creative and add some of it
back if the performance numbers agree.

But there's too much ugly locking and barriers to be fully sane.

Also the documentation needs more whitespace, its very hard to digest in
its current form.

I'll try and look at the actual state machine later, when my brain has
recovered from this.

