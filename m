Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbZIQVu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbZIQVu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZIQVu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:50:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59365 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbZIQVuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:50:52 -0400
Date: Thu, 17 Sep 2009 23:50:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: [GIT PULL] scheduler updates for v2.6.32, part 2
Message-ID: <20090917215039.GA17160@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

This is the second (and final) part of scheduler updates. Note, if you 
merge this there will be an (easy) conflict in 
arch/x86/include/asm/processor.h.

These changes finish the load balancer rewrite/fixing (fresh code but we 
didnt want to wait with this for v2.6.33 and it fixes performance 
regressions as well), plus does re-tuning based on various new testcases 
brought up in recent lkml scheduler threads.

As a summary of expected impact, in our tests this has improved:

 - make -j<nr_cpus> kernel build results
 - sysbench (balancing regression, sleeper preemption regression)
 - scalability of heavy forkers (the x264 testcase)
 - interactivity (buddy latencies, gentler sleeper-fairness)

Right now we dont know about any flip side of these changes yet, and we 
tried to diligently measure all sides of the coin (and eliminate 
negative effects). (famous last words)

 Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      sched: Implement a gentler fair-sleepers feature
      sched: Fix TASK_WAKING & loadaverage breakage

Mike Galbraith (2):
      sched: Complete buddy switches
      sched: Improve latencies and throughput

Peter Zijlstra (33):
      sched: Fix double_rq_lock() compile warning
      sched: Split WAKEUP_OVERLAP
      sched: Add come comments to the sched features
      sched: Move code around
      sched: Move sched_balance_self() into sched_fair.c
      sched: Hook sched_balance_self() into sched_class::select_task_rq()
      sched: Add TASK_WAKING
      sched: Merge select_task_rq_fair() and sched_balance_self()
      sched: Weaken SD_POWERSAVINGS_BALANCE
      sched: for_each_domain() vs RCU
      sched: Fix task affinity for select_task_rq_fair
      sched: Tweak wake_idx
      sched: Fix some domain tunings
      sched: Reduce forkexec_idx
      sched: Provide arch_scale_freq_power
      x86: Move APERF/MPERF into a X86_FEATURE
      x86: Add generic aperf/mperf code
      x86: sched: Provide arch implementations using aperf/mperf
      sched: Feature to disable APERF/MPERF cpu_power
      sched: Rename select_task_rq() argument
      sched: Rename sync arguments
      sched: Add WF_FORK
      sched: Fix sync wakeups again
      sched: Add a few SYNC hint knobs to play with
      sched: Add SD_PREFER_LOCAL
      sched: x86: Name old_perf in a unique way
      sched: Optimize cgroup vs wakeup a bit
      sched: Clean up the load_idx selection in select_task_rq_fair
      sched: Rename flags to wake_flags
      sched: Disable wakeup balancing
      sched: Add new wakeup preemption mode: WAKEUP_RUNNING
      sched: Stop buddies from hogging the system
      sched: Fix SD_POWERSAVING_BALANCE|SD_PREFER_LOCAL vs SD_WAKE_AFFINE


 arch/ia64/include/asm/topology.h           |   17 +-
 arch/mips/include/asm/mach-ip27/topology.h |    1 -
 arch/powerpc/include/asm/topology.h        |    9 +-
 arch/sh/include/asm/topology.h             |   10 +-
 arch/sparc/include/asm/topology_64.h       |    7 +-
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/include/asm/processor.h           |   30 ++
 arch/x86/include/asm/topology.h            |   14 +-
 arch/x86/kernel/cpu/Makefile               |    2 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   88 +-----
 arch/x86/kernel/cpu/intel.c                |    6 +
 arch/x86/kernel/cpu/sched.c                |   55 ++++
 include/linux/sched.h                      |   23 ++-
 include/linux/topology.h                   |   32 +--
 include/linux/wait.h                       |    4 +-
 kernel/sched.c                             |  444 +++++++++-------------------
 kernel/sched_debug.c                       |    1 +
 kernel/sched_fair.c                        |  414 ++++++++++++++++----------
 kernel/sched_features.h                    |  122 +++++++-
 kernel/sched_idletask.c                    |    4 +-
 kernel/sched_rt.c                          |    7 +-
 21 files changed, 688 insertions(+), 603 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/sched.c

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 7b4c8c7..d0141fb 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -61,12 +61,13 @@ void build_cpu_to_node_map(void);
 	.cache_nice_tries	= 2,			\
 	.busy_idx		= 2,			\
 	.idle_idx		= 1,			\
-	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
-	.forkexec_idx		= 1,			\
+	.newidle_idx		= 0,			\
+	.wake_idx		= 0,			\
+	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
@@ -85,14 +86,14 @@ void build_cpu_to_node_map(void);
 	.cache_nice_tries	= 2,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 2,			\
-	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
-	.forkexec_idx		= 1,			\
+	.newidle_idx		= 0,			\
+	.wake_idx		= 0,			\
+	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
+				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
-				| SD_SERIALIZE		\
-				| SD_WAKE_BALANCE,	\
+				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 64,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
index 0754723..2305917 100644
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -48,7 +48,6 @@ extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 	.cache_nice_tries	= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
-				| SD_WAKE_BALANCE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index 054a16d..394edcb 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -57,14 +57,13 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 	.cache_nice_tries	= 1,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 1,			\
-	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
+	.newidle_idx		= 0,			\
+	.wake_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_FORK	\
 				| SD_BALANCE_NEWIDLE	\
-				| SD_WAKE_IDLE		\
-				| SD_SERIALIZE		\
-				| SD_WAKE_BALANCE,	\
+				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index b69ee85..f8c40cc 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -15,14 +15,14 @@
 	.cache_nice_tries	= 2,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 2,			\
-	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
-	.forkexec_idx		= 1,			\
+	.newidle_idx		= 0,			\
+	.wake_idx		= 0,			\
+	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
-				| SD_SERIALIZE		\
-				| SD_WAKE_BALANCE,	\
+				| SD_BALANCE_NEWIDLE	\
+				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index e5ea8d3..26cd25c 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -52,13 +52,12 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 	.busy_idx		= 3,			\
 	.idle_idx		= 2,			\
 	.newidle_idx		= 0, 			\
-	.wake_idx		= 1,			\
-	.forkexec_idx		= 1,			\
+	.wake_idx		= 0,			\
+	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
-				| SD_SERIALIZE		\
-				| SD_WAKE_BALANCE,	\
+				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 847fee6..9cfc88b 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -96,6 +96,7 @@
 #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
 #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
+#define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e08ea04..4ae2ccf 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -27,6 +27,7 @@ struct mm_struct;
 #include <linux/cpumask.h>
 #include <linux/cache.h>
 #include <linux/threads.h>
+#include <linux/math64.h>
 #include <linux/init.h>
 
 /*
@@ -1020,4 +1021,33 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
+struct aperfmperf {
+	u64 aperf, mperf;
+};
+
+static inline void get_aperfmperf(struct aperfmperf *am)
+{
+	WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_APERFMPERF));
+
+	rdmsrl(MSR_IA32_APERF, am->aperf);
+	rdmsrl(MSR_IA32_MPERF, am->mperf);
+}
+
+#define APERFMPERF_SHIFT 10
+
+static inline
+unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
+				    struct aperfmperf *new)
+{
+	u64 aperf = new->aperf - old->aperf;
+	u64 mperf = new->mperf - old->mperf;
+	unsigned long ratio = aperf;
+
+	mperf >>= APERFMPERF_SHIFT;
+	if (mperf)
+		ratio = div64_u64(aperf, mperf);
+
+	return ratio;
+}
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 26d06e0..6f0695d 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -116,15 +116,11 @@ extern unsigned long node_remap_size[];
 
 # define SD_CACHE_NICE_TRIES	1
 # define SD_IDLE_IDX		1
-# define SD_NEWIDLE_IDX		2
-# define SD_FORKEXEC_IDX	0
 
 #else
 
 # define SD_CACHE_NICE_TRIES	2
 # define SD_IDLE_IDX		2
-# define SD_NEWIDLE_IDX		2
-# define SD_FORKEXEC_IDX	1
 
 #endif
 
@@ -137,22 +133,20 @@ extern unsigned long node_remap_size[];
 	.cache_nice_tries	= SD_CACHE_NICE_TRIES,			\
 	.busy_idx		= 3,					\
 	.idle_idx		= SD_IDLE_IDX,				\
-	.newidle_idx		= SD_NEWIDLE_IDX,			\
-	.wake_idx		= 1,					\
-	.forkexec_idx		= SD_FORKEXEC_IDX,			\
+	.newidle_idx		= 0,					\
+	.wake_idx		= 0,					\
+	.forkexec_idx		= 0,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
+				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_WAKE_BALANCE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 1*SD_SERIALIZE			\
-				| 1*SD_WAKE_IDLE_FAR			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index c1f253d..8dd3063 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -13,7 +13,7 @@ CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o
+obj-y			+= vmware.o hypervisor.o sched.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index ae9b503..4109679 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -60,7 +60,6 @@ enum {
 };
 
 #define INTEL_MSR_RANGE		(0xffff)
-#define CPUID_6_ECX_APERFMPERF_CAPABILITY	(0x1)
 
 struct acpi_cpufreq_data {
 	struct acpi_processor_performance *acpi_data;
@@ -71,11 +70,7 @@ struct acpi_cpufreq_data {
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
-struct acpi_msr_data {
-	u64 saved_aperf, saved_mperf;
-};
-
-static DEFINE_PER_CPU(struct acpi_msr_data, msr_data);
+static DEFINE_PER_CPU(struct aperfmperf, old_perf);
 
 DEFINE_TRACE(power_mark);
 
@@ -244,23 +239,12 @@ static u32 get_cur_val(const struct cpumask *mask)
 	return cmd.val;
 }
 
-struct perf_pair {
-	union {
-		struct {
-			u32 lo;
-			u32 hi;
-		} split;
-		u64 whole;
-	} aperf, mperf;
-};
-
 /* Called via smp_call_function_single(), on the target CPU */
 static void read_measured_perf_ctrs(void *_cur)
 {
-	struct perf_pair *cur = _cur;
+	struct aperfmperf *am = _cur;
 
-	rdmsr(MSR_IA32_APERF, cur->aperf.split.lo, cur->aperf.split.hi);
-	rdmsr(MSR_IA32_MPERF, cur->mperf.split.lo, cur->mperf.split.hi);
+	get_aperfmperf(am);
 }
 
 /*
@@ -279,63 +263,17 @@ static void read_measured_perf_ctrs(void *_cur)
 static unsigned int get_measured_perf(struct cpufreq_policy *policy,
 				      unsigned int cpu)
 {
-	struct perf_pair readin, cur;
-	unsigned int perf_percent;
+	struct aperfmperf perf;
+	unsigned long ratio;
 	unsigned int retval;
 
-	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &readin, 1))
+	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
 		return 0;
 
-	cur.aperf.whole = readin.aperf.whole -
-				per_cpu(msr_data, cpu).saved_aperf;
-	cur.mperf.whole = readin.mperf.whole -
-				per_cpu(msr_data, cpu).saved_mperf;
-	per_cpu(msr_data, cpu).saved_aperf = readin.aperf.whole;
-	per_cpu(msr_data, cpu).saved_mperf = readin.mperf.whole;
-
-#ifdef __i386__
-	/*
-	 * We dont want to do 64 bit divide with 32 bit kernel
-	 * Get an approximate value. Return failure in case we cannot get
-	 * an approximate value.
-	 */
-	if (unlikely(cur.aperf.split.hi || cur.mperf.split.hi)) {
-		int shift_count;
-		u32 h;
-
-		h = max_t(u32, cur.aperf.split.hi, cur.mperf.split.hi);
-		shift_count = fls(h);
-
-		cur.aperf.whole >>= shift_count;
-		cur.mperf.whole >>= shift_count;
-	}
-
-	if (((unsigned long)(-1) / 100) < cur.aperf.split.lo) {
-		int shift_count = 7;
-		cur.aperf.split.lo >>= shift_count;
-		cur.mperf.split.lo >>= shift_count;
-	}
-
-	if (cur.aperf.split.lo && cur.mperf.split.lo)
-		perf_percent = (cur.aperf.split.lo * 100) / cur.mperf.split.lo;
-	else
-		perf_percent = 0;
+	ratio = calc_aperfmperf_ratio(&per_cpu(old_perf, cpu), &perf);
+	per_cpu(old_perf, cpu) = perf;
 
-#else
-	if (unlikely(((unsigned long)(-1) / 100) < cur.aperf.whole)) {
-		int shift_count = 7;
-		cur.aperf.whole >>= shift_count;
-		cur.mperf.whole >>= shift_count;
-	}
-
-	if (cur.aperf.whole && cur.mperf.whole)
-		perf_percent = (cur.aperf.whole * 100) / cur.mperf.whole;
-	else
-		perf_percent = 0;
-
-#endif
-
-	retval = (policy->cpuinfo.max_freq * perf_percent) / 100;
+	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
 
 	return retval;
 }
@@ -731,12 +669,8 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	acpi_processor_notify_smm(THIS_MODULE);
 
 	/* Check for APERF/MPERF support in hardware */
-	if (c->x86_vendor == X86_VENDOR_INTEL && c->cpuid_level >= 6) {
-		unsigned int ecx;
-		ecx = cpuid_ecx(6);
-		if (ecx & CPUID_6_ECX_APERFMPERF_CAPABILITY)
-			acpi_cpufreq_driver.getavg = get_measured_perf;
-	}
+	if (cpu_has(c, X86_FEATURE_APERFMPERF))
+		acpi_cpufreq_driver.getavg = get_measured_perf;
 
 	dprintk("CPU%u - ACPI performance management activated.\n", cpu);
 	for (i = 0; i < perf->state_count; i++)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 80a722a..40e1835 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -350,6 +350,12 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
+	if (c->cpuid_level > 6) {
+		unsigned ecx = cpuid_ecx(6);
+		if (ecx & 0x01)
+			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
+	}
+
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 	if (cpu_has_ds) {
diff --git a/arch/x86/kernel/cpu/sched.c b/arch/x86/kernel/cpu/sched.c
new file mode 100644
index 0000000..a640ae5
--- /dev/null
+++ b/arch/x86/kernel/cpu/sched.c
@@ -0,0 +1,55 @@
+#include <linux/sched.h>
+#include <linux/math64.h>
+#include <linux/percpu.h>
+#include <linux/irqflags.h>
+
+#include <asm/cpufeature.h>
+#include <asm/processor.h>
+
+#ifdef CONFIG_SMP
+
+static DEFINE_PER_CPU(struct aperfmperf, old_perf_sched);
+
+static unsigned long scale_aperfmperf(void)
+{
+	struct aperfmperf val, *old = &__get_cpu_var(old_perf_sched);
+	unsigned long ratio, flags;
+
+	local_irq_save(flags);
+	get_aperfmperf(&val);
+	local_irq_restore(flags);
+
+	ratio = calc_aperfmperf_ratio(old, &val);
+	*old = val;
+
+	return ratio;
+}
+
+unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
+{
+	/*
+	 * do aperf/mperf on the cpu level because it includes things
+	 * like turbo mode, which are relevant to full cores.
+	 */
+	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
+		return scale_aperfmperf();
+
+	/*
+	 * maybe have something cpufreq here
+	 */
+
+	return default_scale_freq_power(sd, cpu);
+}
+
+unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
+{
+	/*
+	 * aperf/mperf already includes the smt gain
+	 */
+	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
+		return SCHED_LOAD_SCALE;
+
+	return default_scale_smt_power(sd, cpu);
+}
+
+#endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f3d74bd..8af3d24 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -190,6 +190,7 @@ extern unsigned long long time_sync_thresh;
 /* in tsk->state again */
 #define TASK_DEAD		64
 #define TASK_WAKEKILL		128
+#define TASK_WAKING		256
 
 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
@@ -802,14 +803,14 @@ enum cpu_idle_type {
 #define SD_BALANCE_NEWIDLE	0x0002	/* Balance when about to become idle */
 #define SD_BALANCE_EXEC		0x0004	/* Balance on exec */
 #define SD_BALANCE_FORK		0x0008	/* Balance on fork, clone */
-#define SD_WAKE_IDLE		0x0010	/* Wake to idle CPU on task wakeup */
+#define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
-#define SD_WAKE_BALANCE		0x0040	/* Perform balancing at task wakeup */
+#define SD_PREFER_LOCAL		0x0040  /* Prefer to keep tasks local to this domain */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
 #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
-#define SD_WAKE_IDLE_FAR	0x0800	/* Gain latency sacrificing cache hit */
+
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 
 enum powersavings_balance_level {
@@ -991,6 +992,9 @@ static inline int test_sd_parent(struct sched_domain *sd, int flag)
 	return 0;
 }
 
+unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
+unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
+
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
@@ -1002,6 +1006,7 @@ partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 }
 #endif	/* !CONFIG_SMP */
 
+
 struct io_context;			/* See blkdev.h */
 
 
@@ -1019,6 +1024,12 @@ struct uts_namespace;
 struct rq;
 struct sched_domain;
 
+/*
+ * wake flags
+ */
+#define WF_SYNC		0x01		/* waker goes to sleep after wakup */
+#define WF_FORK		0x02		/* child wakeup after fork */
+
 struct sched_class {
 	const struct sched_class *next;
 
@@ -1026,13 +1037,13 @@ struct sched_class {
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
 
-	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int sync);
+	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
 	struct task_struct * (*pick_next_task) (struct rq *rq);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct task_struct *p, int sync);
+	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
 
 	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
 			struct rq *busiest, unsigned long max_load_move,
@@ -1102,6 +1113,8 @@ struct sched_entity {
 	u64			start_runtime;
 	u64			avg_wakeup;
 
+	u64			avg_running;
+
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 85e8cf7..809b26c 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -95,14 +95,12 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
+				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_WAKE_BALANCE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 0*SD_WAKE_IDLE_FAR			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
@@ -122,20 +120,19 @@ int arch_update_cpu_topology(void);
 	.imbalance_pct		= 125,					\
 	.cache_nice_tries	= 1,					\
 	.busy_idx		= 2,					\
-	.wake_idx		= 1,					\
-	.forkexec_idx		= 1,					\
+	.wake_idx		= 0,					\
+	.forkexec_idx		= 0,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 1*SD_WAKE_IDLE			\
+				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_WAKE_BALANCE			\
+				| 1*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 0*SD_WAKE_IDLE_FAR			\
 				| sd_balance_for_mc_power()		\
 				| sd_power_saving_flags()		\
 				,					\
@@ -155,21 +152,20 @@ int arch_update_cpu_topology(void);
 	.cache_nice_tries	= 1,					\
 	.busy_idx		= 2,					\
 	.idle_idx		= 1,					\
-	.newidle_idx		= 2,					\
-	.wake_idx		= 1,					\
-	.forkexec_idx		= 1,					\
+	.newidle_idx		= 0,					\
+	.wake_idx		= 0,					\
+	.forkexec_idx		= 0,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 1*SD_WAKE_IDLE			\
-				| 0*SD_WAKE_AFFINE			\
-				| 1*SD_WAKE_BALANCE			\
+				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 0*SD_WAKE_IDLE_FAR			\
 				| sd_balance_for_package_power()	\
 				| sd_power_saving_flags()		\
 				,					\
@@ -191,14 +187,12 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 0*SD_BALANCE_EXEC			\
 				| 0*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
-				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_WAKE_BALANCE			\
+				| 0*SD_BALANCE_WAKE			\
+				| 0*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 1*SD_SERIALIZE			\
-				| 1*SD_WAKE_IDLE_FAR			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
diff --git a/include/linux/wait.h b/include/linux/wait.h
index cf3c2f5..a48e16b 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -26,8 +26,8 @@
 #include <asm/current.h>
 
 typedef struct __wait_queue wait_queue_t;
-typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int sync, void *key);
-int default_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
+typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, void *key);
+int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
 
 struct __wait_queue {
 	unsigned int flags;
diff --git a/kernel/sched.c b/kernel/sched.c
index e27a536..3bb4ea2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -119,8 +119,6 @@
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
-static void double_rq_lock(struct rq *rq1, struct rq *rq2);
-
 static inline int rt_policy(int policy)
 {
 	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
@@ -378,13 +376,6 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 
 #else
 
-#ifdef CONFIG_SMP
-static int root_task_group_empty(void)
-{
-	return 1;
-}
-#endif
-
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
 static inline struct task_group *task_group(struct task_struct *p)
 {
@@ -514,14 +505,6 @@ struct root_domain {
 #ifdef CONFIG_SMP
 	struct cpupri cpupri;
 #endif
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	/*
-	 * Preferred wake up cpu nominated by sched_mc balance that will be
-	 * used when most cpus are idle in the system indicating overall very
-	 * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
-	 */
-	unsigned int sched_mc_preferred_wakeup_cpu;
-#endif
 };
 
 /*
@@ -646,9 +629,10 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-static inline void check_preempt_curr(struct rq *rq, struct task_struct *p, int sync)
+static inline
+void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 {
-	rq->curr->sched_class->check_preempt_curr(rq, p, sync);
+	rq->curr->sched_class->check_preempt_curr(rq, p, flags);
 }
 
 static inline int cpu_of(struct rq *rq)
@@ -1509,8 +1493,65 @@ static int tg_nop(struct task_group *tg, void *data)
 #endif
 
 #ifdef CONFIG_SMP
-static unsigned long source_load(int cpu, int type);
-static unsigned long target_load(int cpu, int type);
+/* Used instead of source_load when we know the type == 0 */
+static unsigned long weighted_cpuload(const int cpu)
+{
+	return cpu_rq(cpu)->load.weight;
+}
+
+/*
+ * Return a low guess at the load of a migration-source cpu weighted
+ * according to the scheduling class and "nice" value.
+ *
+ * We want to under-estimate the load of migration sources, to
+ * balance conservatively.
+ */
+static unsigned long source_load(int cpu, int type)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
+
+	if (type == 0 || !sched_feat(LB_BIAS))
+		return total;
+
+	return min(rq->cpu_load[type-1], total);
+}
+
+/*
+ * Return a high guess at the load of a migration-target cpu weighted
+ * according to the scheduling class and "nice" value.
+ */
+static unsigned long target_load(int cpu, int type)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
+
+	if (type == 0 || !sched_feat(LB_BIAS))
+		return total;
+
+	return max(rq->cpu_load[type-1], total);
+}
+
+static struct sched_group *group_of(int cpu)
+{
+	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
+
+	if (!sd)
+		return NULL;
+
+	return sd->groups;
+}
+
+static unsigned long power_of(int cpu)
+{
+	struct sched_group *group = group_of(cpu);
+
+	if (!group)
+		return SCHED_LOAD_SCALE;
+
+	return group->cpu_power;
+}
+
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 
 static unsigned long cpu_avg_load_per_task(int cpu)
@@ -1695,6 +1736,8 @@ static inline void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 
 #ifdef CONFIG_PREEMPT
 
+static void double_rq_lock(struct rq *rq1, struct rq *rq2);
+
 /*
  * fair double_lock_balance: Safely acquires both rq->locks in a fair
  * way at the expense of forcing extra atomic operations in all
@@ -1959,13 +2002,6 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 }
 
 #ifdef CONFIG_SMP
-
-/* Used instead of source_load when we know the type == 0 */
-static unsigned long weighted_cpuload(const int cpu)
-{
-	return cpu_rq(cpu)->load.weight;
-}
-
 /*
  * Is this task likely cache-hot:
  */
@@ -2239,185 +2275,6 @@ void kick_process(struct task_struct *p)
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(kick_process);
-
-/*
- * Return a low guess at the load of a migration-source cpu weighted
- * according to the scheduling class and "nice" value.
- *
- * We want to under-estimate the load of migration sources, to
- * balance conservatively.
- */
-static unsigned long source_load(int cpu, int type)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (type == 0 || !sched_feat(LB_BIAS))
-		return total;
-
-	return min(rq->cpu_load[type-1], total);
-}
-
-/*
- * Return a high guess at the load of a migration-target cpu weighted
- * according to the scheduling class and "nice" value.
- */
-static unsigned long target_load(int cpu, int type)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (type == 0 || !sched_feat(LB_BIAS))
-		return total;
-
-	return max(rq->cpu_load[type-1], total);
-}
-
-/*
- * find_idlest_group finds and returns the least busy CPU group within the
- * domain.
- */
-static struct sched_group *
-find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
-{
-	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
-	unsigned long min_load = ULONG_MAX, this_load = 0;
-	int load_idx = sd->forkexec_idx;
-	int imbalance = 100 + (sd->imbalance_pct-100)/2;
-
-	do {
-		unsigned long load, avg_load;
-		int local_group;
-		int i;
-
-		/* Skip over this group if it has no CPUs allowed */
-		if (!cpumask_intersects(sched_group_cpus(group),
-					&p->cpus_allowed))
-			continue;
-
-		local_group = cpumask_test_cpu(this_cpu,
-					       sched_group_cpus(group));
-
-		/* Tally up the load of all CPUs in the group */
-		avg_load = 0;
-
-		for_each_cpu(i, sched_group_cpus(group)) {
-			/* Bias balancing toward cpus of our domain */
-			if (local_group)
-				load = source_load(i, load_idx);
-			else
-				load = target_load(i, load_idx);
-
-			avg_load += load;
-		}
-
-		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
-
-		if (local_group) {
-			this_load = avg_load;
-			this = group;
-		} else if (avg_load < min_load) {
-			min_load = avg_load;
-			idlest = group;
-		}
-	} while (group = group->next, group != sd->groups);
-
-	if (!idlest || 100*this_load < imbalance*min_load)
-		return NULL;
-	return idlest;
-}
-
-/*
- * find_idlest_cpu - find the idlest cpu among the cpus in group.
- */
-static int
-find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
-{
-	unsigned long load, min_load = ULONG_MAX;
-	int idlest = -1;
-	int i;
-
-	/* Traverse only the allowed CPUs */
-	for_each_cpu_and(i, sched_group_cpus(group), &p->cpus_allowed) {
-		load = weighted_cpuload(i);
-
-		if (load < min_load || (load == min_load && i == this_cpu)) {
-			min_load = load;
-			idlest = i;
-		}
-	}
-
-	return idlest;
-}
-
-/*
- * sched_balance_self: balance the current task (running on cpu) in domains
- * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
- * SD_BALANCE_EXEC.
- *
- * Balance, ie. select the least loaded group.
- *
- * Returns the target CPU number, or the same CPU if no balancing is needed.
- *
- * preempt must be disabled.
- */
-static int sched_balance_self(int cpu, int flag)
-{
-	struct task_struct *t = current;
-	struct sched_domain *tmp, *sd = NULL;
-
-	for_each_domain(cpu, tmp) {
-		/*
-		 * If power savings logic is enabled for a domain, stop there.
-		 */
-		if (tmp->flags & SD_POWERSAVINGS_BALANCE)
-			break;
-		if (tmp->flags & flag)
-			sd = tmp;
-	}
-
-	if (sd)
-		update_shares(sd);
-
-	while (sd) {
-		struct sched_group *group;
-		int new_cpu, weight;
-
-		if (!(sd->flags & flag)) {
-			sd = sd->child;
-			continue;
-		}
-
-		group = find_idlest_group(sd, t, cpu);
-		if (!group) {
-			sd = sd->child;
-			continue;
-		}
-
-		new_cpu = find_idlest_cpu(group, t, cpu);
-		if (new_cpu == -1 || new_cpu == cpu) {
-			/* Now try balancing at a lower domain level of cpu */
-			sd = sd->child;
-			continue;
-		}
-
-		/* Now try balancing at a lower domain level of new_cpu */
-		cpu = new_cpu;
-		weight = cpumask_weight(sched_domain_span(sd));
-		sd = NULL;
-		for_each_domain(cpu, tmp) {
-			if (weight <= cpumask_weight(sched_domain_span(tmp)))
-				break;
-			if (tmp->flags & flag)
-				sd = tmp;
-		}
-		/* while loop will break here if sd == NULL */
-	}
-
-	return cpu;
-}
-
 #endif /* CONFIG_SMP */
 
 /**
@@ -2455,37 +2312,22 @@ void task_oncpu_function_call(struct task_struct *p,
  *
  * returns failure only if the task is already active.
  */
-static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
+static int try_to_wake_up(struct task_struct *p, unsigned int state,
+			  int wake_flags)
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
-	long old_state;
 	struct rq *rq;
 
 	if (!sched_feat(SYNC_WAKEUPS))
-		sync = 0;
-
-#ifdef CONFIG_SMP
-	if (sched_feat(LB_WAKEUP_UPDATE) && !root_task_group_empty()) {
-		struct sched_domain *sd;
+		wake_flags &= ~WF_SYNC;
 
-		this_cpu = raw_smp_processor_id();
-		cpu = task_cpu(p);
-
-		for_each_domain(this_cpu, sd) {
-			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-				update_shares(sd);
-				break;
-			}
-		}
-	}
-#endif
+	this_cpu = get_cpu();
 
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
-	old_state = p->state;
-	if (!(old_state & state))
+	if (!(p->state & state))
 		goto out;
 
 	if (p->se.on_rq)
@@ -2493,27 +2335,29 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 
 	cpu = task_cpu(p);
 	orig_cpu = cpu;
-	this_cpu = smp_processor_id();
 
 #ifdef CONFIG_SMP
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
-	cpu = p->sched_class->select_task_rq(p, sync);
-	if (cpu != orig_cpu) {
+	/*
+	 * In order to handle concurrent wakeups and release the rq->lock
+	 * we put the task in TASK_WAKING state.
+	 *
+	 * First fix up the nr_uninterruptible count:
+	 */
+	if (task_contributes_to_load(p))
+		rq->nr_uninterruptible--;
+	p->state = TASK_WAKING;
+	task_rq_unlock(rq, &flags);
+
+	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
-		task_rq_unlock(rq, &flags);
-		/* might preempt at this point */
-		rq = task_rq_lock(p, &flags);
-		old_state = p->state;
-		if (!(old_state & state))
-			goto out;
-		if (p->se.on_rq)
-			goto out_running;
 
-		this_cpu = smp_processor_id();
-		cpu = task_cpu(p);
-	}
+	rq = task_rq_lock(p, &flags);
+	WARN_ON(p->state != TASK_WAKING);
+	cpu = task_cpu(p);
 
 #ifdef CONFIG_SCHEDSTATS
 	schedstat_inc(rq, ttwu_count);
@@ -2533,7 +2377,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 out_activate:
 #endif /* CONFIG_SMP */
 	schedstat_inc(p, se.nr_wakeups);
-	if (sync)
+	if (wake_flags & WF_SYNC)
 		schedstat_inc(p, se.nr_wakeups_sync);
 	if (orig_cpu != cpu)
 		schedstat_inc(p, se.nr_wakeups_migrate);
@@ -2562,7 +2406,7 @@ out_activate:
 
 out_running:
 	trace_sched_wakeup(rq, p, success);
-	check_preempt_curr(rq, p, sync);
+	check_preempt_curr(rq, p, wake_flags);
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
@@ -2571,6 +2415,7 @@ out_running:
 #endif
 out:
 	task_rq_unlock(rq, &flags);
+	put_cpu();
 
 	return success;
 }
@@ -2613,6 +2458,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.avg_overlap		= 0;
 	p->se.start_runtime		= 0;
 	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
+	p->se.avg_running		= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start			= 0;
@@ -2674,11 +2520,6 @@ void sched_fork(struct task_struct *p, int clone_flags)
 
 	__sched_fork(p);
 
-#ifdef CONFIG_SMP
-	cpu = sched_balance_self(cpu, SD_BALANCE_FORK);
-#endif
-	set_task_cpu(p, cpu);
-
 	/*
 	 * Make sure we do not leak PI boosting priority to the child.
 	 */
@@ -2709,6 +2550,11 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
+#ifdef CONFIG_SMP
+	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
+#endif
+	set_task_cpu(p, cpu);
+
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -2754,7 +2600,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		inc_nr_running(rq);
 	}
 	trace_sched_wakeup_new(rq, p, 1);
-	check_preempt_curr(rq, p, 0);
+	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
 		p->sched_class->task_wake_up(rq, p);
@@ -3263,7 +3109,7 @@ out:
 void sched_exec(void)
 {
 	int new_cpu, this_cpu = get_cpu();
-	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC);
+	new_cpu = current->sched_class->select_task_rq(current, SD_BALANCE_EXEC, 0);
 	put_cpu();
 	if (new_cpu != this_cpu)
 		sched_migrate_task(current, new_cpu);
@@ -3683,11 +3529,6 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 	*imbalance = sds->min_load_per_task;
 	sds->busiest = sds->group_min;
 
-	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
-		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
-			group_first_cpu(sds->group_leader);
-	}
-
 	return 1;
 
 }
@@ -3711,7 +3552,18 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
-unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
+
+unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
+{
+	return SCHED_LOAD_SCALE;
+}
+
+unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
+{
+	return default_scale_freq_power(sd, cpu);
+}
+
+unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = cpumask_weight(sched_domain_span(sd));
 	unsigned long smt_gain = sd->smt_gain;
@@ -3721,6 +3573,11 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 	return smt_gain;
 }
 
+unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
+{
+	return default_scale_smt_power(sd, cpu);
+}
+
 unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -3745,10 +3602,19 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	/* here we could scale based on cpufreq */
+	if (sched_feat(ARCH_POWER))
+		power *= arch_scale_freq_power(sd, cpu);
+	else
+		power *= default_scale_freq_power(sd, cpu);
+
+	power >>= SCHED_LOAD_SHIFT;
 
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
-		power *= arch_scale_smt_power(sd, cpu);
+		if (sched_feat(ARCH_POWER))
+			power *= arch_scale_smt_power(sd, cpu);
+		else
+			power *= default_scale_smt_power(sd, cpu);
+
 		power >>= SCHED_LOAD_SHIFT;
 	}
 
@@ -4161,26 +4027,6 @@ ret:
 	return NULL;
 }
 
-static struct sched_group *group_of(int cpu)
-{
-	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
-
-	if (!sd)
-		return NULL;
-
-	return sd->groups;
-}
-
-static unsigned long power_of(int cpu)
-{
-	struct sched_group *group = group_of(cpu);
-
-	if (!group)
-		return SCHED_LOAD_SCALE;
-
-	return group->cpu_power;
-}
-
 /*
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
@@ -5465,14 +5311,13 @@ static inline void schedule_debug(struct task_struct *prev)
 #endif
 }
 
-static void put_prev_task(struct rq *rq, struct task_struct *prev)
+static void put_prev_task(struct rq *rq, struct task_struct *p)
 {
-	if (prev->state == TASK_RUNNING) {
-		u64 runtime = prev->se.sum_exec_runtime;
+	u64 runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
 
-		runtime -= prev->se.prev_sum_exec_runtime;
-		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
+	update_avg(&p->se.avg_running, runtime);
 
+	if (p->state == TASK_RUNNING) {
 		/*
 		 * In order to avoid avg_overlap growing stale when we are
 		 * indeed overlapping and hence not getting put to sleep, grow
@@ -5482,9 +5327,12 @@ static void put_prev_task(struct rq *rq, struct task_struct *prev)
 		 * correlates to the amount of cache footprint a task can
 		 * build up.
 		 */
-		update_avg(&prev->se.avg_overlap, runtime);
+		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
+		update_avg(&p->se.avg_overlap, runtime);
+	} else {
+		update_avg(&p->se.avg_running, 0);
 	}
-	prev->sched_class->put_prev_task(rq, prev);
+	p->sched_class->put_prev_task(rq, p);
 }
 
 /*
@@ -5716,10 +5564,10 @@ asmlinkage void __sched preempt_schedule_irq(void)
 
 #endif /* CONFIG_PREEMPT */
 
-int default_wake_function(wait_queue_t *curr, unsigned mode, int sync,
+int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
 			  void *key)
 {
-	return try_to_wake_up(curr->private, mode, sync);
+	return try_to_wake_up(curr->private, mode, wake_flags);
 }
 EXPORT_SYMBOL(default_wake_function);
 
@@ -5733,14 +5581,14 @@ EXPORT_SYMBOL(default_wake_function);
  * zero in this (rare) case, and we handle it by continuing to scan the queue.
  */
 static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, int sync, void *key)
+			int nr_exclusive, int wake_flags, void *key)
 {
 	wait_queue_t *curr, *next;
 
 	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
 		unsigned flags = curr->flags;
 
-		if (curr->func(curr, mode, sync, key) &&
+		if (curr->func(curr, mode, wake_flags, key) &&
 				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
 			break;
 	}
@@ -5801,16 +5649,16 @@ void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
 {
 	unsigned long flags;
-	int sync = 1;
+	int wake_flags = WF_SYNC;
 
 	if (unlikely(!q))
 		return;
 
 	if (unlikely(!nr_exclusive))
-		sync = 0;
+		wake_flags = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, sync, key);
+	__wake_up_common(q, mode, nr_exclusive, wake_flags, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync_key);
@@ -8000,9 +7848,7 @@ static int sd_degenerate(struct sched_domain *sd)
 	}
 
 	/* Following flags don't use groups */
-	if (sd->flags & (SD_WAKE_IDLE |
-			 SD_WAKE_AFFINE |
-			 SD_WAKE_BALANCE))
+	if (sd->flags & (SD_WAKE_AFFINE))
 		return 0;
 
 	return 1;
@@ -8019,10 +7865,6 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 	if (!cpumask_equal(sched_domain_span(sd), sched_domain_span(parent)))
 		return 0;
 
-	/* Does parent contain flags not in child? */
-	/* WAKE_BALANCE is a subset of WAKE_AFFINE */
-	if (cflags & SD_WAKE_AFFINE)
-		pflags &= ~SD_WAKE_BALANCE;
 	/* Flags needing groups don't count if only 1 group in parent */
 	if (parent->groups == parent->groups->next) {
 		pflags &= ~(SD_LOAD_BALANCE |
@@ -8708,10 +8550,10 @@ static void set_domain_attribute(struct sched_domain *sd,
 		request = attr->relax_domain_level;
 	if (request < sd->level) {
 		/* turn off idle balance on this domain */
-		sd->flags &= ~(SD_WAKE_IDLE|SD_BALANCE_NEWIDLE);
+		sd->flags &= ~(SD_BALANCE_WAKE|SD_BALANCE_NEWIDLE);
 	} else {
 		/* turn on idle balance on this domain */
-		sd->flags |= (SD_WAKE_IDLE_FAR|SD_BALANCE_NEWIDLE);
+		sd->flags |= (SD_BALANCE_WAKE|SD_BALANCE_NEWIDLE);
 	}
 }
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 5ddbd08..efb8440 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -395,6 +395,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.sum_exec_runtime);
 	PN(se.avg_overlap);
 	PN(se.avg_wakeup);
+	PN(se.avg_running);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index aa7f841..10d218a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -711,7 +711,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS)) {
+		if (sched_feat(FAIR_SLEEPERS)) {
 			unsigned long thresh = sysctl_sched_latency;
 
 			/*
@@ -725,6 +725,13 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 					 task_of(se)->policy != SCHED_IDLE))
 				thresh = calc_delta_fair(thresh, se);
 
+			/*
+			 * Halve their sleep time's effect, to allow
+			 * for a gentler effect of sleepers:
+			 */
+			if (sched_feat(GENTLE_FAIR_SLEEPERS))
+				thresh >>= 1;
+
 			vruntime -= thresh;
 		}
 	}
@@ -757,10 +764,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 
 static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (cfs_rq->last == se)
+	if (!se || cfs_rq->last == se)
 		cfs_rq->last = NULL;
 
-	if (cfs_rq->next == se)
+	if (!se || cfs_rq->next == se)
 		cfs_rq->next = NULL;
 }
 
@@ -1062,83 +1069,6 @@ static void yield_task_fair(struct rq *rq)
 	se->vruntime = rightmost->vruntime + 1;
 }
 
-/*
- * wake_idle() will wake a task on an idle cpu if task->cpu is
- * not idle and an idle cpu is available.  The span of cpus to
- * search starts with cpus closest then further out as needed,
- * so we always favor a closer, idle cpu.
- * Domains may include CPUs that are not usable for migration,
- * hence we need to mask them out (rq->rd->online)
- *
- * Returns the CPU we should wake onto.
- */
-#if defined(ARCH_HAS_SCHED_WAKE_IDLE)
-
-#define cpu_rd_active(cpu, rq) cpumask_test_cpu(cpu, rq->rd->online)
-
-static int wake_idle(int cpu, struct task_struct *p)
-{
-	struct sched_domain *sd;
-	int i;
-	unsigned int chosen_wakeup_cpu;
-	int this_cpu;
-	struct rq *task_rq = task_rq(p);
-
-	/*
-	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
-	 * are idle and this is not a kernel thread and this task's affinity
-	 * allows it to be moved to preferred cpu, then just move!
-	 */
-
-	this_cpu = smp_processor_id();
-	chosen_wakeup_cpu =
-		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
-
-	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP &&
-		idle_cpu(cpu) && idle_cpu(this_cpu) &&
-		p->mm && !(p->flags & PF_KTHREAD) &&
-		cpu_isset(chosen_wakeup_cpu, p->cpus_allowed))
-		return chosen_wakeup_cpu;
-
-	/*
-	 * If it is idle, then it is the best cpu to run this task.
-	 *
-	 * This cpu is also the best, if it has more than one task already.
-	 * Siblings must be also busy(in most cases) as they didn't already
-	 * pickup the extra load from this cpu and hence we need not check
-	 * sibling runqueue info. This will avoid the checks and cache miss
-	 * penalities associated with that.
-	 */
-	if (idle_cpu(cpu) || cpu_rq(cpu)->cfs.nr_running > 1)
-		return cpu;
-
-	for_each_domain(cpu, sd) {
-		if ((sd->flags & SD_WAKE_IDLE)
-		    || ((sd->flags & SD_WAKE_IDLE_FAR)
-			&& !task_hot(p, task_rq->clock, sd))) {
-			for_each_cpu_and(i, sched_domain_span(sd),
-					 &p->cpus_allowed) {
-				if (cpu_rd_active(i, task_rq) && idle_cpu(i)) {
-					if (i != task_cpu(p)) {
-						schedstat_inc(p,
-						       se.nr_wakeups_idle);
-					}
-					return i;
-				}
-			}
-		} else {
-			break;
-		}
-	}
-	return cpu;
-}
-#else /* !ARCH_HAS_SCHED_WAKE_IDLE*/
-static inline int wake_idle(int cpu, struct task_struct *p)
-{
-	return cpu;
-}
-#endif
-
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1225,25 +1155,34 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 #endif
 
-static int
-wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
-	    struct task_struct *p, int prev_cpu, int this_cpu, int sync,
-	    int idx, unsigned long load, unsigned long this_load,
-	    unsigned int imbalance)
+static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
-	struct task_struct *curr = this_rq->curr;
-	struct task_group *tg;
-	unsigned long tl = this_load;
+	struct task_struct *curr = current;
+	unsigned long this_load, load;
+	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
+	unsigned int imbalance;
+	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
 
-	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
-		return 0;
+	idx	  = sd->wake_idx;
+	this_cpu  = smp_processor_id();
+	prev_cpu  = task_cpu(p);
+	load	  = source_load(prev_cpu, idx);
+	this_load = target_load(this_cpu, idx);
 
-	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
-			p->se.avg_overlap > sysctl_sched_migration_cost))
-		sync = 0;
+	if (sync) {
+	       if (sched_feat(SYNC_LESS) &&
+		   (curr->se.avg_overlap > sysctl_sched_migration_cost ||
+		    p->se.avg_overlap > sysctl_sched_migration_cost))
+		       sync = 0;
+	} else {
+		if (sched_feat(SYNC_MORE) &&
+		    (curr->se.avg_overlap < sysctl_sched_migration_cost &&
+		     p->se.avg_overlap < sysctl_sched_migration_cost))
+			sync = 1;
+	}
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
@@ -1254,24 +1193,26 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 		tg = task_group(current);
 		weight = current->se.load.weight;
 
-		tl += effective_load(tg, this_cpu, -weight, -weight);
+		this_load += effective_load(tg, this_cpu, -weight, -weight);
 		load += effective_load(tg, prev_cpu, 0, -weight);
 	}
 
 	tg = task_group(p);
 	weight = p->se.load.weight;
 
+	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
+
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
-	 * due to the sync cause above having dropped tl to 0, we'll always have
-	 * an imbalance, but there's really nothing you can do about that, so
-	 * that's good too.
+	 * due to the sync cause above having dropped this_load to 0, we'll
+	 * always have an imbalance, but there's really nothing you can do
+	 * about that, so that's good too.
 	 *
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	balanced = !tl ||
-		100*(tl + effective_load(tg, this_cpu, weight, weight)) <=
+	balanced = !this_load ||
+		100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
 		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
 
 	/*
@@ -1285,14 +1226,15 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	schedstat_inc(p, se.nr_wakeups_affine_attempts);
 	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	if (balanced || (tl <= load && tl + target_load(prev_cpu, idx) <=
-			tl_per_task)) {
+	if (balanced ||
+	    (this_load <= load &&
+	     this_load + target_load(prev_cpu, idx) <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
 		 * there is no bad imbalance.
 		 */
-		schedstat_inc(this_sd, ttwu_move_affine);
+		schedstat_inc(sd, ttwu_move_affine);
 		schedstat_inc(p, se.nr_wakeups_affine);
 
 		return 1;
@@ -1300,65 +1242,215 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	return 0;
 }
 
-static int select_task_rq_fair(struct task_struct *p, int sync)
+/*
+ * find_idlest_group finds and returns the least busy CPU group within the
+ * domain.
+ */
+static struct sched_group *
+find_idlest_group(struct sched_domain *sd, struct task_struct *p,
+		  int this_cpu, int load_idx)
 {
-	struct sched_domain *sd, *this_sd = NULL;
-	int prev_cpu, this_cpu, new_cpu;
-	unsigned long load, this_load;
-	struct rq *this_rq;
-	unsigned int imbalance;
-	int idx;
+	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
+	unsigned long min_load = ULONG_MAX, this_load = 0;
+	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
-	prev_cpu	= task_cpu(p);
-	this_cpu	= smp_processor_id();
-	this_rq		= cpu_rq(this_cpu);
-	new_cpu		= prev_cpu;
+	do {
+		unsigned long load, avg_load;
+		int local_group;
+		int i;
 
-	/*
-	 * 'this_sd' is the first domain that both
-	 * this_cpu and prev_cpu are present in:
-	 */
-	for_each_domain(this_cpu, sd) {
-		if (cpumask_test_cpu(prev_cpu, sched_domain_span(sd))) {
-			this_sd = sd;
-			break;
+		/* Skip over this group if it has no CPUs allowed */
+		if (!cpumask_intersects(sched_group_cpus(group),
+					&p->cpus_allowed))
+			continue;
+
+		local_group = cpumask_test_cpu(this_cpu,
+					       sched_group_cpus(group));
+
+		/* Tally up the load of all CPUs in the group */
+		avg_load = 0;
+
+		for_each_cpu(i, sched_group_cpus(group)) {
+			/* Bias balancing toward cpus of our domain */
+			if (local_group)
+				load = source_load(i, load_idx);
+			else
+				load = target_load(i, load_idx);
+
+			avg_load += load;
+		}
+
+		/* Adjust by relative CPU power of the group */
+		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
+
+		if (local_group) {
+			this_load = avg_load;
+			this = group;
+		} else if (avg_load < min_load) {
+			min_load = avg_load;
+			idlest = group;
+		}
+	} while (group = group->next, group != sd->groups);
+
+	if (!idlest || 100*this_load < imbalance*min_load)
+		return NULL;
+	return idlest;
+}
+
+/*
+ * find_idlest_cpu - find the idlest cpu among the cpus in group.
+ */
+static int
+find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
+{
+	unsigned long load, min_load = ULONG_MAX;
+	int idlest = -1;
+	int i;
+
+	/* Traverse only the allowed CPUs */
+	for_each_cpu_and(i, sched_group_cpus(group), &p->cpus_allowed) {
+		load = weighted_cpuload(i);
+
+		if (load < min_load || (load == min_load && i == this_cpu)) {
+			min_load = load;
+			idlest = i;
 		}
 	}
 
-	if (unlikely(!cpumask_test_cpu(this_cpu, &p->cpus_allowed)))
-		goto out;
+	return idlest;
+}
 
-	/*
-	 * Check for affine wakeup and passive balancing possibilities.
-	 */
-	if (!this_sd)
+/*
+ * sched_balance_self: balance the current task (running on cpu) in domains
+ * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
+ * SD_BALANCE_EXEC.
+ *
+ * Balance, ie. select the least loaded group.
+ *
+ * Returns the target CPU number, or the same CPU if no balancing is needed.
+ *
+ * preempt must be disabled.
+ */
+static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
+{
+	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
+	int cpu = smp_processor_id();
+	int prev_cpu = task_cpu(p);
+	int new_cpu = cpu;
+	int want_affine = 0;
+	int want_sd = 1;
+	int sync = wake_flags & WF_SYNC;
+
+	if (sd_flag & SD_BALANCE_WAKE) {
+		if (sched_feat(AFFINE_WAKEUPS))
+			want_affine = 1;
+		new_cpu = prev_cpu;
+	}
+
+	rcu_read_lock();
+	for_each_domain(cpu, tmp) {
+		/*
+		 * If power savings logic is enabled for a domain, see if we
+		 * are not overloaded, if so, don't balance wider.
+		 */
+		if (tmp->flags & (SD_POWERSAVINGS_BALANCE|SD_PREFER_LOCAL)) {
+			unsigned long power = 0;
+			unsigned long nr_running = 0;
+			unsigned long capacity;
+			int i;
+
+			for_each_cpu(i, sched_domain_span(tmp)) {
+				power += power_of(i);
+				nr_running += cpu_rq(i)->cfs.nr_running;
+			}
+
+			capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+
+			if (tmp->flags & SD_POWERSAVINGS_BALANCE)
+				nr_running /= 2;
+
+			if (nr_running < capacity)
+				want_sd = 0;
+		}
+
+		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
+		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
+
+			affine_sd = tmp;
+			want_affine = 0;
+		}
+
+		if (!want_sd && !want_affine)
+			break;
+
+		if (!(tmp->flags & sd_flag))
+			continue;
+
+		if (want_sd)
+			sd = tmp;
+	}
+
+	if (sched_feat(LB_SHARES_UPDATE)) {
+		/*
+		 * Pick the largest domain to update shares over
+		 */
+		tmp = sd;
+		if (affine_sd && (!tmp ||
+				  cpumask_weight(sched_domain_span(affine_sd)) >
+				  cpumask_weight(sched_domain_span(sd))))
+			tmp = affine_sd;
+
+		if (tmp)
+			update_shares(tmp);
+	}
+
+	if (affine_sd && wake_affine(affine_sd, p, sync)) {
+		new_cpu = cpu;
 		goto out;
+	}
 
-	idx = this_sd->wake_idx;
+	while (sd) {
+		int load_idx = sd->forkexec_idx;
+		struct sched_group *group;
+		int weight;
 
-	imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;
+		if (!(sd->flags & sd_flag)) {
+			sd = sd->child;
+			continue;
+		}
 
-	load = source_load(prev_cpu, idx);
-	this_load = target_load(this_cpu, idx);
+		if (sd_flag & SD_BALANCE_WAKE)
+			load_idx = sd->wake_idx;
 
-	if (wake_affine(this_sd, this_rq, p, prev_cpu, this_cpu, sync, idx,
-				     load, this_load, imbalance))
-		return this_cpu;
+		group = find_idlest_group(sd, p, cpu, load_idx);
+		if (!group) {
+			sd = sd->child;
+			continue;
+		}
 
-	/*
-	 * Start passive balancing when half the imbalance_pct
-	 * limit is reached.
-	 */
-	if (this_sd->flags & SD_WAKE_BALANCE) {
-		if (imbalance*this_load <= 100*load) {
-			schedstat_inc(this_sd, ttwu_move_balance);
-			schedstat_inc(p, se.nr_wakeups_passive);
-			return this_cpu;
+		new_cpu = find_idlest_cpu(group, p, cpu);
+		if (new_cpu == -1 || new_cpu == cpu) {
+			/* Now try balancing at a lower domain level of cpu */
+			sd = sd->child;
+			continue;
 		}
+
+		/* Now try balancing at a lower domain level of new_cpu */
+		cpu = new_cpu;
+		weight = cpumask_weight(sched_domain_span(sd));
+		sd = NULL;
+		for_each_domain(cpu, tmp) {
+			if (weight <= cpumask_weight(sched_domain_span(tmp)))
+				break;
+			if (tmp->flags & sd_flag)
+				sd = tmp;
+		}
+		/* while loop will break here if sd == NULL */
 	}
 
 out:
-	return wake_idle(new_cpu, p);
+	rcu_read_unlock();
+	return new_cpu;
 }
 #endif /* CONFIG_SMP */
 
@@ -1471,11 +1563,12 @@ static void set_next_buddy(struct sched_entity *se)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
+static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+	int sync = wake_flags & WF_SYNC;
 
 	update_curr(cfs_rq);
 
@@ -1501,7 +1594,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 	 */
 	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
 		set_last_buddy(se);
-	set_next_buddy(pse);
+	if (sched_feat(NEXT_BUDDY) && !(wake_flags & WF_FORK))
+		set_next_buddy(pse);
 
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
@@ -1523,16 +1617,25 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 		return;
 	}
 
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
-	if (sched_feat(WAKEUP_OVERLAP) && (sync ||
-			(se->avg_overlap < sysctl_sched_migration_cost &&
-			 pse->avg_overlap < sysctl_sched_migration_cost))) {
+	if ((sched_feat(WAKEUP_SYNC) && sync) ||
+	    (sched_feat(WAKEUP_OVERLAP) &&
+	     (se->avg_overlap < sysctl_sched_migration_cost &&
+	      pse->avg_overlap < sysctl_sched_migration_cost))) {
 		resched_task(curr);
 		return;
 	}
 
+	if (sched_feat(WAKEUP_RUNNING)) {
+		if (pse->avg_running < se->avg_running) {
+			set_next_buddy(pse);
+			resched_task(curr);
+			return;
+		}
+	}
+
+	if (!sched_feat(WAKEUP_PREEMPT))
+		return;
+
 	find_matching_se(&se, &pse);
 
 	BUG_ON(!pse);
@@ -1555,8 +1658,13 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 		/*
 		 * If se was a buddy, clear it so that it will have to earn
 		 * the favour again.
+		 *
+		 * If se was not a buddy, clear the buddies because neither
+		 * was elegible to run, let them earn it again.
+		 *
+		 * IOW. unconditionally clear buddies.
 		 */
-		__clear_buddies(cfs_rq, se);
+		__clear_buddies(cfs_rq, NULL);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index e2dc63a..0d94083 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -1,17 +1,123 @@
-SCHED_FEAT(NEW_FAIR_SLEEPERS, 0)
+/*
+ * Disregards a certain amount of sleep time (sched_latency_ns) and
+ * considers the task to be running during that period. This gives it
+ * a service deficit on wakeup, allowing it to run sooner.
+ */
+SCHED_FEAT(FAIR_SLEEPERS, 1)
+
+/*
+ * Only give sleepers 50% of their service deficit. This allows
+ * them to run sooner, but does not allow tons of sleepers to
+ * rip the spread apart.
+ */
+SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
+
+/*
+ * By not normalizing the sleep time, heavy tasks get an effective
+ * longer period, and lighter task an effective shorter period they
+ * are considered running.
+ */
 SCHED_FEAT(NORMALIZED_SLEEPER, 0)
-SCHED_FEAT(ADAPTIVE_GRAN, 1)
-SCHED_FEAT(WAKEUP_PREEMPT, 1)
+
+/*
+ * Place new tasks ahead so that they do not starve already running
+ * tasks
+ */
 SCHED_FEAT(START_DEBIT, 1)
+
+/*
+ * Should wakeups try to preempt running tasks.
+ */
+SCHED_FEAT(WAKEUP_PREEMPT, 1)
+
+/*
+ * Compute wakeup_gran based on task behaviour, clipped to
+ *  [0, sched_wakeup_gran_ns]
+ */
+SCHED_FEAT(ADAPTIVE_GRAN, 1)
+
+/*
+ * When converting the wakeup granularity to virtual time, do it such
+ * that heavier tasks preempting a lighter task have an edge.
+ */
+SCHED_FEAT(ASYM_GRAN, 1)
+
+/*
+ * Always wakeup-preempt SYNC wakeups, see SYNC_WAKEUPS.
+ */
+SCHED_FEAT(WAKEUP_SYNC, 0)
+
+/*
+ * Wakeup preempt based on task behaviour. Tasks that do not overlap
+ * don't get preempted.
+ */
+SCHED_FEAT(WAKEUP_OVERLAP, 0)
+
+/*
+ * Wakeup preemption towards tasks that run short
+ */
+SCHED_FEAT(WAKEUP_RUNNING, 0)
+
+/*
+ * Use the SYNC wakeup hint, pipes and the likes use this to indicate
+ * the remote end is likely to consume the data we just wrote, and
+ * therefore has cache benefit from being placed on the same cpu, see
+ * also AFFINE_WAKEUPS.
+ */
+SCHED_FEAT(SYNC_WAKEUPS, 1)
+
+/*
+ * Based on load and program behaviour, see if it makes sense to place
+ * a newly woken task on the same cpu as the task that woke it --
+ * improve cache locality. Typically used with SYNC wakeups as
+ * generated by pipes and the like, see also SYNC_WAKEUPS.
+ */
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
+
+/*
+ * Weaken SYNC hint based on overlap
+ */
+SCHED_FEAT(SYNC_LESS, 1)
+
+/*
+ * Add SYNC hint based on overlap
+ */
+SCHED_FEAT(SYNC_MORE, 0)
+
+/*
+ * Prefer to schedule the task we woke last (assuming it failed
+ * wakeup-preemption), since its likely going to consume data we
+ * touched, increases cache locality.
+ */
+SCHED_FEAT(NEXT_BUDDY, 0)
+
+/*
+ * Prefer to schedule the task that ran last (when we did
+ * wake-preempt) as that likely will touch the same data, increases
+ * cache locality.
+ */
+SCHED_FEAT(LAST_BUDDY, 1)
+
+/*
+ * Consider buddies to be cache hot, decreases the likelyness of a
+ * cache buddy being migrated away, increases cache locality.
+ */
 SCHED_FEAT(CACHE_HOT_BUDDY, 1)
-SCHED_FEAT(SYNC_WAKEUPS, 1)
+
+/*
+ * Use arch dependent cpu power functions
+ */
+SCHED_FEAT(ARCH_POWER, 0)
+
 SCHED_FEAT(HRTICK, 0)
 SCHED_FEAT(DOUBLE_TICK, 0)
-SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(LB_BIAS, 1)
-SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
+SCHED_FEAT(LB_SHARES_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
-SCHED_FEAT(WAKEUP_OVERLAP, 0)
-SCHED_FEAT(LAST_BUDDY, 1)
+
+/*
+ * Spin-wait on mutex acquisition when the mutex owner is running on
+ * another cpu -- assumes that when the owner is running, it will soon
+ * release the lock. Decreases scheduling overhead.
+ */
 SCHED_FEAT(OWNER_SPIN, 1)
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 499672c..a8b448a 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -6,7 +6,7 @@
  */
 
 #ifdef CONFIG_SMP
-static int select_task_rq_idle(struct task_struct *p, int sync)
+static int select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
@@ -14,7 +14,7 @@ static int select_task_rq_idle(struct task_struct *p, int sync)
 /*
  * Idle tasks are unconditionally rescheduled:
  */
-static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int sync)
+static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int flags)
 {
 	resched_task(rq->idle);
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 2eb4bd6..13de712 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -938,10 +938,13 @@ static void yield_task_rt(struct rq *rq)
 #ifdef CONFIG_SMP
 static int find_lowest_rq(struct task_struct *task);
 
-static int select_task_rq_rt(struct task_struct *p, int sync)
+static int select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 {
 	struct rq *rq = task_rq(p);
 
+	if (sd_flag != SD_BALANCE_WAKE)
+		return smp_processor_id();
+
 	/*
 	 * If the current task is an RT task, then
 	 * try to see if we can wake this RT task up on another
@@ -999,7 +1002,7 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int sync)
+static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (p->prio < rq->curr->prio) {
 		resched_task(rq->curr);
