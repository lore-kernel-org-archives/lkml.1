Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbYGOVRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbYGOVRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbYGOVOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:14:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38254 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755928AbYGOVOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:14:33 -0400
Message-Id: <20080715211429.629983000@polaris-admin.engr.sgi.com>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 14:14:30 -0700
From: Mike Travis <travis@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Dave Jones <davej@codemonkey.org.uk>,
       Paul Jackson <pj@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Robert Richter <robert.richter@amd.com>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH 1/8] cpumask: Replace cpumask_of_cpu with cpumask_of_cpu_ptr
Content-Disposition: inline; filename=replace-cpumask_of_cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * This patch replaces the dangerous lvalue version of cpumask_of_cpu
    with new cpumask_of_cpu_ptr macros.  These are patterned after the
    node_to_cpumask_ptr macros.

    In general terms, if there is a cpumask_of_cpu_map[] then a pointer to
    the cpumask_of_cpu_map[cpu] entry is used.  The cpumask_of_cpu_map
    is provided when there is a large NR_CPUS count, reducing
    greatly the amount of code generated and stack space used for
    cpumask_of_cpu().  The pointer to the cpumask_t value is needed for
    calling set_cpus_allowed_ptr() to reduce the amount of stack space
    needed to pass the cpumask_t value.

    If there isn't a cpumask_of_cpu_map[], then a temporary variable is
    declared and filled in with value from cpumask_of_cpu(cpu) as well as
    a pointer variable pointing to this temporary variable.  Afterwards,
    the pointer is used to reference the cpumask value.  The compiler
    will optimize out the extra dereference through the pointer as well
    as the stack space used for the pointer, resulting in identical code.

    A good example of the orthogonal usages is in net/sunrpc/svc.c:

	case SVC_POOL_PERCPU:
	{
		unsigned int cpu = m->pool_to[pidx];
		cpumask_of_cpu_ptr(cpumask, cpu);

		*oldmask = current->cpus_allowed;
		set_cpus_allowed_ptr(current, cpumask);
		return 1;
	}
	case SVC_POOL_PERNODE:
	{
		unsigned int node = m->pool_to[pidx];
		node_to_cpumask_ptr(nodecpumask, node);

		*oldmask = current->cpus_allowed;
		set_cpus_allowed_ptr(current, nodecpumask);
		return 1;
	}

Based on linux-2.6.tip/master at the following commit:

    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
    Merge: 9a635fa... 724dce0...
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Tue Jul 15 14:55:17 2008 +0200

Signed-off-by: Mike Travis <travis@sgi.com>

* ACPI
Cc: Len Brown <len.brown@intel.com>

* CPUFREQ
Cc: Dave Jones <davej@codemonkey.org.uk>

* CPUMASK
Cc: Paul Jackson <pj@sgi.com>

* MICROCODE
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>

* PROFILE
Cc: Robert Richter <robert.richter@amd.com>

* SUNRPC
Cc: Greg Banks <gnb@sgi.com>

* Various
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Schwab <schwab@suse.de>
Cc: Johannes Weiner <hannes@saeurebad.de>

---

    Unfortunately, I cannot break down this patch into separate pieces
    as reverting the cpumask_of_cpu() macro back to it's prior form will
    result in compile errors when referenced as an lvalue.

	One error from checkpatch.pl:

	ERROR: Macros with complex values should be enclosed in parenthesis
	#472: FILE: include/linux/cpumask.h:253:
	+#define cpumask_of_cpu_ptr_next(v, cpu) \
	+                               v = &cpumask_of_cpu(cpu)
---
 arch/x86/kernel/acpi/cstate.c                    |    3 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   10 +++++--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   15 +++++++---
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    9 ++++--
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    3 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    3 +-
 arch/x86/kernel/microcode.c                      |   13 ++++++---
 arch/x86/kernel/reboot.c                         |   14 ++++++----
 drivers/acpi/processor_throttling.c              |   11 +++++--
 drivers/firmware/dcdbas.c                        |    3 +-
 include/linux/cpumask.h                          |   32 +++++++++++++++++++----
 kernel/stop_machine.c                            |    3 +-
 kernel/trace/trace_sysprof.c                     |    4 ++
 net/sunrpc/svc.c                                 |    3 +-
 14 files changed, 91 insertions(+), 35 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/acpi/cstate.c
+++ linux-2.6.tip/arch/x86/kernel/acpi/cstate.c
@@ -73,6 +73,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr(new_mask, cpu);
 	int retval;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int edx_part;
@@ -91,7 +92,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 
 	/* Make sure we are running on right CPU */
 	saved_mask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed_ptr(current, new_mask);
 	if (retval)
 		return -1;
 
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -200,10 +200,12 @@ static void drv_read(struct drv_cmd *cmd
 static void drv_write(struct drv_cmd *cmd)
 {
 	cpumask_t saved_mask = current->cpus_allowed;
+	cpumask_of_cpu_ptr_declare(cpu_mask);
 	unsigned int i;
 
 	for_each_cpu_mask_nr(i, cmd->mask) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+		cpumask_of_cpu_ptr_next(cpu_mask, i);
+		set_cpus_allowed_ptr(current, cpu_mask);
 		do_drv_write(cmd);
 	}
 
@@ -267,11 +269,12 @@ static unsigned int get_measured_perf(un
 	} aperf_cur, mperf_cur;
 
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	unsigned int perf_percent;
 	unsigned int retval;
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpu_mask);
 	if (get_cpu() != cpu) {
 		/* We were not able to run on requested processor */
 		put_cpu();
@@ -337,6 +340,7 @@ static unsigned int get_measured_perf(un
 
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
+	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, cpu);
 	unsigned int freq;
 	unsigned int cached_freq;
@@ -349,7 +353,7 @@ static unsigned int get_cur_freq_on_cpu(
 	}
 
 	cached_freq = data->freq_table[data->acpi_data->state].frequency;
-	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
+	freq = extract_freq(get_cur_val(cpu_mask), data);
 	if (freq != cached_freq) {
 		/*
 		 * The dreaded BIOS frequency change behind our back.
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -479,11 +479,12 @@ static int core_voltage_post_transition(
 static int check_supported_cpu(unsigned int cpu)
 {
 	cpumask_t oldmask;
+	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	u32 eax, ebx, ecx, edx;
 	unsigned int rc = 0;
 
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpu_mask);
 
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", cpu);
@@ -1016,6 +1017,7 @@ static int transition_frequency_pstate(s
 static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsigned relation)
 {
 	cpumask_t oldmask;
+	cpumask_of_cpu_ptr(cpu_mask, pol->cpu);
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
@@ -1030,7 +1032,7 @@ static int powernowk8_target(struct cpuf
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	set_cpus_allowed_ptr(current, cpu_mask);
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1105,6 +1107,7 @@ static int __cpuinit powernowk8_cpu_init
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask;
+	cpumask_of_cpu_ptr_declare(newmask);
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1156,7 +1159,8 @@ static int __cpuinit powernowk8_cpu_init
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	cpumask_of_cpu_ptr_next(newmask, pol->cpu);
+	set_cpus_allowed_ptr(current, newmask);
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1178,7 +1182,7 @@ static int __cpuinit powernowk8_cpu_init
 	set_cpus_allowed_ptr(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cpus = cpumask_of_cpu(pol->cpu);
+		pol->cpus = *newmask;
 	else
 		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
 	data->available_cores = &(pol->cpus);
@@ -1244,6 +1248,7 @@ static unsigned int powernowk8_get (unsi
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask = current->cpus_allowed;
+	cpumask_of_cpu_ptr(newmask, cpu);
 	unsigned int khz = 0;
 	unsigned int first;
 
@@ -1253,7 +1258,7 @@ static unsigned int powernowk8_get (unsi
 	if (!data)
 		return -EINVAL;
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, newmask);
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX
 			"limiting to CPU %d failed in powernowk8_get\n", cpu);
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -406,9 +406,10 @@ static unsigned int get_cur_freq(unsigne
 	unsigned l, h;
 	unsigned clock_freq;
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr(new_mask, cpu);
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, new_mask);
 	if (smp_processor_id() != cpu)
 		return 0;
 
@@ -647,9 +648,11 @@ static int centrino_target (struct cpufr
 		 */
 
 		if (!cpus_empty(covered_cpus)) {
+			cpumask_of_cpu_ptr_declare(new_mask);
+
 			for_each_cpu_mask_nr(j, covered_cpus) {
-				set_cpus_allowed_ptr(current,
-						     &cpumask_of_cpu(j));
+				cpumask_of_cpu_ptr_next(new_mask, j);
+				set_cpus_allowed_ptr(current, new_mask);
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
 			}
 		}
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -244,7 +244,8 @@ static unsigned int _speedstep_get(const
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	return _speedstep_get(&cpumask_of_cpu(cpu));
+	cpumask_of_cpu_ptr(newmask, cpu);
+	return _speedstep_get(newmask);
 }
 
 /**
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -516,6 +516,7 @@ static int __cpuinit detect_cache_attrib
 	unsigned long		j;
 	int			retval;
 	cpumask_t		oldmask;
+	cpumask_of_cpu_ptr(newmask, cpu);
 
 	if (num_cache_leaves == 0)
 		return -ENOENT;
@@ -526,7 +527,7 @@ static int __cpuinit detect_cache_attrib
 		return -ENOMEM;
 
 	oldmask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed_ptr(current, newmask);
 	if (retval)
 		goto out;
 
--- linux-2.6.tip.orig/arch/x86/kernel/microcode.c
+++ linux-2.6.tip/arch/x86/kernel/microcode.c
@@ -388,6 +388,7 @@ static int do_microcode_update (void)
 	void *new_mc = NULL;
 	int cpu;
 	cpumask_t old;
+	cpumask_of_cpu_ptr_declare(newmask);
 
 	old = current->cpus_allowed;
 
@@ -404,7 +405,8 @@ static int do_microcode_update (void)
 
 			if (!uci->valid)
 				continue;
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+			cpumask_of_cpu_ptr_next(newmask, cpu);
+			set_cpus_allowed_ptr(current, newmask);
 			error = get_maching_microcode(new_mc, cpu);
 			if (error < 0)
 				goto out;
@@ -574,6 +576,7 @@ static int apply_microcode_check_cpu(int
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	cpumask_t old;
+	cpumask_of_cpu_ptr(newmask, cpu);
 	unsigned int val[2];
 	int err = 0;
 
@@ -582,7 +585,7 @@ static int apply_microcode_check_cpu(int
 		return 0;
 
 	old = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, newmask);
 
 	/* Check if the microcode we have in memory matches the CPU */
 	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
@@ -620,11 +623,12 @@ static int apply_microcode_check_cpu(int
 static void microcode_init_cpu(int cpu, int resume)
 {
 	cpumask_t old;
+	cpumask_of_cpu_ptr(newmask, cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 	old = current->cpus_allowed;
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, newmask);
 	mutex_lock(&microcode_mutex);
 	collect_cpu_info(cpu);
 	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
@@ -656,11 +660,12 @@ static ssize_t reload_store(struct sys_d
 		return -EINVAL;
 	if (val == 1) {
 		cpumask_t old;
+		cpumask_of_cpu_ptr(newmask, cpu);
 
 		old = current->cpus_allowed;
 
 		get_online_cpus();
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		set_cpus_allowed_ptr(current, newmask);
 
 		mutex_lock(&microcode_mutex);
 		if (uci->valid)
--- linux-2.6.tip.orig/arch/x86/kernel/reboot.c
+++ linux-2.6.tip/arch/x86/kernel/reboot.c
@@ -403,24 +403,28 @@ void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
-	int reboot_cpu_id;
 
 	/* The boot cpu is always logical cpu 0 */
-	reboot_cpu_id = 0;
+	int reboot_cpu_id = 0;
+	cpumask_of_cpu_ptr(newmask, reboot_cpu_id);
 
 #ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
 	if ((reboot_cpu != -1) && (reboot_cpu < NR_CPUS) &&
-		cpu_online(reboot_cpu))
+		cpu_online(reboot_cpu)) {
 		reboot_cpu_id = reboot_cpu;
+		cpumask_of_cpu_ptr_next(newmask, reboot_cpu_id);
+	}
 #endif
 
 	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_online(reboot_cpu_id))
+	if (!cpu_online(reboot_cpu_id)) {
 		reboot_cpu_id = smp_processor_id();
+		cpumask_of_cpu_ptr_next(newmask, reboot_cpu_id);
+	}
 
 	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(reboot_cpu_id));
+	set_cpus_allowed_ptr(current, newmask);
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
--- linux-2.6.tip.orig/drivers/acpi/processor_throttling.c
+++ linux-2.6.tip/drivers/acpi/processor_throttling.c
@@ -827,6 +827,7 @@ static int acpi_processor_get_throttling
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr_declare(new_mask);
 	int ret;
 
 	if (!pr)
@@ -838,7 +839,8 @@ static int acpi_processor_get_throttling
 	 * Migrate task to the cpu pointed by pr.
 	 */
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
+	cpumask_of_cpu_ptr_next(new_mask, pr->id);
+	set_cpus_allowed_ptr(current, new_mask);
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
 	/* restore the previous state */
 	set_cpus_allowed_ptr(current, &saved_mask);
@@ -987,6 +989,7 @@ static int acpi_processor_set_throttling
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr_declare(new_mask);
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
@@ -1025,7 +1028,8 @@ int acpi_processor_set_throttling(struct
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
+		cpumask_of_cpu_ptr_next(new_mask, pr->id);
+		set_cpus_allowed_ptr(current, new_mask);
 		ret = p_throttling->acpi_processor_set_throttling(pr,
 						t_state.target_state);
 	} else {
@@ -1056,7 +1060,8 @@ int acpi_processor_set_throttling(struct
 				continue;
 			}
 			t_state.cpu = i;
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+			cpumask_of_cpu_ptr_next(new_mask, i);
+			set_cpus_allowed_ptr(current, new_mask);
 			ret = match_pr->throttling.
 				acpi_processor_set_throttling(
 				match_pr, t_state.target_state);
--- linux-2.6.tip.orig/drivers/firmware/dcdbas.c
+++ linux-2.6.tip/drivers/firmware/dcdbas.c
@@ -254,6 +254,7 @@ static ssize_t host_control_on_shutdown_
 static int smi_request(struct smi_cmd *smi_cmd)
 {
 	cpumask_t old_mask;
+	cpumask_of_cpu_ptr(new_mask, 0);
 	int ret = 0;
 
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
@@ -264,7 +265,7 @@ static int smi_request(struct smi_cmd *s
 
 	/* SMI requires CPU 0 */
 	old_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
+	set_cpus_allowed_ptr(current, new_mask);
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
 			__func__);
--- linux-2.6.tip.orig/include/linux/cpumask.h
+++ linux-2.6.tip/include/linux/cpumask.h
@@ -62,6 +62,15 @@
  * int next_cpu_nr(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
  *
  * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
+ *ifdef CONFIG_HAS_CPUMASK_OF_CPU
+ * cpumask_of_cpu_ptr_declare(v)	Declares cpumask_t *v
+ * cpumask_of_cpu_ptr_next(v, cpu)	Sets v = &cpumask_of_cpu_map[cpu]
+ * cpumask_of_cpu_ptr(v, cpu)		Combines above two operations
+ *else
+ * cpumask_of_cpu_ptr_declare(v)	Declares cpumask_t _v and *v = &_v
+ * cpumask_of_cpu_ptr_next(v, cpu)	Sets _v = cpumask_of_cpu(cpu)
+ * cpumask_of_cpu_ptr(v, cpu)		Combines above two operations
+ *endif
  * CPU_MASK_ALL				Initializer - all bits set
  * CPU_MASK_NONE			Initializer - no bits set
  * unsigned long *cpus_addr(mask)	Array of unsigned long's in mask
@@ -236,11 +245,16 @@ static inline void __cpus_shift_left(cpu
 
 #ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
 extern cpumask_t *cpumask_of_cpu_map;
-#define cpumask_of_cpu(cpu)    (cpumask_of_cpu_map[cpu])
-
+#define cpumask_of_cpu(cpu)	(cpumask_of_cpu_map[cpu])
+#define	cpumask_of_cpu_ptr(v, cpu)					\
+		const cpumask_t *v = &cpumask_of_cpu(cpu)
+#define	cpumask_of_cpu_ptr_declare(v)					\
+		const cpumask_t *v
+#define cpumask_of_cpu_ptr_next(v, cpu)					\
+					v = &cpumask_of_cpu(cpu)
 #else
 #define cpumask_of_cpu(cpu)						\
-(*({									\
+({									\
 	typeof(_unused_cpumask_arg_) m;					\
 	if (sizeof(m) == sizeof(unsigned long)) {			\
 		m.bits[0] = 1UL<<(cpu);					\
@@ -248,8 +262,16 @@ extern cpumask_t *cpumask_of_cpu_map;
 		cpus_clear(m);						\
 		cpu_set((cpu), m);					\
 	}								\
-	&m;								\
-}))
+	m;								\
+})
+#define	cpumask_of_cpu_ptr(v, cpu) 					\
+		cpumask_t _##v = cpumask_of_cpu(cpu);			\
+		const cpumask_t *v = &_##v
+#define	cpumask_of_cpu_ptr_declare(v)					\
+		cpumask_t _##v;						\
+		const cpumask_t *v = &_##v
+#define cpumask_of_cpu_ptr_next(v, cpu)					\
+					_##v = cpumask_of_cpu(cpu)
 #endif
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
--- linux-2.6.tip.orig/kernel/stop_machine.c
+++ linux-2.6.tip/kernel/stop_machine.c
@@ -33,8 +33,9 @@ static int stopmachine(void *cpu)
 {
 	int irqs_disabled = 0;
 	int prepared = 0;
+	cpumask_of_cpu_ptr(cpumask, (int)(long)cpu);
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu((int)(long)cpu));
+	set_cpus_allowed_ptr(current, cpumask);
 
 	/* Ack: we are alive */
 	smp_mb(); /* Theoretically the ack = 0 might not be on this CPU yet. */
--- linux-2.6.tip.orig/kernel/trace/trace_sysprof.c
+++ linux-2.6.tip/kernel/trace/trace_sysprof.c
@@ -213,7 +213,9 @@ static void start_stack_timers(void)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		cpumask_of_cpu_ptr(new_mask, cpu);
+
+		set_cpus_allowed_ptr(current, new_mask);
 		start_stack_timer(cpu);
 	}
 	set_cpus_allowed_ptr(current, &saved_mask);
--- linux-2.6.tip.orig/net/sunrpc/svc.c
+++ linux-2.6.tip/net/sunrpc/svc.c
@@ -314,9 +314,10 @@ svc_pool_map_set_cpumask(unsigned int pi
 	case SVC_POOL_PERCPU:
 	{
 		unsigned int cpu = m->pool_to[pidx];
+		cpumask_of_cpu_ptr(cpumask, cpu);
 
 		*oldmask = current->cpus_allowed;
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		set_cpus_allowed_ptr(current, cpumask);
 		return 1;
 	}
 	case SVC_POOL_PERNODE:

-- 
