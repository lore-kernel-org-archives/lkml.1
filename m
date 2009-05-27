Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbZE0Hbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbZE0Hbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762346AbZE0H0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:51 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46928 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762351AbZE0H0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:26:50 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 19/29] microblaze_mmu_v2: Add MMU related exceptions handling
Date: Wed, 27 May 2009 08:47:44 +0200
Message-Id: <1243406874-3917-20-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-19-git-send-email-monstr@monstr.eu>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/exceptions.c |   45 ++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/arch/microblaze/kernel/exceptions.c b/arch/microblaze/kernel/exceptions.c
index 4a8a406..0cb64a3 100644
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
@@ -31,7 +31,7 @@
 #define MICROBLAZE_DBUS_EXCEPTION	0x04
 #define MICROBLAZE_DIV_ZERO_EXCEPTION	0x05
 #define MICROBLAZE_FPU_EXCEPTION	0x06
-#define MICROBLAZE_PRIVILEG_EXCEPTION	0x07
+#define MICROBLAZE_PRIVILEGED_EXCEPTION	0x07
 
 static DEFINE_SPINLOCK(die_lock);
 
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
+	case MICROBLAZE_PRIVILEGED_EXCEPTION:
+		printk(KERN_WARNING "Privileged exception\n");
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

