Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbYAZP5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbYAZP5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYAZPyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:54:37 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752797AbYAZPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:54:35 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 23/52] [microblaze] process and init task function
Date: Thu, 24 Jan 2008 16:02:58 +0100
Message-Id: <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/init_task.c |   31 +++++++++
 arch/microblaze/kernel/process.c   |  129 ++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/init_task.c
 create mode 100644 arch/microblaze/kernel/process.c

diff --git a/arch/microblaze/kernel/init_task.c b/arch/microblaze/kernel/init_task.c
new file mode 100644
index 0000000..7c6bce3
--- /dev/null
+++ b/arch/microblaze/kernel/init_task.c
@@ -0,0 +1,31 @@
+/*
+ * arch/microblaze/kernel/init_task.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/init_task.h>
+#include <linux/fs.h>
+#include <linux/mqueue.h>
+
+#include <asm/pgtable.h>
+
+static struct fs_struct init_fs = INIT_FS;
+static struct files_struct init_files = INIT_FILES;
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+struct mm_struct init_mm = INIT_MM(init_mm);
+EXPORT_SYMBOL(init_mm);
+
+union thread_union init_thread_union
+	__attribute__((__section__(".data.init_task"))) =
+{ INIT_THREAD_INFO(init_task) };
+
+struct task_struct init_task = INIT_TASK(init_task);
+EXPORT_SYMBOL(init_task);
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
new file mode 100644
index 0000000..679fe19
--- /dev/null
+++ b/arch/microblaze/kernel/process.c
@@ -0,0 +1,129 @@
+/*
+ * arch/microblaze/kernel/process.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/pm.h>
+
+#include <asm/system.h>
+
+/* FIXME */
+void show_regs(struct pt_regs *regs)
+{
+	unsigned long *p;
+	int i;
+	printk(KERN_INFO "pc:\t0x%08lx\tsp:\t0x%08lx\n", regs->pc, regs->r1);
+	printk(KERN_INFO
+		"flags:\t0x%08lx\tear:\t0x%08lx\tesr:\t"
+		"0x%08lx\tfsr:\t0x%08lx\n",
+		regs->msr, regs->ear, regs->esr, regs->fsr);
+	printk(KERN_INFO
+		"r0:\t0x%08lx\tr1:\t0x%08lx\tr2:\t0x%08lx\tr3\t0x%08lx\n",
+		0L, regs->r1, regs->r2, regs->r3);
+	for (i = 4, p = &(regs->r4); i < 32; i += 4, p += 4) {
+		printk(KERN_INFO "r%i:\t0x%08lx\tr%i:\t0x%08lx\tr%i:\t"
+			"0x%08lx\tr%i:\t0x%08lx\n",
+			i, *p, i+1, *(p+1), i+2, *(p+2), i+3, *(p+3));
+	}
+	printk(KERN_INFO "\n");
+}
+
+void (*pm_power_off)(void) = NULL;
+EXPORT_SYMBOL(pm_power_off);
+
+void cpu_idle(void)
+{
+	set_thread_flag(TIF_POLLING_NRFLAG);
+
+	while (1) {
+		while (!need_resched())
+			cpu_relax();
+
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+	}
+}
+
+void flush_thread(void)
+{
+}
+
+int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+		unsigned long unused,
+		struct task_struct *p, struct pt_regs *regs)
+{
+	struct pt_regs *childregs = task_pt_regs(p);
+	struct thread_info *ti = task_thread_info(p);
+
+	*childregs = *regs;
+
+	if (user_mode(regs))
+		childregs->r1 = usp;
+	else
+		childregs->r1 = ((unsigned long) ti) + THREAD_SIZE;
+
+	memset(&ti->cpu_context, 0, sizeof(struct cpu_context));
+	ti->cpu_context.sp = (unsigned long)childregs;
+	ti->cpu_context.msr = (unsigned long)childregs->msr;
+	ti->cpu_context.r15 = (unsigned long)ret_from_fork - 8;
+
+	if (clone_flags & CLONE_SETTLS)
+		;/* FIXME: not sure what to do */
+
+	return 0;
+}
+
+/*
+ * Return saved PC of a blocked thread.
+ * FIXME this needs to be checked
+ */
+unsigned long thread_saved_pc(struct task_struct *tsk)
+{
+	struct cpu_context *ctx =
+		&(((struct thread_info *)(tsk->stack))->cpu_context);
+
+	/* Check whether the thread is blocked in resume() */
+	if (in_sched_functions(ctx->r15))
+		return ((unsigned long)ctx->r15);
+	else
+		return ctx->r14;
+}
+
+static void kernel_thread_helper(int (*fn)(void *), void *arg)
+{
+	fn(arg);
+	do_exit(-1);
+}
+
+int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+	struct pt_regs regs;
+	int ret;
+
+	memset(&regs, 0, sizeof(regs));
+	/* store them in non-volatile registers */
+	regs.r5 = (unsigned long)fn;
+	regs.r6 = (unsigned long)arg;
+	local_save_flags(regs.msr);
+	regs.pc = (unsigned long)kernel_thread_helper;
+	regs.kernel_mode = 1;
+
+	ret = do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
+			&regs, 0, NULL, NULL);
+
+	return ret;
+}
+
+unsigned long get_wchan(struct task_struct *p)
+{
+/* TBD (used by procfs) */
+	return 0;
+}
-- 
1.5.4.rc4.14.g6fc74

