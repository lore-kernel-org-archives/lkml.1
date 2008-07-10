Return-Path: <linux-kernel-owner+w=401wt.eu-S1761407AbYGJSow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761407AbYGJSow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758450AbYGJSlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:20499 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502AbYGJSlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="11424604"
Message-Id: <20080710182238.774416000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:54 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 20/26] x64, x2apic/intr-remap: x2apic cluster mode support
Content-Disposition: inline; filename=x2apic_cluster.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x2apic cluster mode support.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/genx2apic_cluster.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ tree-x86/arch/x86/kernel/genx2apic_cluster.c	2008-07-10 09:52:27.000000000 -0700
@@ -0,0 +1,135 @@
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <asm/smp.h>
+#include <asm/ipi.h>
+#include <asm/genapic.h>
+
+DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
+
+/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
+
+static cpumask_t x2apic_target_cpus(void)
+{
+	return cpumask_of_cpu(0);
+}
+
+/*
+ * for now each logical cpu is in its own vector allocation domain.
+ */
+static cpumask_t x2apic_vector_allocation_domain(int cpu)
+{
+	cpumask_t domain = CPU_MASK_NONE;
+	cpu_set(cpu, domain);
+	return domain;
+}
+
+static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
+				   unsigned int dest)
+{
+	unsigned long cfg;
+
+	cfg = __prepare_ICR(0, vector, dest);
+
+	/*
+	 * send the IPI.
+	 */
+	x2apic_icr_write(cfg, apicid);
+}
+
+/*
+ * for now, we send the IPI's one by one in the cpumask.
+ * TBD: Based on the cpu mask, we can send the IPI's to the cluster group
+ * at once. We have 16 cpu's in a cluster. This will minimize IPI register
+ * writes.
+ */
+static void x2apic_send_IPI_mask(cpumask_t mask, int vector)
+{
+	unsigned long flags;
+	unsigned long query_cpu;
+
+	local_irq_save(flags);
+	for_each_cpu_mask(query_cpu, mask) {
+		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+				       vector, APIC_DEST_LOGICAL);
+	}
+	local_irq_restore(flags);
+}
+
+static void x2apic_send_IPI_allbutself(int vector)
+{
+	cpumask_t mask = cpu_online_map;
+
+	cpu_clear(smp_processor_id(), mask);
+
+	if (!cpus_empty(mask))
+		x2apic_send_IPI_mask(mask, vector);
+}
+
+static void x2apic_send_IPI_all(int vector)
+{
+	x2apic_send_IPI_mask(cpu_online_map, vector);
+}
+
+static int x2apic_apic_id_registered(void)
+{
+	return 1;
+}
+
+static unsigned int x2apic_cpu_mask_to_apicid(cpumask_t cpumask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	cpu = first_cpu(cpumask);
+	if ((unsigned)cpu < NR_CPUS)
+		return per_cpu(x86_cpu_to_logical_apicid, cpu);
+	else
+		return BAD_APICID;
+}
+
+static unsigned int x2apic_read_id(void)
+{
+	return apic_read(APIC_ID);
+}
+
+static unsigned int phys_pkg_id(int index_msb)
+{
+	return x2apic_read_id() >> index_msb;
+}
+
+static void x2apic_send_IPI_self(int vector)
+{
+	apic_write(APIC_SELF_IPI, vector);
+}
+
+static void init_x2apic_ldr(void)
+{
+	int cpu = smp_processor_id();
+
+	per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
+	return;
+}
+
+struct genapic apic_x2apic_cluster = {
+	.name = "cluster x2apic",
+	.int_delivery_mode = dest_LowestPrio,
+	.int_dest_mode = (APIC_DEST_LOGICAL != 0),
+	.target_cpus = x2apic_target_cpus,
+	.vector_allocation_domain = x2apic_vector_allocation_domain,
+	.apic_id_registered = x2apic_apic_id_registered,
+	.init_apic_ldr = init_x2apic_ldr,
+	.send_IPI_all = x2apic_send_IPI_all,
+	.send_IPI_allbutself = x2apic_send_IPI_allbutself,
+	.send_IPI_mask = x2apic_send_IPI_mask,
+	.send_IPI_self = x2apic_send_IPI_self,
+	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
+	.phys_pkg_id = phys_pkg_id,
+	.read_apic_id = x2apic_read_id,
+};
Index: tree-x86/arch/x86/kernel/Makefile
===================================================================
--- tree-x86.orig/arch/x86/kernel/Makefile	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/Makefile	2008-07-10 09:52:27.000000000 -0700
@@ -104,6 +104,7 @@
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
         obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_uv_x.o tlb_uv.o
+        obj-y				+= genx2apic_cluster.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
         obj-$(CONFIG_AUDIT)		+= audit_64.o
 
Index: tree-x86/arch/x86/kernel/genapic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/genapic_64.c	2008-07-10 09:52:24.000000000 -0700
+++ tree-x86/arch/x86/kernel/genapic_64.c	2008-07-10 09:52:27.000000000 -0700
@@ -38,6 +38,8 @@
 {
 	if (uv_system_type == UV_NON_UNIQUE_APIC)
 		genapic = &apic_x2apic_uv_x;
+	else if (cpu_has_x2apic && intr_remapping_enabled)
+		genapic = &apic_x2apic_cluster;
 	else
 #ifdef CONFIG_ACPI
 	/*
Index: tree-x86/include/asm-x86/genapic_64.h
===================================================================
--- tree-x86.orig/include/asm-x86/genapic_64.h	2008-07-10 09:52:24.000000000 -0700
+++ tree-x86/include/asm-x86/genapic_64.h	2008-07-10 09:52:27.000000000 -0700
@@ -35,6 +35,7 @@
 
 extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
+extern struct genapic apic_x2apic_cluster;
 extern int acpi_madt_oem_check(char *, char *);
 
 extern void apic_send_IPI_self(int vector);

-- 

