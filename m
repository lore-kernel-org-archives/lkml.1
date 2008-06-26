Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbYFZMvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbYFZMvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758517AbYFZMhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:37:12 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:20676 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753997AbYFZMhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:37:08 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 25/60] microblaze_v4: process and init task function
Date: Thu, 26 Jun 2008 14:29:54 +0200
Message-Id: <1214483429-32360-26-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-25-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/init_task.c |   28 ++++++++
 arch/microblaze/kernel/process.c   |  127 ++++++++++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/init_task.c
 create mode 100644 arch/microblaze/kernel/process.c

diff --git a/arch/microblaze/kernel/init_task.c b/arch/microblaze/kernel/init_task.c
new file mode 100644
index 0000000..c841b55
--- /dev/null
+++ b/arch/microblaze/kernel/init_task.c
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
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
index 0000000..c8e6bef
--- /dev/null
+++ b/arch/microblaze/kernel/process.c
@@ -0,0 +1,127 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
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
+	ti->cpu_context.r1 = (unsigned long)childregs;
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
1.5.4.GIT

