Return-Path: <linux-kernel-owner+w=401wt.eu-S1764627AbYCSULl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764627AbYCSULl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbYCSTir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167AbYCSTid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:33 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 49/79] [PATCH] get rid of commenced mask.
Date: Wed, 19 Mar 2008 14:25:44 -0300
Message-Id: <12059477974089-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477922945-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

As we now boot cpus from cpu_up, we don't need it.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 978e137..c30abed 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -59,8 +59,6 @@
 #include <asm/vmi.h>
 #include <asm/mtrr.h>
 
-static cpumask_t smp_commenced_mask;
-
 /* which logical CPU number maps to which CPU (physical APIC ID) */
 u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata =
 			{ [0 ... NR_CPUS-1] = BAD_APICID };
@@ -180,8 +178,6 @@ static void __cpuinit start_secondary(void *unused)
 	cpu_init();
 	preempt_disable();
 	smp_callin();
-	while (!cpu_isset(smp_processor_id(), smp_commenced_mask))
-		cpu_relax();
 
 	/* otherwise gcc will move up smp_processor_id before the cpu_init */
 	barrier();
@@ -667,7 +663,6 @@ void cpu_exit_clear(void)
 	cpu_clear(cpu, cpu_callout_map);
 	cpu_clear(cpu, cpu_callin_map);
 
-	cpu_clear(cpu, smp_commenced_mask);
 	unmap_cpu_to_logical_apicid(cpu);
 }
 #endif
@@ -827,7 +822,6 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	nmi_watchdog_default();
-	smp_commenced_mask = cpumask_of_cpu(0);
 	cpu_callin_map = cpumask_of_cpu(0);
 	mb();
 	smp_boot_cpus(max_cpus);
@@ -869,8 +863,6 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 		return -EIO;
 	}
 
-	/* Unleash the CPU! */
-	cpu_set(cpu, smp_commenced_mask);
 
 	/*
 	 * Check TSC synchronization with the AP (keep irqs disabled
-- 
1.5.0.6

