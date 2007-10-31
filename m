Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbXJaWAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbXJaWAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759795AbXJaV7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:59:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932AbXJaV7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:59:14 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/7] smp x86 consolidation
Date: Wed, 31 Oct 2007 16:13:16 -0300
Message-Id: <1193858022794-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <119385801745-git-send-email-gcosta@redhat.com>
References: <1193857999499-git-send-email-gcosta@redhat.com> <11938580063444-git-send-email-gcosta@redhat.com> <11938580111179-git-send-email-gcosta@redhat.com> <119385801745-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch consolidates part of the pieces of smp for both architectures.
(i386 and x86_64). It makes part the calls go through smp_ops. Later on,
making the functions themselves have shared code is doable and a logical
next step

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/smp_64.c     |   23 ++++++++++----
 arch/x86/kernel/smpboot_64.c |    8 ++--
 include/asm-x86/smp.h        |   66 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/smp_32.h     |   58 ------------------------------------
 include/asm-x86/smp_64.h     |    4 --
 5 files changed, 86 insertions(+), 73 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index ad063a6..9ddcb99 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -291,9 +291,9 @@ void flush_tlb_all(void)
  * anything. Worst case is that we lose a reschedule ...
  */
 
-void smp_send_reschedule(int cpu)
+void native_smp_send_reschedule(int cpu)
 {
-	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
+       send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
 }
 
 /*
@@ -388,7 +388,7 @@ __smp_call_function_mask(cpumask_t mask,
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function_mask(cpumask_t mask,
+int native_smp_call_function_mask(cpumask_t mask,
 			   void (*func)(void *), void *info,
 			   int wait)
 {
@@ -402,7 +402,6 @@ int smp_call_function_mask(cpumask_t mask,
 	spin_unlock(&call_lock);
 	return ret;
 }
-EXPORT_SYMBOL(smp_call_function_mask);
 
 /*
  * smp_call_function_single - Run a function on a specific CPU
@@ -418,7 +417,7 @@ EXPORT_SYMBOL(smp_call_function_mask);
  */
 
 int smp_call_function_single (int cpu, void (*func) (void *info), void *info,
-	int nonatomic, int wait)
+			      int nonatomic, int wait)
 {
 	/* prevent preemption and reschedule on another processor */
 	int ret;
@@ -458,7 +457,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  * Actually there are a few legal cases, like panic.
  */
 int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-			int wait)
+			      int wait)
 {
 	return smp_call_function_mask(cpu_online_map, func, info, wait);
 }
@@ -476,7 +475,7 @@ static void stop_this_cpu(void *dummy)
 		halt();
 } 
 
-void smp_send_stop(void)
+void native_smp_send_stop(void)
 {
 	int nolock;
 	unsigned long flags;
@@ -532,3 +531,13 @@ asmlinkage void smp_call_function_interrupt(void)
 	}
 }
 
+struct smp_ops smp_ops = {
+	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
+	.smp_prepare_cpus = native_smp_prepare_cpus,
+	.cpu_up = native_cpu_up,
+	.smp_cpus_done = native_smp_cpus_done,
+
+	.smp_send_stop = native_smp_send_stop,
+	.smp_send_reschedule = native_smp_send_reschedule,
+	.smp_call_function_mask = native_smp_call_function_mask,
+};
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 500670c..49036d0 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -865,7 +865,7 @@ void __init smp_set_apicids(void)
  * Prepare for SMP bootup.  The MP table or ACPI has been read
  * earlier.  Just do some sanity checking here and enable APIC mode.
  */
-void __init smp_prepare_cpus(unsigned int max_cpus)
+void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	nmi_watchdog_default();
 	current_cpu_data = boot_cpu_data;
@@ -909,7 +909,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 /*
  * Early setup to make printk work.
  */
-void __init smp_prepare_boot_cpu(void)
+void __init native_smp_prepare_boot_cpu(void)
 {
 	int me = smp_processor_id();
 	cpu_set(me, cpu_online_map);
@@ -920,7 +920,7 @@ void __init smp_prepare_boot_cpu(void)
 /*
  * Entry point to boot a CPU.
  */
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit native_cpu_up(unsigned int cpu)
 {
 	int apicid = cpu_present_to_apicid(cpu);
 	unsigned long flags;
@@ -978,7 +978,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 /*
  * Finish the SMP boot.
  */
-void __init smp_cpus_done(unsigned int max_cpus)
+void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 	smp_cleanup_boot();
 	setup_ioapic_dest();
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index f2e8319..b2f99df 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -1,5 +1,71 @@
+#ifndef _X86_SMP_H_
+#define _X86_SMP_H_
+
+#ifndef __ASSEMBLY__
+struct smp_ops
+{
+	void (*smp_prepare_boot_cpu)(void);
+	void (*smp_prepare_cpus)(unsigned max_cpus);
+	int (*cpu_up)(unsigned cpu);
+	void (*smp_cpus_done)(unsigned max_cpus);
+
+	void (*smp_send_stop)(void);
+	void (*smp_send_reschedule)(int cpu);
+	int (*smp_call_function_mask)(cpumask_t mask,
+				      void (*func)(void *info), void *info,
+				      int wait);
+};
+
+extern struct smp_ops smp_ops;
+
+static inline void smp_prepare_boot_cpu(void)
+{
+	smp_ops.smp_prepare_boot_cpu();
+}
+static inline void smp_prepare_cpus(unsigned int max_cpus)
+{
+	smp_ops.smp_prepare_cpus(max_cpus);
+}
+static inline int __cpu_up(unsigned int cpu)
+{
+	return smp_ops.cpu_up(cpu);
+}
+static inline void smp_cpus_done(unsigned int max_cpus)
+{
+	smp_ops.smp_cpus_done(max_cpus);
+}
+
+static inline void smp_send_stop(void)
+{
+	smp_ops.smp_send_stop();
+}
+static inline void smp_send_reschedule(int cpu)
+{
+	smp_ops.smp_send_reschedule(cpu);
+}
+
+static inline int smp_call_function_mask(cpumask_t mask,
+					 void (*func) (void *info),
+					 void *info, int wait)
+{
+	return smp_ops.smp_call_function_mask(mask, func, info, wait);
+}
+
+void native_smp_prepare_boot_cpu(void);
+void native_smp_prepare_cpus(unsigned int max_cpus);
+int native_cpu_up(unsigned int cpunum);
+void native_smp_cpus_done(unsigned int max_cpus);
+
+#ifndef CONFIG_PARAVIRT
+#define startup_ipi_hook(phys_apicid, start_eip, start_esp) 		\
+do { } while (0)
+#endif
+#endif /* __ASSEMBLY__ */
+
 #ifdef CONFIG_X86_32
 # include "smp_32.h"
 #else
 # include "smp_64.h"
 #endif
+
+#endif
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index e10b7af..a53b03f 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -53,64 +53,6 @@ extern void cpu_uninit(void);
 extern void remove_siblinginfo(int cpu);
 #endif
 
-struct smp_ops
-{
-	void (*smp_prepare_boot_cpu)(void);
-	void (*smp_prepare_cpus)(unsigned max_cpus);
-	int (*cpu_up)(unsigned cpu);
-	void (*smp_cpus_done)(unsigned max_cpus);
-
-	void (*smp_send_stop)(void);
-	void (*smp_send_reschedule)(int cpu);
-	int (*smp_call_function_mask)(cpumask_t mask,
-				      void (*func)(void *info), void *info,
-				      int wait);
-};
-
-extern struct smp_ops smp_ops;
-
-static inline void smp_prepare_boot_cpu(void)
-{
-	smp_ops.smp_prepare_boot_cpu();
-}
-static inline void smp_prepare_cpus(unsigned int max_cpus)
-{
-	smp_ops.smp_prepare_cpus(max_cpus);
-}
-static inline int __cpu_up(unsigned int cpu)
-{
-	return smp_ops.cpu_up(cpu);
-}
-static inline void smp_cpus_done(unsigned int max_cpus)
-{
-	smp_ops.smp_cpus_done(max_cpus);
-}
-
-static inline void smp_send_stop(void)
-{
-	smp_ops.smp_send_stop();
-}
-static inline void smp_send_reschedule(int cpu)
-{
-	smp_ops.smp_send_reschedule(cpu);
-}
-static inline int smp_call_function_mask(cpumask_t mask,
-					 void (*func) (void *info), void *info,
-					 int wait)
-{
-	return smp_ops.smp_call_function_mask(mask, func, info, wait);
-}
-
-void native_smp_prepare_boot_cpu(void);
-void native_smp_prepare_cpus(unsigned int max_cpus);
-int native_cpu_up(unsigned int cpunum);
-void native_smp_cpus_done(unsigned int max_cpus);
-
-#ifndef CONFIG_PARAVIRT
-#define startup_ipi_hook(phys_apicid, start_eip, start_esp) 		\
-do { } while (0)
-#endif
-
 /*
  * This function is needed by all SMP systems. It must _always_ be valid
  * from the initial startup. We map APIC_BASE very early in page_setup(),
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index ab612b0..279ff92 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -36,9 +36,6 @@ extern volatile unsigned long smp_invalidate_needed;
 extern void lock_ipi_call_lock(void);
 extern void unlock_ipi_call_lock(void);
 extern int smp_num_siblings;
-extern void smp_send_reschedule(int cpu);
-extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
-				  void *info, int wait);
 
 /*
  * cpu_sibling_map and cpu_core_map now live
@@ -127,4 +124,3 @@ extern unsigned int boot_cpu_id;
 #define cpu_physical_id(cpu)		boot_cpu_id
 #endif /* !CONFIG_SMP */
 #endif
-
-- 
1.4.4.2

