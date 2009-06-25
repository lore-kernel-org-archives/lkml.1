Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZFYTsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZFYTsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZFYTsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:48:31 -0400
Received: from toq5.bellnexxia.net ([209.226.175.27]:48527 "EHLO
	toq5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbZFYTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:48:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEFANtsQ0pMQWRX/2dsb2JhbACBUdFBhA0F
Date: Thu, 25 Jun 2009 15:46:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: venkatesh.pallipadi@intel.com
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Thomas Renninger <trenn@suse.de>
Subject: Re: [patch 2/3] cpufreq: Define dbs_mutex purpose and cleanup its
	usage
Message-ID: <20090625194648.GA24657@Krystal>
References: <20090625183354.491259000@intel.com> <20090625183601.493904000@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090625183601.493904000@intel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:45:41 up 117 days, 16:11,  3 users,  load average: 0.19, 0.22,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* venkatesh.pallipadi@intel.com (venkatesh.pallipadi@intel.com) wrote:
> Commit b14893a62c73af0eca414cfed505b8c09efc613c although it was very
> much needed to cleanup ondemand timer cleanly, openup a can of worms
> related to locking dependencies in cpufreq.
> 
> Patch here defines the need for dbs_mutex and cleans up its usage in
> ondemand governor. This also resolves the lockdep warnings reported here
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0906.1/01925.html
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c |   37 +++++++++++++++--------------------
>  1 files changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 1911d17..b2d2106 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -78,15 +78,14 @@ static DEFINE_PER_CPU(struct cpu_dbs_info_s, cpu_dbs_info);
>  static unsigned int dbs_enable;	/* number of CPUs using this policy */
>  
>  /*
> - * DEADLOCK ALERT! There is a ordering requirement between cpu_hotplug
> - * lock and dbs_mutex. cpu_hotplug lock should always be held before
> - * dbs_mutex. If any function that can potentially take cpu_hotplug lock
> - * (like __cpufreq_driver_target()) is being called with dbs_mutex taken, then
> - * cpu_hotplug lock should be taken before that. Note that cpu_hotplug lock
> - * is recursive for the same process. -Venki
> - * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the dbs_mutex, because it
> - * would deadlock with cancel_delayed_work_sync(), which is needed for proper
> - * raceless workqueue teardown.
> + * dbs_mutex protects data in dbs_tuners_ins from concurrent changes on
> + * different CPUs. It also serializes dbs_enable usage in CPUFREQ_GOV_START
> + * and CPUFREQ_GOV_STOP.
> + *
> + * dbs_mutex should be always held after lock_policy_rwsem whenever needed.
> + * do_dbs_timer() must not take the dbs_mutex, because it would deadlock
> + * with cancel_delayed_work_sync(), which is needed for proper raceless
> + * workqueue teardown.
>   */
>  static DEFINE_MUTEX(dbs_mutex);
>  
> @@ -240,12 +239,10 @@ static ssize_t store_sampling_rate(struct cpufreq_policy *unused,
>  	unsigned int input;
>  	int ret;
>  	ret = sscanf(buf, "%u", &input);
> +	if (ret != 1)
> +		return -EINVAL;
>  
>  	mutex_lock(&dbs_mutex);
> -	if (ret != 1) {
> -		mutex_unlock(&dbs_mutex);
> -		return -EINVAL;
> -	}
>  	dbs_tuners_ins.sampling_rate = max(input, min_sampling_rate);
>  	mutex_unlock(&dbs_mutex);
>  
> @@ -258,14 +255,12 @@ static ssize_t store_up_threshold(struct cpufreq_policy *unused,
>  	unsigned int input;
>  	int ret;
>  	ret = sscanf(buf, "%u", &input);
> -
> -	mutex_lock(&dbs_mutex);
>  	if (ret != 1 || input > MAX_FREQUENCY_UP_THRESHOLD ||
>  			input < MIN_FREQUENCY_UP_THRESHOLD) {
> -		mutex_unlock(&dbs_mutex);
>  		return -EINVAL;
>  	}
>  
> +	mutex_lock(&dbs_mutex);
>  	dbs_tuners_ins.up_threshold = input;
>  	mutex_unlock(&dbs_mutex);
>  
> @@ -324,8 +319,8 @@ static ssize_t store_powersave_bias(struct cpufreq_policy *unused,
>  
>  	mutex_lock(&dbs_mutex);
>  	dbs_tuners_ins.powersave_bias = input;
> -	ondemand_powersave_bias_init();
>  	mutex_unlock(&dbs_mutex);
> +	ondemand_powersave_bias_init();
>  
>  	return count;
>  }
> @@ -598,14 +593,16 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  				max(min_sampling_rate,
>  				    latency * LATENCY_MULTIPLIER);
>  		}
> +		mutex_unlock(&dbs_mutex);
> +
>  		dbs_timer_init(this_dbs_info);
>  
> -		mutex_unlock(&dbs_mutex);
>  		break;
>  
>  	case CPUFREQ_GOV_STOP:
> -		mutex_lock(&dbs_mutex);
>  		dbs_timer_exit(this_dbs_info);

Hrm, so.. how do we protect against concurrent :

CPUFREQ_GOV_START/CPUFREQ_GOV_STOP now ?

Mathieu

> +
> +		mutex_lock(&dbs_mutex);
>  		sysfs_remove_group(&policy->kobj, &dbs_attr_group);
>  		dbs_enable--;
>  		mutex_unlock(&dbs_mutex);
> @@ -613,14 +610,12 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
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
> 1.6.0.6
> 
> -- 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
