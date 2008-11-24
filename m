Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYKXX1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYKXX1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYKXX1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:27:39 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:41754 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYKXX1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:27:38 -0500
Subject: [Patch 2/3] OProfile SPU event profiling support for IBM Cell
	processor
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       cel <cel@linux.vnet.ibm.com>, cbe-oss-dev <cbe-oss-dev@ozlabs.org>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 15:26:41 -0800
Message-Id: <1227569201.6509.214.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch basically rearranges the code a bit to make it easier to
just add the needed SPU event based profiling routines.   The second 
kernel patch contains the new spu event based profiling code.

Signed-off-by: Carl Love <carll@us.ibm.com>


Index: Cell_kernel_11_10_2008/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- Cell_kernel_11_10_2008.orig/arch/powerpc/oprofile/op_model_cell.c
+++ Cell_kernel_11_10_2008/arch/powerpc/oprofile/op_model_cell.c
@@ -40,14 +40,11 @@
 #include "../platforms/cell/interrupt.h"
 #include "cell/pr_util.h"
 
-static void cell_global_stop_spu(void);
+static void cell_global_stop_spu_cycles(void);
 
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
@@ -66,6 +63,15 @@ static unsigned int spu_cycle_reset;
 
 #define MAX_SPU_COUNT 0xFFFFFF	/* maximum 24 bit LFSR value */
 
+/*
+ * spu_cycle_reset is the number of cycles between samples.
+ * This variable is used for SPU profiling and should ONLY be set
+ * at the beginning of cell_reg_setup; otherwise, it's read-only.
+ */
+static unsigned int spu_cycle_reset;
+static unsigned int profiling_mode;
+
+
 struct pmc_cntrl_data {
 	unsigned long vcntr;
 	unsigned long evnts;
@@ -541,44 +547,32 @@ static void start_virt_cntrs(void)
 	add_timer(&timer_virt_cntr);
 }
 
-/* This function is called once for all cpus combined */
-static int cell_reg_setup(struct op_counter_config *ctr,
+static int cell_reg_setup_spu_cycles(struct op_counter_config *ctr,
 			struct op_system_config *sys, int num_ctrs)
 {
 	int i, j, cpu;
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
 
@@ -665,6 +659,42 @@ static int cell_reg_setup(struct op_coun
 }
 
 
+/* This function is called once for all cpus combined */
+static int cell_reg_setup(struct op_counter_config *ctr,
+			struct op_system_config *sys, int num_ctrs)
+{
+	int ret;
+
+	spu_cycle_reset = 0;
+
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
@@ -673,7 +703,11 @@ static int cell_cpu_setup(struct op_coun
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
@@ -686,7 +720,6 @@ static int cell_cpu_setup(struct op_coun
 	cbe_disable_pm(cpu);
 	cbe_disable_pm_interrupts(cpu);
 
-	cbe_write_pm(cpu, pm_interval, 0);
 	cbe_write_pm(cpu, pm_start_stop, 0);
 	cbe_write_pm(cpu, group_control, pm_regs.group_control);
 	cbe_write_pm(cpu, debug_bus_control, pm_regs.debug_bus_control);
@@ -885,7 +918,7 @@ static struct notifier_block cpu_freq_no
 };
 #endif
 
-static int cell_global_start_spu(struct op_counter_config *ctr)
+static int cell_global_start_spu_cycles(struct op_counter_config *ctr)
 {
 	int subfunc;
 	unsigned int lfsr_value;
@@ -970,7 +1003,7 @@ static int cell_global_start_spu(struct 
 	return 0;
 
 out_stop:
-	cell_global_stop_spu();		/* clean up the PMU/debug bus */
+	cell_global_stop_spu_cycles();	/* clean up the PMU/debug bus */
 out:
 	return rtas_error;
 }
@@ -1024,8 +1057,8 @@ static int cell_global_start_ppu(struct 
 
 static int cell_global_start(struct op_counter_config *ctr)
 {
-	if (spu_cycle_reset)
-		return cell_global_start_spu(ctr);
+	if (profiling_mode == SPU_PROFILING_CYCLES)
+		return cell_global_start_spu_cycles(ctr);
 	else
 		return cell_global_start_ppu(ctr);
 }
@@ -1038,7 +1071,7 @@ static int cell_global_start(struct op_c
  * to enable the performance counters and debug bus will work even if
  * the hardware was not cleanly reset.
  */
-static void cell_global_stop_spu(void)
+static void cell_global_stop_spu_cycles(void)
 {
 	int subfunc, rtn_value;
 	unsigned int lfsr_value;
@@ -1075,7 +1108,8 @@ static void cell_global_stop_spu(void)
 		pm_rtas_reset_signals(cbe_cpu_to_node(cpu));
 	}
 
-	stop_spu_profiling();
+	if (profiling_mode == SPU_PROFILING_CYCLES)
+		stop_spu_profiling();
 }
 
 static void cell_global_stop_ppu(void)
@@ -1109,14 +1143,14 @@ static void cell_global_stop_ppu(void)
 
 static void cell_global_stop(void)
 {
-	if (spu_cycle_reset)
-		cell_global_stop_spu();
-	else
+	if (profiling_mode == PPU_PROFILING)
 		cell_global_stop_ppu();
+	else
+		cell_global_stop_spu_cycles();
 }
 
-static void cell_handle_interrupt(struct pt_regs *regs,
-				struct op_counter_config *ctr)
+static void cell_handle_interrupt_ppu(struct pt_regs *regs,
+				      struct op_counter_config *ctr)
 {
 	u32 cpu;
 	u64 pc;
@@ -1188,6 +1222,13 @@ static void cell_handle_interrupt(struct
 	spin_unlock_irqrestore(&virt_cntr_lock, flags);
 }
 
+static void cell_handle_interrupt(struct pt_regs *regs,
+				  struct op_counter_config *ctr)
+{
+	if (profiling_mode == PPU_PROFILING)
+		cell_handle_interrupt_ppu(regs, ctr);
+}
+
 /*
  * This function is called from the generic OProfile
  * driver.  When profiling PPUs, we need to do the
@@ -1195,7 +1236,8 @@ static void cell_handle_interrupt(struct
  */
 static int cell_sync_start(void)
 {
-	if (spu_cycle_reset)
+	if ((profiling_mode == SPU_PROFILING_CYCLES) ||
+		(profiling_mode == SPU_PROFILING_EVENTS))
 		return spu_sync_start();
 	else
 		return DO_GENERIC_SYNC;
@@ -1203,7 +1245,8 @@ static int cell_sync_start(void)
 
 static int cell_sync_stop(void)
 {
-	if (spu_cycle_reset)
+	if ((profiling_mode == SPU_PROFILING_CYCLES) ||
+	    (profiling_mode == SPU_PROFILING_EVENTS))
 		return spu_sync_stop();
 	else
 		return 1;


