Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbXFSUfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbXFSUfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbXFSUfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:35:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53403 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757431AbXFSUfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:35:31 -0400
Date: Tue, 19 Jun 2007 16:35:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070614064835.8BFBA4D059F@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0706191517260.2672-200000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1559625215-1840843770-1182285329=:2624"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1559625215-1840843770-1182285329=:2624
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Wed, 13 Jun 2007, Roland McGrath wrote:

> > I really don't understand your point here.  What's wrong with bp_show?  
> > Is it all the preprocessor conditionals?  I thought that was how we had 
> > agreed portable code should determine which types and lengths were 
> > supported on a particular architecture.
> 
> That part is fine.  The problem is fetching the hw_breakpoint.len field
> directly and expecting it to contain the API values.  In an implementation
> done as I've been referring to, there is no need for any field to contain
> the HW_BREAKPOINT_LEN_8 value, and it's a waste to store one.  If it were
> hw_breakpoint_get_len(bp), that would be fine.

"A waste to store one"?  Waste of what?  It isn't a waste of space; the 
space would otherwise be unused.  Waste of an instruction, perhaps.

> Indeed, that is the natural thing (and all the bits needed) on several.
> I hadn't raised this before since I was having so much trouble already
> convincing you about storing things in machine-dependent fashion so that
> users cannot just use the struct fields directly.

It is now possible for an implementation to store things in a 
machine-dependent fashion; I have added accessor routines as you 
suggested.  But I also left the fields as they were; the documentation 
mentions that they won't necessarily contain any particular values.

You might want to examine the check in validate_settings() for address 
alignment; it might not be valid if other values get stored in the 
low-order bits of the address.  This is a tricky point; it's not safe 
to mix bits around unless you know that the data values are correct, 
but in validate_settings() you don't yet know that.

> On x86 use:
> 
> 	struct arch_hw_breakpoint_info {
> 		union {
> 			const void		*kernel;
> 			const void	__user	*user;
> 			unsigned long		va;
> 		}		address;
> 		u8		len;
> 		u8		type;
> 	} __attribute__((packed));
> 
> and the size of struct hw_breakpoint won't increase.

Maybe.  I don't see any reason for the unnecessary encapsulation, 
though.

> > > What about DR_STEP?  i.e., if DR_STEP was set from a single-step and then
> > > there was a DR_TRAPn debug exception, is DR_STEP still set?  If DR_TRAPn
> > > was set and then you single-step, is DR_TRAPn cleared?
> > 
> > I didn't experiment with using DR_STEP.  There wasn't any simple way to
> > cause a single-step exception.  Perhaps if I were more familiar with
> > kprobes...
> 
> It's easy for user mode with gdb.

Yes, of course.  I feel foolish for having forgotten.

Tests show that my CPU does not clear DR_STEP when a data breakpoint is
hit.  Conversely, the DR_TRAPn bits are cleared even when a single-step 
exception occurs.

The bizarre behavior from before is still present; the system gets in a
long loop when the exception handler leaves any of the 0xe000 bits set
in DR6.  And it kills my shell process, probably by sending it a
SIGTRAP.  Oddly enough, this only happens when there's a kernel-space
debug exception -- faults in user-space continue to work normally.  
It's not clear what this means; the behavior indicates a software
problem but the dependency on the DR6 value indicates a hardware
contribution as well...

If you're interested, I can send you the code I used to do this testing
so you can try it on your machine.


> > I decided on something simpler than messing around with Kconfig.  
> 
> I still think it's the proper thing to make it conditional, not always
> built in.  But it's a pedantic point.

We have three things to consider: ptrace, utrace, and hw-breakpoint.  
Ultimately hw-breakpoint should become part of utrace; we might not
want to bother with a standalone version.

Furthermore, hw-breakpoint takes over the ptrace's mechanism for
breakpoint handling.  If we want to allow a configuration where ptrace
is present and hw-breakpoint isn't, then I would have to add an
alternate implementation containing only support for the legacy
interface.

It doesn't have to be done now, but it is something to bear in mind 
while trying to decide what things should be conditional on which 
options.


> Indeed I think we have come nearly as far as we will before we have a few
> arch ports get done and some heavy use to find the rough edges.  Thanks
> very much for being so accomodating to all my criticism, which I hope has
> been constructive.

There's no question that the code is much improved as a result of our 
interaction.


> > +inline const void *hw_breakpoint_get_kaddr(struct hw_breakpoint *bp)
> 
> These need to be static inline.  Here you're defining a global function
> in every .o file that uses the header.

Whoops.  It's fixed now.

> > +	get_debugreg(dr6, 6);
> > +	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
> > +	if (dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
> > +		tsk->thread.vdr6 = 0;
> 
> Some comment here about this conditional clearing, please.

In fact I decided to change that whole thing around.  Now dr6 gets
stored in vdr6 immediately, with no conditional.  This is the right
thing to do when hw-breakpoint support is missing (aside from false
triggers caused by lazy debug register switching).  Then the
hw-breakpoint notifier routine clears the DR_TRAPn bits from vdr6, and
the ptrace "triggered" callback sets the appropriate virtualized bits
in vdr6.  Overall it's a lot simpler and easier to analyze.

I made a few other changes to do_debug.  For instance, it no longer 
checks whether notify_die() returns NOTIFY_STOP.  That check was a 
mistake to begin with; NOTIFY_STOP merely means to cut the notifier 
chain short -- it doesn't mean that the debug exception can be ignored.  
Also it sends the SIGTRAP when any of the DR_STEP or DR_TRAPn bits are 
set in vdr6; this is now the appropriate condition.

> > +
> > +/*
> > + * HW breakpoint additions
> > + */
> > +
> > +#define HB_NUM		4	/* Number of hardware breakpoints */
> 
> Need #ifdef __KERNEL__ around all these additions to debugreg.h.

Done.

> > +static inline void arch_update_thbi(struct thread_hw_breakpoint *thbi,
> 
> For local functions in a source file (not a header), it's standard form
> now just to define them static, not static inline.  For these trivial
> ones, the compiler will always inline them.

Okay.  Here's the latest form of the code, with the updated bptest 
patch as an attachment.

Alan Stern



Index: usb-2.6/include/asm-i386/hw_breakpoint.h
===================================================================
--- /dev/null
+++ usb-2.6/include/asm-i386/hw_breakpoint.h
@@ -0,0 +1,70 @@
+#ifndef	_I386_HW_BREAKPOINT_H
+#define	_I386_HW_BREAKPOINT_H
+#define	__ARCH_HW_BREAKPOINT_H
+
+#ifdef	__KERNEL__
+#include <asm-generic/hw_breakpoint.h>
+
+/* HW breakpoint static initializers */
+#define HW_BREAKPOINT_KINIT(addr, _len, _type)		\
+		.address	= {.kernel = addr,},	\
+		.len		= _len,			\
+		.type		= _type
+
+#define HW_BREAKPOINT_UINIT(addr, _len, _type)		\
+		.address	= {.user = addr,},	\
+		.len		= _len,			\
+		.type		= _type
+
+/* HW breakpoint setter routines */
+static inline void hw_breakpoint_kinit(struct hw_breakpoint *bp,
+		const void *addr, unsigned len, unsigned type)
+{
+	bp->address.kernel = addr;
+	bp->len = len;
+	bp->type = type;
+}
+
+static inline void hw_breakpoint_uinit(struct hw_breakpoint *bp,
+		const void __user *addr, unsigned len, unsigned type)
+{
+	bp->address.user = addr;
+	bp->len = len;
+	bp->type = type;
+}
+
+/* HW breakpoint accessor routines */
+static inline const void *hw_breakpoint_get_kaddr(struct hw_breakpoint *bp)
+{
+	return bp->address.kernel;
+}
+
+static inline const void __user *hw_breakpoint_get_uaddr(
+		struct hw_breakpoint *bp)
+{
+	return bp->address.user;
+}
+
+static inline unsigned hw_breakpoint_get_len(struct hw_breakpoint *bp)
+{
+	return bp->len;
+}
+
+static inline unsigned hw_breakpoint_get_type(struct hw_breakpoint *bp)
+{
+	return bp->type;
+}
+
+/* Available HW breakpoint length encodings */
+#define HW_BREAKPOINT_LEN_1		0x40
+#define HW_BREAKPOINT_LEN_2		0x44
+#define HW_BREAKPOINT_LEN_4		0x4c
+#define HW_BREAKPOINT_LEN_EXECUTE	0x40
+
+/* Available HW breakpoint type encodings */
+#define HW_BREAKPOINT_EXECUTE	0x80	/* trigger on instruction execute */
+#define HW_BREAKPOINT_WRITE	0x81	/* trigger on memory write */
+#define HW_BREAKPOINT_RW	0x83	/* trigger on memory read or write */
+
+#endif	/* __KERNEL__ */
+#endif	/* _I386_HW_BREAKPOINT_H */
Index: usb-2.6/arch/i386/kernel/process.c
===================================================================
--- usb-2.6.orig/arch/i386/kernel/process.c
+++ usb-2.6/arch/i386/kernel/process.c
@@ -57,6 +57,7 @@
 
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
+#include <asm/debugreg.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -376,9 +377,10 @@ EXPORT_SYMBOL(kernel_thread);
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
@@ -396,15 +398,17 @@ void exit_thread(void)
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
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
@@ -447,14 +451,21 @@ int copy_thread(int nr, unsigned long cl
 
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
 
@@ -484,7 +495,8 @@ int copy_thread(int nr, unsigned long cl
 
 	err = 0;
  out:
-	if (err && p->thread.io_bitmap_ptr) {
+	if (err) {
+		flush_thread_hw_breakpoint(p);
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
@@ -496,18 +508,18 @@ int copy_thread(int nr, unsigned long cl
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
@@ -557,16 +569,6 @@ static noinline void __switch_to_xtra(st
 
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
@@ -699,7 +701,7 @@ struct task_struct fastcall * __switch_t
 		set_iopl_mask(next->iopl);
 
 	/*
-	 * Now maybe handle debug registers and/or IO bitmaps
+	 * Now maybe handle IO bitmaps
 	 */
 	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW)
 	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)))
@@ -731,6 +733,13 @@ struct task_struct fastcall * __switch_t
 
 	x86_write_percpu(current_task, next_p);
 
+	/*
+	 * Handle debug registers.  This must be done _after_ current
+	 * is updated.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
+
 	return prev_p;
 }
 
Index: usb-2.6/arch/i386/kernel/signal.c
===================================================================
--- usb-2.6.orig/arch/i386/kernel/signal.c
+++ usb-2.6/arch/i386/kernel/signal.c
@@ -591,13 +591,6 @@ static void fastcall do_signal(struct pt
 
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
Index: usb-2.6/arch/i386/kernel/traps.c
===================================================================
--- usb-2.6.orig/arch/i386/kernel/traps.c
+++ usb-2.6/arch/i386/kernel/traps.c
@@ -804,62 +804,42 @@ fastcall void __kprobes do_int3(struct p
  */
 fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
 {
-	unsigned int condition;
 	struct task_struct *tsk = current;
+	unsigned long dr6;
 
-	get_debugreg(condition, 6);
+	get_debugreg(dr6, 6);
+	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
+
+	/* Store the virtualized DR6 value */
+	tsk->thread.vdr6 = dr6;
+
+	notify_die(DIE_DEBUG, "debug", regs, dr6, error_code, SIGTRAP);
 
-	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
-					SIGTRAP) == NOTIFY_STOP)
-		return;
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
+	if ((dr6 & DR_STEP) && !user_mode(regs)) {
+		tsk->thread.vdr6 &= ~DR_STEP;
+		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+		regs->eflags &= ~X86_EFLAGS_TF;
 	}
 
-	/* Ok, finally something we can handle */
-	send_sigtrap(tsk, regs, error_code);
-
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
+	if (tsk->thread.vdr6 & (DR_STEP|DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
+		send_sigtrap(tsk, regs, error_code);
 }
 
 /*
Index: usb-2.6/include/asm-i386/debugreg.h
===================================================================
--- usb-2.6.orig/include/asm-i386/debugreg.h
+++ usb-2.6/include/asm-i386/debugreg.h
@@ -48,6 +48,8 @@
 
 #define DR_LOCAL_ENABLE_SHIFT 0    /* Extra shift to the local enable bit */
 #define DR_GLOBAL_ENABLE_SHIFT 1   /* Extra shift to the global enable bit */
+#define DR_LOCAL_ENABLE (0x1)      /* Local enable for reg 0 */
+#define DR_GLOBAL_ENABLE (0x2)     /* Global enable for reg 0 */
 #define DR_ENABLE_SIZE 2           /* 2 enable bits per register */
 
 #define DR_LOCAL_ENABLE_MASK (0x55)  /* Set  local bits for all 4 regs */
@@ -61,4 +63,32 @@
 #define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
 #define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
 
+
+/*
+ * HW breakpoint additions
+ */
+#ifdef __KERNEL__
+
+#define HB_NUM		4	/* Number of hardware breakpoints */
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
+static inline void disable_debug_registers(void)
+{
+	set_debugreg(0, 7);
+}
+
+/* For use by ptrace */
+unsigned long thread_get_debugreg(struct task_struct *tsk, int n);
+int thread_set_debugreg(struct task_struct *tsk, int n, unsigned long val);
+
+#endif	/* __KERNEL__ */
+
 #endif
Index: usb-2.6/include/asm-i386/processor.h
===================================================================
--- usb-2.6.orig/include/asm-i386/processor.h
+++ usb-2.6/include/asm-i386/processor.h
@@ -354,8 +354,9 @@ struct thread_struct {
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
Index: usb-2.6/arch/i386/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ usb-2.6/arch/i386/kernel/hw_breakpoint.c
@@ -0,0 +1,633 @@
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
+	How to know whether RF should be cleared when setting a user
+	execution breakpoint?
+
+*/
+
+#include <linux/init.h>
+#include <linux/irqflags.h>
+#include <linux/kdebug.h>
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
+#include <asm/percpu.h>
+#include <asm/processor.h>
+
+
+/* Per-thread HW breakpoint and debug register info */
+struct thread_hw_breakpoint {
+
+	/* utrace support */
+	struct list_head	node;		/* Entry in thread list */
+	struct list_head	thread_bps;	/* Thread's breakpoints */
+	struct hw_breakpoint	*bps[HB_NUM];	/* Highest-priority bps */
+	int			num_installed;	/* Number of installed bps */
+	unsigned		gennum;		/* update-generation number */
+
+	/* Only the portions below are arch-specific */
+
+	/* ptrace support -- Note that vdr6 is stored directly in the
+	 * thread_struct so that it is always available.
+	 */
+	unsigned long		vdr7;			/* Virtualized DR7 */
+	struct hw_breakpoint	vdr_bps[HB_NUM];	/* Breakpoints
+			representing virtualized debug registers 0 - 3 */
+	unsigned long		tdr[HB_NUM];	/*  and their addresses */
+	unsigned long		tdr7;		/* Thread's DR7 value */
+	unsigned long		tkdr7;		/* Thread + kernel DR7 value */
+};
+
+/* Kernel-space breakpoint data */
+struct kernel_bp_data {
+	unsigned		gennum;		/* Generation number */
+	int			num_kbps;	/* Number of kernel bps */
+	struct hw_breakpoint	*bps[HB_NUM];	/* Loaded breakpoints */
+
+	/* Only the portions below are arch-specific */
+	unsigned long		mkdr7;		/* Masked kernel DR7 value */
+};
+
+/* Per-CPU debug register info */
+struct cpu_hw_breakpoint {
+	struct kernel_bp_data	*cur_kbpdata;	/* Current kbpdata[] entry */
+	struct task_struct	*bp_task;	/* The thread whose bps
+			are currently loaded in the debug registers */
+};
+
+static DEFINE_PER_CPU(struct cpu_hw_breakpoint, cpu_info);
+
+/* Global info */
+static struct kernel_bp_data	kbpdata[2];	/* Old and new settings */
+static int			cur_kbpindex;	/* Alternates 0, 1, ... */
+static struct kernel_bp_data	*cur_kbpdata = &kbpdata[0];
+			/* Always equal to &kbpdata[cur_kbpindex] */
+
+static u8			tprio[HB_NUM];	/* Thread bp max priorities */
+static LIST_HEAD(kernel_bps);			/* Kernel breakpoint list */
+static LIST_HEAD(thread_list);			/* thread_hw_breakpoint list */
+static DEFINE_MUTEX(hw_breakpoint_mutex);	/* Protects everything */
+
+/* Only the portions below are arch-specific */
+
+static unsigned long		kdr7;		/* Unmasked kernel DR7 value */
+
+/* Masks for the bits in DR7 related to kernel breakpoints, for various
+ * values of num_kbps.  Entry n is the mask for when there are n kernel
+ * breakpoints, in debug registers 0 - (n-1).  The DR_GLOBAL_SLOWDOWN bit
+ * (GE) is handled specially.
+ */
+static const unsigned long	kdr7_masks[HB_NUM + 1] = {
+	0x00000000,
+	0x000f0003,	/* LEN0, R/W0, G0, L0 */
+	0x00ff000f,	/* Same for 0,1 */
+	0x0fff003f,	/* Same for 0,1,2 */
+	0xffff00ff	/* Same for 0,1,2,3 */
+};
+
+
+/* Arch-specific hook routines */
+
+
+/*
+ * Install the kernel breakpoints in their debug registers.
+ */
+static void arch_install_chbi(struct cpu_hw_breakpoint *chbi)
+{
+	struct hw_breakpoint **bps;
+
+	/* Don't allow debug exceptions while we update the registers */
+	set_debugreg(0, 7);
+	chbi->cur_kbpdata = rcu_dereference(cur_kbpdata);
+
+	/* Kernel breakpoints are stored starting in DR0 and going up */
+	bps = chbi->cur_kbpdata->bps;
+	switch (chbi->cur_kbpdata->num_kbps) {
+	case 4:
+		set_debugreg(bps[3]->address.va, 3);
+	case 3:
+		set_debugreg(bps[2]->address.va, 2);
+	case 2:
+		set_debugreg(bps[1]->address.va, 1);
+	case 1:
+		set_debugreg(bps[0]->address.va, 0);
+	}
+	/* No need to set DR6 */
+	set_debugreg(chbi->cur_kbpdata->mkdr7, 7);
+}
+
+/*
+ * Update an out-of-date thread hw_breakpoint info structure.
+ */
+static void arch_update_thbi(struct thread_hw_breakpoint *thbi,
+		struct kernel_bp_data *thr_kbpdata)
+{
+	int num = thr_kbpdata->num_kbps;
+
+	thbi->tkdr7 = thr_kbpdata->mkdr7 | (thbi->tdr7 & ~kdr7_masks[num]);
+}
+
+/*
+ * Install the thread breakpoints in their debug registers.
+ */
+static void arch_install_thbi(struct thread_hw_breakpoint *thbi)
+{
+	/* Install the user breakpoints.  Kernel breakpoints are stored
+	 * starting in DR0 and going up; there are num_kbps of them.
+	 * User breakpoints are stored starting in DR3 and going down,
+	 * as many as we have room for.
+	 */
+	switch (thbi->num_installed) {
+	case 4:
+		set_debugreg(thbi->tdr[0], 0);
+	case 3:
+		set_debugreg(thbi->tdr[1], 1);
+	case 2:
+		set_debugreg(thbi->tdr[2], 2);
+	case 1:
+		set_debugreg(thbi->tdr[3], 3);
+	}
+	/* No need to set DR6 */
+	set_debugreg(thbi->tkdr7, 7);
+}
+
+/*
+ * Install the debug register values for just the kernel, no thread.
+ */
+static void arch_install_none(struct cpu_hw_breakpoint *chbi)
+{
+	set_debugreg(chbi->cur_kbpdata->mkdr7, 7);
+}
+
+/*
+ * Create a new kbpdata entry.
+ */
+static void arch_new_kbpdata(struct kernel_bp_data *new_kbpdata)
+{
+	int num = new_kbpdata->num_kbps;
+
+	new_kbpdata->mkdr7 = kdr7 & (kdr7_masks[num] | DR_GLOBAL_SLOWDOWN);
+}
+
+/*
+ * Check for virtual address in user space.
+ */
+static int arch_check_va_in_userspace(unsigned long va,
+		struct task_struct *tsk)
+{
+#ifndef	CONFIG_X86_64
+#define	TASK_SIZE_OF(t)	TASK_SIZE
+#endif
+	return (va < TASK_SIZE_OF(tsk));
+}
+
+/*
+ * Check for virtual address in kernel space.
+ */
+static int arch_check_va_in_kernelspace(unsigned long va)
+{
+#ifndef	CONFIG_X86_64
+#define	TASK_SIZE64	TASK_SIZE
+#endif
+	return (va >= TASK_SIZE64);
+}
+
+/*
+ * Encode the length, type, Exact, and Enable bits for a particular breakpoint
+ * as stored in debug register 7.
+ */
+static unsigned long encode_dr7(int drnum, u8 len, u8 type)
+{
+	unsigned long temp;
+
+	temp = (len | type) & 0xf;
+	temp <<= (DR_CONTROL_SHIFT + drnum * DR_CONTROL_SIZE);
+	temp |= (DR_GLOBAL_ENABLE << (drnum * DR_ENABLE_SIZE)) |
+				DR_GLOBAL_SLOWDOWN;
+	return temp;
+}
+
+/*
+ * Calculate the DR7 value for a list of kernel or user breakpoints.
+ */
+static unsigned long calculate_dr7(struct thread_hw_breakpoint *thbi)
+{
+	int is_user;
+	struct list_head *bp_list;
+	struct hw_breakpoint *bp;
+	int i;
+	int drnum;
+	unsigned long dr7;
+
+	if (thbi) {
+		is_user = 1;
+		bp_list = &thbi->thread_bps;
+		drnum = HB_NUM - 1;
+	} else {
+		is_user = 0;
+		bp_list = &kernel_bps;
+		drnum = 0;
+	}
+
+	/* Kernel bps are assigned from DR0 on up, and user bps are assigned
+	 * from DR3 on down.  Accumulate all 4 bps; the kernel DR7 mask will
+	 * select the appropriate bits later.
+	 */
+	dr7 = 0;
+	i = 0;
+	list_for_each_entry(bp, bp_list, node) {
+
+		/* Get the debug register number and accumulate the bits */
+		dr7 |= encode_dr7(drnum, bp->len, bp->type);
+		if (++i >= HB_NUM)
+			break;
+		if (is_user)
+			--drnum;
+		else
+			++drnum;
+	}
+	return dr7;
+}
+
+/*
+ * Register a new user breakpoint structure.
+ */
+static void arch_register_user_hw_breakpoint(struct hw_breakpoint *bp,
+		struct thread_hw_breakpoint *thbi)
+{
+	thbi->tdr7 = calculate_dr7(thbi);
+
+	/* If this is an execution breakpoint for the current PC address,
+	 * we should clear the task's RF so that the bp will be certain
+	 * to trigger.
+	 *
+	 * FIXME: It's not so easy to get hold of the task's PC as a linear
+	 * address!  ptrace.c does this already...
+	 */
+}
+
+/*
+ * Unregister a user breakpoint structure.
+ */
+static void arch_unregister_user_hw_breakpoint(struct hw_breakpoint *bp,
+		struct thread_hw_breakpoint *thbi)
+{
+	thbi->tdr7 = calculate_dr7(thbi);
+}
+
+/*
+ * Register a kernel breakpoint structure.
+ */
+static void arch_register_kernel_hw_breakpoint(
+		struct hw_breakpoint *bp)
+{
+	kdr7 = calculate_dr7(NULL);
+}
+
+/*
+ * Unregister a kernel breakpoint structure.
+ */
+static void arch_unregister_kernel_hw_breakpoint(
+		struct hw_breakpoint *bp)
+{
+	kdr7 = calculate_dr7(NULL);
+}
+
+
+/* End of arch-specific hook routines */
+
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
+			u_debugreg[i] = thbi->vdr_bps[i].address.va;
+		u_debugreg[7] = thbi->vdr7;
+	}
+	u_debugreg[6] = tsk->thread.vdr6;
+}
+
+/*
+ * Ptrace support: breakpoint trigger routine.
+ */
+
+static struct thread_hw_breakpoint *alloc_thread_hw_breakpoint(
+		struct task_struct *tsk);
+static int __register_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp);
+static void __unregister_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp);
+
+static void ptrace_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
+{
+	struct task_struct *tsk = current;
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+	int i;
+
+	/* Store in the virtual DR6 register the fact that the breakpoint
+	 * was hit so the thread's debugger will see it.
+	 */
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
+			val = (unsigned long) thbi->vdr_bps[n].address.va;
+	} else if (n == 6) {
+		val = tsk->thread.vdr6;
+	} else if (n == 7) {
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
+static int decode_dr7(unsigned long dr7, int bpnum, u8 *len, u8 *type)
+{
+	int temp = dr7 >> (DR_CONTROL_SHIFT + bpnum * DR_CONTROL_SIZE);
+
+	*len = (temp & 0xc) | 0x40;
+	*type = (temp & 0x3) | 0x80;
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
+	/* Loop through all the hardware breakpoints, making the
+	 * appropriate changes to each.
+	 */
+ restore_settings:
+	thbi->vdr7 = data;
+	bp = &thbi->vdr_bps[0];
+	for (i = 0; i < HB_NUM; (++i, ++bp)) {
+		int enabled;
+		u8 len, type;
+
+		enabled = decode_dr7(data, i, &len, &type);
+
+		/* Unregister the breakpoint before trying to change it */
+		if (bp->status)
+			__unregister_user_hw_breakpoint(tsk, bp);
+
+		/* Insert the breakpoint's new settings */
+		bp->len = len;
+		bp->type = type;
+
+		/* Now register the breakpoint if it should be enabled.
+		 * New invalid entries will raise an error here.
+		 */
+		if (enabled) {
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
+	/* We have to hold this lock the entire time, to prevent thbi
+	 * from being deallocated out from under us.
+	 */
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
+		/* If the breakpoint is registered then unregister it,
+		 * change it, and re-register it.  Revert to the original
+		 * address if an error occurs.
+		 */
+		if (bp->status) {
+			unsigned long old_addr = bp->address.va;
+
+			__unregister_user_hw_breakpoint(tsk, bp);
+			bp->address.va = val;
+			rc = __register_user_hw_breakpoint(tsk, bp);
+			if (rc < 0) {
+				bp->address.va = old_addr;
+				__register_user_hw_breakpoint(tsk, bp);
+			}
+		} else {
+			bp->address.va = val;
+			rc = 0;
+		}
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
+
+/*
+ * Handle debug exception notifications.
+ */
+
+static void switch_to_none_hw_breakpoint(void);
+
+static int __kprobes hw_breakpoint_handler(struct die_args *args)
+{
+	struct cpu_hw_breakpoint *chbi;
+	int i;
+	struct hw_breakpoint *bp;
+	struct thread_hw_breakpoint *thbi = NULL;
+
+	/* The DR6 value is stored in args->err */
+#define DR6	(args->err)
+
+	if (!(DR6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
+		return NOTIFY_DONE;
+
+	/* Assert that local interrupts are disabled */
+
+	/* Reset the DRn bits in the virtualized register value.
+	 * The ptrace trigger routine will add in whatever is needed.
+	 */
+	current->thread.vdr6 &= ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);
+
+	/* Are we a victim of lazy debug-register switching? */
+	chbi = &per_cpu(cpu_info, get_cpu());
+	if (!chbi->bp_task)
+		;
+	else if (chbi->bp_task != current) {
+
+		/* No user breakpoints are valid.  Perform the belated
+		 * debug-register switch.
+		 */
+		switch_to_none_hw_breakpoint();
+	} else {
+		thbi = chbi->bp_task->thread.hw_breakpoint_info;
+	}
+
+	/* Disable all breakpoints so that the callbacks can run without
+	 * triggering recursive debug exceptions.
+	 */
+	set_debugreg(0, 7);
+
+	/* Handle all the breakpoints that were triggered */
+	for (i = 0; i < HB_NUM; ++i) {
+		if (likely(!(DR6 & (DR_TRAP0 << i))))
+			continue;
+
+		/* Find the corresponding hw_breakpoint structure and
+		 * invoke its triggered callback.
+		 */
+		if (i < chbi->cur_kbpdata->num_kbps)
+			bp = chbi->cur_kbpdata->bps[i];
+		else if (thbi)
+			bp = thbi->bps[i];
+		else		/* False alarm due to lazy DR switching */
+			continue;
+		if (bp) {		/* Should always be non-NULL */
+
+			/* Set RF at execution breakpoints */
+			if (bp->type == HW_BREAKPOINT_EXECUTE)
+				args->regs->eflags |= X86_EFLAGS_RF;
+			(bp->triggered)(bp, args->regs);
+		}
+	}
+
+	/* Re-enable the breakpoints */
+	set_debugreg(thbi ? thbi->tkdr7 : chbi->cur_kbpdata->mkdr7, 7);
+	put_cpu_no_resched();
+
+	if (!(DR6 & ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
+		return NOTIFY_STOP;
+
+	return NOTIFY_DONE;
+#undef DR6
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
+	load_debug_registers();
+	return register_die_notifier(&hw_breakpoint_exceptions_nb);
+}
+
+core_initcall(init_hw_breakpoint);
+
+
+/* Grab the arch-independent code */
+
+#include "../../../kernel/hw_breakpoint.c"
Index: usb-2.6/arch/i386/kernel/ptrace.c
===================================================================
--- usb-2.6.orig/arch/i386/kernel/ptrace.c
+++ usb-2.6/arch/i386/kernel/ptrace.c
@@ -382,11 +382,11 @@ long arch_ptrace(struct task_struct *chi
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
@@ -416,59 +416,11 @@ long arch_ptrace(struct task_struct *chi
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
 
@@ -624,7 +576,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = ptrace_request(child, request, addr, data);
 		break;
 	}
- out_tsk:
 	return ret;
 }
 
Index: usb-2.6/arch/i386/kernel/Makefile
===================================================================
--- usb-2.6.orig/arch/i386/kernel/Makefile
+++ usb-2.6/arch/i386/kernel/Makefile
@@ -7,7 +7,8 @@ extra-y := head.o init_task.o vmlinux.ld
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_i386.o \
 		pci-dma.o i386_ksyms.o i387.o bootflag.o e820.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o
+		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o \
+		hw_breakpoint.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
Index: usb-2.6/arch/i386/power/cpu.c
===================================================================
--- usb-2.6.orig/arch/i386/power/cpu.c
+++ usb-2.6/arch/i386/power/cpu.c
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/debugreg.h>
 
 static struct saved_context saved_context;
 
@@ -46,6 +47,8 @@ void __save_processor_state(struct saved
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4();
+
+	disable_debug_registers();
 }
 
 void save_processor_state(void)
@@ -70,20 +73,7 @@ static void fix_processor_context(void)
 
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
Index: usb-2.6/arch/i386/kernel/kprobes.c
===================================================================
--- usb-2.6.orig/arch/i386/kernel/kprobes.c
+++ usb-2.6/arch/i386/kernel/kprobes.c
@@ -660,9 +660,17 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
+
+	/* The DR6 value is stored in args->err */
+#define DR6	(args->err)
+
+		if ((DR6 & DR_STEP) && post_kprobe_handler(args->regs)) {
+			if ((DR6 & ~DR_STEP) == 0)
+				ret = NOTIFY_STOP;
+		}
 		break;
+#undef DR6
+
 	case DIE_GPF:
 	case DIE_PAGE_FAULT:
 		/* kprobe_running() needs smp_processor_id() */
Index: usb-2.6/include/asm-generic/hw_breakpoint.h
===================================================================
--- /dev/null
+++ usb-2.6/include/asm-generic/hw_breakpoint.h
@@ -0,0 +1,264 @@
+#ifndef	_ASM_GENERIC_HW_BREAKPOINT_H
+#define	_ASM_GENERIC_HW_BREAKPOINT_H
+
+#ifndef __ARCH_HW_BREAKPOINT_H
+#error "Please don't include this file directly"
+#endif
+
+#ifdef	__KERNEL__
+#include <linux/list.h>
+#include <linux/types.h>
+
+/**
+ * struct hw_breakpoint - unified kernel/user-space hardware breakpoint
+ * @node: internal linked-list management
+ * @triggered: callback invoked when the breakpoint is hit
+ * @installed: callback invoked when the breakpoint is installed
+ * @uninstalled: callback invoked when the breakpoint is uninstalled
+ * @address: location (virtual address) of the breakpoint
+ * @len: encoded extent of the breakpoint address (1, 2, 4, or 8 bytes)
+ * @type: breakpoint type (read-only, write-only, read/write, or execute)
+ * @priority: requested priority level
+ * @status: current registration/installation status
+ *
+ * %hw_breakpoint structures are the kernel's way of representing
+ * hardware breakpoints.  These can be either execute breakpoints
+ * (triggered on instruction execution) or data breakpoints (also known
+ * as "watchpoints", triggered on data access), and the breakpoint's
+ * target address can be located in either kernel space or user space.
+ *
+ * The @address, @len, and @type fields are highly architecture-specific.
+ * Portable drivers should not use them directly but should employ the
+ * following accessor inlines and macros instead:
+ *
+ *	To set @address, @len, and @type before registering a
+ *	breakpoint, use hw_breakpoint_kinit() or hw_breakpoint_uinit()
+ *	for kernel- and user-space breakpoints respectively.
+ *
+ *	To retrieve the values use
+ *	hw_breakpoint_get_{kaddr,uaddr,len,type}().
+ *
+ *	To initialize these fields in a static breakpoint structure,
+ *	use HW_BREAKPOINT_KINIT() or HW_BREAKPOINT_UINIT() as part
+ *	of the initializer.
+ *
+ * The general descriptions below are accurate for x86; on other
+ * architectures some of the fields might be unused or might have bits
+ * altered while a breakpoint is registered.
+ *
+ * The @address field contains the breakpoint's address, as either a
+ * regular kernel pointer or an %__user pointer.
+ *
+ * @len encodes the breakpoint's extent in bytes, which is subject to
+ * certain limitations.  include/asm/hw_breakpoint.h contains macros
+ * defining the available lengths for a specific architecture.  Note that
+ * @address must have the alignment specified by @len.  The breakpoint
+ * will catch accesses to any byte in the range from @address to @address
+ * + (N-1), where N is the value encoded by @len.
+ *
+ * @type indicates the type of access that will trigger the breakpoint.
+ * Possible values may include:
+ *
+ * 	%HW_BREAKPOINT_EXECUTE (triggered on instruction execution),
+ * 	%HW_BREAKPOINT_RW (triggered on read or write access),
+ * 	%HW_BREAKPOINT_WRITE (triggered on write access), and
+ * 	%HW_BREAKPOINT_READ (triggered on read access).
+ *
+ * Appropriate macros are defined in include/asm/hw_breakpoint.h; not all
+ * possibilities are available on all architectures.  Execute breakpoints
+ * must have @len equal to the special value %HW_BREAKPOINT_LEN_EXECUTE.
+ *
+ * With register_user_hw_breakpoint(), @address must refer to a location
+ * in user space (@address.user).  The breakpoint will be active only
+ * while the requested task is running.  Conversely with
+ * register_kernel_hw_breakpoint(), @address must refer to a location in
+ * kernel space (@address.kernel), and the breakpoint will be active on
+ * all CPUs regardless of the current task.
+ *
+ * When a breakpoint gets hit, the @triggered callback is invoked
+ * in_interrupt with a pointer to the %hw_breakpoint structure and the
+ * processor registers.  Execute-breakpoint traps occur before the
+ * breakpointed instruction runs; when the callback returns the
+ * instruction is restarted (this time without a debug exception).  All
+ * other types of trap occur after the memory access has taken place.
+ * Breakpoints are disabled while @triggered runs, to avoid recursive
+ * traps and allow unhindered access to breakpointed memory.
+ *
+ * Hardware breakpoints are implemented using the CPU's debug registers,
+ * which are a limited hardware resource.  Requests to register a
+ * breakpoint will always succeed provided the parameters are valid,
+ * but the breakpoint may not be installed in a debug register right
+ * away.  Physical debug registers are allocated based on the priority
+ * level stored in @priority (higher values indicate higher priority).
+ * User-space breakpoints within a single thread compete with one
+ * another, and all user-space breakpoints compete with all kernel-space
+ * breakpoints; however user-space breakpoints in different threads do
+ * not compete.  %HW_BREAKPOINT_PRIO_PTRACE is the level used for ptrace
+ * requests; an unobtrusive kernel-space breakpoint will use
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
+ * the breakpoint is actually uninstalled.  As a result @triggered can
+ * be called when you may not expect it, but this way you will know that
+ * during the time interval from @installed to @uninstalled, all events
+ * are faithfully reported.  (It is not possible to do any better than
+ * this in general, because on SMP systems there is no way to set a debug
+ * register simultaneously on all CPUs.)  The same isn't always true with
+ * user-space breakpoints, but the differences should not be visible to a
+ * user process.
+ *
+ * If you need to know whether your kernel-space breakpoint was installed
+ * immediately upon registration, you can check the return value from
+ * register_kernel_hw_breakpoint().  If the value is not > 0, you can
+ * give up and unregister the breakpoint right away.
+ *
+ * @node and @status are intended for internal use.  However @status
+ * may be read to determine whether or not the breakpoint is currently
+ * installed.  (The value is not reliable unless local interrupts are
+ * disabled.)
+ *
+ * This sample code sets a breakpoint on pid_max and registers a callback
+ * function for writes to that variable.  Note that it is not portable
+ * as written, because not all architectures support HW_BREAKPOINT_LEN_4.
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
+ *	..........<do anything>............
+ *	hw_breakpoint_kinit(&my_bp, &pid_max, HW_BREAKPOINT_LEN_4,
+ *			HW_BREAKPOINT_WRITE);
+ *	my_bp.triggered = triggered;
+ *	my_bp.priority = HW_BREAKPOINT_PRIO_NORMAL;
+ *	rc = register_kernel_hw_breakpoint(&my_bp);
+ *	..........<do anything>............
+ * }
+ *
+ * static void cleanup_module(void)
+ * {
+ *	..........<do anything>............
+ *	unregister_kernel_hw_breakpoint(&my_bp);
+ *	..........<do anything>............
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
+	union {
+		const void		*kernel;
+		const void __user	*user;
+		unsigned long		va;
+	}		address;
+	u8		len;
+	u8		type;
+	u8		priority;
+	u8		status;
+};
+
+/*
+ * Macros to initialize the arch-specific parts of a static breakpoint
+ * structure (mnemonic: the address, len, and type arguments occur in
+ * alpabetical order):
+ *
+ * HW_BREAKPOINT_KINIT(addr, len, type)
+ * HW_BREAKPOINT_UINIT(addr, len, type)
+ */
+
+/*
+ * Inline setter routines to initialize the arch-specific parts of
+ * a breakpoint structure:
+ */
+static void hw_breakpoint_kinit(struct hw_breakpoint *bp,
+		const void *addr, unsigned len, unsigned type);
+static void hw_breakpoint_uinit(struct hw_breakpoint *bp,
+		const void __user *addr, unsigned len, unsigned type);
+
+/*
+ * Inline accessor routines to retrieve the arch-specific parts of
+ * a breakpoint structure:
+ */
+static const void *hw_breakpoint_get_kaddr(struct hw_breakpoint *bp);
+static const void __user *hw_breakpoint_get_uaddr(struct hw_breakpoint *bp);
+static unsigned hw_breakpoint_get_len(struct hw_breakpoint *bp);
+static unsigned hw_breakpoint_get_type(struct hw_breakpoint *bp);
+
+/*
+ * len and type values are defined in include/asm/hw_breakpoint.h.
+ * Available values vary according to the architecture.  On i386 the
+ * possibilities are:
+ *
+ *	HW_BREAKPOINT_LEN_1
+ *	HW_BREAKPOINT_LEN_2
+ *	HW_BREAKPOINT_LEN_4
+ *	HW_BREAKPOINT_LEN_EXECUTE
+ *	HW_BREAKPOINT_RW
+ *	HW_BREAKPOINT_READ
+ *	HW_BREAKPOINT_EXECUTE
+ *
+ * On other architectures HW_BREAKPOINT_LEN_8 may be available, and the
+ * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
+ * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
+ */
+
+/* Standard HW breakpoint priority levels (higher value = higher priority) */
+#define HW_BREAKPOINT_PRIO_NORMAL	25
+#define HW_BREAKPOINT_PRIO_PTRACE	50
+#define HW_BREAKPOINT_PRIO_HIGH		75
+
+/* HW breakpoint status values (0 = not registered) */
+#define HW_BREAKPOINT_REGISTERED	1
+#define HW_BREAKPOINT_INSTALLED		2
+
+/*
+ * The following two routines are meant to be called only from within
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
+
+/*
+ * Kernel breakpoints are not associated with any particular thread.
+ */
+int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+
+#endif	/* __KERNEL__ */
+#endif	/* _ASM_GENERIC_HW_BREAKPOINT_H */
Index: usb-2.6/arch/i386/kernel/machine_kexec.c
===================================================================
--- usb-2.6.orig/arch/i386/kernel/machine_kexec.c
+++ usb-2.6/arch/i386/kernel/machine_kexec.c
@@ -19,6 +19,7 @@
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/system.h>
+#include <asm/debugreg.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u32 kexec_pgd[1024] PAGE_ALIGNED;
@@ -108,6 +109,7 @@ NORET_TYPE void machine_kexec(struct kim
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	disable_debug_registers();
 
 	control_page = page_address(image->control_code_page);
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
Index: usb-2.6/arch/i386/kernel/smpboot.c
===================================================================
--- usb-2.6.orig/arch/i386/kernel/smpboot.c
+++ usb-2.6/arch/i386/kernel/smpboot.c
@@ -58,6 +58,7 @@
 #include <smpboot_hooks.h>
 #include <asm/vmi.h>
 #include <asm/mtrr.h>
+#include <asm/debugreg.h>
 
 /* Set if we find a B stepping CPU */
 static int __devinitdata smp_b_stepping;
@@ -427,6 +428,7 @@ static void __cpuinit start_secondary(vo
 	local_irq_enable();
 
 	wmb();
+	load_debug_registers();
 	cpu_idle();
 }
 
@@ -1209,6 +1211,7 @@ int __cpu_disable(void)
 	fixup_irqs(map);
 	/* It's now safe to remove this processor from the online map */
 	cpu_clear(cpu, cpu_online_map);
+	disable_debug_registers();
 	return 0;
 }
 
Index: usb-2.6/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ usb-2.6/kernel/hw_breakpoint.c
@@ -0,0 +1,762 @@
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
+ *
+ * This file contains the arch-independent routines.  It is not meant
+ * to be compiled as a standalone source file; rather it should be
+ * #include'd by the arch-specific implementation.
+ */
+
+
+/*
+ * Install the debug register values for a new thread.
+ */
+void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
+{
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+	struct cpu_hw_breakpoint *chbi;
+	struct kernel_bp_data *thr_kbpdata;
+
+	/* This routine is on the hot path; it gets called for every
+	 * context switch into a task with active breakpoints.  We
+	 * must make sure that the common case executes as quickly as
+	 * possible.
+	 */
+	chbi = &per_cpu(cpu_info, get_cpu());
+	chbi->bp_task = tsk;
+
+	/* Use RCU to synchronize with external updates */
+	rcu_read_lock();
+
+	/* Other CPUs might be making updates to the list of kernel
+	 * breakpoints at this time.  If they are, they will modify
+	 * the other entry in kbpdata[] -- the one not pointed to
+	 * by chbi->cur_kbpdata.  So the update itself won't affect
+	 * us directly.
+	 *
+	 * However when the update is finished, an IPI will arrive
+	 * telling this CPU to change chbi->cur_kbpdata.  We need
+	 * to use a single consistent kbpdata[] entry, the present one.
+	 * So we'll copy the pointer to a local variable, thr_kbpdata,
+	 * and we must prevent the compiler from aliasing the two
+	 * pointers.  Only a compiler barrier is required, not a full
+	 * memory barrier, because everything takes place on a single CPU.
+	 */
+ restart:
+	thr_kbpdata = chbi->cur_kbpdata;
+	barrier();
+
+	/* Normally we can keep the same debug register settings as the
+	 * last time this task ran.  But if the kernel breakpoints have
+	 * changed or any user breakpoints have been registered or
+	 * unregistered, we need to handle the updates and possibly
+	 * send out some notifications.
+	 */
+	if (unlikely(thbi->gennum != thr_kbpdata->gennum)) {
+		struct hw_breakpoint *bp;
+		int i;
+		int num;
+
+		thbi->gennum = thr_kbpdata->gennum;
+		arch_update_thbi(thbi, thr_kbpdata);
+		num = thr_kbpdata->num_kbps;
+
+		/* This code can be invoked while a debugger is actively
+		 * updating the thread's breakpoint list (for example, if
+		 * someone sends SIGKILL to the task).  We use RCU to
+		 * protect our access to the list pointers. */
+		thbi->num_installed = 0;
+		i = HB_NUM;
+		list_for_each_entry_rcu(bp, &thbi->thread_bps, node) {
+
+			/* If this register is allocated for kernel bps,
+			 * don't install.  Otherwise do. */
+			if (--i < num) {
+				if (bp->status == HW_BREAKPOINT_INSTALLED) {
+					if (bp->uninstalled)
+						(bp->uninstalled)(bp);
+					bp->status = HW_BREAKPOINT_REGISTERED;
+				}
+			} else {
+				++thbi->num_installed;
+				if (bp->status != HW_BREAKPOINT_INSTALLED) {
+					bp->status = HW_BREAKPOINT_INSTALLED;
+					if (bp->installed)
+						(bp->installed)(bp);
+				}
+			}
+		}
+	}
+
+	/* Set the debug register */
+	arch_install_thbi(thbi);
+
+	/* Were there any kernel breakpoint changes while we were running? */
+	if (unlikely(chbi->cur_kbpdata != thr_kbpdata)) {
+
+		/* DR0-3 might now be assigned to kernel bps and we might
+		 * have messed them up.  Reload all the kernel bps and
+		 * then reload the thread bps.
+		 */
+		arch_install_chbi(chbi);
+		goto restart;
+	}
+
+	rcu_read_unlock();
+	put_cpu_no_resched();
+}
+
+/*
+ * Install the debug register values for just the kernel, no thread.
+ */
+static void switch_to_none_hw_breakpoint(void)
+{
+	struct cpu_hw_breakpoint *chbi;
+
+	chbi = &per_cpu(cpu_info, get_cpu());
+	chbi->bp_task = NULL;
+
+	/* This routine gets called from only two places.  In one
+	 * the caller holds the hw_breakpoint_mutex; in the other
+	 * interrupts are disabled.  In either case, no kernel
+	 * breakpoint updates can arrive while the routine runs.
+	 * So we don't need to use RCU.
+	 */
+	arch_install_none(chbi);
+	put_cpu_no_resched();
+}
+
+/*
+ * Update the debug registers on this CPU.
+ */
+static void update_this_cpu(void *unused)
+{
+	struct cpu_hw_breakpoint *chbi;
+	struct task_struct *tsk = current;
+
+	chbi = &per_cpu(cpu_info, get_cpu());
+
+	/* Install both the kernel and the user breakpoints */
+	arch_install_chbi(chbi);
+	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
+		switch_to_thread_hw_breakpoint(tsk);
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
+	/* We don't need to use any sort of memory barrier.  The IPI
+	 * carried out by on_each_cpu() includes its own barriers.
+	 */
+	on_each_cpu(update_this_cpu, NULL, 0, 0);
+	synchronize_rcu();
+}
+
+/*
+ * Load the debug registers during startup of a CPU.
+ */
+void load_debug_registers(void)
+{
+	unsigned long flags;
+
+	/* Prevent IPIs for new kernel breakpoint updates */
+	local_irq_save(flags);
+
+	rcu_read_lock();
+	update_this_cpu(NULL);
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+}
+
+/*
+ * Take the 4 highest-priority breakpoints in a thread and accumulate
+ * their priorities in tprio.  Highest-priority entry is in tprio[3].
+ */
+static void accum_thread_tprio(struct thread_hw_breakpoint *thbi)
+{
+	int i;
+
+	for (i = HB_NUM - 1; i >= 0 && thbi->bps[i]; --i)
+		tprio[i] = max(tprio[i], thbi->bps[i]->priority);
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
+	 * and accumulate the maximum priority levels in tprio.
+	 */
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
+	int k, u;
+	int changed = 0;
+	struct hw_breakpoint *bp;
+	struct kernel_bp_data *new_kbpdata;
+
+	/* Determine how many debug registers are available for kernel
+	 * breakpoints as opposed to user breakpoints, based on the
+	 * priorities.  Ties are resolved in favor of user bps.
+	 */
+	k = 0;			/* Next kernel bp to allocate */
+	u = HB_NUM - 1;		/* Next user bp to allocate */
+	bp = list_entry(kernel_bps.next, struct hw_breakpoint, node);
+	while (k <= u) {
+		if (&bp->node == &kernel_bps || tprio[u] >= bp->priority)
+			--u;		/* User bps win a slot */
+		else {
+			++k;		/* Kernel bp wins a slot */
+			if (bp->status != HW_BREAKPOINT_INSTALLED)
+				changed = 1;
+			bp = list_entry(bp->node.next, struct hw_breakpoint,
+					node);
+		}
+	}
+	if (k != cur_kbpdata->num_kbps)
+		changed = 1;
+
+	/* Notify the remaining kernel breakpoints that they are about
+	 * to be uninstalled.
+	 */
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
+		cur_kbpindex ^= 1;
+		new_kbpdata = &kbpdata[cur_kbpindex];
+		new_kbpdata->gennum = cur_kbpdata->gennum + 1;
+		new_kbpdata->num_kbps = k;
+		arch_new_kbpdata(new_kbpdata);
+		u = 0;
+		list_for_each_entry(bp, &kernel_bps, node) {
+			if (u >= k)
+				break;
+			new_kbpdata->bps[u] = bp;
+			++u;
+		}
+		rcu_assign_pointer(cur_kbpdata, new_kbpdata);
+
+		/* Tell all the CPUs to update their debug registers */
+		update_all_cpus();
+
+		/* Notify the breakpoints that just got installed */
+		for (u = 0; u < k; ++u) {
+			bp = new_kbpdata->bps[u];
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
+			INIT_LIST_HEAD(&thbi->node);
+			INIT_LIST_HEAD(&thbi->thread_bps);
+
+			/* Force an update the next time tsk runs */
+			thbi->gennum = cur_kbpdata->gennum - 2;
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
+	/* Actually uninstall the breakpoints if necessary */
+	if (tsk == current)
+		switch_to_none_hw_breakpoint();
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
+	 * But what about CLONE_PTRACE?
+	 */
+	clear_tsk_thread_flag(child, TIF_DEBUG);
+	return 0;
+}
+
+/*
+ * Store the highest-priority thread breakpoint entries in an array.
+ */
+static void store_thread_bp_array(struct thread_hw_breakpoint *thbi)
+{
+	struct hw_breakpoint *bp;
+	int i;
+
+	i = HB_NUM - 1;
+	list_for_each_entry(bp, &thbi->thread_bps, node) {
+		thbi->bps[i] = bp;
+		thbi->tdr[i] = bp->address.va;
+		if (--i < 0)
+			break;
+	}
+	while (i >= 0)
+		thbi->bps[i--] = NULL;
+
+	/* Force an update the next time this task runs */
+	thbi->gennum = cur_kbpdata->gennum - 2;
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
+ */
+static int insert_bp_in_list(struct hw_breakpoint *bp,
+		struct thread_hw_breakpoint *thbi, struct task_struct *tsk)
+{
+	struct list_head *head;
+	int pos;
+	struct hw_breakpoint *temp_bp;
+
+	/* tsk and thbi are NULL for kernel bps, non-NULL for user bps */
+	if (tsk)
+		head = &thbi->thread_bps;
+	else
+		head = &kernel_bps;
+
+	/* Equal-priority breakpoints get listed first-come-first-served */
+	pos = 0;
+	list_for_each_entry(temp_bp, head, node) {
+		if (bp->priority > temp_bp->priority)
+			break;
+		++pos;
+	}
+	bp->status = HW_BREAKPOINT_REGISTERED;
+	list_add_tail(&bp->node, &temp_bp->node);
+
+	if (tsk) {
+		store_thread_bp_array(thbi);
+
+		/* Is this the thread's first registered breakpoint? */
+		if (list_empty(&thbi->node)) {
+			set_tsk_thread_flag(tsk, TIF_DEBUG);
+			list_add(&thbi->node, &thread_list);
+		}
+	}
+	return pos;
+}
+
+/*
+ * Remove a breakpoint from its priority-sorted list.
+ *
+ * See the invariants mentioned above.
+ */
+static void remove_bp_from_list(struct hw_breakpoint *bp,
+		struct thread_hw_breakpoint *thbi, struct task_struct *tsk)
+{
+	/* Remove bp from the thread's/kernel's list.  If the list is now
+	 * empty we must clear the TIF_DEBUG flag.  But keep the
+	 * thread_hw_breakpoint structure, so that the virtualized debug
+	 * register values will remain valid.
+	 */
+	list_del(&bp->node);
+	if (tsk) {
+		store_thread_bp_array(thbi);
+
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
+ * Validate the settings in a hw_breakpoint structure.
+ */
+static int validate_settings(struct hw_breakpoint *bp, struct task_struct *tsk)
+{
+	int rc = -EINVAL;
+	unsigned long len;
+
+	switch (hw_breakpoint_get_type(bp)) {
+#ifdef HW_BREAKPOINT_EXECUTE
+	case HW_BREAKPOINT_EXECUTE:
+		if (hw_breakpoint_get_len(bp) != HW_BREAKPOINT_LEN_EXECUTE)
+			return rc;
+		break;
+#endif
+#ifdef HW_BREAKPOINT_READ
+	case HW_BREAKPOINT_READ:	break;
+#endif
+#ifdef HW_BREAKPOINT_WRITE
+	case HW_BREAKPOINT_WRITE:	break;
+#endif
+#ifdef HW_BREAKPOINT_RW
+	case HW_BREAKPOINT_RW:		break;
+#endif
+	default:
+		return rc;
+	}
+
+	switch (hw_breakpoint_get_len(bp)) {
+#ifdef HW_BREAKPOINT_LEN_1
+	case HW_BREAKPOINT_LEN_1:
+		len = 1;
+		break;
+#endif
+#ifdef HW_BREAKPOINT_LEN_2
+	case HW_BREAKPOINT_LEN_2:
+		len = 2;
+		break;
+#endif
+#ifdef HW_BREAKPOINT_LEN_4
+	case HW_BREAKPOINT_LEN_4:
+		len = 4;
+		break;
+#endif
+#ifdef HW_BREAKPOINT_LEN_8
+	case HW_BREAKPOINT_LEN_8:
+		len = 8;
+		break;
+#endif
+	default:
+		return rc;
+	}
+
+	/* Check that the low-order bits of the address are appropriate
+	 * for the alignment implied by len.
+	 */
+	if (bp->address.va & (len - 1))
+		return rc;
+
+	/* Check that the virtual address is in the proper range */
+	if (tsk) {
+		if (!arch_check_va_in_userspace(bp->address.va, tsk))
+			return rc;
+	} else {
+		if (!arch_check_va_in_kernelspace(bp->address.va))
+			return rc;
+	}
+
+	if (bp->triggered)
+		rc = 0;
+	return rc;
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
+	pos = insert_bp_in_list(bp, thbi, tsk);
+	arch_register_user_hw_breakpoint(bp, thbi);
+
+	/* Update and rebalance the priorities.  We don't need to go through
+	 * the list of all threads; adding a breakpoint can only cause the
+	 * priorities for this thread to increase.
+	 */
+	accum_thread_tprio(thbi);
+	balance_kernel_vs_user();
+
+	/* Did bp get allocated to a debug register?  We can tell from its
+	 * position in the list.  The number of registers allocated to
+	 * kernel breakpoints is num_kbps; all the others are available for
+	 * user breakpoints.  If bp's position in the priority-ordered list
+	 * is low enough, it will get a register.
+	 */
+	if (pos < HB_NUM - cur_kbpdata->num_kbps) {
+		rc = 1;
+
+		/* Does it need to be installed right now? */
+		if (tsk == current)
+			switch_to_thread_hw_breakpoint(tsk);
+		/* Otherwise it will get installed the next time tsk runs */
+	}
+
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
+
+	if (!bp->status)
+		return;		/* Not registered */
+
+	/* Remove bp from the thread's list and update the DR7 value */
+	remove_bp_from_list(bp, thbi, tsk);
+	arch_unregister_user_hw_breakpoint(bp, thbi);
+
+	/* Recalculate and rebalance the kernel-vs-user priorities,
+	 * and actually uninstall bp if necessary.
+	 */
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
+	arch_register_kernel_hw_breakpoint(bp);
+
+	/* Rebalance the priorities.  This will install bp if it
+	 * was allocated a debug register.
+	 */
+	balance_kernel_vs_user();
+
+	/* Did bp get allocated to a debug register?  We can tell from its
+	 * position in the list.  The number of registers allocated to
+	 * kernel breakpoints is num_kbps; all the others are available for
+	 * user breakpoints.  If bp's position in the priority-ordered list
+	 * is low enough, it will get a register.
+	 */
+	if (pos < cur_kbpdata->num_kbps)
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
+	arch_unregister_kernel_hw_breakpoint(bp);
+
+	/* Rebalance the priorities.  This will uninstall bp if it
+	 * was allocated a debug register.
+	 */
+	balance_kernel_vs_user();
+
+	mutex_unlock(&hw_breakpoint_mutex);
+}
+EXPORT_SYMBOL_GPL(unregister_kernel_hw_breakpoint);

---1559625215-1840843770-1182285329=:2624
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=bptest
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L0.0706191635290.2624@iolanthe.rowland.org>
Content-Description: 
Content-Disposition: attachment; filename=bptest

SW5kZXg6IHVzYi0yLjYvYnB0ZXN0L01ha2VmaWxlDQo9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09DQotLS0gL2Rldi9udWxsDQorKysgdXNiLTIuNi9icHRlc3Qv
TWFrZWZpbGUNCkBAIC0wLDAgKzEgQEANCitvYmotbQkrPSBicHRlc3Qubw0K
SW5kZXg6IHVzYi0yLjYvYnB0ZXN0L2JwdGVzdC5jDQo9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09DQotLS0gL2Rldi9udWxsDQorKysgdXNiLTIuNi9icHRlc3Qv
YnB0ZXN0LmMNCkBAIC0wLDAgKzEsNDYwIEBADQorLyoNCisgKiBUZXN0IGRy
aXZlciBmb3IgaGFyZHdhcmUgYnJlYWtwb2ludHMuDQorICoNCisgKiBDb3B5
cmlnaHQgKEMpIDIwMDcgQWxhbiBTdGVybiA8c3Rlcm5Acm93bGFuZC5oYXJ2
YXJkLmVkdT4NCisgKi8NCisNCisvKg0KKyAqIFdoZW4gdGhpcyBkcml2ZXIg
aXMgbG9hZGVkLCBpdCB3aWxsIGNyZWF0ZSBzZXZlcmFsIGF0dHJpYnV0ZSBm
aWxlcw0KKyAqIHVuZGVyIC9zeXMvYnVzL3BsYXRmb3JtL2RyaXZlcnMvYnB0
ZXN0Og0KKyAqDQorICoJIGNhbGwsIHJlYWQsIHdyaXRlLCBhbmQgYnAwLC4u
LiwgYnAzLg0KKyAqDQorICogSXQgYWxzbyBhbGxvY2F0ZXMgYSAzMi1ieXRl
IGFycmF5IChjYWxsZWQgImJ5dGVzIikgZm9yIHRlc3RpbmcgZGF0YQ0KKyAq
IGJyZWFrcG9pbnRzLCBhbmQgaXQgY29udGFpbnMgZm91ciBkby1ub3RoaW5n
IHJvdXRpbmVzLCByMCgpLC4uLiwgcjMoKSwNCisgKiBmb3IgdGVzdGluZyBl
eGVjdXRpb24gYnJlYWtwb2ludHMuDQorICoNCisgKiBXcml0aW5nIHRvIHRo
ZSAiY2FsbCIgYXR0cmlidXRlIGNhdXNlcyB0aGUgck4gcm91dGluZXMgdG8g
YmUgY2FsbGVkOw0KKyAqICJlY2hvID5jYWxsIE4iIHdpbGwgY2FsbCByTigp
LCB3aGVyZSBOIGlzIDAsIDEsIDIsIG9yIDMuICBTaW1pbGFybHksDQorICog
ImVjaG8gPmNhbGwiIHdpbGwgY2FsbCBhbGwgZm91ciByb3V0aW5lcy4NCisg
Kg0KKyAqIFRoZSBieXRlIGFycmF5IGNhbiBiZSBhY2Nlc3NlZCB0aHJvdWdo
IHRoZSAicmVhZCIgYW5kICJ3cml0ZSINCisgKiBhdHRyaWJ1dGVzLiAgImVj
aG8gPnJlYWQgTiIgd2lsbCByZWFkIGJ5dGVzW05dLCBhbmQgImVjaG8gPndy
aXRlIE4gViINCisgKiB3aWxsIHN0b3JlIFYgaW4gYnl0ZXNbTl0sIHdoZXJl
IE4gaXMgYmV0d2VlbiAwIGFuZCAzMS4gIFRoZXJlIGFyZQ0KKyAqIG5vIHBy
b3Zpc2lvbiBmb3IgbXVsdGktYnl0ZSBhY2Nlc3NlczsgdGhleSBzaG91bGRu
J3QgYmUgbmVlZGVkIGZvcg0KKyAqIHNpbXBsZSB0ZXN0aW5nLg0KKyAqDQor
ICogVGhlIGRyaXZlciBjb250YWlucyBmb3VyIGh3X2JyZWFrcG9pbnQgc3Ry
dWN0dXJlcywgd2hpY2ggY2FuIGJlDQorICogYWNjZXNzZWQgdGhyb3VnaCB0
aGUgImJwTiIgYXR0cmlidXRlcy4gIFJlYWRpbmcgdGhlIGF0dHJpYnV0ZSBm
aWxlDQorICogd2lsbCB5aWVsZCB0aGUgaHdfYnJlYWtwb2ludCdzIGN1cnJl
bnQgc2V0dGluZ3MuICBUaGUgc2V0dGluZ3MgY2FuIGJlDQorICogYWx0ZXJl
ZCBieSB3cml0aW5nIHRoZSBhdHRyaWJ1dGUuICBUaGUgZm9ybWF0IHRvIHVz
ZSBpczoNCisgKg0KKyAqCWVjaG8gPmJwTiBwcmlvcml0eSB0eXBlIGFkZHJl
c3MgW2xlbl0NCisgKg0KKyAqIHByaW9yaXR5IG11c3QgYmUgYSBudW1iZXIg
YmV0d2VlbiAwIGFuZCAyNTUuICB0eXBlIG11c3QgYmUgb25lIG9mICdlJw0K
KyAqIChleGVjdXRpb24pLCAncicgKHJlYWQpLCAndycgKHdyaXRlKSwgb3Ig
J2InIChib3RoIHJlYWQvd3JpdGUpLg0KKyAqIGFkZHJlc3MgbXVzdCBiZSBh
IG51bWJlciBiZXR3ZWVuIDAgYW5kIDMxOyBpZiB0eXBlIGlzICdlJyB0aGVu
IGFkZHJlc3MNCisgKiBtdXN0IGJlIGJldHdlZW4gMCBhbmQgMy4gIGxlbiBt
dXN0IDEsIDIsIDQsIG9yIDgsIGJ1dCBpZiB0eXBlIGlzICdlJw0KKyAqIHRo
ZW4gbGVuIGlzIG9wdGlvbmFsIGFuZCBpZ25vcmVkLg0KKyAqDQorICogRXhl
Y3V0aW9uIGJyZWFrcG9pbnRzIGFyZSBzZXQgb24gdGhlIHJOIHJvdXRpbmUg
YW5kIGRhdGEgYnJlYWtwb2ludHMNCisgKiBhcmUgc2V0IG9uIGJ5dGVzW05d
LCB3aGVyZSBOIGlzIHRoZSBhZGRyZXNzIHZhbHVlLiAgWW91IGNhbiB1bnJl
Z2lzdGVyDQorICogYSBicmVha3BvaW50IGJ5IGRvaW5nICJlY2hvID5icE4g
dSIsIHdoZXJlICd1JyBpcyBhbnkgbm9uLWRpZ2l0Lg0KKyAqDQorICogKE5v
dGU6IE9uIGkzODYgY2VydGFpbiB2YWx1ZXMgYXJlIG5vdCBpbXBsZW1lbnRl
ZC4gIGxlbiBjYW5ub3QgYmUgc2V0DQorICogdG8gOCBhbmQgdHlwZSBjYW5u
b3QgYmUgc2V0IHRvICdyJy4pDQorICoNCisgKiBUaGUgZHJpdmVyIHByaW50
cyBsb3RzIG9mIGluZm9ybWF0aW9uIHRvIHRoZSBzeXN0ZW0gbG9nIGFzIGl0
IHJ1bnMuDQorICogVG8gYmVzdCBzZWUgdGhpbmdzIGFzIHRoZXkgaGFwcGVu
LCB1c2UgYSBWVCBjb25zb2xlIGFuZCBzZXQgdGhlDQorICogbG9nZ2luZyBs
ZXZlbCBoaWdoIChJIHVzZSBBbHQtU3lzUnEtOSkuDQorICovDQorDQorDQor
I2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPg0KKyNpbmNsdWRlIDxsaW51eC9w
bGF0Zm9ybV9kZXZpY2UuaD4NCisjaW5jbHVkZSA8YXNtL2h3X2JyZWFrcG9p
bnQuaD4NCisNCitNT0RVTEVfQVVUSE9SKCJBbGFuIFN0ZXJuIDxzdGVybkBy
b3dsYW5kLmhhcnZhcmQuZWR1PiIpOw0KK01PRFVMRV9ERVNDUklQVElPTigi
SGFyZHdhcmUgQnJlYWtwb2ludCB0ZXN0IGRyaXZlciIpOw0KK01PRFVMRV9M
SUNFTlNFKCJHUEwiKTsNCisNCisNCitzdGF0aWMgc3RydWN0IGh3X2JyZWFr
cG9pbnQgYnBzWzRdOw0KKw0KKyNkZWZpbmUgTlVNX0JZVEVTCTMyDQorc3Rh
dGljIHVuc2lnbmVkIGNoYXIgYnl0ZXNbTlVNX0JZVEVTXSBfX2F0dHJpYnV0
ZV9fKChhbGlnbmVkKDgpKSk7DQorDQorLyogV3JpdGUgbiB0byByZWFkIGJ5
dGVzW25dICovDQorc3RhdGljIHNzaXplX3QgcmVhZF9zdG9yZShzdHJ1Y3Qg
ZGV2aWNlX2RyaXZlciAqZCwgY29uc3QgY2hhciAqYnVmLA0KKwkJc2l6ZV90
IGNvdW50KQ0KK3sNCisJaW50IG4gPSAtMTsNCisNCisJaWYgKHNzY2FuZihi
dWYsICIlZCIsICZuKSA8IDEgfHwgbiA8IDAgfHwgbiA+PSBOVU1fQllURVMp
IHsNCisJCXByaW50ayhLRVJOX1dBUk5JTkcgImJwdGVzdDogcmVhZDogaW52
YWxpZCBpbmRleCAlZFxuIiwgbik7DQorCQlyZXR1cm4gLUVJTlZBTDsNCisJ
fQ0KKwlwcmludGsoS0VSTl9JTkZPICJicHRlc3Q6IHJlYWQ6IGJ5dGVzWyVk
XSA9ICVkXG4iLCBuLCBieXRlc1tuXSk7DQorCXJldHVybiBjb3VudDsNCit9
DQorc3RhdGljIERSSVZFUl9BVFRSKHJlYWQsIDAyMDAsIE5VTEwsIHJlYWRf
c3RvcmUpOw0KKw0KKy8qIFdyaXRlIG4gdiB0byBzZXQgYnl0ZXNbbl0gPSB2
ICovDQorc3RhdGljIHNzaXplX3Qgd3JpdGVfc3RvcmUoc3RydWN0IGRldmlj
ZV9kcml2ZXIgKmQsIGNvbnN0IGNoYXIgKmJ1ZiwNCisJCXNpemVfdCBjb3Vu
dCkNCit7DQorCWludCBuID0gLTE7DQorCWludCB2Ow0KKw0KKwlpZiAoc3Nj
YW5mKGJ1ZiwgIiVkICVkIiwgJm4sICZ2KSA8IDIgfHwgbiA8IDAgfHwgbiA+
PSBOVU1fQllURVMpIHsNCisJCXByaW50ayhLRVJOX1dBUk5JTkcgImJwdGVz
dDogd3JpdGU6IGludmFsaWQgaW5kZXggJWRcbiIsIG4pOw0KKwkJcmV0dXJu
IC1FSU5WQUw7DQorCX0NCisJYnl0ZXNbbl0gPSB2Ow0KKwlwcmludGsoS0VS
Tl9JTkZPICJicHRlc3Q6IHdyaXRlOiBieXRlc1slZF0gPC0gJWRcbiIsIG4s
IHYpOw0KKwlyZXR1cm4gY291bnQ7DQorfQ0KK3N0YXRpYyBEUklWRVJfQVRU
Uih3cml0ZSwgMDIwMCwgTlVMTCwgd3JpdGVfc3RvcmUpOw0KKw0KKw0KKy8q
IER1bW15IHJvdXRpbmVzIGZvciB0ZXN0aW5nIGluc3RydWN0aW9uIGJyZWFr
cG9pbnRzICovDQorc3RhdGljIHZvaWQgcjAodm9pZCkNCit7DQorCXByaW50
ayhLRVJOX0lORk8gIlRoaXMgaXMgciVkXG4iLCAwKTsNCit9DQorc3RhdGlj
IHZvaWQgcjEodm9pZCkNCit7DQorCXByaW50ayhLRVJOX0lORk8gIlRoaXMg
aXMgciVkXG4iLCAxKTsNCit9DQorc3RhdGljIHZvaWQgcjIodm9pZCkNCit7
DQorCXByaW50ayhLRVJOX0lORk8gIlRoaXMgaXMgciVkXG4iLCAyKTsNCit9
DQorc3RhdGljIHZvaWQgcjModm9pZCkNCit7DQorCXByaW50ayhLRVJOX0lO
Rk8gIlRoaXMgaXMgciVkXG4iLCAzKTsNCit9DQorDQorc3RhdGljIHZvaWQg
KCpydG5zW10pKHZvaWQpID0gew0KKwlyMCwgcjEsIHIyLCByMw0KK307DQor
DQorDQorLyogV3JpdGUgbiB0byBjYWxsIHJvdXRpbmUgciMjbiwgb3IgYSBi
bGFuayBsaW5lIHRvIGNhbGwgdGhlbSBhbGwgKi8NCitzdGF0aWMgc3NpemVf
dCBjYWxsX3N0b3JlKHN0cnVjdCBkZXZpY2VfZHJpdmVyICpkLCBjb25zdCBj
aGFyICpidWYsDQorCQlzaXplX3QgY291bnQpDQorew0KKwlpbnQgbjsNCisN
CisJaWYgKHNzY2FuZihidWYsICIlZCIsICZuKSA9PSAwKSB7DQorCQlwcmlu
dGsoS0VSTl9JTkZPICJicHRlc3Q6IGNhbGwgYWxsIHJvdXRpbmVzXG4iKTsN
CisJCXIwKCk7DQorCQlyMSgpOw0KKwkJcjIoKTsNCisJCXIzKCk7DQorCX0g
ZWxzZSBpZiAobiA+PSAwICYmIG4gPCA0KSB7DQorCQlwcmludGsoS0VSTl9J
TkZPICJicHRlc3Q6IGNhbGwgciVkXG4iLCBuKTsNCisJCXJ0bnNbbl0oKTsN
CisJfSBlbHNlIHsNCisJCXByaW50ayhLRVJOX1dBUk5JTkcgImJwdGVzdDog
Y2FsbDogaW52YWxpZCBpbmRleDogJWRcbiIsIG4pOw0KKwkJY291bnQgPSAt
RUlOVkFMOw0KKwl9DQorCXJldHVybiBjb3VudDsNCit9DQorc3RhdGljIERS
SVZFUl9BVFRSKGNhbGwsIDAyMDAsIE5VTEwsIGNhbGxfc3RvcmUpOw0KKw0K
Kw0KKy8qIEJyZWFrcG9pbnQgY2FsbGJhY2tzICovDQorc3RhdGljIHZvaWQg
YnB0ZXN0X3RyaWdnZXJlZChzdHJ1Y3QgaHdfYnJlYWtwb2ludCAqYnAsIHN0
cnVjdCBwdF9yZWdzICpyZWdzKQ0KK3sNCisJcHJpbnRrKEtFUk5fSU5GTyAi
QnJlYWtwb2ludCAlZCB0cmlnZ2VyZWRcbiIsIGJwIC0gYnBzKTsNCit9DQor
DQorc3RhdGljIHZvaWQgYnB0ZXN0X2luc3RhbGxlZChzdHJ1Y3QgaHdfYnJl
YWtwb2ludCAqYnApDQorew0KKwlwcmludGsoS0VSTl9JTkZPICJCcmVha3Bv
aW50ICVkIGluc3RhbGxlZFxuIiwgYnAgLSBicHMpOw0KK30NCisNCitzdGF0
aWMgdm9pZCBicHRlc3RfdW5pbnN0YWxsZWQoc3RydWN0IGh3X2JyZWFrcG9p
bnQgKmJwKQ0KK3sNCisJcHJpbnRrKEtFUk5fSU5GTyAiQnJlYWtwb2ludCAl
ZCB1bmluc3RhbGxlZFxuIiwgYnAgLSBicHMpOw0KK30NCisNCisNCisvKiBC
cmVha3BvaW50IGF0dHJpYnV0ZSBmaWxlcyBmb3IgdGVzdGluZyAqLw0KK3N0
YXRpYyBzc2l6ZV90IGJwX3Nob3coaW50IG4sIGNoYXIgKmJ1ZikNCit7DQor
CXN0cnVjdCBod19icmVha3BvaW50ICpicCA9ICZicHNbbl07DQorCWludCBh
LCBsZW4sIHR5cGU7DQorDQorCWlmICghYnAtPnN0YXR1cykNCisJCXJldHVy
biBzcHJpbnRmKGJ1ZiwgImJwJWQ6IHVucmVnaXN0ZXJlZFxuIiwgbik7DQor
DQorCWxlbiA9IC0xOw0KKwlzd2l0Y2ggKGh3X2JyZWFrcG9pbnRfZ2V0X2xl
bihicCkpIHsNCisjaWZkZWYgSFdfQlJFQUtQT0lOVF9MRU5fMQ0KKwljYXNl
IEhXX0JSRUFLUE9JTlRfTEVOXzE6CWxlbiA9IDE7CWJyZWFrOw0KKyNlbmRp
Zg0KKyNpZmRlZiBIV19CUkVBS1BPSU5UX0xFTl8yDQorCWNhc2UgSFdfQlJF
QUtQT0lOVF9MRU5fMjoJbGVuID0gMjsJYnJlYWs7DQorI2VuZGlmDQorI2lm
ZGVmIEhXX0JSRUFLUE9JTlRfTEVOXzQNCisJY2FzZSBIV19CUkVBS1BPSU5U
X0xFTl80OglsZW4gPSA0OwlicmVhazsNCisjZW5kaWYNCisjaWZkZWYgSFdf
QlJFQUtQT0lOVF9MRU5fOA0KKwljYXNlIEhXX0JSRUFLUE9JTlRfTEVOXzg6
CWxlbiA9IDg7CWJyZWFrOw0KKyNlbmRpZg0KKwl9DQorDQorCXR5cGUgPSAn
Pyc7DQorCXN3aXRjaCAoaHdfYnJlYWtwb2ludF9nZXRfdHlwZShicCkpIHsN
CisjaWZkZWYgSFdfQlJFQUtQT0lOVF9SRUFEDQorCWNhc2UgSFdfQlJFQUtQ
T0lOVF9SRUFEOgl0eXBlID0gJ3InOwlicmVhazsNCisjZW5kaWYNCisjaWZk
ZWYgSFdfQlJFQUtQT0lOVF9XUklURQ0KKwljYXNlIEhXX0JSRUFLUE9JTlRf
V1JJVEU6CXR5cGUgPSAndyc7CWJyZWFrOw0KKyNlbmRpZg0KKyNpZmRlZiBI
V19CUkVBS1BPSU5UX1JXDQorCWNhc2UgSFdfQlJFQUtQT0lOVF9SVzoJCXR5
cGUgPSAnYic7CWJyZWFrOw0KKyNlbmRpZg0KKyNpZmRlZiBIV19CUkVBS1BP
SU5UX0VYRUNVVEUNCisJY2FzZSBIV19CUkVBS1BPSU5UX0VYRUNVVEU6CXR5
cGUgPSAnZSc7CWJyZWFrOw0KKyNlbmRpZg0KKwl9DQorDQorCWEgPSAtMTsN
CisJaWYgKHR5cGUgPT0gJ2UnKSB7DQorCQljb25zdCB2b2lkICphZGRyID0g
aHdfYnJlYWtwb2ludF9nZXRfa2FkZHIoYnApOw0KKw0KKwkJaWYgKGFkZHIg
PT0gcjApDQorCQkJYSA9IDA7DQorCQllbHNlIGlmIChhZGRyID09IHIxKQ0K
KwkJCWEgPSAxOw0KKwkJZWxzZSBpZiAoYWRkciA9PSByMikNCisJCQlhID0g
MjsNCisJCWVsc2UgaWYgKGFkZHIgPT0gcjMpDQorCQkJYSA9IDM7DQorCX0g
ZWxzZSB7DQorCQljb25zdCB1bnNpZ25lZCBjaGFyICpwID0gaHdfYnJlYWtw
b2ludF9nZXRfa2FkZHIoYnApOw0KKw0KKwkJaWYgKHAgPj0gYnl0ZXMgJiYg
cCA8IGJ5dGVzICsgTlVNX0JZVEVTKQ0KKwkJCWEgPSBwIC0gYnl0ZXM7DQor
CX0NCisNCisJcmV0dXJuIHNwcmludGYoYnVmLCAiYnAlZDogJWQgJWMgJWQg
JWQgWyVzaW5zdGFsbGVkXVxuIiwNCisJCQluLCBicC0+cHJpb3JpdHksIHR5
cGUsIGEsIGxlbiwNCisJCQkoYnAtPnN0YXR1cyA8IEhXX0JSRUFLUE9JTlRf
SU5TVEFMTEVEID8gIm5vdCAiIDogIiIpKTsNCit9DQorDQorc3RhdGljIHNz
aXplX3QgYnBfc3RvcmUoaW50IG4sIGNvbnN0IGNoYXIgKmJ1Ziwgc2l6ZV90
IGNvdW50KQ0KK3sNCisJc3RydWN0IGh3X2JyZWFrcG9pbnQgKmJwID0gJmJw
c1tuXTsNCisJaW50IHByaW8sIGEsIGFsZW47DQorCWNoYXIgYXR5cGU7DQor
CXVuc2lnbmVkIGxlbiwgdHlwZTsNCisJaW50IGk7DQorDQorCWlmIChjb3Vu
dCA8PSAxKSB7DQorCQlwcmludGsoS0VSTl9JTkZPICJicHRlc3Q6IGJwJWQ6
IGZvcm1hdDogIHByaW9yaXR5IHR5cGUgIg0KKwkJCQkiYWRkcmVzcyBsZW5c
biIsIG4pOw0KKwkJcHJpbnRrKEtFUk5fSU5GTyAiICB0eXBlID0gciwgdywg
Yiwgb3IgZTsgYWRkcmVzcyA9IDAgLSAzMTsgIg0KKwkJCQkibGVuID0gMSwg
MiwgNCwgb3IgOFxuIik7DQorCQlwcmludGsoS0VSTl9JTkZPICIgIFdyaXRl
IGFueSBub24tZGlnaXQgdG8gdW5yZWdpc3RlclxuIik7DQorCQlyZXR1cm4g
Y291bnQ7DQorCX0NCisNCisJdW5yZWdpc3Rlcl9rZXJuZWxfaHdfYnJlYWtw
b2ludChicCk7DQorCXByaW50ayhLRVJOX0lORk8gImJwdGVzdDogYnAlZCB1
bnJlZ2lzdGVyZWRcbiIsIG4pOw0KKw0KKwlhbGVuID0gLTE7DQorCWkgPSBz
c2NhbmYoYnVmLCAiJWQgJWMgJWQgJWQiLCAmcHJpbywgJmF0eXBlLCAmYSwg
JmFsZW4pOw0KKwlpZiAoaSA9PSAwKQ0KKwkJcmV0dXJuIGNvdW50Ow0KKwlp
ZiAoaSA8IDMpIHsNCisJCXByaW50ayhLRVJOX1dBUk5JTkcgImJwdGVzdDog
YnAlZDogdG9vIGZldyBmaWVsZHNcbiIsIG4pOw0KKwkJcmV0dXJuIC1FSU5W
QUw7DQorCX0NCisNCisJYnAtPnByaW9yaXR5ID0gcHJpbzsNCisJc3dpdGNo
IChhdHlwZSkgew0KKyNpZmRlZiBIV19CUkVBS1BPSU5UX0VYRUNVVEUNCisJ
Y2FzZSAnZSc6DQorCQl0eXBlID0gSFdfQlJFQUtQT0lOVF9FWEVDVVRFOw0K
KwkJbGVuID0gSFdfQlJFQUtQT0lOVF9MRU5fRVhFQ1VURTsNCisJCWJyZWFr
Ow0KKyNlbmRpZg0KKyNpZmRlZiBIV19CUkVBS1BPSU5UX1JFQUQNCisJY2Fz
ZSAncic6DQorCQl0eXBlID0gSFdfQlJFQUtQT0lOVF9SRUFEOw0KKwkJYnJl
YWs7DQorI2VuZGlmDQorI2lmZGVmIEhXX0JSRUFLUE9JTlRfV1JJVEUNCisJ
Y2FzZSAndyc6DQorCQl0eXBlID0gSFdfQlJFQUtQT0lOVF9XUklURTsNCisJ
CWJyZWFrOw0KKyNlbmRpZg0KKyNpZmRlZiBIV19CUkVBS1BPSU5UX1JXDQor
CWNhc2UgJ2InOg0KKwkJdHlwZSA9IEhXX0JSRUFLUE9JTlRfUlc7DQorCQli
cmVhazsNCisjZW5kaWYNCisJZGVmYXVsdDoNCisJCXByaW50ayhLRVJOX1dB
Uk5JTkcgImJwdGVzdDogYnAlZDogaW52YWxpZCB0eXBlICVjXG4iLA0KKwkJ
CQluLCBhdHlwZSk7DQorCQlyZXR1cm4gLUVJTlZBTDsNCisJfQ0KKw0KKwlp
ZiAoYSA8IDAgfHwgYSA+PSBOVU1fQllURVMgfHwgKGEgPj0gNCAmJiBhdHlw
ZSA9PSAnZScpKSB7DQorCQlwcmludGsoS0VSTl9XQVJOSU5HICJicHRlc3Q6
IGJwJWQ6IGludmFsaWQgYWRkcmVzcyAlZFxuIiwNCisJCQkJbiwgYSk7DQor
CQlyZXR1cm4gLUVJTlZBTDsNCisJfQ0KKwlpZiAoYXR5cGUgPT0gJ2UnKQ0K
KwkJaHdfYnJlYWtwb2ludF9raW5pdChicCwgcnRuc1thXSwgbGVuLCB0eXBl
KTsNCisJZWxzZSB7DQorCQlzd2l0Y2ggKGFsZW4pIHsNCisjaWZkZWYgSFdf
QlJFQUtQT0lOVF9MRU5fMQ0KKwkJY2FzZSAxOgkJbGVuID0gSFdfQlJFQUtQ
T0lOVF9MRU5fMTsJYnJlYWs7DQorI2VuZGlmDQorI2lmZGVmIEhXX0JSRUFL
UE9JTlRfTEVOXzINCisJCWNhc2UgMjoJCWxlbiA9IEhXX0JSRUFLUE9JTlRf
TEVOXzI7CWJyZWFrOw0KKyNlbmRpZg0KKyNpZmRlZiBIV19CUkVBS1BPSU5U
X0xFTl80DQorCQljYXNlIDQ6CQlsZW4gPSBIV19CUkVBS1BPSU5UX0xFTl80
OwlicmVhazsNCisjZW5kaWYNCisjaWZkZWYgSFdfQlJFQUtQT0lOVF9MRU5f
OA0KKwkJY2FzZSA4OgkJbGVuID0gSFdfQlJFQUtQT0lOVF9MRU5fODsJYnJl
YWs7DQorI2VuZGlmDQorCQlkZWZhdWx0Og0KKwkJCXByaW50ayhLRVJOX1dB
Uk5JTkcgImJwdGVzdDogYnAlZDogaW52YWxpZCBsZW4gJWRcbiIsDQorCQkJ
CQluLCBhbGVuKTsNCisJCQlyZXR1cm4gLUVJTlZBTDsNCisJCQlicmVhazsN
CisJCX0NCisJCWh3X2JyZWFrcG9pbnRfa2luaXQoYnAsICZieXRlc1thXSwg
bGVuLCB0eXBlKTsNCisJfQ0KKw0KKwlicC0+dHJpZ2dlcmVkID0gYnB0ZXN0
X3RyaWdnZXJlZDsNCisJYnAtPmluc3RhbGxlZCA9IGJwdGVzdF9pbnN0YWxs
ZWQ7DQorCWJwLT51bmluc3RhbGxlZCA9IGJwdGVzdF91bmluc3RhbGxlZDsN
CisNCisJaSA9IHJlZ2lzdGVyX2tlcm5lbF9od19icmVha3BvaW50KGJwKTsN
CisJaWYgKGkgPCAwKSB7DQorCQlwcmludGsoS0VSTl9XQVJOSU5HICJicHRl
c3Q6IGJwJWQ6IGZhaWxlZCB0byByZWdpc3RlciAlZFxuIiwNCisJCQkJbiwg
aSk7DQorCQljb3VudCA9IGk7DQorCX0gZWxzZQ0KKwkJcHJpbnRrKEtFUk5f
SU5GTyAiYnB0ZXN0OiBicCVkIHJlZ2lzdGVyZWQ6ICVkXG4iLCBuLCBpKTsN
CisJcmV0dXJuIGNvdW50Ow0KK30NCisNCisNCitzdGF0aWMgc3NpemVfdCBi
cDBfc2hvdyhzdHJ1Y3QgZGV2aWNlX2RyaXZlciAqZCwgY2hhciAqYnVmKQ0K
K3sNCisJcmV0dXJuIGJwX3Nob3coMCwgYnVmKTsNCit9DQorc3RhdGljIHNz
aXplX3QgYnAwX3N0b3JlKHN0cnVjdCBkZXZpY2VfZHJpdmVyICpkLCBjb25z
dCBjaGFyICpidWYsDQorCQlzaXplX3QgY291bnQpDQorew0KKwlyZXR1cm4g
YnBfc3RvcmUoMCwgYnVmLCBjb3VudCk7DQorfQ0KK3N0YXRpYyBEUklWRVJf
QVRUUihicDAsIDA2MDAsIGJwMF9zaG93LCBicDBfc3RvcmUpOw0KKw0KK3N0
YXRpYyBzc2l6ZV90IGJwMV9zaG93KHN0cnVjdCBkZXZpY2VfZHJpdmVyICpk
LCBjaGFyICpidWYpDQorew0KKwlyZXR1cm4gYnBfc2hvdygxLCBidWYpOw0K
K30NCitzdGF0aWMgc3NpemVfdCBicDFfc3RvcmUoc3RydWN0IGRldmljZV9k
cml2ZXIgKmQsIGNvbnN0IGNoYXIgKmJ1ZiwNCisJCXNpemVfdCBjb3VudCkN
Cit7DQorCXJldHVybiBicF9zdG9yZSgxLCBidWYsIGNvdW50KTsNCit9DQor
c3RhdGljIERSSVZFUl9BVFRSKGJwMSwgMDYwMCwgYnAxX3Nob3csIGJwMV9z
dG9yZSk7DQorDQorc3RhdGljIHNzaXplX3QgYnAyX3Nob3coc3RydWN0IGRl
dmljZV9kcml2ZXIgKmQsIGNoYXIgKmJ1ZikNCit7DQorCXJldHVybiBicF9z
aG93KDIsIGJ1Zik7DQorfQ0KK3N0YXRpYyBzc2l6ZV90IGJwMl9zdG9yZShz
dHJ1Y3QgZGV2aWNlX2RyaXZlciAqZCwgY29uc3QgY2hhciAqYnVmLA0KKwkJ
c2l6ZV90IGNvdW50KQ0KK3sNCisJcmV0dXJuIGJwX3N0b3JlKDIsIGJ1Ziwg
Y291bnQpOw0KK30NCitzdGF0aWMgRFJJVkVSX0FUVFIoYnAyLCAwNjAwLCBi
cDJfc2hvdywgYnAyX3N0b3JlKTsNCisNCitzdGF0aWMgc3NpemVfdCBicDNf
c2hvdyhzdHJ1Y3QgZGV2aWNlX2RyaXZlciAqZCwgY2hhciAqYnVmKQ0KK3sN
CisJcmV0dXJuIGJwX3Nob3coMywgYnVmKTsNCit9DQorc3RhdGljIHNzaXpl
X3QgYnAzX3N0b3JlKHN0cnVjdCBkZXZpY2VfZHJpdmVyICpkLCBjb25zdCBj
aGFyICpidWYsDQorCQlzaXplX3QgY291bnQpDQorew0KKwlyZXR1cm4gYnBf
c3RvcmUoMywgYnVmLCBjb3VudCk7DQorfQ0KK3N0YXRpYyBEUklWRVJfQVRU
UihicDMsIDA2MDAsIGJwM19zaG93LCBicDNfc3RvcmUpOw0KKw0KKw0KK3N0
YXRpYyBpbnQgYnB0ZXN0X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2Ug
KnBkZXYpDQorew0KKwlyZXR1cm4gLUVOT0RFVjsNCit9DQorDQorc3RhdGlj
IGludCBicHRlc3RfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBk
ZXYpDQorew0KKwlyZXR1cm4gMDsNCit9DQorDQorc3RhdGljIHN0cnVjdCBw
bGF0Zm9ybV9kcml2ZXIgYnB0ZXN0X2RyaXZlciA9IHsNCisJLnByb2JlID0g
YnB0ZXN0X3Byb2JlLA0KKwkucmVtb3ZlID0gYnB0ZXN0X3JlbW92ZSwNCisJ
LmRyaXZlciA9IHsNCisJCS5uYW1lID0gImJwdGVzdCIsDQorCQkub3duZXIg
PSBUSElTX01PRFVMRSwNCisJfQ0KK307DQorDQorDQorc3RhdGljIHN0cnVj
dCBkcml2ZXJfYXR0cmlidXRlICooYnB0ZXN0X2dyb3VwW10pID0gew0KKwkm
ZHJpdmVyX2F0dHJfYnAwLA0KKwkmZHJpdmVyX2F0dHJfYnAxLA0KKwkmZHJp
dmVyX2F0dHJfYnAyLA0KKwkmZHJpdmVyX2F0dHJfYnAzLA0KKwkmZHJpdmVy
X2F0dHJfY2FsbCwNCisJJmRyaXZlcl9hdHRyX3JlYWQsDQorCSZkcml2ZXJf
YXR0cl93cml0ZSwNCisJTlVMTA0KK307DQorDQorc3RhdGljIGludCBhZGRf
ZmlsZXModm9pZCkNCit7DQorCWludCByYyA9IDA7DQorCXN0cnVjdCBkcml2
ZXJfYXR0cmlidXRlICoqZzsNCisNCisJZm9yIChnID0gYnB0ZXN0X2dyb3Vw
OyAqZzsgKytnKSB7DQorCQlyYyA9IGRyaXZlcl9jcmVhdGVfZmlsZSgmYnB0
ZXN0X2RyaXZlci5kcml2ZXIsICpnKTsNCisJCWlmIChyYykNCisJCQlicmVh
azsNCisJfQ0KKwlyZXR1cm4gcmM7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIHJl
bW92ZV9maWxlcyh2b2lkKQ0KK3sNCisJc3RydWN0IGRyaXZlcl9hdHRyaWJ1
dGUgKipnOw0KKw0KKwlmb3IgKGcgPSBicHRlc3RfZ3JvdXA7ICpnOyArK2cp
DQorCQlkcml2ZXJfcmVtb3ZlX2ZpbGUoJmJwdGVzdF9kcml2ZXIuZHJpdmVy
LCAqZyk7DQorfQ0KKw0KK3N0YXRpYyBpbnQgX19pbml0IGJwdGVzdF9pbml0
KHZvaWQpDQorew0KKwlpbnQgcmM7DQorDQorCXJjID0gcGxhdGZvcm1fZHJp
dmVyX3JlZ2lzdGVyKCZicHRlc3RfZHJpdmVyKTsNCisJaWYgKHJjKSB7DQor
CQlwcmludGsoS0VSTl9FUlIgIkZhaWxlZCB0byByZWdpc3RlciBicHRlc3Qg
ZHJpdmVyOiAlZFxuIiwgcmMpOw0KKwkJcmV0dXJuIHJjOw0KKwl9DQorCXJj
ID0gYWRkX2ZpbGVzKCk7DQorCWlmIChyYykgew0KKwkJcmVtb3ZlX2ZpbGVz
KCk7DQorCQlwbGF0Zm9ybV9kcml2ZXJfdW5yZWdpc3RlcigmYnB0ZXN0X2Ry
aXZlcik7DQorCQlyZXR1cm4gcmM7DQorCX0NCisJcHJpbnRrKCJicHRlc3Qg
bG9hZGVkXG4iKTsNCisJcmV0dXJuIDA7DQorfQ0KKw0KK3N0YXRpYyB2b2lk
IF9fZXhpdCBicHRlc3RfZXhpdCh2b2lkKQ0KK3sNCisJaW50IG47DQorDQor
CXJlbW92ZV9maWxlcygpOw0KKwlmb3IgKG4gPSAwOyBuIDwgNDsgKytuKQ0K
KwkJdW5yZWdpc3Rlcl9rZXJuZWxfaHdfYnJlYWtwb2ludCgmYnBzW25dKTsN
CisJcGxhdGZvcm1fZHJpdmVyX3VucmVnaXN0ZXIoJmJwdGVzdF9kcml2ZXIp
Ow0KKwlwcmludGsoImJwdGVzdCB1bmxvYWRlZFxuIik7DQorfQ0KKw0KK21v
ZHVsZV9pbml0KGJwdGVzdF9pbml0KTsNCittb2R1bGVfZXhpdChicHRlc3Rf
ZXhpdCk7DQo=
---1559625215-1840843770-1182285329=:2624--
