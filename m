Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZG1RS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZG1RS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZG1RS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:57 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:3126 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755112AbZG1RSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:42 -0400
X-SpamScore: -1
X-BigFish: VPS-1(zz541Lzz1202hzzz32i87h203h43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DM-03-BLU-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Jason Yeh <jason.yeh@amd.com>, Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/26] oprofile: Implement performance counter multiplexing
Date: Tue, 28 Jul 2009 19:07:03 +0200
Message-ID: <1248800846-25422-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:47.0869 (UTC) FILETIME=[541E08D0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Yeh <jason.yeh@amd.com>

The number of hardware counters is limited. The multiplexing feature
enables OProfile to gather more events than counters are provided by
the hardware. This is realized by switching between events at an user
specified time interval.

A new file (/dev/oprofile/time_slice) is added for the user to specify
the timer interval in ms. If the number of events to profile is higher
than the number of hardware counters available, the patch will
schedule a work queue that switches the event counter and re-writes
the different sets of values into it. The switching mechanism needs to
be implemented for each architecture to support multiplexing. This
patch only implements AMD CPU support, but multiplexing can be easily
extended for other models and architectures.

There are follow-on patches that rework parts of this patch.

Signed-off-by: Jason Yeh <jason.yeh@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/Kconfig                      |   12 +++
 arch/x86/oprofile/nmi_int.c       |  162 +++++++++++++++++++++++++++++++++++-
 arch/x86/oprofile/op_counter.h    |    2 +-
 arch/x86/oprofile/op_model_amd.c  |  110 ++++++++++++++++++++++---
 arch/x86/oprofile/op_model_p4.c   |    4 +
 arch/x86/oprofile/op_model_ppro.c |    2 +
 arch/x86/oprofile/op_x86_model.h  |    7 ++
 drivers/oprofile/oprof.c          |   78 ++++++++++++++++++
 drivers/oprofile/oprof.h          |    2 +
 drivers/oprofile/oprofile_files.c |   43 ++++++++++
 drivers/oprofile/oprofile_stats.c |   10 +++
 include/linux/oprofile.h          |    3 +
 12 files changed, 415 insertions(+), 20 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 99193b1..beea3cc 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -30,6 +30,18 @@ config OPROFILE_IBS
 
 	  If unsure, say N.
 
+config OPROFILE_EVENT_MULTIPLEX
+	bool "OProfile multiplexing support (EXPERIMENTAL)"
+	default n
+	depends on OPROFILE && X86
+	help
+	  The number of hardware counters is limited. The multiplexing
+	  feature enables OProfile to gather more events than counters
+	  are provided by the hardware. This is realized by switching
+	  between events at an user specified time interval.
+
+	  If unsure, say N.
+
 config HAVE_OPROFILE
 	bool
 
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index fca8dc9..e54f6a0 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -1,11 +1,14 @@
 /**
  * @file nmi_int.c
  *
- * @remark Copyright 2002-2008 OProfile authors
+ * @remark Copyright 2002-2009 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
  * @author Robert Richter <robert.richter@amd.com>
+ * @author Barry Kasindorf <barry.kasindorf@amd.com>
+ * @author Jason Yeh <jason.yeh@amd.com>
+ * @author Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
  */
 
 #include <linux/init.h>
@@ -24,6 +27,12 @@
 #include "op_counter.h"
 #include "op_x86_model.h"
 
+
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+DEFINE_PER_CPU(int, switch_index);
+#endif
+
+
 static struct op_x86_model_spec const *model;
 static DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
 static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
@@ -31,6 +40,13 @@ static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
 
+
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+extern atomic_t multiplex_counter;
+#endif
+
+struct op_counter_config counter_config[OP_MAX_COUNTER];
+
 /* common functions */
 
 u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
@@ -95,6 +111,11 @@ static void free_msrs(void)
 		per_cpu(cpu_msrs, i).counters = NULL;
 		kfree(per_cpu(cpu_msrs, i).controls);
 		per_cpu(cpu_msrs, i).controls = NULL;
+
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+		kfree(per_cpu(cpu_msrs, i).multiplex);
+		per_cpu(cpu_msrs, i).multiplex = NULL;
+#endif
 	}
 }
 
@@ -103,6 +124,9 @@ static int allocate_msrs(void)
 	int success = 1;
 	size_t controls_size = sizeof(struct op_msr) * model->num_controls;
 	size_t counters_size = sizeof(struct op_msr) * model->num_counters;
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	size_t multiplex_size = sizeof(struct op_msr) * model->num_virt_counters;
+#endif
 
 	int i;
 	for_each_possible_cpu(i) {
@@ -118,6 +142,14 @@ static int allocate_msrs(void)
 			success = 0;
 			break;
 		}
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+		per_cpu(cpu_msrs, i).multiplex =
+				kmalloc(multiplex_size, GFP_KERNEL);
+		if (!per_cpu(cpu_msrs, i).multiplex) {
+			success = 0;
+			break;
+		}
+#endif
 	}
 
 	if (!success)
@@ -126,6 +158,25 @@ static int allocate_msrs(void)
 	return success;
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void nmi_setup_cpu_mux(struct op_msrs const * const msrs)
+{
+	int i;
+	struct op_msr *multiplex = msrs->multiplex;
+
+	for (i = 0; i < model->num_virt_counters; ++i) {
+		if (counter_config[i].enabled) {
+			multiplex[i].saved = -(u64)counter_config[i].count;
+		} else {
+			multiplex[i].addr  = 0;
+			multiplex[i].saved = 0;
+		}
+	}
+}
+
+#endif
+
 static void nmi_cpu_setup(void *dummy)
 {
 	int cpu = smp_processor_id();
@@ -133,6 +184,9 @@ static void nmi_cpu_setup(void *dummy)
 	nmi_cpu_save_registers(msrs);
 	spin_lock(&oprofilefs_lock);
 	model->setup_ctrs(model, msrs);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	nmi_setup_cpu_mux(msrs);
+#endif
 	spin_unlock(&oprofilefs_lock);
 	per_cpu(saved_lvtpc, cpu) = apic_read(APIC_LVTPC);
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
@@ -173,14 +227,52 @@ static int nmi_setup(void)
 			memcpy(per_cpu(cpu_msrs, cpu).controls,
 				per_cpu(cpu_msrs, 0).controls,
 				sizeof(struct op_msr) * model->num_controls);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+			memcpy(per_cpu(cpu_msrs, cpu).multiplex,
+				per_cpu(cpu_msrs, 0).multiplex,
+				sizeof(struct op_msr) * model->num_virt_counters);
+#endif
 		}
-
 	}
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
 	return 0;
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs)
+{
+	unsigned int si = __get_cpu_var(switch_index);
+	struct op_msr *multiplex = msrs->multiplex;
+	unsigned int i;
+
+	for (i = 0; i < model->num_counters; ++i) {
+		int offset = i + si;
+		if (multiplex[offset].addr) {
+			rdmsrl(multiplex[offset].addr,
+			       multiplex[offset].saved);
+		}
+	}
+}
+
+static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
+{
+	unsigned int si = __get_cpu_var(switch_index);
+	struct op_msr *multiplex = msrs->multiplex;
+	unsigned int i;
+
+	for (i = 0; i < model->num_counters; ++i) {
+		int offset = i + si;
+		if (multiplex[offset].addr) {
+			wrmsrl(multiplex[offset].addr,
+			       multiplex[offset].saved);
+		}
+	}
+}
+
+#endif
+
 static void nmi_cpu_restore_registers(struct op_msrs *msrs)
 {
 	struct op_msr *counters = msrs->counters;
@@ -214,6 +306,9 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTPC, per_cpu(saved_lvtpc, cpu));
 	apic_write(APIC_LVTERR, v);
 	nmi_cpu_restore_registers(msrs);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	__get_cpu_var(switch_index) = 0;
+#endif
 }
 
 static void nmi_shutdown(void)
@@ -252,16 +347,15 @@ static void nmi_stop(void)
 	on_each_cpu(nmi_cpu_stop, NULL, 1);
 }
 
-struct op_counter_config counter_config[OP_MAX_COUNTER];
-
 static int nmi_create_files(struct super_block *sb, struct dentry *root)
 {
 	unsigned int i;
 
-	for (i = 0; i < model->num_counters; ++i) {
+	for (i = 0; i < model->num_virt_counters; ++i) {
 		struct dentry *dir;
 		char buf[4];
 
+#ifndef CONFIG_OPROFILE_EVENT_MULTIPLEX
 		/* quick little hack to _not_ expose a counter if it is not
 		 * available for use.  This should protect userspace app.
 		 * NOTE:  assumes 1:1 mapping here (that counters are organized
@@ -269,6 +363,7 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 		 */
 		if (unlikely(!avail_to_resrv_perfctr_nmi_bit(i)))
 			continue;
+#endif /* CONFIG_OPROFILE_EVENT_MULTIPLEX */
 
 		snprintf(buf,  sizeof(buf), "%d", i);
 		dir = oprofilefs_mkdir(sb, root, buf);
@@ -283,6 +378,57 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 	return 0;
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
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
+	si += model->num_counters;
+	if ((si > model->num_virt_counters) || (counter_config[si].count == 0))
+		per_cpu(switch_index, cpu) = 0;
+	else
+		per_cpu(switch_index, cpu) = si;
+
+	model->switch_ctrl(model, msrs);
+	nmi_cpu_restore_mpx_registers(msrs);
+
+	nmi_cpu_start(NULL);
+}
+
+
+/*
+ * Quick check to see if multiplexing is necessary.
+ * The check should be sufficient since counters are used
+ * in ordre.
+ */
+static int nmi_multiplex_on(void)
+{
+	return counter_config[model->num_counters].count ? 0 : -EINVAL;
+}
+
+static int nmi_switch_event(void)
+{
+	if (!model->switch_ctrl)
+		return -ENOSYS;		/* not implemented */
+	if (nmi_multiplex_on() < 0)
+		return -EINVAL;		/* not necessary */
+
+	on_each_cpu(nmi_cpu_switch, NULL, 1);
+
+	atomic_inc(&multiplex_counter);
+
+	return 0;
+}
+
+#endif
+
 #ifdef CONFIG_SMP
 static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
 				 void *data)
@@ -516,12 +662,18 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	register_cpu_notifier(&oprofile_cpu_nb);
 #endif
 	/* default values, can be overwritten by model */
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	__raw_get_cpu_var(switch_index) = 0;
+#endif
 	ops->create_files	= nmi_create_files;
 	ops->setup		= nmi_setup;
 	ops->shutdown		= nmi_shutdown;
 	ops->start		= nmi_start;
 	ops->stop		= nmi_stop;
 	ops->cpu_type		= cpu_type;
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	ops->switch_events	= nmi_switch_event;
+#endif
 
 	if (model->init)
 		ret = model->init(ops);
diff --git a/arch/x86/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
index 91b6a11..e28398d 100644
--- a/arch/x86/oprofile/op_counter.h
+++ b/arch/x86/oprofile/op_counter.h
@@ -10,7 +10,7 @@
 #ifndef OP_COUNTER_H
 #define OP_COUNTER_H
 
-#define OP_MAX_COUNTER 8
+#define OP_MAX_COUNTER 32
 
 /* Per-perfctr configuration as set via
  * oprofilefs.
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index f676f88..fdbed3a 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -9,12 +9,15 @@
  * @author Philippe Elie
  * @author Graydon Hoare
  * @author Robert Richter <robert.richter@amd.com>
- * @author Barry Kasindorf
+ * @author Barry Kasindorf <barry.kasindorf@amd.com>
+ * @author Jason Yeh <jason.yeh@amd.com>
+ * @author Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
  */
 
 #include <linux/oprofile.h>
 #include <linux/device.h>
 #include <linux/pci.h>
+#include <linux/percpu.h>
 
 #include <asm/ptrace.h>
 #include <asm/msr.h>
@@ -25,12 +28,23 @@
 
 #define NUM_COUNTERS 4
 #define NUM_CONTROLS 4
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+#define NUM_VIRT_COUNTERS 32
+#define NUM_VIRT_CONTROLS 32
+#else
+#define NUM_VIRT_COUNTERS NUM_COUNTERS
+#define NUM_VIRT_CONTROLS NUM_CONTROLS
+#endif
+
 #define OP_EVENT_MASK			0x0FFF
 #define OP_CTR_OVERFLOW			(1ULL<<31)
 
 #define MSR_AMD_EVENTSEL_RESERVED	((0xFFFFFCF0ULL<<32)|(1ULL<<21))
 
-static unsigned long reset_value[NUM_COUNTERS];
+static unsigned long reset_value[NUM_VIRT_COUNTERS];
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+DECLARE_PER_CPU(int, switch_index);
+#endif
 
 #ifdef CONFIG_OPROFILE_IBS
 
@@ -82,6 +96,16 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 		else
 			msrs->controls[i].addr = 0;
 	}
+
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	for (i = 0; i < NUM_VIRT_COUNTERS; i++) {
+		int hw_counter = i % NUM_CONTROLS;
+		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+			msrs->multiplex[i].addr = MSR_K7_PERFCTR0 + hw_counter;
+		else
+			msrs->multiplex[i].addr = 0;
+	}
+#endif
 }
 
 static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
@@ -90,6 +114,15 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	u64 val;
 	int i;
 
+	/* setup reset_value */
+	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
+		if (counter_config[i].enabled) {
+			reset_value[i] = counter_config[i].count;
+		} else {
+			reset_value[i] = 0;
+		}
+	}
+
 	/* clear all counters */
 	for (i = 0; i < NUM_CONTROLS; ++i) {
 		if (unlikely(!msrs->controls[i].addr))
@@ -108,20 +141,49 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (counter_config[i].enabled && msrs->counters[i].addr) {
-			reset_value[i] = counter_config[i].count;
-			wrmsrl(msrs->counters[i].addr,
-			       -(u64)counter_config[i].count);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+		int offset = i + __get_cpu_var(switch_index);
+#else
+		int offset = i;
+#endif
+		if (counter_config[offset].enabled && msrs->counters[i].addr) {
+			/* setup counter registers */
+			wrmsrl(msrs->counters[i].addr, -(u64)reset_value[offset]);
+
+			/* setup control registers */
 			rdmsrl(msrs->controls[i].addr, val);
 			val &= model->reserved;
-			val |= op_x86_get_ctrl(model, &counter_config[i]);
+			val |= op_x86_get_ctrl(model, &counter_config[offset]);
+			wrmsrl(msrs->controls[i].addr, val);
+		}
+	}
+}
+
+
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void op_amd_switch_ctrl(struct op_x86_model_spec const *model,
+			       struct op_msrs const * const msrs)
+{
+	u64 val;
+	int i;
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int offset = i + __get_cpu_var(switch_index);
+		if (counter_config[offset].enabled) {
+			/* setup control registers */
+			rdmsrl(msrs->controls[i].addr, val);
+			val &= model->reserved;
+			val |= op_x86_get_ctrl(model, &counter_config[offset]);
 			wrmsrl(msrs->controls[i].addr, val);
-		} else {
-			reset_value[i] = 0;
 		}
 	}
 }
 
+#endif
+
+
 #ifdef CONFIG_OPROFILE_IBS
 
 static inline int
@@ -230,14 +292,19 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 	int i;
 
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (!reset_value[i])
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+		int offset = i + __get_cpu_var(switch_index);
+#else
+		int offset = i;
+#endif
+		if (!reset_value[offset])
 			continue;
 		rdmsrl(msrs->counters[i].addr, val);
 		/* bit is clear if overflowed: */
 		if (val & OP_CTR_OVERFLOW)
 			continue;
-		oprofile_add_sample(regs, i);
-		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[i]);
+		oprofile_add_sample(regs, offset);
+		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[offset]);
 	}
 
 	op_amd_handle_ibs(regs, msrs);
@@ -250,8 +317,14 @@ static void op_amd_start(struct op_msrs const * const msrs)
 {
 	u64 val;
 	int i;
+
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (reset_value[i]) {
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+		int offset = i + __get_cpu_var(switch_index);
+#else
+		int offset = i;
+#endif
+		if (reset_value[offset]) {
 			rdmsrl(msrs->controls[i].addr, val);
 			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 			wrmsrl(msrs->controls[i].addr, val);
@@ -271,7 +344,11 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	 * pm callback
 	 */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+		if (!reset_value[i + per_cpu(switch_index, smp_processor_id())])
+#else
 		if (!reset_value[i])
+#endif
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
 		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
@@ -289,7 +366,7 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
 	}
-	for (i = 0; i < NUM_CONTROLS; ++i) {
+	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (msrs->controls[i].addr)
 			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
@@ -463,6 +540,8 @@ static void op_amd_exit(void) {}
 struct op_x86_model_spec const op_amd_spec = {
 	.num_counters		= NUM_COUNTERS,
 	.num_controls		= NUM_CONTROLS,
+	.num_virt_counters	= NUM_VIRT_COUNTERS,
+	.num_virt_controls	= NUM_VIRT_CONTROLS,
 	.reserved		= MSR_AMD_EVENTSEL_RESERVED,
 	.event_mask		= OP_EVENT_MASK,
 	.init			= op_amd_init,
@@ -473,4 +552,7 @@ struct op_x86_model_spec const op_amd_spec = {
 	.start			= &op_amd_start,
 	.stop			= &op_amd_stop,
 	.shutdown		= &op_amd_shutdown,
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	.switch_ctrl		= &op_amd_switch_ctrl,
+#endif
 };
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 5921b7f..65b9237 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -698,6 +698,8 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 struct op_x86_model_spec const op_p4_ht2_spec = {
 	.num_counters		= NUM_COUNTERS_HT2,
 	.num_controls		= NUM_CONTROLS_HT2,
+	.num_virt_counters	= NUM_COUNTERS_HT2,
+	.num_virt_controls	= NUM_CONTROLS_HT2,
 	.fill_in_addresses	= &p4_fill_in_addresses,
 	.setup_ctrs		= &p4_setup_ctrs,
 	.check_ctrs		= &p4_check_ctrs,
@@ -710,6 +712,8 @@ struct op_x86_model_spec const op_p4_ht2_spec = {
 struct op_x86_model_spec const op_p4_spec = {
 	.num_counters		= NUM_COUNTERS_NON_HT,
 	.num_controls		= NUM_CONTROLS_NON_HT,
+	.num_virt_counters	= NUM_COUNTERS_NON_HT,
+	.num_virt_controls	= NUM_CONTROLS_NON_HT,
 	.fill_in_addresses	= &p4_fill_in_addresses,
 	.setup_ctrs		= &p4_setup_ctrs,
 	.check_ctrs		= &p4_check_ctrs,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 570d717..098cbca 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -206,6 +206,8 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 struct op_x86_model_spec const op_ppro_spec = {
 	.num_counters		= 2,
 	.num_controls		= 2,
+	.num_virt_counters	= 2,
+	.num_virt_controls	= 2,
 	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
 	.fill_in_addresses	= &ppro_fill_in_addresses,
 	.setup_ctrs		= &ppro_setup_ctrs,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 5054898..0d07d23 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -23,6 +23,7 @@ struct op_msr {
 struct op_msrs {
 	struct op_msr *counters;
 	struct op_msr *controls;
+	struct op_msr *multiplex;
 };
 
 struct pt_regs;
@@ -35,6 +36,8 @@ struct oprofile_operations;
 struct op_x86_model_spec {
 	unsigned int	num_counters;
 	unsigned int	num_controls;
+	unsigned int	num_virt_counters;
+	unsigned int	num_virt_controls;
 	u64		reserved;
 	u16		event_mask;
 	int		(*init)(struct oprofile_operations *ops);
@@ -47,6 +50,10 @@ struct op_x86_model_spec {
 	void		(*start)(struct op_msrs const * const msrs);
 	void		(*stop)(struct op_msrs const * const msrs);
 	void		(*shutdown)(struct op_msrs const * const msrs);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	void		(*switch_ctrl)(struct op_x86_model_spec const *model,
+				       struct op_msrs const * const msrs);
+#endif
 };
 
 struct op_counter_config;
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 3cffce9..7bc64af 100644
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
@@ -27,6 +29,15 @@ unsigned long oprofile_backtrace_depth;
 static unsigned long is_setup;
 static DEFINE_MUTEX(start_mutex);
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void switch_worker(struct work_struct *work);
+static DECLARE_DELAYED_WORK(switch_work, switch_worker);
+unsigned long timeout_jiffies;
+#define MULTIPLEXING_TIMER_DEFAULT 1
+
+#endif
+
 /* timer
    0 - use performance monitoring hardware if available
    1 - use the timer int mechanism regardless
@@ -87,6 +98,20 @@ out:
 	return err;
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
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
+
+#endif
 
 /* Actually start profiling (echo 1>/dev/oprofile/enable) */
 int oprofile_start(void)
@@ -108,6 +133,11 @@ int oprofile_start(void)
 	if ((err = oprofile_ops.start()))
 		goto out;
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	if (oprofile_ops.switch_events)
+		start_switch_worker();
+#endif
+
 	oprofile_started = 1;
 out:
 	mutex_unlock(&start_mutex);
@@ -123,6 +153,11 @@ void oprofile_stop(void)
 		goto out;
 	oprofile_ops.stop();
 	oprofile_started = 0;
+
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	cancel_delayed_work_sync(&switch_work);
+#endif
+
 	/* wake up the daemon to read what remains */
 	wake_up_buffer_waiter();
 out:
@@ -155,6 +190,36 @@ post_sync:
 	mutex_unlock(&start_mutex);
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
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
+		timeout_jiffies = msecs_to_jiffies(MULTIPLEXING_TIMER_DEFAULT);
+
+out:
+	mutex_unlock(&start_mutex);
+	return err;
+
+}
+
+#endif
 
 int oprofile_set_backtrace(unsigned long val)
 {
@@ -179,10 +244,23 @@ out:
 	return err;
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void __init oprofile_multiplexing_init(void)
+{
+	timeout_jiffies = msecs_to_jiffies(MULTIPLEXING_TIMER_DEFAULT);
+}
+
+#endif
+
 static int __init oprofile_init(void)
 {
 	int err;
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	oprofile_multiplexing_init();
+#endif
+
 	err = oprofile_arch_init(&oprofile_ops);
 
 	if (err < 0 || timer) {
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index c288d3c..ee38abc 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -27,6 +27,7 @@ extern unsigned long oprofile_buffer_watershed;
 extern struct oprofile_operations oprofile_ops;
 extern unsigned long oprofile_started;
 extern unsigned long oprofile_backtrace_depth;
+extern unsigned long timeout_jiffies;
 
 struct super_block;
 struct dentry;
@@ -35,5 +36,6 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root);
 void oprofile_timer_init(struct oprofile_operations *ops);
 
 int oprofile_set_backtrace(unsigned long depth);
+int oprofile_set_timeout(unsigned long time);
 
 #endif /* OPROF_H */
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index 5d36ffc..468ec3e 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -9,6 +9,7 @@
 
 #include <linux/fs.h>
 #include <linux/oprofile.h>
+#include <linux/jiffies.h>
 
 #include "event_buffer.h"
 #include "oprofile_stats.h"
@@ -22,6 +23,45 @@ unsigned long oprofile_buffer_size;
 unsigned long oprofile_cpu_buffer_size;
 unsigned long oprofile_buffer_watershed;
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
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
+
+static const struct file_operations timeout_fops = {
+	.read		= timeout_read,
+	.write		= timeout_write,
+};
+
+#endif
+
+
 static ssize_t depth_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
 	return oprofilefs_ulong_to_user(oprofile_backtrace_depth, buf, count,
@@ -139,6 +179,9 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root)
 	oprofilefs_create_file(sb, root, "cpu_type", &cpu_type_fops);
 	oprofilefs_create_file(sb, root, "backtrace_depth", &depth_fops);
 	oprofilefs_create_file(sb, root, "pointer_size", &pointer_size_fops);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	oprofilefs_create_file(sb, root, "time_slice", &timeout_fops);
+#endif
 	oprofile_create_stats_files(sb, root);
 	if (oprofile_ops.create_files)
 		oprofile_ops.create_files(sb, root);
diff --git a/drivers/oprofile/oprofile_stats.c b/drivers/oprofile/oprofile_stats.c
index 3c2270a..77a57a6 100644
--- a/drivers/oprofile/oprofile_stats.c
+++ b/drivers/oprofile/oprofile_stats.c
@@ -16,6 +16,9 @@
 #include "cpu_buffer.h"
 
 struct oprofile_stat_struct oprofile_stats;
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+atomic_t multiplex_counter;
+#endif
 
 void oprofile_reset_stats(void)
 {
@@ -34,6 +37,9 @@ void oprofile_reset_stats(void)
 	atomic_set(&oprofile_stats.sample_lost_no_mapping, 0);
 	atomic_set(&oprofile_stats.event_lost_overflow, 0);
 	atomic_set(&oprofile_stats.bt_lost_no_mapping, 0);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	atomic_set(&multiplex_counter, 0);
+#endif
 }
 
 
@@ -76,4 +82,8 @@ void oprofile_create_stats_files(struct super_block *sb, struct dentry *root)
 		&oprofile_stats.event_lost_overflow);
 	oprofilefs_create_ro_atomic(sb, dir, "bt_lost_no_mapping",
 		&oprofile_stats.bt_lost_no_mapping);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	oprofilefs_create_ro_atomic(sb, dir, "multiplex_counter",
+		&multiplex_counter);
+#endif
 }
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index d68d2ed..5171639 100644
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
1.6.3.3


