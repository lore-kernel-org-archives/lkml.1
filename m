Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbYFZSuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbYFZSuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbYFZStw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:49:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27570 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281AbYFZStq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:49:46 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5326"; a="4080945"
Message-ID: <4863E4C8.9050705@qualcomm.com>
Date: Thu, 26 Jun 2008 11:49:44 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Paul Jackson <pj@sgi.com>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to rebuild_sched_domains()
 to the workqueue
References: <48634BC1.8@google.com>	 <19f34abd0806260234y7616bab2k54bc019dfb0c6305@mail.gmail.com> <6599ad830806260250m39d700a5haf0f32d999cd2129@mail.gmail.com>
In-Reply-To: <6599ad830806260250m39d700a5haf0f32d999cd2129@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Jun 26, 2008 at 2:34 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> On Thu, Jun 26, 2008 at 9:56 AM, Paul Menage <menage@google.com> wrote:
>>> CPUsets: Move most calls to rebuild_sched_domains() to the workqueue
>>>
>>> In the current cpusets code the lock nesting between cgroup_mutex and
>>> cpuhotplug.lock when calling rebuild_sched_domains is inconsistent -
>>> in the CPU hotplug path cpuhotplug.lock nests outside cgroup_mutex,
>>> and in all other paths that call rebuild_sched_domains() it nests
>>> inside.
>>>
>>> This patch makes most calls to rebuild_sched_domains() asynchronous
>>> via the workqueue, which removes the nesting of the two locks in that
>>> case. In the case of an actual hotplug event, cpuhotplug.lock nests
>>> outside cgroup_mutex as now.
>>>
>>> Signed-off-by: Paul Menage <menage@google.com>
>>>
>>> ---
>>>
>>> Note that all I've done with this patch is verify that it compiles
>>> without warnings; I'm not sure how to trigger a hotplug event to test
>>> the lock dependencies or verify that scheduler domain support is still
>>> behaving correctly. 
You can just do:
	echo 0 > /sys/devices/cpu/cpuN/online
	echo 1 > /sys/devices/cpu/cpuN/online

>>> Vegard, does this fix the problems that you were
>>> seeing? Paul/Max, does this still seem sane with regard to scheduler
>>> domains?
>> Nope, sorry :-(
>>
>> =======================================================
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.26-rc8-dirty #39
>> -------------------------------------------------------
>> bash/3510 is trying to acquire lock:
>>  (events){--..}, at: [<c0145690>] cleanup_workqueue_thread+0x10/0x70
>>
>> but task is already holding lock:
>>  (&cpu_hotplug.lock){--..}, at: [<c015d9da>] cpu_hotplug_begin+0x1a/0x50
>>
>> which lock already depends on the new lock.
>>
> 
> Does that mean that you can't ever call get_online_cpus() from a
> workqueue thread?

In general it should be ok (no different from user-space task calling 
it). But there is still circular dependency because we're calling into
domain partitioning code.
Below is more detailed lockdep report with your patch applied on top of 
-rc8.
Looks like this might be a good time to rethink overall locking in there.

> [ INFO: possible circular locking dependency detected ]
> 2.6.26-rc8 #3
> -------------------------------------------------------
> bash/2836 is trying to acquire lock:
>  (cgroup_mutex){--..}, at: [<ffffffff802653e2>] cgroup_lock+0x12/0x20
> 
> but task is already holding lock:
>  (&cpu_hotplug.lock){--..}, at: [<ffffffff8025e062>] cpu_hotplug_begin+0x22/0x60
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&cpu_hotplug.lock){--..}:
>        [<ffffffff8025988f>] __lock_acquire+0x9cf/0xe50
>        [<ffffffff80259d6b>] lock_acquire+0x5b/0x80
>        [<ffffffff804d11b4>] mutex_lock_nested+0x94/0x250
>        [<ffffffff8025e024>] get_online_cpus+0x24/0x40
>        [<ffffffff8022fee1>] sched_getaffinity+0x11/0x80
>        [<ffffffff8026e5c9>] __synchronize_sched+0x19/0x90
>        [<ffffffff8022ed46>] detach_destroy_domains+0x46/0x50
>        [<ffffffff8022f6b9>] partition_sched_domains+0xf9/0x2b0
>        [<ffffffff80268eea>] rebuild_sched_domains+0x9a/0x3e0
>        [<ffffffff80269243>] delayed_rebuild_sched_domains+0x13/0x30
>        [<ffffffff80247d5e>] run_workqueue+0xde/0x220
>        [<ffffffff80247f00>] worker_thread+0x60/0xb0
>        [<ffffffff8024c069>] kthread+0x49/0x90
>        [<ffffffff8020c898>] child_rip+0xa/0x12
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #1 (sched_domains_mutex){--..}:
>        [<ffffffff8025988f>] __lock_acquire+0x9cf/0xe50
>        [<ffffffff80259d6b>] lock_acquire+0x5b/0x80
>        [<ffffffff804d11b4>] mutex_lock_nested+0x94/0x250
>        [<ffffffff8022f5e9>] partition_sched_domains+0x29/0x2b0
>        [<ffffffff80268eea>] rebuild_sched_domains+0x9a/0x3e0
>        [<ffffffff80269243>] delayed_rebuild_sched_domains+0x13/0x30
>        [<ffffffff80247d5e>] run_workqueue+0xde/0x220
>        [<ffffffff80247f00>] worker_thread+0x60/0xb0
>        [<ffffffff8024c069>] kthread+0x49/0x90
>        [<ffffffff8020c898>] child_rip+0xa/0x12
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #0 (cgroup_mutex){--..}:
>        [<ffffffff80259913>] __lock_acquire+0xa53/0xe50
>        [<ffffffff80259d6b>] lock_acquire+0x5b/0x80
>        [<ffffffff804d11b4>] mutex_lock_nested+0x94/0x250
>        [<ffffffff802653e2>] cgroup_lock+0x12/0x20
>        [<ffffffff80269bf1>] cpuset_handle_cpuhp+0x31/0x230
>        [<ffffffff804d677f>] notifier_call_chain+0x3f/0x80
>        [<ffffffff80250679>] __raw_notifier_call_chain+0x9/0x10
>        [<ffffffff804c1638>] _cpu_down+0xa8/0x290
>        [<ffffffff804c185b>] cpu_down+0x3b/0x60
>        [<ffffffff804c2b58>] store_online+0x48/0xa0
>        [<ffffffff803a45b4>] sysdev_store+0x24/0x30
>        [<ffffffff802eeaaa>] sysfs_write_file+0xca/0x140
>        [<ffffffff8029ca2b>] vfs_write+0xcb/0x170
>        [<ffffffff8029cbc0>] sys_write+0x50/0x90
>        [<ffffffff8020b92b>] system_call_after_swapgs+0x7b/0x80
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> other info that might help us debug this:
> 
> 3 locks held by bash/2836:
>  #0:  (&buffer->mutex){--..}, at: [<ffffffff802eea23>] sysfs_write_file+0x43/0x140
>  #1:  (cpu_add_remove_lock){--..}, at: [<ffffffff804c1847>] cpu_down+0x27/0x60
>  #2:  (&cpu_hotplug.lock){--..}, at: [<ffffffff8025e062>] cpu_hotplug_begin+0x22/0x60
> 
> stack backtrace:
> Pid: 2836, comm: bash Not tainted 2.6.26-rc8 #3
> 
> Call Trace:
>  [<ffffffff80258c0c>] print_circular_bug_tail+0x8c/0x90
>  [<ffffffff802589c4>] ? print_circular_bug_entry+0x54/0x60
>  [<ffffffff80259913>] __lock_acquire+0xa53/0xe50
>  [<ffffffff8025867d>] ? mark_held_locks+0x4d/0x90
>  [<ffffffff804d1345>] ? mutex_lock_nested+0x225/0x250
>  [<ffffffff802653e2>] ? cgroup_lock+0x12/0x20
>  [<ffffffff80259d6b>] lock_acquire+0x5b/0x80
>  [<ffffffff802653e2>] ? cgroup_lock+0x12/0x20
>  [<ffffffff804d11b4>] mutex_lock_nested+0x94/0x250
>  [<ffffffff802653e2>] cgroup_lock+0x12/0x20
>  [<ffffffff80269bf1>] cpuset_handle_cpuhp+0x31/0x230
>  [<ffffffff8022edaa>] ? update_sched_domains+0x5a/0x70
>  [<ffffffff804d677f>] notifier_call_chain+0x3f/0x80
>  [<ffffffff80250679>] __raw_notifier_call_chain+0x9/0x10
>  [<ffffffff804c1638>] _cpu_down+0xa8/0x290
>  [<ffffffff804c185b>] cpu_down+0x3b/0x60
>  [<ffffffff804c2b58>] store_online+0x48/0xa0
>  [<ffffffff803a45b4>] sysdev_store+0x24/0x30
>  [<ffffffff802eeaaa>] sysfs_write_file+0xca/0x140
>  [<ffffffff8029ca2b>] vfs_write+0xcb/0x170
>  [<ffffffff8029cbc0>] sys_write+0x50/0x90
>  [<ffffffff8020b92b>] system_call_after_swapgs+0x7b/0x80




