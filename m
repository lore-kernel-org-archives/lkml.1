Return-Path: <linux-kernel-owner+w=401wt.eu-S1764963AbYCSUMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764963AbYCSUMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbYCSTix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbYCSTij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:39 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 31/79] [PATCH] get rid of cpucount
Date: Wed, 19 Mar 2008 14:25:26 -0300
Message-Id: <12059477143205-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477102394-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

weighting a map will do.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 2fea910..5c4e85c 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -166,8 +166,6 @@ static void __cpuinit smp_callin(void)
 	cpu_set(cpuid, cpu_callin_map);
 }
 
-static int cpucount;
-
 /*
  * Activate a secondary processor.
  */
@@ -585,7 +583,6 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	/* start_eip had better be page-aligned! */
 	start_eip = setup_trampoline();
 
-	++cpucount;
 	alternatives_smp_switch(1);
 
 	/* So we see what's up   */
@@ -656,7 +653,6 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
 		cpu_clear(cpu, cpu_possible_map);
 		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
-		cpucount--;
 	}
 
 	/* mark "stuck" area as not stuck */
@@ -672,7 +668,6 @@ void cpu_exit_clear(void)
 
 	idle_task_exit();
 
-	cpucount --;
 	cpu_uninit();
 	irq_ctx_exit(cpu);
 
@@ -795,7 +790,6 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	return 0;
 }
 
-
 /*
  * Cycle through the processors sending APIC IPIs to boot each.
  */
@@ -851,7 +845,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 
 		if (!check_apicid_present(bit))
 			continue;
-		if (max_cpus <= cpucount+1)
+		if (max_cpus <= cpus_weight(cpu_present_map))
 			continue;
 		/* Utterly temporary */
 		for (cpu = 0; cpu < NR_CPUS; cpu++)
@@ -878,7 +872,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 			bogosum += cpu_data(cpu).loops_per_jiffy;
 	printk(KERN_INFO
 		"Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
-		cpucount+1,
+		cpus_weight(cpu_present_map),
 		bogosum/(500000/HZ),
 		(bogosum/(5000/HZ))%100);
 	
@@ -892,7 +886,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 	 * approved Athlon
 	 */
 	if (tainted & TAINT_UNSAFE_SMP) {
-		if (cpucount)
+		if (cpus_weight(cpu_present_map))
 			printk (KERN_INFO "WARNING: This combination of AMD processors is not suitable for SMP.\n");
 		else
 			tainted &= ~TAINT_UNSAFE_SMP;
-- 
1.5.0.6

