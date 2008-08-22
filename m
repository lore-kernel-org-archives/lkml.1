Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbYHVKwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbYHVKwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbYHVKwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:52:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4602 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYHVKwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:52:04 -0400
X-IronPort-AV: E=Sophos;i="4.32,251,1217822400"; 
   d="scan'208";a="16925824"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/5] x86:  Unify x86_32 and x86_64 play_dead into one function
Date: Fri, 22 Aug 2008 11:52:13 +0100
Message-Id: <1219402335-29773-3-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1219402335-29773-2-git-send-email-alex.nixon@citrix.com>
References: <>
 <1219402335-29773-1-git-send-email-alex.nixon@citrix.com>
 <1219402335-29773-2-git-send-email-alex.nixon@citrix.com>
X-OriginalArrivalTime: 22 Aug 2008 10:51:56.0603 (UTC) FILETIME=[187030B0:01C90445]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new play_dead into smpboot.c, as it fits more cleanly in there alongside other CONFIG_HOTPLUG functions.
Separate out the common code into its own function.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_32.c |   32 --------------------------------
 arch/x86/kernel/process_64.c |   23 -----------------------
 arch/x86/kernel/smpboot.c    |   29 +++++++++++++++++++++++++++++
 include/asm-x86/smp.h        |    1 +
 4 files changed, 30 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index c4abfab..aff137c 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -74,38 +74,6 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 	return ((unsigned long *)tsk->thread.sp)[3];
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-#include <asm/nmi.h>
-
-/* We don't actually take CPU down, just spin without interrupts. */
-void native_play_dead(void)
-{
-	int cpu = raw_smp_processor_id();
-
-	idle_task_exit();
-
-	reset_lazy_tlbstate();
-
-	irq_ctx_exit(cpu);
-
-	mb();
-	/* Ack it */
-	__get_cpu_var(cpu_state) = CPU_DEAD;
-
-	/*
-	 * With physical CPU hotplug, we should halt the cpu
-	 */
-	local_irq_disable();
-	/* mask all interrupts, flush any and all caches, and halt */
-	wbinvd_halt();
-}
-#else
-void native_play_dead(void)
-{
-	BUG();
-}
-#endif /* CONFIG_HOTPLUG_CPU */
-
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 1cca50c..b2bab8e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -87,29 +87,6 @@ void exit_idle(void)
 	__exit_idle();
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-DECLARE_PER_CPU(int, cpu_state);
-
-#include <linux/nmi.h>
-/* We halt the CPU with physical CPU hotplug */
-void native_play_dead(void)
-{
-	idle_task_exit();
-	mb();
-	/* Ack it */
-	__get_cpu_var(cpu_state) = CPU_DEAD;
-
-	local_irq_disable();
-	/* mask all interrupts, flush any and all caches, and halt */
-	wbinvd_halt();
-}
-#else
-void native_play_dead(void)
-{
-	BUG();
-}
-#endif /* CONFIG_HOTPLUG_CPU */
-
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c6832ca..58d8c6c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1399,6 +1399,29 @@ void native_cpu_die(unsigned int cpu)
 	}
 	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
 }
+
+void play_dead_common(void)
+{
+	idle_task_exit();
+	reset_lazy_tlbstate();
+	irq_ctx_exit(raw_smp_processor_id());
+
+	mb();
+	/* Ack it */
+	__get_cpu_var(cpu_state) = CPU_DEAD;
+
+	/*
+	 * With physical CPU hotplug, we should halt the cpu
+	 */
+	local_irq_disable();
+}
+
+void native_play_dead(void)
+{
+	play_dead_common();
+	wbinvd_halt();
+}
+
 #else /* ... !CONFIG_HOTPLUG_CPU */
 int native_cpu_disable(void)
 {
@@ -1410,4 +1433,10 @@ void native_cpu_die(unsigned int cpu)
 	/* We said "no" in __cpu_disable */
 	BUG();
 }
+
+void native_play_dead(void)
+{
+	BUG();
+}
+
 #endif
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index dba14d3..95b28c1 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -135,6 +135,7 @@ int native_cpu_up(unsigned int cpunum);
 int native_cpu_disable(void);
 void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
+void play_dead_common(void);
 
 void native_send_call_func_ipi(cpumask_t mask);
 void native_send_call_func_single_ipi(int cpu);
-- 
1.5.4.3

