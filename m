Return-Path: <linux-kernel-owner+w=401wt.eu-S933833AbYDZATv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833AbYDZATv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762120AbYDZAQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:16:00 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59187 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758201AbYDZAPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:15:51 -0400
Message-Id: <20080426001550.398950000@polaris-admin.engr.sgi.com>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 17:15:57 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] x86: Use performance variant for_each_cpu_mask_nr
Content-Disposition: inline; filename=use-for_each_cpu_mask_nr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Change references from for_each_cpu_mask to for_each_cpu_mask_nr
    where appropriate.

For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git


Reviewed-by: Paul Jackson <pj@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    6 +--
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c        |    6 +--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    8 ++--
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   10 ++---
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    4 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    2 -
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c          |    4 +-
 arch/x86/kernel/io_apic_64.c                     |    8 ++--
 arch/x86/kernel/smpboot.c                        |    8 ++--
 arch/x86/xen/smp.c                               |    4 +-
 drivers/acpi/processor_throttling.c              |    6 +--
 drivers/cpufreq/cpufreq.c                        |   14 +++----
 drivers/cpufreq/cpufreq_conservative.c           |    2 -
 drivers/cpufreq/cpufreq_ondemand.c               |    4 +-
 include/asm-x86/ipi.h                            |    2 -
 kernel/cpu.c                                     |    2 -
 kernel/rcuclassic.c                              |    2 -
 kernel/rcupreempt.c                              |   10 ++---
 kernel/sched.c                                   |   44 +++++++++++------------
 kernel/sched_fair.c                              |    2 -
 kernel/sched_rt.c                                |    6 +--
 kernel/taskstats.c                               |    4 +-
 kernel/trace/trace.c                             |    8 ++--
 kernel/workqueue.c                               |    6 +--
 mm/allocpercpu.c                                 |    4 +-
 mm/vmstat.c                                      |    2 -
 net/core/dev.c                                   |    4 +-
 net/iucv/iucv.c                                  |    2 -
 28 files changed, 92 insertions(+), 92 deletions(-)

--- linux-2.6.sched.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6.sched/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -202,7 +202,7 @@ static void drv_write(struct drv_cmd *cm
 	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
-	for_each_cpu_mask(i, cmd->mask) {
+	for_each_cpu_mask_nr(i, cmd->mask) {
 		set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
 		do_drv_write(cmd);
 	}
@@ -441,7 +441,7 @@ static int acpi_cpufreq_target(struct cp
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
-	for_each_cpu_mask(i, cmd.mask) {
+	for_each_cpu_mask_nr(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -456,7 +456,7 @@ static int acpi_cpufreq_target(struct cp
 		}
 	}
 
-	for_each_cpu_mask(i, cmd.mask) {
+	for_each_cpu_mask_nr(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
--- linux-2.6.sched.orig/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ linux-2.6.sched/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -122,7 +122,7 @@ static int cpufreq_p4_target(struct cpuf
 		return 0;
 
 	/* notifiers */
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -130,11 +130,11 @@ static int cpufreq_p4_target(struct cpuf
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
--- linux-2.6.sched.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6.sched/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -966,7 +966,7 @@ static int transition_frequency_fidvid(s
 	freqs.old = find_khz_freq_from_fid(data->currfid);
 	freqs.new = find_khz_freq_from_fid(fid);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -974,7 +974,7 @@ static int transition_frequency_fidvid(s
 	res = transition_fid_vid(data, fid, vid);
 	freqs.new = find_khz_freq_from_fid(data->currfid);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -997,7 +997,7 @@ static int transition_frequency_pstate(s
 	freqs.old = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -1005,7 +1005,7 @@ static int transition_frequency_pstate(s
 	res = transition_pstate(data, pstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
--- linux-2.6.sched.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6.sched/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -476,7 +476,7 @@ static int centrino_target (struct cpufr
 	saved_mask = current->cpus_allowed;
 	first_cpu = 1;
 	cpus_clear(covered_cpus);
-	for_each_cpu_mask(j, online_policy_cpus) {
+	for_each_cpu_mask_nr(j, online_policy_cpus) {
 		/*
 		 * Support for SMP systems.
 		 * Make sure we are running on CPU that wants to change freq
@@ -517,7 +517,7 @@ static int centrino_target (struct cpufr
 			dprintk("target=%dkHz old=%d new=%d msr=%04x\n",
 				target_freq, freqs.old, freqs.new, msr);
 
-			for_each_cpu_mask(k, online_policy_cpus) {
+			for_each_cpu_mask_nr(k, online_policy_cpus) {
 				freqs.cpu = k;
 				cpufreq_notify_transition(&freqs,
 					CPUFREQ_PRECHANGE);
@@ -540,7 +540,7 @@ static int centrino_target (struct cpufr
 		preempt_enable();
 	}
 
-	for_each_cpu_mask(k, online_policy_cpus) {
+	for_each_cpu_mask_nr(k, online_policy_cpus) {
 		freqs.cpu = k;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -554,7 +554,7 @@ static int centrino_target (struct cpufr
 		 */
 
 		if (!cpus_empty(covered_cpus)) {
-			for_each_cpu_mask(j, covered_cpus) {
+			for_each_cpu_mask_nr(j, covered_cpus) {
 				set_cpus_allowed_ptr(current,
 						     &cpumask_of_cpu(j));
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
@@ -564,7 +564,7 @@ static int centrino_target (struct cpufr
 		tmp = freqs.new;
 		freqs.new = freqs.old;
 		freqs.old = tmp;
-		for_each_cpu_mask(j, online_policy_cpus) {
+		for_each_cpu_mask_nr(j, online_policy_cpus) {
 			freqs.cpu = j;
 			cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
--- linux-2.6.sched.orig/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ linux-2.6.sched/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -279,7 +279,7 @@ static int speedstep_target (struct cpuf
 
 	cpus_allowed = current->cpus_allowed;
 
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -292,7 +292,7 @@ static int speedstep_target (struct cpuf
 	/* allow to be run on all CPUs */
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
--- linux-2.6.sched.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6.sched/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -488,7 +488,7 @@ static void __cpuinit cache_remove_share
 	int sibling;
 
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
-	for_each_cpu_mask(sibling, this_leaf->shared_cpu_map) {
+	for_each_cpu_mask_nr(sibling, this_leaf->shared_cpu_map) {
 		sibling_leaf = CPUID4_INFO_IDX(sibling, index);	
 		cpu_clear(cpu, sibling_leaf->shared_cpu_map);
 	}
--- linux-2.6.sched.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ linux-2.6.sched/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -527,7 +527,7 @@ static __cpuinit int threshold_create_ba
 	if (err)
 		goto out_free;
 
-	for_each_cpu_mask(i, b->cpus) {
+	for_each_cpu_mask_nr(i, b->cpus) {
 		if (i == cpu)
 			continue;
 
@@ -617,7 +617,7 @@ static void threshold_remove_bank(unsign
 #endif
 
 	/* remove all sibling symlinks before unregistering */
-	for_each_cpu_mask(i, b->cpus) {
+	for_each_cpu_mask_nr(i, b->cpus) {
 		if (i == cpu)
 			continue;
 
--- linux-2.6.sched.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6.sched/arch/x86/kernel/io_apic_64.c
@@ -722,7 +722,7 @@ static int __assign_irq_vector(int irq, 
 			return 0;
 	}
 
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		cpumask_t domain, new_mask;
 		int new_cpu;
 		int vector, offset;
@@ -743,7 +743,7 @@ next:
 			continue;
 		if (vector == IA32_SYSCALL_VECTOR)
 			goto next;
-		for_each_cpu_mask(new_cpu, new_mask)
+		for_each_cpu_mask_nr(new_cpu, new_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
 		/* Found one! */
@@ -753,7 +753,7 @@ next:
 			cfg->move_in_progress = 1;
 			cfg->old_domain = cfg->domain;
 		}
-		for_each_cpu_mask(new_cpu, new_mask)
+		for_each_cpu_mask_nr(new_cpu, new_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
 		cfg->domain = domain;
@@ -785,7 +785,7 @@ static void __clear_irq_vector(int irq)
 
 	vector = cfg->vector;
 	cpus_and(mask, cfg->domain, cpu_online_map);
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask_nr(cpu, mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
--- linux-2.6.sched.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.sched/arch/x86/kernel/smpboot.c
@@ -464,7 +464,7 @@ void __cpuinit set_cpu_sibling_map(int c
 	cpu_set(cpu, cpu_sibling_setup_map);
 
 	if (smp_num_siblings > 1) {
-		for_each_cpu_mask(i, cpu_sibling_setup_map) {
+		for_each_cpu_mask_nr(i, cpu_sibling_setup_map) {
 			if (c->phys_proc_id == cpu_data(i).phys_proc_id &&
 			    c->cpu_core_id == cpu_data(i).cpu_core_id) {
 				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
@@ -487,7 +487,7 @@ void __cpuinit set_cpu_sibling_map(int c
 		return;
 	}
 
-	for_each_cpu_mask(i, cpu_sibling_setup_map) {
+	for_each_cpu_mask_nr(i, cpu_sibling_setup_map) {
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpu_set(i, c->llc_shared_map);
@@ -1301,7 +1301,7 @@ void remove_siblinginfo(int cpu)
 	int sibling;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	for_each_cpu_mask(sibling, per_cpu(cpu_core_map, cpu)) {
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
 		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
 		/*/
 		 * last thread sibling in this cpu core going down
@@ -1310,7 +1310,7 @@ void remove_siblinginfo(int cpu)
 			cpu_data(sibling).booted_cores--;
 	}
 
-	for_each_cpu_mask(sibling, per_cpu(cpu_sibling_map, cpu))
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
 		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
 	cpus_clear(per_cpu(cpu_sibling_map, cpu));
 	cpus_clear(per_cpu(cpu_core_map, cpu));
--- linux-2.6.sched.orig/arch/x86/xen/smp.c
+++ linux-2.6.sched/arch/x86/xen/smp.c
@@ -345,7 +345,7 @@ static void xen_send_IPI_mask(cpumask_t 
 
 	cpus_and(mask, mask, cpu_online_map);
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask_nr(cpu, mask)
 		xen_send_IPI_one(cpu, vector);
 }
 
@@ -413,7 +413,7 @@ int xen_smp_call_function_mask(cpumask_t
 
 	/* Make sure other vcpus get a chance to run if they need to. */
 	yield = false;
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask_nr(cpu, mask)
 		if (xen_vcpu_stolen(cpu))
 			yield = true;
 
--- linux-2.6.sched.orig/drivers/acpi/processor_throttling.c
+++ linux-2.6.sched/drivers/acpi/processor_throttling.c
@@ -1013,7 +1013,7 @@ int acpi_processor_set_throttling(struct
 	 * affected cpu in order to get one proper T-state.
 	 * The notifier event is THROTTLING_PRECHANGE.
 	 */
-	for_each_cpu_mask(i, online_throttling_cpus) {
+	for_each_cpu_mask_nr(i, online_throttling_cpus) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_PRECHANGE,
 							&t_state);
@@ -1034,7 +1034,7 @@ int acpi_processor_set_throttling(struct
 		 * it is necessary to set T-state for every affected
 		 * cpus.
 		 */
-		for_each_cpu_mask(i, online_throttling_cpus) {
+		for_each_cpu_mask_nr(i, online_throttling_cpus) {
 			match_pr = processors[i];
 			/*
 			 * If the pointer is invalid, we will report the
@@ -1068,7 +1068,7 @@ int acpi_processor_set_throttling(struct
 	 * affected cpu to update the T-states.
 	 * The notifier event is THROTTLING_POSTCHANGE
 	 */
-	for_each_cpu_mask(i, online_throttling_cpus) {
+	for_each_cpu_mask_nr(i, online_throttling_cpus) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
 							&t_state);
--- linux-2.6.sched.orig/drivers/cpufreq/cpufreq.c
+++ linux-2.6.sched/drivers/cpufreq/cpufreq.c
@@ -590,7 +590,7 @@ static ssize_t show_affected_cpus (struc
 	ssize_t i = 0;
 	unsigned int cpu;
 
-	for_each_cpu_mask(cpu, policy->cpus) {
+	for_each_cpu_mask_nr(cpu, policy->cpus) {
 		if (i)
 			i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), " ");
 		i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), "%u", cpu);
@@ -816,7 +816,7 @@ static int cpufreq_add_dev (struct sys_d
 	}
 #endif
 
-	for_each_cpu_mask(j, policy->cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
 		if (cpu == j)
 			continue;
 
@@ -889,14 +889,14 @@ static int cpufreq_add_dev (struct sys_d
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
@@ -938,7 +938,7 @@ static int cpufreq_add_dev (struct sys_d
 
 err_out_unregister:
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask(j, policy->cpus)
+	for_each_cpu_mask_nr(j, policy->cpus)
 		cpufreq_cpu_data[j] = NULL;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1020,7 +1020,7 @@ static int __cpufreq_remove_dev (struct 
 	 * links afterwards.
 	 */
 	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask(j, data->cpus) {
+		for_each_cpu_mask_nr(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			cpufreq_cpu_data[j] = NULL;
@@ -1030,7 +1030,7 @@ static int __cpufreq_remove_dev (struct 
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask(j, data->cpus) {
+		for_each_cpu_mask_nr(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			dprintk("removing link for cpu %u\n", j);
--- linux-2.6.sched.orig/drivers/cpufreq/cpufreq_conservative.c
+++ linux-2.6.sched/drivers/cpufreq/cpufreq_conservative.c
@@ -497,7 +497,7 @@ static int cpufreq_governor_dbs(struct c
 			return rc;
 		}
 
-		for_each_cpu_mask(j, policy->cpus) {
+		for_each_cpu_mask_nr(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
--- linux-2.6.sched.orig/drivers/cpufreq/cpufreq_ondemand.c
+++ linux-2.6.sched/drivers/cpufreq/cpufreq_ondemand.c
@@ -367,7 +367,7 @@ static void dbs_check_cpu(struct cpu_dbs
 
 	/* Get Idle Time */
 	idle_ticks = UINT_MAX;
-	for_each_cpu_mask(j, policy->cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
 		cputime64_t total_idle_ticks;
 		unsigned int tmp_idle_ticks;
 		struct cpu_dbs_info_s *j_dbs_info;
@@ -521,7 +521,7 @@ static int cpufreq_governor_dbs(struct c
 			return rc;
 		}
 
-		for_each_cpu_mask(j, policy->cpus) {
+		for_each_cpu_mask_nr(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
--- linux-2.6.sched.orig/include/asm-x86/ipi.h
+++ linux-2.6.sched/include/asm-x86/ipi.h
@@ -121,7 +121,7 @@ static inline void send_IPI_mask_sequenc
 	 * - mbligh
 	 */
 	local_irq_save(flags);
-	for_each_cpu_mask(query_cpu, mask) {
+	for_each_cpu_mask_nr(query_cpu, mask) {
 		__send_IPI_dest_field(per_cpu(x86_cpu_to_apicid, query_cpu),
 				      vector, APIC_DEST_PHYSICAL);
 	}
--- linux-2.6.sched.orig/kernel/cpu.c
+++ linux-2.6.sched/kernel/cpu.c
@@ -400,7 +400,7 @@ void __ref enable_nonboot_cpus(void)
 		goto out;
 
 	printk("Enabling non-boot CPUs ...\n");
-	for_each_cpu_mask(cpu, frozen_cpus) {
+	for_each_cpu_mask_nr(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
--- linux-2.6.sched.orig/kernel/rcuclassic.c
+++ linux-2.6.sched/kernel/rcuclassic.c
@@ -92,7 +92,7 @@ static void force_quiescent_state(struct
 		 */
 		cpumask = rcp->cpumask;
 		cpu_clear(rdp->cpu, cpumask);
-		for_each_cpu_mask(cpu, cpumask)
+		for_each_cpu_mask_nr(cpu, cpumask)
 			smp_send_reschedule(cpu);
 	}
 }
--- linux-2.6.sched.orig/kernel/rcupreempt.c
+++ linux-2.6.sched/kernel/rcupreempt.c
@@ -758,7 +758,7 @@ rcu_try_flip_idle(void)
 
 	/* Now ask each CPU for acknowledgement of the flip. */
 
-	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
 		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -776,7 +776,7 @@ rcu_try_flip_waitack(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
 		if (rcu_try_flip_waitack_needed(cpu) &&
 		    per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
@@ -808,7 +808,7 @@ rcu_try_flip_waitzero(void)
 	/* Check to see if the sum of the "last" counters is zero. */
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
 		sum += RCU_DATA_CPU(cpu)->rcu_flipctr[lastidx];
 	if (sum != 0) {
 		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
@@ -823,7 +823,7 @@ rcu_try_flip_waitzero(void)
 	smp_mb();  /*  ^^^^^^^^^^^^ */
 
 	/* Call for a memory barrier from each CPU. */
-	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
 		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -843,7 +843,7 @@ rcu_try_flip_waitmb(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
 		if (rcu_try_flip_waitmb_needed(cpu) &&
 		    per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
--- linux-2.6.sched.orig/kernel/sched.c
+++ linux-2.6.sched/kernel/sched.c
@@ -1682,7 +1682,7 @@ void aggregate_group_weight(struct task_
 	unsigned long task_weight = 0;
 	int i;
 
-	for_each_cpu_mask(i, sd->span) {
+	for_each_cpu_mask_nr(i, sd->span) {
 		rq_weight += tg->cfs_rq[i]->load.weight;
 		task_weight += tg->cfs_rq[i]->task_weight;
 	}
@@ -1737,7 +1737,7 @@ void aggregate_group_shares(struct task_
 	int i;
 
 again:
-	for_each_cpu_mask(i, sd->span)
+	for_each_cpu_mask_nr(i, sd->span)
 		shares += tg->cfs_rq[i]->shares;
 
 	/*
@@ -1765,7 +1765,7 @@ void aggregate_group_load(struct task_gr
 		int i;
 
 		load = 0;
-		for_each_cpu_mask(i, sd->span)
+		for_each_cpu_mask_nr(i, sd->span)
 			load += cpu_rq(i)->load.weight;
 
 	} else {
@@ -1874,7 +1874,7 @@ void aggregate_group_set_shares(struct t
 	unsigned long shares = aggregate(tg, sd)->shares;
 	int i;
 
-	for_each_cpu_mask(i, sd->span) {
+	for_each_cpu_mask_nr(i, sd->span) {
 		struct rq *rq = cpu_rq(i);
 		unsigned long flags;
 
@@ -2408,7 +2408,7 @@ find_idlest_group(struct sched_domain *s
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
 
-		for_each_cpu_mask(i, group->cpumask) {
+		for_each_cpu_mask_nr(i, group->cpumask) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
 				load = source_load(i, load_idx);
@@ -2450,7 +2450,7 @@ find_idlest_cpu(struct sched_group *grou
 	/* Traverse only the allowed CPUs */
 	cpus_and(*tmp, group->cpumask, p->cpus_allowed);
 
-	for_each_cpu_mask(i, *tmp) {
+	for_each_cpu_mask_nr(i, *tmp) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -3436,7 +3436,7 @@ find_busiest_group(struct sched_domain *
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
-		for_each_cpu_mask(i, group->cpumask) {
+		for_each_cpu_mask_nr(i, group->cpumask) {
 			struct rq *rq;
 
 			if (!cpu_isset(i, *cpus))
@@ -3700,7 +3700,7 @@ find_busiest_queue(struct sched_group *g
 	unsigned long max_load = 0;
 	int i;
 
-	for_each_cpu_mask(i, group->cpumask) {
+	for_each_cpu_mask_nr(i, group->cpumask) {
 		unsigned long wl;
 
 		if (!cpu_isset(i, *cpus))
@@ -4240,7 +4240,7 @@ static void run_rebalance_domains(struct
 		int balance_cpu;
 
 		cpu_clear(this_cpu, cpus);
-		for_each_cpu_mask(balance_cpu, cpus) {
+		for_each_cpu_mask_nr(balance_cpu, cpus) {
 			/*
 			 * If this cpu gets work to do, stop the load balancing
 			 * work being done for other cpus. Next load
@@ -7009,7 +7009,7 @@ init_sched_build_groups(const cpumask_t 
 
 	cpus_clear(*covered);
 
-	for_each_cpu_mask(i, *span) {
+	for_each_cpu_mask_nr(i, *span) {
 		struct sched_group *sg;
 		int group = group_fn(i, cpu_map, &sg, tmpmask);
 		int j;
@@ -7020,7 +7020,7 @@ init_sched_build_groups(const cpumask_t 
 		cpus_clear(sg->cpumask);
 		sg->__cpu_power = 0;
 
-		for_each_cpu_mask(j, *span) {
+		for_each_cpu_mask_nr(j, *span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
 				continue;
 
@@ -7220,7 +7220,7 @@ static void init_numa_sched_groups_power
 	if (!sg)
 		return;
 	do {
-		for_each_cpu_mask(j, sg->cpumask) {
+		for_each_cpu_mask_nr(j, sg->cpumask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(phys_domains, j);
@@ -7245,7 +7245,7 @@ static void free_sched_groups(const cpum
 {
 	int cpu, i;
 
-	for_each_cpu_mask(cpu, *cpu_map) {
+	for_each_cpu_mask_nr(cpu, *cpu_map) {
 		struct sched_group **sched_group_nodes
 			= sched_group_nodes_bycpu[cpu];
 
@@ -7479,7 +7479,7 @@ static int __build_sched_domains(const c
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = NULL, *p;
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
 
@@ -7551,7 +7551,7 @@ static int __build_sched_domains(const c
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7568,7 +7568,7 @@ static int __build_sched_domains(const c
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		SCHED_CPUMASK_VAR(this_core_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7635,7 +7635,7 @@ static int __build_sched_domains(const c
 			goto error;
 		}
 		sched_group_nodes[i] = sg;
-		for_each_cpu_mask(j, *nodemask) {
+		for_each_cpu_mask_nr(j, *nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
@@ -7681,21 +7681,21 @@ static int __build_sched_domains(const c
 
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
@@ -7715,7 +7715,7 @@ static int __build_sched_domains(const c
 #endif
 
 	/* Attach the domains */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
 		sd = &per_cpu(cpu_domains, i);
@@ -7798,7 +7798,7 @@ static void detach_destroy_domains(const
 
 	unregister_sched_domain_sysctl();
 
-	for_each_cpu_mask(i, *cpu_map)
+	for_each_cpu_mask_nr(i, *cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
 	arch_destroy_sched_domains(cpu_map, &tmpmask);
--- linux-2.6.sched.orig/kernel/sched_fair.c
+++ linux-2.6.sched/kernel/sched_fair.c
@@ -1015,7 +1015,7 @@ static int wake_idle(int cpu, struct tas
 		    || ((sd->flags & SD_WAKE_IDLE_FAR)
 			&& !task_hot(p, task_rq(p)->clock, sd))) {
 			cpus_and(tmp, sd->span, p->cpus_allowed);
-			for_each_cpu_mask(i, tmp) {
+			for_each_cpu_mask_nr(i, tmp) {
 				if (idle_cpu(i)) {
 					if (i != task_cpu(p)) {
 						schedstat_inc(p,
--- linux-2.6.sched.orig/kernel/sched_rt.c
+++ linux-2.6.sched/kernel/sched_rt.c
@@ -231,7 +231,7 @@ static int do_sched_rt_period_timer(stru
 		return 1;
 
 	span = sched_rt_period_mask();
-	for_each_cpu_mask(i, span) {
+	for_each_cpu_mask_nr(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
 		struct rq *rq = rq_of_rt_rq(rt_rq);
@@ -272,7 +272,7 @@ static int balance_runtime(struct rt_rq 
 
 	spin_lock(&rt_b->rt_runtime_lock);
 	rt_period = ktime_to_ns(rt_b->rt_period);
-	for_each_cpu_mask(i, rd->span) {
+	for_each_cpu_mask_nr(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;
 
@@ -960,7 +960,7 @@ static int pull_rt_task(struct rq *this_
 
 	next = pick_next_task_rt(this_rq);
 
-	for_each_cpu_mask(cpu, this_rq->rd->rto_mask) {
+	for_each_cpu_mask_nr(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
 
--- linux-2.6.sched.orig/kernel/taskstats.c
+++ linux-2.6.sched/kernel/taskstats.c
@@ -301,7 +301,7 @@ static int add_del_listener(pid_t pid, c
 		return -EINVAL;
 
 	if (isadd == REGISTER) {
-		for_each_cpu_mask(cpu, mask) {
+		for_each_cpu_mask_nr(cpu, mask) {
 			s = kmalloc_node(sizeof(struct listener), GFP_KERNEL,
 					 cpu_to_node(cpu));
 			if (!s)
@@ -320,7 +320,7 @@ static int add_del_listener(pid_t pid, c
 
 	/* Deregister or cleanup */
 cleanup:
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		listeners = &per_cpu(listener_array, cpu);
 		down_write(&listeners->sem);
 		list_for_each_entry_safe(s, tmp, &listeners->list, list) {
--- linux-2.6.sched.orig/kernel/trace/trace.c
+++ linux-2.6.sched/kernel/trace/trace.c
@@ -40,7 +40,7 @@ static unsigned long __read_mostly	traci
 static cpumask_t __read_mostly		tracing_buffer_mask;
 
 #define for_each_tracing_cpu(cpu)	\
-	for_each_cpu_mask(cpu, tracing_buffer_mask)
+	for_each_cpu_mask_nr(cpu, tracing_buffer_mask)
 
 /* dummy trace to disable tracing */
 static struct tracer no_tracer __read_mostly = {
@@ -2529,7 +2529,7 @@ tracing_read_pipe(struct file *filp, cha
 		cpu_set(cpu, mask);
 	}
 
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		data = iter->tr->data[cpu];
 		__raw_spin_lock(&data->lock);
 
@@ -2555,12 +2555,12 @@ tracing_read_pipe(struct file *filp, cha
 			break;
 	}
 
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		data = iter->tr->data[cpu];
 		__raw_spin_unlock(&data->lock);
 	}
 
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		data = iter->tr->data[cpu];
 		atomic_dec(&data->disabled);
 	}
--- linux-2.6.sched.orig/kernel/workqueue.c
+++ linux-2.6.sched/kernel/workqueue.c
@@ -397,7 +397,7 @@ void flush_workqueue(struct workqueue_st
 	might_sleep();
 	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
-	for_each_cpu_mask(cpu, *cpu_map)
+	for_each_cpu_mask_nr(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -477,7 +477,7 @@ static void wait_on_work(struct work_str
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu_mask(cpu, *cpu_map)
+	for_each_cpu_mask_nr(cpu, *cpu_map)
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
@@ -817,7 +817,7 @@ void destroy_workqueue(struct workqueue_
 	spin_unlock(&workqueue_lock);
 	put_online_cpus();
 
-	for_each_cpu_mask(cpu, *cpu_map) {
+	for_each_cpu_mask_nr(cpu, *cpu_map) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 		cleanup_workqueue_thread(cwq, cpu);
 	}
--- linux-2.6.sched.orig/mm/allocpercpu.c
+++ linux-2.6.sched/mm/allocpercpu.c
@@ -35,7 +35,7 @@ EXPORT_SYMBOL_GPL(percpu_depopulate);
 void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
 {
 	int cpu;
-	for_each_cpu_mask(cpu, *mask)
+	for_each_cpu_mask_nr(cpu, *mask)
 		percpu_depopulate(__pdata, cpu);
 }
 EXPORT_SYMBOL_GPL(__percpu_depopulate_mask);
@@ -86,7 +86,7 @@ int __percpu_populate_mask(void *__pdata
 	int cpu;
 
 	cpus_clear(populated);
-	for_each_cpu_mask(cpu, *mask)
+	for_each_cpu_mask_nr(cpu, *mask)
 		if (unlikely(!percpu_populate(__pdata, size, gfp, cpu))) {
 			__percpu_depopulate_mask(__pdata, &populated);
 			return -ENOMEM;
--- linux-2.6.sched.orig/mm/vmstat.c
+++ linux-2.6.sched/mm/vmstat.c
@@ -26,7 +26,7 @@ static void sum_vm_events(unsigned long 
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu_mask(cpu, *cpumask) {
+	for_each_cpu_mask_nr(cpu, *cpumask) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
--- linux-2.6.sched.orig/net/core/dev.c
+++ linux-2.6.sched/net/core/dev.c
@@ -2231,7 +2231,7 @@ out:
 	 */
 	if (!cpus_empty(net_dma.channel_mask)) {
 		int chan_idx;
-		for_each_cpu_mask(chan_idx, net_dma.channel_mask) {
+		for_each_cpu_mask_nr(chan_idx, net_dma.channel_mask) {
 			struct dma_chan *chan = net_dma.channels[chan_idx];
 			if (chan)
 				dma_async_memcpy_issue_pending(chan);
@@ -4290,7 +4290,7 @@ static void net_dma_rebalance(struct net
 	i = 0;
 	cpu = first_cpu(cpu_online_map);
 
-	for_each_cpu_mask(chan_idx, net_dma->channel_mask) {
+	for_each_cpu_mask_nr(chan_idx, net_dma->channel_mask) {
 		chan = net_dma->channels[chan_idx];
 
 		n = ((num_online_cpus() / cpus_weight(net_dma->channel_mask))
--- linux-2.6.sched.orig/net/iucv/iucv.c
+++ linux-2.6.sched/net/iucv/iucv.c
@@ -497,7 +497,7 @@ static void iucv_setmask_up(void)
 	/* Disable all cpu but the first in cpu_irq_cpumask. */
 	cpumask = iucv_irq_cpumask;
 	cpu_clear(first_cpu(iucv_irq_cpumask), cpumask);
-	for_each_cpu_mask(cpu, cpumask)
+	for_each_cpu_mask_nr(cpu, cpumask)
 		smp_call_function_single(cpu, iucv_block_cpu, NULL, 0, 1);
 }
 

-- 
