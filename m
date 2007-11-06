Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbXKFT4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbXKFT4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbXKFTwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:21 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52134 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755852AbXKFTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:01 -0500
Message-Id: <20071106195200.174230271@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:55 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 11/28] cpu alloc: ACPI cstate handling conversion
Content-Disposition: inline; filename=cpu_alloc_acpi
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/acpi/cstate.c              |   10 ++++++----
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    8 +++++---
 drivers/acpi/processor_perflib.c           |    5 +++--
 3 files changed, 14 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/cstate.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/cstate.c	2007-11-05 22:46:10.000000000 -0800
+++ linux-2.6/arch/x86/kernel/acpi/cstate.c	2007-11-06 09:58:17.000000000 -0800
@@ -15,6 +15,7 @@
 
 #include <acpi/processor.h>
 #include <asm/acpi.h>
+#include <linux/cpu_alloc.h>
 
 /*
  * Initialize bm_flags based on the CPU cache properties
@@ -87,7 +88,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 	if (reg->bit_offset != NATIVE_CSTATE_BEYOND_HALT)
 		return -1;
 
-	percpu_entry = per_cpu_ptr(cpu_cstate_entry, cpu);
+	percpu_entry = CPU_PTR(cpu_cstate_entry, cpu);
 	percpu_entry->states[cx->index].eax = 0;
 	percpu_entry->states[cx->index].ecx = 0;
 
@@ -138,7 +139,7 @@ void acpi_processor_ffh_cstate_enter(str
 	unsigned int cpu = smp_processor_id();
 	struct cstate_entry *percpu_entry;
 
-	percpu_entry = per_cpu_ptr(cpu_cstate_entry, cpu);
+	percpu_entry = CPU_PTR(cpu_cstate_entry, cpu);
 	mwait_idle_with_hints(percpu_entry->states[cx->index].eax,
 	                      percpu_entry->states[cx->index].ecx);
 }
@@ -150,13 +151,14 @@ static int __init ffh_cstate_init(void)
 	if (c->x86_vendor != X86_VENDOR_INTEL)
 		return -1;
 
-	cpu_cstate_entry = alloc_percpu(struct cstate_entry);
+	cpu_cstate_entry = CPU_ALLOC(struct cstate_entry,
+					GFP_KERNEL|__GFP_ZERO);
 	return 0;
 }
 
 static void __exit ffh_cstate_exit(void)
 {
-	free_percpu(cpu_cstate_entry);
+	CPU_FREE(cpu_cstate_entry);
 	cpu_cstate_entry = NULL;
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2007-11-05 22:46:10.000000000 -0800
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2007-11-06 09:58:17.000000000 -0800
@@ -36,6 +36,7 @@
 
 #include <linux/acpi.h>
 #include <acpi/processor.h>
+#include <linux/cpu_alloc.h>
 
 #include <asm/io.h>
 #include <asm/msr.h>
@@ -513,7 +514,8 @@ static int __init acpi_cpufreq_early_ini
 {
 	dprintk("acpi_cpufreq_early_init\n");
 
-	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
+	acpi_perf_data = CPU_ALLOC(struct acpi_processor_performance,
+						GFP_KERNEL|__GFP_ZERO);
 	if (!acpi_perf_data) {
 		dprintk("Memory allocation error for acpi_perf_data.\n");
 		return -ENOMEM;
@@ -569,7 +571,7 @@ static int acpi_cpufreq_cpu_init(struct 
 	if (!data)
 		return -ENOMEM;
 
-	data->acpi_data = percpu_ptr(acpi_perf_data, cpu);
+	data->acpi_data = CPU_PTR(acpi_perf_data, cpu);
 	drv_data[cpu] = data;
 
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC))
@@ -782,7 +784,7 @@ static void __exit acpi_cpufreq_exit(voi
 
 	cpufreq_unregister_driver(&acpi_cpufreq_driver);
 
-	free_percpu(acpi_perf_data);
+	CPU_FREE(acpi_perf_data);
 
 	return;
 }
Index: linux-2.6/drivers/acpi/processor_perflib.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_perflib.c	2007-11-05 22:46:10.000000000 -0800
+++ linux-2.6/drivers/acpi/processor_perflib.c	2007-11-06 09:58:46.000000000 -0800
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/cpufreq.h>
+#include <linux/cpu_alloc.h>
 
 #ifdef CONFIG_X86_ACPI_CPUFREQ_PROC_INTF
 #include <linux/proc_fs.h>
@@ -567,12 +568,12 @@ int acpi_processor_preregister_performan
 			continue;
 		}
 
-		if (!performance || !percpu_ptr(performance, i)) {
+		if (!performance || !CPU_PTR(performance, i)) {
 			retval = -EINVAL;
 			continue;
 		}
 
-		pr->performance = percpu_ptr(performance, i);
+		pr->performance = CPU_PTR(performance, i);
 		cpu_set(i, pr->performance->shared_cpu_map);
 		if (acpi_processor_get_psd(pr)) {
 			retval = -EINVAL;

-- 
