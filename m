Return-Path: <linux-kernel-owner+w=401wt.eu-S1765742AbYCSURA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765742AbYCSURA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbYCSTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbYCSTiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:55 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 34/79] [PATCH] move impress_friends and smp_check to cpus_done
Date: Wed, 19 Mar 2008 14:25:29 -0300
Message-Id: <12059477273855-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477234148-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

the cpu count is changed accordingly: now, what matters is
online cpus.
Also, we add those functions for x86_64

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |    4 ++--
 arch/x86/kernel/smpboot_32.c |   22 ++++++++++++----------
 arch/x86/kernel/smpboot_64.c |    8 ++++++++
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ddb94ef..6978f1b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -114,7 +114,7 @@ void smp_checks(void)
 	 * approved Athlon
 	 */
 	if (tainted & TAINT_UNSAFE_SMP) {
-		if (cpus_weight(cpu_present_map))
+		if (num_online_cpus())
 			printk(KERN_INFO "WARNING: This combination of AMD"
 				"processors is not suitable for SMP.\n");
 		else
@@ -258,7 +258,7 @@ void impress_friends(void)
 			bogosum += cpu_data(cpu).loops_per_jiffy;
 	printk(KERN_INFO
 		"Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
-		cpus_weight(cpu_present_map),
+		num_online_cpus(),
 		bogosum/(500000/HZ),
 		(bogosum/(5000/HZ))%100);
 
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 361851c..1736404 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -788,8 +788,6 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	return 0;
 }
 
-extern void impress_friends(void);
-extern void smp_checks(void);
 /*
  * Cycle through the processors sending APIC IPIs to boot each.
  */
@@ -858,14 +856,6 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 	}
 
 	/*
-	 * Cleanup possible dangling ends...
-	 */
-	smpboot_restore_warm_reset_vector();
-
-	impress_friends();
-
-	smp_checks();
-	/*
 	 * construct cpu_sibling_map, so that we can tell sibling CPUs
 	 * efficiently.
 	 */
@@ -959,8 +949,20 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	return 0;
 }
 
+extern void impress_friends(void);
+extern void smp_checks(void);
+
 void __init native_smp_cpus_done(unsigned int max_cpus)
 {
+	/*
+	 * Cleanup possible dangling ends...
+	 */
+	smpboot_restore_warm_reset_vector();
+
+	Dprintk("Boot done.\n");
+
+	impress_friends();
+	smp_checks();
 #ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
 #endif
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index a9cc911..c3e770b 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -824,12 +824,20 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	return err;
 }
 
+extern void impress_friends(void);
+extern void smp_checks(void);
+
 /*
  * Finish the SMP boot.
  */
 void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 	smp_cleanup_boot();
+
+	Dprintk("Boot done.\n");
+
+	impress_friends();
+	smp_checks();
 	setup_ioapic_dest();
 	check_nmi_watchdog();
 }
-- 
1.5.0.6

