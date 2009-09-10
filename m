Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZIJIal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZIJIal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 04:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZIJIaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 04:30:39 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51951 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbZIJI3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 04:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N8qhl5iiLREiFwdlcvKWrxWDE3n+mUEpG+zIxfHB3DzDKtS5u/sek1+G5BK8lvS+G3
         WLqtRHyCsAJsHYW7YD7wSukCbpyorDvqRloKKLJ9cn6+psRdVaTO+205xhwKEwUTaRme
         YHdKpyQT5l7JbAl88Vpdwtrc2D7KvGvzMM2Pw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf counters
Date: Thu, 10 Sep 2009 10:29:25 +0200
Message-Id: <1252571367-25876-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch rebase the implementation of the breakpoints API on top of
perf counters instances.

The core breakpoint API has changed a bit:

- register_kernel_hw_breakpoint() now takes a cpu as a parameter. For
  now it doesn't support all cpu wide breakpoints but this may be
  implemented soon.

- unregister_kernel_hw_breakpoint() and unregister_user_hw_breakpoint()
  have been unified in a single unregister_hw_breakpoint()

Each breakpoints now match a perf counter which now handles the
register scheduling, thread/cpu attachment, etc..

The new layering is now made as follows:

       ptrace       kgdb      ftrace   perf syscall
          \          |          /         /
           \         |         /         /
                                        /
            Core breakpoint API        /
                                      /
                     |               /
                     |              /

              Breakpoints perf counters

                     |
                     |

               Breakpoints PMU ---- Debug Register constraints handling
                                    (Part of core breakpoint API)
                     |
                     |

             Hardware debug registers

Reasons of this rewrite:

- Use the centralized/optimized pmu registers scheduling,
  implying an easier arch integration
- More powerful register handling: perf attributes (pinned/flexible
  events, exclusive/non-exclusive, tunable period, etc...)

Impact:

- New perf ABI: the hardware breakpoints counters
- Ptrace breakpoints setting remains tricky and still needs some per
  thread breakpoints references.

Todo (in the order):

- Drop struct hw_breakpoint and store generic breakpoints fields inside
  struct perf_counter_attr to have a common way to set breakpoints
  parameters.
- Support breakpoints perf counter events for perf tools (ie: implement
  perf_bpcounter_event())
- Support from perf tools

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/Kconfig                         |    3 +
 arch/x86/include/asm/debugreg.h      |    7 -
 arch/x86/include/asm/hw_breakpoint.h |   31 ++-
 arch/x86/include/asm/processor.h     |   10 +-
 arch/x86/kernel/hw_breakpoint.c      |  217 ++++++++++++---------
 arch/x86/kernel/process.c            |    4 +-
 arch/x86/kernel/process_32.c         |   28 +--
 arch/x86/kernel/process_64.c         |   28 +---
 arch/x86/kernel/ptrace.c             |  163 ++++++++++-----
 arch/x86/kernel/smpboot.c            |    3 -
 arch/x86/power/cpu.c                 |    6 -
 include/asm-generic/hw_breakpoint.h  |   20 ++-
 include/linux/perf_counter.h         |   10 +-
 kernel/hw_breakpoint.c               |  364 +++++++++++-----------------------
 kernel/perf_counter.c                |   25 +++
 kernel/trace/trace_ksym.c            |  151 ++++++++++----
 16 files changed, 546 insertions(+), 524 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index c72f18f..c162ce6 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -115,6 +115,9 @@ config HAVE_DEFAULT_NO_SPIN_MUTEXES
 
 config HAVE_HW_BREAKPOINT
 	bool
+	depends on HAVE_PERF_COUNTERS
+	select ANON_INODES
+	select PERF_COUNTERS
 
 
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 23439fb..1062e4a 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -75,13 +75,6 @@
  */
 #ifdef __KERNEL__
 
-/* For process management */
-extern void flush_thread_hw_breakpoint(struct task_struct *tsk);
-extern int copy_thread_hw_breakpoint(struct task_struct *tsk,
-		struct task_struct *child, unsigned long clone_flags);
-
-/* For CPU management */
-extern void load_debug_registers(void);
 static inline void hw_breakpoint_disable(void)
 {
 	/* Zero the control register for HW Breakpoint */
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 1acb4d4..425a226 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -13,6 +13,8 @@ struct arch_hw_breakpoint {
 
 #include <linux/kdebug.h>
 #include <asm-generic/hw_breakpoint.h>
+#include <linux/percpu.h>
+#include <linux/list.h>
 
 /* Available HW breakpoint length encodings */
 #define HW_BREAKPOINT_LEN_1		0x40
@@ -36,20 +38,27 @@ struct arch_hw_breakpoint {
 /* Total number of available HW breakpoint registers */
 #define HBP_NUM 4
 
-extern struct hw_breakpoint *hbp_kernel[HBP_NUM];
-DECLARE_PER_CPU(struct hw_breakpoint*, this_hbp_kernel[HBP_NUM]);
-extern unsigned int hbp_user_refcount[HBP_NUM];
-
-extern void arch_install_thread_hw_breakpoint(struct task_struct *tsk);
-extern void arch_uninstall_thread_hw_breakpoint(void);
 extern int arch_check_va_in_userspace(unsigned long va, u8 hbp_len);
 extern int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
-						struct task_struct *tsk);
-extern void arch_update_user_hw_breakpoint(int pos, struct task_struct *tsk);
-extern void arch_flush_thread_hw_breakpoint(struct task_struct *tsk);
-extern void arch_update_kernel_hw_breakpoint(void *);
+					 struct task_struct *tsk);
 extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
-				     unsigned long val, void *data);
+					   unsigned long val, void *data);
+
+struct perf_counter;
+
+int arch_install_hw_breakpoint(struct perf_counter *counter);
+void arch_uninstall_hw_breakpoint(struct perf_counter *counter);
+void hw_breakpoint_pmu_read(struct perf_counter *counter);
+void hw_breakpoint_pmu_unthrottle(struct perf_counter *counter);
+
+extern void
+arch_fill_perf_breakpoint(struct perf_counter *counter);
+
+unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type);
+int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type);
+
+void flush_ptrace_hw_breakpoint(struct task_struct *tsk);
+
 #endif	/* __KERNEL__ */
 #endif	/* _I386_HW_BREAKPOINT_H */
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2b03f70..007107f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -433,12 +433,10 @@ struct thread_struct {
 	unsigned long		fs;
 #endif
 	unsigned long		gs;
-	/* Hardware debugging registers: */
-	unsigned long		debugreg[HBP_NUM];
-	unsigned long		debugreg6;
-	unsigned long		debugreg7;
-	/* Hardware breakpoint info */
-	struct hw_breakpoint	*hbp[HBP_NUM];
+	/* Save middle states of ptrace breakpoints */
+	struct hw_breakpoint	*ptrace_bps[HBP_NUM];
+	/* Debug status used for traps, single steps, etc... */
+	unsigned long           debugreg6;
 	/* Fault info: */
 	unsigned long		cr2;
 	unsigned long		trap_no;
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 9316a9d..6d643ee 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -15,6 +15,7 @@
  *
  * Copyright (C) 2007 Alan Stern
  * Copyright (C) 2009 IBM Corporation
+ * Copyright (C) 2009 Frederic Weisbecker <fweisbec@gmail.com>
  */
 
 /*
@@ -22,6 +23,7 @@
  * using the CPU's debug registers.
  */
 
+#include <linux/perf_counter.h>
 #include <linux/irqflags.h>
 #include <linux/notifier.h>
 #include <linux/kallsyms.h>
@@ -38,26 +40,27 @@
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 
-/* Unmasked kernel DR7 value */
-static unsigned long kdr7;
+/* Per cpu debug control register value */
+static DEFINE_PER_CPU(unsigned long, dr7);
 
 /*
- * Masks for the bits corresponding to registers DR0 - DR3 in DR7 register.
- * Used to clear and verify the status of bits corresponding to DR0 - DR3
+ * Stores the breakpoints currently in use on each breakpoint address
+ * register for each cpus
  */
-static const unsigned long	dr7_masks[HBP_NUM] = {
-	0x000f0003,	/* LEN0, R/W0, G0, L0 */
-	0x00f0000c,	/* LEN1, R/W1, G1, L1 */
-	0x0f000030,	/* LEN2, R/W2, G2, L2 */
-	0xf00000c0	/* LEN3, R/W3, G3, L3 */
-};
+static DEFINE_PER_CPU(struct hw_breakpoint *, bp_per_reg[HBP_NUM]);
 
 
+static inline
+struct arch_hw_breakpoint *counter_arch_bp(struct perf_counter *counter)
+{
+	return &counter->hw.bp->info;
+}
+
 /*
  * Encode the length, type, Exact, and Enable bits for a particular breakpoint
  * as stored in debug register 7.
  */
-static unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type)
+unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type)
 {
 	unsigned long bp_info;
 
@@ -68,64 +71,86 @@ static unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type)
 	return bp_info;
 }
 
-void arch_update_kernel_hw_breakpoint(void *unused)
+/*
+ * Decode the length and type bits for a particular breakpoint as
+ * stored in debug register 7.  Return the "enabled" status.
+ */
+int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type)
 {
-	struct hw_breakpoint *bp;
-	int i, cpu = get_cpu();
-	unsigned long temp_kdr7 = 0;
-
-	/* Don't allow debug exceptions while we update the registers */
-	set_debugreg(0UL, 7);
+	int bp_info = dr7 >> (DR_CONTROL_SHIFT + bpnum * DR_CONTROL_SIZE);
 
-	for (i = hbp_kernel_pos; i < HBP_NUM; i++) {
-		per_cpu(this_hbp_kernel[i], cpu) = bp = hbp_kernel[i];
-		if (bp) {
-			temp_kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
-			set_debugreg(bp->info.address, i);
-		}
-	}
+	*len = (bp_info & 0xc) | 0x40;
+	*type = (bp_info & 0x3) | 0x80;
 
-	/* No need to set DR6. Update the debug registers with kernel-space
-	 * breakpoint values from kdr7 and user-space requests from the
-	 * current process
-	 */
-	kdr7 = temp_kdr7;
-	set_debugreg(kdr7 | current->thread.debugreg7, 7);
-	put_cpu();
+	return (dr7 >> (bpnum * DR_ENABLE_SIZE)) & 0x3;
 }
 
 /*
- * Install the thread breakpoints in their debug registers.
+ * Install a perf counter breakpoint.
+ *
+ * We seek a free debug address register and use it for this
+ * breakpoint. Eventually we enable it in the debug control register.
+ *
+ * Atomic: we hold the counter->ctx->lock and we only handle variables
+ * and registers local to this cpu.
  */
-void arch_install_thread_hw_breakpoint(struct task_struct *tsk)
+int arch_install_hw_breakpoint(struct perf_counter *counter)
 {
-	struct thread_struct *thread = &(tsk->thread);
-
-	switch (hbp_kernel_pos) {
-	case 4:
-		set_debugreg(thread->debugreg[3], 3);
-	case 3:
-		set_debugreg(thread->debugreg[2], 2);
-	case 2:
-		set_debugreg(thread->debugreg[1], 1);
-	case 1:
-		set_debugreg(thread->debugreg[0], 0);
-	default:
-		break;
+	struct arch_hw_breakpoint *bp = counter_arch_bp(counter);
+	unsigned long *dr7;
+	int i;
+
+	for (i = 0; i < HBP_NUM; i++) {
+		struct hw_breakpoint **slot = &__get_cpu_var(bp_per_reg[i]);
+
+		if (!*slot) {
+			*slot = counter->hw.bp;
+			break;
+		}
 	}
 
-	/* No need to set DR6 */
-	set_debugreg((kdr7 | thread->debugreg7), 7);
+	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
+		return -EBUSY;
+
+	set_debugreg(bp->address, i);
+
+	dr7 = &__get_cpu_var(dr7);
+	*dr7 |= encode_dr7(i, bp->len, bp->type);
+	set_debugreg(*dr7, 7);
+
+	return 0;
 }
 
 /*
- * Install the debug register values for just the kernel, no thread.
+ * Uninstall the breakpoint contained in the given counter.
+ *
+ * First we search the debug address register it uses and then we disable
+ * it.
+ *
+ * Atomic: we hold the counter->ctx->lock and we only handle variables
+ * and registers local to this cpu.
  */
-void arch_uninstall_thread_hw_breakpoint(void)
+void arch_uninstall_hw_breakpoint(struct perf_counter *counter)
 {
-	/* Clear the user-space portion of debugreg7 by setting only kdr7 */
-	set_debugreg(kdr7, 7);
+	struct arch_hw_breakpoint *bp = counter_arch_bp(counter);
+	unsigned long *dr7;
+	int i;
 
+	for (i = 0; i < HBP_NUM; i++) {
+		struct hw_breakpoint **slot = &__get_cpu_var(bp_per_reg[i]);
+
+		if (*slot == counter->hw.bp) {
+			*slot = NULL;
+			break;
+		}
+	}
+
+	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
+		return;
+
+	dr7 = &__get_cpu_var(dr7);
+	*dr7 &= encode_dr7(i, bp->len, bp->type);
+	set_debugreg(*dr7, 7);
 }
 
 static int get_hbp_len(u8 hbp_len)
@@ -178,15 +203,9 @@ static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
 /*
  * Store a breakpoint's encoded address, length, and type.
  */
-static int arch_store_info(struct hw_breakpoint *bp, struct task_struct *tsk)
+static int arch_store_info(struct hw_breakpoint *bp)
 {
 	/*
-	 * User-space requests will always have the address field populated
-	 * Symbol names from user-space are rejected
-	 */
-	if (tsk && bp->info.name)
-		return -EINVAL;
-	/*
 	 * For kernel-addresses, either the address or symbol name can be
 	 * specified.
 	 */
@@ -202,7 +221,7 @@ static int arch_store_info(struct hw_breakpoint *bp, struct task_struct *tsk)
  * Validate the arch-specific HW Breakpoint register settings
  */
 int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
-						struct task_struct *tsk)
+				  struct task_struct *tsk)
 {
 	unsigned int align;
 	int ret = -EINVAL;
@@ -247,7 +266,7 @@ int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
 	}
 
 	if (bp->triggered)
-		ret = arch_store_info(bp, tsk);
+		ret = arch_store_info(bp);
 
 	if (ret < 0)
 		return ret;
@@ -267,31 +286,30 @@ int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
 								bp->info.len))
 			return -EFAULT;
 	}
+
 	return 0;
 }
 
-void arch_update_user_hw_breakpoint(int pos, struct task_struct *tsk)
+/* start simple: just set a 1 byte length rw breakpoint to the location */
+void arch_fill_perf_breakpoint(struct perf_counter *counter)
 {
-	struct thread_struct *thread = &(tsk->thread);
-	struct hw_breakpoint *bp = thread->hbp[pos];
-
-	thread->debugreg7 &= ~dr7_masks[pos];
-	if (bp) {
-		thread->debugreg[pos] = bp->info.address;
-		thread->debugreg7 |= encode_dr7(pos, bp->info.len,
-							bp->info.type);
-	} else
-		thread->debugreg[pos] = 0;
+	struct arch_hw_breakpoint *bp = counter_arch_bp(counter);
+
+	bp->address = (unsigned long)counter->attr.config;
+	bp->len = HW_BREAKPOINT_LEN_1;
+	bp->type = HW_BREAKPOINT_RW;
 }
 
-void arch_flush_thread_hw_breakpoint(struct task_struct *tsk)
+/*
+ * Release the user breakpoints used by ptrace
+ */
+void flush_ptrace_hw_breakpoint(struct task_struct *tsk)
 {
 	int i;
-	struct thread_struct *thread = &(tsk->thread);
+	struct thread_struct *t = &tsk->thread;
 
-	thread->debugreg7 = 0;
 	for (i = 0; i < HBP_NUM; i++)
-		thread->debugreg[i] = 0;
+		kfree(t->ptrace_bps[i]);
 }
 
 /*
@@ -325,10 +343,6 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 	if ((dr6 & DR_TRAP_BITS) == 0)
 		return NOTIFY_DONE;
 
-	/* Lazy debug register switching */
-	if (!test_tsk_thread_flag(current, TIF_DEBUG))
-		arch_uninstall_thread_hw_breakpoint();
-
 	get_debugreg(dr7, 7);
 	/* Disable breakpoints during exception handling */
 	set_debugreg(0UL, 7);
@@ -344,17 +358,18 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 	for (i = 0; i < HBP_NUM; ++i) {
 		if (likely(!(dr6 & (DR_TRAP0 << i))))
 			continue;
+
 		/*
-		 * Find the corresponding hw_breakpoint structure and
-		 * invoke its triggered callback.
+		 * The counter may be concurrently released but that can only
+		 * occur from a call_rcu() path. We can then safely fetch
+		 * the breakpoint, use its callback, touch its counter
+		 * while we are in an rcu_read_lock() path.
 		 */
-		if (i >= hbp_kernel_pos)
-			bp = per_cpu(this_hbp_kernel[i], cpu);
-		else {
-			bp = current->thread.hbp[i];
-			if (bp)
-				rc = NOTIFY_DONE;
-		}
+		rcu_read_lock();
+
+		bp = per_cpu(bp_per_reg[i], cpu);
+		if (bp)
+			rc = NOTIFY_DONE;
 		/*
 		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
 		 * exception handling
@@ -362,19 +377,23 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 		(*dr6_p) &= ~(DR_TRAP0 << i);
 		/*
 		 * bp can be NULL due to lazy debug register switching
-		 * or due to the delay between updates of hbp_kernel_pos
-		 * and this_hbp_kernel.
+		 * or due to concurrent perf counter removing.
 		 */
-		if (!bp)
-			continue;
+		if (!bp) {
+			rcu_read_unlock();
+			break;
+		}
 
 		(bp->triggered)(bp, args->regs);
+
+		rcu_read_unlock();
 	}
 	if (dr6 & (~DR_TRAP_BITS))
 		rc = NOTIFY_DONE;
 
 	set_debugreg(dr7, 7);
 	put_cpu();
+
 	return rc;
 }
 
@@ -389,3 +408,13 @@ int __kprobes hw_breakpoint_exceptions_notify(
 
 	return hw_breakpoint_handler(data);
 }
+
+void hw_breakpoint_pmu_read(struct perf_counter *counter)
+{
+	/* TODO */
+}
+
+void hw_breakpoint_pmu_unthrottle(struct perf_counter *counter)
+{
+	/* TODO */
+}
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1092a1a..a14cd67 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -51,7 +51,7 @@ void free_thread_xstate(struct task_struct *tsk)
 		tsk->thread.xstate = NULL;
 	}
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
-		flush_thread_hw_breakpoint(tsk);
+		flush_ptrace_hw_breakpoint(tsk);
 
 	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
@@ -113,7 +113,7 @@ void flush_thread(void)
 	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
-		flush_thread_hw_breakpoint(tsk);
+		flush_ptrace_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
 	/*
 	 * Forget coprocessor state..
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 00a8fe4..ae1c489 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -267,9 +267,11 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.io_bitmap_ptr = NULL;
 	tsk = current;
 	err = -ENOMEM;
-	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
-		if (copy_thread_hw_breakpoint(tsk, p, clone_flags))
-			goto out;
+
+	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG))) {
+		memset(p->thread.ptrace_bps, 0,
+		       sizeof(p->thread.ptrace_bps));
+	}
 
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
@@ -290,13 +292,12 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		err = do_set_thread_area(p, -1,
 			(struct user_desc __user *)childregs->si, 0);
 
-out:
 	if (err && p->thread.io_bitmap_ptr) {
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
 	if (err)
-		flush_thread_hw_breakpoint(p);
+		flush_ptrace_hw_breakpoint(p);
 
 	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
 	p->thread.ds_ctx = NULL;
@@ -435,23 +436,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		lazy_load_gs(next->gs);
 
 	percpu_write(current_task, next_p);
-	/*
-	 * There's a problem with moving the arch_install_thread_hw_breakpoint()
-	 * call before current is updated.  Suppose a kernel breakpoint is
-	 * triggered in between the two, the hw-breakpoint handler will see that
-	 * the 'current' task does not have TIF_DEBUG flag set and will think it
-	 * is leftover from an old task (lazy switching) and will erase it. Then
-	 * until the next context switch, no user-breakpoints will be installed.
-	 *
-	 * The real problem is that it's impossible to update both current and
-	 * physical debug registers at the same instant, so there will always be
-	 * a window in which they disagree and a breakpoint might get triggered.
-	 * Since we use lazy switching, we are forced to assume that a
-	 * disagreement means that current is correct and the exception is due
-	 * to lazy debug register switching.
-	 */
-	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
-		arch_install_thread_hw_breakpoint(next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 89c46f1..ca35488 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -247,8 +247,6 @@ void release_thread(struct task_struct *dead_task)
 			BUG();
 		}
 	}
-	if (unlikely(dead_task->thread.debugreg7))
-		flush_thread_hw_breakpoint(dead_task);
 }
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
@@ -312,9 +310,10 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	savesegment(ds, p->thread.ds);
 
 	err = -ENOMEM;
-	if (unlikely(test_tsk_thread_flag(me, TIF_DEBUG)))
-		if (copy_thread_hw_breakpoint(me, p, clone_flags))
-			goto out;
+	if (unlikely(test_tsk_thread_flag(me, TIF_DEBUG))) {
+		memset(p->thread.ptrace_bps, 0,
+		       sizeof(p->thread.ptrace_bps));
+	}
 
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
@@ -355,7 +354,7 @@ out:
 		p->thread.io_bitmap_max = 0;
 	}
 	if (err)
-		flush_thread_hw_breakpoint(p);
+		flush_ptrace_hw_breakpoint(p);
 
 	return err;
 }
@@ -502,23 +501,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
 		math_state_restore();
-	/*
-	 * There's a problem with moving the arch_install_thread_hw_breakpoint()
-	 * call before current is updated.  Suppose a kernel breakpoint is
-	 * triggered in between the two, the hw-breakpoint handler will see that
-	 * the 'current' task does not have TIF_DEBUG flag set and will think it
-	 * is leftover from an old task (lazy switching) and will erase it. Then
-	 * until the next context switch, no user-breakpoints will be installed.
-	 *
-	 * The real problem is that it's impossible to update both current and
-	 * physical debug registers at the same instant, so there will always be
-	 * a window in which they disagree and a breakpoint might get triggered.
-	 * Since we use lazy switching, we are forced to assume that a
-	 * disagreement means that current is correct and the exception is due
-	 * to lazy debug register switching.
-	 */
-	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
-		arch_install_thread_hw_breakpoint(next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 113b892..dc1b7b2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -451,54 +451,56 @@ static int genregs_set(struct task_struct *target,
 	return ret;
 }
 
-/*
- * Decode the length and type bits for a particular breakpoint as
- * stored in debug register 7.  Return the "enabled" status.
- */
-static int decode_dr7(unsigned long dr7, int bpnum, unsigned *len,
-		unsigned *type)
-{
-	int bp_info = dr7 >> (DR_CONTROL_SHIFT + bpnum * DR_CONTROL_SIZE);
-
-	*len = (bp_info & 0xc) | 0x40;
-	*type = (bp_info & 0x3) | 0x80;
-	return (dr7 >> (bpnum * DR_ENABLE_SIZE)) & 0x3;
-}
-
 static void ptrace_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
 {
-	struct thread_struct *thread = &(current->thread);
 	int i;
+	struct thread_struct *thread = &(current->thread);
 
 	/*
 	 * Store in the virtual DR6 register the fact that the breakpoint
 	 * was hit so the thread's debugger will see it.
 	 */
-	for (i = 0; i < hbp_kernel_pos; i++)
-		/*
-		 * We will check bp->info.address against the address stored in
-		 * thread's hbp structure and not debugreg[i]. This is to ensure
-		 * that the corresponding bit for 'i' in DR7 register is enabled
-		 */
-		if (bp->info.address == thread->hbp[i]->info.address)
+	for (i = 0; i < HBP_NUM; i++) {
+		if (thread->ptrace_bps[i] == bp)
 			break;
+	}
 
 	thread->debugreg6 |= (DR_TRAP0 << i);
 }
 
 /*
+ * Walk through every ptrace breakpoints for this thread and
+ * build the dr7 value on top of their attributes.
+ *
+ */
+static unsigned long ptrace_get_dr7(struct hw_breakpoint *bp[])
+{
+	int i;
+	int dr7 = 0;
+
+	for (i = 0; i < HBP_NUM; i++) {
+		if (bp[i] && !bp[i]->inactive)
+			dr7 |= encode_dr7(i, bp[i]->info.len, bp[i]->info.len);
+	}
+
+	return dr7;
+}
+
+/*
  * Handle ptrace writes to debug register 7.
  */
 static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
 {
 	struct thread_struct *thread = &(tsk->thread);
-	unsigned long old_dr7 = thread->debugreg7;
+	unsigned long old_dr7;
 	int i, orig_ret = 0, rc = 0;
 	int enabled, second_pass = 0;
 	unsigned len, type;
 	struct hw_breakpoint *bp;
 
 	data &= ~DR_CONTROL_RESERVED;
+
+	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
 restore:
 	/*
 	 * Loop through all the hardware breakpoints, making the
@@ -506,11 +508,12 @@ restore:
 	 */
 	for (i = 0; i < HBP_NUM; i++) {
 		enabled = decode_dr7(data, i, &len, &type);
-		bp = thread->hbp[i];
+		bp = thread->ptrace_bps[i];
 
 		if (!enabled) {
 			if (bp) {
-				/* Don't unregister the breakpoints right-away,
+				/*
+				 * Don't unregister the breakpoints right-away,
 				 * unless all register_user_hw_breakpoint()
 				 * requests have succeeded. This prevents
 				 * any window of opportunity for debug
@@ -518,26 +521,29 @@ restore:
 				 */
 				if (!second_pass)
 					continue;
-				unregister_user_hw_breakpoint(tsk, bp);
+				thread->ptrace_bps[i] = NULL;
+				unregister_hw_breakpoint(bp);
 				kfree(bp);
 			}
 			continue;
 		}
+
+		/*
+		 * We shoud have at least an inactive breakpoint at this
+		 * slot. It means the user is writing dr7 without having
+		 * written the address register first
+		 */
 		if (!bp) {
-			rc = -ENOMEM;
-			bp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
-			if (bp) {
-				bp->info.address = thread->debugreg[i];
-				bp->triggered = ptrace_triggered;
-				bp->info.len = len;
-				bp->info.type = type;
-				rc = register_user_hw_breakpoint(tsk, bp);
-				if (rc)
-					kfree(bp);
-			}
-		} else
-			rc = modify_user_hw_breakpoint(tsk, bp);
-		if (rc)
+			rc = -EINVAL;
+			break;
+		}
+
+		bp->info.len = len;
+		bp->info.type = type;
+		bp->inactive = false;
+
+		rc = modify_user_hw_breakpoint(tsk, bp);
+		if (rc) /* incorrect bp, or we have a bug in bp API */
 			break;
 	}
 	/*
@@ -563,15 +569,68 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 	struct thread_struct *thread = &(tsk->thread);
 	unsigned long val = 0;
 
-	if (n < HBP_NUM)
-		val = thread->debugreg[n];
-	else if (n == 6)
+	if (n < HBP_NUM) {
+		struct hw_breakpoint *bp;
+		bp = thread->ptrace_bps[n];
+		if (!bp)
+			return 0;
+		val = bp->info.address;
+	} else if (n == 6) {
 		val = thread->debugreg6;
-	else if (n == 7)
-		val = thread->debugreg7;
+	 } else if (n == 7) {
+		val = ptrace_get_dr7(thread->ptrace_bps);
+	}
 	return val;
 }
 
+static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
+				      unsigned long addr)
+{
+	struct hw_breakpoint *bp;
+	struct thread_struct *t = &tsk->thread;
+	bool new = false;
+	int ret;
+
+	if (!t->ptrace_bps[nr]) {
+		bp = kzalloc(sizeof(*bp), GFP_KERNEL);
+		if (!bp)
+			return -ENOMEM;
+
+		t->ptrace_bps[nr] = bp;
+		/*
+		 * Put stub len and type to register (reserve) an inactive but
+		 * correct bp
+		 */
+		bp->info.len = HW_BREAKPOINT_LEN_1;
+		bp->info.type = HW_BREAKPOINT_WRITE;
+		bp->triggered = ptrace_triggered;
+		bp->inactive = true;
+		new = true;
+	} else
+		bp = t->ptrace_bps[nr];
+
+	bp->info.address = addr;
+
+	/*
+	 * CHECKME: the previous code returned -EIO if the addr wasn't a
+	 * valid task virtual addr. The new one will return -EINVAL in this
+	 * case.
+	 * -EINVAL may be what we want for in-kernel breakpoints users, but
+	 * -EIO looks better for ptrace, since we refuse a register writing
+	 * for the user. And anyway this is the previous behaviour.
+	 */
+	if (new) {
+		ret = register_user_hw_breakpoint(tsk, bp);
+		if (ret) {
+			t->ptrace_bps[nr] = NULL;
+			kfree(bp);
+		}
+	} else
+		ret = modify_user_hw_breakpoint(tsk, bp);
+
+	return ret;
+}
+
 /*
  * Handle PTRACE_POKEUSR calls for the debug register area.
  */
@@ -585,19 +644,13 @@ int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
 		return -EIO;
 
 	if (n == 6) {
-		tsk->thread.debugreg6 = val;
+		thread->debugreg6 = val;
 		goto ret_path;
 	}
 	if (n < HBP_NUM) {
-		if (thread->hbp[n]) {
-			if (arch_check_va_in_userspace(val,
-					thread->hbp[n]->info.len) == 0) {
-				rc = -EIO;
-				goto ret_path;
-			}
-			thread->hbp[n]->info.address = val;
-		}
-		thread->debugreg[n] = val;
+		rc = ptrace_set_breakpoint_addr(tsk, n, val);
+		if (rc)
+			return rc;
 	}
 	/* All that's left is DR7 */
 	if (n == 7)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index dee0f3d..2fecda6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -63,7 +63,6 @@
 #include <asm/apic.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
-#include <asm/debugreg.h>
 #include <linux/mc146818rtc.h>
 
 #include <asm/smpboot_hooks.h>
@@ -327,7 +326,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 	setup_secondary_clock();
 
 	wmb();
-	load_debug_registers();
 	cpu_idle();
 }
 
@@ -1256,7 +1254,6 @@ void cpu_disable_common(void)
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs();
-	hw_breakpoint_disable();
 }
 
 int native_cpu_disable(void)
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 9e63db8..92bfb09 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -105,7 +105,6 @@ static void __save_processor_state(struct saved_context *ctxt)
 	ctxt->cr4 = read_cr4();
 	ctxt->cr8 = read_cr8();
 #endif
-	hw_breakpoint_disable();
 }
 
 /* Needed by apm.c */
@@ -144,11 +143,6 @@ static void fix_processor_context(void)
 #endif
 	load_TR_desc();				/* This does ltr */
 	load_LDT(&current->active_mm->context);	/* This does lldt */
-
-	/*
-	 * Now maybe reload the debug registers
-	 */
-	load_debug_registers();
 }
 
 /**
diff --git a/include/asm-generic/hw_breakpoint.h b/include/asm-generic/hw_breakpoint.h
index 9bf2d12..41369f1 100644
--- a/include/asm-generic/hw_breakpoint.h
+++ b/include/asm-generic/hw_breakpoint.h
@@ -10,6 +10,8 @@
 #include <linux/types.h>
 #include <linux/kallsyms.h>
 
+struct perf_counter;
+
 /**
  * struct hw_breakpoint - unified kernel/user-space hardware breakpoint
  * @triggered: callback invoked after target address access
@@ -103,6 +105,8 @@
 struct hw_breakpoint {
 	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
 	struct arch_hw_breakpoint info;
+	struct perf_counter	*counter;
+	bool			inactive;
 };
 
 /*
@@ -123,17 +127,19 @@ struct hw_breakpoint {
 
 extern int register_user_hw_breakpoint(struct task_struct *tsk,
 					struct hw_breakpoint *bp);
-extern int modify_user_hw_breakpoint(struct task_struct *tsk,
-					struct hw_breakpoint *bp);
-extern void unregister_user_hw_breakpoint(struct task_struct *tsk,
-						struct hw_breakpoint *bp);
+extern int
+modify_user_hw_breakpoint(struct task_struct *tsk, struct hw_breakpoint *bp);
 /*
  * Kernel breakpoints are not associated with any particular thread.
  */
-extern int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
-extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+extern int register_kernel_hw_breakpoint(struct hw_breakpoint *bp, int cpu);
+extern int register_perf_hw_breakpoint(struct perf_counter *counter);
+extern int __register_perf_hw_breakpoint(struct perf_counter *counter);
+extern void unregister_hw_breakpoint(struct hw_breakpoint *bp);
+
+struct pmu;
 
-extern unsigned int hbp_kernel_pos;
+extern struct pmu perf_ops_bp;
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_GENERIC_HW_BREAKPOINT_H */
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 1181c24..44c78ec 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -31,6 +31,7 @@ enum perf_type_id {
 	PERF_TYPE_TRACEPOINT			= 2,
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
+	PERF_TYPE_BREAKPOINT			= 5,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
@@ -464,6 +465,10 @@ struct hw_perf_counter {
 			atomic64_t	count;
 			struct hrtimer	hrtimer;
 		};
+		struct { /* hardware breakpoint */
+			struct hw_breakpoint	*bp;
+			int			counter;
+		};
 	};
 	atomic64_t			prev_count;
 	u64				sample_period;
@@ -499,7 +504,6 @@ enum perf_counter_active_state {
 	PERF_COUNTER_STATE_OFF		= -1,
 	PERF_COUNTER_STATE_INACTIVE	=  0,
 	PERF_COUNTER_STATE_ACTIVE	=  1,
-	PERF_COUNTER_STATE_UNOPENED	=  2,
 };
 
 struct file;
@@ -780,6 +784,8 @@ extern int sysctl_perf_counter_sample_rate;
 extern void perf_counter_init(void);
 extern void perf_tpcounter_event(int event_id, u64 addr, u64 count,
 				 void *record, int entry_size);
+extern void
+perf_bpcounter_event(struct hw_breakpoint *bp, struct pt_regs *regs);
 
 #ifndef perf_misc_flags
 #define perf_misc_flags(regs)	(user_mode(regs) ? PERF_EVENT_MISC_USER : \
@@ -829,6 +835,8 @@ static inline void perf_install_in_context(struct perf_counter_context *ctx,
 					   int cpu)			{ }
 static inline void
 perf_counter_remove_from_context(struct perf_counter *counter)		{ }
+static inline void
+perf_bpcounter_event(struct hw_breakpoint *bp, struct pt_regs *regs)	{ }
 
 #endif
 
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index c1f64e6..1d6a6e8 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -15,6 +15,7 @@
  *
  * Copyright (C) 2007 Alan Stern
  * Copyright (C) IBM Corporation, 2009
+ * Copyright (C) 2009, Frederic Weisbecker <fweisbec@gmail.com>
  */
 
 /*
@@ -35,179 +36,130 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 
+#include <linux/perf_counter.h>
+
 #include <asm/hw_breakpoint.h>
 #include <asm/processor.h>
 
 #ifdef CONFIG_X86
 #include <asm/debugreg.h>
 #endif
-/*
- * Spinlock that protects all (un)register operations over kernel/user-space
- * breakpoint requests
- */
-static DEFINE_SPINLOCK(hw_breakpoint_lock);
 
-/* Array of kernel-space breakpoint structures */
-struct hw_breakpoint *hbp_kernel[HBP_NUM];
+static atomic_t bp_slot;
 
-/*
- * Per-processor copy of hbp_kernel[]. Used only when hbp_kernel is being
- * modified but we need the older copy to handle any hbp exceptions. It will
- * sync with hbp_kernel[] value after updation is done through IPIs.
- */
-DEFINE_PER_CPU(struct hw_breakpoint*, this_hbp_kernel[HBP_NUM]);
+static int reserve_bp_slot(struct perf_counter *counter)
+{
+	if (atomic_inc_return(&bp_slot) == HBP_NUM) {
+		atomic_dec(&bp_slot);
 
-/*
- * Kernel breakpoints grow downwards, starting from HBP_NUM
- * 'hbp_kernel_pos' denotes lowest numbered breakpoint register occupied for
- * kernel-space request. We will initialise it here and not in an __init
- * routine because load_debug_registers(), which uses this variable can be
- * called very early during CPU initialisation.
- */
-unsigned int hbp_kernel_pos = HBP_NUM;
+		return -ENOSPC;
+	}
 
-/*
- * An array containing refcount of threads using a given bkpt register
- * Accesses are synchronised by acquiring hw_breakpoint_lock
- */
-unsigned int hbp_user_refcount[HBP_NUM];
+	return 0;
+}
 
-/*
- * Load the debug registers during startup of a CPU.
- */
-void load_debug_registers(void)
+static void release_bp_slot(struct perf_counter *counter)
 {
-	unsigned long flags;
-	struct task_struct *tsk = current;
+	atomic_dec(&bp_slot);
+}
 
-	spin_lock_bh(&hw_breakpoint_lock);
+int __register_perf_hw_breakpoint(struct perf_counter *counter)
+{
+	int ret;
+	struct hw_breakpoint *bp = counter->hw.bp;
 
-	/* Prevent IPIs for new kernel breakpoint updates */
-	local_irq_save(flags);
-	arch_update_kernel_hw_breakpoint(NULL);
-	local_irq_restore(flags);
+	ret = arch_validate_hwbkpt_settings(bp, counter->ctx->task);
+	if (ret)
+		return ret;
 
-	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
-		arch_install_thread_hw_breakpoint(tsk);
+	if (!bp->triggered)
+		return -EINVAL;
 
-	spin_unlock_bh(&hw_breakpoint_lock);
+	return 0;
 }
 
-/*
- * Erase all the hardware breakpoint info associated with a thread.
- *
- * If tsk != current then tsk must not be usable (for example, a
- * child being cleaned up from a failed fork).
+/**
+ * register_perf_hw_breakpoint - register a breakpoint for perf counter
+ * @counter: the breakpoint counter pre-initialized by perf
  */
-void flush_thread_hw_breakpoint(struct task_struct *tsk)
+int register_perf_hw_breakpoint(struct perf_counter *counter)
 {
-	int i;
-	struct thread_struct *thread = &(tsk->thread);
-
-	spin_lock_bh(&hw_breakpoint_lock);
-
-	/* The thread no longer has any breakpoints associated with it */
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
-	for (i = 0; i < HBP_NUM; i++) {
-		if (thread->hbp[i]) {
-			hbp_user_refcount[i]--;
-			kfree(thread->hbp[i]);
-			thread->hbp[i] = NULL;
-		}
-	}
+	counter->hw.bp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
+	if (!counter->hw.bp)
+		return -ENOMEM;
+
+	arch_fill_perf_breakpoint(counter);
+	counter->hw.bp->triggered = perf_bpcounter_event;
 
-	arch_flush_thread_hw_breakpoint(tsk);
+	counter->hw.bp->counter = counter;
 
-	/* Actually uninstall the breakpoints if necessary */
-	if (tsk == current)
-		arch_uninstall_thread_hw_breakpoint();
-	spin_unlock_bh(&hw_breakpoint_lock);
+	return __register_perf_hw_breakpoint(counter);
 }
 
 /*
- * Copy the hardware breakpoint info from a thread to its cloned child.
+ * Register a breakpoint bound to a task and a given cpu.
+ * If cpu is -1, the breakpoint is active for the task in every cpu
+ * If the task is -1, the breakpoint is active for every tasks in the given
+ * cpu.
  */
-int copy_thread_hw_breakpoint(struct task_struct *tsk,
-		struct task_struct *child, unsigned long clone_flags)
-{
-	/*
-	 * We will assume that breakpoint settings are not inherited
-	 * and the child starts out with no debug registers set.
-	 * But what about CLONE_PTRACE?
-	 */
-	clear_tsk_thread_flag(child, TIF_DEBUG);
-
-	/* We will call flush routine since the debugregs are not inherited */
-	arch_flush_thread_hw_breakpoint(child);
-
-	return 0;
-}
-
-static int __register_user_hw_breakpoint(int pos, struct task_struct *tsk,
-					struct hw_breakpoint *bp)
+static int register_user_hw_breakpoint_cpu(pid_t pid,
+					   struct hw_breakpoint *bp,
+					   int cpu)
 {
-	struct thread_struct *thread = &(tsk->thread);
-	int rc;
-
-	/* Do not overcommit. Fail if kernel has used the hbp registers */
-	if (pos >= hbp_kernel_pos)
-		return -ENOSPC;
+	struct perf_counter_attr *attr;
+	struct perf_counter_context *ctx;
+	struct perf_counter *counter;
+	int ret;
 
-	rc = arch_validate_hwbkpt_settings(bp, tsk);
-	if (rc)
-		return rc;
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
 
-	thread->hbp[pos] = bp;
-	hbp_user_refcount[pos]++;
-
-	arch_update_user_hw_breakpoint(pos, tsk);
+	attr->type = PERF_TYPE_BREAKPOINT;
+	attr->size = sizeof(*attr);
 	/*
-	 * Does it need to be installed right now?
-	 * Otherwise it will get installed the next time tsk runs
+	 * Such breakpoints are used by debuggers to trigger signals when
+	 * we hit the excepted memory op. We can't miss such events, they
+	 * must be pinned.
 	 */
-	if (tsk == current)
-		arch_install_thread_hw_breakpoint(tsk);
+	attr->pinned = 1;
 
-	return rc;
-}
+	if (bp->inactive)
+		attr->disabled = 1;
 
-/*
- * Modify the address of a hbp register already in use by the task
- * Do not invoke this in-lieu of a __unregister_user_hw_breakpoint()
- */
-static int __modify_user_hw_breakpoint(int pos, struct task_struct *tsk,
-					struct hw_breakpoint *bp)
-{
-	struct thread_struct *thread = &(tsk->thread);
+	ctx = find_get_context(pid, cpu);
+	if (IS_ERR(ctx)) {
+		ret = PTR_ERR(ctx);
+		goto fail_ctx;
+	}
 
-	if ((pos >= hbp_kernel_pos) || (arch_validate_hwbkpt_settings(bp, tsk)))
-		return -EINVAL;
+	/* This is not called from perf syscall, build the counter ourself */
+	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
+	if (!counter) {
+		ret = -ENOMEM;
+		goto fail_counter;
+	}
 
-	if (thread->hbp[pos] == NULL)
-		return -EINVAL;
+	counter->hw.bp = bp;
+	bp->counter = counter;
 
-	thread->hbp[pos] = bp;
-	/*
-	 * 'pos' must be that of a hbp register already used by 'tsk'
-	 * Otherwise arch_modify_user_hw_breakpoint() will fail
-	 */
-	arch_update_user_hw_breakpoint(pos, tsk);
+	ret = __perf_counter_init(counter, attr, cpu, ctx, NULL, NULL);
+	if (ret)
+		goto fail_init;
 
-	if (tsk == current)
-		arch_install_thread_hw_breakpoint(tsk);
+	perf_install_in_context(counter->ctx, counter, counter->cpu);
 
 	return 0;
-}
-
-static void __unregister_user_hw_breakpoint(int pos, struct task_struct *tsk)
-{
-	hbp_user_refcount[pos]--;
-	tsk->thread.hbp[pos] = NULL;
 
-	arch_update_user_hw_breakpoint(pos, tsk);
+fail_init:
+	kfree(counter);
+	bp->counter = NULL;
+fail_counter:
+	put_ctx(ctx);
+fail_ctx:
+	kfree(attr);
 
-	if (tsk == current)
-		arch_install_thread_hw_breakpoint(tsk);
+	return ret;
 }
 
 /**
@@ -220,149 +172,64 @@ static void __unregister_user_hw_breakpoint(int pos, struct task_struct *tsk)
  *
  */
 int register_user_hw_breakpoint(struct task_struct *tsk,
-					struct hw_breakpoint *bp)
+				struct hw_breakpoint *bp)
 {
-	struct thread_struct *thread = &(tsk->thread);
-	int i, rc = -ENOSPC;
-
-	spin_lock_bh(&hw_breakpoint_lock);
-
-	for (i = 0; i < hbp_kernel_pos; i++) {
-		if (!thread->hbp[i]) {
-			rc = __register_user_hw_breakpoint(i, tsk, bp);
-			break;
-		}
-	}
-	if (!rc)
-		set_tsk_thread_flag(tsk, TIF_DEBUG);
-
-	spin_unlock_bh(&hw_breakpoint_lock);
-	return rc;
+	return register_user_hw_breakpoint_cpu(tsk->pid, bp, -1);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
 /**
  * modify_user_hw_breakpoint - modify a user-space hardware breakpoint
- * @tsk: pointer to 'task_struct' of the process to which the address belongs
- * @bp: the breakpoint structure to unregister
+ * @bp: the breakpoint structure to modify
  *
  */
 int modify_user_hw_breakpoint(struct task_struct *tsk, struct hw_breakpoint *bp)
 {
-	struct thread_struct *thread = &(tsk->thread);
-	int i, ret = -ENOENT;
-
-	spin_lock_bh(&hw_breakpoint_lock);
-	for (i = 0; i < hbp_kernel_pos; i++) {
-		if (bp == thread->hbp[i]) {
-			ret = __modify_user_hw_breakpoint(i, tsk, bp);
-			break;
-		}
-	}
-	spin_unlock_bh(&hw_breakpoint_lock);
-	return ret;
+	/*
+	 * FIXME: do it without unregistering
+	 * - We don't want to lose our slot
+	 * - If the new bp is incorrect, don't lose the older one
+	 */
+	unregister_hw_breakpoint(bp);
+
+	return register_user_hw_breakpoint(tsk, bp);
 }
 EXPORT_SYMBOL_GPL(modify_user_hw_breakpoint);
 
 /**
- * unregister_user_hw_breakpoint - unregister a user-space hardware breakpoint
- * @tsk: pointer to 'task_struct' of the process to which the address belongs
+ * unregister_hw_breakpoint - unregister a user-space hardware breakpoint
  * @bp: the breakpoint structure to unregister
  *
+ * If you want to release the breakpoint structure after that, do it
+ * through call_rcu or after synchronize_rcu() to ensure every pending
+ * breakpoint triggered callbacks have been completed.
  */
-void unregister_user_hw_breakpoint(struct task_struct *tsk,
-						struct hw_breakpoint *bp)
+void unregister_hw_breakpoint(struct hw_breakpoint *bp)
 {
-	struct thread_struct *thread = &(tsk->thread);
-	int i, pos = -1, hbp_counter = 0;
-
-	spin_lock_bh(&hw_breakpoint_lock);
-	for (i = 0; i < hbp_kernel_pos; i++) {
-		if (thread->hbp[i])
-			hbp_counter++;
-		if (bp == thread->hbp[i])
-			pos = i;
-	}
-	if (pos >= 0) {
-		__unregister_user_hw_breakpoint(pos, tsk);
-		hbp_counter--;
-	}
-	if (!hbp_counter)
-		clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	if (!bp->counter)
+		return;
 
-	spin_unlock_bh(&hw_breakpoint_lock);
+	perf_counter_remove_from_context(bp->counter);
+	free_counter(bp->counter);
 }
-EXPORT_SYMBOL_GPL(unregister_user_hw_breakpoint);
+EXPORT_SYMBOL_GPL(unregister_hw_breakpoint);
+
 
 /**
- * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
+ * register_kernel_hw_breakpoint - register a cpu wide breakpoint in the kernel
  * @bp: the breakpoint structure to register
+ * @cpu: cpu in which we want this breakpoint to be set
  *
  * @bp.info->name or @bp.info->address, @bp.info->len, @bp.info->type and
  * @bp->triggered must be set properly before invocation
  *
  */
-int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+int register_kernel_hw_breakpoint(struct hw_breakpoint *bp, int cpu)
 {
-	int rc;
-
-	rc = arch_validate_hwbkpt_settings(bp, NULL);
-	if (rc)
-		return rc;
-
-	spin_lock_bh(&hw_breakpoint_lock);
-
-	rc = -ENOSPC;
-	/* Check if we are over-committing */
-	if ((hbp_kernel_pos > 0) && (!hbp_user_refcount[hbp_kernel_pos-1])) {
-		hbp_kernel_pos--;
-		hbp_kernel[hbp_kernel_pos] = bp;
-		on_each_cpu(arch_update_kernel_hw_breakpoint, NULL, 1);
-		rc = 0;
-	}
-
-	spin_unlock_bh(&hw_breakpoint_lock);
-	return rc;
+	return register_user_hw_breakpoint_cpu(-1, bp, cpu);
 }
 EXPORT_SYMBOL_GPL(register_kernel_hw_breakpoint);
 
-/**
- * unregister_kernel_hw_breakpoint - unregister a HW breakpoint for kernel space
- * @bp: the breakpoint structure to unregister
- *
- * Uninstalls and unregisters @bp.
- */
-void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
-{
-	int i, j;
-
-	spin_lock_bh(&hw_breakpoint_lock);
-
-	/* Find the 'bp' in our list of breakpoints for kernel */
-	for (i = hbp_kernel_pos; i < HBP_NUM; i++)
-		if (bp == hbp_kernel[i])
-			break;
-
-	/* Check if we did not find a match for 'bp'. If so return early */
-	if (i == HBP_NUM) {
-		spin_unlock_bh(&hw_breakpoint_lock);
-		return;
-	}
-
-	/*
-	 * We'll shift the breakpoints one-level above to compact if
-	 * unregistration creates a hole
-	 */
-	for (j = i; j > hbp_kernel_pos; j--)
-		hbp_kernel[j] = hbp_kernel[j-1];
-
-	hbp_kernel[hbp_kernel_pos] = NULL;
-	on_each_cpu(arch_update_kernel_hw_breakpoint, NULL, 1);
-	hbp_kernel_pos++;
-
-	spin_unlock_bh(&hw_breakpoint_lock);
-}
-EXPORT_SYMBOL_GPL(unregister_kernel_hw_breakpoint);
 
 static struct notifier_block hw_breakpoint_exceptions_nb = {
 	.notifier_call = hw_breakpoint_exceptions_notify,
@@ -374,5 +241,14 @@ static int __init init_hw_breakpoint(void)
 {
 	return register_die_notifier(&hw_breakpoint_exceptions_nb);
 }
-
 core_initcall(init_hw_breakpoint);
+
+
+struct pmu perf_ops_bp = {
+	.enable		= arch_install_hw_breakpoint,
+	.disable	= arch_uninstall_hw_breakpoint,
+	.read		= hw_breakpoint_pmu_read,
+	.unthrottle	= hw_breakpoint_pmu_unthrottle,
+	.open		= reserve_bp_slot,
+	.close		= release_bp_slot
+};
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index de62fab..5e05fd7 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -28,6 +28,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/perf_counter.h>
 
+#include <asm/hw_breakpoint.h>
 #include <asm/irq_regs.h>
 
 /*
@@ -3953,6 +3954,26 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 }
 #endif
 
+static const struct pmu *bp_perf_counter_init(struct perf_counter *counter)
+{
+	/*
+	 * The breakpoint is already filled if we haven't created the counter
+	 * through perf syscall
+	 */
+	if (!counter->hw.bp)
+		register_perf_hw_breakpoint(counter);
+	else
+		__register_perf_hw_breakpoint(counter);
+
+	return &perf_ops_bp;
+}
+
+void
+perf_bpcounter_event(struct hw_breakpoint *bp, struct pt_regs *regs)
+{
+	/* TODO (need to know where we encode the id of the bp counter) */
+}
+
 atomic_t perf_swcounter_enabled[PERF_COUNT_SW_MAX];
 
 static void sw_perf_counter_destroy(struct perf_counter *counter)
@@ -4085,6 +4106,10 @@ int __perf_counter_init(struct perf_counter *counter,
 		pmu = tp_perf_counter_init(counter);
 		break;
 
+	case PERF_TYPE_BREAKPOINT:
+		pmu = bp_perf_counter_init(counter);
+		break;
+
 	default:
 		break;
 	}
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 6d5609c..f0835a6 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/kallsyms.h>
+#include <linux/percpu.h>
 #include <linux/uaccess.h>
 #include <linux/debugfs.h>
 #include <linux/ftrace.h>
@@ -182,6 +183,7 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 {
 	struct trace_ksym *entry;
 	int ret = -ENOMEM;
+	int cpu;
 
 	if (ksym_filter_entry_count >= KSYM_TRACER_MAX) {
 		printk(KERN_ERR "ksym_tracer: Maximum limit:(%d) reached. No"
@@ -194,36 +196,53 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->ksym_hbp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
+	entry->ksym_hbp = alloc_percpu(typeof(*entry->ksym_hbp));
 	if (!entry->ksym_hbp)
-		goto err;
+		goto err_bp;
 
-	entry->ksym_hbp->info.name = kstrdup(ksymname, GFP_KERNEL);
-	if (!entry->ksym_hbp->info.name)
-		goto err;
+	entry->ksym_addr = addr;
+
+	for_each_possible_cpu(cpu) {
+		struct hw_breakpoint *bp = per_cpu_ptr(entry->ksym_hbp, cpu);
+
+		bp->info.name = kstrdup(ksymname, GFP_KERNEL);
+		if (!bp->info.name)
+			goto err_bp_cpu;
 
-	entry->ksym_hbp->info.type = op;
-	entry->ksym_addr = entry->ksym_hbp->info.address = addr;
 #ifdef CONFIG_X86
-	entry->ksym_hbp->info.len = HW_BREAKPOINT_LEN_4;
+		bp->info.type = op;
+		bp->info.address = addr;
+		bp->info.len = HW_BREAKPOINT_LEN_4;
+		bp->triggered = ksym_hbp_handler;
 #endif
-	entry->ksym_hbp->triggered = (void *)ksym_hbp_handler;
-
-	ret = register_kernel_hw_breakpoint(entry->ksym_hbp);
-	if (ret < 0) {
-		printk(KERN_INFO "ksym_tracer request failed. Try again"
-					" later!!\n");
-		ret = -EAGAIN;
-		goto err;
+		ret = register_kernel_hw_breakpoint(bp, cpu);
+		if (ret < 0) {
+			printk(KERN_INFO "ksym_tracer request failed. Try again"
+					 " later!!\n");
+			ret = -EAGAIN;
+			goto err_bp_cpu;
+		}
 	}
+
 	hlist_add_head_rcu(&(entry->ksym_hlist), &ksym_filter_head);
 	ksym_filter_entry_count++;
+
 	return 0;
-err:
-	if (entry->ksym_hbp)
-		kfree(entry->ksym_hbp->info.name);
-	kfree(entry->ksym_hbp);
+
+err_bp_cpu:
+	for_each_online_cpu(cpu) {
+		struct hw_breakpoint *bp = per_cpu_ptr(entry->ksym_hbp, cpu);
+
+		unregister_hw_breakpoint(bp);
+#ifdef CONFIG_X86
+		kfree(bp->info.name);
+#endif
+	}
+
+	free_percpu(entry->ksym_hbp);
+err_bp:
 	kfree(entry);
+
 	return ret;
 }
 
@@ -243,15 +262,29 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 
 	mutex_lock(&ksym_tracer_mutex);
 
+#ifdef CONFIG_X86
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
-		ret = trace_seq_printf(s, "%s:", entry->ksym_hbp->info.name);
-		if (entry->ksym_hbp->info.type == HW_BREAKPOINT_WRITE)
+		struct hw_breakpoint *bp = NULL;
+		int cpu;
+
+		/* take the first valid cpu breakpoint */
+		for_each_possible_cpu(cpu) {
+			bp = per_cpu_ptr(entry->ksym_hbp, cpu);
+			break;
+		}
+
+		if (!bp)
+			continue;
+
+		ret = trace_seq_printf(s, "%s:", bp->info.name);
+		if (bp->info.type == HW_BREAKPOINT_WRITE)
 			ret = trace_seq_puts(s, "-w-\n");
-		else if (entry->ksym_hbp->info.type == HW_BREAKPOINT_RW)
+		else if (bp->info.type == HW_BREAKPOINT_RW)
 			ret = trace_seq_puts(s, "rw-\n");
+
 		WARN_ON_ONCE(!ret);
 	}
-
+#endif
 	cnt = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
 
 	mutex_unlock(&ksym_tracer_mutex);
@@ -269,12 +302,19 @@ static void __ksym_trace_reset(void)
 	mutex_lock(&ksym_tracer_mutex);
 	hlist_for_each_entry_safe(entry, node, node1, &ksym_filter_head,
 								ksym_hlist) {
-		unregister_kernel_hw_breakpoint(entry->ksym_hbp);
+		struct hw_breakpoint *bp;
+		int cpu;
+
+		for_each_possible_cpu(cpu) {
+			bp = per_cpu_ptr(entry->ksym_hbp, cpu);
+			unregister_hw_breakpoint(bp);
+			kfree(bp->info.name);
+		}
+
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
-		kfree(entry->ksym_hbp->info.name);
-		kfree(entry->ksym_hbp);
+		free_percpu(entry->ksym_hbp);
 		kfree(entry);
 	}
 	mutex_unlock(&ksym_tracer_mutex);
@@ -326,27 +366,42 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	ret = -EINVAL;
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
 		if (entry->ksym_addr == ksym_addr) {
-			/* Check for malformed request: (6) */
-			if (entry->ksym_hbp->info.type != op)
-				changed = 1;
-			else
-				goto out;
-			break;
+			int cpu;
+
+			for_each_possible_cpu(cpu) {
+				struct hw_breakpoint *bp;
+
+				bp = per_cpu_ptr(entry->ksym_hbp, cpu);
+
+				/* Check for malformed request: (6) */
+				if (bp->info.type != op)
+					changed = 1;
+				else
+					goto out;
+				break;
+			}
 		}
 	}
 	if (changed) {
-		unregister_kernel_hw_breakpoint(entry->ksym_hbp);
-		entry->ksym_hbp->info.type = op;
-		if (op > 0) {
-			ret = register_kernel_hw_breakpoint(entry->ksym_hbp);
-			if (ret == 0)
-				goto out;
+		int cpu;
+
+		for_each_possible_cpu(cpu) {
+			struct hw_breakpoint *bp;
+
+			bp = per_cpu_ptr(entry->ksym_hbp, cpu);
+			unregister_hw_breakpoint(bp);
+			bp->info.type = op;
+			if (op > 0) {
+				ret = register_kernel_hw_breakpoint(bp, 0);
+				if (ret == 0)
+					goto out;
+			}
+			kfree(bp->info.name);
 		}
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
-		kfree(entry->ksym_hbp->info.name);
-		kfree(entry->ksym_hbp);
+		free_percpu(entry->ksym_hbp);
 		kfree(entry);
 		ret = 0;
 		goto out;
@@ -487,11 +542,21 @@ static int ksym_tracer_stat_show(struct seq_file *m, void *v)
 	struct trace_ksym *entry;
 	int access_type = 0;
 	char fn_name[KSYM_NAME_LEN];
+	struct hw_breakpoint *bp = NULL;
+	int cpu;
 
 	entry = hlist_entry(stat, struct trace_ksym, ksym_hlist);
+	if (!entry->ksym_hbp)
+		return 0;
+
+	for_each_possible_cpu(cpu) {
+		bp = per_cpu_ptr(entry->ksym_hbp, cpu);
+		break;
+	}
+	if (!bp)
+		return 0;
 
-	if (entry->ksym_hbp)
-		access_type = entry->ksym_hbp->info.type;
+	access_type = bp->info.type;
 
 	switch (access_type) {
 	case HW_BREAKPOINT_WRITE:
-- 
1.6.2.3

