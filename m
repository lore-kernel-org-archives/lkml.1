Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYGAXcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYGAXcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757599AbYGAXcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:32:19 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:18265 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbYGAXcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:32:18 -0400
Date: Wed, 2 Jul 2008 01:31:03 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] x86: traps_xx: modify __die
Message-ID: <20080701233103.GC29903@mailshack.com>
References: <20080701193643.GA29695@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701193643.GA29695@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Wed, 02 Jul 2008 01:32:01 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.59; VDF: 7.0.5.30; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if (cond) block -> if (!cond) goto end_of_block

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   32 ++++++++++++++------------------
 arch/x86/kernel/traps_64.c |    4 ++--
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 7e88fa3..9ed060e 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -400,26 +400,22 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
-
 	if (notify_die(DIE_OOPS, str, regs, err,
-			current->thread.trap_no, SIGSEGV) != NOTIFY_STOP) {
-
-		show_registers(regs);
-		/* Executive summary in case the oops scrolled away */
-		sp = (unsigned long) (&regs->sp);
-		savesegment(ss, ss);
-		if (user_mode(regs)) {
-			sp = regs->sp;
-			ss = regs->ss & 0xffff;
-		}
-		printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
-		print_symbol("%s", regs->ip);
-		printk(" SS:ESP %04x:%08lx\n", ss, sp);
+			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+		return 1;
 
-		return 0;
+	show_registers(regs);
+	/* Executive summary in case the oops scrolled away */
+	sp = (unsigned long) (&regs->sp);
+	savesegment(ss, ss);
+	if (user_mode(regs)) {
+		sp = regs->sp;
+		ss = regs->ss & 0xffff;
 	}
-
-	return 1;
+	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
+	print_symbol("%s", regs->ip);
+	printk(" SS:ESP %04x:%08lx\n", ss, sp);
+	return 0;
 }
 
 /*
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 934bd0f..1ae0d4d 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -562,9 +562,9 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	do_exit(signr);
 }
 
-int __kprobes __die(const char * str, struct pt_regs * regs, long err)
+int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 {
-	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff,++die_counter);
+	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff, ++die_counter);
 #ifdef CONFIG_PREEMPT
 	printk("PREEMPT ");
 #endif
-- 
1.5.4.3

