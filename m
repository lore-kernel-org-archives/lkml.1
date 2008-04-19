Return-Path: <linux-kernel-owner+w=401wt.eu-S1762181AbYDSPIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762181AbYDSPIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbYDSPHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:07:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11069 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762210AbYDSPHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=Ia+SimzuAGC8voRDjqXSZOl92tM4WESEeTbfk3bkb+6ZgU5bxcKV00HBuLorMz7GvPgEozg4lPxzCOlBIREYlsD7AIWRIpwU4e6G0AM3ffQ/zv64odSK3pahbWSME4SKHGgaJnRTzPhjql0oeliZcjej42LbuZUmrY0rvPstWYs=
References: <20080419145510.150338641@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:17 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 07/10] x86: use cpumask function for present, possible, and online cpus
Content-Disposition: inline; filename=x86-use-cpumask-functions.patch
Message-ID: <480a0a98.12da600a.609a.541a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_online(), cpu_present(), for_each_possible_cpu(), num_possible_cpus()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/genapic_64.c        |    2 +-
 arch/x86/kernel/smpboot.c           |    4 ++--
 arch/x86/kernel/tlb_64.c            |    4 ++--
 arch/x86/mach-voyager/voyager_smp.c |   10 +++++-----
 arch/x86/xen/smp.c                  |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

Index: 2.6-git/arch/x86/mach-voyager/voyager_smp.c
===================================================================
--- 2.6-git.orig/arch/x86/mach-voyager/voyager_smp.c
+++ 2.6-git/arch/x86/mach-voyager/voyager_smp.c
@@ -115,7 +115,7 @@ static inline void send_QIC_CPI(__u32 cp
 	for_each_online_cpu(cpu) {
 		if (cpuset & (1 << cpu)) {
 #ifdef VOYAGER_DEBUG
-			if (!cpu_isset(cpu, cpu_online_map))
+			if (!cpu_online(cpu))
 				VDEBUG(("CPU%d sending cpi %d to CPU%d not in "
 					"cpu_online_map\n",
 					hard_smp_processor_id(), cpi, cpu));
@@ -702,9 +702,9 @@ void __init smp_boot_cpus(void)
 	 * Code added from smpboot.c */
 	{
 		unsigned long bogosum = 0;
-		for (i = 0; i < NR_CPUS; i++)
-			if (cpu_isset(i, cpu_online_map))
-				bogosum += cpu_data(i).loops_per_jiffy;
+
+		for_each_online_cpu(i)
+			bogosum += cpu_data(i).loops_per_jiffy;
 		printk(KERN_INFO "Total of %d processors activated "
 		       "(%lu.%02lu BogoMIPS).\n",
 		       cpucount + 1, bogosum / (500000 / HZ),
@@ -1857,7 +1857,7 @@ static int __cpuinit voyager_cpu_up(unsi
 		return -EIO;
 	/* Unleash the CPU! */
 	cpu_set(cpu, smp_commenced_mask);
-	while (!cpu_isset(cpu, cpu_online_map))
+	while (!cpu_online(cpu))
 		mb();
 	return 0;
 }
Index: 2.6-git/arch/x86/kernel/smpboot.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/smpboot.c
+++ 2.6-git/arch/x86/kernel/smpboot.c
@@ -1047,7 +1047,7 @@ int __cpuinit native_cpu_up(unsigned int
 	check_tsc_sync_source(cpu);
 	local_irq_restore(flags);
 
-	while (!cpu_isset(cpu, cpu_online_map)) {
+	while (!cpu_online(cpu)) {
 		cpu_relax();
 		touch_nmi_watchdog();
 	}
@@ -1157,7 +1157,7 @@ static void __init smp_cpu_index_default
 	int i;
 	struct cpuinfo_x86 *c;
 
-	for_each_cpu_mask(i, cpu_possible_map) {
+	for_each_possible_cpu(i) {
 		c = &cpu_data(i);
 		/* mark all to hotplug */
 		c->cpu_index = NR_CPUS;
Index: 2.6-git/arch/x86/kernel/genapic_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/genapic_64.c
+++ 2.6-git/arch/x86/kernel/genapic_64.c
@@ -51,7 +51,7 @@ void __init setup_apic_routing(void)
 	else
 #endif
 
-	if (cpus_weight(cpu_possible_map) <= 8)
+	if (num_possible_cpus() <= 8)
 		genapic = &apic_flat;
 	else
 		genapic = &apic_physflat;
Index: 2.6-git/arch/x86/kernel/tlb_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/tlb_64.c
+++ 2.6-git/arch/x86/kernel/tlb_64.c
@@ -195,9 +195,9 @@ int __cpuinit init_smp_flush(void)
 {
 	int i;
 
-	for_each_cpu_mask(i, cpu_possible_map) {
+	for_each_possible_cpu(i)
 		spin_lock_init(&per_cpu(flush_state, i).tlbstate_lock);
-	}
+
 	return 0;
 }
 core_initcall(init_smp_flush);
Index: 2.6-git/arch/x86/xen/smp.c
===================================================================
--- 2.6-git.orig/arch/x86/xen/smp.c
+++ 2.6-git/arch/x86/xen/smp.c
@@ -183,7 +183,7 @@ void __init xen_smp_prepare_cpus(unsigne
 
 	/* Restrict the possible_map according to max_cpus. */
 	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
-		for (cpu = NR_CPUS-1; !cpu_isset(cpu, cpu_possible_map); cpu--)
+		for (cpu = NR_CPUS - 1; !cpu_possible(cpu); cpu--)
 			continue;
 		cpu_clear(cpu, cpu_possible_map);
 	}

-- 
