Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbYGQHtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbYGQHtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbYGQHtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:49:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbYGQHtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:49:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 3/6] x86: tracehook: asm/syscall.h
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:45:50 -0700 <20080717074550.EE1E215411D@magilla.localdomain>
References: <20080717074550.EE1E215411D@magilla.localdomain>
X-Windows: even your dog won't like it.
Message-Id: <20080717074852.4DE5A15411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:48:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add asm/syscall.h for x86 with all the required entry points.
This will allow arch-independent tracing code for system calls.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-x86/ptrace.h  |    5 +
 include/asm-x86/syscall.h |  210 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 215 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 8a71db8..91a77f5 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -213,6 +213,11 @@ static inline unsigned long frame_pointer(struct pt_regs *regs)
 	return regs->bp;
 }
 
+static inline unsigned long user_stack_pointer(struct pt_regs *regs)
+{
+	return regs->sp;
+}
+
 /*
  * These are defined as per linux/ptrace.h, which see.
  */
diff --git a/include/asm-x86/syscall.h b/include/asm-x86/syscall.h
new file mode 100644
index 0000000..7de35f0
--- /dev/null
+++ b/include/asm-x86/syscall.h
@@ -0,0 +1,210 @@
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
+	/*
+	 * We always sign-extend a -1 value being set here,
+	 * so this is always either -1L or a syscall number.
+	 */
+	return regs->orig_ax;
+}
+
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	regs->ax = regs->orig_ax;
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	unsigned long error = regs->ax;
+#ifdef CONFIG_IA32_EMULATION
+	/*
+	 * TS_COMPAT is set for 32-bit syscall entries and then
+	 * remains set until we return to user mode.
+	 */
+	if (task_thread_info(task)->status & TS_COMPAT)
+		/*
+		 * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
+		 * and will match correctly in comparisons.
+		 */
+		error = (long) (int) error;
+#endif
+	return error >= -4095L ? error : 0;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->ax;
+}
+
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	regs->ax = (long) error ?: val;
+}
+
+#ifdef CONFIG_X86_32
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long args[n])
+{
+	BUG_ON(i + n > 6);
+	memcpy(args, &regs->bx + i, n * sizeof(args[0]));
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long args[n])
+{
+	BUG_ON(i + n > 6);
+	memcpy(&regs->bx + i, args, n * sizeof(args[0]));
+}
+
+#else	 /* CONFIG_X86_64 */
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+# ifdef CONFIG_IA32_EMULATION
+	if (task_thread_info(task)->status & TS_COMPAT)
+		switch (i + n) {
+		case 6:
+			if (!n--) break;
+			*args++ = regs->bp;
+		case 5:
+			if (!n--) break;
+			*args++ = regs->di;
+		case 4:
+			if (!n--) break;
+			*args++ = regs->si;
+		case 3:
+			if (!n--) break;
+			*args++ = regs->dx;
+		case 2:
+			if (!n--) break;
+			*args++ = regs->cx;
+		case 1:
+			if (!n--) break;
+			*args++ = regs->bx;
+		case 0:
+			if (!n--) break;
+		default:
+			BUG();
+			break;
+		}
+	else
+# endif
+		switch (i + n) {
+		case 6:
+			if (!n--) break;
+			*args++ = regs->r9;
+		case 5:
+			if (!n--) break;
+			*args++ = regs->r8;
+		case 4:
+			if (!n--) break;
+			*args++ = regs->r10;
+		case 3:
+			if (!n--) break;
+			*args++ = regs->dx;
+		case 2:
+			if (!n--) break;
+			*args++ = regs->si;
+		case 1:
+			if (!n--) break;
+			*args++ = regs->di;
+		case 0:
+			if (!n--) break;
+		default:
+			BUG();
+			break;
+		}
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+# ifdef CONFIG_IA32_EMULATION
+	if (task_thread_info(task)->status & TS_COMPAT)
+		switch (i + n) {
+		case 6:
+			if (!n--) break;
+			regs->bp = *args++;
+		case 5:
+			if (!n--) break;
+			regs->di = *args++;
+		case 4:
+			if (!n--) break;
+			regs->si = *args++;
+		case 3:
+			if (!n--) break;
+			regs->dx = *args++;
+		case 2:
+			if (!n--) break;
+			regs->cx = *args++;
+		case 1:
+			if (!n--) break;
+			regs->bx = *args++;
+		case 0:
+			if (!n--) break;
+		default:
+			BUG();
+		}
+	else
+# endif
+		switch (i + n) {
+		case 6:
+			if (!n--) break;
+			regs->r9 = *args++;
+		case 5:
+			if (!n--) break;
+			regs->r8 = *args++;
+		case 4:
+			if (!n--) break;
+			regs->r10 = *args++;
+		case 3:
+			if (!n--) break;
+			regs->dx = *args++;
+		case 2:
+			if (!n--) break;
+			regs->si = *args++;
+		case 1:
+			if (!n--) break;
+			regs->di = *args++;
+		case 0:
+			if (!n--) break;
+		default:
+			BUG();
+		}
+}
+
+#endif	/* CONFIG_X86_32 */
+
+#endif	/* _ASM_SYSCALL_H */
