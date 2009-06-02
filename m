Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZFBWqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZFBWqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZFBWn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:43:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:20851 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbZFBWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TXDvaakkEaCV17ObA09MAG3tOe9I2e93r5MI7is9AG+jxXzuhbjzs/H+ghNXqRwFAR
         jLhZCR5734z5kAbwwr88u7QwkkRAbNLJbk/p3VeH+UEP9OfpU4iC/GkU4AkHXxQhJ0yr
         a/rvkT6CX91EbIT5tjmmY12eeh2LDXnzsZdCc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 12/12] hw-breakpoints: reset bits in dr6 after the corresponding exception is handled
Date: Wed,  3 Jun 2009 00:43:36 +0200
Message-Id: <1243982616-18212-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K.Prasad <prasad@linux.vnet.ibm.com>

This patch resets the bit in dr6 after the corresponding exception is
handled in code, so that we keep a clean track of the current virtual debug
status register.

[ Impact: keep track of breakpoints triggering completion ]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/hw_breakpoint.c |   13 +++++++++++--
 arch/x86/kernel/kgdb.c          |    6 ++++++
 arch/x86/kernel/kprobes.c       |    9 ++++++++-
 arch/x86/kernel/traps.c         |    4 ++--
 arch/x86/mm/kmmio.c             |    8 +++++++-
 5 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 4867c9f..6945147 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -314,8 +314,12 @@ int __kprobes hw_breakpoint_handler(struct die_args *args)
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
@@ -352,6 +356,11 @@ int __kprobes hw_breakpoint_handler(struct die_args *args)
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
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index b1f4dff..f820b73 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -43,6 +43,7 @@
 #include <linux/smp.h>
 #include <linux/nmi.h>
 
+#include <asm/debugreg.h>
 #include <asm/apicdef.h>
 #include <asm/system.h>
 
@@ -434,6 +435,11 @@ single_step_cont(struct pt_regs *regs, struct die_args *args)
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
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 7b5169d..b5b1848 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -54,6 +54,7 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
+#include <asm/debugreg.h>
 
 void jprobe_return_end(void);
 
@@ -967,8 +968,14 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
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
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index de99132..124a4d5 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -545,8 +545,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;
 
-	if (notify_die(DIE_DEBUG, "debug", regs, dr6, error_code,
-						SIGTRAP) == NOTIFY_STOP)
+	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
+							SIGTRAP) == NOTIFY_STOP)
 		return;
 
 	/* It's safe to allow irq's after DR6 has been saved */
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 16ccbd7..11a4ad4 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -540,8 +540,14 @@ kmmio_die_notifier(struct notifier_block *nb, unsigned long val, void *args)
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
-- 
1.6.2.3

