Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZBDJFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZBDJFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZBDJFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:05:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50570 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZBDJFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:05:33 -0500
Message-ID: <498959C6.2090509@cn.fujitsu.com>
Date: Wed, 04 Feb 2009 17:03:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, menage@google.com, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the
 unallowed node when memory spread is set
References: <4976D77C.3020107@cn.fujitsu.com>	<20090127144233.18cf9b3f.akpm@linux-foundation.org>	<4987B925.1010405@cn.fujitsu.com> <20090203141645.91c7ea18.akpm@linux-foundation.org>
In-Reply-To: <20090203141645.91c7ea18.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2009-2-4 6:16 Andrew Morton wrote:
> On Tue, 03 Feb 2009 11:25:25 +0800
> Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
>> on 2009-1-28 6:42 Andrew Morton wrote:
>>> On Wed, 21 Jan 2009 16:06:20 +0800
>>> Miao Xie <miaox@cn.fujitsu.com> wrote:
>>>
>>>> The task still allocated the page caches on old node after modifying its
>>>> cpuset's mems when 'memory_spread_page' was set, it is caused by the old
>>>> mem_allowed_list of the task, the current kernel doesn't updates it unless some
>>>> function invokes cpuset_update_task_memory_state(), it is too late sometimes.
>>>> We must update the mem_allowed_list of the tasks in time.
>>>>
>>>> Slab has the same problem.
>>>>
>>>> We fixes the bug by updating tasks' mem_allowed_list and spread flag after
>>>> its cpuset's mems or spread flag is changed.
>>>>
>>>>
>>>> ...
>>>>
>>>> --- a/kernel/kthread.c
>>>> +++ b/kernel/kthread.c
>>>> @@ -242,6 +242,7 @@ int kthreadd(void *unused)
>>>>  	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
>>>>  	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
>>>>  
>>>> +	current->mems_allowed = node_possible_map;
>>>>  	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
>>> Why this change?  kthreadd() is called from rest_init(), before anyone
>>> has had a chance to alter ->mems_allowed?
>> I found that after mems_allowed of kthreadd was not initialized applying this patch,
>> every bit of it is 1, so...
>> Maybe it is redundant.
> 
> I think it is redundant.  kthreadd's mems_allowed _should_ be all-ones.
> Or at least, all-nodes-allowed.
> 
> I wasn't able to find out where the setting of init'smems_allowed
> happens, after a bit of grepping and hunting.  It should be done within
> INIT_TASK, but isn't.

I found it. Call trace is following:
start_kernel()
  ->build_all_zonelists()
      ->cpuset_init_current_mems_allowed()
          ->nodes_setall(current->mems_allowed);
then, it is inherited by kthreadd.

> 
> Still, kthreadd is reliably parented by swapper, and there shold be no
> need to alter its mems_allowed.

but it is strange to users because there are not so many nodes in the system in fact,
so I think using node_possible_map to set init's mems_allowed is better.

> Similarly, what was the reason for setting current->mems_allowed in
> kernel_init()?  That also should be unneeded.

The same as above.

> 
> Finally, I've somewhat lost track of where we are with this patch. 
> Paul, do you see any other remaining issues?
> 
> 
> 
> 


