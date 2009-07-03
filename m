Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbZGCA2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbZGCA2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbZGCA1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:27:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:28041 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbZGCA1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:27:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,337,1243839600"; 
   d="scan'208";a="529835255"
Message-Id: <20090703000924.117666000@intel.com>
References: <20090703000829.735976000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Jul 2009 17:08:32 -0700
From: venkatesh.pallipadi@intel.com
To: "Dave Jones" <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       kernel-testers@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Dave Young" <hidave.darkstar@gmail.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Thomas Renninger" <trenn@suse.de>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
Subject: [patch 3/4] cpufreq: Cleanup locking in ondemand governor
Content-Disposition: inline; filename=0003-cpufreq-Cleanup-locking-in-ondemand-governor.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Redesign the locking inside ondemand driver. Make dbs_mutex handle all the
global state changes inside the driver and invent a new percpu mutex
to serialize percpu timer and frequency limit change.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |   62 +++++++++++++++--------------------
 1 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 246ae14..d6ba142 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -70,8 +70,13 @@ struct cpu_dbs_info_s {
 	unsigned int freq_lo_jiffies;
 	unsigned int freq_hi_jiffies;
 	int cpu;
-	unsigned int enable:1,
-		sample_type:1;
+	unsigned int sample_type:1;
+	/*
+	 * percpu mutex that serializes governor limit change with
+	 * do_dbs_timer invocation. We do not want do_dbs_timer to run
+	 * when user is changing the governor or limits.
+	 */
+	struct mutex timer_mutex;
 };
 static DEFINE_PER_CPU(struct cpu_dbs_info_s, cpu_dbs_info);
 
@@ -79,9 +84,7 @@ static unsigned int dbs_enable;	/* number of CPUs using this policy */
 
 /*
  * dbs_mutex protects data in dbs_tuners_ins from concurrent changes on
- * different CPUs. It protects dbs_enable in governor start/stop. It also
- * serializes governor limit_change with do_dbs_timer. We do not want
- * do_dbs_timer to run when user is changing the governor or limits.
+ * different CPUs. It protects dbs_enable in governor start/stop.
  */
 static DEFINE_MUTEX(dbs_mutex);
 
@@ -187,13 +190,18 @@ static unsigned int powersave_bias_target(struct cpufreq_policy *policy,
 	return freq_hi;
 }
 
+static void ondemand_powersave_bias_init_cpu(int cpu)
+{
+	struct cpu_dbs_info_s *dbs_info = &per_cpu(cpu_dbs_info, cpu);
+	dbs_info->freq_table = cpufreq_frequency_get_table(cpu);
+	dbs_info->freq_lo = 0;
+}
+
 static void ondemand_powersave_bias_init(void)
 {
 	int i;
 	for_each_online_cpu(i) {
-		struct cpu_dbs_info_s *dbs_info = &per_cpu(cpu_dbs_info, i);
-		dbs_info->freq_table = cpufreq_frequency_get_table(i);
-		dbs_info->freq_lo = 0;
+		ondemand_powersave_bias_init_cpu(i);
 	}
 }
 
@@ -235,12 +243,10 @@ static ssize_t store_sampling_rate(struct cpufreq_policy *unused,
 	unsigned int input;
 	int ret;
 	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
 
 	mutex_lock(&dbs_mutex);
-	if (ret != 1) {
-		mutex_unlock(&dbs_mutex);
-		return -EINVAL;
-	}
 	dbs_tuners_ins.sampling_rate = max(input, min_sampling_rate);
 	mutex_unlock(&dbs_mutex);
 
@@ -254,13 +260,12 @@ static ssize_t store_up_threshold(struct cpufreq_policy *unused,
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
-	mutex_lock(&dbs_mutex);
 	if (ret != 1 || input > MAX_FREQUENCY_UP_THRESHOLD ||
 			input < MIN_FREQUENCY_UP_THRESHOLD) {
-		mutex_unlock(&dbs_mutex);
 		return -EINVAL;
 	}
 
+	mutex_lock(&dbs_mutex);
 	dbs_tuners_ins.up_threshold = input;
 	mutex_unlock(&dbs_mutex);
 
@@ -358,9 +363,6 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 	struct cpufreq_policy *policy;
 	unsigned int j;
 
-	if (!this_dbs_info->enable)
-		return;
-
 	this_dbs_info->freq_lo = 0;
 	policy = this_dbs_info->cur_policy;
 
@@ -488,13 +490,7 @@ static void do_dbs_timer(struct work_struct *work)
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 
 	delay -= jiffies % delay;
-
-	mutex_lock(&dbs_mutex);
-
-	if (!dbs_info->enable) {
-		mutex_unlock(&dbs_mutex);
-		return;
-	}
+	mutex_lock(&dbs_info->timer_mutex);
 
 	/* Common NORMAL_SAMPLE setup */
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
@@ -511,7 +507,7 @@ static void do_dbs_timer(struct work_struct *work)
 			dbs_info->freq_lo, CPUFREQ_RELATION_H);
 	}
 	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
-	mutex_unlock(&dbs_mutex);
+	mutex_unlock(&dbs_info->timer_mutex);
 }
 
 static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
@@ -520,8 +516,6 @@ static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 	delay -= jiffies % delay;
 
-	dbs_info->enable = 1;
-	ondemand_powersave_bias_init();
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
 	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
@@ -530,7 +524,6 @@ static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 
 static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
 {
-	dbs_info->enable = 0;
 	cancel_delayed_work_sync(&dbs_info->work);
 }
 
@@ -549,19 +542,15 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		if ((!cpu_online(cpu)) || (!policy->cur))
 			return -EINVAL;
 
-		if (this_dbs_info->enable) /* Already enabled */
-			break;
-
 		mutex_lock(&dbs_mutex);
-		dbs_enable++;
 
 		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
 		if (rc) {
-			dbs_enable--;
 			mutex_unlock(&dbs_mutex);
 			return rc;
 		}
 
+		dbs_enable++;
 		for_each_cpu(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
@@ -575,6 +564,8 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			}
 		}
 		this_dbs_info->cpu = cpu;
+		ondemand_powersave_bias_init_cpu(cpu);
+		mutex_init(&this_dbs_info->timer_mutex);
 		/*
 		 * Start the timerschedule work, when this governor
 		 * is used for first time
@@ -602,20 +593,21 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 		mutex_lock(&dbs_mutex);
 		sysfs_remove_group(&policy->kobj, &dbs_attr_group);
+		mutex_destroy(&this_dbs_info->timer_mutex);
 		dbs_enable--;
 		mutex_unlock(&dbs_mutex);
 
 		break;
 
 	case CPUFREQ_GOV_LIMITS:
-		mutex_lock(&dbs_mutex);
+		mutex_lock(&this_dbs_info->timer_mutex);
 		if (policy->max < this_dbs_info->cur_policy->cur)
 			__cpufreq_driver_target(this_dbs_info->cur_policy,
 				policy->max, CPUFREQ_RELATION_H);
 		else if (policy->min > this_dbs_info->cur_policy->cur)
 			__cpufreq_driver_target(this_dbs_info->cur_policy,
 				policy->min, CPUFREQ_RELATION_L);
-		mutex_unlock(&dbs_mutex);
+		mutex_unlock(&this_dbs_info->timer_mutex);
 		break;
 	}
 	return 0;
-- 
1.6.0.6

-- 

