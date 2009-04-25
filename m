Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbZDYAQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbZDYAQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZDYAQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:16:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZDYAQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:16:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 16/17] arm: asm/syscall.h (unfinished)
Message-Id: <20090425001503.85473FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:15:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the user_stack_pointer() macro in asm/ptrace.h,
which some new arch-independent code wants to be able to use.

It also adds the asm/syscall.h header to let arch-independent
code interpret the registers as system call arguments or return.

The syscall_get_nr() function here is not really right.  I don't
know enough about ARM to finish it correctly.  It needs to figure
out if the blocked user task is really in the kernel for a system
call and return -1 if not.  I also did not try to handle all the
different ABI variants, which I don't really understand.

Until this is fixed, /proc/pid/syscall can show bogus results
for a process that is blocked inside a fault or something else
that's not a system call.  (It's probably all wrong for !AEABI too.)

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/include/asm/ptrace.h  |    4 +-
 arch/arm/include/asm/syscall.h |   65 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/include/asm/syscall.h

diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index 236a06b..34075dc 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -140,7 +140,8 @@ static inline int valid_user_regs(struct pt_regs *regs)
 	return 0;
 }
 
-#define instruction_pointer(regs)	(regs)->ARM_pc
+#define instruction_pointer(regs)	((regs)->ARM_pc)
+#define user_stack_pointer(regs)	((regs)->ARM_sp)
 
 #ifdef CONFIG_SMP
 extern unsigned long profile_pc(struct pt_regs *regs);
@@ -156,4 +157,3 @@ extern unsigned long profile_pc(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 
 #endif
-
diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
new file mode 100644
index 0000000..56aefe6
--- /dev/null
+++ b/arch/arm/include/asm/syscall.h
@@ -0,0 +1,65 @@
+/*
+ * Access to user system call parameters and results
+ *
+ * See asm-generic/syscall.h for descriptions of what we must do here.
+ */
+
+#ifndef _ASM_SYSCALL_H
+#define _ASM_SYSCALL_H	1
+
+#include <linux/sched.h>
+#include <linux/err.h>
+
+static inline long syscall_get_nr(struct task_struct *task,
+				  struct pt_regs *regs)
+{
+	/* XXX how to figure out if blocked in a syscall or not?? */
+
+	return regs->ARM_r7;	/* XXX apparently */
+	return task_thread_info(task)->syscall; /* XXX if changed via ptrace */
+}
+
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	regs->ARM_r0 = regs->ARM_ORIG_r0;
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	return IS_ERR_VALUE(regs->ARM_r0) ? regs->ARM_r0 : 0;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->ARM_r0;
+}
+
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	regs->ARM_r0 = (long) error ?: val;
+}
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	BUG_ON(i + n > 6);
+	memcpy(args, &regs->uregs[i], n * sizeof(args[0]));
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+	BUG_ON(i + n > 6);
+	memcpy(&regs->uregs[i], args, n * sizeof(args[0]));
+}
+
+#endif	/* _ASM_SYSCALL_H */
