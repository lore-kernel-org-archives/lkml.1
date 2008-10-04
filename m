Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbYJDVWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbYJDVWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYJDVWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:22:07 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:28110 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYJDVWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:22:06 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@lusi.uni-sb.de>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] dumpstack: x86: use log_lvl and unify trace formatting
Date: Sat,  4 Oct 2008 23:12:44 +0200
Message-Id: <1223154766-19350-6-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223154766-19350-5-git-send-email-heukelum@fastmail.fm>
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-2-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-3-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-4-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-5-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sat, 04 Oct 2008 23:21:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.243; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@sleipnir.lusi.uni-sb.de>

 - x86: Write log_lvl strings if available
 - start raw stack dumps on new line
 - i386: Remove extra indentation for raw stack dumps

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_32.c |   18 +++++++++---------
 arch/x86/kernel/dumpstack_64.c |    8 ++++----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 851b692..96d78c9 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -155,8 +155,8 @@ static void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
+	printk("%sCall Trace:\n", log_lvl);
 	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-	printk("%s =======================\n", log_lvl);
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,
@@ -184,17 +184,16 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		if (kstack_end(stack))
 			break;
 		if (i && ((i % 8) == 0))
-			printk("\n%s       ", log_lvl);
-		printk("%08lx ", *stack++);
+			printk("\n%s", log_lvl);
+		printk(" %08lx", *stack++);
+		touch_nmi_watchdog();
 	}
-	printk("\n%sCall Trace:\n", log_lvl);
-
+	printk("\n");
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	printk("       ");
 	show_stack_log_lvl(task, NULL, sp, 0, "");
 }
 
@@ -229,7 +228,7 @@ void show_registers(struct pt_regs *regs)
 	print_modules();
 	__show_regs(regs, 0);
 
-	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
+	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)\n",
 		TASK_COMM_LEN, current->comm, task_pid_nr(current),
 		current_thread_info(), current, task_thread_info(current));
 	/*
@@ -242,8 +241,9 @@ void show_registers(struct pt_regs *regs)
 		unsigned char c;
 		u8 *ip;
 
-		printk("\n" KERN_EMERG "Stack: ");
-		show_stack_log_lvl(NULL, regs, &regs->sp, 0, KERN_EMERG);
+		printk(KERN_EMERG "Stack:\n");
+		show_stack_log_lvl(NULL, regs, &regs->sp,
+				0, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 029c141..6ac80f0 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -284,7 +284,7 @@ static void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
-	printk("Call Trace:\n");
+	printk("%sCall Trace:\n", log_lvl);
 	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
 }
 
@@ -330,7 +330,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 			break;
 		}
 		if (i && ((i % 4) == 0))
-			printk("\n");
+			printk("\n%s", log_lvl);
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
@@ -388,9 +388,9 @@ void show_registers(struct pt_regs *regs)
 		unsigned char c;
 		u8 *ip;
 
-		printk("Stack: ");
+		printk(KERN_EMERG "Stack:\n");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
-				regs->bp, "");
+				regs->bp, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
-- 
1.5.4.3

