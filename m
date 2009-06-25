Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZFYPB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZFYPB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZFYPBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:01:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:36749 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZFYPBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:01:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,290,1243839600"; 
   d="scan'208";a="527764795"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Renninger <trenn@suse.de>
CC: "kernel@stable.org" <kernel@stable.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "rjw@sisk.pl" <rjw@sisk.pl>,
       "hidave.darkstar@gmail.com" <hidave.darkstar@gmail.com>,
       "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       "davej@redhat.com" <davej@redhat.com>
Date: Thu, 25 Jun 2009 08:03:47 -0700
Subject: RE: [PATCH 1/2] CPUFREQ: Remove unneeded dbs_mutexes from ondemand
	and conservative governors
Thread-Topic: [PATCH 1/2] CPUFREQ: Remove unneeded dbs_mutexes from ondemand
	and conservative governors
Thread-Index: Acn1oN1yLg7rmb4FTXSiM88qEelYagABKumA
Message-ID: <7E82351C108FA840AB1866AC776AEC46697F2A18@orsmsx505.amr.corp.intel.com>
References: <20090623193215.GA31374@elte.hu>
 <1245938485-12663-2-git-send-email-trenn@suse.de>
 <20090625142552.GA18000@Krystal>
In-Reply-To: <20090625142552.GA18000@Krystal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Mathieu Desnoyers [mailto:mathieu.desnoyers@polymtl.ca] 
>Sent: Thursday, June 25, 2009 7:26 AM
>To: Thomas Renninger
>Cc: kernel@stable.org; cpufreq@vger.kernel.org; 
>linux-kernel@vger.kernel.org; mingo@elte.hu; rjw@sisk.pl; 
>hidave.darkstar@gmail.com; penberg@cs.helsinki.fi; 
>kernel-testers@vger.kernel.org; davej@redhat.com; Pallipadi, Venkatesh
>Subject: Re: [PATCH 1/2] CPUFREQ: Remove unneeded dbs_mutexes 
>from ondemand and conservative governors
>
>* Thomas Renninger (trenn@suse.de) wrote:
>> Comment from Venkatesh:
>> ...
>> This mutex is just serializing the changes to those 
>variables. I could't
>> think of any functionality issues of not having the lock as such.
>> 
>> -> rip it out.
>> 
>> CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> Signed-off-by: Thomas Renninger <trenn@suse.de>
>> ---
>>  drivers/cpufreq/cpufreq_conservative.c |   61 
>+++-----------------------------
>>  drivers/cpufreq/cpufreq_ondemand.c     |   48 
>+++----------------------
>>  2 files changed, 10 insertions(+), 99 deletions(-)
>> 
>> diff --git a/drivers/cpufreq/cpufreq_conservative.c 
>b/drivers/cpufreq/cpufreq_conservative.c
>> index 7a74d17..6303379 100644
>> --- a/drivers/cpufreq/cpufreq_conservative.c
>> +++ b/drivers/cpufreq/cpufreq_conservative.c
>> @@ -18,7 +18,6 @@
>>  #include <linux/cpu.h>
>>  #include <linux/jiffies.h>
>>  #include <linux/kernel_stat.h>
>> -#include <linux/mutex.h>
>>  #include <linux/hrtimer.h>
>>  #include <linux/tick.h>
>>  #include <linux/ktime.h>
>> @@ -84,19 +83,6 @@ static DEFINE_PER_CPU(struct 
>cpu_dbs_info_s, cpu_dbs_info);
>>  
>>  static unsigned int dbs_enable;	/* number of CPUs using 
>this policy */
>>  
>> -/*
>> - * DEADLOCK ALERT! There is a ordering requirement between 
>cpu_hotplug
>> - * lock and dbs_mutex. cpu_hotplug lock should always be held before
>> - * dbs_mutex. If any function that can potentially take 
>cpu_hotplug lock
>> - * (like __cpufreq_driver_target()) is being called with 
>dbs_mutex taken, then
>> - * cpu_hotplug lock should be taken before that. Note that 
>cpu_hotplug lock
>> - * is recursive for the same process. -Venki
>> - * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the 
>dbs_mutex, because it
>> - * would deadlock with cancel_delayed_work_sync(), which is 
>needed for proper
>> - * raceless workqueue teardown.
>> - */
>> -static DEFINE_MUTEX(dbs_mutex);
>> -
>>  static struct workqueue_struct	*kconservative_wq;
>>  
>>  static struct dbs_tuners {
>> @@ -236,10 +222,7 @@ static ssize_t 
>store_sampling_down_factor(struct cpufreq_policy *unused,
>>  	if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
>>  		return -EINVAL;
>>  
>> -	mutex_lock(&dbs_mutex);
>>  	dbs_tuners_ins.sampling_down_factor = input;
>> -	mutex_unlock(&dbs_mutex);
>> -
>>  	return count;
>>  }
>>  
>> @@ -253,10 +236,7 @@ static ssize_t 
>store_sampling_rate(struct cpufreq_policy *unused,
>>  	if (ret != 1)
>>  		return -EINVAL;
>>  
>> -	mutex_lock(&dbs_mutex);
>>  	dbs_tuners_ins.sampling_rate = max(input, 
>minimum_sampling_rate());
>> -	mutex_unlock(&dbs_mutex);
>> -
>>  	return count;
>>  }
>>  
>> @@ -267,16 +247,11 @@ static ssize_t 
>store_up_threshold(struct cpufreq_policy *unused,
>>  	int ret;
>>  	ret = sscanf(buf, "%u", &input);
>>  
>> -	mutex_lock(&dbs_mutex);
>>  	if (ret != 1 || input > 100 ||
>> -			input <= dbs_tuners_ins.down_threshold) {
>> -		mutex_unlock(&dbs_mutex);
>> +			input <= dbs_tuners_ins.down_threshold)
>>  		return -EINVAL;
>> -	}
>>  
>>  	dbs_tuners_ins.up_threshold = input;
>> -	mutex_unlock(&dbs_mutex);
>
>Here, for instance, there might be a problem if down_threshold is
>changed concurrently with a store_up_threshold() call. See 
>that there is
>a test before the modification, and we need the mutex there 
>for it to be
>consistent.
>
>> -
>>  	return count;
>>  }
>>  
>> @@ -287,17 +262,12 @@ static ssize_t 
>store_down_threshold(struct cpufreq_policy *unused,
>>  	int ret;
>>  	ret = sscanf(buf, "%u", &input);
>>  
>> -	mutex_lock(&dbs_mutex);
>>  	/* cannot be lower than 11 otherwise freq will not fall */
>>  	if (ret != 1 || input < 11 || input > 100 ||
>> -			input >= dbs_tuners_ins.up_threshold) {
>> -		mutex_unlock(&dbs_mutex);
>> +			input >= dbs_tuners_ins.up_threshold)
>>  		return -EINVAL;
>> -	}
>>  
>>  	dbs_tuners_ins.down_threshold = input;
>> -	mutex_unlock(&dbs_mutex);
>> -
>>  	return count;
>>  }
>>  
>> @@ -316,11 +286,9 @@ static ssize_t 
>store_ignore_nice_load(struct cpufreq_policy *policy,
>>  	if (input > 1)
>>  		input = 1;
>>  
>> -	mutex_lock(&dbs_mutex);
>> -	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
>> -		mutex_unlock(&dbs_mutex);
>> +	if (input == dbs_tuners_ins.ignore_nice) /* nothing to do */
>>  		return count;
>> -	}
>> +
>>  	dbs_tuners_ins.ignore_nice = input;
>>  
>>  	/* we need to re-evaluate prev_cpu_idle */
>> @@ -332,8 +300,6 @@ static ssize_t 
>store_ignore_nice_load(struct cpufreq_policy *policy,
>>  		if (dbs_tuners_ins.ignore_nice)
>>  			dbs_info->prev_cpu_nice = 
>kstat_cpu(j).cpustat.nice;
>>  	}
>> -	mutex_unlock(&dbs_mutex);
>> -
>>  	return count;
>>  }
>>  
>> @@ -352,10 +318,7 @@ static ssize_t store_freq_step(struct 
>cpufreq_policy *policy,
>>  
>>  	/* no need to test here if freq_step is zero as the 
>user might actually
>>  	 * want this, they would be crazy though :) */
>> -	mutex_lock(&dbs_mutex);
>>  	dbs_tuners_ins.freq_step = input;
>> -	mutex_unlock(&dbs_mutex);
>> -
>>  	return count;
>>  }
>>  
>> @@ -566,13 +529,9 @@ static int cpufreq_governor_dbs(struct 
>cpufreq_policy *policy,
>
>Hrm, this is where we want the mutexes removed, but I fear this is
>creating a race between sysfs_create_group (sysfs file creation) and
>policy initialization...
>
>I'm not convinced this mutex is not needed.
>

I am with Mathieu on this one. We can reduce the use of mutex here. But, it will still be needed. As I mentioned earlier, we need it to protect dbs_tuners getting changed from different CPUs at the same time. We also need it for dbs_enable change in start and stop from different CPUs. Otherwise dbs_enable increment/decrement and test will have races. I was playing with some changes for this. I should have a cleaner patchset later today...

Thanks,
Venki