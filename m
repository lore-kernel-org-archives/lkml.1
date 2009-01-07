Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZAGSXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZAGSXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZAGSXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:23:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZAGSXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:23:23 -0500
Date: Wed, 7 Jan 2009 19:22:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Dave Jones <davej@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Tony Luck <tony.luck@intel.com>
Subject: [git pull] cpus4096 updates
Message-ID: <20090107182251.GA15288@elte.hu>
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

Please pull the latest cpus4096-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git cpus4096-for-linus

Some more cpumask conversion bits: the PCI portion has been seen (and 
acked) by Jesse, the cpufreq bits have been seen (and acked) by DaveJ.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      [IA64] fix typo in cpumask_of_pcibus()

Mike Travis (9):
      ia64: cpumask fix for is_affinity_mask_valid()
      cpumask: update local_cpus_show to use new cpumask API
      cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
      x86: cleanup remaining cpumask_t ops in smpboot code
      cpumask: use work_on_cpu in acpi/cstate.c
      cpumask: use cpumask_var_t in acpi-cpufreq.c
      cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
      cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
      x86: fix x86_32 builds for summit and es7000 arch's

Rusty Russell (2):
      cpumask: replace CPUMASK_ALLOC etc with cpumask_var_t
      cpumask: convert struct cpufreq_policy to cpumask_var_t


 arch/ia64/include/asm/irq.h                      |    2 +-
 arch/ia64/include/asm/topology.h                 |    2 +-
 arch/ia64/kernel/irq.c                           |   15 +-
 arch/x86/include/asm/es7000/apic.h               |    2 +
 arch/x86/include/asm/smp.h                       |   32 ++++-
 arch/x86/include/asm/summit/apic.h               |    1 +
 arch/x86/kernel/acpi/cstate.c                    |   70 +++++----
 arch/x86/kernel/cpu/common.c                     |   26 +++-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |  170 +++++++++++-----------
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c        |    8 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    6 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h        |    2 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   35 ++---
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |   18 +-
 arch/x86/kernel/setup_percpu.c                   |   25 +++-
 arch/x86/kernel/smp.c                            |   17 ++-
 arch/x86/kernel/smpboot.c                        |  128 ++++++++--------
 drivers/cpufreq/cpufreq.c                        |   42 ++++--
 drivers/cpufreq/cpufreq_conservative.c           |    2 +-
 drivers/cpufreq/cpufreq_ondemand.c               |    4 +-
 drivers/pci/pci-sysfs.c                          |   12 +-
 drivers/pci/probe.c                              |    8 +-
 include/linux/cpufreq.h                          |    4 +-
 23 files changed, 363 insertions(+), 268 deletions(-)

diff --git a/arch/ia64/include/asm/irq.h b/arch/ia64/include/asm/irq.h
index 36429a5..5282546 100644
--- a/arch/ia64/include/asm/irq.h
+++ b/arch/ia64/include/asm/irq.h
@@ -27,7 +27,7 @@ irq_canonicalize (int irq)
 }
 
 extern void set_irq_affinity_info (unsigned int irq, int dest, int redir);
-bool is_affinity_mask_valid(cpumask_var_t cpumask);
+bool is_affinity_mask_valid(const struct cpumask *cpumask);
 
 #define is_affinity_mask_valid is_affinity_mask_valid
 
diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 76a33a9..32f3af1 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -124,7 +124,7 @@ extern void arch_fix_phys_package_id(int num, u32 slot);
 
 #define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
 				 cpu_all_mask :				\
-				 cpumask_from_node(pcibus_to_node(bus)))
+				 cpumask_of_node(pcibus_to_node(bus)))
 
 #include <asm-generic/topology.h>
 
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index 95ff16c..a58f64c 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -102,17 +102,14 @@ static char irq_redir [NR_IRQS]; // = { [0 ... NR_IRQS-1] = 1 };
 
 void set_irq_affinity_info (unsigned int irq, int hwid, int redir)
 {
-	cpumask_t mask = CPU_MASK_NONE;
-
-	cpu_set(cpu_logical_id(hwid), mask);
-
 	if (irq < NR_IRQS) {
-		irq_desc[irq].affinity = mask;
+		cpumask_copy(&irq_desc[irq].affinity,
+			     cpumask_of(cpu_logical_id(hwid)));
 		irq_redir[irq] = (char) (redir & 0xff);
 	}
 }
 
-bool is_affinity_mask_valid(cpumask_var_t cpumask)
+bool is_affinity_mask_valid(const struct cpumask *cpumask)
 {
 	if (ia64_platform_is("sn2")) {
 		/* Only allow one CPU to be specified in the smp_affinity mask */
@@ -128,7 +125,7 @@ bool is_affinity_mask_valid(cpumask_var_t cpumask)
 unsigned int vectors_in_migration[NR_IRQS];
 
 /*
- * Since cpu_online_map is already updated, we just need to check for
+ * Since cpu_online_mask is already updated, we just need to check for
  * affinity that has zeros
  */
 static void migrate_irqs(void)
@@ -158,7 +155,7 @@ static void migrate_irqs(void)
 			 */
 			vectors_in_migration[irq] = irq;
 
-			new_cpu = any_online_cpu(cpu_online_map);
+			new_cpu = cpumask_any(cpu_online_mask);
 
 			/*
 			 * Al three are essential, currently WARN_ON.. maybe panic?
@@ -191,7 +188,7 @@ void fixup_irqs(void)
 	 * Find a new timesync master
 	 */
 	if (smp_processor_id() == time_keeper_id) {
-		time_keeper_id = first_cpu(cpu_online_map);
+		time_keeper_id = cpumask_first(cpu_online_mask);
 		printk ("CPU %d is now promoted to time-keeper master\n", time_keeper_id);
 	}
 
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index bc53d5e..c58b9cc 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_ES7000_APIC_H
 #define __ASM_ES7000_APIC_H
 
+#include <linux/gfp.h>
+
 #define xapic_phys_to_log_apicid(cpu) per_cpu(x86_bios_cpu_apicid, cpu)
 #define esr_disable (1)
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 830b9fc..19953df 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -18,9 +18,26 @@
 #include <asm/pda.h>
 #include <asm/thread_info.h>
 
+#ifdef CONFIG_X86_64
+
+extern cpumask_var_t cpu_callin_mask;
+extern cpumask_var_t cpu_callout_mask;
+extern cpumask_var_t cpu_initialized_mask;
+extern cpumask_var_t cpu_sibling_setup_mask;
+
+#else /* CONFIG_X86_32 */
+
+extern cpumask_t cpu_callin_map;
 extern cpumask_t cpu_callout_map;
 extern cpumask_t cpu_initialized;
-extern cpumask_t cpu_callin_map;
+extern cpumask_t cpu_sibling_setup_map;
+
+#define cpu_callin_mask		((struct cpumask *)&cpu_callin_map)
+#define cpu_callout_mask	((struct cpumask *)&cpu_callout_map)
+#define cpu_initialized_mask	((struct cpumask *)&cpu_initialized)
+#define cpu_sibling_setup_mask	((struct cpumask *)&cpu_sibling_setup_map)
+
+#endif /* CONFIG_X86_32 */
 
 extern void (*mtrr_hook)(void);
 extern void zap_low_mappings(void);
@@ -29,7 +46,6 @@ extern int __cpuinit get_local_pda(int cpu);
 
 extern int smp_num_siblings;
 extern unsigned int num_processors;
-extern cpumask_t cpu_initialized;
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
@@ -38,6 +54,16 @@ DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(int, cpu_number);
 #endif
 
+static inline struct cpumask *cpu_sibling_mask(int cpu)
+{
+	return &per_cpu(cpu_sibling_map, cpu);
+}
+
+static inline struct cpumask *cpu_core_mask(int cpu)
+{
+	return &per_cpu(cpu_core_map, cpu);
+}
+
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 
@@ -149,7 +175,7 @@ void smp_store_cpu_info(int id);
 /* We don't mark CPUs online until __cpu_up(), so we need another measure */
 static inline int num_booting_cpus(void)
 {
-	return cpus_weight(cpu_callout_map);
+	return cpumask_weight(cpu_callout_mask);
 }
 #else
 static inline void prefill_possible_map(void)
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 4bb5fb3..93d2c86 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -2,6 +2,7 @@
 #define __ASM_SUMMIT_APIC_H
 
 #include <asm/smp.h>
+#include <linux/gfp.h>
 
 #define esr_disable (1)
 #define NO_BALANCE_IRQ (0)
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index c2502eb..cf5ec58 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -66,35 +66,15 @@ static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
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
@@ -114,21 +94,45 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3f95a40..83492b1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -40,6 +40,26 @@
 
 #include "cpu.h"
 
+#ifdef CONFIG_X86_64
+
+/* all of these masks are initialized in setup_cpu_local_masks() */
+cpumask_var_t cpu_callin_mask;
+cpumask_var_t cpu_callout_mask;
+cpumask_var_t cpu_initialized_mask;
+
+/* representing cpus for which sibling maps can be computed */
+cpumask_var_t cpu_sibling_setup_mask;
+
+#else /* CONFIG_X86_32 */
+
+cpumask_t cpu_callin_map;
+cpumask_t cpu_callout_map;
+cpumask_t cpu_initialized;
+cpumask_t cpu_sibling_setup_map;
+
+#endif /* CONFIG_X86_32 */
+
+
 static struct cpu_dev *this_cpu __cpuinitdata;
 
 #ifdef CONFIG_X86_64
@@ -856,8 +876,6 @@ static __init int setup_disablecpuid(char *arg)
 }
 __setup("clearcpuid=", setup_disablecpuid);
 
-cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
-
 #ifdef CONFIG_X86_64
 struct x8664_pda **_cpu_pda __read_mostly;
 EXPORT_SYMBOL(_cpu_pda);
@@ -976,7 +994,7 @@ void __cpuinit cpu_init(void)
 
 	me = current;
 
-	if (cpu_test_and_set(cpu, cpu_initialized))
+	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
 		panic("CPU#%d already initialized!\n", cpu);
 
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
@@ -1085,7 +1103,7 @@ void __cpuinit cpu_init(void)
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 	struct thread_struct *thread = &curr->thread;
 
-	if (cpu_test_and_set(cpu, cpu_initialized)) {
+	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
 		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
 		for (;;) local_irq_enable();
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 28102ad..06fcd8f 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
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
@@ -166,10 +167,12 @@ static void do_drv_read(struct drv_cmd *cmd)
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
@@ -186,48 +189,41 @@ static void do_drv_write(struct drv_cmd *cmd)
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
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
-		perf = per_cpu(drv_data, first_cpu(*mask))->acpi_data;
+		perf = per_cpu(drv_data, cpumask_first(mask))->acpi_data;
 		cmd.addr.io.port = perf->control_register.address;
 		cmd.addr.io.bit_width = perf->control_register.bit_width;
 		break;
@@ -235,15 +231,44 @@ static u32 get_cur_val(const cpumask_t *mask)
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
@@ -260,31 +285,12 @@ static u32 get_cur_val(const cpumask_t *mask)
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
@@ -292,37 +298,39 @@ static unsigned int get_measured_perf(struct cpufreq_policy *policy,
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
 
@@ -330,10 +338,6 @@ static unsigned int get_measured_perf(struct cpufreq_policy *policy,
 
 	retval = per_cpu(drv_data, policy->cpu)->max_freq * perf_percent / 100;
 
-	put_cpu();
-	set_cpus_allowed_ptr(current, &saved_mask);
-
-	dprintk("cpu %d: performance percent %d\n", cpu, perf_percent);
 	return retval;
 }
 
@@ -351,7 +355,7 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 	}
 
 	cached_freq = data->freq_table[data->acpi_data->state].frequency;
-	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
+	freq = extract_freq(get_cur_val(cpumask_of(cpu)), data);
 	if (freq != cached_freq) {
 		/*
 		 * The dreaded BIOS frequency change behind our back.
@@ -386,7 +390,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, policy->cpu);
 	struct acpi_processor_performance *perf;
 	struct cpufreq_freqs freqs;
-	cpumask_t online_policy_cpus;
 	struct drv_cmd cmd;
 	unsigned int next_state = 0; /* Index into freq_table */
 	unsigned int next_perf_state = 0; /* Index into perf table */
@@ -401,20 +404,18 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
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
-	cpus_and(online_policy_cpus, cpu_online_map, policy->cpus);
-#else
-	online_policy_cpus = policy->cpus;
-#endif
+	if (unlikely(result)) {
+		result = -ENODEV;
+		goto out;
+	}
 
 	next_perf_state = data->freq_table[next_state].index;
 	if (perf->state == next_perf_state) {
@@ -425,7 +426,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		} else {
 			dprintk("Already at target state (P%d)\n",
 				next_perf_state);
-			return 0;
+			goto out;
 		}
 	}
 
@@ -444,19 +445,19 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
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
@@ -464,19 +465,22 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
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
 
@@ -626,15 +630,15 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	 */
 	if (policy->shared_type == CPUFREQ_SHARED_TYPE_ALL ||
 	    policy->shared_type == CPUFREQ_SHARED_TYPE_ANY) {
-		cpumask_copy(&policy->cpus, perf->shared_cpu_map);
+		cpumask_copy(policy->cpus, perf->shared_cpu_map);
 	}
-	cpumask_copy(&policy->related_cpus, perf->shared_cpu_map);
+	cpumask_copy(policy->related_cpus, perf->shared_cpu_map);
 
 #ifdef CONFIG_SMP
 	dmi_check_system(sw_any_bug_dmi_table);
-	if (bios_with_sw_any_bug && cpus_weight(policy->cpus) == 1) {
+	if (bios_with_sw_any_bug && cpumask_weight(policy->cpus) == 1) {
 		policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
-		policy->cpus = per_cpu(cpu_core_map, cpu);
+		cpumask_copy(policy->cpus, cpu_core_mask(cpu));
 	}
 #endif
 
diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index beea446..b585e04 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -122,7 +122,7 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 		return 0;
 
 	/* notifiers */
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -130,11 +130,11 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 	/* run on each logical CPU, see section 13.15.3 of IA32 Intel Architecture Software
 	 * Developer's Manual, Volume 3
 	 */
-	for_each_cpu_mask_nr(i, policy->cpus)
+	for_each_cpu(i, policy->cpus)
 		cpufreq_p4_setdc(i, p4clockmod_table[newstate].index);
 
 	/* notifiers */
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -203,7 +203,7 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 	unsigned int i;
 
 #ifdef CONFIG_SMP
-	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
+	cpumask_copy(policy->cpus, &per_cpu(cpu_sibling_map, policy->cpu));
 #endif
 
 	/* Errata workaround */
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index c3c9adb..5c28b37 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1199,10 +1199,10 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	set_cpus_allowed_ptr(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cpus = cpumask_of_cpu(pol->cpu);
+		cpumask_copy(pol->cpus, cpumask_of(pol->cpu));
 	else
-		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
-	data->available_cores = &(pol->cpus);
+		cpumask_copy(pol->cpus, &per_cpu(cpu_core_map, pol->cpu));
+	data->available_cores = pol->cpus;
 
 	/* Take a crude guess here.
 	 * That guess was in microseconds, so multiply with 1000 */
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index 65cfb5d..8ecc75b 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -53,7 +53,7 @@ struct powernow_k8_data {
 	/* we need to keep track of associated cores, but let cpufreq
 	 * handle hotplug events - so just point at cpufreq pol->cpus
 	 * structure */
-	cpumask_t *available_cores;
+	struct cpumask *available_cores;
 };
 
 
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index f0ea6fa..f089982 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -458,11 +458,6 @@ static int centrino_verify (struct cpufreq_policy *policy)
  *
  * Sets a new CPUFreq policy.
  */
-struct allmasks {
-	cpumask_t		saved_mask;
-	cpumask_t		covered_cpus;
-};
-
 static int centrino_target (struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
@@ -472,12 +467,15 @@ static int centrino_target (struct cpufreq_policy *policy,
 	struct cpufreq_freqs	freqs;
 	int			retval = 0;
 	unsigned int		j, k, first_cpu, tmp;
-	CPUMASK_ALLOC(allmasks);
-	CPUMASK_PTR(saved_mask, allmasks);
-	CPUMASK_PTR(covered_cpus, allmasks);
+	cpumask_var_t saved_mask, covered_cpus;
 
-	if (unlikely(allmasks == NULL))
+	if (unlikely(!alloc_cpumask_var(&saved_mask, GFP_KERNEL)))
 		return -ENOMEM;
+	if (unlikely(!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))) {
+		free_cpumask_var(saved_mask);
+		return -ENOMEM;
+	}
+	cpumask_copy(saved_mask, &current->cpus_allowed);
 
 	if (unlikely(per_cpu(centrino_model, cpu) == NULL)) {
 		retval = -ENODEV;
@@ -493,11 +491,9 @@ static int centrino_target (struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	*saved_mask = current->cpus_allowed;
 	first_cpu = 1;
-	cpus_clear(*covered_cpus);
-	for_each_cpu_mask_nr(j, policy->cpus) {
-		const cpumask_t *mask;
+	for_each_cpu(j, policy->cpus) {
+		const struct cpumask *mask;
 
 		/* cpufreq holds the hotplug lock, so we are safe here */
 		if (!cpu_online(j))
@@ -508,9 +504,9 @@ static int centrino_target (struct cpufreq_policy *policy,
 		 * Make sure we are running on CPU that wants to change freq
 		 */
 		if (policy->shared_type == CPUFREQ_SHARED_TYPE_ANY)
-			mask = &policy->cpus;
+			mask = policy->cpus;
 		else
-			mask = &cpumask_of_cpu(j);
+			mask = cpumask_of(j);
 
 		set_cpus_allowed_ptr(current, mask);
 		preempt_disable();
@@ -542,7 +538,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 			dprintk("target=%dkHz old=%d new=%d msr=%04x\n",
 				target_freq, freqs.old, freqs.new, msr);
 
-			for_each_cpu_mask_nr(k, policy->cpus) {
+			for_each_cpu(k, policy->cpus) {
 				if (!cpu_online(k))
 					continue;
 				freqs.cpu = k;
@@ -567,7 +563,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 		preempt_enable();
 	}
 
-	for_each_cpu_mask_nr(k, policy->cpus) {
+	for_each_cpu(k, policy->cpus) {
 		if (!cpu_online(k))
 			continue;
 		freqs.cpu = k;
@@ -590,7 +586,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 		tmp = freqs.new;
 		freqs.new = freqs.old;
 		freqs.old = tmp;
-		for_each_cpu_mask_nr(j, policy->cpus) {
+		for_each_cpu(j, policy->cpus) {
 			if (!cpu_online(j))
 				continue;
 			cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
@@ -605,7 +601,8 @@ migrate_end:
 	preempt_enable();
 	set_cpus_allowed_ptr(current, saved_mask);
 out:
-	CPUMASK_FREE(allmasks);
+	free_cpumask_var(saved_mask);
+	free_cpumask_var(covered_cpus);
 	return retval;
 }
 
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index 04d0376..dedc1e9 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -229,7 +229,7 @@ static unsigned int speedstep_detect_chipset (void)
 	return 0;
 }
 
-static unsigned int _speedstep_get(const cpumask_t *cpus)
+static unsigned int _speedstep_get(const struct cpumask *cpus)
 {
 	unsigned int speed;
 	cpumask_t cpus_allowed;
@@ -244,7 +244,7 @@ static unsigned int _speedstep_get(const cpumask_t *cpus)
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	return _speedstep_get(&cpumask_of_cpu(cpu));
+	return _speedstep_get(cpumask_of(cpu));
 }
 
 /**
@@ -267,7 +267,7 @@ static int speedstep_target (struct cpufreq_policy *policy,
 	if (cpufreq_frequency_table_target(policy, &speedstep_freqs[0], target_freq, relation, &newstate))
 		return -EINVAL;
 
-	freqs.old = _speedstep_get(&policy->cpus);
+	freqs.old = _speedstep_get(policy->cpus);
 	freqs.new = speedstep_freqs[newstate].frequency;
 	freqs.cpu = policy->cpu;
 
@@ -279,20 +279,20 @@ static int speedstep_target (struct cpufreq_policy *policy,
 
 	cpus_allowed = current->cpus_allowed;
 
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
 
 	/* switch to physical CPU where state is to be changed */
-	set_cpus_allowed_ptr(current, &policy->cpus);
+	set_cpus_allowed_ptr(current, policy->cpus);
 
 	speedstep_set_state(newstate);
 
 	/* allow to be run on all CPUs */
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -322,11 +322,11 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 
 	/* only run on CPU to be set, or on its sibling */
 #ifdef CONFIG_SMP
-	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
+	cpumask_copy(policy->cpus, &per_cpu(cpu_sibling_map, policy->cpu));
 #endif
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &policy->cpus);
+	set_cpus_allowed_ptr(current, policy->cpus);
 
 	/* detect low and high frequency and transition latency */
 	result = speedstep_get_freqs(speedstep_processor,
@@ -339,7 +339,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 		return result;
 
 	/* get current speed setting */
-	speed = _speedstep_get(&policy->cpus);
+	speed = _speedstep_get(policy->cpus);
 	if (!speed)
 		return -EIO;
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index a4b619c..aa55764 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -131,7 +131,27 @@ static void __init setup_cpu_pda_map(void)
 	/* point to new pointer table */
 	_cpu_pda = new_cpu_pda;
 }
-#endif
+
+#endif /* CONFIG_SMP && CONFIG_X86_64 */
+
+#ifdef CONFIG_X86_64
+
+/* correctly size the local cpu masks */
+static void setup_cpu_local_masks(void)
+{
+	alloc_bootmem_cpumask_var(&cpu_initialized_mask);
+	alloc_bootmem_cpumask_var(&cpu_callin_mask);
+	alloc_bootmem_cpumask_var(&cpu_callout_mask);
+	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
+}
+
+#else /* CONFIG_X86_32 */
+
+static inline void setup_cpu_local_masks(void)
+{
+}
+
+#endif /* CONFIG_X86_32 */
 
 /*
  * Great future plan:
@@ -187,6 +207,9 @@ void __init setup_per_cpu_areas(void)
 
 	/* Setup node to cpumask map */
 	setup_node_to_cpumask_map();
+
+	/* Setup cpu initialized, callin, callout masks */
+	setup_cpu_local_masks();
 }
 
 #endif
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index beea264..182135b 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -128,16 +128,23 @@ void native_send_call_func_single_ipi(int cpu)
 
 void native_send_call_func_ipi(const struct cpumask *mask)
 {
-	cpumask_t allbutself;
+	cpumask_var_t allbutself;
 
-	allbutself = cpu_online_map;
-	cpu_clear(smp_processor_id(), allbutself);
+	if (!alloc_cpumask_var(&allbutself, GFP_ATOMIC)) {
+		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+		return;
+	}
 
-	if (cpus_equal(*mask, allbutself) &&
-	    cpus_equal(cpu_online_map, cpu_callout_map))
+	cpumask_copy(allbutself, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), allbutself);
+
+	if (cpumask_equal(mask, allbutself) &&
+	    cpumask_equal(cpu_online_mask, cpu_callout_mask))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
 		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+
+	free_cpumask_var(allbutself);
 }
 
 /*
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6bd4d9b..00e17e5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -102,9 +102,6 @@ EXPORT_SYMBOL(smp_num_siblings);
 /* Last level cache ID of each logical CPU */
 DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
 
-cpumask_t cpu_callin_map;
-cpumask_t cpu_callout_map;
-
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
@@ -120,9 +117,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 static atomic_t init_deasserted;
 
 
-/* representing cpus for which sibling maps can be computed */
-static cpumask_t cpu_sibling_setup_map;
-
 /* Set if we find a B stepping CPU */
 static int __cpuinitdata smp_b_stepping;
 
@@ -140,7 +134,7 @@ EXPORT_SYMBOL(cpu_to_node_map);
 static void map_cpu_to_node(int cpu, int node)
 {
 	printk(KERN_INFO "Mapping cpu %d to node %d\n", cpu, node);
-	cpu_set(cpu, node_to_cpumask_map[node]);
+	cpumask_set_cpu(cpu, &node_to_cpumask_map[node]);
 	cpu_to_node_map[cpu] = node;
 }
 
@@ -151,7 +145,7 @@ static void unmap_cpu_to_node(int cpu)
 
 	printk(KERN_INFO "Unmapping cpu %d from all nodes\n", cpu);
 	for (node = 0; node < MAX_NUMNODES; node++)
-		cpu_clear(cpu, node_to_cpumask_map[node]);
+		cpumask_clear_cpu(cpu, &node_to_cpumask_map[node]);
 	cpu_to_node_map[cpu] = 0;
 }
 #else /* !(CONFIG_NUMA && CONFIG_X86_32) */
@@ -209,7 +203,7 @@ static void __cpuinit smp_callin(void)
 	 */
 	phys_id = read_apic_id();
 	cpuid = smp_processor_id();
-	if (cpu_isset(cpuid, cpu_callin_map)) {
+	if (cpumask_test_cpu(cpuid, cpu_callin_mask)) {
 		panic("%s: phys CPU#%d, CPU#%d already present??\n", __func__,
 					phys_id, cpuid);
 	}
@@ -231,7 +225,7 @@ static void __cpuinit smp_callin(void)
 		/*
 		 * Has the boot CPU finished it's STARTUP sequence?
 		 */
-		if (cpu_isset(cpuid, cpu_callout_map))
+		if (cpumask_test_cpu(cpuid, cpu_callout_mask))
 			break;
 		cpu_relax();
 	}
@@ -274,7 +268,7 @@ static void __cpuinit smp_callin(void)
 	/*
 	 * Allow the master to continue.
 	 */
-	cpu_set(cpuid, cpu_callin_map);
+	cpumask_set_cpu(cpuid, cpu_callin_mask);
 }
 
 static int __cpuinitdata unsafe_smp;
@@ -332,7 +326,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	ipi_call_lock();
 	lock_vector_lock();
 	__setup_vector_irq(smp_processor_id());
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 	unlock_vector_lock();
 	ipi_call_unlock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
@@ -438,50 +432,52 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	int i;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	cpu_set(cpu, cpu_sibling_setup_map);
+	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
 
 	if (smp_num_siblings > 1) {
-		for_each_cpu_mask_nr(i, cpu_sibling_setup_map) {
-			if (c->phys_proc_id == cpu_data(i).phys_proc_id &&
-			    c->cpu_core_id == cpu_data(i).cpu_core_id) {
-				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
-				cpu_set(cpu, per_cpu(cpu_sibling_map, i));
-				cpu_set(i, per_cpu(cpu_core_map, cpu));
-				cpu_set(cpu, per_cpu(cpu_core_map, i));
-				cpu_set(i, c->llc_shared_map);
-				cpu_set(cpu, cpu_data(i).llc_shared_map);
+		for_each_cpu(i, cpu_sibling_setup_mask) {
+			struct cpuinfo_x86 *o = &cpu_data(i);
+
+			if (c->phys_proc_id == o->phys_proc_id &&
+			    c->cpu_core_id == o->cpu_core_id) {
+				cpumask_set_cpu(i, cpu_sibling_mask(cpu));
+				cpumask_set_cpu(cpu, cpu_sibling_mask(i));
+				cpumask_set_cpu(i, cpu_core_mask(cpu));
+				cpumask_set_cpu(cpu, cpu_core_mask(i));
+				cpumask_set_cpu(i, &c->llc_shared_map);
+				cpumask_set_cpu(cpu, &o->llc_shared_map);
 			}
 		}
 	} else {
-		cpu_set(cpu, per_cpu(cpu_sibling_map, cpu));
+		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
 	}
 
-	cpu_set(cpu, c->llc_shared_map);
+	cpumask_set_cpu(cpu, &c->llc_shared_map);
 
 	if (current_cpu_data.x86_max_cores == 1) {
-		per_cpu(cpu_core_map, cpu) = per_cpu(cpu_sibling_map, cpu);
+		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
 		c->booted_cores = 1;
 		return;
 	}
 
-	for_each_cpu_mask_nr(i, cpu_sibling_setup_map) {
+	for_each_cpu(i, cpu_sibling_setup_mask) {
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
-			cpu_set(i, c->llc_shared_map);
-			cpu_set(cpu, cpu_data(i).llc_shared_map);
+			cpumask_set_cpu(i, &c->llc_shared_map);
+			cpumask_set_cpu(cpu, &cpu_data(i).llc_shared_map);
 		}
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
-			cpu_set(i, per_cpu(cpu_core_map, cpu));
-			cpu_set(cpu, per_cpu(cpu_core_map, i));
+			cpumask_set_cpu(i, cpu_core_mask(cpu));
+			cpumask_set_cpu(cpu, cpu_core_mask(i));
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
-			if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1) {
+			if (cpumask_weight(cpu_sibling_mask(cpu)) == 1) {
 				/*
 				 * for each core in package, increment
 				 * the booted_cores for this new cpu
 				 */
-				if (first_cpu(per_cpu(cpu_sibling_map, i)) == i)
+				if (cpumask_first(cpu_sibling_mask(i)) == i)
 					c->booted_cores++;
 				/*
 				 * increment the core count for all
@@ -504,7 +500,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	 * And for power savings, we return cpu_core_map
 	 */
 	if (sched_mc_power_savings || sched_smt_power_savings)
-		return &per_cpu(cpu_core_map, cpu);
+		return cpu_core_mask(cpu);
 	else
 		return &c->llc_shared_map;
 }
@@ -523,7 +519,7 @@ static void impress_friends(void)
 	 */
 	pr_debug("Before bogomips.\n");
 	for_each_possible_cpu(cpu)
-		if (cpu_isset(cpu, cpu_callout_map))
+		if (cpumask_test_cpu(cpu, cpu_callout_mask))
 			bogosum += cpu_data(cpu).loops_per_jiffy;
 	printk(KERN_INFO
 		"Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
@@ -904,19 +900,19 @@ do_rest:
 		 * allow APs to start initializing.
 		 */
 		pr_debug("Before Callout %d.\n", cpu);
-		cpu_set(cpu, cpu_callout_map);
+		cpumask_set_cpu(cpu, cpu_callout_mask);
 		pr_debug("After Callout %d.\n", cpu);
 
 		/*
 		 * Wait 5s total for a response
 		 */
 		for (timeout = 0; timeout < 50000; timeout++) {
-			if (cpu_isset(cpu, cpu_callin_map))
+			if (cpumask_test_cpu(cpu, cpu_callin_mask))
 				break;	/* It has booted */
 			udelay(100);
 		}
 
-		if (cpu_isset(cpu, cpu_callin_map)) {
+		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
 			/* number CPUs logically, starting from 1 (BSP is 0) */
 			pr_debug("OK.\n");
 			printk(KERN_INFO "CPU%d: ", cpu);
@@ -941,9 +937,14 @@ restore_state:
 	if (boot_error) {
 		/* Try to put things back the way they were before ... */
 		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
-		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
-		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
-		cpu_clear(cpu, cpu_present_map);
+
+		/* was set by do_boot_cpu() */
+		cpumask_clear_cpu(cpu, cpu_callout_mask);
+
+		/* was set by cpu_init() */
+		cpumask_clear_cpu(cpu, cpu_initialized_mask);
+
+		set_cpu_present(cpu, false);
 		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	}
 
@@ -977,7 +978,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	/*
 	 * Already booted CPU?
 	 */
-	if (cpu_isset(cpu, cpu_callin_map)) {
+	if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
 		pr_debug("do_boot_cpu %d Already started\n", cpu);
 		return -ENOSYS;
 	}
@@ -1032,8 +1033,9 @@ int __cpuinit native_cpu_up(unsigned int cpu)
  */
 static __init void disable_smp(void)
 {
-	cpu_present_map = cpumask_of_cpu(0);
-	cpu_possible_map = cpumask_of_cpu(0);
+	/* use the read/write pointers to the present and possible maps */
+	cpumask_copy(&cpu_present_map, cpumask_of(0));
+	cpumask_copy(&cpu_possible_map, cpumask_of(0));
 	smpboot_clear_io_apic_irqs();
 
 	if (smp_found_config)
@@ -1041,8 +1043,8 @@ static __init void disable_smp(void)
 	else
 		physid_set_mask_of_physid(0, &phys_cpu_present_map);
 	map_cpu_to_logical_apicid();
-	cpu_set(0, per_cpu(cpu_sibling_map, 0));
-	cpu_set(0, per_cpu(cpu_core_map, 0));
+	cpumask_set_cpu(0, cpu_sibling_mask(0));
+	cpumask_set_cpu(0, cpu_core_mask(0));
 }
 
 /*
@@ -1064,14 +1066,14 @@ static int __init smp_sanity_check(unsigned max_cpus)
 		nr = 0;
 		for_each_present_cpu(cpu) {
 			if (nr >= 8)
-				cpu_clear(cpu, cpu_present_map);
+				set_cpu_present(cpu, false);
 			nr++;
 		}
 
 		nr = 0;
 		for_each_possible_cpu(cpu) {
 			if (nr >= 8)
-				cpu_clear(cpu, cpu_possible_map);
+				set_cpu_possible(cpu, false);
 			nr++;
 		}
 
@@ -1167,7 +1169,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	preempt_disable();
 	smp_cpu_index_default();
 	current_cpu_data = boot_cpu_data;
-	cpu_callin_map = cpumask_of_cpu(0);
+	cpumask_copy(cpu_callin_mask, cpumask_of(0));
 	mb();
 	/*
 	 * Setup boot CPU information
@@ -1242,8 +1244,8 @@ void __init native_smp_prepare_boot_cpu(void)
 	init_gdt(me);
 #endif
 	switch_to_new_gdt();
-	/* already set me in cpu_online_map in boot_cpu_init() */
-	cpu_set(me, cpu_callout_map);
+	/* already set me in cpu_online_mask in boot_cpu_init() */
+	cpumask_set_cpu(me, cpu_callout_mask);
 	per_cpu(cpu_state, me) = CPU_ONLINE;
 }
 
@@ -1311,7 +1313,7 @@ __init void prefill_possible_map(void)
 		possible, max_t(int, possible - num_processors, 0));
 
 	for (i = 0; i < possible; i++)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 
 	nr_cpu_ids = possible;
 }
@@ -1323,31 +1325,31 @@ static void remove_siblinginfo(int cpu)
 	int sibling;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
-		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
+	for_each_cpu(sibling, cpu_core_mask(cpu)) {
+		cpumask_clear_cpu(cpu, cpu_core_mask(sibling));
 		/*/
 		 * last thread sibling in this cpu core going down
 		 */
-		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
+		if (cpumask_weight(cpu_sibling_mask(cpu)) == 1)
 			cpu_data(sibling).booted_cores--;
 	}
 
-	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
-		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
-	cpus_clear(per_cpu(cpu_sibling_map, cpu));
-	cpus_clear(per_cpu(cpu_core_map, cpu));
+	for_each_cpu(sibling, cpu_sibling_mask(cpu))
+		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
+	cpumask_clear(cpu_sibling_mask(cpu));
+	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id = 0;
 	c->cpu_core_id = 0;
-	cpu_clear(cpu, cpu_sibling_setup_map);
+	cpumask_clear_cpu(cpu, cpu_sibling_setup_mask);
 }
 
 static void __ref remove_cpu_from_maps(int cpu)
 {
-	cpu_clear(cpu, cpu_online_map);
-	cpu_clear(cpu, cpu_callout_map);
-	cpu_clear(cpu, cpu_callin_map);
+	set_cpu_online(cpu, false);
+	cpumask_clear_cpu(cpu, cpu_callout_mask);
+	cpumask_clear_cpu(cpu, cpu_callin_mask);
 	/* was set by cpu_init() */
-	cpu_clear(cpu, cpu_initialized);
+	cpumask_clear_cpu(cpu, cpu_initialized_mask);
 	numa_remove_cpu(cpu);
 }
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 01dde80..b55cb67 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -584,12 +584,12 @@ out:
 	return i;
 }
 
-static ssize_t show_cpus(cpumask_t mask, char *buf)
+static ssize_t show_cpus(const struct cpumask *mask, char *buf)
 {
 	ssize_t i = 0;
 	unsigned int cpu;
 
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu(cpu, mask) {
 		if (i)
 			i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), " ");
 		i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), "%u", cpu);
@@ -606,7 +606,7 @@ static ssize_t show_cpus(cpumask_t mask, char *buf)
  */
 static ssize_t show_related_cpus(struct cpufreq_policy *policy, char *buf)
 {
-	if (cpus_empty(policy->related_cpus))
+	if (cpumask_empty(policy->related_cpus))
 		return show_cpus(policy->cpus, buf);
 	return show_cpus(policy->related_cpus, buf);
 }
@@ -806,9 +806,20 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 		ret = -ENOMEM;
 		goto nomem_out;
 	}
+	if (!alloc_cpumask_var(&policy->cpus, GFP_KERNEL)) {
+		kfree(policy);
+		ret = -ENOMEM;
+		goto nomem_out;
+	}
+	if (!alloc_cpumask_var(&policy->related_cpus, GFP_KERNEL)) {
+		free_cpumask_var(policy->cpus);
+		kfree(policy);
+		ret = -ENOMEM;
+		goto nomem_out;
+	}
 
 	policy->cpu = cpu;
-	policy->cpus = cpumask_of_cpu(cpu);
+	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
 	/* Initially set CPU itself as the policy_cpu */
 	per_cpu(policy_cpu, cpu) = cpu;
@@ -843,7 +854,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	}
 #endif
 
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu(j, policy->cpus) {
 		if (cpu == j)
 			continue;
 
@@ -861,7 +872,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 				goto err_out_driver_exit;
 
 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
-			managed_policy->cpus = policy->cpus;
+			cpumask_copy(managed_policy->cpus, policy->cpus);
 			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
 			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -916,14 +927,14 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	}
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu(j, policy->cpus) {
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(policy_cpu, j) = policy->cpu;
 	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	/* symlink affected CPUs */
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu(j, policy->cpus) {
 		if (j == cpu)
 			continue;
 		if (!cpu_online(j))
@@ -963,7 +974,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 
 err_out_unregister:
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask_nr(j, policy->cpus)
+	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1024,7 +1035,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	 */
 	if (unlikely(cpu != data->cpu)) {
 		dprintk("removing link\n");
-		cpu_clear(cpu, data->cpus);
+		cpumask_clear_cpu(cpu, data->cpus);
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		sysfs_remove_link(&sys_dev->kobj, "cpufreq");
 		cpufreq_cpu_put(data);
@@ -1045,8 +1056,8 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	 * per_cpu(cpufreq_cpu_data) while holding the lock, and remove
 	 * the sysfs links afterwards.
 	 */
-	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask_nr(j, data->cpus) {
+	if (unlikely(cpumask_weight(data->cpus) > 1)) {
+		for_each_cpu(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			per_cpu(cpufreq_cpu_data, j) = NULL;
@@ -1055,8 +1066,8 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask_nr(j, data->cpus) {
+	if (unlikely(cpumask_weight(data->cpus) > 1)) {
+		for_each_cpu(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			dprintk("removing link for cpu %u\n", j);
@@ -1090,7 +1101,10 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(data);
 
+	free_cpumask_var(data->related_cpus);
+	free_cpumask_var(data->cpus);
 	kfree(data);
+	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
 	cpufreq_debug_enable_ratelimit();
 	return 0;
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index e265783..0320962 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -498,7 +498,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			return rc;
 		}
 
-		for_each_cpu_mask_nr(j, policy->cpus) {
+		for_each_cpu(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 2ab3c12..6a2b036 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -400,7 +400,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 	/* Get Absolute Load - in terms of freq */
 	max_load_freq = 0;
 
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_info_s *j_dbs_info;
 		cputime64_t cur_wall_time, cur_idle_time;
 		unsigned int idle_time, wall_time;
@@ -568,7 +568,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			return rc;
 		}
 
-		for_each_cpu_mask_nr(j, policy->cpus) {
+		for_each_cpu(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index c884858..e4957e2 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -70,11 +70,11 @@ static ssize_t broken_parity_status_store(struct device *dev,
 static ssize_t local_cpus_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {		
-	cpumask_t mask;
+	const struct cpumask *mask;
 	int len;
 
-	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpumask_scnprintf(buf, PAGE_SIZE-2, &mask);
+	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
+	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
@@ -84,11 +84,11 @@ static ssize_t local_cpus_show(struct device *dev,
 static ssize_t local_cpulist_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	cpumask_t mask;
+	const struct cpumask *mask;
 	int len;
 
-	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpulist_scnprintf(buf, PAGE_SIZE-2, &mask);
+	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
+	len = cpulist_scnprintf(buf, PAGE_SIZE-2, mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5b3f593..5a021b8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -51,12 +51,12 @@ static ssize_t pci_bus_show_cpuaffinity(struct device *dev,
 					char *buf)
 {
 	int ret;
-	cpumask_t cpumask;
+	const struct cpumask *cpumask;
 
-	cpumask = pcibus_to_cpumask(to_pci_bus(dev));
+	cpumask = cpumask_of_pcibus(to_pci_bus(dev));
 	ret = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, &cpumask) :
-		cpumask_scnprintf(buf, PAGE_SIZE-2, &cpumask);
+		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask) :
+		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
 	buf[ret++] = '\n';
 	buf[ret] = '\0';
 	return ret;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 484b3ab..384b38d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -80,8 +80,8 @@ struct cpufreq_real_policy {
 };
 
 struct cpufreq_policy {
-	cpumask_t		cpus;	/* CPUs requiring sw coordination */
-	cpumask_t		related_cpus; /* CPUs with any coordination */
+	cpumask_var_t		cpus;	/* CPUs requiring sw coordination */
+	cpumask_var_t		related_cpus; /* CPUs with any coordination */
 	unsigned int		shared_type; /* ANY or ALL affected CPUs
 						should set cpufreq */
 	unsigned int		cpu;    /* cpu nr of registered CPU */
