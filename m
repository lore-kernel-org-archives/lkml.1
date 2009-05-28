Return-Path: <linux-kernel-owner+w=401wt.eu-S1764936AbZE1UuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764936AbZE1UuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762084AbZE1Ut5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:49:57 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:63405 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764690AbZE1Utz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r46Sd1MP8FKkMyzWYPC0yzLzGVurRgRR0V6syYbxTw4PaG0SXtv2JV6XPvEB2pLLfu
         YpKNBjJ94w0yVYR4A2p5+AdvR2QyNZqFYFukZoNWZp+cZzLyLviTSrluEzW/jB4WG2dW
         l0xFuzZZXhTYaK5JM08w/mCbjhSD6VFd2ykvE=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v1 5/5] mips specific system call tracer
Date: Fri, 29 May 2009 04:49:45 +0800
Message-Id: <58998df2bd9a70ce2a4cbb0e6a0d9d5439cebdba.1243543471.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1243543471.git.wuzj@lemote.com>
References: <cover.1243543471.git.wuzj@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

FIXME: there are several different sys_call_entry in mips64, but
currently, i only use the the one in arch/mips/kernel/scall64-o32.S
so,if people not use o32 standard, it will not compiled normally.

the system call tracing demo in a debian system on
qemu-system-mipsel/malta:

debian-mips-malta:~# mount -t debugfs nodev /debug
debian-mips-malta:~# echo 20000 > /debug/tracing/buffer_size_kb
debian-mips-malta:~# cat /debug/tracing/available_tracers
syscall nop
debian-mips-malta:~# echo syscall > /debug/tracing/current_tracer
debian-mips-malta:~# echo 1 > /debug/tracing/tracing_enabled
debian-mips-malta:~# sleep 1
debian-mips-malta:~# echo 0 > /debug/tracing/tracing_enabled
debian-mips-malta:~# cat /debug/tracing/trace | head -20
           <...>-533   [000]    60.458291: sys_write(fd: 1, buf: 4fc408, count: 8)
           <...>-533   [000]    64.325614: sys_getrlimit(resource: 3, rlim: 530020)
           <...>-533   [000]    64.327089: sys_read(fd: 2, buf: 4fc008, count: 6)
           <...>-533   [000]    64.969663: sys_exit(error_code: 2)
           <...>-533   [000]    65.608794: sys_exit(error_code: 2)
           <...>-533   [000]    66.231796: sys_read(fd: 2, buf: 4fc008, count: 6)
           <...>-533   [000]    66.913687: sys_open(filename: 1, flags: 0, mode: a)
           <...>-533   [000]    66.914617: sys_exit(error_code: 1)
           <...>-533   [000]    70.797507: sys_exit(error_code: 503be8)
           <...>-536   [000]    70.833108: sys_exit(error_code: 2aac6cfc)
           <...>-536   [000]    70.833897: sys_exit(error_code: 2aac6540)
           <...>-536   [000]    70.835711: sys_exit(error_code: 2aac6cfc)
           <...>-536   [000]    70.840609: sys_lchown(filename: 3, user: 7fb08b38, group: 20)
           <...>-533   [000]    71.877785: sys_open(filename: ffffffff, flags: 7fcf08c8, mode: b)
           <...>-533   [000]    75.531122: sys_open(filename: 1, flags: 0, mode: a)

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/Kconfig                   |    1 +
 arch/mips/include/asm/ptrace.h      |    2 +
 arch/mips/include/asm/reg.h         |    5 ++
 arch/mips/include/asm/syscall.h     |   84 +++++++++++++++++++++++++++++++++++
 arch/mips/include/asm/thread_info.h |    5 ++-
 arch/mips/kernel/Makefile           |    1 +
 arch/mips/kernel/entry.S            |    2 +-
 arch/mips/kernel/ftrace.c           |   71 +++++++++++++++++++++++++++++
 arch/mips/kernel/ptrace.c           |   14 +++++-
 arch/mips/kernel/scall64-o32.S      |    2 +-
 10 files changed, 182 insertions(+), 5 deletions(-)
 create mode 100644 arch/mips/include/asm/syscall.h

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ac1437e..f488027 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -10,6 +10,7 @@ config MIPS
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
 	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_FTRACE_SYSCALLS
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index ce47118..32e5b62 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -45,6 +45,8 @@ struct pt_regs {
 	unsigned long cp0_badvaddr;
 	unsigned long cp0_cause;
 	unsigned long cp0_epc;
+	/* Used for restarting system calls */
+	unsigned long orig_v0;
 #ifdef CONFIG_MIPS_MT_SMTC
 	unsigned long cp0_tcstatus;
 #endif /* CONFIG_MIPS_MT_SMTC */
diff --git a/arch/mips/include/asm/reg.h b/arch/mips/include/asm/reg.h
index 634b55d..93d66bc 100644
--- a/arch/mips/include/asm/reg.h
+++ b/arch/mips/include/asm/reg.h
@@ -65,6 +65,8 @@
 #define EF_CP0_CAUSE		43
 #define EF_UNUSED0		44
 
+#define EF_ORIG_V0		45
+
 #define EF_SIZE			180
 
 #endif
@@ -121,6 +123,9 @@
 #define EF_CP0_STATUS		36
 #define EF_CP0_CAUSE		37
 
+
+#define EF_ORIG_V0			38
+
 #define EF_SIZE			304	/* size in bytes */
 
 #endif /* CONFIG_64BIT */
diff --git a/arch/mips/include/asm/syscall.h b/arch/mips/include/asm/syscall.h
new file mode 100644
index 0000000..b785098
--- /dev/null
+++ b/arch/mips/include/asm/syscall.h
@@ -0,0 +1,84 @@
+/*
+ * Access to user system call parameters and results
+ *
+ * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2009 DSLab, Lanzhou University, China
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * See asm-generic/syscall.h for descriptions of what we must do here.
+ */
+
+#ifndef _ASM_SYSCALL_H
+#define _ASM_SYSCALL_H	1
+
+#include <linux/sched.h>
+
+static inline long syscall_get_nr(struct task_struct *task,
+				  struct pt_regs *regs)
+{
+	/*        syscall   Exc-Code: 0 1000 00     v0 */
+	return ((regs->cp0_cause&0xff) == 0x20)  ? regs->regs[2] : -1L;
+}
+
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	regs->regs[2] = regs->orig_v0;
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	return regs->regs[2] ? -regs->regs[2] : 0;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->regs[2];
+}
+
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	if (error)
+		regs->regs[2] = -error;
+	else
+		regs->regs[2] = val;
+}
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+#ifdef CONFIG_32BIT
+	/* fixme: only 4 argument register available in mip32, so, how to handle
+	 * others?
+	 */
+	BUG_ON(i + n > 4);
+#else
+	BUG_ON(i + n > 6);
+#endif
+	memcpy(args, &regs->regs[4 + i], n * sizeof(args[0]));
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+#ifdef CONFIG_32BIT
+	BUG_ON(i + n > 4);
+#else
+	BUG_ON(i + n > 6);
+#endif
+	memcpy(&regs->regs[4 + i], args, n * sizeof(args[0]));
+}
+
+#endif	/* _ASM_SYSCALL_H */
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 143a481..1d55dc0 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -128,6 +128,7 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define TIF_32BIT_ADDR		23	/* 32-bit address space (o32/n32) */
 #define TIF_FPUBOUND		24	/* thread bound to FPU-full CPU set */
 #define TIF_LOAD_WATCH		25	/* If set, load watch registers */
+#define TIF_SYSCALL_FTRACE	27	/* for ftrace syscall instrumentation */
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #ifdef CONFIG_MIPS32_O32
@@ -151,11 +152,13 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define _TIF_32BIT_ADDR		(1<<TIF_32BIT_ADDR)
 #define _TIF_FPUBOUND		(1<<TIF_FPUBOUND)
 #define _TIF_LOAD_WATCH		(1<<TIF_LOAD_WATCH)
+#define _TIF_SYSCALL_FTRACE	(1<<TIF_SYSCALL_FTRACE)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
 /* work to do on any return to u-space */
-#define _TIF_ALLWORK_MASK	(0x8000ffff & ~_TIF_SECCOMP)
+#define _TIF_ALLWORK_MASK	\
+	((0x8000ffff & ~_TIF_SECCOMP) | _TIF_SYSCALL_FTRACE)
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 5dec76f..8b4fafa 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
 
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o
+obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_NOP_TRACER)	+= ftrace_clock.o
 
 obj-$(CONFIG_CPU_LOONGSON2)	+= r4k_fpu.o r4k_switch.o
diff --git a/arch/mips/kernel/entry.S b/arch/mips/kernel/entry.S
index ffa3310..786e4ef 100644
--- a/arch/mips/kernel/entry.S
+++ b/arch/mips/kernel/entry.S
@@ -167,7 +167,7 @@ work_notifysig:				# deal with pending signals and
 FEXPORT(syscall_exit_work_partial)
 	SAVE_STATIC
 syscall_exit_work:
-	li	t0, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t0, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SYSCALL_FTRACE
 	and	t0, a2			# a2 is preloaded with TI_FLAGS
 	beqz	t0, work_pending	# trace bit set?
 	local_irq_enable		# could let do_syscall_trace()
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index e7f15f7..5967998 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -22,6 +22,8 @@
 #include <asm/asm.h>
 #include <asm/unistd.h>
 
+#include <trace/syscall.h>
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 #define JAL 0x0c000000	/* jump & link: ip --> ra, jump to target */
@@ -287,3 +289,72 @@ out:
     return parent_ip;
 }
 #endif				/* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+
+extern unsigned long __start_syscalls_metadata[];
+extern unsigned long __stop_syscalls_metadata[];
+
+/* fixme: in mips64, there are different entries of sys_call_table when using
+ * different standards, in loongson2f based machines: Fuloong & Yeeloong, the
+ * system use o32 standard, so here, we only use the sys_call_table in
+ * arch/mips/kernel/scall64-o32.S */
+
+extern unsigned long *sys_call_table;
+
+static struct syscall_metadata **syscalls_metadata;
+
+static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
+{
+	struct syscall_metadata *start;
+	struct syscall_metadata *stop;
+	char str[KSYM_SYMBOL_LEN];
+
+
+	start = (struct syscall_metadata *)__start_syscalls_metadata;
+	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
+	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
+
+	for ( ; start < stop; start++) {
+		if (start->name && !strcmp(start->name, str))
+			return start;
+	}
+	return NULL;
+}
+
+struct syscall_metadata *syscall_nr_to_meta(int nr)
+{
+	if (!syscalls_metadata || nr >= __NR_Linux_syscalls || nr < 0)
+		return NULL;
+
+	return syscalls_metadata[nr];
+}
+
+void arch_init_ftrace_syscalls(void)
+{
+	int i;
+	struct syscall_metadata *meta;
+	unsigned long **psys_syscall_table = &sys_call_table;
+	static atomic_t refs;
+
+	if (atomic_inc_return(&refs) != 1)
+		goto end;
+
+	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
+					__NR_Linux_syscalls, GFP_KERNEL);
+	if (!syscalls_metadata) {
+		WARN_ON(1);
+		return;
+	}
+
+	for (i = 0; i < __NR_Linux_syscalls; i++) {
+		meta = find_syscall_meta(psys_syscall_table[i]);
+		syscalls_metadata[i] = meta;
+	}
+	return;
+
+	/* Paranoid: avoid overflow */
+end:
+	atomic_dec(&refs);
+}
+#endif	/* CONFIG_FTRACE_SYSCALLS */
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 054861c..fa762dc 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -25,6 +25,7 @@
 #include <linux/security.h>
 #include <linux/audit.h>
 #include <linux/seccomp.h>
+#include <linux/ftrace.h>
 
 #include <asm/byteorder.h>
 #include <asm/cpu.h>
@@ -39,6 +40,7 @@
 #include <asm/bootinfo.h>
 #include <asm/reg.h>
 
+#include <trace/syscall.h>
 /*
  * Called by kernel/ptrace.c when detaching..
  *
@@ -60,7 +62,7 @@ int ptrace_getregs(struct task_struct *child, __s64 __user *data)
 	struct pt_regs *regs;
 	int i;
 
-	if (!access_ok(VERIFY_WRITE, data, 38 * 8))
+	if (!access_ok(VERIFY_WRITE, data, 39 * 8))
 		return -EIO;
 
 	regs = task_pt_regs(child);
@@ -73,6 +75,7 @@ int ptrace_getregs(struct task_struct *child, __s64 __user *data)
 	__put_user((long)regs->cp0_badvaddr, data + EF_CP0_BADVADDR - EF_R0);
 	__put_user((long)regs->cp0_status, data + EF_CP0_STATUS - EF_R0);
 	__put_user((long)regs->cp0_cause, data + EF_CP0_CAUSE - EF_R0);
+	__put_user((long)regs->orig_v0, data + EF_ORIG_V0 - EF_R0);
 
 	return 0;
 }
@@ -87,7 +90,7 @@ int ptrace_setregs(struct task_struct *child, __s64 __user *data)
 	struct pt_regs *regs;
 	int i;
 
-	if (!access_ok(VERIFY_READ, data, 38 * 8))
+	if (!access_ok(VERIFY_READ, data, 39 * 8))
 		return -EIO;
 
 	regs = task_pt_regs(child);
@@ -97,6 +100,7 @@ int ptrace_setregs(struct task_struct *child, __s64 __user *data)
 	__get_user(regs->lo, data + EF_LO - EF_R0);
 	__get_user(regs->hi, data + EF_HI - EF_R0);
 	__get_user(regs->cp0_epc, data + EF_CP0_EPC - EF_R0);
+	__get_user(regs->orig_v0, data + EF_ORIG_V0 - EF_R0);
 
 	/* badvaddr, status, and cause may not be written.  */
 
@@ -575,6 +579,9 @@ asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
 	if (!(current->ptrace & PT_PTRACED))
 		goto out;
 
+	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
+		ftrace_syscall_exit(regs);
+
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		goto out;
 
@@ -594,6 +601,9 @@ asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
 	}
 
 out:
+	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
+		ftrace_syscall_enter(regs);
+
 	if (unlikely(current->audit_context) && !entryexit)
 		audit_syscall_entry(audit_arch(), regs->regs[0],
 				    regs->regs[4], regs->regs[5],
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index a5598b2..dd1f13a 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -202,7 +202,7 @@ einval:	li	v0, -ENOSYS
 
 	.align	3
 	.type	sys_call_table,@object
-sys_call_table:
+EXPORT(sys_call_table)
 	PTR	sys32_syscall			/* 4000 */
 	PTR	sys_exit
 	PTR	sys_fork
-- 
1.6.0.4

