Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbYH2JQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbYH2JQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYH2JQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:16:46 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:63785 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbYH2JQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:16:45 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
       linux-kernel@vger.kernel.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] avr32: Fix lockup after Java stack underflow in user mode
Date: Fri, 29 Aug 2008 11:16:23 +0200
Message-Id: <1220001383-5690-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 29 Aug 2008 09:16:19.0904 (UTC) FILETIME=[E5FDA400:01C909B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the Java Extension Module hardware, a Java stack underflow or
overflow trap may cause the system to enter an infinite exception loop.
Although there's no kernel support for the Java hardware yet, we need to
be able to recover from this situation and keep the system running.

This patch adds code to detect and fixup this situation in the critical
exception handler and terminate the faulting process. We may have to
rethink how to handle this more gracefully when the necessary kernel
support for hardware-accelerated Java is added.

Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
This should be applied before 2.6.27 as well as any open stable
branches.

 arch/avr32/kernel/asm-offsets.c  |    6 ++++
 arch/avr32/kernel/entry-avr32b.S |   59 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/kernel/asm-offsets.c b/arch/avr32/kernel/asm-offsets.c
index e4796c6..d6a8193 100644
--- a/arch/avr32/kernel/asm-offsets.c
+++ b/arch/avr32/kernel/asm-offsets.c
@@ -4,6 +4,8 @@
  * to extract and format the required data.
  */
 
+#include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/thread_info.h>
 #include <linux/kbuild.h>
 
@@ -17,4 +19,8 @@ void foo(void)
 	OFFSET(TI_rar_saved, thread_info, rar_saved);
 	OFFSET(TI_rsr_saved, thread_info, rsr_saved);
 	OFFSET(TI_restart_block, thread_info, restart_block);
+	BLANK();
+	OFFSET(TSK_active_mm, task_struct, active_mm);
+	BLANK();
+	OFFSET(MM_pgd, mm_struct, pgd);
 }
diff --git a/arch/avr32/kernel/entry-avr32b.S b/arch/avr32/kernel/entry-avr32b.S
index 2b398ca..33d4937 100644
--- a/arch/avr32/kernel/entry-avr32b.S
+++ b/arch/avr32/kernel/entry-avr32b.S
@@ -334,9 +334,64 @@ save_full_context_ex:
 
 	/* Low-level exception handlers */
 handle_critical:
+	/*
+	 * AT32AP700x errata:
+	 *
+	 * After a Java stack overflow or underflow trap, any CPU
+	 * memory access may cause erratic behavior. This will happen
+	 * when the four least significant bits of the JOSP system
+	 * register contains any value between 9 and 15 (inclusive).
+	 *
+	 * Possible workarounds:
+	 *   - Don't use the Java Extension Module
+	 *   - Ensure that the stack overflow and underflow trap
+	 *     handlers do not do any memory access or trigger any
+	 *     exceptions before the overflow/underflow condition is
+	 *     cleared (by incrementing or decrementing the JOSP)
+	 *   - Make sure that JOSP does not contain any problematic
+	 *     value before doing any exception or interrupt
+	 *     processing.
+	 *   - Set up a critical exception handler which writes a
+	 *     known-to-be-safe value, e.g. 4, to JOSP before doing
+	 *     any further processing.
+	 *
+	 * We'll use the last workaround for now since we cannot
+	 * guarantee that user space processes don't use Java mode.
+	 * Non-well-behaving userland will be terminated with extreme
+	 * prejudice.
+	 */
+#ifdef CONFIG_CPU_AT32AP700X
+	/*
+	 * There's a chance we can't touch memory, so temporarily
+	 * borrow PTBR to save the stack pointer while we fix things
+	 * up...
+	 */
+	mtsr	SYSREG_PTBR, sp
+	mov	sp, 4
+	mtsr	SYSREG_JOSP, sp
+	mfsr	sp, SYSREG_PTBR
+	sub	pc, -2
+
+	/* Push most of pt_regs on stack. We'll do the rest later */
 	sub	sp, 4
-	stmts	--sp, r0-lr
-	rcall	save_full_context_ex
+	pushm	r0-r12
+
+	/* PTBR mirrors current_thread_info()->task->active_mm->pgd */
+	get_thread_info r0
+	ld.w	r1, r0[TI_task]
+	ld.w	r2, r1[TSK_active_mm]
+	ld.w	r3, r2[MM_pgd]
+	mtsr	SYSREG_PTBR, r3
+#else
+	sub	sp, 4
+	pushm	r0-r12
+#endif
+	sub	r0, sp, -(14 * 4)
+	mov	r1, lr
+	mfsr	r2, SYSREG_RAR_EX
+	mfsr	r3, SYSREG_RSR_EX
+	pushm	r0-r3
+
 	mfsr	r12, SYSREG_ECR
 	mov	r11, sp
 	rcall	do_critical_exception
-- 
1.5.6.3

