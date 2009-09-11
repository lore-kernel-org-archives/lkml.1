Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZIKPgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZIKPgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZIKPgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:36:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:45222 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbZIKPgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:36:47 -0400
Date: Fri, 11 Sep 2009 17:40:19 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       peterz@infradead.org, yanmin_zhang@linux.intel.com,
       torvalds@linux-foundation.org, jens.axboe@oracle.com
Subject: PATCH] cpuidle: A new variant of the menu governor to boost IO
 performance
Message-ID: <20090911174019.1ed02737@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] cpuidle: A new variant of the menu governor

This patch adds a new idle governor which balances power savings,
energy efficiency and performance impact.

The reason for a reworked governor is that there have been
serious performance issues reported with the existing code
on Nehalem server systems.

To show this I'm sure Andrew wants to see benchmark results:
(benchmark is "fio", "no cstates" is using "idle=poll")

		no cstates	current linux	new algorithm
1 disk		107 Mb/s	85 Mb/s		105 Mb/s
2 disks		215 Mb/s	123 Mb/s	209 Mb/s
12 disks	590 Mb/s	320 Mb/s	585 Mb/s

In various power benchmark measurements, no degredation was found
by our measurement&diagnostics team. Obviously a bit more power was
used in the "fio" benchmark, due to the much higher performance.

The integration plan for this is to first add the new governor,
but for one kernel generation, leave the old menu governor in place
so that it's possible to separate out behavior from this governor
versus other things in diagnostics. If no issues are found,
I'll remove the old governor in the kernel cycle after that.

While it would be a novel idea to describe the new algorithm in this
commit message, I cheaped out and described it in comments in the
code instead.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/cpuidle/Kconfig              |    5 +
 drivers/cpuidle/governors/Makefile   |    2 +
 drivers/cpuidle/governors/menu-tng.c |  334 ++++++++++++++++++++++++++++++++++
 include/linux/sched.h                |    4 +
 kernel/sched.c                       |   15 ++
 5 files changed, 360 insertions(+), 0 deletions(-)
 create mode 100644 drivers/cpuidle/governors/menu-tng.c

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 7dbc4a8..3a19d8c 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -18,3 +18,8 @@ config CPU_IDLE_GOV_MENU
 	bool
 	depends on CPU_IDLE && NO_HZ
 	default y
+
+config CPU_IDLE_GOV_MENU_TNG
+	bool
+	depends on CPU_IDLE && NO_HZ
+	default y
diff --git a/drivers/cpuidle/governors/Makefile b/drivers/cpuidle/governors/Makefile
index 1b51272..be4f8e3 100644
--- a/drivers/cpuidle/governors/Makefile
+++ b/drivers/cpuidle/governors/Makefile
@@ -4,3 +4,5 @@
 
 obj-$(CONFIG_CPU_IDLE_GOV_LADDER) += ladder.o
 obj-$(CONFIG_CPU_IDLE_GOV_MENU) += menu.o
+obj-$(CONFIG_CPU_IDLE_GOV_MENU_TNG) += menu-tng.o
+
diff --git a/drivers/cpuidle/governors/menu-tng.c b/drivers/cpuidle/governors/menu-tng.c
new file mode 100644
index 0000000..6e76c56
--- /dev/null
+++ b/drivers/cpuidle/governors/menu-tng.c
@@ -0,0 +1,334 @@
+/*
+ * menu-tng.c - the menu idle governor
+ *
+ * Copyright (C) 2009 Intel Corporation
+ * Author:
+ *        Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * Based on framework code from
+ * Copyright (C) 2006-2007 Adam Belay <abelay@novell.com>
+ *
+ * This code is licenced under the GPL version 2 as described
+ * in the COPYING file that acompanies the Linux Kernel.
+ */
+
+#include <linux/kernel.h>
+#include <linux/cpuidle.h>
+#include <linux/pm_qos_params.h>
+#include <linux/time.h>
+#include <linux/ktime.h>
+#include <linux/hrtimer.h>
+#include <linux/tick.h>
+#include <linux/sched.h>
+
+
+#define BUCKETS 12
+#define RESOLUTION 1024
+#define DECAY 4
+#define MAX_INTERESTING 50000
+
+/*
+ * Concepts and ideas behind the menu-tng governor
+ *
+ * For the menu-tng governor, there are 3 decision factors for picking a C
+ * state:
+ * 1) Energie break even point
+ * 2) Performance impact
+ * 3) Latency tolerance (from pmqos infrastructure)
+ * These these three factors are treated independently.
+ *
+ * Energy break even point
+ * -----------------------
+ * C state entry and exit have an energy cost, and a certain amount of time in
+ * the  C state is required to actually break even on this cost. CPUIDLE
+ * provides us this duration in the "target_residency" field. So all that we
+ * need is a good prediction of how long we'll be idle. Like the traditional
+ * menu governor, we start with the actual known "next timer event" time.
+ *
+ * Since there are other source of wakeups (interrupts for example) than
+ * the next timer event, this estimation is rather optimistic. To get a
+ * more realistic estimate, a correction factor is applied to the estimate,
+ * that is based on historic behavior. For example, if in the past the actual
+ * duration always was 50% of the next timer tick, the correction factor will
+ * be 0.5.
+ *
+ * menu-tng uses a running average for this correction factor, however it uses a
+ * set of factors, not just a single factor. This stems from the realization
+ * that the ratio is dependent on the order of magnitude of the expected
+ * duration; if we expect 500 milliseconds of idle time the likelyhood of
+ * getting an interrupt very early is much higher than if we expect 50 micro
+ * seconds of idle time. A second independent factor that has big impact on
+ * the actual factor is if there is (disk) IO outstanding or not.
+ * (as a special twist, we consider every sleep longer than 50 milliseconds
+ * as perfect; there is no power gains for sleeping longer than this)
+ *
+ * For these two reasons we keep an array of 12 independent factors, that gets
+ * indexed based on the magnitude of the expected duration as well as the
+ * "is IO outstanding" property.
+ *
+ * Limiting Performance Impact
+ * ---------------------------
+ * C states, especially those with large exit latencies, can have a real
+ * noticable impact on workloads, which is not acceptable for most sysadmins,
+ * and in addition, less performance has a power price of its own.
+ *
+ * As a general rule of thumb, menu-tng assumes that the following heuristic
+ * holds:
+ *     The busier the system, the less impact of C states is acceptable
+ *
+ * This rule-of-thumb is implemented using a performance-multiplier:
+ * If the exit latency times the performance multiplier is longer than
+ * the predicted duration, the C state is not considered a candidate
+ * for selection due to a too high performance impact. So the higher
+ * this multiplier is, the longer we need to be idle to pick a deep C
+ * state, and thus the less likely a busy CPU will hit such a deep
+ * C state.
+ *
+ * Two factors are used in determing this multiplier:
+ * a value of 10 is added for each point of "per cpu load average" we have.
+ * a value of 5 points is added for each process that is waiting for
+ * IO on this CPU.
+ * (these values are experimentally determined)
+ *
+ * The load average factor gives a longer term (few seconds) input to the
+ * decision, while the iowait value gives a cpu local instantanious input.
+ * The iowait factor may look low, but realize that this is also already
+ * represented in the system load average.
+ *
+ */
+
+struct menu_device {
+	int		last_state_idx;
+
+	unsigned int	expected_us;
+	u64		predicted_us;
+	unsigned int	measured_us;
+	unsigned int	exit_us;
+	unsigned int	bucket;
+	u64		correction_factor[BUCKETS];
+};
+
+
+#define LOAD_INT(x) ((x) >> FSHIFT)
+#define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
+
+static int get_loadavg(void)
+{
+	unsigned long this = this_cpu_load();
+
+
+	return LOAD_INT(this) * 10 + LOAD_FRAC(this) / 10;
+}
+
+static inline int which_bucket(unsigned int duration)
+{
+	int bucket = 0;
+
+	/*
+	 * We keep two groups of stats; one with no
+	 * IO pending, one without.
+	 * This allows us to calculate
+	 * E(duration)|iowait
+	 */
+	if (nr_iowait_cpu())
+		bucket = BUCKETS/2;
+
+	if (duration < 10)
+		return bucket;
+	if (duration < 100)
+		return bucket + 1;
+	if (duration < 1000)
+		return bucket + 2;
+	if (duration < 10000)
+		return bucket + 3;
+	if (duration < 100000)
+		return bucket + 4;
+	return bucket + 5;
+}
+
+/*
+ * Return a multiplier for the exit latency that is intended
+ * to take performance requirements into account.
+ * The more performance critical we estimate the system
+ * to be, the higher this multiplier, and thus the higher
+ * the barrier to go to an expensive C state.
+ */
+static inline int performance_multiplier(void)
+{
+	int mult = 1;
+
+	/* for higher loadavg, we are more reluctant */
+
+	mult += 2 * get_loadavg();
+
+	/* for IO wait tasks (per cpu!) we add 5x each */
+	mult += 10 * nr_iowait_cpu();
+
+	return mult;
+}
+
+static DEFINE_PER_CPU(struct menu_device, menu_devices);
+
+/**
+ * menu_select - selects the next idle state to enter
+ * @dev: the CPU
+ */
+static int menu_select(struct cpuidle_device *dev)
+{
+	struct menu_device *data = &__get_cpu_var(menu_devices);
+	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
+	int i, multiplier;
+
+	data->last_state_idx = 0;
+	data->exit_us = 0;
+
+	/* Special case when user has set very strict latency requirement */
+	if (unlikely(latency_req == 0))
+		return 0;
+
+	/* determine the expected residency time, round up */
+	data->expected_us =
+		(u32) (ktime_to_ns(tick_nohz_get_sleep_length())+999) / 1000;
+
+
+	data->bucket = which_bucket(data->expected_us);
+
+	multiplier = performance_multiplier();
+
+	/*
+	 * if the correction factor is 0 (eg first time init or cpu hotplug
+	 * etc), we actually want to start out with a unity factor.
+	 */
+	if (data->correction_factor[data->bucket] == 0)
+		data->correction_factor[data->bucket] = RESOLUTION * DECAY;
+
+	/* Make sure to round up for half microseconds */
+	data->predicted_us =
+		(data->expected_us * data->correction_factor[data->bucket] +
+		RESOLUTION * DECAY/2) / RESOLUTION / DECAY;
+
+	/*
+	 * We want to default to C1 (hlt), not to busy polling
+	 * unless the timer is happening really really soon.
+	 */
+	if (data->expected_us > 5)
+		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
+
+
+	/* find the deepest idle state that satisfies our constraints */
+	for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
+		struct cpuidle_state *s = &dev->states[i];
+
+		if (s->target_residency > data->predicted_us)
+			break;
+		if (s->exit_latency > latency_req)
+			break;
+		if (s->exit_latency * multiplier > data->predicted_us)
+			break;
+		data->exit_us = s->exit_latency;
+		data->last_state_idx = i;
+	}
+
+	return data->last_state_idx;
+}
+
+/**
+ * menu_reflect - attempts to guess what happened after entry
+ * @dev: the CPU
+ *
+ * NOTE: it's important to be fast here because this operation will add to
+ *       the overall exit latency.
+ */
+static void menu_reflect(struct cpuidle_device *dev)
+{
+	struct menu_device *data = &__get_cpu_var(menu_devices);
+	int last_idx = data->last_state_idx;
+	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
+	struct cpuidle_state *target = &dev->states[last_idx];
+	unsigned int measured_us;
+	u64 new_factor;
+
+	/*
+	 * Ugh, this idle state doesn't support residency measurements, so we
+	 * are basically lost in the dark.  As a compromise, assume we slept
+	 * for the whole expected time.
+	 */
+	if (unlikely(!(target->flags & CPUIDLE_FLAG_TIME_VALID)))
+		last_idle_us = data->expected_us;
+
+
+	measured_us = last_idle_us;
+
+	/*
+	 * We correct for the exit latency; we are assuming here that the
+	 * exit latency happens after the event that we're interested in.
+	 */
+	if (measured_us > data->exit_us)
+		measured_us -= data->exit_us;
+
+
+	/* update our correction ratio */
+
+	new_factor = data->correction_factor[data->bucket]
+			* (DECAY - 1) / DECAY;
+
+	if (data->expected_us > 0 && data->measured_us < MAX_INTERESTING)
+		new_factor += RESOLUTION * measured_us / data->expected_us;
+	else
+		/*
+		 * we were idle so long that we count it as a perfect
+		 * prediction
+		 */
+		new_factor += RESOLUTION;
+
+	/*
+	 * We don't want as factor; we always want at least
+	 * a tiny bit of estimated time.
+	 */
+	if (new_factor == 0)
+		new_factor = 1;
+
+	data->correction_factor[data->bucket] = new_factor;
+}
+
+/**
+ * menu_enable_device - scans a CPU's states and does setup
+ * @dev: the CPU
+ */
+static int menu_enable_device(struct cpuidle_device *dev)
+{
+	struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
+
+	memset(data, 0, sizeof(struct menu_device));
+
+	return 0;
+}
+
+static struct cpuidle_governor menu_governor = {
+	.name =		"menu-tng",
+	.rating =	30,
+	.enable =	menu_enable_device,
+	.select =	menu_select,
+	.reflect =	menu_reflect,
+	.owner =	THIS_MODULE,
+};
+
+/**
+ * init_menu - initializes the governor
+ */
+static int __init init_menu(void)
+{
+	return cpuidle_register_governor(&menu_governor);
+}
+
+/**
+ * exit_menu - exits the governor
+ */
+static void __exit exit_menu(void)
+{
+	cpuidle_unregister_governor(&menu_governor);
+}
+
+MODULE_LICENSE("GPL");
+module_init(init_menu);
+module_exit(exit_menu);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index afb4812..79cbe44 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -140,6 +140,10 @@ extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
+extern unsigned long nr_iowait_cpu(void);
+extern unsigned long this_cpu_load(void);
+
+
 extern void calc_global_load(void);
 extern u64 cpu_nr_migrations(int cpu);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 69b9730..132accc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3047,6 +3047,21 @@ unsigned long nr_iowait(void)
 	return sum;
 }
 
+unsigned long nr_iowait_cpu(void)
+{
+	int this_cpu = smp_processor_id();
+	struct rq *this_rq = cpu_rq(this_cpu);
+	return atomic_read(&this_rq->nr_iowait);
+}
+
+unsigned long this_cpu_load(void)
+{
+	int this_cpu = smp_processor_id();
+	struct rq *this_rq = cpu_rq(this_cpu);
+	return this_rq->cpu_load[0];
+}
+
+
 /* Variables and functions for calc_load */
 static atomic_long_t calc_load_tasks;
 static unsigned long calc_load_update;
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
