Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbYCSUTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbYCSUTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbYCSTjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbYCSTi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:57 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 48/79] [PATCH] boot cpus from cpu_up, instead of prepare_cpus
Date: Wed, 19 Mar 2008 14:25:43 -0300
Message-Id: <12059477922945-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477881973-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

After all the infrastructure work, we're now prepared
to boot the cpus from cpu_up, and not from prepare_cpus.
So the difference between cold boot and hotplug is effectively
over, and the functions are used to the purposes they're meant to.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   48 +----------------------------------------
 1 files changed, 2 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 88ee655..978e137 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -670,6 +670,7 @@ void cpu_exit_clear(void)
 	cpu_clear(cpu, smp_commenced_mask);
 	unmap_cpu_to_logical_apicid(cpu);
 }
+#endif
 
 struct warm_boot_cpu_info {
 	struct completion *complete;
@@ -710,7 +711,6 @@ static void __cpuinit __smp_prepare_cpu(int cpu)
 		wait_for_completion(&done);
 	}
 }
-#endif
 
 static int boot_cpu_logical_apicid;
 /* Where the IO area was mapped on multiquad, always 0 otherwise */
@@ -790,8 +790,6 @@ static int __init smp_sanity_check(unsigned max_cpus)
  */
 static void __init smp_boot_cpus(unsigned int max_cpus)
 {
-	int apicid, cpu, bit, kicked;
-
 	/*
 	 * Setup boot CPU information
 	 */
@@ -819,39 +817,6 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 
 	setup_portio_remap();
 
-	/*
-	 * Scan the CPU present map and fire up the other CPUs via do_boot_cpu
-	 *
-	 * In clustered apic mode, phys_cpu_present_map is a constructed thus:
-	 * bits 0-3 are quad0, 4-7 are quad1, etc. A perverse twist on the 
-	 * clustered apic ID.
-	 */
-	Dprintk("CPU present map: %lx\n", physids_coerce(phys_cpu_present_map));
-
-	kicked = 1;
-	for (bit = 0; kicked < NR_CPUS && bit < MAX_APICS; bit++) {
-		apicid = cpu_present_to_apicid(bit);
-		/*
-		 * Don't even attempt to start the boot CPU!
-		 */
-		if ((apicid == boot_cpu_apicid) || (apicid == BAD_APICID))
-			continue;
-
-		if (!check_apicid_present(bit))
-			continue;
-		if (max_cpus <= cpus_weight(cpu_present_map))
-			continue;
-		/* Utterly temporary */
-		for (cpu = 0; cpu < NR_CPUS; cpu++)
-			if (per_cpu(x86_cpu_to_apicid, cpu) == apicid)
-				break;
-		if (do_boot_cpu(apicid, cpu))
-			printk("CPU #%d not responding - cannot use it.\n",
-								apicid);
-		else
-			++kicked;
-	}
-
 	smpboot_setup_io_apic();
 
 	setup_boot_clock();
@@ -895,17 +860,8 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	}
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
-#ifdef CONFIG_HOTPLUG_CPU
 
-	/*
-	 * We do warm boot only on cpus that had booted earlier
-	 * Otherwise cold boot is all handled from smp_boot_cpus().
-	 * cpu_callin_map is set during AP kickstart process. Its reset
-	 * when a cpu is taken offline from cpu_exit_clear().
-	 */
-	if (!cpu_isset(cpu, cpu_callin_map))
-		__smp_prepare_cpu(cpu);
-#endif
+	__smp_prepare_cpu(cpu);
 
 	/* In case one didn't come up */
 	if (!cpu_isset(cpu, cpu_callin_map)) {
-- 
1.5.0.6

