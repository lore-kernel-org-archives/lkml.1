Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbXA0UrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbXA0UrH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbXA0UrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:47:07 -0500
Received: from www.osadl.org ([213.239.205.134]:55958 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751970AbXA0UrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:47:06 -0500
Subject: Re: Linux 2.6.20-rc6 - supend lockdep warning
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 27 Jan 2007 21:47:34 +0100
Message-Id: <1169930854.17469.114.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 18:58 -0800, Linus Torvalds wrote:
> It's been more than a week since -rc5, but I blame everybody (including 
> me) being away for Linux.conf.au and then me waiting for a few days 
> afterwards to let everybody sync up.

2.6.20-rc6-git (today) on a dual core laptop:

PM: Preparing system for mem sleep
Disabling non-boot CPUs ...

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.20-rc6 #3
-------------------------------------------------------
pm-suspend/3601 is trying to acquire lock:
 (cpu_bitmask_lock){--..}, at: [<c032cd2b>] mutex_lock+0x1c/0x1f

but task is already holding lock:
 (workqueue_mutex){--..}, at: [<c032cd2b>] mutex_lock+0x1c/0x1f

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (workqueue_mutex){--..}:
       [<c0140880>] __lock_acquire+0x8dd/0xa04
       [<c0140c90>] lock_acquire+0x56/0x6f
       [<c032cb80>] __mutex_lock_slowpath+0xe5/0x274
       [<c032cd2b>] mutex_lock+0x1c/0x1f
       [<c0136d14>] __create_workqueue+0x61/0x136
       [<f8bfe62e>] cpufreq_governor_dbs+0xa1/0x30e [cpufreq_ondemand]
       [<c02b2c3c>] __cpufreq_governor+0x9e/0xd2
       [<c02b2df7>] __cpufreq_set_policy+0x187/0x209
       [<c02b3056>] store_scaling_governor+0x164/0x1b1
       [<c02b24f9>] store+0x37/0x48
       [<c01aeb8d>] sysfs_write_file+0xb3/0xdb
       [<c0175e0f>] vfs_write+0xaf/0x163
       [<c017645d>] sys_write+0x3d/0x61
       [<c0103f8c>] sysenter_past_esp+0x5d/0x99
       [<ffffffff>] 0xffffffff

-> #2 (dbs_mutex){--..}:
       [<c0140880>] __lock_acquire+0x8dd/0xa04
       [<c0140c90>] lock_acquire+0x56/0x6f
       [<c032cb80>] __mutex_lock_slowpath+0xe5/0x274
       [<c032cd2b>] mutex_lock+0x1c/0x1f
       [<f8bfe612>] cpufreq_governor_dbs+0x85/0x30e [cpufreq_ondemand]
       [<c02b2c3c>] __cpufreq_governor+0x9e/0xd2
       [<c02b2df7>] __cpufreq_set_policy+0x187/0x209
       [<c02b3056>] store_scaling_governor+0x164/0x1b1
       [<c02b24f9>] store+0x37/0x48
       [<c01aeb8d>] sysfs_write_file+0xb3/0xdb
       [<c0175e0f>] vfs_write+0xaf/0x163
       [<c017645d>] sys_write+0x3d/0x61
       [<c0103f8c>] sysenter_past_esp+0x5d/0x99
       [<ffffffff>] 0xffffffff

-> #1 (&policy->lock){--..}:
       [<c0140880>] __lock_acquire+0x8dd/0xa04
       [<c0140c90>] lock_acquire+0x56/0x6f
       [<c032cb80>] __mutex_lock_slowpath+0xe5/0x274
       [<c032cd2b>] mutex_lock+0x1c/0x1f
       [<c02b2ea2>] cpufreq_set_policy+0x29/0x79
       [<c02b3804>] cpufreq_add_dev+0x342/0x48a
       [<c025a799>] sysdev_driver_register+0x5f/0xa9
       [<c02b2ad5>] cpufreq_register_driver+0xac/0x175
       [<c046fd3f>] centrino_init+0x9b/0xa2
       [<c01004c4>] init+0x11b/0x2c8
       [<c0104c87>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (cpu_bitmask_lock){--..}:
       [<c0140781>] __lock_acquire+0x7de/0xa04
       [<c0140c90>] lock_acquire+0x56/0x6f
       [<c032cb80>] __mutex_lock_slowpath+0xe5/0x274
       [<c032cd2b>] mutex_lock+0x1c/0x1f
       [<c0144840>] lock_cpu_hotplug+0x6c/0x78
       [<c02b3264>] cpufreq_driver_target+0x28/0x5e
       [<c02b398e>] cpufreq_cpu_callback+0x42/0x52
       [<c0133cd3>] notifier_call_chain+0x20/0x31
       [<c0133d00>] raw_notifier_call_chain+0x8/0xa
       [<c014452e>] _cpu_down+0x47/0x1fb
       [<c01448c7>] disable_nonboot_cpus+0x7b/0x100
       [<c014853f>] enter_state+0x91/0x1bb
       [<c01486ef>] state_store+0x86/0x9c
       [<c01ae8e8>] subsys_attr_store+0x20/0x25
       [<c01aeb8d>] sysfs_write_file+0xb3/0xdb
       [<c0175e0f>] vfs_write+0xaf/0x163
       [<c017645d>] sys_write+0x3d/0x61
       [<c0103f8c>] sysenter_past_esp+0x5d/0x99
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

4 locks held by pm-suspend/3601:
 #0:  (pm_mutex){--..}, at: [<c01484ee>] enter_state+0x40/0x1bb
 #1:  (cpu_add_remove_lock){--..}, at: [<c032cd2b>] mutex_lock+0x1c/0x1f
 #2:  (cache_chain_mutex){--..}, at: [<c032cd2b>] mutex_lock+0x1c/0x1f
 #3:  (workqueue_mutex){--..}, at: [<c032cd2b>] mutex_lock+0x1c/0x1f

stack backtrace:
 [<c0104ff6>] show_trace_log_lvl+0x1a/0x2f
 [<c01056af>] show_trace+0x12/0x14
 [<c0105761>] dump_stack+0x16/0x18
 [<c013f101>] print_circular_bug_tail+0x5f/0x68
 [<c0140781>] __lock_acquire+0x7de/0xa04
 [<c0140c90>] lock_acquire+0x56/0x6f
 [<c032cb80>] __mutex_lock_slowpath+0xe5/0x274
 [<c032cd2b>] mutex_lock+0x1c/0x1f
 [<c0144840>] lock_cpu_hotplug+0x6c/0x78
 [<c02b3264>] cpufreq_driver_target+0x28/0x5e
 [<c02b398e>] cpufreq_cpu_callback+0x42/0x52
 [<c0133cd3>] notifier_call_chain+0x20/0x31
 [<c0133d00>] raw_notifier_call_chain+0x8/0xa
 [<c014452e>] _cpu_down+0x47/0x1fb
 [<c01448c7>] disable_nonboot_cpus+0x7b/0x100
 [<c014853f>] enter_state+0x91/0x1bb
 [<c01486ef>] state_store+0x86/0x9c
 [<c01ae8e8>] subsys_attr_store+0x20/0x25
 [<c01aeb8d>] sysfs_write_file+0xb3/0xdb
 [<c0175e0f>] vfs_write+0xaf/0x163
 [<c017645d>] sys_write+0x3d/0x61
 [<c0103f8c>] sysenter_past_esp+0x5d/0x99
 =======================
Breaking affinity for irq 1
Breaking affinity for irq 12
Breaking affinity for irq 21
Breaking affinity for irq 22
Breaking affinity for irq 219
CPU 1 is now offline


