Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbYGJSqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbYGJSqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758727AbYGJSl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:28099 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbYGJSlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="409061787"
Message-Id: <20080710182239.492000000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:59 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 25/26] x64, x2apic/intr-remap: support for x2apic physical mode support
Content-Disposition: inline; filename=x2apic_physical.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x2apic Physical mode  support. By default we will use x2apic cluster mode.
x2apic physical mode can be selected using "x2apic_phys" boot parameter.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/Makefile
===================================================================
--- tree-x86.orig/arch/x86/kernel/Makefile	2008-07-10 09:52:27.000000000 -0700
+++ tree-x86/arch/x86/kernel/Makefile	2008-07-10 09:52:40.000000000 -0700
@@ -105,6 +105,7 @@
 ifeq ($(CONFIG_X86_64),y)
         obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_uv_x.o tlb_uv.o
         obj-y				+= genx2apic_cluster.o
+        obj-y				+= genx2apic_phys.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
         obj-$(CONFIG_AUDIT)		+= audit_64.o
 
Index: tree-x86/include/asm-x86/genapic_64.h
===================================================================
--- tree-x86.orig/include/asm-x86/genapic_64.h	2008-07-10 09:52:27.000000000 -0700
+++ tree-x86/include/asm-x86/genapic_64.h	2008-07-10 09:52:40.000000000 -0700
@@ -36,6 +36,7 @@
 extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
 extern struct genapic apic_x2apic_cluster;
+extern struct genapic apic_x2apic_phys;
 extern int acpi_madt_oem_check(char *, char *);
 
 extern void apic_send_IPI_self(int vector);
Index: tree-x86/arch/x86/kernel/genx2apic_phys.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ tree-x86/arch/x86/kernel/genx2apic_phys.c	2008-07-10 09:52:40.000000000 -0700
@@ -0,0 +1,122 @@
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
+
+/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
+
+static cpumask_t x2apic_target_cpus(void)
+{
+	return cpumask_of_cpu(0);
+}
+
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
+static void x2apic_send_IPI_mask(cpumask_t mask, int vector)
+{
+	unsigned long flags;
+	unsigned long query_cpu;
+
+	local_irq_save(flags);
+	for_each_cpu_mask(query_cpu, mask) {
+		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
+				       vector, APIC_DEST_PHYSICAL);
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
+		return per_cpu(x86_cpu_to_apicid, cpu);
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
+void x2apic_send_IPI_self(int vector)
+{
+	apic_write(APIC_SELF_IPI, vector);
+}
+
+void init_x2apic_ldr(void)
+{
+	return;
+}
+
+struct genapic apic_x2apic_phys = {
+	.name = "physical x2apic",
+	.int_delivery_mode = dest_Fixed,
+	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
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
Index: tree-x86/arch/x86/kernel/genapic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/genapic_64.c	2008-07-10 09:52:36.000000000 -0700
+++ tree-x86/arch/x86/kernel/genapic_64.c	2008-07-10 09:52:40.000000000 -0700
@@ -30,6 +30,15 @@
 
 struct genapic __read_mostly *genapic = &apic_flat;
 
+static int x2apic_phys = 0;
+
+static int set_x2apic_phys_mode(char *arg)
+{
+	x2apic_phys = 1;
+	return 0;
+}
+early_param("x2apic_phys", set_x2apic_phys_mode);
+
 static enum uv_system_type uv_system_type;
 
 /*
@@ -39,9 +48,12 @@
 {
 	if (uv_system_type == UV_NON_UNIQUE_APIC)
 		genapic = &apic_x2apic_uv_x;
-	else if (cpu_has_x2apic && intr_remapping_enabled)
-		genapic = &apic_x2apic_cluster;
-	else
+	else if (cpu_has_x2apic && intr_remapping_enabled) {
+		if (x2apic_phys)
+			genapic = &apic_x2apic_phys;
+		else
+			genapic = &apic_x2apic_cluster;
+	} else
 #ifdef CONFIG_ACPI
 	/*
 	 * Quirk: some x86_64 machines can only use physical APIC mode

-- 

