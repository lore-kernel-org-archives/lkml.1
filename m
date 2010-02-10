Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab0BJGyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 01:54:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab0BJGyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 01:54:01 -0500
Message-ID: <4B7258AB.2000502@redhat.com>
Date: Wed, 10 Feb 2010 14:56:43 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Xiaotian Feng <xtfeng@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       Prarit Bhargava <prarit@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [Patch] cpufreq: fix a deadlock during shutting down
References: <20100209091408.29971.63921.sendpatchset@localhost.localdomain> <alpine.DEB.2.00.1002090117160.9056@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002090117160.9056@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Tue, 9 Feb 2010, Amerigo Wang wrote:
> 
>> Benjamin reported that, the machine deadlocks right after printing the
>> following when doing a shutdown:
>>
>> halt/4071 is trying to acquire lock:
>>  (s_active){++++.+}, at: [<c0000000001ef868>] .sysfs_addrm_finish+0x58/0xc0
>>
>> but task is already holding lock:
>>  (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at: [<c0000000004cd6ac>] .lock_policy_rwsem_write+0x84/0xf4
>>
>> which lock already depends on the new lock.
>>
>> the existing dependency chain (in reverse order) is:
>>
>> <nothing else ... machine deadlocked here>
>>
>>
>> This is because we are trying to kobject_put() a kobject while
>> we are holding cpu policy rwsem. So just move kobject_put()
>> down after releasing the rwsem.
>>
>> Totally untested.
>>
>> Reported-by: Xiaotian Feng <xtfeng@gmail.com>
>> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Dave Jones <davej@redhat.com>
>> Cc: Thomas Renninger <trenn@suse.de>
>> Cc: Prarit Bhargava <prarit@redhat.com>
>> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>
>> ---
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 67bc2ec..222b35f 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1113,6 +1113,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
>>  	unsigned int cpu = sys_dev->id;
>>  	unsigned long flags;
>>  	struct cpufreq_policy *data;
>> +	struct kobject *kobj;
>>  #ifdef CONFIG_SMP
>>  	struct sys_device *cpu_sys_dev;
>>  	unsigned int j;
>> @@ -1192,7 +1193,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
>>  	if (cpufreq_driver->target)
>>  		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
>>  
>> -	kobject_put(&data->kobj);
>> +	kobj = &data->kobj;
>>  
>>  	/* we need to make sure that the underlying kobj is actually
>>  	 * not referenced anymore by anybody before we proceed with
> 
> NACK.
> 
> If you read this comment, it says:
> 
> 	/* we need to make sure that the underlying kobj is actually
> 	 * not referenced anymore by anybody before we proceed with
> 	 * unloading.
> 	 */
> 
> That would suggest that the wait_for_completion(&data->kobj_unregister); 
> would never actually return if you're holding a reference to it in your 
> patch since it only completes when the last reference is dropped (the 
> ->release function is cpufreq_sysfs_release()).

Oh, my bad.

Then this case seems to be more complex... But anyway, this is _not_ a
bogus.

Thanks.
