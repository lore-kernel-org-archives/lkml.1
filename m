Return-Path: <linux-kernel-owner+w=401wt.eu-S1762956AbZE0HbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762956AbZE0HbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762278AbZE0H0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:39 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46922 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762293AbZE0H0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:26:37 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 22/29] microblaze_mmu_v2: Traps MMU update
Date: Wed, 27 May 2009 08:47:47 +0200
Message-Id: <1243406874-3917-23-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-22-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
 <1243406874-3917-13-git-send-email-monstr@monstr.eu>
 <1243406874-3917-14-git-send-email-monstr@monstr.eu>
 <1243406874-3917-15-git-send-email-monstr@monstr.eu>
 <1243406874-3917-16-git-send-email-monstr@monstr.eu>
 <1243406874-3917-17-git-send-email-monstr@monstr.eu>
 <1243406874-3917-18-git-send-email-monstr@monstr.eu>
 <1243406874-3917-19-git-send-email-monstr@monstr.eu>
 <1243406874-3917-20-git-send-email-monstr@monstr.eu>
 <1243406874-3917-21-git-send-email-monstr@monstr.eu>
 <1243406874-3917-22-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/exceptions.h |   24 +++++++--------------
 arch/microblaze/kernel/traps.c           |   34 ++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/arch/microblaze/include/asm/exceptions.h b/arch/microblaze/include/asm/exceptions.h
index 24ca540..90731df 100644
--- a/arch/microblaze/include/asm/exceptions.h
+++ b/arch/microblaze/include/asm/exceptions.h
@@ -1,8 +1,8 @@
 /*
  * Preliminary support for HW exception handing for Microblaze
  *
- * Copyright (C) 2008 Michal Simek
- * Copyright (C) 2008 PetaLogix
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2005 John Williams <jwilliams@itee.uq.edu.au>
  *
  * This file is subject to the terms and conditions of the GNU General
@@ -64,21 +64,13 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 void die(const char *str, struct pt_regs *fp, long err);
 void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr);
 
-#if defined(CONFIG_XMON)
-extern void xmon(struct pt_regs *regs);
-extern int xmon_bpt(struct pt_regs *regs);
-extern int xmon_sstep(struct pt_regs *regs);
-extern int xmon_iabr_match(struct pt_regs *regs);
-extern int xmon_dabr_match(struct pt_regs *regs);
-extern void (*xmon_fault_handler)(struct pt_regs *regs);
+#ifdef CONFIG_MMU
+void __bug(const char *file, int line, void *data);
+int bad_trap(int trap_num, struct pt_regs *regs);
+int debug_trap(struct pt_regs *regs);
+#endif /* CONFIG_MMU */
 
-void (*debugger)(struct pt_regs *regs) = xmon;
-int (*debugger_bpt)(struct pt_regs *regs) = xmon_bpt;
-int (*debugger_sstep)(struct pt_regs *regs) = xmon_sstep;
-int (*debugger_iabr_match)(struct pt_regs *regs) = xmon_iabr_match;
-int (*debugger_dabr_match)(struct pt_regs *regs) = xmon_dabr_match;
-void (*debugger_fault_handler)(struct pt_regs *regs);
-#elif defined(CONFIG_KGDB)
+#if defined(CONFIG_KGDB)
 void (*debugger)(struct pt_regs *regs);
 int (*debugger_bpt)(struct pt_regs *regs);
 int (*debugger_sstep)(struct pt_regs *regs);
diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
index 6322cc1..eaaaf80 100644
--- a/arch/microblaze/kernel/traps.c
+++ b/arch/microblaze/kernel/traps.c
@@ -97,3 +97,37 @@ void dump_stack(void)
 	show_stack(NULL, NULL);
 }
 EXPORT_SYMBOL(dump_stack);
+
+#ifdef CONFIG_MMU
+void __bug(const char *file, int line, void *data)
+{
+	if (data)
+		printk(KERN_CRIT "kernel BUG at %s:%d (data = %p)!\n",
+			file, line, data);
+	else
+		printk(KERN_CRIT "kernel BUG at %s:%d!\n", file, line);
+
+	machine_halt();
+}
+
+int bad_trap(int trap_num, struct pt_regs *regs)
+{
+	printk(KERN_CRIT
+		"unimplemented trap %d called at 0x%08lx, pid %d!\n",
+		trap_num, regs->pc, current->pid);
+	return -ENOSYS;
+}
+
+int debug_trap(struct pt_regs *regs)
+{
+	int i;
+	printk(KERN_CRIT "debug trap\n");
+	for (i = 0; i < 32; i++) {
+		/* printk("r%i:%08X\t",i,regs->gpr[i]); */
+		if ((i % 4) == 3)
+			printk(KERN_CRIT "\n");
+	}
+	printk(KERN_CRIT "pc:%08lX\tmsr:%08lX\n", regs->pc, regs->msr);
+	return -ENOSYS;
+}
+#endif
-- 
1.5.5.1

