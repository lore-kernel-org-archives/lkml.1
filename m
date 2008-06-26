Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbYFZMxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbYFZMxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758952AbYFZMhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:37:41 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:20892 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758922AbYFZMhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:37:36 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 29/60] microblaze_v4: traps support
Date: Thu, 26 Jun 2008 14:29:58 +0200
Message-Id: <1214483429-32360-30-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-29-git-send-email-monstr@seznam.cz>
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
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/traps.c |   86 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/traps.c

diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
new file mode 100644
index 0000000..69d75ee
--- /dev/null
+++ b/arch/microblaze/kernel/traps.c
@@ -0,0 +1,86 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kallsyms.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include <asm/exceptions.h>
+#include <asm/system.h>
+
+void trap_init(void)
+{
+	initialize_exception_handlers();
+	__enable_hw_exceptions();
+}
+
+void __bad_xchg(volatile void *ptr, int size)
+{
+	printk(KERN_INFO "xchg: bad data size: pc 0x%p, ptr 0x%p, size %d\n",
+		__builtin_return_address(0), ptr, size);
+	BUG();
+}
+EXPORT_SYMBOL(__bad_xchg);
+
+static int kstack_depth_to_print = 24;
+
+void show_trace(struct task_struct *task, unsigned long *stack)
+{
+	unsigned long addr;
+
+	if (!stack)
+		stack = (unsigned long *)&stack;
+
+	printk(KERN_INFO "Call Trace: ");
+#ifdef CONFIG_KALLSYMS
+	printk(KERN_INFO "\n");
+#endif
+	while (!kstack_end(stack)) {
+		addr = *stack++;
+		if (__kernel_text_address(addr)) {
+			printk(KERN_INFO "[<%08lx>] ", addr);
+			print_symbol("%s\n", addr);
+		}
+	}
+	printk(KERN_INFO "\n");
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	unsigned long *stack;
+	int i;
+
+	if (sp == NULL) {
+		if (task)
+			sp = (unsigned long *) ((struct thread_info *)
+						(task->stack))->cpu_context.r1;
+		else
+			sp = (unsigned long *)&sp;
+	}
+
+	stack = sp;
+
+	printk(KERN_INFO "\nStack:\n  ");
+
+	for (i = 0; i < kstack_depth_to_print; i++) {
+		if (kstack_end(sp))
+			break;
+		if (i && ((i % 8) == 0))
+			printk("\n  ");
+		printk("%08lx ", *sp++);
+	}
+	printk("\n");
+	show_trace(task, stack);
+}
+
+void dump_stack(void)
+{
+	show_stack(NULL, NULL);
+}
+EXPORT_SYMBOL(dump_stack);
-- 
1.5.4.GIT

