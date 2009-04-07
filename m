Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbZDGIXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbZDGIXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZDGIWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:22:44 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35132 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZDGIWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:22:39 -0400
Date: Tue, 7 Apr 2009 13:52:24 +0530
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
Message-ID: <20090407082224.GA22500@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090327220621.GA1373@in.ibm.com> <Pine.LNX.4.44L0.0904011057100.3736-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904011057100.3736-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 12:16:26PM -0400, Alan Stern wrote:
> Sorry for not replying sooner; I was away on a short vacation.
> 
> On Sat, 28 Mar 2009, K.Prasad wrote:
> 
> > > There are some serious issues involving userspace breakpoints and the
> > > legacy ptrace interface.  It all comes down to this: At what point
> > > is a breakpoint registered for a ptrace caller?
> > > 
> > > Remember, to set up a breakpoint a debugger needs to call ptrace
> > > twice: once to put the address in one of the DR0-DR3 registers and
> > > once to set up DR7.  So when does the task own the breakpoint?
> > > 
> > > Logically, we should wait until DR7 gets set, because until then the
> > > breakpoint is not active.  But then how do we let the caller know that
> > > one of his breakpoints conflicts with a kernel breakpoint?
> > > 
> > > If we report an error during an attempt to set DR0-DR3 then at least
> > > it's unambiguous.  But then how do we know when the task is _finished_
> > > using the breakpoint?  It's under no obligation to set the register
> > > back to 0.
> > > 
> > > Related to this is the question of how to store the task's versions of
> > > DR0-DR3 when there is no associated active breakpoint.  Maybe it would
> > > be best to keep the existing registers in the thread structure.
> > > 
> > 
> > These are profound questions and I believe that it is upto the process in
> > user-space to answer them.
> > 
> > What we could ensure from the kernel-space is to retain the
> > existing behaviour of ptrace i.e. return success when a write is done on
> > DR0-DR3 (almost unconditionally) and reserve error returns only when DR7
> > is written into.
> > 
> > The patch in question could possibly return an -ENOMEM (even when write
> > is done on DR0-DR3) but I will change the behaviour as stated above.
> > 
> > 
> > A DR0 - DR3 return will do a:
> > 	thread->debugreg[n] = val;
> > 	return 0;
> > 
> > while all error returns are reserved for:
> > 	rc = ptrace_write_dr7(tsk, val);
> 
> That does seem to be the most logical approach.  The problem with it is
> that it doesn't give the caller much information about the cause of the
> problem or how to fix it.  (Not that existing programs would know how
> to interpret this information anyway...)
> 

A slight change though...writes to DR0-DR3 may fail if the address is
invalid. This behaviour is true even in existing implementation of
ptrace_set_debugreg().

I am removing some of the comments below, which I have addressed in the
patch. Like using switch-case and consolidating updation of kernel
breakpoints into one function: arch_update_kernel_hw_breakpoints(), etc.

> > > > +int arch_modify_user_hw_breakpoint(int pos, struct hw_breakpoint *bp,
> > > > +		struct task_struct *tsk)
> > > > +{
> > > > +	struct thread_struct *thread = &(tsk->thread);
> > > > +
> > > > +	/* Check if the register to be modified was enabled by the thread */
> > > > +	if (!(thread->dr7 & (1 << (pos * DR_ENABLE_SIZE))))
> > > > +		return -EINVAL;
> > > > +
> > > > +	thread->dr7 &= ~dr7_masks[pos];
> > > > +	thread->dr7 |= encode_dr7(pos, bp->info.len, bp->info.type);
> > > > +
> > > > +	return 0;
> > > > +}
> > > 
> > > It might be possible to eliminate this rather awkward code, once the
> > > DR0-DR3 values are added back into the thread structure.
> > > 
> > 
> > I'm sorry I don't see how. Can you explain?
> 
> This gets back to those tricky questions about integrating ptrace with
> hw_breakpoint.  In theory we could avoid allocating hw_breakpoint
> structures for ptrace breakpoints and treat them completely
> independently, but overall it's probably better to do things uniformly.
> 
> Regardless, we are still left with the problem that it's not easy to
> capture the ptrace interface using an hw_breakpoint structure, because
> ptrace breakpoints are set up in two stages: one to save the address in
> DRn (0 <= n <= 3) and one to save the type and length in DR7.  What's
> the best way to handle it when task being debugged isn't running and
> the debugger changes the breakpoint address?  Or changes the
> length/type fields in DR7?  I wrote modify_user_hw_breakpoint() to
> handle this, but it was just a kludge.
> 
> If we store debugreg[0..3] in the thread structure, and if 
> __register_user_hw_breakpoint() is written properly, then maybe ptrace 
> can install modifications to existing breakpoints simply by calling 
> __register_user_hw_breakpoint() and re-using the old "pos" value.
> 

I've re-written __modify_user_hw_breakpoint() to invoke the common
(new) worker routine arch_update_user_hw_breakpoint(). Let me know if
you think the new code still needs re-work.

> > 
> > This code is in hw_breakpoint_handler() which we don't intend to enter 
> > if single-stepping bit is set (through kprobes) and hence the
> > NOTIFY_DONE.
> 
> I don't see why we shouldn't enter even in this case.  Suppose somebody
> single-steps over an instruction that accesses a variable with an
> associated data breakpoint?
>

I think this is an important case that I missed, which made me add the
early return in hw_breakpoint_handler() for (DR6 & DR_STEP). I have
changed hw_breakpoint_handler() code to address all of your comments
except making dr6 a pointer. I will talk about my concerns about it 
in the subsequent mail.
 
> > 
> > 	/* Lazy debug register switching */
> > 	if (per_cpu(last_debugged_task, get_cpu()) != current) {
> > 		switch_to_none_hw_breakpoint();
> > 		put_cpu_no_resched();
> > 	}
> 
> I just noticed that the lines saving DR7 and setting it to 0 need to
> come here.  Otherwise switch_to_none_hw_breakpoint() might set DR7 back
> to a nonzero value, and it might not match the value stored in dr7.
> 

arch_uninstall_thread_hw_breakpoint()<--switch_to_none_hw_breakpoint()
will store 'kdr7' (which contains all kernel-space breakpoints in
encoded format) to DR7 physical register. Given that the current()
process should not have TIF_DEBUG() set (if it were set,
switch_to_thread_hw_breakpoint() would have been invoked to set
last_debugged_task), we will wipe out all user-space breakpoints and
store only kdr7.

> > > > @@ -530,13 +530,14 @@ asmlinkage __kprobes struct pt_regs *syn
> > > >  dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
> > > >  {
> > > >  	struct task_struct *tsk = current;
> > > > -	unsigned long condition;
> > > > +	unsigned long dr6;
> > > >  	int si_code;
> > > >  
> > > > -	get_debugreg(condition, 6);
> > > > +	get_debugreg(dr6, 6);
> > > > +	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
> > > >  
> > > >  	/* Catch kmemcheck conditions first of all! */
> > > > -	if (condition & DR_STEP && kmemcheck_trap(regs))
> > > > +	if (dr6 & DR_STEP && kmemcheck_trap(regs))
> > > >  		return;
> > > 
> > > Are you sure this is right?  Is it possible for any of the DR_TRAPn bits
> > > to be set as well when this happens?
> > > 
> > > 
> > 
> > I did not look at this check before. But the (dr6 & DR_STEP) condition
> > should make sure no HW breakpoint exceptions are set (since we don't
> > allow instruction breakpoints in kernel-space yet, as explained above).
> 
> What does kmemcheck_trap() do?
>

As I said before, the fact that I ignored a case where we could
single-step an instruction accessing a data being monitored by a
breakpoint, made me ignore all (dr6 & DR_STEP) cases.

kmemcheck_trap()'s functionality can be nicely understood from the
"Technical description" section in Documentation/kmemcheck.txt.
Basically it uses single-stepping to 'hide' a page immediately after
the instruction, say i, using the page has finished execution. This
is to cause page-fault deliberately, which is used by kmemcheck.

However, as you rightly pointed, the next instruction (i + 1) could be
accessing a data monitored by the debug registers and TRAP<n> bits could
be set. We shouldn't allow return in such a case. I will modify the code
in do_debug() also.

Thanks,
K.Prasad

