Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbXLFM4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbXLFM4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbXLFMof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:35 -0500
Received: from nic2.axis.se ([193.13.178.10]:45016 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbXLFMoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:34 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <bcb009a14ec15a9c03db519e5a7fb076a509f504.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Mon, 3 Dec 2007 11:12:10 +0100
Subject: [PATCH 43/47] Update and improve CRISv32 kernel/traps.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove watchdog handling, handled elsewhere.
- Shorten include paths to machine dependent header files.
- Remove raw_printk hack, we now use oops_in_progress instead.
- Add handling of BUG for exception handlers (break 14).
- Formatting and whitespace changes.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/traps.c |  192 ++++++++++++++++++++++---------------
 1 files changed, 114 insertions(+), 78 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/traps.c b/arch/cris/arch-v32/kernel/traps.c
index 17fd3db..9003e38 100644
--- a/arch/cris/arch-v32/kernel/traps.c
+++ b/arch/cris/arch-v32/kernel/traps.c
@@ -1,50 +1,45 @@
 /*
- * Copyright (C) 2003, Axis Communications AB.
+ * Copyright (C) 2003-2006, Axis Communications AB.
  */
 
 #include <linux/ptrace.h>
+#include <linux/module.h>
 #include <asm/uaccess.h>
-
-#include <asm/arch/hwregs/supp_reg.h>
-
-extern void reset_watchdog(void);
-extern void stop_watchdog(void);
-
-extern int raw_printk(const char *fmt, ...);
+#include <hwregs/supp_reg.h>
+#include <hwregs/intr_vect_defs.h>
+#include <asm/irq.h>
 
 void
 show_registers(struct pt_regs *regs)
 {
 	/*
 	 * It's possible to use either the USP register or current->thread.usp.
-	 * USP might not correspond to the current proccess for all cases this
+	 * USP might not correspond to the current process for all cases this
 	 * function is called, and current->thread.usp isn't up to date for the
-	 * current proccess. Experience shows that using USP is the way to go.
+	 * current process. Experience shows that using USP is the way to go.
 	 */
-	unsigned long usp;
+	unsigned long usp = rdusp();
 	unsigned long d_mmu_cause;
 	unsigned long i_mmu_cause;
 
-	usp = rdusp();
+	printk("CPU: %d\n", smp_processor_id());
 
-	raw_printk("CPU: %d\n", smp_processor_id());
+	printk("ERP: %08lx SRP: %08lx  CCS: %08lx USP: %08lx MOF: %08lx\n",
+	       regs->erp, regs->srp, regs->ccs, usp, regs->mof);
 
-	raw_printk("ERP: %08lx SRP: %08lx  CCS: %08lx USP: %08lx MOF: %08lx\n",
-		regs->erp, regs->srp, regs->ccs, usp, regs->mof);
+	printk(" r0: %08lx  r1: %08lx   r2: %08lx  r3: %08lx\n",
+	       regs->r0, regs->r1, regs->r2, regs->r3);
 
-	raw_printk(" r0: %08lx  r1: %08lx   r2: %08lx  r3: %08lx\n",
-		regs->r0, regs->r1, regs->r2, regs->r3);
+	printk(" r4: %08lx  r5: %08lx   r6: %08lx  r7: %08lx\n",
+	       regs->r4, regs->r5, regs->r6, regs->r7);
 
-	raw_printk(" r4: %08lx  r5: %08lx   r6: %08lx  r7: %08lx\n",
-		regs->r4, regs->r5, regs->r6, regs->r7);
+	printk(" r8: %08lx  r9: %08lx  r10: %08lx r11: %08lx\n",
+	       regs->r8, regs->r9, regs->r10, regs->r11);
 
-	raw_printk(" r8: %08lx  r9: %08lx  r10: %08lx r11: %08lx\n",
-		regs->r8, regs->r9, regs->r10, regs->r11);
+	printk("r12: %08lx r13: %08lx oR10: %08lx acr: %08lx\n",
+	       regs->r12, regs->r13, regs->orig_r10, regs->acr);
 
-	raw_printk("r12: %08lx r13: %08lx oR10: %08lx acr: %08lx\n",
-		regs->r12, regs->r13, regs->orig_r10, regs->acr);
-
-	raw_printk("sp: %08lx\n", regs);
+	printk(" sp: %08lx\n", (unsigned long)regs);
 
 	SUPP_BANK_SEL(BANK_IM);
 	SUPP_REG_RD(RW_MM_CAUSE, i_mmu_cause);
@@ -52,18 +47,20 @@ show_registers(struct pt_regs *regs)
 	SUPP_BANK_SEL(BANK_DM);
 	SUPP_REG_RD(RW_MM_CAUSE, d_mmu_cause);
 
-	raw_printk("       Data MMU Cause: %08lx\n", d_mmu_cause);
-	raw_printk("Instruction MMU Cause: %08lx\n", i_mmu_cause);
+	printk("       Data MMU Cause: %08lx\n", d_mmu_cause);
+	printk("Instruction MMU Cause: %08lx\n", i_mmu_cause);
 
-	raw_printk("Process %s (pid: %d, stackpage: %08lx)\n",
-		current->comm, current->pid, (unsigned long) current);
+	printk("Process %s (pid: %d, stackpage=%08lx)\n",
+	       current->comm, current->pid, (unsigned long)current);
 
-	/* Show additional info if in kernel-mode. */
+	/*
+	 * When in-kernel, we also print out the stack and code at the
+	 * time of the fault..
+	 */
 	if (!user_mode(regs)) {
 		int i;
-		unsigned char c;
 
-		show_stack(NULL, (unsigned long *) usp);
+		show_stack(NULL, (unsigned long *)usp);
 
 		/*
 		 * If the previous stack-dump wasn't a kernel one, dump the
@@ -72,7 +69,7 @@ show_registers(struct pt_regs *regs)
 		if (usp != 0)
 			show_stack(NULL, NULL);
 
-		raw_printk("\nCode: ");
+		printk("\nCode: ");
 
 		if (regs->erp < PAGE_OFFSET)
 			goto bad_value;
@@ -84,76 +81,115 @@ show_registers(struct pt_regs *regs)
 		 * instruction decoding should be in sync at the interesting
 		 * point, but small enough to fit on a row. The regs->erp
 		 * location is pointed out in a ksymoops-friendly way by
-		 * wrapping the byte for that address in parenthesis.
+		 * wrapping the byte for that address in parenthesises.
 		 */
 		for (i = -12; i < 12; i++) {
-			if (__get_user(c, &((unsigned char *) regs->erp)[i])) {
+			unsigned char c;
+
+			if (__get_user(c, &((unsigned char *)regs->erp)[i])) {
 bad_value:
-				raw_printk(" Bad IP value.");
+				printk(" Bad IP value.");
 				break;
 			}
 
 			if (i == 0)
-				raw_printk("(%02x) ", c);
+				printk("(%02x) ", c);
 			else
-				raw_printk("%02x ", c);
+				printk("%02x ", c);
 		}
-
-		raw_printk("\n");
+		printk("\n");
 	}
 }
 
-/*
- * This gets called from entry.S when the watchdog has bitten. Show something
- * similar to an Oops dump, and if the kernel is configured to be a nice doggy;
- * halt instead of reboot.
- */
 void
-watchdog_bite_hook(struct pt_regs *regs)
+arch_enable_nmi(void)
 {
-#ifdef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
-	local_irq_disable();
-	stop_watchdog();
-	show_registers(regs);
+	unsigned long flags;
 
-	while (1)
-		; /* Do nothing. */
-#else
-	show_registers(regs);
-#endif
+	local_save_flags(flags);
+	flags |= (1 << 30); /* NMI M flag is at bit 30 */
+	local_irq_restore(flags);
 }
 
-/* This is normally the Oops function. */
-void
-die_if_kernel(const char *str, struct pt_regs *regs, long err)
+extern void (*nmi_handler)(struct pt_regs *);
+void handle_nmi(struct pt_regs *regs)
 {
-	if (user_mode(regs))
-		return;
+#ifdef CONFIG_ETRAXFS
+	reg_intr_vect_r_nmi r;
+#endif
 
-#ifdef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
-	/*
-	 * This printout might take too long and could trigger
-	 * the watchdog normally. If NICE_DOGGY is set, simply
-	 * stop the watchdog during the printout.
-	 */
-	stop_watchdog();
+	if (nmi_handler)
+		nmi_handler(regs);
+
+#ifdef CONFIG_ETRAXFS
+	/* Wait until nmi is no longer active. */
+	do {
+		r = REG_RD(intr_vect, regi_irq, r_nmi);
+	} while (r.ext == regk_intr_vect_on);
 #endif
+}
 
-	raw_printk("%s: %04lx\n", str, err & 0xffff);
 
-	show_registers(regs);
+#ifdef CONFIG_BUG
+extern void die_if_kernel(const char *str, struct pt_regs *regs, long err);
 
-#ifdef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
-	reset_watchdog();
-#endif
+/* Copy of the regs at BUG() time.  */
+struct pt_regs BUG_regs;
 
-	do_exit(SIGSEGV);
+void do_BUG(char *file, unsigned int line)
+{
+	printk("kernel BUG at %s:%d!\n", file, line);
+	die_if_kernel("Oops", &BUG_regs, 0);
 }
+EXPORT_SYMBOL(do_BUG);
 
-void arch_enable_nmi(void)
+void fixup_BUG(struct pt_regs *regs)
 {
-	unsigned long flags;
-	local_save_flags(flags);
-	flags |= (1<<30); /* NMI M flag is at bit 30 */
-	local_irq_restore(flags);
+	BUG_regs = *regs;
+
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+	/*
+	 * Fixup the BUG arguments through exception handlers.
+	 */
+	{
+		const struct exception_table_entry *fixup;
+
+		/*
+		 * ERP points at the "break 14" + 2, compensate for the 2
+		 * bytes.
+		 */
+		fixup = search_exception_tables(instruction_pointer(regs) - 2);
+		if (fixup) {
+			/* Adjust the instruction pointer in the stackframe. */
+			instruction_pointer(regs) = fixup->fixup;
+			arch_fixup(regs);
+		}
+	}
+#else
+	/* Dont try to lookup the filename + line, just dump regs.  */
+	do_BUG("unknown", 0);
+#endif
 }
+
+/*
+ * Break 14 handler. Save regs and jump into the fixup_BUG.
+ */
+__asm__  ( ".text\n\t"
+	   ".global breakh_BUG\n\t"
+	   "breakh_BUG:\n\t"
+	   SAVE_ALL
+	   KGDB_FIXUP
+	   "move.d $sp, $r10\n\t"
+	   "jsr fixup_BUG\n\t"
+	   "nop\n\t"
+	   "jump ret_from_intr\n\t"
+	   "nop\n\t");
+
+
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+void
+handle_BUG(struct pt_regs *regs)
+{
+}
+#endif
+#endif
-- 
1.5.3.6.970.gd25430

