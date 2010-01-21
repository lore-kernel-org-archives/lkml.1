Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122Ab0AUDRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0AUDRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 22:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017Ab0AUDRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 22:17:18 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14914 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab0AUDRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 22:17:17 -0500
From: Mike Chan <mike@android.com>
To: cpufreq@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Miller@fmi.uni-stuttgart.de, tj@kernel.org,
       venkatesh.pallipadi@intel.com, trenn@suse.de, davej@redhat.com,
       Mike Chan <mike@android.com>
Subject: [PATCH 2/2] cpufreq: ondemand: Replace ignore_nice_load with nice_max_freq
Date: Wed, 20 Jan 2010 19:15:37 -0800
Message-Id: <1264043737-2505-2-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264043737-2505-1-git-send-email-mike@android.com>
References: <1264043737-2505-1-git-send-email-mike@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow lower priority threads to scale frequency to specified nice_max_freq.
This allows low priority threads to operate at the most efficient
power/performance frequency.

Often the highest and lowest cpu speeds do not provide the the optimal
performance/power ratios. Latency requirements for normal and high priority
threads require the maximum speed that are not always optimal power wise
inorder to satisfy the requirements.

To enable set nice_max_freq (to a speed lower than the scaling_max_freq).

The governor will first attempt to scale the cpu to policy->max (default)
only using normal and high priority threads. It will ignore nice threads.
If the load is high enough without nice threads then ondemand will scale to
the max speed and exit.

If load for normal and high priority threads are not high enough to increase
the cpu speed, check again including the load from nice threads. Only scale
to the nice_max_freq specified.

Previous behavior is maintained by setting the values below:

+ When nice_max_freq is set to 0, behavior is the current default
(nice is counted for load).

+ When nice_max_freq is set to scaling_min_freq, the behavior is the same
as the original ignore_nice_load == 1. Which counts all nice threads as
idle time when computing cpu load.

**Note: ingore_nice_load has been removed since the same functionality
can be achieved by setting nice_max_freq to scaling_min_freq.

Signed-off-by: Mike Chan <mike@android.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |   96 +++++++++++++++++++++++-------------
 1 files changed, 62 insertions(+), 34 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 3dcf126..e3f537b 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -106,13 +106,13 @@ static struct dbs_tuners {
 	unsigned int sampling_rate;
 	unsigned int up_threshold;
 	unsigned int down_differential;
-	unsigned int ignore_nice;
 	unsigned int powersave_bias;
+	unsigned int nice_max_freq;
 } dbs_tuners_ins = {
 	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
 	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
-	.ignore_nice = 0,
 	.powersave_bias = 0,
+	.nice_max_freq = 0,
 };
 
 static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
@@ -250,7 +250,7 @@ static ssize_t show_##file_name						\
 }
 show_one(sampling_rate, sampling_rate);
 show_one(up_threshold, up_threshold);
-show_one(ignore_nice_load, ignore_nice);
+show_one(nice_max_freq, nice_max_freq);
 show_one(powersave_bias, powersave_bias);
 
 /*** delete after deprecation time ***/
@@ -269,7 +269,7 @@ static ssize_t show_##file_name##_old					\
 }
 show_one_old(sampling_rate);
 show_one_old(up_threshold);
-show_one_old(ignore_nice_load);
+show_one_old(nice_max_freq);
 show_one_old(powersave_bias);
 show_one_old(sampling_rate_min);
 show_one_old(sampling_rate_max);
@@ -318,7 +318,7 @@ static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
 	return count;
 }
 
-static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
+static ssize_t store_nice_max_freq(struct kobject *a, struct attribute *b,
 				      const char *buf, size_t count)
 {
 	unsigned int input;
@@ -330,15 +330,12 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 	if (ret != 1)
 		return -EINVAL;
 
-	if (input > 1)
-		input = 1;
-
 	mutex_lock(&dbs_mutex);
-	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
+	if (input == dbs_tuners_ins.nice_max_freq) { /* nothing to do */
 		mutex_unlock(&dbs_mutex);
 		return count;
 	}
-	dbs_tuners_ins.ignore_nice = input;
+	dbs_tuners_ins.nice_max_freq = input;
 
 	/* we need to re-evaluate prev_cpu_idle */
 	for_each_online_cpu(j) {
@@ -346,7 +343,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info = &per_cpu(od_cpu_dbs_info, j);
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
-		if (dbs_tuners_ins.ignore_nice)
+		if (dbs_tuners_ins.nice_max_freq)
 			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
 
 	}
@@ -382,7 +379,7 @@ __ATTR(_name, 0644, show_##_name, store_##_name)
 
 define_one_rw(sampling_rate);
 define_one_rw(up_threshold);
-define_one_rw(ignore_nice_load);
+define_one_rw(nice_max_freq);
 define_one_rw(powersave_bias);
 
 static struct attribute *dbs_attributes[] = {
@@ -390,7 +387,7 @@ static struct attribute *dbs_attributes[] = {
 	&sampling_rate_min.attr,
 	&sampling_rate.attr,
 	&up_threshold.attr,
-	&ignore_nice_load.attr,
+	&nice_max_freq.attr,
 	&powersave_bias.attr,
 	NULL
 };
@@ -412,7 +409,7 @@ static ssize_t store_##file_name##_old					\
 }
 write_one_old(sampling_rate);
 write_one_old(up_threshold);
-write_one_old(ignore_nice_load);
+write_one_old(nice_max_freq);
 write_one_old(powersave_bias);
 
 #define define_one_rw_old(object, _name)       \
@@ -421,7 +418,7 @@ __ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
 
 define_one_rw_old(sampling_rate_old, sampling_rate);
 define_one_rw_old(up_threshold_old, up_threshold);
-define_one_rw_old(ignore_nice_load_old, ignore_nice_load);
+define_one_rw_old(nice_max_freq_old, nice_max_freq);
 define_one_rw_old(powersave_bias_old, powersave_bias);
 
 static struct attribute *dbs_attributes_old[] = {
@@ -429,7 +426,7 @@ static struct attribute *dbs_attributes_old[] = {
        &sampling_rate_min_old.attr,
        &sampling_rate_old.attr,
        &up_threshold_old.attr,
-       &ignore_nice_load_old.attr,
+       &nice_max_freq_old.attr,
        &powersave_bias_old.attr,
        NULL
 };
@@ -443,20 +440,19 @@ static struct attribute_group dbs_attr_group_old = {
 
 /************************** sysfs end ************************/
 
-static int dbs_freq_increase(struct cpufreq_policy *p, unsigned int target_freq)
+static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 {
 	if (dbs_tuners_ins.powersave_bias)
-		target_freq = powersave_bias_target(p, target_freq,
-				CPUFREQ_RELATION_H);
+		freq = powersave_bias_target(p, freq, CPUFREQ_RELATION_H);
 
-	__cpufreq_driver_target(p, target_freq,
-			dbs_tuners_ins.powersave_bias ?
+	__cpufreq_driver_target(p, freq, dbs_tuners_ins.powersave_bias ?
 			CPUFREQ_RELATION_L : CPUFREQ_RELATION_H);
 }
 
 static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 {
 	unsigned int max_load_freq;
+	unsigned int max_ignore_nice_load_freq;
 
 	struct cpufreq_policy *policy;
 	unsigned int j;
@@ -477,12 +473,13 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 	 */
 
 	/* Get Absolute Load - in terms of freq */
-	max_load_freq = 0;
+	max_load_freq = max_ignore_nice_load_freq = 0;
 
 	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_info_s *j_dbs_info;
 		cputime64_t cur_wall_time, cur_idle_time;
-		unsigned int idle_time, wall_time;
+		unsigned int idle_time,  wall_time;
+		unsigned long cur_nice_jiffies;
 		unsigned int load, load_freq;
 		int freq_avg;
 
@@ -498,9 +495,13 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 				j_dbs_info->prev_cpu_idle);
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
-		if (dbs_tuners_ins.ignore_nice) {
+		freq_avg = __cpufreq_driver_getavg(policy, j);
+		if (freq_avg <= 0)
+			freq_avg = policy->cur;
+
+		if (dbs_tuners_ins.nice_max_freq) {
 			cputime64_t cur_nice;
-			unsigned long cur_nice_jiffies;
+			unsigned nice_idle_time = idle_time;
 
 			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
 					 j_dbs_info->prev_cpu_nice);
@@ -512,27 +513,47 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 					cputime64_to_jiffies64(cur_nice);
 
 			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
-			idle_time += jiffies_to_usecs(cur_nice_jiffies);
+			nice_idle_time += jiffies_to_usecs(cur_nice_jiffies);
+
+			if (wall_time < nice_idle_time)
+				continue;
+
+			load = 100 * (wall_time - nice_idle_time) / wall_time;
+			load_freq = load * freq_avg;
+			if (load_freq > max_ignore_nice_load_freq)
+				max_ignore_nice_load_freq = load_freq;
 		}
 
-		if (unlikely(!wall_time || wall_time < idle_time))
+		if (unlikely(!wall_time || wall_time < idle_time +
+					jiffies_to_usecs(cur_nice_jiffies)))
 			continue;
 
 		load = 100 * (wall_time - idle_time) / wall_time;
 
-		freq_avg = __cpufreq_driver_getavg(policy, j);
-		if (freq_avg <= 0)
-			freq_avg = policy->cur;
-
 		load_freq = load * freq_avg;
 		if (load_freq > max_load_freq)
 			max_load_freq = load_freq;
 	}
 
-	/* Check for frequency increase */
+	/* Check for frequency increase ignoring nice, scale to max */
+	if (max_ignore_nice_load_freq >
+			dbs_tuners_ins.up_threshold * policy->cur) {
+		if (policy->cur < policy->max)
+			dbs_freq_increase(policy, policy->max);
+		return;
+	}
+
+	/*
+	 * If we failed to increase frequency, check again including nice load.
+	 * This time only scale to the specified maximum speed for nice loads.
+	 */
 	if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
-		if (policy->cur != policy->max)
+		/* Standard behavior, scale to max */
+		if (!dbs_tuners_ins.nice_max_freq && policy->cur < policy->max)
 			dbs_freq_increase(policy, policy->max);
+		/* Scale to specified freq if set for nice threads */
+		else if (policy->cur < dbs_tuners_ins.nice_max_freq)
+			dbs_freq_increase(policy, dbs_tuners_ins.nice_max_freq);
 		return;
 	}
 
@@ -542,6 +563,13 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 		return;
 
 	/*
+	 * When nice frequency is set as the min available frequency, ignore
+	 * nice when calculating the load_freq when scaling down.
+	 */
+	if (dbs_tuners_ins.nice_max_freq == policy->min)
+		max_load_freq = max_ignore_nice_load_freq;
+
+	/*
 	 * The optimal frequency is the frequency that is the lowest that
 	 * can support the current CPU usage without triggering the up
 	 * policy. To be safe, we focus 10 points under the threshold.
@@ -645,7 +673,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 			j_dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&j_dbs_info->prev_cpu_wall);
-			if (dbs_tuners_ins.ignore_nice) {
+			if (dbs_tuners_ins.nice_max_freq) {
 				j_dbs_info->prev_cpu_nice =
 						kstat_cpu(j).cpustat.nice;
 			}
-- 
1.6.6

