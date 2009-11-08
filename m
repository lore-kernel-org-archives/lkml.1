Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZKHP3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZKHP3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZKHP3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:29:47 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:57937 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbZKHP3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:29:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C2yyk2pJ0HqJF8mpP8xVyP3QXMud6Uhy5JE0oRvCAAvBr0d4H1nQxpmFAsQ9ZX4VDW
         KO63H4twQCHgRV68mJ/DfKfe3JdpwNnlmwl2CFuxcWuW/lYJm2vnPc91wqORTg7PnFMO
         26Ke0MqT/ygCVq6Nu1OdY5GZ0mofLa8u3Q1WA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/7 v6] hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf events
Date: Sun,  8 Nov 2009 16:28:59 +0100
Message-Id: <1257694141-5670-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch rebase the implementation of the breakpoints API on top of
perf events instances.

Each breakpoints are now perf events that handle the
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

              Breakpoints perf events

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

- Support breakpoints perf counter events for perf tools (ie: implement
  perf_bpcounter_event())
- Support from perf tools

Changes in v2:

- Follow the perf "event " rename
- The ptrace regression have been fixed (ptrace breakpoint perf events
  weren't released when a task ended)
- Drop the struct hw_breakpoint and store generic fields in
  perf_event_attr.
- Separate core and arch specific headers, drop
  asm-generic/hw_breakpoint.h and create linux/hw_breakpoint.h
- Use new generic len/type for breakpoint
- Handle off case: when breakpoints api is not supported by an arch

Changes in v3:

- Fix broken CONFIG_KVM, we need to propagate the breakpoint api
  changes to kvm when we exit the guest and restore the bp registers
  to the host.

Changes in v4:

- Drop the hw_breakpoint_restore() stub as it is only used by KVM
- EXPORT_SYMBOL_GPL hw_breakpoint_restore() as KVM can be built as a
  module
- Restore the breakpoints unconditionally on kvm guest exit:
  TIF_DEBUG_THREAD doesn't anymore cover every cases of running
  breakpoints and vcpu->arch.switch_db_regs might not always be
  set when the guest used debug registers.
  (Waiting for a reliable optimization)

Changes in v5:

- Split-up the asm-generic/hw-breakpoint.h moving to
  linux/hw_breakpoint.h into a separate patch
- Optimize the breakpoints restoring while switching from kvm guest
  to host. We only want to restore the state if we have active
  breakpoints to the host, otherwise we don't care about messed-up
  address registers.
- Add asm/hw_breakpoint.h to Kbuild
- Fix bad breakpoint type in trace_selftest.c

Changes in v6:

- Fix wrong header inclusion in trace.h (triggered a build
  error with CONFIG_FTRACE_SELFTEST

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kiszka <jan.kiszka@web.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/Kconfig                         |    3 +
 arch/x86/include/asm/Kbuild          |    1 +
 arch/x86/include/asm/debugreg.h      |   11 +-
 arch/x86/include/asm/hw_breakpoint.h |   58 +++--
 arch/x86/include/asm/processor.h     |   12 +-
 arch/x86/kernel/hw_breakpoint.c      |  391 ++++++++++++++++++++-----------
 arch/x86/kernel/process.c            |    7 +-
 arch/x86/kernel/process_32.c         |   26 +--
 arch/x86/kernel/process_64.c         |   26 +--
 arch/x86/kernel/ptrace.c             |  182 ++++++++++-----
 arch/x86/kernel/smpboot.c            |    3 -
 arch/x86/kvm/x86.c                   |   18 +-
 arch/x86/power/cpu.c                 |    6 -
 include/linux/hw_breakpoint.h        |  243 ++++++++++----------
 include/linux/perf_event.h           |   26 ++-
 kernel/exit.c                        |    5 +
 kernel/hw_breakpoint.c               |  424 ++++++++++++++--------------------
 kernel/perf_event.c                  |   53 ++++-
 kernel/trace/trace.h                 |    5 +-
 kernel/trace/trace_entries.h         |    6 +-
 kernel/trace/trace_ksym.c            |  126 +++++------
 kernel/trace/trace_selftest.c        |    3 +-
 22 files changed, 885 insertions(+), 750 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index acb6643..eef3bbb 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -128,6 +128,9 @@ config HAVE_DEFAULT_NO_SPIN_MUTEXES
 
 config HAVE_HW_BREAKPOINT
 	bool
+	depends on HAVE_PERF_EVENTS
+	select ANON_INODES
+	select PERF_EVENTS
 
 
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 4a8e80c..9f828f8 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -10,6 +10,7 @@ header-y += ptrace-abi.h
 header-y += sigcontext32.h
 header-y += ucontext.h
 header-y += processor-flags.h
+header-y += hw_breakpoint.h
 
 unifdef-y += e820.h
 unifdef-y += ist.h
diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 23439fb..9a3333c 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -75,13 +75,8 @@
  */
 #ifdef __KERNEL__
 
-/* For process management */
-extern void flush_thread_hw_breakpoint(struct task_struct *tsk);
-extern int copy_thread_hw_breakpoint(struct task_struct *tsk,
-		struct task_struct *child, unsigned long clone_flags);
+DECLARE_PER_CPU(unsigned long, dr7);
 
-/* For CPU management */
-extern void load_debug_registers(void);
 static inline void hw_breakpoint_disable(void)
 {
 	/* Zero the control register for HW Breakpoint */
@@ -94,6 +89,10 @@ static inline void hw_breakpoint_disable(void)
 	set_debugreg(0UL, 3);
 }
 
+#ifdef CONFIG_KVM
+extern void hw_breakpoint_restore(void);
+#endif
+
 #endif	/* __KERNEL__ */
 
 #endif /* _ASM_X86_DEBUGREG_H */
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 3cfca8e..0675a7c 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -4,6 +4,11 @@
 #ifdef	__KERNEL__
 #define	__ARCH_HW_BREAKPOINT_H
 
+/*
+ * The name should probably be something dealt in
+ * a higher level. While dealing with the user
+ * (display/resolving)
+ */
 struct arch_hw_breakpoint {
 	char		*name; /* Contains name of the symbol to set bkpt */
 	unsigned long	address;
@@ -12,44 +17,57 @@ struct arch_hw_breakpoint {
 };
 
 #include <linux/kdebug.h>
-#include <linux/hw_breakpoint.h>
+#include <linux/percpu.h>
+#include <linux/list.h>
 
 /* Available HW breakpoint length encodings */
-#define HW_BREAKPOINT_LEN_1		0x40
-#define HW_BREAKPOINT_LEN_2		0x44
-#define HW_BREAKPOINT_LEN_4		0x4c
-#define HW_BREAKPOINT_LEN_EXECUTE	0x40
+#define X86_BREAKPOINT_LEN_1		0x40
+#define X86_BREAKPOINT_LEN_2		0x44
+#define X86_BREAKPOINT_LEN_4		0x4c
+#define X86_BREAKPOINT_LEN_EXECUTE	0x40
 
 #ifdef CONFIG_X86_64
-#define HW_BREAKPOINT_LEN_8		0x48
+#define X86_BREAKPOINT_LEN_8		0x48
 #endif
 
 /* Available HW breakpoint type encodings */
 
 /* trigger on instruction execute */
-#define HW_BREAKPOINT_EXECUTE	0x80
+#define X86_BREAKPOINT_EXECUTE	0x80
 /* trigger on memory write */
-#define HW_BREAKPOINT_WRITE	0x81
+#define X86_BREAKPOINT_WRITE	0x81
 /* trigger on memory read or write */
-#define HW_BREAKPOINT_RW	0x83
+#define X86_BREAKPOINT_RW	0x83
 
 /* Total number of available HW breakpoint registers */
 #define HBP_NUM 4
 
-extern struct hw_breakpoint *hbp_kernel[HBP_NUM];
-DECLARE_PER_CPU(struct hw_breakpoint*, this_hbp_kernel[HBP_NUM]);
-extern unsigned int hbp_user_refcount[HBP_NUM];
+struct perf_event;
+struct pmu;
 
-extern void arch_install_thread_hw_breakpoint(struct task_struct *tsk);
-extern void arch_uninstall_thread_hw_breakpoint(void);
 extern int arch_check_va_in_userspace(unsigned long va, u8 hbp_len);
-extern int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
-						struct task_struct *tsk);
-extern void arch_update_user_hw_breakpoint(int pos, struct task_struct *tsk);
-extern void arch_flush_thread_hw_breakpoint(struct task_struct *tsk);
-extern void arch_update_kernel_hw_breakpoint(void *);
+extern int arch_validate_hwbkpt_settings(struct perf_event *bp,
+					 struct task_struct *tsk);
 extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
-				     unsigned long val, void *data);
+					   unsigned long val, void *data);
+
+
+int arch_install_hw_breakpoint(struct perf_event *bp);
+void arch_uninstall_hw_breakpoint(struct perf_event *bp);
+void hw_breakpoint_pmu_read(struct perf_event *bp);
+void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
+
+extern void
+arch_fill_perf_breakpoint(struct perf_event *bp);
+
+unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type);
+int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type);
+
+extern int arch_bp_generic_fields(int x86_len, int x86_type,
+				  int *gen_len, int *gen_type);
+
+extern struct pmu perf_ops_bp;
+
 #endif	/* __KERNEL__ */
 #endif	/* _I386_HW_BREAKPOINT_H */
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 61aafb7..820f300 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -423,6 +423,8 @@ extern unsigned int xstate_size;
 extern void free_thread_xstate(struct task_struct *);
 extern struct kmem_cache *task_xstate_cachep;
 
+struct perf_event;
+
 struct thread_struct {
 	/* Cached TLS descriptors: */
 	struct desc_struct	tls_array[GDT_ENTRY_TLS_ENTRIES];
@@ -444,12 +446,10 @@ struct thread_struct {
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
+	struct perf_event	*ptrace_bps[HBP_NUM];
+	/* Debug status used for traps, single steps, etc... */
+	unsigned long           debugreg6;
 	/* Fault info: */
 	unsigned long		cr2;
 	unsigned long		trap_no;
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 9316a9d..e622620 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -15,6 +15,7 @@
  *
  * Copyright (C) 2007 Alan Stern
  * Copyright (C) 2009 IBM Corporation
+ * Copyright (C) 2009 Frederic Weisbecker <fweisbec@gmail.com>
  */
 
 /*
@@ -22,6 +23,8 @@
  * using the CPU's debug registers.
  */
 
+#include <linux/perf_event.h>
+#include <linux/hw_breakpoint.h>
 #include <linux/irqflags.h>
 #include <linux/notifier.h>
 #include <linux/kallsyms.h>
@@ -38,26 +41,24 @@
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 
-/* Unmasked kernel DR7 value */
-static unsigned long kdr7;
+/* Per cpu debug control register value */
+DEFINE_PER_CPU(unsigned long, dr7);
+
+/* Per cpu debug address registers values */
+static DEFINE_PER_CPU(unsigned long, cpu_debugreg[HBP_NUM]);
 
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
+static DEFINE_PER_CPU(struct perf_event *, bp_per_reg[HBP_NUM]);
 
 
 /*
  * Encode the length, type, Exact, and Enable bits for a particular breakpoint
  * as stored in debug register 7.
  */
-static unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type)
+unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type)
 {
 	unsigned long bp_info;
 
@@ -68,64 +69,89 @@ static unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type)
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
+int arch_install_hw_breakpoint(struct perf_event *bp)
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
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	unsigned long *dr7;
+	int i;
+
+	for (i = 0; i < HBP_NUM; i++) {
+		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);
+
+		if (!*slot) {
+			*slot = bp;
+			break;
+		}
 	}
 
-	/* No need to set DR6 */
-	set_debugreg((kdr7 | thread->debugreg7), 7);
+	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
+		return -EBUSY;
+
+	set_debugreg(info->address, i);
+	__get_cpu_var(cpu_debugreg[i]) = info->address;
+
+	dr7 = &__get_cpu_var(dr7);
+	*dr7 |= encode_dr7(i, info->len, info->type);
+
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
+void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 {
-	/* Clear the user-space portion of debugreg7 by setting only kdr7 */
-	set_debugreg(kdr7, 7);
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	unsigned long *dr7;
+	int i;
+
+	for (i = 0; i < HBP_NUM; i++) {
+		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);
+
+		if (*slot == bp) {
+			*slot = NULL;
+			break;
+		}
+	}
+
+	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
+		return;
 
+	dr7 = &__get_cpu_var(dr7);
+	*dr7 &= ~encode_dr7(i, info->len, info->type);
+
+	set_debugreg(*dr7, 7);
 }
 
 static int get_hbp_len(u8 hbp_len)
@@ -133,17 +159,17 @@ static int get_hbp_len(u8 hbp_len)
 	unsigned int len_in_bytes = 0;
 
 	switch (hbp_len) {
-	case HW_BREAKPOINT_LEN_1:
+	case X86_BREAKPOINT_LEN_1:
 		len_in_bytes = 1;
 		break;
-	case HW_BREAKPOINT_LEN_2:
+	case X86_BREAKPOINT_LEN_2:
 		len_in_bytes = 2;
 		break;
-	case HW_BREAKPOINT_LEN_4:
+	case X86_BREAKPOINT_LEN_4:
 		len_in_bytes = 4;
 		break;
 #ifdef CONFIG_X86_64
-	case HW_BREAKPOINT_LEN_8:
+	case X86_BREAKPOINT_LEN_8:
 		len_in_bytes = 8;
 		break;
 #endif
@@ -178,67 +204,146 @@ static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
 /*
  * Store a breakpoint's encoded address, length, and type.
  */
-static int arch_store_info(struct hw_breakpoint *bp, struct task_struct *tsk)
+static int arch_store_info(struct perf_event *bp)
 {
-	/*
-	 * User-space requests will always have the address field populated
-	 * Symbol names from user-space are rejected
-	 */
-	if (tsk && bp->info.name)
-		return -EINVAL;
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
 	/*
 	 * For kernel-addresses, either the address or symbol name can be
 	 * specified.
 	 */
-	if (bp->info.name)
-		bp->info.address = (unsigned long)
-					kallsyms_lookup_name(bp->info.name);
-	if (bp->info.address)
+	if (info->name)
+		info->address = (unsigned long)
+				kallsyms_lookup_name(info->name);
+	if (info->address)
 		return 0;
+
 	return -EINVAL;
 }
 
-/*
- * Validate the arch-specific HW Breakpoint register settings
- */
-int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
-						struct task_struct *tsk)
+int arch_bp_generic_fields(int x86_len, int x86_type,
+			   int *gen_len, int *gen_type)
 {
-	unsigned int align;
-	int ret = -EINVAL;
+	/* Len */
+	switch (x86_len) {
+	case X86_BREAKPOINT_LEN_1:
+		*gen_len = HW_BREAKPOINT_LEN_1;
+		break;
+	case X86_BREAKPOINT_LEN_2:
+		*gen_len = HW_BREAKPOINT_LEN_2;
+		break;
+	case X86_BREAKPOINT_LEN_4:
+		*gen_len = HW_BREAKPOINT_LEN_4;
+		break;
+#ifdef CONFIG_X86_64
+	case X86_BREAKPOINT_LEN_8:
+		*gen_len = HW_BREAKPOINT_LEN_8;
+		break;
+#endif
+	default:
+		return -EINVAL;
+	}
 
-	switch (bp->info.type) {
-	/*
-	 * Ptrace-refactoring code
-	 * For now, we'll allow instruction breakpoint only for user-space
-	 * addresses
-	 */
-	case HW_BREAKPOINT_EXECUTE:
-		if ((!arch_check_va_in_userspace(bp->info.address,
-							bp->info.len)) &&
-			bp->info.len != HW_BREAKPOINT_LEN_EXECUTE)
-			return ret;
+	/* Type */
+	switch (x86_type) {
+	case X86_BREAKPOINT_EXECUTE:
+		*gen_type = HW_BREAKPOINT_X;
 		break;
-	case HW_BREAKPOINT_WRITE:
+	case X86_BREAKPOINT_WRITE:
+		*gen_type = HW_BREAKPOINT_W;
 		break;
-	case HW_BREAKPOINT_RW:
+	case X86_BREAKPOINT_RW:
+		*gen_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
 		break;
 	default:
-		return ret;
+		return -EINVAL;
 	}
 
-	switch (bp->info.len) {
+	return 0;
+}
+
+
+static int arch_build_bp_info(struct perf_event *bp)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+
+	info->address = bp->attr.bp_addr;
+
+	/* Len */
+	switch (bp->attr.bp_len) {
 	case HW_BREAKPOINT_LEN_1:
-		align = 0;
+		info->len = X86_BREAKPOINT_LEN_1;
 		break;
 	case HW_BREAKPOINT_LEN_2:
-		align = 1;
+		info->len = X86_BREAKPOINT_LEN_2;
 		break;
 	case HW_BREAKPOINT_LEN_4:
-		align = 3;
+		info->len = X86_BREAKPOINT_LEN_4;
 		break;
 #ifdef CONFIG_X86_64
 	case HW_BREAKPOINT_LEN_8:
+		info->len = X86_BREAKPOINT_LEN_8;
+		break;
+#endif
+	default:
+		return -EINVAL;
+	}
+
+	/* Type */
+	switch (bp->attr.bp_type) {
+	case HW_BREAKPOINT_W:
+		info->type = X86_BREAKPOINT_WRITE;
+		break;
+	case HW_BREAKPOINT_W | HW_BREAKPOINT_R:
+		info->type = X86_BREAKPOINT_RW;
+		break;
+	case HW_BREAKPOINT_X:
+		info->type = X86_BREAKPOINT_EXECUTE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+/*
+ * Validate the arch-specific HW Breakpoint register settings
+ */
+int arch_validate_hwbkpt_settings(struct perf_event *bp,
+				  struct task_struct *tsk)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	unsigned int align;
+	int ret;
+
+
+	ret = arch_build_bp_info(bp);
+	if (ret)
+		return ret;
+
+	ret = -EINVAL;
+
+	if (info->type == X86_BREAKPOINT_EXECUTE)
+		/*
+		 * Ptrace-refactoring code
+		 * For now, we'll allow instruction breakpoint only for user-space
+		 * addresses
+		 */
+		if ((!arch_check_va_in_userspace(info->address, info->len)) &&
+			info->len != X86_BREAKPOINT_EXECUTE)
+			return ret;
+
+	switch (info->len) {
+	case X86_BREAKPOINT_LEN_1:
+		align = 0;
+		break;
+	case X86_BREAKPOINT_LEN_2:
+		align = 1;
+		break;
+	case X86_BREAKPOINT_LEN_4:
+		align = 3;
+		break;
+#ifdef CONFIG_X86_64
+	case X86_BREAKPOINT_LEN_8:
 		align = 7;
 		break;
 #endif
@@ -246,8 +351,8 @@ int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
 		return ret;
 	}
 
-	if (bp->triggered)
-		ret = arch_store_info(bp, tsk);
+	if (bp->callback)
+		ret = arch_store_info(bp);
 
 	if (ret < 0)
 		return ret;
@@ -255,44 +360,47 @@ int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
 	 * Check that the low-order bits of the address are appropriate
 	 * for the alignment implied by len.
 	 */
-	if (bp->info.address & align)
+	if (info->address & align)
 		return -EINVAL;
 
 	/* Check that the virtual address is in the proper range */
 	if (tsk) {
-		if (!arch_check_va_in_userspace(bp->info.address, bp->info.len))
+		if (!arch_check_va_in_userspace(info->address, info->len))
 			return -EFAULT;
 	} else {
-		if (!arch_check_va_in_kernelspace(bp->info.address,
-								bp->info.len))
+		if (!arch_check_va_in_kernelspace(info->address, info->len))
 			return -EFAULT;
 	}
+
 	return 0;
 }
 
-void arch_update_user_hw_breakpoint(int pos, struct task_struct *tsk)
+/*
+ * Release the user breakpoints used by ptrace
+ */
+void flush_ptrace_hw_breakpoint(struct task_struct *tsk)
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
+	int i;
+	struct thread_struct *t = &tsk->thread;
+
+	for (i = 0; i < HBP_NUM; i++) {
+		unregister_hw_breakpoint(t->ptrace_bps[i]);
+		t->ptrace_bps[i] = NULL;
+	}
 }
 
-void arch_flush_thread_hw_breakpoint(struct task_struct *tsk)
+#ifdef CONFIG_KVM
+void hw_breakpoint_restore(void)
 {
-	int i;
-	struct thread_struct *thread = &(tsk->thread);
-
-	thread->debugreg7 = 0;
-	for (i = 0; i < HBP_NUM; i++)
-		thread->debugreg[i] = 0;
+	set_debugreg(__get_cpu_var(cpu_debugreg[0]), 0);
+	set_debugreg(__get_cpu_var(cpu_debugreg[1]), 1);
+	set_debugreg(__get_cpu_var(cpu_debugreg[2]), 2);
+	set_debugreg(__get_cpu_var(cpu_debugreg[3]), 3);
+	set_debugreg(current->thread.debugreg6, 6);
+	set_debugreg(__get_cpu_var(dr7), 7);
 }
+EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
+#endif
 
 /*
  * Handle debug exception notifications.
@@ -313,7 +421,7 @@ void arch_flush_thread_hw_breakpoint(struct task_struct *tsk)
 static int __kprobes hw_breakpoint_handler(struct die_args *args)
 {
 	int i, cpu, rc = NOTIFY_STOP;
-	struct hw_breakpoint *bp;
+	struct perf_event *bp;
 	unsigned long dr7, dr6;
 	unsigned long *dr6_p;
 
@@ -325,10 +433,6 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 	if ((dr6 & DR_TRAP_BITS) == 0)
 		return NOTIFY_DONE;
 
-	/* Lazy debug register switching */
-	if (!test_tsk_thread_flag(current, TIF_DEBUG))
-		arch_uninstall_thread_hw_breakpoint();
-
 	get_debugreg(dr7, 7);
 	/* Disable breakpoints during exception handling */
 	set_debugreg(0UL, 7);
@@ -344,17 +448,18 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
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
@@ -362,19 +467,23 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
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
+
+		(bp->callback)(bp, args->regs);
 
-		(bp->triggered)(bp, args->regs);
+		rcu_read_unlock();
 	}
 	if (dr6 & (~DR_TRAP_BITS))
 		rc = NOTIFY_DONE;
 
 	set_debugreg(dr7, 7);
 	put_cpu();
+
 	return rc;
 }
 
@@ -389,3 +498,13 @@ int __kprobes hw_breakpoint_exceptions_notify(
 
 	return hw_breakpoint_handler(data);
 }
+
+void hw_breakpoint_pmu_read(struct perf_event *bp)
+{
+	/* TODO */
+}
+
+void hw_breakpoint_pmu_unthrottle(struct perf_event *bp)
+{
+	/* TODO */
+}
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index cf8ee00..744508e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -10,6 +10,7 @@
 #include <linux/clockchips.h>
 #include <linux/random.h>
 #include <trace/events/power.h>
+#include <linux/hw_breakpoint.h>
 #include <asm/system.h>
 #include <asm/apic.h>
 #include <asm/syscalls.h>
@@ -18,7 +19,6 @@
 #include <asm/i387.h>
 #include <asm/ds.h>
 #include <asm/debugreg.h>
-#include <asm/hw_breakpoint.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
@@ -47,8 +47,6 @@ void free_thread_xstate(struct task_struct *tsk)
 		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
 		tsk->thread.xstate = NULL;
 	}
-	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
-		flush_thread_hw_breakpoint(tsk);
 
 	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
@@ -107,8 +105,7 @@ void flush_thread(void)
 	}
 #endif
 
-	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
-		flush_thread_hw_breakpoint(tsk);
+	flush_ptrace_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
 	/*
 	 * Forget coprocessor state..
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 209e748..d5bd313 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -59,7 +59,6 @@
 #include <asm/syscalls.h>
 #include <asm/ds.h>
 #include <asm/debugreg.h>
-#include <asm/hw_breakpoint.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -264,9 +263,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.io_bitmap_ptr = NULL;
 	tsk = current;
 	err = -ENOMEM;
-	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
-		if (copy_thread_hw_breakpoint(tsk, p, clone_flags))
-			goto out;
+
+	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
@@ -287,13 +285,10 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		err = do_set_thread_area(p, -1,
 			(struct user_desc __user *)childregs->si, 0);
 
-out:
 	if (err && p->thread.io_bitmap_ptr) {
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
-	if (err)
-		flush_thread_hw_breakpoint(p);
 
 	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
 	p->thread.ds_ctx = NULL;
@@ -437,23 +432,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
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
index 72edac0..5bafdec 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -53,7 +53,6 @@
 #include <asm/syscalls.h>
 #include <asm/ds.h>
 #include <asm/debugreg.h>
-#include <asm/hw_breakpoint.h>
 
 asmlinkage extern void ret_from_fork(void);
 
@@ -244,8 +243,6 @@ void release_thread(struct task_struct *dead_task)
 			BUG();
 		}
 	}
-	if (unlikely(dead_task->thread.debugreg7))
-		flush_thread_hw_breakpoint(dead_task);
 }
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
@@ -309,9 +306,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	savesegment(ds, p->thread.ds);
 
 	err = -ENOMEM;
-	if (unlikely(test_tsk_thread_flag(me, TIF_DEBUG)))
-		if (copy_thread_hw_breakpoint(me, p, clone_flags))
-			goto out;
+	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
@@ -351,8 +346,6 @@ out:
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
-	if (err)
-		flush_thread_hw_breakpoint(p);
 
 	return err;
 }
@@ -508,23 +501,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	if (preload_fpu)
 		__math_state_restore();
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
index 267cb85..e79610d 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -22,6 +22,8 @@
 #include <linux/seccomp.h>
 #include <linux/signal.h>
 #include <linux/workqueue.h>
+#include <linux/perf_event.h>
+#include <linux/hw_breakpoint.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -441,54 +443,59 @@ static int genregs_set(struct task_struct *target,
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
-static void ptrace_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
+static void ptrace_triggered(struct perf_event *bp, void *data)
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
+static unsigned long ptrace_get_dr7(struct perf_event *bp[])
+{
+	int i;
+	int dr7 = 0;
+	struct arch_hw_breakpoint *info;
+
+	for (i = 0; i < HBP_NUM; i++) {
+		if (bp[i] && !bp[i]->attr.disabled) {
+			info = counter_arch_bp(bp[i]);
+			dr7 |= encode_dr7(i, info->len, info->type);
+		}
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
-	struct hw_breakpoint *bp;
+	int gen_len, gen_type;
+	struct perf_event *bp;
 
 	data &= ~DR_CONTROL_RESERVED;
+	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
 restore:
 	/*
 	 * Loop through all the hardware breakpoints, making the
@@ -496,11 +503,12 @@ restore:
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
@@ -508,27 +516,45 @@ restore:
 				 */
 				if (!second_pass)
 					continue;
-				unregister_user_hw_breakpoint(tsk, bp);
-				kfree(bp);
+				thread->ptrace_bps[i] = NULL;
+				unregister_hw_breakpoint(bp);
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
+			rc = -EINVAL;
+			break;
+		}
+
+		rc = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
 		if (rc)
 			break;
+
+		/*
+		 * This is a temporary thing as bp is unregistered/registered
+		 * to simulate modification
+		 */
+		bp = modify_user_hw_breakpoint(bp, bp->attr.bp_addr, gen_len,
+					       gen_type, bp->callback,
+					       tsk, true);
+		thread->ptrace_bps[i] = NULL;
+
+		if (!bp) { /* incorrect bp, or we have a bug in bp API */
+			rc = -EINVAL;
+			break;
+		}
+		if (IS_ERR(bp)) {
+			rc = PTR_ERR(bp);
+			bp = NULL;
+			break;
+		}
+		thread->ptrace_bps[i] = bp;
 	}
 	/*
 	 * Make a second pass to free the remaining unused breakpoints
@@ -553,15 +579,63 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 	struct thread_struct *thread = &(tsk->thread);
 	unsigned long val = 0;
 
-	if (n < HBP_NUM)
-		val = thread->debugreg[n];
-	else if (n == 6)
+	if (n < HBP_NUM) {
+		struct perf_event *bp;
+		bp = thread->ptrace_bps[n];
+		if (!bp)
+			return 0;
+		val = bp->hw.info.address;
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
+	struct perf_event *bp;
+	struct thread_struct *t = &tsk->thread;
+
+	if (!t->ptrace_bps[nr]) {
+		/*
+		 * Put stub len and type to register (reserve) an inactive but
+		 * correct bp
+		 */
+		bp = register_user_hw_breakpoint(addr, HW_BREAKPOINT_LEN_1,
+						 HW_BREAKPOINT_W,
+						 ptrace_triggered, tsk,
+						 false);
+	} else {
+		bp = t->ptrace_bps[nr];
+		t->ptrace_bps[nr] = NULL;
+		bp = modify_user_hw_breakpoint(bp, addr, bp->attr.bp_len,
+					       bp->attr.bp_type,
+					       bp->callback,
+					       tsk,
+					       bp->attr.disabled);
+	}
+
+	if (!bp)
+		return -EIO;
+	/*
+	 * CHECKME: the previous code returned -EIO if the addr wasn't a
+	 * valid task virtual addr. The new one will return -EINVAL in this
+	 * case.
+	 * -EINVAL may be what we want for in-kernel breakpoints users, but
+	 * -EIO looks better for ptrace, since we refuse a register writing
+	 * for the user. And anyway this is the previous behaviour.
+	 */
+	if (IS_ERR(bp))
+		return PTR_ERR(bp);
+
+	t->ptrace_bps[nr] = bp;
+
+	return 0;
+}
+
 /*
  * Handle PTRACE_POKEUSR calls for the debug register area.
  */
@@ -575,19 +649,13 @@ int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
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
index 213a7a3..565ebc6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -64,7 +64,6 @@
 #include <asm/apic.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
-#include <asm/debugreg.h>
 #include <linux/mc146818rtc.h>
 
 #include <asm/smpboot_hooks.h>
@@ -328,7 +327,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 	x86_cpuinit.setup_percpu_clockev();
 
 	wmb();
-	load_debug_registers();
 	cpu_idle();
 }
 
@@ -1269,7 +1267,6 @@ void cpu_disable_common(void)
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs();
-	hw_breakpoint_disable();
 }
 
 int native_cpu_disable(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fc2974a..22dee7a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -42,6 +42,7 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+#include <asm/debugreg.h>
 #include <asm/uaccess.h>
 #include <asm/msr.h>
 #include <asm/desc.h>
@@ -3643,14 +3644,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	trace_kvm_entry(vcpu->vcpu_id);
 	kvm_x86_ops->run(vcpu, kvm_run);
 
-	if (unlikely(vcpu->arch.switch_db_regs || test_thread_flag(TIF_DEBUG))) {
-		set_debugreg(current->thread.debugreg[0], 0);
-		set_debugreg(current->thread.debugreg[1], 1);
-		set_debugreg(current->thread.debugreg[2], 2);
-		set_debugreg(current->thread.debugreg[3], 3);
-		set_debugreg(current->thread.debugreg6, 6);
-		set_debugreg(current->thread.debugreg7, 7);
-	}
+	/*
+	 * If the guest has used debug registers, at least dr7
+	 * will be disabled while returning to the host.
+	 * If we don't have active breakpoints in the host, we don't
+	 * care about the messed up debug address registers. But if
+	 * we have some of them active, restore the old state.
+	 */
+	if (__get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK)
+		hw_breakpoint_restore();
 
 	set_bit(KVM_REQ_KICK, &vcpu->requests);
 	local_irq_enable();
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index e09a44f..0a979f3 100644
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
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 61ccc8f..7eba9b9 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -1,136 +1,131 @@
 #ifndef _LINUX_HW_BREAKPOINT_H
 #define _LINUX_HW_BREAKPOINT_H
 
+#include <linux/perf_event.h>
 
-#ifdef	__KERNEL__
-#include <linux/list.h>
-#include <linux/types.h>
-#include <linux/kallsyms.h>
-
-/**
- * struct hw_breakpoint - unified kernel/user-space hardware breakpoint
- * @triggered: callback invoked after target address access
- * @info: arch-specific breakpoint info (address, length, and type)
- *
- * %hw_breakpoint structures are the kernel's way of representing
- * hardware breakpoints.  These are data breakpoints
- * (also known as "watchpoints", triggered on data access), and the breakpoint's
- * target address can be located in either kernel space or user space.
- *
- * The breakpoint's address, length, and type are highly
- * architecture-specific.  The values are encoded in the @info field; you
- * specify them when registering the breakpoint.  To examine the encoded
- * values use hw_breakpoint_get_{kaddress,uaddress,len,type}(), declared
- * below.
- *
- * The address is specified as a regular kernel pointer (for kernel-space
- * breakponts) or as an %__user pointer (for user-space breakpoints).
- * With register_user_hw_breakpoint(), the address must refer to a
- * location in user space.  The breakpoint will be active only while the
- * requested task is running.  Conversely with
- * register_kernel_hw_breakpoint(), the address must refer to a location
- * in kernel space, and the breakpoint will be active on all CPUs
- * regardless of the current task.
- *
- * The length is the breakpoint's extent in bytes, which is subject to
- * certain limitations.  include/asm/hw_breakpoint.h contains macros
- * defining the available lengths for a specific architecture.  Note that
- * the address's alignment must match the length.  The breakpoint will
- * catch accesses to any byte in the range from address to address +
- * (length - 1).
- *
- * The breakpoint's type indicates the sort of access that will cause it
- * to trigger.  Possible values may include:
- *
- * 	%HW_BREAKPOINT_RW (triggered on read or write access),
- * 	%HW_BREAKPOINT_WRITE (triggered on write access), and
- * 	%HW_BREAKPOINT_READ (triggered on read access).
- *
- * Appropriate macros are defined in include/asm/hw_breakpoint.h; not all
- * possibilities are available on all architectures.  Execute breakpoints
- * must have length equal to the special value %HW_BREAKPOINT_LEN_EXECUTE.
- *
- * When a breakpoint gets hit, the @triggered callback is
- * invoked in_interrupt with a pointer to the %hw_breakpoint structure and the
- * processor registers.
- * Data breakpoints occur after the memory access has taken place.
- * Breakpoints are disabled during execution @triggered, to avoid
- * recursive traps and allow unhindered access to breakpointed memory.
- *
- * This sample code sets a breakpoint on pid_max and registers a callback
- * function for writes to that variable.  Note that it is not portable
- * as written, because not all architectures support HW_BREAKPOINT_LEN_4.
- *
- * ----------------------------------------------------------------------
- *
- * #include <asm/hw_breakpoint.h>
- *
- * struct hw_breakpoint my_bp;
- *
- * static void my_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
- * {
- * 	printk(KERN_DEBUG "Inside triggered routine of breakpoint exception\n");
- * 	dump_stack();
- *  	.......<more debugging output>........
- * }
- *
- * static struct hw_breakpoint my_bp;
- *
- * static int init_module(void)
- * {
- *	..........<do anything>............
- *	my_bp.info.type = HW_BREAKPOINT_WRITE;
- *	my_bp.info.len = HW_BREAKPOINT_LEN_4;
- *
- *	my_bp.installed = (void *)my_bp_installed;
- *
- *	rc = register_kernel_hw_breakpoint(&my_bp);
- *	..........<do anything>............
- * }
- *
- * static void cleanup_module(void)
- * {
- *	..........<do anything>............
- *	unregister_kernel_hw_breakpoint(&my_bp);
- *	..........<do anything>............
- * }
- *
- * ----------------------------------------------------------------------
- */
-struct hw_breakpoint {
-	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
-	struct arch_hw_breakpoint info;
+enum {
+	HW_BREAKPOINT_LEN_1 = 1,
+	HW_BREAKPOINT_LEN_2 = 2,
+	HW_BREAKPOINT_LEN_4 = 4,
+	HW_BREAKPOINT_LEN_8 = 8,
 };
 
-/*
- * len and type values are defined in include/asm/hw_breakpoint.h.
- * Available values vary according to the architecture.  On i386 the
- * possibilities are:
- *
- *	HW_BREAKPOINT_LEN_1
- *	HW_BREAKPOINT_LEN_2
- *	HW_BREAKPOINT_LEN_4
- *	HW_BREAKPOINT_RW
- *	HW_BREAKPOINT_READ
- *
- * On other architectures HW_BREAKPOINT_LEN_8 may be available, and the
- * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
- * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
- */
+enum {
+	HW_BREAKPOINT_R = 1,
+	HW_BREAKPOINT_W = 2,
+	HW_BREAKPOINT_X = 4,
+};
+
+static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
+{
+	return &bp->hw.info;
+}
+
+static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
+{
+	return bp->attr.bp_addr;
+}
+
+static inline int hw_breakpoint_type(struct perf_event *bp)
+{
+	return bp->attr.bp_type;
+}
+
+static inline int hw_breakpoint_len(struct perf_event *bp)
+{
+	return bp->attr.bp_len;
+}
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+extern struct perf_event *
+register_user_hw_breakpoint(unsigned long addr,
+			    int len,
+			    int type,
+			    perf_callback_t triggered,
+			    struct task_struct *tsk,
+			    bool active);
+
+/* FIXME: only change from the attr, and don't unregister */
+extern struct perf_event *
+modify_user_hw_breakpoint(struct perf_event *bp,
+			  unsigned long addr,
+			  int len,
+			  int type,
+			  perf_callback_t triggered,
+			  struct task_struct *tsk,
+			  bool active);
 
-extern int register_user_hw_breakpoint(struct task_struct *tsk,
-					struct hw_breakpoint *bp);
-extern int modify_user_hw_breakpoint(struct task_struct *tsk,
-					struct hw_breakpoint *bp);
-extern void unregister_user_hw_breakpoint(struct task_struct *tsk,
-						struct hw_breakpoint *bp);
 /*
  * Kernel breakpoints are not associated with any particular thread.
  */
-extern int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
-extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+extern struct perf_event *
+register_wide_hw_breakpoint_cpu(unsigned long addr,
+				int len,
+				int type,
+				perf_callback_t triggered,
+				int cpu,
+				bool active);
+
+extern struct perf_event **
+register_wide_hw_breakpoint(unsigned long addr,
+			    int len,
+			    int type,
+			    perf_callback_t triggered,
+			    bool active);
+
+extern int register_perf_hw_breakpoint(struct perf_event *bp);
+extern int __register_perf_hw_breakpoint(struct perf_event *bp);
+extern void unregister_hw_breakpoint(struct perf_event *bp);
+extern void unregister_wide_hw_breakpoint(struct perf_event **cpu_events);
+
+extern int reserve_bp_slot(struct perf_event *bp);
+extern void release_bp_slot(struct perf_event *bp);
+
+extern void flush_ptrace_hw_breakpoint(struct task_struct *tsk);
+
+#else /* !CONFIG_HAVE_HW_BREAKPOINT */
+
+static inline struct perf_event *
+register_user_hw_breakpoint(unsigned long addr,
+			    int len,
+			    int type,
+			    perf_callback_t triggered,
+			    struct task_struct *tsk,
+			    bool active)		{ return NULL; }
+static inline struct perf_event *
+modify_user_hw_breakpoint(struct perf_event *bp,
+			  unsigned long addr,
+			  int len,
+			  int type,
+			  perf_callback_t triggered,
+			  struct task_struct *tsk,
+			  bool active)			{ return NULL; }
+static inline struct perf_event *
+register_wide_hw_breakpoint_cpu(unsigned long addr,
+				int len,
+				int type,
+				perf_callback_t triggered,
+				int cpu,
+				bool active)		{ return NULL; }
+static inline struct perf_event **
+register_wide_hw_breakpoint(unsigned long addr,
+			    int len,
+			    int type,
+			    perf_callback_t triggered,
+			    bool active)		{ return NULL; }
+static inline int
+register_perf_hw_breakpoint(struct perf_event *bp)	{ return -ENOSYS; }
+static inline int
+__register_perf_hw_breakpoint(struct perf_event *bp) 	{ return -ENOSYS; }
+static inline void unregister_hw_breakpoint(struct perf_event *bp)	{ }
+static inline void
+unregister_wide_hw_breakpoint(struct perf_event **cpu_events)		{ }
+static inline int
+reserve_bp_slot(struct perf_event *bp)			{return -ENOSYS; }
+static inline void release_bp_slot(struct perf_event *bp) 		{ }
+
+static inline void flush_ptrace_hw_breakpoint(struct task_struct *tsk)	{ }
 
-extern unsigned int hbp_kernel_pos;
+#endif /* CONFIG_HAVE_HW_BREAKPOINT */
 
-#endif	/* __KERNEL__ */
-#endif	/* _LINUX_HW_BREAKPOINT_H */
+#endif /* _LINUX_HW_BREAKPOINT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8d54e6d..cead64e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -18,6 +18,10 @@
 #include <linux/ioctl.h>
 #include <asm/byteorder.h>
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#include <asm/hw_breakpoint.h>
+#endif
+
 /*
  * User-space ABI bits:
  */
@@ -31,6 +35,7 @@ enum perf_type_id {
 	PERF_TYPE_TRACEPOINT			= 2,
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
+	PERF_TYPE_BREAKPOINT			= 5,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
@@ -207,6 +212,15 @@ struct perf_event_attr {
 		__u32		wakeup_events;	  /* wakeup every n events */
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
+
+	union {
+		struct { /* Hardware breakpoint info */
+			__u64		bp_addr;
+			__u32		bp_type;
+			__u32		bp_len;
+		};
+	};
+
 	__u32			__reserved_2;
 
 	__u64			__reserved_3;
@@ -476,6 +490,11 @@ struct hw_perf_event {
 			atomic64_t	count;
 			struct hrtimer	hrtimer;
 		};
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+		union { /* breakpoint */
+			struct arch_hw_breakpoint	info;
+		};
+#endif
 	};
 	atomic64_t			prev_count;
 	u64				sample_period;
@@ -588,7 +607,7 @@ struct perf_event {
 	u64				tstamp_running;
 	u64				tstamp_stopped;
 
-	struct perf_event_attr	attr;
+	struct perf_event_attr		attr;
 	struct hw_perf_event		hw;
 
 	struct perf_event_context	*ctx;
@@ -643,6 +662,8 @@ struct perf_event {
 
 	perf_callback_t			callback;
 
+	perf_callback_t			event_callback;
+
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -831,6 +852,7 @@ extern int sysctl_perf_event_sample_rate;
 extern void perf_event_init(void);
 extern void perf_tp_event(int event_id, u64 addr, u64 count,
 				 void *record, int entry_size);
+extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
 #define perf_misc_flags(regs)	(user_mode(regs) ? PERF_RECORD_MISC_USER : \
@@ -865,6 +887,8 @@ static inline int perf_event_task_enable(void)				{ return -EINVAL; }
 static inline void
 perf_sw_event(u32 event_id, u64 nr, int nmi,
 		     struct pt_regs *regs, u64 addr)			{ }
+static inline void
+perf_bp_event(struct perf_event *event, void *data)		{ }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
diff --git a/kernel/exit.c b/kernel/exit.c
index e61891f..266f892 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -49,6 +49,7 @@
 #include <linux/init_task.h>
 #include <linux/perf_event.h>
 #include <trace/events/sched.h>
+#include <linux/hw_breakpoint.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -980,6 +981,10 @@ NORET_TYPE void do_exit(long code)
 	proc_exit_connector(tsk);
 
 	/*
+	 * FIXME: do that only when needed, using sched_exit tracepoint
+	 */
+	flush_ptrace_hw_breakpoint(tsk);
+	/*
 	 * Flush inherited counters to the parent - before the parent
 	 * gets woken up by child-exit notifications.
 	 */
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index c1f64e6..08f6d01 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -15,6 +15,7 @@
  *
  * Copyright (C) 2007 Alan Stern
  * Copyright (C) IBM Corporation, 2009
+ * Copyright (C) 2009, Frederic Weisbecker <fweisbec@gmail.com>
  */
 
 /*
@@ -35,334 +36,242 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 
-#include <asm/hw_breakpoint.h>
+#include <linux/hw_breakpoint.h>
+
 #include <asm/processor.h>
 
 #ifdef CONFIG_X86
 #include <asm/debugreg.h>
 #endif
-/*
- * Spinlock that protects all (un)register operations over kernel/user-space
- * breakpoint requests
- */
-static DEFINE_SPINLOCK(hw_breakpoint_lock);
-
-/* Array of kernel-space breakpoint structures */
-struct hw_breakpoint *hbp_kernel[HBP_NUM];
-
-/*
- * Per-processor copy of hbp_kernel[]. Used only when hbp_kernel is being
- * modified but we need the older copy to handle any hbp exceptions. It will
- * sync with hbp_kernel[] value after updation is done through IPIs.
- */
-DEFINE_PER_CPU(struct hw_breakpoint*, this_hbp_kernel[HBP_NUM]);
-
-/*
- * Kernel breakpoints grow downwards, starting from HBP_NUM
- * 'hbp_kernel_pos' denotes lowest numbered breakpoint register occupied for
- * kernel-space request. We will initialise it here and not in an __init
- * routine because load_debug_registers(), which uses this variable can be
- * called very early during CPU initialisation.
- */
-unsigned int hbp_kernel_pos = HBP_NUM;
 
-/*
- * An array containing refcount of threads using a given bkpt register
- * Accesses are synchronised by acquiring hw_breakpoint_lock
- */
-unsigned int hbp_user_refcount[HBP_NUM];
+static atomic_t bp_slot;
 
-/*
- * Load the debug registers during startup of a CPU.
- */
-void load_debug_registers(void)
+int reserve_bp_slot(struct perf_event *bp)
 {
-	unsigned long flags;
-	struct task_struct *tsk = current;
-
-	spin_lock_bh(&hw_breakpoint_lock);
-
-	/* Prevent IPIs for new kernel breakpoint updates */
-	local_irq_save(flags);
-	arch_update_kernel_hw_breakpoint(NULL);
-	local_irq_restore(flags);
-
-	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
-		arch_install_thread_hw_breakpoint(tsk);
-
-	spin_unlock_bh(&hw_breakpoint_lock);
-}
+	if (atomic_inc_return(&bp_slot) == HBP_NUM) {
+		atomic_dec(&bp_slot);
 
-/*
- * Erase all the hardware breakpoint info associated with a thread.
- *
- * If tsk != current then tsk must not be usable (for example, a
- * child being cleaned up from a failed fork).
- */
-void flush_thread_hw_breakpoint(struct task_struct *tsk)
-{
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
+		return -ENOSPC;
 	}
 
-	arch_flush_thread_hw_breakpoint(tsk);
-
-	/* Actually uninstall the breakpoints if necessary */
-	if (tsk == current)
-		arch_uninstall_thread_hw_breakpoint();
-	spin_unlock_bh(&hw_breakpoint_lock);
+	return 0;
 }
 
-/*
- * Copy the hardware breakpoint info from a thread to its cloned child.
- */
-int copy_thread_hw_breakpoint(struct task_struct *tsk,
-		struct task_struct *child, unsigned long clone_flags)
+void release_bp_slot(struct perf_event *bp)
 {
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
+	atomic_dec(&bp_slot);
 }
 
-static int __register_user_hw_breakpoint(int pos, struct task_struct *tsk,
-					struct hw_breakpoint *bp)
+int __register_perf_hw_breakpoint(struct perf_event *bp)
 {
-	struct thread_struct *thread = &(tsk->thread);
-	int rc;
+	int ret;
 
-	/* Do not overcommit. Fail if kernel has used the hbp registers */
-	if (pos >= hbp_kernel_pos)
-		return -ENOSPC;
+	ret = reserve_bp_slot(bp);
+	if (ret)
+		return ret;
 
-	rc = arch_validate_hwbkpt_settings(bp, tsk);
-	if (rc)
-		return rc;
+	if (!bp->attr.disabled)
+		ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
 
-	thread->hbp[pos] = bp;
-	hbp_user_refcount[pos]++;
+	return ret;
+}
 
-	arch_update_user_hw_breakpoint(pos, tsk);
-	/*
-	 * Does it need to be installed right now?
-	 * Otherwise it will get installed the next time tsk runs
-	 */
-	if (tsk == current)
-		arch_install_thread_hw_breakpoint(tsk);
+int register_perf_hw_breakpoint(struct perf_event *bp)
+{
+	bp->callback = perf_bp_event;
 
-	return rc;
+	return __register_perf_hw_breakpoint(bp);
 }
 
 /*
- * Modify the address of a hbp register already in use by the task
- * Do not invoke this in-lieu of a __unregister_user_hw_breakpoint()
+ * Register a breakpoint bound to a task and a given cpu.
+ * If cpu is -1, the breakpoint is active for the task in every cpu
+ * If the task is -1, the breakpoint is active for every tasks in the given
+ * cpu.
  */
-static int __modify_user_hw_breakpoint(int pos, struct task_struct *tsk,
-					struct hw_breakpoint *bp)
+static struct perf_event *
+register_user_hw_breakpoint_cpu(unsigned long addr,
+				int len,
+				int type,
+				perf_callback_t triggered,
+				pid_t pid,
+				int cpu,
+				bool active)
 {
-	struct thread_struct *thread = &(tsk->thread);
-
-	if ((pos >= hbp_kernel_pos) || (arch_validate_hwbkpt_settings(bp, tsk)))
-		return -EINVAL;
-
-	if (thread->hbp[pos] == NULL)
-		return -EINVAL;
-
-	thread->hbp[pos] = bp;
+	struct perf_event_attr *attr;
+	struct perf_event *bp;
+
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return ERR_PTR(-ENOMEM);
+
+	attr->type = PERF_TYPE_BREAKPOINT;
+	attr->size = sizeof(*attr);
+	attr->bp_addr = addr;
+	attr->bp_len = len;
+	attr->bp_type = type;
 	/*
-	 * 'pos' must be that of a hbp register already used by 'tsk'
-	 * Otherwise arch_modify_user_hw_breakpoint() will fail
+	 * Such breakpoints are used by debuggers to trigger signals when
+	 * we hit the excepted memory op. We can't miss such events, they
+	 * must be pinned.
 	 */
-	arch_update_user_hw_breakpoint(pos, tsk);
+	attr->pinned = 1;
 
-	if (tsk == current)
-		arch_install_thread_hw_breakpoint(tsk);
+	if (!active)
+		attr->disabled = 1;
 
-	return 0;
-}
-
-static void __unregister_user_hw_breakpoint(int pos, struct task_struct *tsk)
-{
-	hbp_user_refcount[pos]--;
-	tsk->thread.hbp[pos] = NULL;
+	bp = perf_event_create_kernel_counter(attr, cpu, pid, triggered);
+	kfree(attr);
 
-	arch_update_user_hw_breakpoint(pos, tsk);
-
-	if (tsk == current)
-		arch_install_thread_hw_breakpoint(tsk);
+	return bp;
 }
 
 /**
  * register_user_hw_breakpoint - register a hardware breakpoint for user space
+ * @addr: is the memory address that triggers the breakpoint
+ * @len: the length of the access to the memory (1 byte, 2 bytes etc...)
+ * @type: the type of the access to the memory (read/write/exec)
+ * @triggered: callback to trigger when we hit the breakpoint
  * @tsk: pointer to 'task_struct' of the process to which the address belongs
- * @bp: the breakpoint structure to register
- *
- * @bp.info->name or @bp.info->address, @bp.info->len, @bp.info->type and
- * @bp->triggered must be set properly before invocation
+ * @active: should we activate it while registering it
  *
  */
-int register_user_hw_breakpoint(struct task_struct *tsk,
-					struct hw_breakpoint *bp)
+struct perf_event *
+register_user_hw_breakpoint(unsigned long addr,
+			    int len,
+			    int type,
+			    perf_callback_t triggered,
+			    struct task_struct *tsk,
+			    bool active)
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
+	return register_user_hw_breakpoint_cpu(addr, len, type, triggered,
+					       tsk->pid, -1, active);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
 /**
  * modify_user_hw_breakpoint - modify a user-space hardware breakpoint
+ * @bp: the breakpoint structure to modify
+ * @addr: is the memory address that triggers the breakpoint
+ * @len: the length of the access to the memory (1 byte, 2 bytes etc...)
+ * @type: the type of the access to the memory (read/write/exec)
+ * @triggered: callback to trigger when we hit the breakpoint
  * @tsk: pointer to 'task_struct' of the process to which the address belongs
- * @bp: the breakpoint structure to unregister
- *
+ * @active: should we activate it while registering it
  */
-int modify_user_hw_breakpoint(struct task_struct *tsk, struct hw_breakpoint *bp)
+struct perf_event *
+modify_user_hw_breakpoint(struct perf_event *bp,
+			  unsigned long addr,
+			  int len,
+			  int type,
+			  perf_callback_t triggered,
+			  struct task_struct *tsk,
+			  bool active)
 {
-	struct thread_struct *thread = &(tsk->thread);
-	int i, ret = -ENOENT;
+	/*
+	 * FIXME: do it without unregistering
+	 * - We don't want to lose our slot
+	 * - If the new bp is incorrect, don't lose the older one
+	 */
+	unregister_hw_breakpoint(bp);
 
-	spin_lock_bh(&hw_breakpoint_lock);
-	for (i = 0; i < hbp_kernel_pos; i++) {
-		if (bp == thread->hbp[i]) {
-			ret = __modify_user_hw_breakpoint(i, tsk, bp);
-			break;
-		}
-	}
-	spin_unlock_bh(&hw_breakpoint_lock);
-	return ret;
+	return register_user_hw_breakpoint(addr, len, type, triggered,
+					   tsk, active);
 }
 EXPORT_SYMBOL_GPL(modify_user_hw_breakpoint);
 
 /**
- * unregister_user_hw_breakpoint - unregister a user-space hardware breakpoint
- * @tsk: pointer to 'task_struct' of the process to which the address belongs
+ * unregister_hw_breakpoint - unregister a user-space hardware breakpoint
  * @bp: the breakpoint structure to unregister
- *
  */
-void unregister_user_hw_breakpoint(struct task_struct *tsk,
-						struct hw_breakpoint *bp)
+void unregister_hw_breakpoint(struct perf_event *bp)
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
-
-	spin_unlock_bh(&hw_breakpoint_lock);
+	if (!bp)
+		return;
+	perf_event_release_kernel(bp);
+}
+EXPORT_SYMBOL_GPL(unregister_hw_breakpoint);
+
+static struct perf_event *
+register_kernel_hw_breakpoint_cpu(unsigned long addr,
+				  int len,
+				  int type,
+				  perf_callback_t triggered,
+				  int cpu,
+				  bool active)
+{
+	return register_user_hw_breakpoint_cpu(addr, len, type, triggered,
+					       -1, cpu, active);
 }
-EXPORT_SYMBOL_GPL(unregister_user_hw_breakpoint);
 
 /**
- * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
- * @bp: the breakpoint structure to register
- *
- * @bp.info->name or @bp.info->address, @bp.info->len, @bp.info->type and
- * @bp->triggered must be set properly before invocation
+ * register_wide_hw_breakpoint - register a wide breakpoint in the kernel
+ * @addr: is the memory address that triggers the breakpoint
+ * @len: the length of the access to the memory (1 byte, 2 bytes etc...)
+ * @type: the type of the access to the memory (read/write/exec)
+ * @triggered: callback to trigger when we hit the breakpoint
+ * @active: should we activate it while registering it
  *
+ * @return a set of per_cpu pointers to perf events
  */
-int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+struct perf_event **
+register_wide_hw_breakpoint(unsigned long addr,
+			    int len,
+			    int type,
+			    perf_callback_t triggered,
+			    bool active)
 {
-	int rc;
+	struct perf_event **cpu_events, **pevent, *bp;
+	long err;
+	int cpu;
+
+	cpu_events = alloc_percpu(typeof(*cpu_events));
+	if (!cpu_events)
+		return ERR_PTR(-ENOMEM);
 
-	rc = arch_validate_hwbkpt_settings(bp, NULL);
-	if (rc)
-		return rc;
+	for_each_possible_cpu(cpu) {
+		pevent = per_cpu_ptr(cpu_events, cpu);
+		bp = register_kernel_hw_breakpoint_cpu(addr, len, type,
+					triggered, cpu, active);
 
-	spin_lock_bh(&hw_breakpoint_lock);
+		*pevent = bp;
 
-	rc = -ENOSPC;
-	/* Check if we are over-committing */
-	if ((hbp_kernel_pos > 0) && (!hbp_user_refcount[hbp_kernel_pos-1])) {
-		hbp_kernel_pos--;
-		hbp_kernel[hbp_kernel_pos] = bp;
-		on_each_cpu(arch_update_kernel_hw_breakpoint, NULL, 1);
-		rc = 0;
+		if (IS_ERR(bp) || !bp) {
+			err = PTR_ERR(bp);
+			goto fail;
+		}
 	}
 
-	spin_unlock_bh(&hw_breakpoint_lock);
-	return rc;
+	return cpu_events;
+
+fail:
+	for_each_possible_cpu(cpu) {
+		pevent = per_cpu_ptr(cpu_events, cpu);
+		if (IS_ERR(*pevent) || !*pevent)
+			break;
+		unregister_hw_breakpoint(*pevent);
+	}
+	free_percpu(cpu_events);
+	/* return the error if any */
+	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(register_kernel_hw_breakpoint);
 
 /**
- * unregister_kernel_hw_breakpoint - unregister a HW breakpoint for kernel space
- * @bp: the breakpoint structure to unregister
- *
- * Uninstalls and unregisters @bp.
+ * unregister_wide_hw_breakpoint - unregister a wide breakpoint in the kernel
+ * @cpu_events: the per cpu set of events to unregister
  */
-void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+void unregister_wide_hw_breakpoint(struct perf_event **cpu_events)
 {
-	int i, j;
-
-	spin_lock_bh(&hw_breakpoint_lock);
-
-	/* Find the 'bp' in our list of breakpoints for kernel */
-	for (i = hbp_kernel_pos; i < HBP_NUM; i++)
-		if (bp == hbp_kernel[i])
-			break;
+	int cpu;
+	struct perf_event **pevent;
 
-	/* Check if we did not find a match for 'bp'. If so return early */
-	if (i == HBP_NUM) {
-		spin_unlock_bh(&hw_breakpoint_lock);
-		return;
+	for_each_possible_cpu(cpu) {
+		pevent = per_cpu_ptr(cpu_events, cpu);
+		unregister_hw_breakpoint(*pevent);
 	}
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
+	free_percpu(cpu_events);
 }
-EXPORT_SYMBOL_GPL(unregister_kernel_hw_breakpoint);
+
 
 static struct notifier_block hw_breakpoint_exceptions_nb = {
 	.notifier_call = hw_breakpoint_exceptions_notify,
@@ -374,5 +283,12 @@ static int __init init_hw_breakpoint(void)
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
+	.unthrottle	= hw_breakpoint_pmu_unthrottle
+};
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 5087125..98dc56b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -29,6 +29,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
+#include <linux/hw_breakpoint.h>
 
 #include <asm/irq_regs.h>
 
@@ -4229,6 +4230,51 @@ static void perf_event_free_filter(struct perf_event *event)
 
 #endif /* CONFIG_EVENT_PROFILE */
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+static void bp_perf_event_destroy(struct perf_event *event)
+{
+	release_bp_slot(event);
+}
+
+static const struct pmu *bp_perf_event_init(struct perf_event *bp)
+{
+	int err;
+	/*
+	 * The breakpoint is already filled if we haven't created the counter
+	 * through perf syscall
+	 * FIXME: manage to get trigerred to NULL if it comes from syscalls
+	 */
+	if (!bp->callback)
+		err = register_perf_hw_breakpoint(bp);
+	else
+		err = __register_perf_hw_breakpoint(bp);
+	if (err)
+		return ERR_PTR(err);
+
+	bp->destroy = bp_perf_event_destroy;
+
+	return &perf_ops_bp;
+}
+
+void perf_bp_event(struct perf_event *bp, void *regs)
+{
+	/* TODO */
+}
+#else
+static void bp_perf_event_destroy(struct perf_event *event)
+{
+}
+
+static const struct pmu *bp_perf_event_init(struct perf_event *bp)
+{
+	return NULL;
+}
+
+void perf_bp_event(struct perf_event *bp, void *regs)
+{
+}
+#endif
+
 atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 static void sw_perf_event_destroy(struct perf_event *event)
@@ -4375,6 +4421,11 @@ perf_event_alloc(struct perf_event_attr *attr,
 		pmu = tp_perf_event_init(event);
 		break;
 
+	case PERF_TYPE_BREAKPOINT:
+		pmu = bp_perf_event_init(event);
+		break;
+
+
 	default:
 		break;
 	}
@@ -4686,7 +4737,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 
 	ctx = find_get_context(pid, cpu);
 	if (IS_ERR(ctx))
-		return NULL ;
+		return NULL;
 
 	event = perf_event_alloc(attr, cpu, ctx, NULL,
 				     NULL, callback, GFP_KERNEL);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 91c3d0e..d72f06f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -11,14 +11,11 @@
 #include <linux/ftrace.h>
 #include <trace/boot.h>
 #include <linux/kmemtrace.h>
+#include <linux/hw_breakpoint.h>
 
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
 
-#ifdef CONFIG_KSYM_TRACER
-#include <asm/hw_breakpoint.h>
-#endif
-
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
 
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index e19747d..c16a08f 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -372,11 +372,11 @@ FTRACE_ENTRY(ksym_trace, ksym_trace_entry,
 	F_STRUCT(
 		__field(	unsigned long,	ip			  )
 		__field(	unsigned char,	type			  )
-		__array(	char	     ,	ksym_name, KSYM_NAME_LEN  )
 		__array(	char	     ,	cmd,	   TASK_COMM_LEN  )
+		__field(	unsigned long,  addr			  )
 	),
 
-	F_printk("ip: %pF type: %d ksym_name: %s cmd: %s",
+	F_printk("ip: %pF type: %d ksym_name: %pS cmd: %s",
 		(void *)__entry->ip, (unsigned int)__entry->type,
-		__entry->ksym_name, __entry->cmd)
+		(void *)__entry->addr,  __entry->cmd)
 );
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 6d5609c..fea83ee 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -29,7 +29,11 @@
 #include "trace_stat.h"
 #include "trace.h"
 
-/* For now, let us restrict the no. of symbols traced simultaneously to number
+#include <linux/hw_breakpoint.h>
+#include <asm/hw_breakpoint.h>
+
+/*
+ * For now, let us restrict the no. of symbols traced simultaneously to number
  * of available hardware breakpoint registers.
  */
 #define KSYM_TRACER_MAX HBP_NUM
@@ -37,8 +41,10 @@
 #define KSYM_TRACER_OP_LEN 3 /* rw- */
 
 struct trace_ksym {
-	struct hw_breakpoint	*ksym_hbp;
+	struct perf_event	**ksym_hbp;
 	unsigned long		ksym_addr;
+	int			type;
+	int			len;
 #ifdef CONFIG_PROFILE_KSYM_TRACER
 	unsigned long		counter;
 #endif
@@ -75,10 +81,11 @@ void ksym_collect_stats(unsigned long hbp_hit_addr)
 }
 #endif /* CONFIG_PROFILE_KSYM_TRACER */
 
-void ksym_hbp_handler(struct hw_breakpoint *hbp, struct pt_regs *regs)
+void ksym_hbp_handler(struct perf_event *hbp, void *data)
 {
 	struct ring_buffer_event *event;
 	struct ksym_trace_entry *entry;
+	struct pt_regs *regs = data;
 	struct ring_buffer *buffer;
 	int pc;
 
@@ -96,12 +103,12 @@ void ksym_hbp_handler(struct hw_breakpoint *hbp, struct pt_regs *regs)
 
 	entry		= ring_buffer_event_data(event);
 	entry->ip	= instruction_pointer(regs);
-	entry->type	= hbp->info.type;
-	strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
+	entry->type	= hw_breakpoint_type(hbp);
+	entry->addr	= hw_breakpoint_addr(hbp);
 	strlcpy(entry->cmd, current->comm, TASK_COMM_LEN);
 
 #ifdef CONFIG_PROFILE_KSYM_TRACER
-	ksym_collect_stats(hbp->info.address);
+	ksym_collect_stats(hw_breakpoint_addr(hbp));
 #endif /* CONFIG_PROFILE_KSYM_TRACER */
 
 	trace_buffer_unlock_commit(buffer, event, 0, pc);
@@ -120,31 +127,21 @@ static int ksym_trace_get_access_type(char *str)
 	int access = 0;
 
 	if (str[0] == 'r')
-		access += 4;
-	else if (str[0] != '-')
-		return -EINVAL;
+		access |= HW_BREAKPOINT_R;
 
 	if (str[1] == 'w')
-		access += 2;
-	else if (str[1] != '-')
-		return -EINVAL;
+		access |= HW_BREAKPOINT_W;
 
-	if (str[2] != '-')
-		return -EINVAL;
+	if (str[2] == 'x')
+		access |= HW_BREAKPOINT_X;
 
 	switch (access) {
-	case 6:
-		access = HW_BREAKPOINT_RW;
-		break;
-	case 4:
-		access = -EINVAL;
-		break;
-	case 2:
-		access = HW_BREAKPOINT_WRITE;
-		break;
+	case HW_BREAKPOINT_W:
+	case HW_BREAKPOINT_W | HW_BREAKPOINT_R:
+		return access;
+	default:
+		return -EINVAL;
 	}
-
-	return access;
 }
 
 /*
@@ -194,36 +191,33 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->ksym_hbp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
-	if (!entry->ksym_hbp)
-		goto err;
-
-	entry->ksym_hbp->info.name = kstrdup(ksymname, GFP_KERNEL);
-	if (!entry->ksym_hbp->info.name)
-		goto err;
-
-	entry->ksym_hbp->info.type = op;
-	entry->ksym_addr = entry->ksym_hbp->info.address = addr;
-#ifdef CONFIG_X86
-	entry->ksym_hbp->info.len = HW_BREAKPOINT_LEN_4;
-#endif
-	entry->ksym_hbp->triggered = (void *)ksym_hbp_handler;
+	entry->type = op;
+	entry->ksym_addr = addr;
+	entry->len = HW_BREAKPOINT_LEN_4;
+
+	ret = -EAGAIN;
+	entry->ksym_hbp = register_wide_hw_breakpoint(entry->ksym_addr,
+					entry->len, entry->type,
+					ksym_hbp_handler, true);
+	if (IS_ERR(entry->ksym_hbp)) {
+		entry->ksym_hbp = NULL;
+		ret = PTR_ERR(entry->ksym_hbp);
+	}
 
-	ret = register_kernel_hw_breakpoint(entry->ksym_hbp);
-	if (ret < 0) {
+	if (!entry->ksym_hbp) {
 		printk(KERN_INFO "ksym_tracer request failed. Try again"
 					" later!!\n");
-		ret = -EAGAIN;
 		goto err;
 	}
+
 	hlist_add_head_rcu(&(entry->ksym_hlist), &ksym_filter_head);
 	ksym_filter_entry_count++;
+
 	return 0;
+
 err:
-	if (entry->ksym_hbp)
-		kfree(entry->ksym_hbp->info.name);
-	kfree(entry->ksym_hbp);
 	kfree(entry);
+
 	return ret;
 }
 
@@ -244,10 +238,10 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 	mutex_lock(&ksym_tracer_mutex);
 
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
-		ret = trace_seq_printf(s, "%s:", entry->ksym_hbp->info.name);
-		if (entry->ksym_hbp->info.type == HW_BREAKPOINT_WRITE)
+		ret = trace_seq_printf(s, "%pS:", (void *)entry->ksym_addr);
+		if (entry->type == HW_BREAKPOINT_W)
 			ret = trace_seq_puts(s, "-w-\n");
-		else if (entry->ksym_hbp->info.type == HW_BREAKPOINT_RW)
+		else if (entry->type == (HW_BREAKPOINT_W | HW_BREAKPOINT_R))
 			ret = trace_seq_puts(s, "rw-\n");
 		WARN_ON_ONCE(!ret);
 	}
@@ -269,12 +263,10 @@ static void __ksym_trace_reset(void)
 	mutex_lock(&ksym_tracer_mutex);
 	hlist_for_each_entry_safe(entry, node, node1, &ksym_filter_head,
 								ksym_hlist) {
-		unregister_kernel_hw_breakpoint(entry->ksym_hbp);
+		unregister_wide_hw_breakpoint(entry->ksym_hbp);
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
-		kfree(entry->ksym_hbp->info.name);
-		kfree(entry->ksym_hbp);
 		kfree(entry);
 	}
 	mutex_unlock(&ksym_tracer_mutex);
@@ -327,7 +319,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
 		if (entry->ksym_addr == ksym_addr) {
 			/* Check for malformed request: (6) */
-			if (entry->ksym_hbp->info.type != op)
+			if (entry->type != op)
 				changed = 1;
 			else
 				goto out;
@@ -335,18 +327,21 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 		}
 	}
 	if (changed) {
-		unregister_kernel_hw_breakpoint(entry->ksym_hbp);
-		entry->ksym_hbp->info.type = op;
+		unregister_wide_hw_breakpoint(entry->ksym_hbp);
+		entry->type = op;
 		if (op > 0) {
-			ret = register_kernel_hw_breakpoint(entry->ksym_hbp);
-			if (ret == 0)
+			entry->ksym_hbp =
+				register_wide_hw_breakpoint(entry->ksym_addr,
+					entry->len, entry->type,
+					ksym_hbp_handler, true);
+			if (IS_ERR(entry->ksym_hbp))
+				entry->ksym_hbp = NULL;
+			if (!entry->ksym_hbp)
 				goto out;
 		}
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
-		kfree(entry->ksym_hbp->info.name);
-		kfree(entry->ksym_hbp);
 		kfree(entry);
 		ret = 0;
 		goto out;
@@ -413,16 +408,16 @@ static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_printf(s, "%11s-%-5d [%03d] %-30s ", field->cmd,
-				entry->pid, iter->cpu, field->ksym_name);
+	ret = trace_seq_printf(s, "%11s-%-5d [%03d] %pS", field->cmd,
+				entry->pid, iter->cpu, (char *)field->addr);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	switch (field->type) {
-	case HW_BREAKPOINT_WRITE:
+	case HW_BREAKPOINT_W:
 		ret = trace_seq_printf(s, " W  ");
 		break;
-	case HW_BREAKPOINT_RW:
+	case HW_BREAKPOINT_R | HW_BREAKPOINT_W:
 		ret = trace_seq_printf(s, " RW ");
 		break;
 	default:
@@ -490,14 +485,13 @@ static int ksym_tracer_stat_show(struct seq_file *m, void *v)
 
 	entry = hlist_entry(stat, struct trace_ksym, ksym_hlist);
 
-	if (entry->ksym_hbp)
-		access_type = entry->ksym_hbp->info.type;
+	access_type = entry->type;
 
 	switch (access_type) {
-	case HW_BREAKPOINT_WRITE:
+	case HW_BREAKPOINT_W:
 		seq_puts(m, "  W           ");
 		break;
-	case HW_BREAKPOINT_RW:
+	case HW_BREAKPOINT_R | HW_BREAKPOINT_W:
 		seq_puts(m, "  RW          ");
 		break;
 	default:
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 7179c12..27c5072 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -828,7 +828,8 @@ trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
 
 	ksym_selftest_dummy = 0;
 	/* Register the read-write tracing request */
-	ret = process_new_ksym_entry(KSYM_SELFTEST_ENTRY, HW_BREAKPOINT_RW,
+	ret = process_new_ksym_entry(KSYM_SELFTEST_ENTRY,
+				     HW_BREAKPOINT_R | HW_BREAKPOINT_W,
 					(unsigned long)(&ksym_selftest_dummy));
 
 	if (ret < 0) {
-- 
1.6.2.3

