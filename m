Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYGWRTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYGWRTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbYGWRSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:18:49 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58722 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753860AbYGWRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:18:47 -0400
Message-Id: <20080723171841.997896000@polaris-admin.engr.sgi.com>
References: <20080723171841.815234000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 23 Jul 2008 10:18:42 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Dave Jones <davej@codemonkey.org.uk>, Paul Jackson <pj@sgi.com>,
       Tony Luck <tony.luck@intel.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robert Richter <robert.richter@amd.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sam Creasey <sammy@sammy.net>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use cpumask_of_cpu_map
Content-Disposition: inline; filename=add-generic-cpumask_of_cpu_map
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * The previous "lvalue replacement for cpumask_of_cpu()" was not usable
    in certain situations and generally added unneeded complexity.  So
    this patch replaces the cpumask_of_cpu_ptr* macros with a generic
    cpumask_of_cpu_map[].  The only config option is whether this is a
    static map, or allocated at boot up time:

    #ifdef	CONFIG_HAVE_CPUMASK_OF_CPU_MAP_PTR
	    /* architecture initializes *cpumask_of_cpu_map */
    #else
	    /* start_kernel() initializes cpumask_of_cpu_map[] */

    #endif

    The reason for two is in the case where NR_CPUS is a very large
    value it's preferred to allocate the map sized on the actual
    number of possible cpus, and not NR_CPUS.

    Note that the declaration of cpumask_of_cpu_map[] is initialized
    so that cpumask_of_cpu(0) is defined early.  This assumes that
    cpu 0 is the boot cpu.

Based on linux-2.6.tip/master at the following commit:

    commit a099a9b18ab434594bb01ed920e8c58574203fa9
    Merge: 9b4ae4d... f3b51d7...
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Tue Jul 22 15:43:36 2008 +0200

    Merge branch 'out-of-tree'

Signed-off-by: Mike Travis <travis@sgi.com>

* ACPI
Cc: Len Brown <len.brown@intel.com>

* ARM (???)
Cc: Lennert Buytenhek <kernel@wantstofly.org>

* CPUFREQ
Cc: Dave Jones <davej@codemonkey.org.uk>

* CPUMASK
Cc: Paul Jackson <pj@sgi.com>

* IA64 (Itanium) PLATFORM
Cc: Tony Luck <tony.luck@intel.com>

* MICROCODE
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>

* POWERPC (32-BIT AND 64-BIT)
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

* PROFILE
Cc: Robert Richter <robert.richter@amd.com>

# S390
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>

* SUN3/3X
Cc: Sam Creasey <sammy@sammy.net>

* SUNRPC
Cc: Greg Banks <gnb@sgi.com>

* Various
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Schwab <schwab@suse.de>
Cc: Johannes Weiner <hannes@saeurebad.de>

---
Note: 2 false WARNINGS from checkpatch.pl
---
 arch/x86/Kconfig                                 |    2 -
 arch/x86/configs/i386_defconfig                  |    2 -
 arch/x86/configs/x86_64_defconfig                |    2 -
 arch/x86/kernel/acpi/cstate.c                    |    3 -
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   10 +-----
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   15 +++------
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   12 ++-----
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    3 -
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    3 -
 arch/x86/kernel/ldt.c                            |    6 +--
 arch/x86/kernel/microcode.c                      |   17 +++-------
 arch/x86/kernel/reboot.c                         |   11 +-----
 arch/x86/kernel/setup_percpu.c                   |   11 +++++-
 drivers/acpi/processor_throttling.c              |   11 +-----
 drivers/firmware/dcdbas.c                        |    3 -
 drivers/misc/sgi-xp/xpc_main.c                   |    3 -
 include/linux/cpumask.h                          |   38 +++++++----------------
 init/main.c                                      |   28 +++++++++++++++-
 kernel/stop_machine.c                            |    3 -
 kernel/time/tick-common.c                        |    8 +---
 kernel/trace/trace_sysprof.c                     |    4 --
 lib/smp_processor_id.c                           |    5 ---
 net/sunrpc/svc.c                                 |    3 -
 23 files changed, 87 insertions(+), 116 deletions(-)

--- linux-2.6.tip.orig/arch/x86/Kconfig
+++ linux-2.6.tip/arch/x86/Kconfig
@@ -126,7 +126,7 @@ config ARCH_HAS_CACHE_LINE_SIZE
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64_SMP || (X86_SMP && !X86_VOYAGER)
 
-config HAVE_CPUMASK_OF_CPU_MAP
+config HAVE_CPUMASK_OF_CPU_MAP_PTR
 	def_bool X86_64_SMP
 
 config ARCH_HIBERNATION_POSSIBLE
--- linux-2.6.tip.orig/arch/x86/configs/i386_defconfig
+++ linux-2.6.tip/arch/x86/configs/i386_defconfig
@@ -36,7 +36,7 @@ CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_ARCH_HAS_CPU_RELAX=y
 CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
-# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
+# CONFIG_HAVE_CPUMASK_OF_CPU_MAP_PTR is not set
 CONFIG_ARCH_HIBERNATION_POSSIBLE=y
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
 # CONFIG_ZONE_DMA32 is not set
--- linux-2.6.tip.orig/arch/x86/configs/x86_64_defconfig
+++ linux-2.6.tip/arch/x86/configs/x86_64_defconfig
@@ -36,7 +36,7 @@ CONFIG_GENERIC_TIME_VSYSCALL=y
 CONFIG_ARCH_HAS_CPU_RELAX=y
 CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
-CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
+CONFIG_HAVE_CPUMASK_OF_CPU_MAP_PTR=y
 CONFIG_ARCH_HIBERNATION_POSSIBLE=y
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
 CONFIG_ZONE_DMA32=y
--- linux-2.6.tip.orig/arch/x86/kernel/acpi/cstate.c
+++ linux-2.6.tip/arch/x86/kernel/acpi/cstate.c
@@ -73,7 +73,6 @@ int acpi_processor_ffh_cstate_probe(unsi
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	cpumask_t saved_mask;
-	cpumask_of_cpu_ptr(new_mask, cpu);
 	int retval;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int edx_part;
@@ -92,7 +91,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 
 	/* Make sure we are running on right CPU */
 	saved_mask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, new_mask);
+	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (retval)
 		return -1;
 
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -200,12 +200,10 @@ static void drv_read(struct drv_cmd *cmd
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
 
@@ -269,12 +267,11 @@ static unsigned int get_measured_perf(un
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
@@ -340,7 +337,6 @@ static unsigned int get_measured_perf(un
 
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
-	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, cpu);
 	unsigned int freq;
 	unsigned int cached_freq;
@@ -353,7 +349,7 @@ static unsigned int get_cur_freq_on_cpu(
 	}
 
 	cached_freq = data->freq_table[data->acpi_data->state].frequency;
-	freq = extract_freq(get_cur_val(cpu_mask), data);
+	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
 	if (freq != cached_freq) {
 		/*
 		 * The dreaded BIOS frequency change behind our back.
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -479,12 +479,11 @@ static int core_voltage_post_transition(
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
@@ -1017,7 +1016,6 @@ static int transition_frequency_pstate(s
 static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsigned relation)
 {
 	cpumask_t oldmask;
-	cpumask_of_cpu_ptr(cpu_mask, pol->cpu);
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
@@ -1032,7 +1030,7 @@ static int powernowk8_target(struct cpuf
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, cpu_mask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1107,7 +1105,6 @@ static int __cpuinit powernowk8_cpu_init
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask;
-	cpumask_of_cpu_ptr_declare(newmask);
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1159,8 +1156,7 @@ static int __cpuinit powernowk8_cpu_init
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	cpumask_of_cpu_ptr_next(newmask, pol->cpu);
-	set_cpus_allowed_ptr(current, newmask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1182,7 +1178,7 @@ static int __cpuinit powernowk8_cpu_init
 	set_cpus_allowed_ptr(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cpus = *newmask;
+		pol->cpus = cpumask_of_cpu(pol->cpu);
 	else
 		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
 	data->available_cores = &(pol->cpus);
@@ -1248,7 +1244,6 @@ static unsigned int powernowk8_get (unsi
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask = current->cpus_allowed;
-	cpumask_of_cpu_ptr(newmask, cpu);
 	unsigned int khz = 0;
 	unsigned int first;
 
@@ -1258,7 +1253,7 @@ static unsigned int powernowk8_get (unsi
 	if (!data)
 		return -EINVAL;
 
-	set_cpus_allowed_ptr(current, newmask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX
 			"limiting to CPU %d failed in powernowk8_get\n", cpu);
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -417,10 +417,9 @@ static unsigned int get_cur_freq(unsigne
 	unsigned l, h;
 	unsigned clock_freq;
 	cpumask_t saved_mask;
-	cpumask_of_cpu_ptr(new_mask, cpu);
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, new_mask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu)
 		return 0;
 
@@ -678,15 +677,12 @@ static int centrino_target (struct cpufr
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
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -244,8 +244,7 @@ static unsigned int _speedstep_get(const
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	cpumask_of_cpu_ptr(newmask, cpu);
-	return _speedstep_get(newmask);
+	return _speedstep_get(&cpumask_of_cpu(cpu));
 }
 
 /**
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -516,7 +516,6 @@ static int __cpuinit detect_cache_attrib
 	unsigned long		j;
 	int			retval;
 	cpumask_t		oldmask;
-	cpumask_of_cpu_ptr(newmask, cpu);
 
 	if (num_cache_leaves == 0)
 		return -ENOENT;
@@ -527,7 +526,7 @@ static int __cpuinit detect_cache_attrib
 		return -ENOMEM;
 
 	oldmask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, newmask);
+	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (retval)
 		goto out;
 
--- linux-2.6.tip.orig/arch/x86/kernel/ldt.c
+++ linux-2.6.tip/arch/x86/kernel/ldt.c
@@ -63,12 +63,10 @@ static int alloc_ldt(mm_context_t *pc, i
 
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
--- linux-2.6.tip.orig/arch/x86/kernel/microcode.c
+++ linux-2.6.tip/arch/x86/kernel/microcode.c
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
@@ -576,7 +574,6 @@ static int apply_microcode_check_cpu(int
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	cpumask_t old;
-	cpumask_of_cpu_ptr(newmask, cpu);
 	unsigned int val[2];
 	int err = 0;
 
@@ -585,7 +582,7 @@ static int apply_microcode_check_cpu(int
 		return 0;
 
 	old = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, newmask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 
 	/* Check if the microcode we have in memory matches the CPU */
 	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
@@ -623,12 +620,11 @@ static int apply_microcode_check_cpu(int
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
@@ -659,13 +655,10 @@ static ssize_t reload_store(struct sys_d
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
--- linux-2.6.tip.orig/arch/x86/kernel/reboot.c
+++ linux-2.6.tip/arch/x86/kernel/reboot.c
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
--- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
@@ -80,8 +80,15 @@ static void __init setup_per_cpu_maps(vo
 #endif
 }
 
-#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
-cpumask_t *cpumask_of_cpu_map __read_mostly;
+#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP_PTR
+/*
+ * Configure an initial cpumask_of_cpu(0) for early users
+ */
+static cpumask_t initial_cpumask_of_cpu_map __initdata = (cpumask_t) { {
+	[BITS_TO_LONGS(NR_CPUS)-1] = 1
+} };
+cpumask_t *cpumask_of_cpu_map __read_mostly =
+	(cpumask_t *)&initial_cpumask_of_cpu_map;
 EXPORT_SYMBOL(cpumask_of_cpu_map);
 
 /* requires nr_cpu_ids to be initialized */
--- linux-2.6.tip.orig/drivers/acpi/processor_throttling.c
+++ linux-2.6.tip/drivers/acpi/processor_throttling.c
@@ -827,7 +827,6 @@ static int acpi_processor_get_throttling
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
 	cpumask_t saved_mask;
-	cpumask_of_cpu_ptr_declare(new_mask);
 	int ret;
 
 	if (!pr)
@@ -839,8 +838,7 @@ static int acpi_processor_get_throttling
 	 * Migrate task to the cpu pointed by pr.
 	 */
 	saved_mask = current->cpus_allowed;
-	cpumask_of_cpu_ptr_next(new_mask, pr->id);
-	set_cpus_allowed_ptr(current, new_mask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
 	/* restore the previous state */
 	set_cpus_allowed_ptr(current, &saved_mask);
@@ -989,7 +987,6 @@ static int acpi_processor_set_throttling
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
 	cpumask_t saved_mask;
-	cpumask_of_cpu_ptr_declare(new_mask);
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
@@ -1028,8 +1025,7 @@ int acpi_processor_set_throttling(struct
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		cpumask_of_cpu_ptr_next(new_mask, pr->id);
-		set_cpus_allowed_ptr(current, new_mask);
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
 		ret = p_throttling->acpi_processor_set_throttling(pr,
 						t_state.target_state);
 	} else {
@@ -1060,8 +1056,7 @@ int acpi_processor_set_throttling(struct
 				continue;
 			}
 			t_state.cpu = i;
-			cpumask_of_cpu_ptr_next(new_mask, i);
-			set_cpus_allowed_ptr(current, new_mask);
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
 			ret = match_pr->throttling.
 				acpi_processor_set_throttling(
 				match_pr, t_state.target_state);
--- linux-2.6.tip.orig/drivers/firmware/dcdbas.c
+++ linux-2.6.tip/drivers/firmware/dcdbas.c
@@ -254,7 +254,6 @@ static ssize_t host_control_on_shutdown_
 static int smi_request(struct smi_cmd *smi_cmd)
 {
 	cpumask_t old_mask;
-	cpumask_of_cpu_ptr(new_mask, 0);
 	int ret = 0;
 
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
@@ -265,7 +264,7 @@ static int smi_request(struct smi_cmd *s
 
 	/* SMI requires CPU 0 */
 	old_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, new_mask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
 			__func__);
--- linux-2.6.tip.orig/drivers/misc/sgi-xp/xpc_main.c
+++ linux-2.6.tip/drivers/misc/sgi-xp/xpc_main.c
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
--- linux-2.6.tip.orig/include/linux/cpumask.h
+++ linux-2.6.tip/include/linux/cpumask.h
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
@@ -273,17 +265,17 @@ static inline void __cpus_shift_left(cpu
 	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
 }
 
+#ifdef CONFIG_SMP
+/* lvalue version of cpumask_of_cpu() */
+#define cpumask_of_cpu(cpu)		(cpumask_of_cpu_map[cpu])
 
-#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP_PTR
 extern cpumask_t *cpumask_of_cpu_map;
-#define cpumask_of_cpu(cpu)	(cpumask_of_cpu_map[cpu])
-#define	cpumask_of_cpu_ptr(v, cpu)					\
-		const cpumask_t *v = &cpumask_of_cpu(cpu)
-#define	cpumask_of_cpu_ptr_declare(v)					\
-		const cpumask_t *v
-#define cpumask_of_cpu_ptr_next(v, cpu)					\
-					v = &cpumask_of_cpu(cpu)
 #else
+extern cpumask_t cpumask_of_cpu_map[NR_CPUS];
+#endif
+
+#if 0	/* previous (non-lvalue) version */
 #define cpumask_of_cpu(cpu)						\
 ({									\
 	typeof(_unused_cpumask_arg_) m;					\
@@ -295,14 +287,10 @@ extern cpumask_t *cpumask_of_cpu_map;
 	}								\
 	m;								\
 })
-#define	cpumask_of_cpu_ptr(v, cpu) 					\
-		cpumask_t _##v = cpumask_of_cpu(cpu);			\
-		const cpumask_t *v = &_##v
-#define	cpumask_of_cpu_ptr_declare(v)					\
-		cpumask_t _##v;						\
-		const cpumask_t *v = &_##v
-#define cpumask_of_cpu_ptr_next(v, cpu)					\
-					_##v = cpumask_of_cpu(cpu)
+#endif
+
+#else /* !CONFIG_SMP */
+#define cpumask_of_cpu(cpu)		(cpumask_t) { { [0] = 1 } }
 #endif
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
--- linux-2.6.tip.orig/init/main.c
+++ linux-2.6.tip/init/main.c
@@ -366,8 +366,9 @@ static void __init smp_init(void)
 static inline void setup_per_cpu_areas(void) { }
 static inline void setup_nr_cpu_ids(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
+static inline void setup_cpumask_of_cpu(void) { }
 
-#else
+#else /* CONFIG_SMP */
 
 #if NR_CPUS > BITS_PER_LONG
 cpumask_t cpu_mask_all __read_mostly = CPU_MASK_ALL;
@@ -412,6 +413,27 @@ static void __init setup_per_cpu_areas(v
 }
 #endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
 
+#ifndef CONFIG_HAVE_CPUMASK_OF_CPU_MAP_PTR
+/*
+ * Define map for cpumask_of_cpu() macro with cpumask_of_cpu(0) initialized,
+ * in case it's referenced before setup_cpumask_of_cpu() is called.
+ */
+cpumask_t cpumask_of_cpu_map[NR_CPUS] __read_mostly = { {
+	[BITS_TO_LONGS(NR_CPUS)-1] = 1
+} };
+EXPORT_SYMBOL(cpumask_of_cpu_map);
+
+static void __init setup_cpumask_of_cpu(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		cpu_set(cpu, cpumask_of_cpu_map[cpu]);
+}
+#else
+static inline void setup_cpumask_of_cpu(void) { }
+#endif
+
 /* Called by boot processor to activate the rest. */
 static void __init smp_init(void)
 {
@@ -436,8 +458,7 @@ static void __init smp_init(void)
 	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
 	smp_cpus_done(setup_max_cpus);
 }
-
-#endif
+#endif /* CONFIG_SMP */
 
 /*
  * We need to store the untouched command line for future reference.
@@ -583,6 +604,7 @@ asmlinkage void __init start_kernel(void
 	unwind_setup();
 	setup_per_cpu_areas();
 	setup_nr_cpu_ids();
+	setup_cpumask_of_cpu();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
 	/*
--- linux-2.6.tip.orig/kernel/stop_machine.c
+++ linux-2.6.tip/kernel/stop_machine.c
@@ -33,9 +33,8 @@ static int stopmachine(void *cpu)
 {
 	int irqs_disabled = 0;
 	int prepared = 0;
-	cpumask_of_cpu_ptr(cpumask, (int)(long)cpu);
 
-	set_cpus_allowed_ptr(current, cpumask);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu((int)(long)cpu));
 
 	/* Ack: we are alive */
 	smp_mb(); /* Theoretically the ack = 0 might not be on this CPU yet. */
--- linux-2.6.tip.orig/kernel/time/tick-common.c
+++ linux-2.6.tip/kernel/time/tick-common.c
@@ -196,12 +196,10 @@ static int tick_check_new_device(struct 
 	struct tick_device *td;
 	int cpu, ret = NOTIFY_OK;
 	unsigned long flags;
-	cpumask_of_cpu_ptr_declare(cpumask);
 
 	spin_lock_irqsave(&tick_device_lock, flags);
 
 	cpu = smp_processor_id();
-	cpumask_of_cpu_ptr_next(cpumask, cpu);
 	if (!cpu_isset(cpu, newdev->cpumask))
 		goto out_bc;
 
@@ -209,7 +207,7 @@ static int tick_check_new_device(struct 
 	curdev = td->evtdev;
 
 	/* cpu local device ? */
-	if (!cpus_equal(newdev->cpumask, *cpumask)) {
+	if (!cpus_equal(newdev->cpumask, cpumask_of_cpu(cpu))) {
 
 		/*
 		 * If the cpu affinity of the device interrupt can not
@@ -222,7 +220,7 @@ static int tick_check_new_device(struct 
 		 * If we have a cpu local device already, do not replace it
 		 * by a non cpu local device
 		 */
-		if (curdev && cpus_equal(curdev->cpumask, *cpumask))
+		if (curdev && cpus_equal(curdev->cpumask, cpumask_of_cpu(cpu)))
 			goto out_bc;
 	}
 
@@ -254,7 +252,7 @@ static int tick_check_new_device(struct 
 		curdev = NULL;
 	}
 	clockevents_exchange_device(curdev, newdev);
-	tick_setup_device(td, newdev, cpu, cpumask);
+	tick_setup_device(td, newdev, cpu, &cpumask_of_cpu(cpu));
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 
--- linux-2.6.tip.orig/kernel/trace/trace_sysprof.c
+++ linux-2.6.tip/kernel/trace/trace_sysprof.c
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
--- linux-2.6.tip.orig/lib/smp_processor_id.c
+++ linux-2.6.tip/lib/smp_processor_id.c
@@ -11,7 +11,6 @@ notrace unsigned int debug_smp_processor
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
-	cpumask_of_cpu_ptr_declare(this_mask);
 
 	if (likely(preempt_count))
 		goto out;
@@ -23,9 +22,7 @@ notrace unsigned int debug_smp_processor
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	cpumask_of_cpu_ptr_next(this_mask, this_cpu);
-
-	if (cpus_equal(current->cpus_allowed, *this_mask))
+	if (cpus_equal(current->cpus_allowed, cpumask_of_cpu(this_cpu)))
 		goto out;
 
 	/*
--- linux-2.6.tip.orig/net/sunrpc/svc.c
+++ linux-2.6.tip/net/sunrpc/svc.c
@@ -310,8 +310,7 @@ svc_pool_map_set_cpumask(struct task_str
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
 	{
-		cpumask_of_cpu_ptr(cpumask, node);
-		set_cpus_allowed_ptr(task, cpumask);
+		set_cpus_allowed_ptr(task, &cpumask_of_cpu(node));
 		break;
 	}
 	case SVC_POOL_PERNODE:

-- 
