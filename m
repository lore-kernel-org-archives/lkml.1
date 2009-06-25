Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZFYO0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZFYO0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZFYOZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:25:58 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:36175 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbZFYOZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:25:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEFAL8fQ0pMQWRX/2dsb2JhbACBUdAihA0F
Date: Thu, 25 Jun 2009 10:25:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Thomas Renninger <trenn@suse.de>
Cc: kernel@stable.org, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rjw@sisk.pl, hidave.darkstar@gmail.com,
       penberg@cs.helsinki.fi, kernel-testers@vger.kernel.org,
       davej@redhat.com, Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Remove unneeded dbs_mutexes from ondemand
	and conservative governors
Message-ID: <20090625142552.GA18000@Krystal>
References: <20090623193215.GA31374@elte.hu> <1245938485-12663-2-git-send-email-trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1245938485-12663-2-git-send-email-trenn@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:19:32 up 117 days, 10:45,  3 users,  load average: 0.01, 0.07,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Renninger (trenn@suse.de) wrote:
> Comment from Venkatesh:
> ...
> This mutex is just serializing the changes to those variables. I could't
> think of any functionality issues of not having the lock as such.
> 
> -> rip it out.
> 
> CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> ---
>  drivers/cpufreq/cpufreq_conservative.c |   61 +++-----------------------------
>  drivers/cpufreq/cpufreq_ondemand.c     |   48 +++----------------------
>  2 files changed, 10 insertions(+), 99 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index 7a74d17..6303379 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -18,7 +18,6 @@
>  #include <linux/cpu.h>
>  #include <linux/jiffies.h>
>  #include <linux/kernel_stat.h>
> -#include <linux/mutex.h>
>  #include <linux/hrtimer.h>
>  #include <linux/tick.h>
>  #include <linux/ktime.h>
> @@ -84,19 +83,6 @@ static DEFINE_PER_CPU(struct cpu_dbs_info_s, cpu_dbs_info);
>  
>  static unsigned int dbs_enable;	/* number of CPUs using this policy */
>  
> -/*
> - * DEADLOCK ALERT! There is a ordering requirement between cpu_hotplug
> - * lock and dbs_mutex. cpu_hotplug lock should always be held before
> - * dbs_mutex. If any function that can potentially take cpu_hotplug lock
> - * (like __cpufreq_driver_target()) is being called with dbs_mutex taken, then
> - * cpu_hotplug lock should be taken before that. Note that cpu_hotplug lock
> - * is recursive for the same process. -Venki
> - * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the dbs_mutex, because it
> - * would deadlock with cancel_delayed_work_sync(), which is needed for proper
> - * raceless workqueue teardown.
> - */
> -static DEFINE_MUTEX(dbs_mutex);
> -
>  static struct workqueue_struct	*kconservative_wq;
>  
>  static struct dbs_tuners {
> @@ -236,10 +222,7 @@ static ssize_t store_sampling_down_factor(struct cpufreq_policy *unused,
>  	if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
>  		return -EINVAL;
>  
> -	mutex_lock(&dbs_mutex);
>  	dbs_tuners_ins.sampling_down_factor = input;
> -	mutex_unlock(&dbs_mutex);
> -
>  	return count;
>  }
>  
> @@ -253,10 +236,7 @@ static ssize_t store_sampling_rate(struct cpufreq_policy *unused,
>  	if (ret != 1)
>  		return -EINVAL;
>  
> -	mutex_lock(&dbs_mutex);
>  	dbs_tuners_ins.sampling_rate = max(input, minimum_sampling_rate());
> -	mutex_unlock(&dbs_mutex);
> -
>  	return count;
>  }
>  
> @@ -267,16 +247,11 @@ static ssize_t store_up_threshold(struct cpufreq_policy *unused,
>  	int ret;
>  	ret = sscanf(buf, "%u", &input);
>  
> -	mutex_lock(&dbs_mutex);
>  	if (ret != 1 || input > 100 ||
> -			input <= dbs_tuners_ins.down_threshold) {
> -		mutex_unlock(&dbs_mutex);
> +			input <= dbs_tuners_ins.down_threshold)
>  		return -EINVAL;
> -	}
>  
>  	dbs_tuners_ins.up_threshold = input;
> -	mutex_unlock(&dbs_mutex);

Here, for instance, there might be a problem if down_threshold is
changed concurrently with a store_up_threshold() call. See that there is
a test before the modification, and we need the mutex there for it to be
consistent.

> -
>  	return count;
>  }
>  
> @@ -287,17 +262,12 @@ static ssize_t store_down_threshold(struct cpufreq_policy *unused,
>  	int ret;
>  	ret = sscanf(buf, "%u", &input);
>  
> -	mutex_lock(&dbs_mutex);
>  	/* cannot be lower than 11 otherwise freq will not fall */
>  	if (ret != 1 || input < 11 || input > 100 ||
> -			input >= dbs_tuners_ins.up_threshold) {
> -		mutex_unlock(&dbs_mutex);
> +			input >= dbs_tuners_ins.up_threshold)
>  		return -EINVAL;
> -	}
>  
>  	dbs_tuners_ins.down_threshold = input;
> -	mutex_unlock(&dbs_mutex);
> -
>  	return count;
>  }
>  
> @@ -316,11 +286,9 @@ static ssize_t store_ignore_nice_load(struct cpufreq_policy *policy,
>  	if (input > 1)
>  		input = 1;
>  
> -	mutex_lock(&dbs_mutex);
> -	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
> -		mutex_unlock(&dbs_mutex);
> +	if (input == dbs_tuners_ins.ignore_nice) /* nothing to do */
>  		return count;
> -	}
> +
>  	dbs_tuners_ins.ignore_nice = input;
>  
>  	/* we need to re-evaluate prev_cpu_idle */
> @@ -332,8 +300,6 @@ static ssize_t store_ignore_nice_load(struct cpufreq_policy *policy,
>  		if (dbs_tuners_ins.ignore_nice)
>  			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
>  	}
> -	mutex_unlock(&dbs_mutex);
> -
>  	return count;
>  }
>  
> @@ -352,10 +318,7 @@ static ssize_t store_freq_step(struct cpufreq_policy *policy,
>  
>  	/* no need to test here if freq_step is zero as the user might actually
>  	 * want this, they would be crazy though :) */
> -	mutex_lock(&dbs_mutex);
>  	dbs_tuners_ins.freq_step = input;
> -	mutex_unlock(&dbs_mutex);
> -
>  	return count;
>  }
>  
> @@ -566,13 +529,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,

Hrm, this is where we want the mutexes removed, but I fear this is
creating a race between sysfs_create_group (sysfs file creation) and
policy initialization...

I'm not convinced this mutex is not needed.

Mathieu

>  		if (this_dbs_info->enable) /* Already enabled */
>  			break;
>  
> -		mutex_lock(&dbs_mutex);
> -
>  		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
> -		if (rc) {
> -			mutex_unlock(&dbs_mutex);
> +		if (rc)
>  			return rc;
> -		}
>  
>  		for_each_cpu(j, policy->cpus) {
>  			struct cpu_dbs_info_s *j_dbs_info;
> @@ -612,13 +571,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  					CPUFREQ_TRANSITION_NOTIFIER);
>  		}
>  		dbs_timer_init(this_dbs_info);
> -
> -		mutex_unlock(&dbs_mutex);
> -
>  		break;
>  
>  	case CPUFREQ_GOV_STOP:
> -		mutex_lock(&dbs_mutex);
>  		dbs_timer_exit(this_dbs_info);
>  		sysfs_remove_group(&policy->kobj, &dbs_attr_group);
>  		dbs_enable--;
> @@ -631,13 +586,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  			cpufreq_unregister_notifier(
>  					&dbs_cpufreq_notifier_block,
>  					CPUFREQ_TRANSITION_NOTIFIER);
> -
> -		mutex_unlock(&dbs_mutex);
> -
>  		break;
>  
>  	case CPUFREQ_GOV_LIMITS:
> -		mutex_lock(&dbs_mutex);
>  		if (policy->max < this_dbs_info->cur_policy->cur)
>  			__cpufreq_driver_target(
>  					this_dbs_info->cur_policy,
> @@ -646,8 +597,6 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  			__cpufreq_driver_target(
>  					this_dbs_info->cur_policy,
>  					policy->min, CPUFREQ_RELATION_L);
> -		mutex_unlock(&dbs_mutex);
> -
>  		break;
>  	}
>  	return 0;
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index e741c33..d080a48 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -17,7 +17,6 @@
>  #include <linux/cpu.h>
>  #include <linux/jiffies.h>
>  #include <linux/kernel_stat.h>
> -#include <linux/mutex.h>
>  #include <linux/hrtimer.h>
>  #include <linux/tick.h>
>  #include <linux/ktime.h>
> @@ -91,19 +90,6 @@ static DEFINE_PER_CPU(struct cpu_dbs_info_s, cpu_dbs_info);
>  
>  static unsigned int dbs_enable;	/* number of CPUs using this policy */
>  
> -/*
> - * DEADLOCK ALERT! There is a ordering requirement between cpu_hotplug
> - * lock and dbs_mutex. cpu_hotplug lock should always be held before
> - * dbs_mutex. If any function that can potentially take cpu_hotplug lock
> - * (like __cpufreq_driver_target()) is being called with dbs_mutex taken, then
> - * cpu_hotplug lock should be taken before that. Note that cpu_hotplug lock
> - * is recursive for the same process. -Venki
> - * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the dbs_mutex, because it
> - * would deadlock with cancel_delayed_work_sync(), which is needed for proper
> - * raceless workqueue teardown.
> - */
> -static DEFINE_MUTEX(dbs_mutex);
> -
>  static struct workqueue_struct	*kondemand_wq;
>  
>  static struct dbs_tuners {
> @@ -269,14 +255,10 @@ static ssize_t store_sampling_rate(struct cpufreq_policy *unused,
>  	int ret;
>  	ret = sscanf(buf, "%u", &input);
>  
> -	mutex_lock(&dbs_mutex);
> -	if (ret != 1) {
> -		mutex_unlock(&dbs_mutex);
> +	if (ret != 1)
>  		return -EINVAL;
> -	}
> -	dbs_tuners_ins.sampling_rate = max(input, minimum_sampling_rate());
> -	mutex_unlock(&dbs_mutex);
>  
> +	dbs_tuners_ins.sampling_rate = max(input, minimum_sampling_rate());
>  	return count;
>  }
>  
> @@ -287,16 +269,11 @@ static ssize_t store_up_threshold(struct cpufreq_policy *unused,
>  	int ret;
>  	ret = sscanf(buf, "%u", &input);
>  
> -	mutex_lock(&dbs_mutex);
>  	if (ret != 1 || input > MAX_FREQUENCY_UP_THRESHOLD ||
> -			input < MIN_FREQUENCY_UP_THRESHOLD) {
> -		mutex_unlock(&dbs_mutex);
> +			input < MIN_FREQUENCY_UP_THRESHOLD)
>  		return -EINVAL;
> -	}
>  
>  	dbs_tuners_ins.up_threshold = input;
> -	mutex_unlock(&dbs_mutex);
> -
>  	return count;
>  }
>  
> @@ -315,11 +292,9 @@ static ssize_t store_ignore_nice_load(struct cpufreq_policy *policy,
>  	if (input > 1)
>  		input = 1;
>  
> -	mutex_lock(&dbs_mutex);
> -	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
> -		mutex_unlock(&dbs_mutex);
> +	if (input == dbs_tuners_ins.ignore_nice) /* nothing to do */
>  		return count;
> -	}
> +
>  	dbs_tuners_ins.ignore_nice = input;
>  
>  	/* we need to re-evaluate prev_cpu_idle */
> @@ -332,8 +307,6 @@ static ssize_t store_ignore_nice_load(struct cpufreq_policy *policy,
>  			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
>  
>  	}
> -	mutex_unlock(&dbs_mutex);
> -
>  	return count;
>  }
>  
> @@ -350,10 +323,8 @@ static ssize_t store_powersave_bias(struct cpufreq_policy *unused,
>  	if (input > 1000)
>  		input = 1000;
>  
> -	mutex_lock(&dbs_mutex);
>  	dbs_tuners_ins.powersave_bias = input;
>  	ondemand_powersave_bias_init();
> -	mutex_unlock(&dbs_mutex);
>  
>  	return count;
>  }
> @@ -586,13 +557,11 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  		if (this_dbs_info->enable) /* Already enabled */
>  			break;
>  
> -		mutex_lock(&dbs_mutex);
>  		dbs_enable++;
>  
>  		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
>  		if (rc) {
>  			dbs_enable--;
> -			mutex_unlock(&dbs_mutex);
>  			return rc;
>  		}
>  
> @@ -627,28 +596,21 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  			dbs_tuners_ins.sampling_rate = def_sampling_rate;
>  		}
>  		dbs_timer_init(this_dbs_info);
> -
> -		mutex_unlock(&dbs_mutex);
>  		break;
>  
>  	case CPUFREQ_GOV_STOP:
> -		mutex_lock(&dbs_mutex);
>  		dbs_timer_exit(this_dbs_info);
>  		sysfs_remove_group(&policy->kobj, &dbs_attr_group);
>  		dbs_enable--;
> -		mutex_unlock(&dbs_mutex);
> -
>  		break;
>  
>  	case CPUFREQ_GOV_LIMITS:
> -		mutex_lock(&dbs_mutex);
>  		if (policy->max < this_dbs_info->cur_policy->cur)
>  			__cpufreq_driver_target(this_dbs_info->cur_policy,
>  				policy->max, CPUFREQ_RELATION_H);
>  		else if (policy->min > this_dbs_info->cur_policy->cur)
>  			__cpufreq_driver_target(this_dbs_info->cur_policy,
>  				policy->min, CPUFREQ_RELATION_L);
> -		mutex_unlock(&dbs_mutex);
>  		break;
>  	}
>  	return 0;
> -- 
> 1.6.0.2
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
