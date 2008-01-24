Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYAZPxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYAZPxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYAZPxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:53:45 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752224AbYAZPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:53:44 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 27/52] [microblaze] traps support
Date: Thu, 24 Jan 2008 16:03:02 +0100
Message-Id: <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
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
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/traps.c |   88 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/traps.c

diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
new file mode 100644
index 0000000..eb8202b
--- /dev/null
+++ b/arch/microblaze/kernel/traps.c
@@ -0,0 +1,88 @@
+/*
+ * arch/microblaze/kernel/traps.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
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
+						(task->stack))->cpu_context.sp;
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
1.5.4.rc4.14.g6fc74

