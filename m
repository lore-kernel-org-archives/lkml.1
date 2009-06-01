Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZFACqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZFACqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 22:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZFACqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 22:46:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbZFACqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 22:46:09 -0400
Message-ID: <4A23402B.1020601@cn.fujitsu.com>
Date: Mon, 01 Jun 2009 10:42:51 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rusty@rustcorp.com.au, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 2/2] cpuhotplug: introduce try_get_online_cpus()
References: <4A1F9CEE.5090305@cn.fujitsu.com> <20090529133118.1c7b16c2.akpm@linux-foundation.org>
In-Reply-To: <20090529133118.1c7b16c2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
>> ---
>> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
>> index 2643d84..98f5c4b 100644
>> --- a/include/linux/cpu.h
>> +++ b/include/linux/cpu.h
>> @@ -104,6 +104,7 @@ extern struct sysdev_class cpu_sysdev_class;
>>  
>>  extern void get_online_cpus(void);
>>  extern void put_online_cpus(void);
>> +extern int try_get_online_cpus(void);
>>  #define hotcpu_notifier(fn, pri) {				\
>>  	static struct notifier_block fn##_nb __cpuinitdata =	\
>>  		{ .notifier_call = fn, .priority = pri };	\
>> @@ -117,6 +118,7 @@ int cpu_down(unsigned int cpu);
>>  
>>  #define get_online_cpus()	do { } while (0)
>>  #define put_online_cpus()	do { } while (0)
>> +#define try_get_online_cpus()	(1)
>>  #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
>>  /* These aren't inline functions due to a GCC bug. */
>>  #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>> index 62198ec..e948f19 100644
>> --- a/kernel/cpu.c
>> +++ b/kernel/cpu.c
>> @@ -66,6 +66,15 @@ void put_online_cpus(void)
>>  }
>>  EXPORT_SYMBOL_GPL(put_online_cpus);
>>  
>> +int try_get_online_cpus(void)
>> +{
>> +	might_sleep();
>> +	if (cpu_hotplug.active_writer == current)
>> +		return 1;
>> +	return down_read_trylock(&cpu_hotplug.rwlock);
>> +
>> +}
>> +EXPORT_SYMBOL_GPL(try_get_online_cpus);
> 
> It's strange to add a might_sleep() to a function which doesn't sleep.

It might sleep indeed. I prefer to add a might_sleep()/cond_sched()
for a sleepable function.

> 
> The patch adds no callers to this function.  This is significant
> because it would be quite interesting to find out which subsystem(s)
> you've found to have this deadlock.  I do think that we should look at
> alternative (non-trylocky) ways of fixing them.
> 

This problem exist in cgroup/cpuset. and Max Krasnyansky fix it:
(non-trylocky way)
 *
 * The rebuild_sched_domains() and partition_sched_domains()
 * routines must nest cgroup_lock() inside get_online_cpus(),
 * but such cpuset changes as these must nest that locking the
 * other way, holding cgroup_lock() for much of the code.
 *
 * So in order to avoid an ABBA deadlock, the cpuset code handling
 * these user changes delegates the actual sched domain rebuilding
 * to a separate workqueue thread, which ends up processing the
 * above do_rebuild_sched_domains() function.
 */
static void async_rebuild_sched_domains(void)
{
	queue_work(cpuset_wq, &rebuild_sched_domains_work);
}


get_online_cpus() is so a coarsely granular lock, and
try_get_online_cpus() fails rarely. The kernel indeed needs
try_get_online_cpus().

Paul will use it: 
http://lkml.org/lkml/2009/5/22/332

Lai


