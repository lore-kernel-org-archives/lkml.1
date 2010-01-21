Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333Ab0AULc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab0AULc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 06:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035Ab0AULc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 06:32:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:45815 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab0AULc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 06:32:56 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Mike Chan <mike@android.com>
Subject: Re: [PATCH 2/2] cpufreq: ondemand: Replace ignore_nice_load with nice_max_freq
Date: Thu, 21 Jan 2010 12:32:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.1-0.0.14.f17927a-desktop; KDE/4.3.1; x86_64; ; )
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Miller@fmi.uni-stuttgart.de, tj@kernel.org,
       venkatesh.pallipadi@intel.com, davej@redhat.com
References: <1264043737-2505-1-git-send-email-mike@android.com> <1264043737-2505-2-git-send-email-mike@android.com>
In-Reply-To: <1264043737-2505-2-git-send-email-mike@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201001211232.53116.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 21 January 2010 04:15:37 Mike Chan wrote:
..
> **Note: ingore_nice_load has been removed since the same functionality
> can be achieved by setting nice_max_freq to scaling_min_freq.
This breaks userspace tools.
Why not keep ignore_nice_load and set nice_max_freq to min/max internally.
You could mark it deprecated by printk_once("Don't use this file it's
deprecated, use nice_max_freq instead").

> Signed-off-by: Mike Chan <mike@android.com>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c |   96 +++++++++++++++++++++++-------------
>  1 files changed, 62 insertions(+), 34 deletions(-)
Whatabout cpufreq_conservative.c?
Does something similar make sense there, too?
...
> -static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
> +static ssize_t store_nice_max_freq(struct kobject *a, struct attribute *b,
>  				      const char *buf, size_t count)
>  {
>  	unsigned int input;
> @@ -330,15 +330,12 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
>  	if (ret != 1)
>  		return -EINVAL;
>  
> -	if (input > 1)
> -		input = 1;

> -
>  	mutex_lock(&dbs_mutex);
> -	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
> +	if (input == dbs_tuners_ins.nice_max_freq) { /* nothing to do */
>  		mutex_unlock(&dbs_mutex);
>  		return count;
>  	}
> -	dbs_tuners_ins.ignore_nice = input;
> +	dbs_tuners_ins.nice_max_freq = input;
What happens if userspace provides a wrong value?
Sanity checking is ugly at this place, though.
Only idea I have is to iterate over all cpuinfo.{min,max}_freq

...  
>  };
> @@ -412,7 +409,7 @@ static ssize_t store_##file_name##_old					\
>  }
>  write_one_old(sampling_rate);
>  write_one_old(up_threshold);
> -write_one_old(ignore_nice_load);
> +write_one_old(nice_max_freq);
This is the depracated
/sys/devices/system/cpu/cpuX/cpufreq/ondemand
interface. If this should be a global variable for all cores
here:
/sys/devices/system/cpu/cpufreq/ondemand
you don't need it. If this should be configurable per core
you don't need the other and should add this one not marked
old and place it outside this paragraph:
/*** delete after deprecation time ***/

>  write_one_old(powersave_bias);
>  
>  #define define_one_rw_old(object, _name)       \
> @@ -421,7 +418,7 @@ __ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
>  
>  define_one_rw_old(sampling_rate_old, sampling_rate);
>  define_one_rw_old(up_threshold_old, up_threshold);
> -define_one_rw_old(ignore_nice_load_old, ignore_nice_load);
> +define_one_rw_old(nice_max_freq_old, nice_max_freq);
same here.
>  define_one_rw_old(powersave_bias_old, powersave_bias);
>  
>  static struct attribute *dbs_attributes_old[] = {
> @@ -429,7 +426,7 @@ static struct attribute *dbs_attributes_old[] = {
>         &sampling_rate_min_old.attr,
>         &sampling_rate_old.attr,
>         &up_threshold_old.attr,
> -       &ignore_nice_load_old.attr,
> +       &nice_max_freq_old.attr,
and here.
>         &powersave_bias_old.attr,
>         NULL
>  };
...
> @@ -477,12 +473,13 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
>  	 */
>  
>  	/* Get Absolute Load - in terms of freq */
> -	max_load_freq = 0;
> +	max_load_freq = max_ignore_nice_load_freq = 0;
>  
>  	for_each_cpu(j, policy->cpus) {
>  		struct cpu_dbs_info_s *j_dbs_info;
>  		cputime64_t cur_wall_time, cur_idle_time;
> -		unsigned int idle_time, wall_time;
> +		unsigned int idle_time,  wall_time;
not needed whitespace.

> +		unsigned long cur_nice_jiffies;
>  		unsigned int load, load_freq;
>  		int freq_avg;
>  
...
> @@ -512,27 +513,47 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
>  					cputime64_to_jiffies64(cur_nice);
>  
>  			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
> -			idle_time += jiffies_to_usecs(cur_nice_jiffies);
> +			nice_idle_time += jiffies_to_usecs(cur_nice_jiffies);
> +
> +			if (wall_time < nice_idle_time)
> +				continue;
Can wall_time and nice_idle_time ever be both zero?
> +			load = 100 * (wall_time - nice_idle_time) / wall_time;
Then you divide through zero here.
> +			load_freq = load * freq_avg;
> +			if (load_freq > max_ignore_nice_load_freq)
> +				max_ignore_nice_load_freq = load_freq;
>  		}
>  
> -		if (unlikely(!wall_time || wall_time < idle_time))
> +		if (unlikely(!wall_time || wall_time < idle_time +
> +					jiffies_to_usecs(cur_nice_jiffies)))
>  			continue;
>  
...
