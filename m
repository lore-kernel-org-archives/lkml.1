Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbYLBAUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbYLBAUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 19:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYLBATe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 19:19:34 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:52324 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbYLBATb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 19:19:31 -0500
Subject: [Patch 2/3]  Kernel patch, IBM CELL processor OProfile cleanup and
	restructuring
From: Carl Love <cel@us.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 16:18:34 -0800
Message-Id: <1228177114.6509.287.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch restructures and cleans up the code a bit to make it 
easier to add new functionality later.  The patch makes no 
functional changes to the existing code.

Signed-off-by: Carl Love <carll@us.ibm.com>


Index: Cell_kernel_11_10_2008/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- Cell_kernel_11_10_2008.orig/arch/powerpc/oprofile/op_model_cell.c
+++ Cell_kernel_11_10_2008/arch/powerpc/oprofile/op_model_cell.c
@@ -40,14 +40,9 @@
 #include "../platforms/cell/interrupt.h"
 #include "cell/pr_util.h"
 
-static void cell_global_stop_spu(void);
-
-/*
- * spu_cycle_reset is the number of cycles between samples.
- * This variable is used for SPU profiling and should ONLY be set
- * at the beginning of cell_reg_setup; otherwise, it's read-only.
- */
-static unsigned int spu_cycle_reset;
+#define PPU_PROFILING            0
+#define SPU_PROFILING_CYCLES     1
+#define SPU_PROFILING_EVENTS     2
 
 #define NUM_SPUS_PER_NODE    8
 #define SPU_CYCLES_EVENT_NUM 2	/*  event number for SPU_CYCLES */
@@ -66,6 +61,14 @@ static unsigned int spu_cycle_reset;
 
 #define MAX_SPU_COUNT 0xFFFFFF	/* maximum 24 bit LFSR value */
 
+/*
+ * spu_cycle_reset is the number of cycles between samples.
+ * This variable is used for SPU profiling and should ONLY be set
+ * at the beginning of cell_reg_setup; otherwise, it's read-only.
+ */
+static unsigned int spu_cycle_reset;
+static unsigned int profiling_mode;
+
 struct pmc_cntrl_data {
 	unsigned long vcntr;
 	unsigned long evnts;
@@ -122,7 +125,6 @@ static struct {
 #define GET_INPUT_CONTROL(x) ((x & 0x00000004) >> 2)
 
 static DEFINE_PER_CPU(unsigned long[NR_PHYS_CTRS], pmc_values);
-
 static struct pmc_cntrl_data pmc_cntrl[NUM_THREADS][NR_PHYS_CTRS];
 
 /*
@@ -165,7 +167,7 @@ static int spu_rtas_token;   /* token fo
 static u32 reset_value[NR_PHYS_CTRS];
 static int num_counters;
 static int oprofile_running;
-static DEFINE_SPINLOCK(virt_cntr_lock);
+static DEFINE_SPINLOCK(cntr_lock);
 
 static u32 ctr_enabled;
 
@@ -367,7 +369,7 @@ static void write_pm_cntrl(int cpu)
 	if (pm_regs.pm_cntrl.stop_at_max == 1)
 		val |= CBE_PM_STOP_AT_MAX;
 
-	if (pm_regs.pm_cntrl.trace_mode == 1)
+	if (pm_regs.pm_cntrl.trace_mode != 0)
 		val |= CBE_PM_TRACE_MODE_SET(pm_regs.pm_cntrl.trace_mode);
 
 	if (pm_regs.pm_cntrl.freeze == 1)
@@ -441,7 +443,7 @@ static void cell_virtual_cntr(unsigned l
 	 * not both playing with the counters on the same node.
 	 */
 
-	spin_lock_irqsave(&virt_cntr_lock, flags);
+	spin_lock_irqsave(&cntr_lock, flags);
 
 	prev_hdw_thread = hdw_thread;
 
@@ -527,7 +529,7 @@ static void cell_virtual_cntr(unsigned l
 		cbe_enable_pm(cpu);
 	}
 
-	spin_unlock_irqrestore(&virt_cntr_lock, flags);
+	spin_unlock_irqrestore(&cntr_lock, flags);
 
 	mod_timer(&timer_virt_cntr, jiffies + HZ / 10);
 }
@@ -541,44 +543,30 @@ static void start_virt_cntrs(void)
 	add_timer(&timer_virt_cntr);
 }
 
-/* This function is called once for all cpus combined */
-static int cell_reg_setup(struct op_counter_config *ctr,
+static int cell_reg_setup_spu_cycles(struct op_counter_config *ctr,
 			struct op_system_config *sys, int num_ctrs)
 {
-	int i, j, cpu;
-	spu_cycle_reset = 0;
-
-	if (ctr[0].event == SPU_CYCLES_EVENT_NUM) {
-		spu_cycle_reset = ctr[0].count;
-
-		/*
-		 * Each node will need to make the rtas call to start
-		 * and stop SPU profiling.  Get the token once and store it.
-		 */
-		spu_rtas_token = rtas_token("ibm,cbe-spu-perftools");
-
-		if (unlikely(spu_rtas_token == RTAS_UNKNOWN_SERVICE)) {
-			printk(KERN_ERR
-			       "%s: rtas token ibm,cbe-spu-perftools unknown\n",
-			       __func__);
-			return -EIO;
-		}
-	}
-
-	pm_rtas_token = rtas_token("ibm,cbe-perftools");
+	spu_cycle_reset = ctr[0].count;
 
 	/*
-	 * For all events excetp PPU CYCLEs, each node will need to make
-	 * the rtas cbe-perftools call to setup and reset the debug bus.
-	 * Make the token lookup call once and store it in the global
-	 * variable pm_rtas_token.
+	 * Each node will need to make the rtas call to start
+	 * and stop SPU profiling.  Get the token once and store it.
 	 */
-	if (unlikely(pm_rtas_token == RTAS_UNKNOWN_SERVICE)) {
+	spu_rtas_token = rtas_token("ibm,cbe-spu-perftools");
+
+	if (unlikely(spu_rtas_token == RTAS_UNKNOWN_SERVICE)) {
 		printk(KERN_ERR
-		       "%s: rtas token ibm,cbe-perftools unknown\n",
+		       "%s: rtas token ibm,cbe-spu-perftools unknown\n",
 		       __func__);
 		return -EIO;
 	}
+	return 0;
+}
+
+static int cell_reg_setup_ppu(struct op_counter_config *ctr,
+			struct op_system_config *sys, int num_ctrs)
+{
+	int i, j, cpu;
 
 	num_counters = num_ctrs;
 
@@ -665,6 +653,41 @@ static int cell_reg_setup(struct op_coun
 }
 
 
+/* This function is called once for all cpus combined */
+static int cell_reg_setup(struct op_counter_config *ctr,
+			struct op_system_config *sys, int num_ctrs)
+{
+	int ret;
+
+	spu_cycle_reset = 0;
+
+	/*
+	 * For all events except PPU CYCLEs, each node will need to make
+	 * the rtas cbe-perftools call to setup and reset the debug bus.
+	 * Make the token lookup call once and store it in the global
+	 * variable pm_rtas_token.
+	 */
+	pm_rtas_token = rtas_token("ibm,cbe-perftools");
+
+	if (unlikely(pm_rtas_token == RTAS_UNKNOWN_SERVICE)) {
+		printk(KERN_ERR
+		       "%s: rtas token ibm,cbe-perftools unknown\n",
+		       __func__);
+		return -EIO;
+	}
+
+	if (ctr[0].event == SPU_CYCLES_EVENT_NUM) {
+		profiling_mode = SPU_PROFILING_CYCLES;
+		ret = cell_reg_setup_spu_cycles(ctr, sys, num_ctrs);
+	} else {
+		profiling_mode = PPU_PROFILING;
+		ret = cell_reg_setup_ppu(ctr, sys, num_ctrs);
+	}
+
+	return ret;
+}
+
+
 
 /* This function is called once for each cpu */
 static int cell_cpu_setup(struct op_counter_config *cntr)
@@ -673,7 +696,11 @@ static int cell_cpu_setup(struct op_coun
 	u32 num_enabled = 0;
 	int i;
 
-	if (spu_cycle_reset)
+	/* Cycle based SPU profiling does not use the performance
+	 * counters.  The trace array is configured to collect
+	 * the data.
+	 */
+	if (profiling_mode == SPU_PROFILING_CYCLES)
 		return 0;
 
 	/* There is one performance monitor per processor chip (i.e. node),
@@ -686,7 +713,6 @@ static int cell_cpu_setup(struct op_coun
 	cbe_disable_pm(cpu);
 	cbe_disable_pm_interrupts(cpu);
 
-	cbe_write_pm(cpu, pm_interval, 0);
 	cbe_write_pm(cpu, pm_start_stop, 0);
 	cbe_write_pm(cpu, group_control, pm_regs.group_control);
 	cbe_write_pm(cpu, debug_bus_control, pm_regs.debug_bus_control);
@@ -885,7 +911,94 @@ static struct notifier_block cpu_freq_no
 };
 #endif
 
-static int cell_global_start_spu(struct op_counter_config *ctr)
+/*
+ * Note the generic OProfile stop calls do not support returning
+ * an error on stop.  Hence, will not return an error if the FW
+ * calls fail on stop.	Failure to reset the debug bus is not an issue.
+ * Failure to disable the SPU profiling is not an issue.  The FW calls
+ * to enable the performance counters and debug bus will work even if
+ * the hardware was not cleanly reset.
+ */
+static void cell_global_stop_spu_cycles(void)
+{
+	int subfunc, rtn_value;
+	unsigned int lfsr_value;
+	int cpu;
+
+	oprofile_running = 0;
+
+#ifdef CONFIG_CPU_FREQ
+	cpufreq_unregister_notifier(&cpu_freq_notifier_block,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+#endif
+
+	for_each_online_cpu(cpu) {
+		if (cbe_get_hw_thread_id(cpu))
+			continue;
+
+		subfunc = 3;	/*
+				 * 2 - activate SPU tracing,
+				 * 3 - deactivate
+				 */
+		lfsr_value = 0x8f100000;
+
+		rtn_value = rtas_call(spu_rtas_token, 3, 1, NULL,
+				      subfunc, cbe_cpu_to_node(cpu),
+				      lfsr_value);
+
+		if (unlikely(rtn_value != 0)) {
+			printk(KERN_ERR
+			       "%s: rtas call ibm,cbe-spu-perftools " \
+			       "failed, return = %d\n",
+			       __func__, rtn_value);
+		}
+
+		/* Deactivate the signals */
+		pm_rtas_reset_signals(cbe_cpu_to_node(cpu));
+	}
+
+	if (profiling_mode == SPU_PROFILING_CYCLES)
+		stop_spu_profiling_cycles();
+}
+
+static void cell_global_stop_ppu(void)
+{
+	int cpu;
+
+	/*
+	 * This routine will be called once for the system.
+	 * There is one performance monitor per node, so we
+	 * only need to perform this function once per node.
+	 */
+	del_timer_sync(&timer_virt_cntr);
+	oprofile_running = 0;
+	smp_wmb();
+
+	for_each_online_cpu(cpu) {
+		if (cbe_get_hw_thread_id(cpu))
+			continue;
+
+		cbe_sync_irq(cbe_cpu_to_node(cpu));
+		/* Stop the counters */
+		cbe_disable_pm(cpu);
+
+		/* Deactivate the signals */
+		pm_rtas_reset_signals(cbe_cpu_to_node(cpu));
+
+		/* Deactivate interrupts */
+		cbe_disable_pm_interrupts(cpu);
+	}
+}
+
+static void cell_global_stop(void)
+{
+	if (profiling_mode == PPU_PROFILING)
+		cell_global_stop_ppu();
+	else
+		cell_global_stop_spu_cycles();
+}
+
+static int cell_global_start_spu_cycles(struct op_counter_config *ctr)
 {
 	int subfunc;
 	unsigned int lfsr_value;
@@ -955,14 +1068,14 @@ static int cell_global_start_spu(struct 
 
 		if (unlikely(ret != 0)) {
 			printk(KERN_ERR
-			       "%s: rtas call ibm,cbe-spu-perftools failed, return = %d\n",
-			       __func__, ret);
+			       "%s: rtas call ibm,cbe-spu-perftools failed, " \
+			       "return = %d\n", __func__, ret);
 			rtas_error = -EIO;
 			goto out;
 		}
 	}
 
-	rtas_error = start_spu_profiling(spu_cycle_reset);
+	rtas_error = start_spu_profiling_cycles(spu_cycle_reset);
 	if (rtas_error)
 		goto out_stop;
 
@@ -970,7 +1083,7 @@ static int cell_global_start_spu(struct 
 	return 0;
 
 out_stop:
-	cell_global_stop_spu();		/* clean up the PMU/debug bus */
+	cell_global_stop_spu_cycles();	/* clean up the PMU/debug bus */
 out:
 	return rtas_error;
 }
@@ -1024,99 +1137,15 @@ static int cell_global_start_ppu(struct 
 
 static int cell_global_start(struct op_counter_config *ctr)
 {
-	if (spu_cycle_reset)
-		return cell_global_start_spu(ctr);
+	if (profiling_mode == SPU_PROFILING_CYCLES)
+		return cell_global_start_spu_cycles(ctr);
 	else
 		return cell_global_start_ppu(ctr);
 }
 
-/*
- * Note the generic OProfile stop calls do not support returning
- * an error on stop.  Hence, will not return an error if the FW
- * calls fail on stop.	Failure to reset the debug bus is not an issue.
- * Failure to disable the SPU profiling is not an issue.  The FW calls
- * to enable the performance counters and debug bus will work even if
- * the hardware was not cleanly reset.
- */
-static void cell_global_stop_spu(void)
-{
-	int subfunc, rtn_value;
-	unsigned int lfsr_value;
-	int cpu;
-
-	oprofile_running = 0;
 
-#ifdef CONFIG_CPU_FREQ
-	cpufreq_unregister_notifier(&cpu_freq_notifier_block,
-				    CPUFREQ_TRANSITION_NOTIFIER);
-#endif
-
-	for_each_online_cpu(cpu) {
-		if (cbe_get_hw_thread_id(cpu))
-			continue;
-
-		subfunc = 3;	/*
-				 * 2 - activate SPU tracing,
-				 * 3 - deactivate
-				 */
-		lfsr_value = 0x8f100000;
-
-		rtn_value = rtas_call(spu_rtas_token, 3, 1, NULL,
-				      subfunc, cbe_cpu_to_node(cpu),
-				      lfsr_value);
-
-		if (unlikely(rtn_value != 0)) {
-			printk(KERN_ERR
-			       "%s: rtas call ibm,cbe-spu-perftools failed, return = %d\n",
-			       __func__, rtn_value);
-		}
-
-		/* Deactivate the signals */
-		pm_rtas_reset_signals(cbe_cpu_to_node(cpu));
-	}
-
-	stop_spu_profiling();
-}
-
-static void cell_global_stop_ppu(void)
-{
-	int cpu;
-
-	/*
-	 * This routine will be called once for the system.
-	 * There is one performance monitor per node, so we
-	 * only need to perform this function once per node.
-	 */
-	del_timer_sync(&timer_virt_cntr);
-	oprofile_running = 0;
-	smp_wmb();
-
-	for_each_online_cpu(cpu) {
-		if (cbe_get_hw_thread_id(cpu))
-			continue;
-
-		cbe_sync_irq(cbe_cpu_to_node(cpu));
-		/* Stop the counters */
-		cbe_disable_pm(cpu);
-
-		/* Deactivate the signals */
-		pm_rtas_reset_signals(cbe_cpu_to_node(cpu));
-
-		/* Deactivate interrupts */
-		cbe_disable_pm_interrupts(cpu);
-	}
-}
-
-static void cell_global_stop(void)
-{
-	if (spu_cycle_reset)
-		cell_global_stop_spu();
-	else
-		cell_global_stop_ppu();
-}
-
-static void cell_handle_interrupt(struct pt_regs *regs,
-				struct op_counter_config *ctr)
+static void cell_handle_interrupt_ppu(struct pt_regs *regs,
+				      struct op_counter_config *ctr)
 {
 	u32 cpu;
 	u64 pc;
@@ -1132,7 +1161,7 @@ static void cell_handle_interrupt(struct
 	 * routine are not running at the same time. See the
 	 * cell_virtual_cntr() routine for additional comments.
 	 */
-	spin_lock_irqsave(&virt_cntr_lock, flags);
+	spin_lock_irqsave(&cntr_lock, flags);
 
 	/*
 	 * Need to disable and reenable the performance counters
@@ -1185,7 +1214,14 @@ static void cell_handle_interrupt(struct
 		 */
 		cbe_enable_pm(cpu);
 	}
-	spin_unlock_irqrestore(&virt_cntr_lock, flags);
+	spin_unlock_irqrestore(&cntr_lock, flags);
+}
+
+static void cell_handle_interrupt(struct pt_regs *regs,
+				  struct op_counter_config *ctr)
+{
+	if (profiling_mode == PPU_PROFILING)
+		cell_handle_interrupt_ppu(regs, ctr);
 }
 
 /*
@@ -1195,7 +1231,8 @@ static void cell_handle_interrupt(struct
  */
 static int cell_sync_start(void)
 {
-	if (spu_cycle_reset)
+	if ((profiling_mode == SPU_PROFILING_CYCLES) ||
+	    (profiling_mode == SPU_PROFILING_EVENTS))
 		return spu_sync_start();
 	else
 		return DO_GENERIC_SYNC;
@@ -1203,7 +1240,8 @@ static int cell_sync_start(void)
 
 static int cell_sync_stop(void)
 {
-	if (spu_cycle_reset)
+	if ((profiling_mode == SPU_PROFILING_CYCLES) ||
+	    (profiling_mode == SPU_PROFILING_EVENTS))
 		return spu_sync_stop();
 	else
 		return 1;
Index: Cell_kernel_11_10_2008/arch/powerpc/oprofile/cell/spu_profiler.c
===================================================================
--- Cell_kernel_11_10_2008.orig/arch/powerpc/oprofile/cell/spu_profiler.c
+++ Cell_kernel_11_10_2008/arch/powerpc/oprofile/cell/spu_profiler.c
@@ -31,8 +31,8 @@ static unsigned int profiling_interval;
 
 #define SPU_PC_MASK	     0xFFFF
 
-static DEFINE_SPINLOCK(sample_array_lock);
-unsigned long sample_array_lock_flags;
+static DEFINE_SPINLOCK(oprof_spu_smpl_arry_lck);
+unsigned long oprof_spu_smpl_arry_lck_flags;
 
 void set_spu_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset)
 {
@@ -145,13 +145,13 @@ static enum hrtimer_restart profile_spus
 		 * sample array must be loaded and then processed for a given
 		 * cpu.	 The sample array is not per cpu.
 		 */
-		spin_lock_irqsave(&sample_array_lock,
-				  sample_array_lock_flags);
+		spin_lock_irqsave(&oprof_spu_smpl_arry_lck,
+				  oprof_spu_smpl_arry_lck_flags);
 		num_samples = cell_spu_pc_collection(cpu);
 
 		if (num_samples == 0) {
-			spin_unlock_irqrestore(&sample_array_lock,
-					       sample_array_lock_flags);
+			spin_unlock_irqrestore(&oprof_spu_smpl_arry_lck,
+					       oprof_spu_smpl_arry_lck_flags);
 			continue;
 		}
 
@@ -162,8 +162,8 @@ static enum hrtimer_restart profile_spus
 					num_samples);
 		}
 
-		spin_unlock_irqrestore(&sample_array_lock,
-				       sample_array_lock_flags);
+		spin_unlock_irqrestore(&oprof_spu_smpl_arry_lck,
+				       oprof_spu_smpl_arry_lck_flags);
 
 	}
 	smp_wmb();	/* insure spu event buffer updates are written */
@@ -182,13 +182,13 @@ static enum hrtimer_restart profile_spus
 
 static struct hrtimer timer;
 /*
- * Entry point for SPU profiling.
+ * Entry point for SPU cycle profiling.
  * NOTE:  SPU profiling is done system-wide, not per-CPU.
  *
  * cycles_reset is the count value specified by the user when
  * setting up OProfile to count SPU_CYCLES.
  */
-int start_spu_profiling(unsigned int cycles_reset)
+int start_spu_profiling_cycles(unsigned int cycles_reset)
 {
 	ktime_t kt;
 
@@ -212,10 +212,10 @@ int start_spu_profiling(unsigned int cyc
 	return 0;
 }
 
-void stop_spu_profiling(void)
+void stop_spu_profiling_cycles(void)
 {
 	spu_prof_running = 0;
 	hrtimer_cancel(&timer);
 	kfree(samples);
-	pr_debug("SPU_PROF: stop_spu_profiling issued\n");
+	pr_debug("SPU_PROF: stop_spu_profiling_cycles issued\n");
 }


