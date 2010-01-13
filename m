Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474Ab0AMBQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab0AMBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560Ab0AMBQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:16:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:33763 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab0AMBQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:16:27 -0500
From: Mike Chan <mike@android.com>
To: cpufreq@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Chan <mike@android.com>
Subject: [PATCH] cpufreq: stats: Do not account for idle time when tracking time_in_state
Date: Tue, 12 Jan 2010 17:15:50 -0800
Message-Id: <1263345350-25975-1-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.6.6
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting ignore_idle to 1 ignores idle time from time_in_state accounting.

Currently cpufreq stats accounts for idle time time_in_state for each
cpu speed. For cpu's that have a low power idle state this improperly
accounts for time spent at each speed.

The most relevant case is when the system is idle yet cpu time is still
accounted for at the lowest speed. This results in heavily skewed statistics
(towards the lowest speed) which makes these statistics useless when tuning
cpufreq scaling with cpuidle.

Signed-off-by: Mike Chan <mike@android.com>
---
 drivers/cpufreq/cpufreq_stats.c |   42 +++++++++++++++++++++++++++++++++++---
 include/linux/cpufreq.h         |    5 ++++
 kernel/sched.c                  |    2 +
 3 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 5a62d67..8add3ac 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -23,10 +23,11 @@
 
 static spinlock_t cpufreq_stats_lock;
 
-#define CPUFREQ_STATDEVICE_ATTR(_name, _mode, _show) \
+#define CPUFREQ_STATDEVICE_ATTR(_name, _mode, _show, _store) \
 static struct freq_attr _attr_##_name = {\
 	.attr = {.name = __stringify(_name), .mode = _mode, }, \
 	.show = _show,\
+	.store = _store,\
 };
 
 struct cpufreq_stats {
@@ -43,6 +44,8 @@ struct cpufreq_stats {
 #endif
 };
 
+static int ignore_idle;
+
 static DEFINE_PER_CPU(struct cpufreq_stats *, cpufreq_stats_table);
 
 struct cpufreq_stats_attribute {
@@ -136,11 +139,27 @@ static ssize_t show_trans_table(struct cpufreq_policy *policy, char *buf)
 		return PAGE_SIZE;
 	return len;
 }
-CPUFREQ_STATDEVICE_ATTR(trans_table, 0444, show_trans_table);
+CPUFREQ_STATDEVICE_ATTR(trans_table, 0444, show_trans_table, NULL);
 #endif
 
-CPUFREQ_STATDEVICE_ATTR(total_trans, 0444, show_total_trans);
-CPUFREQ_STATDEVICE_ATTR(time_in_state, 0444, show_time_in_state);
+static ssize_t store_ignore_idle(struct cpufreq_policy *policy, char *buf)
+{
+	int input;
+	if (sscanf(buf, "%d", &input) != 1)
+		return -EINVAL;
+
+	ignore_idle = input;
+	return 1;
+}
+
+static ssize_t show_ignore_idle(struct cpufreq_policy *policy, char *buf)
+{
+	return sprintf(buf, "%d\n", ignore_idle);
+}
+
+CPUFREQ_STATDEVICE_ATTR(total_trans, 0444, show_total_trans, NULL);
+CPUFREQ_STATDEVICE_ATTR(time_in_state, 0444, show_time_in_state, NULL);
+CPUFREQ_STATDEVICE_ATTR(ignore_idle, 0664, show_ignore_idle, store_ignore_idle);
 
 static struct attribute *default_attrs[] = {
 	&_attr_total_trans.attr,
@@ -304,6 +323,21 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
 	return 0;
 }
 
+void cpufreq_exit_idle(int cpu, unsigned long ticks)
+{
+	struct cpufreq_stats *stat;
+	stat = per_cpu(cpufreq_stats_table, cpu);
+
+	/* Wait until cpu stats is initalized */
+	if (!ignore_idle || !stat || !stat->time_in_state)
+		return;
+
+	spin_lock(&cpufreq_stats_lock);
+	stat->time_in_state[stat->last_index] =
+		cputime_sub(stat->time_in_state[stat->last_index], ticks);
+	spin_unlock(&cpufreq_stats_lock);
+}
+
 static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 					       unsigned long action,
 					       void *hcpu)
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4de02b1..e3f1363 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -256,6 +256,11 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 
 void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state);
 
+#ifdef CONFIG_CPU_FREQ_STAT
+extern void cpufreq_exit_idle(int cpu, unsigned long ticks);
+#else
+#define cpufreq_exit_idle(int cpu, unsigned long ticks) do {} while (0)
+#endif
 
 static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy, unsigned int min, unsigned int max) 
 {
diff --git a/kernel/sched.c b/kernel/sched.c
index c535cc4..feef94c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -54,6 +54,7 @@
 #include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
+#include <linux/cpufreq.h>
 #include <linux/percpu.h>
 #include <linux/kthread.h>
 #include <linux/proc_fs.h>
@@ -5187,6 +5188,7 @@ void account_steal_ticks(unsigned long ticks)
  */
 void account_idle_ticks(unsigned long ticks)
 {
+	cpufreq_exit_idle(smp_processor_id(), ticks);
 	account_idle_time(jiffies_to_cputime(ticks));
 }
 
-- 
1.6.6

