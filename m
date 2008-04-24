Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbYDXS6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbYDXS6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757658AbYDXS6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:58:02 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:3321 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbYDXS6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:58:00 -0400
Date: Thu, 24 Apr 2008 12:57:58 -0600
From: Alex Chiang <achiang@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>, lenb@kernel.org,
       linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ia64: Provide ACPI fixup for
	/proc/cpuinfo/physical_id
Message-ID: <20080424185758.GE32553@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Luck, Tony" <tony.luck@intel.com>, lenb@kernel.org,
	linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080310222735.GA22619@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843ECCBFA9D@orsmsx424.amr.corp.intel.com> <20080319233140.GD16237@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843ECE13C6E@orsmsx424.amr.corp.intel.com> <20080326185912.GA30749@ldl.fc.hp.com> <20080421052450.GA24055@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843EC012664E0@orsmsx424.amr.corp.intel.com> <20080424184417.GA32553@ldl.fc.hp.com> <20080424185222.GC32553@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424185222.GC32553@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the checkpatch issues in this patch as well.

/ac

From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 2/2] ia64: Provide ACPI fixup for /proc/cpuinfo/physical_id

Legacy HP ia64 platforms currently cannot provide
/proc/cpuinfo/physical_id due to legacy SAL/PAL implementations.
However, that physical topology information can be obtained
via ACPI.

Provide an interface that gives ACPI one last chance to provide
physical_id for these legacy platforms. This logic only comes
into play iff:

	- ACPI actually provides slot information for the CPU
	- we lack a valid socket_id

Otherwise, we don't do anything. Since x86 uses the ACPI processor
driver as well, we provide an empty #define.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 arch/ia64/kernel/topology.c   |    7 +++++++
 drivers/acpi/processor_core.c |    8 ++++++++
 include/asm-ia64/cpu.h        |    1 +
 include/asm-ia64/topology.h   |    1 +
 include/asm-x86/topology.h    |    2 ++
 5 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index a2484fc..bb584b4 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -27,6 +27,13 @@
 
 static struct ia64_cpu *sysfs_cpus;
 
+void ia64_fix_socket_id(int num, u32 slot)
+{
+	if (cpu_data(num)->socket_id == -1)
+		cpu_data(num)->socket_id = slot;
+}
+EXPORT_SYMBOL_GPL(ia64_fix_socket_id);
+
 int arch_register_cpu(int num)
 {
 #if defined (CONFIG_ACPI) && defined (CONFIG_HOTPLUG_CPU)
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index a825b43..89578d4 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -612,6 +612,14 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
 		request_region(pr->throttling.address, 6, "ACPI CPU throttle");
 	}
 
+	/*
+	 * If ACPI describes a slot number for this CPU, we can use it
+	 * to fix a broken topology->physical_package_id.
+	 */
+	status = acpi_evaluate_object(pr->handle, "_SUN", NULL, &buffer);
+	if (ACPI_SUCCESS(status))
+		arch_fix_phys_package_id(pr->id, object.integer.value);
+
 	return 0;
 }
 
diff --git a/include/asm-ia64/cpu.h b/include/asm-ia64/cpu.h
index e87fa32..9ba5155 100644
--- a/include/asm-ia64/cpu.h
+++ b/include/asm-ia64/cpu.h
@@ -14,6 +14,7 @@ DECLARE_PER_CPU(struct ia64_cpu, cpu_devices);
 
 DECLARE_PER_CPU(int, cpu_state);
 
+extern void arch_fix_phys_package_id(int num, u32 slot);
 extern int arch_register_cpu(int num);
 #ifdef CONFIG_HOTPLUG_CPU
 extern void arch_unregister_cpu(int);
diff --git a/include/asm-ia64/topology.h b/include/asm-ia64/topology.h
index f2f72ef..8e68f0f 100644
--- a/include/asm-ia64/topology.h
+++ b/include/asm-ia64/topology.h
@@ -116,6 +116,7 @@ void build_cpu_to_node_map(void);
 #define smt_capable() 				(smp_num_siblings > 1)
 #endif
 
+#define arch_fix_phys_package_id(num, slot)	ia64_fix_socket_id(num, slot)
 #define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
 					CPU_MASK_ALL : \
 					node_to_cpumask(pcibus_to_node(bus)) \
diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index 2207326..efa3108 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -193,6 +193,8 @@ extern cpumask_t cpu_coregroup_map(int cpu);
 #define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #endif
 
+#define arch_fix_phys_package_id(num, slot)
+
 #ifdef CONFIG_SMP
 #define mc_capable()			(boot_cpu_data.x86_max_cores > 1)
 #define smt_capable()			(smp_num_siblings > 1)
-- 
1.5.3.1.g1e61

