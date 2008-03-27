Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYC0RLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYC0RLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbYC0RLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:11:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758464AbYC0RLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:11:01 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 7/9] [PATCH] x86: merge SMP definitions of smp.h
Date: Thu, 27 Mar 2008 14:06:02 -0300
Message-Id: <12066375943864-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12066375644061-git-send-email-gcosta@redhat.com>
References: <12066375644061-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we merge everything that is inside CONFIG_SMP
to smp.h. They differ a little bit, so we use
CONFIG_X86_32_SMP and CONFIG_X86_64_SMP as markers.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h    |   33 ++++++++++++++++++++++++++++++++-
 include/asm-x86/smp_32.h |   21 ---------------------
 include/asm-x86/smp_64.h |   27 ---------------------------
 3 files changed, 32 insertions(+), 49 deletions(-)

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 1cd434d..5f6ea69 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -131,8 +131,39 @@ extern unsigned long setup_trampoline(void);
 
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
-#else
+
+/* We don't mark CPUs online until __cpu_up(), so we need another measure */
+static inline int num_booting_cpus(void)
+{
+	return cpus_weight(cpu_callout_map);
+}
+#endif /* CONFIG_SMP */
+
+#ifdef CONFIG_X86_32_SMP
+/*
+ * This function is needed by all SMP systems. It must _always_ be valid
+ * from the initial startup. We map APIC_BASE very early in page_setup(),
+ * so this is correct in the x86 case.
+ */
+DECLARE_PER_CPU(int, cpu_number);
+#define raw_smp_processor_id() (x86_read_percpu(cpu_number))
+extern int safe_smp_processor_id(void);
+
+#elif defined(CONFIG_X86_64_SMP)
+#define raw_smp_processor_id()	read_pda(cpunumber)
+
+#define stack_smp_processor_id()					\
+({								\
+	struct thread_info *ti;						\
+	__asm__("andq %%rsp,%0; ":"=r" (ti) : "0" (CURRENT_MASK));	\
+	ti->cpu;							\
+})
+#define safe_smp_processor_id()		smp_processor_id()
+
+#else /* !CONFIG_X86_32_SMP && !CONFIG_X86_64_SMP */
 #define cpu_physical_id(cpu)		boot_cpu_physical_apicid
+#define safe_smp_processor_id()		0
+#define stack_smp_processor_id() 	0
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 694d324..d9ae5ac 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -8,26 +8,5 @@ extern cpumask_t cpu_callin_map;
 extern void (*mtrr_hook)(void);
 extern void zap_low_mappings(void);
 
-#ifdef CONFIG_SMP
-/*
- * This function is needed by all SMP systems. It must _always_ be valid
- * from the initial startup. We map APIC_BASE very early in page_setup(),
- * so this is correct in the x86 case.
- */
-DECLARE_PER_CPU(int, cpu_number);
-#define raw_smp_processor_id() (x86_read_percpu(cpu_number))
-
-extern int safe_smp_processor_id(void);
-
-/* We don't mark CPUs online until __cpu_up(), so we need another measure */
-static inline int num_booting_cpus(void)
-{
-	return cpus_weight(cpu_callout_map);
-}
-
-#else /* CONFIG_SMP */
-#define safe_smp_processor_id()		0
-#endif /* !CONFIG_SMP */
-
 #endif /* !ASSEMBLY */
 #endif
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index 8ea4952..058f413 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -7,32 +7,5 @@ extern cpumask_t cpu_callin_map;
 extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 				  void *info, int wait);
 
-#ifdef CONFIG_SMP
-
-#define raw_smp_processor_id()	read_pda(cpunumber)
-
-#define stack_smp_processor_id()					\
-({									\
-	struct thread_info *ti;						\
-	asm("andq %%rsp,%0; ":"=r" (ti) : "0" (CURRENT_MASK));	\
-	ti->cpu;							\
-})
-
-/*
- * On x86 all CPUs are mapped 1:1 to the APIC space. This simplifies
- * scheduling and IPI sending and compresses data structures.
- */
-static inline int num_booting_cpus(void)
-{
-	return cpus_weight(cpu_callout_map);
-}
-
-#define safe_smp_processor_id()		smp_processor_id()
-#else /* CONFIG_SMP */
-#define stack_smp_processor_id() 0
-#define safe_smp_processor_id() 0
-#endif /* !CONFIG_SMP */
-
-
 #endif
 
-- 
1.5.0.6

