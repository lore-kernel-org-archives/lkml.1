Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbZA3LTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbZA3LTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 06:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZA3LTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 06:19:25 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:43102 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZA3LTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 06:19:23 -0500
Date: Fri, 30 Jan 2009 16:49:14 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mingo@elte.hu, richardj_moore@uk.ibm.com, naren@linux.vnet.ibm.com
Subject: Re: [RFC Patch 1/10] Introducing generic hardware breakpoint
	handler interfaces
Message-ID: <20090130111914.GB13814@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090122135640.GA11161@in.ibm.com> <20090122140029.GA18351@in.ibm.com> <20090129035557.GD6462@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129035557.GD6462@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 07:55:57PM -0800, Paul E. McKenney wrote:
> On Thu, Jan 22, 2009 at 07:30:29PM +0530, K.Prasad wrote:
> > This patch introduces two new files hw_breakpoint.[ch] which defines the 
> > generic interfaces to use hardware breakpoint infrastructure of the system. 
> 
> Leveraging hardware breakpoints across architectures wouldbe quite nice!

Thanks for the support!

> 
> A few RCU-related questions below.
> 
> 							Thanx, Paul
> 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > ---
> >  include/asm-generic/hw_breakpoint.h |  243 ++++++++++++
> >  kernel/hw_breakpoint.c              |  722 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 965 insertions(+)
> > 
> > Index: linux-HBKPT-kgdb-2.6.28/include/asm-generic/hw_breakpoint.h
> > ===================================================================
> > --- /dev/null
> > +++ linux-HBKPT-kgdb-2.6.28/include/asm-generic/hw_breakpoint.h
> > @@ -0,0 +1,243 @@
> > +#ifndef	_ASM_GENERIC_HW_BREAKPOINT_H
> > +#define	_ASM_GENERIC_HW_BREAKPOINT_H
> > +
> > +#ifndef __ARCH_HW_BREAKPOINT_H
> > +#error "Please don't include this file directly"
> > +#endif
> > +
> > +#ifdef	__KERNEL__
> > +#include <linux/list.h>
> > +#include <linux/types.h>
> > +#include <linux/kallsyms.h>
> > +
> > +/**
> > + * struct hw_breakpoint - unified kernel/user-space hardware breakpoint
> > + * @node: internal linked-list management
> > + * @triggered: callback invoked after target address access
> > + * @installed: callback invoked when the breakpoint is installed
> > + * @uninstalled: callback invoked when the breakpoint is uninstalled
> > + * @info: arch-specific breakpoint info (address, length, and type)
> > + * @priority: requested priority level
> > + * @status: current registration/installation status
> > + *
> > + * %hw_breakpoint structures are the kernel's way of representing
> > + * hardware breakpoints.  These are data breakpoints
> > + * (also known as "watchpoints", triggered on data access), and the breakpoint's
> > + * target address can be located in either kernel space or user space.
> > + *
> > + * The breakpoint's address, length, and type are highly
> > + * architecture-specific.  The values are encoded in the @info field; you
> > + * specify them when registering the breakpoint.  To examine the encoded
> > + * values use hw_breakpoint_get_{kaddress,uaddress,len,type}(), declared
> > + * below.
> > + *
> > + * The address is specified as a regular kernel pointer (for kernel-space
> > + * breakponts) or as an %__user pointer (for user-space breakpoints).
> > + * With register_user_hw_breakpoint(), the address must refer to a
> > + * location in user space.  The breakpoint will be active only while the
> > + * requested task is running.  Conversely with
> > + * register_kernel_hw_breakpoint(), the address must refer to a location
> > + * in kernel space, and the breakpoint will be active on all CPUs
> > + * regardless of the current task.
> > + *
> > + * The length is the breakpoint's extent in bytes, which is subject to
> > + * certain limitations.  include/asm/hw_breakpoint.h contains macros
> > + * defining the available lengths for a specific architecture.  Note that
> > + * the address's alignment must match the length.  The breakpoint will
> > + * catch accesses to any byte in the range from address to address +
> > + * (length - 1).
> > + *
> > + * The breakpoint's type indicates the sort of access that will cause it
> > + * to trigger.  Possible values may include:
> > + *
> > + * 	%HW_BREAKPOINT_RW (triggered on read or write access),
> > + * 	%HW_BREAKPOINT_WRITE (triggered on write access), and
> > + * 	%HW_BREAKPOINT_READ (triggered on read access).
> > + *
> > + * Appropriate macros are defined in include/asm/hw_breakpoint.h; not all
> > + * possibilities are available on all architectures.  Execute breakpoints
> > + * must have length equal to the special value %HW_BREAKPOINT_LEN_EXECUTE.
> > + *
> > + * When a breakpoint gets hit, the @pre_handler or @post_handler (whichever or
> > + * both depending upon architecture support and assignment by user) callback is
> > + * invoked in_interrupt with a pointer to the %hw_breakpoint structure and the
> > + * processor registers.
> > + * Data breakpoints occur after the memory access has taken place.
> > + * Breakpoints are disabled during execution @triggered, to avoid
> > + * recursive traps and allow unhindered access to breakpointed memory.
> > + *
> > + * Hardware breakpoints are implemented using the CPU's debug registers,
> > + * which are a limited hardware resource.  Requests to register a
> > + * breakpoint will always succeed provided the parameters are valid,
> > + * but the breakpoint may not be installed in a debug register right
> > + * away.  Physical debug registers are allocated based on the priority
> > + * level stored in @priority (higher values indicate higher priority).
> > + * User-space breakpoints within a single thread compete with one
> > + * another, and all user-space breakpoints compete with all kernel-space
> > + * breakpoints; however user-space breakpoints in different threads do
> > + * not compete.  %HW_BREAKPOINT_PRIO_PTRACE is the level used for ptrace
> > + * requests; an unobtrusive kernel-space breakpoint will use
> > + * %HW_BREAKPOINT_PRIO_NORMAL to avoid disturbing user programs.  A
> > + * kernel-space breakpoint that always wants to be installed and doesn't
> > + * care about disrupting user debugging sessions can specify
> > + * %HW_BREAKPOINT_PRIO_HIGH.
> > + *
> > + * A particular breakpoint may be allocated (installed in) a debug
> > + * register or deallocated (uninstalled) from its debug register at any
> > + * time, as other breakpoints are registered and unregistered.  The
> > + * @installed and @uninstalled callbacks are invoked in_atomic when these
> > + * events occur.  It is legal for @installed or @uninstalled to be %NULL,
> > + * but one of the handlers - @pre_handler or @post_handler must be populated
> > + * (please check support for your architecture using pre_ and
> > + * post_handler_supported() routines to check for support.  Note that it is not
> > + * possible to register or unregister a user-space breakpoint from within a
> > + * callback routine, since doing so requires a process context.  Note that for
> > + * user breakpoints, while in @installed and @uninstalled the thread may be
> > + * context switched. Hence it may not be safe to call printk().
> > + *
> > + * For kernel-space breakpoints, @installed is invoked after the
> > + * breakpoint is actually installed and @uninstalled is invoked before
> > + * the breakpoint is actually uninstalled.  As a result the @pre_ and
> > + * @post_handler() routines may be invoked when not expected, but this way you
> > + * will know that during the time interval from @installed to @uninstalled, all
> > + * events are faithfully reported.  (It is not possible to do any better than
> > + * this in general, because on SMP systems there is no way to set a debug
> > + * register simultaneously on all CPUs.)  The same isn't always true with
> > + * user-space breakpoints, but the differences should not be visible to a
> > + * user process.
> > + *
> > + * If you need to know whether your kernel-space breakpoint was installed
> > + * immediately upon registration, you can check the return value from
> > + * register_kernel_hw_breakpoint().  If the value is not > 0, you can
> > + * give up and unregister the breakpoint right away.
> > + *
> > + * @node and @status are intended for internal use.  However @status
> > + * may be read to determine whether or not the breakpoint is currently
> > + * installed.  (The value is not reliable unless local interrupts are
> > + * disabled.)
> > + *
> > + * This sample code sets a breakpoint on pid_max and registers a callback
> > + * function for writes to that variable.  Note that it is not portable
> > + * as written, because not all architectures support HW_BREAKPOINT_LEN_4.
> > + *
> > + * ----------------------------------------------------------------------
> > + *
> > + * #include <asm/hw_breakpoint.h>
> > + *
> > + * static void my_pre_handler(struct hw_breakpoint *bp, struct pt_regs *regs)
> > + * {
> > + * 	printk(KERN_DEBUG "Inside pre_handler of breakpoint exception\n");
> > + * 	dump_stack();
> > + *  	.......<more debugging output>........
> > + * }
> > + *
> > + * static void my_post_handler(struct hw_breakpoint *bp, struct pt_regs *regs)
> > + * {
> > + * 	printk(KERN_DEBUG "Inside post_handler of breakpoint exception\n");
> > + * 	dump_stack();
> > + *  	.......<more debugging output>........
> > + * }
> > + *
> > + * static struct hw_breakpoint my_bp;
> > + *
> > + * static int init_module(void)
> > + * {
> > + *	..........<do anything>............
> > + *	int bkpt_type = HW_BREAKPOINT_WRITE;
> > + *
> > + *	if (pre_handler_supported(bkpt_type)
> > + *		my_bp.pre_handler = my_pre_handler;
> > + *	if (post_handler_supported(bkpt_type)
> > + *		my_bp.post_handler = my_post_handler;
> > + *	my_bp.priority = HW_BREAKPOINT_PRIO_NORMAL;
> > + *	rc = register_kernel_hw_breakpoint(&my_bp, &pid_max,
> > + *			HW_BREAKPOINT_LEN_4, bkpt_type);
> > + *	..........<do anything>............
> > + * }
> > + *
> > + * static void cleanup_module(void)
> > + * {
> > + *	..........<do anything>............
> > + *	unregister_kernel_hw_breakpoint(&my_bp);
> > + *	..........<do anything>............
> > + * }
> > + *
> > + * ----------------------------------------------------------------------
> > + *
> > + */
> > +struct hw_breakpoint {
> > +	struct list_head	node;
> > +	void		(*installed)(struct hw_breakpoint *);
> > +	void		(*uninstalled)(struct hw_breakpoint *);
> > +	void		(*triggered)(struct hw_breakpoint *,
> > +							struct pt_regs *);
> > +	struct arch_hw_breakpoint	info;
> > +	u8		priority;
> > +	u8		status;
> > +};
> > +
> > +/*
> > + * Inline accessor routines to retrieve the arch-specific parts of
> > + * a breakpoint structure:
> > + */
> > +static const void *hw_breakpoint_get_kaddress(struct hw_breakpoint *bp);
> > +static const void __user *hw_breakpoint_get_uaddress(struct hw_breakpoint *bp);
> > +static unsigned hw_breakpoint_get_len(struct hw_breakpoint *bp);
> > +static unsigned hw_breakpoint_get_type(struct hw_breakpoint *bp);
> > +//TODO: Prasad
> > +static inline unsigned long hw_breakpoint_lookup_name(const char *name);
> > +
> > +/*
> > + * len and type values are defined in include/asm/hw_breakpoint.h.
> > + * Available values vary according to the architecture.  On i386 the
> > + * possibilities are:
> > + *
> > + *	HW_BREAKPOINT_LEN_1
> > + *	HW_BREAKPOINT_LEN_2
> > + *	HW_BREAKPOINT_LEN_4
> > + *	HW_BREAKPOINT_LEN_EXECUTE
> > + *	HW_BREAKPOINT_RW
> > + *	HW_BREAKPOINT_READ
> > + *	HW_BREAKPOINT_EXECUTE
> > + *
> > + * On other architectures HW_BREAKPOINT_LEN_8 may be available, and the
> > + * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
> > + * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
> > + */
> > +
> > +/* Standard HW breakpoint priority levels (higher value = higher priority) */
> > +#define HW_BREAKPOINT_PRIO_NORMAL	25
> > +#define HW_BREAKPOINT_PRIO_PTRACE	50
> > +#define HW_BREAKPOINT_PRIO_HIGH		75
> > +
> > +/* HW breakpoint status values (0 = not registered) */
> > +#define HW_BREAKPOINT_REGISTERED	1
> > +#define HW_BREAKPOINT_INSTALLED		2
> > +
> > +static DEFINE_MUTEX(hw_breakpoint_mutex);	/* Protects everything */
> > +
> > +/*
> > + * The following two routines are meant to be called only from within
> > + * the ptrace or utrace subsystems.  The tsk argument will usually be a
> > + * process being debugged by the current task, although it is also legal
> > + * for tsk to be the current task.  In any case it must be guaranteed
> > + * that tsk will not start running in user mode while its breakpoints are
> > + * being modified.
> > + */
> > +int register_user_hw_breakpoint(struct task_struct *tsk,
> > +		struct hw_breakpoint *bp,
> > +		const void __user *address, unsigned len, unsigned type);
> > +void unregister_user_hw_breakpoint(struct task_struct *tsk,
> > +		struct hw_breakpoint *bp);
> > +
> > +/*
> > + * Kernel breakpoints are not associated with any particular thread.
> > + */
> > +int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
> > +void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
> > +
> > +struct thread_hw_breakpoint *alloc_thread_hw_breakpoint(
> > +						struct task_struct *tsk);
> > +
> > +#endif	/* __KERNEL__ */
> > +#endif	/* _ASM_GENERIC_HW_BREAKPOINT_H */
> > Index: linux-HBKPT-kgdb-2.6.28/kernel/hw_breakpoint.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-HBKPT-kgdb-2.6.28/kernel/hw_breakpoint.c
> > @@ -0,0 +1,722 @@
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
> > +
> > +/*
> > + * Install the debug register values for a new thread.
> > + */
> > +void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
> > +{
> > +	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
> > +	struct cpu_hw_breakpoint *chbi;
> > +	struct kernel_bp_data *thr_kbpdata;
> > +
> > +	/* This routine is on the hot path; it gets called for every
> > +	 * context switch into a task with active breakpoints.  We
> > +	 * must make sure that the common case executes as quickly as
> > +	 * possible.
> > +	 */
> > +	chbi = &per_cpu(cpu_info, get_cpu());
> > +	chbi->bp_task = tsk;
> > +
> > +	/* Use RCU to synchronize with external updates */
> > +	rcu_read_lock();
> > +
> > +	/* Other CPUs might be making updates to the list of kernel
> > +	 * breakpoints at this time.  If they are, they will modify
> > +	 * the other entry in kbpdata[] -- the one not pointed to
> > +	 * by chbi->cur_kbpdata.  So the update itself won't affect
> > +	 * us directly.
> > +	 *
> > +	 * However when the update is finished, an IPI will arrive
> > +	 * telling this CPU to change chbi->cur_kbpdata.  We need
> > +	 * to use a single consistent kbpdata[] entry, the present one.
> > +	 * So we'll copy the pointer to a local variable, thr_kbpdata,
> > +	 * and we must prevent the compiler from aliasing the two
> > +	 * pointers.  Only a compiler barrier is required, not a full
> > +	 * memory barrier, because everything takes place on a single CPU.
> > +	 */
> > + restart:
> > +	thr_kbpdata = chbi->cur_kbpdata;
> > +	barrier();
> 
> Couldn't the above two lines instead be:
> 
> 	thr_kbpdata = ACCESS_ONCE(chbi->cur_kbpdata);
> 
> This would prevent the pointer aliasing, but would make it very clear
> exactly how the compiler was to be restricted.

Ok. Using a barrier() could be an overkill. I will change it.

> 
> > +	/* Normally we can keep the same debug register settings as the
> > +	 * last time this task ran.  But if the kernel breakpoints have
> > +	 * changed or any user breakpoints have been registered or
> > +	 * unregistered, we need to handle the updates and possibly
> > +	 * send out some notifications.
> > +	 */
> > +	if (unlikely(thbi->gennum != thr_kbpdata->gennum)) {
> > +		struct hw_breakpoint *bp;
> > +		int i;
> > +		int num;
> > +
> > +		thbi->gennum = thr_kbpdata->gennum;
> > +		arch_update_thbi(thbi, thr_kbpdata);
> > +		num = thr_kbpdata->num_kbps;
> > +
> > +		/* This code can be invoked while a debugger is actively
> > +		 * updating the thread's breakpoint list. We use RCU to
> > +		 * protect our access to the list pointers. */
> > +		thbi->num_installed = 0;
> > +		i = HB_NUM;
> > +		list_for_each_entry_rcu(bp, &thbi->thread_bps, node) {
> > +
> > +			/* If this register is allocated for kernel bps,
> > +			 * don't install.  Otherwise do. */
> > +			if (--i < num) {
> > +				if (bp->status == HW_BREAKPOINT_INSTALLED) {
> > +					if (bp->uninstalled)
> > +						(bp->uninstalled)(bp);
> > +					bp->status = HW_BREAKPOINT_REGISTERED;
> > +				}
> > +			} else {
> > +				++thbi->num_installed;
> > +				if (bp->status != HW_BREAKPOINT_INSTALLED) {
> > +					bp->status = HW_BREAKPOINT_INSTALLED;
> > +					if (bp->installed)
> > +						(bp->installed)(bp);
> > +				}
> > +			}
> > +		}
> > +	}
> > +
> > +	/* Set the debug register */
> > +	arch_install_thbi(thbi);
> > +
> > +	/* Were there any kernel breakpoint changes while we were running? */
> > +	if (unlikely(chbi->cur_kbpdata != thr_kbpdata)) {
> > +
> > +		/* Some debug registers now be assigned to kernel bps and
> > +		 * we might have messed them up.  Reload all the kernel bps
> > +		 * and then reload the thread bps.
> > +		 */
> > +		arch_install_chbi(chbi);
> > +		goto restart;
> > +	}
> > +
> > +	rcu_read_unlock();
> > +	put_cpu_no_resched();
> > +}
> > +
> > +/*
> > + * Install the debug register values for just the kernel, no thread.
> > + */
> > +static void switch_to_none_hw_breakpoint(void)
> > +{
> > +	struct cpu_hw_breakpoint *chbi;
> > +
> > +	chbi = &per_cpu(cpu_info, get_cpu());
> > +	chbi->bp_task = NULL;
> > +
> > +	/* This routine gets called from only two places.  In one
> > +	 * the caller holds the hw_breakpoint_mutex; in the other
> > +	 * interrupts are disabled.  In either case, no kernel
> > +	 * breakpoint updates can arrive while the routine runs.
> > +	 * So we don't need to use RCU.
> > +	 */
> > +	arch_install_none(chbi);
> > +	put_cpu_no_resched();
> > +}
> > +
> > +/*
> > + * Update the debug registers on this CPU.
> > + */
> > +static void update_this_cpu(void *unused)
> > +{
> > +	struct cpu_hw_breakpoint *chbi;
> > +	struct task_struct *tsk = current;
> > +
> > +	chbi = &per_cpu(cpu_info, get_cpu());
> > +
> > +	/* Install both the kernel and the user breakpoints */
> > +	arch_install_chbi(chbi);
> > +	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
> > +		switch_to_thread_hw_breakpoint(tsk);
> > +
> > +	put_cpu_no_resched();
> > +}
> > +
> > +/*
> > + * Tell all CPUs to update their debug registers.
> > + *
> > + * The caller must hold hw_breakpoint_mutex.
> > + */
> > +static void update_all_cpus(void)
> > +{
> > +	/* We don't need to use any sort of memory barrier.  The IPI
> > +	 * carried out by on_each_cpu() includes its own barriers.
> > +	 */
> > +	on_each_cpu(update_this_cpu, NULL, 0);
> > +	synchronize_rcu();
> 
> Don't we need the rcu_read_lock() / rcu_read_unlock() pair from
> load_debug_registers() to move down into update_this_cpu() in order
> for this to be guaranteed to work?  As the code reads now, the
> update_this_cpu() calls running on other CPUs are not running under
> RCU protection, right?
> 

Yes, indeed. With the current implementation, there's a possibility of
two instances of update_this_cpu() function executing - one with an
rcu_read_lock() taken (when called from load_debug_registers) while the
other without (when invoked through update_all_cpus()).

I will change update_this_cpu() to read like this:

+static void update_this_cpu(void *unused)
+{
+       struct cpu_hw_breakpoint *chbi;
+       struct task_struct *tsk = current;
+
+       chbi = &per_cpu(cpu_info, get_cpu());
+
+       rcu_read_lock();
+       /* Install both the kernel and the user breakpoints */
+       arch_install_chbi(chbi);
+       if (test_tsk_thread_flag(tsk, TIF_DEBUG))
+               switch_to_thread_hw_breakpoint(tsk);
+
+       rcu_read_unlock();
+
+       put_cpu_no_resched();
+}

while removing the rcu_read_(un)lock() routine from
load_debug_registers().

Thanks,
K.Prasad

