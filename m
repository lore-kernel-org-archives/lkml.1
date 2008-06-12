Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYFLKaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYFLKaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbYFLK3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:29:21 -0400
Received: from www.tglx.de ([62.245.132.106]:59823 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759554AbYFLK3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:29:20 -0400
Message-Id: <20080610171712.412031164@linutronix.de>
References: <20080610171639.551369443@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 10:28:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [patch 5/6] x86: move more common idle functions/variables to
	process.c
Content-Disposition: inline;
	filename=0005-0f619dcd9614c003426c472f1fe8227db7cc1a42.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>

---
 arch/x86/kernel/process.c    |   70 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c |   54 ---------------------------------
 arch/x86/kernel/process_64.c |   28 -----------------
 3 files changed, 70 insertions(+), 82 deletions(-)

Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c
+++ linux-2.6/arch/x86/kernel/process.c
@@ -45,6 +45,76 @@ void arch_task_cache_init(void)
 				  SLAB_PANIC, NULL);
 }
 
+/*
+ * Idle related variables and functions
+ */
+unsigned long boot_option_idle_override = 0;
+EXPORT_SYMBOL(boot_option_idle_override);
+
+/*
+ * Powermanagement idle function, if any..
+ */
+void (*pm_idle)(void);
+EXPORT_SYMBOL(pm_idle);
+
+#ifdef CONFIG_X86_32
+/*
+ * This halt magic was a workaround for ancient floppy DMA
+ * wreckage. It should be safe to remove.
+ */
+static int hlt_counter;
+void disable_hlt(void)
+{
+	hlt_counter++;
+}
+EXPORT_SYMBOL(disable_hlt);
+
+void enable_hlt(void)
+{
+	hlt_counter--;
+}
+EXPORT_SYMBOL(enable_hlt);
+
+static inline int hlt_use_halt(void)
+{
+	return !hlt_counter && boot_cpu_data.hlt_works_ok;
+}
+#else
+static inline int hlt_use_halt(void)
+{
+	return 1;
+}
+#endif
+
+/*
+ * We use this if we don't have any better
+ * idle routine..
+ */
+void default_idle(void)
+{
+	if (hlt_use_halt()) {
+		current_thread_info()->status &= ~TS_POLLING;
+		/*
+		 * TS_POLLING-cleared state must be visible before we
+		 * test NEED_RESCHED:
+		 */
+		smp_mb();
+
+		if (!need_resched())
+			safe_halt();	/* enables interrupts racelessly */
+		else
+			local_irq_enable();
+		current_thread_info()->status |= TS_POLLING;
+	} else {
+		local_irq_enable();
+		/* loop is done by the caller */
+		cpu_relax();
+	}
+}
+#ifdef CONFIG_APM_MODULE
+EXPORT_SYMBOL(default_idle);
+#endif
+
 static void do_nothing(void *unused)
 {
 }
Index: linux-2.6/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_32.c
+++ linux-2.6/arch/x86/kernel/process_32.c
@@ -58,11 +58,6 @@
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
-static int hlt_counter;
-
-unsigned long boot_option_idle_override = 0;
-EXPORT_SYMBOL(boot_option_idle_override);
-
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
@@ -77,55 +72,6 @@ unsigned long thread_saved_pc(struct tas
 	return ((unsigned long *)tsk->thread.sp)[3];
 }
 
-/*
- * Powermanagement idle function, if any..
- */
-void (*pm_idle)(void);
-EXPORT_SYMBOL(pm_idle);
-
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-
-EXPORT_SYMBOL(enable_hlt);
-
-/*
- * We use this if we don't have any better
- * idle routine..
- */
-void default_idle(void)
-{
-	if (!hlt_counter && boot_cpu_data.hlt_works_ok) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we
-		 * test NEED_RESCHED:
-		 */
-		smp_mb();
-
-		if (!need_resched())
-			safe_halt();	/* enables interrupts racelessly */
-		else
-			local_irq_enable();
-		current_thread_info()->status |= TS_POLLING;
-	} else {
-		local_irq_enable();
-		/* loop is done by the caller */
-		cpu_relax();
-	}
-}
-#ifdef CONFIG_APM_MODULE
-EXPORT_SYMBOL(default_idle);
-#endif
-
 #ifdef CONFIG_HOTPLUG_CPU
 #include <asm/nmi.h>
 /* We don't actually take CPU down, just spin without interrupts. */
Index: linux-2.6/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_64.c
+++ linux-2.6/arch/x86/kernel/process_64.c
@@ -56,15 +56,6 @@ asmlinkage extern void ret_from_fork(voi
 
 unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
 
-unsigned long boot_option_idle_override = 0;
-EXPORT_SYMBOL(boot_option_idle_override);
-
-/*
- * Powermanagement idle function, if any..
- */
-void (*pm_idle)(void);
-EXPORT_SYMBOL(pm_idle);
-
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
 
 void idle_notifier_register(struct notifier_block *n)
@@ -94,25 +85,6 @@ void exit_idle(void)
 	__exit_idle();
 }
 
-/*
- * We use this if we don't have any better
- * idle routine..
- */
-void default_idle(void)
-{
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we
-	 * test NEED_RESCHED:
-	 */
-	smp_mb();
-	if (!need_resched())
-		safe_halt();	/* enables interrupts racelessly */
-	else
-		local_irq_enable();
-	current_thread_info()->status |= TS_POLLING;
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 DECLARE_PER_CPU(int, cpu_state);
 

-- 

