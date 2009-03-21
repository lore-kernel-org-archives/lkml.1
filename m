Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZCUVkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZCUVkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 17:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZCUVkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 17:40:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33575 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751399AbZCUVkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 17:40:03 -0400
Date: Sat, 21 Mar 2009 17:39:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
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
In-Reply-To: <20090321172618.GB9906@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0903211712040.27294-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009, K.Prasad wrote:

> > > + * Kernel breakpoints grow downwards, starting from HB_NUM
> > > + * 'hbkpt_kernel_pos' denotes lowest numbered breakpoint register occupied for
> > > + * kernel-space request
> > > + */
> > > +unsigned int hbkpt_kernel_pos;
> > 
> > This doesn't make much sense.  All you need to know is which registers
> > are in use; all others are available.
> > 
> 
> As explained by Maneesh earlier, we compact the kernel-space requests
> into registers (HB_NUM - 1) to hbkpt_kernel_pos. The kernel-space
> requests aren't specific to any given register number too, and so
> compaction would be suitable for this case (unlike when implemented for
> user-space which might need virtualisation of registers).

Okay, that makes sense.  Perhaps you could add a short comment here
explaining that the register allocations get compacted when a kernel
breakpoint is unregistered, so they will always be contiguous.

> > It's also a poor choice of name.  Everywhere else (in my patches,
> > anyway) the code refers to hardware breakpoints using the abbreviation
> > "hwbp" or "hw_breakpoint".  There's no reason suddenly to start using
> > "hbkpt".
> > 
> 
> I began using 'hbkpt' as a shorter naming convention (the longer one
> being hw_breakpoint) without being really conscious of the 'hwbkpt'
> usage by you (even some of the previous iterations contained them in
> samples/hw_breakpoint and ftrace-plugin).
> 
> Well, I will rename my shorter name to 'hwbkpt' for uniformity.

My patch never used "hwbkpt".  Besides "hw_breakpoint", it used only 
"bp".  On going back and checking, I found that it didn't even use 
"hwbp".  Some other abbreviations it did use were "kbp" for kernel 
breakpoint, "chbi" for per-CPU hardware breakpoint info, and "thbi" for 
per-thread hardware breakpoint info.

If you're looking for a good short name, and if you want to keep 
hardware breakpoints distinct from software breakpoints, I suggest 
"hbp" instead of "hbkpt".  But it's up to you, and it's worth noticing 
that the code already contains lots of variables named just "bp".

> > > +/* One higher than the highest counted user-space breakpoint register */
> > > +unsigned int hbkpt_user_max;
> > 
> > Likewise, this variable isn't really needed.  It's just one more than
> > the largest i such that hbkpt_user_max_refcount[i] > 0.
> > 
> 
> It acts like a cache for determining the user-space breakpoint boundary.
> It is used for sanity checks and in its absence we will have to compute from
> hbkpt_user_max_refcount[] everytime.

That's right.  Isn't it simpler to check

	kernel_pos > 0 && hbkpt_user_refcount[kernel_pos - 1] == 0

than to check

	kernel_pos - 1 >= hbkpt_user_max

_and_ to keep hbkpt_user_max set to the correct value at all times?

> > > +/*
> > > + * Load the debug registers during startup of a CPU.
> > > + */
> > > +void load_debug_registers(void)
> > > +{
> > > +	int i;
> > > +	unsigned long flags;
> > > +
> > > +	/* Prevent IPIs for new kernel breakpoint updates */
> > > +	local_irq_save(flags);
> > > +
> > > +	for (i = hbkpt_kernel_pos; i < HB_NUM; i++)
> > > +		if (hbkpt_kernel[i])
> > > +			on_each_cpu(arch_install_kernel_hbkpt,
> > > +				(void *)hbkpt_kernel[i], 0);
> > 
> > This is completely wrong.  First of all, it's dumb to send multiple
> > IPIs (one for each iteration through the loop).  Second, this routine
> > shouldn't send any IPIs at all!  It gets invoked when a CPU is
> > starting up and wants to load its _own_ debug registers -- not tell
> > another CPU to load anything.
> > 
> 
> As I agreed before, it is an overkill (given the design of
> arch_install_kernel_hbkpt()). I will create a new
> arch_update_kernel_hbkpt(pos, bp) that will install breakpoints only
> on the CPU starting up.

Doesn't arch_install_kernel_hbkpt() already install breakpoints
on only the current CPU?  So why do you need a new function?

> > > +	/* Check that the virtual address is in the proper range */
> > > +	if (tsk) {
> > > +		if (!arch_check_va_in_userspace(bp->info.address, tsk))
> > > +			return -EFAULT;
> > > +	} else {
> > > +		if (!arch_check_va_in_kernelspace(bp->info.address))
> > > +			return -EFAULT;
> > > +	}
> > 
> > Roland pointed out that these checks need to take into account the
> > length of the breakpoint.  For example, in
> > arch_check_va_in_userspace() it isn't sufficient for the start of the
> > breakpoint region to be a userspace address; the end of the
> > breakpoint region must also be in userspace.
> > 
> 
> Ok. Will do something like:
> return (va <= (TASK_SIZE - (hw_breakpoint_length * word_size)));

What is the purpose of word_size here?  The breakpoint length should be 
specified in bytes, not words.

Don't forget that that in arch_check_va_in_kernelspace() you need to 
check both for values that are too low and values that are too high 
(they overflow and wrap around back to a user address).

> We don't keep track of the thread (in the sense the task_struct) but
> 'hbkpt_user_max' is used for validating requests and book-keeping. As
> Maneesh mentioned before flush_thread_hw_breakpoint() updates
> 'hbkpt_user_max'.
> 
> I can change it to read like the one below if it sounds better to you.
> 
> /* 
>  * 'tsk' uses more number of registers than 'hbkpt_user_max'. Update
>  * the same.
>  */

My preference is simply to eliminate hbkpt_user_max entirely.

Alan Stern

