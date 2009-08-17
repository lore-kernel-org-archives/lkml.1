Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbZHQRxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbZHQRxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 13:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbZHQRxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 13:53:38 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:60396 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbZHQRxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 13:53:37 -0400
Date: Mon, 17 Aug 2009 19:53:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [circular locking bug] Re: [patch 00/15] clocksource /
 timekeeping rework V4 (resend V3 + bug fix)
Message-ID: <20090817195332.1e1f98b0@skybase>
In-Reply-To: <20090817092807.GA10460@elte.hu>
References: <20090814134717.859098725@de.ibm.com>
	<1250300765.8269.29.camel@localhost.localdomain>
	<alpine.LFD.2.00.0908151057500.1283@localhost.localdomain>
	<20090815095221.GA15831@elte.hu>
	<alpine.LFD.2.00.0908151207000.1283@localhost.localdomain>
	<20090817094042.03fe5d38@skybase>
	<alpine.LFD.2.00.0908171038420.2782@localhost.localdomain>
	<20090817092807.GA10460@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 11:28:07 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> -tip testing still triggers lockdep troubles with latest 
> timers/core. I think timekeeping_notify() might be involved.
> 
> Bootlog below, config attached.
> [   43.081726] =======================================================
> [   43.089512] [ INFO: possible circular locking dependency detected ]
> [   43.090020] 2.6.31-rc6-tip-01039-ge54d9cb-dirty #4937
> [   43.090020] -------------------------------------------------------
> [   43.090020] S99local/5002 is trying to acquire lock:
> [   43.090020]  (events){+.+.+.}, at: [<ffffffff8106ff4c>] cleanup_workqueue_thread+0x2d/0xdd
> [   43.090020] 
> [   43.090020] but task is already holding lock:
> [   43.090020]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff818387aa>] cpu_down+0x3b/0xb4
> [   43.090020] 
> [   43.090020] which lock already depends on the new lock.
> [   43.090020] 
> [   43.090020] 
> [   43.090020] the existing dependency chain (in reverse order) is:
> [   43.090020] 
> [   43.090020] -> #4 (cpu_add_remove_lock){+.+.+.}:
> [   43.090020]        [<ffffffff8108925d>] check_prev_add+0x18e/0x225
> [   43.090020]        [<ffffffff8108976a>] validate_chain+0x476/0x556
> [   43.090020]        [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
> [   43.090020]        [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
> [   43.090020]        [<ffffffff81872229>] __mutex_lock_common+0x5b/0x3b0
> [   43.090020]        [<ffffffff81872683>] mutex_lock_nested+0x45/0x62
> [   43.090020]        [<ffffffff8105de75>] cpu_maps_update_begin+0x25/0x3b
> [   43.090020]        [<ffffffff81070348>] __create_workqueue_key+0x137/0x200
> [   43.090020]        [<ffffffff810a2397>] stop_machine_create+0x4d/0xc2
> [   43.090020]        [<ffffffff810a2438>] stop_machine+0x2c/0x74
> [   43.090020]        [<ffffffff8107f163>] timekeeping_notify+0x31/0x4c
> [   43.090020]        [<ffffffff81080258>] clocksource_select+0xc9/0xe8
> [   43.090020]        [<ffffffff81080b8c>] clocksource_register+0x70/0xa1
> [   43.090020]        [<ffffffff81d4cc6a>] init_acpi_pm_clocksource+0xf3/0x114
> [   43.090020]        [<ffffffff8100a092>] do_one_initcall+0x65/0x15b
> [   43.090020]        [<ffffffff81d0d992>] do_basic_setup+0x59/0x82
> [   43.090020]        [<ffffffff81d0da3e>] kernel_init+0x83/0xdd
> [   43.090020]        [<ffffffff8101520a>] child_rip+0xa/0x20
> [   43.090020] 
> [   43.090020] -> #3 (setup_lock){+.+.+.}:
> [   43.090020]        [<ffffffff8108925d>] check_prev_add+0x18e/0x225
> [   43.090020]        [<ffffffff8108976a>] validate_chain+0x476/0x556
> [   43.090020]        [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
> [   43.090020]        [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
> [   43.090020]        [<ffffffff81872229>] __mutex_lock_common+0x5b/0x3b0
> [   43.090020]        [<ffffffff81872683>] mutex_lock_nested+0x45/0x62
> [   43.090020]        [<ffffffff810a236f>] stop_machine_create+0x25/0xc2
> [   43.090020]        [<ffffffff810a2438>] stop_machine+0x2c/0x74
> [   43.090020]        [<ffffffff8107f163>] timekeeping_notify+0x31/0x4c
> [   43.090020]        [<ffffffff81080258>] clocksource_select+0xc9/0xe8
> [   43.090020]        [<ffffffff81080b8c>] clocksource_register+0x70/0xa1
> [   43.090020]        [<ffffffff81d4cc6a>] init_acpi_pm_clocksource+0xf3/0x114
> [   43.090020]        [<ffffffff8100a092>] do_one_initcall+0x65/0x15b
> [   43.090020]        [<ffffffff81d0d992>] do_basic_setup+0x59/0x82
> [   43.090020]        [<ffffffff81d0da3e>] kernel_init+0x83/0xdd
> [   43.090020]        [<ffffffff8101520a>] child_rip+0xa/0x20
> [   43.090020] 
> [   43.090020] -> #2 (clocksource_mutex){+.+.+.}:
> [   43.090020]        [<ffffffff8108925d>] check_prev_add+0x18e/0x225
> [   43.090020]        [<ffffffff8108976a>] validate_chain+0x476/0x556
> [   43.090020]        [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
> [   43.090020]        [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
> [   43.090020]        [<ffffffff81872229>] __mutex_lock_common+0x5b/0x3b0
> [   43.090020]        [<ffffffff81872683>] mutex_lock_nested+0x45/0x62
> [   43.090020]        [<ffffffff8108076c>] clocksource_change_rating+0x34/0xaf
> [   43.090020]        [<ffffffff8108091a>] clocksource_watchdog_work+0x133/0x16f
> [   43.090020]        [<ffffffff8106f9ca>] run_workqueue+0x161/0x265
> [   43.090020]        [<ffffffff8106fbb3>] worker_thread+0xe5/0x10c
> [   43.090020]        [<ffffffff81074b64>] kthread+0x98/0xa0
> [   43.090020]        [<ffffffff8101520a>] child_rip+0xa/0x20
> [   43.090020] 
> [   43.090020] -> #1 (&watchdog_work){+.+...}:
> [   43.090020]        [<ffffffff8108925d>] check_prev_add+0x18e/0x225
> [   43.090020]        [<ffffffff8108976a>] validate_chain+0x476/0x556
> [   43.090020]        [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
> [   43.090020]        [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
> [   43.090020]        [<ffffffff8106f9c4>] run_workqueue+0x15b/0x265
> [   43.090020]        [<ffffffff8106fbb3>] worker_thread+0xe5/0x10c
> [   43.090020]        [<ffffffff81074b64>] kthread+0x98/0xa0
> [   43.090020]        [<ffffffff8101520a>] child_rip+0xa/0x20
> [   43.090020] 
> [   43.090020] -> #0 (events){+.+.+.}:
> [   43.090020]        [<ffffffff81089146>] check_prev_add+0x77/0x225
> [   43.090020]        [<ffffffff8108976a>] validate_chain+0x476/0x556
> [   43.090020]        [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
> [   43.090020]        [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
> [   43.090020]        [<ffffffff8106ff73>] cleanup_workqueue_thread+0x54/0xdd
> [   43.090020]        [<ffffffff81839c41>] workqueue_cpu_callback+0xdb/0x13f
> [   43.090020]        [<ffffffff8187714e>] notifier_call_chain+0x6d/0xb5
> [   43.090020]        [<ffffffff8107a19e>] raw_notifier_call_chain+0x22/0x38
> [   43.090020]        [<ffffffff81838735>] _cpu_down+0x2c2/0x2fc
> [   43.090020]        [<ffffffff818387cc>] cpu_down+0x5d/0xb4
> [   43.090020]        [<ffffffff8183988e>] store_online+0x3f/0x9a
> [   43.090020]        [<ffffffff813c2e41>] sysdev_store+0x2e/0x44
> [   43.090020]        [<ffffffff811559a5>] sysfs_write_file+0xf3/0x13c
> [   43.090020]        [<ffffffff810f6f7a>] vfs_write+0xbe/0x130
> [   43.090020]        [<ffffffff810f70e2>] sys_write+0x56/0x93
> [   43.090020]        [<ffffffff81014042>] system_call_fastpath+0x16/0x1b
> [   43.090020] 
> [   43.090020] other info that might help us debug this:
> [   43.090020] 
> [   43.090020] 2 locks held by S99local/5002:
> [   43.090020]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811558f9>] sysfs_write_file+0x47/0x13c
> [   43.090020]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff818387aa>] cpu_down+0x3b/0xb4
> [   43.090020] 
> [   43.090020] stack backtrace:
> [   43.090020] Pid: 5002, comm: S99local Not tainted 2.6.31-rc6-tip-01039-ge54d9cb-dirty #4937
> [   43.090020] Call Trace:
> [   43.090020]  [<ffffffff81088bb0>] print_circular_bug+0xcf/0xf4
> [   43.090020]  [<ffffffff81089146>] check_prev_add+0x77/0x225
> [   43.090020]  [<ffffffff818710e5>] ? wait_for_common+0xeb/0x150
> [   43.090020]  [<ffffffff8108976a>] validate_chain+0x476/0x556
> [   43.090020]  [<ffffffff81087d17>] ? mark_lock+0x31/0x17d
> [   43.090020]  [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
> [   43.090020]  [<ffffffff8106ff4c>] ? cleanup_workqueue_thread+0x2d/0xdd
> [   43.090020]  [<ffffffff8106ff4c>] ? cleanup_workqueue_thread+0x2d/0xdd
> [   43.090020]  [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
> [   43.090020]  [<ffffffff8106ff4c>] ? cleanup_workqueue_thread+0x2d/0xdd
> [   43.090020]  [<ffffffff81871283>] ? wait_for_completion+0x2b/0x41
> [   43.090020]  [<ffffffff81074be5>] ? kthread_stop+0x79/0xd9
> [   43.090020]  [<ffffffff8106ff73>] cleanup_workqueue_thread+0x54/0xdd
> [   43.090020]  [<ffffffff8106ff4c>] ? cleanup_workqueue_thread+0x2d/0xdd
> [   43.090020]  [<ffffffff81839c41>] workqueue_cpu_callback+0xdb/0x13f
> [   43.090020]  [<ffffffff8187714e>] notifier_call_chain+0x6d/0xb5
> [   43.090020]  [<ffffffff8107a19e>] raw_notifier_call_chain+0x22/0x38
> [   43.090020]  [<ffffffff81838735>] _cpu_down+0x2c2/0x2fc
> [   43.090020]  [<ffffffff818710e5>] ? wait_for_common+0xeb/0x150
> [   43.090020]  [<ffffffff818387cc>] cpu_down+0x5d/0xb4
> [   43.090020]  [<ffffffff8183988e>] store_online+0x3f/0x9a
> [   43.090020]  [<ffffffff813c2e41>] sysdev_store+0x2e/0x44
> [   43.090020]  [<ffffffff811559a5>] sysfs_write_file+0xf3/0x13c
> [   43.090020]  [<ffffffff810f65fa>] ? rw_verify_area+0x97/0xd1
> [   43.090020]  [<ffffffff810f6f7a>] vfs_write+0xbe/0x130
> [   43.090020]  [<ffffffff810f70e2>] sys_write+0x56/0x93
> [   43.090020]  [<ffffffff81014042>] system_call_fastpath+0x16/0x1b
> [   43.829633] lockdep: fixing up alternatives.

Urg. As far as I read the lockdep message it complains about this: 
cpu_down tries to remove the workqueue, the workqueue tries to get
the clocksource_mutex, timekeeping_notify is called with the
clocksource_mutex held and tries to execute stop_machine which is
blocked because of cpu_down.
A solution would be to use a single-threaded workqueue, no?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

