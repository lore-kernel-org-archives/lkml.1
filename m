Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbZGCP4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbZGCP4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbZGCP4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:56:18 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41400 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758355AbZGCP4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:56:14 -0400
Message-Id: <20090703152715.168962431@polymtl.ca>
References: <20090703152514.903448283@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 03 Jul 2009 11:25:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       cpufreq@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Shaohua Li <shaohua.li@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>, sven.wegener@stealer.net
Subject: [patch 2.6.30 4/4] cpufreq ondemand and conservative remove dbs_mutex
Content-Disposition: inline; filename=cpufreq-ondemand-and-conservative-remove-dbs-mutex.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  3 Jul 2009 15:55:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dbs_mutex is not needed given serialization is provided by the
cpufreq_gov_mutex wrapping all update calls in cpufreq.c.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
CC: rjw@sisk.pl
CC: mingo@elte.hu
CC: Shaohua Li <shaohua.li@intel.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Dave Young <hidave.darkstar@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: sven.wegener@stealer.net
CC: cpufreq@vger.kernel.org
CC: Thomas Renninger <trenn@suse.de>
---
 drivers/cpufreq/cpufreq_conservative.c |   58 ++++++---------------------------
 drivers/cpufreq/cpufreq_ondemand.c     |   50 +++++++---------------------
 2 files changed, 25 insertions(+), 83 deletions(-)

Index: linux-2.6-lttng/drivers/cpufreq/cpufreq_ondemand.c
===================================================================
--- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq_ondemand.c	2009-07-03 10:29:56.000000000 -0400
+++ linux-2.6-lttng/drivers/cpufreq/cpufreq_ondemand.c	2009-07-03 10:30:24.000000000 -0400
@@ -87,23 +87,12 @@ struct cpu_dbs_info_s {
 	unsigned int enable:1,
 		sample_type:1;
 };
+
+/* Protected by cpufreq_gov_mutex in cpufreq.c */
 static DEFINE_PER_CPU(struct cpu_dbs_info_s, cpu_dbs_info);
 
 static unsigned int dbs_enable;	/* number of CPUs using this policy */
 
-/*
- * DEADLOCK ALERT! There is a ordering requirement between cpu_hotplug
- * lock and dbs_mutex. cpu_hotplug lock should always be held before
- * dbs_mutex. If any function that can potentially take cpu_hotplug lock
- * (like __cpufreq_driver_target()) is being called with dbs_mutex taken, then
- * cpu_hotplug lock should be taken before that. Note that cpu_hotplug lock
- * is recursive for the same process. -Venki
- * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the dbs_mutex, because it
- * would deadlock with cancel_delayed_work_sync(), which is needed for proper
- * raceless workqueue teardown.
- */
-static DEFINE_MUTEX(dbs_mutex);
-
 static struct workqueue_struct	*kondemand_wq;
 
 static struct dbs_tuners {
@@ -269,13 +258,10 @@ static ssize_t store_sampling_rate(struc
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
-	mutex_lock(&dbs_mutex);
-	if (ret != 1) {
-		mutex_unlock(&dbs_mutex);
+	if (ret != 1)
 		return -EINVAL;
-	}
+
 	dbs_tuners_ins.sampling_rate = max(input, minimum_sampling_rate());
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -287,15 +273,11 @@ static ssize_t store_up_threshold(struct
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
-	mutex_lock(&dbs_mutex);
 	if (ret != 1 || input > MAX_FREQUENCY_UP_THRESHOLD ||
-			input < MIN_FREQUENCY_UP_THRESHOLD) {
-		mutex_unlock(&dbs_mutex);
+			input < MIN_FREQUENCY_UP_THRESHOLD)
 		return -EINVAL;
-	}
 
 	dbs_tuners_ins.up_threshold = input;
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -315,11 +297,8 @@ static ssize_t store_ignore_nice_load(st
 	if (input > 1)
 		input = 1;
 
-	mutex_lock(&dbs_mutex);
-	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
-		mutex_unlock(&dbs_mutex);
+	if (input == dbs_tuners_ins.ignore_nice) /* nothing to do */
 		return count;
-	}
 	dbs_tuners_ins.ignore_nice = input;
 
 	/* we need to re-evaluate prev_cpu_idle */
@@ -332,7 +311,6 @@ static ssize_t store_ignore_nice_load(st
 			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
 
 	}
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -350,10 +328,8 @@ static ssize_t store_powersave_bias(stru
 	if (input > 1000)
 		input = 1000;
 
-	mutex_lock(&dbs_mutex);
 	dbs_tuners_ins.powersave_bias = input;
 	ondemand_powersave_bias_init();
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -568,6 +544,12 @@ static inline void dbs_timer_exit(struct
 	cancel_delayed_work_sync(&dbs_info->work);
 }
 
+/*
+ * Always called with cpufreq_gov_mutex held.
+ * Called with lock_policy_rwsem write lock held except for GOV_STOP.
+ * Called with only cpufreq_gov_mutex held for GOV_STOP for timer sync
+ * teardown.
+ */
 static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				   unsigned int event)
 {
@@ -586,13 +568,11 @@ static int cpufreq_governor_dbs(struct c
 		if (this_dbs_info->enable) /* Already enabled */
 			break;
 
-		mutex_lock(&dbs_mutex);
 		dbs_enable++;
 
 		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
 		if (rc) {
 			dbs_enable--;
-			mutex_unlock(&dbs_mutex);
 			return rc;
 		}
 
@@ -628,27 +608,23 @@ static int cpufreq_governor_dbs(struct c
 		}
 		dbs_timer_init(this_dbs_info);
 
-		mutex_unlock(&dbs_mutex);
 		break;
 
 	case CPUFREQ_GOV_STOP:
-		mutex_lock(&dbs_mutex);
 		dbs_timer_exit(this_dbs_info);
 		sysfs_remove_group(&policy->kobj, &dbs_attr_group);
 		dbs_enable--;
-		mutex_unlock(&dbs_mutex);
 
 		break;
 
 	case CPUFREQ_GOV_LIMITS:
-		mutex_lock(&dbs_mutex);
 		if (policy->max < this_dbs_info->cur_policy->cur)
 			__cpufreq_driver_target(this_dbs_info->cur_policy,
 				policy->max, CPUFREQ_RELATION_H);
 		else if (policy->min > this_dbs_info->cur_policy->cur)
 			__cpufreq_driver_target(this_dbs_info->cur_policy,
 				policy->min, CPUFREQ_RELATION_L);
-		mutex_unlock(&dbs_mutex);
+
 		break;
 	}
 	return 0;
Index: linux-2.6-lttng/drivers/cpufreq/cpufreq_conservative.c
===================================================================
--- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq_conservative.c	2009-07-03 10:29:56.000000000 -0400
+++ linux-2.6-lttng/drivers/cpufreq/cpufreq_conservative.c	2009-07-03 10:30:24.000000000 -0400
@@ -80,23 +80,12 @@ struct cpu_dbs_info_s {
 	int cpu;
 	unsigned int enable:1;
 };
+
+/* Protected by cpufreq_gov_mutex in cpufreq.c */
 static DEFINE_PER_CPU(struct cpu_dbs_info_s, cpu_dbs_info);
 
 static unsigned int dbs_enable;	/* number of CPUs using this policy */
 
-/*
- * DEADLOCK ALERT! There is a ordering requirement between cpu_hotplug
- * lock and dbs_mutex. cpu_hotplug lock should always be held before
- * dbs_mutex. If any function that can potentially take cpu_hotplug lock
- * (like __cpufreq_driver_target()) is being called with dbs_mutex taken, then
- * cpu_hotplug lock should be taken before that. Note that cpu_hotplug lock
- * is recursive for the same process. -Venki
- * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the dbs_mutex, because it
- * would deadlock with cancel_delayed_work_sync(), which is needed for proper
- * raceless workqueue teardown.
- */
-static DEFINE_MUTEX(dbs_mutex);
-
 static struct workqueue_struct	*kconservative_wq;
 
 static struct dbs_tuners {
@@ -236,9 +225,7 @@ static ssize_t store_sampling_down_facto
 	if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
 		return -EINVAL;
 
-	mutex_lock(&dbs_mutex);
 	dbs_tuners_ins.sampling_down_factor = input;
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -253,9 +240,7 @@ static ssize_t store_sampling_rate(struc
 	if (ret != 1)
 		return -EINVAL;
 
-	mutex_lock(&dbs_mutex);
 	dbs_tuners_ins.sampling_rate = max(input, minimum_sampling_rate());
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -267,15 +252,11 @@ static ssize_t store_up_threshold(struct
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
-	mutex_lock(&dbs_mutex);
 	if (ret != 1 || input > 100 ||
-			input <= dbs_tuners_ins.down_threshold) {
-		mutex_unlock(&dbs_mutex);
+			input <= dbs_tuners_ins.down_threshold)
 		return -EINVAL;
-	}
 
 	dbs_tuners_ins.up_threshold = input;
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -287,16 +268,12 @@ static ssize_t store_down_threshold(stru
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
-	mutex_lock(&dbs_mutex);
 	/* cannot be lower than 11 otherwise freq will not fall */
 	if (ret != 1 || input < 11 || input > 100 ||
-			input >= dbs_tuners_ins.up_threshold) {
-		mutex_unlock(&dbs_mutex);
+			input >= dbs_tuners_ins.up_threshold)
 		return -EINVAL;
-	}
 
 	dbs_tuners_ins.down_threshold = input;
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -316,11 +293,8 @@ static ssize_t store_ignore_nice_load(st
 	if (input > 1)
 		input = 1;
 
-	mutex_lock(&dbs_mutex);
-	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
-		mutex_unlock(&dbs_mutex);
+	if (input == dbs_tuners_ins.ignore_nice) /* nothing to do */
 		return count;
-	}
 	dbs_tuners_ins.ignore_nice = input;
 
 	/* we need to re-evaluate prev_cpu_idle */
@@ -332,7 +306,6 @@ static ssize_t store_ignore_nice_load(st
 		if (dbs_tuners_ins.ignore_nice)
 			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
 	}
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -352,9 +325,7 @@ static ssize_t store_freq_step(struct cp
 
 	/* no need to test here if freq_step is zero as the user might actually
 	 * want this, they would be crazy though :) */
-	mutex_lock(&dbs_mutex);
 	dbs_tuners_ins.freq_step = input;
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -548,6 +519,12 @@ static inline void dbs_timer_exit(struct
 	cancel_delayed_work_sync(&dbs_info->work);
 }
 
+/*
+ * Always called with cpufreq_gov_mutex held.
+ * Called with lock_policy_rwsem write lock held except for GOV_STOP.
+ * Called with only cpufreq_gov_mutex held for GOV_STOP for timer sync
+ * teardown.
+ */
 static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				   unsigned int event)
 {
@@ -566,13 +543,9 @@ static int cpufreq_governor_dbs(struct c
 		if (this_dbs_info->enable) /* Already enabled */
 			break;
 
-		mutex_lock(&dbs_mutex);
-
 		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
-		if (rc) {
-			mutex_unlock(&dbs_mutex);
+		if (rc)
 			return rc;
-		}
 
 		for_each_cpu(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
@@ -613,12 +586,9 @@ static int cpufreq_governor_dbs(struct c
 		}
 		dbs_timer_init(this_dbs_info);
 
-		mutex_unlock(&dbs_mutex);
-
 		break;
 
 	case CPUFREQ_GOV_STOP:
-		mutex_lock(&dbs_mutex);
 		dbs_timer_exit(this_dbs_info);
 		sysfs_remove_group(&policy->kobj, &dbs_attr_group);
 		dbs_enable--;
@@ -632,12 +602,9 @@ static int cpufreq_governor_dbs(struct c
 					&dbs_cpufreq_notifier_block,
 					CPUFREQ_TRANSITION_NOTIFIER);
 
-		mutex_unlock(&dbs_mutex);
-
 		break;
 
 	case CPUFREQ_GOV_LIMITS:
-		mutex_lock(&dbs_mutex);
 		if (policy->max < this_dbs_info->cur_policy->cur)
 			__cpufreq_driver_target(
 					this_dbs_info->cur_policy,
@@ -646,7 +613,6 @@ static int cpufreq_governor_dbs(struct c
 			__cpufreq_driver_target(
 					this_dbs_info->cur_policy,
 					policy->min, CPUFREQ_RELATION_L);
-		mutex_unlock(&dbs_mutex);
 
 		break;
 	}

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
