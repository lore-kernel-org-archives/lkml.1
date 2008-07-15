Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbYGOC5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbYGOC5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbYGOC47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:56:59 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:5065 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbYGOC46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:56:58 -0400
Date: Mon, 14 Jul 2008 20:56:56 -0600
From: Alex Chiang <achiang@hp.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: [PATCH 11/14] x86: Populate cpu_enabled_map
Message-ID: <20080715025656.GC15452@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-acpi@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715023344.2528.1836.stgit@blender.achiang>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate the cpu_enabled_map correctly.

Note that this patch does not actually make any decisions based
on the contents of the map.

However, as the map is presented via sysfs in:

	/sys/devices/system/cpu/

It should be populated correctly.

There will be a user-visible change under the above directory.
cpuN/ entries for firmware-disabled CPUs will now appear, whereas
before, they did not due to a check against ACPI_MADT_ENABLED.

The cpuN/ entries will be empty, and the online file in the
above directory will reflect which CPUs are actually schedulable.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---

 arch/x86/kernel/acpi/boot.c         |    7 +++++--
 arch/x86/kernel/apic_32.c           |    1 +
 arch/x86/kernel/apic_64.c           |    1 +
 arch/x86/kernel/smpboot.c           |    2 ++
 arch/x86/mach-voyager/voyager_smp.c |    2 ++
 arch/x86/xen/smp.c                  |    1 +
 6 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 33c5216..c6dc5da 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -559,8 +559,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 
 	lapic = (struct acpi_madt_local_apic *)obj->buffer.pointer;
 
-	if (lapic->header.type != ACPI_MADT_TYPE_LOCAL_APIC ||
-	    !(lapic->lapic_flags & ACPI_MADT_ENABLED)) {
+	if (lapic->header.type != ACPI_MADT_TYPE_LOCAL_APIC) {
 		kfree(buffer.pointer);
 		return -EINVAL;
 	}
@@ -584,6 +583,9 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 		return -EINVAL;
 	}
 
+	if (lapic->lapic_flags & ACPI_MADT_ENABLED)
+		cpu_set(cpu, cpu_enabled_map);
+
 	cpu = first_cpu(new_map);
 
 	*pcpu = cpu;
@@ -601,6 +603,7 @@ int acpi_unmap_lsapic(int cpu)
 {
 	per_cpu(x86_cpu_to_apicid, cpu) = -1;
 	cpu_clear(cpu, cpu_present_map);
+	cpu_clear(cpu, cpu_enabled_map);
 	num_processors--;
 
 	return (0);
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 4b99b1b..787699e 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1547,6 +1547,7 @@ void __cpuinit generic_processor_info(int apicid, int version)
 #endif
 	cpu_set(cpu, cpu_possible_map);
 	cpu_set(cpu, cpu_present_map);
+	cpu_set(cpu, cpu_enabled_map);
 }
 
 /*
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 0633cfd..ad21476 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1104,6 +1104,7 @@ void __cpuinit generic_processor_info(int apicid, int version)
 
 	cpu_set(cpu, cpu_possible_map);
 	cpu_set(cpu, cpu_present_map);
+	cpu_set(cpu, cpu_enabled_map);
 }
 
 /*
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3e1cece..3d378cf 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -997,6 +997,7 @@ do_rest:
 		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
 		cpu_clear(cpu, cpu_present_map);
+		cpu_clear(cpu, cpu_enabled_map);
 		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	}
 
@@ -1086,6 +1087,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 static __init void disable_smp(void)
 {
 	cpu_present_map = cpumask_of_cpu(0);
+	cpu_enabled_map = cpumask_of_cpu(0);
 	cpu_possible_map = cpumask_of_cpu(0);
 #ifdef CONFIG_X86_32
 	smpboot_clear_io_apic_irqs();
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 8acbf0c..8dee2b8 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -606,6 +606,7 @@ static void __init do_boot_cpu(__u8 cpu)
 		wmb();
 		cpu_set(cpu, cpu_callout_map);
 		cpu_set(cpu, cpu_present_map);
+		cpu_set(cpu, cpu_enabled_map);
 	} else {
 		printk("CPU%d FAILED TO BOOT: ", cpu);
 		if (*
@@ -1825,6 +1826,7 @@ static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 	cpu_set(smp_processor_id(), cpu_callout_map);
 	cpu_set(smp_processor_id(), cpu_possible_map);
 	cpu_set(smp_processor_id(), cpu_present_map);
+	cpu_set(smp_processor_id(), cpu_enabled_map);
 }
 
 static int __cpuinit voyager_cpu_up(unsigned int cpu)
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 94e6900..bc0a53d 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -209,6 +209,7 @@ void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 			panic("failed fork for CPU %d", cpu);
 
 		cpu_set(cpu, cpu_present_map);
+		cpu_set(cpu, cpu_enabled_map);
 	}
 
 	//init_xenbus_allowed_cpumask();
