Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYLBAU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYLBAU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 19:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYLBATm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 19:19:42 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36310 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbYLBATj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 19:19:39 -0500
Subject: [Patch 3/3]  Kernel patch, IBM CELL processor add OProfile SPU
	event profiling support
From: Carl Love <cel@us.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 16:18:36 -0800
Message-Id: <1228177116.6509.288.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the SPU event based profiling funcitonality for the
IBM Cell processor.  Previously, the CELL OProfile kernel code supported
PPU event, PPU cycle profiling and SPU cycle profiling.   The addition of
SPU event profiling allows the users to identify where in their SPU code
various SPU evnets are occuring.  This should help users further identify
issues with their code.  Note, SPU profiling has some limitations due to HW
constraints.  Only one event at a time can be used for profiling and SPU event 
profiling must be time sliced across all of the SPUs in a node.  

The patch adds a new arch specific file to the OProfile file system. The
file has bit 0 set to indicate that the kernel supports SPU event profiling.
The user tool must check this file/bit to make sure the kernel supports
SPU event profiling before trying to do SPU event profiling.  The user tool
check is part of the user tool patch for SPU event profiling.

Signed-off-by: Carl Love <carll@us.ibm.com>

Index: Cell_kernel_11_10_2008-new-patches/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- Cell_kernel_11_10_2008-new-patches.orig/arch/powerpc/oprofile/op_model_cell.c
+++ Cell_kernel_11_10_2008-new-patches/arch/powerpc/oprofile/op_model_cell.c
@@ -44,6 +44,12 @@
 #define SPU_PROFILING_CYCLES     1
 #define SPU_PROFILING_EVENTS     2
 
+#define SPU_EVENT_NUM_START      4100
+#define SPU_EVENT_NUM_STOP       4399
+#define SPU_PROFILE_EVENT_ADDR          4363  /* spu, address trace, decimal */
+#define SPU_PROFILE_EVENT_ADDR_MASK_A   0x146 /* sub unit set to zero */
+#define SPU_PROFILE_EVENT_ADDR_MASK_B   0x186 /* sub unit set to zero */
+
 #define NUM_SPUS_PER_NODE    8
 #define SPU_CYCLES_EVENT_NUM 2	/*  event number for SPU_CYCLES */
 
@@ -61,6 +67,12 @@
 
 #define MAX_SPU_COUNT 0xFFFFFF	/* maximum 24 bit LFSR value */
 
+/* Minumum HW interval timer setting to send value to trace buffer is 10 cycle.
+ * To configure counter to send value every N cycles set counter to
+ * 2^32 - 1 - N.
+ */
+#define NUM_INTERVAL_CYC  0xFFFFFFFF - 10
+
 /*
  * spu_cycle_reset is the number of cycles between samples.
  * This variable is used for SPU profiling and should ONLY be set
@@ -68,6 +80,7 @@
  */
 static unsigned int spu_cycle_reset;
 static unsigned int profiling_mode;
+static int spu_evnt_phys_spu_indx;
 
 struct pmc_cntrl_data {
 	unsigned long vcntr;
@@ -108,6 +121,8 @@ struct pm_cntrl {
 	u16 trace_mode;
 	u16 freeze;
 	u16 count_mode;
+	u16 spu_addr_trace;
+	u8  trace_buf_ovflw;
 };
 
 static struct {
@@ -125,6 +140,7 @@ static struct {
 #define GET_INPUT_CONTROL(x) ((x & 0x00000004) >> 2)
 
 static DEFINE_PER_CPU(unsigned long[NR_PHYS_CTRS], pmc_values);
+static unsigned long spu_pm_cnt[MAX_NUMNODES * NUM_SPUS_PER_NODE];
 static struct pmc_cntrl_data pmc_cntrl[NUM_THREADS][NR_PHYS_CTRS];
 
 /*
@@ -154,6 +170,7 @@ static u32 hdw_thread;
 
 static u32 virt_cntr_inter_mask;
 static struct timer_list timer_virt_cntr;
+static struct timer_list timer_spu_event_swap;
 
 /*
  * pm_signal needs to be global since it is initialized in
@@ -372,9 +389,13 @@ static void write_pm_cntrl(int cpu)
 	if (pm_regs.pm_cntrl.trace_mode != 0)
 		val |= CBE_PM_TRACE_MODE_SET(pm_regs.pm_cntrl.trace_mode);
 
+	if (pm_regs.pm_cntrl.trace_buf_ovflw == 1)
+		val |= CBE_PM_TRACE_BUF_OVFLW(pm_regs.pm_cntrl.trace_buf_ovflw);
 	if (pm_regs.pm_cntrl.freeze == 1)
 		val |= CBE_PM_FREEZE_ALL_CTRS;
 
+	val |= CBE_PM_SPU_ADDR_TRACE_SET(pm_regs.pm_cntrl.spu_addr_trace);
+
 	/*
 	 * Routine set_count_mode must be called previously to set
 	 * the count mode based on the user selection of user and kernel.
@@ -563,9 +584,184 @@ static int cell_reg_setup_spu_cycles(str
 	return 0;
 }
 
+/* Unfortunately, the hardware will only support event profiling
+ * on one SPU per node at a time.  Therefore, we must time slice
+ * the profiling across all SPUs in the node.  Note, we do this
+ * in parallel for each node.  The following routine is called
+ * periodically based on kernel timer to switch which SPU is
+ * being monitored in a round robbin fashion.
+ */
+static void spu_evnt_swap(unsigned long data)
+{
+	int node;
+	int cur_phys_spu, nxt_phys_spu, cur_spu_evnt_phys_spu_indx;
+	unsigned long flags;
+	int cpu;
+	int ret;
+	u32 interrupt_mask;
+
+
+	/* enable interrupts on cntr 0 */
+	interrupt_mask = CBE_PM_CTR_OVERFLOW_INTR(0);
+
+	hdw_thread = 0;
+
+	/* Make sure spu event interrupt handler and spu event swap
+	 * don't access the counters simultaneously.
+	 */
+	spin_lock_irqsave(&cntr_lock, flags);
+
+	cur_spu_evnt_phys_spu_indx = spu_evnt_phys_spu_indx;
+
+	if (++(spu_evnt_phys_spu_indx) == NUM_SPUS_PER_NODE)
+		spu_evnt_phys_spu_indx = 0;
+
+	pm_signal[0].sub_unit = spu_evnt_phys_spu_indx;
+	pm_signal[1].sub_unit = spu_evnt_phys_spu_indx;
+	pm_signal[2].sub_unit = spu_evnt_phys_spu_indx;
+
+	/* switch the SPU being profiled on each node */
+	for_each_online_cpu(cpu) {
+		if (cbe_get_hw_thread_id(cpu))
+			continue;
+
+		node = cbe_cpu_to_node(cpu);
+		cur_phys_spu = (node * NUM_SPUS_PER_NODE)
+			+ cur_spu_evnt_phys_spu_indx;
+		nxt_phys_spu = (node * NUM_SPUS_PER_NODE)
+			+ spu_evnt_phys_spu_indx;
+
+		/*
+		 * stop counters, save counter values, restore counts
+		 * for previous physical SPU
+		 */
+		cbe_disable_pm(cpu);
+		cbe_disable_pm_interrupts(cpu);
+
+		spu_pm_cnt[cur_phys_spu]
+			    = cbe_read_ctr(cpu, 0);
+
+		/* restore previous count for the next spu to sample */
+		/* NOTE, hardware issue, counter will not start if the
+		 * counter value is at max (0xFFFFFFFF).
+		 */
+		if (spu_pm_cnt[nxt_phys_spu] >= 0xFFFFFFFF)
+			cbe_write_ctr(cpu, 0, 0xFFFFFFF0);
+		 else
+			 cbe_write_ctr(cpu, 0, spu_pm_cnt[nxt_phys_spu]);
+
+		pm_rtas_reset_signals(cbe_cpu_to_node(cpu));
+
+		/* setup the debug bus measure the one event and
+		 * the two events to route the next SPU's PC on
+		 * the debug bus
+		 */
+		ret = pm_rtas_activate_signals(cbe_cpu_to_node(cpu), 3);
+		if (ret)
+			printk(KERN_ERR
+		       "%s: pm_rtas_activate_signals failed, SPU event swap\n",
+		       __func__);
+
+		/* clear the trace buffer, don't want to take PC for
+		 * previous SPU*/
+		cbe_write_pm(cpu, trace_address, 0);
+
+		enable_ctr(cpu, 0, pm_regs.pm07_cntrl);
+
+		/* Enable interrupts on the CPU thread that is starting */
+		cbe_enable_pm_interrupts(cpu, hdw_thread,
+					 interrupt_mask);
+		cbe_enable_pm(cpu);
+	}
+
+	spin_unlock_irqrestore(&cntr_lock, flags);
+
+	/* swap approximately every 0.1 seconds */
+	mod_timer(&timer_spu_event_swap, jiffies + HZ / 25);
+}
+
+static void start_spu_event_swap(void)
+{
+	init_timer(&timer_spu_event_swap);
+	timer_spu_event_swap.function = spu_evnt_swap;
+	timer_spu_event_swap.data = 0UL;
+	timer_spu_event_swap.expires = jiffies + HZ / 25;
+	add_timer(&timer_spu_event_swap);
+}
+
+static int cell_reg_setup_spu_events(struct op_counter_config *ctr,
+			struct op_system_config *sys, int num_ctrs)
+{
+	int i;
+
+	/* routine is called once for all nodes */
+
+	spu_evnt_phys_spu_indx = 0;
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
+	/* setup the pm_control register settings,
+	 * settings will be written per node by the
+	 * cell_cpu_setup() function.
+	 */
+	pm_regs.pm_cntrl.trace_buf_ovflw = 1;
+
+	/* Use the occurrence trace mode to have SPU PC saved
+	 * to the trace buffer.  Occurrence data in trace buffer
+	 * is not used.  Bit 2 must be set to store SPU addresses.
+	 */
+	pm_regs.pm_cntrl.trace_mode = 2;
+
+	pm_regs.pm_cntrl.spu_addr_trace = 0x1;  /* using debug bus
+						   event 2 & 3 */
+
+	/* setup the debug bus event array with the SPU PC routing events.
+	*  Note, pm_signal[0] will be filled in by set_pm_event() call below.
+	*/
+	pm_signal[1].signal_group = SPU_PROFILE_EVENT_ADDR / 100;
+	pm_signal[1].bus_word = GET_BUS_WORD(SPU_PROFILE_EVENT_ADDR_MASK_A);
+	pm_signal[1].bit = SPU_PROFILE_EVENT_ADDR % 100;
+	pm_signal[1].sub_unit = spu_evnt_phys_spu_indx;
+
+	pm_signal[2].signal_group = SPU_PROFILE_EVENT_ADDR / 100;
+	pm_signal[2].bus_word = GET_BUS_WORD(SPU_PROFILE_EVENT_ADDR_MASK_B);
+	pm_signal[2].bit = SPU_PROFILE_EVENT_ADDR % 100;
+	pm_signal[2].sub_unit = spu_evnt_phys_spu_indx;
+
+	/* Set the user selected spu event to profile on,
+	 * note, only one SPU profiling event is supported
+	 */
+	num_counters = 1;  /* Only support one SPU event at a time */
+	set_pm_event(0, ctr[0].event, ctr[0].unit_mask);
+
+	reset_value[0] = 0xFFFFFFFF - ctr[0].count;
+
+	/* global, used by cell_cpu_setup */
+	ctr_enabled |= 1;
+
+	/* Initialize the count for each SPU to the reset value */
+	for (i=0; i < MAX_NUMNODES * NUM_SPUS_PER_NODE; i++)
+		spu_pm_cnt[i] = reset_value[0];
+
+	return 0;
+}
+
 static int cell_reg_setup_ppu(struct op_counter_config *ctr,
 			struct op_system_config *sys, int num_ctrs)
 {
+	/* routine is called once for all nodes */
 	int i, j, cpu;
 
 	num_counters = num_ctrs;
@@ -577,14 +773,6 @@ static int cell_reg_setup_ppu(struct op_
 		       __func__);
 		return -EIO;
 	}
-	pm_regs.group_control = 0;
-	pm_regs.debug_bus_control = 0;
-
-	/* setup the pm_control register */
-	memset(&pm_regs.pm_cntrl, 0, sizeof(struct pm_cntrl));
-	pm_regs.pm_cntrl.stop_at_max = 1;
-	pm_regs.pm_cntrl.trace_mode = 0;
-	pm_regs.pm_cntrl.freeze = 1;
 
 	set_count_mode(sys->enable_kernel, sys->enable_user);
 
@@ -657,10 +845,20 @@ static int cell_reg_setup_ppu(struct op_
 static int cell_reg_setup(struct op_counter_config *ctr,
 			struct op_system_config *sys, int num_ctrs)
 {
-	int ret;
-
+	int ret=0;
 	spu_cycle_reset = 0;
 
+	/* initialize the spu_arr_trace value, will be reset if
+	 * doing spu event profiling.
+	 */
+	pm_regs.group_control = 0;
+	pm_regs.debug_bus_control = 0;
+	pm_regs.pm_cntrl.stop_at_max = 1;
+	pm_regs.pm_cntrl.trace_mode = 0;
+	pm_regs.pm_cntrl.freeze = 1;
+	pm_regs.pm_cntrl.trace_buf_ovflw = 0;
+	pm_regs.pm_cntrl.spu_addr_trace = 0;
+
 	/*
 	 * For all events except PPU CYCLEs, each node will need to make
 	 * the rtas cbe-perftools call to setup and reset the debug bus.
@@ -679,6 +877,18 @@ static int cell_reg_setup(struct op_coun
 	if (ctr[0].event == SPU_CYCLES_EVENT_NUM) {
 		profiling_mode = SPU_PROFILING_CYCLES;
 		ret = cell_reg_setup_spu_cycles(ctr, sys, num_ctrs);
+	} else if ((ctr[0].event >= SPU_EVENT_NUM_START) &&
+		   (ctr[0].event <= SPU_EVENT_NUM_STOP)) {
+		profiling_mode = SPU_PROFILING_EVENTS;
+		spu_cycle_reset = ctr[0].count;
+
+		/* for SPU event profiling, need to setup the
+		 * pm_signal array with the events to route the
+		 * SPU PC before making the FW call.  Note, only
+		 * one SPU event for profiling can be specified
+		 * at a time.
+		 */
+		cell_reg_setup_spu_events(ctr, sys, num_ctrs);
 	} else {
 		profiling_mode = PPU_PROFILING;
 		ret = cell_reg_setup_ppu(ctr, sys, num_ctrs);
@@ -695,6 +905,7 @@ static int cell_cpu_setup(struct op_coun
 	u32 cpu = smp_processor_id();
 	u32 num_enabled = 0;
 	int i;
+	int ret;
 
 	/* Cycle based SPU profiling does not use the performance
 	 * counters.  The trace array is configured to collect
@@ -729,7 +940,20 @@ static int cell_cpu_setup(struct op_coun
 	 * The pm_rtas_activate_signals will return -EIO if the FW
 	 * call failed.
 	 */
-	return pm_rtas_activate_signals(cbe_cpu_to_node(cpu), num_enabled);
+	if (profiling_mode == SPU_PROFILING_EVENTS) {
+		/* For SPU event profiling also need to setup the
+		 * pm interval timer
+		 */
+		ret = pm_rtas_activate_signals(cbe_cpu_to_node(cpu),
+					       num_enabled+2);
+		/* store PC from debug bus to Trace buffer as often
+		 * as possible (every 10 cycles)
+		 */
+		cbe_write_pm(cpu, pm_interval, NUM_INTERVAL_CYC);
+		return ret;
+	} else
+		return pm_rtas_activate_signals(cbe_cpu_to_node(cpu),
+						num_enabled);
 }
 
 #define ENTRIES	 303
@@ -926,6 +1150,7 @@ static void cell_global_stop_spu_cycles(
 	int cpu;
 
 	oprofile_running = 0;
+	smp_wmb();
 
 #ifdef CONFIG_CPU_FREQ
 	cpufreq_unregister_notifier(&cpu_freq_notifier_block,
@@ -957,8 +1182,33 @@ static void cell_global_stop_spu_cycles(
 		pm_rtas_reset_signals(cbe_cpu_to_node(cpu));
 	}
 
-	if (profiling_mode == SPU_PROFILING_CYCLES)
-		stop_spu_profiling_cycles();
+	stop_spu_profiling_cycles();
+}
+
+static void cell_global_stop_spu_events(void)
+{
+	int cpu;
+	oprofile_running = 0;
+
+	stop_spu_profiling_events();
+	smp_wmb();
+
+	for_each_online_cpu(cpu) {
+		if (cbe_get_hw_thread_id(cpu))
+			continue;
+
+		cbe_sync_irq(cbe_cpu_to_node(cpu));
+		/* Stop the counters */
+		cbe_disable_pm(cpu);
+		cbe_write_pm07_control(cpu, 0, 0);
+
+		/* Deactivate the signals */
+		pm_rtas_reset_signals(cbe_cpu_to_node(cpu));
+
+		/* Deactivate interrupts */
+		cbe_disable_pm_interrupts(cpu);
+	}
+	del_timer_sync(&timer_spu_event_swap);
 }
 
 static void cell_global_stop_ppu(void)
@@ -994,6 +1244,8 @@ static void cell_global_stop(void)
 {
 	if (profiling_mode == PPU_PROFILING)
 		cell_global_stop_ppu();
+	else if (profiling_mode == SPU_PROFILING_EVENTS)
+		cell_global_stop_spu_events();
 	else
 		cell_global_stop_spu_cycles();
 }
@@ -1088,6 +1340,69 @@ out:
 	return rtas_error;
 }
 
+static int cell_global_start_spu_events(struct op_counter_config *ctr)
+{
+	int cpu;
+	u32 interrupt_mask = 0;
+	int rtn = 0;
+
+	hdw_thread = 0;
+
+	/* spu event profiling, uses the performance counters to generate
+	 * an interrupt.  The hardware is setup to store the SPU program
+	 * counter into the trace array.  The occurrence mode is used to
+	 * enable storing data to the trace buffer.  The bits are set
+	 * to send/store the SPU address in the trace buffer.  The debug
+	 * bus must be setup to route the SPU program counter onto the
+	 * debug bus.  The occurrence data in the trace buffer is not used.
+	 */
+
+	/* This routine gets called once for the system.
+	 * There is one performance monitor per node, so we
+	 * only need to perform this function once per node.
+	 */
+
+	for_each_online_cpu(cpu) {
+		if (cbe_get_hw_thread_id(cpu))
+			continue;
+
+		/*
+		 * Setup SPU event-based profiling.
+		 * Set perf_mon_control bit 0 to a zero before
+		 * enabling spu collection hardware.
+		 *
+		 * Only support one SPU event on one SPU per node.
+		 */
+		if (ctr_enabled & 1) {
+			cbe_write_ctr(cpu, 0, reset_value[0]);
+			enable_ctr(cpu, 0, pm_regs.pm07_cntrl);
+			interrupt_mask |=
+				CBE_PM_CTR_OVERFLOW_INTR(0);
+		} else {
+			/* Disable counter */
+			cbe_write_pm07_control(cpu, 0, 0);
+		}
+
+		cbe_get_and_clear_pm_interrupts(cpu);
+		cbe_enable_pm_interrupts(cpu, hdw_thread, interrupt_mask);
+		cbe_enable_pm(cpu);
+
+		/* clear the trace buffer */
+		cbe_write_pm(cpu, trace_address, 0);
+	}
+
+	/* Start the timer to time slice collecting the event profile
+	 * on each of the SPUs.  Note, can collect profile on one SPU
+	 * per node at a time.
+	 */
+	start_spu_event_swap();
+	start_spu_profiling_events();
+  	oprofile_running = 1;
+	smp_wmb();
+
+	return rtn;
+}
+
 static int cell_global_start_ppu(struct op_counter_config *ctr)
 {
 	u32 cpu, i;
@@ -1139,11 +1454,158 @@ static int cell_global_start(struct op_c
 {
 	if (profiling_mode == SPU_PROFILING_CYCLES)
 		return cell_global_start_spu_cycles(ctr);
+	else if (profiling_mode == SPU_PROFILING_EVENTS)
+		return cell_global_start_spu_events(ctr);
 	else
 		return cell_global_start_ppu(ctr);
 }
 
 
+/* The SPU interrupt handler
+ *
+ * SPU event profiling works as follows:
+ * The pm_signal[0] holds the one SPU event to be measured.  It is routed on
+ * the debug bus using word 0 or 1.  The value of pm_signal[1] and
+ * pm_signal[2] contain the necessary events to route the SPU program
+ * counter for the selected SPU onto the debug bus using words 2 and 3.
+ * The pm_interval register is setup to write the SPU PC value into the
+ * trace buffer at the maximum rate possible.  The trace buffer is configured
+ * to store the PCs, wrapping when it is full.  The performance counter is
+ * intialized to the max hardware count minus the number of events, N, between
+ * samples.  Once the N events have occured, a HW counter overflow occurs
+ * causing the generation of a HW counter interrupt which also stops the
+ * writing of the SPU PC values to the trace buffer.  Hence the last PC
+ * written to the trace buffer is the SPU PC that we want.  Unfortunately,
+ * we have to read from the beginning of the trace buffer to get to the
+ * last value written.  We just hope the PPU has nothing better to do then
+ * service this interrupt. The PC for the specific SPU being profiled is
+ * extracted from the trace buffer processed and stored.  The trace buffer
+ * is cleared, interrupts are cleared, the counter is reset to max - N.
+ * A kernel timer is used to periodically call the routine spu_evnt_swap()
+ * to switch to the next physical SPU in the node to profile in round robbin
+ * order.  This way data is collected for all SPUs on the node. It does mean
+ * that we need to use a relatively small value of N to ensure enough samples
+ * on each SPU are collected each SPU is being profiled 1/8 of the time.
+ * It may also be necessary to use a longer sample collection period.
+ */
+static void cell_handle_interrupt_spu(struct pt_regs *regs,
+				      struct op_counter_config *ctr)
+{
+	u32 cpu, cpu_tmp;
+	u64 trace_entry;
+	u32 interrupt_mask;
+	u64 trace_buffer[2];
+	u64 last_trace_buffer;
+	u32 sample;
+	u32 trace_addr;
+	unsigned long sample_array_lock_flags;
+	int spu_num;
+	unsigned long flags;
+
+	/* Make sure spu event interrupt handler and spu event swap
+	 * don't access the counters simultaneously.
+	 */
+	cpu = smp_processor_id();
+	spin_lock_irqsave(&cntr_lock, flags);
+
+	cpu_tmp = cpu;
+	cbe_disable_pm(cpu);
+
+	interrupt_mask = cbe_get_and_clear_pm_interrupts(cpu);
+
+	sample = 0xABCDEF;
+	trace_entry = 0xfedcba;
+	last_trace_buffer = 0xdeadbeaf;
+
+        if ((oprofile_running == 1) && (interrupt_mask != 0)) {
+		/* disable writes to trace buff */
+		cbe_write_pm(cpu, pm_interval, 0);
+
+		/* only have one perf cntr being used, cntr 0 */
+		if ((interrupt_mask & CBE_PM_CTR_OVERFLOW_INTR(0))
+			    && ctr[0].enabled)
+			/* The SPU PC values will be read
+			 * from the trace buffer, reset counter
+			 */
+
+			cbe_write_ctr(cpu, 0, reset_value[0]);
+
+		trace_addr = cbe_read_pm(cpu, trace_address);
+
+		while (!(trace_addr & CBE_PM_TRACE_BUF_EMPTY)) {
+			/* There is data in the trace buffer to process
+			 * Read the buffer until you get to the last
+			 * entry.  This is the value we want.
+			 */
+
+			cbe_read_trace_buffer(cpu, trace_buffer);
+			trace_addr = cbe_read_pm(cpu, trace_address);
+		}
+
+		/* SPU Address 16 bit count format for 128 bit
+		 * HW trace buffer is used for the SPU PC storage
+		 *    HDR bits          0:15
+		 *    SPU Addr 0 bits   16:31
+		 *    SPU Addr 1 bits   32:47
+		 *    unused bits       48:127
+		 *
+		 * HDR: bit4 = 1 SPU Address 0 valid
+		 * HDR: bit5 = 1 SPU Address 1 valid
+		 *  - unfortunately, the valid bits don't seem to work
+		 *
+		 * Note trace_buffer[0] holds bits 0:63 of the HW
+		 * trace buffer, trace_buffer[1] holds bits 64:127
+		 */
+
+		trace_entry = trace_buffer[0]
+			& 0x00000000FFFF0000;
+
+		/* only top 16 of the 18 bit SPU PC address
+		 * is stored in trace buffer, hence shift right
+		 * by 16 -2 bits */
+		sample = trace_entry >> 14;
+		last_trace_buffer = trace_buffer[0];
+
+		spu_num = spu_evnt_phys_spu_indx
+			+ (cbe_cpu_to_node(cpu) * NUM_SPUS_PER_NODE);
+
+		/* make sure only one process at a time is calling
+		 * spu_sync_buffer()
+		 */
+		spin_lock_irqsave(&oprof_spu_smpl_arry_lck,
+				  sample_array_lock_flags);
+		spu_sync_buffer(spu_num, &sample, 1);
+		spin_unlock_irqrestore(&oprof_spu_smpl_arry_lck,
+				       sample_array_lock_flags);
+
+		smp_wmb();    /* insure spu event buffer updates are written
+			       * don't want events intermingled... */
+
+		/* The counters were frozen by the interrupt.
+		 * Reenable the interrupt and restart the counters.
+		 */
+		cbe_write_pm(cpu, pm_interval, NUM_INTERVAL_CYC);
+		cbe_enable_pm_interrupts(cpu, hdw_thread,
+					 virt_cntr_inter_mask);
+
+		/* clear the trace buffer, re-enable writes to trace buff */
+		cbe_write_pm(cpu, trace_address, 0);
+		cbe_write_pm(cpu, pm_interval, NUM_INTERVAL_CYC);
+
+		/* The writes to the various performance counters only writes
+		 * to a latch.  The new values (interrupt setting bits, reset
+		 * counter value etc.) are not copied to the actual registers
+		 * until the performance monitor is enabled.  In order to get
+		 * this to work as desired, the permormance monitor needs to
+		 * be disabled while writing to the latches.  This is a
+		 * HW design issue.
+		 */
+		write_pm_cntrl(cpu);
+		cbe_enable_pm(cpu);
+	}
+	spin_unlock_irqrestore(&cntr_lock, flags);
+}
+
 static void cell_handle_interrupt_ppu(struct pt_regs *regs,
 				      struct op_counter_config *ctr)
 {
@@ -1222,6 +1684,8 @@ static void cell_handle_interrupt(struct
 {
 	if (profiling_mode == PPU_PROFILING)
 		cell_handle_interrupt_ppu(regs, ctr);
+	else
+		cell_handle_interrupt_spu(regs, ctr);
 }
 
 /*
Index: Cell_kernel_11_10_2008-new-patches/include/asm-powerpc/cell-pmu.h
===================================================================
--- Cell_kernel_11_10_2008-new-patches.orig/include/asm-powerpc/cell-pmu.h
+++ Cell_kernel_11_10_2008-new-patches/include/asm-powerpc/cell-pmu.h
@@ -37,9 +37,11 @@
 #define CBE_PM_STOP_AT_MAX                 0x40000000
 #define CBE_PM_TRACE_MODE_GET(pm_control)  (((pm_control) >> 28) & 0x3)
 #define CBE_PM_TRACE_MODE_SET(mode)        (((mode)  & 0x3) << 28)
+#define CBE_PM_TRACE_BUF_OVFLW(bit)        (((bit) & 0x1) << 17)
 #define CBE_PM_COUNT_MODE_SET(count)       (((count) & 0x3) << 18)
 #define CBE_PM_FREEZE_ALL_CTRS             0x00100000
 #define CBE_PM_ENABLE_EXT_TRACE            0x00008000
+#define CBE_PM_SPU_ADDR_TRACE_SET(msk)     (((msk) & 0x3) << 9)
 
 /* Macros for the trace_address register. */
 #define CBE_PM_TRACE_BUF_FULL              0x00000800
Index: Cell_kernel_11_10_2008-new-patches/arch/powerpc/oprofile/cell/pr_util.h
===================================================================
--- Cell_kernel_11_10_2008-new-patches.orig/arch/powerpc/oprofile/cell/pr_util.h
+++ Cell_kernel_11_10_2008-new-patches/arch/powerpc/oprofile/cell/pr_util.h
@@ -30,6 +30,10 @@
 extern struct delayed_work spu_work;
 extern int spu_prof_running;
 
+#define TRACE_ARRAY_SIZE 1024
+
+extern spinlock_t oprof_spu_smpl_arry_lck;
+
 struct spu_overlay_info {	/* map of sections within an SPU overlay */
 	unsigned int vma;	/* SPU virtual memory address from elf */
 	unsigned int size;	/* size of section from elf */
@@ -90,9 +94,10 @@ void vma_map_free(struct vma_to_fileoffs
  * cycles_reset is the SPU_CYCLES count value specified by the user.
  */
 int start_spu_profiling_cycles(unsigned int cycles_reset);
+void start_spu_profiling_events(void);
 
 void stop_spu_profiling_cycles(void);
-
+void stop_spu_profiling_events(void);
 
 /* add the necessary profiling hooks */
 int spu_sync_start(void);
Index: Cell_kernel_11_10_2008-new-patches/arch/powerpc/oprofile/cell/spu_profiler.c
===================================================================
--- Cell_kernel_11_10_2008-new-patches.orig/arch/powerpc/oprofile/cell/spu_profiler.c
+++ Cell_kernel_11_10_2008-new-patches/arch/powerpc/oprofile/cell/spu_profiler.c
@@ -18,11 +18,21 @@
 #include <asm/cell-pmu.h>
 #include "pr_util.h"
 
-#define TRACE_ARRAY_SIZE 1024
 #define SCALE_SHIFT 14
 
 static u32 *samples;
 
+/* spu_prof_running is a flag used to indicate if spu profiling is enabled
+ * or not.  It is set by the routines start_spu_profiling_cycles() and
+ * start_spu_profiling_events().  The flag is cleared by the routines
+ * stop_spu_profiling_cycles() and stop_spu_profiling_events().  These
+ * routines are called via global_start() and global_stop() which are called in
+ * op_powerpc_start() and op_powerpc_stop().  These routines are called once
+ * per system as a result of the user starting/stopping oprofile.  Hence, only
+ * one CPU per user at a time will be changing  the value of spu_prof_running.
+ * In general, OProfile does not protect against multiple users trying to run
+ * OProfile at a time.
+ */
 int spu_prof_running;
 static unsigned int profiling_interval;
 
@@ -31,7 +41,7 @@ static unsigned int profiling_interval;
 
 #define SPU_PC_MASK	     0xFFFF
 
-static DEFINE_SPINLOCK(oprof_spu_smpl_arry_lck);
+DEFINE_SPINLOCK(oprof_spu_smpl_arry_lck);
 unsigned long oprof_spu_smpl_arry_lck_flags;
 
 void set_spu_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset)
@@ -212,6 +222,21 @@ int start_spu_profiling_cycles(unsigned 
 	return 0;
 }
 
+/*
+ * Entry point for SPU event profiling.
+ * NOTE:  SPU profiling is done system-wide, not per-CPU.
+ *
+ * cycles_reset is the count value specified by the user when
+ * setting up OProfile to count SPU_CYCLES.
+ */
+void start_spu_profiling_events(void)
+{
+	spu_prof_running = 1;
+	schedule_delayed_work(&spu_work, DEFAULT_TIMER_EXPIRE);
+
+	return;
+}
+
 void stop_spu_profiling_cycles(void)
 {
 	spu_prof_running = 0;
@@ -219,3 +244,8 @@ void stop_spu_profiling_cycles(void)
 	kfree(samples);
 	pr_debug("SPU_PROF: stop_spu_profiling_cycles issued\n");
 }
+
+void stop_spu_profiling_events(void)
+{
+	spu_prof_running = 0;
+}
Index: Cell_kernel_11_10_2008-new-patches/arch/powerpc/oprofile/common.c
===================================================================
--- Cell_kernel_11_10_2008-new-patches.orig/arch/powerpc/oprofile/common.c
+++ Cell_kernel_11_10_2008-new-patches/arch/powerpc/oprofile/common.c
@@ -132,6 +132,28 @@ static int op_powerpc_create_files(struc
 	oprofilefs_create_ulong(sb, root, "mmcr0", &sys.mmcr0);
 	oprofilefs_create_ulong(sb, root, "mmcr1", &sys.mmcr1);
 	oprofilefs_create_ulong(sb, root, "mmcra", &sys.mmcra);
+#ifdef CONFIG_OPROFILE_CELL
+	/* create a file the user tool can check to see what level of profiling
+	 * support exits with this kernel. Initialize bit mask to indicate
+	 * what support the kernel has:
+	 * bit 0      -  Supports SPU event profiling in addition to PPU
+	 *               event and cycles; and SPU cycle profiling
+	 * bits 1-31  -  Currently unused.
+	 *
+	 * If the file does not exist, then the kernel only supports SPU
+	 * cycle profiling, PPU event and cycle profiling.
+	 */
+	oprofilefs_create_ulong(sb, root, "cell_support", &sys.cell_support);
+	sys.cell_support = 0x1; /* Note, the user OProfile tool must check
+				 * that this bit is set before attempting to
+				 * user SPU event profiling.  Older kernels
+				 * will not have this file, hence the user
+				 * tool is not allowed to do SPU event
+				 * profiling on older kernels.  Older kernels
+				 * will accept SPU events but collected data
+				 * is garbage.
+				 */
+#endif
 #endif
 
 	for (i = 0; i < model->num_counters; ++i) {
Index: Cell_kernel_11_10_2008-new-patches/include/asm-powerpc/oprofile_impl.h
===================================================================
--- Cell_kernel_11_10_2008-new-patches.orig/include/asm-powerpc/oprofile_impl.h
+++ Cell_kernel_11_10_2008-new-patches/include/asm-powerpc/oprofile_impl.h
@@ -32,6 +32,12 @@ struct op_system_config {
 	unsigned long mmcr0;
 	unsigned long mmcr1;
 	unsigned long mmcra;
+#ifdef CONFIG_OPROFILE_CELL
+	/* Register for oprofile user tool to check cell kernel profiling
+	 * suport.
+	 */
+	unsigned long cell_support;
+#endif
 #endif
 	unsigned long enable_kernel;
 	unsigned long enable_user;


