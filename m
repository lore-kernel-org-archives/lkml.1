Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbYG0GwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbYG0GwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYG0GwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:52:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbYG0GwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:52:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] powerpc: tracehook: asm/syscall.h
In-Reply-To: Roland McGrath's message of  Saturday, 26 July 2008 23:48:59 -0700 <20080727064859.69692154280@magilla.localdomain>
References: <20080727064859.69692154280@magilla.localdomain>
X-Windows: sometimes you fill a vacuum and it still sucks.
Message-Id: <20080727065135.6A08A154280@magilla.localdomain>
Date: Sat, 26 Jul 2008 23:51:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add asm/syscall.h for powerpc with all the required entry points.
This will allow arch-independent tracing code for system calls.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-powerpc/ptrace.h  |    1 +
 include/asm-powerpc/syscall.h |   84 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-powerpc/syscall.h

diff --git a/include/asm-powerpc/ptrace.h b/include/asm-powerpc/ptrace.h
index 3d6e310..734e075 100644
--- a/include/asm-powerpc/ptrace.h
+++ b/include/asm-powerpc/ptrace.h
@@ -84,6 +84,7 @@ struct pt_regs {
 #ifndef __ASSEMBLY__
 
 #define instruction_pointer(regs) ((regs)->nip)
+#define user_stack_pointer(regs) ((regs)->gpr[1])
 #define regs_return_value(regs) ((regs)->gpr[3])
 
 #ifdef CONFIG_SMP
diff --git a/include/asm-powerpc/syscall.h b/include/asm-powerpc/syscall.h
new file mode 100644
index 0000000..3ced23a
--- /dev/null
+++ b/include/asm-powerpc/syscall.h
@@ -0,0 +1,84 @@
+/*
+ * Access to user system call parameters and results
+ *
+ * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
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
+	return regs->trap == 0xc01 ? regs->gpr[0] : -1L;
+}
+
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	regs->gpr[3] = regs->orig_gpr3;
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	return (regs->ccr & 0x1000) ? -regs->gpr[3] : 0;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->gpr[3];
+}
+
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	if (error) {
+		regs->ccr |= 0x1000L;
+		regs->gpr[3] = -error;
+	} else {
+		regs->ccr &= ~0x1000L;
+		regs->gpr[3] = val;
+	}
+}
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	BUG_ON(i + n > 6);
+#ifdef CONFIG_PPC64
+	if (test_tsk_thread_flag(task, TIF_32BIT)) {
+		/*
+		 * Zero-extend 32-bit argument values.  The high bits are
+		 * garbage ignored by the actual syscall dispatch.
+		 */
+		while (n-- > 0)
+			args[n] = (u32) regs->gpr[3 + i + n];
+		return;
+	}
+#endif
+	memcpy(args, &regs->gpr[3 + i], n * sizeof(args[0]));
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+	BUG_ON(i + n > 6);
+	memcpy(&regs->gpr[3 + i], args, n * sizeof(args[0]));
+}
+
+#endif	/* _ASM_SYSCALL_H */
