Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbYHUSGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbYHUSGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbYHUSFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:05:05 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50420 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497AbYHUSFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:05:02 -0400
X-IronPort-AV: E=Sophos;i="4.32,246,1217822400"; 
   d="scan'208";a="16837667"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 6/7] x86:  Separate generic cpu disabling code from APIC writes in cpu_disable
Date: Thu, 21 Aug 2008 19:04:47 +0100
Message-Id: <1219341888-23191-6-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1219341888-23191-5-git-send-email-alex.nixon@citrix.com>
References: <>
 <1219341888-23191-1-git-send-email-alex.nixon@citrix.com>
 <1219341888-23191-2-git-send-email-alex.nixon@citrix.com>
 <1219341888-23191-3-git-send-email-alex.nixon@citrix.com>
 <1219341888-23191-4-git-send-email-alex.nixon@citrix.com>
 <1219341888-23191-5-git-send-email-alex.nixon@citrix.com>
X-OriginalArrivalTime: 21 Aug 2008 18:05:01.0381 (UTC) FILETIME=[6E28E750:01C903B8]
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
index 83e9591..ccb3b12 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1340,25 +1340,9 @@ static void __ref remove_cpu_from_maps(int cpu)
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
@@ -1376,6 +1360,28 @@ int native_cpu_disable(void)
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
index fd2a070..bff3fa6 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -109,6 +109,7 @@ static inline void arch_send_call_function_ipi(cpumask_t mask)
 	smp_ops.send_call_func_ipi(mask);
 }
 
+void cpu_disable_common(void);
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
-- 
1.5.4.3

