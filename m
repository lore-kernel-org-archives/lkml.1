Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0BJQ0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:26:14 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:50358 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0BJQ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:26:12 -0500
Date: Wed, 10 Feb 2010 17:26:10 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] s390: add pt_regs register and stack access API
Message-ID: <20100210162610.GC6933@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

This API is needed for the kprobe-based event tracer.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig              |    1 
 arch/s390/include/asm/ptrace.h |   14 +++++++
 arch/s390/kernel/ptrace.c      |   76 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 90 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -492,13 +492,25 @@ struct user_regs_struct
 struct task_struct;
 extern void user_enable_single_step(struct task_struct *);
 extern void user_disable_single_step(struct task_struct *);
+extern void show_regs(struct pt_regs * regs);
 
 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
 #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
 #define user_stack_pointer(regs)((regs)->gprs[15])
 #define regs_return_value(regs)((regs)->gprs[2])
 #define profile_pc(regs) instruction_pointer(regs)
-extern void show_regs(struct pt_regs * regs);
+
+int regs_query_register_offset(const char *name);
+const char *regs_query_register_name(unsigned int offset);
+unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n);
+unsigned long regs_get_register(struct pt_regs *regs, unsigned int offset);
+unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs, unsigned int n);
+
+static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
+{
+	return regs->gprs[15] & PSW_ADDR_INSN;
+}
+
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -87,6 +87,7 @@ config S390
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_DEFAULT_NO_SPIN_MUTEXES
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -992,3 +992,79 @@ const struct user_regset_view *task_user
 #endif
 	return &user_s390_view;
 }
+
+static const char *gpr_names[NUM_GPRS] = {
+	"r0", "r1",  "r2",  "r3",  "r4",  "r5",  "r6",  "r7",
+	"r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
+};
+
+unsigned long regs_get_register(struct pt_regs *regs, unsigned int offset)
+{
+	if (offset >= NUM_GPRS)
+		return 0;
+	return regs->gprs[offset];
+}
+
+int regs_query_register_offset(const char *name)
+{
+	unsigned long offset;
+
+	if (!name || *name != 'r')
+		return -EINVAL;
+	if (strict_strtoul(name + 1, 10, &offset))
+		return -EINVAL;
+	if (offset >= NUM_GPRS)
+		return -EINVAL;
+	return offset;
+}
+
+const char *regs_query_register_name(unsigned int offset)
+{
+	if (offset >= NUM_GPRS)
+		return NULL;
+	return gpr_names[offset];
+}
+
+static int regs_within_kernel_stack(struct pt_regs *regs, unsigned long addr)
+{
+	unsigned long ksp = kernel_stack_pointer(regs);
+
+	return (addr & ~(THREAD_SIZE - 1)) == (ksp & ~(THREAD_SIZE - 1));
+}
+
+/**
+ * regs_get_kernel_stack_nth() - get Nth entry of the stack
+ * @regs:pt_regs which contains kernel stack pointer.
+ * @n:stack entry number.
+ *
+ * regs_get_kernel_stack_nth() returns @n th entry of the kernel stack which
+ * is specifined by @regs. If the @n th entry is NOT in the kernel stack,
+ * this returns 0.
+ */
+unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs, unsigned int n)
+{
+	unsigned long addr;
+
+	addr = kernel_stack_pointer(regs) + n * sizeof(long);
+	if (!regs_within_kernel_stack(regs, addr))
+		return 0;
+	return *(unsigned long *)addr;
+}
+
+/**
+ * regs_get_argument_nth() - get Nth argument at function call
+ * @regs:pt_regs which contains registers at function entry.
+ * @n:argument number.
+ *
+ * regs_get_argument_nth() returns @n th argument of a function call.
+ * Since usually the kernel stack will be changed right after function entry,
+ * you must use this at function entry. If the @n th entry is NOT in the
+ * kernel stack or pt_regs, this returns 0.
+ */
+unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n)
+{
+	if (n < 5)
+		return regs->gprs[2 + n];
+	n += STACK_FRAME_OVERHEAD / sizeof(long);
+	return regs_get_kernel_stack_nth(regs, n - 5);
+}
