Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbZE1NmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbZE1NmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758698AbZE1NmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:42:03 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44654 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789AbZE1NmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:42:01 -0400
Date: Thu, 28 May 2009 19:11:51 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: David Gibson <dwg@au1.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 03/12] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090528134151.GA4257@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115303.GD25673@in.ibm.com> <20090528063515.GB3091@yookeroo.seuss>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528063515.GB3091@yookeroo.seuss>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 04:35:15PM +1000, David Gibson wrote:
> On Mon, May 11, 2009 at 05:23:03PM +0530, K.Prasad wrote:
> > This patch introduces the arch-specific implementation of
> > hw_breakpoint.c inside x86 specific directories. They contain
> > functions which help validate and serve requests for using Hardware
> > Breakpoint registers on x86 processors.
> 
> [snip]
> > +static int get_hbp_len(u8 hbp_len)
> > +{
> > +	unsigned int len_in_bytes = 0;
> > +
> > +	switch (hbp_len) {
> > +	case HW_BREAKPOINT_LEN_1:
> > +		len_in_bytes = 1;
> > +		break;
> > +	case HW_BREAKPOINT_LEN_2:
> > +		len_in_bytes = 2;
> > +		break;
> > +	case HW_BREAKPOINT_LEN_4:
> > +		len_in_bytes = 4;
> > +		break;
> > +#ifdef CONFIG_X86_64
> > +	case HW_BREAKPOINT_LEN_8:
> > +		len_in_bytes = 8;
> > +		break;
> > +#endif
> 
> Hrm, the fact that you have to do this nasty back-conversion again
> makes me wonder at the wisdom of having per-arch encodings for
> breakpoint length.
> 

If you're suggesting that users would specify the length of the requested
breakpoint directly as numerals (like 2, 4 or 8 bytes) and not
pre-defined constants such as HW_BREAKPOINT_LEN, it has two implications
to it. By defining the permissible values for breakpoint length, the
user is assured that the request for breakpoint registration is valid
(atleast in terms of length) and does not have to refer the
code/processor manual for supported address lengths on the host
processor.

On the other hand, it may be perceived as being less user-friendly as
you cited above.

Given the above reasoning, do you prefer to allow numeric values
specified by the user?

> > +	}
> > +	return len_in_bytes;
> > +}
> > +
> > +/*
> > + * Check for virtual address in user space.
> > + */
> > +int arch_check_va_in_userspace(unsigned long va, u8 hbp_len)
> > +{
> > +	unsigned int len;
> > +
> > +	len = get_hbp_len(hbp_len);
> > +
> > +	return (va <= TASK_SIZE - len);
> > +}
> > +
> > +/*
> > + * Check for virtual address in kernel space.
> > + */
> > +int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
> > +{
> > +	unsigned int len;
> > +
> > +	len = get_hbp_len(hbp_len);
> > +
> > +	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
> > +}
> > +
> > +/*
> > + * Store a breakpoint's encoded address, length, and type.
> > + */
> > +static int arch_store_info(struct hw_breakpoint *bp)
> 
> This function doesn't look very arch specific.  Nor is the name very
> meaningful.
> 

The function populates arch-specific fields and hence the arch_ prefix.
I am open to any suggestions that will be incorporated in future
enhancements.

> > +{
> > +	/*
> > +	 * User-space requests will always have the address field populated
> > +	 * For kernel-addresses, either the address or symbol name can be
> > +	 * specified.
> > +	 */
> > +	if (bp->info.name)
> > +		bp->info.address = (unsigned long)
> > +					kallsyms_lookup_name(bp->info.name);
> > +	if (bp->info.address)
> > +		return 0;
> > +	return -EINVAL;
> > +}
> > +
> > +/*
> > + * Validate the arch-specific HW Breakpoint register settings
> > + */
> > +int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
> > +						struct task_struct *tsk)
> > +{
> > +	unsigned int align;
> > +	int ret = -EINVAL;
> > +
> > +	switch (bp->info.type) {
> > +	/*
> > +	 * Ptrace-refactoring code
> > +	 * For now, we'll allow instruction breakpoint only for user-space
> > +	 * addresses
> > +	 */
> > +	case HW_BREAKPOINT_EXECUTE:
> > +		if ((!arch_check_va_in_userspace(bp->info.address,
> > +							bp->info.len)) &&
> > +			bp->info.len != HW_BREAKPOINT_LEN_EXECUTE)
> > +			return ret;
> > +		break;
> > +	case HW_BREAKPOINT_WRITE:
> > +		break;
> > +	case HW_BREAKPOINT_RW:
> > +		break;
> > +	default:
> > +		return ret;
> > +	}
> > +
> > +	switch (bp->info.len) {
> > +	case HW_BREAKPOINT_LEN_1:
> > +		align = 0;
> > +		break;
> > +	case HW_BREAKPOINT_LEN_2:
> > +		align = 1;
> > +		break;
> > +	case HW_BREAKPOINT_LEN_4:
> > +		align = 3;
> > +		break;
> > +#ifdef CONFIG_X86_64
> > +	case HW_BREAKPOINT_LEN_8:
> > +		align = 7;
> > +		break;
> > +#endif
> > +	default:
> > +		return ret;
> > +	}
> > +
> > +	if (bp->triggered)
> > +		ret = arch_store_info(bp);
> > +
> > +	if (ret < 0)
> > +		return ret;
> > +	/*
> > +	 * Check that the low-order bits of the address are appropriate
> > +	 * for the alignment implied by len.
> > +	 */
> > +	if (bp->info.address & align)
> > +		return -EINVAL;
> > +
> > +	/* Check that the virtual address is in the proper range */
> > +	if (tsk) {
> > +		if (!arch_check_va_in_userspace(bp->info.address, bp->info.len))
> > +			return -EFAULT;
> > +	} else {
> > +		if (!arch_check_va_in_kernelspace(bp->info.address,
> > +								bp->info.len))
> > +			return -EFAULT;
> > +	}
> > +	return 0;
> > +}
> > +
> > +void arch_update_user_hw_breakpoint(int pos, struct task_struct *tsk)
> > +{
> > +	struct thread_struct *thread = &(tsk->thread);
> > +	struct hw_breakpoint *bp = thread->hbp[pos];
> > +
> > +	thread->debugreg7 &= ~dr7_masks[pos];
> > +	if (bp) {
> > +		thread->debugreg[pos] = bp->info.address;
> > +		thread->debugreg7 |= encode_dr7(pos, bp->info.len,
> > +							bp->info.type);
> > +	} else
> > +		thread->debugreg[pos] = 0;
> > +}
> > +
> > +void arch_flush_thread_hw_breakpoint(struct task_struct *tsk)
> > +{
> > +	int i;
> > +	struct thread_struct *thread = &(tsk->thread);
> > +
> > +	thread->debugreg7 = 0;
> > +	for (i = 0; i < HB_NUM; i++)
> > +		thread->debugreg[i] = 0;
> > +}
> > +
> > +/*
> > + * Handle debug exception notifications.
> > + */
> > +int __kprobes hw_breakpoint_handler(struct die_args *args)
> > +{
> > +	int i, cpu, rc = NOTIFY_STOP;
> > +	struct hw_breakpoint *bp;
> > +	/* The DR6 value is stored in args->err */
> > +	unsigned long dr7, dr6 = args->err;
> > +
> > +	/* Do an early return if no trap bits are set in DR6 */
> > +	if ((dr6 & DR_TRAP_BITS) == 0)
> > +		return NOTIFY_DONE;
> > +
> > +	/* Lazy debug register switching */
> > +	if (!test_tsk_thread_flag(current, TIF_DEBUG))
> > +		switch_to_none_hw_breakpoint();
> 
> Shouldn't you also drop out of the handler here, rather than having to
> again check for a false alarm below.
> 

No. We could be inside the handler because of a kernel-space breakpoint
and still have the above condition true.

> It's also not immediately clear to me how lazy switching buys you
> anything here, since it's only lazy switching off, not lazy switching
> on.
>

In this code-snippet from __switch_to() in arch/x86/kernel/process_32.c,

        if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
                arch_install_thread_hw_breakpoint(next_p);

we only check if 'next_p' has TIF_DEBUG flag set in order to enable
breakpoints, but don't clear the physical debug registers if 'prev'
process had used them (can be detected by testing for TIF_DEBUG).
This saves us one additional check in the hot-path but we might
encounter stray exceptions due to lazy debug register switching.

Such exceptions are detected in the above code, resulting in the
physical debug registers being cleared-off their stale values and the
exception being ignored.

Thanks,
K.Prasad

