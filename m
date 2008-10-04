Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbYJDVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbYJDVWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYJDVWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:22:06 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:28107 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYJDVWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:22:05 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] dumptrace: x86: consistently include loglevel, print stack switch
Date: Sat,  4 Oct 2008 23:12:43 +0200
Message-Id: <1223154766-19350-5-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223154766-19350-4-git-send-email-heukelum@fastmail.fm>
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-2-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-3-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-4-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sat, 04 Oct 2008 23:21:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.243; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - i386 and x86_64: always printk the 'data' parameter
 - i386: announce stack switch (irq -> normal)
 - i386: check if there is a stack switch before announcing it

There is a warning that 'context' might come out corrupt in early
boot. If this is true it should be fixed, not worked around.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_32.c |   17 ++++++-----------
 arch/x86/kernel/dumpstack_64.c |    9 +++++++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 09cd37c..851b692 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -104,16 +104,12 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		context = (struct thread_info *)
 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
 		bp = print_context_stack(context, stack, bp, ops, data, NULL);
-		/*
-		 * Should be after the line below, but somewhere
-		 * in early boot context comes out corrupted and we
-		 * can't reference it:
-		 */
-		if (ops->stack(data, "IRQ") < 0)
-			break;
+
 		stack = (unsigned long *)context->previous_esp;
 		if (!stack)
 			break;
+		if (ops->stack(data, "IRQ") < 0)
+			break;
 		touch_nmi_watchdog();
 	}
 }
@@ -134,6 +130,7 @@ static void print_trace_warning(void *data, char *msg)
 
 static int print_trace_stack(void *data, char *name)
 {
+	printk("%s <%s> ", (char *)data, name);
 	return 0;
 }
 
@@ -142,11 +139,9 @@ static int print_trace_stack(void *data, char *name)
  */
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
-	printk("%s [<%08lx>] ", (char *)data, addr);
-	if (!reliable)
-		printk("? ");
-	print_symbol("%s\n", addr);
 	touch_nmi_watchdog();
+	printk(data);
+	printk_address(addr, reliable);
 }
 
 static const struct stacktrace_ops print_trace_ops = {
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 9e40357..029c141 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -247,24 +247,29 @@ EXPORT_SYMBOL(dump_trace);
 static void
 print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
 {
+	printk(data);
 	print_symbol(msg, symbol);
 	printk("\n");
 }
 
 static void print_trace_warning(void *data, char *msg)
 {
-	printk("%s\n", msg);
+	printk("%s%s\n", (char *)data, msg);
 }
 
 static int print_trace_stack(void *data, char *name)
 {
-	printk(" <%s> ", name);
+	printk("%s <%s> ", (char *)data, name);
 	return 0;
 }
 
+/*
+ * Print one address/symbol entries per line.
+ */
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
 	touch_nmi_watchdog();
+	printk(data);
 	printk_address(addr, reliable);
 }
 
-- 
1.5.4.3

