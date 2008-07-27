Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbYG0TGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbYG0TGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 15:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbYG0TGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 15:06:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39240 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYG0TGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 15:06:32 -0400
Date: Sun, 27 Jul 2008 21:06:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [git pull] cpus4096 fixes
Message-ID: <20080727190601.GA764@elte.hu>
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

Please pull the latest cpus4096-fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git cpus4096

this fixes the cpumask_of_cpu API fallout described here:

   http://lkml.org/lkml/2008/7/23/76

... and the fix is wider than i'd like it to be, so close to -rc1 - but 
it's the cleanest one and it has Rusty's ack as well. These changes have 
been tested thoroughly on x86 in the past 2-3 days and caused no 
problems. Mike cross-compiled them on a lot of architectures:

   http://lkml.org/lkml/2008/7/24/483

or we could also delay it to after -rc1.

Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      cpumask: export cpumask_of_cpu_map

Mike Travis (3):
      cpumask: make cpumask_of_cpu_map generic
      cpumask: put cpumask_of_cpu_map in the initdata section
      cpumask: change cpumask_of_cpu_ptr to use new cpumask_of_cpu


 arch/x86/kernel/acpi/cstate.c                    |    3 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   10 +--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   15 +--
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   12 +--
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    3 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    3 +-
 arch/x86/kernel/ldt.c                            |    6 +-
 arch/x86/kernel/microcode.c                      |   17 +---
 arch/x86/kernel/reboot.c                         |   11 +--
 arch/x86/kernel/setup_percpu.c                   |   10 +-
 drivers/acpi/processor_throttling.c              |   11 +--
 drivers/firmware/dcdbas.c                        |    3 +-
 drivers/misc/sgi-xp/xpc_main.c                   |    3 +-
 include/linux/cpumask.h                          |   41 +-------
 kernel/cpu.c                                     |  113 ++++++++++++++++++++++
 kernel/stop_machine.c                            |    3 +-
 kernel/time/tick-common.c                        |    8 +-
 kernel/trace/trace_sysprof.c                     |    4 +-
 lib/smp_processor_id.c                           |    5 +-
 net/sunrpc/svc.c                                 |    3 +-
 20 files changed, 159 insertions(+), 125 deletions(-)

diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index 9220cf4..c2502eb 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -73,7 +73,6 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	cpumask_t saved_mask;
-	cpumask_of_cpu_ptr(new_mask, cpu);
 	int retval;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int edx_part;
@@ -92,7 +91,7 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 
 	/* Make sure we are running on right CPU */
 	saved_mask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, new_mask);
+	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (retval)
 		return -1;
 
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index ff2fff5..dd097b8 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -200,12 +200,10 @@ static void drv_read(struct drv_cmd *cmd)
 static void drv_write(struct drv_cmd *cmd)
 {
 	cpumask_t saved_mask = current->cpus_allowed;
-	cpumask_of_cpu_ptr_declare(cpu_mask);
 	unsigned int i;
 
 	for_each_cpu_mask_nr(i, cmd->mask) {
-		cpumask_of_cpu_ptr_next(cpu_mask, i);
-		set_cpus_allowed_ptr(current, cpu_mask);
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
 		do_drv_write(cmd);
 	}
 
@@ -269,12 +267,11 @@ static unsigned int get_measured_perf(unsigned int cpu)
 	} aperf_cur, mperf_cur;
 
 	cpumask_t saved_mask;
-	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	unsigned int perf_percent;
 	unsigned int retval;
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpu_mask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (get_cpu() != cpu) {
 		/* We were not able to run on requested processor */
 		put_cpu();
@@ -340,7 +337,6 @@ static unsigned int get_measured_perf(unsigned int cpu)
 
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
-	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, cpu);
 	unsigned int freq;
 	unsigned int cached_freq;
@@ -353,7 +349,7 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 	}
 
 	cached_freq = data->freq_table[data->acpi_data->state].frequency;
-	freq = extract_freq(get_cur_val(cpu_mask), data);
+	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
 	if (freq != cached_freq) {
 		/*
 		 * The dreaded BIOS frequency change behind our back.
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 53c7b69..c45ca6d 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -479,12 +479,11 @@ static int core_voltage_post_transition(struct powernow_k8_data *data, u32 reqvi
 static int check_supported_cpu(unsigned int cpu)
 {
 	cpumask_t oldmask;
-	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	u32 eax, ebx, ecx, edx;
 	unsigned int rc = 0;
 
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpu_mask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", cpu);
@@ -1017,7 +1016,6 @@ static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned i
 static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsigned relation)
 {
 	cpumask_t oldmask;
-	cpumask_of_cpu_ptr(cpu_mask, pol->cpu);
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
@@ -1032,7 +1030,7 @@ static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsi
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpu_mask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1107,7 +1105,6 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask;
-	cpumask_of_cpu_ptr_declare(newmask);
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1159,8 +1156,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	cpumask_of_cpu_ptr_next(newmask, pol->cpu);
-	set_cpus_allowed_ptr(current, newmask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1182,7 +1178,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	set_cpus_allowed_ptr(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cpus = *newmask;
+		pol->cpus = cpumask_of_cpu(pol->cpu);
 	else
 		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
 	data->available_cores = &(pol->cpus);
@@ -1248,7 +1244,6 @@ static unsigned int powernowk8_get (unsigned int cpu)
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask = current->cpus_allowed;
-	cpumask_of_cpu_ptr(newmask, cpu);
 	unsigned int khz = 0;
 	unsigned int first;
 
@@ -1258,7 +1253,7 @@ static unsigned int powernowk8_get (unsigned int cpu)
 	if (!data)
 		return -EINVAL;
 
-	set_cpus_allowed_ptr(current, newmask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX
 			"limiting to CPU %d failed in powernowk8_get\n", cpu);
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index ca2ac13..15e13c0 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -324,10 +324,9 @@ static unsigned int get_cur_freq(unsigned int cpu)
 	unsigned l, h;
 	unsigned clock_freq;
 	cpumask_t saved_mask;
-	cpumask_of_cpu_ptr(new_mask, cpu);
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, new_mask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu)
 		return 0;
 
@@ -585,15 +584,12 @@ static int centrino_target (struct cpufreq_policy *policy,
 		 * Best effort undo..
 		 */
 
-		if (!cpus_empty(*covered_cpus)) {
-			cpumask_of_cpu_ptr_declare(new_mask);
-
+		if (!cpus_empty(*covered_cpus))
 			for_each_cpu_mask_nr(j, *covered_cpus) {
-				cpumask_of_cpu_ptr_next(new_mask, j);
-				set_cpus_allowed_ptr(current, new_mask);
+				set_cpus_allowed_ptr(current,
+						     &cpumask_of_cpu(j));
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
 			}
-		}
 
 		tmp = freqs.new;
 		freqs.new = freqs.old;
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index 2f3728d..191f726 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -244,8 +244,7 @@ static unsigned int _speedstep_get(const cpumask_t *cpus)
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	cpumask_of_cpu_ptr(newmask, cpu);
-	return _speedstep_get(newmask);
+	return _speedstep_get(&cpumask_of_cpu(cpu));
 }
 
 /**
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 650d40f..6b0a10b 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -516,7 +516,6 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 	unsigned long		j;
 	int			retval;
 	cpumask_t		oldmask;
-	cpumask_of_cpu_ptr(newmask, cpu);
 
 	if (num_cache_leaves == 0)
 		return -ENOENT;
@@ -527,7 +526,7 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 		return -ENOMEM;
 
 	oldmask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, newmask);
+	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (retval)
 		goto out;
 
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 3fee2aa..b68e21f 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -62,12 +62,10 @@ static int alloc_ldt(mm_context_t *pc, int mincount, int reload)
 
 	if (reload) {
 #ifdef CONFIG_SMP
-		cpumask_of_cpu_ptr_declare(mask);
-
 		preempt_disable();
 		load_LDT(pc);
-		cpumask_of_cpu_ptr_next(mask, smp_processor_id());
-		if (!cpus_equal(current->mm->cpu_vm_mask, *mask))
+		if (!cpus_equal(current->mm->cpu_vm_mask,
+				cpumask_of_cpu(smp_processor_id())))
 			smp_call_function(flush_ldt, current->mm, 1);
 		preempt_enable();
 #else
diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 6994c75..652fa5c 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -388,7 +388,6 @@ static int do_microcode_update (void)
 	void *new_mc = NULL;
 	int cpu;
 	cpumask_t old;
-	cpumask_of_cpu_ptr_declare(newmask);
 
 	old = current->cpus_allowed;
 
@@ -405,8 +404,7 @@ static int do_microcode_update (void)
 
 			if (!uci->valid)
 				continue;
-			cpumask_of_cpu_ptr_next(newmask, cpu);
-			set_cpus_allowed_ptr(current, newmask);
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 			error = get_maching_microcode(new_mc, cpu);
 			if (error < 0)
 				goto out;
@@ -576,7 +574,6 @@ static int apply_microcode_check_cpu(int cpu)
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	cpumask_t old;
-	cpumask_of_cpu_ptr(newmask, cpu);
 	unsigned int val[2];
 	int err = 0;
 
@@ -585,7 +582,7 @@ static int apply_microcode_check_cpu(int cpu)
 		return 0;
 
 	old = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, newmask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 
 	/* Check if the microcode we have in memory matches the CPU */
 	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
@@ -623,12 +620,11 @@ static int apply_microcode_check_cpu(int cpu)
 static void microcode_init_cpu(int cpu, int resume)
 {
 	cpumask_t old;
-	cpumask_of_cpu_ptr(newmask, cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 	old = current->cpus_allowed;
 
-	set_cpus_allowed_ptr(current, newmask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	mutex_lock(&microcode_mutex);
 	collect_cpu_info(cpu);
 	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
@@ -661,13 +657,10 @@ static ssize_t reload_store(struct sys_device *dev,
 	if (end == buf)
 		return -EINVAL;
 	if (val == 1) {
-		cpumask_t old;
-		cpumask_of_cpu_ptr(newmask, cpu);
-
-		old = current->cpus_allowed;
+		cpumask_t old = current->cpus_allowed;
 
 		get_online_cpus();
-		set_cpus_allowed_ptr(current, newmask);
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 
 		mutex_lock(&microcode_mutex);
 		if (uci->valid)
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 06a9f64..724adfc 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -414,25 +414,20 @@ void native_machine_shutdown(void)
 
 	/* The boot cpu is always logical cpu 0 */
 	int reboot_cpu_id = 0;
-	cpumask_of_cpu_ptr(newmask, reboot_cpu_id);
 
 #ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
 	if ((reboot_cpu != -1) && (reboot_cpu < NR_CPUS) &&
-		cpu_online(reboot_cpu)) {
+		cpu_online(reboot_cpu))
 		reboot_cpu_id = reboot_cpu;
-		cpumask_of_cpu_ptr_next(newmask, reboot_cpu_id);
-	}
 #endif
 
 	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_online(reboot_cpu_id)) {
+	if (!cpu_online(reboot_cpu_id))
 		reboot_cpu_id = smp_processor_id();
-		cpumask_of_cpu_ptr_next(newmask, reboot_cpu_id);
-	}
 
 	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, newmask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(reboot_cpu_id));
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index f7745f9..1cd53df 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -81,10 +81,12 @@ static void __init setup_per_cpu_maps(void)
 }
 
 #ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
-cpumask_t *cpumask_of_cpu_map __read_mostly;
-EXPORT_SYMBOL(cpumask_of_cpu_map);
-
-/* requires nr_cpu_ids to be initialized */
+/*
+ * Replace static cpumask_of_cpu_map in the initdata section,
+ * with one that's allocated sized by the possible number of cpus.
+ *
+ * (requires nr_cpu_ids to be initialized)
+ */
 static void __init setup_cpumask_of_cpu(void)
 {
 	int i;
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index a2c3f9c..a56fc6c 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -827,7 +827,6 @@ static int acpi_processor_get_throttling_ptc(struct acpi_processor *pr)
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
 	cpumask_t saved_mask;
-	cpumask_of_cpu_ptr_declare(new_mask);
 	int ret;
 
 	if (!pr)
@@ -839,8 +838,7 @@ static int acpi_processor_get_throttling(struct acpi_processor *pr)
 	 * Migrate task to the cpu pointed by pr.
 	 */
 	saved_mask = current->cpus_allowed;
-	cpumask_of_cpu_ptr_next(new_mask, pr->id);
-	set_cpus_allowed_ptr(current, new_mask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
 	/* restore the previous state */
 	set_cpus_allowed_ptr(current, &saved_mask);
@@ -989,7 +987,6 @@ static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
 	cpumask_t saved_mask;
-	cpumask_of_cpu_ptr_declare(new_mask);
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
@@ -1028,8 +1025,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		cpumask_of_cpu_ptr_next(new_mask, pr->id);
-		set_cpus_allowed_ptr(current, new_mask);
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
 		ret = p_throttling->acpi_processor_set_throttling(pr,
 						t_state.target_state);
 	} else {
@@ -1060,8 +1056,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 				continue;
 			}
 			t_state.cpu = i;
-			cpumask_of_cpu_ptr_next(new_mask, i);
-			set_cpus_allowed_ptr(current, new_mask);
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
 			ret = match_pr->throttling.
 				acpi_processor_set_throttling(
 				match_pr, t_state.target_state);
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index c66817e..50a071f 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -245,7 +245,6 @@ static ssize_t host_control_on_shutdown_store(struct device *dev,
 static int smi_request(struct smi_cmd *smi_cmd)
 {
 	cpumask_t old_mask;
-	cpumask_of_cpu_ptr(new_mask, 0);
 	int ret = 0;
 
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
@@ -256,7 +255,7 @@ static int smi_request(struct smi_cmd *smi_cmd)
 
 	/* SMI requires CPU 0 */
 	old_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, new_mask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
 			__func__);
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index 579b01f..c3b4227 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -229,11 +229,10 @@ xpc_hb_checker(void *ignore)
 	int last_IRQ_count = 0;
 	int new_IRQ_count;
 	int force_IRQ = 0;
-	cpumask_of_cpu_ptr(cpumask, XPC_HB_CHECK_CPU);
 
 	/* this thread was marked active by xpc_hb_init() */
 
-	set_cpus_allowed_ptr(current, cpumask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(XPC_HB_CHECK_CPU));
 
 	/* set our heartbeating to other partitions into motion */
 	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 1b5c98e..8fa3b6d 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -62,15 +62,7 @@
  * int next_cpu_nr(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
  *
  * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
- *ifdef CONFIG_HAS_CPUMASK_OF_CPU
- * cpumask_of_cpu_ptr_declare(v)	Declares cpumask_t *v
- * cpumask_of_cpu_ptr_next(v, cpu)	Sets v = &cpumask_of_cpu_map[cpu]
- * cpumask_of_cpu_ptr(v, cpu)		Combines above two operations
- *else
- * cpumask_of_cpu_ptr_declare(v)	Declares cpumask_t _v and *v = &_v
- * cpumask_of_cpu_ptr_next(v, cpu)	Sets _v = cpumask_of_cpu(cpu)
- * cpumask_of_cpu_ptr(v, cpu)		Combines above two operations
- *endif
+ *					(can be used as an lvalue)
  * CPU_MASK_ALL				Initializer - all bits set
  * CPU_MASK_NONE			Initializer - no bits set
  * unsigned long *cpus_addr(mask)	Array of unsigned long's in mask
@@ -274,36 +266,9 @@ static inline void __cpus_shift_left(cpumask_t *dstp,
 }
 
 
-#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
-extern cpumask_t *cpumask_of_cpu_map;
+/* cpumask_of_cpu_map[] is in kernel/cpu.c */
+extern const cpumask_t *cpumask_of_cpu_map;
 #define cpumask_of_cpu(cpu)	(cpumask_of_cpu_map[cpu])
-#define	cpumask_of_cpu_ptr(v, cpu)					\
-		const cpumask_t *v = &cpumask_of_cpu(cpu)
-#define	cpumask_of_cpu_ptr_declare(v)					\
-		const cpumask_t *v
-#define cpumask_of_cpu_ptr_next(v, cpu)					\
-					v = &cpumask_of_cpu(cpu)
-#else
-#define cpumask_of_cpu(cpu)						\
-({									\
-	typeof(_unused_cpumask_arg_) m;					\
-	if (sizeof(m) == sizeof(unsigned long)) {			\
-		m.bits[0] = 1UL<<(cpu);					\
-	} else {							\
-		cpus_clear(m);						\
-		cpu_set((cpu), m);					\
-	}								\
-	m;								\
-})
-#define	cpumask_of_cpu_ptr(v, cpu) 					\
-		cpumask_t _##v = cpumask_of_cpu(cpu);			\
-		const cpumask_t *v = &_##v
-#define	cpumask_of_cpu_ptr_declare(v)					\
-		cpumask_t _##v;						\
-		const cpumask_t *v = &_##v
-#define cpumask_of_cpu_ptr_next(v, cpu)					\
-					_##v = cpumask_of_cpu(cpu)
-#endif
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 10ba5f1..a35d899 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -461,3 +461,116 @@ out:
 #endif /* CONFIG_PM_SLEEP_SMP */
 
 #endif /* CONFIG_SMP */
+
+/* 64 bits of zeros, for initializers. */
+#if BITS_PER_LONG == 32
+#define Z64 0, 0
+#else
+#define Z64 0
+#endif
+
+/* Initializer macros. */
+#define CMI0(n) { .bits = { 1UL << (n) } }
+#define CMI(n, ...) { .bits = { __VA_ARGS__, 1UL << ((n) % BITS_PER_LONG) } }
+
+#define CMI8(n, ...)						\
+	CMI((n), __VA_ARGS__), CMI((n)+1, __VA_ARGS__),		\
+	CMI((n)+2, __VA_ARGS__), CMI((n)+3, __VA_ARGS__),	\
+	CMI((n)+4, __VA_ARGS__), CMI((n)+5, __VA_ARGS__),	\
+	CMI((n)+6, __VA_ARGS__), CMI((n)+7, __VA_ARGS__)
+
+#if BITS_PER_LONG == 32
+#define CMI64(n, ...)							\
+	CMI8((n), __VA_ARGS__), CMI8((n)+8, __VA_ARGS__),		\
+	CMI8((n)+16, __VA_ARGS__), CMI8((n)+24, __VA_ARGS__),		\
+	CMI8((n)+32, 0, __VA_ARGS__), CMI8((n)+40, 0, __VA_ARGS__),	\
+	CMI8((n)+48, 0, __VA_ARGS__), CMI8((n)+56, 0, __VA_ARGS__)
+#else
+#define CMI64(n, ...)							\
+	CMI8((n), __VA_ARGS__), CMI8((n)+8, __VA_ARGS__),		\
+	CMI8((n)+16, __VA_ARGS__), CMI8((n)+24, __VA_ARGS__),		\
+	CMI8((n)+32, __VA_ARGS__), CMI8((n)+40, __VA_ARGS__),	\
+	CMI8((n)+48, __VA_ARGS__), CMI8((n)+56, __VA_ARGS__)
+#endif
+
+#define CMI256(n, ...)							\
+	CMI64((n), __VA_ARGS__), CMI64((n)+64, Z64, __VA_ARGS__),	\
+	CMI64((n)+128, Z64, Z64, __VA_ARGS__),				\
+	CMI64((n)+192, Z64, Z64, Z64, __VA_ARGS__)
+#define Z256 Z64, Z64, Z64, Z64
+
+#define CMI1024(n, ...)					\
+	CMI256((n), __VA_ARGS__),			\
+	CMI256((n)+256, Z256, __VA_ARGS__),		\
+	CMI256((n)+512, Z256, Z256, __VA_ARGS__),	\
+	CMI256((n)+768, Z256, Z256, Z256, __VA_ARGS__)
+#define Z1024 Z256, Z256, Z256, Z256
+
+/* We want this statically initialized, just to be safe.  We try not
+ * to waste too much space, either. */
+static const cpumask_t cpumask_map[]
+#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+__initdata
+#endif
+= {
+	CMI0(0), CMI0(1), CMI0(2), CMI0(3),
+#if NR_CPUS > 4
+	CMI0(4), CMI0(5), CMI0(6), CMI0(7),
+#endif
+#if NR_CPUS > 8
+	CMI0(8), CMI0(9), CMI0(10), CMI0(11),
+	CMI0(12), CMI0(13), CMI0(14), CMI0(15),
+#endif
+#if NR_CPUS > 16
+	CMI0(16), CMI0(17), CMI0(18), CMI0(19),
+	CMI0(20), CMI0(21), CMI0(22), CMI0(23),
+	CMI0(24), CMI0(25), CMI0(26), CMI0(27),
+	CMI0(28), CMI0(29), CMI0(30), CMI0(31),
+#endif
+#if NR_CPUS > 32
+#if BITS_PER_LONG == 32
+	CMI(32, 0), CMI(33, 0), CMI(34, 0), CMI(35, 0),
+	CMI(36, 0), CMI(37, 0), CMI(38, 0), CMI(39, 0),
+	CMI(40, 0), CMI(41, 0), CMI(42, 0), CMI(43, 0),
+	CMI(44, 0), CMI(45, 0), CMI(46, 0), CMI(47, 0),
+	CMI(48, 0), CMI(49, 0), CMI(50, 0), CMI(51, 0),
+	CMI(52, 0), CMI(53, 0), CMI(54, 0), CMI(55, 0),
+	CMI(56, 0), CMI(57, 0), CMI(58, 0), CMI(59, 0),
+	CMI(60, 0), CMI(61, 0), CMI(62, 0), CMI(63, 0),
+#else
+	CMI0(32), CMI0(33), CMI0(34), CMI0(35),
+	CMI0(36), CMI0(37), CMI0(38), CMI0(39),
+	CMI0(40), CMI0(41), CMI0(42), CMI0(43),
+	CMI0(44), CMI0(45), CMI0(46), CMI0(47),
+	CMI0(48), CMI0(49), CMI0(50), CMI0(51),
+	CMI0(52), CMI0(53), CMI0(54), CMI0(55),
+	CMI0(56), CMI0(57), CMI0(58), CMI0(59),
+	CMI0(60), CMI0(61), CMI0(62), CMI0(63),
+#endif /* BITS_PER_LONG == 64 */
+#endif
+#if NR_CPUS > 64
+	CMI64(64, Z64),
+#endif
+#if NR_CPUS > 128
+	CMI64(128, Z64, Z64), CMI64(192, Z64, Z64, Z64),
+#endif
+#if NR_CPUS > 256
+	CMI256(256, Z256),
+#endif
+#if NR_CPUS > 512
+	CMI256(512, Z256, Z256), CMI256(768, Z256, Z256, Z256),
+#endif
+#if NR_CPUS > 1024
+	CMI1024(1024, Z1024),
+#endif
+#if NR_CPUS > 2048
+	CMI1024(2048, Z1024, Z1024), CMI1024(3072, Z1024, Z1024, Z1024),
+#endif
+#if NR_CPUS > 4096
+#error NR_CPUS too big.  Fix initializers or set CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+#endif
+};
+
+const cpumask_t *cpumask_of_cpu_map = cpumask_map;
+
+EXPORT_SYMBOL_GPL(cpumask_of_cpu_map);
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 738b411..ba9b205 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -33,9 +33,8 @@ static int stopmachine(void *cpu)
 {
 	int irqs_disabled = 0;
 	int prepared = 0;
-	cpumask_of_cpu_ptr(cpumask, (int)(long)cpu);
 
-	set_cpus_allowed_ptr(current, cpumask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu((int)(long)cpu));
 
 	/* Ack: we are alive */
 	smp_mb(); /* Theoretically the ack = 0 might not be on this CPU yet. */
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index bf43284..80c4336 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -196,12 +196,10 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 	struct tick_device *td;
 	int cpu, ret = NOTIFY_OK;
 	unsigned long flags;
-	cpumask_of_cpu_ptr_declare(cpumask);
 
 	spin_lock_irqsave(&tick_device_lock, flags);
 
 	cpu = smp_processor_id();
-	cpumask_of_cpu_ptr_next(cpumask, cpu);
 	if (!cpu_isset(cpu, newdev->cpumask))
 		goto out_bc;
 
@@ -209,7 +207,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 	curdev = td->evtdev;
 
 	/* cpu local device ? */
-	if (!cpus_equal(newdev->cpumask, *cpumask)) {
+	if (!cpus_equal(newdev->cpumask, cpumask_of_cpu(cpu))) {
 
 		/*
 		 * If the cpu affinity of the device interrupt can not
@@ -222,7 +220,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 		 * If we have a cpu local device already, do not replace it
 		 * by a non cpu local device
 		 */
-		if (curdev && cpus_equal(curdev->cpumask, *cpumask))
+		if (curdev && cpus_equal(curdev->cpumask, cpumask_of_cpu(cpu)))
 			goto out_bc;
 	}
 
@@ -254,7 +252,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 		curdev = NULL;
 	}
 	clockevents_exchange_device(curdev, newdev);
-	tick_setup_device(td, newdev, cpu, cpumask);
+	tick_setup_device(td, newdev, cpu, &cpumask_of_cpu(cpu));
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index ce2d723..bb948e5 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -213,9 +213,7 @@ static void start_stack_timers(void)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		cpumask_of_cpu_ptr(new_mask, cpu);
-
-		set_cpus_allowed_ptr(current, new_mask);
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 		start_stack_timer(cpu);
 	}
 	set_cpus_allowed_ptr(current, &saved_mask);
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index c4381d9..0f8fc22 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -11,7 +11,6 @@ notrace unsigned int debug_smp_processor_id(void)
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
-	cpumask_of_cpu_ptr_declare(this_mask);
 
 	if (likely(preempt_count))
 		goto out;
@@ -23,9 +22,7 @@ notrace unsigned int debug_smp_processor_id(void)
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	cpumask_of_cpu_ptr_next(this_mask, this_cpu);
-
-	if (cpus_equal(current->cpus_allowed, *this_mask))
+	if (cpus_equal(current->cpus_allowed, cpumask_of_cpu(this_cpu)))
 		goto out;
 
 	/*
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 835d274..5a32cb7 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -310,8 +310,7 @@ svc_pool_map_set_cpumask(struct task_struct *task, unsigned int pidx)
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
 	{
-		cpumask_of_cpu_ptr(cpumask, node);
-		set_cpus_allowed_ptr(task, cpumask);
+		set_cpus_allowed_ptr(task, &cpumask_of_cpu(node));
 		break;
 	}
 	case SVC_POOL_PERNODE:
