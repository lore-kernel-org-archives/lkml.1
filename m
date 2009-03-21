Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZCUR0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZCUR0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 13:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZCUR0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 13:26:35 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43470 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbZCUR0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 13:26:34 -0400
Date: Sat, 21 Mar 2009 22:56:18 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 01/11] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090321172618.GB9906@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090319234804.GB10517@in.ibm.com> <Pine.LNX.4.44L0.0903201006120.2686-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903201006120.2686-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 10:33:26AM -0400, Alan Stern wrote:
> On Fri, 20 Mar 2009, K.Prasad wrote:
> 
> > This patch introduces two new files hw_breakpoint.[ch] which defines the 
> > generic interfaces to use hardware breakpoint infrastructure of the system. 
> 
> Prasad:
> 
> I'm sorry to say this is full of mistakes.  So far I have looked only 
> at patch 01/11, but it's not good.
> 

After you pointed out, I realise that the code in load_debug_registers()
is an overkill and unregister_kernel_hw_breakpoint() has an obvious 
error which should have caught my attention. My next revision should 
fix them.

> > + * Kernel breakpoints grow downwards, starting from HB_NUM
> > + * 'hbkpt_kernel_pos' denotes lowest numbered breakpoint register occupied for
> > + * kernel-space request
> > + */
> > +unsigned int hbkpt_kernel_pos;
> 
> This doesn't make much sense.  All you need to know is which registers
> are in use; all others are available.
> 

As explained by Maneesh earlier, we compact the kernel-space requests
into registers (HB_NUM - 1) to hbkpt_kernel_pos. The kernel-space
requests aren't specific to any given register number too, and so
compaction would be suitable for this case (unlike when implemented for
user-space which might need virtualisation of registers).

> For example, suppose the kernel allocated breakpoints 3, 2, and 1, and
> then deallocated 2.  Then bp 2 would be available for use, even though
> 2 > 1.
> 
> It's also a poor choice of name.  Everywhere else (in my patches,
> anyway) the code refers to hardware breakpoints using the abbreviation
> "hwbp" or "hw_breakpoint".  There's no reason suddenly to start using
> "hbkpt".
> 

I began using 'hbkpt' as a shorter naming convention (the longer one
being hw_breakpoint) without being really conscious of the 'hwbkpt'
usage by you (even some of the previous iterations contained them in
samples/hw_breakpoint and ftrace-plugin).

Well, I will rename my shorter name to 'hwbkpt' for uniformity.

> > +/* An array containing refcount of threads using a given bkpt register */
> > +unsigned int hbkpt_user_max_refcount[HB_NUM];
> 
> Why did you put "max" in the name?  Isn't this just a simple refcount?
> 

Ok. It will be hbkpt_user_refcount[].

> > +/* One higher than the highest counted user-space breakpoint register */
> > +unsigned int hbkpt_user_max;
> 
> Likewise, this variable isn't really needed.  It's just one more than
> the largest i such that hbkpt_user_max_refcount[i] > 0.
> 

It acts like a cache for determining the user-space breakpoint boundary.
It is used for sanity checks and in its absence we will have to compute from
hbkpt_user_max_refcount[] everytime.

> > +/*
> > + * Install the debug register values for a new thread.
> > + */
> > +void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
> > +{
> > +	/* Set the debug register */
> 
> Set _which_ debug register?
> 

Will change it to read:
/* Set all debug registers used by 'tsk' */

> > +	arch_install_thread_hbkpt(tsk);
> > +	last_debugged_task = current;
> > +
> > +	put_cpu_no_resched();
> 
> What's this line doing here?  It looks like something you forgot to
> erase.
> 
> > +}
> > +
> > +/*
> > + * Install the debug register values for just the kernel, no thread.
> > + */
> > +void switch_to_none_hw_breakpoint(void)
> > +{
> > +	arch_install_none();
> > +	put_cpu_no_resched();
> 
> Same for this line.
> 

These are carriages from the previous code. They are still invoked from
the same places (such as flush_thread_hw_breakpoint(),
hw_breakpoint_handler()) and hence I didn't analyse it enough to see if
they were to be removed.

However, having found that preempt_count() is already zero at places where
these are called I think they can be removed.

> > +}
> > +
> > +/*
> > + * Load the debug registers during startup of a CPU.
> > + */
> > +void load_debug_registers(void)
> > +{
> > +	int i;
> > +	unsigned long flags;
> > +
> > +	/* Prevent IPIs for new kernel breakpoint updates */
> > +	local_irq_save(flags);
> > +
> > +	for (i = hbkpt_kernel_pos; i < HB_NUM; i++)
> > +		if (hbkpt_kernel[i])
> > +			on_each_cpu(arch_install_kernel_hbkpt,
> > +				(void *)hbkpt_kernel[i], 0);
> 
> This is completely wrong.  First of all, it's dumb to send multiple
> IPIs (one for each iteration through the loop).  Second, this routine
> shouldn't send any IPIs at all!  It gets invoked when a CPU is
> starting up and wants to load its _own_ debug registers -- not tell
> another CPU to load anything.
> 

As I agreed before, it is an overkill (given the design of
arch_install_kernel_hbkpt()). I will create a new
arch_update_kernel_hbkpt(pos, bp) that will install breakpoints only
on the CPU starting up.

> > +	if (current->thread.dr7)
> > +		arch_install_thread_hbkpt(current);
> > +
> > +	local_irq_restore(flags);
> > +}
> > +
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
> > +	/* Let the breakpoints know they are being uninstalled */
> 
> This comment looks like a leftover which should have been erased.
> 
> > +/*
> > + * Validate the settings in a hw_breakpoint structure.
> > + */
> > +static int validate_settings(struct hw_breakpoint *bp, struct task_struct *tsk)
> > +{
> > +	int ret;
> > +	unsigned int align;
> > +
> > +	ret = arch_validate_hwbkpt_settings(bp, &align, tsk);
> > +	if (ret < 0)
> > +		goto err;
> > +
> > +	/* Check that the low-order bits of the address are appropriate
> > +	 * for the alignment implied by len.
> > +	 */
> > +	if (bp->info.address & align)
> > +		return -EINVAL;
> > +
> > +	/* Check that the virtual address is in the proper range */
> > +	if (tsk) {
> > +		if (!arch_check_va_in_userspace(bp->info.address, tsk))
> > +			return -EFAULT;
> > +	} else {
> > +		if (!arch_check_va_in_kernelspace(bp->info.address))
> > +			return -EFAULT;
> > +	}
> 
> Roland pointed out that these checks need to take into account the
> length of the breakpoint.  For example, in
> arch_check_va_in_userspace() it isn't sufficient for the start of the
> breakpoint region to be a userspace address; the end of the
> breakpoint region must also be in userspace.
> 

Ok. Will do something like:
return (va <= (TASK_SIZE - (hw_breakpoint_length * word_size)));

> > + err:
> > +	return ret;
> > +}
> > +
> > +int __register_user_hw_breakpoint(int pos, struct task_struct *tsk,
> > +					struct hw_breakpoint *bp)
> > +{
> > +	struct thread_struct *thread = &(tsk->thread);
> > +	int rc;
> > +
> > +	/* Do not overcommit. Fail if kernel has used the hbkpt registers */
> > +	if (pos >= hbkpt_kernel_pos)
> > +		return -ENOSPC;
> 
> In fact you should fail if the debug register is already in use,
> regardless of whether it is being used by a kernel breakpoint.  And you 
> shouldn't check against hbkpt_kernel_pos; you should check whether 
> hbkpt_kernel[pos] is NULL and thread->hbkpt[pos] is NULL.
> 

As explained before, the intended design was like this:

ample layout:
hbkpt_kernel_pos = 1
hbkpt_user_max = 1

---------------------------------------------------------------------
|                |                |                |                |
|       DR3      |       DR2      |       DR1      |       DR0      |
|                |                |                |                |
---------------------------------------------------------------------
^                                                  ^                ^
|                                                  |                |
-----------------kernel-space addresses-------------------user-------

After removing breakpoint in say DR2, compaction occurs.
New layout will be:
hbkpt_kernel_pos = 2
hbkpt_user_max = 1

---------------------------------------------------------------------
|                |                |                |                |
|       DR3      |       DR2      |       DR1      |       DR0      |
|                |                |                |                |
---------------------------------------------------------------------
^                                 ^                ^                ^
|                                 |                |                |
-----------------kernel------------------empty-----------user--------

The above design, in my opinion is intuitive, allows re-use of
uninstalled registers and is simple to implement.

What was missing in the sent patch was the updation of dr7 and dr[pos]
register after compaction. I will add them in the next iteration of the
patch.

> > +
> > +	rc = validate_settings(bp, tsk);
> > +	if (rc)
> > +		return rc;
> > +
> > +	thread->hbkpt[pos] = bp;
> > +	thread->hbkpt_num_installed++;
> > +	hbkpt_user_max_refcount[pos]++;
> > +	/* 'tsk' is the thread that uses max number of hbkpt registers */
> 
> This is a bad comment.  It sounds like it's saying that "tsk" is
> defined as the thread using the maximum number of breakpoints, rather
> than being defined as the thread for which the breakpoint is being
> registered.
> 
> Besides, there's no reason to keep track of which thread uses the max 
> number of breakpoints anyway.  Not to mention the fact that you don't 
> update hbkpt_user_max when its thread exits.
> 

We don't keep track of the thread (in the sense the task_struct) but
'hbkpt_user_max' is used for validating requests and book-keeping. As
Maneesh mentioned before flush_thread_hw_breakpoint() updates
'hbkpt_user_max'.

I can change it to read like the one below if it sounds better to you.

/* 
 * 'tsk' uses more number of registers than 'hbkpt_user_max'. Update
 * the same.
 */

> > +	if (hbkpt_user_max < thread->hbkpt_num_installed)
> > +		hbkpt_user_max++;
> 
> At this point I got tired of looking, but it seems obvious that the new 
> patch series needs a bunch of improvements.
> 
> Alan Stern
>

As mentioned before the next iteration would contain the changes I've
discussed above.

Thanks,
K.Prasad
 
