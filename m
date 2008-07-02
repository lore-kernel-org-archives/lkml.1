Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbYGBDzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbYGBDzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYGBDz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:55:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60136 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512AbYGBDz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:55:28 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5329"; a="4218884"
Message-ID: <486AFC33.7010901@qualcomm.com>
Date: Tue, 01 Jul 2008 20:55:31 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: a.p.zijlstra@chello.nl, pj@sgi.com, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] CGroups: Add a per-subsystem hierarchy lock
References: <20080627075912.92AE43D6907@localhost> <6599ad830806271702y2c1df2edh3a75dda75336ddad@mail.gmail.com>
In-Reply-To: <6599ad830806271702y2c1df2edh3a75dda75336ddad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Sorry for the delay.

Paul Menage wrote:
> On Fri, Jun 27, 2008 at 12:59 AM, Paul Menage <menage@google.com> wrote:
>> This patch adds a hierarchy_mutex to the cgroup_subsys object that
>> protects changes to the hierarchy observed by that subsystem. It is
>> taken by the cgroup subsystem for the following operations:
>>
>> - linking a cgroup into that subsystem's cgroup tree
>> - unlinking a cgroup from that subsystem's cgroup tree
>> - moving the subsystem to/from a hierarchy (including across the
>>  bind() callback)
>>
>> Thus if the subsystem holds its own hierarchy_mutex, it can safely
>> traverse its ts own hierarchy.
>>
>
> It struck me that there's a small race in this code now that we're not
> doing cgroup_lock() in the hotplug path.
>
> - we start to attach a task T to cpuset C, with a single CPU "X" in
> its "cpus" list
> - cpuset_can_attach() returns successfully since the cpuset has a cpu
> - CPU X gets hot-unplugged; any tasks in C are moved to their parent
> cpuset and C loses its cpu.
> - we update T->cgroups to point to C, which is broken since C has no cpus.
>
> So we'll need some additional locking work on top of this - but I
> think this patch is still a step in the right direction.
I was about to say "yeah, looks good" and then tried a couple of
different hot-plug scenarious.
We still have circular locking even with your patch

[ INFO: possible circular locking dependency detected ]
2.6.26-rc8 #4
-------------------------------------------------------
bash/2779 is trying to acquire lock:
 (&cpu_hotplug.lock){--..}, at: [<ffffffff8025e024>] get_online_cpus+0x24/0x40

but task is already holding lock:
 (sched_domains_mutex){--..}, at: [<ffffffff8022f5e9>]
partition_sched_domains+0x29/0x2b0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (sched_domains_mutex){--..}:
       [<ffffffff8025988f>] __lock_acquire+0x9cf/0xe50
       [<ffffffff80259d6b>] lock_acquire+0x5b/0x80
       [<ffffffff804d12c4>] mutex_lock_nested+0x94/0x250
       [<ffffffff8022f5e9>] partition_sched_domains+0x29/0x2b0
       [<ffffffff80268f9d>] rebuild_sched_domains+0x9d/0x3f0
       [<ffffffff80269f05>] cpuset_handle_cpuhp+0x205/0x220
       [<ffffffff804d688f>] notifier_call_chain+0x3f/0x80
       [<ffffffff80250679>] __raw_notifier_call_chain+0x9/0x10
       [<ffffffff804c1748>] _cpu_down+0xa8/0x290
       [<ffffffff804c196b>] cpu_down+0x3b/0x60
       [<ffffffff804c2c68>] store_online+0x48/0xa0
       [<ffffffff803a46c4>] sysdev_store+0x24/0x30
       [<ffffffff802eebba>] sysfs_write_file+0xca/0x140
       [<ffffffff8029cb3b>] vfs_write+0xcb/0x170
       [<ffffffff8029ccd0>] sys_write+0x50/0x90
       [<ffffffff8020b92b>] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&ss->hierarchy_mutex){--..}:
       [<ffffffff8025988f>] __lock_acquire+0x9cf/0xe50
       [<ffffffff80259d6b>] lock_acquire+0x5b/0x80
       [<ffffffff804d12c4>] mutex_lock_nested+0x94/0x250
       [<ffffffff80269d39>] cpuset_handle_cpuhp+0x39/0x220
       [<ffffffff804d688f>] notifier_call_chain+0x3f/0x80
       [<ffffffff80250679>] __raw_notifier_call_chain+0x9/0x10
       [<ffffffff804c1748>] _cpu_down+0xa8/0x290
       [<ffffffff804c196b>] cpu_down+0x3b/0x60
       [<ffffffff804c2c68>] store_online+0x48/0xa0
       [<ffffffff803a46c4>] sysdev_store+0x24/0x30
       [<ffffffff802eebba>] sysfs_write_file+0xca/0x140
       [<ffffffff8029cb3b>] vfs_write+0xcb/0x170
       [<ffffffff8029ccd0>] sys_write+0x50/0x90
       [<ffffffff8020b92b>] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&cpu_hotplug.lock){--..}:
       [<ffffffff80259913>] __lock_acquire+0xa53/0xe50
       [<ffffffff80259d6b>] lock_acquire+0x5b/0x80
       [<ffffffff804d12c4>] mutex_lock_nested+0x94/0x250
       [<ffffffff8025e024>] get_online_cpus+0x24/0x40
       [<ffffffff8022fee1>] sched_getaffinity+0x11/0x80
       [<ffffffff8026e6d9>] __synchronize_sched+0x19/0x90
       [<ffffffff8022ed46>] detach_destroy_domains+0x46/0x50
       [<ffffffff8022f6b9>] partition_sched_domains+0xf9/0x2b0
       [<ffffffff80268f9d>] rebuild_sched_domains+0x9d/0x3f0
       [<ffffffff8026a858>] cpuset_common_file_write+0x2b8/0x5c0
       [<ffffffff8026657c>] cgroup_file_write+0x7c/0x1a0
       [<ffffffff8029cb3b>] vfs_write+0xcb/0x170
       [<ffffffff8029ccd0>] sys_write+0x50/0x90
       [<ffffffff8020b92b>] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by bash/2779:
 #0:  (cgroup_mutex){--..}, at: [<ffffffff802653e2>] cgroup_lock+0x12/0x20
 #1:  (sched_domains_mutex){--..}, at: [<ffffffff8022f5e9>]
partition_sched_domains+0x29/0x2b0

stack backtrace:
Pid: 2779, comm: bash Not tainted 2.6.26-rc8 #4

Call Trace:
 [<ffffffff80258c0c>] print_circular_bug_tail+0x8c/0x90
 [<ffffffff802589c4>] ? print_circular_bug_entry+0x54/0x60
 [<ffffffff80259913>] __lock_acquire+0xa53/0xe50
 [<ffffffff8025e024>] ? get_online_cpus+0x24/0x40
 [<ffffffff80259d6b>] lock_acquire+0x5b/0x80
 [<ffffffff8025e024>] ? get_online_cpus+0x24/0x40
 [<ffffffff804d12c4>] mutex_lock_nested+0x94/0x250
 [<ffffffff8025867d>] ? mark_held_locks+0x4d/0x90
 [<ffffffff8025e024>] get_online_cpus+0x24/0x40
 [<ffffffff8022fee1>] sched_getaffinity+0x11/0x80
 [<ffffffff8026e6d9>] __synchronize_sched+0x19/0x90
 [<ffffffff8022ed46>] detach_destroy_domains+0x46/0x50
 [<ffffffff8022f6b9>] partition_sched_domains+0xf9/0x2b0
 [<ffffffff80258801>] ? trace_hardirqs_on+0xc1/0xe0
 [<ffffffff80268f9d>] rebuild_sched_domains+0x9d/0x3f0
 [<ffffffff8026a858>] cpuset_common_file_write+0x2b8/0x5c0
 [<ffffffff80268c00>] ? cpuset_test_cpumask+0x0/0x20
 [<ffffffff80269f20>] ? cpuset_change_cpumask+0x0/0x20
 [<ffffffff80265260>] ? started_after+0x0/0x50
 [<ffffffff8026657c>] cgroup_file_write+0x7c/0x1a0
 [<ffffffff8029cb3b>] vfs_write+0xcb/0x170
 [<ffffffff8029ccd0>] sys_write+0x50/0x90
 [<ffffffff8020b92b>] system_call_after_swapgs+0x7b/0x80

CPU3 attaching NULL sched-domain.



