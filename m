Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968227Ab0B0Mwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:52:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:36082 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968207Ab0B0Mwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:52:31 -0500
Date: Sat, 27 Feb 2010 12:52:07 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com
In-Reply-To: <20100212123840.GB27548@osiris.boeblingen.de.ibm.com>
References: <20100212123840.GB27548@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] s390: Add pt_regs register and stack access API
Message-ID: <tip-952974ac61f686896bd4134dae106a886a5589f1@git.kernel.org>
Git-Commit-ID: 952974ac61f686896bd4134dae106a886a5589f1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Feb 2010 12:52:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  952974ac61f686896bd4134dae106a886a5589f1
Gitweb:     http://git.kernel.org/tip/952974ac61f686896bd4134dae106a886a5589f1
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Fri, 12 Feb 2010 13:38:40 +0100
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 17 Feb 2010 13:19:26 +0100

s390: Add pt_regs register and stack access API

This API is needed for the kprobe-based event tracer.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
LKML-Reference: <20100212123840.GB27548@osiris.boeblingen.de.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/s390/Kconfig              |    1 +
 arch/s390/include/asm/ptrace.h |   13 ++++++++-
 arch/s390/kernel/ptrace.c      |   58 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c802352..2590ce2 100644
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
diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index 95dcf18..dd2d913 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -492,13 +492,24 @@ struct user_regs_struct
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
 
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 13815d3..1720f38 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -984,3 +984,61 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
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
