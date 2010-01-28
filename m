Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054Ab0A1XH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0A1XH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691Ab0A1XHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:07:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:46421 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab0A1XHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:07:16 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/2] x86,hw_breakpoint,kgdb: kgdb to use hw_breakpoint API
Date: Thu, 28 Jan 2010 17:04:42 -0600
Message-Id: <1264719883-7285-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1264719883-7285-1-git-send-email-jason.wessel@windriver.com>
References: <1264719883-7285-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 28 Jan 2010 23:04:51.0453 (UTC) FILETIME=[4BF2CAD0:01CAA06E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the 2.6.33 kernel, the hw_breakpoint API is now used for the
performance event counters.  The hw_breakpoint_handler() now consumes
the hw breakpoints that were previously set by kgdb arch specific
code.  In order for kgdb to work in conjunction with this core API
change, kgdb must use some of the low level functions of the
hw_breakpoint API to install, uninstall, and deal with hw breakpoint
reservations.

The kgdb core required a change to call kgdb_disable_hw_debug anytime
a slave cpu enters kgdb_wait() in order to keep all the hw breakpoints
in sync as well as to prevent hitting a hw breakpoint while kgdb is
active.

During the architecture specific initialization of kgdb, it will
pre-allocate 4 disabled (struct perf event **) structures.  Kgdb will
use these to manage the capabilities for the 4 hw breakpoint
registers, per cpu.  Right now the hw_breakpoint API does not have a
way to ask how many breakpoints are available, on each CPU so it is
possible that the install of a breakpoint might fail when kgdb
restores the system to the run state.  The intent of this patch is to
first get the basic functionality of hw breakpoints working and leave
it to the person debugging the kernel to understand what hw
breakpoints are in use and what restrictions have been imposed as a
result.  Breakpoint constraints will be dealt with in a future patch.

While atomic, the x86 specific kgdb code will call
arch_uninstall_hw_breakpoint() and arch_install_hw_breakpoint() to
manage the cpu specific hw breakpoints.

The net result of these changes allow kgdb to use the same pool of
hw_breakpoints that are used by the perf event API, but neither knows
about future reservations for the available hw breakpoint slots.

CC: Ingo Molnar <mingo@elte.hu>
CC: K.Prasad <prasad@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/kgdb.c |  171 ++++++++++++++++++++++++++++++++----------------
 kernel/kgdb.c          |    3 +
 2 files changed, 117 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index dd74fe7..62bea73 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -42,6 +42,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
+#include <linux/hw_breakpoint.h>
 
 #include <asm/debugreg.h>
 #include <asm/apicdef.h>
@@ -204,40 +205,38 @@ void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 
 static struct hw_breakpoint {
 	unsigned		enabled;
-	unsigned		type;
-	unsigned		len;
 	unsigned long		addr;
+	int			len;
+	int			type;
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
+		struct arch_hw_breakpoint *info;
+		int val;
+		int cpu = raw_smp_processor_id();
+		if (!breakinfo[breakno].enabled)
+			continue;
+		bp = *per_cpu_ptr(breakinfo[breakno].pev, cpu);
+		info = counter_arch_bp(bp);
+		if (bp->attr.disabled != 1)
+			continue;
+		bp->attr.bp_addr = breakinfo[breakno].addr;
+		bp->attr.bp_len = breakinfo[breakno].len;
+		bp->attr.bp_type = breakinfo[breakno].type;
+		info->address = breakinfo[breakno].addr;
+		info->len = breakinfo[breakno].len;
+		info->type = breakinfo[breakno].type;
+		val = arch_install_hw_breakpoint(bp);
+		if (!val)
+			bp->attr.disabled = 0;
 	}
-	if (correctit)
-		set_debugreg(dr7, 7);
+	hw_breakpoint_restore();
 }
 
 static int
@@ -259,15 +258,23 @@ kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
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
 
 	for (i = 0; i < 4; i++)
@@ -278,27 +285,38 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 
 	switch (bptype) {
 	case BP_HARDWARE_BREAKPOINT:
-		type = 0;
-		len  = 1;
+		len = 1;
+		breakinfo[i].type = X86_BREAKPOINT_EXECUTE;
 		break;
 	case BP_WRITE_WATCHPOINT:
-		type = 1;
+		breakinfo[i].type = X86_BREAKPOINT_WRITE;
 		break;
 	case BP_ACCESS_WATCHPOINT:
-		type = 3;
+		breakinfo[i].type = X86_BREAKPOINT_RW;
 		break;
 	default:
 		return -1;
 	}
-
-	if (len == 1 || len == 2 || len == 4)
-		breakinfo[i].len  = len - 1;
-	else
+	switch (len) {
+	case 1:
+		breakinfo[i].len = X86_BREAKPOINT_LEN_1;
+		break;
+	case 2:
+		breakinfo[i].len = X86_BREAKPOINT_LEN_2;
+		break;
+	case 4:
+		breakinfo[i].len = X86_BREAKPOINT_LEN_4;
+		break;
+#ifdef CONFIG_X86_64
+	case 8:
+		breakinfo[i].len = X86_BREAKPOINT_LEN_8;
+		break;
+#endif
+	default:
 		return -1;
-
-	breakinfo[i].enabled = 1;
+	}
 	breakinfo[i].addr = addr;
-	breakinfo[i].type = type;
+	breakinfo[i].enabled = 1;
 
 	return 0;
 }
@@ -313,8 +331,21 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
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
@@ -378,7 +409,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 			       struct pt_regs *linux_regs)
 {
 	unsigned long addr;
-	unsigned long dr6;
 	char *ptr;
 	int newPC;
 
@@ -404,20 +434,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
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
@@ -485,8 +501,7 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 		break;
 
 	case DIE_DEBUG:
-		if (atomic_read(&kgdb_cpu_doing_single_step) ==
-		    raw_smp_processor_id()) {
+		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
 			if (user_mode(regs))
 				return single_step_cont(regs, args);
 			break;
@@ -539,7 +554,42 @@ static struct notifier_block kgdb_notifier = {
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
+	attr.bp_type = HW_BREAKPOINT_W;
+	attr.disabled = 1;
+	for (i = 0; i < 4; i++) {
+		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL);
+		if (IS_ERR(breakinfo[i].pev)) {
+			printk(KERN_ERR "kgdb: Could not allocate hw breakpoints\n");
+			breakinfo[i].pev = NULL;
+			kgdb_arch_exit();
+			return -1;
+		}
+		for_each_online_cpu(cpu) {
+			pevent = per_cpu_ptr(breakinfo[i].pev, cpu);
+			pevent[0]->hw.sample_period = 1;
+			if (pevent[0]->destroy != NULL) {
+				pevent[0]->destroy = NULL;
+				release_bp_slot(*pevent);
+			}
+		}
+	}
+	return ret;
 }
 
 /**
@@ -550,6 +600,13 @@ int kgdb_arch_init(void)
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
index 2eb517e..c7ade62 100644
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

