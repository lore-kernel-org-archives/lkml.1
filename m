Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYLPE1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYLPE1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 23:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYLPE0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 23:26:50 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49017 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751584AbYLPE0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 23:26:49 -0500
Message-Id: <20081216042645.955131000@polaris-admin.engr.sgi.com>
References: <20081216042645.629941000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 20:26:47 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Ashok Raj <ashok.raj@intel.com>, Rusty Russell <rusty@rustycorp.com.au>
Subject: [PATCH 2/3] x86: use possible_cpus=NUM to extend the possible cpus allowed
Content-Disposition: inline; filename=x86:add-setup_possible_cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: allow adding additional cpus.

Use possible_cpus=NUM kernel parameter to extend the number of possible
cpus.

The ability to HOTPLUG ON cpus that are "possible" but not "present" is
dealt with in a later patch.

Based on tip/cpus4096 + .../rusty/linux-2.6-for-ingo.git/master +
	 x86-only-patches sent 12/15.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Rusty Russell <rusty@rustycorp.com.au>
---
 Documentation/cpu-hotplug.txt |   17 +++++++++--------
 arch/x86/kernel/apic.c        |   16 ++++++++++------
 arch/x86/kernel/smpboot.c     |   25 +++++++++++++++++++++----
 3 files changed, 40 insertions(+), 18 deletions(-)

--- linux-2.6-for-ingo.orig/Documentation/cpu-hotplug.txt
+++ linux-2.6-for-ingo/Documentation/cpu-hotplug.txt
@@ -50,16 +50,17 @@ additional_cpus=n (*)	Use this to limit 
   			cpu_possible_map = cpu_present_map + additional_cpus
 
 (*) Option valid only for following architectures
-- x86_64, ia64
+- ia64
 
-ia64 and x86_64 use the number of disabled local apics in ACPI tables MADT
-to determine the number of potentially hot-pluggable cpus. The implementation
-should only rely on this to count the # of cpus, but *MUST* not rely on the
-apicid values in those tables for disabled apics. In the event BIOS doesn't
-mark such hot-pluggable cpus as disabled entries, one could use this
-parameter "additional_cpus=x" to represent those cpus in the cpu_possible_map.
+ia64 uses the number of disabled local apics in ACPI tables MADT to
+determine the number of potentially hot-pluggable cpus. The implementation
+should only rely on this to count the # of cpus, but *MUST* not rely
+on the apicid values in those tables for disabled apics. In the event
+BIOS doesn't mark such hot-pluggable cpus as disabled entries, one could
+use this parameter "additional_cpus=x" to represent those cpus in the
+cpu_possible_map.
 
-possible_cpus=n		[s390 only] use this to set hotpluggable cpus.
+possible_cpus=n		[s390,x86_64] use this to set hotpluggable cpus.
 			This option sets possible_cpus bits in
 			cpu_possible_map. Thus keeping the numbers of bits set
 			constant even if the machine gets rebooted.
--- linux-2.6-for-ingo.orig/arch/x86/kernel/apic.c
+++ linux-2.6-for-ingo/arch/x86/kernel/apic.c
@@ -1832,7 +1832,6 @@ void disconnect_bsp_APIC(int virt_wire_s
 void __cpuinit generic_processor_info(int apicid, int version)
 {
 	int cpu;
-	cpumask_t tmp_map;
 
 	/*
 	 * Validate version
@@ -1845,15 +1844,20 @@ void __cpuinit generic_processor_info(in
 	}
 	apic_version[apicid] = version;
 
-	if (num_processors >= NR_CPUS) {
-		printk(KERN_WARNING "WARNING: NR_CPUS limit of %i reached."
-			"  Processor ignored.\n", NR_CPUS);
+	if (num_processors >= nr_cpu_ids) {
+		int max = nr_cpu_ids;
+		int thiscpu = max + disabled_cpus;
+
+		printk(KERN_WARNING
+			"ACPI: NR_CPUS/possible_cpus limit of %i reached."
+			"  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);
+
+		disabled_cpus++;
 		return;
 	}
 
 	num_processors++;
-	cpus_complement(tmp_map, cpu_present_map);
-	cpu = first_cpu(tmp_map);
+	cpu = cpumask_next_zero(-1, cpu_present_mask);
 
 	physid_set(apicid, phys_cpu_present_map);
 	if (apicid == boot_cpu_physical_apicid) {
--- linux-2.6-for-ingo.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6-for-ingo/arch/x86/kernel/smpboot.c
@@ -1254,6 +1254,15 @@ void __init native_smp_cpus_done(unsigne
 	check_nmi_watchdog();
 }
 
+static int __initdata setup_possible_cpus = -1;
+static int __init _setup_possible_cpus(char *str)
+{
+	get_option(&str, &setup_possible_cpus);
+	return 0;
+}
+early_param("possible_cpus", _setup_possible_cpus);
+
+
 /*
  * cpu_possible_map should be static, it cannot change as cpu's
  * are onlined, or offlined. The reason is per-cpu data-structures
@@ -1266,7 +1275,7 @@ void __init native_smp_cpus_done(unsigne
  *
  * Three ways to find out the number of additional hotplug CPUs:
  * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
- * - The user can overwrite it with additional_cpus=NUM
+ * - The user can overwrite it with possible_cpus=NUM
  * - Otherwise don't reserve additional CPUs.
  * We do this because additional CPUs waste a lot of memory.
  * -AK
@@ -1279,9 +1288,17 @@ __init void prefill_possible_map(void)
 	if (!num_processors)
 		num_processors = 1;
 
-	possible = num_processors + disabled_cpus;
-	if (possible > NR_CPUS)
-		possible = NR_CPUS;
+	if (setup_possible_cpus == -1)
+		possible = num_processors + disabled_cpus;
+	else
+		possible = setup_possible_cpus;
+
+	if (possible > CONFIG_NR_CPUS) {
+		printk(KERN_WARNING
+			"%d Processors exceeds NR_CPUS limit of %d\n",
+			possible, CONFIG_NR_CPUS);
+		possible = CONFIG_NR_CPUS;
+	}
 
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
 		possible, max_t(int, possible - num_processors, 0));

-- 
