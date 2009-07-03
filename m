Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZGCO0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZGCO0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbZGCO0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:26:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:33922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbZGCO0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:26:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,342,1243839600"; 
   d="scan'208";a="471795775"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas Renninger <trenn@suse.de>
CC: Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Fri, 3 Jul 2009 07:28:43 -0700
Subject: RE: [patch 1/4] cpufreq: Eliminate the recent lockdep warnings in
 cpufreq
Thread-Topic: [patch 1/4] cpufreq: Eliminate the recent lockdep warnings in
 cpufreq
Thread-Index: Acn70zCLdjUn8fEMSpG7ia6twVe6cwAFg1uA
Message-ID: <7E82351C108FA840AB1866AC776AEC4669BFF050@orsmsx505.amr.corp.intel.com>
References: <20090703000829.735976000@intel.com>
 <20090703000923.800507000@intel.com> <200907031341.19141.trenn@suse.de>
In-Reply-To: <200907031341.19141.trenn@suse.de>
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
>From: Thomas Renninger [mailto:trenn@suse.de] 
>Sent: Friday, July 03, 2009 4:41 AM
>To: Pallipadi, Venkatesh
>Cc: Dave Jones; linux-kernel@vger.kernel.org; 
>cpufreq@vger.kernel.org; kernel-testers@vger.kernel.org; Ingo 
>Molnar; Rafael J. Wysocki; Dave Young; Pekka Enberg; Mathieu Desnoyers
>Subject: Re: [patch 1/4] cpufreq: Eliminate the recent lockdep 
>warnings in cpufreq
>
>On Friday 03 July 2009 02:08:30 venkatesh.pallipadi@intel.com wrote:
>> Commit b14893a62c73af0eca414cfed505b8c09efc613c although it was very
>> much needed to properly cleanup ondemand timer, opened-up a 
>can of worms
>> related to locking dependencies in cpufreq.
>> 
>> Patch here defines the need for dbs_mutex and cleans up its usage in
>> ondemand governor. This also resolves the lockdep warnings 
>reported here
>I think I get these changes and now dbs_mutex is needed...
>Making sure governor() is always called with rwsem held (hope 
>that is the
>case now) is a good idea. Unfortunately it requires the dbs_mutex in
>do_dbs_timer and it will be hard to ever remove it.

Yes. Rwsem held for any policy changes from cpufreq core makes this fix
clean. I did not like the earlier state where rwsem was helt for START
and not for STOP calls etc.

Patch 3 and 4 removes dbs_mutex from do_dbs_timer.

>I still do not see the need of "dbs_mutex protects data in 
>dbs_tuners_ins
>from concurrent changes", though. If someone enlightens me, that would
>be appreciated.

OK. Consider these two happening in parallel.
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice
echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/ignore_nice

As they are coming from different cpu, rwsem wont protect us and 
without the dbs_mutex, end state after this can will be unpredictable.
prev_cpu_idle and prev_cpu_nice can end up with wrong values where
only one of them is set etc. That will affect the ondemand algorithm.

Thanks,
Venki

>> http://lkml.indiana.edu/hypermail/linux/kernel/0906.1/01925.html
>> http://lkml.indiana.edu/hypermail/linux/kernel/0907.0/00820.html
>> 
>> and few others..
>> 
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> ---
>>  drivers/cpufreq/cpufreq.c              |    4 ++--
>>  drivers/cpufreq/cpufreq_conservative.c |   27 
>+++++++++++----------------
>>  drivers/cpufreq/cpufreq_ondemand.c     |   27 
>+++++++++++----------------
>>  3 files changed, 24 insertions(+), 34 deletions(-)
>> 
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 6e2ec0b..c7fe16e 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1070,8 +1070,6 @@ static int __cpufreq_remove_dev(struct 
>sys_device 
>*sys_dev)
>>  	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>>  #endif
>>  
>> -	unlock_policy_rwsem_write(cpu);
>> -
>>  	if (cpufreq_driver->target)
>>  		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
>>  
>> @@ -1088,6 +1086,8 @@ static int __cpufreq_remove_dev(struct 
>sys_device 
>*sys_dev)
>>  	if (cpufreq_driver->exit)
>>  		cpufreq_driver->exit(data);
>>  
>> +	unlock_policy_rwsem_write(cpu);
>> +
>>  	free_cpumask_var(data->related_cpus);
>>  	free_cpumask_var(data->cpus);
>>  	kfree(data);
>> diff --git a/drivers/cpufreq/cpufreq_conservative.c 
>b/drivers/cpufreq/cpufreq_conservative.c
>> index 7fc58af..58889f2 100644
>> --- a/drivers/cpufreq/cpufreq_conservative.c
>> +++ b/drivers/cpufreq/cpufreq_conservative.c
>> @@ -70,15 +70,10 @@ static DEFINE_PER_CPU(struct cpu_dbs_info_s, 
>cpu_dbs_info);
>>  static unsigned int dbs_enable;	/* number of CPUs using 
>this policy */
>>  
>>  /*
>> - * DEADLOCK ALERT! There is a ordering requirement between 
>cpu_hotplug
>> - * lock and dbs_mutex. cpu_hotplug lock should always be held before
>> - * dbs_mutex. If any function that can potentially take 
>cpu_hotplug lock
>> - * (like __cpufreq_driver_target()) is being called with 
>dbs_mutex taken, 
>then
>> - * cpu_hotplug lock should be taken before that. Note that 
>cpu_hotplug lock
>> - * is recursive for the same process. -Venki
>> - * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the 
>dbs_mutex, 
>because it
>> - * would deadlock with cancel_delayed_work_sync(), which is 
>needed for 
>proper
>> - * raceless workqueue teardown.
>> + * dbs_mutex protects data in dbs_tuners_ins from 
>concurrent changes on
>> + * different CPUs. It protects dbs_enable in governor 
>start/stop. It also
>> + * serializes governor limit_change with do_dbs_timer. We 
>do not want
>> + * do_dbs_timer to run when user is changing the governor or limits.
>>   */
>>  static DEFINE_MUTEX(dbs_mutex);
>>  
>> @@ -488,18 +483,17 @@ static void do_dbs_timer(struct 
>work_struct *work)
>>  
>>  	delay -= jiffies % delay;
>>  
>> -	if (lock_policy_rwsem_write(cpu) < 0)
>> -		return;
>> +	mutex_lock(&dbs_mutex);
>>  
>>  	if (!dbs_info->enable) {
>> -		unlock_policy_rwsem_write(cpu);
>> +		mutex_unlock(&dbs_mutex);
>>  		return;
>>  	}
>>  
>>  	dbs_check_cpu(dbs_info);
>>  
>>  	queue_delayed_work_on(cpu, kconservative_wq, 
>&dbs_info->work, delay);
>> -	unlock_policy_rwsem_write(cpu);
>> +	mutex_unlock(&dbs_mutex);
>>  }
>>  
>>  static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
>> @@ -590,15 +584,16 @@ static int cpufreq_governor_dbs(struct 
>cpufreq_policy 
>*policy,
>>  					&dbs_cpufreq_notifier_block,
>>  					CPUFREQ_TRANSITION_NOTIFIER);
>>  		}
>> -		dbs_timer_init(this_dbs_info);
>> -
>>  		mutex_unlock(&dbs_mutex);
>>  
>> +		dbs_timer_init(this_dbs_info);
>> +
>>  		break;
>>  
>>  	case CPUFREQ_GOV_STOP:
>> -		mutex_lock(&dbs_mutex);
>>  		dbs_timer_exit(this_dbs_info);
>> +
>> +		mutex_lock(&dbs_mutex);
>>  		sysfs_remove_group(&policy->kobj, &dbs_attr_group);
>>  		dbs_enable--;
>>  
>> diff --git a/drivers/cpufreq/cpufreq_ondemand.c 
>b/drivers/cpufreq/cpufreq_ondemand.c
>> index 1911d17..246ae14 100644
>> --- a/drivers/cpufreq/cpufreq_ondemand.c
>> +++ b/drivers/cpufreq/cpufreq_ondemand.c
>> @@ -78,15 +78,10 @@ static DEFINE_PER_CPU(struct cpu_dbs_info_s, 
>cpu_dbs_info);
>>  static unsigned int dbs_enable;	/* number of CPUs using 
>this policy */
>>  
>>  /*
>> - * DEADLOCK ALERT! There is a ordering requirement between 
>cpu_hotplug
>> - * lock and dbs_mutex. cpu_hotplug lock should always be held before
>> - * dbs_mutex. If any function that can potentially take 
>cpu_hotplug lock
>> - * (like __cpufreq_driver_target()) is being called with 
>dbs_mutex taken, 
>then
>> - * cpu_hotplug lock should be taken before that. Note that 
>cpu_hotplug lock
>> - * is recursive for the same process. -Venki
>> - * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the 
>dbs_mutex, 
>because it
>> - * would deadlock with cancel_delayed_work_sync(), which is 
>needed for 
>proper
>> - * raceless workqueue teardown.
>> + * dbs_mutex protects data in dbs_tuners_ins from 
>concurrent changes on
>> + * different CPUs. It protects dbs_enable in governor 
>start/stop. It also
>> + * serializes governor limit_change with do_dbs_timer. We 
>do not want
>> + * do_dbs_timer to run when user is changing the governor or limits.
>>   */
>>  static DEFINE_MUTEX(dbs_mutex);
>>  
>> @@ -494,11 +489,10 @@ static void do_dbs_timer(struct 
>work_struct *work)
>>  
>>  	delay -= jiffies % delay;
>>  
>> -	if (lock_policy_rwsem_write(cpu) < 0)
>> -		return;
>> +	mutex_lock(&dbs_mutex);
>>  
>>  	if (!dbs_info->enable) {
>> -		unlock_policy_rwsem_write(cpu);
>> +		mutex_unlock(&dbs_mutex);
>>  		return;
>>  	}
>>  
>> @@ -517,7 +511,7 @@ static void do_dbs_timer(struct 
>work_struct *work)
>>  			dbs_info->freq_lo, CPUFREQ_RELATION_H);
>>  	}
>>  	queue_delayed_work_on(cpu, kondemand_wq, 
>&dbs_info->work, delay);
>> -	unlock_policy_rwsem_write(cpu);
>> +	mutex_unlock(&dbs_mutex);
>>  }
>>  
>>  static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
>> @@ -598,14 +592,15 @@ static int cpufreq_governor_dbs(struct 
>cpufreq_policy 
>*policy,
>>  				max(min_sampling_rate,
>>  				    latency * LATENCY_MULTIPLIER);
>>  		}
>> -		dbs_timer_init(this_dbs_info);
>> -
>>  		mutex_unlock(&dbs_mutex);
>> +
>> +		dbs_timer_init(this_dbs_info);
>>  		break;
>>  
>>  	case CPUFREQ_GOV_STOP:
>> -		mutex_lock(&dbs_mutex);
>>  		dbs_timer_exit(this_dbs_info);
>> +
>> +		mutex_lock(&dbs_mutex);
>>  		sysfs_remove_group(&policy->kobj, &dbs_attr_group);
>>  		dbs_enable--;
>>  		mutex_unlock(&dbs_mutex);
>> -- 
>> 1.6.0.6
>> 
>> -- 
>> 
>> 
>
>
>