Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbYCSUWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbYCSUWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYCSTj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbYCSTjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:03 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 30/79] [PATCH] fill cpu to apicid and present map in mpparse
Date: Wed, 19 Mar 2008 14:25:25 -0300
Message-Id: <12059477102394-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477063046-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This is the way x86_64 does, and complement the already
present patch that does the bios cpu to apicid mapping here

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/mpparse_32.c |   19 +++++++++++++++++--
 arch/x86/kernel/smpboot_32.c |   24 +++++++-----------------
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/mpparse_32.c b/arch/x86/kernel/mpparse_32.c
index 56fb828..b18fb0f 100644
--- a/arch/x86/kernel/mpparse_32.c
+++ b/arch/x86/kernel/mpparse_32.c
@@ -106,7 +106,8 @@ static struct mpc_config_translation *translation_table[MAX_MPC_ENTRY] __cpuinit
 
 static void __cpuinit MP_processor_info (struct mpc_config_processor *m)
 {
- 	int ver, apicid;
+	int ver, apicid, cpu;
+	cpumask_t tmp_map;
 	physid_mask_t phys_cpu;
  	
 	if (!(m->mpc_cpuflag & CPU_ENABLED)) {
@@ -199,6 +200,16 @@ static void __cpuinit MP_processor_info (struct mpc_config_processor *m)
 
 	cpu_set(num_processors, cpu_possible_map);
 	num_processors++;
+	cpus_complement(tmp_map, cpu_present_map);
+	cpu = first_cpu(tmp_map);
+
+	if (m->mpc_cpuflag & CPU_BOOTPROCESSOR)
+		/*
+		 * x86_bios_cpu_apicid is required to have processors listed
+		 * in same order as logical cpu numbers. Hence the first
+		 * entry is BSP, and so on.
+		 */
+		cpu = 0;
 
 	/*
 	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
@@ -221,12 +232,16 @@ static void __cpuinit MP_processor_info (struct mpc_config_processor *m)
 	}
 	/* are we being called early in kernel startup? */
 	if (x86_cpu_to_apicid_early_ptr) {
+		u16 *cpu_to_apicid = x86_cpu_to_apicid_early_ptr;
 		u16 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+
+		cpu_to_apicid[cpu] = m->mpc_apicid;
 		bios_cpu_apicid[num_processors - 1] = m->mpc_apicid;
 	} else {
-		int cpu = num_processors - 1;
+		per_cpu(x86_cpu_to_apicid, cpu) = m->mpc_apicid;
 		per_cpu(x86_bios_cpu_apicid, cpu) = m->mpc_apicid;
 	}
+	cpu_set(cpu, cpu_present_map);
 }
 
 static void __init MP_bus_info (struct mpc_config_bus *m)
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index bf5c9e9..2fea910 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -525,16 +525,6 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 #endif	/* WAKE_SECONDARY_VIA_INIT */
 
 extern cpumask_t cpu_initialized;
-static inline int alloc_cpu_id(void)
-{
-	cpumask_t	tmp_map;
-	int cpu;
-	cpus_complement(tmp_map, cpu_present_map);
-	cpu = first_cpu(tmp_map);
-	if (cpu >= NR_CPUS)
-		return -ENODEV;
-	return cpu;
-}
 
 #ifdef CONFIG_HOTPLUG_CPU
 static struct task_struct * __cpuinitdata cpu_idle_tasks[NR_CPUS];
@@ -605,7 +595,6 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 
 	irq_ctx_init(cpu);
 
-	per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 	/*
 	 * This grunge runs the startup process for
 	 * the targeted processor.
@@ -666,10 +655,8 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 		cpu_clear(cpu, cpu_callout_map); /* was set here (do_boot_cpu()) */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
 		cpu_clear(cpu, cpu_possible_map);
+		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 		cpucount--;
-	} else {
-		per_cpu(x86_cpu_to_apicid, cpu) = apicid;
-		cpu_set(cpu, cpu_present_map);
 	}
 
 	/* mark "stuck" area as not stuck */
@@ -745,6 +732,7 @@ EXPORT_SYMBOL(xquad_portio);
 static void __init disable_smp(void)
 {
 	cpu_possible_map = cpumask_of_cpu(0);
+	cpu_present_map = cpumask_of_cpu(0);
 	smpboot_clear_io_apic_irqs();
 	phys_cpu_present_map = physid_mask_of_physid(0);
 	map_cpu_to_logical_apicid();
@@ -825,7 +813,6 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 
 	boot_cpu_physical_apicid = GET_APIC_ID(apic_read(APIC_ID));
 	boot_cpu_logical_apicid = logical_smp_processor_id();
-	per_cpu(x86_cpu_to_apicid, 0) = boot_cpu_physical_apicid;
 
 	current_thread_info()->cpu = 0;
 
@@ -866,8 +853,11 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 			continue;
 		if (max_cpus <= cpucount+1)
 			continue;
-
-		if (((cpu = alloc_cpu_id()) <= 0) || do_boot_cpu(apicid, cpu))
+		/* Utterly temporary */
+		for (cpu = 0; cpu < NR_CPUS; cpu++)
+			if (per_cpu(x86_cpu_to_apicid, cpu) == apicid)
+				break;
+		if (do_boot_cpu(apicid, cpu))
 			printk("CPU #%d not responding - cannot use it.\n",
 								apicid);
 		else
-- 
1.5.0.6

