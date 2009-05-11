Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbZEKRU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbZEKRU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZEKRUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:20:49 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48590 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZEKRUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:20:47 -0400
Date: Mon, 11 May 2009 22:50:34 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 00/12] Hardware Breakpoint Interfaces
Message-ID: <20090511172034.GA8774@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090511113644.GB26721@in.ibm.com> <Pine.LNX.4.44L0.0905111025500.2975-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905111025500.2975-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 10:50:39AM -0400, Alan Stern wrote:
> On Mon, 11 May 2009, K.Prasad wrote:
> 
> > > You shouldn't call on_each_cpu() while holding a spinlock.  The same
> > > thing happens in unregister_kernel_hw_breakpoint().
> > > 
> > 
> > First, on_each_cpu() will now be changed to return only after all
> > functions invoked through IPIs have returned (by changing @wait
> > parameter to 1). This is required to prevent side effects of
> > incrementing hbp_kernel_pos after on_each_cpu() in
> > unregister_kernel_hw_breakpoint() [hbp_kernel_pos is still incremented
> > after IPI and I will explain it below].
> 
> Good.  I thought this was already done; it's lucky you noticed it
> wasn't.
> 
> > on_each_cpu() isn't a blocking call (despite @wait being set to 1, which
> > does a busy wait through cpu_relax()) and should be safe to invoke
> > inside a spin_lock() context. I would like to know if you think
> > otherwise.
> 
> I guess you're right.  Why did you change the spin_lock to 
> spin_lock_bh?
> 

I realised that flush_thread_hw_breakpoint()-->flush_thread() is invoked
through a softIRQ. Considering that it can cause potential deadlock due
to circular lock dependancy, spin_lock() calls were changed to
spin_lock_bh(). Here's a traceback and message from lockdep that helped
me:

=================================
[ INFO: inconsistent lock state ]
2.6.30-rc4-tip.hbkpt #31
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (hw_breakpoint_lock){+.?...}, at: [<c0498f73>]
flush_thread_hw_breakpoint+0x16/0x75
{SOFTIRQ-ON-W} state was registered at:
  [<c0459309>] __lock_acquire+0x2e8/0xb55
  [<c0459c11>] lock_acquire+0x9b/0xbe
  [<c0701dbd>] _spin_lock+0x23/0x53
  [<c0499190>] load_debug_registers+0x1b/0x77
  [<c06fcf20>] start_secondary+0x1b9/0x1c6
  [<ffffffff>] 0xffffffff
irq event stamp: 1447500
hardirqs last  enabled at (1447500): [<c04be9ff>]
kmem_cache_free+0xb2/0xe7
hardirqs last disabled at (1447499): [<c04be996>]
kmem_cache_free+0x49/0xe7
softirqs last  enabled at (1447468): [<c043cdda>]
__do_softirq+0x14c/0x154
softirqs last disabled at (1447473): [<c04051b8>] do_softirq+0x6d/0xcd

other info that might help us debug this:
no locks held by swapper/0.

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.30-rc4-tip.hbkpt #31
Call Trace:
 [<c06ff8d2>] ? printk+0x14/0x1a
 [<c04582e7>] valid_state+0x12a/0x13d
 [<c04583e0>] mark_lock+0xe6/0x1e9
 [<c0458ae8>] ? check_usage_forwards+0x0/0x3f
 [<c0459287>] __lock_acquire+0x266/0xb55
 [<c04aa403>] ? page_address+0xe/0xb1
 [<c0459c11>] lock_acquire+0x9b/0xbe
 [<c0498f73>] ? flush_thread_hw_breakpoint+0x16/0x75
 [<c0701dbd>] _spin_lock+0x23/0x53
 [<c0498f73>] ? flush_thread_hw_breakpoint+0x16/0x75
 [<c0498f73>] flush_thread_hw_breakpoint+0x16/0x75
 [<c0409751>] free_thread_xstate+0x40/0x62
 [<c0409785>] free_thread_info+0x12/0x1e
 [<c043611b>] free_task+0x1e/0x34
 [<c0437522>] __put_task_struct+0xa7/0xac
 [<c0439084>] delayed_put_task_struct+0x75/0x7c
 [<c047bd9c>] __rcu_process_callbacks+0x1a5/0x229
 [<c047be44>] rcu_process_callbacks+0x24/0x42
 [<c043cd2b>] __do_softirq+0x9d/0x154
 [<c043cc8e>] ? __do_softirq+0x0/0x154
 <IRQ>  [<c043c816>] ? irq_exit+0x3a/0x68
 [<c07055d4>] ? smp_apic_timer_interrupt+0x79/0x87
 [<c0403d47>] ? apic_timer_interrupt+0x2f/0x34
 [<c041eeb4>] ? native_safe_halt+0xa/0xc
 [<c0409296>] ? default_idle+0x4f/0x81
 [<c048c417>] ? stop_critical_timings+0x25/0x2a
 [<c040263b>] ? cpu_idle+0x58/0x79
 [<c06f0004>] ? rest_init+0x58/0x5a
 [<c08cc805>] ? start_kernel+0x2fc/0x301
 [<c08cc06a>] ? __init_begin+0x6a/0x6f

> 
> > > What happens if a kernel breakpoint is triggered on another CPU while
> > > this loop is running?  Or what happens if the breakpoint being removed
> > > is triggered on another CPU before on_each_cpu() is called below?
> > > 
> > > Basically, it's impossible to change the kernel breakpoints 
> > > simultaneously on all CPUs.  That means you somehow have to keep both 
> > > the old set and the new set around until all the CPUs are updated.
> > > 
> > 
> > I must admit that the code did not handle the above scenario. I am
> > adding a per-cpu instance of 'hbp_kernel[]' called 'this_hbp_kernel[]'.
> > The breakpoint handler would use the per-cpu instance which will remain
> > valid throughout the execution of the handler. The per-cpu instance will
> > be updated with hbp_kernel[] values in arch_update_kernel_hw_breakpoint().
> > [This necessitates hbp_kernel_pos increment to happen after the IPI call
> > in unregister_kernel code].
> 
> Yes, okay.  I'm a little nervous about making this_hbp_kernel[] be
> per-cpu while hbp_kernel_pos isn't.  It means the two values will
> sometimes be out of sync with each other.  But it ought to be safe
> since during the out-of-sync periods, hbp_kernel_pos will always point
> to an empty breakpoint slot.
> 
> Still, in hw_breakpoint_handler(), perhaps the "if (i >= 
> hbp_kernel_pos)" path should also check for !bp.  Just to be safe.  In 
> other words, move the 
> 
> +			if (!bp)
> +				continue;
> +			rc = NOTIFY_DONE;
> 
> lines outside the "if" statement.
> 
> 

I don't see where the out-of-sync situation between hbp_kernel_pos and
this_hbp_kernel[] can cause problem. Our concern is when an exception
arises in the small time-window starting at the time when hbp_kernel[]
is updated in common code and ends when exceptions are disabled through
the IPI routine arch_update_kernel_hw_breakpoint. Consider these two
cases now:

i)register_kernel_hw_breakpoint() - Although hbp_kernel_pos is
decremented before the IPI, no new exceptions will arise because of the
same on a CPU where this_hbp_kernel[] is not synced because the physical
debug registers are not yet set. So, the 'i' in "if (i >= hbp_kernel_pos)"
cannot belong to the newly registered breakpoint. If it is for the new
breakpoint, then it is on a CPU where this_hbp_kernel[] is synced with
hbp_kernel[].

ii)unregister_kernel_hw_breakpoint() - hbp_kernel_pos is incremented
after all the IPIs have finished, so hbp_kernel_pos still points to the
old value whose hbp_kernel[] is NULL. However in "if (i >= hbp_kernel_pos)"
if 'i' points to the 'pending-delete' breakpoint, then 'bp' is derived
from this_hbp_kernel[] which contains the old value. The callback
bp->triggered() is invoked and the exception returns fine.

Let me know if I am missing any possibility leading to incorrect
behaviour. 

> > > Another problem: kdr7 is a global variable, and here you've got every
> > > CPU recomputing it whenever a kernel breakpoint is added or removed.
> > > It should be computed just once, before the on_each_cpu() call.
> > > 
> > 
> > If kdr7 needs to be updated only once, it has to be kept outside the IPI
> > through the use of a wrapper routine (in arch/x86/kernel/hw_breakpoint.c
> > as it is arch-specific). This would mean one more function call in
> > (un)register_kernel_<> routines taking the code back to one of its previous
> > designs. In a trade-off between code-brevity and efficiency, the present one
> > chose the former keeping in mind some of the comments received during the
> > early stages of this patch.
> 
> You don't appreciate the seriousness of this problem.  Here's the new code:
> 
> +	/* Clear all kernel-space breakpoints in kdr7 */
> +	kdr7 = 0;
> (A)
> +	for (i = hbp_kernel_pos; i < HB_NUM; i++) {
> +		per_cpu(this_hbp_kernel[i], cpu) = bp = hbp_kernel[i];
> +		if (bp) {
> +			kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
> +			set_debugreg(hbp_kernel[i]->info.address, i);
> +		}
> +	}
> +
> +	/* No need to set DR6. Update the debug registers with kernel-space
> +	 * breakpoint values from kdr7 and user-space requests from the
> +	 * current process
> +	 */
> (B)
> +	set_debugreg(kdr7 | current->thread.debugreg7, 7);
> 
> Suppose you send out the IPIs, and one of the CPUs happens to reach (A)
> at the same time another CPU reaches (B).  The second CPU will load an
> incorrect value into DR7.
> 
> If you prefer you can replace kdr7 above with a local variable, and 
> set kdr7 to the local variable's value at the end of the function.  
> Also, in the first set_debugreg() line above, you can replace 
> hbp_kernel[i] with bp.
> 
>

I failed to realise the potential inconsistency in kdr7 value. The code
will be modified like this:

void arch_update_kernel_hw_breakpoints(void *unused)
{
        struct hw_breakpoint *bp;
        int i, cpu = get_cpu();
        unsigned long temp_kdr7 = 0;

        /* Don't allow debug exceptions while we update the registers */
        set_debugreg(0UL, 7);

        for (i = hbp_kernel_pos; i < HB_NUM; i++) {
                per_cpu(this_hbp_kernel[i], cpu) = bp = hbp_kernel[i];
                if (bp) {
                        temp_kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
                        set_debugreg(bp->info.address, i);
                }
        }

        /* No need to set DR6. Update the debug registers with kernel-space
         * breakpoint values from temp_kdr7 and user-space requests from
         * the current process
         */
        kdr7 = temp_kdr7;
        set_debugreg(kdr7 | current->thread.debugreg7, 7);
        put_cpu_no_resched();
}

 
> > > > +	void *temp_mem = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
> > > > +	if (!temp_mem)
> > > > +		temp_mem_used = -ENOMEM;
> > > 
> > > I don't think this is a good idea...
> > > 
> > 
> > I agree that it turned out to be wrong. ptrace is now modified to use
> > the (un)register_user_hw_breakpoint() interfaces directly and not the
> > worker routines, thereby avoiding all this complexity. Please find the
> > changes in the new patch.
> 
> > > And now if something went wrong, you have already freed the memory
> > > holding the original breakpoint structures.  It would be better to
> > > keep them around until you know they aren't going to be needed.
> 
> I still think it would be a good idea to avoid freeing any breakpoint
> structures until you know for certain they aren't needed.  Otherwise
> you might find that you're unable to allocate memory to re-create a
> structure that was already present.
> 
> Alan Stern
>

I agree that we shouldn't free memory temporarily that would be needed
later, as memory may not be available. However such a situation does not
arise in ptrace_write_dr7() after the re-write using
(un)register_user_hw_breakpoint(). kfree(bp) is done when
i) an existing breakpoint is disabled
ii) a breakpoint is requested but register_user_hw_breakpoint() routine
fails for some reasons. Hence the breakpoint structure kzalloc()'ed
afresh is kfree()'ed.
iii) In case of modifications to the type of breakpoint (such as
read<-->write), the breakpoint structure is not de-allocated and this is
where __modify_user_hw_breakpoint() helps us. There is no opportunity
window where the breakpoint can be grabbed by other requests when a
modification is done.

Let me know if you think there's still some discrepancy here.

Thanks for your detailed review and pointing me to the errors. I am
sending the patchset again with the changes discussed above.

Thanks,
K.Prasad

 
