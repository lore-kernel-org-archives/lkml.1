Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYHUSGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYHUSGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbYHUSE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:04:56 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50420 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459AbYHUSEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:04:55 -0400
X-IronPort-AV: E=Sophos;i="4.32,246,1217822400"; 
   d="scan'208";a="16837645"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/7] x86_32:  Clean up play_dead.
Date: Thu, 21 Aug 2008 19:04:45 +0100
Message-Id: <1219341888-23191-4-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1219341888-23191-3-git-send-email-alex.nixon@citrix.com>
References: <>
 <1219341888-23191-1-git-send-email-alex.nixon@citrix.com>
 <1219341888-23191-2-git-send-email-alex.nixon@citrix.com>
 <1219341888-23191-3-git-send-email-alex.nixon@citrix.com>
X-OriginalArrivalTime: 21 Aug 2008 18:04:55.0194 (UTC) FILETIME=[6A78D7A0:01C903B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The removal of the CPU from the various maps was redundant as it already happened in cpu_disable.

After cleaning this up, cpu_uninit only resets the tlb state, so rename it and create a noop version for the X86_64 case (so the two play_deads can be unified later).

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    6 +-----
 arch/x86/kernel/process_32.c |   17 ++++-------------
 include/asm-x86/smp.h        |    7 ++++++-
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d3bc82f..531e054 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -755,14 +755,10 @@ void __cpuinit cpu_init(void)
 	xsave_init();
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-void __cpuinit cpu_uninit(void)
+void reset_lazy_tlbstate(void)
 {
 	int cpu = raw_smp_processor_id();
-	cpu_clear(cpu, cpu_initialized);
 
-	/* lazy TLB state */
 	per_cpu(cpu_tlbstate, cpu).state = 0;
 	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
 }
-#endif
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 53887cd..2db1746 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -83,26 +83,17 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 #define play_dead native_play_dead
 #endif
 
-static void cpu_exit_clear(void)
+/* We don't actually take CPU down, just spin without interrupts. */
+void native_play_dead(void)
 {
 	int cpu = raw_smp_processor_id();
 
 	idle_task_exit();
 
-	cpu_uninit();
-	irq_ctx_exit(cpu);
+	reset_lazy_tlbstate();
 
-	cpu_clear(cpu, cpu_callout_map);
-	cpu_clear(cpu, cpu_callin_map);
-
-	numa_remove_cpu(cpu);
-}
+	irq_ctx_exit(cpu);
 
-/* We don't actually take CPU down, just spin without interrupts. */
-void native_play_dead(void)
-{
-	/* This must be done before dead CPU ack */
-	cpu_exit_clear();
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index f7d153f..2b97b4c 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -215,7 +215,12 @@ static inline int hard_smp_processor_id(void)
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_HOTPLUG_CPU
-extern void cpu_uninit(void);
+#ifdef CONFIG_X86_32
+extern void reset_lazy_tlbstate(void);
+#else
+static inline void reset_lazy_tlbstate(void)
+{ }
+#endif /* CONFIG_X86_32 */
 #endif
 
 #endif /* __ASSEMBLY__ */
-- 
1.5.4.3

