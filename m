Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZLKRUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZLKRUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZLKRUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:20:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:40296 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbZLKRU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:20:29 -0500
Message-ID: <4B227F2C.7050403@windriver.com>
Date: Fri, 11 Dec 2009 11:19:40 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [RFC] Fix 2.6.33 x86 regression to kgdb hw breakpoints - due to perf
 API changes
Content-Type: multipart/mixed;
 boundary="------------010307090002010101060009"
X-OriginalArrivalTime: 11 Dec 2009 17:19:40.0371 (UTC) FILETIME=[1F5A7A30:01CA7A86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010307090002010101060009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


I'll lead with a question.  Are the people making the Perf API changes
booting allyesconfig kernels?

The regression tests built into the kernel for kgdb fail as a result of
the perf API changes and can result in a hard kernel hang.  My hope
would have been that someone would have reported the problem, created a
patch to disable the test that hangs the kernel, or to fix kgdb such
that it works with the API changes.  Likewise, if there are tests I
should run to regression test the changes to the perf API, I would like
to know since we all want to make use of the same hw resource.

A patch has been included in this mail which allows kgdb to pass the
internal regression tests for hw breakpoints.  I would like to get some
comments or start a discussion as to how to solve this problem in the
2.6.33 cycle, as it is a regression in functionality.

I did not address this in the patch, but I found that the
hw_breakpoint.c API is lacking a function to query if there is a
breakpoint slot available on every processor, while atomic.  Having that
would allow an end user to see an error generated up to gdb that there
are not enough breakpoints available, as opposed to finding out about it
via a printk message after you resume the system.

Thanks,
Jason.

--------------010307090002010101060009
Content-Type: text/x-diff;
 name="x86-breakpoints-repair.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86-breakpoints-repair.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] x86,hw_breakpoint,kgdb: kgdb to use hw_breakpoint API

In the 2.6.33 kernel, the hw_breakpoint API is now used for the
performance event counters.  The hw_breakpoint_handler() now consumes
the hw breakpoints that were previously set by kgdb arch specific
code.  In order for kgdb to work in conjunction with this core API
change, kgdb must use some of the low level functions of the
hw_breakpoint API to install, uninstall, and receive call backs for hw
breakpoints.

The kgdb core needs to call kgdb_disable_hw_debug anytime a slave cpu
enters kgdb_wait() in order to keep all the hw breakpoints in sync as
well as to prevent hitting a hw breakpoint while kgdb is active.

During the architecture specific initialization of kgdb, it will
pre-allocate 4 disabled (struct perf event **) structures.  Kgdb will
use these to manage the capabilities for the 4 hw breakpoint
registers.  Right now the hw_breakpoint API does not have a way to ask
how many breakpoints are available, on each CPU so it is possible that
the install of a breakpoint might fail when kgdb restores the system
to the run state.  The intent of this patch is to first get the basic
functionality of hw breakpoints working and leave it to the person
debugging the kernel to understand what hw breakpoints are in use and
what restrictions have been imposed as a result.

While atomic, the x86 specific kgdb code will call
arch_uninstall_hw_breakpoint() and arch_install_hw_breakpoint() to
manage the cpu specific hw breakpoints.

The arch specific hw_breakpoint_handler() was changed to restore the
cpu specific dr7 instead of the dr7 that was locally saved, because
the dr7 can be modified while in a call back to kgdb.

The net result of these changes allow kgdb to use the same pool of
hw_breakpoints that are used by the perf event API, but neither knows
about future reservations for the available hw breakpoint slots.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/x86/kernel/hw_breakpoint.c |    5 -
 arch/x86/kernel/kgdb.c          |  179 +++++++++++++++++++++++++++-------------
 kernel/kgdb.c                   |    3 
 3 files changed, 127 insertions(+), 60 deletions(-)

--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -42,6 +42,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
+#include <linux/hw_breakpoint.h>
 
 #include <asm/debugreg.h>
 #include <asm/apicdef.h>
@@ -204,40 +205,27 @@ void gdb_regs_to_pt_regs(unsigned long *
 
 static struct hw_breakpoint {
 	unsigned		enabled;
-	unsigned		type;
-	unsigned		len;
 	unsigned long		addr;
+	struct perf_event	**pev;
 } breakinfo[4];
 
 static void kgdb_correct_hw_break(void)
 {
-	unsigned long dr7;
-	int correctit = 0;
-	int breakbit;
 	int breakno;
 
-	get_debugreg(dr7, 7);
 	for (breakno = 0; breakno < 4; breakno++) {
-		breakbit = 2 << (breakno << 1);
-		if (!(dr7 & breakbit) && breakinfo[breakno].enabled) {
-			correctit = 1;
-			dr7 |= breakbit;
-			dr7 &= ~(0xf0000 << (breakno << 2));
-			dr7 |= ((breakinfo[breakno].len << 2) |
-				 breakinfo[breakno].type) <<
-			       ((breakno << 2) + 16);
-			set_debugreg(breakinfo[breakno].addr, breakno);
-
-		} else {
-			if ((dr7 & breakbit) && !breakinfo[breakno].enabled) {
-				correctit = 1;
-				dr7 &= ~breakbit;
-				dr7 &= ~(0xf0000 << (breakno << 2));
-			}
-		}
+		struct perf_event *bp;
+		int val;
+		int cpu = raw_smp_processor_id();
+		if (!breakinfo[breakno].enabled)
+			continue;
+		bp = *per_cpu_ptr(breakinfo[breakno].pev, cpu);
+		if (bp->attr.disabled != 1)
+			continue;
+		val = arch_install_hw_breakpoint(bp);
+		if (!val)
+			bp->attr.disabled = 0;
 	}
-	if (correctit)
-		set_debugreg(dr7, 7);
 }
 
 static int
@@ -259,46 +247,74 @@ kgdb_remove_hw_break(unsigned long addr,
 static void kgdb_remove_all_hw_break(void)
 {
 	int i;
+	int cpu = raw_smp_processor_id();
+	struct perf_event *bp;
 
-	for (i = 0; i < 4; i++)
-		memset(&breakinfo[i], 0, sizeof(struct hw_breakpoint));
+	for (i = 0; i < 4; i++) {
+		if (!breakinfo[i].enabled)
+			continue;
+		bp = *per_cpu_ptr(breakinfo[i].pev, cpu);
+		if (bp->attr.disabled == 1)
+			continue;
+		arch_uninstall_hw_breakpoint(bp);
+		bp->attr.disabled = 1;
+	}
 }
 
 static int
 kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 {
-	unsigned type;
 	int i;
+	struct perf_event *bp;
+	struct arch_hw_breakpoint *info;
 
 	for (i = 0; i < 4; i++)
 		if (!breakinfo[i].enabled)
 			break;
 	if (i == 4)
 		return -1;
-
+	bp = *per_cpu_ptr(breakinfo[i].pev, raw_smp_processor_id());
+	info = counter_arch_bp(bp);
 	switch (bptype) {
 	case BP_HARDWARE_BREAKPOINT:
-		type = 0;
-		len  = 1;
+		len = 1;
+		info->type = X86_BREAKPOINT_EXECUTE;
 		break;
 	case BP_WRITE_WATCHPOINT:
-		type = 1;
+		info->type = X86_BREAKPOINT_WRITE;
 		break;
 	case BP_ACCESS_WATCHPOINT:
-		type = 3;
+		info->type = X86_BREAKPOINT_RW;
 		break;
 	default:
 		return -1;
 	}
 
-	if (len == 1 || len == 2 || len == 4)
-		breakinfo[i].len  = len - 1;
-	else
+	switch (len) {
+	case 1:
+		info->len = X86_BREAKPOINT_LEN_1;
+		break;
+	case 2:
+		info->len = X86_BREAKPOINT_LEN_2;
+		break;
+	case 4:
+		info->len = X86_BREAKPOINT_LEN_4;
+		break;
+#ifdef CONFIG_X86_64
+	case 8:
+		info->len = X86_BREAKPOINT_LEN_8;
+		break;
+#endif
+	default:
 		return -1;
+	}
 
-	breakinfo[i].enabled = 1;
 	breakinfo[i].addr = addr;
-	breakinfo[i].type = type;
+	info->address = addr;
+	bp->attr.bp_addr = info->address;
+	bp->attr.bp_len = info->len;
+	bp->attr.bp_type = info->type;
+	breakinfo[i].enabled = 1;
 
 	return 0;
 }
@@ -313,8 +329,21 @@ kgdb_set_hw_break(unsigned long addr, in
  */
 void kgdb_disable_hw_debug(struct pt_regs *regs)
 {
+	int i;
+	int cpu = raw_smp_processor_id();
+	struct perf_event *bp;
+
 	/* Disable hardware debugging while we are in kgdb: */
 	set_debugreg(0UL, 7);
+	for (i = 0; i < 4; i++) {
+		if (!breakinfo[i].enabled)
+			continue;
+		bp = *per_cpu_ptr(breakinfo[i].pev, cpu);
+		if (bp->attr.disabled == 1)
+			continue;
+		arch_uninstall_hw_breakpoint(bp);
+		bp->attr.disabled = 1;
+	}
 }
 
 /**
@@ -378,7 +407,6 @@ int kgdb_arch_handle_exception(int e_vec
 			       struct pt_regs *linux_regs)
 {
 	unsigned long addr;
-	unsigned long dr6;
 	char *ptr;
 	int newPC;
 
@@ -404,20 +432,6 @@ int kgdb_arch_handle_exception(int e_vec
 				   raw_smp_processor_id());
 		}
 
-		get_debugreg(dr6, 6);
-		if (!(dr6 & 0x4000)) {
-			int breakno;
-
-			for (breakno = 0; breakno < 4; breakno++) {
-				if (dr6 & (1 << breakno) &&
-				    breakinfo[breakno].type == 0) {
-					/* Set restore flag: */
-					linux_regs->flags |= X86_EFLAGS_RF;
-					break;
-				}
-			}
-		}
-		set_debugreg(0UL, 6);
 		kgdb_correct_hw_break();
 
 		return 0;
@@ -448,6 +462,7 @@ single_step_cont(struct pt_regs *regs, s
 }
 
 static int was_in_debug_nmi[NR_CPUS];
+static int recieved_hw_brk[NR_CPUS];
 
 static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 {
@@ -485,16 +500,19 @@ static int __kgdb_notify(struct die_args
 		break;
 
 	case DIE_DEBUG:
-		if (atomic_read(&kgdb_cpu_doing_single_step) ==
-		    raw_smp_processor_id()) {
+		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
 			if (user_mode(regs))
 				return single_step_cont(regs, args);
 			break;
-		} else if (test_thread_flag(TIF_SINGLESTEP))
+		} else if (test_thread_flag(TIF_SINGLESTEP)) {
 			/* This means a user thread is single stepping
 			 * a system call which should be ignored
 			 */
 			return NOTIFY_DONE;
+		} else if (recieved_hw_brk[raw_smp_processor_id()] == 1) {
+			recieved_hw_brk[raw_smp_processor_id()] = 0;
+			return NOTIFY_STOP;
+		}
 		/* fall through */
 	default:
 		if (user_mode(regs))
@@ -531,6 +549,21 @@ static struct notifier_block kgdb_notifi
 	.priority	= -INT_MAX,
 };
 
+static void kgdb_hw_bp(struct perf_event *bp, void *data)
+{
+	struct die_args args;
+
+	args.trapnr = 0;
+	args.signr = 5;
+	args.err = 0;
+	args.regs = data;
+	args.str = "debug";
+	if (__kgdb_notify(&args, DIE_DEBUG) == NOTIFY_STOP)
+		recieved_hw_brk[raw_smp_processor_id()] = 1;
+	else
+		recieved_hw_brk[raw_smp_processor_id()] = 0;
+}
+
 /**
  *	kgdb_arch_init - Perform any architecture specific initalization.
  *
@@ -539,7 +572,32 @@ static struct notifier_block kgdb_notifi
  */
 int kgdb_arch_init(void)
 {
-	return register_die_notifier(&kgdb_notifier);
+	int i;
+	int ret;
+	DEFINE_BREAKPOINT_ATTR(attr);
+
+	ret = register_die_notifier(&kgdb_notifier);
+	if (ret != 0)
+		return ret;
+	/* Pre-allocate the hw breakpoint structions in the non-atomic
+	 * portion of kgdb because this operation requires mutexs to
+	 * complete. */
+	attr.bp_addr = (unsigned long)kgdb_arch_init;
+	attr.type = 1;
+	attr.bp_len = HW_BREAKPOINT_LEN_1;
+	attr.bp_type = HW_BREAKPOINT_X;
+	attr.disabled = 1;
+	for (i = 0; i < 4; i++) {
+		breakinfo[i].pev = register_wide_hw_breakpoint(&attr,
+							       kgdb_hw_bp);
+		if (IS_ERR(breakinfo[i].pev)) {
+			printk(KERN_ERR "kgdb: Could not allocate hw breakpoints\n");
+			breakinfo[i].pev = NULL;
+			kgdb_arch_exit();
+			return -1;
+		}
+	}
+	return ret;
 }
 
 /**
@@ -550,6 +608,13 @@ int kgdb_arch_init(void)
  */
 void kgdb_arch_exit(void)
 {
+	int i;
+	for (i = 0; i < 4; i++) {
+		if (breakinfo[i].pev) {
+			unregister_wide_hw_breakpoint(breakinfo[i].pev);
+			breakinfo[i].pev = NULL;
+		}
+	}
 	unregister_die_notifier(&kgdb_notifier);
 }
 
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -467,7 +467,7 @@ static int __kprobes hw_breakpoint_handl
 {
 	int i, cpu, rc = NOTIFY_STOP;
 	struct perf_event *bp;
-	unsigned long dr7, dr6;
+	unsigned long dr6;
 	unsigned long *dr6_p;
 
 	/* The DR6 value is pointed by args->err */
@@ -478,7 +478,6 @@ static int __kprobes hw_breakpoint_handl
 	if ((dr6 & DR_TRAP_BITS) == 0)
 		return NOTIFY_DONE;
 
-	get_debugreg(dr7, 7);
 	/* Disable breakpoints during exception handling */
 	set_debugreg(0UL, 7);
 	/*
@@ -526,7 +525,7 @@ static int __kprobes hw_breakpoint_handl
 	if (dr6 & (~DR_TRAP_BITS))
 		rc = NOTIFY_DONE;
 
-	set_debugreg(dr7, 7);
+	set_debugreg(__get_cpu_var(cpu_dr7), 7);
 	put_cpu();
 
 	return rc;
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -583,6 +583,9 @@ static void kgdb_wait(struct pt_regs *re
 	smp_wmb();
 	atomic_set(&cpu_in_kgdb[cpu], 1);
 
+	/* Disable any cpu specific hw breakpoints */
+	kgdb_disable_hw_debug(regs);
+
 	/* Wait till primary CPU is done with debugging */
 	while (atomic_read(&passive_cpu_wait[cpu]))
 		cpu_relax();

--------------010307090002010101060009--
