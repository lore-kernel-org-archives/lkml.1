Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbYGOCiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbYGOCiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYGOCes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:48 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:16107 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761588AbYGOCeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:46 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 12/14] [IA64] Populate and use cpu_enabled_map
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Tony Luck <tony.luck@intel.com>
Date: Mon, 14 Jul 2008 20:34:45 -0600
Message-ID: <20080715023445.2528.16785.stgit@blender.achiang>
In-Reply-To: <20080715023344.2528.1836.stgit@blender.achiang>
References: <20080715023344.2528.1836.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify MADT local SAPIC parsing such that:

	- all present CPUs added to cpu_present_map
	- all enabled CPUs added to cpu_enabled_map

This change allows us to check during __cpu_up() if we should
actually bring up the CPU. That is, if a CPU is present, but not
enabled by firmware, we should not bring it up.

Contrariwise, by creating a sysfs interface for a disabled CPU,
we provide a hook that allows a user to interact with the CPU.

The most visible user interface change with this patch is that more
sysfs entries will appear in /sys/devices/system/cpu/cpuN/ on
multi-threaded systems with threads turned off.

The actual directories will be empty. A later patch in this series
will provide an example of using this new hook to provide a user
interface for disabled CPUs.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Tony Luck <tony.luck@intel.com>
---

 arch/ia64/kernel/acpi.c    |   16 +++++++++-------
 arch/ia64/kernel/smpboot.c |    7 +++++++
 include/asm-ia64/smp.h     |    1 +
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 43687cc..1b4b338 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -212,13 +212,14 @@ acpi_parse_lsapic(struct acpi_subtable_header * header, const unsigned long end)
 
 	/*Skip BAD_MADT_ENTRY check, as lsapic size could vary */
 
-	if (lsapic->lapic_flags & ACPI_MADT_ENABLED) {
 #ifdef CONFIG_SMP
-		smp_boot_data.cpu_phys_id[available_cpus] =
-		    (lsapic->id << 8) | lsapic->eid;
+	smp_boot_data.cpu_phys_id[available_cpus] =
+	    (lsapic->id << 8) | lsapic->eid;
+
+	smp_boot_data.cpu_enabled[available_cpus] =
+		lsapic->lapic_flags & ACPI_MADT_ENABLED;
 #endif
-		++available_cpus;
-	}
+	++available_cpus;
 
 	total_cpus++;
 	return 0;
@@ -872,8 +873,7 @@ int acpi_map_lsapic(acpi_handle handle, int *pcpu)
 
 	lsapic = (struct acpi_madt_local_sapic *)obj->buffer.pointer;
 
-	if ((lsapic->header.type != ACPI_MADT_TYPE_LOCAL_SAPIC) ||
-	    (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))) {
+	if (lsapic->header.type != ACPI_MADT_TYPE_LOCAL_SAPIC) {
 		kfree(buffer.pointer);
 		return -EINVAL;
 	}
@@ -892,6 +892,8 @@ int acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	acpi_map_cpu2node(handle, cpu, physid);
 
 	cpu_set(cpu, cpu_present_map);
+	if (lsapic->lapic_flags & ACPI_MADT_ENABLED)
+		cpu_set(cpu, cpu_enabled_map);
 	ia64_cpu_to_sapicid[cpu] = physid;
 
 	*pcpu = cpu;
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index d7ad42b..caa1a44 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -582,14 +582,18 @@ smp_build_cpu_map (void)
 
 	ia64_cpu_to_sapicid[0] = boot_cpu_id;
 	cpus_clear(cpu_present_map);
+	cpus_clear(cpu_enabled_map);
 	cpu_set(0, cpu_present_map);
 	cpu_set(0, cpu_possible_map);
+	cpu_set(0, cpu_enabled_map);
 	for (cpu = 1, i = 0; i < smp_boot_data.cpu_count; i++) {
 		sapicid = smp_boot_data.cpu_phys_id[i];
 		if (sapicid == boot_cpu_id)
 			continue;
 		cpu_set(cpu, cpu_present_map);
 		cpu_set(cpu, cpu_possible_map);
+		if (smp_boot_data.cpu_enabled[cpu])
+			cpu_set(cpu, cpu_enabled_map);
 		ia64_cpu_to_sapicid[cpu] = sapicid;
 		cpu++;
 	}
@@ -820,6 +824,9 @@ __cpu_up (unsigned int cpu)
 	if (cpu_isset(cpu, cpu_callin_map))
 		return -EINVAL;
 
+	if (!cpu_isset(cpu, cpu_enabled_map))
+		return -EINVAL;
+
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 	/* Processor goes to start_secondary(), sets online flag */
 	ret = do_boot_cpu(sapicid, cpu);
diff --git a/include/asm-ia64/smp.h b/include/asm-ia64/smp.h
index ec5f355..e5f60e8 100644
--- a/include/asm-ia64/smp.h
+++ b/include/asm-ia64/smp.h
@@ -55,6 +55,7 @@ extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 extern struct smp_boot_data {
 	int cpu_count;
 	int cpu_phys_id[NR_CPUS];
+	int cpu_enabled[NR_CPUS];
 } smp_boot_data __initdata;
 
 extern char no_int_routing __devinitdata;

