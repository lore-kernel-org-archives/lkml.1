Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZLWVUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZLWVUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbZLWVU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:20:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:45008 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbZLWVUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:18 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 02/37] x86,hw_breakpoint,kgdb: kgdb to use hw_breakpoint API
Date: Wed, 23 Dec 2009 15:19:15 -0600
Message-Id: <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:19:54.0223 (UTC) FILETIME=[ABA2BFF0:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/x86/kernel/hw_breakpoint.c |    5 +-
 arch/x86/kernel/kgdb.c          |  191 +++++++++++++++++++++++++++------------
 kernel/kgdb.c                   |    3 +
 3 files changed, 139 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 05d5fec..cbf19e0 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -466,7 +466,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 {
 	int i, cpu, rc = NOTIFY_STOP;
 	struct perf_event *bp;
-	unsigned long dr7, dr6;
+	unsigned long dr6;
 	unsigned long *dr6_p;
 
 	/* The DR6 value is pointed by args->err */
@@ -477,7 +477,6 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 	if ((dr6 & DR_TRAP_BITS) == 0)
 		return NOTIFY_DONE;
 
-	get_debugreg(dr7, 7);
 	/* Disable breakpoints during exception handling */
 	set_debugreg(0UL, 7);
 	/*
@@ -525,7 +524,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 	if (dr6 & (~DR_TRAP_BITS))
 		rc = NOTIFY_DONE;
 
-	set_debugreg(dr7, 7);
+	set_debugreg(__get_cpu_var(cpu_dr7), 7);
 	put_cpu();
 
 	return rc;
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index dd74fe7..48384fa 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -42,6 +42,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
+#include <linux/hw_breakpoint.h>
 
 #include <asm/debugreg.h>
 #include <asm/apicdef.h>
@@ -204,40 +205,27 @@ void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 
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
@@ -259,46 +247,74 @@ kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
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
@@ -313,8 +329,21 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
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
@@ -378,7 +407,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 			       struct pt_regs *linux_regs)
 {
 	unsigned long addr;
-	unsigned long dr6;
 	char *ptr;
 	int newPC;
 
@@ -404,20 +432,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
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
@@ -448,6 +462,7 @@ single_step_cont(struct pt_regs *regs, struct die_args *args)
 }
 
 static int was_in_debug_nmi[NR_CPUS];
+static int recieved_hw_brk[NR_CPUS];
 
 static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 {
@@ -485,16 +500,19 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
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
@@ -531,6 +549,23 @@ static struct notifier_block kgdb_notifier = {
 	.priority	= -INT_MAX,
 };
 
+static void kgdb_hw_bp(struct perf_event *bp, int nmi,
+		       struct perf_sample_data *data,
+		       struct pt_regs *regs)
+{
+	struct die_args args;
+
+	args.trapnr = 0;
+	args.signr = 5;
+	args.err = 0;
+	args.regs = regs;
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
@@ -539,7 +574,42 @@ static struct notifier_block kgdb_notifier = {
  */
 int kgdb_arch_init(void)
 {
-	return register_die_notifier(&kgdb_notifier);
+	int i, cpu;
+	int ret;
+	struct perf_event_attr attr;
+	struct perf_event **pevent;
+
+	ret = register_die_notifier(&kgdb_notifier);
+	if (ret != 0)
+		return ret;
+	/*
+	 * Pre-allocate the hw breakpoint structions in the non-atomic
+	 * portion of kgdb because this operation requires mutexs to
+	 * complete.
+	 */
+	attr.bp_addr = (unsigned long)kgdb_arch_init;
+	attr.type = PERF_TYPE_BREAKPOINT;
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
+		for_each_online_cpu(cpu) {
+			pevent = per_cpu_ptr(breakinfo[i].pev, cpu);
+			if (pevent[0]->destroy != NULL) {
+				pevent[0]->destroy = NULL;
+				release_bp_slot(*pevent);
+			}
+		}
+	}
+	return ret;
 }
 
 /**
@@ -550,6 +620,13 @@ int kgdb_arch_init(void)
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
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 87f2cc5..761fdd2 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -583,6 +583,9 @@ static void kgdb_wait(struct pt_regs *regs)
 	smp_wmb();
 	atomic_set(&cpu_in_kgdb[cpu], 1);
 
+	/* Disable any cpu specific hw breakpoints */
+	kgdb_disable_hw_debug(regs);
+
 	/* Wait till primary CPU is done with debugging */
 	while (atomic_read(&passive_cpu_wait[cpu]))
 		cpu_relax();
-- 
1.6.4.rc1

