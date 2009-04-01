Return-Path: <linux-kernel-owner+w=401wt.eu-S1765115AbZDAQQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765115AbZDAQQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762366AbZDAQQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:16:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55470 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756512AbZDAQQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:16:31 -0400
Date: Wed, 1 Apr 2009 12:16:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
In-Reply-To: <20090327220621.GA1373@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0904011057100.3736-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for not replying sooner; I was away on a short vacation.

On Sat, 28 Mar 2009, K.Prasad wrote:

> > There are some serious issues involving userspace breakpoints and the
> > legacy ptrace interface.  It all comes down to this: At what point
> > is a breakpoint registered for a ptrace caller?
> > 
> > Remember, to set up a breakpoint a debugger needs to call ptrace
> > twice: once to put the address in one of the DR0-DR3 registers and
> > once to set up DR7.  So when does the task own the breakpoint?
> > 
> > Logically, we should wait until DR7 gets set, because until then the
> > breakpoint is not active.  But then how do we let the caller know that
> > one of his breakpoints conflicts with a kernel breakpoint?
> > 
> > If we report an error during an attempt to set DR0-DR3 then at least
> > it's unambiguous.  But then how do we know when the task is _finished_
> > using the breakpoint?  It's under no obligation to set the register
> > back to 0.
> > 
> > Related to this is the question of how to store the task's versions of
> > DR0-DR3 when there is no associated active breakpoint.  Maybe it would
> > be best to keep the existing registers in the thread structure.
> > 
> 
> These are profound questions and I believe that it is upto the process in
> user-space to answer them.
> 
> What we could ensure from the kernel-space is to retain the
> existing behaviour of ptrace i.e. return success when a write is done on
> DR0-DR3 (almost unconditionally) and reserve error returns only when DR7
> is written into.
> 
> The patch in question could possibly return an -ENOMEM (even when write
> is done on DR0-DR3) but I will change the behaviour as stated above.
> 
> 
> A DR0 - DR3 return will do a:
> 	thread->debugreg[n] = val;
> 	return 0;
> 
> while all error returns are reserved for:
> 	rc = ptrace_write_dr7(tsk, val);

That does seem to be the most logical approach.  The problem with it is
that it doesn't give the caller much information about the cause of the
problem or how to fix it.  (Not that existing programs would know how
to interpret this information anyway...)

> > > +++ linux-2.6-tip/kernel/hw_breakpoint.c
> > > @@ -0,0 +1,367 @@
> > ...
> > > +struct task_struct *last_debugged_task;
> > 
> > Is this variable provided only for use by the hw_breakpoint_handler()
> > routine, for detecting lazy debug-register switching?  It won't work
> > right on SMP systems.  You need to use a per-CPU variable instead.
> > 
> 
> Thanks for pointing it out. Here's what it will be made:
> DEFINE_PER_CPU(struct task_struct *, last_debugged_task);
> 
> That also re-introduces the put_cpu_no_sched() into
> switch_to_thread_hw_breakpoint() function.
> 
> void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
> {
> 	/* Set the debug register */
> 	arch_install_thread_hw_breakpoint(tsk);
> 	per_cpu(last_debugged_task, get_cpu()) = current;
> 	put_cpu_no_resched();
> }

With the corresponding change in hw_breakpoint_handler(), of course.

> > Even though "arch_install_none" was my own name, I don't like it very
> > much.  "arch_remove_user_hw_breakpoints" would be better.
> > 
> 
> How about arch_uninstall_thread_hw_breakpoint()? (Being the opposite
> of arch_install_thread_hw_breakpoint()).

Okay.

> > > +/*
> > > + * Erase all the hardware breakpoint info associated with a thread.
> > > + *
> > > + * If tsk != current then tsk must not be usable (for example, a
> > > + * child being cleaned up from a failed fork).
> > > + */
> > > +void flush_thread_hw_breakpoint(struct task_struct *tsk)
> > > +{
> > > +	int i;
> > > +	struct thread_struct *thread = &(tsk->thread);
> > > +
> > > +	mutex_lock(&hw_breakpoint_mutex);
> > > +
> > > +	/* The thread no longer has any breakpoints associated with it */
> > > +	clear_tsk_thread_flag(tsk, TIF_DEBUG);
> > > +	for (i = 0; i < HB_NUM; i++) {
> > > +		if (thread->hbp[i]) {
> > > +			hbp_user_refcount[i]--;
> > > +			kfree(thread->hbp[i]);
> > 
> > Ugh!  In general you shouldn't deallocate memory you didn't allocate
> > originally.  What will happen when there is a utrace interface in
> > addition to the ptrace interface?
> > 
> 
> I can't see how I can invoke ptrace related code here to free memory
> here, although I agree that __unregister_user_hw_breakpoint() code need not
> mess with it.
> I will retain the kfree() in flush_thread_hw_breakpoint(), but remove it move 
> it from the latter to ptrace related code.

Yes, that seems like the best compromise.  If utrace has a problem, we 
can fix it later.

> > > +/**
> > > + * unregister_kernel_hw_breakpoint - unregister a HW breakpoint for kernel space
> > > + * @bp: the breakpoint structure to unregister
> > > + *
> > > + * Uninstalls and unregisters @bp.
> > > + */
> > > +void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > > +{
> > > +	int i, j;
> > > +
> > > +	mutex_lock(&hw_breakpoint_mutex);
> > > +
> > > +	/* Find the 'bp' in our list of breakpoints for kernel */
> > > +	for (i = hbp_kernel_pos; i < HB_NUM; i++)
> > > +		if (bp == hbp_kernel[i])
> > > +			break;
> > 
> > If you would store the register number in the arch-specific part of
> > struct hw_breakpoint then this loop wouldn't be needed.
> > 
> 
> It's just a tiny loop (theoretical max is HB_NUM). It could save a member in 
> 'struct hw_breakpoint' - a significant saving if there are
> multiple number of threads that use debug registers.
> 
> The code is already guilty of storing the address of the breakpoint
> twice i.e. once in thread->hbp->info.address and again in
> thread->debugreg[n]. Adding this would be another. What do you say?

I don't know.  You're right that the loop above is insignificant.  On 
the other hand, it's hard to imagine a very large number of threads all 
being debugged simultaneously (there would have to be many thousands of 
them before the overhead was noticeable).

> > > +
> > > +	/*
> > > +	 * Delete the last kernel breakpoint entry after compaction and update
> > > +	 * the pointer to the lowest numbered kernel entry after updating its
> > > +	 * corresponding value in kdr7
> > > +	 */
> > > +	hbp_kernel[hbp_kernel_pos] = 0;
> > > +	arch_unregister_kernel_hw_breakpoint();
> > 
> > Even though it was part of my original design, there's no good reason
> > for making arch_register_kernel_hw_breakpoint and
> > arch_unregister_kernel_hw_breakpoint be separate functions.  There
> > should just be a single function: arch_update_kernel_hw_breakpoints.
> > The same is true for arch_update_user_hw_breakpoints.  In each case,
> > all that is needed is to recalculate the DR7 mask and value.
> > 
> 
> This and a few other suggestions below can be taken only if we chose to
> update all kernel related breakpoint registers, irrespective of the
> change. In return for saving a few lines of code (+simpler code +
> increased readability) we should take some runtime overhead during
> (un)register_<> calls.

That's true.  On the other hand, I don't think people will be 
installing and removing kernel breakpoints very often.  Probably only 
while testing the kernel, not during normal operation.

(By the way, notice that the overhead occurs only during 
_registration_; during unregistration you loop over all the breakpoints 
anyway.  Also notice that the loop overhead is comparable to the amount 
of work done inside the loop, so the total runtime might not change 
much.)

> I'm not sure about the overhead of processing an IPI (which you've cited
> as being much larger than the actual code being executed), but a little
> reluctant to remove code that is tuned for more specific tasks. Consider
> a large system where the number of CPUs is huge (say three digits or so),
> and we want to install a breakpoint for the last register hb_num. It would
> invoke a  write on all hb_num-1 registers for 'n' CPUs. I'm not sure if it's
> worthwhile for saving a few lines of code.

If the breakpoint you want to install is the only kernel breakpoint 
then it would not involve an extra write to all HB_NUM - 1 registers.  
The code I proposed writes only to registers hbp_kernel_pos through 
HB_NUM - 1.

On the other hand, if you want to install multiple kernel breakpoints 
then it's true, my scheme would require some extra writes to the 
debug registers.  However each write boils down to something like three 
machine instructions (one to fetch the address of the hw_breakpoint 
structure, one to fetch the address of the breakpoint, and one to write 
the debug register).  If HB_NUM were larger than 16 or so I might worry 
about the extra work, but with at most four we can forget about it.

> I can change it if you insist. Let me know what you think.

I prefer the simpler interface.  Especially since it doesn't involve 
converting between int and void *.

> > > +	hbp_kernel_pos++;
> > 
> > And this should be moved up one line, so that the arch-specific code
> > knows how many kernel breakpoints to register.
> > 
> 
> This is done after invoking arch_unregister_kernel_hw_breakpoint() just
> so that the corresponding values in kdr7 are updated.

You have to recalculate kdr7 in any case, since some of the other 
breakpoints may have been compacted.

> > > +{
> > > +	int pos = *(int *)idx;
> > > +	unsigned long dr7;
> > > +	int i;
> > > +
> > > +	get_debugreg(dr7, 7);
> > > +
> > > +	/* Don't allow debug exceptions while we update the registers */
> > > +	set_debugreg(0UL, 7);
> > > +
> > > +	for (i = hbp_kernel_pos; i < HB_NUM; i++) {
> > > +		if ((pos >= 0) && (i != pos))
> > > +			continue;
> > > +		dr7 &= ~(dr7_masks[i]);
> > > +		if (hbp_kernel[i])
> > > +			set_debugreg(hbp_kernel[i]->info.address, i);
> > > +	}
> > 
> > For example, this loop could be written more simply as follows:
> > 
> > 	switch (hbp_kernel_pos) {
> > 	case 0:
> > 		set_debugreg(hbp_kernel[0]->info.address, 0);
> > 	case 1:
> > 		set_debugreg(hbp_kernel[1]->info.address, 1);
> > 		...
> > 	}
> > 
> With above code
> i)it uses fewer lines of code

But those lines are more complicated, both in terms of what the CPU has 
to go through to execute them and what the reader has to go through to 
think about them.  Sheer number of lines isn't always the best metric.

>  ii)Although when coding is completely
> done, hbp_kernel[i] cannot be NULL here, we have a check for the same
> just in case. It helped me several times during the course of development
> to have the check as above and prevent crashes.

I'm not worried about that.  There should be only one place where these
variables are set, so it should be easy enough to make sure there
aren't any mistakes.  And if there are, crashing is a better way to
bring them to your attention than just skipping over the bad entries!  
:-)

> > > +/*
> > > + * Install the thread breakpoints in their debug registers.
> > > + */
> > > +void arch_install_thread_hw_breakpoint(struct task_struct *tsk)
> > > +{
> > > +	int i;
> > > +	struct thread_struct *thread = &(tsk->thread);
> > > +
> > > +	for (i = 0;  (i < hbp_kernel_pos) && hbp_user_refcount[i]; i++)
> > > +		if (thread->hbp[i])
> > > +			set_debugreg(thread->hbp[i]->info.address, i);
> > 
> > The loop condition is wrong.  But since this routine is on the hot
> > path we should avoid using a loop at all.  In fact, if the DR0-DR3
> > register values are added back into the thread structure, we could
> > simply do this:
> > 
> > 	switch (hbp_kernel_pos) {
> > 	case 4:
> > 		set_debugreg(thread->dr3, 3);
> > 	case 3:
> > 		set_debugreg(thread->dr2, 2);
> > 		...
> > 	}
> > 
> 
> The above loop will now become (after inclusion of debug registers in
> thread_struct), with fewer indirections.
> 
> 	for (i = 0;  i < hbp_kernel_pos; i++)
> 		if (thread->hbp[i])
> 			set_debugreg(thread->debugreg[i], i);
> 
> It is better because i)contains fewer lines of code compared to a switch case

No.  As I mentioned above, the number of lines of code isn't always the
best guide.  In this case we want fastest execution.  The tests and
conditional jumps in the loop slow it down considerably when compared
to the straight-through execution of the "switch".

> ii)doesn't write onto 'dont-care' debug registers

Since the registers are "don't-care", I don't care if they get written 
to!  :-)

> iii)If considered an
> overhead, the compiler can always unroll the loop for optimisation.
> 
> Will change if you insist.

This is one place where Roland insisted I change it, so I'm forwarding 
his insistence onto you.

> > > +/*
> > > + * Check for virtual address in kernel space.
> > > + */
> > > +int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
> > > +{
> > > +	unsigned int len;
> > > +
> > > +	len = get_hbp_len(hbp_len);
> > > +
> > > +	return ((va >= TASK_SIZE) && ((va + len) >= TASK_SIZE));
> > 
> > In theory this should be (va + len - 1).
> >
> 
> You mean check for?
> return ((va >= TASK_SIZE) && ((va + (len - 1)) >= TASK_SIZE));

Yes.  (Although I would write it without the extra parentheses, but 
that's just a matter of personal taste.)

> > > +/*
> > > + * Modify an existing user breakpoint structure.
> > > + */
> > > +int arch_modify_user_hw_breakpoint(int pos, struct hw_breakpoint *bp,
> > > +		struct task_struct *tsk)
> > > +{
> > > +	struct thread_struct *thread = &(tsk->thread);
> > > +
> > > +	/* Check if the register to be modified was enabled by the thread */
> > > +	if (!(thread->dr7 & (1 << (pos * DR_ENABLE_SIZE))))
> > > +		return -EINVAL;
> > > +
> > > +	thread->dr7 &= ~dr7_masks[pos];
> > > +	thread->dr7 |= encode_dr7(pos, bp->info.len, bp->info.type);
> > > +
> > > +	return 0;
> > > +}
> > 
> > It might be possible to eliminate this rather awkward code, once the
> > DR0-DR3 values are added back into the thread structure.
> > 
> 
> I'm sorry I don't see how. Can you explain?

This gets back to those tricky questions about integrating ptrace with
hw_breakpoint.  In theory we could avoid allocating hw_breakpoint
structures for ptrace breakpoints and treat them completely
independently, but overall it's probably better to do things uniformly.

Regardless, we are still left with the problem that it's not easy to
capture the ptrace interface using an hw_breakpoint structure, because
ptrace breakpoints are set up in two stages: one to save the address in
DRn (0 <= n <= 3) and one to save the type and length in DR7.  What's
the best way to handle it when task being debugged isn't running and
the debugger changes the breakpoint address?  Or changes the
length/type fields in DR7?  I wrote modify_user_hw_breakpoint() to
handle this, but it was just a kludge.

If we store debugreg[0..3] in the thread structure, and if 
__register_user_hw_breakpoint() is written properly, then maybe ptrace 
can install modifications to existing breakpoints simply by calling 
__register_user_hw_breakpoint() and re-using the old "pos" value.

> > > +/*
> > > + * Copy out the debug register information for a core dump.
> > > + *
> > > + * tsk must be equal to current.
> > > + */
> > > +void dump_thread_hw_breakpoint(struct task_struct *tsk, int u_debugreg[8])
> > > +{
> > > +	struct thread_struct *thread = &(tsk->thread);
> > > +	int i;
> > > +
> > > +	memset(u_debugreg, 0, sizeof u_debugreg);
> > > +	for (i = 0; i < thread->hbp_num_installed && thread->hbp[i]; ++i)
> > > +		u_debugreg[i] = thread->hbp[i]->info.address;
> > 
> > The loop condition is wrong, since you don't compact userspace
> > breakpoints.  But it could be unrolled into:
> > 
> > 	u_debugreg[0] = thread->dr0;
> > 	...
> > 	u_debugreg[3] = thread->dr3;
> > 
> 
> I agree that some of the code in the patch were based on the assumption
> that the registers by user-space users would be consumed in an
> increasing fashion, but it should be changed.
> 
> The above code will become:
> 	for (i = 0; i < HB_NUM; ++i)
> 		if (thread->hbp[i])
> 			u_debugreg[i] = thread->debugreg[i];

Why bother to test?  Since we don't care what's in the registers when 
they aren't being used, just write to all of them.

Also, the upper limit of the loop should be hbp_kernel_pos, not HB_NUM.

> Also note that "unsinged long debugreg[HB_NUM]" is embedded in
> thread_struct and not as shown below for using them in loops
> conveniently.
> 
> unsigned long debugreg0;
> unsigned long debugreg1;
> ...

If anything, that's an argument for unrolling the loop by hand.  But it 
doesn't matter; you can always change the contents of the 
thread_struct.

> > > +
> > > +	if (dr6 & DR_STEP)
> > > +		return NOTIFY_DONE;
> > 
> > This test is wrong.  Why did you change it?  It should be:
> > 
> > 	if (!(dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
> > 
> > In theory it's possible to have both the Single-Step bit and a Debug-Trap
> > bit set at the same time.
> > 
> 
> This code is in hw_breakpoint_handler() which we don't intend to enter 
> if single-stepping bit is set (through kprobes) and hence the
> NOTIFY_DONE.

I don't see why we shouldn't enter even in this case.  Suppose somebody
single-steps over an instruction that accesses a variable with an
associated data breakpoint?

> Given that HW_BREAKPOINT_EXECUTE is not
> allowed over kernel-space addresses, we cannot have a kprobe and a HW
> breakpoint over the same address causing simultaneous exceptions.

Kprobe would use INT 3, wouldn't it?  But that's a separate issue; an 
instruction breakpoint is different from a single-step exception.

> However when the patch once had support for Instructions breakpoints + 
> post_handler(), it was a different case then.
> 
> Is there a reason why you think this check and/or return condition
> should be different?

Yes, because there _can_ be simultaneous single-step and data 
breakpoint exceptions.

> The hw_breakpoint_handler() will be modified like this:
> (without the modifications to dr6). Note that the 'goto exit' has
> changed to 'continue' to allow handling of multiple exceptions.
> 
> int __kprobes hw_breakpoint_handler(struct die_args *args)
> {
> 	int i, rc = NOTIFY_DONE;
> 	struct hw_breakpoint *bp;
> 	/* The DR6 value is stored in args->err */
> 	unsigned long dr7, dr6 = args->err;
> 
> 	if (dr6 & DR_STEP)
> 		return NOTIFY_DONE;
> 
> 	get_debugreg(dr7, 7);
> 
> 	/* Disable breakpoints during exception handling */
> 	set_debugreg(0UL, 7);
> 
> 	/*
> 	 * Assert that local interrupts are disabled
> 	 * Reset the DRn bits in the virtualized register value.
> 	 * The ptrace trigger routine will add in whatever is needed.
> 	 */
> 	current->thread.debugreg6 &= \
> 			~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);

The '\' character isn't needed.

> 
> 	/* Lazy debug register switching */
> 	if (per_cpu(last_debugged_task, get_cpu()) != current) {
> 		switch_to_none_hw_breakpoint();
> 		put_cpu_no_resched();
> 	}

I just noticed that the lines saving DR7 and setting it to 0 need to
come here.  Otherwise switch_to_none_hw_breakpoint() might set DR7 back
to a nonzero value, and it might not match the value stored in dr7.

> 
> 	/* Handle all the breakpoints that were triggered */
> 	for (i = 0; i < HB_NUM; ++i) {
> 		if (likely(!(dr6 & (DR_TRAP0 << i))))
> 			continue;
> 		/*
> 		 * Find the corresponding hw_breakpoint structure and
> 		 * invoke its triggered callback.
> 		 */
> 		if (i >= hbp_kernel_pos)
> 			bp = hbp_kernel[i];
> 		else {
> 			bp = current->thread.hbp[i];
> 			if (!bp) {
> 				/* False alarm due to lazy DR switching */
> 				continue;
> 			}
> 		}
> 
> 		switch (bp->info.type) {
> 		case HW_BREAKPOINT_WRITE:
> 		case HW_BREAKPOINT_RW:
> 			(bp->triggered)(bp, args->regs);
> 
> 			if (arch_check_va_in_userspace(bp->info.address,
> 							bp->info.len))
> 				rc = NOTIFY_DONE;
> 			else
> 				rc = NOTIFY_STOP;;
> 			continue;
> 		case HW_BREAKPOINT_EXECUTE:
> 			/*
> 			 * Presently we allow instruction breakpoints
> 			 * only in
> 			 * user-space when requested through ptrace.
> 			 */
> 			if (arch_check_va_in_userspace(bp->info.address,
> 							bp->info.len)) {
> 				(bp->triggered)(bp, args->regs);
> 				/*
> 				 * do_debug will notify user through a
> 				 * SIGTRAP
> 				 * signal. So we are not requesting a
> 				 * NOTIFY_STOP here
> 				 */
> 				rc = NOTIFY_DONE;
> 				continue;
> 			}
> 		}
> 	}

I don't understand why you are setting rc above.  The value returned by
this function should not depend on what breakpoints were hit; it should
depend only on whether there is still more work for the notifier chain
to do.

I also don't understand why you need to check for instruction
breakpoints occurring in kernel code.  We already know they can't
happen because the registration routines won't allow them.  
Double-checking isn't necessary.  All breakpoints should be treated
exactly the same: Invoke the "triggered" callback.  Nothing more.

Besides, putting a check in here means there's one more opportunity for 
mistakes when you _do_ decide to allow instruction breakpoints in the 
kernel.

> 
> 	set_debugreg(dr7, 7);
> 	return rc;
> }

> > > @@ -530,13 +530,14 @@ asmlinkage __kprobes struct pt_regs *syn
> > >  dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
> > >  {
> > >  	struct task_struct *tsk = current;
> > > -	unsigned long condition;
> > > +	unsigned long dr6;
> > >  	int si_code;
> > >  
> > > -	get_debugreg(condition, 6);
> > > +	get_debugreg(dr6, 6);
> > > +	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
> > >  
> > >  	/* Catch kmemcheck conditions first of all! */
> > > -	if (condition & DR_STEP && kmemcheck_trap(regs))
> > > +	if (dr6 & DR_STEP && kmemcheck_trap(regs))
> > >  		return;
> > 
> > Are you sure this is right?  Is it possible for any of the DR_TRAPn bits
> > to be set as well when this happens?
> > 
> > 
> 
> I did not look at this check before. But the (dr6 & DR_STEP) condition
> should make sure no HW breakpoint exceptions are set (since we don't
> allow instruction breakpoints in kernel-space yet, as explained above).

What does kmemcheck_trap() do?

> Will read like this:
> 	/*
> 	 * There's a problem with moving the
> 	 * switch_to_thread_hw_breakpoint()
> 	 * call before current is updated.  Suppose a kernel breakpoint
> 	 * is
> 	 * triggered in between the two.  The hw-breakpoint handler will
> 	 * see
> 	 * that current is different from the task pointer stored in
> 	 * last_debugged_task, so it will think the task pointer is
> 	 * leftover
> 	 * from an old task (lazy switching) and will erase it. Then
> 	 * until the
> 	 * next context switch, no user-breakpoints will be installed.
> 	 *
> 	 * The real problem is that it's impossible to update both
> 	 * current and
> 	 * last_debugged_task at the same instant, so there will always
> 	 * be a
> 	 * window in which they disagree and a breakpoint might get
> 	 * triggered.
> 	 * Since we use lazy switching, we are forced to assume that a
> 	 * disagreement means that current is correct and
> 	 * last_debugged_task is
> 	 * old.  But if you move the code above then you'll create a
> 	 * window in
> 	 * which current is old and last_debugged_task is correct.
> 	 */

With the line breaks fixed up, please.

Alan Stern

