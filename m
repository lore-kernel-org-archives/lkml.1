Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbZE1L4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbZE1L4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759256AbZE1Lzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:55:52 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:59969 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760142AbZE1Lzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:55:50 -0400
Date: Thu, 28 May 2009 17:25:46 +0530
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
Subject: Re: [Patch 02/12] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090528115546.GA6107@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115240.GC25673@in.ibm.com> <20090528061517.GA3091@yookeroo.seuss>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528061517.GA3091@yookeroo.seuss>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 04:15:18PM +1000, David Gibson wrote:
> On Mon, May 11, 2009 at 05:22:40PM +0530, K.Prasad wrote:
> > This patch introduces the generic Hardware Breakpoint interfaces for
> > both user and kernel space requests.
> 
> [snip]
> > Index: kernel/hw_breakpoint.c
> > ===================================================================
> > --- /dev/null
> > +++ kernel/hw_breakpoint.c
> > @@ -0,0 +1,367 @@
> > +/*
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > + *
> > + * Copyright (C) 2007 Alan Stern
> > + * Copyright (C) IBM Corporation, 2009
> > + */
> > +
> > +/*
> > + * HW_breakpoint: a unified kernel/user-space hardware breakpoint facility,
> > + * using the CPU's debug registers.
> > + *
> > + * This file contains the arch-independent routines.  It is not meant
> > + * to be compiled as a standalone source file; rather it should be
> > + * #include'd by the arch-specific implementation.
> > + */
> > +
> > +#include <linux/irqflags.h>
> > +#include <linux/kallsyms.h>
> > +#include <linux/notifier.h>
> > +#include <linux/kprobes.h>
> > +#include <linux/kdebug.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/percpu.h>
> > +#include <linux/mutex.h>
> > +#include <linux/sched.h>
> > +#include <linux/init.h>
> > +#include <linux/smp.h>
> > +
> > +#include <asm/hw_breakpoint.h>
> > +#include <asm/processor.h>
> > +
> > +#ifdef CONFIG_X86
> 
> That's a nasty #ifdef.  Surely this include should instead go in the
> x86 version of hw_breakpoint.h.
> 

Agreed. I will make the change.

> > +#include <asm/debugreg.h>
> > +#endif
> > +/*
> > + * Spinlock that protects all (un)register operations over kernel/user-space
> > + * breakpoint requests
> > + */
> > +DEFINE_SPINLOCK(hw_breakpoint_lock);
> > +
> > +/* Array of kernel-space breakpoint structures */
> > +struct hw_breakpoint *hbp_kernel[HB_NUM];
> > +
> > +/*
> > + * Per-processor copy of hbp_kernel[]. Used only when hbp_kernel is being
> > + * modified but we need the older copy to handle any hbp exceptions. It will
> > + * sync with hbp_kernel[] value after updation is done through IPIs.
> > + */
> > +DEFINE_PER_CPU(struct hw_breakpoint*, this_hbp_kernel[HB_NUM]);
> 
> Ok.. this seems to assume that all breakpoints are equal as far as
> allocation goes - i.e. that the total number of breakpoints is the
> only allocation limit.  That's apparently true for x86, but on
> embedded powerpc (4xx), for example, we can have up to 2 data
> breakpoints and up to 4 instruction breakpoints independent of each
> other.
> 

True. But I hope that you see that the infrastructure is extensible.
While the generic infrastructure has served the purposes of x86 and
PPC64 well, one may want to 'grow' it when implementing breakpoints for
4xx processors. Say, make hbp_kernel[] a 2-D array, one for each
HBP_TYPE (say DAC and IAC) and hbp_kernel_pos into an array (of size
HBP_TYPE).

> > +/*
> > + * Kernel breakpoints grow downwards, starting from HB_NUM
> > + * 'hbp_kernel_pos' denotes lowest numbered breakpoint register occupied for
> > + * kernel-space request. We will initialise it here and not in an __init
> > + * routine because load_debug_registers(), which uses this variable can be
> > + * called very early during CPU initialisation.
> > + */
> > +unsigned int hbp_kernel_pos = HB_NUM;
> 
> Likewise here.  For 44x we would need separate tables and separate
> pointers for data and instruction breakpoints.
> 
> > +/*
> > + * An array containing refcount of threads using a given bkpt register
> > + * Accesses are synchronised by acquiring hw_breakpoint_lock
> > + */
> > +unsigned int hbp_user_refcount[HB_NUM];
> > +
> > +/*
> > + * Install the debug register values for a new thread.
> > + */
> > +void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
> > +{
> > +	/* Set the debug register */
> > +	arch_install_thread_hw_breakpoint(tsk);
> 
> Um.. and the point of this wrapper which does nothing extra around the
> arch-specific function would be...?
> 
> > +}
> > +
> > +/*
> > + * Install the debug register values for just the kernel, no thread.
> > + */
> > +void switch_to_none_hw_breakpoint(void)
> > +{
> > +	arch_uninstall_thread_hw_breakpoint();
> 
> And again.
> 

These functions have hence been removed. You can find the latest
patchset here: http://lkml.org/lkml/2009/5/21/143.

> > +}
> > +
> > +/*
> > + * Load the debug registers during startup of a CPU.
> > + */
> > +void load_debug_registers(void)
> 
> This name does not suggest a boot and/or cpu hotplug only function.
> 

I think the name aptly describes what the function achieves
(irrespective of where it is employed). Let us know if you have better
suggestions.

> > +{
> > +	unsigned long flags;
> > +	struct task_struct *tsk = current;
> > +
> > +	spin_lock_bh(&hw_breakpoint_lock);
> > +
> > +	/* Prevent IPIs for new kernel breakpoint updates */
> > +	local_irq_save(flags);
> > +	arch_update_kernel_hw_breakpoint(NULL);
> > +	local_irq_restore(flags);
> > +
> > +	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
> > +		switch_to_thread_hw_breakpoint(tsk);
> > +
> > +	spin_unlock_bh(&hw_breakpoint_lock);
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
> > +	spin_lock_bh(&hw_breakpoint_lock);
> > +
> > +	/* The thread no longer has any breakpoints associated with it */
> > +	clear_tsk_thread_flag(tsk, TIF_DEBUG);
> > +	for (i = 0; i < HB_NUM; i++) {
> > +		if (thread->hbp[i]) {
> > +			hbp_user_refcount[i]--;
> > +			kfree(thread->hbp[i]);
> > +			thread->hbp[i] = NULL;
> > +		}
> > +	}
> > +
> > +	arch_flush_thread_hw_breakpoint(tsk);
> > +
> > +	/* Actually uninstall the breakpoints if necessary */
> > +	if (tsk == current)
> > +		switch_to_none_hw_breakpoint();
> > +	spin_unlock_bh(&hw_breakpoint_lock);
> > +}
> > +
> > +/*
> > + * Copy the hardware breakpoint info from a thread to its cloned
> > child.
> 
> This comment contradicts what the code actually does.
> 

Agreed. Will change it.

> > + */
> > +int copy_thread_hw_breakpoint(struct task_struct *tsk,
> > +		struct task_struct *child, unsigned long clone_flags)
> > +{
> > +	/*
> > +	 * We will assume that breakpoint settings are not inherited
> > +	 * and the child starts out with no debug registers set.
> > +	 * But what about CLONE_PTRACE?
> > +	 */
> > +	clear_tsk_thread_flag(child, TIF_DEBUG);
> > +
> > +	/* We will call flush routine since the debugregs are not inherited */
> > +	arch_flush_thread_hw_breakpoint(child);
> 
> > +
> > +	return 0;
> > +}
> > +
> > +int __register_user_hw_breakpoint(int pos, struct task_struct *tsk,
> > +					struct hw_breakpoint *bp)
> > +{
> > +	struct thread_struct *thread = &(tsk->thread);
> > +	int rc;
> > +
> > +	/* Do not overcommit. Fail if kernel has used the hbp registers */
> > +	if (pos >= hbp_kernel_pos)
> > +		return -ENOSPC;
> 
> Again, this is generic code making a non-portable assumption about how
> breakpoints must be allocated.
> 

As explained before, this function and its kernel counterparts can be
extended to accomodate newer processors which will be supported by this
infrastructure.

Thanks,
K.Prasad

