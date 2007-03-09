Return-Path: <linux-kernel-owner+w=401wt.eu-S1767460AbXCISku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767460AbXCISku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXCISkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:40:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56607 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932929AbXCISkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:40:46 -0500
Date: Fri, 9 Mar 2007 13:40:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070309065203.3A81A180063@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0703091253050.2611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Roland McGrath wrote:

> > That sounds like a rather fragile approach to avoiding a minimal amount of 
> > work.  Debug exceptions don't occur very often, and when they do it won't 
> > matter too much if we go through some extra notifier-chain callouts.
> 
> When single-stepping occurs it happens repeatedly many times, and that
> doesn't need any more overhead than it already has.  

Well, I can add in the test for 0, but finding the set of always-on bits
in DR6 will have to be done separately.  Isn't it possible that different
CPUs could have different bits?


> > It turns out that this won't work correctly unless I use something
> > stronger, like a spinlock or RCU.  Either one seems like overkill.
> 
> What is the problem with just clearing TIF_DEBUG?  It just means that in
> the SIGKILL case, the dying thread won't switch in its local debugregs.
> The global kernel allocations will already be set in the processor from the
> previous context, and old user-address allocations do no harm since we
> won't run in user mode again before switching out at the end of do_exit.

Here's what might happen.  Let's say T is being debugged by D, when
somebody sends T a SIGKILL.  CPU 0 does a __switch_to() to take care of
terminating T, and since TIF_DEBUG is still set, it runs the
switch_to_thread_hw_breakpoint() routine.  The routine begins to install 
the debug registers for T.

At that moment D, running on CPU 1, decides to unregister a breakpoint in
T.  Clearing TIF_DEBUG now doesn't do any good -- it's too late; CPU 0 has
already tested it.  CPU 1 goes in and alters the user breakpoint data,
maybe even deallocating a breakpoint structure that CPU 0 is about to
read.  Not a good situation.

What I need is some way for CPU 0 to know from the start that the current 
task is about to die, so it can avoid installing the user breakpoints 
altogether.  Or else there has to be some sort of mutual exclusion so that 
the two CPUs don't try to access the breakpoint data at the same time.


> > Is there any way to find out from within the
> > switch_to_thread_hw_breakpoint routine whether the task is in this unusual
> > state?  (By which I mean the task is being debugged and the debugger
> > hasn't told it to start running.)  Would (tsk->exit_code == SIGKILL) work?  
> 
> That won't necessarily work.  There isn't any cheap check that won't also
> catch a task preempted on its way to stopping for the debugger.  

No way to tell when a task being debugged is started up by anything other 
than its debugger?  Hmmm, in that case maybe it would be better to use 
RCU.  It won't add much overhead to anything but the code for registering 
and unregistering user breakpoints.


> > In a similar vein, I need a reliable way to know whether a task has gone 
> > through exit_thread().  If it has, then its hw_breakpoint area has been 
> > deallocated and a new one must not be allocated.  Will (tsk->flags & 
> > PF_EXITING) always be true once that happens?
> 
> PF_EXITING it set after there is no possibility of returning to user mode,
> but a while before exit_thread, when you might still want kernel-mode
> breakpoints.  If the only per-thread allocations you support are for user
> mode, then you can certainly refuse to do any when PF_EXITING is set.

Okay, that's easy enough.


On Fri, 9 Mar 2007, Christoph Hellwig wrote:

> btw, can you repost a snapshot patch with your?  I seem to have lost
> were we're standing code-wise currently.  Also do you have some examples
> we can put in now?  If not I'd like to hack some up based on that snapshot.

Below is the current version of the patch, against 2.6.21-rc3.  The source 
file include/asm-i386/hw_breakpoint.h includes an example showing how to 
set up a kernel breakpoint.

Alan Stern



Index: 2.6.21-rc2/include/asm-i386/hw_breakpoint.h
===================================================================
--- /dev/null
+++ 2.6.21-rc2/include/asm-i386/hw_breakpoint.h
@@ -0,0 +1,193 @@
+#ifndef	_I386_HW_BREAKPOINT_H
+#define	_I386_HW_BREAKPOINT_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+
+/**
+ *
+ * struct hw_breakpoint - unified kernel/user-space hardware breakpoint
+ * @node: internal linked-list management
+ * @triggered: callback invoked when the breakpoint is hit
+ * @installed: callback invoked when the breakpoint is installed
+ * @uninstalled: callback invoked when the breakpoint is uninstalled
+ * @address: location (virtual address) of the breakpoint
+ * @len: extent of the breakpoint address (1, 2, or 4 bytes)
+ * @type: breakpoint type (write-only, read/write, execute, or I/O)
+ * @priority: requested priority level
+ * @status: current registration/installation status
+ *
+ * %hw_breakpoint structures are the kernel's way of representing
+ * hardware breakpoints.  These can be either execution breakpoints
+ * (triggered on instruction execution) or data breakpoints (also known
+ * as "watchpoints", triggered on data access), and the breakpoint's
+ * target address can be located in either kernel space or user space.
+ *
+ * The @address, @len, and @type fields are standard, indicating the
+ * location of the breakpoint, its extent in bytes, and the type of
+ * access that will trigger the breakpoint.  Possible values for @len are
+ * 1, 2, and 4.  (On x86_64, @len may also be 8.)  Possible values for
+ * @type are %HW_BREAKPOINT_WRITE (triggered on write access),
+ * %HW_BREAKPOINT_RW (triggered on read or write access),
+ * %HW_BREAKPOINT_IO (triggered on I/O-space access), and
+ * %HW_BREAKPOINT_EXECUTE (triggered on instruction execution).  Certain
+ * restrictions apply: %HW_BREAKPOINT_EXECUTE requires that @len be 1,
+ * and %HW_BREAKPOINT_IO is available only on processors with Debugging
+ * Extensions.
+ *
+ * (Note: %HW_BREAKPOINT_IO is currently unimplemented.  It can be added
+ * if there is a demand for it.)
+ *
+ * In register_user_hw_breakpoint() and modify_user_hw_breakpoint(),
+ * @address must refer to a location in user space (unless @type is
+ * %HW_BREAKPOINT_IO).  The breakpoint will be active only while the
+ * requested task is running.  Conversely, in
+ * register_kernel_hw_breakpoint() @address must refer to a location in
+ * kernel space, and the breakpoint will be active on all CPUs regardless
+ * of the task being run.
+ *
+ * When a breakpoint gets hit, the @triggered callback is invoked
+ * in_interrupt with a pointer to the %hw_breakpoint structure and the
+ * processor registers.  %HW_BREAKPOINT_EXECUTE traps occur before the
+ * breakpointed instruction executes; all other types of trap occur after
+ * the memory or I/O access has taken place.  All breakpoints are
+ * disabled while @triggered runs, to avoid recursive traps and allow
+ * unhindered access to breakpointed memory.
+ *
+ * Hardware breakpoints are implemented using the CPU's debug registers,
+ * which are a limited hardware resource.  Requests to register a
+ * breakpoint will always succeed (provided the member entries are
+ * valid), but the breakpoint may not be installed in a debug register
+ * right away.  Physical debug registers are allocated based on the
+ * priority level stored in @priority (higher values indicate higher
+ * priority).  User-space breakpoints within a single thread compete with
+ * one another, and all user-space breakpoints compete with all
+ * kernel-space breakpoints; however user-space breakpoints in different
+ * threads do not compete.  %HW_BREAKPOINT_PRIO_PTRACE is the level used
+ * for ptrace requests; an unobtrusive kernel-space breakpoint will use
+ * %HW_BREAKPOINT_PRIO_NORMAL to avoid disturbing user programs.  A
+ * kernel-space breakpoint that always wants to be installed and doesn't
+ * care about disrupting user debugging sessions can specify
+ * %HW_BREAKPOINT_PRIO_HIGH.
+ *
+ * A particular breakpoint may be allocated (installed in) a debug
+ * register or deallocated (uninstalled) from its debug register at any
+ * time, as other breakpoints are registered and unregistered.  The
+ * @installed and @uninstalled callbacks are invoked in_atomic when these
+ * events occur.  It is legal for @installed or @uninstalled to be %NULL,
+ * however @triggered must not be.  Note that it is not possible to
+ * register or unregister a breakpoint from within a callback routine,
+ * since doing so requires a process context.  Note also that for user
+ * breakpoints, @installed and @uninstalled may be called during the
+ * middle of a context switch, at a time when it is not safe to call
+ * printk().
+ *
+ * For kernel-space breakpoints, @installed is invoked after the
+ * breakpoint is actually installed and @uninstalled is invoked before
+ * the breakpoint is actually uninstalled.  As a result @triggered might
+ * be called when you may not expect it, but this way the breakpoint
+ * owner knows that during the time interval from @installed to
+ * @uninstalled, all events are faithfully reported.  (It is not possible
+ * to do any better than this in general, because on SMP systems there is
+ * no way to set a debug register simultaneously on all CPUs.)  The same
+ * isn't always true with user-space breakpoints, but the differences
+ * should not be visible to a user process.
+ *
+ * The @address, @len, and @type fields in a use-space breakpoint can be
+ * changed by calling modify_user_hw_breakpoint().  Kernel-space
+ * breakpoints cannot be modified, nor can the @priority value in
+ * user-space breakpoints, after the breakpoint has been registered.  And
+ * of course all the fields in a %hw_breakpoint structure should be
+ * treated as read-only while the breakpoint is registered.
+ *
+ * @node and @status are intended for internal use, however @status may
+ * be read to determine whether or not the breakpoint is currently
+ * installed.
+ *
+ * This sample code sets a breakpoint on pid_max and registers a callback
+ * function for writes to that variable.
+ *
+ * ----------------------------------------------------------------------
+ *
+ * #include <asm/hw_breakpoint.h>
+ *
+ * static void triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
+ * {
+ * 	printk(KERN_DEBUG "Breakpoint triggered\n");
+ * 	dump_stack();
+ *  	.......<more debugging output>........
+ * }
+ *
+ * static struct hw_breakpoint my_bp;
+ *
+ * static int init_module(void)
+ * {
+ * 	..........<do anything>............
+ * 	my_bp.address = &pid_max;
+ * 	my_bp.type = HW_BREAKPOINT_WRITE;
+ * 	my_bp.len = 4;
+ * 	my_bp.triggered = triggered;
+ * 	my_bp.priority = HW_BREAKPOINT_PRIO_NORMAL;
+ * 	rc = register_kernel_hw_breakpoint(&my_bp);
+ * 	..........<do anything>............
+ * }
+ *
+ * static void cleanup_module(void)
+ * {
+ * 	..........<do anything>............
+ * 	unregister_kernel_hw_breakpoint(&my_bp);
+ * 	..........<do anything>............
+ * }
+ *
+ * ----------------------------------------------------------------------
+ *
+ */
+struct hw_breakpoint {
+	struct list_head	node;
+	void		(*triggered)(struct hw_breakpoint *, struct pt_regs *);
+	void		(*installed)(struct hw_breakpoint *);
+	void		(*uninstalled)(struct hw_breakpoint *);
+	void		*address;
+	u8		len;
+	u8		type;
+	u8		priority;
+	u8		status;
+};
+
+/* HW breakpoint types */
+#define HW_BREAKPOINT_EXECUTE	0x0	/* trigger on instruction execute */
+#define HW_BREAKPOINT_WRITE	0x1	/* trigger on memory write */
+#define HW_BREAKPOINT_IO	0x2	/* trigger on I/O space access */
+#define HW_BREAKPOINT_RW	0x3	/* trigger on memory read or write */
+
+/* Standard HW breakpoint priority levels (higher value = higher priority) */
+#define HW_BREAKPOINT_PRIO_NORMAL	25
+#define HW_BREAKPOINT_PRIO_PTRACE	50
+#define HW_BREAKPOINT_PRIO_HIGH		75
+
+/* HW breakpoint status values */
+#define HW_BREAKPOINT_REGISTERED	1
+#define HW_BREAKPOINT_INSTALLED		2
+
+/*
+ * The following three routines are meant to be called only from within
+ * the ptrace or utrace subsystems.  The tsk argument will usually be a
+ * process being debugged by the current task, although it is also legal
+ * for tsk to be the current task.  In any case it must be guaranteed
+ * that tsk will not start running in user mode while its breakpoints are
+ * being modified.
+ */
+int register_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp);
+void unregister_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp);
+int modify_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp, void *address, u8 len, u8 type);
+
+/*
+ * Kernel breakpoints are not associated with any particular thread.
+ */
+int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+
+#endif	/* _I386_HW_BREAKPOINT_H */
Index: 2.6.21-rc2/arch/i386/kernel/process.c
===================================================================
--- 2.6.21-rc2.orig/arch/i386/kernel/process.c
+++ 2.6.21-rc2/arch/i386/kernel/process.c
@@ -58,6 +58,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
 #include <asm/pda.h>
+#include <asm/debugreg.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -359,9 +360,10 @@ EXPORT_SYMBOL(kernel_thread);
  */
 void exit_thread(void)
 {
+	struct task_struct *tsk = current;
+
 	/* The process may have allocated an io port bitmap... nuke it. */
 	if (unlikely(test_thread_flag(TIF_IO_BITMAP))) {
-		struct task_struct *tsk = current;
 		struct thread_struct *t = &tsk->thread;
 		int cpu = get_cpu();
 		struct tss_struct *tss = &per_cpu(init_tss, cpu);
@@ -379,15 +381,17 @@ void exit_thread(void)
 		tss->io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
+	if (unlikely(tsk->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(tsk);
 }
 
 void flush_thread(void)
 {
 	struct task_struct *tsk = current;
 
-	memset(tsk->thread.debugreg, 0, sizeof(unsigned long)*8);
-	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));	
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
+	if (unlikely(tsk->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(tsk);
 	/*
 	 * Forget coprocessor state..
 	 */
@@ -430,14 +434,21 @@ int copy_thread(int nr, unsigned long cl
 
 	savesegment(gs,p->thread.gs);
 
+	p->thread.hw_breakpoint_info = NULL;
+	p->thread.io_bitmap_ptr = NULL;
+
 	tsk = current;
+	err = -ENOMEM;
+	if (unlikely(tsk->thread.hw_breakpoint_info)) {
+		if (copy_thread_hw_breakpoint(tsk, p, clone_flags))
+			goto out;
+	}
+
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
 						IO_BITMAP_BYTES, GFP_KERNEL);
-		if (!p->thread.io_bitmap_ptr) {
-			p->thread.io_bitmap_max = 0;
-			return -ENOMEM;
-		}
+		if (!p->thread.io_bitmap_ptr)
+			goto out;
 		set_tsk_thread_flag(p, TIF_IO_BITMAP);
 	}
 
@@ -467,7 +478,8 @@ int copy_thread(int nr, unsigned long cl
 
 	err = 0;
  out:
-	if (err && p->thread.io_bitmap_ptr) {
+	if (err) {
+		flush_thread_hw_breakpoint(p);
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
@@ -479,18 +491,18 @@ int copy_thread(int nr, unsigned long cl
  */
 void dump_thread(struct pt_regs * regs, struct user * dump)
 {
-	int i;
+	struct task_struct *tsk = current;
 
 /* changed the size calculations - should hopefully work better. lbt */
 	dump->magic = CMAGIC;
 	dump->start_code = 0;
 	dump->start_stack = regs->esp & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
-	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
+	dump->u_tsize = ((unsigned long) tsk->mm->end_code) >> PAGE_SHIFT;
+	dump->u_dsize = ((unsigned long) (tsk->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
 	dump->u_dsize -= dump->u_tsize;
 	dump->u_ssize = 0;
-	for (i = 0; i < 8; i++)
-		dump->u_debugreg[i] = current->thread.debugreg[i];  
+
+	dump_thread_hw_breakpoint(tsk, dump->u_debugreg);
 
 	if (dump->start_stack < TASK_SIZE)
 		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
@@ -540,16 +552,6 @@ static noinline void __switch_to_xtra(st
 
 	next = &next_p->thread;
 
-	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
-		set_debugreg(next->debugreg[0], 0);
-		set_debugreg(next->debugreg[1], 1);
-		set_debugreg(next->debugreg[2], 2);
-		set_debugreg(next->debugreg[3], 3);
-		/* no 4 and 5 */
-		set_debugreg(next->debugreg[6], 6);
-		set_debugreg(next->debugreg[7], 7);
-	}
-
 	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
 		 * Disable the bitmap via an invalid offset. We still cache
@@ -682,7 +684,7 @@ struct task_struct fastcall * __switch_t
 		set_iopl_mask(next->iopl);
 
 	/*
-	 * Now maybe handle debug registers and/or IO bitmaps
+	 * Now maybe handle IO bitmaps
 	 */
 	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW)
 	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)))
@@ -714,6 +716,13 @@ struct task_struct fastcall * __switch_t
 
 	write_pda(pcurrent, next_p);
 
+	/*
+	 * Handle debug registers.  This must be done _after_ current
+	 * is updated.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
+
 	return prev_p;
 }
 
Index: 2.6.21-rc2/arch/i386/kernel/signal.c
===================================================================
--- 2.6.21-rc2.orig/arch/i386/kernel/signal.c
+++ 2.6.21-rc2/arch/i386/kernel/signal.c
@@ -592,13 +592,6 @@ static void fastcall do_signal(struct pt
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
-		/* Reenable any watchpoints before delivering the
-		 * signal to user space. The processor register will
-		 * have been cleared if the watchpoint triggered
-		 * inside the kernel.
-		 */
-		if (unlikely(current->thread.debugreg[7]))
-			set_debugreg(current->thread.debugreg[7], 7);
 
 		/* Whee!  Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
Index: 2.6.21-rc2/arch/i386/kernel/traps.c
===================================================================
--- 2.6.21-rc2.orig/arch/i386/kernel/traps.c
+++ 2.6.21-rc2/arch/i386/kernel/traps.c
@@ -806,62 +806,49 @@ fastcall void __kprobes do_int3(struct p
  */
 fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
 {
-	unsigned int condition;
 	struct task_struct *tsk = current;
+	struct die_args args;
 
-	get_debugreg(condition, 6);
-
-	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
-					SIGTRAP) == NOTIFY_STOP)
+	args.regs = regs;
+	args.str = "debug";
+	get_debugreg(args.err, 6);
+	set_debugreg(0, 6);	/* DR6 is never cleared by the CPU */
+	args.trapnr = error_code;
+	args.signr = SIGTRAP;
+	args.ret = 0;
+	if (atomic_notifier_call_chain(&i386die_chain, DIE_DEBUG, &args) ==
+			NOTIFY_STOP)
 		return;
+
 	/* It's safe to allow irq's after DR6 has been saved */
 	if (regs->eflags & X86_EFLAGS_IF)
 		local_irq_enable();
 
-	/* Mask out spurious debug traps due to lazy DR7 setting */
-	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
-		if (!tsk->thread.debugreg[7])
-			goto clear_dr7;
+	if (regs->eflags & VM_MASK) {
+		handle_vm86_trap((struct kernel_vm86_regs *) regs,
+				error_code, 1);
+		return;
 	}
 
-	if (regs->eflags & VM_MASK)
-		goto debug_vm86;
-
-	/* Save debug status register where ptrace can see it */
-	tsk->thread.debugreg[6] = condition;
-
 	/*
-	 * Single-stepping through TF: make sure we ignore any events in
-	 * kernel space (but re-enable TF when returning to user mode).
+	 * Single-stepping through system calls: ignore any exceptions in
+	 * kernel space, but re-enable TF when returning to user mode.
+	 *
+	 * We already checked v86 mode above, so we can check for kernel mode
+	 * by just checking the CPL of CS.
 	 */
-	if (condition & DR_STEP) {
-		/*
-		 * We already checked v86 mode above, so we can
-		 * check for kernel mode by just checking the CPL
-		 * of CS.
-		 */
-		if (!user_mode(regs))
-			goto clear_TF_reenable;
+	if ((args.err & DR_STEP) && !user_mode(regs)) {
+		args.err &= ~DR_STEP;
+		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+		regs->eflags &= ~TF_MASK;
 	}
 
-	/* Ok, finally something we can handle */
-	send_sigtrap(tsk, regs, error_code);
+	/* Store the virtualized DR6 value */
+	tsk->thread.vdr6 |= args.err;
 
-	/* Disable additional traps. They'll be re-enabled when
-	 * the signal is delivered.
-	 */
-clear_dr7:
-	set_debugreg(0, 7);
-	return;
-
-debug_vm86:
-	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
-	return;
-
-clear_TF_reenable:
-	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
-	regs->eflags &= ~TF_MASK;
-	return;
+	if ((args.err & (DR_STEP|DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) ||
+			args.ret)
+		send_sigtrap(tsk, regs, error_code);
 }
 
 /*
Index: 2.6.21-rc2/include/asm-i386/debugreg.h
===================================================================
--- 2.6.21-rc2.orig/include/asm-i386/debugreg.h
+++ 2.6.21-rc2/include/asm-i386/debugreg.h
@@ -48,6 +48,8 @@
 
 #define DR_LOCAL_ENABLE_SHIFT 0    /* Extra shift to the local enable bit */
 #define DR_GLOBAL_ENABLE_SHIFT 1   /* Extra shift to the global enable bit */
+#define DR_LOCAL_ENABLE (0x1)      /* Local enable for reg 0 */
+#define DR_GLOBAL_ENABLE (0x2)     /* Global enable for reg 0 */
 #define DR_ENABLE_SIZE 2           /* 2 enable bits per register */
 
 #define DR_LOCAL_ENABLE_MASK (0x55)  /* Set  local bits for all 4 regs */
@@ -58,7 +60,46 @@
    gdt or the ldt if we want to.  I am not sure why this is an advantage */
 
 #define DR_CONTROL_RESERVED (0xFC00) /* Reserved by Intel */
-#define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
-#define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
+#define DR_LOCAL_EXACT (0x100)       /* Local slow the pipeline */
+#define DR_GLOBAL_EXACT (0x200)      /* Global slow the pipeline */
+
+
+/*
+ * HW breakpoint additions
+ */
+
+#include <asm/hw_breakpoint.h>
+#include <linux/spinlock.h>
+
+#define HB_NUM		4	/* Number of hardware breakpoints */
+
+struct thread_hw_breakpoint {	/* HW breakpoint info for a thread */
+	spinlock_t		lock;		/* Protect thread_bps, tdr7 */
+
+	/* utrace support */
+	struct list_head	node;		/* Entry in thread list */
+	struct list_head	thread_bps;	/* Thread's breakpoints */
+	unsigned long		tdr7;		/* Thread's DR7 value */
+
+	/* ptrace support -- note that vdr6 is stored directly in the
+	 * thread_struct so that it is always available */
+	unsigned long		vdr7;			/* Virtualized DR7 */
+	struct hw_breakpoint	vdr_bps[HB_NUM];	/* Breakpoints
+			* representing virtualized debug registers 0 - 3 */
+};
+
+/* For process management */
+void flush_thread_hw_breakpoint(struct task_struct *tsk);
+int copy_thread_hw_breakpoint(struct task_struct *tsk,
+		struct task_struct *child, unsigned long clone_flags);
+void dump_thread_hw_breakpoint(struct task_struct *tsk, int u_debugreg[8]);
+void switch_to_thread_hw_breakpoint(struct task_struct *tsk);
+
+/* For CPU management */
+void load_debug_registers(void);
+
+/* For use by ptrace */
+unsigned long thread_get_debugreg(struct task_struct *tsk, int n);
+int thread_set_debugreg(struct task_struct *tsk, int n, unsigned long val);
 
 #endif
Index: 2.6.21-rc2/include/asm-i386/processor.h
===================================================================
--- 2.6.21-rc2.orig/include/asm-i386/processor.h
+++ 2.6.21-rc2/include/asm-i386/processor.h
@@ -402,8 +402,9 @@ struct thread_struct {
 	unsigned long	esp;
 	unsigned long	fs;
 	unsigned long	gs;
-/* Hardware debugging registers */
-	unsigned long	debugreg[8];  /* %%db0-7 debug registers */
+/* Hardware breakpoint info */
+	unsigned long	vdr6;
+	struct thread_hw_breakpoint	*hw_breakpoint_info;
 /* fault info */
 	unsigned long	cr2, trap_no, error_code;
 /* floating point info */
Index: 2.6.21-rc2/arch/i386/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ 2.6.21-rc2/arch/i386/kernel/hw_breakpoint.c
@@ -0,0 +1,1149 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2007 Alan Stern
+ */
+
+/*
+ * HW_breakpoint: a unified kernel/user-space hardware breakpoint facility,
+ * using the CPU's debug registers.
+ */
+
+/* QUESTIONS
+
+	Permissions for I/O user bp?
+
+	Set RF flag bit for execution faults?
+
+	TF flag bit for single-step exceptions in kernel space?
+
+	CPU hotplug, kexec, etc?
+
+*/
+
+#include <linux/init.h>
+#include <linux/irqflags.h>
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+
+#include <asm-generic/percpu.h>
+
+#include <asm/debugreg.h>
+#include <asm/kdebug.h>
+#include <asm/processor.h>
+
+
+/* Per-CPU debug register info */
+struct cpu_hw_breakpoint {
+	struct hw_breakpoint	*bps[HB_NUM];	/* Loaded breakpoints */
+	int			num_kbps;	/* Number of kernel bps */
+	struct task_struct	*bp_task;	/* The thread whose bps
+			are currently loaded in the debug registers */
+};
+
+static DEFINE_PER_CPU(struct cpu_hw_breakpoint, cpu_info);
+
+/* Kernel-space breakpoint data */
+static LIST_HEAD(kernel_bps);			/* Kernel breakpoint list */
+static unsigned long		kdr7;		/* Kernel DR7 value */
+static int			num_kbps;	/* Number of kernel bps */
+
+static u8			tprio[HB_NUM];	/* Thread bp max priorities */
+static LIST_HEAD(thread_list);			/* thread_hw_breakpoint list */
+static DEFINE_MUTEX(hw_breakpoint_mutex);	/* Protects everything */
+
+/* Masks for the bits in DR7 related to kernel breakpoints, for various
+ * values of num_kbps.  Entry n is the mask for when there are n kernel
+ * breakpoints, in debug registers 0 - (n-1). */
+static const unsigned long	kdr7_masks[HB_NUM + 1] = {
+	0x00000000,
+	0x000f0203,	/* LEN0, R/W0, GE, G0, L0 */
+	0x00ff020f,	/* Same for 0,1 */
+	0x0fff023f,	/* Same for 0,1,2 */
+	0xffff02ff	/* Same for 0,1,2,3 */
+};
+
+
+/*
+ * Install a single breakpoint in its debug register.
+ */
+static void install_breakpoint(struct cpu_hw_breakpoint *chbi, int i,
+		struct hw_breakpoint *bp)
+{
+	unsigned long temp;
+
+	chbi->bps[i] = bp;
+	temp = (unsigned long) bp->address;
+	switch (i) {
+		case 0:	set_debugreg(temp, 0);	break;
+		case 1:	set_debugreg(temp, 1);	break;
+		case 2:	set_debugreg(temp, 2);	break;
+		case 3:	set_debugreg(temp, 3);	break;
+	}
+}
+
+/*
+ * Install the debug register values for a new thread.
+ */
+void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
+{
+	unsigned long dr7;
+	struct cpu_hw_breakpoint *chbi;
+	int i = HB_NUM;
+	unsigned long flags;
+
+	/* Other CPUs might be making updates to the list of kernel
+	 * breakpoints at this same time, so we can't use the global
+	 * value stored in num_kbps.  Instead we'll use the per-cpu
+	 * value stored in cpu_info. */
+
+	/* Block kernel breakpoint updates from other CPUs */
+	local_irq_save(flags);
+	chbi = &per_cpu(cpu_info, get_cpu());
+	chbi->bp_task = tsk;
+
+	/* Keep the DR7 bits that refer to kernel breakpoints */
+	get_debugreg(dr7, 7);
+	dr7 &= kdr7_masks[chbi->num_kbps];
+
+	/* Kernel breakpoints are stored starting in DR0 and going up,
+	 * and there are num_kbps of them.  Thread breakpoints are stored
+	 * starting in DR3 and going down, as many as we have room for. */
+	if (tsk && test_tsk_thread_flag(tsk, TIF_DEBUG)) {
+		struct thread_hw_breakpoint *thbi =
+				tsk->thread.hw_breakpoint_info;
+		struct hw_breakpoint *bp;
+
+		set_debugreg(dr7, 7);	/* Disable user bps while switching */
+
+		/* Store this thread's breakpoint addresses and update
+		 * the statuses. */
+//		spin_lock(&thbi->lock);
+		list_for_each_entry(bp, &thbi->thread_bps, node) {
+
+			/* If this register is allocated for kernel bps,
+			 * don't install.  Otherwise do. */
+			if (--i < chbi->num_kbps) {
+				if (bp->status == HW_BREAKPOINT_INSTALLED) {
+					if (bp->uninstalled)
+						(bp->uninstalled)(bp);
+					bp->status = HW_BREAKPOINT_REGISTERED;
+				}
+			} else {
+				if (bp->status != HW_BREAKPOINT_INSTALLED) {
+					bp->status = HW_BREAKPOINT_INSTALLED;
+					if (bp->installed)
+						(bp->installed)(bp);
+				}
+				install_breakpoint(chbi, i, bp);
+			}
+		}
+
+		/* Mask in the parts of DR7 that refer to the new thread */
+		dr7 |= (~kdr7_masks[chbi->num_kbps] & thbi->tdr7);
+//		spin_unlock(&thbi->lock);
+	}
+
+	/* Clear any remaining stale bp pointers */
+	while (--i >= chbi->num_kbps)
+		chbi->bps[i] = NULL;
+	set_debugreg(dr7, 7);
+
+	put_cpu_no_resched();
+	local_irq_restore(flags);
+}
+
+/*
+ * Install the kernel breakpoints in their debug registers.
+ */
+static void switch_kernel_hw_breakpoint(struct cpu_hw_breakpoint *chbi)
+{
+	struct hw_breakpoint *bp;
+	int i;
+	unsigned long dr7;
+
+	/* Don't allow debug exceptions while we update the registers */
+	set_debugreg(0, 7);
+
+	/* Kernel breakpoints are stored starting in DR0 and going up */
+	i = 0;
+	list_for_each_entry(bp, &kernel_bps, node) {
+		if (i >= chbi->num_kbps)
+			break;
+		install_breakpoint(chbi, i, bp);
+		++i;
+	}
+
+	dr7 = kdr7 & kdr7_masks[chbi->num_kbps];
+	set_debugreg(dr7, 7);
+}
+
+/*
+ * Update the debug registers on this CPU.
+ */
+static void update_this_cpu(void *unused)
+{
+	struct cpu_hw_breakpoint *chbi;
+
+	chbi = &per_cpu(cpu_info, get_cpu());
+	chbi->num_kbps = num_kbps;
+
+	/* Install both the kernel and the user breakpoints */
+	switch_kernel_hw_breakpoint(chbi);
+	switch_to_thread_hw_breakpoint(chbi->bp_task);
+
+	put_cpu_no_resched();
+}
+
+/*
+ * Tell all CPUs to update their debug registers.
+ *
+ * The caller must hold hw_breakpoint_mutex.
+ */
+static void update_all_cpus(void)
+{
+	on_each_cpu(update_this_cpu, NULL, 0, 0);
+}
+
+/*
+ * Load the debug registers during startup of a CPU.
+ */
+void load_debug_registers(void)
+{
+	update_this_cpu(NULL);
+}
+
+/*
+ * Take the 4 highest-priority breakpoints in a thread and accumulate
+ * their priorities in tprio.
+ */
+static void accum_thread_tprio(struct thread_hw_breakpoint *thbi)
+{
+	int i;
+	struct hw_breakpoint *bp;
+
+	i = 0;
+	list_for_each_entry(bp, &thbi->thread_bps, node) {
+		tprio[i] = max(tprio[i], bp->priority);
+		if (++i >= HB_NUM)
+			break;
+	}
+}
+
+/*
+ * Recalculate the value of the tprio array, the maximum priority levels
+ * requested by user breakpoints in all threads.
+ *
+ * Each thread has a list of registered breakpoints, kept in order of
+ * decreasing priority.  We'll set tprio[0] to the maximum priority of
+ * the first entries in all the lists, tprio[1] to the maximum priority
+ * of the second entries in all the lists, etc.  In the end, we'll know
+ * that no thread requires breakpoints with priorities higher than the
+ * values in tprio.
+ *
+ * The caller must hold hw_breakpoint_mutex.
+ */
+static void recalc_tprio(void)
+{
+	struct thread_hw_breakpoint *thbi;
+
+	memset(tprio, 0, sizeof tprio);
+
+	/* Loop through all threads having registered breakpoints
+	 * and accumulate the maximum priority levels in tprio. */
+	list_for_each_entry(thbi, &thread_list, node)
+		accum_thread_tprio(thbi);
+}
+
+/*
+ * Decide how many debug registers will be allocated to kernel breakpoints
+ * and consequently, how many remain available for user breakpoints.
+ *
+ * The priorities of the entries in the list of registered kernel bps
+ * are compared against the priorities stored in tprio[].  The 4 highest
+ * winners overall get to be installed in a debug register; num_kpbs
+ * keeps track of how many of those winners come from the kernel list.
+ *
+ * If num_kbps changes, or if a kernel bp changes its installation status,
+ * then call update_all_cpus() so that the debug registers will be set
+ * correctly on every CPU.  If neither condition holds then the set of
+ * kernel bps hasn't changed, and nothing more needs to be done.
+ *
+ * The caller must hold hw_breakpoint_mutex.
+ */
+static void balance_kernel_vs_user(void)
+{
+	int i;
+	struct hw_breakpoint *bp;
+	int new_num_kbps;
+	int changed = 0;
+
+	/* Determine how many debug registers are available for kernel
+	 * breakpoints as opposed to user breakpoints, based on the
+	 * priorities.  Ties are resolved in favor of user bps. */
+	new_num_kbps = i = 0;
+	bp = list_entry(kernel_bps.next, struct hw_breakpoint, node);
+	while (i + new_num_kbps < HB_NUM) {
+		if (&bp->node == &kernel_bps || tprio[i] >= bp->priority)
+			++i;		/* User bps win a slot */
+		else {
+			++new_num_kbps;	/* Kernel bp wins a slot */
+			if (bp->status != HW_BREAKPOINT_INSTALLED)
+				changed = 1;
+			bp = list_entry(bp->node.next, struct hw_breakpoint,
+					node);
+		}
+	}
+	if (new_num_kbps != num_kbps) {
+		changed = 1;
+		num_kbps = new_num_kbps;
+	}
+
+	/* Notify the remaining kernel breakpoints that they are about
+	 * to be uninstalled. */
+	list_for_each_entry_from(bp, &kernel_bps, node) {
+		if (bp->status == HW_BREAKPOINT_INSTALLED) {
+			if (bp->uninstalled)
+				(bp->uninstalled)(bp);
+			bp->status = HW_BREAKPOINT_REGISTERED;
+			changed = 1;
+		}
+	}
+
+	if (changed) {
+
+		/* Tell all the CPUs to update their debug registers */
+		update_all_cpus();
+
+		/* Notify the breakpoints that just got installed */
+		i = 0;
+		list_for_each_entry(bp, &kernel_bps, node) {
+			if (i++ >= num_kbps)
+				break;
+			if (bp->status != HW_BREAKPOINT_INSTALLED) {
+				bp->status = HW_BREAKPOINT_INSTALLED;
+				if (bp->installed)
+					(bp->installed)(bp);
+			}
+		}
+	}
+}
+
+/*
+ * Return the pointer to a thread's hw_breakpoint info area,
+ * and try to allocate one if it doesn't exist.
+ *
+ * The caller must hold hw_breakpoint_mutex.
+ */
+static struct thread_hw_breakpoint *alloc_thread_hw_breakpoint(
+		struct task_struct *tsk)
+{
+	if (!tsk->thread.hw_breakpoint_info && !(tsk->flags & PF_EXITING)) {
+		struct thread_hw_breakpoint *thbi;
+
+		thbi = kzalloc(sizeof(struct thread_hw_breakpoint),
+				GFP_KERNEL);
+		if (thbi) {
+//			spin_lock_init(&thbi->lock);
+			INIT_LIST_HEAD(&thbi->node);
+			INIT_LIST_HEAD(&thbi->thread_bps);
+			tsk->thread.hw_breakpoint_info = thbi;
+		}
+	}
+	return tsk->thread.hw_breakpoint_info;
+}
+
+/*
+ * Erase all the hardware breakpoint info associated with a thread.
+ *
+ * If tsk != current then tsk must not be usable (for example, a
+ * child being cleaned up from a failed fork).
+ */
+void flush_thread_hw_breakpoint(struct task_struct *tsk)
+{
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+	struct hw_breakpoint *bp;
+
+	if (!thbi)
+		return;
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* Let the breakpoints know they are being uninstalled */
+	list_for_each_entry(bp, &thbi->thread_bps, node) {
+		if (bp->status == HW_BREAKPOINT_INSTALLED && bp->uninstalled)
+			(bp->uninstalled)(bp);
+		bp->status = 0;
+	}
+
+	/* Remove tsk from the list of all threads with registered bps */
+	list_del(&thbi->node);
+
+	/* The thread no longer has any breakpoints associated with it */
+	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	tsk->thread.hw_breakpoint_info = NULL;
+	kfree(thbi);
+
+	/* Recalculate and rebalance the kernel-vs-user priorities */
+	recalc_tprio();
+	balance_kernel_vs_user();
+
+	/* Actually uninstall the breakpoints if necessary, and don't keep
+	 * a pointer to a task which may be about to exit. */
+	if (tsk == current)
+		switch_to_thread_hw_breakpoint(NULL);
+	mutex_unlock(&hw_breakpoint_mutex);
+}
+
+/*
+ * Copy the hardware breakpoint info from a thread to its cloned child.
+ */
+int copy_thread_hw_breakpoint(struct task_struct *tsk,
+		struct task_struct *child, unsigned long clone_flags)
+{
+	/* We will assume that breakpoint settings are not inherited
+	 * and the child starts out with no debug registers set.
+	 * But what about CLONE_PTRACE? */
+
+	clear_tsk_thread_flag(child, TIF_DEBUG);
+	return 0;
+}
+
+/*
+ * Copy out the debug register information for a core dump.
+ *
+ * tsk must be equal to current.
+ */
+void dump_thread_hw_breakpoint(struct task_struct *tsk, int u_debugreg[8])
+{
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+	int i;
+
+	memset(u_debugreg, 0, sizeof u_debugreg);
+	if (thbi) {
+		for (i = 0; i < HB_NUM; ++i)
+			u_debugreg[i] = (unsigned long)
+					thbi->vdr_bps[i].address;
+		u_debugreg[7] = thbi->vdr7;
+	}
+	u_debugreg[6] = tsk->thread.vdr6;
+}
+
+/*
+ * Validate the settings in a hw_breakpoint structure.
+ */
+static int validate_settings(struct hw_breakpoint *bp, struct task_struct *tsk)
+{
+	int rc = -EINVAL;
+
+	switch (bp->len) {
+	case 1:  case 2:  case 4:	/* 8 is also valid for x86_64 */
+		break;
+	default:
+		return rc;
+	}
+
+	switch (bp->type) {
+	case HW_BREAKPOINT_WRITE:
+	case HW_BREAKPOINT_RW:
+		break;
+	case HW_BREAKPOINT_IO:
+		if (!cpu_has_de)
+			return rc;
+		break;
+	case HW_BREAKPOINT_EXECUTE:
+		if (bp->len == 1)
+			break;
+		/* FALL THROUGH */
+	default:
+		return rc;
+	}
+
+	/* Check that the address is in the proper range.  Note that tsk
+	 * is NULL for kernel bps and non-NULL for user bps. */
+	if (bp->type == HW_BREAKPOINT_IO) {
+#if 0
+		/* Check whether the task has permission to access the
+		 * I/O port at bp->address. */
+		if (tsk) {
+			/* WRITEME */
+			return -EPERM;
+		}
+#else
+		return -ENOSYS;	/* Not implemented, requires setting CR4.DE */
+#endif
+	} else {
+
+		/* Check whether bp->address points to user space.
+		 * With x86_64, use TASK_SIZE_OF(tsk) instead of TASK_SIZE. */
+		if ((tsk != NULL) != ((unsigned long) bp->address < TASK_SIZE))
+			return rc;
+	}
+
+	if (bp->triggered)
+		rc = 0;
+	return rc;
+}
+
+/*
+ * Encode the length, type, Exact, and Enable bits for a particular breakpoint
+ * as stored in debug register 7.
+ */
+static inline unsigned long encode_dr7(int drnum, u8 len, u8 type, int local)
+{
+	unsigned long temp;
+
+	/* For x86_64:
+	 *
+	 * if (len == 8)
+	 *	len = 3;
+	 */
+	temp = ((len - 1) << 2) | type;
+	temp <<= (DR_CONTROL_SHIFT + drnum * DR_CONTROL_SIZE);
+	if (local)
+		temp |= (DR_LOCAL_ENABLE << (drnum * DR_ENABLE_SIZE)) |
+				DR_LOCAL_EXACT;
+	else
+		temp |= (DR_GLOBAL_ENABLE << (drnum * DR_ENABLE_SIZE)) |
+				DR_GLOBAL_EXACT;
+	return temp;
+}
+
+/*
+ * Calculate the DR7 value for the list of kernel or user breakpoints.
+ */
+static unsigned long calculate_dr7(struct list_head *bp_list, int is_user)
+{
+	struct hw_breakpoint *bp;
+	int i;
+	int drnum;
+	unsigned long dr7;
+
+	/* Kernel bps are assigned from DR0 on up, and user bps are assigned
+	 * from DR3 on down.  Accumulate all 4 bps; the kernel DR7 mask will
+	 * select the appropriate bits later. */
+	dr7 = 0;
+	i = 0;
+	list_for_each_entry(bp, bp_list, node) {
+
+		/* Get the debug register number and accumulate the bits */
+		drnum = (is_user ? HB_NUM - 1 - i : i);
+		dr7 |= encode_dr7(drnum, bp->len, bp->type, is_user);
+		if (++i >= HB_NUM)
+			break;
+	}
+	return dr7;
+}
+
+/*
+ * Update the DR7 value for a user thread.
+ */
+static void update_user_dr7(struct thread_hw_breakpoint *thbi)
+{
+	thbi->tdr7 = calculate_dr7(&thbi->thread_bps, 1);
+}
+
+/*
+ * Insert a new breakpoint in a priority-sorted list.
+ * Return the bp's index in the list.
+ *
+ * Thread invariants:
+ *	tsk_thread_flag(tsk, TIF_DEBUG) set implies
+ *		tsk->thread.hw_breakpoint_info is not NULL.
+ *	tsk_thread_flag(tsk, TIF_DEBUG) set iff thbi->thread_bps is non-empty
+ *		iff thbi->node is on thread_list.
+ *
+ * The caller must hold thbi->lock.
+ */
+static int insert_bp_in_list(struct hw_breakpoint *bp,
+		struct thread_hw_breakpoint *thbi, struct task_struct *tsk)
+{
+	struct list_head *head;
+	int pos;
+	struct hw_breakpoint *temp_bp;
+
+	/* tsk and thbi are NULL for kernel bps, non-NULL for user bps */
+	if (tsk) {
+		head = &thbi->thread_bps;
+
+		/* Is this the thread's first registered breakpoint? */
+		if (list_empty(head)) {
+			set_tsk_thread_flag(tsk, TIF_DEBUG);
+			list_add(&thbi->node, &thread_list);
+		}
+	} else
+		head = &kernel_bps;
+
+	/* Equal-priority breakpoints get listed first-come-first-served */
+	pos = 0;
+	list_for_each_entry(temp_bp, head, node) {
+		if (bp->priority > temp_bp->priority)
+			break;
+		++pos;
+	}
+	list_add_tail(&bp->node, &temp_bp->node);
+
+	bp->status = HW_BREAKPOINT_REGISTERED;
+	return pos;
+}
+
+/*
+ * Remove a breakpoint from its priority-sorted list.
+ *
+ * See the invariants mentioned above.
+ *
+ * The caller must hold thbi->lock.
+ */
+static void remove_bp_from_list(struct hw_breakpoint *bp, struct thread_hw_breakpoint *thbi,
+		struct task_struct *tsk)
+{
+	/* Remove bp from the thread's/kernel's list.  If the list is now
+	 * empty we must clear the TIF_DEBUG flag.  But keep the thread_hw_breakpoint
+	 * structure, so that the virtualized debug register values will
+	 * remain valid. */
+	list_del(&bp->node);
+	if (tsk) {
+		if (list_empty(&thbi->thread_bps)) {
+			list_del_init(&thbi->node);
+			clear_tsk_thread_flag(tsk, TIF_DEBUG);
+		}
+	}
+
+	/* Tell the breakpoint it is being uninstalled */
+	if (bp->status == HW_BREAKPOINT_INSTALLED && bp->uninstalled)
+		(bp->uninstalled)(bp);
+	bp->status = 0;
+}
+
+/*
+ * Actual implementation of register_user_hw_breakpoint.
+ */
+static int __register_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp)
+{
+	int rc;
+	struct thread_hw_breakpoint *thbi;
+	int pos;
+//	unsigned long flags;
+
+	bp->status = 0;
+	rc = validate_settings(bp, tsk);
+	if (rc)
+		return rc;
+
+	thbi = alloc_thread_hw_breakpoint(tsk);
+	if (!thbi)
+		return -ENOMEM;
+
+	/* Insert bp in the thread's list and update the DR7 value */
+//	spin_lock_irqsave(&thbi->lock, flags);
+	pos = insert_bp_in_list(bp, thbi, tsk);
+	update_user_dr7(thbi);
+//	spin_unlock_irqrestore(&thbi->lock, flags);
+
+	/* Update and rebalance the priorities.  We don't need to go through
+	 * the list of all threads; adding a breakpoint can only cause the
+	 * priorities for this thread to increase. */
+	accum_thread_tprio(thbi);
+	balance_kernel_vs_user();
+
+	/* Did bp get allocated to a debug register?  We can tell from its
+	 * position in the list.  The number of registers allocated to
+	 * kernel breakpoints is num_kbps; all the others are available for
+	 * user breakpoints.  If bp's position in the priority-ordered list
+	 * is low enough, it will get a register. */
+	if (pos < HB_NUM - num_kbps) {
+		rc = 1;
+
+		/* Does it need to be installed right now? */
+		if (tsk == current)
+			switch_to_thread_hw_breakpoint(tsk);
+		/* Otherwise it will get installed the next time tsk runs */
+	}
+	return rc;
+}
+
+/**
+ * register_user_hw_breakpoint - register a hardware breakpoint for user space
+ * @tsk: the task in whose memory space the breakpoint will be set
+ * @bp: the breakpoint structure to register
+ *
+ * This routine registers a breakpoint to be associated with @tsk's
+ * memory space and active only while @tsk is running.  It does not
+ * guarantee that the breakpoint will be allocated to a debug register
+ * immediately; there may be other higher-priority breakpoints registered
+ * which require the use of all the debug registers.
+ *
+ * @tsk will normally be a process being debugged by the current process,
+ * but it may also be the current process.
+ *
+ * The fields in @bp are checked for validity.  @bp->len, @bp->type,
+ * @bp->address, @bp->triggered, and @bp->priority must be set properly.
+ *
+ * Returns 1 if @bp is allocated to a debug register, 0 if @bp is
+ * registered but not allowed to be installed, otherwise a negative error
+ * code.
+ */
+int register_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp)
+{
+	int rc;
+
+	mutex_lock(&hw_breakpoint_mutex);
+	rc = __register_user_hw_breakpoint(tsk, bp);
+	mutex_unlock(&hw_breakpoint_mutex);
+	return rc;
+}
+
+/*
+ * Actual implementation of unregister_user_hw_breakpoint.
+ */
+static void __unregister_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp)
+{
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+//	unsigned long flags;
+
+	if (!bp->status)
+		return;		/* Not registered */
+
+	/* Remove bp from the thread's list and update the DR7 value */
+//	spin_lock_irqsave(&thbi->lock, flags);
+	remove_bp_from_list(bp, thbi, tsk);
+	update_user_dr7(thbi);
+//	spin_unlock_irqrestore(&thbi->lock, flags);
+
+	/* Recalculate and rebalance the kernel-vs-user priorities,
+	 * and actually uninstall bp if necessary. */
+	recalc_tprio();
+	balance_kernel_vs_user();
+	if (tsk == current)
+		switch_to_thread_hw_breakpoint(tsk);
+}
+
+/**
+ * unregister_user_hw_breakpoint - unregister a hardware breakpoint for user space
+ * @tsk: the task in whose memory space the breakpoint is registered
+ * @bp: the breakpoint structure to unregister
+ *
+ * Uninstalls and unregisters @bp.
+ */
+void unregister_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp)
+{
+	mutex_lock(&hw_breakpoint_mutex);
+	__unregister_user_hw_breakpoint(tsk, bp);
+	mutex_unlock(&hw_breakpoint_mutex);
+}
+
+/*
+ * Actual implementation of modify_user_hw_breakpoint.
+ */
+static int __modify_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp, void *address, u8 len, u8 type)
+{
+	unsigned long flags;
+
+	if (!bp->status) {	/* Not registered, just store the values */
+		bp->address = address;
+		bp->len = len;
+		bp->type = type;
+		return 0;
+	}
+
+	/* Check the new values */
+	{
+		struct hw_breakpoint temp_bp = *bp;
+		int rc;
+
+		temp_bp.address = address;
+		temp_bp.len = len;
+		temp_bp.type = type;
+		rc = validate_settings(&temp_bp, tsk);
+		if (rc)
+			return rc;
+	}
+
+	/* Okay, update the breakpoint.  An interrupt at this point might
+	 * cause I/O to a breakpointed port, so disable interrupts. */
+	local_irq_save(flags);
+	bp->address = address;
+	bp->len = len;
+	bp->type = type;
+	update_user_dr7(tsk->thread.hw_breakpoint_info);
+
+	/* The priority hasn't changed so we don't need to rebalance
+	 * anything.  Just install the new breakpoint, if necessary. */
+	if (tsk == current)
+		switch_to_thread_hw_breakpoint(tsk);
+	local_irq_restore(flags);
+	return 0;
+}
+
+/**
+ * modify_user_hw_breakpoint - modify a hardware breakpoint for user space
+ * @tsk: the task in whose memory space the breakpoint is registered
+ * @bp: the breakpoint structure to modify
+ * @address: the new value for @bp->address
+ * @len: the new value for @bp->len
+ * @type: the new value for @bp->type
+ *
+ * @bp need not currently be registered.  If it isn't, the new values
+ * are simply stored in it and @tsk is ignored.  Otherwise the new values
+ * are validated first and then stored.  If @tsk is the current process
+ * and @bp is installed in a debug register, the register is updated.
+ *
+ * Returns 0 if the new values are acceptable, otherwise a negative error
+ * number.
+ */
+int modify_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp, void *address, u8 len, u8 type)
+{
+	int rc;
+
+	mutex_lock(&hw_breakpoint_mutex);
+	rc = __modify_user_hw_breakpoint(tsk, bp, address, len, type);
+	mutex_unlock(&hw_breakpoint_mutex);
+	return rc;
+}
+
+/*
+ * Update the DR7 value for the kernel.
+ */
+static void update_kernel_dr7(void)
+{
+	kdr7 = calculate_dr7(&kernel_bps, 0);
+}
+
+/**
+ * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
+ * @bp: the breakpoint structure to register
+ *
+ * This routine registers a breakpoint to be active at all times.  It
+ * does not guarantee that the breakpoint will be allocated to a debug
+ * register immediately; there may be other higher-priority breakpoints
+ * registered which require the use of all the debug registers.
+ *
+ * The fields in @bp are checked for validity.  @bp->len, @bp->type,
+ * @bp->address, @bp->triggered, and @bp->priority must be set properly.
+ *
+ * Returns 1 if @bp is allocated to a debug register, 0 if @bp is
+ * registered but not allowed to be installed, otherwise a negative error
+ * code.
+ */
+int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+{
+	int rc;
+	int pos;
+
+	bp->status = 0;
+	rc = validate_settings(bp, NULL);
+	if (rc)
+		return rc;
+
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* Insert bp in the kernel's list and update the DR7 value */
+	pos = insert_bp_in_list(bp, NULL, NULL);
+	update_kernel_dr7();
+
+	/* Rebalance the priorities.  This will install bp if it
+	 * was allocated a debug register. */
+	balance_kernel_vs_user();
+
+	/* Did bp get allocated to a debug register?  We can tell from its
+	 * position in the list.  The number of registers allocated to
+	 * kernel breakpoints is num_kbps; all the others are available for
+	 * user breakpoints.  If bp's position in the priority-ordered list
+	 * is low enough, it will get a register. */
+	if (pos < num_kbps)
+		rc = 1;
+
+	mutex_unlock(&hw_breakpoint_mutex);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(register_kernel_hw_breakpoint);
+
+/**
+ * unregister_kernel_hw_breakpoint - unregister a hardware breakpoint for kernel space
+ * @bp: the breakpoint structure to unregister
+ *
+ * Uninstalls and unregisters @bp.
+ */
+void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+{
+	if (!bp->status)
+		return;		/* Not registered */
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* Remove bp from the kernel's list and update the DR7 value */
+	remove_bp_from_list(bp, NULL, NULL);
+	update_kernel_dr7();
+
+	/* Rebalance the priorities.  This will uninstall bp if it
+	 * was allocated a debug register. */
+	balance_kernel_vs_user();
+
+	mutex_unlock(&hw_breakpoint_mutex);
+}
+EXPORT_SYMBOL_GPL(unregister_kernel_hw_breakpoint);
+
+/*
+ * Ptrace support: breakpoint trigger routine.
+ */
+static void ptrace_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
+{
+	struct task_struct *tsk = current;
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+	int i;
+
+	/* Store in the virtual DR6 register the fact that breakpoint i
+	 * was hit, so the thread's debugger will see it. */
+	if (thbi) {
+		i = bp - thbi->vdr_bps;
+		tsk->thread.vdr6 |= (DR_TRAP0 << i);
+	}
+}
+
+/*
+ * Handle PTRACE_PEEKUSR calls for the debug register area.
+ */
+unsigned long thread_get_debugreg(struct task_struct *tsk, int n)
+{
+	struct thread_hw_breakpoint *thbi;
+	unsigned long val = 0;
+
+	mutex_lock(&hw_breakpoint_mutex);
+	thbi = tsk->thread.hw_breakpoint_info;
+	if (n < HB_NUM) {
+		if (thbi)
+			val = (unsigned long) thbi->vdr_bps[n].address;
+	} else if (n == 6)
+		val = tsk->thread.vdr6;
+	else if (n == 7) {
+		if (thbi)
+			val = thbi->vdr7;
+	}
+	mutex_unlock(&hw_breakpoint_mutex);
+	return val;
+}
+
+/*
+ * Decode the length and type bits for a particular breakpoint as
+ * stored in debug register 7.  Return the "enabled" status.
+ */
+static inline int decode_dr7(unsigned long dr7, int bpnum, u8 *len, u8 *type)
+{
+	int temp = dr7 >> (DR_CONTROL_SHIFT + bpnum * DR_CONTROL_SIZE);
+	int tlen = 1 + ((temp >> 2) & 0x3);
+
+	/* For x86_64:
+	 *
+	 * if (tlen == 3)
+	 *	tlen = 8;
+	 */
+	*len = tlen;
+	*type = temp & 0x3;
+	return (dr7 >> (bpnum * DR_ENABLE_SIZE)) & 0x3;
+}
+
+/*
+ * Handle ptrace writes to debug register 7.
+ */
+static int ptrace_write_dr7(struct task_struct *tsk,
+		struct thread_hw_breakpoint *thbi, unsigned long data)
+{
+	struct hw_breakpoint *bp;
+	int i;
+	int rc = 0;
+	unsigned long old_dr7 = thbi->vdr7;
+
+	data &= ~DR_CONTROL_RESERVED;
+
+	/* Loop through all the hardware breakpoints,
+	 * making the appropriate changes to each. */
+restore_settings:
+	thbi->vdr7 = data;
+	bp = &thbi->vdr_bps[0];
+	for (i = 0; i < HB_NUM; (++i, ++bp)) {
+		int enabled;
+		u8 len, type;
+
+		enabled = decode_dr7(data, i, &len, &type);
+
+		/* Unregister the breakpoint if it should now be disabled.
+		 * Do this first so that setting invalid values for len
+		 * or type won't cause an error. */
+		if (!enabled && bp->status)
+			__unregister_user_hw_breakpoint(tsk, bp);
+
+		/* Insert the breakpoint's settings.  If the bp is enabled,
+		 * an invalid entry will cause an error. */
+		if (__modify_user_hw_breakpoint(tsk, bp,
+				bp->address, len, type) < 0 && rc == 0)
+			break;
+
+		/* Now register the breakpoint if it should be enabled.
+		 * New invalid entries will cause an error here. */
+		if (enabled && !bp->status) {
+			bp->triggered = ptrace_triggered;
+			bp->priority = HW_BREAKPOINT_PRIO_PTRACE;
+			if (__register_user_hw_breakpoint(tsk, bp) < 0 &&
+					rc == 0)
+				break;
+		}
+	}
+
+	/* If anything above failed, restore the original settings */
+	if (i < HB_NUM) {
+		rc = -EIO;
+		data = old_dr7;
+		goto restore_settings;
+	}
+	return rc;
+}
+
+/*
+ * Handle PTRACE_POKEUSR calls for the debug register area.
+ */
+int thread_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
+{
+	struct thread_hw_breakpoint *thbi;
+	int rc = -EIO;
+
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* There are no DR4 or DR5 registers */
+	if (n == 4 || n == 5)
+		;
+
+	/* Writes to DR6 modify the virtualized value */
+	else if (n == 6) {
+		tsk->thread.vdr6 = val;
+		rc = 0;
+	}
+
+	else if (!tsk->thread.hw_breakpoint_info && val == 0)
+		rc = 0;		/* Minor optimization */
+
+	else if ((thbi = alloc_thread_hw_breakpoint(tsk)) == NULL)
+		rc = -ENOMEM;
+
+	/* Writes to DR0 - DR3 change a breakpoint address */
+	else if (n < HB_NUM) {
+		struct hw_breakpoint *bp = &thbi->vdr_bps[n];
+
+		if (__modify_user_hw_breakpoint(tsk, bp, (void *) val,
+				bp->len, bp->type) >= 0)
+			rc = 0;
+	}
+
+	/* All that's left is DR7 */
+	else
+		rc = ptrace_write_dr7(tsk, thbi, val);
+
+	mutex_unlock(&hw_breakpoint_mutex);
+	return rc;
+}
+
+/*
+ * Handle debug exception notifications.
+ */
+static int __kprobes hw_breakpoint_handler(struct die_args *data)
+{
+	unsigned long dr6, dr7;
+	struct cpu_hw_breakpoint *chbi;
+	int i;
+	struct hw_breakpoint *bp;
+
+	dr6 = data->err;
+	if ((dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) == 0)
+		return NOTIFY_DONE;
+
+	/* Assert that local interrupts are disabled */
+
+	/* Disable all breakpoints so that the callbacks can run without
+	 * triggering recursive debug exceptions. */
+	get_debugreg(dr7, 7);
+	set_debugreg(0, 7);
+
+	/* Are we a victim of lazy debug-register switching? */
+	chbi = &per_cpu(cpu_info, get_cpu());
+	if (chbi->bp_task != current && chbi->bp_task != NULL) {
+
+		/* No user breakpoints are valid.  Clear those bits in
+		 * dr6 and perform the belated debug-register switch. */
+		chbi->bp_task = NULL;
+		dr7 &= kdr7_masks[chbi->num_kbps];
+		for (i = chbi->num_kbps; i < HB_NUM; ++i) {
+			dr6 &= ~(DR_TRAP0 << i);
+			chbi->bps[i] = NULL;
+		}
+	}
+
+	/* Handle all the breakpoints that were triggered */
+	for (i = 0; i < HB_NUM; ++i) {
+		if (!(dr6 & (DR_TRAP0 << i)))
+			continue;
+
+		/* If this was a user breakpoint, tell do_debug() to send
+		 * a SIGTRAP. */
+		if (i >= chbi->num_kbps)
+			data->ret = 1;
+
+		/* Invoke the triggered callback */
+		bp = chbi->bps[i];
+		if (bp)		/* Should always be non-NULL */
+			(bp->triggered)(bp, data->regs);
+	}
+	put_cpu_no_resched();
+
+	/* Re-enable the breakpoints */
+	set_debugreg(dr7, 7);
+
+	/* Mask out the bits we have handled from the DR6 value */
+	data->err &= ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);
+
+	/* Early exit from the notifier chain if everything has been handled */
+	if (data->err == 0)
+		return NOTIFY_STOP;
+	return NOTIFY_DONE;
+}
+
+/*
+ * Handle debug exception notifications.
+ */
+static int __kprobes hw_breakpoint_exceptions_notify(
+		struct notifier_block *unused, unsigned long val, void *data)
+{
+	if (val != DIE_DEBUG)
+		return NOTIFY_DONE;
+	return hw_breakpoint_handler(data);
+}
+
+static struct notifier_block hw_breakpoint_exceptions_nb = {
+	.notifier_call = hw_breakpoint_exceptions_notify
+};
+
+static int __init init_hw_breakpoint(void)
+{
+	return register_die_notifier(&hw_breakpoint_exceptions_nb);
+}
+
+core_initcall(init_hw_breakpoint);
Index: 2.6.21-rc2/arch/i386/kernel/ptrace.c
===================================================================
--- 2.6.21-rc2.orig/arch/i386/kernel/ptrace.c
+++ 2.6.21-rc2/arch/i386/kernel/ptrace.c
@@ -383,11 +383,11 @@ long arch_ptrace(struct task_struct *chi
 		tmp = 0;  /* Default return condition */
 		if(addr < FRAME_SIZE*sizeof(long))
 			tmp = getreg(child, addr);
-		if(addr >= (long) &dummy->u_debugreg[0] &&
-		   addr <= (long) &dummy->u_debugreg[7]){
+		else if (addr >= (long) &dummy->u_debugreg[0] &&
+				addr <= (long) &dummy->u_debugreg[7]) {
 			addr -= (long) &dummy->u_debugreg[0];
 			addr = addr >> 2;
-			tmp = child->thread.debugreg[addr];
+			tmp = thread_get_debugreg(child, addr);
 		}
 		ret = put_user(tmp, datap);
 		break;
@@ -417,59 +417,11 @@ long arch_ptrace(struct task_struct *chi
 		   have to be selective about what portions we allow someone
 		   to modify. */
 
-		  ret = -EIO;
-		  if(addr >= (long) &dummy->u_debugreg[0] &&
-		     addr <= (long) &dummy->u_debugreg[7]){
-
-			  if(addr == (long) &dummy->u_debugreg[4]) break;
-			  if(addr == (long) &dummy->u_debugreg[5]) break;
-			  if(addr < (long) &dummy->u_debugreg[4] &&
-			     ((unsigned long) data) >= TASK_SIZE-3) break;
-			  
-			  /* Sanity-check data. Take one half-byte at once with
-			   * check = (val >> (16 + 4*i)) & 0xf. It contains the
-			   * R/Wi and LENi bits; bits 0 and 1 are R/Wi, and bits
-			   * 2 and 3 are LENi. Given a list of invalid values,
-			   * we do mask |= 1 << invalid_value, so that
-			   * (mask >> check) & 1 is a correct test for invalid
-			   * values.
-			   *
-			   * R/Wi contains the type of the breakpoint /
-			   * watchpoint, LENi contains the length of the watched
-			   * data in the watchpoint case.
-			   *
-			   * The invalid values are:
-			   * - LENi == 0x10 (undefined), so mask |= 0x0f00.
-			   * - R/Wi == 0x10 (break on I/O reads or writes), so
-			   *   mask |= 0x4444.
-			   * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
-			   *   0x1110.
-			   *
-			   * Finally, mask = 0x0f00 | 0x4444 | 0x1110 == 0x5f54.
-			   *
-			   * See the Intel Manual "System Programming Guide",
-			   * 15.2.4
-			   *
-			   * Note that LENi == 0x10 is defined on x86_64 in long
-			   * mode (i.e. even for 32-bit userspace software, but
-			   * 64-bit kernel), so the x86_64 mask value is 0x5454.
-			   * See the AMD manual no. 24593 (AMD64 System
-			   * Programming)*/
-
-			  if(addr == (long) &dummy->u_debugreg[7]) {
-				  data &= ~DR_CONTROL_RESERVED;
-				  for(i=0; i<4; i++)
-					  if ((0x5f54 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
-						  goto out_tsk;
-				  if (data)
-					  set_tsk_thread_flag(child, TIF_DEBUG);
-				  else
-					  clear_tsk_thread_flag(child, TIF_DEBUG);
-			  }
-			  addr -= (long) &dummy->u_debugreg;
-			  addr = addr >> 2;
-			  child->thread.debugreg[addr] = data;
-			  ret = 0;
+		if (addr >= (long) &dummy->u_debugreg[0] &&
+				addr <= (long) &dummy->u_debugreg[7]) {
+			addr -= (long) &dummy->u_debugreg;
+			addr = addr >> 2;
+			ret = thread_set_debugreg(child, addr, data);
 		  }
 		  break;
 
@@ -625,7 +577,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = ptrace_request(child, request, addr, data);
 		break;
 	}
- out_tsk:
 	return ret;
 }
 
Index: 2.6.21-rc2/arch/i386/kernel/Makefile
===================================================================
--- 2.6.21-rc2.orig/arch/i386/kernel/Makefile
+++ 2.6.21-rc2/arch/i386/kernel/Makefile
@@ -7,7 +7,8 @@ extra-y := head.o init_task.o vmlinux.ld
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_i386.o \
 		pci-dma.o i386_ksyms.o i387.o bootflag.o e820.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o
+		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o \
+		hw_breakpoint.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
Index: 2.6.21-rc2/arch/i386/power/cpu.c
===================================================================
--- 2.6.21-rc2.orig/arch/i386/power/cpu.c
+++ 2.6.21-rc2/arch/i386/power/cpu.c
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/debugreg.h>
 
 static struct saved_context saved_context;
 
@@ -45,6 +46,11 @@ void __save_processor_state(struct saved
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4();
+
+	/*
+	 * disable the debug registers
+	 */
+	set_debugreg(0, 7);
 }
 
 void save_processor_state(void)
@@ -69,20 +75,7 @@ static void fix_processor_context(void)
 
 	load_TR_desc();				/* This does ltr */
 	load_LDT(&current->active_mm->context);	/* This does lldt */
-
-	/*
-	 * Now maybe reload the debug registers
-	 */
-	if (current->thread.debugreg[7]){
-		set_debugreg(current->thread.debugreg[0], 0);
-		set_debugreg(current->thread.debugreg[1], 1);
-		set_debugreg(current->thread.debugreg[2], 2);
-		set_debugreg(current->thread.debugreg[3], 3);
-		/* no 4 and 5 */
-		set_debugreg(current->thread.debugreg[6], 6);
-		set_debugreg(current->thread.debugreg[7], 7);
-	}
-
+	load_debug_registers();
 }
 
 void __restore_processor_state(struct saved_context *ctxt)
Index: 2.6.21-rc2/arch/i386/kernel/kprobes.c
===================================================================
--- 2.6.21-rc2.orig/arch/i386/kernel/kprobes.c
+++ 2.6.21-rc2/arch/i386/kernel/kprobes.c
@@ -670,8 +670,11 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
+		if ((args->err & DR_STEP) && post_kprobe_handler(args->regs)) {
+			args->err &= ~DR_STEP;
+			if (args->err == 0)
+				ret = NOTIFY_STOP;
+		}
 		break;
 	case DIE_GPF:
 	case DIE_PAGE_FAULT:
Index: 2.6.21-rc2/include/asm-i386/kdebug.h
===================================================================
--- 2.6.21-rc2.orig/include/asm-i386/kdebug.h
+++ 2.6.21-rc2/include/asm-i386/kdebug.h
@@ -15,6 +15,7 @@ struct die_args {
 	long err;
 	int trapnr;
 	int signr;
+	int ret;
 };
 
 extern int register_die_notifier(struct notifier_block *);

