Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZD0JxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZD0JxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZD0Jsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:39 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754636AbZD0Jsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:37 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 24/30] microblaze_mmu_v1: Traps MMU update
Date: Mon, 27 Apr 2009 10:32:13 +0200
Message-Id: <1240821139-7247-25-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-24-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
 <1240821139-7247-6-git-send-email-monstr@monstr.eu>
 <1240821139-7247-7-git-send-email-monstr@monstr.eu>
 <1240821139-7247-8-git-send-email-monstr@monstr.eu>
 <1240821139-7247-9-git-send-email-monstr@monstr.eu>
 <1240821139-7247-10-git-send-email-monstr@monstr.eu>
 <1240821139-7247-11-git-send-email-monstr@monstr.eu>
 <1240821139-7247-12-git-send-email-monstr@monstr.eu>
 <1240821139-7247-13-git-send-email-monstr@monstr.eu>
 <1240821139-7247-14-git-send-email-monstr@monstr.eu>
 <1240821139-7247-15-git-send-email-monstr@monstr.eu>
 <1240821139-7247-16-git-send-email-monstr@monstr.eu>
 <1240821139-7247-17-git-send-email-monstr@monstr.eu>
 <1240821139-7247-18-git-send-email-monstr@monstr.eu>
 <1240821139-7247-19-git-send-email-monstr@monstr.eu>
 <1240821139-7247-20-git-send-email-monstr@monstr.eu>
 <1240821139-7247-21-git-send-email-monstr@monstr.eu>
 <1240821139-7247-22-git-send-email-monstr@monstr.eu>
 <1240821139-7247-23-git-send-email-monstr@monstr.eu>
 <1240821139-7247-24-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/exceptions.h |   10 ++++++-
 arch/microblaze/kernel/traps.c           |   36 ++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/include/asm/exceptions.h b/arch/microblaze/include/asm/exceptions.h
index 24ca540..b55b132 100644
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
@@ -64,6 +64,12 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 void die(const char *str, struct pt_regs *fp, long err);
 void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr);
 
+#ifdef CONFIG_MMU
+void __bug(const char *file, int line, void *data);
+int bad_trap(int trap_num, struct pt_regs *regs);
+int debug_trap(struct pt_regs *regs);
+#endif /* CONFIG_MMU */
+
 #if defined(CONFIG_XMON)
 extern void xmon(struct pt_regs *regs);
 extern int xmon_bpt(struct pt_regs *regs);
diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
index 293ef48..ffe48ad 100644
--- a/arch/microblaze/kernel/traps.c
+++ b/arch/microblaze/kernel/traps.c
@@ -22,6 +22,7 @@ void trap_init(void)
 	__enable_hw_exceptions();
 }
 
+#ifndef CONFIG_MMU
 void __bad_xchg(volatile void *ptr, int size)
 {
 	printk(KERN_INFO "xchg: bad data size: pc 0x%p, ptr 0x%p, size %d\n",
@@ -29,6 +30,7 @@ void __bad_xchg(volatile void *ptr, int size)
 	BUG();
 }
 EXPORT_SYMBOL(__bad_xchg);
+#endif
 
 static int kstack_depth_to_print = 24;
 
@@ -105,3 +107,37 @@ void dump_stack(void)
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

