Return-Path: <linux-kernel-owner+w=401wt.eu-S1760487AbYHUSGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487AbYHUSGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbYHUSFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:05:00 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50420 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497AbYHUSE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:04:59 -0400
X-IronPort-AV: E=Sophos;i="4.32,246,1217822400"; 
   d="scan'208";a="16837652"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/7] x86:  Unify x86_32 and x86_64 play_dead into one function
Date: Thu, 21 Aug 2008 19:04:46 +0100
Message-Id: <1219341888-23191-5-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1219341888-23191-4-git-send-email-alex.nixon@citrix.com>
References: <>
 <1219341888-23191-1-git-send-email-alex.nixon@citrix.com>
 <1219341888-23191-2-git-send-email-alex.nixon@citrix.com>
 <1219341888-23191-3-git-send-email-alex.nixon@citrix.com>
 <1219341888-23191-4-git-send-email-alex.nixon@citrix.com>
X-OriginalArrivalTime: 21 Aug 2008 18:04:58.0272 (UTC) FILETIME=[6C4E8200:01C903B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new play_dead into smpboot.c, as it fits more cleanly in there alongside other CONFIG_HOTPLUG functions.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_32.c |   38 --------------------------------------
 arch/x86/kernel/process_64.c |   28 ----------------------------
 arch/x86/kernel/smpboot.c    |   25 +++++++++++++++++++++++++
 include/asm-x86/smp.h        |    1 +
 4 files changed, 26 insertions(+), 66 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 2db1746..aff137c 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -74,44 +74,6 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 	return ((unsigned long *)tsk->thread.sp)[3];
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-#include <asm/nmi.h>
-
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define play_dead native_play_dead
-#endif
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
-void play_dead(void)
-{
-	BUG();
-}
-#endif /* CONFIG_HOTPLUG_CPU */
-
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 7512044..b2bab8e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -86,34 +86,6 @@ void exit_idle(void)
 		return;
 	__exit_idle();
 }
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define play_dead native_play_dead
-#endif
-
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
 
 /*
  * The idle thread. There's no useful work to be
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2a555a1..83e9591 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1396,6 +1396,25 @@ void native_cpu_die(unsigned int cpu)
 	}
 	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
 }
+
+void native_play_dead(void)
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
+	/* mask all interrupts, flush any and all caches, and halt */
+	wbinvd_halt();
+}
+
 #else /* ... !CONFIG_HOTPLUG_CPU */
 int native_cpu_disable(void)
 {
@@ -1407,4 +1426,10 @@ void native_cpu_die(unsigned int cpu)
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
index 2b97b4c..fd2a070 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -126,6 +126,7 @@ void native_send_call_func_single_ipi(int cpu);
 #else
 #define __cpu_disable	native_cpu_disable
 #define __cpu_die	native_cpu_die
+#define play_dead	native_play_dead
 #endif
 
 void smp_store_cpu_info(int id);
-- 
1.5.4.3

