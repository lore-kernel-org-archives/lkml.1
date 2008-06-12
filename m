Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYFLK31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYFLK31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbYFLK3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:29:04 -0400
Received: from www.tglx.de ([62.245.132.106]:33224 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759406AbYFLK3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:29:01 -0400
Message-Id: <20080610171712.196774103@linutronix.de>
References: <20080610171639.551369443@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 10:28:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [patch 1/6] x86: simplify idle selection
Content-Disposition: inline;
	filename=0001-391c1a465c0bad7a2c5ab6c46fd5da7fcaee4adc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default_idle is selected in cpu_idle(), when no other idle routine is
selected. Select it in select_idle_routine() when mwait is not
selected.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>

---
 arch/x86/kernel/process.c    |   18 +++++++-----------
 arch/x86/kernel/process_32.c |    7 +------
 arch/x86/kernel/process_64.c |    7 ++-----
 3 files changed, 10 insertions(+), 22 deletions(-)

Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c
+++ linux-2.6/arch/x86/kernel/process.c
@@ -139,27 +139,23 @@ static int __cpuinit mwait_usable(const 
 
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
-	static int selected;
-
-	if (selected)
-		return;
 #ifdef CONFIG_X86_SMP
 	if (pm_idle == poll_idle && smp_num_siblings > 1) {
 		printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
 			" performance may degrade.\n");
 	}
 #endif
+	if (pm_idle)
+		return;
+
 	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
 		/*
-		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
 		 */
-		if (!pm_idle) {
-			printk(KERN_INFO "using mwait in idle threads.\n");
-			pm_idle = mwait_idle;
-		}
-	}
-	selected = 1;
+		printk(KERN_INFO "using mwait in idle threads.\n");
+		pm_idle = mwait_idle;
+	} else
+		pm_idle = default_idle;
 }
 
 static int __init idle_setup(char *str)
Index: linux-2.6/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_32.c
+++ linux-2.6/arch/x86/kernel/process_32.c
@@ -168,24 +168,19 @@ void cpu_idle(void)
 	while (1) {
 		tick_nohz_stop_sched_tick();
 		while (!need_resched()) {
-			void (*idle)(void);
 
 			check_pgt_cache();
 			rmb();
-			idle = pm_idle;
 
 			if (rcu_pending(cpu))
 				rcu_check_callbacks(cpu, 0);
 
-			if (!idle)
-				idle = default_idle;
-
 			if (cpu_is_offline(cpu))
 				play_dead();
 
 			local_irq_disable();
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
-			idle();
+			pm_idle();
 		}
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
Index: linux-2.6/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_64.c
+++ linux-2.6/arch/x86/kernel/process_64.c
@@ -150,12 +150,9 @@ void cpu_idle(void)
 	while (1) {
 		tick_nohz_stop_sched_tick();
 		while (!need_resched()) {
-			void (*idle)(void);
 
 			rmb();
-			idle = pm_idle;
-			if (!idle)
-				idle = default_idle;
+
 			if (cpu_is_offline(smp_processor_id()))
 				play_dead();
 			/*
@@ -165,7 +162,7 @@ void cpu_idle(void)
 			 */
 			local_irq_disable();
 			enter_idle();
-			idle();
+			pm_idle();
 			/* In many cases the interrupt that ended idle
 			   has already called exit_idle. But some idle
 			   loops can be woken up without interrupt. */

-- 

