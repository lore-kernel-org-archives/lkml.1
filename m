Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876Ab0A0BIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0A0BIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409Ab0A0BIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:08:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:21125 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab0A0BIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:08:07 -0500
From: Mike Chan <mike@android.com>
Cc: Mike Chan <mike@android.com>, Dave Jones <davej@redhat.com>,
       Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>,
       Alexander Miller <Miller@fmi.uni-stuttgart.de>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] cpufreq: ondemand: Independent max speed for nice threads with nice_max_freq
Date: Tue, 26 Jan 2010 17:06:48 -0800
Message-Id: <1264554408-20966-2-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264554408-20966-1-git-send-email-mike@android.com>
References: <1264554408-20966-1-git-send-email-mike@android.com>
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
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

*** v2 ***
+ The ignore_nice_load sysfs still behaves the same as before (0/1) and is
kept around for legacy support. Userspace scripts should now use
nice_max_freq.

*** v3 ***
Fixed: Properly scale freq if powersave_bias is enabled.

Signed-off-by: Mike Chan <mike@android.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |  156 ++++++++++++++++++++++++++----------
 1 files changed, 113 insertions(+), 43 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 516d0fe..92727c4 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -1,5 +1,4 @@
-/*
- *  drivers/cpufreq/cpufreq_ondemand.c
+/* *  drivers/cpufreq/cpufreq_ondemand.c
  *
  *  Copyright (C)  2001 Russell King
  *            (C)  2003 Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>.
@@ -108,11 +107,13 @@ static struct dbs_tuners {
 	unsigned int down_differential;
 	unsigned int ignore_nice;
 	unsigned int powersave_bias;
+	unsigned int nice_max_freq;
 } dbs_tuners_ins = {
 	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
 	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
 	.ignore_nice = 0,
 	.powersave_bias = 0,
+	.nice_max_freq = 0,
 };
 
 static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
@@ -251,6 +252,7 @@ static ssize_t show_##file_name						\
 show_one(sampling_rate, sampling_rate);
 show_one(up_threshold, up_threshold);
 show_one(ignore_nice_load, ignore_nice);
+show_one(nice_max_freq, nice_max_freq);
 show_one(powersave_bias, powersave_bias);
 
 /*** delete after deprecation time ***/
@@ -318,27 +320,60 @@ static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
 	return count;
 }
 
+/*
+ * Preserve ignore_nice_load behavior, if enabled do not allow low priority
+ * threads to scale beyond the minimum frequency.
+ */
 static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 				      const char *buf, size_t count)
 {
-	unsigned int input;
-	int ret;
-
+	unsigned long input;
 	unsigned int j;
 
-	ret = sscanf(buf, "%u", &input);
-	if (ret != 1)
+	printk_once(KERN_INFO "CPUFREQ: ondemand ignore_nice_load"
+	       "sysfs file is deprecated - use nice_max_freq instead");
+
+	if (strict_strtoul(buf, 10, &input) < 0)
 		return -EINVAL;
 
 	if (input > 1)
 		input = 1;
 
 	mutex_lock(&dbs_mutex);
-	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
+	dbs_tuners_ins.ignore_nice = input;
+
+	for_each_online_cpu(j) {
+		struct cpufreq_policy *policy;
+		struct cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, j);
+		policy = dbs_info->cur_policy;
+
+		if (input && policy->min < dbs_tuners_ins.nice_max_freq)
+				dbs_tuners_ins.nice_max_freq = policy->min;
+		else if (!input && policy->max > dbs_tuners_ins.nice_max_freq)
+				dbs_tuners_ins.nice_max_freq = policy->max;
+	}
+	mutex_unlock(&dbs_mutex);
+
+	return count;
+}
+
+static ssize_t store_nice_max_freq(struct kobject *a, struct attribute *b,
+				      const char *buf, size_t count)
+{
+	unsigned long input;
+	int ret;
+
+	unsigned int j;
+
+	if (strict_strtoul(buf, 10, &input) < 0)
+		return -EINVAL;
+
+	mutex_lock(&dbs_mutex);
+	if (input == dbs_tuners_ins.nice_max_freq) { /* nothing to do */
 		mutex_unlock(&dbs_mutex);
 		return count;
 	}
-	dbs_tuners_ins.ignore_nice = input;
+	dbs_tuners_ins.nice_max_freq = input;
 
 	/* we need to re-evaluate prev_cpu_idle */
 	for_each_online_cpu(j) {
@@ -346,9 +381,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info = &per_cpu(od_cpu_dbs_info, j);
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
-		if (dbs_tuners_ins.ignore_nice)
-			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
-
+		dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
 	}
 	mutex_unlock(&dbs_mutex);
 
@@ -383,6 +416,7 @@ __ATTR(_name, 0644, show_##_name, store_##_name)
 define_one_rw(sampling_rate);
 define_one_rw(up_threshold);
 define_one_rw(ignore_nice_load);
+define_one_rw(nice_max_freq);
 define_one_rw(powersave_bias);
 
 static struct attribute *dbs_attributes[] = {
@@ -391,6 +425,7 @@ static struct attribute *dbs_attributes[] = {
 	&sampling_rate.attr,
 	&up_threshold.attr,
 	&ignore_nice_load.attr,
+	&nice_max_freq.attr,
 	&powersave_bias.attr,
 	NULL
 };
@@ -457,6 +492,8 @@ static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 {
 	unsigned int max_load_freq;
+	unsigned int max_ignore_nice_load_freq;
+	unsigned int down_load_freq;
 
 	struct cpufreq_policy *policy;
 	unsigned int j;
@@ -477,12 +514,14 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 	 */
 
 	/* Get Absolute Load - in terms of freq */
-	max_load_freq = 0;
+	max_load_freq = max_ignore_nice_load_freq = 0;
 
 	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_info_s *j_dbs_info;
 		cputime64_t cur_wall_time, cur_idle_time;
+		cputime64_t cur_nice;
 		unsigned int idle_time, wall_time;
+		unsigned long cur_nice_jiffies;
 		unsigned int load, load_freq;
 		int freq_avg;
 
@@ -498,43 +537,57 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 				j_dbs_info->prev_cpu_idle);
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
-		if (dbs_tuners_ins.ignore_nice) {
-			cputime64_t cur_nice;
-			unsigned long cur_nice_jiffies;
-
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
-					 j_dbs_info->prev_cpu_nice);
-			/*
-			 * Assumption: nice time between sampling periods will
-			 * be less than 2^32 jiffies for 32 bit sys
-			 */
-			cur_nice_jiffies = (unsigned long)
-					cputime64_to_jiffies64(cur_nice);
-
-			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
-			idle_time += jiffies_to_usecs(cur_nice_jiffies);
-		}
-
 		if (unlikely(!wall_time || wall_time < idle_time))
 			continue;
 
-		load = 100 * (wall_time - idle_time) / wall_time;
-
 		freq_avg = __cpufreq_driver_getavg(policy, j);
 		if (freq_avg <= 0)
 			freq_avg = policy->cur;
 
+		/* Calculate load with with idle */
+		load = 100 * (wall_time - idle_time) / wall_time;
 		load_freq = load * freq_avg;
 		if (load_freq > max_load_freq)
 			max_load_freq = load_freq;
+
+		cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
+				j_dbs_info->prev_cpu_nice);
+		/*
+		 * Assumption: nice time between sampling periods will
+		 * be less than 2^32 jiffies for 32 bit sys
+		 */
+		cur_nice_jiffies =
+			(unsigned long) cputime64_to_jiffies64(cur_nice);
+
+		j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+		idle_time += jiffies_to_usecs(cur_nice_jiffies);
+
+		if (unlikely(!wall_time || wall_time < idle_time))
+			continue;
+
+		/* Calculate load with without idle */
+		load = 100 * (wall_time - idle_time) / wall_time;
+		load_freq = load * freq_avg;
+		if (load_freq > max_ignore_nice_load_freq)
+			max_ignore_nice_load_freq = load_freq;
 	}
 
-	/* Check for frequency increase */
-	if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
+	/* Check for frequency increase ignoring nice, scale to max */
+	if (max_ignore_nice_load_freq >
+			dbs_tuners_ins.up_threshold * policy->cur) {
 		dbs_freq_increase(policy, policy->max);
 		return;
 	}
 
+	/*
+	 * If we failed to increase frequency, check again including nice load.
+	 * This time only scale to the specified maximum speed for nice loads.
+	 */
+	if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
+		dbs_freq_increase(policy, dbs_tuners_ins.nice_max_freq);
+		return;
+	}
+
 	/* Check for frequency decrease */
 	/* if we cannot reduce the frequency anymore, break out early */
 	if (policy->cur == policy->min)
@@ -545,14 +598,31 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 	 * can support the current CPU usage without triggering the up
 	 * policy. To be safe, we focus 10 points under the threshold.
 	 */
-	if (max_load_freq <
-	    (dbs_tuners_ins.up_threshold - dbs_tuners_ins.down_differential) *
-	     policy->cur) {
+	down_load_freq = (dbs_tuners_ins.up_threshold -
+			dbs_tuners_ins.down_differential) * policy->cur;
+
+	/* First attempt to scale down ignoring low priority threads */
+	if (max_ignore_nice_load_freq < down_load_freq) {
 		unsigned int freq_next;
-		freq_next = max_load_freq /
+		freq_next = max_ignore_nice_load_freq /
+				(dbs_tuners_ins.up_threshold -
+				 dbs_tuners_ins.down_differential);
+
+		/*
+		 * If freq_next is below nice_max, recalculate frequency
+		 * factoring in nice threads. We do not want to cripple
+		 * nice threads.
+		 */
+		if (freq_next < dbs_tuners_ins.nice_max_freq &&
+				max_load_freq < down_load_freq) {
+			freq_next = max_load_freq /
 				(dbs_tuners_ins.up_threshold -
 				 dbs_tuners_ins.down_differential);
 
+			if (freq_next > dbs_tuners_ins.nice_max_freq)
+				freq_next = dbs_tuners_ins.nice_max_freq;
+		}
+
 		if (!dbs_tuners_ins.powersave_bias) {
 			__cpufreq_driver_target(policy, freq_next,
 					CPUFREQ_RELATION_L);
@@ -641,13 +711,13 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
-
 			j_dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&j_dbs_info->prev_cpu_wall);
-			if (dbs_tuners_ins.ignore_nice) {
-				j_dbs_info->prev_cpu_nice =
-						kstat_cpu(j).cpustat.nice;
-			}
+			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+
+			/* Take the largest policy->max frequency */
+			if (dbs_tuners_ins.nice_max_freq < policy->max)
+				dbs_tuners_ins.nice_max_freq = policy->max;
 		}
 		this_dbs_info->cpu = cpu;
 		ondemand_powersave_bias_init_cpu(cpu);
-- 
1.6.6

