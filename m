Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbXCERZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbXCERZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 12:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbXCERZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 12:25:26 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36650 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752816AbXCERZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 12:25:25 -0500
Date: Mon, 5 Mar 2007 12:25:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070305070136.4CB881801C4@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0703051118200.3401-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2007, Roland McGrath wrote:

> Thanks, Alan.  Great work.  I have some suggestions for changes.
> 
> > 	I pretty much copied the existing code for handling vm86 mode
> > 	and single-step exceptions, without fully understanding it.
> > 
> > 	The code doesn't virtualize the BS (single-step) flag in DR6
> > 	for userspace.  It could be added, but I wonder whether it is
> > 	really needed.
> 
> There is only one TF flag, it and the DR_STEP bit in dr6 are part of the
> unitary thread state.  You should not be doing anything at all on
> single-step exceptions.

Presumably you mean that hw-breakpoint.c shouldn't do anything at all on
single-step exceptions.  do_debug does have to know about them, because it
has to know whether or not to send a SIGTRAP.  Separation of duties; I
tried to move too much out of do_debug.


> > 	Setting user breakpoints on I/O ports should require permissions
> > 	checking.  I haven't tried to figure out how that works or
> > 	how to implement it yet.
> 
> I would just leave the I/O breakpoint feature out for the first cut.  
> See if there is demand for it.  

Good enough.

> It requires setting CR4.DE, which we don't do.  The validation is
> relatively simple, comparing against the io_bitmap_ptr data (if any).
> You can check at insertion time (requiring doing ioperm before inserting
> an I/O breakpoint), and then check again at exception time if the hit
> was in kernel mode and ignore it for a user-only breakpoint, or perhaps
> check again and eject the breakpoint if it's been cleared from the
> ioperm bitmap.

It's easier simply to ignore the whole issue.  :-)  Fortunately many other 
architectures don't have to worry about it at all.


> > 	It seems likely that some of the new routines should be marked
> > 	"__kprobes", but I don't know which, or even what that annotation
> > 	is supposed to mean.
> 
> That annotation is for code that is in the kprobes maintenance code path
> (where you cannot insert kprobes).  do_debug has it for the notify_die
> path that might lead to kprobes.  The only thing in your code that
> should need it is your notifier function, which might get called for an
> exception that turns out to be a kprobes single-step.  There shouldn't
> be any problem inserting kprobes into the other hwbkpt code.

Got it.


> > 	The parts relating to kernel breakpoints could be made conditional
> > 	on a Kconfig option.  The amount of code space saved would be
> > 	relatively small; I'm not sure that it would be worthwhile.
> 
> In a utrace merge, the user parts can be made conditional on CONFIG_UTRACE.
> Then with both turned off, the code goes away completely.  It's unlikely it
> will ever be turned off, but it is a clean way to go about things in case
> someone wants the smallest possible config for a limited-use installation.

So far I've been developing under 2.6.21-rc, which doesn't have utrace.  
But eventually this will be submitted by way of -mm, which does.  The
easiest approach would be to make the whole thing conditional on 
CONFIG_UTRACE.


> > +	void		*data;
> 
> Leave this out.  Let the caller embed struct hwbkpt in his larger struct
> and use container_of.

Okay.


> > +/*
> > + * The tsk argument in the following three routines will usually be a
> > + * process being PTRACEd by the current task, normally a debugger.
> > + * It is also legal for tsk to be the current task.  In either case we
> > + * can guarantee that tsk will not start running on another CPU while
> > + * its breakpoints are being modified.  If that happened it could cause
> > + * a crash.
> > + */
> > +int register_user_hwbkpt(struct task_struct *tsk, struct hwbkpt *bp);
> > +void unregister_user_hwbkpt(struct task_struct *tsk, struct hwbkpt *bp);
> > +int modify_user_hwbkpt(struct task_struct *tsk, struct hwbkpt *bp,
> > +		void *address, u8 len, u8 type);
> 
> These are the kinds of constraints utrace is there to make doable.
> (I'm assuming that guarantee is really "will not start running in
> user mode", since SIGKILL is always possible.)

The actual guarantee I need is that nobody will switch_to() the task while
my routines are running.

>  In a utrace merge,
> I think we want the only entry points for this to be a utrace-based
> interface that explicitly requires utrace's notion of quiescence
> (as its accessors for thread register data do).

Yes; I had in mind that the user-breakpoint part would be called only by 
utrace and/or ptrace.  That's why the routines aren't EXPORTed.  But I 
wrote it in more general form, to make it easier to understand.  I'll add 
some comments about this.


> > +/*
> > + * Kernel breakpoints are not associated with any particular thread.
> > + */
> > +int register_kernel_hwbkpt(struct hwbkpt *bp);
> > +void unregister_kernel_hwbkpt(struct hwbkpt *bp);
> 
> Potentially kernel users might want per-thread installations, if
> it's simple to provide the option.  e.g., a probe at some syscall
> entry that installs a watchpoint while calling into complex
> subsystems, and then removes it before returning.

If someone really needs to do that, they can always put their own call to
(un)register_kernel_hwbkpt() at the entry(exit) to the complex subsystems.  
Or perhaps it should be a job for systemtap, which would use hwbkpt to do
the actual work.


> > @@ -379,15 +381,15 @@ void exit_thread(void)
> >  		tss->io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
> >  		put_cpu();
> >  	}
> > +	flush_thread_hwbkpt(tsk);
> 
> I'd make this do if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG))),

That's the wrong test, but I get your point.

> or make it an inline doing that test before calling out to the guts.
> Most of the time the hwbkpt code need not be on a hot path, and the
> exit path will be one.

Not nearly as hot as switch_to()!  But I'll do it.


> > +struct thread_hwbkpt {		/* HW breakpoint info for a thread */
> > +
> > +	/* utrace support */
> > +	struct list_head	node;		/* Entry in thread list */
> > +	struct list_head	thread_bps;	/* Thread's breakpoints */
> > +	unsigned long		tdr7;		/* Thread's DR7 value */
> > +
> > +	/* ptrace support */
> > +	struct hwbkpt		ptrace_bps[HB_NUM];
> 
> I wouldn't use ptrace in the name, it's "the thread's virtual state".

That may be so, but the only way to access that part of the state is via
ptrace.  Think of it this way: The debug register settings really should
not be part of the thread's virtual state.  If we had some other, more
logical API for managing breakpoints in a task then ptrace_bps[] wouldn't
be necessary at all (other than for backward compatibility perhaps).

> You shouldn't need a struct hwbpkt here really, just unsigned long vdr[4].

That would make things much more complicated.  It's a lot easier to treat 
all breakpoints as though they are the same under the hood.

Besides, the extra memory usage will show up only on threads that are 
being debugged, which means we can safely ignore it.


> > +		/* Check whether bp->address points to user space */
> > +		if ((tsk != NULL) != ((unsigned long) bp->address < TASK_SIZE))
> 
> On x86_64, make sure this is TASK_SIZE_OF(tsk).

Another thing to watch out for is that we would have to allow length-8
breakpoints in 64-bit mode.  I'll add a few comments.


> > +	if (val != DIE_DEBUG)
> > +		return NOTIFY_DONE;
> 
> The very next thing should be:
> 
> 	dr6 = ((struct die_args *) data)->err;
> 	if ((dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) == 0)
> 		return NOTIFY_DONE;
> 	if (unlikely(regs->eflags & VM_MASK))
> 		return NOTIFY_DONE;
> 
> You are not involved at all if the exception was not produced by a debug
> register setting.  When no notify_die hook returns NOTIFY_STOP, do_debug
> should do thread->vdr6 |= dr6.  (In practice this will only be the DR_STEP
> bit, but maybe others will come along in later chips.  If you're not
> explicitly virtualizing something, you should be passing it through.)

I get the picture.

> To avoid this needing to do allocation when TIF_DEBUG was not already set,
> probably the vdr6 should stay in thread_struct directly alongside the pointer.

Good idea.


> > +		if (!(dr6 & (0x1 << i)))
> > +			continue;
> 
> Use (DR_TRAP0 << i).

Okay.


> > +static struct notifier_block hwbkpt_exceptions_nb = {
> > +	.notifier_call = hwbkpt_exceptions_notify,
> > +	.priority = INT_MAX - 1		/* We need to be notified second */
> 
> The order shouldn't matter if everyone only swallows their own exceptions.

True.  .priority can take on its default value of 0.

> kprobes needs to be a little better behaved this way:
> 
> diff --git a/arch/i386/kernel/kprobes.c b/arch/i386/kernel/kprobes.c
> index b545bc7..0000000 100644  
> --- a/arch/i386/kernel/kprobes.c
> +++ b/arch/i386/kernel/kprobes.c
> @@ -670,7 +670,7 @@ int __kprobes kprobe_exceptions_notify(s
>  			ret = NOTIFY_STOP;
>  		break;
>  	case DIE_DEBUG:
> -		if (post_kprobe_handler(args->regs))
> +		if ((args->err & DR_STEP) && post_kprobe_handler(args->regs))
>  			ret = NOTIFY_STOP;
>  		break;
>  	case DIE_GPF:
> diff --git a/arch/x86_64/kernel/kprobes.c b/arch/x86_64/kernel/kprobes.c
> index 209c8c0..0000000 100644  
> --- a/arch/x86_64/kernel/kprobes.c
> +++ b/arch/x86_64/kernel/kprobes.c
> @@ -661,7 +661,7 @@ int __kprobes kprobe_exceptions_notify(s
>  			ret = NOTIFY_STOP;
>  		break;
>  	case DIE_DEBUG:
> -		if (post_kprobe_handler(args->regs))
> +		if ((args->err & DR_STEP) && post_kprobe_handler(args->regs))
>  			ret = NOTIFY_STOP;
>  		break;
>  	case DIE_GPF:

That doesn't seem quite right.  What if you encounter _both_ a single-step 
exception and a breakpoint at the same time?  Probably kprobes should 
always return NOTIFY_DONE.

Which implies that do_debug needs to decide whether or not to issue 
SIGTRAP.  Presumably the condition will be that any of the DR_STEP or 
DR_TRAPn bits remain set after the notifier chain has run.  This means the 
kprobes code will have to be modified to clear DR_STEP in args->err.


> > Index: 2.6.21-rc2/arch/i386/kernel/ptrace.c
> > ===================================================================
> > --- 2.6.21-rc2.orig/arch/i386/kernel/ptrace.c
> > +++ 2.6.21-rc2/arch/i386/kernel/ptrace.c
> 
> I would like all this stuff to be in hw-breakpoint.c, and just called with:
> 
>     int thread_set_debugreg(struct task_struct *, int n, unsigned long val);
>     unsigned long thread_get_debugreg(struct task_struct *, int n);

Easy enough.  I'll just move the code from one file to the other.

> Writes to 0..3,6 can just write the slot (after allocating the thread's
> struct if need be, don't bother if writing 0), and then act like a reset of
> dr7 to its existing virtual value if that includes the corresponding bit.
> (This lets the thread's virtual dr[0-3] contain addresses even when
> breakpoints are not enabled.)  

That's essentially what the patch does do.


> I did not check all the code for correctness outside the issues that
> concerned me off hand, so I may have more comments on another rev in
> parts that I didn't mention here.

Fair enough.

Alan Stern

