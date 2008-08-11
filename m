Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYHKVzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYHKVzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757229AbYHKVzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:55:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48085 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221AbYHKVzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:55:33 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5358"; a="5579773"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.org>,
       Max Krasnyansky <maxk@qualcomm.com>, lizf@cn.fujitsu.com,
       jeff.chua.linux@gmail.com
Subject: [PATCH] Resurect proper handling of maxcpus= kernel option (take 2)
Date: Mon, 11 Aug 2008 14:55:31 -0700
Message-Id: <1218491731-10673-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyansky <maxk@qualcomm.org>

For some reason we had two parsers registered for maxcpus=. One in init/main.c 
and another in arch/x86/smpboot.c. So I nuked the one in arch/x86.

Also 64-bit kernels used to handle maxcpus= as documented in
Documentation/cpu-hotplug.txt. CPUs with 'id > maxcpus' are initialized
but not booted. 32-bit version for some reason ignored them even though
all the infrastructure for booting them later is there.

In the current mainline both 64 and 32 bit versions are broken.
This patch restores the correct behaviour. I've tested x86_64 version on
4- and 8- way Core2 and 2-way Opteron based machines. Various config
combinations SMP, !SMP, CPU_HOTPLUG, !CPU_HOTPLUG.
Booted with maxcpus=1 and maxcpus=4, etc. Everything is working as expected.

So far we've received two reports from different people confirming that 32-bit 
version also works fine, both on dual core laptops and 16way server machines.

This version fixes visws breakage pointed out by Ingo.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
Cc: lizf@cn.fujitsu.com
Cc: jeff.chua.linux@gmail.com
---
 arch/x86/kernel/apic_32.c      |    8 --------
 arch/x86/kernel/apic_64.c      |    7 -------
 arch/x86/kernel/smpboot.c      |   14 --------------
 arch/x86/kernel/visws_quirks.c |    6 ++----
 4 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index d6c8983..71d49cc 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1454,8 +1454,6 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 	}
 }
 
-unsigned int __cpuinitdata maxcpus = NR_CPUS;
-
 void __cpuinit generic_processor_info(int apicid, int version)
 {
 	int cpu;
@@ -1482,12 +1480,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		return;
 	}
 
-	if (num_processors >= maxcpus) {
-		printk(KERN_WARNING "WARNING: maxcpus limit of %i reached."
-			" Processor ignored.\n", maxcpus);
-		return;
-	}
-
 	num_processors++;
 	cpus_complement(tmp_map, cpu_present_map);
 	cpu = first_cpu(tmp_map);
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 7f1f030..446c062 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -90,7 +90,6 @@ static unsigned long apic_phys;
 
 unsigned long mp_lapic_addr;
 
-unsigned int __cpuinitdata maxcpus = NR_CPUS;
 /*
  * Get the LAPIC version
  */
@@ -1062,12 +1061,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		return;
 	}
 
-	if (num_processors >= maxcpus) {
-		printk(KERN_WARNING "WARNING: maxcpus limit of %i reached."
-		       " Processor ignored.\n", maxcpus);
-		return;
-	}
-
 	num_processors++;
 	cpus_complement(tmp_map, cpu_present_map);
 	cpu = first_cpu(tmp_map);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3325127..4fcce79 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1370,17 +1370,3 @@ void __cpu_die(unsigned int cpu)
 	BUG();
 }
 #endif
-
-/*
- * If the BIOS enumerates physical processors before logical,
- * maxcpus=N at enumeration-time can be used to disable HT.
- */
-static int __init parse_maxcpus(char *arg)
-{
-	extern unsigned int maxcpus;
-
-	if (arg)
-		maxcpus = simple_strtoul(arg, NULL, 0);
-	return 0;
-}
-early_param("maxcpus", parse_maxcpus);
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 41e01b1..594ef47 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -184,8 +184,6 @@ static int __init visws_get_smp_config(unsigned int early)
 	return 1;
 }
 
-extern unsigned int __cpuinitdata maxcpus;
-
 /*
  * The Visual Workstation is Intel MP compliant in the hardware
  * sense, but it doesn't have a BIOS(-configuration table).
@@ -244,8 +242,8 @@ static int __init visws_find_smp_config(unsigned int reserve)
 		ncpus = CO_CPU_MAX;
 	}
 
-	if (ncpus > maxcpus)
-		ncpus = maxcpus;
+	if (ncpus > setup_max_cpus)
+		ncpus = setup_max_cpus;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	smp_found_config = 1;
-- 
1.5.5.1

