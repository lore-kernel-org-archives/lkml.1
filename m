Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0BRLNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:13:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61799 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab0BRLNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k3fcn9VTPgLSVY+kq3qpFLprjLjmsTtnBDuPSa5mZzjkW2+JWkpl7xwP/oVt6zSaMc
         RLkskJ1EU9qjSo/xIUR5msZ8tXfuCpb0bA3lLXfSelZqhpn6oVscq1aQGocs9GAhWMWT
         rqy01HlLCY34pn8YP5djZPiAmostdK64MQBug=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier@gentoo.org>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] s390: Add pt_regs register and stack access API
Date: Thu, 18 Feb 2010 12:13:36 +0100
Message-Id: <1266491616-6270-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

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
-- 
1.6.2.3

