Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZG1W2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZG1W2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZG1W2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:28:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:33096 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbZG1W2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:28:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,285,1246863600"; 
   d="scan'208";a="169891943"
Date: Tue, 28 Jul 2009 15:28:29 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] ondemand: Make kondemand workqueue run with dynamic sched priority
Message-ID: <20090728222829.GA10406@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Problem 1:
If a real time process starts while the CPU is at a lower frequency,
and runs for a long time, CPU will continue to be at low freq during the
run, as kondemand thread will never get a chance to run (due to its
non-rt priority). RT thread performance will be low due to CPU
running at lower frequency.

Simple solution for problem 1:
Make kondemand workqueue RT priority.

Problem 2:
kondemand work need not interrupt a running process, when CPU is already
at its highest frequency. At this point kondemand should only run when
CPU goes idle and check whether it has to reduce the freq.
Simple solution to Problem 1 above magnifies this Problem 2, as now
kondemand will interrupt RT threads as well, even when CPU is at highest
frequency.

Solution:
One solutions here is to make kondemand, a workqueue with dynamic sched
priority. The driver will know what freq CPU is at based on which it
can set the priority of kondemand.
With this RFC:
kondemand will have a priority of SCHED_FIFO:90 when CPU is not
at its highest frequency.
kondemand will have a priority of SCHED_IDLE whcn CPU is already at its
highest frequency.
kondemand will have SCHED_NORMAL when non-standard ondemand powerbias
option is set.

This mostly resolves Problem 1 for all cases except when the user task
also has a priority of SCHED_FIFO:90 or higher. In all other RT cases,
ondemand will indeed increase the frequency based on CPU utilization. In
the case where user has RT priority of 90 or higher, user probably knows
what he is doing.

This mostly resolves Problem 2, in that kondemand will not run as
frequently as before, when CPU is already at its highest frequency.
In my experiment, with HZ=1000, when CPU is 100% busy and already
at its highest frequency, I saw kondemand woken up 100 times a second
without this patch. With this patch (using SCHED_IDLE), in the same
situation, kondemand is woken up 9 times a second.

Some alternatives I thought of before going this path:
- Using a bit in timer to add run the timer only on idle flag, similar
  to existing deferrable timer.
- Using idle notifiers to schedule the work.

Comments about "mostly resolves" part. Any better alternatives here?
Comments about the way workqueue sched priority is being changed here.
Is it better to have a generic workqueue APIs instead of doing this in
the driver by hand?

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 drivers/cpufreq/cpufreq_ondemand.c |   53 ++++++++++++++++++++++++++++++++---
 include/linux/kthread.h            |    2 +
 kernel/kthread.c                   |    2 -
 3 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index d6ba142..ca291b1 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -22,6 +22,7 @@
 #include <linux/tick.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/kthread.h>
 
 /*
  * dbs is used in this file as a shortform for demandbased switching
@@ -59,6 +60,9 @@ static void do_dbs_timer(struct work_struct *work);
 /* Sampling types */
 enum {DBS_NORMAL_SAMPLE, DBS_SUB_SAMPLE};
 
+/* Schedule priority levels */
+enum {DBS_PRIO_LOW, DBS_PRIO_MED, DBS_PRIO_HIGH};
+
 struct cpu_dbs_info_s {
 	cputime64_t prev_cpu_idle;
 	cputime64_t prev_cpu_wall;
@@ -70,6 +74,7 @@ struct cpu_dbs_info_s {
 	unsigned int freq_lo_jiffies;
 	unsigned int freq_hi_jiffies;
 	int cpu;
+	unsigned int prio:2;
 	unsigned int sample_type:1;
 	/*
 	 * percpu mutex that serializes governor limit change with
@@ -356,7 +361,7 @@ static struct attribute_group dbs_attr_group = {
 
 /************************** sysfs end ************************/
 
-static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
+static unsigned int dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 {
 	unsigned int max_load_freq;
 
@@ -436,23 +441,24 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 		/* if we are already at full speed then break out early */
 		if (!dbs_tuners_ins.powersave_bias) {
 			if (policy->cur == policy->max)
-				return;
+				return DBS_PRIO_LOW;
 
 			__cpufreq_driver_target(policy, policy->max,
 				CPUFREQ_RELATION_H);
+			return DBS_PRIO_LOW;
 		} else {
 			int freq = powersave_bias_target(policy, policy->max,
 					CPUFREQ_RELATION_H);
 			__cpufreq_driver_target(policy, freq,
 				CPUFREQ_RELATION_L);
+			return DBS_PRIO_MED;
 		}
-		return;
 	}
 
 	/* Check for frequency decrease */
 	/* if we cannot reduce the frequency anymore, break out early */
 	if (policy->cur == policy->min)
-		return;
+		return DBS_PRIO_HIGH;
 
 	/*
 	 * The optimal frequency is the frequency that is the lowest that
@@ -470,13 +476,16 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 		if (!dbs_tuners_ins.powersave_bias) {
 			__cpufreq_driver_target(policy, freq_next,
 					CPUFREQ_RELATION_L);
+			return DBS_PRIO_HIGH;
 		} else {
 			int freq = powersave_bias_target(policy, freq_next,
 					CPUFREQ_RELATION_L);
 			__cpufreq_driver_target(policy, freq,
 				CPUFREQ_RELATION_L);
+			return DBS_PRIO_MED;
 		}
 	}
+	return this_dbs_info->prio;
 }
 
 static void do_dbs_timer(struct work_struct *work)
@@ -485,6 +494,7 @@ static void do_dbs_timer(struct work_struct *work)
 		container_of(work, struct cpu_dbs_info_s, work.work);
 	unsigned int cpu = dbs_info->cpu;
 	int sample_type = dbs_info->sample_type;
+	int next_prio = DBS_PRIO_MED;
 
 	/* We want all CPUs to do sampling nearly on same jiffy */
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
@@ -496,16 +506,48 @@ static void do_dbs_timer(struct work_struct *work)
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	if (!dbs_tuners_ins.powersave_bias ||
 	    sample_type == DBS_NORMAL_SAMPLE) {
-		dbs_check_cpu(dbs_info);
+		next_prio = dbs_check_cpu(dbs_info);
 		if (dbs_info->freq_lo) {
 			/* Setup timer for SUB_SAMPLE */
 			dbs_info->sample_type = DBS_SUB_SAMPLE;
 			delay = dbs_info->freq_hi_jiffies;
+			/* override priority when powersave_bias is involved */
+			next_prio = DBS_PRIO_MED;
 		}
 	} else {
 		__cpufreq_driver_target(dbs_info->cur_policy,
 			dbs_info->freq_lo, CPUFREQ_RELATION_H);
 	}
+
+	if (dbs_info->prio != next_prio) {
+		struct sched_param param;
+		int policy;
+		switch (next_prio) {
+		    case DBS_PRIO_HIGH:
+			param.sched_priority = MAX_RT_PRIO - 10;
+			policy = SCHED_FIFO;
+			break;
+
+		    case DBS_PRIO_LOW:
+			param.sched_priority = 0;
+			policy = SCHED_IDLE;
+			break;
+
+		    case DBS_PRIO_MED:
+		    default:
+			param.sched_priority = 0;
+			policy = SCHED_NORMAL;
+			break;
+		}
+
+		dbs_info->prio = next_prio;
+		sched_setscheduler(current, policy, &param);
+
+		if (next_prio == DBS_PRIO_MED)
+			set_user_nice(current, KTHREAD_NICE_LEVEL);
+
+	}
+
 	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
 	mutex_unlock(&dbs_info->timer_mutex);
 }
@@ -516,6 +558,7 @@ static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 	delay -= jiffies % delay;
 
+	dbs_info->prio = 0;
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
 	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index aabc8a1..464f743 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -4,6 +4,8 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 
+#define KTHREAD_NICE_LEVEL (-5)
+
 struct task_struct *kthread_create(int (*threadfn)(void *data),
 				   void *data,
 				   const char namefmt[], ...)
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 9b1a7de..084c4db 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -16,8 +16,6 @@
 #include <linux/mutex.h>
 #include <trace/events/sched.h>
 
-#define KTHREAD_NICE_LEVEL (-5)
-
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
 struct task_struct *kthreadd_task;
-- 
1.6.0.6

