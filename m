Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZD0Jx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZD0Jx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZD0Jsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:42 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754553AbZD0Jsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:41 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 21/30] microblaze_mmu_v1: Add MMU related exceptions handling
Date: Mon, 27 Apr 2009 10:32:10 +0200
Message-Id: <1240821139-7247-22-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-21-git-send-email-monstr@monstr.eu>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/exceptions.c |   43 +++++++++++++++++++++++++++++-----
 1 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/microblaze/kernel/exceptions.c b/arch/microblaze/kernel/exceptions.c
index 4a8a406..38be9fa 100644
--- a/arch/microblaze/kernel/exceptions.c
+++ b/arch/microblaze/kernel/exceptions.c
@@ -21,9 +21,9 @@
 
 #include <asm/exceptions.h>
 #include <asm/entry.h>		/* For KM CPU var */
-#include <asm/uaccess.h>
-#include <asm/errno.h>
-#include <asm/ptrace.h>
+#include <linux/uaccess.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
 #include <asm/current.h>
 
 #define MICROBLAZE_ILL_OPCODE_EXCEPTION	0x02
@@ -66,6 +66,11 @@ void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr)
 asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 							int fsr, int addr)
 {
+#ifdef CONFIG_MMU
+	int code;
+	addr = regs->pc;
+#endif
+
 #if 0
 	printk(KERN_WARNING "Exception %02x in %s mode, FSR=%08x PC=%08x ESR=%08x\n",
 			type, user_mode(regs) ? "user" : "kernel", fsr,
@@ -74,7 +79,13 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 
 	switch (type & 0x1F) {
 	case MICROBLAZE_ILL_OPCODE_EXCEPTION:
-		_exception(SIGILL, regs, ILL_ILLOPC, addr);
+		if (user_mode(regs)) {
+			printk(KERN_WARNING "Illegal opcode exception in user mode.\n");
+			_exception(SIGILL, regs, ILL_ILLOPC, addr);
+			return;
+		}
+		printk(KERN_WARNING "Illegal opcode exception in kernel mode.\n");
+		die("opcode exception", regs, SIGBUS);
 		break;
 	case MICROBLAZE_IBUS_EXCEPTION:
 		if (user_mode(regs)) {
@@ -95,11 +106,16 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 		die("bus exception", regs, SIGBUS);
 		break;
 	case MICROBLAZE_DIV_ZERO_EXCEPTION:
-		printk(KERN_WARNING "Divide by zero exception\n");
-		_exception(SIGILL, regs, ILL_ILLOPC, addr);
+		if (user_mode(regs)) {
+			printk(KERN_WARNING "Divide by zero exception in user mode\n");
+			_exception(SIGILL, regs, ILL_ILLOPC, addr);
+			return;
+		}
+		printk(KERN_WARNING "Divide by zero exception in kernel mode.\n");
+		die("Divide by exception", regs, SIGBUS);
 		break;
-
 	case MICROBLAZE_FPU_EXCEPTION:
+		printk(KERN_WARNING "FPU exception\n");
 		/* IEEE FP exception */
 		/* I removed fsr variable and use code var for storing fsr */
 		if (fsr & FSR_IO)
@@ -115,7 +131,20 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 		_exception(SIGFPE, regs, fsr, addr);
 		break;
 
+#ifdef CONFIG_MMU
+	case MICROBLAZE_PRIVILEG_EXCEPTION:
+		printk(KERN_WARNING "Privileg exception\n");
+		/* "brk r0,r0" - used as debug breakpoint */
+		if (get_user(code, (unsigned long *)regs->pc) == 0
+			&& code == 0x980c0000) {
+			_exception(SIGTRAP, regs, TRAP_BRKPT, addr);
+		} else {
+			_exception(SIGILL, regs, ILL_PRVOPC, addr);
+		}
+		break;
+#endif
 	default:
+	/* FIXME what to do in unexpected exception */
 		printk(KERN_WARNING "Unexpected exception %02x "
 			"PC=%08x in %s mode\n", type, (unsigned int) addr,
 			kernel_mode(regs) ? "kernel" : "user");
-- 
1.5.5.1

