Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbYCSU0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbYCSU0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbYCSTjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbYCSTjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:09 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 65/79] [PATCH] integrate start_secondary
Date: Wed, 19 Mar 2008 14:26:00 -0300
Message-Id: <12059478682569-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947862872-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

It now looks the same between architectures, so we
merge it in smpboot.c. Minor differences goes inside
an ifdef

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   86 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/smpboot_32.c |   75 ------------------------------------
 arch/x86/kernel/smpboot_64.c |   63 ------------------------------
 3 files changed, 85 insertions(+), 139 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 69c1796..a36ae27 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -17,6 +17,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mtrr.h>
 #include <asm/nmi.h>
+#include <asm/vmi.h>
 #include <linux/mc146818rtc.h>
 
 #include <mach_apic.h>
@@ -229,6 +230,90 @@ void __cpuinit smp_callin(void)
 	cpu_set(cpuid, cpu_callin_map);
 }
 
+/*
+ * Activate a secondary processor.
+ */
+void __cpuinit start_secondary(void *unused)
+{
+	/*
+	 * Don't put *anything* before cpu_init(), SMP booting is too
+	 * fragile that we want to limit the things done here to the
+	 * most necessary things.
+	 */
+#ifdef CONFIG_VMI
+	vmi_bringup();
+#endif
+	cpu_init();
+	preempt_disable();
+	smp_callin();
+
+	/* otherwise gcc will move up smp_processor_id before the cpu_init */
+	barrier();
+	/*
+	 * Check TSC synchronization with the BP:
+	 */
+	check_tsc_sync_target();
+
+	if (nmi_watchdog == NMI_IO_APIC) {
+		disable_8259A_irq(0);
+		enable_NMI_through_LVT0();
+		enable_8259A_irq(0);
+	}
+
+	/* This must be done before setting cpu_online_map */
+	set_cpu_sibling_map(raw_smp_processor_id());
+	wmb();
+
+	/*
+	 * We need to hold call_lock, so there is no inconsistency
+	 * between the time smp_call_function() determines number of
+	 * IPI recipients, and the time when the determination is made
+	 * for which cpus receive the IPI. Holding this
+	 * lock helps us to not include this cpu in a currently in progress
+	 * smp_call_function().
+	 */
+	lock_ipi_call_lock();
+#ifdef CONFIG_X86_64
+	spin_lock(&vector_lock);
+
+	/* Setup the per cpu irq handling data structures */
+	__setup_vector_irq(smp_processor_id());
+	/*
+	 * Allow the master to continue.
+	 */
+	spin_unlock(&vector_lock);
+#endif
+	cpu_set(smp_processor_id(), cpu_online_map);
+	unlock_ipi_call_lock();
+	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+
+	setup_secondary_clock();
+
+	wmb();
+	cpu_idle();
+}
+
+#ifdef CONFIG_X86_32
+/*
+ * Everything has been set up for the secondary
+ * CPUs - they just need to reload everything
+ * from the task structure
+ * This function must not return.
+ */
+void __devinit initialize_secondary(void)
+{
+	/*
+	 * We don't actually need to load the full TSS,
+	 * basically just the stack pointer and the ip.
+	 */
+
+	asm volatile(
+		"movl %0,%%esp\n\t"
+		"jmp *%1"
+		:
+		:"m" (current->thread.sp), "m" (current->thread.ip));
+}
+#endif
 
 static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
 {
@@ -533,7 +618,6 @@ wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
 }
 #endif	/* WAKE_SECONDARY_VIA_NMI */
 
-extern void start_secondary(void *unused);
 #ifdef WAKE_SECONDARY_VIA_INIT
 static int __devinit
 wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index e82eeb2..77b045c 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -80,81 +80,6 @@ extern void unmap_cpu_to_logical_apicid(int cpu);
 /* State of each CPU. */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-extern void smp_callin(void);
-
-/*
- * Activate a secondary processor.
- */
-void __cpuinit start_secondary(void *unused)
-{
-	/*
-	 * Don't put *anything* before cpu_init(), SMP booting is too
-	 * fragile that we want to limit the things done here to the
-	 * most necessary things.
-	 */
-#ifdef CONFIG_VMI
-	vmi_bringup();
-#endif
-	cpu_init();
-	preempt_disable();
-	smp_callin();
-
-	/* otherwise gcc will move up smp_processor_id before the cpu_init */
-	barrier();
-	/*
-	 * Check TSC synchronization with the BP:
-	 */
-	check_tsc_sync_target();
-
-	if (nmi_watchdog == NMI_IO_APIC) {
-		disable_8259A_irq(0);
-		enable_NMI_through_LVT0();
-		enable_8259A_irq(0);
-	}
-
-	/* This must be done before setting cpu_online_map */
-	set_cpu_sibling_map(raw_smp_processor_id());
-	wmb();
-
-	/*
-	 * We need to hold call_lock, so there is no inconsistency
-	 * between the time smp_call_function() determines number of
-	 * IPI recipients, and the time when the determination is made
-	 * for which cpus receive the IPI. Holding this
-	 * lock helps us to not include this cpu in a currently in progress
-	 * smp_call_function().
-	 */
-	lock_ipi_call_lock();
-	cpu_set(smp_processor_id(), cpu_online_map);
-	unlock_ipi_call_lock();
-	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
-
-	setup_secondary_clock();
-
-	wmb();
-	cpu_idle();
-}
-
-/*
- * Everything has been set up for the secondary
- * CPUs - they just need to reload everything
- * from the task structure
- * This function must not return.
- */
-void __devinit initialize_secondary(void)
-{
-	/*
-	 * We don't actually need to load the full TSS,
-	 * basically just the stack pointer and the ip.
-	 */
-
-	asm volatile(
-		"movl %0,%%esp\n\t"
-		"jmp *%1"
-		:
-		:"m" (current->thread.sp),"m" (current->thread.ip));
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 void cpu_exit_clear(void)
 {
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 71f13b1..60cd8cf 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -71,69 +71,6 @@ int smp_threads_ready;
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-extern void smp_callin(void);
-/*
- * Setup code on secondary processor (after comming out of the trampoline)
- */
-void __cpuinit start_secondary(void)
-{
-	/*
-	 * Dont put anything before smp_callin(), SMP
-	 * booting is too fragile that we want to limit the
-	 * things done here to the most necessary things.
-	 */
-	cpu_init();
-	preempt_disable();
-	smp_callin();
-
-	/* otherwise gcc will move up the smp_processor_id before the cpu_init */
-	barrier();
-
-	/*
-  	 * Check TSC sync first:
- 	 */
-	check_tsc_sync_target();
-
-	if (nmi_watchdog == NMI_IO_APIC) {
-		disable_8259A_irq(0);
-		enable_NMI_through_LVT0();
-		enable_8259A_irq(0);
-	}
-
-	/*
-	 * The sibling maps must be set before turing the online map on for
-	 * this cpu
-	 */
-	set_cpu_sibling_map(smp_processor_id());
-
-	/*
-	 * We need to hold call_lock, so there is no inconsistency
-	 * between the time smp_call_function() determines number of
-	 * IPI recipients, and the time when the determination is made
-	 * for which cpus receive the IPI in genapic_flat.c. Holding this
-	 * lock helps us to not include this cpu in a currently in progress
-	 * smp_call_function().
-	 */
-	lock_ipi_call_lock();
-	spin_lock(&vector_lock);
-
-	/* Setup the per cpu irq handling data structures */
-	__setup_vector_irq(smp_processor_id());
-	/*
-	 * Allow the master to continue.
-	 */
-	spin_unlock(&vector_lock);
-	cpu_set(smp_processor_id(), cpu_online_map);
-	unlock_ipi_call_lock();
-
-	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
-
-	setup_secondary_clock();
-
-	wmb();
-	cpu_idle();
-}
-
 cycles_t cacheflush_time;
 unsigned long cache_decay_ticks;
 
-- 
1.5.0.6

