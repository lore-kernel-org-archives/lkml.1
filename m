Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbZC0WHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbZC0WHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZC0WG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:06:59 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:42424 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbZC0WG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:06:56 -0400
Date: Sat, 28 Mar 2009 03:36:21 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090327220621.GA1373@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090324152435.GA17918@in.ibm.com> <Pine.LNX.4.44L0.0903251547150.21443-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903251547150.21443-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 03:48:31PM -0400, Alan Stern wrote:

Hi Alan,
Thanks for the thorough review. It has helped uncover bugs that might
have been discovered after much delay. Please find my responses inline.

> There are some serious issues involving userspace breakpoints and the
> legacy ptrace interface.  It all comes down to this: At what point
> is a breakpoint registered for a ptrace caller?
> 
> Remember, to set up a breakpoint a debugger needs to call ptrace
> twice: once to put the address in one of the DR0-DR3 registers and
> once to set up DR7.  So when does the task own the breakpoint?
> 
> Logically, we should wait until DR7 gets set, because until then the
> breakpoint is not active.  But then how do we let the caller know that
> one of his breakpoints conflicts with a kernel breakpoint?
> 
> If we report an error during an attempt to set DR0-DR3 then at least
> it's unambiguous.  But then how do we know when the task is _finished_
> using the breakpoint?  It's under no obligation to set the register
> back to 0.
> 
> Related to this is the question of how to store the task's versions of
> DR0-DR3 when there is no associated active breakpoint.  Maybe it would
> be best to keep the existing registers in the thread structure.
> 

These are profound questions and I believe that it is upto the process in
user-space to answer them.

What we could ensure from the kernel-space is to retain the
existing behaviour of ptrace i.e. return success when a write is done on
DR0-DR3 (almost unconditionally) and reserve error returns only when DR7
is written into.

The patch in question could possibly return an -ENOMEM (even when write
is done on DR0-DR3) but I will change the behaviour as stated above.


A DR0 - DR3 return will do a:
	thread->debugreg[n] = val;
	return 0;

while all error returns are reserved for:
	rc = ptrace_write_dr7(tsk, val);

> > +++ linux-2.6-tip/kernel/hw_breakpoint.c
> > @@ -0,0 +1,367 @@
> ...
> > +struct task_struct *last_debugged_task;
> 
> Is this variable provided only for use by the hw_breakpoint_handler()
> routine, for detecting lazy debug-register switching?  It won't work
> right on SMP systems.  You need to use a per-CPU variable instead.
> 

Thanks for pointing it out. Here's what it will be made:
DEFINE_PER_CPU(struct task_struct *, last_debugged_task);

That also re-introduces the put_cpu_no_sched() into
switch_to_thread_hw_breakpoint() function.

void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
{
	/* Set the debug register */
	arch_install_thread_hw_breakpoint(tsk);
	per_cpu(last_debugged_task, get_cpu()) = current;
	put_cpu_no_resched();
}

> > +/*
> > + * Install the debug register values for just the kernel, no thread.
> > + */
> > +void switch_to_none_hw_breakpoint(void)
> > +{
> > +	arch_install_none();
> > +}
> 
> Even though "arch_install_none" was my own name, I don't like it very
> much.  "arch_remove_user_hw_breakpoints" would be better.
> 

How about arch_uninstall_thread_hw_breakpoint()? (Being the opposite
of arch_install_thread_hw_breakpoint()).

> > +/*
> > + * Erase all the hardware breakpoint info associated with a thread.
> > + *
> > + * If tsk != current then tsk must not be usable (for example, a
> > + * child being cleaned up from a failed fork).
> > + */
> > +void flush_thread_hw_breakpoint(struct task_struct *tsk)
> > +{
> > +	int i;
> > +	struct thread_struct *thread = &(tsk->thread);
> > +
> > +	mutex_lock(&hw_breakpoint_mutex);
> > +
> > +	/* The thread no longer has any breakpoints associated with it */
> > +	clear_tsk_thread_flag(tsk, TIF_DEBUG);
> > +	for (i = 0; i < HB_NUM; i++) {
> > +		if (thread->hbp[i]) {
> > +			hbp_user_refcount[i]--;
> > +			kfree(thread->hbp[i]);
> 
> Ugh!  In general you shouldn't deallocate memory you didn't allocate
> originally.  What will happen when there is a utrace interface in
> addition to the ptrace interface?
> 

I can't see how I can invoke ptrace related code here to free memory
here, although I agree that __unregister_user_hw_breakpoint() code need not
mess with it.
I will retain the kfree() in flush_thread_hw_breakpoint(), but remove it move 
it from the latter to ptrace related code.

> > +			thread->hbp[i] = NULL;
> > +		}
> > +	}
> > +	thread->hbp_num_installed = 0;
> 
> This variable doesn't seem to serve any particularly useful purpose.
> Eliminate it.
> 

Done.

> > +/*
> > + * Validate the settings in a hw_breakpoint structure.
> > + */
> > +static int validate_settings(struct hw_breakpoint *bp, struct task_struct *tsk)
> > +{
> > +	int ret;
> > +	unsigned int align;
> > +
> > +	if (!bp)
> > +		return -EINVAL;
> > +
> > +	ret = arch_validate_hwbkpt_settings(bp, &align, tsk);
> > +	if (ret < 0)
> > +		goto err;
> > +
> > +	/*
> > +	 * Check that the low-order bits of the address are appropriate
> > +	 * for the alignment implied by len.
> > +	 */
> > +	if (bp->info.address & align)
> > +		return -EINVAL;
> 
> I sort of think this test belongs in the arch-specific code also.
> After all, some types of CPU might not have alignment constraints.
> 

Moved. It also helps eliminate passing a parameter back and forth.

> > +/*
> > + * Actual implementation of unregister_user_hw_breakpoint.
> > + */
> > +void __unregister_user_hw_breakpoint(int pos, struct task_struct *tsk,
> > +						struct hw_breakpoint *bp)
> 
> What happened to unregister_user_hw_breakpoint?  It doesn't seem to
> exist any more.
> 

I thought it would be more convenient to introduce them after we have
virtualised debug registers. But thinking further, I think we can adopt
a simple 'first-fit' approach can be used to allocate debug registers
for user-space too. I will include a
(un)register_user_hw_breakpoint(task, hw_breakpoint)
in the next iteration and export them too.

> In general, will the caller know the value of pos?  Probably not,
> unless the caller is ptrace.  It shouldn't be one of the parameters.
> 

Given that ptrace contains the debugreg number, I chose to use it. The
proposed interfaces (as discussed above) will help users who cannot
provide the info.

> > +{
> > +	struct thread_struct *thread = &(tsk->thread);
> > +
> > +	if (!bp)
> > +		return;
> > +
> > +	hbp_user_refcount[pos]--;
> > +	thread->hbp_num_installed--;
> > +
> > +	arch_unregister_user_hw_breakpoint(pos, bp, tsk);
> > +
> > +	if (tsk == current)
> > +		switch_to_thread_hw_breakpoint(tsk);
> > +	kfree(tsk->thread.hbp[pos]);
> 
> Once again, memory should be deallocated by the same module that
> allocated it.
> 

Moved to ptrace_write_dr7() where __unregister_user_hw_breakpoint() is
invoked.

> > +/**
> > + * unregister_kernel_hw_breakpoint - unregister a HW breakpoint for kernel space
> > + * @bp: the breakpoint structure to unregister
> > + *
> > + * Uninstalls and unregisters @bp.
> > + */
> > +void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > +{
> > +	int i, j;
> > +
> > +	mutex_lock(&hw_breakpoint_mutex);
> > +
> > +	/* Find the 'bp' in our list of breakpoints for kernel */
> > +	for (i = hbp_kernel_pos; i < HB_NUM; i++)
> > +		if (bp == hbp_kernel[i])
> > +			break;
> 
> If you would store the register number in the arch-specific part of
> struct hw_breakpoint then this loop wouldn't be needed.
> 

It's just a tiny loop (theoretical max is HB_NUM). It could save a member in 
'struct hw_breakpoint' - a significant saving if there are
multiple number of threads that use debug registers.

The code is already guilty of storing the address of the breakpoint
twice i.e. once in thread->hbp->info.address and again in
thread->debugreg[n]. Adding this would be another. What do you say?

> > +	/*
> > +	 * We'll shift the breakpoints one-level above to compact if
> > +	 * unregistration creates a hole
> > +	 */
> > +	if (i > hbp_kernel_pos)
> > +		for (j = i; j == hbp_kernel_pos; j--)
> > +			hbp_kernel[j] = hbp_kernel[j-1];
> 
> The loop condition "j == hbp_kernel_pos" is wrong.  It should be
> "j > hbp_kernel_pos".  And making this change shows that the preceding
> "if" statement is redundant.
> 

I missed it, will correct.

> > +
> > +	/*
> > +	 * Delete the last kernel breakpoint entry after compaction and update
> > +	 * the pointer to the lowest numbered kernel entry after updating its
> > +	 * corresponding value in kdr7
> > +	 */
> > +	hbp_kernel[hbp_kernel_pos] = 0;
> > +	arch_unregister_kernel_hw_breakpoint();
> 
> Even though it was part of my original design, there's no good reason
> for making arch_register_kernel_hw_breakpoint and
> arch_unregister_kernel_hw_breakpoint be separate functions.  There
> should just be a single function: arch_update_kernel_hw_breakpoints.
> The same is true for arch_update_user_hw_breakpoints.  In each case,
> all that is needed is to recalculate the DR7 mask and value.
> 

This and a few other suggestions below can be taken only if we chose to
update all kernel related breakpoint registers, irrespective of the
change. In return for saving a few lines of code (+simpler code +
increased readability) we should take some runtime overhead during
(un)register_<> calls.

I'm not sure about the overhead of processing an IPI (which you've cited
as being much larger than the actual code being executed), but a little
reluctant to remove code that is tuned for more specific tasks. Consider
a large system where the number of CPUs is huge (say three digits or so),
and we want to install a breakpoint for the last register hb_num. It would
invoke a  write on all hb_num-1 registers for 'n' CPUs. I'm not sure if it's
worthwhile for saving a few lines of code.

I can change it if you insist. Let me know what you think.

> > +	hbp_kernel_pos++;
> 
> And this should be moved up one line, so that the arch-specific code
> knows how many kernel breakpoints to register.
> 

This is done after invoking arch_unregister_kernel_hw_breakpoint() just
so that the corresponding values in kdr7 are updated.

> > +static int __init init_hw_breakpoint(void)
> > +{
> > +	int i;
> > +
> > +	hbp_kernel_pos = HB_NUM;
> > +	for (i = 0; i < HB_NUM; i++)
> > +		hbp_user_refcount[i] = 0;
> 
> This loop is unnecessary, since uninitialized static values are set to
> 0 in any case.
> 
> > +	load_debug_registers();
> 
> Hmm, I suspect this line can safely be omitted.
> 

Done.

> > +
> > +	return register_die_notifier(&hw_breakpoint_exceptions_nb);
> > +}
> 
> 
> > +/*
> > + * Install the kernel breakpoints in their debug registers.
> > + * If 0 <= pos < HB_NUM, then set the debug register corresponding to that number
> > + * If 'pos' is negative, then all debug registers are updated
> > + */
> > +void arch_install_kernel_hw_breakpoint(void *idx)
> 
> I don't like this design decision.  Why not simply install all the
> kernel breakpoints every time?  The extra effort would be invisible
> compared to the overhead of an IPI.
> 

Response as above.

> > +{
> > +	int pos = *(int *)idx;
> > +	unsigned long dr7;
> > +	int i;
> > +
> > +	get_debugreg(dr7, 7);
> > +
> > +	/* Don't allow debug exceptions while we update the registers */
> > +	set_debugreg(0UL, 7);
> > +
> > +	for (i = hbp_kernel_pos; i < HB_NUM; i++) {
> > +		if ((pos >= 0) && (i != pos))
> > +			continue;
> > +		dr7 &= ~(dr7_masks[i]);
> > +		if (hbp_kernel[i])
> > +			set_debugreg(hbp_kernel[i]->info.address, i);
> > +	}
> 
> For example, this loop could be written more simply as follows:
> 
> 	switch (hbp_kernel_pos) {
> 	case 0:
> 		set_debugreg(hbp_kernel[0]->info.address, 0);
> 	case 1:
> 		set_debugreg(hbp_kernel[1]->info.address, 1);
> 		...
> 	}
> 
With above code
i)it uses fewer lines of code ii)Although when coding is completely
done, hbp_kernel[i] cannot be NULL here, we have a check for the same
just in case. It helped me several times during the course of development
to have the check as above and prevent crashes.

> > +
> > +	dr7 |= kdr7;
> 
> Of course, you would also have to mask out the user bits from DR7.
> You could do something like this:
> 
> 	dr7 = (dr7 & dr7_user_mask[hbp_kernel_pos]) | kdr7;
> 
> where dr7_user_mask is a static array containing the five appropriate
> mask values.
> 

These are functionally equivalent changes and hope you wouldn't mind if
I choose to skip them.

> > +	/* No need to set DR6 */
> > +	set_debugreg(dr7, 7);
> > +}
> > +
> > +void arch_load_debug_registers()
> > +{
> > +	int pos = -1;
> > +	/*
> > +	 * We want all debug registers to be initialised for this
> > +	 * CPU so pos = -1
> > +	 */
> > +	arch_install_kernel_hw_breakpoint((void *)&pos);
> > +}
> 
> If you follow my suggestion above then this routine isn't needed at
> all.  Callers can invoke arch_install_kernel_hw_breakpoints instead.
> 

Response as earlier.

> > +/*
> > + * Install the thread breakpoints in their debug registers.
> > + */
> > +void arch_install_thread_hw_breakpoint(struct task_struct *tsk)
> > +{
> > +	int i;
> > +	struct thread_struct *thread = &(tsk->thread);
> > +
> > +	for (i = 0;  (i < hbp_kernel_pos) && hbp_user_refcount[i]; i++)
> > +		if (thread->hbp[i])
> > +			set_debugreg(thread->hbp[i]->info.address, i);
> 
> The loop condition is wrong.  But since this routine is on the hot
> path we should avoid using a loop at all.  In fact, if the DR0-DR3
> register values are added back into the thread structure, we could
> simply do this:
> 
> 	switch (hbp_kernel_pos) {
> 	case 4:
> 		set_debugreg(thread->dr3, 3);
> 	case 3:
> 		set_debugreg(thread->dr2, 2);
> 		...
> 	}
> 

The above loop will now become (after inclusion of debug registers in
thread_struct), with fewer indirections.

	for (i = 0;  i < hbp_kernel_pos; i++)
		if (thread->hbp[i])
			set_debugreg(thread->debugreg[i], i);

It is better because i)contains fewer lines of code compared to a switch case
ii)doesn't write onto 'dont-care' debug registers iii)If considered an
overhead, the compiler can always unroll the loop for optimisation.

Will change if you insist.

> > +
> > +	/* No need to set DR6 */
> > +
> > +	set_debugreg((kdr7 | thread->dr7), 7);
> > +}
> 
> > +/*
> > + * Check for virtual address in kernel space.
> > + */
> > +int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
> > +{
> > +	unsigned int len;
> > +
> > +	len = get_hbp_len(hbp_len);
> > +
> > +	return ((va >= TASK_SIZE) && ((va + len) >= TASK_SIZE));
> 
> In theory this should be (va + len - 1).
>

You mean check for?
return ((va >= TASK_SIZE) && ((va + (len - 1)) >= TASK_SIZE));

> > +}
> > +
> > +/*
> > + * Store a breakpoint's encoded address, length, and type.
> > + */
> > +void arch_store_info(struct hw_breakpoint *bp)
> > +{
> > +	/*
> > +	 * User-space requests will always have the address field populated
> > +	 * For kernel-addresses, either the address or symbol name can be
> > +	 * specified.
> > +	 */
> > +	if (bp->info.address)
> > +		return;
> > +	if (bp->info.name)
> > +		bp->info.address = (unsigned long)
> > +					kallsyms_lookup_name(bp->info.name);
> > +}
> 
> I still think the address and name fields shouldn't be arch-specific.
> After all, won't _every_ arch need to have a copy of exactly this same
> function?
> 

It is the thought of having breakpoints for I/O (which cannot possibly
have a name) and breakpoints over a range of addresses (unlike having
just one address field) that makes me think that these are best kept in
arch-specific structure.

If at a later point in time, they appear on all arch-specific structures
(that have an implementation), I will move the fields into generic
structure.

> > +/*
> > + * Modify an existing user breakpoint structure.
> > + */
> > +int arch_modify_user_hw_breakpoint(int pos, struct hw_breakpoint *bp,
> > +		struct task_struct *tsk)
> > +{
> > +	struct thread_struct *thread = &(tsk->thread);
> > +
> > +	/* Check if the register to be modified was enabled by the thread */
> > +	if (!(thread->dr7 & (1 << (pos * DR_ENABLE_SIZE))))
> > +		return -EINVAL;
> > +
> > +	thread->dr7 &= ~dr7_masks[pos];
> > +	thread->dr7 |= encode_dr7(pos, bp->info.len, bp->info.type);
> > +
> > +	return 0;
> > +}
> 
> It might be possible to eliminate this rather awkward code, once the
> DR0-DR3 values are added back into the thread structure.
> 

I'm sorry I don't see how. Can you explain?

> > +/*
> > + * Copy out the debug register information for a core dump.
> > + *
> > + * tsk must be equal to current.
> > + */
> > +void dump_thread_hw_breakpoint(struct task_struct *tsk, int u_debugreg[8])
> > +{
> > +	struct thread_struct *thread = &(tsk->thread);
> > +	int i;
> > +
> > +	memset(u_debugreg, 0, sizeof u_debugreg);
> > +	for (i = 0; i < thread->hbp_num_installed && thread->hbp[i]; ++i)
> > +		u_debugreg[i] = thread->hbp[i]->info.address;
> 
> The loop condition is wrong, since you don't compact userspace
> breakpoints.  But it could be unrolled into:
> 
> 	u_debugreg[0] = thread->dr0;
> 	...
> 	u_debugreg[3] = thread->dr3;
> 

I agree that some of the code in the patch were based on the assumption
that the registers by user-space users would be consumed in an
increasing fashion, but it should be changed.

The above code will become:
	for (i = 0; i < HB_NUM; ++i)
		if (thread->hbp[i])
			u_debugreg[i] = thread->debugreg[i];

Also note that "unsinged long debugreg[HB_NUM]" is embedded in
thread_struct and not as shown below for using them in loops
conveniently.

unsigned long debugreg0;
unsigned long debugreg1;
...

> > +	u_debugreg[7] = thread->dr7;
> > +	u_debugreg[6] = thread->dr6;
> > +}
> > +
> > +/*
> > + * Handle debug exception notifications.
> > + */
> > +int __kprobes hw_breakpoint_handler(struct die_args *args)
> > +{
> > +	int i, rc = NOTIFY_DONE;
> > +	struct hw_breakpoint *bp;
> > +	/* The DR6 value is stored in args->err */
> > +	unsigned long dr7, dr6 = args->err;
> 
> Please change this.  (I should have changed it long ago, but I never
> got around to it.)  Instead of passing the DR6 value in args->err,
> pass a pointer to the dr6 variable in do_debug().  That way the
> handler routines can turn off bits in that variable and do_debug() can
> see which bits remain set at the end.
> 
> Of course, this will require a corresponding change to the
> post_kprobe_handler() routine.
> 

Ok.

> > +
> > +	if (dr6 & DR_STEP)
> > +		return NOTIFY_DONE;
> 
> This test is wrong.  Why did you change it?  It should be:
> 
> 	if (!(dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
> 
> In theory it's possible to have both the Single-Step bit and a Debug-Trap
> bit set at the same time.
> 

This code is in hw_breakpoint_handler() which we don't intend to enter 
if single-stepping bit is set (through kprobes) and hence the
NOTIFY_DONE. Given that HW_BREAKPOINT_EXECUTE is not
allowed over kernel-space addresses, we cannot have a kprobe and a HW
breakpoint over the same address causing simultaneous exceptions.

However when the patch once had support for Instructions breakpoints + 
post_handler(), it was a different case then.

Is there a reason why you think this check and/or return condition
should be different?

> > +
> > +	get_debugreg(dr7, 7);
> > +
> > +	/* Disable breakpoints during exception handling */
> > +	set_debugreg(0UL, 7);
> > +
> > +	/*
> > +	 * Assert that local interrupts are disabled
> > +	 * Reset the DRn bits in the virtualized register value.
> > +	 * The ptrace trigger routine will add in whatever is needed.
> > +	 */
> > +	current->thread.dr6 &= ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);
> > +
> > +	/* Lazy debug register switching */
> > +	if (last_debugged_task != current)
> > +		switch_to_none_hw_breakpoint();
> > +
> > +	/* Handle all the breakpoints that were triggered */
> > +	for (i = 0; i < HB_NUM; ++i) {
> > +		if (likely(!(dr6 & (DR_TRAP0 << i))))
> > +			continue;
> > +		/*
> > +		 * Find the corresponding hw_breakpoint structure and
> > +		 * invoke its triggered callback.
> > +		 */
> > +		if (hbp_user_refcount[i])
> > +			bp = current->thread.hbp[i];
> > +		else if (i >= hbp_kernel_pos)
> > +			bp = hbp_kernel[i];
> > +		else	/* False alarm due to lazy DR switching */
> > +			continue;
> > +
> > +		if (!bp)
> > +			break;
> 
> This logic is wrong.  It should go like this:
> 
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

I agree. The 'break' following the "if (!bp)" in my patch would have ignored a
few genuine exceptions and it should have been:
		if (!bp)
			continue;

Your suggested code is elegant and I'll adopt it.

> > +
> > +		switch (bp->info.type) {
> > +		case HW_BREAKPOINT_WRITE:
> > +		case HW_BREAKPOINT_RW:
> > +			if (bp->triggered)
> 
> Do you really need to test bp->triggered?
> 

It's a carriage from old code. Will remove.

> > +				(bp->triggered)(bp, args->regs);
> > +
> > +			if (arch_check_va_in_userspace(bp->info.address,
> > +							bp->info.len))
> > +				rc = NOTIFY_DONE;
> > +			else
> > +				rc = NOTIFY_STOP;;
> > +			goto exit;
> 
> What on Earth is the reason for all this?  What happens if two
> breakpoints get triggered at the same time?
> 

The hw_breakpoint_handler() will be modified like this:
(without the modifications to dr6). Note that the 'goto exit' has
changed to 'continue' to allow handling of multiple exceptions.

int __kprobes hw_breakpoint_handler(struct die_args *args)
{
	int i, rc = NOTIFY_DONE;
	struct hw_breakpoint *bp;
	/* The DR6 value is stored in args->err */
	unsigned long dr7, dr6 = args->err;

	if (dr6 & DR_STEP)
		return NOTIFY_DONE;

	get_debugreg(dr7, 7);

	/* Disable breakpoints during exception handling */
	set_debugreg(0UL, 7);

	/*
	 * Assert that local interrupts are disabled
	 * Reset the DRn bits in the virtualized register value.
	 * The ptrace trigger routine will add in whatever is needed.
	 */
	current->thread.debugreg6 &= \
			~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);

	/* Lazy debug register switching */
	if (per_cpu(last_debugged_task, get_cpu()) != current) {
		switch_to_none_hw_breakpoint();
		put_cpu_no_resched();
	}

	/* Handle all the breakpoints that were triggered */
	for (i = 0; i < HB_NUM; ++i) {
		if (likely(!(dr6 & (DR_TRAP0 << i))))
			continue;
		/*
		 * Find the corresponding hw_breakpoint structure and
		 * invoke its triggered callback.
		 */
		if (i >= hbp_kernel_pos)
			bp = hbp_kernel[i];
		else {
			bp = current->thread.hbp[i];
			if (!bp) {
				/* False alarm due to lazy DR switching */
				continue;
			}
		}

		switch (bp->info.type) {
		case HW_BREAKPOINT_WRITE:
		case HW_BREAKPOINT_RW:
			(bp->triggered)(bp, args->regs);

			if (arch_check_va_in_userspace(bp->info.address,
							bp->info.len))
				rc = NOTIFY_DONE;
			else
				rc = NOTIFY_STOP;;
			continue;
		case HW_BREAKPOINT_EXECUTE:
			/*
			 * Presently we allow instruction breakpoints
			 * only in
			 * user-space when requested through ptrace.
			 */
			if (arch_check_va_in_userspace(bp->info.address,
							bp->info.len)) {
				(bp->triggered)(bp, args->regs);
				/*
				 * do_debug will notify user through a
				 * SIGTRAP
				 * signal. So we are not requesting a
				 * NOTIFY_STOP here
				 */
				rc = NOTIFY_DONE;
				continue;
			}
		}
	}

	set_debugreg(dr7, 7);
	return rc;
}

> > +		case HW_BREAKPOINT_EXECUTE:
> > +			/*
> > +			 * Presently we allow instruction breakpoints only in
> > +			 * user-space when requested through ptrace.
> > +			 */
> > +			if (arch_check_va_in_userspace(bp->info.address,
> > +							bp->info.len)) {
> > +				(bp->triggered)(bp, args->regs);
> 
> Why do you need this test?
> 
> > +				/*
> > +				 * do_debug will notify user through a SIGTRAP
> > +				 * signal So we are not requesting a
> > +				 * NOTIFY_STOP here
> > +				 */
> > +				rc = NOTIFY_DONE;
> > +				goto exit;
> > +			}
> > +		}
> 
> In fact, why do you distinguish between data breakpoints and code
> breakpoints in the first place?  Shouldn't they be treated the same?
> 

We would receive breakpoint exceptions with type HW_BREAKPOINT_EXECUTE
only for user-space (through ptrace) and this is a double-check (the
first one being done at arch_validate_hwbkpt_settings(). Also, we don't
want to invoke bp->triggered (which would be ptrace_triggered) without
checking if the causative IP is in user-space. Hence the above code.

> > +	}
> > +
> > +	/* Stop processing further if the exception is a stray one */
> 
> That comment is wrong.  It should say something like this:
> 
> 	/* Stop processing if there's nothing more to do */
> 
> > +	if (!(dr6 & ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
> > +		rc = NOTIFY_STOP;
> 
> On the other hand, I'm not sure that this NOTIFY_STOP will help much
> anyway.  All it does is provide an early exit from the notifier chain
> when a hardware breakpoint occurs.  But if there wasn't also a
> Single-Step exception, the kprobes handler shouldn't take long to
> run.  Hence an early exit doesn't provide much advantage.
> 

Yes, I'm for removing this check too.

> > +exit:
> > +	set_debugreg(dr7, 7);
> > +	return rc;
> > +}
> 
> 
> > @@ -530,13 +530,14 @@ asmlinkage __kprobes struct pt_regs *syn
> >  dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
> >  {
> >  	struct task_struct *tsk = current;
> > -	unsigned long condition;
> > +	unsigned long dr6;
> >  	int si_code;
> >  
> > -	get_debugreg(condition, 6);
> > +	get_debugreg(dr6, 6);
> > +	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
> >  
> >  	/* Catch kmemcheck conditions first of all! */
> > -	if (condition & DR_STEP && kmemcheck_trap(regs))
> > +	if (dr6 & DR_STEP && kmemcheck_trap(regs))
> >  		return;
> 
> Are you sure this is right?  Is it possible for any of the DR_TRAPn bits
> to be set as well when this happens?
> 
> 

I did not look at this check before. But the (dr6 & DR_STEP) condition
should make sure no HW breakpoint exceptions are set (since we don't
allow instruction breakpoints in kernel-space yet, as explained above).

> > @@ -83,6 +85,8 @@ void exit_thread(void)
> >  		put_cpu();
> >  		kfree(bp);
> >  	}
> > +	if (unlikely(t->dr7))
> > +		flush_thread_hw_breakpoint(me);
> 
> Shouldn't you test the TIF_DEBUG flag instead?  After all, the thread
> might very well have some hw_breakpoint structures allocated even though
> t->dr7 is 0.
> 

Yes, it's a mistake and missed many eyes before. Thanks for pointing it
out!

> >  
> >  	ds_exit_thread(current);
> >  }
> > @@ -103,14 +107,9 @@ void flush_thread(void)
> >  	}
> >  #endif
> >  
> > -	clear_tsk_thread_flag(tsk, TIF_DEBUG);
> > +	if (unlikely(tsk->thread.dr7))
> > +		flush_thread_hw_breakpoint(tsk);
> 
> Same thing here.
> 
> > @@ -265,7 +267,14 @@ int copy_thread(int nr, unsigned long cl
> >  
> >  	task_user_gs(p) = get_user_gs(regs);
> >  
> > +	p->thread.io_bitmap_ptr = NULL;
> > +
> >  	tsk = current;
> > +	err = -ENOMEM;
> > +	if (unlikely(tsk->thread.dr7)) {
> > +		if (copy_thread_hw_breakpoint(tsk, p, clone_flags))
> > +			goto out;
> > +	}
> 
> And here.
> 
> > @@ -426,6 +438,25 @@ __switch_to(struct task_struct *prev_p, 
> >  		lazy_load_gs(next->gs);
> >  
> >  	percpu_write(current_task, next_p);
> > +	/*
> > +	 * There's a problem with moving the switch_to_thread_hw_breakpoint()
> > +	 * call before current is updated.  Suppose a kernel breakpoint is
> > +	 * triggered in between the two.  The hw-breakpoint handler will see
> > +	 * that current is different from the task pointer stored in the chbi
> > +	 * area, so it will think the task pointer is leftover from an old task
> > +	 * (lazy switching) and will erase it.  Then until the next context
> > +	 * switch, no user-breakpoints will be installed.
> > +	 *
> > +	 * The real problem is that it's impossible to update both current and
> > +	 * chbi->bp_task at the same instant, so there will always be a window
> > +	 * in which they disagree and a breakpoint might get triggered.  Since
> > +	 * we use lazy switching, we are forced to assume that a disagreement
> > +	 * means that current is correct and chbi->bp_task is old.  But if you
> > +	 * move the code above then you'll create a window in which current is
> > +	 * old and chbi->bp_task is correct.
> > +	 */
> 
> Don't you think this comment should be updated to match the changes
> you have made in the code?  There no longer is a chbi area, for example.
> 
> 
> Alan Stern
> 

Will read like this:
	/*
	 * There's a problem with moving the
	 * switch_to_thread_hw_breakpoint()
	 * call before current is updated.  Suppose a kernel breakpoint
	 * is
	 * triggered in between the two.  The hw-breakpoint handler will
	 * see
	 * that current is different from the task pointer stored in
	 * last_debugged_task, so it will think the task pointer is
	 * leftover
	 * from an old task (lazy switching) and will erase it. Then
	 * until the
	 * next context switch, no user-breakpoints will be installed.
	 *
	 * The real problem is that it's impossible to update both
	 * current and
	 * last_debugged_task at the same instant, so there will always
	 * be a
	 * window in which they disagree and a breakpoint might get
	 * triggered.
	 * Since we use lazy switching, we are forced to assume that a
	 * disagreement means that current is correct and
	 * last_debugged_task is
	 * old.  But if you move the code above then you'll create a
	 * window in
	 * which current is old and last_debugged_task is correct.
	 */
	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
		switch_to_thread_hw_breakpoint(next_p);


Thanks,
K.Prasad

