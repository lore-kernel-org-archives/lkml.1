Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbYG2BFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbYG2BFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYG2BEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:04:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYG2BEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:04:51 -0400
Date: Mon, 28 Jul 2008 21:03:57 -0400
Message-Id: <200807290103.m6T13vt3000862@file.rdu.redhat.com>
From: Glauber Costa <gcosta@redhat.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [GIT-PULL] time.c integration
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull the latest master git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master

into your tree


It contains code to integrate time_32.c and time_64.c into time.c

Thanks!

	Glauber

------------------>
Glauber Costa (22):
      x86: use user_mode macro
      x86: coalesce tests
      x86: use frame pointer information on x86_64 profile_pc
      x86: remove SEGMENT_IS_FLAT_CODE
      x86: use user_mode_vm instead of user_mode
      x86: bind irq0 irq data to cpu0
      x86: factor out irq initialization for x86_64
      x86: make init_ISA_irqs nonstatic
      x86: rename timer_event_interrupt to timer_interrupt
      x86: allow x86_64 to build with subarch support
      x86: replace ISA initialization function
      x86: use generic intr_init call
      x86: use time_init_hook in time_64.c
      x86: use generic time hook
      x86: replace hardcoded number
      x86: assign timer_ack variable
      x86: wrap MCA_bus test around an ifdef
      x86: wrap conditional inside ifdef at profile_pc
      x86: fix checkpatch errors
      x86: move vgetcpu mode probing to cpu detection
      x86: add pre_time_init_hooks to x86_64 time initialization
      x86: integrate time.c

 arch/x86/Makefile                                |    4 -
 arch/x86/kernel/Makefile                         |    2 +-
 arch/x86/kernel/acpi/cstate.c                    |    3 +-
 arch/x86/kernel/cpu/common_64.c                  |    9 ++
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   10 ++-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   15 ++-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   12 ++-
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    3 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    3 +-
 arch/x86/kernel/io_apic_64.c                     |    6 +-
 arch/x86/kernel/irqinit_64.c                     |   59 +++++-----
 arch/x86/kernel/ldt.c                            |    6 +-
 arch/x86/kernel/microcode.c                      |   17 ++-
 arch/x86/kernel/reboot.c                         |   11 ++-
 arch/x86/kernel/setup_percpu.c                   |   21 ++++
 arch/x86/kernel/{time_32.c => time.c}            |   66 +++++++++++-
 arch/x86/kernel/time_64.c                        |  126 ----------------------
 drivers/acpi/processor_throttling.c              |   11 ++-
 drivers/char/pcmcia/ipwireless/hardware.c        |    2 +-
 drivers/firmware/dcdbas.c                        |    3 +-
 drivers/misc/sgi-xp/xpc_main.c                   |    3 +-
 include/asm-x86/segment.h                        |    6 -
 include/linux/cpumask.h                          |   63 +++++++----
 kernel/cpu.c                                     |   25 -----
 kernel/time/tick-common.c                        |    8 +-
 kernel/trace/trace_sysprof.c                     |    4 +-
 lib/smp_processor_id.c                           |    5 +-
 net/sunrpc/svc.c                                 |    3 +-
 28 files changed, 247 insertions(+), 259 deletions(-)
 rename arch/x86/kernel/{time_32.c => time.c} (70%)
 delete mode 100644 arch/x86/kernel/time_64.c

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f5631da..f3a5133 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -121,10 +121,6 @@ mcore-$(CONFIG_X86_GENERICARCH)	:= arch/x86/mach-default/
 # default subarch .h files
 mflags-y += -Iinclude/asm-x86/mach-default
 
-# 64 bit does not support subarch support - clear sub arch variables
-fcore-$(CONFIG_X86_64)  :=
-mcore-$(CONFIG_X86_64)  :=
-
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 3db651f..d7f5cf7 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -24,7 +24,7 @@ CFLAGS_tsc.o		:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
-obj-y			+= time_$(BITS).o ioport.o ldt.o
+obj-y			+= time.o ioport.o ldt.o
 obj-y			+= setup.o i8259.o irqinit_$(BITS).o setup_percpu.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index c2502eb..9220cf4 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -73,6 +73,7 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr(new_mask, cpu);
 	int retval;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int edx_part;
@@ -91,7 +92,7 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 
 	/* Make sure we are running on right CPU */
 	saved_mask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed_ptr(current, new_mask);
 	if (retval)
 		return -1;
 
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index dd6e3f1..53dd9dd 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -375,9 +375,18 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 }
 
+static void vgetcpu_set_mode(void)
+{
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
+		vgetcpu_mode = VGETCPU_RDTSCP;
+	else
+		vgetcpu_mode = VGETCPU_LSL;
+}
+
 void __cpuinit identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
+	vgetcpu_set_mode();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index dd097b8..ff2fff5 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -200,10 +200,12 @@ static void drv_read(struct drv_cmd *cmd)
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
 
@@ -267,11 +269,12 @@ static unsigned int get_measured_perf(unsigned int cpu)
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
@@ -337,6 +340,7 @@ static unsigned int get_measured_perf(unsigned int cpu)
 
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
+	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, cpu);
 	unsigned int freq;
 	unsigned int cached_freq;
@@ -349,7 +353,7 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 	}
 
 	cached_freq = data->freq_table[data->acpi_data->state].frequency;
-	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
+	freq = extract_freq(get_cur_val(cpu_mask), data);
 	if (freq != cached_freq) {
 		/*
 		 * The dreaded BIOS frequency change behind our back.
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index c45ca6d..53c7b69 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -479,11 +479,12 @@ static int core_voltage_post_transition(struct powernow_k8_data *data, u32 reqvi
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
@@ -1016,6 +1017,7 @@ static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned i
 static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsigned relation)
 {
 	cpumask_t oldmask;
+	cpumask_of_cpu_ptr(cpu_mask, pol->cpu);
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
@@ -1030,7 +1032,7 @@ static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsi
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	set_cpus_allowed_ptr(current, cpu_mask);
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1105,6 +1107,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask;
+	cpumask_of_cpu_ptr_declare(newmask);
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1156,7 +1159,8 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	cpumask_of_cpu_ptr_next(newmask, pol->cpu);
+	set_cpus_allowed_ptr(current, newmask);
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1178,7 +1182,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	set_cpus_allowed_ptr(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cpus = cpumask_of_cpu(pol->cpu);
+		pol->cpus = *newmask;
 	else
 		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
 	data->available_cores = &(pol->cpus);
@@ -1244,6 +1248,7 @@ static unsigned int powernowk8_get (unsigned int cpu)
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask = current->cpus_allowed;
+	cpumask_of_cpu_ptr(newmask, cpu);
 	unsigned int khz = 0;
 	unsigned int first;
 
@@ -1253,7 +1258,7 @@ static unsigned int powernowk8_get (unsigned int cpu)
 	if (!data)
 		return -EINVAL;
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, newmask);
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX
 			"limiting to CPU %d failed in powernowk8_get\n", cpu);
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index 15e13c0..ca2ac13 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -324,9 +324,10 @@ static unsigned int get_cur_freq(unsigned int cpu)
 	unsigned l, h;
 	unsigned clock_freq;
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr(new_mask, cpu);
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, new_mask);
 	if (smp_processor_id() != cpu)
 		return 0;
 
@@ -584,12 +585,15 @@ static int centrino_target (struct cpufreq_policy *policy,
 		 * Best effort undo..
 		 */
 
-		if (!cpus_empty(*covered_cpus))
+		if (!cpus_empty(*covered_cpus)) {
+			cpumask_of_cpu_ptr_declare(new_mask);
+
 			for_each_cpu_mask_nr(j, *covered_cpus) {
-				set_cpus_allowed_ptr(current,
-						     &cpumask_of_cpu(j));
+				cpumask_of_cpu_ptr_next(new_mask, j);
+				set_cpus_allowed_ptr(current, new_mask);
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
 			}
+		}
 
 		tmp = freqs.new;
 		freqs.new = freqs.old;
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index 191f726..2f3728d 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -244,7 +244,8 @@ static unsigned int _speedstep_get(const cpumask_t *cpus)
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	return _speedstep_get(&cpumask_of_cpu(cpu));
+	cpumask_of_cpu_ptr(newmask, cpu);
+	return _speedstep_get(newmask);
 }
 
 /**
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 6b0a10b..650d40f 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -516,6 +516,7 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 	unsigned long		j;
 	int			retval;
 	cpumask_t		oldmask;
+	cpumask_of_cpu_ptr(newmask, cpu);
 
 	if (num_cache_leaves == 0)
 		return -ENOENT;
@@ -526,7 +527,7 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 		return -ENOMEM;
 
 	oldmask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed_ptr(current, newmask);
 	if (retval)
 		goto out;
 
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 8269434..ff070e5 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -49,6 +49,7 @@
 #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
+#include <asm/timer.h>
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
@@ -91,7 +92,7 @@ char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
 
 int sis_apic_bug; /* not actually supported, dummy for compile */
 
-static int no_timer_check;
+int no_timer_check;
 
 static int disable_timer_pin_1 __initdata;
 
@@ -1689,6 +1690,7 @@ static inline void __init check_timer(void)
 	 */
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
+	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
 
 	pin1  = find_isa_irq_pin(0, mp_INT);
 	apic1 = find_isa_irq_apic(0, mp_INT);
@@ -1767,6 +1769,8 @@ static inline void __init check_timer(void)
 		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
 	}
 
+	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
+
 	if (nmi_watchdog == NMI_IO_APIC) {
 		apic_printk(APIC_QUIET, KERN_WARNING "timer doesn't work "
 			    "through the IO-APIC - disabling NMI Watchdog!\n");
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 1f26fd9..92b5f2b 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -22,6 +22,7 @@
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
+#include <asm/arch_hooks.h>
 
 /*
  * Common place to define all x86 IRQ vectors
@@ -102,18 +103,6 @@ static void (*__initdata interrupt[NR_VECTORS - FIRST_EXTERNAL_VECTOR])(void) =
 #undef IRQ
 #undef IRQLIST_16
 
-
-
-
-/*
- * IRQ2 is cascade interrupt to second interrupt controller
- */
-
-static struct irqaction irq2 = {
-	.handler = no_action,
-	.mask = CPU_MASK_NONE,
-	.name = "cascade",
-};
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[0 ... IRQ0_VECTOR - 1] = -1,
 	[IRQ0_VECTOR] = 0,
@@ -135,7 +124,7 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
-static void __init init_ISA_irqs (void)
+void __init init_ISA_irqs(void)
 {
 	int i;
 
@@ -164,22 +153,8 @@ static void __init init_ISA_irqs (void)
 
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
-void __init native_init_IRQ(void)
+void __init smp_intr_init(void)
 {
-	int i;
-
-	init_ISA_irqs();
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (vector != IA32_SYSCALL_VECTOR)
-			set_intr_gate(vector, interrupt[i]);
-	}
-
 #ifdef CONFIG_SMP
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
@@ -207,6 +182,14 @@ void __init native_init_IRQ(void)
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
+}
+
+void __init apic_intr_init(void)
+{
+#ifdef CONFIG_SMP
+	smp_intr_init();
+#endif
+
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 
@@ -216,7 +199,23 @@ void __init native_init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+}
+
+void __init native_init_IRQ(void)
+{
+	int i;
+
+	pre_intr_init_hook();
+	/*
+	 * Cover the whole vector space, no vector can escape
+	 * us. (some of these will be overridden and become
+	 * 'special' SMP interrupts)
+	 */
+	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		if (vector != IA32_SYSCALL_VECTOR)
+			set_intr_gate(vector, interrupt[i]);
+	}
 
-	if (!acpi_ioapic)
-		setup_irq(2, &irq2);
+	intr_init_hook();
 }
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index b68e21f..3fee2aa 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -62,10 +62,12 @@ static int alloc_ldt(mm_context_t *pc, int mincount, int reload)
 
 	if (reload) {
 #ifdef CONFIG_SMP
+		cpumask_of_cpu_ptr_declare(mask);
+
 		preempt_disable();
 		load_LDT(pc);
-		if (!cpus_equal(current->mm->cpu_vm_mask,
-				cpumask_of_cpu(smp_processor_id())))
+		cpumask_of_cpu_ptr_next(mask, smp_processor_id());
+		if (!cpus_equal(current->mm->cpu_vm_mask, *mask))
 			smp_call_function(flush_ldt, current->mm, 1);
 		preempt_enable();
 #else
diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 652fa5c..6994c75 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
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
@@ -574,6 +576,7 @@ static int apply_microcode_check_cpu(int cpu)
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	cpumask_t old;
+	cpumask_of_cpu_ptr(newmask, cpu);
 	unsigned int val[2];
 	int err = 0;
 
@@ -582,7 +585,7 @@ static int apply_microcode_check_cpu(int cpu)
 		return 0;
 
 	old = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, newmask);
 
 	/* Check if the microcode we have in memory matches the CPU */
 	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
@@ -620,11 +623,12 @@ static int apply_microcode_check_cpu(int cpu)
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
@@ -657,10 +661,13 @@ static ssize_t reload_store(struct sys_device *dev,
 	if (end == buf)
 		return -EINVAL;
 	if (val == 1) {
-		cpumask_t old = current->cpus_allowed;
+		cpumask_t old;
+		cpumask_of_cpu_ptr(newmask, cpu);
+
+		old = current->cpus_allowed;
 
 		get_online_cpus();
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		set_cpus_allowed_ptr(current, newmask);
 
 		mutex_lock(&microcode_mutex);
 		if (uci->valid)
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 724adfc..06a9f64 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -414,20 +414,25 @@ void native_machine_shutdown(void)
 
 	/* The boot cpu is always logical cpu 0 */
 	int reboot_cpu_id = 0;
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
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 76e305e..f7745f9 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -80,6 +80,24 @@ static void __init setup_per_cpu_maps(void)
 #endif
 }
 
+#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+cpumask_t *cpumask_of_cpu_map __read_mostly;
+EXPORT_SYMBOL(cpumask_of_cpu_map);
+
+/* requires nr_cpu_ids to be initialized */
+static void __init setup_cpumask_of_cpu(void)
+{
+	int i;
+
+	/* alloc_bootmem zeroes memory */
+	cpumask_of_cpu_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
+	for (i = 0; i < nr_cpu_ids; i++)
+		cpu_set(i, cpumask_of_cpu_map[i]);
+}
+#else
+static inline void setup_cpumask_of_cpu(void) { }
+#endif
+
 #ifdef CONFIG_X86_32
 /*
  * Great future not-so-futuristic plan: make i386 and x86_64 do it
@@ -179,6 +197,9 @@ void __init setup_per_cpu_areas(void)
 
 	/* Setup node to cpumask map */
 	setup_node_to_cpumask_map();
+
+	/* Setup cpumask_of_cpu map */
+	setup_cpumask_of_cpu();
 }
 
 #endif
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time.c
similarity index 70%
rename from arch/x86/kernel/time_32.c
rename to arch/x86/kernel/time.c
index ffe3c66..cad01a0 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time.c
@@ -36,20 +36,70 @@
 #include <asm/arch_hooks.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
+#include <asm/nmi.h>
 
 #include "do_timer.h"
 
 int timer_ack;
 
+#ifdef CONFIG_X86_64
+volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
+
+/* calibrate_cpu is used on systems with fixed rate TSCs to determine
+ * processor frequency */
+#define TICK_COUNT 100000000
+unsigned long __init calibrate_cpu(void)
+{
+	int tsc_start, tsc_now;
+	int i, no_ctr_free;
+	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
+	unsigned long flags;
+
+	for (i = 0; i < 4; i++)
+		if (avail_to_resrv_perfctr_nmi_bit(i))
+			break;
+	no_ctr_free = (i == 4);
+	if (no_ctr_free) {
+		i = 3;
+		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		rdmsrl(MSR_K7_PERFCTR3, pmc3);
+	} else {
+		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+	local_irq_save(flags);
+	/* start measuring cycles, incrementing from 0 */
+	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
+	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
+	rdtscl(tsc_start);
+	do {
+		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
+		tsc_now = get_cycles();
+	} while ((tsc_now - tsc_start) < TICK_COUNT);
+
+	local_irq_restore(flags);
+	if (no_ctr_free) {
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		wrmsrl(MSR_K7_PERFCTR3, pmc3);
+		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
+	} else {
+		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+
+	return pmc_now * tsc_khz / (tsc_now - tsc_start);
+}
+#endif
+
 unsigned long profile_pc(struct pt_regs *regs)
 {
 	unsigned long pc = instruction_pointer(regs);
 
 #ifdef CONFIG_SMP
-	if (!v8086_mode(regs) && SEGMENT_IS_KERNEL_CODE(regs->cs) &&
-	    in_lock_functions(pc)) {
+	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
 #ifdef CONFIG_FRAME_POINTER
-		return *(unsigned long *)(regs->bp + 4);
+		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
 		unsigned long *sp = (unsigned long *)&regs->sp;
 
@@ -75,7 +125,11 @@ EXPORT_SYMBOL(profile_pc);
 irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	/* Keep nmi watchdog up to date */
+#ifdef CONFIG_X86_32
 	per_cpu(irq_stat, smp_processor_id()).irq0_irqs++;
+#else
+	add_pda(irq0_irqs, 1);
+#endif
 
 #ifdef CONFIG_X86_IO_APIC
 	if (timer_ack) {
@@ -94,6 +148,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 	do_timer_interrupt_hook();
 
+#ifdef CONFIG_MCA
 	if (MCA_bus) {
 		/* The PS/2 uses level-triggered interrupts.  You can't
 		turn them off, nor would you want to (any attempt to
@@ -104,9 +159,10 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 		high bit of the PPI port B (0x61).  Note that some PS/2s,
 		notably the 55SX, work fine if this is removed.  */
 
-		u8 irq_v = inb_p( 0x61 );	/* read the current state */
-		outb_p( irq_v|0x80, 0x61 );	/* reset the IRQ */
+		u8 irq_v = inb_p(0x61);	/* read the current state */
+		outb_p(irq_v|0x80, 0x61);	/* reset the IRQ */
 	}
+#endif
 
 	return IRQ_HANDLED;
 }
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
deleted file mode 100644
index e3d49c5..0000000
--- a/arch/x86/kernel/time_64.c
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- *  "High Precision Event Timer" based timekeeping.
- *
- *  Copyright (c) 1991,1992,1995  Linus Torvalds
- *  Copyright (c) 1994  Alan Modra
- *  Copyright (c) 1995  Markus Kuhn
- *  Copyright (c) 1996  Ingo Molnar
- *  Copyright (c) 1998  Andrea Arcangeli
- *  Copyright (c) 2002,2006  Vojtech Pavlik
- *  Copyright (c) 2003  Andi Kleen
- *  RTC support code taken from arch/i386/kernel/timers/time_hpet.c
- */
-
-#include <linux/clockchips.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/time.h>
-
-#include <asm/i8253.h>
-#include <asm/hpet.h>
-#include <asm/nmi.h>
-#include <asm/vgtod.h>
-#include <asm/time.h>
-#include <asm/timer.h>
-
-volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
-
-unsigned long profile_pc(struct pt_regs *regs)
-{
-	unsigned long pc = instruction_pointer(regs);
-
-	/* Assume the lock function has either no stack frame or a copy
-	   of flags from PUSHF
-	   Eflags always has bits 22 and up cleared unlike kernel addresses. */
-	if (!user_mode(regs) && in_lock_functions(pc)) {
-		unsigned long *sp = (unsigned long *)regs->sp;
-		if (sp[0] >> 22)
-			return sp[0];
-		if (sp[1] >> 22)
-			return sp[1];
-	}
-	return pc;
-}
-EXPORT_SYMBOL(profile_pc);
-
-static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
-{
-	add_pda(irq0_irqs, 1);
-
-	global_clock_event->event_handler(global_clock_event);
-
-	return IRQ_HANDLED;
-}
-
-/* calibrate_cpu is used on systems with fixed rate TSCs to determine
- * processor frequency */
-#define TICK_COUNT 100000000
-unsigned long __init calibrate_cpu(void)
-{
-	int tsc_start, tsc_now;
-	int i, no_ctr_free;
-	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
-	unsigned long flags;
-
-	for (i = 0; i < 4; i++)
-		if (avail_to_resrv_perfctr_nmi_bit(i))
-			break;
-	no_ctr_free = (i == 4);
-	if (no_ctr_free) {
-		i = 3;
-		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
-		wrmsrl(MSR_K7_EVNTSEL3, 0);
-		rdmsrl(MSR_K7_PERFCTR3, pmc3);
-	} else {
-		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-	local_irq_save(flags);
-	/* start measuring cycles, incrementing from 0 */
-	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
-	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
-	rdtscl(tsc_start);
-	do {
-		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
-		tsc_now = get_cycles();
-	} while ((tsc_now - tsc_start) < TICK_COUNT);
-
-	local_irq_restore(flags);
-	if (no_ctr_free) {
-		wrmsrl(MSR_K7_EVNTSEL3, 0);
-		wrmsrl(MSR_K7_PERFCTR3, pmc3);
-		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
-	} else {
-		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-
-	return pmc_now * tsc_khz / (tsc_now - tsc_start);
-}
-
-static struct irqaction irq0 = {
-	.handler	= timer_event_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
-	.mask		= CPU_MASK_NONE,
-	.name		= "timer"
-};
-
-void __init hpet_time_init(void)
-{
-	if (!hpet_enable())
-		setup_pit_timer();
-
-	setup_irq(0, &irq0);
-}
-
-void __init time_init(void)
-{
-	tsc_init();
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
-		vgetcpu_mode = VGETCPU_RDTSCP;
-	else
-		vgetcpu_mode = VGETCPU_LSL;
-
-	late_time_init = choose_time_init();
-}
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index a56fc6c..a2c3f9c 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -827,6 +827,7 @@ static int acpi_processor_get_throttling_ptc(struct acpi_processor *pr)
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr_declare(new_mask);
 	int ret;
 
 	if (!pr)
@@ -838,7 +839,8 @@ static int acpi_processor_get_throttling(struct acpi_processor *pr)
 	 * Migrate task to the cpu pointed by pr.
 	 */
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
+	cpumask_of_cpu_ptr_next(new_mask, pr->id);
+	set_cpus_allowed_ptr(current, new_mask);
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
 	/* restore the previous state */
 	set_cpus_allowed_ptr(current, &saved_mask);
@@ -987,6 +989,7 @@ static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr_declare(new_mask);
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
@@ -1025,7 +1028,8 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
+		cpumask_of_cpu_ptr_next(new_mask, pr->id);
+		set_cpus_allowed_ptr(current, new_mask);
 		ret = p_throttling->acpi_processor_set_throttling(pr,
 						t_state.target_state);
 	} else {
@@ -1056,7 +1060,8 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 				continue;
 			}
 			t_state.cpu = i;
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+			cpumask_of_cpu_ptr_next(new_mask, i);
+			set_cpus_allowed_ptr(current, new_mask);
 			ret = match_pr->throttling.
 				acpi_processor_set_throttling(
 				match_pr, t_state.target_state);
diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index 4c1820c..7d500f8 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -568,7 +568,7 @@ static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
 			list_del(&packet->queue);
 		} else {
 			const int min_capacity =
-				ipwireless_ppp_mru(hw->network) + 2;
+				ipwireless_ppp_mru(hw->network + 2);
 			int new_capacity;
 
 			spin_unlock_irqrestore(&hw->lock, flags);
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 50a071f..c66817e 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -245,6 +245,7 @@ static ssize_t host_control_on_shutdown_store(struct device *dev,
 static int smi_request(struct smi_cmd *smi_cmd)
 {
 	cpumask_t old_mask;
+	cpumask_of_cpu_ptr(new_mask, 0);
 	int ret = 0;
 
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
@@ -255,7 +256,7 @@ static int smi_request(struct smi_cmd *smi_cmd)
 
 	/* SMI requires CPU 0 */
 	old_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
+	set_cpus_allowed_ptr(current, new_mask);
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
 			__func__);
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index c3b4227..579b01f 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -229,10 +229,11 @@ xpc_hb_checker(void *ignore)
 	int last_IRQ_count = 0;
 	int new_IRQ_count;
 	int force_IRQ = 0;
+	cpumask_of_cpu_ptr(cpumask, XPC_HB_CHECK_CPU);
 
 	/* this thread was marked active by xpc_hb_init() */
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(XPC_HB_CHECK_CPU));
+	set_cpus_allowed_ptr(current, cpumask);
 
 	/* set our heartbeating to other partitions into motion */
 	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);
diff --git a/include/asm-x86/segment.h b/include/asm-x86/segment.h
index 646452e..c4224cf 100644
--- a/include/asm-x86/segment.h
+++ b/include/asm-x86/segment.h
@@ -131,12 +131,6 @@
  * Matching rules for certain types of segments.
  */
 
-/* Matches only __KERNEL_CS, ignoring PnP / USER / APM segments */
-#define SEGMENT_IS_KERNEL_CODE(x) (((x) & 0xfc) == GDT_ENTRY_KERNEL_CS * 8)
-
-/* Matches __KERNEL_CS and __USER_CS (they must be 2 entries apart) */
-#define SEGMENT_IS_FLAT_CODE(x)  (((x) & 0xec) == GDT_ENTRY_KERNEL_CS * 8)
-
 /* Matches PNP_CS32 and PNP_CS16 (they must be consecutive) */
 #define SEGMENT_IS_PNP_CODE(x)   (((x) & 0xf4) == GDT_ENTRY_PNPBIOS_BASE * 8)
 
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 96d0509..1b5c98e 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -62,7 +62,15 @@
  * int next_cpu_nr(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
  *
  * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
- *					(can be used as an lvalue)
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
@@ -265,30 +273,37 @@ static inline void __cpus_shift_left(cpumask_t *dstp,
 	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
 }
 
-/*
- * Special-case data structure for "single bit set only" constant CPU masks.
- *
- * We pre-generate all the 64 (or 32) possible bit positions, with enough
- * padding to the left and the right, and return the constant pointer
- * appropriately offset.
- */
-extern const unsigned long
-	cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];
-
-static inline const cpumask_t *get_cpu_mask(unsigned int cpu)
-{
-	const unsigned long *p = cpu_bit_bitmap[1 + cpu % BITS_PER_LONG];
-	p -= cpu / BITS_PER_LONG;
-	return (const cpumask_t *)p;
-}
-
-/*
- * In cases where we take the address of the cpumask immediately,
- * gcc optimizes it out (it's a constant) and there's no huge stack
- * variable created:
- */
-#define cpumask_of_cpu(cpu) ({ *get_cpu_mask(cpu); })
 
+#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+extern cpumask_t *cpumask_of_cpu_map;
+#define cpumask_of_cpu(cpu)	(cpumask_of_cpu_map[cpu])
+#define	cpumask_of_cpu_ptr(v, cpu)					\
+		const cpumask_t *v = &cpumask_of_cpu(cpu)
+#define	cpumask_of_cpu_ptr_declare(v)					\
+		const cpumask_t *v
+#define cpumask_of_cpu_ptr_next(v, cpu)					\
+					v = &cpumask_of_cpu(cpu)
+#else
+#define cpumask_of_cpu(cpu)						\
+({									\
+	typeof(_unused_cpumask_arg_) m;					\
+	if (sizeof(m) == sizeof(unsigned long)) {			\
+		m.bits[0] = 1UL<<(cpu);					\
+	} else {							\
+		cpus_clear(m);						\
+		cpu_set((cpu), m);					\
+	}								\
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
+#endif
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e202a68..29510d6 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -455,28 +455,3 @@ out:
 #endif /* CONFIG_PM_SLEEP_SMP */
 
 #endif /* CONFIG_SMP */
-
-/*
- * cpu_bit_bitmap[] is a special, "compressed" data structure that
- * represents all NR_CPUS bits binary values of 1<<nr.
- *
- * It is used by cpumask_of_cpu() to get a constant address to a CPU
- * mask value that has a single bit set only.
- */
-
-/* cpu_bit_bitmap[0] is empty - so we can back into it */
-#define MASK_DECLARE_1(x)	[x+1][0] = 1UL << (x)
-#define MASK_DECLARE_2(x)	MASK_DECLARE_1(x), MASK_DECLARE_1(x+1)
-#define MASK_DECLARE_4(x)	MASK_DECLARE_2(x), MASK_DECLARE_2(x+2)
-#define MASK_DECLARE_8(x)	MASK_DECLARE_4(x), MASK_DECLARE_4(x+4)
-
-const unsigned long cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)] = {
-
-	MASK_DECLARE_8(0),	MASK_DECLARE_8(8),
-	MASK_DECLARE_8(16),	MASK_DECLARE_8(24),
-#if BITS_PER_LONG > 32
-	MASK_DECLARE_8(32),	MASK_DECLARE_8(40),
-	MASK_DECLARE_8(48),	MASK_DECLARE_8(56),
-#endif
-};
-EXPORT_SYMBOL_GPL(cpu_bit_bitmap);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 80c4336..bf43284 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -196,10 +196,12 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 	struct tick_device *td;
 	int cpu, ret = NOTIFY_OK;
 	unsigned long flags;
+	cpumask_of_cpu_ptr_declare(cpumask);
 
 	spin_lock_irqsave(&tick_device_lock, flags);
 
 	cpu = smp_processor_id();
+	cpumask_of_cpu_ptr_next(cpumask, cpu);
 	if (!cpu_isset(cpu, newdev->cpumask))
 		goto out_bc;
 
@@ -207,7 +209,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 	curdev = td->evtdev;
 
 	/* cpu local device ? */
-	if (!cpus_equal(newdev->cpumask, cpumask_of_cpu(cpu))) {
+	if (!cpus_equal(newdev->cpumask, *cpumask)) {
 
 		/*
 		 * If the cpu affinity of the device interrupt can not
@@ -220,7 +222,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 		 * If we have a cpu local device already, do not replace it
 		 * by a non cpu local device
 		 */
-		if (curdev && cpus_equal(curdev->cpumask, cpumask_of_cpu(cpu)))
+		if (curdev && cpus_equal(curdev->cpumask, *cpumask))
 			goto out_bc;
 	}
 
@@ -252,7 +254,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 		curdev = NULL;
 	}
 	clockevents_exchange_device(curdev, newdev);
-	tick_setup_device(td, newdev, cpu, &cpumask_of_cpu(cpu));
+	tick_setup_device(td, newdev, cpu, cpumask);
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index bb948e5..ce2d723 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
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
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 0f8fc22..c4381d9 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -11,6 +11,7 @@ notrace unsigned int debug_smp_processor_id(void)
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
+	cpumask_of_cpu_ptr_declare(this_mask);
 
 	if (likely(preempt_count))
 		goto out;
@@ -22,7 +23,9 @@ notrace unsigned int debug_smp_processor_id(void)
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	if (cpus_equal(current->cpus_allowed, cpumask_of_cpu(this_cpu)))
+	cpumask_of_cpu_ptr_next(this_mask, this_cpu);
+
+	if (cpus_equal(current->cpus_allowed, *this_mask))
 		goto out;
 
 	/*
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 5a32cb7..835d274 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -310,7 +310,8 @@ svc_pool_map_set_cpumask(struct task_struct *task, unsigned int pidx)
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
 	{
-		set_cpus_allowed_ptr(task, &cpumask_of_cpu(node));
+		cpumask_of_cpu_ptr(cpumask, node);
+		set_cpus_allowed_ptr(task, cpumask);
 		break;
 	}
 	case SVC_POOL_PERNODE:
