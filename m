Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYGWVJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYGWVJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYGWVJC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:09:02 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:53308 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbYGWVI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:08:59 -0400
X-BigFish: VPS16(zz655O10d1Izz10d3izzz32i87il43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4H9DQ-01-3TD-01
From: Robert Richter <robert.richter@amd.com>
To: Jason Yeh <jason.yeh@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, Jason Yeh <jason.yeh@amd.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] Oprofile Multiplexing Patch
Date: Wed, 23 Jul 2008 23:05:53 +0200
Message-ID: <1216847153-28435-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 23 Jul 2008 21:08:22.0053 (UTC) FILETIME=[3D177D50:01C8ED08]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Yeh <jason.yeh@amd.com>

This patch introduces multiplexing support for the Oprofile kernel
module. It basically adds a new function pointer in oprofile_operator
allowing each architecture to supply its callback to switch between
different sets of event when the timer expires. Userspace tools can
modify the time slice through /dev/oprofile/time_slice.

It also modifies the number of counters exposed to the userspace through
/dev/oprofile. For example, the number of counters for AMD CPUs are
changed to 32 and multiplexed in the sets of 4.

Signed-off-by: Jason Yeh <jason.yeh@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |  100 ++++++++++++++++++++++++++++++++++---
 arch/x86/oprofile/op_counter.h    |    3 +-
 arch/x86/oprofile/op_model_amd.c  |   76 +++++++++++++++++-----------
 arch/x86/oprofile/op_model_p4.c   |    4 ++
 arch/x86/oprofile/op_model_ppro.c |    2 +
 arch/x86/oprofile/op_x86_model.h  |    3 +
 drivers/oprofile/oprof.c          |   58 ++++++++++++++++++++-
 drivers/oprofile/oprof.h          |    4 +-
 drivers/oprofile/oprofile_files.c |   39 ++++++++++++++-
 include/linux/oprofile.h          |    3 +
 10 files changed, 247 insertions(+), 45 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index f46d8fc..186ab90 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -23,12 +23,18 @@
 #include "op_counter.h"
 #include "op_x86_model.h"
 
+DEFINE_PER_CPU(int, switch_index);
+
 static struct op_x86_model_spec const *model;
 static DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
 static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 
 static int nmi_start(void);
 static void nmi_stop(void);
+static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs);
+static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs);
+static void nmi_cpu_stop(void *dummy);
+static void nmi_cpu_start(void *dummy);
 
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
@@ -81,6 +87,47 @@ static void exit_sysfs(void)
 #define exit_sysfs() do { } while (0)
 #endif /* CONFIG_PM */
 
+static void nmi_cpu_switch(void *dummy)
+{
+	int cpu = smp_processor_id();
+	int si = per_cpu(switch_index, cpu);
+	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
+
+	nmi_cpu_stop(NULL);
+	nmi_cpu_save_mpx_registers(msrs);
+
+	/* move to next set */
+	si += model->num_hardware_counters;
+	if ((si > model->num_counters) || (counter_config[si].count == 0))
+		per_cpu(switch_index, smp_processor_id()) = 0;
+	else
+		per_cpu(switch_index, smp_processor_id()) = si;
+
+	nmi_cpu_restore_mpx_registers(msrs);
+	model->setup_ctrs(msrs);
+	nmi_cpu_start(NULL);
+}
+
+/*
+ * Quick check to see if multiplexing is necessary.
+ * The check should be sufficient since counters are used
+ * in ordre.
+ */
+static int nmi_multiplex_on(void)
+{
+	return counter_config[model->num_hardware_counters].count ? 0 : -EINVAL;
+}
+
+static int nmi_switch_event(void)
+{
+	if (nmi_multiplex_on() < 0)
+		return -EINVAL;
+
+	on_each_cpu(nmi_cpu_switch, NULL, 0, 1);
+
+	return 0;
+}
+
 static int profile_exceptions_notify(struct notifier_block *self,
 				     unsigned long val, void *data)
 {
@@ -144,11 +191,10 @@ static void free_msrs(void)
 
 static int allocate_msrs(void)
 {
-	int success = 1;
+	int i, success = 1;
 	size_t controls_size = sizeof(struct op_msr) * model->num_controls;
 	size_t counters_size = sizeof(struct op_msr) * model->num_counters;
 
-	int i;
 	for_each_possible_cpu(i) {
 		per_cpu(cpu_msrs, i).counters = kmalloc(counters_size,
 								GFP_KERNEL);
@@ -156,8 +202,8 @@ static int allocate_msrs(void)
 			success = 0;
 			break;
 		}
-		per_cpu(cpu_msrs, i).controls = kmalloc(controls_size,
-								GFP_KERNEL);
+		per_cpu(cpu_msrs, i).controls =
+				kmalloc(controls_size, GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).controls) {
 			success = 0;
 			break;
@@ -201,7 +247,8 @@ static int nmi_setup(void)
 		return err;
 	}
 
-	/* We need to serialize save and setup for HT because the subset
+	/*
+	 * We need to serialize save and setup for HT because the subset
 	 * of msrs are distinct for save and setup operations
 	 */
 
@@ -217,7 +264,6 @@ static int nmi_setup(void)
 				per_cpu(cpu_msrs, 0).controls,
 				sizeof(struct op_msr) * model->num_controls);
 		}
-
 	}
 	on_each_cpu(nmi_save_registers, NULL, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
@@ -225,7 +271,41 @@ static int nmi_setup(void)
 	return 0;
 }
 
-static void nmi_restore_registers(struct op_msrs *msrs)
+static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs)
+{
+	unsigned int si = __get_cpu_var(switch_index);
+	unsigned int const nr_ctrs = model->num_hardware_counters;
+	struct op_msr *counters = &msrs->counters[si];
+	unsigned int i;
+
+	for (i = 0; i < nr_ctrs; ++i) {
+		int offset = i + si;
+		if (counters[offset].addr) {
+			rdmsr(counters[offset].addr,
+				counters[offset].multiplex.low,
+				counters[offset].multiplex.high);
+		}
+	}
+}
+
+static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
+{
+	unsigned int si = __get_cpu_var(switch_index);
+	unsigned int const nr_ctrs = model->num_hardware_counters;
+	struct op_msr *counters = &msrs->counters[si];
+	unsigned int i;
+
+	for (i = 0; i < nr_ctrs; ++i) {
+		int offset = i + si;
+		if (counters[offset].addr) {
+			wrmsr(counters[offset].addr,
+				counters[offset].multiplex.low,
+				counters[offset].multiplex.high);
+		}
+	}
+}
+
+static void nmi_cpu_restore_registers(struct op_msrs *msrs)
 {
 	unsigned int const nr_ctrs = model->num_counters;
 	unsigned int const nr_ctrls = model->num_controls;
@@ -265,7 +345,8 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTERR, v | APIC_LVT_MASKED);
 	apic_write(APIC_LVTPC, per_cpu(saved_lvtpc, cpu));
 	apic_write(APIC_LVTERR, v);
-	nmi_restore_registers(msrs);
+	nmi_cpu_restore_registers(msrs);
+	__get_cpu_var(switch_index) = 0;
 }
 
 static void nmi_shutdown(void)
@@ -328,6 +409,7 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 		oprofilefs_create_ulong(sb, dir, "unit_mask", &counter_config[i].unit_mask);
 		oprofilefs_create_ulong(sb, dir, "kernel", &counter_config[i].kernel);
 		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
+		counter_config[i].save_count_low = 0;
 	}
 
 	return 0;
@@ -455,12 +537,14 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	}
 
 	/* default values, can be overwritten by model */
+	__get_cpu_var(switch_index) = 0;
 	ops->create_files = nmi_create_files;
 	ops->setup = nmi_setup;
 	ops->shutdown = nmi_shutdown;
 	ops->start = nmi_start;
 	ops->stop = nmi_stop;
 	ops->cpu_type = cpu_type;
+	ops->switch_events = nmi_switch_event;
 
 	if (model->init)
 		ret = model->init(ops);
diff --git a/arch/x86/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
index 2880b15..786d6e0 100644
--- a/arch/x86/oprofile/op_counter.h
+++ b/arch/x86/oprofile/op_counter.h
@@ -10,13 +10,14 @@
 #ifndef OP_COUNTER_H
 #define OP_COUNTER_H
  
-#define OP_MAX_COUNTER 8
+#define OP_MAX_COUNTER 32
  
 /* Per-perfctr configuration as set via
  * oprofilefs.
  */
 struct op_counter_config {
         unsigned long count;
+		unsigned long save_count_low;
         unsigned long enabled;
         unsigned long event;
         unsigned long kernel;
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index d9faf60..bbf2b68 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -15,6 +15,7 @@
 #include <linux/oprofile.h>
 #include <linux/device.h>
 #include <linux/pci.h>
+#include <linux/percpu.h>
 
 #include <asm/ptrace.h>
 #include <asm/msr.h>
@@ -23,8 +24,10 @@
 #include "op_x86_model.h"
 #include "op_counter.h"
 
-#define NUM_COUNTERS 4
-#define NUM_CONTROLS 4
+#define NUM_COUNTERS 32
+#define NUM_HARDWARE_COUNTERS 4
+#define NUM_CONTROLS 32
+#define NUM_HARDWARE_CONTROLS 4
 
 #define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
 #define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
@@ -48,6 +51,7 @@
 #define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
 static unsigned long reset_value[NUM_COUNTERS];
+DECLARE_PER_CPU(int, switch_index);
 
 #ifdef CONFIG_OPROFILE_IBS
 
@@ -130,15 +134,17 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i = 0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
+		int hw_counter = i % NUM_HARDWARE_COUNTERS;
+		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + hw_counter))
+			msrs->counters[i].addr = MSR_K7_PERFCTR0 + hw_counter;
 		else
 			msrs->counters[i].addr = 0;
 	}
 
 	for (i = 0; i < NUM_CONTROLS; i++) {
-		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
-			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		int hw_control = i % NUM_HARDWARE_CONTROLS;
+		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + hw_control))
+			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + hw_control;
 		else
 			msrs->controls[i].addr = 0;
 	}
@@ -150,8 +156,16 @@ static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
 	unsigned int low, high;
 	int i;
 
+	for (i = 0; i < NUM_HARDWARE_CONTROLS; ++i) {
+		int offset = i + __get_cpu_var(switch_index);
+		if (counter_config[offset].enabled)
+			reset_value[offset] = counter_config[offset].count;
+		else
+			reset_value[offset] = 0;
+	}
+
 	/* clear all counters */
-	for (i = 0 ; i < NUM_CONTROLS; ++i) {
+	for (i = 0 ; i < NUM_HARDWARE_CONTROLS; ++i) {
 		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
 			continue;
 		CTRL_READ(low, high, msrs, i);
@@ -161,34 +175,31 @@ static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
 	}
 
 	/* avoid a false detection of ctr overflows in NMI handler */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
+	for (i = 0; i < NUM_HARDWARE_COUNTERS; ++i) {
 		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
 			continue;
 		CTR_WRITE(1, msrs, i);
 	}
 
 	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
-			reset_value[i] = counter_config[i].count;
-
-			CTR_WRITE(counter_config[i].count, msrs, i);
+	for (i = 0; i < NUM_HARDWARE_COUNTERS; ++i) {
+		int offset = i + __get_cpu_var(switch_index);
+		if ((counter_config[offset].enabled) && (CTR_IS_RESERVED(msrs, i))) {
+			CTR_WRITE(counter_config[offset].count, msrs, i);
 
 			CTRL_READ(low, high, msrs, i);
 			CTRL_CLEAR_LO(low);
 			CTRL_CLEAR_HI(high);
 			CTRL_SET_ENABLE(low);
-			CTRL_SET_USR(low, counter_config[i].user);
-			CTRL_SET_KERN(low, counter_config[i].kernel);
-			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
-			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
+			CTRL_SET_USR(low, counter_config[offset].user);
+			CTRL_SET_KERN(low, counter_config[offset].kernel);
+			CTRL_SET_UM(low, counter_config[offset].unit_mask);
+			CTRL_SET_EVENT_LOW(low, counter_config[offset].event);
+			CTRL_SET_EVENT_HIGH(high, counter_config[offset].event);
 			CTRL_SET_HOST_ONLY(high, 0);
 			CTRL_SET_GUEST_ONLY(high, 0);
 
 			CTRL_WRITE(low, high, msrs, i);
-		} else {
-			reset_value[i] = 0;
 		}
 	}
 }
@@ -276,13 +287,14 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 	unsigned int low, high;
 	int i;
 
-	for (i = 0 ; i < NUM_COUNTERS; ++i) {
-		if (!reset_value[i])
+	for (i = 0 ; i < NUM_HARDWARE_COUNTERS ; ++i) {
+		int offset = i + __get_cpu_var(switch_index);
+		if (!reset_value[offset])
 			continue;
 		CTR_READ(low, high, msrs, i);
 		if (CTR_OVERFLOWED(low)) {
-			oprofile_add_sample(regs, i);
-			CTR_WRITE(reset_value[i], msrs, i);
+			oprofile_add_sample(regs, offset);
+			CTR_WRITE(reset_value[offset], msrs, i);
 		}
 	}
 
@@ -298,8 +310,10 @@ static void op_amd_start(struct op_msrs const * const msrs)
 {
 	unsigned int low, high;
 	int i;
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (reset_value[i]) {
+
+	for (i = 0 ; i < NUM_HARDWARE_COUNTERS ; ++i) {
+		int offset = i + __get_cpu_var(switch_index);
+		if (reset_value[offset]) {
 			CTRL_READ(low, high, msrs, i);
 			CTRL_SET_ACTIVE(low);
 			CTRL_WRITE(low, high, msrs, i);
@@ -329,8 +343,8 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 
 	/* Subtle: stop on all counters to avoid race with
 	 * setting our pm callback */
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (!reset_value[i])
+	for (i = 0 ; i < NUM_HARDWARE_COUNTERS ; ++i) {
+		if (!reset_value[i + per_cpu(switch_index, smp_processor_id())])
 			continue;
 		CTRL_READ(low, high, msrs, i);
 		CTRL_SET_INACTIVE(low);
@@ -356,11 +370,11 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+	for (i = 0 ; i < NUM_HARDWARE_COUNTERS ; ++i) {
 		if (CTR_IS_RESERVED(msrs, i))
 			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
 	}
-	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
+	for (i = 0 ; i < NUM_HARDWARE_COUNTERS ; ++i) {
 		if (CTRL_IS_RESERVED(msrs, i))
 			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
@@ -534,6 +548,8 @@ struct op_x86_model_spec const op_amd_spec = {
 	.exit = op_amd_exit,
 	.num_counters = NUM_COUNTERS,
 	.num_controls = NUM_CONTROLS,
+	.num_hardware_counters = NUM_HARDWARE_COUNTERS,
+	.num_hardware_controls = NUM_HARDWARE_CONTROLS,
 	.fill_in_addresses = &op_amd_fill_in_addresses,
 	.setup_ctrs = &op_amd_setup_ctrs,
 	.check_ctrs = &op_amd_check_ctrs,
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 56b4757..e641545 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -701,6 +701,8 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 struct op_x86_model_spec const op_p4_ht2_spec = {
 	.num_counters = NUM_COUNTERS_HT2,
 	.num_controls = NUM_CONTROLS_HT2,
+	.num_hardware_counters = NUM_COUNTERS_HT2,
+	.num_hardware_controls = NUM_CONTROLS_HT2,
 	.fill_in_addresses = &p4_fill_in_addresses,
 	.setup_ctrs = &p4_setup_ctrs,
 	.check_ctrs = &p4_check_ctrs,
@@ -713,6 +715,8 @@ struct op_x86_model_spec const op_p4_ht2_spec = {
 struct op_x86_model_spec const op_p4_spec = {
 	.num_counters = NUM_COUNTERS_NON_HT,
 	.num_controls = NUM_CONTROLS_NON_HT,
+	.num_hardware_counters = NUM_COUNTERS_NON_HT,
+	.num_hardware_controls = NUM_CONTROLS_NON_HT,
 	.fill_in_addresses = &p4_fill_in_addresses,
 	.setup_ctrs = &p4_setup_ctrs,
 	.check_ctrs = &p4_check_ctrs,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index eff431f..e5811aa 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -183,6 +183,8 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 struct op_x86_model_spec const op_ppro_spec = {
 	.num_counters = NUM_COUNTERS,
 	.num_controls = NUM_CONTROLS,
+	.num_hardware_counters = NUM_COUNTERS,
+	.num_hardware_controls = NUM_CONTROLS,
 	.fill_in_addresses = &ppro_fill_in_addresses,
 	.setup_ctrs = &ppro_setup_ctrs,
 	.check_ctrs = &ppro_check_ctrs,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 05a0261..e07ba10 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -19,6 +19,7 @@ struct op_saved_msr {
 struct op_msr {
 	unsigned long addr;
 	struct op_saved_msr saved;
+	struct op_saved_msr multiplex;
 };
 
 struct op_msrs {
@@ -34,6 +35,8 @@ struct pt_regs;
 struct op_x86_model_spec {
 	int (*init)(struct oprofile_operations *ops);
 	void (*exit)(void);
+	unsigned int const num_hardware_counters;
+	unsigned int const num_hardware_controls;
 	unsigned int const num_counters;
 	unsigned int const num_controls;
 	void (*fill_in_addresses)(struct op_msrs * const msrs);
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 2c64517..b2fa5df 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -12,6 +12,8 @@
 #include <linux/init.h>
 #include <linux/oprofile.h>
 #include <linux/moduleparam.h>
+#include <linux/workqueue.h>
+#include <linux/time.h>
 #include <asm/mutex.h>
 
 #include "oprof.h"
@@ -19,13 +21,18 @@
 #include "cpu_buffer.h"
 #include "buffer_sync.h"
 #include "oprofile_stats.h"
+
+static unsigned long is_setup;
+static void switch_worker(struct work_struct *work);
+static DECLARE_DELAYED_WORK(switch_work, switch_worker);
+static DEFINE_MUTEX(start_mutex);
  
 struct oprofile_operations oprofile_ops;
 
+unsigned long timeout_jiffies;
 unsigned long oprofile_started;
 unsigned long backtrace_depth;
-static unsigned long is_setup;
-static DEFINE_MUTEX(start_mutex);
+/* Multiplexing defaults at 1 msec*/
 
 /* timer
    0 - use performance monitoring hardware if available
@@ -87,6 +94,16 @@ out:
 	return err;
 }
 
+static void start_switch_worker(void)
+{
+	schedule_delayed_work(&switch_work, timeout_jiffies);
+}
+
+static void switch_worker(struct work_struct *work)
+{
+	if (!oprofile_ops.switch_events())
+		start_switch_worker();
+}
 
 /* Actually start profiling (echo 1>/dev/oprofile/enable) */
 int oprofile_start(void)
@@ -94,7 +111,6 @@ int oprofile_start(void)
 	int err = -EINVAL;
  
 	mutex_lock(&start_mutex);
- 
 	if (!is_setup)
 		goto out;
 
@@ -108,6 +124,9 @@ int oprofile_start(void)
 	if ((err = oprofile_ops.start()))
 		goto out;
 
+	if (oprofile_ops.switch_events)
+		start_switch_worker();
+
 	oprofile_started = 1;
 out:
 	mutex_unlock(&start_mutex);
@@ -123,6 +142,7 @@ void oprofile_stop(void)
 		goto out;
 	oprofile_ops.stop();
 	oprofile_started = 0;
+	cancel_delayed_work_sync(&switch_work);
 	/* wake up the daemon to read what remains */
 	wake_up_buffer_waiter();
 out:
@@ -155,6 +175,32 @@ post_sync:
 	mutex_unlock(&start_mutex);
 }
 
+/* User inputs in ms, converts to jiffies */
+int oprofile_set_timeout(unsigned long val_msec)
+{
+	int err = 0;
+
+	mutex_lock(&start_mutex);
+
+	if (oprofile_started) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (!oprofile_ops.switch_events) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	timeout_jiffies = msecs_to_jiffies(val_msec);
+	if (timeout_jiffies == MAX_JIFFY_OFFSET)
+		timeout_jiffies = msecs_to_jiffies(1);
+
+out:
+	mutex_unlock(&start_mutex);
+	return err;
+
+}
 
 int oprofile_set_backtrace(unsigned long val)
 {
@@ -179,10 +225,16 @@ out:
 	return err;
 }
 
+static void __init oprofile_switch_timer_init(void)
+{
+	timeout_jiffies = msecs_to_jiffies(1);
+}
+
 static int __init oprofile_init(void)
 {
 	int err;
 
+	oprofile_switch_timer_init();
 	err = oprofile_arch_init(&oprofile_ops);
 
 	if (err < 0 || timer) {
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index 1832365..c4406a7 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -27,7 +27,8 @@ extern unsigned long fs_buffer_watershed;
 extern struct oprofile_operations oprofile_ops;
 extern unsigned long oprofile_started;
 extern unsigned long backtrace_depth;
- 
+extern unsigned long timeout_jiffies;
+
 struct super_block;
 struct dentry;
 
@@ -35,5 +36,6 @@ void oprofile_create_files(struct super_block * sb, struct dentry * root);
 void oprofile_timer_init(struct oprofile_operations * ops);
 
 int oprofile_set_backtrace(unsigned long depth);
+int oprofile_set_timeout(unsigned long time);
  
 #endif /* OPROF_H */
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index ef953ba..cc4f5a1 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -9,6 +9,7 @@
 
 #include <linux/fs.h>
 #include <linux/oprofile.h>
+#include <linux/jiffies.h>
 
 #include "event_buffer.h"
 #include "oprofile_stats.h"
@@ -18,6 +19,40 @@ unsigned long fs_buffer_size = 131072;
 unsigned long fs_cpu_buffer_size = 8192;
 unsigned long fs_buffer_watershed = 32768; /* FIXME: tune */
 
+static ssize_t timeout_read(struct file *file, char __user *buf,
+		size_t count, loff_t *offset)
+{
+	return oprofilefs_ulong_to_user(jiffies_to_msecs(timeout_jiffies),
+				buf, count, offset);
+}
+
+
+static ssize_t timeout_write(struct file *file, char const __user *buf,
+		size_t count, loff_t *offset)
+{
+	unsigned long val;
+	int retval;
+
+	if (*offset)
+		return -EINVAL;
+
+	retval = oprofilefs_ulong_from_user(&val, buf, count);
+	if (retval)
+		return retval;
+
+	retval = oprofile_set_timeout(val);
+
+	if (retval)
+		return retval;
+	return count;
+}
+
+static const struct file_operations timeout_fops = {
+	.read		= timeout_read,
+	.write		= timeout_write,
+};
+
+
 static ssize_t depth_read(struct file * file, char __user * buf, size_t count, loff_t * offset)
 {
 	return oprofilefs_ulong_to_user(backtrace_depth, buf, count, offset);
@@ -85,11 +120,10 @@ static ssize_t enable_write(struct file * file, char const __user * buf, size_t
 
 	if (*offset)
 		return -EINVAL;
-
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;
- 
+
 	if (val)
 		retval = oprofile_start();
 	else
@@ -129,6 +163,7 @@ void oprofile_create_files(struct super_block * sb, struct dentry * root)
 	oprofilefs_create_file(sb, root, "cpu_type", &cpu_type_fops); 
 	oprofilefs_create_file(sb, root, "backtrace_depth", &depth_fops);
 	oprofilefs_create_file(sb, root, "pointer_size", &pointer_size_fops);
+	oprofilefs_create_file(sb, root, "timeout_ms", &timeout_fops);
 	oprofile_create_stats_files(sb, root);
 	if (oprofile_ops.create_files)
 		oprofile_ops.create_files(sb, root);
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index bcb8f72..687f2f4 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -67,6 +67,9 @@ struct oprofile_operations {
 
 	/* Initiate a stack backtrace. Optional. */
 	void (*backtrace)(struct pt_regs * const regs, unsigned int depth);
+
+	/* Multiplex between different events. Optional. */
+	int (*switch_events)(void);
 	/* CPU identification string. */
 	char * cpu_type;
 };
-- 
1.5.5.4


