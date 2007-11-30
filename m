Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbXLFMvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbXLFMvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbXLFMns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:43:48 -0500
Received: from nic2.axis.se ([193.13.178.10]:35764 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbXLFMnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:47 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <f8fad52fb87d1d89d848b7c56533a0e32fd9b596.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 16:22:50 +0100
Subject: [PATCH 29/47] Update CRISv32 traps.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove raw_prink hack, use oops_in_progress instead.
- When ETRAX_WATCHDOG_NICE_DOGGY is set, loop in trap after oops dump
  instead of rebooting.
- Break long lines to less than 80 chars.
- Fix whitespace errors.
- Remove unnecessary comments.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/kernel/traps.c |  198 ++++++++++++++++++-------------------
 1 files changed, 95 insertions(+), 103 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/traps.c b/arch/cris/arch-v10/kernel/traps.c
index 4becc1b..9eada5d 100644
--- a/arch/cris/arch-v10/kernel/traps.c
+++ b/arch/cris/arch-v10/kernel/traps.c
@@ -1,13 +1,10 @@
-/* $Id: traps.c,v 1.4 2005/04/24 18:47:55 starvik Exp $
+/*
+ * Helper functions for trap handlers
  *
- *  linux/arch/cris/arch-v10/traps.c
+ * Copyright (C) 2000-2007, Axis Communications AB.
  *
- *  Heler functions for trap handlers
- * 
- *  Copyright (C) 2000-2002 Axis Communications AB
- *
- *  Authors:   Bjorn Wesen
- *  	       Hans-Peter Nilsson
+ * Authors:   Bjorn Wesen
+ *            Hans-Peter Nilsson
  *
  */
 
@@ -15,124 +12,119 @@
 #include <asm/uaccess.h>
 #include <asm/arch/sv_addr_ag.h>
 
-extern int raw_printk(const char *fmt, ...);
-
-void 
-show_registers(struct pt_regs * regs)
+void
+show_registers(struct pt_regs *regs)
 {
-	/* We either use rdusp() - the USP register, which might not
-	   correspond to the current process for all cases we're called,
-	   or we use the current->thread.usp, which is not up to date for
-	   the current process.  Experience shows we want the USP
-	   register.  */
+	/*
+	 * It's possible to use either the USP register or current->thread.usp.
+	 * USP might not correspond to the current process for all cases this
+	 * function is called, and current->thread.usp isn't up to date for the
+	 * current process. Experience shows that using USP is the way to go.
+	 */
 	unsigned long usp = rdusp();
 
-	raw_printk("IRP: %08lx SRP: %08lx DCCR: %08lx USP: %08lx MOF: %08lx\n",
-	       regs->irp, regs->srp, regs->dccr, usp, regs->mof );
-	raw_printk(" r0: %08lx  r1: %08lx   r2: %08lx  r3: %08lx\n",
+	printk("IRP: %08lx SRP: %08lx DCCR: %08lx USP: %08lx MOF: %08lx\n",
+	       regs->irp, regs->srp, regs->dccr, usp, regs->mof);
+
+	printk(" r0: %08lx  r1: %08lx   r2: %08lx  r3: %08lx\n",
 	       regs->r0, regs->r1, regs->r2, regs->r3);
-	raw_printk(" r4: %08lx  r5: %08lx   r6: %08lx  r7: %08lx\n",
+
+	printk(" r4: %08lx  r5: %08lx   r6: %08lx  r7: %08lx\n",
 	       regs->r4, regs->r5, regs->r6, regs->r7);
-	raw_printk(" r8: %08lx  r9: %08lx  r10: %08lx r11: %08lx\n",
+
+	printk(" r8: %08lx  r9: %08lx  r10: %08lx r11: %08lx\n",
 	       regs->r8, regs->r9, regs->r10, regs->r11);
-	raw_printk("r12: %08lx r13: %08lx oR10: %08lx  sp: %08lx\n",
-	       regs->r12, regs->r13, regs->orig_r10, regs);
-	raw_printk("R_MMU_CAUSE: %08lx\n", (unsigned long)*R_MMU_CAUSE);
-	raw_printk("Process %s (pid: %d, stackpage=%08lx)\n",
+
+	printk("r12: %08lx r13: %08lx oR10: %08lx  sp: %08lx\n",
+	       regs->r12, regs->r13, regs->orig_r10, (long unsigned)regs);
+
+	printk("R_MMU_CAUSE: %08lx\n", (unsigned long)*R_MMU_CAUSE);
+
+	printk("Process %s (pid: %d, stackpage=%08lx)\n",
 	       current->comm, current->pid, (unsigned long)current);
 
 	/*
-         * When in-kernel, we also print out the stack and code at the
-         * time of the fault..
-         */
-        if (! user_mode(regs)) {
-	  	int i;
+	 * When in-kernel, we also print out the stack and code at the
+	 * time of the fault..
+	 */
+	if (!user_mode(regs)) {
+		int i;
 
-                show_stack(NULL, (unsigned long*)usp);
+		show_stack(NULL, (unsigned long *)usp);
 
-		/* Dump kernel stack if the previous dump wasn't one.  */
+		/*
+		 * If the previous stack-dump wasn't a kernel one, dump the
+		 * kernel stack now.
+		 */
 		if (usp != 0)
-			show_stack (NULL, NULL);
-
-                raw_printk("\nCode: ");
-                if(regs->irp < PAGE_OFFSET)
-                        goto bad;
-
-		/* Often enough the value at regs->irp does not point to
-		   the interesting instruction, which is most often the
-		   _previous_ instruction.  So we dump at an offset large
-		   enough that instruction decoding should be in sync at
-		   the interesting point, but small enough to fit on a row
-		   (sort of).  We point out the regs->irp location in a
-		   ksymoops-friendly way by wrapping the byte for that
-		   address in parentheses.  */
-                for(i = -12; i < 12; i++)
-                {
-                        unsigned char c;
-                        if(__get_user(c, &((unsigned char*)regs->irp)[i])) {
-bad:
-                                raw_printk(" Bad IP value.");
-                                break;
-                        }
+			show_stack(NULL, NULL);
+
+		printk("\nCode: ");
+
+		if (regs->irp < PAGE_OFFSET)
+			goto bad_value;
+
+		/*
+		 * Quite often the value at regs->irp doesn't point to the
+		 * interesting instruction, which often is the previous
+		 * instruction. So dump at an offset large enough that the
+		 * instruction decoding should be in sync at the interesting
+		 * point, but small enough to fit on a row. The regs->irp
+		 * location is pointed out in a ksymoops-friendly way by
+		 * wrapping the byte for that address in parenthesises.
+		 */
+		for (i = -12; i < 12; i++) {
+			unsigned char c;
+
+			if (__get_user(c, &((unsigned char *)regs->irp)[i])) {
+bad_value:
+				printk(" Bad IP value.");
+				break;
+			}
 
 			if (i == 0)
-			  raw_printk("(%02x) ", c);
+				printk("(%02x) ", c);
 			else
-			  raw_printk("%02x ", c);
-                }
-		raw_printk("\n");
-        }
+				printk("%02x ", c);
+		}
+		printk("\n");
+	}
 }
 
-/* Called from entry.S when the watchdog has bitten
- * We print out something resembling an oops dump, and if
- * we have the nice doggy development flag set, we halt here
- * instead of rebooting.
- */
-
-extern void reset_watchdog(void);
-extern void stop_watchdog(void);
-
-
 void
-watchdog_bite_hook(struct pt_regs *regs)
+arch_enable_nmi(void)
 {
-#ifdef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
-	local_irq_disable();
-	stop_watchdog();
-	show_registers(regs);
-	while(1) /* nothing */;
-#else
-	show_registers(regs);
-#endif	
+	asm volatile ("setf m");
 }
 
-/* This is normally the 'Oops' routine */
-void 
-die_if_kernel(const char * str, struct pt_regs * regs, long err)
+extern void (*nmi_handler)(struct pt_regs *);
+void handle_nmi(struct pt_regs *regs)
 {
-	if(user_mode(regs))
-		return;
-
-#ifdef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
-	/* This printout might take too long and trigger the 
-	 * watchdog normally. If we're in the nice doggy
-	 * development mode, stop the watchdog during printout.
-	 */
-	stop_watchdog();
-#endif
-
-	raw_printk("%s: %04lx\n", str, err & 0xffff);
-
-	show_registers(regs);
-
-#ifdef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
-	reset_watchdog();
-#endif
-	do_exit(SIGSEGV);
+	if (nmi_handler)
+		nmi_handler(regs);
+
+	/* Wait until nmi is no longer active. (We enable NMI immediately after
+	   returning from this function, and we don't want it happening while
+	   exiting from the NMI interrupt handler.) */
+	while (*R_IRQ_MASK0_RD & IO_STATE(R_IRQ_MASK0_RD, nmi_pin, active))
+		;
 }
 
-void arch_enable_nmi(void)
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+void
+handle_BUG(struct pt_regs *regs)
 {
-  asm volatile("setf m");
+	struct bug_frame f;
+	unsigned char c;
+	unsigned long irp = regs->irp;
+
+	if (__copy_from_user(&f, (const void __user *)(irp - 8), sizeof f))
+		return;
+	if (f.prefix != BUG_PREFIX || f.magic != BUG_MAGIC)
+		return;
+	if (__get_user(c, f.filename))
+		f.filename = "<bad filename>";
+
+	printk("kernel BUG at %s:%d!\n", f.filename, f.line);
 }
+#endif
-- 
1.5.3.6.970.gd25430

