Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbZFNMFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbZFNMFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758829AbZFNMBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:42 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52687 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758587AbZFNMBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:40 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 14/17] Blackfin: convert irq/process to asm-generic
Date: Sun, 14 Jun 2009 08:01:15 -0400
Message-Id: <1244980878-2124-15-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/hardirq.h   |   36 ++------------------------------
 arch/blackfin/include/asm/irq.h       |    5 +---
 arch/blackfin/include/asm/processor.h |   35 ++-----------------------------
 arch/blackfin/kernel/process.c        |   23 +++++++++++++++++++++
 4 files changed, 30 insertions(+), 69 deletions(-)

diff --git a/arch/blackfin/include/asm/hardirq.h b/arch/blackfin/include/asm/hardirq.h
index 717181a..5a64084 100644
--- a/arch/blackfin/include/asm/hardirq.h
+++ b/arch/blackfin/include/asm/hardirq.h
@@ -1,47 +1,17 @@
 #ifndef __BFIN_HARDIRQ_H
 #define __BFIN_HARDIRQ_H
 
-#include <linux/cache.h>
-#include <linux/threads.h>
-#include <asm/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-	unsigned int __syscall_count;
-	struct task_struct *__ksoftirqd_task;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
-/*
- * We put the hardirq and softirq counter into the preemption
- * counter. The bitmask has the following meaning:
- *
- * - bits 0-7 are the preemption count (max preemption depth: 256)
- * - bits 8-15 are the softirq count (max # of softirqs: 256)
- * - bits 16-23 are the hardirq count (max # of hardirqs: 256)
- *
- * - ( bit 26 is the PREEMPT_ACTIVE flag. )
- *
- * PREEMPT_MASK: 0x000000ff
- * HARDIRQ_MASK: 0x0000ff00
- * SOFTIRQ_MASK: 0x00ff0000
- */
-
 #if NR_IRQS > 256
 #define HARDIRQ_BITS	9
 #else
 #define HARDIRQ_BITS	8
 #endif
 
-#ifdef NR_IRQS
-# if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-# endif
-#endif
-
 #define __ARCH_IRQ_EXIT_IRQS_DISABLED	1
 
 extern void ack_bad_irq(unsigned int irq);
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
 
 #endif
diff --git a/arch/blackfin/include/asm/irq.h b/arch/blackfin/include/asm/irq.h
index 400bdd5..9a7f63a 100644
--- a/arch/blackfin/include/asm/irq.h
+++ b/arch/blackfin/include/asm/irq.h
@@ -45,9 +45,6 @@
 		: "d" (bfin_irq_flags) \
 	)
 
-static inline int irq_canonicalize(int irq)
-{
-	return irq;
-}
+#include <asm-generic/irq.h>
 
 #endif				/* _BFIN_IRQ_H_ */
diff --git a/arch/blackfin/include/asm/processor.h b/arch/blackfin/include/asm/processor.h
index 3040415..d0be99b 100644
--- a/arch/blackfin/include/asm/processor.h
+++ b/arch/blackfin/include/asm/processor.h
@@ -7,9 +7,8 @@
  */
 #define current_text_addr() ({ __label__ _l; _l: &&_l;})
 
+#include <asm/ptrace.h>
 #include <asm/blackfin.h>
-#include <asm/segment.h>
-#include <linux/compiler.h>
 
 static inline unsigned long rdusp(void)
 {
@@ -59,36 +58,8 @@ struct thread_struct {
 	PS_S, 0, 0						\
 }
 
-/*
- * Do necessary setup to start up a newly executed thread.
- *
- * pass the data segment into user programs if it exists,
- * it can't hurt anything as far as I can tell
- */
-#ifndef CONFIG_SMP
-#define start_thread(_regs, _pc, _usp)					\
-do {									\
-	set_fs(USER_DS);						\
-	(_regs)->pc = (_pc);						\
-	if (current->mm)						\
-		(_regs)->p5 = current->mm->start_data;			\
-	task_thread_info(current)->l1_task_info.stack_start		\
-		= (void *)current->mm->context.stack_start;		\
-	task_thread_info(current)->l1_task_info.lowest_sp = (void *)(_usp); \
-	memcpy(L1_SCRATCH_TASK_INFO, &task_thread_info(current)->l1_task_info, \
-		sizeof(*L1_SCRATCH_TASK_INFO));				\
-	wrusp(_usp);							\
-} while(0)
-#else
-#define start_thread(_regs, _pc, _usp)					\
-do {									\
-	set_fs(USER_DS);						\
-	(_regs)->pc = (_pc);						\
-	if (current->mm)						\
-		(_regs)->p5 = current->mm->start_data;			\
-	wrusp(_usp);							\
-} while (0)
-#endif
+extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
+					       unsigned long new_sp);
 
 /* Forward declaration, a strange C thing */
 struct task_struct;
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 30d0843..3e1d86e 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -160,6 +160,29 @@ pid_t kernel_thread(int (*fn) (void *), void *arg, unsigned long flags)
 }
 EXPORT_SYMBOL(kernel_thread);
 
+/*
+ * Do necessary setup to start up a newly executed thread.
+ *
+ * pass the data segment into user programs if it exists,
+ * it can't hurt anything as far as I can tell
+ */
+void start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
+{
+	set_fs(USER_DS);
+	regs->pc = new_ip;
+	if (current->mm)
+		regs->p5 = current->mm->start_data;
+#ifdef CONFIG_SMP
+	task_thread_info(current)->l1_task_info.stack_start =
+		(void *)current->mm->context.stack_start;
+	task_thread_info(current)->l1_task_info.lowest_sp = (void *)new_sp;
+	memcpy(L1_SCRATCH_TASK_INFO, &task_thread_info(current)->l1_task_info,
+	       sizeof(*L1_SCRATCH_TASK_INFO));
+#endif
+	wrusp(new_sp);
+}
+EXPORT_SYMBOL_GPL(start_thread);
+
 void flush_thread(void)
 {
 }
-- 
1.6.3.1

