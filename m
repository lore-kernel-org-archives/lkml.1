Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZG1RSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZG1RSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbZG1RSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:42 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:30130 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753605AbZG1RSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:13 -0400
X-SpamScore: 7
X-BigFish: VPS7(zz541L78fbpzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DK-04-A2E-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/26] oprofile: Performance counter multiplexing
Date: Tue, 28 Jul 2009 19:07:00 +0200
Message-ID: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 28 Jul 2009 17:17:47.0197 (UTC) FILETIME=[53B77ED0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces performance counter multiplexing for
oprofile. 

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
patch series only implements AMD CPU support, but multiplexing can be
easily extended for other models and architectures.

The patch set includes the initial patch from Jason Yeh and many code
improvements and reworks on top. It evolved over time and documents
its development. Thus, for review also the enclosed overall diff might
be useful.

The patches can be pulled from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git mux

-Robert


The following changes since commit 8045a4c293d36c61656a20d581b11f7f0cd7acd5:
  Robert Richter (1):
        x86/oprofile: Fix cast of counter value

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git mux

Jason Yeh (1):
      oprofile: Implement performance counter multiplexing

Robert Richter (25):
      x86/oprofile: Rework and simplify nmi_cpu_setup()
      x86/oprofile: Whitespaces changes only
      x86/oprofile: Fix usage of NUM_CONTROLS/NUM_COUNTERS macros
      x86/oprofile: Use per_cpu() instead of __get_cpu_var()
      x86/oprofile: Fix initialization of switch_index
      oprofile: oprofile_set_timeout(), return with error for invalid args
      oprofile: Rename variable timeout_jiffies and move to oprofile_files.c
      oprofile: Remove oprofile_multiplexing_init()
      oprofile: Grouping multiplexing code in oprof.c
      oprofile: Introduce op_x86_phys_to_virt()
      oprofile: Grouping multiplexing code in op_model_amd.c
      x86/oprofile: Implement multiplexing setup/shutdown functions
      x86/oprofile: Moving nmi_setup_cpu_mux() in nmi_int.c
      x86/oprofile: Moving nmi_cpu_save/restore_mpx_registers() in nmi_int.c
      x86/oprofile: Moving nmi_cpu_switch() in nmi_int.c
      x86/oprofile: Remove const qualifier from struct op_x86_model_spec
      x86/oprofile: Remove unused num_virt_controls from struct op_x86_model_spec
      x86/oprofile: Modify initialization of num_virt_counters
      x86/oprofile: Add function has_mux() to check multiplexing support
      x86/oprofile: Enable multiplexing only if the model supports it
      x86/oprofile: Implement mux_clone()
      oprofile: Adding switch counter to oprofile statistic variables
      x86/oprofile: Implement op_x86_virt_to_phys()
      x86/oprofile: Add counter reservation check for virtual counters
      x86/oprofile: Small coding style fixes

 arch/Kconfig                      |   12 ++
 arch/x86/oprofile/nmi_int.c       |  307 +++++++++++++++++++++++++++++--------
 arch/x86/oprofile/op_counter.h    |    2 +-
 arch/x86/oprofile/op_model_amd.c  |  127 ++++++++++++----
 arch/x86/oprofile/op_model_p4.c   |   12 +-
 arch/x86/oprofile/op_model_ppro.c |   10 +-
 arch/x86/oprofile/op_x86_model.h  |   16 ++-
 drivers/oprofile/oprof.c          |   71 +++++++++-
 drivers/oprofile/oprof.h          |    3 +
 drivers/oprofile/oprofile_files.c |   46 ++++++
 drivers/oprofile/oprofile_stats.c |    5 +
 drivers/oprofile/oprofile_stats.h |    1 +
 include/linux/oprofile.h          |    3 +
 13 files changed, 501 insertions(+), 114 deletions(-)

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
index 93df76d..cb88b1a 100644
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
@@ -24,13 +27,15 @@
 #include "op_counter.h"
 #include "op_x86_model.h"
 
-static struct op_x86_model_spec const *model;
+static struct op_x86_model_spec *model;
 static DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
 static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
 
+struct op_counter_config counter_config[OP_MAX_COUNTER];
+
 /* common functions */
 
 u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
@@ -87,13 +92,199 @@ static void nmi_cpu_save_registers(struct op_msrs *msrs)
 	}
 }
 
-static void nmi_save_registers(void *dummy)
+static void nmi_cpu_start(void *dummy)
+{
+	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
+	model->start(msrs);
+}
+
+static int nmi_start(void)
+{
+	on_each_cpu(nmi_cpu_start, NULL, 1);
+	return 0;
+}
+
+static void nmi_cpu_stop(void *dummy)
+{
+	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
+	model->stop(msrs);
+}
+
+static void nmi_stop(void)
+{
+	on_each_cpu(nmi_cpu_stop, NULL, 1);
+}
+
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static DEFINE_PER_CPU(int, switch_index);
+
+static inline int has_mux(void)
+{
+	return !!model->switch_ctrl;
+}
+
+inline int op_x86_phys_to_virt(int phys)
+{
+	return __get_cpu_var(switch_index) + phys;
+}
+
+inline int op_x86_virt_to_phys(int virt)
+{
+	return virt % model->num_counters;
+}
+
+static void nmi_shutdown_mux(void)
+{
+	int i;
+
+	if (!has_mux())
+		return;
+
+	for_each_possible_cpu(i) {
+		kfree(per_cpu(cpu_msrs, i).multiplex);
+		per_cpu(cpu_msrs, i).multiplex = NULL;
+		per_cpu(switch_index, i) = 0;
+	}
+}
+
+static int nmi_setup_mux(void)
+{
+	size_t multiplex_size =
+		sizeof(struct op_msr) * model->num_virt_counters;
+	int i;
+
+	if (!has_mux())
+		return 1;
+
+	for_each_possible_cpu(i) {
+		per_cpu(cpu_msrs, i).multiplex =
+			kmalloc(multiplex_size, GFP_KERNEL);
+		if (!per_cpu(cpu_msrs, i).multiplex)
+			return 0;
+	}
+
+	return 1;
+}
+
+static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
+{
+	int i;
+	struct op_msr *multiplex = msrs->multiplex;
+
+	if (!has_mux())
+		return;
+
+	for (i = 0; i < model->num_virt_counters; ++i) {
+		if (counter_config[i].enabled) {
+			multiplex[i].saved = -(u64)counter_config[i].count;
+		} else {
+			multiplex[i].addr  = 0;
+			multiplex[i].saved = 0;
+		}
+	}
+
+	per_cpu(switch_index, cpu) = 0;
+}
+
+static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs)
+{
+	struct op_msr *multiplex = msrs->multiplex;
+	int i;
+
+	for (i = 0; i < model->num_counters; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (multiplex[virt].addr)
+			rdmsrl(multiplex[virt].addr, multiplex[virt].saved);
+	}
+}
+
+static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
+{
+	struct op_msr *multiplex = msrs->multiplex;
+	int i;
+
+	for (i = 0; i < model->num_counters; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (multiplex[virt].addr)
+			wrmsrl(multiplex[virt].addr, multiplex[virt].saved);
+	}
+}
+
+static void nmi_cpu_switch(void *dummy)
 {
 	int cpu = smp_processor_id();
+	int si = per_cpu(switch_index, cpu);
 	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
-	nmi_cpu_save_registers(msrs);
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
 }
 
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
+	if (!has_mux())
+		return -ENOSYS;		/* not implemented */
+	if (nmi_multiplex_on() < 0)
+		return -EINVAL;		/* not necessary */
+
+	on_each_cpu(nmi_cpu_switch, NULL, 1);
+
+	return 0;
+}
+
+static inline void mux_init(struct oprofile_operations *ops)
+{
+	if (has_mux())
+		ops->switch_events = nmi_switch_event;
+}
+
+static void mux_clone(int cpu)
+{
+	if (!has_mux())
+		return;
+
+	memcpy(per_cpu(cpu_msrs, cpu).multiplex,
+	       per_cpu(cpu_msrs, 0).multiplex,
+	       sizeof(struct op_msr) * model->num_virt_counters);
+}
+
+#else
+
+inline int op_x86_phys_to_virt(int phys) { return phys; }
+inline int op_x86_virt_to_phys(int virt) { return virt; }
+static inline void nmi_shutdown_mux(void) { }
+static inline int nmi_setup_mux(void) { return 1; }
+static inline void
+nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs) { }
+static inline void mux_init(struct oprofile_operations *ops) { }
+static void mux_clone(int cpu) { }
+
+#endif
+
 static void free_msrs(void)
 {
 	int i;
@@ -107,38 +298,32 @@ static void free_msrs(void)
 
 static int allocate_msrs(void)
 {
-	int success = 1;
 	size_t controls_size = sizeof(struct op_msr) * model->num_controls;
 	size_t counters_size = sizeof(struct op_msr) * model->num_counters;
 
 	int i;
 	for_each_possible_cpu(i) {
 		per_cpu(cpu_msrs, i).counters = kmalloc(counters_size,
-								GFP_KERNEL);
-		if (!per_cpu(cpu_msrs, i).counters) {
-			success = 0;
-			break;
-		}
+							GFP_KERNEL);
+		if (!per_cpu(cpu_msrs, i).counters)
+			return 0;
 		per_cpu(cpu_msrs, i).controls = kmalloc(controls_size,
-								GFP_KERNEL);
-		if (!per_cpu(cpu_msrs, i).controls) {
-			success = 0;
-			break;
-		}
+							GFP_KERNEL);
+		if (!per_cpu(cpu_msrs, i).controls)
+			return 0;
 	}
 
-	if (!success)
-		free_msrs();
-
-	return success;
+	return 1;
 }
 
 static void nmi_cpu_setup(void *dummy)
 {
 	int cpu = smp_processor_id();
 	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
+	nmi_cpu_save_registers(msrs);
 	spin_lock(&oprofilefs_lock);
 	model->setup_ctrs(model, msrs);
+	nmi_cpu_setup_mux(cpu, msrs);
 	spin_unlock(&oprofilefs_lock);
 	per_cpu(saved_lvtpc, cpu) = apic_read(APIC_LVTPC);
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
@@ -156,11 +341,15 @@ static int nmi_setup(void)
 	int cpu;
 
 	if (!allocate_msrs())
-		return -ENOMEM;
+		err = -ENOMEM;
+	else if (!nmi_setup_mux())
+		err = -ENOMEM;
+	else
+		err = register_die_notifier(&profile_exceptions_nb);
 
-	err = register_die_notifier(&profile_exceptions_nb);
 	if (err) {
 		free_msrs();
+		nmi_shutdown_mux();
 		return err;
 	}
 
@@ -171,24 +360,25 @@ static int nmi_setup(void)
 	/* Assume saved/restored counters are the same on all CPUs */
 	model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
 	for_each_possible_cpu(cpu) {
-		if (cpu != 0) {
-			memcpy(per_cpu(cpu_msrs, cpu).counters,
-				per_cpu(cpu_msrs, 0).counters,
-				sizeof(struct op_msr) * model->num_counters);
-
-			memcpy(per_cpu(cpu_msrs, cpu).controls,
-				per_cpu(cpu_msrs, 0).controls,
-				sizeof(struct op_msr) * model->num_controls);
-		}
+		if (!cpu)
+			continue;
 
+		memcpy(per_cpu(cpu_msrs, cpu).counters,
+		       per_cpu(cpu_msrs, 0).counters,
+		       sizeof(struct op_msr) * model->num_counters);
+
+		memcpy(per_cpu(cpu_msrs, cpu).controls,
+		       per_cpu(cpu_msrs, 0).controls,
+		       sizeof(struct op_msr) * model->num_controls);
+
+		mux_clone(cpu);
 	}
-	on_each_cpu(nmi_save_registers, NULL, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
 	return 0;
 }
 
-static void nmi_restore_registers(struct op_msrs *msrs)
+static void nmi_cpu_restore_registers(struct op_msrs *msrs)
 {
 	struct op_msr *counters = msrs->counters;
 	struct op_msr *controls = msrs->controls;
@@ -209,7 +399,7 @@ static void nmi_cpu_shutdown(void *dummy)
 {
 	unsigned int v;
 	int cpu = smp_processor_id();
-	struct op_msrs *msrs = &__get_cpu_var(cpu_msrs);
+	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
 
 	/* restoring APIC_LVTPC can trigger an apic error because the delivery
 	 * mode and vector nr combination can be illegal. That's by design: on
@@ -220,7 +410,7 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTERR, v | APIC_LVT_MASKED);
 	apic_write(APIC_LVTPC, per_cpu(saved_lvtpc, cpu));
 	apic_write(APIC_LVTERR, v);
-	nmi_restore_registers(msrs);
+	nmi_cpu_restore_registers(msrs);
 }
 
 static void nmi_shutdown(void)
@@ -230,42 +420,18 @@ static void nmi_shutdown(void)
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
+	nmi_shutdown_mux();
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
 	free_msrs();
 	put_cpu_var(cpu_msrs);
 }
 
-static void nmi_cpu_start(void *dummy)
-{
-	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
-	model->start(msrs);
-}
-
-static int nmi_start(void)
-{
-	on_each_cpu(nmi_cpu_start, NULL, 1);
-	return 0;
-}
-
-static void nmi_cpu_stop(void *dummy)
-{
-	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
-	model->stop(msrs);
-}
-
-static void nmi_stop(void)
-{
-	on_each_cpu(nmi_cpu_stop, NULL, 1);
-}
-
-struct op_counter_config counter_config[OP_MAX_COUNTER];
-
 static int nmi_create_files(struct super_block *sb, struct dentry *root)
 {
 	unsigned int i;
 
-	for (i = 0; i < model->num_counters; ++i) {
+	for (i = 0; i < model->num_virt_counters; ++i) {
 		struct dentry *dir;
 		char buf[4];
 
@@ -274,7 +440,7 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 		 * NOTE:  assumes 1:1 mapping here (that counters are organized
 		 *        sequentially in their struct assignment).
 		 */
-		if (unlikely(!avail_to_resrv_perfctr_nmi_bit(i)))
+		if (!avail_to_resrv_perfctr_nmi_bit(op_x86_virt_to_phys(i)))
 			continue;
 
 		snprintf(buf,  sizeof(buf), "%d", i);
@@ -406,7 +572,7 @@ module_param_call(cpu_type, force_cpu_type, NULL, NULL, 0);
 static int __init ppro_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
-	struct op_x86_model_spec const *spec = &op_ppro_spec;	/* default */
+	struct op_x86_model_spec *spec = &op_ppro_spec;	/* default */
 
 	if (force_arch_perfmon && cpu_has_arch_perfmon)
 		return 0;
@@ -523,18 +689,23 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	register_cpu_notifier(&oprofile_cpu_nb);
 #endif
 	/* default values, can be overwritten by model */
-	ops->create_files = nmi_create_files;
-	ops->setup = nmi_setup;
-	ops->shutdown = nmi_shutdown;
-	ops->start = nmi_start;
-	ops->stop = nmi_stop;
-	ops->cpu_type = cpu_type;
+	ops->create_files	= nmi_create_files;
+	ops->setup		= nmi_setup;
+	ops->shutdown		= nmi_shutdown;
+	ops->start		= nmi_start;
+	ops->stop		= nmi_stop;
+	ops->cpu_type		= cpu_type;
 
 	if (model->init)
 		ret = model->init(ops);
 	if (ret)
 		return ret;
 
+	if (!model->num_virt_counters)
+		model->num_virt_counters = model->num_counters;
+
+	mux_init(ops);
+
 	init_sysfs();
 	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
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
index 7ca8306..827beec 100644
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
@@ -25,12 +28,20 @@
 
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
 
 #ifdef CONFIG_OPROFILE_IBS
 
@@ -63,6 +74,45 @@ static struct op_ibs_config ibs_config;
 
 #endif
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void op_mux_fill_in_addresses(struct op_msrs * const msrs)
+{
+	int i;
+
+	for (i = 0; i < NUM_VIRT_COUNTERS; i++) {
+		int hw_counter = op_x86_virt_to_phys(i);
+		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+			msrs->multiplex[i].addr = MSR_K7_PERFCTR0 + hw_counter;
+		else
+			msrs->multiplex[i].addr = 0;
+	}
+}
+
+static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
+			       struct op_msrs const * const msrs)
+{
+	u64 val;
+	int i;
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (!counter_config[virt].enabled)
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
+	}
+}
+
+#else
+
+static inline void op_mux_fill_in_addresses(struct op_msrs * const msrs) { }
+
+#endif
+
 /* functions for op_amd_spec */
 
 static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
@@ -82,6 +132,8 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 		else
 			msrs->controls[i].addr = 0;
 	}
+
+	op_mux_fill_in_addresses(msrs);
 }
 
 static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
@@ -90,8 +142,16 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	u64 val;
 	int i;
 
+	/* setup reset_value */
+	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
+		if (counter_config[i].enabled)
+			reset_value[i] = counter_config[i].count;
+		else
+			reset_value[i] = 0;
+	}
+
 	/* clear all counters */
-	for (i = 0 ; i < NUM_CONTROLS; ++i) {
+	for (i = 0; i < NUM_CONTROLS; ++i) {
 		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
@@ -108,17 +168,20 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (counter_config[i].enabled && msrs->counters[i].addr) {
-			reset_value[i] = counter_config[i].count;
-			wrmsrl(msrs->counters[i].addr,
-			       -(u64)counter_config[i].count);
-			rdmsrl(msrs->controls[i].addr, val);
-			val &= model->reserved;
-			val |= op_x86_get_ctrl(model, &counter_config[i]);
-			wrmsrl(msrs->controls[i].addr, val);
-		} else {
-			reset_value[i] = 0;
-		}
+		int virt = op_x86_phys_to_virt(i);
+		if (!counter_config[virt].enabled)
+			continue;
+		if (!msrs->counters[i].addr)
+			continue;
+
+		/* setup counter registers */
+		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
+
+		/* setup control registers */
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 }
 
@@ -229,15 +292,16 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 	u64 val;
 	int i;
 
-	for (i = 0 ; i < NUM_COUNTERS; ++i) {
-		if (!reset_value[i])
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (!reset_value[virt])
 			continue;
 		rdmsrl(msrs->counters[i].addr, val);
 		/* bit is clear if overflowed: */
 		if (val & OP_CTR_OVERFLOW)
 			continue;
-		oprofile_add_sample(regs, i);
-		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[i]);
+		oprofile_add_sample(regs, virt);
+		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
 	}
 
 	op_amd_handle_ibs(regs, msrs);
@@ -250,12 +314,13 @@ static void op_amd_start(struct op_msrs const * const msrs)
 {
 	u64 val;
 	int i;
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (reset_value[i]) {
-			rdmsrl(msrs->controls[i].addr, val);
-			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-			wrmsrl(msrs->controls[i].addr, val);
-		}
+
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (!reset_value[op_x86_phys_to_virt(i)])
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 
 	op_amd_start_ibs();
@@ -270,8 +335,8 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	 * Subtle: stop on all counters to avoid race with setting our
 	 * pm callback
 	 */
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (!reset_value[i])
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
 		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
@@ -285,11 +350,11 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
 	}
-	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
+	for (i = 0; i < NUM_CONTROLS; ++i) {
 		if (msrs->controls[i].addr)
 			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
@@ -460,9 +525,10 @@ static void op_amd_exit(void) {}
 
 #endif /* CONFIG_OPROFILE_IBS */
 
-struct op_x86_model_spec const op_amd_spec = {
+struct op_x86_model_spec op_amd_spec = {
 	.num_counters		= NUM_COUNTERS,
 	.num_controls		= NUM_CONTROLS,
+	.num_virt_counters	= NUM_VIRT_COUNTERS,
 	.reserved		= MSR_AMD_EVENTSEL_RESERVED,
 	.event_mask		= OP_EVENT_MASK,
 	.init			= op_amd_init,
@@ -473,4 +539,7 @@ struct op_x86_model_spec const op_amd_spec = {
 	.start			= &op_amd_start,
 	.stop			= &op_amd_stop,
 	.shutdown		= &op_amd_shutdown,
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	.switch_ctrl		= &op_mux_switch_ctrl,
+#endif
 };
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 9db9e36..ac6b354 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -558,7 +558,7 @@ static void p4_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 
 	/* clear the cccrs we will use */
-	for (i = 0 ; i < num_counters ; i++) {
+	for (i = 0; i < num_counters; i++) {
 		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		rdmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
@@ -575,7 +575,7 @@ static void p4_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 
 	/* setup all counters */
-	for (i = 0 ; i < num_counters ; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (counter_config[i].enabled && msrs->controls[i].addr) {
 			reset_value[i] = counter_config[i].count;
 			pmc_setup_one_p4_counter(i);
@@ -678,7 +678,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0 ; i < num_counters ; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (msrs->counters[i].addr)
 			release_perfctr_nmi(msrs->counters[i].addr);
 	}
@@ -687,7 +687,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 	 * conjunction with the counter registers (hence the starting offset).
 	 * This saves a few bits.
 	 */
-	for (i = num_counters ; i < num_controls ; ++i) {
+	for (i = num_counters; i < num_controls; ++i) {
 		if (msrs->controls[i].addr)
 			release_evntsel_nmi(msrs->controls[i].addr);
 	}
@@ -695,7 +695,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 
 
 #ifdef CONFIG_SMP
-struct op_x86_model_spec const op_p4_ht2_spec = {
+struct op_x86_model_spec op_p4_ht2_spec = {
 	.num_counters		= NUM_COUNTERS_HT2,
 	.num_controls		= NUM_CONTROLS_HT2,
 	.fill_in_addresses	= &p4_fill_in_addresses,
@@ -707,7 +707,7 @@ struct op_x86_model_spec const op_p4_ht2_spec = {
 };
 #endif
 
-struct op_x86_model_spec const op_p4_spec = {
+struct op_x86_model_spec op_p4_spec = {
 	.num_counters		= NUM_COUNTERS_NON_HT,
 	.num_controls		= NUM_CONTROLS_NON_HT,
 	.fill_in_addresses	= &p4_fill_in_addresses,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index cd72d5c..4899215 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -81,7 +81,7 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 
 	/* clear all counters */
-	for (i = 0 ; i < num_counters; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
@@ -125,7 +125,7 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 	if (unlikely(!reset_value))
 		goto out;
 
-	for (i = 0 ; i < num_counters; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
 		rdmsrl(msrs->counters[i].addr, val);
@@ -188,11 +188,11 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0 ; i < num_counters ; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
 	}
-	for (i = 0 ; i < num_counters ; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (msrs->controls[i].addr)
 			release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
 	}
@@ -203,7 +203,7 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 }
 
 
-struct op_x86_model_spec const op_ppro_spec = {
+struct op_x86_model_spec op_ppro_spec = {
 	.num_counters		= 2,
 	.num_controls		= 2,
 	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 5054898..b837761 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -23,6 +23,7 @@ struct op_msr {
 struct op_msrs {
 	struct op_msr *counters;
 	struct op_msr *controls;
+	struct op_msr *multiplex;
 };
 
 struct pt_regs;
@@ -35,6 +36,7 @@ struct oprofile_operations;
 struct op_x86_model_spec {
 	unsigned int	num_counters;
 	unsigned int	num_controls;
+	unsigned int	num_virt_counters;
 	u64		reserved;
 	u16		event_mask;
 	int		(*init)(struct oprofile_operations *ops);
@@ -47,17 +49,23 @@ struct op_x86_model_spec {
 	void		(*start)(struct op_msrs const * const msrs);
 	void		(*stop)(struct op_msrs const * const msrs);
 	void		(*shutdown)(struct op_msrs const * const msrs);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	void		(*switch_ctrl)(struct op_x86_model_spec const *model,
+				       struct op_msrs const * const msrs);
+#endif
 };
 
 struct op_counter_config;
 
 extern u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 			   struct op_counter_config *counter_config);
+extern int op_x86_phys_to_virt(int phys);
+extern int op_x86_virt_to_phys(int virt);
 
-extern struct op_x86_model_spec const op_ppro_spec;
-extern struct op_x86_model_spec const op_p4_spec;
-extern struct op_x86_model_spec const op_p4_ht2_spec;
-extern struct op_x86_model_spec const op_amd_spec;
+extern struct op_x86_model_spec op_ppro_spec;
+extern struct op_x86_model_spec op_p4_spec;
+extern struct op_x86_model_spec op_p4_ht2_spec;
+extern struct op_x86_model_spec op_amd_spec;
 extern struct op_x86_model_spec op_arch_perfmon_spec;
 
 #endif /* OP_X86_MODEL_H */
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 3cffce9..dc8a042 100644
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
@@ -87,6 +89,69 @@ out:
 	return err;
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void switch_worker(struct work_struct *work);
+static DECLARE_DELAYED_WORK(switch_work, switch_worker);
+
+static void start_switch_worker(void)
+{
+	if (oprofile_ops.switch_events)
+		schedule_delayed_work(&switch_work, oprofile_time_slice);
+}
+
+static void stop_switch_worker(void)
+{
+	cancel_delayed_work_sync(&switch_work);
+}
+
+static void switch_worker(struct work_struct *work)
+{
+	if (oprofile_ops.switch_events())
+		return;
+
+	atomic_inc(&oprofile_stats.multiplex_counter);
+	start_switch_worker();
+}
+
+/* User inputs in ms, converts to jiffies */
+int oprofile_set_timeout(unsigned long val_msec)
+{
+	int err = 0;
+	unsigned long time_slice;
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
+	time_slice = msecs_to_jiffies(val_msec);
+	if (time_slice == MAX_JIFFY_OFFSET) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	oprofile_time_slice = time_slice;
+
+out:
+	mutex_unlock(&start_mutex);
+	return err;
+
+}
+
+#else
+
+static inline void start_switch_worker(void) { }
+static inline void stop_switch_worker(void) { }
+
+#endif
 
 /* Actually start profiling (echo 1>/dev/oprofile/enable) */
 int oprofile_start(void)
@@ -108,6 +173,8 @@ int oprofile_start(void)
 	if ((err = oprofile_ops.start()))
 		goto out;
 
+	start_switch_worker();
+
 	oprofile_started = 1;
 out:
 	mutex_unlock(&start_mutex);
@@ -123,6 +190,9 @@ void oprofile_stop(void)
 		goto out;
 	oprofile_ops.stop();
 	oprofile_started = 0;
+
+	stop_switch_worker();
+
 	/* wake up the daemon to read what remains */
 	wake_up_buffer_waiter();
 out:
@@ -155,7 +225,6 @@ post_sync:
 	mutex_unlock(&start_mutex);
 }
 
-
 int oprofile_set_backtrace(unsigned long val)
 {
 	int err = 0;
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index c288d3c..cb92f5c 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -24,6 +24,8 @@ struct oprofile_operations;
 extern unsigned long oprofile_buffer_size;
 extern unsigned long oprofile_cpu_buffer_size;
 extern unsigned long oprofile_buffer_watershed;
+extern unsigned long oprofile_time_slice;
+
 extern struct oprofile_operations oprofile_ops;
 extern unsigned long oprofile_started;
 extern unsigned long oprofile_backtrace_depth;
@@ -35,5 +37,6 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root);
 void oprofile_timer_init(struct oprofile_operations *ops);
 
 int oprofile_set_backtrace(unsigned long depth);
+int oprofile_set_timeout(unsigned long time);
 
 #endif /* OPROF_H */
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index 5d36ffc..bbd7516 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -9,6 +9,7 @@
 
 #include <linux/fs.h>
 #include <linux/oprofile.h>
+#include <linux/jiffies.h>
 
 #include "event_buffer.h"
 #include "oprofile_stats.h"
@@ -17,10 +18,51 @@
 #define BUFFER_SIZE_DEFAULT		131072
 #define CPU_BUFFER_SIZE_DEFAULT		8192
 #define BUFFER_WATERSHED_DEFAULT	32768	/* FIXME: tune */
+#define TIME_SLICE_DEFAULT		1
 
 unsigned long oprofile_buffer_size;
 unsigned long oprofile_cpu_buffer_size;
 unsigned long oprofile_buffer_watershed;
+unsigned long oprofile_time_slice;
+
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static ssize_t timeout_read(struct file *file, char __user *buf,
+		size_t count, loff_t *offset)
+{
+	return oprofilefs_ulong_to_user(jiffies_to_msecs(oprofile_time_slice),
+					buf, count, offset);
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
 
 static ssize_t depth_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
@@ -129,6 +171,7 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root)
 	oprofile_buffer_size =		BUFFER_SIZE_DEFAULT;
 	oprofile_cpu_buffer_size =	CPU_BUFFER_SIZE_DEFAULT;
 	oprofile_buffer_watershed =	BUFFER_WATERSHED_DEFAULT;
+	oprofile_time_slice =		msecs_to_jiffies(TIME_SLICE_DEFAULT);
 
 	oprofilefs_create_file(sb, root, "enable", &enable_fops);
 	oprofilefs_create_file_perm(sb, root, "dump", &dump_fops, 0666);
@@ -139,6 +182,9 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root)
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
index 3c2270a..61689e8 100644
--- a/drivers/oprofile/oprofile_stats.c
+++ b/drivers/oprofile/oprofile_stats.c
@@ -34,6 +34,7 @@ void oprofile_reset_stats(void)
 	atomic_set(&oprofile_stats.sample_lost_no_mapping, 0);
 	atomic_set(&oprofile_stats.event_lost_overflow, 0);
 	atomic_set(&oprofile_stats.bt_lost_no_mapping, 0);
+	atomic_set(&oprofile_stats.multiplex_counter, 0);
 }
 
 
@@ -76,4 +77,8 @@ void oprofile_create_stats_files(struct super_block *sb, struct dentry *root)
 		&oprofile_stats.event_lost_overflow);
 	oprofilefs_create_ro_atomic(sb, dir, "bt_lost_no_mapping",
 		&oprofile_stats.bt_lost_no_mapping);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	oprofilefs_create_ro_atomic(sb, dir, "multiplex_counter",
+		&oprofile_stats.multiplex_counter);
+#endif
 }
diff --git a/drivers/oprofile/oprofile_stats.h b/drivers/oprofile/oprofile_stats.h
index 3da0d08..0b54e46 100644
--- a/drivers/oprofile/oprofile_stats.h
+++ b/drivers/oprofile/oprofile_stats.h
@@ -17,6 +17,7 @@ struct oprofile_stat_struct {
 	atomic_t sample_lost_no_mapping;
 	atomic_t bt_lost_no_mapping;
 	atomic_t event_lost_overflow;
+	atomic_t multiplex_counter;
 };
 
 extern struct oprofile_stat_struct oprofile_stats;
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






