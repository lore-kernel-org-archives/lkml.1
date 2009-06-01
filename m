Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZFASR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZFASR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZFASRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:17:11 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:41315 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbZFASRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:17:09 -0400
Date: Mon, 1 Jun 2009 23:47:06 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 12/12] Reset bits in dr6 after the corresponding exception
	is handled
Message-ID: <20090601181706.GM23582@in.ibm.com>
References: <20090601180605.799735829@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=dr6_changes_12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch resets the bit in dr6 after the corresponding exception is
handled in code.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/hw_breakpoint.c |   13 +++++++++++--
 arch/x86/kernel/kgdb.c          |    6 ++++++
 arch/x86/kernel/kprobes.c       |    9 ++++++++-
 arch/x86/kernel/traps.c         |    4 ++--
 arch/x86/mm/kmmio.c             |    8 +++++++-
 5 files changed, 34 insertions(+), 6 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
@@ -314,8 +314,12 @@ int __kprobes hw_breakpoint_handler(stru
 {
 	int i, cpu, rc = NOTIFY_STOP;
 	struct hw_breakpoint *bp;
-	/* The DR6 value is stored in args->err */
-	unsigned long dr7, dr6 = args->err;
+	unsigned long dr7, dr6;
+	unsigned long *dr6_p;
+
+	/* The DR6 value is pointed by args->err */
+	dr6_p = (unsigned long *)ERR_PTR(args->err);
+	dr6 = *dr6_p;
 
 	/* Do an early return if no trap bits are set in DR6 */
 	if ((dr6 & DR_TRAP_BITS) == 0)
@@ -352,6 +356,11 @@ int __kprobes hw_breakpoint_handler(stru
 				rc = NOTIFY_DONE;
 		}
 		/*
+		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
+		 * exception handling
+		 */
+		(*dr6_p) &= ~(DR_TRAP0 << i);
+		/*
 		 * bp can be NULL due to lazy debug register switching
 		 * or due to the delay between updates of hbp_kernel_pos
 		 * and this_hbp_kernel.
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/kgdb.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/kgdb.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/kgdb.c
@@ -43,6 +43,7 @@
 #include <linux/smp.h>
 #include <linux/nmi.h>
 
+#include <asm/debugreg.h>
 #include <asm/apicdef.h>
 #include <asm/system.h>
 
@@ -434,6 +435,11 @@ single_step_cont(struct pt_regs *regs, s
 			"resuming...\n");
 	kgdb_arch_handle_exception(args->trapnr, args->signr,
 				   args->err, "c", "", regs);
+	/*
+	 * Reset the BS bit in dr6 (pointed by args->err) to
+	 * denote completion of processing
+	 */
+	(*(unsigned long *)ERR_PTR(args->err)) &= ~DR_STEP;
 
 	return NOTIFY_STOP;
 }
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/kprobes.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/kprobes.c
@@ -54,6 +54,7 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
+#include <asm/debugreg.h>
 
 void jprobe_return_end(void);
 
@@ -967,8 +968,14 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
+		if (post_kprobe_handler(args->regs)) {
+			/*
+			 * Reset the BS bit in dr6 (pointed by args->err) to
+			 * denote completion of processing
+			 */
+			(*(unsigned long *)ERR_PTR(args->err)) &= ~DR_STEP;
 			ret = NOTIFY_STOP;
+		}
 		break;
 	case DIE_GPF:
 		/*
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/traps.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/traps.c
@@ -550,8 +550,8 @@ dotraplinkage void __kprobes do_debug(st
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;
 
-	if (notify_die(DIE_DEBUG, "debug", regs, dr6, error_code,
-						SIGTRAP) == NOTIFY_STOP)
+	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
+							SIGTRAP) == NOTIFY_STOP)
 		return;
 
 	/* It's safe to allow irq's after DR6 has been saved */
Index: linux-2.6-tip.hbkpt/arch/x86/mm/kmmio.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/mm/kmmio.c
+++ linux-2.6-tip.hbkpt/arch/x86/mm/kmmio.c
@@ -540,8 +540,14 @@ kmmio_die_notifier(struct notifier_block
 	struct die_args *arg = args;
 
 	if (val == DIE_DEBUG && (arg->err & DR_STEP))
-		if (post_kmmio_handler(arg->err, arg->regs) == 1)
+		if (post_kmmio_handler(arg->err, arg->regs) == 1) {
+			/*
+			 * Reset the BS bit in dr6 (pointed by args->err) to
+			 * denote completion of processing
+			 */
+			(*(unsigned long *)ERR_PTR(arg->err)) &= ~DR_STEP;
 			return NOTIFY_STOP;
+		}
 
 	return NOTIFY_DONE;
 }

