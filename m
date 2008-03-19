Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbYCSUUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbYCSUUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYCSTjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260AbYCSTi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:58 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 66/79] [PATCH] merge smp_prepare_boot_cpu
Date: Wed, 19 Mar 2008 14:26:01 -0300
Message-Id: <12059478732976-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478682569-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

it is practically the same between arches now, so it is
moved to smpboot.c. Minor differences (gdt initialization)
live inside an ifdef

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   18 ++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   14 --------------
 arch/x86/kernel/smpboot_64.c |   14 --------------
 3 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a36ae27..b214d8d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -24,6 +24,9 @@
 #include <mach_wakecpu.h>
 #include <smpboot_hooks.h>
 
+/* State of each CPU */
+DEFINE_PER_CPU(int, cpu_state) = { 0 };
+
 /* Store all idle threads, this can be reused instead of creating
 * a new thread. Also avoids complicated thread destroy functionality
 * for idle threads.
@@ -999,6 +1002,21 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	return 0;
 }
 
+/*
+ * Early setup to make printk work.
+ */
+void __init native_smp_prepare_boot_cpu(void)
+{
+	int me = smp_processor_id();
+#ifdef CONFIG_X86_32
+	init_gdt(me);
+	switch_to_new_gdt();
+#endif
+	/* already set me in cpu_online_map in boot_cpu_init() */
+	cpu_set(me, cpu_callout_map);
+	per_cpu(cpu_state, me) = CPU_ONLINE;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 void remove_siblinginfo(int cpu)
 {
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 77b045c..5d27b1d 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -77,9 +77,6 @@ u8 apicid_2_node[MAX_APICID];
 extern void map_cpu_to_logical_apicid(void);
 extern void unmap_cpu_to_logical_apicid(int cpu);
 
-/* State of each CPU. */
-DEFINE_PER_CPU(int, cpu_state) = { 0 };
-
 #ifdef CONFIG_HOTPLUG_CPU
 void cpu_exit_clear(void)
 {
@@ -219,17 +216,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	smp_boot_cpus(max_cpus);
 }
 
-void __init native_smp_prepare_boot_cpu(void)
-{
-	unsigned int cpu = smp_processor_id();
-
-	init_gdt(cpu);
-	switch_to_new_gdt();
-
-	cpu_set(cpu, cpu_callout_map);
-	__get_cpu_var(cpu_state) = CPU_ONLINE;
-}
-
 extern void impress_friends(void);
 extern void smp_checks(void);
 
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 60cd8cf..f77299b 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -68,9 +68,6 @@
 /* Set when the idlers are all forked */
 int smp_threads_ready;
 
-/* State of each CPU */
-DEFINE_PER_CPU(int, cpu_state) = { 0 };
-
 cycles_t cacheflush_time;
 unsigned long cache_decay_ticks;
 
@@ -216,17 +213,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	print_cpu_info(&cpu_data(0));
 }
 
-/*
- * Early setup to make printk work.
- */
-void __init native_smp_prepare_boot_cpu(void)
-{
-	int me = smp_processor_id();
-	/* already set me in cpu_online_map in boot_cpu_init() */
-	cpu_set(me, cpu_callout_map);
-	per_cpu(cpu_state, me) = CPU_ONLINE;
-}
-
 extern void impress_friends(void);
 extern void smp_checks(void);
 
-- 
1.5.0.6

