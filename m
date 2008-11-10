Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYKJHmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYKJHmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbYKJHmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:42:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50368 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbYKJHmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:42:35 -0500
Message-ID: <4917E4C9.5060900@cn.fujitsu.com>
Date: Mon, 10 Nov 2008 15:37:45 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: update top cpuset's mems after adding a node
References: <4917D7B4.4000605@cn.fujitsu.com> <20081110155231.F82E.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20081110155231.F82E.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2008-11-10 14:56 Yasunori Goto wrote:
> Did you test this patch?  Was it OK?

Sorry. I forget.
I will do it as soon as possible. 

> If yes,
> Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> 
> 
> Thanks.
> 
> 
>> After adding a node into the machine, top cpuset's mems isn't updated.
>>
>> By reviewing the code, we found that the update function
>>   cpuset_track_online_nodes()
>> was invoked after node_states[N_ONLINE] changes. It is wrong because N_ONLINE
>> just means node has pgdat, and if node has/added memory, we use N_HIGH_MEMORY.
>> So, We should invoke the update function after node_states[N_HIGH_MEMORY]
>> changes, just like its commit says.
>>
>> This patch fixes it. And we use notifier of memory hotplug instead of direct
>> calling of cpuset_track_online_nodes().
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
>>
>> ---
>>  include/linux/cpuset.h |    4 ----
>>  kernel/cpuset.c        |   19 ++++++++++++++++---
>>  mm/memory_hotplug.c    |    3 ---
>>  3 files changed, 16 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>> index 2691926..8e540d3 100644
>> --- a/include/linux/cpuset.h
>> +++ b/include/linux/cpuset.h
>> @@ -74,8 +74,6 @@ static inline int cpuset_do_slab_mem_spread(void)
>>  	return current->flags & PF_SPREAD_SLAB;
>>  }
>>  
>> -extern void cpuset_track_online_nodes(void);
>> -
>>  extern int current_cpuset_is_being_rebound(void);
>>  
>>  extern void rebuild_sched_domains(void);
>> @@ -151,8 +149,6 @@ static inline int cpuset_do_slab_mem_spread(void)
>>  	return 0;
>>  }
>>  
>> -static inline void cpuset_track_online_nodes(void) {}
>> -
>>  static inline int current_cpuset_is_being_rebound(void)
>>  {
>>  	return 0;
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index 3e00526..909a548 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -36,6 +36,7 @@
>>  #include <linux/list.h>
>>  #include <linux/mempolicy.h>
>>  #include <linux/mm.h>
>> +#include <linux/memory.h>
>>  #include <linux/module.h>
>>  #include <linux/mount.h>
>>  #include <linux/namei.h>
>> @@ -2011,12 +2012,23 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
>>   * Call this routine anytime after node_states[N_HIGH_MEMORY] changes.
>>   * See also the previous routine cpuset_track_online_cpus().
>>   */
>> -void cpuset_track_online_nodes(void)
>> +static int cpuset_track_online_nodes(struct notifier_block *self,
>> +				unsigned long action, void *arg)
>>  {
>>  	cgroup_lock();
>> -	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>> -	scan_for_empty_cpusets(&top_cpuset);
>> +	switch (action) {
>> +	case MEM_ONLINE:
>> +		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>> +		break;
>> +	case MEM_OFFLINE:
>> +		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>> +		scan_for_empty_cpusets(&top_cpuset);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>>  	cgroup_unlock();
>> +	return NOTIFY_OK;
>>  }
>>  #endif
>>  
>> @@ -2032,6 +2044,7 @@ void __init cpuset_init_smp(void)
>>  	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>>  
>>  	hotcpu_notifier(cpuset_track_online_cpus, 0);
>> +	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
>>  }
>>  
>>  /**
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 6837a10..b5b2b15 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -22,7 +22,6 @@
>>  #include <linux/highmem.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/ioport.h>
>> -#include <linux/cpuset.h>
>>  #include <linux/delay.h>
>>  #include <linux/migrate.h>
>>  #include <linux/page-isolation.h>
>> @@ -498,8 +497,6 @@ int add_memory(int nid, u64 start, u64 size)
>>  	/* we online node here. we can't roll back from here. */
>>  	node_set_online(nid);
>>  
>> -	cpuset_track_online_nodes();
>> -
>>  	if (new_pgdat) {
>>  		ret = register_one_node(nid);
>>  		/*
>> -- 
>> 1.5.3.8
>>
> 


