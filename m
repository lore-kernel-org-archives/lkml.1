Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbZE0VUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbZE0VUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbZE0VUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:20:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:53676 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbZE0VUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OLbnVcwAXJQIuqg/BEI+PojIIzgqqMX9VFreHzxAiirtaYUuo0tJTudWQilkcOdWXQ
         NRsSmpyq9t9/SY3wbNZmk0jxWhKuUFZgPpz2LVNVP5TnUa8pOPm+NBgeFW+ictziSKtV
         W7WMgxSU+LEl8iOLyjNUzuEzMryAAl7cDCuOM=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, wuzj@lemote.com
Subject: [PATCH] mips-specific ftrace support
Date: Thu, 28 May 2009 05:19:52 +0800
Message-Id: <73465d64a9a6773936f5eab3735a69f651c13187.1243458732.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

ftrace is a mcount based kernel tracing tool/framework, which is
originally from RT_PREEMPT(http://rt.wiki.kernel.org).

ftrace is short for function tracer, this is its original name, but now,
it becomes a kernel tracing framework, lots of kernel tracers are built
on it, such as irqoff tracer, wakeup tracer and so forth.  these tracers
are arch-independent(?), but some of them are arch-dependent, such as
the original ftrace: function tracer, and dynamic function tracer,
function graph tracer, and also, system call tracer.

here is the mips porting of the front three arch-dependent tracers,
currently, the porting of system call tracer is not stable, so, not
included in this patch.

here is the new available kernel config options added by this patch.

kernel hacking --->
           Tracers -->
                [*] Kernel Function Tracer
                [*]   Kernel Function Graph Tracer
                ...
                [*] enable/disable ftrace tracepoints dynamically

in reality, because the high-precision time information getting function
are arch-dependent, lots of the tracers are arch-dependent. the
arch-dependent part is that: sched_clock, or we say
ring_buffer_time_stamp or trace_clock_local function. to get
high-precision time, we can read the MIPS clock counter, but for it only
have 32bit, so, overflow should be handled carefully.

read the following document, and play with it:
	Documentation/trace/ftrace.txt

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/Kconfig              |    6 +
 arch/mips/Makefile             |    2 +
 arch/mips/include/asm/ftrace.h |   37 ++++-
 arch/mips/kernel/Makefile      |   11 ++
 arch/mips/kernel/csrc-r4k.c    |    2 +-
 arch/mips/kernel/ftrace.c      |  366 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mcount.S      |  239 ++++++++++++++++++++++++++
 arch/mips/kernel/mips_ksyms.c  |    5 +
 arch/mips/kernel/vmlinux.lds.S |    1 +
 include/linux/clocksource.h    |    4 +-
 kernel/sched_clock.c           |    2 +-
 kernel/trace/ring_buffer.c     |    3 +-
 kernel/trace/trace_clock.c     |    2 +-
 scripts/Makefile.build         |    1 +
 scripts/recordmcount.pl        |   31 +++-
 15 files changed, 699 insertions(+), 13 deletions(-)
 create mode 100644 arch/mips/kernel/ftrace.c
 create mode 100644 arch/mips/kernel/mcount.S

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 09b1287..b588f74 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -3,6 +3,12 @@ config MIPS
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_DYNAMIC_FTRACE
+	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
+	select HAVE_FUNCTION_TRACER
+	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_ARCH_KGDB
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index c4cae9e..f86fb15 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -48,7 +48,9 @@ ifneq ($(SUBARCH),$(ARCH))
   endif
 endif
 
+ifndef CONFIG_FUNCTION_TRACER
 cflags-y := -ffunction-sections
+endif
 cflags-y += $(call cc-option, -mno-check-zero-division)
 
 ifdef CONFIG_32BIT
diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
index 40a8c17..1501f2c 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -1 +1,36 @@
-/* empty */
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2009 DSLab, Lanzhou University, China
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ */
+
+
+#ifndef _ASM_MIPS_FTRACE_H
+#define _ASM_MIPS_FTRACE_H
+
+#ifdef CONFIG_FUNCTION_TRACER
+
+#define MCOUNT_ADDR ((unsigned long)(_mcount))
+#define MCOUNT_INSN_SIZE 4	/* sizeof mcount call */
+
+#ifndef __ASSEMBLY__
+extern void _mcount(void);
+#define mcount _mcount
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+    /* reloction of mcount call site is the same as the address */
+    return addr;
+}
+
+struct dyn_arch_ftrace {
+};
+#endif				/* CONFIG_DYNAMIC_FTRACE */
+#endif				/* __ASSEMBLY__ */
+#endif				/* CONFIG_FUNCTION_TRACER */
+#endif				/* _ASM_MIPS_FTRACE_H */
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index e961221..3a3621b 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -8,6 +8,13 @@ obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 		   ptrace.o reset.o setup.o signal.o syscall.o \
 		   time.o topology.o traps.o unaligned.o watch.o
 
+ifdef CONFIG_FUNCTION_TRACER
+# Do not profile debug and lowlevel utilities
+CFLAGS_REMOVE_mcount.o = -pg
+CFLAGS_REMOVE_ftrace.o = -pg
+CFLAGS_REMOVE_early_printk.o = -pg
+endif
+
 obj-$(CONFIG_CEVT_BCM1480)	+= cevt-bcm1480.o
 obj-$(CONFIG_CEVT_R4K_LIB)	+= cevt-r4k.o
 obj-$(CONFIG_MIPS_MT_SMTC)	+= cevt-smtc.o
@@ -20,6 +27,8 @@ obj-$(CONFIG_CSRC_IOASIC)	+= csrc-ioasic.o
 obj-$(CONFIG_CSRC_R4K_LIB)	+= csrc-r4k.o
 obj-$(CONFIG_CSRC_SB1250)	+= csrc-sb1250.o
 obj-$(CONFIG_SYNC_R4K)		+= sync-r4k.o
+obj-$(CONFIG_FUNCTION_TRACER)		+= mcount.o
+obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= mcount.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
@@ -83,6 +92,8 @@ obj-$(CONFIG_I8253)		+= i8253.o
 
 obj-$(CONFIG_GPIO_TXX9)		+= gpio_txx9.o
 
+obj-$(CONFIG_NOP_TRACER)	+= ftrace.o
+
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
index e95a3cd..3da1c7a 100644
--- a/arch/mips/kernel/csrc-r4k.c
+++ b/arch/mips/kernel/csrc-r4k.c
@@ -10,7 +10,7 @@
 
 #include <asm/time.h>
 
-static cycle_t c0_hpt_read(struct clocksource *cs)
+static cycle_t notrace c0_hpt_read(struct clocksource *cs)
 {
 	return read_c0_count();
 }
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
new file mode 100644
index 0000000..d421ce0
--- /dev/null
+++ b/arch/mips/kernel/ftrace.c
@@ -0,0 +1,366 @@
+/*
+ * Code for replacing ftrace calls with jumps.
+ *
+ * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2009 DSLab, Lanzhou University, China
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ *
+ * Thanks goes to Steven Rostedt for writing the original x86 version.
+ */
+
+#include <linux/clocksource.h>
+#include <linux/ring_buffer.h>
+#include <linux/spinlock.h>
+#include <linux/jiffies.h>
+#include <linux/hardirq.h>
+#include <linux/uaccess.h>
+#include <linux/ftrace.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/ftrace.h>
+
+#include <asm/cacheflush.h>
+#include <asm/ftrace.h>
+#include <asm/asm.h>
+
+#ifndef DEBUG_SHIFT
+#define DEBUG_SHIFT 0
+#endif
+
+u64 native_ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
+{
+	u64 current_cycles;
+	static unsigned long old_jiffies;
+	static u64 time, old_cycles;
+
+	preempt_disable_notrace();
+	/* update timestamp to avoid missing the timer interrupt */
+	if (time_before(jiffies, old_jiffies)) {
+		old_jiffies = jiffies;
+		time = sched_clock();
+		old_cycles = clock->cycle_last;
+	}
+	current_cycles = clock->read(clock);
+
+	time = (time + cyc2ns(clock, (current_cycles - old_cycles) \
+				& clock->mask)) << DEBUG_SHIFT;
+
+	old_cycles = current_cycles;
+	preempt_enable_no_resched_notrace();
+
+	return time;
+}
+
+u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
+		__attribute__((alias("native_ring_buffer_time_stamp")));
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+#define JMP	0x08000000	/* jump to target directly */
+#define JAL 0x0c000000		/* jump & link: ip --> ra, jump to target */
+#define ADDR_MASK 0x03ffffff	/*  op_code|addr : 31...26|25 ....0 */
+
+static unsigned int ftrace_nop = 0x00000000;
+
+static unsigned char *ftrace_call_replace(unsigned long op_code,
+					  unsigned long addr)
+{
+    static unsigned int op;
+
+    op = op_code | ((addr >> 2) & ADDR_MASK);
+
+    return (unsigned char *) &op;
+}
+
+static atomic_t in_nmi = ATOMIC_INIT(0);
+static int mod_code_status;	/* holds return value of text write */
+static int mod_code_write;	/* set when NMI should do the write */
+static void *mod_code_ip;	/* holds the IP to write to */
+static void *mod_code_newcode;	/* holds the text to write to the IP */
+
+static unsigned nmi_wait_count;
+static atomic_t nmi_update_count = ATOMIC_INIT(0);
+
+int ftrace_arch_read_dyn_info(char *buf, int size)
+{
+    int r;
+
+    r = snprintf(buf, size, "%u %u",
+		 nmi_wait_count, atomic_read(&nmi_update_count));
+    return r;
+}
+
+static void ftrace_mod_code(void)
+{
+    /*
+     * Yes, more than one CPU process can be writing to mod_code_status.
+     *    (and the code itself)
+     * But if one were to fail, then they all should, and if one were
+     * to succeed, then they all should.
+     */
+    mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
+					 MCOUNT_INSN_SIZE);
+
+    /* if we fail, then kill any new writers */
+    if (mod_code_status)
+		mod_code_write = 0;
+}
+
+void ftrace_nmi_enter(void)
+{
+    atomic_inc(&in_nmi);
+    /* Must have in_nmi seen before reading write flag */
+    smp_mb();
+    if (mod_code_write) {
+		ftrace_mod_code();
+		atomic_inc(&nmi_update_count);
+    }
+}
+
+void ftrace_nmi_exit(void)
+{
+    /* Finish all executions before clearing in_nmi */
+    smp_wmb();
+    atomic_dec(&in_nmi);
+}
+
+static void wait_for_nmi(void)
+{
+    int waited = 0;
+
+    while (atomic_read(&in_nmi)) {
+		waited = 1;
+		cpu_relax();
+    }
+
+    if (waited)
+		nmi_wait_count++;
+}
+
+static int do_ftrace_mod_code(unsigned long ip, void *new_code)
+{
+    mod_code_ip = (void *) ip;
+    mod_code_newcode = new_code;
+
+    /* The buffers need to be visible before we let NMIs write them */
+    smp_wmb();
+
+    mod_code_write = 1;
+
+    /* Make sure write bit is visible before we wait on NMIs */
+    smp_mb();
+
+    wait_for_nmi();
+
+    /* Make sure all running NMIs have finished before we write the code */
+    smp_mb();
+
+    ftrace_mod_code();
+
+    /* Make sure the write happens before clearing the bit */
+    smp_wmb();
+
+    mod_code_write = 0;
+
+    /* make sure NMIs see the cleared bit */
+    smp_mb();
+
+    wait_for_nmi();
+
+    return mod_code_status;
+}
+
+static unsigned char *ftrace_nop_replace(void)
+{
+    return (unsigned char *) &ftrace_nop;
+}
+
+static int
+ftrace_modify_code(unsigned long ip, unsigned char *old_code,
+		   unsigned char *new_code)
+{
+    unsigned char replaced[MCOUNT_INSN_SIZE];
+
+    /*
+     * Note: Due to modules and __init, code can
+     *  disappear and change, we need to protect against faulting
+     *  as well as code changing. We do this by using the
+     *  probe_kernel_* functions.
+     *
+     * No real locking needed, this code is run through
+     * kstop_machine, or before SMP starts.
+     */
+
+    /* read the text we want to modify */
+    if (probe_kernel_read(replaced, (void *) ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+    /* Make sure it is what we expect it to be */
+    if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
+		return -EINVAL;
+
+    /* replace the text with the new text */
+    if (do_ftrace_mod_code(ip, new_code))
+		return -EPERM;
+
+    return 0;
+}
+
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
+    unsigned char *new, *old;
+
+    old = ftrace_call_replace(JAL, addr);
+    new = ftrace_nop_replace();
+
+    return ftrace_modify_code(rec->ip, old, new);
+}
+
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+    unsigned char *new, *old;
+
+    old = ftrace_nop_replace();
+    new = ftrace_call_replace(JAL, addr);
+
+    return ftrace_modify_code(rec->ip, old, new);
+}
+
+int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+    unsigned long ip = (unsigned long) (&ftrace_call);
+    unsigned char old[MCOUNT_INSN_SIZE], *new;
+    int ret;
+
+    memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
+    new = ftrace_call_replace(JAL, (unsigned long) func);
+    ret = ftrace_modify_code(ip, old, new);
+
+    return ret;
+}
+
+int __init ftrace_dyn_arch_init(void *data)
+{
+    /* The return code is retured via data */
+    *(unsigned long *) data = 0;
+
+    return 0;
+}
+#endif				/* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+/*
+ * trace_clock_local(): the simplest and least coherent tracing clock.
+ *
+ * Useful for tracing that does not cross to other CPUs nor
+ * does it go through idle events.
+ */
+u64 notrace native_trace_clock_local(void)
+{
+	unsigned long flags;
+	u64 clock;
+
+	/*
+	 * sched_clock() is an architecture implemented, fast, scalable,
+	 * lockless clock. It is not guaranteed to be coherent across
+	 * CPUs, nor across CPU idle events.
+	 */
+	raw_local_irq_save(flags);
+	clock = ring_buffer_time_stamp(NULL, raw_smp_processor_id());
+	raw_local_irq_restore(flags);
+
+	return clock;
+}
+
+u64 trace_clock_local(void)
+		__attribute__((alias("native_trace_clock_local")));
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+extern void ftrace_graph_call(void);
+
+int ftrace_enable_ftrace_graph_caller(void)
+{
+    unsigned long ip = (unsigned long) (&ftrace_graph_call);
+    unsigned char old[MCOUNT_INSN_SIZE], *new;
+    int ret;
+
+	/* j ftrace_stub */
+    memcpy(old, (unsigned long *) ip, MCOUNT_INSN_SIZE);
+    new = ftrace_call_replace(JMP, (unsigned long) ftrace_graph_caller);
+
+    ret = ftrace_modify_code(ip, old, new);
+
+    return ret;
+}
+
+int ftrace_disable_ftrace_graph_caller(void)
+{
+    unsigned long ip = (unsigned long) (&ftrace_graph_call);
+    unsigned char old[MCOUNT_INSN_SIZE], *new;
+    int ret;
+
+	/* j ftrace_graph_caller */
+    memcpy(old, (unsigned long *) ip, MCOUNT_INSN_SIZE);
+    new = ftrace_call_replace(JMP, (unsigned long) ftrace_stub);
+
+    ret = ftrace_modify_code(ip, old, new);
+
+    return ret;
+}
+
+#else				/* CONFIG_DYNAMIC_FTRACE */
+
+/*
+ * These functions are picked from those used on
+ * this page for dynamic ftrace. They have been
+ * simplified to ignore all traces in NMI context.
+ */
+static atomic_t in_nmi;
+
+void ftrace_nmi_enter(void)
+{
+    atomic_inc(&in_nmi);
+    /* Must have in_nmi seen before reading write flag */
+    smp_mb();
+}
+
+void ftrace_nmi_exit(void)
+{
+    /* Finish all executions before clearing in_nmi */
+    smp_wmb();
+    atomic_dec(&in_nmi);
+}
+
+#endif				/* !CONFIG_DYNAMIC_FTRACE */
+
+unsigned long prepare_ftrace_return(unsigned long ip,
+				    unsigned long parent_ip)
+{
+    struct ftrace_graph_ent trace;
+
+    /* Nmi's are currently unsupported */
+    if (unlikely(atomic_read(&in_nmi)))
+		goto out;
+
+    if (unlikely(atomic_read(&current->tracing_graph_pause)))
+		goto out;
+
+    if (ftrace_push_return_trace(parent_ip, ip, &trace.depth) == -EBUSY)
+		goto out;
+
+    trace.func = ip;
+
+    /* Only trace if the calling function expects to */
+    if (!ftrace_graph_entry(&trace)) {
+		current->curr_ret_stack--;
+		goto out;
+    }
+    return (unsigned long) &return_to_handler;
+out:
+    return parent_ip;
+}
+#endif				/* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
new file mode 100644
index 0000000..0c73105
--- /dev/null
+++ b/arch/mips/kernel/mcount.S
@@ -0,0 +1,239 @@
+/*
+ * the mips-specific _mcount implementation of ftrace
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2009 DSLab, Lanzhou University, China
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ */
+
+#include <asm/regdef.h>
+#include <asm/stackframe.h>
+#include <asm/ftrace.h>
+
+#ifdef CONFIG_32BIT
+
+		#define FTRACE_FRMSZ	32
+		#define RA_REG	4
+
+		/* there is a "addiu sp,sp,-8" before "jal _mcount" in 32bit */
+		.macro RESTORE_SP_FOR_32BIT
+		addiu sp, sp, 8
+		.endm
+
+		.macro MCOUNT_SAVE_REGS
+		addiu	sp, sp, -FTRACE_FRMSZ
+#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
+		sw	v0,	28(sp)
+		sw	v1,	24(sp)
+#endif
+		sw	a0, 20(sp)
+		sw	a1, 16(sp)
+		sw	a2, 12(sp)
+		sw	a3, 8(sp)
+		sw	ra, RA_REG(sp)
+		.set	noat
+		sw	$1, 0(sp)
+		.set	at
+		.endm
+
+		.macro MCOUNT_RESTORE_REGS
+#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
+		lw	v0,	28(sp)
+		lw	v1,	24(sp)
+#endif
+		lw	a0, 20(sp)
+		lw	a1, 16(sp)
+		lw	a2, 12(sp)
+		lw	a3, 8(sp)
+		lw	ra, RA_REG(sp)
+		.set	noat
+		lw	$1, 0(sp)
+		.set	at
+		addiu	sp, sp, FTRACE_FRMSZ
+		.endm
+
+#else	/* CONFIG_64BIT */
+
+		#define FTRACE_FRMSZ	96
+		#define RA_REG 8
+
+		.macro RESTORE_SP_FOR_32BIT
+		/* no need for 64bit */
+		.endm
+
+		.macro MCOUNT_SAVE_REGS
+		daddiu	sp, sp, -FTRACE_FRMSZ
+#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
+		sd	v0, 88(sp)
+		sd	v1,	80(sp)
+#endif
+		sd	a0, 72(sp)
+		sd	a1, 64(sp)
+		sd	a2, 56(sp)
+		sd	a3, 48(sp)
+		sd	a4, 40(sp)
+		sd	a5, 32(sp)
+		sd	a6, 24(sp)
+		sd	a7, 16(sp)
+		sd	ra, RA_REG(sp)
+		.set	noat
+		sd	$1, 0(sp)
+		.set	at
+		.endm
+
+		.macro MCOUNT_RESTORE_REGS
+#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
+		ld	v0, 88(sp)
+		ld	v1,	80(sp)
+#endif
+		ld	a0, 72(sp)
+		ld	a1, 64(sp)
+		ld	a2, 56(sp)
+		ld	a3, 48(sp)
+		ld	a4, 40(sp)
+		ld	a5, 32(sp)
+		ld	a6, 24(sp)
+		ld	a7, 16(sp)
+		ld	ra, RA_REG(sp)
+		.set	noat
+		ld	$1, 0(sp)
+		.set	at
+		daddiu	sp, sp, FTRACE_FRMSZ
+		.endm
+#endif
+
+		.macro MCOUNT_SET_ARGS
+		move	a0, ra	/* arg1: next ip, selfaddr */
+		.set	noat
+		move	a1, $1	/* arg2: the caller's next ip, parent */
+		.set	at
+		LONG_SUB	a0, a0, MCOUNT_INSN_SIZE
+		.endm
+
+		.macro RETURN_BACK
+		/* fix for loongson2f */
+#ifdef	CONFIG_LOONGSON2F
+		.set	noat
+		move	t0,	$1
+		.set	at
+		jr	ra
+		move	ra,	t0
+#else
+		jr	ra
+		.set	noat
+		move	ra, $1
+		.set	at
+#endif
+		.endm
+
+.set noreorder
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+LEAF(_mcount)
+	RESTORE_SP_FOR_32BIT
+	RETURN_BACK
+	END(_mcount)
+
+NESTED(ftrace_caller, FTRACE_FRMSZ, ra)
+	RESTORE_SP_FOR_32BIT
+	lw	t0, function_trace_stop
+	bnez	t0, ftrace_stub
+	nop
+
+	MCOUNT_SAVE_REGS
+
+	MCOUNT_SET_ARGS
+	.globl ftrace_call
+ftrace_call:
+	jal	ftrace_stub
+	nop
+
+	MCOUNT_RESTORE_REGS
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.globl ftrace_graph_call
+ftrace_graph_call:
+	j	ftrace_stub
+	nop
+#endif
+	.globl ftrace_stub
+ftrace_stub:
+	RETURN_BACK
+	END(ftrace_caller)
+
+#else	/* ! CONFIG_DYNAMIC_FTRACE */
+
+NESTED(_mcount, FTRACE_FRMSZ, ra)
+	RESTORE_SP_FOR_32BIT
+	lw	t0, function_trace_stop
+	bnez	t0, ftrace_stub
+	nop
+
+	PTR_LA	t0, ftrace_stub
+	/* *ftrace_trace_function -> t1, please don't use t1 later, safe? */
+	LONG_L	t1, ftrace_trace_function
+	bne	t0, t1, static_trace
+	nop
+
+#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
+	LONG_L	t2, ftrace_graph_return
+	bne	t0,	t2, ftrace_graph_caller
+	nop
+	PTR_LA	t0, ftrace_graph_entry_stub
+	LONG_L	t2, ftrace_graph_entry
+	bne	t0,	t2, ftrace_graph_caller
+	nop
+#endif
+	j	ftrace_stub
+	nop
+
+static_trace:
+	MCOUNT_SAVE_REGS
+	MCOUNT_SET_ARGS
+
+	/* t1 hold *ftrace_trace_function */
+	jalr	t1
+	nop
+
+	MCOUNT_RESTORE_REGS
+#	.globl ftrace_stub
+FEXPORT(ftrace_stub)
+	RETURN_BACK
+	END(_mcount)
+
+#endif 		/* !CONFIG_FUNCTION_TRACER */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+NESTED(ftrace_graph_caller, FTRACE_FRMSZ, ra)
+	MCOUNT_SAVE_REGS
+	MCOUNT_SET_ARGS
+
+	jal	prepare_ftrace_return
+	nop
+	/* overwrite the parent as &return_to_handler, safe or not?? */
+	LONG_S	v0, 0(sp)
+
+	MCOUNT_RESTORE_REGS
+	RETURN_BACK
+	END(ftrace_graph_caller)
+
+	.align	2
+	.globl	return_to_handler
+return_to_handler:
+	MCOUNT_SAVE_REGS
+
+	/* restore the real parent address */
+	jal	ftrace_return_to_handler
+	nop
+	LONG_S	v0, RA_REG(sp)
+
+	MCOUNT_RESTORE_REGS
+	RETURN_BACK
+
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+.set reorder
diff --git a/arch/mips/kernel/mips_ksyms.c b/arch/mips/kernel/mips_ksyms.c
index 225755d..30833fe 100644
--- a/arch/mips/kernel/mips_ksyms.c
+++ b/arch/mips/kernel/mips_ksyms.c
@@ -13,6 +13,7 @@
 #include <asm/checksum.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
+#include <asm/ftrace.h>
 
 extern void *__bzero(void *__s, size_t __count);
 extern long __strncpy_from_user_nocheck_asm(char *__to,
@@ -51,3 +52,7 @@ EXPORT_SYMBOL(csum_partial_copy_nocheck);
 EXPORT_SYMBOL(__csum_partial_copy_user);
 
 EXPORT_SYMBOL(invalid_pte_table);
+#ifdef CONFIG_FUNCTION_TRACER
+/* mcount is defined in assembly */
+EXPORT_SYMBOL(_mcount);
+#endif
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 58738c8..67435e5 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -36,6 +36,7 @@ SECTIONS
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		IRQENTRY_TEXT
 		*(.text.*)
 		*(.fixup)
 		*(.gnu.warning)
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 5a40d14..93066c8 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -273,7 +273,7 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
  *
  * Uses the clocksource to return the current cycle_t value
  */
-static inline cycle_t clocksource_read(struct clocksource *cs)
+static inline notrace cycle_t clocksource_read(struct clocksource *cs)
 {
 	return cs->read(cs);
 }
@@ -314,7 +314,7 @@ static inline void clocksource_disable(struct clocksource *cs)
  *
  * XXX - This could use some mult_lxl_ll() asm optimization
  */
-static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
+static inline notrace s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
 {
 	u64 ret = (u64)cycles;
 	ret = (ret * cs->mult) >> cs->shift;
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e1d16c9..c809677 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -36,7 +36,7 @@
  * This is default implementation.
  * Architectures and sub-architectures can override this.
  */
-unsigned long long __attribute__((weak)) sched_clock(void)
+unsigned long long notrace __attribute__((weak)) sched_clock(void)
 {
 	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
 					* (NSEC_PER_SEC / HZ);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 960cbf4..717bd8e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -420,7 +420,8 @@ struct ring_buffer_iter {
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
-u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
+u64 __attribute__((weak)) ring_buffer_time_stamp(struct ring_buffer *buffer,
+				int cpu)
 {
 	u64 time;
 
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index b588fd8..78c98c8 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -26,7 +26,7 @@
  * Useful for tracing that does not cross to other CPUs nor
  * does it go through idle events.
  */
-u64 notrace trace_clock_local(void)
+u64 __attribute__((weak)) notrace trace_clock_local(void)
 {
 	unsigned long flags;
 	u64 clock;
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5c4b7a4..548d575 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -207,6 +207,7 @@ endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
+	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 409596e..8c1b218 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -1,5 +1,6 @@
 #!/usr/bin/perl -w
 # (c) 2008, Steven Rostedt <srostedt@redhat.com>
+# (c) 2009, Wu Zhangjin <wuzj@lemote.com>, DSLab,Lanzhou University,China
 # Licensed under the terms of the GNU GPL License version 2
 #
 # recordmcount.pl - makes a section called __mcount_loc that holds
@@ -100,13 +101,13 @@ $P =~ s@.*/@@g;
 
 my $V = '0.1';
 
-if ($#ARGV < 7) {
-	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
+if ($#ARGV < 8) {
+	print "usage: $P arch endian bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
 	print "version: $V\n";
 	exit(1);
 }
 
-my ($arch, $bits, $objdump, $objcopy, $cc,
+my ($arch, $endian, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
@@ -213,6 +214,24 @@ if ($arch eq "x86_64") {
     if ($is_module eq "0") {
         $cc .= " -mconstant-gp";
     }
+
+} elsif ($arch eq "mips") {
+	$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
+	$objdump .= " -Melf-trad".$endian."mips ";
+	if ($endian eq "big") {
+		$endian = " -EB ";
+		$ld .= " -melf".$bits."btsmip";
+	} else {
+		$endian = " -EL ";
+		$ld .= " -melf".$bits."ltsmip";
+	}
+	$cc .= " -mno-abicalls -mabi=" . $bits . $endian;
+	$ld .= $endian;
+
+	if ($bits == 64) {
+		$type = ".dword";
+	}
+
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
@@ -441,12 +460,12 @@ if ($#converts >= 0) {
     #
     # Step 5: set up each local function as a global
     #
-    `$objcopy $globallist $inputfile $globalobj`;
+    `$objcopy $globallist $inputfile $globalobj 2>&1 >/dev/null`;
 
     #
     # Step 6: Link the global version to our list.
     #
-    `$ld -r $globalobj $mcount_o -o $globalmix`;
+    `$ld -r $globalobj $mcount_o -o $globalmix 2>&1 >/dev/null`;
 
     #
     # Step 7: Convert the local functions back into local symbols
@@ -454,7 +473,7 @@ if ($#converts >= 0) {
     `$objcopy $locallist $globalmix $inputfile`;
 
     # Remove the temp files
-    `$rm $globalobj $globalmix`;
+    `$rm $globalobj $globalmix 2>&1 >/dev/null`;
 
 } else {
 
-- 
1.6.0.4

