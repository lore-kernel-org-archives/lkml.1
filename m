Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbYLTBDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbYLTBDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYLTBBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:01:01 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45028 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753157AbYLTBA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:00:57 -0500
Message-Id: <20081220010044.578920000@polaris-admin.engr.sgi.com>
References: <20081220010043.879277000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 17:00:48 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 5/8] cpumask: use work_on_cpu in some other places.
Content-Disposition: inline; filename=cpumask:more-work_on_cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: remove potential problem with cpus_allowed, use new API

Replace cpumask_t's used by set_cpus_allowed_ptr() to use
work_on_cpu instead.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/acpi/cstate.c                    |   70 ++++----
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |  160 +++++++++---------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |  195 ++++++++++++++---------
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   34 ++--
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c          |    2 
 5 files changed, 264 insertions(+), 197 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/acpi/cstate.c
+++ linux-2.6-for-ingo/arch/x86/kernel/acpi/cstate.c
@@ -66,35 +66,15 @@ static short mwait_supported[ACPI_PROCES
 
 #define NATIVE_CSTATE_BEYOND_HALT	(2)
 
-int acpi_processor_ffh_cstate_probe(unsigned int cpu,
-		struct acpi_processor_cx *cx, struct acpi_power_register *reg)
+static long acpi_processor_ffh_cstate_probe_cpu(void *_cx)
 {
-	struct cstate_entry *percpu_entry;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	cpumask_t saved_mask;
-	int retval;
+	struct acpi_processor_cx *cx = _cx;
+	long retval;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int edx_part;
 	unsigned int cstate_type; /* C-state type and not ACPI C-state type */
 	unsigned int num_cstate_subtype;
 
-	if (!cpu_cstate_entry || c->cpuid_level < CPUID_MWAIT_LEAF )
-		return -1;
-
-	if (reg->bit_offset != NATIVE_CSTATE_BEYOND_HALT)
-		return -1;
-
-	percpu_entry = per_cpu_ptr(cpu_cstate_entry, cpu);
-	percpu_entry->states[cx->index].eax = 0;
-	percpu_entry->states[cx->index].ecx = 0;
-
-	/* Make sure we are running on right CPU */
-	saved_mask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	if (retval)
-		return -1;
-
 	cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, &edx);
 
 	/* Check whether this particular cx_type (in CST) is supported or not */
@@ -114,21 +94,45 @@ int acpi_processor_ffh_cstate_probe(unsi
 		retval = -1;
 		goto out;
 	}
-	percpu_entry->states[cx->index].ecx = MWAIT_ECX_INTERRUPT_BREAK;
-
-	/* Use the hint in CST */
-	percpu_entry->states[cx->index].eax = cx->address;
 
 	if (!mwait_supported[cstate_type]) {
 		mwait_supported[cstate_type] = 1;
-		printk(KERN_DEBUG "Monitor-Mwait will be used to enter C-%d "
-		       "state\n", cx->type);
+		printk(KERN_DEBUG
+			"Monitor-Mwait will be used to enter C-%d "
+			"state\n", cx->type);
 	}
-	snprintf(cx->desc, ACPI_CX_DESC_LEN, "ACPI FFH INTEL MWAIT 0x%x",
-		 cx->address);
-
+	snprintf(cx->desc,
+			ACPI_CX_DESC_LEN, "ACPI FFH INTEL MWAIT 0x%x",
+			cx->address);
 out:
-	set_cpus_allowed_ptr(current, &saved_mask);
+	return retval;
+}
+
+int acpi_processor_ffh_cstate_probe(unsigned int cpu,
+		struct acpi_processor_cx *cx, struct acpi_power_register *reg)
+{
+	struct cstate_entry *percpu_entry;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	long retval;
+
+	if (!cpu_cstate_entry || c->cpuid_level < CPUID_MWAIT_LEAF)
+		return -1;
+
+	if (reg->bit_offset != NATIVE_CSTATE_BEYOND_HALT)
+		return -1;
+
+	percpu_entry = per_cpu_ptr(cpu_cstate_entry, cpu);
+	percpu_entry->states[cx->index].eax = 0;
+	percpu_entry->states[cx->index].ecx = 0;
+
+	/* Make sure we are running on right CPU */
+
+	retval = work_on_cpu(cpu, acpi_processor_ffh_cstate_probe_cpu, cx);
+	if (retval == 0) {
+		/* Use the hint in CST */
+		percpu_entry->states[cx->index].eax = cx->address;
+		percpu_entry->states[cx->index].ecx = MWAIT_ECX_INTERRUPT_BREAK;
+	}
 	return retval;
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -145,13 +145,14 @@ typedef union {
 
 struct drv_cmd {
 	unsigned int type;
-	cpumask_t mask;
+	cpumask_var_t mask;
 	drv_addr_union addr;
 	u32 val;
 };
 
-static void do_drv_read(struct drv_cmd *cmd)
+static long do_drv_read(void *_cmd)
 {
+	struct drv_cmd *cmd = _cmd;
 	u32 h;
 
 	switch (cmd->type) {
@@ -166,10 +167,12 @@ static void do_drv_read(struct drv_cmd *
 	default:
 		break;
 	}
+	return 0;
 }
 
-static void do_drv_write(struct drv_cmd *cmd)
+static long do_drv_write(void *_cmd)
 {
+	struct drv_cmd *cmd = _cmd;
 	u32 lo, hi;
 
 	switch (cmd->type) {
@@ -186,41 +189,34 @@ static void do_drv_write(struct drv_cmd 
 	default:
 		break;
 	}
+	return 0;
 }
 
 static void drv_read(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
 	cmd->val = 0;
 
-	set_cpus_allowed_ptr(current, &cmd->mask);
-	do_drv_read(cmd);
-	set_cpus_allowed_ptr(current, &saved_mask);
+	work_on_cpu(cpumask_any(cmd->mask), do_drv_read, cmd);
 }
 
 static void drv_write(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
-	for_each_cpu_mask_nr(i, cmd->mask) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
-		do_drv_write(cmd);
+	for_each_cpu(i, cmd->mask) {
+		work_on_cpu(i, do_drv_write, cmd);
 	}
-
-	set_cpus_allowed_ptr(current, &saved_mask);
-	return;
 }
 
-static u32 get_cur_val(const cpumask_t *mask)
+static u32 get_cur_val(const struct cpumask *mask)
 {
 	struct acpi_processor_performance *perf;
 	struct drv_cmd cmd;
 
-	if (unlikely(cpus_empty(*mask)))
+	if (unlikely(cpumask_empty(mask)))
 		return 0;
 
-	switch (per_cpu(drv_data, first_cpu(*mask))->cpu_feature) {
+	switch (per_cpu(drv_data, cpumask_first(mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
 		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
@@ -235,15 +231,44 @@ static u32 get_cur_val(const cpumask_t *
 		return 0;
 	}
 
-	cmd.mask = *mask;
+	if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
+		return 0;
+
+	cpumask_copy(cmd.mask, mask);
 
 	drv_read(&cmd);
 
+	free_cpumask_var(cmd.mask);
+
 	dprintk("get_cur_val = %u\n", cmd.val);
 
 	return cmd.val;
 }
 
+struct perf_cur {
+	union {
+		struct {
+			u32 lo;
+			u32 hi;
+		} split;
+		u64 whole;
+	} aperf_cur, mperf_cur;
+};
+
+
+static long read_measured_perf_ctrs(void *_cur)
+{
+	struct perf_cur *cur = _cur;
+
+	rdmsr(MSR_IA32_APERF, cur->aperf_cur.split.lo, cur->aperf_cur.split.hi);
+	rdmsr(MSR_IA32_MPERF, cur->mperf_cur.split.lo, cur->mperf_cur.split.hi);
+
+	wrmsr(MSR_IA32_APERF, 0, 0);
+	wrmsr(MSR_IA32_MPERF, 0, 0);
+
+	return 0;
+}
+
 /*
  * Return the measured active (C0) frequency on this CPU since last call
  * to this function.
@@ -260,31 +285,12 @@ static u32 get_cur_val(const cpumask_t *
 static unsigned int get_measured_perf(struct cpufreq_policy *policy,
 				      unsigned int cpu)
 {
-	union {
-		struct {
-			u32 lo;
-			u32 hi;
-		} split;
-		u64 whole;
-	} aperf_cur, mperf_cur;
-
-	cpumask_t saved_mask;
+	struct perf_cur cur;
 	unsigned int perf_percent;
 	unsigned int retval;
 
-	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	if (get_cpu() != cpu) {
-		/* We were not able to run on requested processor */
-		put_cpu();
+	if (!work_on_cpu(cpu, read_measured_perf_ctrs, &cur))
 		return 0;
-	}
-
-	rdmsr(MSR_IA32_APERF, aperf_cur.split.lo, aperf_cur.split.hi);
-	rdmsr(MSR_IA32_MPERF, mperf_cur.split.lo, mperf_cur.split.hi);
-
-	wrmsr(MSR_IA32_APERF, 0,0);
-	wrmsr(MSR_IA32_MPERF, 0,0);
 
 #ifdef __i386__
 	/*
@@ -292,37 +298,39 @@ static unsigned int get_measured_perf(st
 	 * Get an approximate value. Return failure in case we cannot get
 	 * an approximate value.
 	 */
-	if (unlikely(aperf_cur.split.hi || mperf_cur.split.hi)) {
+	if (unlikely(cur.aperf_cur.split.hi || cur.mperf_cur.split.hi)) {
 		int shift_count;
 		u32 h;
 
-		h = max_t(u32, aperf_cur.split.hi, mperf_cur.split.hi);
+		h = max_t(u32, cur.aperf_cur.split.hi, cur.mperf_cur.split.hi);
 		shift_count = fls(h);
 
-		aperf_cur.whole >>= shift_count;
-		mperf_cur.whole >>= shift_count;
+		cur.aperf_cur.whole >>= shift_count;
+		cur.mperf_cur.whole >>= shift_count;
 	}
 
-	if (((unsigned long)(-1) / 100) < aperf_cur.split.lo) {
+	if (((unsigned long)(-1) / 100) < cur.aperf_cur.split.lo) {
 		int shift_count = 7;
-		aperf_cur.split.lo >>= shift_count;
-		mperf_cur.split.lo >>= shift_count;
+		cur.aperf_cur.split.lo >>= shift_count;
+		cur.mperf_cur.split.lo >>= shift_count;
 	}
 
-	if (aperf_cur.split.lo && mperf_cur.split.lo)
-		perf_percent = (aperf_cur.split.lo * 100) / mperf_cur.split.lo;
+	if (cur.aperf_cur.split.lo && cur.mperf_cur.split.lo)
+		perf_percent = (cur.aperf_cur.split.lo * 100) /
+				cur.mperf_cur.split.lo;
 	else
 		perf_percent = 0;
 
 #else
-	if (unlikely(((unsigned long)(-1) / 100) < aperf_cur.whole)) {
+	if (unlikely(((unsigned long)(-1) / 100) < cur.aperf_cur.whole)) {
 		int shift_count = 7;
-		aperf_cur.whole >>= shift_count;
-		mperf_cur.whole >>= shift_count;
+		cur.aperf_cur.whole >>= shift_count;
+		cur.mperf_cur.whole >>= shift_count;
 	}
 
-	if (aperf_cur.whole && mperf_cur.whole)
-		perf_percent = (aperf_cur.whole * 100) / mperf_cur.whole;
+	if (cur.aperf_cur.whole && cur.mperf_cur.whole)
+		perf_percent = (cur.aperf_cur.whole * 100) /
+				cur.mperf_cur.whole;
 	else
 		perf_percent = 0;
 
@@ -330,10 +338,6 @@ static unsigned int get_measured_perf(st
 
 	retval = per_cpu(drv_data, policy->cpu)->max_freq * perf_percent / 100;
 
-	put_cpu();
-	set_cpus_allowed_ptr(current, &saved_mask);
-
-	dprintk("cpu %d: performance percent %d\n", cpu, perf_percent);
 	return retval;
 }
 
@@ -351,7 +355,7 @@ static unsigned int get_cur_freq_on_cpu(
 	}
 
 	cached_freq = data->freq_table[data->acpi_data->state].frequency;
-	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
+	freq = extract_freq(get_cur_val(cpumask_of(cpu)), data);
 	if (freq != cached_freq) {
 		/*
 		 * The dreaded BIOS frequency change behind our back.
@@ -386,7 +390,6 @@ static int acpi_cpufreq_target(struct cp
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, policy->cpu);
 	struct acpi_processor_performance *perf;
 	struct cpufreq_freqs freqs;
-	cpumask_t online_policy_cpus;
 	struct drv_cmd cmd;
 	unsigned int next_state = 0; /* Index into freq_table */
 	unsigned int next_perf_state = 0; /* Index into perf table */
@@ -401,20 +404,18 @@ static int acpi_cpufreq_target(struct cp
 		return -ENODEV;
 	}
 
+	if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
+		return -ENOMEM;
+
 	perf = data->acpi_data;
 	result = cpufreq_frequency_table_target(policy,
 						data->freq_table,
 						target_freq,
 						relation, &next_state);
-	if (unlikely(result))
-		return -ENODEV;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	/* cpufreq holds the hotplug lock, so we are safe from here on */
-	cpumask_and(&online_policy_cpus, cpu_online_mask, policy->cpus);
-#else
-	online_policy_cpus = policy->cpus;
-#endif
+	if (unlikely(result)) {
+		result = -ENODEV;
+		goto out;
+	}
 
 	next_perf_state = data->freq_table[next_state].index;
 	if (perf->state == next_perf_state) {
@@ -425,7 +426,7 @@ static int acpi_cpufreq_target(struct cp
 		} else {
 			dprintk("Already at target state (P%d)\n",
 				next_perf_state);
-			return 0;
+			goto out;
 		}
 	}
 
@@ -444,19 +445,19 @@ static int acpi_cpufreq_target(struct cp
 		cmd.val = (u32) perf->states[next_perf_state].control;
 		break;
 	default:
-		return -ENODEV;
+		result = -ENODEV;
+		goto out;
 	}
 
-	cpus_clear(cmd.mask);
-
+	/* cpufreq holds the hotplug lock, so we are safe from here on */
 	if (policy->shared_type != CPUFREQ_SHARED_TYPE_ANY)
-		cmd.mask = online_policy_cpus;
+		cpumask_and(cmd.mask, cpu_online_mask, policy->cpus);
 	else
-		cpu_set(policy->cpu, cmd.mask);
+		cpumask_copy(cmd.mask, cpumask_of(policy->cpu));
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
-	for_each_cpu_mask_nr(i, cmd.mask) {
+	for_each_cpu(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -464,19 +465,22 @@ static int acpi_cpufreq_target(struct cp
 	drv_write(&cmd);
 
 	if (acpi_pstate_strict) {
-		if (!check_freqs(&cmd.mask, freqs.new, data)) {
+		if (!check_freqs(cmd.mask, freqs.new, data)) {
 			dprintk("acpi_cpufreq_target failed (%d)\n",
 				policy->cpu);
-			return -EAGAIN;
+			result = -EAGAIN;
+			goto out;
 		}
 	}
 
-	for_each_cpu_mask_nr(i, cmd.mask) {
+	for_each_cpu(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
 	perf->state = next_perf_state;
 
+out:
+	free_cpumask_var(cmd.mask);
 	return result;
 }
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -483,60 +483,56 @@ static int core_voltage_post_transition(
 	return 0;
 }
 
-static int check_supported_cpu(unsigned int cpu)
+static long read_cpuid_fields(void *unused)
 {
-	cpumask_t oldmask;
 	u32 eax, ebx, ecx, edx;
-	unsigned int rc = 0;
-
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-
-	if (smp_processor_id() != cpu) {
-		printk(KERN_ERR PFX "limiting to cpu %u failed\n", cpu);
-		goto out;
-	}
 
 	if (current_cpu_data.x86_vendor != X86_VENDOR_AMD)
-		goto out;
+		return -ENODEV;
 
 	eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
 	if (((eax & CPUID_XFAM) != CPUID_XFAM_K8) &&
 	    ((eax & CPUID_XFAM) < CPUID_XFAM_10H))
-		goto out;
+		return -ENODEV;
 
 	if ((eax & CPUID_XFAM) == CPUID_XFAM_K8) {
 		if (((eax & CPUID_USE_XFAM_XMOD) != CPUID_USE_XFAM_XMOD) ||
 		    ((eax & CPUID_XMOD) > CPUID_XMOD_REV_MASK)) {
-			printk(KERN_INFO PFX "Processor cpuid %x not supported\n", eax);
-			goto out;
+			printk(KERN_INFO PFX
+				"Processor cpuid %x not supported\n", eax);
+			return -ENODEV;
 		}
 
 		eax = cpuid_eax(CPUID_GET_MAX_CAPABILITIES);
 		if (eax < CPUID_FREQ_VOLT_CAPABILITIES) {
 			printk(KERN_INFO PFX
 			       "No frequency change capabilities detected\n");
-			goto out;
+			return -ENODEV;
 		}
 
 		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
-		if ((edx & P_STATE_TRANSITION_CAPABLE) != P_STATE_TRANSITION_CAPABLE) {
-			printk(KERN_INFO PFX "Power state transitions not supported\n");
-			goto out;
+		if ((edx & P_STATE_TRANSITION_CAPABLE)
+			!= P_STATE_TRANSITION_CAPABLE) {
+			printk(KERN_INFO PFX
+				"Power state transitions not supported\n");
+			return -ENODEV;
 		}
 	} else { /* must be a HW Pstate capable processor */
 		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
 		if ((edx & USE_HW_PSTATE) == USE_HW_PSTATE)
 			cpu_family = CPU_HW_PSTATE;
 		else
-			goto out;
+			return -ENODEV;
 	}
 
-	rc = 1;
+	return 0;
+}
 
-out:
-	set_cpus_allowed_ptr(current, &oldmask);
-	return rc;
+static int check_supported_cpu(unsigned int cpu)
+{
+	if (work_on_cpu(cpu, read_cpuid_fields, NULL))
+		return 0;
+	return 1;
 }
 
 static int check_pst_table(struct powernow_k8_data *data, struct pst_s *pst, u8 maxvid)
@@ -654,7 +650,7 @@ static int fill_powernow_table(struct po
 
 	dprintk("cfid 0x%x, cvid 0x%x\n", data->currfid, data->currvid);
 	data->powernow_table = powernow_table;
-	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
+	if (cpumask_first(&per_cpu(cpu_core_map, data->cpu)) == data->cpu)
 		print_basics(data);
 
 	for (j = 0; j < data->numps; j++)
@@ -808,7 +804,7 @@ static int powernow_k8_cpu_init_acpi(str
 
 	/* fill in data */
 	data->numps = data->acpi_data.state_count;
-	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
+	if (cpumask_first(&per_cpu(cpu_core_map, data->cpu)) == data->cpu)
 		print_basics(data);
 	powernow_k8_acpi_pst_values(data, 0);
 
@@ -1025,25 +1021,27 @@ static int transition_frequency_pstate(s
 }
 
 /* Driver entry point to switch to the target frequency */
-static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsigned relation)
+struct powernowk8_target_args {
+	struct cpufreq_policy *pol;
+	unsigned targfreq;
+	unsigned relation;
+};
+
+static long powernowk8_target_on_cpu(void *_args)
 {
-	cpumask_t oldmask;
+	struct powernowk8_target_args *args = _args;
+	struct cpufreq_policy *pol = args->pol;
+	unsigned targfreq = args->targfreq;
+	unsigned relation = args->relation;
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
 	unsigned int newstate;
 	int ret = -EIO;
 
-	if (!data)
-		return -EINVAL;
-
 	checkfid = data->currfid;
 	checkvid = data->currvid;
 
-	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
-
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
 		goto err_out;
@@ -1097,10 +1095,26 @@ static int powernowk8_target(struct cpuf
 	ret = 0;
 
 err_out:
-	set_cpus_allowed_ptr(current, &oldmask);
 	return ret;
 }
 
+static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq,
+							 unsigned relation)
+{
+	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
+	struct powernowk8_target_args args;
+
+	if (!data)
+		return -EINVAL;
+
+	args.pol = pol;
+	args.targfreq = targfreq;
+	args.relation = relation;
+
+	/* only run on specific CPU from here on */
+	return work_on_cpu(pol->cpu, powernowk8_target_on_cpu, &args);
+}
+
 /* Driver entry point to verify the policy and range of frequencies */
 static int powernowk8_verify(struct cpufreq_policy *pol)
 {
@@ -1113,10 +1127,39 @@ static int powernowk8_verify(struct cpuf
 }
 
 /* per CPU init entry point to the driver */
+struct powernowk8_cpu_init_args {
+	struct cpufreq_policy *pol;
+	struct powernow_k8_data *data;
+};
+
+static long __cpuinit powernowk8_cpu_init_on_cpu(void *_args)
+{
+	struct powernowk8_cpu_init_args *args = _args;
+	struct cpufreq_policy *pol = args->pol;
+	struct powernow_k8_data *data = args->data;
+
+	if (smp_processor_id() != pol->cpu) {
+		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
+		return -ENODEV;
+	}
+
+	if (pending_bit_stuck()) {
+		printk(KERN_ERR PFX "failing init, change pending bit set\n");
+		return -EBUSY;
+	}
+
+	if (query_current_values_with_pending_wait(data))
+		return -EBUSY;
+
+	if (cpu_family == CPU_OPTERON)
+		fidvid_msr_init();
+
+	return 0;
+}
+
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask;
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1170,27 +1213,17 @@ static int __cpuinit powernowk8_cpu_init
 	}
 
 	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	{
+		struct powernowk8_cpu_init_args args;
 
-	if (smp_processor_id() != pol->cpu) {
-		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
-		goto err_out;
-	}
+		args.pol = pol;
+		args.data = data;
 
-	if (pending_bit_stuck()) {
-		printk(KERN_ERR PFX "failing init, change pending bit set\n");
-		goto err_out;
+		rc = work_on_cpu(pol->cpu, powernowk8_cpu_init_on_cpu, &args);
+		if (rc)
+			goto err_out;
 	}
-
-	if (query_current_values_with_pending_wait(data))
-		goto err_out;
-
-	if (cpu_family == CPU_OPTERON)
-		fidvid_msr_init();
-
 	/* run on any CPU again */
-	set_cpus_allowed_ptr(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
 		cpumask_copy(pol->cpus, cpumask_of(pol->cpu));
@@ -1231,7 +1264,6 @@ static int __cpuinit powernowk8_cpu_init
 	return 0;
 
 err_out:
-	set_cpus_allowed_ptr(current, &oldmask);
 	powernow_k8_cpu_exit_acpi(data);
 
 	kfree(data);
@@ -1255,39 +1287,54 @@ static int __devexit powernowk8_cpu_exit
 	return 0;
 }
 
-static unsigned int powernowk8_get (unsigned int cpu)
-{
+struct powernowk8_get_args {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask = current->cpus_allowed;
-	unsigned int khz = 0;
-	unsigned int first;
-
-	first = first_cpu(per_cpu(cpu_core_map, cpu));
-	data = per_cpu(powernow_data, first);
+	unsigned int cpu;
+	unsigned int *khz;
+};
 
-	if (!data)
-		return -EINVAL;
+static long powernowk8_get_on_cpu(void *_args)
+{
+	struct powernowk8_get_args *args = _args;
+	struct powernow_k8_data *data = args->data;
+	unsigned int cpu = args->cpu;
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX
 			"limiting to CPU %d failed in powernowk8_get\n", cpu);
-		set_cpus_allowed_ptr(current, &oldmask);
-		return 0;
+		return -ENODEV;
 	}
 
 	if (query_current_values_with_pending_wait(data))
-		goto out;
+		return -EBUSY;
 
 	if (cpu_family == CPU_HW_PSTATE)
-		khz = find_khz_freq_from_pstate(data->powernow_table,
-						data->currpstate);
+		*(args->khz) = find_khz_freq_from_pstate(data->powernow_table,
+							 data->currpstate);
 	else
-		khz = find_khz_freq_from_fid(data->currfid);
+		*(args->khz) = find_khz_freq_from_fid(data->currfid);
+
+	return 0;
+}
+
+static unsigned int powernowk8_get(unsigned int cpu)
+{
+	struct powernow_k8_data *data;
+	struct powernowk8_get_args args;
+	unsigned int khz = 0;
+	unsigned int first;
+
+	first = cpumask_first(&per_cpu(cpu_core_map, cpu));
+	data = per_cpu(powernow_data, first);
+
+	if (!data)
+		return -EINVAL;
 
+	args.data = data;
+	args.cpu = cpu;
+	args.khz = &khz;
+	work_on_cpu(cpu, powernowk8_get_on_cpu, &args);
 
-out:
-	set_cpus_allowed_ptr(current, &oldmask);
 	return khz;
 }
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -319,21 +319,23 @@ static unsigned extract_clock(unsigned m
 }
 
 /* Return the current CPU frequency in kHz */
-static unsigned int get_cur_freq(unsigned int cpu)
+struct get_cur_freq_args {
+	unsigned int cpu;
+	unsigned int *clock_freq;
+};
+
+static long get_cur_freq_on_cpu(void *_args)
 {
+	struct get_cur_freq_args *args = _args;
 	unsigned l, h;
-	unsigned clock_freq;
-	cpumask_t saved_mask;
 
-	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	if (smp_processor_id() != cpu)
+	if (smp_processor_id() != args->cpu)
 		return 0;
 
 	rdmsr(MSR_IA32_PERF_STATUS, l, h);
-	clock_freq = extract_clock(l, cpu, 0);
+	*(args->clock_freq) = extract_clock(l, args->cpu, 0);
 
-	if (unlikely(clock_freq == 0)) {
+	if (unlikely(*(args->clock_freq) == 0)) {
 		/*
 		 * On some CPUs, we can see transient MSR values (which are
 		 * not present in _PSS), while CPU is doing some automatic
@@ -341,13 +343,23 @@ static unsigned int get_cur_freq(unsigne
 		 * in PERF_CTL.
 		 */
 		rdmsr(MSR_IA32_PERF_CTL, l, h);
-		clock_freq = extract_clock(l, cpu, 1);
+		*(args->clock_freq) = extract_clock(l, args->cpu, 1);
 	}
 
-	set_cpus_allowed_ptr(current, &saved_mask);
-	return clock_freq;
+	return 0;
 }
 
+static unsigned int get_cur_freq(unsigned int cpu)
+{
+	struct get_cur_freq_args args;
+	unsigned clock_freq = 0;
+
+	args.cpu = cpu;
+	args.clock_freq = &clock_freq;
+	work_on_cpu(cpu, get_cur_freq_on_cpu, &args);
+
+	return clock_freq;
+}
 
 static int centrino_cpu_init(struct cpufreq_policy *policy)
 {
--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -398,7 +398,7 @@ static __cpuinit int allocate_threshold_
 	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
 		return 0;
 
-	if (rdmsr_safe(address, &low, &high))
+	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
 		return 0;
 
 	if (!(high & MASK_VALID_HI)) {

-- 
