Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbYGOWqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbYGOWqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbYGOWp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:45:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38167 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758918AbYGOWpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:45:53 -0400
Date: Wed, 16 Jul 2008 00:45:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] optimizations for 4096 CPUs, for v2.6.27
Message-ID: <20080715224539.GA22776@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest "4096 CPUs" git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git cpus4096

this includes performance and stack footprint optimizations for crazy 
SGI systems with 4096 CPUs.

The tree-wide scope is relatively large because automatic conversion to 
the faster for_each_cpu_*_nr() APIs was not possible, it had to be done 
one by one in the case where it was safe to iterate to nr_cpu_ids.

Thanks,

	Ingo

------------------>
Alexander van Heukelum (1):
      cpumask: make for_each_cpu_mask a bit smaller

Ingo Molnar (1):
      Revert "cpumask: introduce new APIs"

Mike Travis (12):
      sched: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c
      cpu: change some globals to statics in drivers/base/cpu.c v2
      x86: Add performance variants of cpumask operators
      acpi: use performance variant for_each_cpu_mask_nr
      cpufreq: use performance variant for_each_cpu_mask_nr
      core: use performance variant for_each_cpu_mask_nr
      mm: use performance variant for_each_cpu_mask_nr
      net: use performance variant for_each_cpu_mask_nr
      x86: use performance variant for_each_cpu_mask_nr
      infiniband: use performance variant for_each_cpu_mask_nr
      clocksource/events: use performance variant for_each_cpu_mask_nr
      net: Pass reference to cpumask variable in net/sunrpc/svc.c


 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    6 +-
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c        |    6 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    8 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   10 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    4 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c          |    4 +-
 arch/x86/kernel/io_apic_64.c                     |    8 +-
 arch/x86/kernel/smpboot.c                        |    8 +-
 arch/x86/xen/smp.c                               |    4 +-
 drivers/acpi/processor_throttling.c              |    6 +-
 drivers/base/cpu.c                               |    4 +-
 drivers/cpufreq/cpufreq.c                        |   14 ++--
 drivers/cpufreq/cpufreq_conservative.c           |    2 +-
 drivers/cpufreq/cpufreq_ondemand.c               |    4 +-
 drivers/infiniband/hw/ehca/ehca_irq.c            |    4 +-
 include/asm-x86/ipi.h                            |    2 +-
 include/linux/cpumask.h                          |   94 ++++++++++++++--------
 kernel/cpu.c                                     |    2 +-
 kernel/rcuclassic.c                              |    2 +-
 kernel/rcupreempt.c                              |   10 +-
 kernel/sched.c                                   |   36 ++++----
 kernel/sched_fair.c                              |    2 +-
 kernel/sched_rt.c                                |    4 +-
 kernel/taskstats.c                               |    4 +-
 kernel/time/clocksource.c                        |    4 +-
 kernel/time/tick-broadcast.c                     |    3 +-
 kernel/workqueue.c                               |    6 +-
 lib/cpumask.c                                    |    9 ++
 mm/allocpercpu.c                                 |    4 +-
 mm/vmstat.c                                      |    2 +-
 net/core/dev.c                                   |    4 +-
 net/iucv/iucv.c                                  |    2 +-
 net/sunrpc/svc.c                                 |    2 +-
 34 files changed, 161 insertions(+), 125 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index b0c8208..dd097b8 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -202,7 +202,7 @@ static void drv_write(struct drv_cmd *cmd)
 	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
-	for_each_cpu_mask(i, cmd->mask) {
+	for_each_cpu_mask_nr(i, cmd->mask) {
 		set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
 		do_drv_write(cmd);
 	}
@@ -451,7 +451,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
-	for_each_cpu_mask(i, cmd.mask) {
+	for_each_cpu_mask_nr(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -466,7 +466,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		}
 	}
 
-	for_each_cpu_mask(i, cmd.mask) {
+	for_each_cpu_mask_nr(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index 199e4e0..f1685fb 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -122,7 +122,7 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 		return 0;
 
 	/* notifiers */
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -130,11 +130,11 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 	/* run on each logical CPU, see section 13.15.3 of IA32 Intel Architecture Software
 	 * Developer's Manual, Volume 3
 	 */
-	for_each_cpu_mask(i, policy->cpus)
+	for_each_cpu_mask_nr(i, policy->cpus)
 		cpufreq_p4_setdc(i, p4clockmod_table[newstate].index);
 
 	/* notifiers */
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 206791e..c45ca6d 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -966,7 +966,7 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data, unsigned i
 	freqs.old = find_khz_freq_from_fid(data->currfid);
 	freqs.new = find_khz_freq_from_fid(fid);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -974,7 +974,7 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data, unsigned i
 	res = transition_fid_vid(data, fid, vid);
 	freqs.new = find_khz_freq_from_fid(data->currfid);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -997,7 +997,7 @@ static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned i
 	freqs.old = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -1005,7 +1005,7 @@ static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned i
 	res = transition_pstate(data, pstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index 908dd34..8b0dd6f 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -476,7 +476,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 	saved_mask = current->cpus_allowed;
 	first_cpu = 1;
 	cpus_clear(covered_cpus);
-	for_each_cpu_mask(j, online_policy_cpus) {
+	for_each_cpu_mask_nr(j, online_policy_cpus) {
 		/*
 		 * Support for SMP systems.
 		 * Make sure we are running on CPU that wants to change freq
@@ -517,7 +517,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 			dprintk("target=%dkHz old=%d new=%d msr=%04x\n",
 				target_freq, freqs.old, freqs.new, msr);
 
-			for_each_cpu_mask(k, online_policy_cpus) {
+			for_each_cpu_mask_nr(k, online_policy_cpus) {
 				freqs.cpu = k;
 				cpufreq_notify_transition(&freqs,
 					CPUFREQ_PRECHANGE);
@@ -540,7 +540,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 		preempt_enable();
 	}
 
-	for_each_cpu_mask(k, online_policy_cpus) {
+	for_each_cpu_mask_nr(k, online_policy_cpus) {
 		freqs.cpu = k;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -554,7 +554,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 		 */
 
 		if (!cpus_empty(covered_cpus)) {
-			for_each_cpu_mask(j, covered_cpus) {
+			for_each_cpu_mask_nr(j, covered_cpus) {
 				set_cpus_allowed_ptr(current,
 						     &cpumask_of_cpu(j));
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
@@ -564,7 +564,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 		tmp = freqs.new;
 		freqs.new = freqs.old;
 		freqs.old = tmp;
-		for_each_cpu_mask(j, online_policy_cpus) {
+		for_each_cpu_mask_nr(j, online_policy_cpus) {
 			freqs.cpu = j;
 			cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index 1b50244..191f726 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -279,7 +279,7 @@ static int speedstep_target (struct cpufreq_policy *policy,
 
 	cpus_allowed = current->cpus_allowed;
 
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -292,7 +292,7 @@ static int speedstep_target (struct cpufreq_policy *policy,
 	/* allow to be run on all CPUs */
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 2c8afaf..a7b0f8f 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -489,7 +489,7 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 	int sibling;
 
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
-	for_each_cpu_mask(sibling, this_leaf->shared_cpu_map) {
+	for_each_cpu_mask_nr(sibling, this_leaf->shared_cpu_map) {
 		sibling_leaf = CPUID4_INFO_IDX(sibling, index);	
 		cpu_clear(cpu, sibling_leaf->shared_cpu_map);
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 7c9a813..88736ca 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -527,7 +527,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	if (err)
 		goto out_free;
 
-	for_each_cpu_mask(i, b->cpus) {
+	for_each_cpu_mask_nr(i, b->cpus) {
 		if (i == cpu)
 			continue;
 
@@ -617,7 +617,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 #endif
 
 	/* remove all sibling symlinks before unregistering */
-	for_each_cpu_mask(i, b->cpus) {
+	for_each_cpu_mask_nr(i, b->cpus) {
 		if (i == cpu)
 			continue;
 
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 6510cde..bf27114 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -731,7 +731,7 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
 			return 0;
 	}
 
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		cpumask_t domain, new_mask;
 		int new_cpu;
 		int vector, offset;
@@ -752,7 +752,7 @@ next:
 			continue;
 		if (vector == IA32_SYSCALL_VECTOR)
 			goto next;
-		for_each_cpu_mask(new_cpu, new_mask)
+		for_each_cpu_mask_nr(new_cpu, new_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
 		/* Found one! */
@@ -762,7 +762,7 @@ next:
 			cfg->move_in_progress = 1;
 			cfg->old_domain = cfg->domain;
 		}
-		for_each_cpu_mask(new_cpu, new_mask)
+		for_each_cpu_mask_nr(new_cpu, new_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
 		cfg->domain = domain;
@@ -794,7 +794,7 @@ static void __clear_irq_vector(int irq)
 
 	vector = cfg->vector;
 	cpus_and(mask, cfg->domain, cpu_online_map);
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask_nr(cpu, mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 687376a..09b98cd 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -438,7 +438,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	cpu_set(cpu, cpu_sibling_setup_map);
 
 	if (smp_num_siblings > 1) {
-		for_each_cpu_mask(i, cpu_sibling_setup_map) {
+		for_each_cpu_mask_nr(i, cpu_sibling_setup_map) {
 			if (c->phys_proc_id == cpu_data(i).phys_proc_id &&
 			    c->cpu_core_id == cpu_data(i).cpu_core_id) {
 				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
@@ -461,7 +461,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		return;
 	}
 
-	for_each_cpu_mask(i, cpu_sibling_setup_map) {
+	for_each_cpu_mask_nr(i, cpu_sibling_setup_map) {
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpu_set(i, c->llc_shared_map);
@@ -1230,7 +1230,7 @@ static void remove_siblinginfo(int cpu)
 	int sibling;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	for_each_cpu_mask(sibling, per_cpu(cpu_core_map, cpu)) {
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
 		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
 		/*/
 		 * last thread sibling in this cpu core going down
@@ -1239,7 +1239,7 @@ static void remove_siblinginfo(int cpu)
 			cpu_data(sibling).booted_cores--;
 	}
 
-	for_each_cpu_mask(sibling, per_cpu(cpu_sibling_map, cpu))
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
 		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
 	cpus_clear(per_cpu(cpu_sibling_map, cpu));
 	cpus_clear(per_cpu(cpu_core_map, cpu));
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 233156f..463adec 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -351,7 +351,7 @@ static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
 
 	cpus_and(mask, mask, cpu_online_map);
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask_nr(cpu, mask)
 		xen_send_IPI_one(cpu, vector);
 }
 
@@ -362,7 +362,7 @@ void xen_smp_send_call_function_ipi(cpumask_t mask)
 	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		if (xen_vcpu_stolen(cpu)) {
 			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
 			break;
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index bb06738..28509fb 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -1013,7 +1013,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 	 * affected cpu in order to get one proper T-state.
 	 * The notifier event is THROTTLING_PRECHANGE.
 	 */
-	for_each_cpu_mask(i, online_throttling_cpus) {
+	for_each_cpu_mask_nr(i, online_throttling_cpus) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_PRECHANGE,
 							&t_state);
@@ -1034,7 +1034,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 		 * it is necessary to set T-state for every affected
 		 * cpus.
 		 */
-		for_each_cpu_mask(i, online_throttling_cpus) {
+		for_each_cpu_mask_nr(i, online_throttling_cpus) {
 			match_pr = processors[i];
 			/*
 			 * If the pointer is invalid, we will report the
@@ -1068,7 +1068,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 	 * affected cpu to update the T-states.
 	 * The notifier event is THROTTLING_POSTCHANGE
 	 */
-	for_each_cpu_mask(i, online_throttling_cpus) {
+	for_each_cpu_mask_nr(i, online_throttling_cpus) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
 							&t_state);
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index e38dfed..5000402 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -119,14 +119,14 @@ static ssize_t print_cpus_##type(struct sysdev_class *class, char *buf)	\
 {									\
 	return print_cpus_map(buf, &cpu_##type##_map);			\
 }									\
-struct sysdev_class_attribute attr_##type##_map = 			\
+static struct sysdev_class_attribute attr_##type##_map = 		\
 	_SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
 
 print_cpus_func(online);
 print_cpus_func(possible);
 print_cpus_func(present);
 
-struct sysdev_class_attribute *cpu_state_attr[] = {
+static struct sysdev_class_attribute *cpu_state_attr[] = {
 	&attr_online_map,
 	&attr_possible_map,
 	&attr_present_map,
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1d41496..d8f8b1e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -589,7 +589,7 @@ static ssize_t show_cpus(cpumask_t mask, char *buf)
 	ssize_t i = 0;
 	unsigned int cpu;
 
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		if (i)
 			i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), " ");
 		i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), "%u", cpu);
@@ -835,7 +835,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	}
 #endif
 
-	for_each_cpu_mask(j, policy->cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
 		if (cpu == j)
 			continue;
 
@@ -898,14 +898,14 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	}
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask(j, policy->cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
 		cpufreq_cpu_data[j] = policy;
 		per_cpu(policy_cpu, j) = policy->cpu;
 	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	/* symlink affected CPUs */
-	for_each_cpu_mask(j, policy->cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
 		if (j == cpu)
 			continue;
 		if (!cpu_online(j))
@@ -945,7 +945,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 
 err_out_unregister:
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask(j, policy->cpus)
+	for_each_cpu_mask_nr(j, policy->cpus)
 		cpufreq_cpu_data[j] = NULL;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1028,7 +1028,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	 * links afterwards.
 	 */
 	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask(j, data->cpus) {
+		for_each_cpu_mask_nr(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			cpufreq_cpu_data[j] = NULL;
@@ -1038,7 +1038,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask(j, data->cpus) {
+		for_each_cpu_mask_nr(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			dprintk("removing link for cpu %u\n", j);
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 5d3a04b..fe565ee 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -497,7 +497,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			return rc;
 		}
 
-		for_each_cpu_mask(j, policy->cpus) {
+		for_each_cpu_mask_nr(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index d2af20d..33855cb 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -367,7 +367,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 
 	/* Get Idle Time */
 	idle_ticks = UINT_MAX;
-	for_each_cpu_mask(j, policy->cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
 		cputime64_t total_idle_ticks;
 		unsigned int tmp_idle_ticks;
 		struct cpu_dbs_info_s *j_dbs_info;
@@ -521,7 +521,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			return rc;
 		}
 
-		for_each_cpu_mask(j, policy->cpus) {
+		for_each_cpu_mask_nr(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 0792d93..7a64aa9 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -646,8 +646,8 @@ static inline int find_next_online_cpu(struct ehca_comp_pool *pool)
 		ehca_dmp(&cpu_online_map, sizeof(cpumask_t), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
-	cpu = next_cpu(pool->last_cpu, cpu_online_map);
-	if (cpu == NR_CPUS)
+	cpu = next_cpu_nr(pool->last_cpu, cpu_online_map);
+	if (cpu >= nr_cpu_ids)
 		cpu = first_cpu(cpu_online_map);
 	pool->last_cpu = cpu;
 	spin_unlock_irqrestore(&pool->last_cpu_lock, flags);
diff --git a/include/asm-x86/ipi.h b/include/asm-x86/ipi.h
index 196d63c..bb1c09f 100644
--- a/include/asm-x86/ipi.h
+++ b/include/asm-x86/ipi.h
@@ -122,7 +122,7 @@ static inline void send_IPI_mask_sequence(cpumask_t mask, int vector)
 	 * - mbligh
 	 */
 	local_irq_save(flags);
-	for_each_cpu_mask(query_cpu, mask) {
+	for_each_cpu_mask_nr(query_cpu, mask) {
 		__send_IPI_dest_field(per_cpu(x86_cpu_to_apicid, query_cpu),
 				      vector, APIC_DEST_PHYSICAL);
 	}
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c24875b..80226e7 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -17,6 +17,20 @@
  * For details of cpus_onto(), see bitmap_onto in lib/bitmap.c.
  * For details of cpus_fold(), see bitmap_fold in lib/bitmap.c.
  *
+ * . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
+ * Note: The alternate operations with the suffix "_nr" are used
+ *       to limit the range of the loop to nr_cpu_ids instead of
+ *       NR_CPUS when NR_CPUS > 64 for performance reasons.
+ *       If NR_CPUS is <= 64 then most assembler bitmask
+ *       operators execute faster with a constant range, so
+ *       the operator will continue to use NR_CPUS.
+ *
+ *       Another consideration is that nr_cpu_ids is initialized
+ *       to NR_CPUS and isn't lowered until the possible cpus are
+ *       discovered (including any disabled cpus).  So early uses
+ *       will span the entire range of NR_CPUS.
+ * . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
+ *
  * The available cpumask operations are:
  *
  * void cpu_set(cpu, mask)		turn on bit 'cpu' in mask
@@ -38,12 +52,14 @@
  * int cpus_empty(mask)			Is mask empty (no bits sets)?
  * int cpus_full(mask)			Is mask full (all bits sets)?
  * int cpus_weight(mask)		Hamming weigh - number of set bits
+ * int cpus_weight_nr(mask)		Same using nr_cpu_ids instead of NR_CPUS
  *
  * void cpus_shift_right(dst, src, n)	Shift right
  * void cpus_shift_left(dst, src, n)	Shift left
  *
  * int first_cpu(mask)			Number lowest set bit, or NR_CPUS
  * int next_cpu(cpu, mask)		Next cpu past 'cpu', or NR_CPUS
+ * int next_cpu_nr(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
  *
  * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
  * CPU_MASK_ALL				Initializer - all bits set
@@ -59,7 +75,8 @@
  * void cpus_onto(dst, orig, relmap)	*dst = orig relative to relmap
  * void cpus_fold(dst, orig, sz)	dst bits = orig bits mod sz
  *
- * for_each_cpu_mask(cpu, mask)		for-loop cpu over mask
+ * for_each_cpu_mask(cpu, mask)		for-loop cpu over mask using NR_CPUS
+ * for_each_cpu_mask_nr(cpu, mask)	for-loop cpu over mask using nr_cpu_ids
  *
  * int num_online_cpus()		Number of online CPUs
  * int num_possible_cpus()		Number of all possible CPUs
@@ -216,15 +233,6 @@ static inline void __cpus_shift_left(cpumask_t *dstp,
 	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
 }
 
-#ifdef CONFIG_SMP
-int __first_cpu(const cpumask_t *srcp);
-#define first_cpu(src) __first_cpu(&(src))
-int __next_cpu(int n, const cpumask_t *srcp);
-#define next_cpu(n, src) __next_cpu((n), &(src))
-#else
-#define first_cpu(src)		({ (void)(src); 0; })
-#define next_cpu(n, src)	({ (void)(src); 1; })
-#endif
 
 #ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
 extern cpumask_t *cpumask_of_cpu_map;
@@ -343,20 +351,49 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 	bitmap_fold(dstp->bits, origp->bits, sz, nbits);
 }
 
-#if NR_CPUS > 1
-#define for_each_cpu_mask(cpu, mask)		\
-	for ((cpu) = first_cpu(mask);		\
-		(cpu) < NR_CPUS;		\
-		(cpu) = next_cpu((cpu), (mask)))
-#else /* NR_CPUS == 1 */
-#define for_each_cpu_mask(cpu, mask)		\
+#if NR_CPUS == 1
+
+#define nr_cpu_ids		1
+#define first_cpu(src)		({ (void)(src); 0; })
+#define next_cpu(n, src)	({ (void)(src); 1; })
+#define any_online_cpu(mask)	0
+#define for_each_cpu_mask(cpu, mask)	\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
-#endif /* NR_CPUS */
+
+#else /* NR_CPUS > 1 */
+
+extern int nr_cpu_ids;
+int __first_cpu(const cpumask_t *srcp);
+int __next_cpu(int n, const cpumask_t *srcp);
+int __any_online_cpu(const cpumask_t *mask);
+
+#define first_cpu(src)		__first_cpu(&(src))
+#define next_cpu(n, src)	__next_cpu((n), &(src))
+#define any_online_cpu(mask) __any_online_cpu(&(mask))
+#define for_each_cpu_mask(cpu, mask)			\
+	for ((cpu) = -1;				\
+		(cpu) = next_cpu((cpu), (mask)),	\
+		(cpu) < NR_CPUS; )
+#endif
+
+#if NR_CPUS <= 64
 
 #define next_cpu_nr(n, src)		next_cpu(n, src)
 #define cpus_weight_nr(cpumask)		cpus_weight(cpumask)
 #define for_each_cpu_mask_nr(cpu, mask)	for_each_cpu_mask(cpu, mask)
 
+#else /* NR_CPUS > 64 */
+
+int __next_cpu_nr(int n, const cpumask_t *srcp);
+#define next_cpu_nr(n, src)	__next_cpu_nr((n), &(src))
+#define cpus_weight_nr(cpumask)	__cpus_weight(&(cpumask), nr_cpu_ids)
+#define for_each_cpu_mask_nr(cpu, mask)			\
+	for ((cpu) = -1;				\
+		(cpu) = next_cpu_nr((cpu), (mask)),	\
+		(cpu) < nr_cpu_ids; )
+
+#endif /* NR_CPUS > 64 */
+
 /*
  * The following particular system cpumasks and operations manage
  * possible, present and online cpus.  Each of them is a fixed size
@@ -418,9 +455,9 @@ extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_present_map;
 
 #if NR_CPUS > 1
-#define num_online_cpus()	cpus_weight(cpu_online_map)
-#define num_possible_cpus()	cpus_weight(cpu_possible_map)
-#define num_present_cpus()	cpus_weight(cpu_present_map)
+#define num_online_cpus()	cpus_weight_nr(cpu_online_map)
+#define num_possible_cpus()	cpus_weight_nr(cpu_possible_map)
+#define num_present_cpus()	cpus_weight_nr(cpu_present_map)
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
@@ -435,17 +472,8 @@ extern cpumask_t cpu_present_map;
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
 
-#ifdef CONFIG_SMP
-extern int nr_cpu_ids;
-#define any_online_cpu(mask) __any_online_cpu(&(mask))
-int __any_online_cpu(const cpumask_t *mask);
-#else
-#define nr_cpu_ids			1
-#define any_online_cpu(mask)		0
-#endif
-
-#define for_each_possible_cpu(cpu)  for_each_cpu_mask((cpu), cpu_possible_map)
-#define for_each_online_cpu(cpu)  for_each_cpu_mask((cpu), cpu_online_map)
-#define for_each_present_cpu(cpu) for_each_cpu_mask((cpu), cpu_present_map)
+#define for_each_possible_cpu(cpu) for_each_cpu_mask_nr((cpu), cpu_possible_map)
+#define for_each_online_cpu(cpu)   for_each_cpu_mask_nr((cpu), cpu_online_map)
+#define for_each_present_cpu(cpu)  for_each_cpu_mask_nr((cpu), cpu_present_map)
 
 #endif /* __LINUX_CPUMASK_H */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index b11f06d..b21ba7e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -412,7 +412,7 @@ void __ref enable_nonboot_cpus(void)
 		goto out;
 
 	printk("Enabling non-boot CPUs ...\n");
-	for_each_cpu_mask(cpu, frozen_cpus) {
+	for_each_cpu_mask_nr(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 16eeeaa..6f8696c 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -106,7 +106,7 @@ static void force_quiescent_state(struct rcu_data *rdp,
 		 */
 		cpus_and(cpumask, rcp->cpumask, cpu_online_map);
 		cpu_clear(rdp->cpu, cpumask);
-		for_each_cpu_mask(cpu, cpumask)
+		for_each_cpu_mask_nr(cpu, cpumask)
 			smp_send_reschedule(cpu);
 	}
 }
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 6f62b77..2782793 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -756,7 +756,7 @@ rcu_try_flip_idle(void)
 
 	/* Now ask each CPU for acknowledgement of the flip. */
 
-	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
 		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -774,7 +774,7 @@ rcu_try_flip_waitack(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
 		if (rcu_try_flip_waitack_needed(cpu) &&
 		    per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
@@ -806,7 +806,7 @@ rcu_try_flip_waitzero(void)
 	/* Check to see if the sum of the "last" counters is zero. */
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
 		sum += RCU_DATA_CPU(cpu)->rcu_flipctr[lastidx];
 	if (sum != 0) {
 		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
@@ -821,7 +821,7 @@ rcu_try_flip_waitzero(void)
 	smp_mb();  /*  ^^^^^^^^^^^^ */
 
 	/* Call for a memory barrier from each CPU. */
-	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
 		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -841,7 +841,7 @@ rcu_try_flip_waitmb(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
 		if (rcu_try_flip_waitmb_needed(cpu) &&
 		    per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
diff --git a/kernel/sched.c b/kernel/sched.c
index 99e6d85..a6d0a7f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2108,7 +2108,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
 
-		for_each_cpu_mask(i, group->cpumask) {
+		for_each_cpu_mask_nr(i, group->cpumask) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
 				load = source_load(i, load_idx);
@@ -2150,7 +2150,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
 	/* Traverse only the allowed CPUs */
 	cpus_and(*tmp, group->cpumask, p->cpus_allowed);
 
-	for_each_cpu_mask(i, *tmp) {
+	for_each_cpu_mask_nr(i, *tmp) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -3168,7 +3168,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
-		for_each_cpu_mask(i, group->cpumask) {
+		for_each_cpu_mask_nr(i, group->cpumask) {
 			struct rq *rq;
 
 			if (!cpu_isset(i, *cpus))
@@ -3447,7 +3447,7 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 	unsigned long max_load = 0;
 	int i;
 
-	for_each_cpu_mask(i, group->cpumask) {
+	for_each_cpu_mask_nr(i, group->cpumask) {
 		unsigned long wl;
 
 		if (!cpu_isset(i, *cpus))
@@ -3989,7 +3989,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 		int balance_cpu;
 
 		cpu_clear(this_cpu, cpus);
-		for_each_cpu_mask(balance_cpu, cpus) {
+		for_each_cpu_mask_nr(balance_cpu, cpus) {
 			/*
 			 * If this cpu gets work to do, stop the load balancing
 			 * work being done for other cpus. Next load
@@ -6802,7 +6802,7 @@ init_sched_build_groups(const cpumask_t *span, const cpumask_t *cpu_map,
 
 	cpus_clear(*covered);
 
-	for_each_cpu_mask(i, *span) {
+	for_each_cpu_mask_nr(i, *span) {
 		struct sched_group *sg;
 		int group = group_fn(i, cpu_map, &sg, tmpmask);
 		int j;
@@ -6813,7 +6813,7 @@ init_sched_build_groups(const cpumask_t *span, const cpumask_t *cpu_map,
 		cpus_clear(sg->cpumask);
 		sg->__cpu_power = 0;
 
-		for_each_cpu_mask(j, *span) {
+		for_each_cpu_mask_nr(j, *span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
 				continue;
 
@@ -7013,7 +7013,7 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 	if (!sg)
 		return;
 	do {
-		for_each_cpu_mask(j, sg->cpumask) {
+		for_each_cpu_mask_nr(j, sg->cpumask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(phys_domains, j);
@@ -7038,7 +7038,7 @@ static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
 {
 	int cpu, i;
 
-	for_each_cpu_mask(cpu, *cpu_map) {
+	for_each_cpu_mask_nr(cpu, *cpu_map) {
 		struct sched_group **sched_group_nodes
 			= sched_group_nodes_bycpu[cpu];
 
@@ -7277,7 +7277,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = NULL, *p;
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
 
@@ -7344,7 +7344,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7361,7 +7361,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		SCHED_CPUMASK_VAR(this_core_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7428,7 +7428,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 			goto error;
 		}
 		sched_group_nodes[i] = sg;
-		for_each_cpu_mask(j, *nodemask) {
+		for_each_cpu_mask_nr(j, *nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
@@ -7474,21 +7474,21 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(cpu_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(core_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(phys_domains, i);
 
 		init_sched_groups_power(i, sd);
@@ -7508,7 +7508,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 #endif
 
 	/* Attach the domains */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
 		sd = &per_cpu(cpu_domains, i);
@@ -7603,7 +7603,7 @@ static void detach_destroy_domains(const cpumask_t *cpu_map)
 
 	unregister_sched_domain_sysctl();
 
-	for_each_cpu_mask(i, *cpu_map)
+	for_each_cpu_mask_nr(i, *cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
 	arch_destroy_sched_domains(cpu_map, &tmpmask);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f2aa987..bb61fe2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1031,7 +1031,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 		    || ((sd->flags & SD_WAKE_IDLE_FAR)
 			&& !task_hot(p, task_rq(p)->clock, sd))) {
 			cpus_and(tmp, sd->span, p->cpus_allowed);
-			for_each_cpu_mask(i, tmp) {
+			for_each_cpu_mask_nr(i, tmp) {
 				if (idle_cpu(i)) {
 					if (i != task_cpu(p)) {
 						schedstat_inc(p,
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 47ceac9..7c96147 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -240,7 +240,7 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 
 	spin_lock(&rt_b->rt_runtime_lock);
 	rt_period = ktime_to_ns(rt_b->rt_period);
-	for_each_cpu_mask(i, rd->span) {
+	for_each_cpu_mask_nr(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;
 
@@ -1107,7 +1107,7 @@ static int pull_rt_task(struct rq *this_rq)
 
 	next = pick_next_task_rt(this_rq);
 
-	for_each_cpu_mask(cpu, this_rq->rd->rto_mask) {
+	for_each_cpu_mask_nr(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
 
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 4a23517..06b1754 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -301,7 +301,7 @@ static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
 		return -EINVAL;
 
 	if (isadd == REGISTER) {
-		for_each_cpu_mask(cpu, mask) {
+		for_each_cpu_mask_nr(cpu, mask) {
 			s = kmalloc_node(sizeof(struct listener), GFP_KERNEL,
 					 cpu_to_node(cpu));
 			if (!s)
@@ -320,7 +320,7 @@ static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
 
 	/* Deregister or cleanup */
 cleanup:
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		listeners = &per_cpu(listener_array, cpu);
 		down_write(&listeners->sem);
 		list_for_each_entry_safe(s, tmp, &listeners->list, list) {
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index dadde53..60ceabd 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -145,9 +145,9 @@ static void clocksource_watchdog(unsigned long data)
 		 * Cycle through CPUs to check if the CPUs stay
 		 * synchronized to each other.
 		 */
-		int next_cpu = next_cpu(raw_smp_processor_id(), cpu_online_map);
+		int next_cpu = next_cpu_nr(raw_smp_processor_id(), cpu_online_map);
 
-		if (next_cpu >= NR_CPUS)
+		if (next_cpu >= nr_cpu_ids)
 			next_cpu = first_cpu(cpu_online_map);
 		watchdog_timer.expires += WATCHDOG_INTERVAL;
 		add_timer_on(&watchdog_timer, next_cpu);
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f48d0f0..31463d3 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -399,8 +399,7 @@ again:
 	mask = CPU_MASK_NONE;
 	now = ktime_get();
 	/* Find all expired events */
-	for (cpu = first_cpu(tick_broadcast_oneshot_mask); cpu != NR_CPUS;
-	     cpu = next_cpu(cpu, tick_broadcast_oneshot_mask)) {
+	for_each_cpu_mask_nr(cpu, tick_broadcast_oneshot_mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
 			cpu_set(cpu, mask);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ce77995..a6d3634 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -397,7 +397,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	might_sleep();
 	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
-	for_each_cpu_mask(cpu, *cpu_map)
+	for_each_cpu_mask_nr(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -477,7 +477,7 @@ static void wait_on_work(struct work_struct *work)
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu_mask(cpu, *cpu_map)
+	for_each_cpu_mask_nr(cpu, *cpu_map)
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
@@ -813,7 +813,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu_mask(cpu, *cpu_map)
+	for_each_cpu_mask_nr(cpu, *cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
 	put_online_cpus();
 
diff --git a/lib/cpumask.c b/lib/cpumask.c
index bb4f76d..5f97dc2 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -15,6 +15,15 @@ int __next_cpu(int n, const cpumask_t *srcp)
 }
 EXPORT_SYMBOL(__next_cpu);
 
+#if NR_CPUS > 64
+int __next_cpu_nr(int n, const cpumask_t *srcp)
+{
+	return min_t(int, nr_cpu_ids,
+				find_next_bit(srcp->bits, nr_cpu_ids, n+1));
+}
+EXPORT_SYMBOL(__next_cpu_nr);
+#endif
+
 int __any_online_cpu(const cpumask_t *mask)
 {
 	int cpu;
diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
index 05f2b40..8433645 100644
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -35,7 +35,7 @@ EXPORT_SYMBOL_GPL(percpu_depopulate);
 void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
 {
 	int cpu;
-	for_each_cpu_mask(cpu, *mask)
+	for_each_cpu_mask_nr(cpu, *mask)
 		percpu_depopulate(__pdata, cpu);
 }
 EXPORT_SYMBOL_GPL(__percpu_depopulate_mask);
@@ -86,7 +86,7 @@ int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
 	int cpu;
 
 	cpus_clear(populated);
-	for_each_cpu_mask(cpu, *mask)
+	for_each_cpu_mask_nr(cpu, *mask)
 		if (unlikely(!percpu_populate(__pdata, size, gfp, cpu))) {
 			__percpu_depopulate_mask(__pdata, &populated);
 			return -ENOMEM;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index db9eabb..c3d4a78 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -26,7 +26,7 @@ static void sum_vm_events(unsigned long *ret, cpumask_t *cpumask)
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu_mask(cpu, *cpumask) {
+	for_each_cpu_mask_nr(cpu, *cpumask) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
diff --git a/net/core/dev.c b/net/core/dev.c
index 821cb16..df5520a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2261,7 +2261,7 @@ out:
 	 */
 	if (!cpus_empty(net_dma.channel_mask)) {
 		int chan_idx;
-		for_each_cpu_mask(chan_idx, net_dma.channel_mask) {
+		for_each_cpu_mask_nr(chan_idx, net_dma.channel_mask) {
 			struct dma_chan *chan = net_dma.channels[chan_idx];
 			if (chan)
 				dma_async_memcpy_issue_pending(chan);
@@ -4322,7 +4322,7 @@ static void net_dma_rebalance(struct net_dma *net_dma)
 	i = 0;
 	cpu = first_cpu(cpu_online_map);
 
-	for_each_cpu_mask(chan_idx, net_dma->channel_mask) {
+	for_each_cpu_mask_nr(chan_idx, net_dma->channel_mask) {
 		chan = net_dma->channels[chan_idx];
 
 		n = ((num_online_cpus() / cpus_weight(net_dma->channel_mask))
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index cc34ac7..411b339 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -497,7 +497,7 @@ static void iucv_setmask_up(void)
 	/* Disable all cpu but the first in cpu_irq_cpumask. */
 	cpumask = iucv_irq_cpumask;
 	cpu_clear(first_cpu(iucv_irq_cpumask), cpumask);
-	for_each_cpu_mask(cpu, cpumask)
+	for_each_cpu_mask_nr(cpu, cpumask)
 		smp_call_function_single(cpu, iucv_block_cpu, NULL, 1);
 }
 
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 01c7e31..d43cf8d 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -603,7 +603,7 @@ __svc_create_thread(svc_thread_fn func, struct svc_serv *serv,
 	error = kernel_thread((int (*)(void *)) func, rqstp, 0);
 
 	if (have_oldmask)
-		set_cpus_allowed(current, oldmask);
+		set_cpus_allowed_ptr(current, &oldmask);
 
 	if (error < 0)
 		goto out_thread;
