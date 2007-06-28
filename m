Return-Path: <linux-kernel-owner+w=401wt.eu-S1764190AbXF1DDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764190AbXF1DDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763209AbXF1DC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:02:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759831AbXF1DCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:02:55 -0400
Date: Wed, 27 Jun 2007 23:02:53 -0400
Message-Id: <200706280302.l5S32rEL022807@int-mx1.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Tuesday, 26 June 2007 23:26:37 -0400 <Pine.LNX.4.44L0.0706262244100.23864-100000@netrider.rowland.org>
X-Fcc: ~/Mail/utrace
X-Antipastobozoticataclysm: Bariumenemanilow
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I did the first crack at a powerpc port.  I'd appreciate your comments on
this patch.  It should not be incorporated, isn't finished, probably breaks
ptrace, etc.  I'm posting it now just to get any thoughts you have raised
by seeing the second machine share the intended arch-independent code.

I just translated your implementation to powerpc terms without thinking
about it much.  If you see anything that you aren't sure is right, please
tell me and don't presume there is some powerpc-specific reason it's
different.  More likely I just didn't think it through.

In the first battle just to make it compile, the only issue was that you
assume every machine has TIF_DEBUG, which is in fact an implementation
detail chosen lately by i386 and x86_64.  AFAIK the only reason for it
there is just to make a cheap test of multiple bits in the hot path
deciding to call __switch_to_xtra.  Do you rely on it meaning something
more precise than just being a shorthand for hw_breakpoint_info!=NULL?

Incidentally, I think it would be nice if kernel/hw_breakpoint.c itself had
all the #include's for everything it uses directly.  arch hw_breakpoint.c
files probably only need <asm/hw_breakpoint.h> and one or two others to
define what they need before #include "../../../kernel/hw_breakpoint.c".

The num_installed/num_kbps stuff feels a little hokey when it's really a
flag because the maximum number is one.  It seems like I could make it
tighter with some more finesse in the arch-specific hook options, so that
chbi and thbi each just store dabr, dabr!=0 means "mine gets installed",
and the switch in is just chbi->dabr?:thbi->dabr or something like that.
As we get more machines, more cleanups along these lines will probably make
sense.  (Also, before the next person not me or you tries a port, we could
use for the generic hw_breakpoint.c to get some comments at the top making
explicit what the arch file is expected to define in its types, etc.)

With just the included change to the generic code for the TIF_DEBUG, this
kind of works.  That is, it doesn't break everything else and I can use
bptest, sort of.  I didn't even try ptrace, I probably broke that.

It works enough to make clear the main new wrinkle.  On powerpc, the data
breakpoint exception is a fault before the instruction executes, not a trap
after it.  The load/store will not complete until the breakpoint is cleared.
With this patch, you can use bptest to generate a tight loop of bp0 triggers.

For ptrace compatibility, userland already expects to deal with this.  gdb
has it as per-machine implementation options how ptrace watchpoints behave,
and for powerpc it knows to remove the watchpoint, step, and reinsert it.

One approach for hw_breakpoint is just to expose in asm/hw_breakpoint.h
some standard macros saying how things behave, and caveat emptor.  But I
don't like that much.  I think things will just wind up being confused and
inadvertently unportable if the important semantics vary too much between
machines.  The point of the whole facility is to make watchpoints easy to
use, after all.

Some uses might be happy with trigger-before, but I don't see much benefit.
For writing, the trigger function can look at the memory before it's
changed.  But you could just as well have recorded the old value before
setting the breakpoint, as you have to for trigger-after--and to see both
old and new values you then need to single-step to get the new value, which
trigger-after handles with a single exception.  For reading, the trigger
function can change the memory before it's read.  But likewise, you could
just as well have changed it before setting the breakpoint--you know noone
will have read the new value until your trigger anyway.  (I have never used
a read-triggered breakpoint, so I'm rather vague on those use scenarios.)

The third machine whose manual I have handy is ia64.  It has instruction
and data breakpoints that are both trigger-before.  It has processor flags
similar to x86's RF for both, to ignore one or both breakpoint flavor for
one instruction.  That makes it cheap to continue past the breakpoint since
you don't have to clear and reset it.  But for getting new values from
data-write breakpoints, it still requires a single-step and second stop,
like powerpc.  (Incidentally ia64 has another interesting feature, which I
think the generic code accomodates nicely as an upward-compatible addition
just by changing the len arg in the register and arch_* calls to unsigned long,
and adding an arch_validate_len that can short-circuit the generic length
and alignment check.)

So, I'd like your thoughts on the whole situation.  The starting point we
can do without anything else is:

	int hw_breakpoint_triggers_before(struct hw_breakpoint *);
	int hw_breakpoint_can_resume(struct hw_breakpoint *);

or perhaps taking (unsigned int type) instead, in <asm-cpu/hw_breakpoint.h>.
i.e. for x86:

#define hw_breakpoint_triggers_before(type) ((type) == HW_BREAKPOINT_EXECUTE)
#define hw_breakpoint_can_resume(type) 	    1

and powerpc:

#define hw_breakpoint_triggers_before(any)	1
#define hw_breakpoint_can_resume(any)		0


For powerpc at least (and I figure for ia64 too) it seems easy enough to
implement disable-step-enable to turn it into trigger-after.  But it is
costly and hairy if one doesn't care.  So now I'm thinking to somewhat
follow the kprobes model, and have pre and post trigger handler options.
i.e.

	int hw_breakpoint_pre_handle_type(unsigned type);
	int hw_breakpoint_post_handle_type(unsigned type);

and in struct hw_breakpoint (replacing trigger):

	int	(*pre_handler)(struct hw_breakpoint *, struct pt_regs *);
	void	(*post_handler)(struct hw_breakpoint *, struct pt_regs *);

The pre_handler returns zero if it wants the post_handler to run.  On x86,
register would return -EINVAL if pre_handler is not NULL and type is not
EXECUTE (i.e. pre_handle_type returns false).  It also fails if
post_handler is not NULL and post_handle_type returns false, meaning the
arch code doesn't want to deal with step-over-and-trigger.

We'd still want hw_breakpoint_can_resume to tell whether you can return
from a pre_handler and continue with no a post_handler, without needing to
unregister the breakpoint.  That's true on ia64, while on powerpc you
either have to clear the breakpoint or request the post_handler stepping logic.


Thanks,
Roland


---
 arch/powerpc/kernel/Makefile        |    2 
 arch/powerpc/kernel/hw_breakpoint.c |  348 ++++++++++++++++++++++++++++++++++++
 arch/powerpc/kernel/process.c       |   14 -
 arch/powerpc/kernel/ptrace-common.h |   16 -
 arch/powerpc/kernel/ptrace.c        |    2 
 arch/powerpc/kernel/ptrace32.c      |    2 
 arch/powerpc/kernel/signal_32.c     |   10 -
 arch/powerpc/kernel/signal_64.c     |    8 
 arch/powerpc/mm/fault.c             |   19 -
 include/asm-powerpc/hw_breakpoint.h |   49 +++++
 include/asm-powerpc/processor.h     |    2 
 kernel/hw_breakpoint.c              |   22 +-
 12 files changed, 438 insertions(+), 56 deletions(-)

Index: b/include/asm-powerpc/hw_breakpoint.h
===================================================================
--- /dev/null
+++ b/include/asm-powerpc/hw_breakpoint.h
@@ -0,0 +1,49 @@
+#ifndef	_ASM_POWERPC_HW_BREAKPOINT_H
+#define	_ASM_POWERPC_HW_BREAKPOINT_H
+
+/*
+ * The only available size of data breakpoint is 8.
+ */
+#define HW_BREAKPOINT_LEN_8	0x0d00dbe8
+
+/*
+ * Available HW breakpoint type encodings.
+ */
+#define HW_BREAKPOINT_READ	0x0dab0005	/* trigger on memory read */
+#define HW_BREAKPOINT_WRITE	0x0dab0006	/* trigger on memory write */
+#define HW_BREAKPOINT_RW	0x0dab0007	/* ... on read or write */
+
+
+struct arch_hw_breakpoint {
+	/*
+	 * High bits are aligned address, low 3 bits are flags.
+	 */
+	unsigned long dabr;
+};
+
+#define	__ARCH_HW_BREAKPOINT_H
+#include <asm-generic/hw_breakpoint.h>
+
+/* HW breakpoint accessor routines */
+static inline const void *hw_breakpoint_get_kaddress(struct hw_breakpoint *bp)
+{
+	return (const void *) (bp->info.dabr &~ 7UL);
+}
+
+static inline const void __user *hw_breakpoint_get_uaddress(
+		struct hw_breakpoint *bp)
+{
+	return (const void __user *) (bp->info.dabr &~ 7UL);
+}
+
+static inline unsigned hw_breakpoint_get_len(struct hw_breakpoint *bp)
+{
+	return HW_BREAKPOINT_LEN_8;
+}
+
+static inline unsigned hw_breakpoint_get_type(struct hw_breakpoint *bp)
+{
+	return (bp->info.dabr & 7UL) | 0x0dab0000;
+}
+
+#endif	/* _ASM_POWERPC_HW_BREAKPOINT_H */
Index: b/arch/powerpc/kernel/Makefile
===================================================================
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -75,6 +75,8 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec.o 
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
+obj64-y				+= hw_breakpoint.o
+
 ifneq ($(CONFIG_PPC_INDIRECT_IO),y)
 obj-y				+= iomap.o
 endif
Index: b/arch/powerpc/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -0,0 +1,348 @@
+/*
+ * HW_breakpoint: a unified kernel/user-space hardware breakpoint facility,
+ * using the CPU's debug registers.
+ */
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
+#include <asm/hw_breakpoint.h>
+
+#define HB_NUM	1
+
+/* Per-thread HW breakpoint and debug register info */
+struct thread_hw_breakpoint {
+
+	struct list_head	node;		/* Entry in thread list */
+	struct list_head	thread_bps;	/* Thread's breakpoints */
+	struct hw_breakpoint	*bps[HB_NUM];	/* Highest-priority bps */
+	int			num_installed;	/* Number of installed bps */
+	unsigned		gennum;		/* update-generation number */
+
+	struct hw_breakpoint	ptrace_bp;
+
+	unsigned long		dabr;		/* Value switched in */
+};
+
+/* Kernel-space breakpoint data */
+struct kernel_bp_data {
+	unsigned		gennum;		/* Generation number */
+	struct hw_breakpoint	*bps[HB_NUM];	/* Loaded breakpoint */
+	int			num_kbps;
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
+/* Arch-specific hook routines */
+
+
+/*
+ * Install the kernel breakpoints in their debug registers.
+ */
+static void arch_install_chbi(struct cpu_hw_breakpoint *chbi)
+{
+	/*
+	 * Don't allow debug exceptions while we update the DABR.
+	 */
+	set_dabr(0);
+
+	chbi->cur_kbpdata = rcu_dereference(cur_kbpdata);
+
+	if (chbi->cur_kbpdata->num_kbps)
+		set_dabr(chbi->cur_kbpdata->bps[0]->info.dabr);
+}
+
+/*
+ * Update an out-of-date thread hw_breakpoint info structure.
+ */
+static void arch_update_thbi(struct thread_hw_breakpoint *thbi,
+			     struct kernel_bp_data *thr_kbpdata)
+{
+}
+
+/*
+ * Install the thread breakpoints in their debug registers.
+ */
+static void arch_install_thbi(struct thread_hw_breakpoint *thbi)
+{
+	if (thbi->dabr)
+		set_dabr(thbi->dabr);
+}
+
+/*
+ * Install the debug register values for just the kernel, no thread.
+ */
+static void arch_install_none(struct cpu_hw_breakpoint *chbi)
+{
+}
+
+/*
+ * Create a new kbpdata entry.
+ */
+static void arch_new_kbpdata(struct kernel_bp_data *new_kbpdata)
+{
+}
+
+/*
+ * Store a thread breakpoint array entry's address
+ */
+static void arch_store_thread_bp_array(struct thread_hw_breakpoint *thbi,
+				       struct hw_breakpoint *bp, int i)
+{
+	thbi->dabr = bp->info.dabr;
+}
+
+#define TASK_SIZE_OF(tsk) \
+	(test_tsk_thread_flag(tsk, TIF_32BIT) \
+	 ? TASK_SIZE_USER32 : TASK_SIZE_USER64)
+
+/*
+ * Check for virtual address in user space.
+ */
+static int arch_check_va_in_userspace(unsigned long va, struct task_struct *tsk)
+{
+	return va < TASK_SIZE_OF(tsk);
+}
+
+/*
+ * Check for virtual address in kernel space.
+ */
+static int arch_check_va_in_kernelspace(unsigned long va)
+{
+	return va >= TASK_SIZE_USER64;
+}
+
+/*
+ * Store a breakpoint's encoded address, length, and type.
+ */
+static void arch_store_info(struct hw_breakpoint *bp,
+			    unsigned long address, unsigned len, unsigned type)
+{
+	BUG_ON(address & 7UL);
+	BUG_ON(!(type & DABR_TRANSLATION));
+	bp->info.dabr = address | (type & 7UL);
+}
+
+
+/*
+ * Register a new user breakpoint structure.
+ */
+static void arch_register_user_hw_breakpoint(struct hw_breakpoint *bp,
+					     struct thread_hw_breakpoint *thbi)
+{
+}
+
+/*
+ * Unregister a user breakpoint structure.
+ */
+static void arch_unregister_user_hw_breakpoint(struct hw_breakpoint *bp,
+		struct thread_hw_breakpoint *thbi)
+{
+}
+
+/*
+ * Register a kernel breakpoint structure.
+ */
+static void arch_register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+{
+}
+
+/*
+ * Unregister a kernel breakpoint structure.
+ */
+static void arch_unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+{
+}
+
+
+/* End of arch-specific hook routines */
+
+
+/*
+ * Ptrace support: breakpoint trigger routine.
+ */
+
+static struct thread_hw_breakpoint *alloc_thread_hw_breakpoint(
+	struct task_struct *tsk);
+static int __register_user_hw_breakpoint(struct task_struct *tsk,
+					 struct hw_breakpoint *bp,
+					 unsigned long address,
+					 unsigned len, unsigned type);
+static void __unregister_user_hw_breakpoint(struct task_struct *tsk,
+					    struct hw_breakpoint *bp);
+
+/*
+ * This is a placeholder that never gets called.
+ */
+static void ptrace_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
+{
+	BUG();
+}
+
+unsigned long thread_get_dabr(struct task_struct *tsk)
+{
+	if (tsk->thread.hw_breakpoint_info)
+		return tsk->thread.hw_breakpoint_info->dabr;
+	return 0;
+}
+
+int thread_set_dabr(struct task_struct *tsk, unsigned long val)
+{
+	unsigned long addr = val &~ 7UL;
+	unsigned int type = 0x0dab0000 | (val & 7UL);
+
+	struct thread_hw_breakpoint *thbi;
+	int rc = -EIO;
+
+	/* We have to hold this lock the entire time, to prevent thbi
+	 * from being deallocated out from under us.
+	 */
+	mutex_lock(&hw_breakpoint_mutex);
+
+	if (!tsk->thread.hw_breakpoint_info && val == 0)
+		rc = 0;		/* Minor optimization */
+	else if ((thbi = alloc_thread_hw_breakpoint(tsk)) == NULL)
+		rc = -ENOMEM;
+	else {
+		struct hw_breakpoint *bp = &thbi->ptrace_bp;
+
+		/*
+		 * If the breakpoint is registered then unregister it,
+		 * change it, and re-register it.  Revert to the original
+		 * address if an error occurs.
+		 */
+		if (bp->status) {
+			unsigned long old_dabr = bp->info.dabr;
+
+			__unregister_user_hw_breakpoint(tsk, bp);
+			if (val != 0) {
+				rc = __register_user_hw_breakpoint(
+					tsk, bp, addr,
+					HW_BREAKPOINT_LEN_8, type);
+				if (rc < 0)
+					__register_user_hw_breakpoint(
+						tsk, bp,
+						old_dabr &~ 7UL,
+						HW_BREAKPOINT_LEN_8,
+						0x0dab0000 | (old_dabr & 7UL));
+			}
+		} else if (val != 0) {
+			bp->triggered = ptrace_triggered;
+			bp->priority = HW_BREAKPOINT_PRIO_PTRACE;
+			rc = __register_user_hw_breakpoint(
+				tsk, bp, addr,
+				HW_BREAKPOINT_LEN_8, type);
+		}
+	}
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
+static int hw_breakpoint_handler(struct die_args *args)
+{
+	struct cpu_hw_breakpoint *chbi;
+	struct hw_breakpoint *bp;
+	struct thread_hw_breakpoint *thbi = NULL;
+	int ret;
+
+	/* Assert that local interrupts are disabled */
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
+	/*
+	 * Disable all breakpoints so that the callbacks can run without
+	 * triggering recursive debug exceptions.
+	 */
+	set_dabr(0);
+
+	bp = chbi->cur_kbpdata->bps[0] ?: thbi->bps[0];
+	ret = NOTIFY_STOP;
+	if (bp == &thbi->ptrace_bp)
+		ret = NOTIFY_DONE;
+	else
+		(*bp->triggered)(bp, args->regs);
+
+	/* Re-enable the breakpoints */
+	set_dabr(thbi ? thbi->dabr : chbi->cur_kbpdata->bps[0]->info.dabr);
+	put_cpu_no_resched();
+
+	return NOTIFY_STOP;
+}
+
+/*
+ * Handle debug exception notifications.
+ */
+static int hw_breakpoint_exceptions_notify(
+	struct notifier_block *unused, unsigned long val, void *data)
+{
+	if (val != DIE_DABR_MATCH)
+		return NOTIFY_DONE;
+	return hw_breakpoint_handler(data);
+}
+
+static struct notifier_block hw_breakpoint_exceptions_nb = {
+	.notifier_call = hw_breakpoint_exceptions_notify
+};
+
+void load_debug_registers(void);
+
+static int __init init_hw_breakpoint(void)
+{
+	printk(KERN_EMERG "hw_breakpoint initializing\n");
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
Index: b/arch/powerpc/kernel/ptrace-common.h
===================================================================
--- a/arch/powerpc/kernel/ptrace-common.h
+++ b/arch/powerpc/kernel/ptrace-common.h
@@ -139,6 +139,10 @@ static inline int set_vrregs(struct task
 }
 #endif
 
+#ifdef CONFIG_PPC64
+unsigned long thread_get_dabr(struct task_struct *tsk);
+int thread_set_dabr(struct task_struct *tsk, unsigned long val);
+
 static inline int ptrace_set_debugreg(struct task_struct *task,
 				      unsigned long addr, unsigned long data)
 {
@@ -146,16 +150,8 @@ static inline int ptrace_set_debugreg(st
 	if (addr > 0)
 		return -EINVAL;
 
-	/* The bottom 3 bits are flags */
-	if ((data & ~0x7UL) >= TASK_SIZE)
-		return -EIO;
-
-	/* Ensure translation is on */
-	if (data && !(data & DABR_TRANSLATION))
-		return -EIO;
-
-	task->thread.dabr = data;
-	return 0;
+	return thread_set_dabr(task, data);
 }
+#endif
 
 #endif /* _PPC64_PTRACE_COMMON_H */
Index: b/arch/powerpc/kernel/ptrace.c
===================================================================
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -390,7 +390,7 @@ long arch_ptrace(struct task_struct *chi
 		/* We only support one DABR and no IABRS at the moment */
 		if (addr > 0)
 			break;
-		ret = put_user(child->thread.dabr,
+		ret = put_user(thread_get_dabr(child),
 			       (unsigned long __user *)data);
 		break;
 	}
Index: b/arch/powerpc/kernel/ptrace32.c
===================================================================
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -330,7 +330,7 @@ long compat_sys_ptrace(int request, int 
 		/* We only support one DABR and no IABRS at the moment */
 		if (addr > 0)
 			break;
-		ret = put_user(child->thread.dabr, (u32 __user *)data);
+		ret = put_user((u32)thread_get_dabr(child), (u32 __user *)data);
 		break;
 	}
 
Index: b/arch/powerpc/kernel/signal_32.c
===================================================================
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1197,16 +1197,6 @@ no_signal:
 		newsp = regs->gpr[1];
 	newsp &= ~0xfUL;
 
-#ifdef CONFIG_PPC64
-	/*
-	 * Reenable the DABR before delivering the signal to
-	 * user space. The DABR will have been cleared if it
-	 * triggered inside the kernel.
-	 */
-	if (current->thread.dabr)
-		set_dabr(current->thread.dabr);
-#endif
-
 	/* Whee!  Actually deliver the signal.  */
 	if (ka.sa.sa_flags & SA_SIGINFO)
 		ret = handle_rt_signal(signr, &ka, &info, oldset, regs, newsp);
Index: b/arch/powerpc/kernel/signal_64.c
===================================================================
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -529,14 +529,6 @@ int do_signal(sigset_t *oldset, struct p
 		if (TRAP(regs) == 0x0C00)
 			syscall_restart(regs, &ka);
 
-		/*
-		 * Reenable the DABR before delivering the signal to
-		 * user space. The DABR will have been cleared if it
-		 * triggered inside the kernel.
-		 */
-		if (current->thread.dabr)
-			set_dabr(current->thread.dabr);
-
 		ret = handle_signal(signr, &ka, &info, oldset, regs);
 
 		/* If a signal was successfully delivered, the saved sigmask is in
Index: b/arch/powerpc/mm/fault.c
===================================================================
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -113,9 +113,6 @@ static void do_dabr(struct pt_regs *regs
 	if (debugger_dabr_match(regs))
 		return;
 
-	/* Clear the DABR */
-	set_dabr(0);
-
 	/* Deliver the signal to userspace */
 	info.si_signo = SIGTRAP;
 	info.si_errno = 0;
@@ -164,6 +161,14 @@ int __kprobes do_page_fault(struct pt_re
 	is_write = error_code & ESR_DST;
 #endif /* CONFIG_4xx || CONFIG_BOOKE */
 
+#if !(defined(CONFIG_4xx) || defined(CONFIG_BOOKE))
+  	if (error_code & DSISR_DABRMATCH) {
+		/* DABR match */
+		do_dabr(regs, address, error_code);
+		return 0;
+	}
+#endif /* !(CONFIG_4xx || CONFIG_BOOKE)*/
+
 	if (notify_page_fault(regs))
 		return 0;
 
@@ -176,14 +181,6 @@ int __kprobes do_page_fault(struct pt_re
 	if (!user_mode(regs) && (address >= TASK_SIZE))
 		return SIGSEGV;
 
-#if !(defined(CONFIG_4xx) || defined(CONFIG_BOOKE))
-  	if (error_code & DSISR_DABRMATCH) {
-		/* DABR match */
-		do_dabr(regs, address, error_code);
-		return 0;
-	}
-#endif /* !(CONFIG_4xx || CONFIG_BOOKE)*/
-
 	if (in_atomic() || mm == NULL) {
 		if (!user_mode(regs))
 			return SIGSEGV;
Index: b/include/asm-powerpc/processor.h
===================================================================
--- a/include/asm-powerpc/processor.h
+++ b/include/asm-powerpc/processor.h
@@ -149,8 +149,8 @@ struct thread_struct {
 #ifdef CONFIG_PPC64
 	unsigned long	start_tb;	/* Start purr when proc switched in */
 	unsigned long	accum_tb;	/* Total accumilated purr for process */
+	struct thread_hw_breakpoint *hw_breakpoint_info;
 #endif
-	unsigned long	dabr;		/* Data address breakpoint register */
 #ifdef CONFIG_ALTIVEC
 	/* Complete AltiVec register set */
 	vector128	vr[32] __attribute((aligned(16)));
Index: b/arch/powerpc/kernel/process.c
===================================================================
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -46,6 +46,7 @@
 #include <asm/syscalls.h>
 #ifdef CONFIG_PPC64
 #include <asm/firmware.h>
+#include <asm/hw_breakpoint.h>
 #endif
 
 extern unsigned long _get_SP(void);
@@ -232,7 +233,6 @@ int set_dabr(unsigned long dabr)
 
 #ifdef CONFIG_PPC64
 DEFINE_PER_CPU(struct cpu_usage, cpu_usage_array);
-static DEFINE_PER_CPU(unsigned long, current_dabr);
 #endif
 
 struct task_struct *__switch_to(struct task_struct *prev,
@@ -300,10 +300,8 @@ struct task_struct *__switch_to(struct t
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_PPC64	/* for now */
-	if (unlikely(__get_cpu_var(current_dabr) != new->thread.dabr)) {
-		set_dabr(new->thread.dabr);
-		__get_cpu_var(current_dabr) = new->thread.dabr;
-	}
+	if (unlikely(new->thread.hw_breakpoint_info != NULL))
+		switch_to_thread_hw_breakpoint(new);
 #endif /* CONFIG_PPC64 */
 
 	new_thread = &new->thread;
@@ -474,10 +472,8 @@ void flush_thread(void)
 	discard_lazy_cpu_state();
 
 #ifdef CONFIG_PPC64	/* for now */
-	if (current->thread.dabr) {
-		current->thread.dabr = 0;
-		set_dabr(0);
-	}
+	if (unlikely(current->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(current);
 #endif
 }
 
Index: b/kernel/hw_breakpoint.c
===================================================================
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -25,6 +25,18 @@
  * #include'd by the arch-specific implementation.
  */
 
+#include <asm/thread_info.h>
+
+#ifdef TIF_DEBUG
+#define clear_tsk_debug_flag(tsk)	clear_tsk_thread_flag(tsk, TIF_DEBUG)
+#define set_tsk_debug_flag(tsk)		set_tsk_thread_flag(tsk, TIF_DEBUG)
+#define test_tsk_debug_flag(tsk)	test_tsk_thread_flag(tsk, TIF_DEBUG)
+#else
+#define clear_tsk_debug_flag(tsk)	do { } while (0)
+#define set_tsk_debug_flag(tsk)		do { } while (0)
+#define test_tsk_debug_flag(tsk)	\
+	((tsk)->thread.hw_breakpoint_info != NULL)
+#endif
 
 /*
  * Install the debug register values for a new thread.
@@ -156,7 +168,7 @@ static void update_this_cpu(void *unused
 
 	/* Install both the kernel and the user breakpoints */
 	arch_install_chbi(chbi);
-	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
+	if (test_tsk_debug_flag(tsk))
 		switch_to_thread_hw_breakpoint(tsk);
 
 	put_cpu_no_resched();
@@ -369,7 +381,7 @@ void flush_thread_hw_breakpoint(struct t
 	list_del(&thbi->node);
 
 	/* The thread no longer has any breakpoints associated with it */
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	clear_tsk_debug_flag(tsk);
 	tsk->thread.hw_breakpoint_info = NULL;
 	kfree(thbi);
 
@@ -393,7 +405,7 @@ int copy_thread_hw_breakpoint(struct tas
 	 * and the child starts out with no debug registers set.
 	 * But what about CLONE_PTRACE?
 	 */
-	clear_tsk_thread_flag(child, TIF_DEBUG);
+	clear_tsk_debug_flag(child);
 	return 0;
 }
 
@@ -457,7 +469,7 @@ static int insert_bp_in_list(struct hw_b
 
 		/* Is this the thread's first registered breakpoint? */
 		if (list_empty(&thbi->node)) {
-			set_tsk_thread_flag(tsk, TIF_DEBUG);
+			set_tsk_debug_flag(tsk);
 			list_add(&thbi->node, &thread_list);
 		}
 	}
@@ -483,7 +495,7 @@ static void remove_bp_from_list(struct h
 
 		if (list_empty(&thbi->thread_bps)) {
 			list_del_init(&thbi->node);
-			clear_tsk_thread_flag(tsk, TIF_DEBUG);
+			clear_tsk_debug_flag(tsk);
 		}
 	}
 
