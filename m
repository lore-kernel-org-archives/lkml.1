Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYICNjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYICNjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYICNiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:38:55 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6695 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbYICNiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:38:54 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="18324189"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 3/3] x86: Build fix for !CONFIG_SMP
Date: Wed,  3 Sep 2008 14:30:23 +0100
Message-Id: <1220448623-14860-3-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220448623-14860-2-git-send-email-alex.nixon@citrix.com>
References: <>
 <1220448623-14860-1-git-send-email-alex.nixon@citrix.com>
 <1220448623-14860-2-git-send-email-alex.nixon@citrix.com>
X-OriginalArrivalTime: 03 Sep 2008 13:29:27.0900 (UTC) FILETIME=[16CEA9C0:01C90DC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move reset_lazy_tlbstate into tlb_32.c, and define noop versions of play_dead in process_{32,64}.c when !CONFIG_SMP

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/kernel/cpu/common.c |    7 -------
 arch/x86/kernel/process_32.c |    7 +++++++
 arch/x86/kernel/process_64.c |    7 +++++++
 arch/x86/kernel/tlb_32.c     |    8 ++++++++
 include/asm-x86/smp.h        |    9 ---------
 include/asm-x86/tlbflush.h   |   10 ++++++++++
 6 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 531e054..58ff997 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -755,10 +755,3 @@ void __cpuinit cpu_init(void)
 	xsave_init();
 }
 
-void reset_lazy_tlbstate(void)
-{
-	int cpu = raw_smp_processor_id();
-
-	per_cpu(cpu_tlbstate, cpu).state = 0;
-	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
-}
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index aff137c..4eb2159 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -74,6 +74,13 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 	return ((unsigned long *)tsk->thread.sp)[3];
 }
 
+#ifndef CONFIG_SMP
+static inline void play_dead(void)
+{
+	BUG();
+}
+#endif
+
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b2bab8e..88f1ceb 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -87,6 +87,13 @@ void exit_idle(void)
 	__exit_idle();
 }
 
+#ifndef CONFIG_SMP
+static inline void play_dead(void)
+{
+	BUG();
+}
+#endif
+
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index fec1ece..e00534b 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -241,3 +241,11 @@ void flush_tlb_all(void)
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
+void reset_lazy_tlbstate(void)
+{
+	int cpu = raw_smp_processor_id();
+
+	per_cpu(cpu_tlbstate, cpu).state = 0;
+	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
+}
+
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index e0ac06a..6df2615 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -227,14 +227,5 @@ static inline int hard_smp_processor_id(void)
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
-#ifdef CONFIG_HOTPLUG_CPU
-#ifdef CONFIG_X86_32
-extern void reset_lazy_tlbstate(void);
-#else
-static inline void reset_lazy_tlbstate(void)
-{ }
-#endif /* CONFIG_X86_32 */
-#endif
-
 #endif /* __ASSEMBLY__ */
 #endif /* ASM_X86__SMP_H */
diff --git a/include/asm-x86/tlbflush.h b/include/asm-x86/tlbflush.h
index ef68b76..3cdd08b 100644
--- a/include/asm-x86/tlbflush.h
+++ b/include/asm-x86/tlbflush.h
@@ -119,6 +119,10 @@ static inline void native_flush_tlb_others(const cpumask_t *cpumask,
 {
 }
 
+static inline void reset_lazy_tlbstate(void)
+{
+}
+
 #else  /* SMP */
 
 #include <asm/smp.h>
@@ -151,6 +155,12 @@ struct tlb_state {
 	char __cacheline_padding[L1_CACHE_BYTES-8];
 };
 DECLARE_PER_CPU(struct tlb_state, cpu_tlbstate);
+
+void reset_lazy_tlbstate(void);
+#else
+static inline void reset_lazy_tlbstate(void)
+{
+}
 #endif
 
 #endif	/* SMP */
-- 
1.5.4.3

