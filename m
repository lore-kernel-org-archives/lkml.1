Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZFWSSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZFWSSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZFWSSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:18:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbZFWSSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:18:39 -0400
Date: Tue, 23 Jun 2009 20:17:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org, mark.langsdorf@amd.com,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: [PATCH] cpufreq: remove dbs_mutex
Message-ID: <20090623181748.GA31148@elte.hu>
References: <4A2835D8.6040903@kernel.org> <20090611105211.GA6760@elte.hu> <20090620124817.GA22831@elte.hu> <200906212155.49849.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906212155.49849.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Renninger <trenn@suse.de> wrote:

> > Note, this bug warning still triggers rather frequently with 
> > latest -git (fb20871) during bootup on two test-systems - 
> > relevant portion of the bootlog attached below. As usual i can 
> > test any fix for this.
>
> Best rip out the dbs_mutex in drivers/cpufreq/cpufreq_ondemand.c 
> totally. I can provide several locking cleanups for cpufreq for 
> .31 the next days, including dbs_mutex removal, which I think is 
> not needed. The dbs_mutex removal which should fix this could then 
> be marked: CC: stable@kernel.org

drivers/cpufreq/cpufreq_conservative.c too i guess?

Something like the patch below?

Utterly untested and such.

	Ingo

---------------->
>From 750e2309db0287a979f4295aeaef68d39bacd124 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 23 Jun 2009 20:12:48 +0200
Subject: [PATCH] cpufreq: remove dbs_mutex

As per the cpufreq people's recommendation, remove all uses of
dbs_mutex.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/cpufreq/cpufreq_conservative.c |   40 --------------------------------
 drivers/cpufreq/cpufreq_ondemand.c     |   31 ------------------------
 2 files changed, 0 insertions(+), 71 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 7fc58af..3c427f5 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -69,19 +69,6 @@ static DEFINE_PER_CPU(struct cpu_dbs_info_s, cpu_dbs_info);
 
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
@@ -208,9 +195,7 @@ static ssize_t store_sampling_down_factor(struct cpufreq_policy *unused,
 	if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
 		return -EINVAL;
 
-	mutex_lock(&dbs_mutex);
 	dbs_tuners_ins.sampling_down_factor = input;
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -225,9 +210,7 @@ static ssize_t store_sampling_rate(struct cpufreq_policy *unused,
 	if (ret != 1)
 		return -EINVAL;
 
-	mutex_lock(&dbs_mutex);
 	dbs_tuners_ins.sampling_rate = max(input, min_sampling_rate);
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -239,15 +222,12 @@ static ssize_t store_up_threshold(struct cpufreq_policy *unused,
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
-	mutex_lock(&dbs_mutex);
 	if (ret != 1 || input > 100 ||
 			input <= dbs_tuners_ins.down_threshold) {
-		mutex_unlock(&dbs_mutex);
 		return -EINVAL;
 	}
 
 	dbs_tuners_ins.up_threshold = input;
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -259,16 +239,13 @@ static ssize_t store_down_threshold(struct cpufreq_policy *unused,
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
-	mutex_lock(&dbs_mutex);
 	/* cannot be lower than 11 otherwise freq will not fall */
 	if (ret != 1 || input < 11 || input > 100 ||
 			input >= dbs_tuners_ins.up_threshold) {
-		mutex_unlock(&dbs_mutex);
 		return -EINVAL;
 	}
 
 	dbs_tuners_ins.down_threshold = input;
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -288,9 +265,7 @@ static ssize_t store_ignore_nice_load(struct cpufreq_policy *policy,
 	if (input > 1)
 		input = 1;
 
-	mutex_lock(&dbs_mutex);
 	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
-		mutex_unlock(&dbs_mutex);
 		return count;
 	}
 	dbs_tuners_ins.ignore_nice = input;
@@ -304,7 +279,6 @@ static ssize_t store_ignore_nice_load(struct cpufreq_policy *policy,
 		if (dbs_tuners_ins.ignore_nice)
 			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
 	}
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -324,9 +298,7 @@ static ssize_t store_freq_step(struct cpufreq_policy *policy,
 
 	/* no need to test here if freq_step is zero as the user might actually
 	 * want this, they would be crazy though :) */
-	mutex_lock(&dbs_mutex);
 	dbs_tuners_ins.freq_step = input;
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -538,11 +510,8 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		if (this_dbs_info->enable) /* Already enabled */
 			break;
 
-		mutex_lock(&dbs_mutex);
-
 		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
 		if (rc) {
-			mutex_unlock(&dbs_mutex);
 			return rc;
 		}
 
@@ -592,12 +561,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
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
@@ -610,13 +576,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			cpufreq_unregister_notifier(
 					&dbs_cpufreq_notifier_block,
 					CPUFREQ_TRANSITION_NOTIFIER);
-
-		mutex_unlock(&dbs_mutex);
-
 		break;
 
 	case CPUFREQ_GOV_LIMITS:
-		mutex_lock(&dbs_mutex);
 		if (policy->max < this_dbs_info->cur_policy->cur)
 			__cpufreq_driver_target(
 					this_dbs_info->cur_policy,
@@ -625,8 +587,6 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			__cpufreq_driver_target(
 					this_dbs_info->cur_policy,
 					policy->min, CPUFREQ_RELATION_L);
-		mutex_unlock(&dbs_mutex);
-
 		break;
 	}
 	return 0;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 1911d17..054c10b 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -77,19 +77,6 @@ static DEFINE_PER_CPU(struct cpu_dbs_info_s, cpu_dbs_info);
 
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
@@ -241,13 +228,10 @@ static ssize_t store_sampling_rate(struct cpufreq_policy *unused,
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
-	mutex_lock(&dbs_mutex);
 	if (ret != 1) {
-		mutex_unlock(&dbs_mutex);
 		return -EINVAL;
 	}
 	dbs_tuners_ins.sampling_rate = max(input, min_sampling_rate);
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -259,15 +243,12 @@ static ssize_t store_up_threshold(struct cpufreq_policy *unused,
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
-	mutex_lock(&dbs_mutex);
 	if (ret != 1 || input > MAX_FREQUENCY_UP_THRESHOLD ||
 			input < MIN_FREQUENCY_UP_THRESHOLD) {
-		mutex_unlock(&dbs_mutex);
 		return -EINVAL;
 	}
 
 	dbs_tuners_ins.up_threshold = input;
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -287,9 +268,7 @@ static ssize_t store_ignore_nice_load(struct cpufreq_policy *policy,
 	if (input > 1)
 		input = 1;
 
-	mutex_lock(&dbs_mutex);
 	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
-		mutex_unlock(&dbs_mutex);
 		return count;
 	}
 	dbs_tuners_ins.ignore_nice = input;
@@ -304,7 +283,6 @@ static ssize_t store_ignore_nice_load(struct cpufreq_policy *policy,
 			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
 
 	}
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -322,10 +300,8 @@ static ssize_t store_powersave_bias(struct cpufreq_policy *unused,
 	if (input > 1000)
 		input = 1000;
 
-	mutex_lock(&dbs_mutex);
 	dbs_tuners_ins.powersave_bias = input;
 	ondemand_powersave_bias_init();
-	mutex_unlock(&dbs_mutex);
 
 	return count;
 }
@@ -558,13 +534,11 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
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
 
@@ -600,27 +574,22 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
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
 		break;
 	}
 	return 0;
