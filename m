Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYGJTSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYGJTSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYGJTSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:18:04 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:8677 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYGJTSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:18:03 -0400
Date: Thu, 10 Jul 2008 21:16:39 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86: traps_xx: modify x86_64 to use _log_lvl variants
Message-ID: <20080710191638.GB19475@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Thu, 10 Jul 2008 21:17:16 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.64; VDF: 7.0.5.95; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386 has show_trace_log_lvl and show_stack_log_lvl, allowing
traces to be emitted with log-level annotations. This patch
introduces them to x86_64, but log_lvl is only ever set to
an empty string. Output of traces is unchanged.

i386-chunk is whitespace-only.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |    2 +-
 arch/x86/kernel/traps_64.c |   24 ++++++++++++++++--------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 51cccde..c971dce 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -256,7 +256,7 @@ static const struct stacktrace_ops print_trace_ops = {
 
 static void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *stack, unsigned long bp, char *log_lvl)
+		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
 	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
 	printk("%s =======================\n", log_lvl);
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 58b1619..a998cef 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -378,17 +378,24 @@ static const struct stacktrace_ops print_trace_ops = {
 	.address = print_trace_address,
 };
 
-void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp)
+static void
+show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
 	printk("\nCall Trace:\n");
-	dump_trace(task, regs, stack, bp, &print_trace_ops, NULL);
+	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
 	printk("\n");
 }
 
+void show_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp)
+{
+	show_trace_log_lvl(task, regs, stack, bp, "");
+}
+
 static void
-_show_stack(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp)
+show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *sp, unsigned long bp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -422,12 +429,12 @@ _show_stack(struct task_struct *task, struct pt_regs *regs,
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
-	show_trace(task, regs, sp, bp);
+	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	_show_stack(task, NULL, sp, 0);
+	show_stack_log_lvl(task, NULL, sp, 0, "");
 }
 
 /*
@@ -477,7 +484,8 @@ void show_registers(struct pt_regs *regs)
 		u8 *ip;
 
 		printk("Stack: ");
-		_show_stack(NULL, regs, (unsigned long *)sp, regs->bp);
+		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
+				regs->bp, "");
 		printk("\n");
 
 		printk(KERN_EMERG "Code: ");
-- 
1.5.4.3

