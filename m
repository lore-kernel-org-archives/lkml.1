Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZCTOdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZCTOdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZCTOdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:33:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34888 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754225AbZCTOdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:33:31 -0400
Date: Fri, 20 Mar 2009 10:33:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 01/11] Introducing generic hardware breakpoint handler
 interfaces
In-Reply-To: <20090319234804.GB10517@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0903201006120.2686-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, K.Prasad wrote:

> This patch introduces two new files hw_breakpoint.[ch] which defines the 
> generic interfaces to use hardware breakpoint infrastructure of the system. 

Prasad:

I'm sorry to say this is full of mistakes.  So far I have looked only 
at patch 01/11, but it's not good.

> + * Kernel breakpoints grow downwards, starting from HB_NUM
> + * 'hbkpt_kernel_pos' denotes lowest numbered breakpoint register occupied for
> + * kernel-space request
> + */
> +unsigned int hbkpt_kernel_pos;

This doesn't make much sense.  All you need to know is which registers
are in use; all others are available.

For example, suppose the kernel allocated breakpoints 3, 2, and 1, and
then deallocated 2.  Then bp 2 would be available for use, even though
2 > 1.

It's also a poor choice of name.  Everywhere else (in my patches,
anyway) the code refers to hardware breakpoints using the abbreviation
"hwbp" or "hw_breakpoint".  There's no reason suddenly to start using
"hbkpt".

> +/* An array containing refcount of threads using a given bkpt register */
> +unsigned int hbkpt_user_max_refcount[HB_NUM];

Why did you put "max" in the name?  Isn't this just a simple refcount?

> +/* One higher than the highest counted user-space breakpoint register */
> +unsigned int hbkpt_user_max;

Likewise, this variable isn't really needed.  It's just one more than
the largest i such that hbkpt_user_max_refcount[i] > 0.

> +/*
> + * Install the debug register values for a new thread.
> + */
> +void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
> +{
> +	/* Set the debug register */

Set _which_ debug register?

> +	arch_install_thread_hbkpt(tsk);
> +	last_debugged_task = current;
> +
> +	put_cpu_no_resched();

What's this line doing here?  It looks like something you forgot to
erase.

> +}
> +
> +/*
> + * Install the debug register values for just the kernel, no thread.
> + */
> +void switch_to_none_hw_breakpoint(void)
> +{
> +	arch_install_none();
> +	put_cpu_no_resched();

Same for this line.

> +}
> +
> +/*
> + * Load the debug registers during startup of a CPU.
> + */
> +void load_debug_registers(void)
> +{
> +	int i;
> +	unsigned long flags;
> +
> +	/* Prevent IPIs for new kernel breakpoint updates */
> +	local_irq_save(flags);
> +
> +	for (i = hbkpt_kernel_pos; i < HB_NUM; i++)
> +		if (hbkpt_kernel[i])
> +			on_each_cpu(arch_install_kernel_hbkpt,
> +				(void *)hbkpt_kernel[i], 0);

This is completely wrong.  First of all, it's dumb to send multiple
IPIs (one for each iteration through the loop).  Second, this routine
shouldn't send any IPIs at all!  It gets invoked when a CPU is
starting up and wants to load its _own_ debug registers -- not tell
another CPU to load anything.

> +	if (current->thread.dr7)
> +		arch_install_thread_hbkpt(current);
> +
> +	local_irq_restore(flags);
> +}
> +
> +/*
> + * Erase all the hardware breakpoint info associated with a thread.
> + *
> + * If tsk != current then tsk must not be usable (for example, a
> + * child being cleaned up from a failed fork).
> + */
> +void flush_thread_hw_breakpoint(struct task_struct *tsk)
> +{
> +	int i;
> +	struct thread_struct *thread = &(tsk->thread);
> +
> +	mutex_lock(&hw_breakpoint_mutex);
> +
> +	/* Let the breakpoints know they are being uninstalled */

This comment looks like a leftover which should have been erased.

> +/*
> + * Validate the settings in a hw_breakpoint structure.
> + */
> +static int validate_settings(struct hw_breakpoint *bp, struct task_struct *tsk)
> +{
> +	int ret;
> +	unsigned int align;
> +
> +	ret = arch_validate_hwbkpt_settings(bp, &align, tsk);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* Check that the low-order bits of the address are appropriate
> +	 * for the alignment implied by len.
> +	 */
> +	if (bp->info.address & align)
> +		return -EINVAL;
> +
> +	/* Check that the virtual address is in the proper range */
> +	if (tsk) {
> +		if (!arch_check_va_in_userspace(bp->info.address, tsk))
> +			return -EFAULT;
> +	} else {
> +		if (!arch_check_va_in_kernelspace(bp->info.address))
> +			return -EFAULT;
> +	}

Roland pointed out that these checks need to take into account the
length of the breakpoint.  For example, in
arch_check_va_in_userspace() it isn't sufficient for the start of the
breakpoint region to be a userspace address; the end of the
breakpoint region must also be in userspace.

> + err:
> +	return ret;
> +}
> +
> +int __register_user_hw_breakpoint(int pos, struct task_struct *tsk,
> +					struct hw_breakpoint *bp)
> +{
> +	struct thread_struct *thread = &(tsk->thread);
> +	int rc;
> +
> +	/* Do not overcommit. Fail if kernel has used the hbkpt registers */
> +	if (pos >= hbkpt_kernel_pos)
> +		return -ENOSPC;

In fact you should fail if the debug register is already in use,
regardless of whether it is being used by a kernel breakpoint.  And you 
shouldn't check against hbkpt_kernel_pos; you should check whether 
hbkpt_kernel[pos] is NULL and thread->hbkpt[pos] is NULL.

> +
> +	rc = validate_settings(bp, tsk);
> +	if (rc)
> +		return rc;
> +
> +	thread->hbkpt[pos] = bp;
> +	thread->hbkpt_num_installed++;
> +	hbkpt_user_max_refcount[pos]++;
> +	/* 'tsk' is the thread that uses max number of hbkpt registers */

This is a bad comment.  It sounds like it's saying that "tsk" is
defined as the thread using the maximum number of breakpoints, rather
than being defined as the thread for which the breakpoint is being
registered.

Besides, there's no reason to keep track of which thread uses the max 
number of breakpoints anyway.  Not to mention the fact that you don't 
update hbkpt_user_max when its thread exits.

> +	if (hbkpt_user_max < thread->hbkpt_num_installed)
> +		hbkpt_user_max++;

At this point I got tired of looking, but it seems obvious that the new 
patch series needs a bunch of improvements.

Alan Stern

