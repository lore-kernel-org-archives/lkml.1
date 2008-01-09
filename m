Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYAIAsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYAIAsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYAIAsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:48:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:57222 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbYAIAsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:48:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ekKgF8p3HRgiyz2I2S6yzJKjuyDh6tUIMn2GP0M9WV2ya3THePESoGslH5dCyoz2UnYC3zJWNpQ6fGd+XJBXXJbOuiyz/en4ea9jIFQJXWNG4Ivy24Woy6uyr8T8yTuMMzN5GkvcJf7sCzBs7XrjnZuJ1ZW8W+VRCJiFx1t3fGg=
Subject: [PATCH] x86: Introduce __die helper to X86_32
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 16:48:08 -0800
Message-Id: <1199839688.6424.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small step towards unifying traps_32|64.c.  No functional
changes.  Pull out a small helper from an if() statement
in die().

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, I know this will have checkpatch problems, doing code
movement first, will do the cleanup as a final step once
we get to the end of unifying the files.

 arch/x86/kernel/traps_32.c |   76 ++++++++++++++++++++++++-------------------
 1 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index ac8fd36..edd0750 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -352,6 +352,45 @@ int is_valid_bugaddr(unsigned long ip)
 	return ud2 == 0x0b0f;
 }
 
+static int die_counter;
+
+static int __die(const char * str, struct pt_regs * regs, long err)
+{
+	unsigned long sp;
+	unsigned short ss;
+
+	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
+#ifdef CONFIG_PREEMPT
+	printk("PREEMPT ");
+#endif
+#ifdef CONFIG_SMP
+	printk("SMP ");
+#endif
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	printk("DEBUG_PAGEALLOC");
+#endif
+	printk("\n");
+
+	if (notify_die(DIE_OOPS, str, regs, err,
+				current->thread.trap_no, SIGSEGV) !=
+			NOTIFY_STOP) {
+		show_registers(regs);
+		/* Executive summary in case the oops scrolled away */
+		sp = (unsigned long) (&regs->sp);
+		savesegment(ss, ss);
+		if (user_mode(regs)) {
+			sp = regs->sp;
+			ss = regs->ss & 0xffff;
+		}
+		printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
+		print_symbol("%s", regs->ip);
+		printk(" SS:ESP %04x:%08lx\n", ss, sp);
+		return 0;
+	} else {
+		return 1;
+	}
+}
+
 /*
  * This is gone through when something in the kernel has done something bad and
  * is about to be terminated.
@@ -367,7 +406,6 @@ void die(const char * str, struct pt_regs * regs, long err)
 		.lock_owner =		-1,
 		.lock_owner_depth =	0
 	};
-	static int die_counter;
 	unsigned long flags;
 
 	oops_enter();
@@ -383,43 +421,13 @@ void die(const char * str, struct pt_regs * regs, long err)
 		raw_local_irq_save(flags);
 
 	if (++die.lock_owner_depth < 3) {
-		unsigned long sp;
-		unsigned short ss;
-
 		report_bug(regs->ip, regs);
 
-		printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff,
-		       ++die_counter);
-#ifdef CONFIG_PREEMPT
-		printk("PREEMPT ");
-#endif
-#ifdef CONFIG_SMP
-		printk("SMP ");
-#endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-		printk("DEBUG_PAGEALLOC");
-#endif
-		printk("\n");
-
-		if (notify_die(DIE_OOPS, str, regs, err,
-					current->thread.trap_no, SIGSEGV) !=
-				NOTIFY_STOP) {
-			show_registers(regs);
-			/* Executive summary in case the oops scrolled away */
-			sp = (unsigned long) (&regs->sp);
-			savesegment(ss, ss);
-			if (user_mode(regs)) {
-				sp = regs->sp;
-				ss = regs->ss & 0xffff;
-			}
-			printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
-			print_symbol("%s", regs->ip);
-			printk(" SS:ESP %04x:%08lx\n", ss, sp);
-		}
-		else
+		if (__die(str, regs, err))
 			regs = NULL;
-  	} else
+	} else {
 		printk(KERN_EMERG "Recursive die() failure, output suppressed\n");
+	}
 
 	bust_spinlocks(0);
 	die.lock_owner = -1;
-- 
1.5.4.rc2.1164.g6451


