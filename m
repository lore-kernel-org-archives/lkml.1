Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYFCQRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYFCQRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYFCQRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:17:06 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:54889 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYFCQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:17:04 -0400
X-BigFish: VPS-7(z5edJz655Ozz10d3izzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K1WAJY-01-6KJ-01
Subject: [PATCH] Updated: Oprofile Multiplexing
From: Jason Yeh <jason.yeh@amd.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 3 Jun 2008 11:16:47 -0500
Message-ID: <1212509807.22351.1.camel@pranjaparamita>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2008 16:16:51.0010 (UTC) FILETIME=[3AF6A220:01C8C595]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated patch to enable Oprofile module to switch between different
sets of events at the user specified interval. It allows the module to gather
more event statistics than the number of event counters on the hardware in a
single run of profiling.

A new file (/dev/oprofile/timeout_ms) is added for user to specify the interval.
If the number of user specified events is more than the number of events counter
on the hardware, the patch will schedule a delayed work and switch/re-writes the
different sets of value into the events counter. The switching mechanism needs
to be done for each architecture if it wishes to support this multiplexing scheme.
Only AMD CPU is supported in this patch.

Signed-off-by: Jason Yeh <jason.yeh@amd.com>
---

 arch/x86/oprofile/nmi_int.c         |   20 +++++
 arch/x86/oprofile/op_counter.h      |    3
 arch/x86/oprofile/op_model_athlon.c |  123 +++++++++++++++++++++++++++++-------
 arch/x86/oprofile/op_x86_model.h    |    2
 drivers/oprofile/oprof.c            |   57 +++++++++++++++-
 drivers/oprofile/oprof.h            |    4 -
 drivers/oprofile/oprofile_files.c   |   39 ++++++++++-
 include/linux/oprofile.h            |    3
 8 files changed, 223 insertions(+), 28 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cc48d3f..42fef97 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -80,6 +80,24 @@ static void exit_sysfs(void)
 #define exit_sysfs() do { } while (0)
 #endif /* CONFIG_PM */
 
+static void nmi_cpu_switch(void *dummy)
+{
+	struct op_msrs *msrs = &__get_cpu_var(cpu_msrs);
+	model->switch_ctrs(msrs);
+}
+
+static int nmi_switch_event(void)
+{
+	/* Check CPU 0 should be sufficient */
+	struct op_msrs const *msrs = &per_cpu(cpu_msrs, 0);
+
+	if (model->check_multiplexing(msrs) < 0)
+		return -EINVAL;
+
+	on_each_cpu(nmi_cpu_switch, NULL, 0, 1);
+	return 0;
+}
+
 static int profile_exceptions_notify(struct notifier_block *self,
 				     unsigned long val, void *data)
 {
@@ -326,6 +344,7 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 		oprofilefs_create_ulong(sb, dir, "unit_mask", &counter_config[i].unit_mask);
 		oprofilefs_create_ulong(sb, dir, "kernel", &counter_config[i].kernel);
 		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
+		counter_config[i].save_count_low = 0;
 	}
 
 	return 0;
@@ -455,6 +474,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	ops->start = nmi_start;
 	ops->stop = nmi_stop;
 	ops->cpu_type = cpu_type;
+	ops->switch_events = nmi_switch_event;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;
 }
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
diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 3d53487..4a09666 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/oprofile.h>
+#include <linux/percpu.h>
 #include <asm/ptrace.h>
 #include <asm/msr.h>
 #include <asm/nmi.h>
@@ -18,8 +19,10 @@
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
@@ -43,21 +46,24 @@
 #define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
 static unsigned long reset_value[NUM_COUNTERS];
+static DEFINE_PER_CPU(int, switch_index);
 
 static void athlon_fill_in_addresses(struct op_msrs * const msrs)
 {
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
@@ -69,8 +75,15 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
 	unsigned int low, high;
 	int i;
 
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (counter_config[i].enabled)
+			reset_value[i] = counter_config[i].count;
+		else
+			reset_value[i] = 0;
+	}
+
 	/* clear all counters */
-	for (i = 0 ; i < NUM_CONTROLS; ++i) {
+	for (i = 0 ; i < NUM_HARDWARE_CONTROLS; ++i) {
 		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
 			continue;
 		CTRL_READ(low, high, msrs, i);
@@ -80,14 +93,14 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
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
+	for (i = 0; i < NUM_HARDWARE_COUNTERS; ++i) {
 		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
 			reset_value[i] = counter_config[i].count;
 
@@ -106,26 +119,36 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
 			CTRL_SET_GUEST_ONLY(high, 0);
 
 			CTRL_WRITE(low, high, msrs, i);
-		} else {
-			reset_value[i] = 0;
 		}
 	}
 }
 
 
+/*
+ * Quick check to see if multiplexing is necessary.
+ * The check should be efficient since counters are used
+ * in ordre.
+ */
+static int athlon_check_multiplexing(struct op_msrs const * const msrs)
+{
+	return counter_config[NUM_HARDWARE_COUNTERS].count ? 0 : -EINVAL;
+}
+
+
 static int athlon_check_ctrs(struct pt_regs * const regs,
 			     struct op_msrs const * const msrs)
 {
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
 
@@ -138,13 +161,14 @@ static void athlon_start(struct op_msrs const * const msrs)
 {
 	unsigned int low, high;
 	int i;
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+	for (i = 0 ; i < NUM_HARDWARE_COUNTERS ; ++i) {
 		if (reset_value[i]) {
 			CTRL_READ(low, high, msrs, i);
 			CTRL_SET_ACTIVE(low);
 			CTRL_WRITE(low, high, msrs, i);
 		}
 	}
+	__get_cpu_var(switch_index) = 0;
 }
 
 
@@ -155,8 +179,8 @@ static void athlon_stop(struct op_msrs const * const msrs)
 
 	/* Subtle: stop on all counters to avoid race with
 	 * setting our pm callback */
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (!reset_value[i])
+	for (i = 0 ; i < NUM_HARDWARE_COUNTERS ; ++i) {
+		if (!reset_value[i + per_cpu(switch_index, smp_processor_id())])
 			continue;
 		CTRL_READ(low, high, msrs, i);
 		CTRL_SET_INACTIVE(low);
@@ -164,15 +188,70 @@ static void athlon_stop(struct op_msrs const * const msrs)
 	}
 }
 
+
+static void athlon_switch_ctrs(struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	int i, s = per_cpu(switch_index, smp_processor_id());
+
+	athlon_stop(msrs);
+
+	/* save the current hw counts */
+	for (i = 0; i < NUM_HARDWARE_COUNTERS; ++i) {
+		int offset = i + s;
+		if (!reset_value[offset])
+			continue;
+		CTR_READ(low, high, msrs, i);
+		/* convert counter value to actual count, assume high = -1 */
+		counter_config[offset].save_count_low =
+				(unsigned int) -1 - low - 1;
+	}
+
+	/* move to next eventset */
+	s += NUM_HARDWARE_COUNTERS;
+	if ((s > NUM_HARDWARE_COUNTERS) || (counter_config[s].count == 0)) {
+		per_cpu(switch_index, smp_processor_id()) = 0;
+		s = 0;
+	} else
+		per_cpu(switch_index, smp_processor_id()) = s;
+
+	/* enable next active counters */
+	for (i = 0; i < NUM_HARDWARE_COUNTERS; ++i) {
+		int offset = i + s;
+		if ((counter_config[offset].enabled)
+					&& (CTR_IS_RESERVED(msrs, i))) {
+			if (unlikely(!counter_config[offset].save_count_low))
+				counter_config[offset].save_count_low =
+						counter_config[offset].count;
+			CTR_WRITE(counter_config[offset].save_count_low,
+					msrs, i);
+			CTRL_READ(low, high, msrs, i);
+			CTRL_CLEAR_LO(low);
+			CTRL_CLEAR_HI(high);
+			CTRL_SET_ENABLE(low);
+			CTRL_SET_USR(low, counter_config[offset].user);
+			CTRL_SET_KERN(low, counter_config[offset].kernel);
+			CTRL_SET_UM(low, counter_config[offset].unit_mask);
+			CTRL_SET_EVENT_LOW(low, counter_config[offset].event);
+			CTRL_SET_EVENT_HIGH(high, counter_config[offset].event);
+			CTRL_SET_HOST_ONLY(high, 0);
+			CTRL_SET_GUEST_ONLY(high, 0);
+			CTRL_SET_ACTIVE(low);
+			CTRL_WRITE(low, high, msrs, i);
+		}
+	}
+}
+
+
 static void athlon_shutdown(struct op_msrs const * const msrs)
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
@@ -186,5 +265,7 @@ struct op_x86_model_spec const op_athlon_spec = {
 	.check_ctrs = &athlon_check_ctrs,
 	.start = &athlon_start,
 	.stop = &athlon_stop,
-	.shutdown = &athlon_shutdown
+	.shutdown = &athlon_shutdown,
+	.switch_ctrs = &athlon_switch_ctrs,
+	.check_multiplexing = &athlon_check_multiplexing
 };
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 45b605f..45003c2 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -41,6 +41,8 @@ struct op_x86_model_spec {
 	void (*start)(struct op_msrs const * const msrs);
 	void (*stop)(struct op_msrs const * const msrs);
 	void (*shutdown)(struct op_msrs const * const msrs);
+	void (*switch_ctrs)(struct op_msrs const * const msrs);
+	int (*check_multiplexing)(struct op_msrs const * const msrs);
 };
 
 extern struct op_x86_model_spec const op_ppro_spec;
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 2c64517..9385e1a 100644
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
@@ -155,6 +175,31 @@ post_sync:
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
+	if ((timeout_jiffies = msecs_to_jiffies(val_msec)) == MAX_JIFFY_OFFSET)
+		timeout_jiffies = msecs_to_jiffies(1);
+
+out:
+	mutex_unlock(&start_mutex);
+	return err;
+
+}
 
 int oprofile_set_backtrace(unsigned long val)
 {
@@ -179,10 +224,16 @@ out:
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
index 041bb31..71af056 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -65,6 +65,9 @@ struct oprofile_operations {
 
 	/* Initiate a stack backtrace. Optional. */
 	void (*backtrace)(struct pt_regs * const regs, unsigned int depth);
+
+	/* Multiplex between different events. Optional. */
+	int (*switch_events)(void);
 	/* CPU identification string. */
 	char * cpu_type;
 };





