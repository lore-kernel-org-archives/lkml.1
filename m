Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574Ab0A1ASZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0A1ASZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 19:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881Ab0A1ASY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 19:18:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932171Ab0A1ASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 19:18:23 -0500
Date: Wed, 27 Jan 2010 16:17:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Chan <mike@android.com>
Cc: venkatesh.pallipadi@intel.com, tj@kernel.org, Miller@fmi.uni-stuttgart.de,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cpufreq: ondemand: Independent max speed for
 nice threads with nice_max_freq
Message-Id: <20100127161705.941360c4.akpm@linux-foundation.org>
In-Reply-To: <1264470435-14739-2-git-send-email-mike@android.com>
References: <1264470435-14739-1-git-send-email-mike@android.com>
	<1264470435-14739-2-git-send-email-mike@android.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 17:47:15 -0800
Mike Chan <mike@android.com> wrote:

> Allow lower priority threads to scale frequency to specified nice_max_freq.
> This allows low priority threads to operate at the most efficient
> power/performance frequency.
> 
> Often the highest and lowest cpu speeds do not provide the the optimal
> performance/power ratios. Latency requirements for normal and high priority
> threads require the maximum speed that are not always optimal power wise
> inorder to satisfy the requirements.
> 
> To enable set nice_max_freq (to a speed lower than the scaling_max_freq).
> 
> The governor will first attempt to scale the cpu to policy->max (default)
> only using normal and high priority threads. It will ignore nice threads.
> If the load is high enough without nice threads then ondemand will scale to
> the max speed and exit.
> 
> If load for normal and high priority threads are not high enough to increase
> the cpu speed, check again including the load from nice threads. Only scale
> to the nice_max_freq specified.
> 
> Previous behavior is maintained by setting the values below:
> 
> + When nice_max_freq is set to 0, behavior is the current default
> (nice is counted for load).
> 
> + When nice_max_freq is set to scaling_min_freq, the behavior is the same
> as the original ignore_nice_load == 1. Which counts all nice threads as
> idle time when computing cpu load.
> 
> *** v2 ***
> + The ignore_nice_load sysfs still behaves the same as before (0/1) and is
> kept around for legacy support. Userspace scripts should now use
> nice_max_freq.

The patch conflicts a bit with a change which is pending in linux-next:

--- linux-2.6.33-rc5/drivers/cpufreq/cpufreq_ondemand.c	2009-12-03 12:12:09.000000000 -0800
+++ 25/drivers/cpufreq/cpufreq_ondemand.c	2010-01-27 16:11:18.000000000 -0800
@@ -554,6 +554,9 @@ static void dbs_check_cpu(struct cpu_dbs
 				(dbs_tuners_ins.up_threshold -
 				 dbs_tuners_ins.down_differential);
 
+		if (freq_next < policy->min)
+			freq_next = policy->min;
+
 		if (!dbs_tuners_ins.powersave_bias) {
 			__cpufreq_driver_target(policy, freq_next,
 					CPUFREQ_RELATION_L);

You might want to check that - there might be functional interactions.

> index 3dcf126..2a5a414 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -108,11 +108,13 @@ static struct dbs_tuners {
>  	unsigned int down_differential;
>  	unsigned int ignore_nice;
>  	unsigned int powersave_bias;
> +	unsigned int nice_max_freq;
>  } dbs_tuners_ins = {
>  	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
>  	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
>  	.ignore_nice = 0,
>  	.powersave_bias = 0,
> +	.nice_max_freq = 0,
>  };

The initialisation to zero is unneeded and unidiomatic.  It'd be better
to remove the other two.

>  static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
> @@ -251,6 +253,7 @@ static ssize_t show_##file_name						\
>  show_one(sampling_rate, sampling_rate);
>  show_one(up_threshold, up_threshold);
>  show_one(ignore_nice_load, ignore_nice);
> +show_one(nice_max_freq, nice_max_freq);
>  show_one(powersave_bias, powersave_bias);
>  
>  /*** delete after deprecation time ***/
> @@ -318,10 +321,48 @@ static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
>  	return count;
>  }
>  
> +/*
> + * Preserve ignore_nice_load behavior, if enabled do not allow low priority
> + * threads to scale beyond the minimum frequency.
> + */
>  static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
>  				      const char *buf, size_t count)
>  {
>  	unsigned int input;
> +	unsigned int j;
> +
> +	printk_once(KERN_INFO "CPUFREQ: ondemand ignore_nice_load"
> +	       "sysfs file is deprecated - use nice_max_freq instead");

This printk will come out wrong: "ondemand ignore_nice_loadsysfs file"

> +	if (sscanf(buf, "%u", &input) != 1)
> +		return -EINVAL;

This will treat input of the form "42foo" as a valid number, which is
sloppy.  Use strict_strtoul() to fix.

> +	if (input > 1)
> +		input = 1;

So inputs which aren't 0 or 1 are invalid.  It'd be better to fail,
rather than to silently modify-and-accept?

> +	mutex_lock(&dbs_mutex);
> +	dbs_tuners_ins.ignore_nice = input;
> +
> +	for_each_online_cpu(j) {
> +		struct cpufreq_policy *policy;
> +		struct cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, j);
> +		policy = dbs_info->cur_policy;
> +
> +
> +		if (input && policy->min < dbs_tuners_ins.nice_max_freq)
> +				dbs_tuners_ins.nice_max_freq = policy->min;
> +		else if (!input && policy->max > dbs_tuners_ins.nice_max_freq)
> +				dbs_tuners_ins.nice_max_freq = policy->max;
> +	}
> +	mutex_unlock(&dbs_mutex);

What prevents a CPU from going offline while this loop is executing?

> +	return count;
> +}
> +
>
> ...
>
