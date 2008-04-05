Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYDEBOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYDEBOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYDEBLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:15 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45155 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751742AbYDEBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:04 -0400
Message-Id: <20080405011101.703570000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:05 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH 05/12] x86: use new set_cpus_allowed_ptr function
Content-Disposition: inline; filename=x86-set_cpus_allowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Use new set_cpus_allowed_ptr() function added by previous patch,
    which instead of passing the "newly allowed cpus" cpumask_t arg
    by value,  pass it by pointer:

    -int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
    +int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)

  * Cleanup uses of CPU_MASK_ALL.

  * Collapse other NR_CPUS changes to arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
    Use pointers to cpumask_t arguments whenever possible.

Depends on:
	[sched-devel]: sched: add new set_cpus_allowed_ptr function

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

# acpi/cpufreq
Cc: Len Brown <len.brown@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/acpi/cstate.c                    |    4 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   28 ++++++++++----------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   32 ++++++++++++-----------
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   13 +++++----
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |   20 +++++++-------
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    4 +-
 arch/x86/kernel/microcode.c                      |   16 +++++------
 arch/x86/kernel/reboot.c                         |    2 -
 8 files changed, 61 insertions(+), 58 deletions(-)

--- linux-2.6.x86.orig/arch/x86/kernel/acpi/cstate.c
+++ linux-2.6.x86/arch/x86/kernel/acpi/cstate.c
@@ -91,7 +91,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 
 	/* Make sure we are running on right CPU */
 	saved_mask = current->cpus_allowed;
-	retval = set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (retval)
 		return -1;
 
@@ -128,7 +128,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 		 cx->address);
 
 out:
-	set_cpus_allowed(current, saved_mask);
+	set_cpus_allowed_ptr(current, &saved_mask);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
--- linux-2.6.x86.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6.x86/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -192,9 +192,9 @@ static void drv_read(struct drv_cmd *cmd
 	cpumask_t saved_mask = current->cpus_allowed;
 	cmd->val = 0;
 
-	set_cpus_allowed(current, cmd->mask);
+	set_cpus_allowed_ptr(current, &cmd->mask);
 	do_drv_read(cmd);
-	set_cpus_allowed(current, saved_mask);
+	set_cpus_allowed_ptr(current, &saved_mask);
 }
 
 static void drv_write(struct drv_cmd *cmd)
@@ -203,30 +203,30 @@ static void drv_write(struct drv_cmd *cm
 	unsigned int i;
 
 	for_each_cpu_mask(i, cmd->mask) {
-		set_cpus_allowed(current, cpumask_of_cpu(i));
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
 		do_drv_write(cmd);
 	}
 
-	set_cpus_allowed(current, saved_mask);
+	set_cpus_allowed_ptr(current, &saved_mask);
 	return;
 }
 
-static u32 get_cur_val(cpumask_t mask)
+static u32 get_cur_val(const cpumask_t *mask)
 {
 	struct acpi_processor_performance *perf;
 	struct drv_cmd cmd;
 
-	if (unlikely(cpus_empty(mask)))
+	if (unlikely(cpus_empty(*mask)))
 		return 0;
 
-	switch (per_cpu(drv_data, first_cpu(mask))->cpu_feature) {
+	switch (per_cpu(drv_data, first_cpu(*mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
 		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
-		perf = per_cpu(drv_data, first_cpu(mask))->acpi_data;
+		perf = per_cpu(drv_data, first_cpu(*mask))->acpi_data;
 		cmd.addr.io.port = perf->control_register.address;
 		cmd.addr.io.bit_width = perf->control_register.bit_width;
 		break;
@@ -234,7 +234,7 @@ static u32 get_cur_val(cpumask_t mask)
 		return 0;
 	}
 
-	cmd.mask = mask;
+	cmd.mask = *mask;
 
 	drv_read(&cmd);
 
@@ -271,7 +271,7 @@ static unsigned int get_measured_perf(un
 	unsigned int retval;
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (get_cpu() != cpu) {
 		/* We were not able to run on requested processor */
 		put_cpu();
@@ -329,7 +329,7 @@ static unsigned int get_measured_perf(un
 	retval = per_cpu(drv_data, cpu)->max_freq * perf_percent / 100;
 
 	put_cpu();
-	set_cpus_allowed(current, saved_mask);
+	set_cpus_allowed_ptr(current, &saved_mask);
 
 	dprintk("cpu %d: performance percent %d\n", cpu, perf_percent);
 	return retval;
@@ -347,13 +347,13 @@ static unsigned int get_cur_freq_on_cpu(
 		return 0;
 	}
 
-	freq = extract_freq(get_cur_val(cpumask_of_cpu(cpu)), data);
+	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
 	dprintk("cur freq = %u\n", freq);
 
 	return freq;
 }
 
-static unsigned int check_freqs(cpumask_t mask, unsigned int freq,
+static unsigned int check_freqs(const cpumask_t *mask, unsigned int freq,
 				struct acpi_cpufreq_data *data)
 {
 	unsigned int cur_freq;
@@ -449,7 +449,7 @@ static int acpi_cpufreq_target(struct cp
 	drv_write(&cmd);
 
 	if (acpi_pstate_strict) {
-		if (!check_freqs(cmd.mask, freqs.new, data)) {
+		if (!check_freqs(&cmd.mask, freqs.new, data)) {
 			dprintk("acpi_cpufreq_target failed (%d)\n",
 				policy->cpu);
 			return -EAGAIN;
--- linux-2.6.x86.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6.x86/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -478,12 +478,12 @@ static int core_voltage_post_transition(
 
 static int check_supported_cpu(unsigned int cpu)
 {
-	cpumask_t oldmask = CPU_MASK_ALL;
+	cpumask_t oldmask;
 	u32 eax, ebx, ecx, edx;
 	unsigned int rc = 0;
 
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", cpu);
@@ -528,7 +528,7 @@ static int check_supported_cpu(unsigned 
 	rc = 1;
 
 out:
-	set_cpus_allowed(current, oldmask);
+	set_cpus_allowed_ptr(current, &oldmask);
 	return rc;
 }
 
@@ -1015,7 +1015,7 @@ static int transition_frequency_pstate(s
 /* Driver entry point to switch to the target frequency */
 static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsigned relation)
 {
-	cpumask_t oldmask = CPU_MASK_ALL;
+	cpumask_t oldmask;
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
@@ -1030,7 +1030,7 @@ static int powernowk8_target(struct cpuf
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(pol->cpu));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1085,7 +1085,7 @@ static int powernowk8_target(struct cpuf
 	ret = 0;
 
 err_out:
-	set_cpus_allowed(current, oldmask);
+	set_cpus_allowed_ptr(current, &oldmask);
 	return ret;
 }
 
@@ -1104,7 +1104,7 @@ static int powernowk8_verify(struct cpuf
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask = CPU_MASK_ALL;
+	cpumask_t oldmask;
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1145,7 +1145,7 @@ static int __cpuinit powernowk8_cpu_init
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(pol->cpu));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1164,7 +1164,7 @@ static int __cpuinit powernowk8_cpu_init
 		fidvid_msr_init();
 
 	/* run on any CPU again */
-	set_cpus_allowed(current, oldmask);
+	set_cpus_allowed_ptr(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
 		pol->cpus = cpumask_of_cpu(pol->cpu);
@@ -1205,7 +1205,7 @@ static int __cpuinit powernowk8_cpu_init
 	return 0;
 
 err_out:
-	set_cpus_allowed(current, oldmask);
+	set_cpus_allowed_ptr(current, &oldmask);
 	powernow_k8_cpu_exit_acpi(data);
 
 	kfree(data);
@@ -1242,10 +1242,11 @@ static unsigned int powernowk8_get (unsi
 	if (!data)
 		return -EINVAL;
 
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu) {
-		printk(KERN_ERR PFX "limiting to CPU %d failed in powernowk8_get\n", cpu);
-		set_cpus_allowed(current, oldmask);
+		printk(KERN_ERR PFX
+			"limiting to CPU %d failed in powernowk8_get\n", cpu);
+		set_cpus_allowed_ptr(current, &oldmask);
 		return 0;
 	}
 
@@ -1253,13 +1254,14 @@ static unsigned int powernowk8_get (unsi
 		goto out;
 
 	if (cpu_family == CPU_HW_PSTATE)
-		khz = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
+		khz = find_khz_freq_from_pstate(data->powernow_table,
+						data->currpstate);
 	else
 		khz = find_khz_freq_from_fid(data->currfid);
 
 
 out:
-	set_cpus_allowed(current, oldmask);
+	set_cpus_allowed_ptr(current, &oldmask);
 	return khz;
 }
 
--- linux-2.6.x86.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6.x86/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -315,7 +315,7 @@ static unsigned int get_cur_freq(unsigne
 	cpumask_t saved_mask;
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu)
 		return 0;
 
@@ -333,7 +333,7 @@ static unsigned int get_cur_freq(unsigne
 		clock_freq = extract_clock(l, cpu, 1);
 	}
 
-	set_cpus_allowed(current, saved_mask);
+	set_cpus_allowed_ptr(current, &saved_mask);
 	return clock_freq;
 }
 
@@ -487,7 +487,7 @@ static int centrino_target (struct cpufr
 		else
 			cpu_set(j, set_mask);
 
-		set_cpus_allowed(current, set_mask);
+		set_cpus_allowed_ptr(current, &set_mask);
 		preempt_disable();
 		if (unlikely(!cpu_isset(smp_processor_id(), set_mask))) {
 			dprintk("couldn't limit to CPUs in this domain\n");
@@ -555,7 +555,8 @@ static int centrino_target (struct cpufr
 
 		if (!cpus_empty(covered_cpus)) {
 			for_each_cpu_mask(j, covered_cpus) {
-				set_cpus_allowed(current, cpumask_of_cpu(j));
+				set_cpus_allowed_ptr(current,
+						     &cpumask_of_cpu(j));
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
 			}
 		}
@@ -569,12 +570,12 @@ static int centrino_target (struct cpufr
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 		}
 	}
-	set_cpus_allowed(current, saved_mask);
+	set_cpus_allowed_ptr(current, &saved_mask);
 	return 0;
 
 migrate_end:
 	preempt_enable();
-	set_cpus_allowed(current, saved_mask);
+	set_cpus_allowed_ptr(current, &saved_mask);
 	return 0;
 }
 
--- linux-2.6.x86.orig/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ linux-2.6.x86/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -229,22 +229,22 @@ static unsigned int speedstep_detect_chi
 	return 0;
 }
 
-static unsigned int _speedstep_get(cpumask_t cpus)
+static unsigned int _speedstep_get(const cpumask_t *cpus)
 {
 	unsigned int speed;
 	cpumask_t cpus_allowed;
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed(current, cpus);
+	set_cpus_allowed_ptr(current, cpus);
 	speed = speedstep_get_processor_frequency(speedstep_processor);
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 	dprintk("detected %u kHz as current frequency\n", speed);
 	return speed;
 }
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	return _speedstep_get(cpumask_of_cpu(cpu));
+	return _speedstep_get(&cpumask_of_cpu(cpu));
 }
 
 /**
@@ -267,7 +267,7 @@ static int speedstep_target (struct cpuf
 	if (cpufreq_frequency_table_target(policy, &speedstep_freqs[0], target_freq, relation, &newstate))
 		return -EINVAL;
 
-	freqs.old = _speedstep_get(policy->cpus);
+	freqs.old = _speedstep_get(&policy->cpus);
 	freqs.new = speedstep_freqs[newstate].frequency;
 	freqs.cpu = policy->cpu;
 
@@ -285,12 +285,12 @@ static int speedstep_target (struct cpuf
 	}
 
 	/* switch to physical CPU where state is to be changed */
-	set_cpus_allowed(current, policy->cpus);
+	set_cpus_allowed_ptr(current, &policy->cpus);
 
 	speedstep_set_state(newstate);
 
 	/* allow to be run on all CPUs */
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	for_each_cpu_mask(i, policy->cpus) {
 		freqs.cpu = i;
@@ -326,7 +326,7 @@ static int speedstep_cpu_init(struct cpu
 #endif
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed(current, policy->cpus);
+	set_cpus_allowed_ptr(current, &policy->cpus);
 
 	/* detect low and high frequency and transition latency */
 	result = speedstep_get_freqs(speedstep_processor,
@@ -334,12 +334,12 @@ static int speedstep_cpu_init(struct cpu
 				     &speedstep_freqs[SPEEDSTEP_HIGH].frequency,
 				     &policy->cpuinfo.transition_latency,
 				     &speedstep_set_state);
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 	if (result)
 		return result;
 
 	/* get current speed setting */
-	speed = _speedstep_get(policy->cpus);
+	speed = _speedstep_get(&policy->cpus);
 	if (!speed)
 		return -EIO;
 
--- linux-2.6.x86.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6.x86/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -525,7 +525,7 @@ static int __cpuinit detect_cache_attrib
 		return -ENOMEM;
 
 	oldmask = current->cpus_allowed;
-	retval = set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (retval)
 		goto out;
 
@@ -542,7 +542,7 @@ static int __cpuinit detect_cache_attrib
 		}
 		cache_shared_cpu_map_setup(cpu, j);
 	}
-	set_cpus_allowed(current, oldmask);
+	set_cpus_allowed_ptr(current, &oldmask);
 
 out:
 	if (retval) {
--- linux-2.6.x86.orig/arch/x86/kernel/microcode.c
+++ linux-2.6.x86/arch/x86/kernel/microcode.c
@@ -402,7 +402,7 @@ static int do_microcode_update (void)
 
 			if (!uci->valid)
 				continue;
-			set_cpus_allowed(current, cpumask_of_cpu(cpu));
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 			error = get_maching_microcode(new_mc, cpu);
 			if (error < 0)
 				goto out;
@@ -416,7 +416,7 @@ out:
 		vfree(new_mc);
 	if (cursor < 0)
 		error = cursor;
-	set_cpus_allowed(current, old);
+	set_cpus_allowed_ptr(current, &old);
 	return error;
 }
 
@@ -579,7 +579,7 @@ static int apply_microcode_check_cpu(int
 		return 0;
 
 	old = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 
 	/* Check if the microcode we have in memory matches the CPU */
 	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
@@ -610,7 +610,7 @@ static int apply_microcode_check_cpu(int
 			" sig=0x%x, pf=0x%x, rev=0x%x\n",
 			cpu, uci->sig, uci->pf, uci->rev);
 
-	set_cpus_allowed(current, old);
+	set_cpus_allowed_ptr(current, &old);
 	return err;
 }
 
@@ -621,13 +621,13 @@ static void microcode_init_cpu(int cpu, 
 
 	old = current->cpus_allowed;
 
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	mutex_lock(&microcode_mutex);
 	collect_cpu_info(cpu);
 	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
 		cpu_request_microcode(cpu);
 	mutex_unlock(&microcode_mutex);
-	set_cpus_allowed(current, old);
+	set_cpus_allowed_ptr(current, &old);
 }
 
 static void microcode_fini_cpu(int cpu)
@@ -657,14 +657,14 @@ static ssize_t reload_store(struct sys_d
 		old = current->cpus_allowed;
 
 		get_online_cpus();
-		set_cpus_allowed(current, cpumask_of_cpu(cpu));
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 
 		mutex_lock(&microcode_mutex);
 		if (uci->valid)
 			err = cpu_request_microcode(cpu);
 		mutex_unlock(&microcode_mutex);
 		put_online_cpus();
-		set_cpus_allowed(current, old);
+		set_cpus_allowed_ptr(current, &old);
 	}
 	if (err)
 		return err;
--- linux-2.6.x86.orig/arch/x86/kernel/reboot.c
+++ linux-2.6.x86/arch/x86/kernel/reboot.c
@@ -420,7 +420,7 @@ static void native_machine_shutdown(void
 		reboot_cpu_id = smp_processor_id();
 
 	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(reboot_cpu_id));
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.

-- 
