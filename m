Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZFOG5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZFOG5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZFOG5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:57:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57564 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZFOG47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:56:59 -0400
Message-ID: <4A35F112.7010506@cn.fujitsu.com>
Date: Mon, 15 Jun 2009 14:58:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpumask: use zalloc_cpumask_var() where possible
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open-coded zalloc_cpumask_var() and zalloc_cpumask_var_node().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 arch/x86/kernel/apic/io_apic.c      |    7 ++-----
 arch/x86/kernel/process.c           |    6 ++----
 arch/x86/kernel/smpboot.c           |    9 +++------
 drivers/acpi/processor_perflib.c    |    3 +--
 drivers/acpi/processor_throttling.c |    3 +--
 drivers/net/sfc/efx.c               |    3 +--
 drivers/oprofile/buffer_sync.c      |    3 +--
 kernel/trace/trace.c                |    7 ++-----
 virt/kvm/kvm_main.c                 |    3 +--
 9 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ef8d929..f125f7a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -215,17 +215,14 @@ static struct irq_cfg *get_one_free_irq_cfg(int node)
 
 	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
 	if (cfg) {
-		if (!alloc_cpumask_var_node(&cfg->domain, GFP_ATOMIC, node)) {
+		if (!zalloc_cpumask_var_node(&cfg->domain, GFP_ATOMIC, node)) {
 			kfree(cfg);
 			cfg = NULL;
-		} else if (!alloc_cpumask_var_node(&cfg->old_domain,
+		} else if (!zalloc_cpumask_var_node(&cfg->old_domain,
 							  GFP_ATOMIC, node)) {
 			free_cpumask_var(cfg->domain);
 			kfree(cfg);
 			cfg = NULL;
-		} else {
-			cpumask_clear(cfg->domain);
-			cpumask_clear(cfg->old_domain);
 		}
 	}
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index fc6e4b7..9b3e096 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -562,10 +562,8 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 void __init init_c1e_mask(void)
 {
 	/* If we're using c1e_idle, we need to allocate c1e_mask. */
-	if (pm_idle == c1e_idle) {
-		alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
-		cpumask_clear(c1e_mask);
-	}
+	if (pm_idle == c1e_idle)
+		zalloc_cpumask_var(&c1e_mask, GFP_KERNEL);
 }
 
 static int __init idle_setup(char *str)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index dee0f3d..bd9f290 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1059,12 +1059,9 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 #endif
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
-		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
-		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		alloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
-		cpumask_clear(per_cpu(cpu_core_map, i));
-		cpumask_clear(per_cpu(cpu_sibling_map, i));
-		cpumask_clear(cpu_data(i).llc_shared_map);
+		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 717c770..7579afe 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -513,7 +513,7 @@ int acpi_processor_preregister_performance(
 	struct acpi_processor *match_pr;
 	struct acpi_psd_package *match_pdomain;
 
-	if (!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&covered_cpus, GFP_KERNEL))
 		return -ENOMEM;
 
 	mutex_lock(&performance_mutex);
@@ -560,7 +560,6 @@ int acpi_processor_preregister_performance(
 	 * Now that we have _PSD data from all CPUs, lets setup P-state 
 	 * domain info.
 	 */
-	cpumask_clear(covered_cpus);
 	for_each_possible_cpu(i) {
 		pr = per_cpu(processors, i);
 		if (!pr)
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 2275437..423cf24 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -74,7 +74,7 @@ static int acpi_processor_update_tsd_coord(void)
 	struct acpi_tsd_package *pdomain, *match_pdomain;
 	struct acpi_processor_throttling *pthrottling, *match_pthrottling;
 
-	if (!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&covered_cpus, GFP_KERNEL))
 		return -ENOMEM;
 
 	/*
@@ -102,7 +102,6 @@ static int acpi_processor_update_tsd_coord(void)
 	if (retval)
 		goto err_ret;
 
-	cpumask_clear(covered_cpus);
 	for_each_possible_cpu(i) {
 		pr = per_cpu(processors, i);
 		if (!pr)
diff --git a/drivers/net/sfc/efx.c b/drivers/net/sfc/efx.c
index 7269a42..23ee983 100644
--- a/drivers/net/sfc/efx.c
+++ b/drivers/net/sfc/efx.c
@@ -894,13 +894,12 @@ static int efx_wanted_rx_queues(void)
 	int count;
 	int cpu;
 
-	if (!alloc_cpumask_var(&core_mask, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&core_mask, GFP_KERNEL)) {
 		printk(KERN_WARNING
 		       "efx.c: allocation failure, irq balancing hobbled\n");
 		return 1;
 	}
 
-	cpumask_clear(core_mask);
 	count = 0;
 	for_each_online_cpu(cpu) {
 		if (!cpumask_test_cpu(cpu, core_mask)) {
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 8574622..c9e2ae9 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -154,9 +154,8 @@ int sync_start(void)
 {
 	int err;
 
-	if (!alloc_cpumask_var(&marked_cpus, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&marked_cpus, GFP_KERNEL))
 		return -ENOMEM;
-	cpumask_clear(marked_cpus);
 
 	start_cpu_work();
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0f57f1b..95ba1bf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1919,11 +1919,9 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (current_trace)
 		*iter->trace = *current_trace;
 
-	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&iter->started, GFP_KERNEL))
 		goto fail;
 
-	cpumask_clear(iter->started);
-
 	if (current_trace && current_trace->print_max)
 		iter->tr = &max_tr;
 	else
@@ -4290,7 +4288,7 @@ __init static int tracer_alloc_buffers(void)
 	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
 
-	if (!alloc_cpumask_var(&tracing_reader_cpumask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&tracing_reader_cpumask, GFP_KERNEL))
 		goto out_free_tracing_cpumask;
 
 	/* To save memory, keep the ring buffer size to its minimum */
@@ -4301,7 +4299,6 @@ __init static int tracer_alloc_buffers(void)
 
 	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
 	cpumask_copy(tracing_cpumask, cpu_all_mask);
-	cpumask_clear(tracing_reader_cpumask);
 
 	/* TODO: make the number of buffers hot pluggable with CPUS */
 	global_trace.buffer = ring_buffer_alloc(ring_buf_size,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7645543..82498ed 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -742,8 +742,7 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	bool called = true;
 	struct kvm_vcpu *vcpu;
 
-	if (alloc_cpumask_var(&cpus, GFP_ATOMIC))
-		cpumask_clear(cpus);
+	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
 	me = get_cpu();
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-- 
1.5.4.rc3

