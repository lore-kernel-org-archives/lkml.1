Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbXCEHCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbXCEHCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 02:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXCEHCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 02:02:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXCEHCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 02:02:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Friday, 2 March 2007 12:19:55 -0500 <Pine.LNX.4.44L0.0703021158001.2485-100000@iolanthe.rowland.org>
X-Shopping-List: (1) Tenuous accusers
   (2) Various logs
   (3) Problematic lips
   (4) Neoclassical floats
   (5) Intoxicating notorious puppy inhibitions
Message-Id: <20070305070136.4CB881801C4@magilla.sf.frob.com>
Date: Sun,  4 Mar 2007 23:01:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Alan.  Great work.  I have some suggestions for changes.

> 	I pretty much copied the existing code for handling vm86 mode
> 	and single-step exceptions, without fully understanding it.
> 
> 	The code doesn't virtualize the BS (single-step) flag in DR6
> 	for userspace.  It could be added, but I wonder whether it is
> 	really needed.

There is only one TF flag, it and the DR_STEP bit in dr6 are part of the
unitary thread state.  You should not be doing anything at all on
single-step exceptions.

> 	Setting user breakpoints on I/O ports should require permissions
> 	checking.  I haven't tried to figure out how that works or
> 	how to implement it yet.

I would just leave the I/O breakpoint feature out for the first cut.  
See if there is demand for it.  

It requires setting CR4.DE, which we don't do.  The validation is
relatively simple, comparing against the io_bitmap_ptr data (if any).
You can check at insertion time (requiring doing ioperm before inserting
an I/O breakpoint), and then check again at exception time if the hit
was in kernel mode and ignore it for a user-only breakpoint, or perhaps
check again and eject the breakpoint if it's been cleared from the
ioperm bitmap.

> 	It seems likely that some of the new routines should be marked
> 	"__kprobes", but I don't know which, or even what that annotation
> 	is supposed to mean.

That annotation is for code that is in the kprobes maintenance code path
(where you cannot insert kprobes).  do_debug has it for the notify_die
path that might lead to kprobes.  The only thing in your code that
should need it is your notifier function, which might get called for an
exception that turns out to be a kprobes single-step.  There shouldn't
be any problem inserting kprobes into the other hwbkpt code.

> 	The parts relating to kernel breakpoints could be made conditional
> 	on a Kconfig option.  The amount of code space saved would be
> 	relatively small; I'm not sure that it would be worthwhile.

In a utrace merge, the user parts can be made conditional on CONFIG_UTRACE.
Then with both turned off, the code goes away completely.  It's unlikely it
will ever be turned off, but it is a clean way to go about things in case
someone wants the smallest possible config for a limited-use installation.

> +	void		(*installed)(struct hwbkpt *);
> +	void		(*uninstalled)(struct hwbkpt *);

Save space in the struct by having just one function for both installed
and uninstalled, taking an argument.  Probably a caller should be able to
pass a null function here to say that the registration call should fail if
it can't be installed due to higher-priority or no-callback registrations
existing, and that its registration cannot be ejected by another (i.e., an
ill-behaved user).

> +	void		*data;

Leave this out.  Let the caller embed struct hwbkpt in his larger struct
and use container_of.

> +/*
> + * The tsk argument in the following three routines will usually be a
> + * process being PTRACEd by the current task, normally a debugger.
> + * It is also legal for tsk to be the current task.  In either case we
> + * can guarantee that tsk will not start running on another CPU while
> + * its breakpoints are being modified.  If that happened it could cause
> + * a crash.
> + */
> +int register_user_hwbkpt(struct task_struct *tsk, struct hwbkpt *bp);
> +void unregister_user_hwbkpt(struct task_struct *tsk, struct hwbkpt *bp);
> +int modify_user_hwbkpt(struct task_struct *tsk, struct hwbkpt *bp,
> +		void *address, u8 len, u8 type);

These are the kinds of constraints utrace is there to make doable.
(I'm assuming that guarantee is really "will not start running in
user mode", since SIGKILL is always possible.)  In a utrace merge,
I think we want the only entry points for this to be a utrace-based
interface that explicitly requires utrace's notion of quiescence
(as its accessors for thread register data do).

> +/*
> + * Kernel breakpoints are not associated with any particular thread.
> + */
> +int register_kernel_hwbkpt(struct hwbkpt *bp);
> +void unregister_kernel_hwbkpt(struct hwbkpt *bp);

Potentially kernel users might want per-thread installations, if
it's simple to provide the option.  e.g., a probe at some syscall
entry that installs a watchpoint while calling into complex
subsystems, and then removes it before returning.

> @@ -379,15 +381,15 @@ void exit_thread(void)
>  		tss->io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
>  		put_cpu();
>  	}
> +	flush_thread_hwbkpt(tsk);

I'd make this do if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG))),
or make it an inline doing that test before calling out to the guts.
Most of the time the hwbkpt code need not be on a hot path, and the
exit path will be one.

> +struct thread_hwbkpt {		/* HW breakpoint info for a thread */
> +
> +	/* utrace support */
> +	struct list_head	node;		/* Entry in thread list */
> +	struct list_head	thread_bps;	/* Thread's breakpoints */
> +	unsigned long		tdr7;		/* Thread's DR7 value */
> +
> +	/* ptrace support */
> +	struct hwbkpt		ptrace_bps[HB_NUM];

I wouldn't use ptrace in the name, it's "the thread's virtual state".
You shouldn't need a struct hwbpkt here really, just unsigned long vdr[4].

> +		/* Check whether bp->address points to user space */
> +		if ((tsk != NULL) != ((unsigned long) bp->address < TASK_SIZE))

On x86_64, make sure this is TASK_SIZE_OF(tsk).

> +	if (val != DIE_DEBUG)
> +		return NOTIFY_DONE;

The very next thing should be:

	dr6 = ((struct die_args *) data)->err;
	if ((dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) == 0)
		return NOTIFY_DONE;
	if (unlikely(regs->eflags & VM_MASK))
		return NOTIFY_DONE;

You are not involved at all if the exception was not produced by a debug
register setting.  When no notify_die hook returns NOTIFY_STOP, do_debug
should do thread->vdr6 |= dr6.  (In practice this will only be the DR_STEP
bit, but maybe others will come along in later chips.  If you're not
explicitly virtualizing something, you should be passing it through.)
To avoid this needing to do allocation when TIF_DEBUG was not already set,
probably the vdr6 should stay in thread_struct directly alongside the pointer.

> +		if (!(dr6 & (0x1 << i)))
> +			continue;

Use (DR_TRAP0 << i).

> +static struct notifier_block hwbkpt_exceptions_nb = {
> +	.notifier_call = hwbkpt_exceptions_notify,
> +	.priority = INT_MAX - 1		/* We need to be notified second */

The order shouldn't matter if everyone only swallows their own exceptions.
kprobes needs to be a little better behaved this way:

diff --git a/arch/i386/kernel/kprobes.c b/arch/i386/kernel/kprobes.c
index b545bc7..0000000 100644  
--- a/arch/i386/kernel/kprobes.c
+++ b/arch/i386/kernel/kprobes.c
@@ -670,7 +670,7 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
+		if ((args->err & DR_STEP) && post_kprobe_handler(args->regs))
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_GPF:
diff --git a/arch/x86_64/kernel/kprobes.c b/arch/x86_64/kernel/kprobes.c
index 209c8c0..0000000 100644  
--- a/arch/x86_64/kernel/kprobes.c
+++ b/arch/x86_64/kernel/kprobes.c
@@ -661,7 +661,7 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
+		if ((args->err & DR_STEP) && post_kprobe_handler(args->regs))
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_GPF:

> Index: 2.6.21-rc2/arch/i386/kernel/ptrace.c
> ===================================================================
> --- 2.6.21-rc2.orig/arch/i386/kernel/ptrace.c
> +++ 2.6.21-rc2/arch/i386/kernel/ptrace.c

I would like all this stuff to be in hw-breakpoint.c, and just called with:

    int thread_set_debugreg(struct task_struct *, int n, unsigned long val);
    unsigned long thread_get_debugreg(struct task_struct *, int n);

Writes to 0..3,6 can just write the slot (after allocating the thread's
struct if need be, don't bother if writing 0), and then act like a reset of
dr7 to its existing virtual value if that includes the corresponding bit.
(This lets the thread's virtual dr[0-3] contain addresses even when
breakpoints are not enabled.)  


I did not check all the code for correctness outside the issues that
concerned me off hand, so I may have more comments on another rev in
parts that I didn't mention here.


Thanks,
Roland
