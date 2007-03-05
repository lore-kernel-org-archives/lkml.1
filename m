Return-Path: <linux-kernel-owner+w=401wt.eu-S1750971AbXCEHYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971AbXCEHYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 02:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXCEHYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 02:24:11 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:13708 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbXCEHYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 02:24:10 -0500
X-IronPort-AV: i="4.14,247,1170651600"; 
   d="scan'208"; a="23544355:sNHT24197222"
Subject: [PATCH -mm] Blackfin: blackfin utrace patch
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 05 Mar 2007 15:24:00 +0800
Message-Id: <1173079440.5264.169.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

As utrace is very promising in the -mm tree, a simple support is added
to blackfin architecture. I send this patch out just for review and it
is only a start point, we will make it fully work in the future.

Now after applying this patch, the blackfin-arch can be compile in the
2.6.21-rc2-mm1 with utrace enabled and ptrace disabled.

[PATCH -mm] Blackfin: blackfin utrace patch

This patch adds support utrace in blackfin architecture.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---

 arch/blackfin/kernel/asm-offsets.c |    2
 arch/blackfin/kernel/ptrace.c      |    8 +++
 include/asm-blackfin/thread_info.h |    2
 include/asm-blackfin/tracehook.h   |   79 +++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)

diff -uprN linux-2.6-orig/arch/blackfin/kernel/asm-offsets.c linux-2.6/arch/blackfin/kernel/asm-offsets.c
--- linux-2.6-orig/arch/blackfin/kernel/asm-offsets.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/asm-offsets.c	2007-03-05 11:57:23.000000000 +0800
@@ -45,7 +45,9 @@ int main(void)
 	/* offsets into the task struct */
 	DEFINE(TASK_STATE, offsetof(struct task_struct, state));
 	DEFINE(TASK_FLAGS, offsetof(struct task_struct, flags));
+#if 0
 	DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
+#endif
 	DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
 	DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
 	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, thread_info));
diff -uprN linux-2.6-orig/arch/blackfin/kernel/ptrace.c linux-2.6/arch/blackfin/kernel/ptrace.c
--- linux-2.6-orig/arch/blackfin/kernel/ptrace.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/ptrace.c	2007-03-05 11:57:23.000000000 +0800
@@ -34,12 +34,14 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
+#include <linux/tracehook.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/signal.h>
 
 #include <asm/uaccess.h>
+#include <asm/tracehook.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -173,6 +175,8 @@ static inline int is_user_addr_valid(str
 	return -EIO;
 }
 
+#ifdef CONFIG_PTRACE
+
 /*
  * Called by kernel/ptrace.c when detaching..
  *
@@ -386,12 +390,15 @@ long arch_ptrace(struct task_struct *chi
 	return ret;
 }
 
+#endif /* CONFIG_PTRACE */
+
 asmlinkage void syscall_trace(void)
 {
 
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return;
 
+#if 0	
 	if (!(current->ptrace & PT_PTRACED))
 		return;
 
@@ -400,6 +407,7 @@ asmlinkage void syscall_trace(void)
 	 */
 	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
 				 ? 0x80 : 0));
+#endif
 
 	/*
 	 * this isn't the same as continuing with a signal, but it will do
diff -uprN linux-2.6-orig/include/asm-blackfin/thread_info.h linux-2.6/include/asm-blackfin/thread_info.h
--- linux-2.6-orig/include/asm-blackfin/thread_info.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/thread_info.h	2007-03-05 11:57:23.000000000 +0800
@@ -127,6 +127,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE              5
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_FREEZE              7       /* is freezing for suspend */
+#define TIF_SINGLESTEP		8       /* restore singlestep on return to user mode */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -136,6 +137,7 @@ static inline struct thread_info *curren
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE             (1<<TIF_FREEZE)
+#define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
diff -uprN linux-2.6-orig/include/asm-blackfin/tracehook.h linux-2.6/include/asm-blackfin/tracehook.h
--- linux-2.6-orig/include/asm-blackfin/tracehook.h	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6/include/asm-blackfin/tracehook.h	2007-03-05 11:57:23.000000000 +0800
@@ -0,0 +1,79 @@
+/*
+ * Tracing hooks, Blackfin Architecture support
+ *
+ * Copyright (C) 2006, 2007 Analog Devices, Inc.  All rights reserved.
+ * Copyright (C) 2006, 2007 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * ADI Author: Bryan Wu
+ * Red Hat Author: Roland McGrath.
+ */
+
+#ifndef _ASM_TRACEHOOK_H
+#define _ASM_TRACEHOOK_H	1
+
+#include <linux/sched.h>
+#include <asm/ptrace.h>
+
+/*
+ * See linux/tracehook.h for the descriptions of what these need to do.
+ */
+
+#define ARCH_HAS_SINGLE_STEP	(1)
+
+static inline void tracehook_enable_single_step(struct task_struct *task)
+{
+	/* TODO */
+#if 0
+	struct pt_regs *regs = task->thread.regs;
+
+	if (regs != NULL) {
+	}
+#endif 
+	set_tsk_thread_flag(task, TIF_SINGLESTEP);
+}
+
+static inline void tracehook_disable_single_step(struct task_struct *task)
+{
+	/* TODO */
+#if 0
+	struct pt_regs *regs = task->thread.regs;
+
+	if (regs != NULL) {
+	}
+#endif
+	clear_tsk_thread_flag(task, TIF_SINGLESTEP);
+}
+
+
+static inline int tracehook_single_step_enabled(struct task_struct *tsk)
+{
+	return test_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+}
+
+static inline void tracehook_enable_syscall_trace(struct task_struct *tsk)
+{
+	set_tsk_thread_flag(tsk, TIF_SYSCALL_TRACE);
+}
+
+static inline void tracehook_disable_syscall_trace(struct task_struct *tsk)
+{
+	clear_tsk_thread_flag(tsk, TIF_SYSCALL_TRACE);
+}
+
+static inline void tracehook_abort_syscall(struct pt_regs *regs)
+{
+	regs->orig_r0 = -1;
+}
+
+extern const struct utrace_regset_view utrace_bfin_native;
+static inline const struct utrace_regset_view *
+utrace_native_view(struct task_struct *tsk)
+{
+	return &utrace_bfin_native;
+}
+
+#endif
_

Thanks
-Bryan Wu
