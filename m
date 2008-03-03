Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYCCR1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYCCR1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759785AbYCCRPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759745AbYCCRPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:49 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 44/52] unify setup_trampoline
Date: Mon,  3 Mar 2008 14:13:12 -0300
Message-Id: <1204564400-17636-45-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-44-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
 <1204564400-17636-34-git-send-email-gcosta@redhat.com>
 <1204564400-17636-35-git-send-email-gcosta@redhat.com>
 <1204564400-17636-36-git-send-email-gcosta@redhat.com>
 <1204564400-17636-37-git-send-email-gcosta@redhat.com>
 <1204564400-17636-38-git-send-email-gcosta@redhat.com>
 <1204564400-17636-39-git-send-email-gcosta@redhat.com>
 <1204564400-17636-40-git-send-email-gcosta@redhat.com>
 <1204564400-17636-41-git-send-email-gcosta@redhat.com>
 <1204564400-17636-42-git-send-email-gcosta@redhat.com>
 <1204564400-17636-43-git-send-email-gcosta@redhat.com>
 <1204564400-17636-44-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_trampoline() looks very similar between architectures, and this
patch unifies them. The i386 version allocates bootmem memory, while
the x86_64 version uses a fixed address.

In this patch, we initialize the global trampoline_base to the x86_64 version,
and i386 allocation can later override it.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   29 -----------------------------
 arch/x86/kernel/smpboot_64.c |   14 --------------
 include/asm-x86/smp.h        |    4 ++++
 include/asm-x86/smp_64.h     |    2 --
 5 files changed, 37 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 34c3117..b13b9d5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -3,6 +3,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/percpu.h>
+#include <linux/bootmem.h>
 
 #include <asm/nmi.h>
 #include <asm/irq.h>
@@ -38,6 +39,9 @@ EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
+/* ready for x86_64, no harm for x86, since it will overwrite after alloc */
+unsigned char *trampoline_base = __va(SMP_TRAMPOLINE_BASE);
+
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
 
@@ -117,6 +121,35 @@ cpumask_t cpu_coregroup_map(int cpu)
 		return c->llc_shared_map;
 }
 
+/*
+ * Currently trivial. Write the real->protected mode
+ * bootstrap into the page concerned. The caller
+ * has made sure it's suitably aligned.
+ */
+
+unsigned long __cpuinit setup_trampoline(void)
+{
+	memcpy(trampoline_base, trampoline_data,
+	       trampoline_end - trampoline_data);
+	return virt_to_phys(trampoline_base);
+}
+
+#ifdef CONFIG_X86_32
+/*
+ * We are called very early to get the low memory for the
+ * SMP bootup trampoline page.
+ */
+void __init smp_alloc_memory(void)
+{
+	trampoline_base = alloc_bootmem_low_pages(PAGE_SIZE);
+	/*
+	 * Has to be in very low memory so we can execute
+	 * real-mode AP code.
+	 */
+	if (__pa(trampoline_base) >= 0x9F000)
+		BUG();
+}
+#endif
 
 #ifdef CONFIG_HOTPLUG_CPU
 void remove_siblinginfo(int cpu)
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index a21f254..ee82659 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -73,41 +73,12 @@ EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
 u8 apicid_2_node[MAX_APICID];
 
-static unsigned char *trampoline_base;
-
 static void map_cpu_to_logical_apicid(void);
 
 /* State of each CPU. */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
 /*
- * Currently trivial. Write the real->protected mode
- * bootstrap into the page concerned. The caller
- * has made sure it's suitably aligned.
- */
-
-static unsigned long __cpuinit setup_trampoline(void)
-{
-	memcpy(trampoline_base, trampoline_data, trampoline_end - trampoline_data);
-	return virt_to_phys(trampoline_base);
-}
-
-/*
- * We are called very early to get the low memory for the
- * SMP bootup trampoline page.
- */
-void __init smp_alloc_memory(void)
-{
-	trampoline_base = alloc_bootmem_low_pages(PAGE_SIZE);
-	/*
-	 * Has to be in very low memory so we can execute
-	 * real-mode AP code.
-	 */
-	if (__pa(trampoline_base) >= 0x9F000)
-		BUG();
-}
-
-/*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
  */
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 2cc1b8b..9f4935e 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -85,20 +85,6 @@ struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 #define set_idle_for_cpu(x,p)   (idle_thread_array[(x)] = (p))
 #endif
 
-
-/*
- * Currently trivial. Write the real->protected mode
- * bootstrap into the page concerned. The caller
- * has made sure it's suitably aligned.
- */
-
-static unsigned long __cpuinit setup_trampoline(void)
-{
-	void *tramp = __va(SMP_TRAMPOLINE_BASE); 
-	memcpy(tramp, trampoline_data, trampoline_end - trampoline_data);
-	return virt_to_phys(tramp);
-}
-
 /*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index b2a1697..513c857 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -14,6 +14,7 @@ extern unsigned int num_processors;
  */
 extern const unsigned char trampoline_data [];
 extern const unsigned char trampoline_end  [];
+extern unsigned char *trampoline_base;
 
 struct smp_ops {
 	void (*smp_prepare_boot_cpu)(void);
@@ -81,6 +82,9 @@ extern void __cpu_die(unsigned int cpu);
 
 extern unsigned disabled_cpus;
 extern void prefill_possible_map(void);
+
+#define SMP_TRAMPOLINE_BASE 0x6000
+extern unsigned long setup_trampoline(void);
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index d554d7d..394c785 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -40,8 +40,6 @@ static inline int cpu_present_to_apicid(int mps_cpu)
 
 #ifdef CONFIG_SMP
 
-#define SMP_TRAMPOLINE_BASE 0x6000
-
 #define raw_smp_processor_id()	read_pda(cpunumber)
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
-- 
1.5.0.6

