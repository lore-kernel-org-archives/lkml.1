Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYI2SHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYI2SHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYI2SDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58617 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753667AbYI2SCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:52 -0400
Message-Id: <20080929180251.633894000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:01 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 11/31] cpumask: remove set_cpus_allowed_ptr
Content-Disposition: inline; filename=set_cpus_allowed_ptr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/acpi/cstate.c                    |    4 ++--
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   12 ++++++------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   20 ++++++++++----------
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   12 ++++++------
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |   12 ++++++------
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c          |    4 ++--
 arch/x86/kernel/microcode_core.c                 |   12 ++++++------
 arch/x86/kernel/reboot.c                         |    2 +-
 drivers/acpi/processor_throttling.c              |   10 +++++-----
 drivers/firmware/dcdbas.c                        |    4 ++--
 drivers/misc/sgi-xp/xpc_main.c                   |    2 +-
 drivers/pci/pci-driver.c                         |    4 ++--
 include/linux/sched.h                            |   12 ++++--------
 init/main.c                                      |    2 +-
 kernel/cpu.c                                     |    4 ++--
 kernel/cpuset.c                                  |    4 ++--
 kernel/kmod.c                                    |    2 +-
 kernel/kthread.c                                 |    4 ++--
 kernel/rcutorture.c                              |   10 +++++-----
 kernel/sched.c                                   |   12 ++++++------
 kernel/trace/trace_sysprof.c                     |    4 ++--
 mm/pdflush.c                                     |    2 +-
 mm/vmscan.c                                      |    4 ++--
 net/sunrpc/svc.c                                 |    4 ++--
 25 files changed, 81 insertions(+), 85 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/acpi/cstate.c
+++ struct-cpumasks/arch/x86/kernel/acpi/cstate.c
@@ -91,7 +91,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 
 	/* Make sure we are running on right CPU */
 	saved_mask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (retval)
 		return -1;
 
@@ -128,7 +128,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 		 cx->address);
 
 out:
-	set_cpus_allowed_ptr(current, &saved_mask);
+	set_cpus_allowed(current, &saved_mask);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -192,9 +192,9 @@ static void drv_read(struct drv_cmd *cmd
 	cpumask_t saved_mask = current->cpus_allowed;
 	cmd->val = 0;
 
-	set_cpus_allowed_ptr(current, &cmd->mask);
+	set_cpus_allowed(current, &cmd->mask);
 	do_drv_read(cmd);
-	set_cpus_allowed_ptr(current, &saved_mask);
+	set_cpus_allowed(current, &saved_mask);
 }
 
 static void drv_write(struct drv_cmd *cmd)
@@ -203,11 +203,11 @@ static void drv_write(struct drv_cmd *cm
 	unsigned int i;
 
 	for_each_cpu_mask(i, cmd->mask) {
-		set_cpus_allowed_ptr(current, cpumask_of_cpu(i));
+		set_cpus_allowed(current, cpumask_of_cpu(i));
 		do_drv_write(cmd);
 	}
 
-	set_cpus_allowed_ptr(current, &saved_mask);
+	set_cpus_allowed(current, &saved_mask);
 	return;
 }
 
@@ -271,7 +271,7 @@ static unsigned int get_measured_perf(un
 	unsigned int retval;
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (get_cpu() != cpu) {
 		/* We were not able to run on requested processor */
 		put_cpu();
@@ -329,7 +329,7 @@ static unsigned int get_measured_perf(un
 	retval = per_cpu(drv_data, cpu)->max_freq * perf_percent / 100;
 
 	put_cpu();
-	set_cpus_allowed_ptr(current, &saved_mask);
+	set_cpus_allowed(current, &saved_mask);
 
 	dprintk("cpu %d: performance percent %d\n", cpu, perf_percent);
 	return retval;
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -480,7 +480,7 @@ static int check_supported_cpu(unsigned 
 	unsigned int rc = 0;
 
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", cpu);
@@ -525,7 +525,7 @@ static int check_supported_cpu(unsigned 
 	rc = 1;
 
 out:
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed(current, &oldmask);
 	return rc;
 }
 
@@ -1027,7 +1027,7 @@ static int powernowk8_target(struct cpuf
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(pol->cpu));
+	set_cpus_allowed(current, cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1082,7 +1082,7 @@ static int powernowk8_target(struct cpuf
 	ret = 0;
 
 err_out:
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed(current, &oldmask);
 	return ret;
 }
 
@@ -1153,7 +1153,7 @@ static int __cpuinit powernowk8_cpu_init
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(pol->cpu));
+	set_cpus_allowed(current, cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1172,7 +1172,7 @@ static int __cpuinit powernowk8_cpu_init
 		fidvid_msr_init();
 
 	/* run on any CPU again */
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
 		pol->cpus = cpumask_of_cpu(pol->cpu);
@@ -1213,7 +1213,7 @@ static int __cpuinit powernowk8_cpu_init
 	return 0;
 
 err_out:
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed(current, &oldmask);
 	powernow_k8_cpu_exit_acpi(data);
 
 	kfree(data);
@@ -1250,11 +1250,11 @@ static unsigned int powernowk8_get (unsi
 	if (!data)
 		return -EINVAL;
 
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX
 			"limiting to CPU %d failed in powernowk8_get\n", cpu);
-		set_cpus_allowed_ptr(current, &oldmask);
+		set_cpus_allowed(current, &oldmask);
 		return 0;
 	}
 
@@ -1269,7 +1269,7 @@ static unsigned int powernowk8_get (unsi
 
 
 out:
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed(current, &oldmask);
 	return khz;
 }
 
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -419,7 +419,7 @@ static unsigned int get_cur_freq(unsigne
 	cpumask_t saved_mask;
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu)
 		return 0;
 
@@ -437,7 +437,7 @@ static unsigned int get_cur_freq(unsigne
 		clock_freq = extract_clock(l, cpu, 1);
 	}
 
-	set_cpus_allowed_ptr(current, &saved_mask);
+	set_cpus_allowed(current, &saved_mask);
 	return clock_freq;
 }
 
@@ -611,7 +611,7 @@ static int centrino_target (struct cpufr
 		else
 			cpu_set(j, *set_mask);
 
-		set_cpus_allowed_ptr(current, set_mask);
+		set_cpus_allowed(current, set_mask);
 		preempt_disable();
 		if (unlikely(!cpu_isset(smp_processor_id(), *set_mask))) {
 			dprintk("couldn't limit to CPUs in this domain\n");
@@ -679,7 +679,7 @@ static int centrino_target (struct cpufr
 
 		if (!cpus_empty(*covered_cpus))
 			for_each_cpu_mask(j, *covered_cpus) {
-				set_cpus_allowed_ptr(current,
+				set_cpus_allowed(current,
 						     cpumask_of_cpu(j));
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
 			}
@@ -693,13 +693,13 @@ static int centrino_target (struct cpufr
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 		}
 	}
-	set_cpus_allowed_ptr(current, saved_mask);
+	set_cpus_allowed(current, saved_mask);
 	retval = 0;
 	goto out;
 
 migrate_end:
 	preempt_enable();
-	set_cpus_allowed_ptr(current, saved_mask);
+	set_cpus_allowed(current, saved_mask);
 out:
 	CPUMASK_FREE(allmasks);
 	return retval;
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -235,9 +235,9 @@ static unsigned int _speedstep_get(const
 	cpumask_t cpus_allowed;
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpus);
+	set_cpus_allowed(current, cpus);
 	speed = speedstep_get_processor_frequency(speedstep_processor);
-	set_cpus_allowed_ptr(current, &cpus_allowed);
+	set_cpus_allowed(current, &cpus_allowed);
 	dprintk("detected %u kHz as current frequency\n", speed);
 	return speed;
 }
@@ -285,12 +285,12 @@ static int speedstep_target (struct cpuf
 	}
 
 	/* switch to physical CPU where state is to be changed */
-	set_cpus_allowed_ptr(current, &policy->cpus);
+	set_cpus_allowed(current, &policy->cpus);
 
 	speedstep_set_state(newstate);
 
 	/* allow to be run on all CPUs */
-	set_cpus_allowed_ptr(current, &cpus_allowed);
+	set_cpus_allowed(current, &cpus_allowed);
 
 	for_each_cpu_mask(i, policy->cpus) {
 		freqs.cpu = i;
@@ -326,7 +326,7 @@ static int speedstep_cpu_init(struct cpu
 #endif
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &policy->cpus);
+	set_cpus_allowed(current, &policy->cpus);
 
 	/* detect low and high frequency and transition latency */
 	result = speedstep_get_freqs(speedstep_processor,
@@ -334,7 +334,7 @@ static int speedstep_cpu_init(struct cpu
 				     &speedstep_freqs[SPEEDSTEP_HIGH].frequency,
 				     &policy->cpuinfo.transition_latency,
 				     &speedstep_set_state);
-	set_cpus_allowed_ptr(current, &cpus_allowed);
+	set_cpus_allowed(current, &cpus_allowed);
 	if (result)
 		return result;
 
--- struct-cpumasks.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ struct-cpumasks/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -550,7 +550,7 @@ static int __cpuinit detect_cache_attrib
 		return -ENOMEM;
 
 	oldmask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (retval)
 		goto out;
 
@@ -567,7 +567,7 @@ static int __cpuinit detect_cache_attrib
 		}
 		cache_shared_cpu_map_setup(cpu, j);
 	}
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed(current, &oldmask);
 
 out:
 	if (retval) {
--- struct-cpumasks.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ struct-cpumasks/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -257,12 +257,12 @@ static void affinity_set(unsigned int cp
 	*oldmask = current->cpus_allowed;
 	cpus_clear(*newmask);
 	cpu_set(cpu, *newmask);
-	set_cpus_allowed_ptr(current, newmask);
+	set_cpus_allowed(current, newmask);
 }
 
 static void affinity_restore(const cpumask_t *oldmask)
 {
-	set_cpus_allowed_ptr(current, oldmask);
+	set_cpus_allowed(current, oldmask);
 }
 
 #define SHOW_FIELDS(name)                                           \
--- struct-cpumasks.orig/arch/x86/kernel/microcode_core.c
+++ struct-cpumasks/arch/x86/kernel/microcode_core.c
@@ -122,7 +122,7 @@ static int do_microcode_update(const voi
 		if (!uci->valid)
 			continue;
 
-		set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
+		set_cpus_allowed(current, cpumask_of_cpu(cpu));
 		error = microcode_ops->request_microcode_user(cpu, buf, size);
 		if (error < 0)
 			goto out;
@@ -130,7 +130,7 @@ static int do_microcode_update(const voi
 			microcode_ops->apply_microcode(cpu);
 	}
 out:
-	set_cpus_allowed_ptr(current, &old);
+	set_cpus_allowed(current, &old);
 	return error;
 }
 
@@ -222,7 +222,7 @@ static ssize_t reload_store(struct sys_d
 
 		get_online_cpus();
 		if (cpu_online(cpu)) {
-			set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
+			set_cpus_allowed(current, cpumask_of_cpu(cpu));
 			mutex_lock(&microcode_mutex);
 			if (uci->valid) {
 				err = microcode_ops->request_microcode_fw(cpu,
@@ -231,7 +231,7 @@ static ssize_t reload_store(struct sys_d
 					microcode_ops->apply_microcode(cpu);
 			}
 			mutex_unlock(&microcode_mutex);
-			set_cpus_allowed_ptr(current, &old);
+			set_cpus_allowed(current, &old);
 		}
 		put_online_cpus();
 	}
@@ -351,9 +351,9 @@ static void microcode_init_cpu(int cpu)
 {
 	cpumask_t old = current->cpus_allowed;
 
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	microcode_update_cpu(cpu);
-	set_cpus_allowed_ptr(current, &old);
+	set_cpus_allowed(current, &old);
 }
 
 static int mc_sysdev_add(struct sys_device *sys_dev)
--- struct-cpumasks.orig/arch/x86/kernel/reboot.c
+++ struct-cpumasks/arch/x86/kernel/reboot.c
@@ -431,7 +431,7 @@ void native_machine_shutdown(void)
 		reboot_cpu_id = smp_processor_id();
 
 	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(reboot_cpu_id));
+	set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
--- struct-cpumasks.orig/drivers/acpi/processor_throttling.c
+++ struct-cpumasks/drivers/acpi/processor_throttling.c
@@ -838,10 +838,10 @@ static int acpi_processor_get_throttling
 	 * Migrate task to the cpu pointed by pr.
 	 */
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(pr->id));
+	set_cpus_allowed(current, cpumask_of_cpu(pr->id));
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
 	/* restore the previous state */
-	set_cpus_allowed_ptr(current, &saved_mask);
+	set_cpus_allowed(current, &saved_mask);
 
 	return ret;
 }
@@ -1025,7 +1025,7 @@ int acpi_processor_set_throttling(struct
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		set_cpus_allowed_ptr(current, cpumask_of_cpu(pr->id));
+		set_cpus_allowed(current, cpumask_of_cpu(pr->id));
 		ret = p_throttling->acpi_processor_set_throttling(pr,
 						t_state.target_state);
 	} else {
@@ -1056,7 +1056,7 @@ int acpi_processor_set_throttling(struct
 				continue;
 			}
 			t_state.cpu = i;
-			set_cpus_allowed_ptr(current, cpumask_of_cpu(i));
+			set_cpus_allowed(current, cpumask_of_cpu(i));
 			ret = match_pr->throttling.
 				acpi_processor_set_throttling(
 				match_pr, t_state.target_state);
@@ -1074,7 +1074,7 @@ int acpi_processor_set_throttling(struct
 							&t_state);
 	}
 	/* restore the previous state */
-	set_cpus_allowed_ptr(current, &saved_mask);
+	set_cpus_allowed(current, &saved_mask);
 	return ret;
 }
 
--- struct-cpumasks.orig/drivers/firmware/dcdbas.c
+++ struct-cpumasks/drivers/firmware/dcdbas.c
@@ -255,7 +255,7 @@ static int smi_request(struct smi_cmd *s
 
 	/* SMI requires CPU 0 */
 	old_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(0));
+	set_cpus_allowed(current, cpumask_of_cpu(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
 			__func__);
@@ -275,7 +275,7 @@ static int smi_request(struct smi_cmd *s
 	);
 
 out:
-	set_cpus_allowed_ptr(current, &old_mask);
+	set_cpus_allowed(current, &old_mask);
 	return ret;
 }
 
--- struct-cpumasks.orig/drivers/misc/sgi-xp/xpc_main.c
+++ struct-cpumasks/drivers/misc/sgi-xp/xpc_main.c
@@ -318,7 +318,7 @@ xpc_hb_checker(void *ignore)
 
 	/* this thread was marked active by xpc_hb_init() */
 
-	set_cpus_allowed_ptr(current, cpumask_of_cpu(XPC_HB_CHECK_CPU));
+	set_cpus_allowed(current, cpumask_of_cpu(XPC_HB_CHECK_CPU));
 
 	/* set our heartbeating to other partitions into motion */
 	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);
--- struct-cpumasks.orig/drivers/pci/pci-driver.c
+++ struct-cpumasks/drivers/pci/pci-driver.c
@@ -185,7 +185,7 @@ static int pci_call_probe(struct pci_dri
 
 	if (node >= 0) {
 		node_to_cpumask_ptr(nodecpumask, node);
-		set_cpus_allowed_ptr(current, nodecpumask);
+		set_cpus_allowed(current, nodecpumask);
 	}
 	/* And set default memory allocation policy */
 	oldpol = current->mempolicy;
@@ -193,7 +193,7 @@ static int pci_call_probe(struct pci_dri
 #endif
 	error = drv->probe(dev, id);
 #ifdef CONFIG_NUMA
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed(current, &oldmask);
 	current->mempolicy = oldpol;
 #endif
 	return error;
--- struct-cpumasks.orig/include/linux/sched.h
+++ struct-cpumasks/include/linux/sched.h
@@ -960,7 +960,7 @@ struct sched_class {
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_new) (struct rq *rq, struct task_struct *p);
 	void (*set_cpus_allowed)(struct task_struct *p,
-				 const cpumask_t *newmask);
+				 const cpumask_t newmask);
 
 	void (*rq_online)(struct rq *rq);
 	void (*rq_offline)(struct rq *rq);
@@ -1582,21 +1582,17 @@ extern cputime_t task_gtime(struct task_
 #define used_math() tsk_used_math(current)
 
 #ifdef CONFIG_SMP
-extern int set_cpus_allowed_ptr(struct task_struct *p,
+extern int set_cpus_allowed(struct task_struct *p,
 				const cpumask_t new_mask);
 #else
-static inline int set_cpus_allowed_ptr(struct task_struct *p,
+static inline int set_cpus_allowed(struct task_struct *p,
 				       const cpumask_t new_mask)
 {
-	if (!cpu_isset(0, *new_mask))
+	if (!cpu_isset(0, new_mask))
 		return -EINVAL;
 	return 0;
 }
 #endif
-static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
-{
-	return set_cpus_allowed_ptr(p, new_mask);
-}
 
 extern unsigned long long sched_clock(void);
 
--- struct-cpumasks.orig/init/main.c
+++ struct-cpumasks/init/main.c
@@ -937,7 +937,7 @@ static int __init kernel_init(void * unu
 	/*
 	 * init can run on any cpu.
 	 */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed(current, CPU_MASK_ALL_PTR);
 	/*
 	 * Tell the world that we're going to be the grim
 	 * reaper of innocent orphaned children.
--- struct-cpumasks.orig/kernel/cpu.c
+++ struct-cpumasks/kernel/cpu.c
@@ -253,7 +253,7 @@ static int __ref _cpu_down(unsigned int 
 	old_allowed = current->cpus_allowed;
 	cpus_setall(tmp);
 	cpu_clear(cpu, tmp);
-	set_cpus_allowed_ptr(current, &tmp);
+	set_cpus_allowed(current, &tmp);
 	tmp = cpumask_of_cpu(cpu);
 
 	err = __stop_machine(take_cpu_down, &tcd_param, &tmp);
@@ -282,7 +282,7 @@ static int __ref _cpu_down(unsigned int 
 	check_for_tasks(cpu);
 
 out_allowed:
-	set_cpus_allowed_ptr(current, &old_allowed);
+	set_cpus_allowed(current, &old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
--- struct-cpumasks.orig/kernel/cpuset.c
+++ struct-cpumasks/kernel/cpuset.c
@@ -837,7 +837,7 @@ static int cpuset_test_cpumask(struct ta
 static void cpuset_change_cpumask(struct task_struct *tsk,
 				  struct cgroup_scanner *scan)
 {
-	set_cpus_allowed_ptr(tsk, &((cgroup_cs(scan->cg))->cpus_allowed));
+	set_cpus_allowed(tsk, &((cgroup_cs(scan->cg))->cpus_allowed));
 }
 
 /**
@@ -1330,7 +1330,7 @@ static void cpuset_attach(struct cgroup_
 
 	mutex_lock(&callback_mutex);
 	guarantee_online_cpus(cs, &cpus);
-	err = set_cpus_allowed_ptr(tsk, &cpus);
+	err = set_cpus_allowed(tsk, &cpus);
 	mutex_unlock(&callback_mutex);
 	if (err)
 		return;
--- struct-cpumasks.orig/kernel/kmod.c
+++ struct-cpumasks/kernel/kmod.c
@@ -166,7 +166,7 @@ static int ____call_usermodehelper(void 
 	}
 
 	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed(current, CPU_MASK_ALL_PTR);
 
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
--- struct-cpumasks.orig/kernel/kthread.c
+++ struct-cpumasks/kernel/kthread.c
@@ -107,7 +107,7 @@ static void create_kthread(struct kthrea
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
+		set_cpus_allowed(create->result, CPU_MASK_ALL_PTR);
 	}
 	complete(&create->done);
 }
@@ -238,7 +238,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
+	set_cpus_allowed(tsk, CPU_MASK_ALL_PTR);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
--- struct-cpumasks.orig/kernel/rcutorture.c
+++ struct-cpumasks/kernel/rcutorture.c
@@ -858,27 +858,27 @@ static void rcu_torture_shuffle_tasks(vo
 	if (rcu_idle_cpu != -1)
 		cpu_clear(rcu_idle_cpu, tmp_mask);
 
-	set_cpus_allowed_ptr(current, &tmp_mask);
+	set_cpus_allowed(current, &tmp_mask);
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
 			if (reader_tasks[i])
-				set_cpus_allowed_ptr(reader_tasks[i],
+				set_cpus_allowed(reader_tasks[i],
 						     &tmp_mask);
 	}
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
-				set_cpus_allowed_ptr(fakewriter_tasks[i],
+				set_cpus_allowed(fakewriter_tasks[i],
 						     &tmp_mask);
 	}
 
 	if (writer_task)
-		set_cpus_allowed_ptr(writer_task, &tmp_mask);
+		set_cpus_allowed(writer_task, &tmp_mask);
 
 	if (stats_task)
-		set_cpus_allowed_ptr(stats_task, &tmp_mask);
+		set_cpus_allowed(stats_task, &tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;
--- struct-cpumasks.orig/kernel/sched.c
+++ struct-cpumasks/kernel/sched.c
@@ -5453,7 +5453,7 @@ long sched_setaffinity(pid_t pid, const 
 	cpuset_cpus_allowed(p, &cpus_allowed);
 	cpus_and(new_mask, new_mask, cpus_allowed);
  again:
-	retval = set_cpus_allowed_ptr(p, &new_mask);
+	retval = set_cpus_allowed(p, &new_mask);
 
 	if (!retval) {
 		cpuset_cpus_allowed(p, &cpus_allowed);
@@ -5970,7 +5970,7 @@ static inline void sched_init_granularit
  * task must not exit() & deallocate itself prematurely. The
  * call is not atomic; no spinlocks may be held.
  */
-int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
+int set_cpus_allowed(struct task_struct *p, const cpumask_t new_mask)
 {
 	struct migration_req req;
 	unsigned long flags;
@@ -5978,13 +5978,13 @@ int set_cpus_allowed_ptr(struct task_str
 	int ret = 0;
 
 	rq = task_rq_lock(p, &flags);
-	if (!cpus_intersects(*new_mask, cpu_online_map)) {
+	if (!cpus_intersects(new_mask, cpu_online_map)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
-		     !cpus_equal(p->cpus_allowed, *new_mask))) {
+		     !cpus_equal(p->cpus_allowed, new_mask))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -6013,7 +6013,7 @@ out:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
+EXPORT_SYMBOL_GPL(set_cpus_allowed);
 
 /*
  * Move (not current) task off this cpu, onto dest cpu. We're doing
@@ -8011,7 +8011,7 @@ void __init sched_init_smp(void)
 	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
-	if (set_cpus_allowed_ptr(current, &non_isolated_cpus) < 0)
+	if (set_cpus_allowed(current, &non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
 }
--- struct-cpumasks.orig/kernel/trace/trace_sysprof.c
+++ struct-cpumasks/kernel/trace/trace_sysprof.c
@@ -213,10 +213,10 @@ static void start_stack_timers(void)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
+		set_cpus_allowed(current, cpumask_of_cpu(cpu));
 		start_stack_timer(cpu);
 	}
-	set_cpus_allowed_ptr(current, &saved_mask);
+	set_cpus_allowed(current, &saved_mask);
 }
 
 static void stop_stack_timer(int cpu)
--- struct-cpumasks.orig/mm/pdflush.c
+++ struct-cpumasks/mm/pdflush.c
@@ -188,7 +188,7 @@ static int pdflush(void *dummy)
 	 * The boottime pdflush's are easily placed w/o these 2 lines.
 	 */
 	cpuset_cpus_allowed(current, &cpus_allowed);
-	set_cpus_allowed_ptr(current, &cpus_allowed);
+	set_cpus_allowed(current, &cpus_allowed);
 
 	return __pdflush(&my_work);
 }
--- struct-cpumasks.orig/mm/vmscan.c
+++ struct-cpumasks/mm/vmscan.c
@@ -1690,7 +1690,7 @@ static int kswapd(void *p)
 	node_to_cpumask_ptr(cpumask, pgdat->node_id);
 
 	if (!cpus_empty(*cpumask))
-		set_cpus_allowed_ptr(tsk, cpumask);
+		set_cpus_allowed(tsk, cpumask);
 	current->reclaim_state = &reclaim_state;
 
 	/*
@@ -1928,7 +1928,7 @@ static int __devinit cpu_callback(struct
 
 			if (any_online_cpu(*mask) < nr_cpu_ids)
 				/* One of our CPUs online: restore mask */
-				set_cpus_allowed_ptr(pgdat->kswapd, mask);
+				set_cpus_allowed(pgdat->kswapd, mask);
 		}
 	}
 	return NOTIFY_OK;
--- struct-cpumasks.orig/net/sunrpc/svc.c
+++ struct-cpumasks/net/sunrpc/svc.c
@@ -310,13 +310,13 @@ svc_pool_map_set_cpumask(struct task_str
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
 	{
-		set_cpus_allowed_ptr(task, cpumask_of_cpu(node));
+		set_cpus_allowed(task, cpumask_of_cpu(node));
 		break;
 	}
 	case SVC_POOL_PERNODE:
 	{
 		node_to_cpumask_ptr(nodecpumask, node);
-		set_cpus_allowed_ptr(task, nodecpumask);
+		set_cpus_allowed(task, nodecpumask);
 		break;
 	}
 	}

-- 
