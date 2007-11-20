Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbXKTBSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbXKTBSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbXKTBNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:49 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49845 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753954AbXKTBNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:35 -0500
Message-Id: <20071120011335.036003167@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:46 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 14/45] cpu alloc: ACPI cstate handling conversion
Content-Disposition: inline; filename=0022-cpu-alloc-ACPI-cstate-handling-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 arch/x86/kernel/acpi/cstate.c              |    9 +++++----
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    7 ++++---
 drivers/acpi/processor_perflib.c           |    4 ++--
 3 files changed, 11 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/cstate.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/cstate.c	2007-11-15 21:18:09.238904115 -0800
+++ linux-2.6/arch/x86/kernel/acpi/cstate.c	2007-11-15 21:25:30.499154221 -0800
@@ -87,7 +87,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 	if (reg->bit_offset != NATIVE_CSTATE_BEYOND_HALT)
 		return -1;
 
-	percpu_entry = per_cpu_ptr(cpu_cstate_entry, cpu);
+	percpu_entry = CPU_PTR(cpu_cstate_entry, cpu);
 	percpu_entry->states[cx->index].eax = 0;
 	percpu_entry->states[cx->index].ecx = 0;
 
@@ -138,7 +138,7 @@ void acpi_processor_ffh_cstate_enter(str
 	unsigned int cpu = smp_processor_id();
 	struct cstate_entry *percpu_entry;
 
-	percpu_entry = per_cpu_ptr(cpu_cstate_entry, cpu);
+	percpu_entry = CPU_PTR(cpu_cstate_entry, cpu);
 	mwait_idle_with_hints(percpu_entry->states[cx->index].eax,
 	                      percpu_entry->states[cx->index].ecx);
 }
@@ -150,13 +150,14 @@ static int __init ffh_cstate_init(void)
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
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2007-11-15 21:18:09.246904080 -0800
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2007-11-15 21:25:30.499154221 -0800
@@ -513,7 +513,8 @@ static int __init acpi_cpufreq_early_ini
 {
 	dprintk("acpi_cpufreq_early_init\n");
 
-	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
+	acpi_perf_data = CPU_ALLOC(struct acpi_processor_performance,
+						GFP_KERNEL|__GFP_ZERO);
 	if (!acpi_perf_data) {
 		dprintk("Memory allocation error for acpi_perf_data.\n");
 		return -ENOMEM;
@@ -569,7 +570,7 @@ static int acpi_cpufreq_cpu_init(struct 
 	if (!data)
 		return -ENOMEM;
 
-	data->acpi_data = percpu_ptr(acpi_perf_data, cpu);
+	data->acpi_data = CPU_PTR(acpi_perf_data, cpu);
 	drv_data[cpu] = data;
 
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC))
@@ -782,7 +783,7 @@ static void __exit acpi_cpufreq_exit(voi
 
 	cpufreq_unregister_driver(&acpi_cpufreq_driver);
 
-	free_percpu(acpi_perf_data);
+	CPU_FREE(acpi_perf_data);
 
 	return;
 }
Index: linux-2.6/drivers/acpi/processor_perflib.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_perflib.c	2007-11-15 21:18:09.254904773 -0800
+++ linux-2.6/drivers/acpi/processor_perflib.c	2007-11-15 21:25:30.499154221 -0800
@@ -567,12 +567,12 @@ int acpi_processor_preregister_performan
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
