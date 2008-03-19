Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbYCSUN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbYCSUN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbYCSTiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194AbYCSTil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:41 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 32/79] [PATCH] allow user to impress friends.
Date: Wed, 19 Mar 2008 14:25:27 -0300
Message-Id: <1205947719906-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477143205-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Impressing friends is a very important thing.
Do it in a separate function to make it even more
explicit, and ease integration.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   20 ++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   17 ++---------------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a157a52..02427d1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -228,6 +228,26 @@ void __init smp_alloc_memory(void)
 }
 #endif
 
+void impress_friends(void)
+{
+	int cpu;
+	unsigned long bogosum = 0;
+	/*
+	 * Allow the user to impress friends.
+	 */
+	Dprintk("Before bogomips.\n");
+	for_each_possible_cpu(cpu)
+		if (cpu_isset(cpu, cpu_callout_map))
+			bogosum += cpu_data(cpu).loops_per_jiffy;
+	printk(KERN_INFO
+		"Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
+		cpus_weight(cpu_present_map),
+		bogosum/(500000/HZ),
+		(bogosum/(5000/HZ))%100);
+
+	Dprintk("Before bogocount - setting activated=1.\n");
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 void remove_siblinginfo(int cpu)
 {
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 5c4e85c..34493f8 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -790,13 +790,13 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	return 0;
 }
 
+extern void impress_friends(void);
 /*
  * Cycle through the processors sending APIC IPIs to boot each.
  */
 static void __init smp_boot_cpus(unsigned int max_cpus)
 {
 	int apicid, cpu, bit, kicked;
-	unsigned long bogosum = 0;
 
 	/*
 	 * Setup boot CPU information
@@ -863,20 +863,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 	 */
 	smpboot_restore_warm_reset_vector();
 
-	/*
-	 * Allow the user to impress friends.
-	 */
-	Dprintk("Before bogomips.\n");
-	for_each_possible_cpu(cpu)
-		if (cpu_isset(cpu, cpu_callout_map))
-			bogosum += cpu_data(cpu).loops_per_jiffy;
-	printk(KERN_INFO
-		"Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
-		cpus_weight(cpu_present_map),
-		bogosum/(500000/HZ),
-		(bogosum/(5000/HZ))%100);
-	
-	Dprintk("Before bogocount - setting activated=1.\n");
+	impress_friends();
 
 	if (smp_b_stepping)
 		printk(KERN_WARNING "WARNING: SMP operation may be unreliable with B stepping processors.\n");
-- 
1.5.0.6

