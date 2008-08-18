Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYHRQuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYHRQuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbYHRQp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:28022 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYHRQpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=akmAdYaDtzL67zFO1Ia2nAzkPvb9kF42wimWm5q1GkD7E/XjLWx3FdTxIuoXlQl53L
         wAMA3hYFxmc6EtYqu8hB2h/o3rHDe+JTLJLNvvUqKbggowD0N9hiAa1qoiN3i538TkNl
         SDuCWvzSnJ0iP8wwXVxp8lOdtsCa5rPoorT9I=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 09/15] x86: apic - generic_processor_info
Date: Mon, 18 Aug 2008 20:45:57 +0400
Message-Id: <00457651ed2e64054e61fd982cf29baef19f8ad0.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- use physid_set instead of phys_cpu and physids_or
- set phys_cpu_present_map bit AFTER check for allowed
  number of processors
- add checking for APIC valid version in 64bit mode
  (mostly not needed but added for merging purpose)
- add apic_version definition for 64bit mode which
  is used now

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |   15 ++++++++-------
 arch/x86/kernel/apic_64.c |   41 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 3095bb7..c3a252b 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1480,7 +1480,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 {
 	int cpu;
 	cpumask_t tmp_map;
-	physid_mask_t phys_cpu;
 
 	/*
 	 * Validate version
@@ -1493,9 +1492,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	}
 	apic_version[apicid] = version;
 
-	phys_cpu = apicid_to_cpu_present(apicid);
-	physids_or(phys_cpu_present_map, phys_cpu_present_map, phys_cpu);
-
 	if (num_processors >= NR_CPUS) {
 		printk(KERN_WARNING "WARNING: NR_CPUS limit of %i reached."
 			"  Processor ignored.\n", NR_CPUS);
@@ -1512,17 +1508,19 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	cpus_complement(tmp_map, cpu_present_map);
 	cpu = first_cpu(tmp_map);
 
-	if (apicid == boot_cpu_physical_apicid)
+	physid_set(apicid, phys_cpu_present_map);
+	if (apicid == boot_cpu_physical_apicid) {
 		/*
 		 * x86_bios_cpu_apicid is required to have processors listed
 		 * in same order as logical cpu numbers. Hence the first
 		 * entry is BSP, and so on.
 		 */
 		cpu = 0;
-
+	}
 	if (apicid > max_physical_apicid)
 		max_physical_apicid = apicid;
 
+#ifdef CONFIG_X86_32
 	/*
 	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
 	 * but we need to work other dependencies like SMP_SUSPEND etc
@@ -1542,7 +1540,9 @@ void __cpuinit generic_processor_info(int apicid, int version)
 			def_to_bigsmp = 1;
 		}
 	}
-#ifdef CONFIG_SMP
+#endif
+
+#if defined(CONFIG_X86_SMP) || defined(CONFIG_X86_64)
 	/* are we being called early in kernel startup? */
 	if (early_per_cpu_ptr(x86_cpu_to_apicid)) {
 		u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
@@ -1555,6 +1555,7 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 	}
 #endif
+
 	cpu_set(cpu, cpu_possible_map);
 	cpu_set(cpu, cpu_present_map);
 }
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 0d96910..76c2077 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1215,6 +1215,8 @@ void __init init_apic_mappings(void)
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
  */
+int apic_version[MAX_APICS];
+
 int __init APIC_init_uniprocessor(void)
 {
 	if (disable_apic) {
@@ -1409,15 +1411,26 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	int cpu;
 	cpumask_t tmp_map;
 
+	/*
+	 * Validate version
+	 */
+	if (version == 0x0) {
+		printk(KERN_WARNING "BIOS bug, APIC version is 0 for CPU#%d! "
+				"fixing up to 0x10. (tell your hw vendor)\n",
+				version);
+		version = 0x10;
+	}
+	apic_version[apicid] = version;
+
 	if (num_processors >= NR_CPUS) {
 		printk(KERN_WARNING "WARNING: NR_CPUS limit of %i reached."
-		       " Processor ignored.\n", NR_CPUS);
+			"  Processor ignored.\n", NR_CPUS);
 		return;
 	}
 
 	if (num_processors >= maxcpus) {
 		printk(KERN_WARNING "WARNING: maxcpus limit of %i reached."
-		       " Processor ignored.\n", maxcpus);
+			" Processor ignored.\n", maxcpus);
 		return;
 	}
 
@@ -1437,6 +1450,29 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	if (apicid > max_physical_apicid)
 		max_physical_apicid = apicid;
 
+#ifdef CONFIG_X86_32
+	/*
+	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
+	 * but we need to work other dependencies like SMP_SUSPEND etc
+	 * before this can be done without some confusion.
+	 * if (CPU_HOTPLUG_ENABLED || num_processors > 8)
+	 *       - Ashok Raj <ashok.raj@intel.com>
+	 */
+	if (max_physical_apicid >= 8) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			if (!APIC_XAPIC(version)) {
+				def_to_bigsmp = 0;
+				break;
+			}
+			/* If P4 and above fall through */
+		case X86_VENDOR_AMD:
+			def_to_bigsmp = 1;
+		}
+	}
+#endif
+
+#if defined(CONFIG_X86_SMP) || defined(CONFIG_X86_64)
 	/* are we being called early in kernel startup? */
 	if (early_per_cpu_ptr(x86_cpu_to_apicid)) {
 		u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
@@ -1448,6 +1484,7 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 		per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 	}
+#endif
 
 	cpu_set(cpu, cpu_possible_map);
 	cpu_set(cpu, cpu_present_map);
-- 
1.6.0.rc1.34.g0fe8c

