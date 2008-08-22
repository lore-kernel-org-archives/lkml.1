Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbYHVKxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbYHVKxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYHVKwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:52:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15428 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbYHVKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:52:05 -0400
X-IronPort-AV: E=Sophos;i="4.32,251,1217822400"; 
   d="scan'208";a="16925827"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/5] x86:  Separate generic cpu disabling code from APIC writes in cpu_disable
Date: Fri, 22 Aug 2008 11:52:14 +0100
Message-Id: <1219402335-29773-4-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1219402335-29773-3-git-send-email-alex.nixon@citrix.com>
References: <>
 <1219402335-29773-1-git-send-email-alex.nixon@citrix.com>
 <1219402335-29773-2-git-send-email-alex.nixon@citrix.com>
 <1219402335-29773-3-git-send-email-alex.nixon@citrix.com>
X-OriginalArrivalTime: 22 Aug 2008 10:51:59.0727 (UTC) FILETIME=[1A4CDFF0:01C90445]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows paravirt implementations of cpu_disable to share the cpu_disable_common code, without having to take on board APIC writes, which may not be appropriate.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |   40 +++++++++++++++++++++++-----------------
 include/asm-x86/smp.h     |    1 +
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58d8c6c..acac8df 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1343,25 +1343,9 @@ static void __ref remove_cpu_from_maps(int cpu)
 	numa_remove_cpu(cpu);
 }
 
-int native_cpu_disable(void)
+void cpu_disable_common(void)
 {
 	int cpu = smp_processor_id();
-
-	/*
-	 * Perhaps use cpufreq to drop frequency, but that could go
-	 * into generic code.
-	 *
-	 * We won't take down the boot processor on i386 due to some
-	 * interrupts only being able to be serviced by the BSP.
-	 * Especially so if we're not using an IOAPIC	-zwane
-	 */
-	if (cpu == 0)
-		return -EBUSY;
-
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		stop_apic_nmi_watchdog(NULL);
-	clear_local_APIC();
-
 	/*
 	 * HACK:
 	 * Allow any queued timer interrupts to get serviced
@@ -1379,6 +1363,28 @@ int native_cpu_disable(void)
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs(cpu_online_map);
+}
+
+int native_cpu_disable(void)
+{
+	int cpu = smp_processor_id();
+
+	/*
+	 * Perhaps use cpufreq to drop frequency, but that could go
+	 * into generic code.
+	 *
+	 * We won't take down the boot processor on i386 due to some
+	 * interrupts only being able to be serviced by the BSP.
+	 * Especially so if we're not using an IOAPIC	-zwane
+	 */
+	if (cpu == 0)
+		return -EBUSY;
+
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		stop_apic_nmi_watchdog(NULL);
+	clear_local_APIC();
+
+	cpu_disable_common();
 	return 0;
 }
 
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 95b28c1..e0ac06a 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -128,6 +128,7 @@ static inline void arch_send_call_function_ipi(cpumask_t mask)
 	smp_ops.send_call_func_ipi(mask);
 }
 
+void cpu_disable_common(void);
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
-- 
1.5.4.3

