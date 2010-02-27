Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968376Ab0B0Nyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:54:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968349Ab0B0Nyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:54:50 -0500
Date: Sat, 27 Feb 2010 14:54:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] OProfile changes for v2.6.34
Message-ID: <20100227135435.GA8417@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest oprofile-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git oprofile-for-linus

 Thanks,

	Ingo

------------------>
Naga Chumbalkar (1):
      oprofile/x86: add comment to counter-in-use warning

Robert Richter (10):
      oprofile: remove tracing build dependency
      oprofile: remove EXPERIMENTAL from the config option description
      oprofile/x86: remove OPROFILE_IBS config option
      oprofile/x86: remove node check in AMD IBS initialization
      oprofile/x86: implement IBS cpuid feature detection
      oprofile/x86: implement randomization for IBS periodic op counter
      oprofile/x86: warn user if a counter is already active
      oprofile/x86: fix perfctr nmi reservation for mulitplexing
      oprofile/x86: use kzalloc() instead of kmalloc()
      oprofile/x86: fix msr access to reserved counters

Suravee Suthikulpanit (1):
      oprofile/x86: implement lsfr pseudo-random number generator for IBS


 arch/Kconfig                      |   18 +---
 arch/x86/oprofile/nmi_int.c       |   17 ++--
 arch/x86/oprofile/op_model_amd.c  |  244 ++++++++++++++++++++++++-------------
 arch/x86/oprofile/op_model_p4.c   |    6 -
 arch/x86/oprofile/op_model_ppro.c |   17 ++-
 arch/x86/oprofile/op_x86_model.h  |   20 +++
 init/Kconfig                      |    2 +-
 7 files changed, 200 insertions(+), 124 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 9d055b4..06a1372 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -3,11 +3,9 @@
 #
 
 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	depends on HAVE_OPROFILE
-	depends on TRACING_SUPPORT
-	select TRACING
 	select RING_BUFFER
 	select RING_BUFFER_ALLOW_SWAP
 	help
@@ -17,20 +15,6 @@ config OPROFILE
 
 	  If unsure, say N.
 
-config OPROFILE_IBS
-	bool "OProfile AMD IBS support (EXPERIMENTAL)"
-	default n
-	depends on OPROFILE && SMP && X86
-	help
-          Instruction-Based Sampling (IBS) is a new profiling
-          technique that provides rich, precise program performance
-          information. IBS is introduced by AMD Family10h processors
-          (AMD Opteron Quad-Core processor "Barcelona") to overcome
-          the limitations of conventional performance counter
-          sampling.
-
-	  If unsure, say N.
-
 config OPROFILE_EVENT_MULTIPLEX
 	bool "OProfile multiplexing support (EXPERIMENTAL)"
 	default n
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 3347f69..2c505ee 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -159,7 +159,7 @@ static int nmi_setup_mux(void)
 
 	for_each_possible_cpu(i) {
 		per_cpu(cpu_msrs, i).multiplex =
-			kmalloc(multiplex_size, GFP_KERNEL);
+			kzalloc(multiplex_size, GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).multiplex)
 			return 0;
 	}
@@ -179,7 +179,6 @@ static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
 		if (counter_config[i].enabled) {
 			multiplex[i].saved = -(u64)counter_config[i].count;
 		} else {
-			multiplex[i].addr  = 0;
 			multiplex[i].saved = 0;
 		}
 	}
@@ -189,25 +188,27 @@ static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
 
 static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs)
 {
+	struct op_msr *counters = msrs->counters;
 	struct op_msr *multiplex = msrs->multiplex;
 	int i;
 
 	for (i = 0; i < model->num_counters; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (multiplex[virt].addr)
-			rdmsrl(multiplex[virt].addr, multiplex[virt].saved);
+		if (counters[i].addr)
+			rdmsrl(counters[i].addr, multiplex[virt].saved);
 	}
 }
 
 static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
 {
+	struct op_msr *counters = msrs->counters;
 	struct op_msr *multiplex = msrs->multiplex;
 	int i;
 
 	for (i = 0; i < model->num_counters; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (multiplex[virt].addr)
-			wrmsrl(multiplex[virt].addr, multiplex[virt].saved);
+		if (counters[i].addr)
+			wrmsrl(counters[i].addr, multiplex[virt].saved);
 	}
 }
 
@@ -303,11 +304,11 @@ static int allocate_msrs(void)
 
 	int i;
 	for_each_possible_cpu(i) {
-		per_cpu(cpu_msrs, i).counters = kmalloc(counters_size,
+		per_cpu(cpu_msrs, i).counters = kzalloc(counters_size,
 							GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).counters)
 			return 0;
-		per_cpu(cpu_msrs, i).controls = kmalloc(controls_size,
+		per_cpu(cpu_msrs, i).controls = kzalloc(controls_size,
 							GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).controls)
 			return 0;
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 39686c2..6a58256 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -22,6 +22,9 @@
 #include <asm/ptrace.h>
 #include <asm/msr.h>
 #include <asm/nmi.h>
+#include <asm/apic.h>
+#include <asm/processor.h>
+#include <asm/cpufeature.h>
 
 #include "op_x86_model.h"
 #include "op_counter.h"
@@ -43,15 +46,13 @@
 
 static unsigned long reset_value[NUM_VIRT_COUNTERS];
 
-#ifdef CONFIG_OPROFILE_IBS
-
 /* IbsFetchCtl bits/masks */
 #define IBS_FETCH_RAND_EN		(1ULL<<57)
 #define IBS_FETCH_VAL			(1ULL<<49)
 #define IBS_FETCH_ENABLE		(1ULL<<48)
 #define IBS_FETCH_CNT_MASK		0xFFFF0000ULL
 
-/*IbsOpCtl bits */
+/* IbsOpCtl bits */
 #define IBS_OP_CNT_CTL			(1ULL<<19)
 #define IBS_OP_VAL			(1ULL<<18)
 #define IBS_OP_ENABLE			(1ULL<<17)
@@ -59,7 +60,7 @@ static unsigned long reset_value[NUM_VIRT_COUNTERS];
 #define IBS_FETCH_SIZE			6
 #define IBS_OP_SIZE			12
 
-static int has_ibs;	/* AMD Family10h and later */
+static u32 ibs_caps;
 
 struct op_ibs_config {
 	unsigned long op_enabled;
@@ -71,24 +72,52 @@ struct op_ibs_config {
 };
 
 static struct op_ibs_config ibs_config;
+static u64 ibs_op_ctl;
 
-#endif
+/*
+ * IBS cpuid feature detection
+ */
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+#define IBS_CPUID_FEATURES      0x8000001b
+
+/*
+ * Same bit mask as for IBS cpuid feature flags (Fn8000_001B_EAX), but
+ * bit 0 is used to indicate the existence of IBS.
+ */
+#define IBS_CAPS_AVAIL			(1LL<<0)
+#define IBS_CAPS_RDWROPCNT		(1LL<<3)
+#define IBS_CAPS_OPCNT			(1LL<<4)
+
+/*
+ * IBS randomization macros
+ */
+#define IBS_RANDOM_BITS			12
+#define IBS_RANDOM_MASK			((1ULL << IBS_RANDOM_BITS) - 1)
+#define IBS_RANDOM_MAXCNT_OFFSET	(1ULL << (IBS_RANDOM_BITS - 5))
 
-static void op_mux_fill_in_addresses(struct op_msrs * const msrs)
+static u32 get_ibs_caps(void)
 {
-	int i;
+	u32 ibs_caps;
+	unsigned int max_level;
 
-	for (i = 0; i < NUM_VIRT_COUNTERS; i++) {
-		int hw_counter = op_x86_virt_to_phys(i);
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			msrs->multiplex[i].addr = MSR_K7_PERFCTR0 + hw_counter;
-		else
-			msrs->multiplex[i].addr = 0;
-	}
+	if (!boot_cpu_has(X86_FEATURE_IBS))
+		return 0;
+
+	/* check IBS cpuid feature flags */
+	max_level = cpuid_eax(0x80000000);
+	if (max_level < IBS_CPUID_FEATURES)
+		return IBS_CAPS_AVAIL;
+
+	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (!(ibs_caps & IBS_CAPS_AVAIL))
+		/* cpuid flags not valid */
+		return IBS_CAPS_AVAIL;
+
+	return ibs_caps;
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
 static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
 			       struct op_msrs const * const msrs)
 {
@@ -98,7 +127,7 @@ static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (!counter_config[virt].enabled)
+		if (!reset_value[virt])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
 		val &= model->reserved;
@@ -107,10 +136,6 @@ static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
 	}
 }
 
-#else
-
-static inline void op_mux_fill_in_addresses(struct op_msrs * const msrs) { }
-
 #endif
 
 /* functions for op_amd_spec */
@@ -122,18 +147,12 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 	for (i = 0; i < NUM_COUNTERS; i++) {
 		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
 			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-		else
-			msrs->counters[i].addr = 0;
 	}
 
 	for (i = 0; i < NUM_CONTROLS; i++) {
 		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
-		else
-			msrs->controls[i].addr = 0;
 	}
-
-	op_mux_fill_in_addresses(msrs);
 }
 
 static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
@@ -144,7 +163,8 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* setup reset_value */
 	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
-		if (counter_config[i].enabled)
+		if (counter_config[i].enabled
+		    && msrs->counters[op_x86_virt_to_phys(i)].addr)
 			reset_value[i] = counter_config[i].count;
 		else
 			reset_value[i] = 0;
@@ -152,9 +172,18 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear all counters */
 	for (i = 0; i < NUM_CONTROLS; ++i) {
-		if (unlikely(!msrs->controls[i].addr))
+		if (unlikely(!msrs->controls[i].addr)) {
+			if (counter_config[i].enabled && !smp_processor_id())
+				/*
+				 * counter is reserved, this is on all
+				 * cpus, so report only for cpu #0
+				 */
+				op_x86_warn_reserved(i);
 			continue;
+		}
 		rdmsrl(msrs->controls[i].addr, val);
+		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
@@ -169,9 +198,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (!counter_config[virt].enabled)
-			continue;
-		if (!msrs->counters[i].addr)
+		if (!reset_value[virt])
 			continue;
 
 		/* setup counter registers */
@@ -185,7 +212,60 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 }
 
-#ifdef CONFIG_OPROFILE_IBS
+/*
+ * 16-bit Linear Feedback Shift Register (LFSR)
+ *
+ *                       16   14   13    11
+ * Feedback polynomial = X  + X  + X  +  X  + 1
+ */
+static unsigned int lfsr_random(void)
+{
+	static unsigned int lfsr_value = 0xF00D;
+	unsigned int bit;
+
+	/* Compute next bit to shift in */
+	bit = ((lfsr_value >> 0) ^
+	       (lfsr_value >> 2) ^
+	       (lfsr_value >> 3) ^
+	       (lfsr_value >> 5)) & 0x0001;
+
+	/* Advance to next register value */
+	lfsr_value = (lfsr_value >> 1) | (bit << 15);
+
+	return lfsr_value;
+}
+
+/*
+ * IBS software randomization
+ *
+ * The IBS periodic op counter is randomized in software. The lower 12
+ * bits of the 20 bit counter are randomized. IbsOpCurCnt is
+ * initialized with a 12 bit random value.
+ */
+static inline u64 op_amd_randomize_ibs_op(u64 val)
+{
+	unsigned int random = lfsr_random();
+
+	if (!(ibs_caps & IBS_CAPS_RDWROPCNT))
+		/*
+		 * Work around if the hw can not write to IbsOpCurCnt
+		 *
+		 * Randomize the lower 8 bits of the 16 bit
+		 * IbsOpMaxCnt [15:0] value in the range of -128 to
+		 * +127 by adding/subtracting an offset to the
+		 * maximum count (IbsOpMaxCnt).
+		 *
+		 * To avoid over or underflows and protect upper bits
+		 * starting at bit 16, the initial value for
+		 * IbsOpMaxCnt must fit in the range from 0x0081 to
+		 * 0xff80.
+		 */
+		val += (s8)(random >> 4);
+	else
+		val |= (u64)(random & IBS_RANDOM_MASK) << 32;
+
+	return val;
+}
 
 static inline void
 op_amd_handle_ibs(struct pt_regs * const regs,
@@ -194,7 +274,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 	u64 val, ctl;
 	struct op_entry entry;
 
-	if (!has_ibs)
+	if (!ibs_caps)
 		return;
 
 	if (ibs_config.fetch_enabled) {
@@ -236,8 +316,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
-			ctl &= ~IBS_OP_VAL & 0xFFFFFFFF;
-			ctl |= IBS_OP_ENABLE;
+			ctl = op_amd_randomize_ibs_op(ibs_op_ctl);
 			wrmsrl(MSR_AMD64_IBSOPCTL, ctl);
 		}
 	}
@@ -246,41 +325,57 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 static inline void op_amd_start_ibs(void)
 {
 	u64 val;
-	if (has_ibs && ibs_config.fetch_enabled) {
+
+	if (!ibs_caps)
+		return;
+
+	if (ibs_config.fetch_enabled) {
 		val = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
 		val |= ibs_config.rand_en ? IBS_FETCH_RAND_EN : 0;
 		val |= IBS_FETCH_ENABLE;
 		wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
 	}
 
-	if (has_ibs && ibs_config.op_enabled) {
-		val = (ibs_config.max_cnt_op >> 4) & 0xFFFF;
-		val |= ibs_config.dispatched_ops ? IBS_OP_CNT_CTL : 0;
-		val |= IBS_OP_ENABLE;
+	if (ibs_config.op_enabled) {
+		ibs_op_ctl = ibs_config.max_cnt_op >> 4;
+		if (!(ibs_caps & IBS_CAPS_RDWROPCNT)) {
+			/*
+			 * IbsOpCurCnt not supported.  See
+			 * op_amd_randomize_ibs_op() for details.
+			 */
+			ibs_op_ctl = clamp(ibs_op_ctl, 0x0081ULL, 0xFF80ULL);
+		} else {
+			/*
+			 * The start value is randomized with a
+			 * positive offset, we need to compensate it
+			 * with the half of the randomized range. Also
+			 * avoid underflows.
+			 */
+			ibs_op_ctl = min(ibs_op_ctl + IBS_RANDOM_MAXCNT_OFFSET,
+					 0xFFFFULL);
+		}
+		if (ibs_caps & IBS_CAPS_OPCNT && ibs_config.dispatched_ops)
+			ibs_op_ctl |= IBS_OP_CNT_CTL;
+		ibs_op_ctl |= IBS_OP_ENABLE;
+		val = op_amd_randomize_ibs_op(ibs_op_ctl);
 		wrmsrl(MSR_AMD64_IBSOPCTL, val);
 	}
 }
 
 static void op_amd_stop_ibs(void)
 {
-	if (has_ibs && ibs_config.fetch_enabled)
+	if (!ibs_caps)
+		return;
+
+	if (ibs_config.fetch_enabled)
 		/* clear max count and enable */
 		wrmsrl(MSR_AMD64_IBSFETCHCTL, 0);
 
-	if (has_ibs && ibs_config.op_enabled)
+	if (ibs_config.op_enabled)
 		/* clear max count and enable */
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
-#else
-
-static inline void op_amd_handle_ibs(struct pt_regs * const regs,
-				    struct op_msrs const * const msrs) { }
-static inline void op_amd_start_ibs(void) { }
-static inline void op_amd_stop_ibs(void) { }
-
-#endif
-
 static int op_amd_check_ctrs(struct pt_regs * const regs,
 			     struct op_msrs const * const msrs)
 {
@@ -355,8 +450,6 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
-#ifdef CONFIG_OPROFILE_IBS
-
 static u8 ibs_eilvt_off;
 
 static inline void apic_init_ibs_nmi_per_cpu(void *arg)
@@ -405,45 +498,36 @@ static int init_ibs_nmi(void)
 		return 1;
 	}
 
-#ifdef CONFIG_NUMA
-	/* Sanity check */
-	/* Works only for 64bit with proper numa implementation. */
-	if (nodes != num_possible_nodes()) {
-		printk(KERN_DEBUG "Failed to setup CPU node(s) for IBS, "
-			"found: %d, expected %d",
-			nodes, num_possible_nodes());
-		return 1;
-	}
-#endif
 	return 0;
 }
 
 /* uninitialize the APIC for the IBS interrupts if needed */
 static void clear_ibs_nmi(void)
 {
-	if (has_ibs)
+	if (ibs_caps)
 		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
 }
 
 /* initialize the APIC for the IBS interrupts if available */
 static void ibs_init(void)
 {
-	has_ibs = boot_cpu_has(X86_FEATURE_IBS);
+	ibs_caps = get_ibs_caps();
 
-	if (!has_ibs)
+	if (!ibs_caps)
 		return;
 
 	if (init_ibs_nmi()) {
-		has_ibs = 0;
+		ibs_caps = 0;
 		return;
 	}
 
-	printk(KERN_INFO "oprofile: AMD IBS detected\n");
+	printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n",
+	       (unsigned)ibs_caps);
 }
 
 static void ibs_exit(void)
 {
-	if (!has_ibs)
+	if (!ibs_caps)
 		return;
 
 	clear_ibs_nmi();
@@ -463,7 +547,7 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 	if (ret)
 		return ret;
 
-	if (!has_ibs)
+	if (!ibs_caps)
 		return ret;
 
 	/* model specific files */
@@ -473,7 +557,7 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 	ibs_config.fetch_enabled = 0;
 	ibs_config.max_cnt_op = 250000;
 	ibs_config.op_enabled = 0;
-	ibs_config.dispatched_ops = 1;
+	ibs_config.dispatched_ops = 0;
 
 	dir = oprofilefs_mkdir(sb, root, "ibs_fetch");
 	oprofilefs_create_ulong(sb, dir, "enable",
@@ -488,8 +572,9 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 				&ibs_config.op_enabled);
 	oprofilefs_create_ulong(sb, dir, "max_count",
 				&ibs_config.max_cnt_op);
-	oprofilefs_create_ulong(sb, dir, "dispatched_ops",
-				&ibs_config.dispatched_ops);
+	if (ibs_caps & IBS_CAPS_OPCNT)
+		oprofilefs_create_ulong(sb, dir, "dispatched_ops",
+					&ibs_config.dispatched_ops);
 
 	return 0;
 }
@@ -507,19 +592,6 @@ static void op_amd_exit(void)
 	ibs_exit();
 }
 
-#else
-
-/* no IBS support */
-
-static int op_amd_init(struct oprofile_operations *ops)
-{
-	return 0;
-}
-
-static void op_amd_exit(void) {}
-
-#endif /* CONFIG_OPROFILE_IBS */
-
 struct op_x86_model_spec op_amd_spec = {
 	.num_counters		= NUM_COUNTERS,
 	.num_controls		= NUM_CONTROLS,
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index ac6b354..e6a160a 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -394,12 +394,6 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 	setup_num_counters();
 	stag = get_stagger();
 
-	/* initialize some registers */
-	for (i = 0; i < num_counters; ++i)
-		msrs->counters[i].addr = 0;
-	for (i = 0; i < num_controls; ++i)
-		msrs->controls[i].addr = 0;
-
 	/* the counter & cccr registers we pay attention to */
 	for (i = 0; i < num_counters; ++i) {
 		addr = p4_counters[VIRT_CTR(stag, i)].counter_address;
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 8eb0587..5d1727b 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -37,15 +37,11 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 	for (i = 0; i < num_counters; i++) {
 		if (reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
 			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
-		else
-			msrs->counters[i].addr = 0;
 	}
 
 	for (i = 0; i < num_counters; i++) {
 		if (reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
-		else
-			msrs->controls[i].addr = 0;
 	}
 }
 
@@ -57,7 +53,7 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 	int i;
 
 	if (!reset_value) {
-		reset_value = kmalloc(sizeof(reset_value[0]) * num_counters,
+		reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
 					GFP_ATOMIC);
 		if (!reset_value)
 			return;
@@ -82,9 +78,18 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear all counters */
 	for (i = 0; i < num_counters; ++i) {
-		if (unlikely(!msrs->controls[i].addr))
+		if (unlikely(!msrs->controls[i].addr)) {
+			if (counter_config[i].enabled && !smp_processor_id())
+				/*
+				 * counter is reserved, this is on all
+				 * cpus, so report only for cpu #0
+				 */
+				op_x86_warn_reserved(i);
 			continue;
+		}
 		rdmsrl(msrs->controls[i].addr, val);
+		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 7b8e75d..ff82a75 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -57,6 +57,26 @@ struct op_x86_model_spec {
 
 struct op_counter_config;
 
+static inline void op_x86_warn_in_use(int counter)
+{
+	/*
+	 * The warning indicates an already running counter. If
+	 * oprofile doesn't collect data, then try using a different
+	 * performance counter on your platform to monitor the desired
+	 * event. Delete counter #%d from the desired event by editing
+	 * the /usr/share/oprofile/%s/<cpu>/events file. If the event
+	 * cannot be monitored by any other counter, contact your
+	 * hardware or BIOS vendor.
+	 */
+	pr_warning("oprofile: counter #%d on cpu #%d may already be used\n",
+		   counter, smp_processor_id());
+}
+
+static inline void op_x86_warn_reserved(int counter)
+{
+	pr_warning("oprofile: counter #%d is already reserved\n", counter);
+}
+
 extern u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 			   struct op_counter_config *counter_config);
 extern int op_x86_phys_to_virt(int phys);
diff --git a/init/Kconfig b/init/Kconfig
index d95ca7c..b7c5839 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1112,7 +1112,7 @@ config MMAP_ALLOW_UNINITIALIZED
 	  See Documentation/nommu-mmap.txt for more information.
 
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.
