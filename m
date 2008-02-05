Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYBEOGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYBEOGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 09:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYBEOG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 09:06:29 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:30719 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYBEOG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 09:06:27 -0500
Message-Id: <47A82590.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 05 Feb 2008 07:00:00 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: <dwalker@mvista.com>, "Max Krasnyanskiy" <maxk@qualcomm.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: CPU hotplug and IRQ affinity with 2.6.24-rt1
References: <47A7A131.8040800@qualcomm.com>
 <20080205025144.GA31774@dwalker1.mvista.com>
In-Reply-To: <20080205025144.GA31774@dwalker1.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Feb 4, 2008 at  9:51 PM, in message
<20080205025144.GA31774@dwalker1.mvista.com>, Daniel Walker
<dwalker@dwalker1.mvista.com> wrote: 
> On Mon, Feb 04, 2008 at 03:35:13PM -0800, Max Krasnyanskiy wrote:

[snip]

>>
>> Also the first thing I tried was to bring CPU1 off-line. Thats the fastest 
>> way to get irqs, soft-irqs, timers, etc of a CPU. But the box hung 
>> completely.

After applying my earlier submitted patch, I was able to reproduce the hang you mentioned.  I poked around in sysrq and it looked like a deadlock on a rt_mutex, so I turned on lockdep and it found:


=======================================================
[ INFO: possible circular locking dependency detected ]
[ 2.6.24-rt1-rt #3
-------------------------------------------------------
bash/4604 is trying to acquire lock:
 (events){--..}, at: [<ffffffff802537b6>] cleanup_workqueue_thread+0x16/0x80

but task is already holding lock:
 (workqueue_mutex){--..}, at: [<ffffffff80254615>] workqueue_cpu_callback+0xe5/0x140

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (workqueue_mutex){--..}:
       [<ffffffff80266752>] __lock_acquire+0xf82/0x1090
       [<ffffffff802668b7>] lock_acquire+0x57/0x80
       [<ffffffff80254615>] workqueue_cpu_callback+0xe5/0x140
       [<ffffffff80486818>] _mutex_lock+0x28/0x40
       [<ffffffff80254615>] workqueue_cpu_callback+0xe5/0x140
       [<ffffffff8048a575>] notifier_call_chain+0x45/0x90
       [<ffffffff8025d079>] __raw_notifier_call_chain+0x9/0x10
       [<ffffffff8025d091>] raw_notifier_call_chain+0x11/0x20
       [<ffffffff8026d157>] _cpu_down+0x97/0x2d0
       [<ffffffff8026d3b5>] cpu_down+0x25/0x60
       [<ffffffff8026d3c8>] cpu_down+0x38/0x60
       [<ffffffff803d6719>] store_online+0x49/0xa0
       [<ffffffff803d2774>] sysdev_store+0x24/0x30
       [<ffffffff8031279f>] sysfs_write_file+0xcf/0x140
       [<ffffffff802c0005>] vfs_write+0xe5/0x1a0
       [<ffffffff802c0733>] sys_write+0x53/0x90
       [<ffffffff8020c4fe>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #4 (cache_chain_mutex){--..}:
       [<ffffffff80266752>] __lock_acquire+0xf82/0x1090
       [<ffffffff802668b7>] lock_acquire+0x57/0x80
       [<ffffffff802bb7fa>] kmem_cache_create+0x6a/0x480
       [<ffffffff80486818>] _mutex_lock+0x28/0x40
       [<ffffffff802bb7fa>] kmem_cache_create+0x6a/0x480
       [<ffffffff802872a6>] __rcu_read_unlock+0x96/0xb0
       [<ffffffff8046b824>] fib_hash_init+0xa4/0xe0
       [<ffffffff80467ee5>] fib_new_table+0x35/0x70
       [<ffffffff80467fb1>] fib_magic+0x91/0x100
       [<ffffffff80468093>] fib_add_ifaddr+0x73/0x170
       [<ffffffff8046829b>] fib_inetaddr_event+0x4b/0x260
       [<ffffffff8048a575>] notifier_call_chain+0x45/0x90
       [<ffffffff8025d2ce>] __blocking_notifier_call_chain+0x5e/0x90
       [<ffffffff8025d311>] blocking_notifier_call_chain+0x11/0x20
       [<ffffffff8045f714>] __inet_insert_ifa+0xd4/0x170
       [<ffffffff8045f7bd>] inet_insert_ifa+0xd/0x10
       [<ffffffff8046083a>] inetdev_event+0x45a/0x510
       [<ffffffff8041ee4d>] fib_rules_event+0x6d/0x160
       [<ffffffff8048a575>] notifier_call_chain+0x45/0x90
       [<ffffffff8025d079>] __raw_notifier_call_chain+0x9/0x10
       [<ffffffff8025d091>] raw_notifier_call_chain+0x11/0x20
       [<ffffffff8040f466>] call_netdevice_notifiers+0x16/0x20
       [<ffffffff80410f6d>] dev_open+0x8d/0xa0
       [<ffffffff8040f5e9>] dev_change_flags+0x99/0x1b0
       [<ffffffff80460ffd>] devinet_ioctl+0x5ad/0x760
       [<ffffffff80410d6a>] dev_ioctl+0x4ba/0x590
       [<ffffffff8026523d>] trace_hardirqs_on+0xd/0x10
       [<ffffffff8046162d>] inet_ioctl+0x5d/0x80
       [<ffffffff80400f21>] sock_ioctl+0xd1/0x260
       [<ffffffff802ce154>] do_ioctl+0x34/0xa0
       [<ffffffff802ce239>] vfs_ioctl+0x79/0x2f0
       [<ffffffff80485f30>] trace_hardirqs_on_thunk+0x3a/0x3f
       [<ffffffff802ce532>] sys_ioctl+0x82/0xa0
       [<ffffffff8020c4fe>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #3 ((inetaddr_chain).rwsem){..--}:
       [<ffffffff80266752>] __lock_acquire+0xf82/0x1090
       [<ffffffff802668b7>] lock_acquire+0x57/0x80
       [<ffffffff8026ca9b>] rt_down_read+0xb/0x10
       [<ffffffff8026ca29>] __rt_down_read+0x29/0x80
       [<ffffffff8026ca9b>] rt_down_read+0xb/0x10
       [<ffffffff8025d2b8>] __blocking_notifier_call_chain+0x48/0x90
       [<ffffffff8025d311>] blocking_notifier_call_chain+0x11/0x20
       [<ffffffff8045f714>] __inet_insert_ifa+0xd4/0x170
       [<ffffffff8045f7bd>] inet_insert_ifa+0xd/0x10
       [<ffffffff8046083a>] inetdev_event+0x45a/0x510
       [<ffffffff8041ee4d>] fib_rules_event+0x6d/0x160
       [<ffffffff8048a575>] notifier_call_chain+0x45/0x90
       [<ffffffff8025d079>] __raw_notifier_call_chain+0x9/0x10
       [<ffffffff8025d091>] raw_notifier_call_chain+0x11/0x20
       [<ffffffff8040f466>] call_netdevice_notifiers+0x16/0x20
       [<ffffffff80410f6d>] dev_open+0x8d/0xa0
       [<ffffffff8040f5e9>] dev_change_flags+0x99/0x1b0
       [<ffffffff80460ffd>] devinet_ioctl+0x5ad/0x760
       [<ffffffff80410d6a>] dev_ioctl+0x4ba/0x590
       [<ffffffff8026523d>] trace_hardirqs_on+0xd/0x10
       [<ffffffff8046162d>] inet_ioctl+0x5d/0x80
       [<ffffffff80400f21>] sock_ioctl+0xd1/0x260
       [<ffffffff802ce154>] do_ioctl+0x34/0xa0
       [<ffffffff802ce239>] vfs_ioctl+0x79/0x2f0
       [<ffffffff80485f30>] trace_hardirqs_on_thunk+0x3a/0x3f
       [<ffffffff802ce532>] sys_ioctl+0x82/0xa0
       [<ffffffff8020c4fe>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #2 (rtnl_mutex){--..}:
       [<ffffffff80266752>] __lock_acquire+0xf82/0x1090
       [<ffffffff802668b7>] lock_acquire+0x57/0x80
       [<ffffffff8041a450>] rtnl_lock+0x10/0x20
       [<ffffffff80486818>] _mutex_lock+0x28/0x40
       [<ffffffff8041a450>] rtnl_lock+0x10/0x20
       [<ffffffff8041b839>] linkwatch_event+0x9/0x40
       [<ffffffff80253481>] run_workqueue+0x221/0x2f0
       [<ffffffff8041b830>] linkwatch_event+0x0/0x40
       [<ffffffff802544c3>] worker_thread+0xd3/0x140
       [<ffffffff80257f40>] autoremove_wake_function+0x0/0x40
       [<ffffffff802543f0>] worker_thread+0x0/0x140
       [<ffffffff80257b4d>] kthread+0x4d/0x80
       [<ffffffff8020d468>] child_rip+0xa/0x12
       [<ffffffff8020cb53>] restore_args+0x0/0x30
       [<ffffffff80257b00>] kthread+0x0/0x80
       [<ffffffff8020d45e>] child_rip+0x0/0x12
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 ((linkwatch_work).work){--..}:
       [<ffffffff80266752>] __lock_acquire+0xf82/0x1090
       [<ffffffff802668b7>] lock_acquire+0x57/0x80
       [<ffffffff8025342a>] run_workqueue+0x1ca/0x2f0
       [<ffffffff8025347a>] run_workqueue+0x21a/0x2f0
       [<ffffffff8041b830>] linkwatch_event+0x0/0x40
       [<ffffffff802544c3>] worker_thread+0xd3/0x140
       [<ffffffff80257f40>] autoremove_wake_function+0x0/0x40
       [<ffffffff802543f0>] worker_thread+0x0/0x140
       [<ffffffff80257b4d>] kthread+0x4d/0x80
       [<ffffffff8020d468>] child_rip+0xa/0x12
       [<ffffffff8020cb53>] restore_args+0x0/0x30
       [<ffffffff80257b00>] kthread+0x0/0x80
       [<ffffffff8020d45e>] child_rip+0x0/0x12
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (events){--..}:
       [<ffffffff802636e9>] print_circular_bug_entry+0x49/0x60
       [<ffffffff80266550>] __lock_acquire+0xd80/0x1090
       [<ffffffff802668b7>] lock_acquire+0x57/0x80
       [<ffffffff802537b6>] cleanup_workqueue_thread+0x16/0x80
       [<ffffffff802537d9>] cleanup_workqueue_thread+0x39/0x80
       [<ffffffff802545bd>] workqueue_cpu_callback+0x8d/0x140
       [<ffffffff8048a575>] notifier_call_chain+0x45/0x90
       [<ffffffff8025d079>] __raw_notifier_call_chain+0x9/0x10
       [<ffffffff8025d091>] raw_notifier_call_chain+0x11/0x20
       [<ffffffff8026d2ab>] _cpu_down+0x1eb/0x2d0
       [<ffffffff8026d3b5>] cpu_down+0x25/0x60
       [<ffffffff8026d3c8>] cpu_down+0x38/0x60
       [<ffffffff803d6719>] store_online+0x49/0xa0
       [<ffffffff803d2774>] sysdev_store+0x24/0x30
       [<ffffffff8031279f>] sysfs_write_file+0xcf/0x140
       [<ffffffff802c0005>] vfs_write+0xe5/0x1a0
       [<ffffffff802c0733>] sys_write+0x53/0x90
       [<ffffffff8020c4fe>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

5 locks held by bash/4604:
 #0:  (&buffer->mutex){--..}, at: [<ffffffff80312711>] sysfs_write_file+0x41/0x140
 #1:  (cpu_add_remove_lock){--..}, at: [<ffffffff8026d3b5>] cpu_down+0x25/0x60
 #2:  (sched_hotcpu_mutex){--..}, at: [<ffffffff80239c31>] migration_call+0x2b1/0x540
 #3:  (cache_chain_mutex){--..}, at: [<ffffffff802bb541>] cpuup_callback+0x211/0x400
 #4:  (workqueue_mutex){--..}, at: [<ffffffff80254615>] workqueue_cpu_callback+0xe5/0x140

stack backtrace:
Pid: 4604, comm: bash Not tainted 2.6.24-rt1-rt #3

Call Trace:
 [<ffffffff80264094>] print_circular_bug_tail+0x84/0x90
 [<ffffffff802636e9>] print_circular_bug_entry+0x49/0x60
 [<ffffffff80266550>] __lock_acquire+0xd80/0x1090
 [<ffffffff802668b7>] lock_acquire+0x57/0x80
 [<ffffffff802537b6>] cleanup_workqueue_thread+0x16/0x80
 [<ffffffff802537d9>] cleanup_workqueue_thread+0x39/0x80
 [<ffffffff802545bd>] workqueue_cpu_callback+0x8d/0x140
 [<ffffffff8048a575>] notifier_call_chain+0x45/0x90
 [<ffffffff8025d079>] __raw_notifier_call_chain+0x9/0x10
 [<ffffffff8025d091>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff8026d2ab>] _cpu_down+0x1eb/0x2d0
 [<ffffffff8026d3b5>] cpu_down+0x25/0x60
 [<ffffffff8026d3c8>] cpu_down+0x38/0x60
 [<ffffffff803d6719>] store_online+0x49/0xa0
 [<ffffffff803d2774>] sysdev_store+0x24/0x30
 [<ffffffff8031279f>] sysfs_write_file+0xcf/0x140
 [<ffffffff802c0005>] vfs_write+0xe5/0x1a0
 [<ffffffff802c0733>] sys_write+0x53/0x90
 [<ffffffff8020c4fe>] system_call+0x7e/0x83

INFO: lockdep is turned off.
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------



