Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZEQKnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZEQKnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 06:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZEQKnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 06:43:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:42917 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbZEQKnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 06:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=fhsUI6yVU6oQTEkhPYUmlWtvhUWBj0jmPJv5BTR8l2QTpCwkx3I4xsZFeXxHu43qy2
         rSv8tqh3Xdc250hkT407vIrtl8c4d5QdAccRYgrNuAHAR5dldQKPxry+5hWCJ2fw0qM3
         R/mnQDDmo+MY0h6bpMm6lkzOg1PIlYuN7n9W4=
Date: Sun, 17 May 2009 18:42:51 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
Message-ID: <20090517184251.1a87a270@linux-lm>
In-Reply-To: <20090517071834.GA8507@elte.hu>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	<20090517071834.GA8507@elte.hu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 May 2009 09:18:34 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> Cc:s added. This dependency:
> 
> > -> #2 (cfg80211_mutex){+.+.+.}:
> >        [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
> >        [<ffffffff80271f38>] lock_acquire+0x98/0x140
> >        [<ffffffff8054e78c>] __mutex_lock_common+0x4c/0x3b0
> >        [<ffffffff8054ebf6>] mutex_lock_nested+0x46/0x60
> >        [<ffffffffa007e66a>] reg_todo+0x19a/0x590 [cfg80211]
> >        [<ffffffff80258f18>] worker_thread+0x1e8/0x3a0
> >        [<ffffffff8025dc3a>] kthread+0x5a/0xa0
> >        [<ffffffff8020d23a>] child_rip+0xa/0x20
> 
> is what sets the dependencies upside down.
> 
> 	Ingo
> 

If I remove cfg80211 and related wireless module, the warning becomes:


[  562.689264] [ INFO: possible circular locking dependency detected ]
[  562.689267] 2.6.30-rc5-next-20090515-00004-g346c29d-dirty #106
[  562.689270] -------------------------------------------------------
[  562.689272] pm-suspend/4672 is trying to acquire lock:
[  562.689275]  (events){+.+.+.}, at: [<ffffffff80258523>] cleanup_workqueue_thread+0x23/0xf1
[  562.689284] 
[  562.689285] but task is already holding lock:
[  562.689287]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff80247685>] disable_nonboot_cpus+0x38/0x125
[  562.689295] 
[  562.689296] which lock already depends on the new lock.
[  562.689298] 
[  562.689299] 
[  562.689300] the existing dependency chain (in reverse order) is:
[  562.689302] 
[  562.689303] -> #5 (cpu_add_remove_lock){+.+.+.}:
[  562.689308]        [<ffffffff8026eae8>] __lock_acquire+0x13a9/0x171c
[  562.689313]        [<ffffffff8026ef5f>] lock_acquire+0x104/0x130
[  562.689318]        [<ffffffff804ab2f0>] mutex_lock_nested+0x6f/0x36b
[  562.689324]        [<ffffffff802475df>] cpu_maps_update_begin+0x17/0x19
[  562.689328]        [<ffffffff8025883d>] __create_workqueue_key+0xef/0x1bd
[  562.689333]        [<ffffffff80282024>] stop_machine_create+0x3f/0xa0
[  562.689338]        [<ffffffff802820a3>] stop_machine+0x1e/0x4f
[  562.689343]        [<ffffffff8028ef29>] ftrace_run_update_code+0x2b/0x7c
[  562.689347]        [<ffffffff8028f21d>] ftrace_startup+0x42/0x44
[  562.689351]        [<ffffffff8028f2a2>] register_ftrace_function+0x83/0x95
[  562.689356]        [<ffffffff8029b09b>] function_trace_init+0x91/0xa1
[  562.689360]        [<ffffffff80298017>] tracer_init+0x1d/0x22
[  562.689366]        [<ffffffff80298c49>] trace_selftest_startup_function+0x4e/0xf7
[  562.689371]        [<ffffffff8029840a>] register_tracer+0x151/0x270
[  562.689375]        [<ffffffff806e7132>] init_function_trace+0x3c/0x3e
[  562.689381]        [<ffffffff80209080>] do_one_initcall+0x75/0x18a
[  562.689386]        [<ffffffff806d0678>] kernel_init+0x138/0x18e
[  562.689391]        [<ffffffff8020c33a>] child_rip+0xa/0x20
[  562.689396]        [<ffffffffffffffff>] 0xffffffffffffffff
[  562.689406] 
[  562.689407] -> #4 (setup_lock){+.+...}:
[  562.689411]        [<ffffffff8026eae8>] __lock_acquire+0x13a9/0x171c
[  562.689416]        [<ffffffff8026ef5f>] lock_acquire+0x104/0x130
[  562.689420]        [<ffffffff804ab2f0>] mutex_lock_nested+0x6f/0x36b
[  562.689424]        [<ffffffff80281ffc>] stop_machine_create+0x17/0xa0
[  562.689429]        [<ffffffff80247668>] disable_nonboot_cpus+0x1b/0x125
[  562.689434]        [<ffffffff8027b235>] suspend_devices_and_enter+0xdb/0x1c0
[  562.689439]        [<ffffffff8027b4b0>] enter_state+0x168/0x1ce
[  562.689443]        [<ffffffff8027b5d2>] state_store+0xbc/0xdd
[  562.689447]        [<ffffffff803696ef>] kobj_attr_store+0x17/0x19
[  562.689452]        [<ffffffff8032d5f9>] sysfs_write_file+0xe9/0x11e
[  562.689457]        [<ffffffff802db580>] vfs_write+0xb3/0x13c
[  562.689462]        [<ffffffff802db6d7>] sys_write+0x4c/0x73
[  562.689466]        [<ffffffff8020b202>] system_call_fastpath+0x16/0x1b
[  562.689471]        [<ffffffffffffffff>] 0xffffffffffffffff
[  562.689475] 
[  562.689476] -> #3 (dpm_list_mtx){+.+.+.}:
[  562.689480]        [<ffffffff8026eae8>] __lock_acquire+0x13a9/0x171c
[  562.689484]        [<ffffffff8026ef5f>] lock_acquire+0x104/0x130
[  562.689489]        [<ffffffff804ab2f0>] mutex_lock_nested+0x6f/0x36b
[  562.689493]        [<ffffffff803f6395>] device_pm_add+0x4b/0xf2
[  562.689499]        [<ffffffff803ef382>] device_add+0x498/0x62a
[  562.689503]        [<ffffffff8043fd32>] netdev_register_kobject+0x7b/0x80
[  562.689509]        [<ffffffff80434761>] register_netdevice+0x2d0/0x469
[  562.689514]        [<ffffffff80434939>] register_netdev+0x3f/0x4d
[  562.689519]        [<ffffffff806f634f>] loopback_net_init+0x40/0x7d
[  562.689524]        [<ffffffff8042ee79>] register_pernet_device+0x32/0x5f
[  562.689528]        [<ffffffff806fb41a>] net_dev_init+0x143/0x1a1
[  562.689533]        [<ffffffff80209080>] do_one_initcall+0x75/0x18a
[  562.689538]        [<ffffffff806d0678>] kernel_init+0x138/0x18e
[  562.689542]        [<ffffffff8020c33a>] child_rip+0xa/0x20
[  562.689546]        [<ffffffffffffffff>] 0xffffffffffffffff
[  562.689550] 
[  562.689551] -> #2 (rtnl_mutex){+.+.+.}:
[  562.689555]        [<ffffffff8026eae8>] __lock_acquire+0x13a9/0x171c
[  562.689559]        [<ffffffff8026ef5f>] lock_acquire+0x104/0x130
[  562.689564]        [<ffffffff804ab2f0>] mutex_lock_nested+0x6f/0x36b
[  562.689568]        [<ffffffff8043cf2d>] rtnl_lock+0x17/0x19
[  562.689573]        [<ffffffff8043df37>] linkwatch_event+0xe/0x2c
[  562.689577]        [<ffffffff8025810b>] worker_thread+0x23a/0x359
[  562.689581]        [<ffffffff8025c258>] kthread+0x5b/0x88
[  562.689586]        [<ffffffff8020c33a>] child_rip+0xa/0x20
[  562.689590]        [<ffffffffffffffff>] 0xffffffffffffffff
[  562.689594] 
[  562.689595] -> #1 ((linkwatch_work).work){+.+...}:
[  562.689599]        [<ffffffff8026eae8>] __lock_acquire+0x13a9/0x171c
[  562.689603]        [<ffffffff8026ef5f>] lock_acquire+0x104/0x130
[  562.689607]        [<ffffffff80258102>] worker_thread+0x231/0x359
[  562.689611]        [<ffffffff8025c258>] kthread+0x5b/0x88
[  562.689616]        [<ffffffff8020c33a>] child_rip+0xa/0x20
[  562.689619]        [<ffffffffffffffff>] 0xffffffffffffffff
[  562.689635] 
[  562.689636] -> #0 (events){+.+.+.}:
[  562.689639]        [<ffffffff8026e81d>] __lock_acquire+0x10de/0x171c
[  562.689644]        [<ffffffff8026ef5f>] lock_acquire+0x104/0x130
[  562.689648]        [<ffffffff8025854a>] cleanup_workqueue_thread+0x4a/0xf1
[  562.689652]        [<ffffffff8049b999>] workqueue_cpu_callback+0xc7/0x10a
[  562.689658]        [<ffffffff802606ff>] notifier_call_chain+0x33/0x5b
[  562.689663]        [<ffffffff802607ab>] raw_notifier_call_chain+0x14/0x16
[  562.689667]        [<ffffffff80499bca>] _cpu_down+0x280/0x29d
[  562.689672]        [<ffffffff802476ca>] disable_nonboot_cpus+0x7d/0x125
[  562.689677]        [<ffffffff8027b235>] suspend_devices_and_enter+0xdb/0x1c0
[  562.689681]        [<ffffffff8027b4b0>] enter_state+0x168/0x1ce
[  562.689685]        [<ffffffff8027b5d2>] state_store+0xbc/0xdd
[  562.689689]        [<ffffffff803696ef>] kobj_attr_store+0x17/0x19
[  562.689694]        [<ffffffff8032d5f9>] sysfs_write_file+0xe9/0x11e
[  562.689698]        [<ffffffff802db580>] vfs_write+0xb3/0x13c
[  562.689702]        [<ffffffff802db6d7>] sys_write+0x4c/0x73
[  562.689706]        [<ffffffff8020b202>] system_call_fastpath+0x16/0x1b
[  562.689711]        [<ffffffffffffffff>] 0xffffffffffffffff
[  562.689715] 
[  562.689716] other info that might help us debug this:
[  562.689717] 
[  562.689720] 4 locks held by pm-suspend/4672:
[  562.689722]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8032d54d>] sysfs_write_file+0x3d/0x11e
[  562.689729]  #1:  (pm_mutex){+.+.+.}, at: [<ffffffff8027b50d>] enter_state+0x1c5/0x1ce
[  562.689736]  #2:  (dpm_list_mtx){+.+.+.}, at: [<ffffffff803f55f9>] device_pm_lock+0x17/0x19
[  562.689742]  #3:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff80247685>] disable_nonboot_cpus+0x38/0x125
[  562.689749] 
[  562.689750] stack backtrace:
[  562.689753] Pid: 4672, comm: pm-suspend Not tainted 2.6.30-rc5-next-20090515-00004-g346c29d-dirty #106
[  562.689757] Call Trace:
[  562.689762]  [<ffffffff8026d297>] print_circular_bug_tail+0xc1/0xcc
[  562.689767]  [<ffffffff8026e81d>] __lock_acquire+0x10de/0x171c
[  562.689772]  [<ffffffff8026add2>] ? lock_release_holdtime+0x7d/0x100
[  562.689776]  [<ffffffff8026acf6>] ? get_lock_stats+0x14/0x4c
[  562.689781]  [<ffffffff804aaca2>] ? __mutex_unlock_slowpath+0x121/0x14d
[  562.689786]  [<ffffffff8026ca24>] ? trace_hardirqs_on_caller+0x12d/0x158
[  562.689791]  [<ffffffff8026ef5f>] lock_acquire+0x104/0x130
[  562.689795]  [<ffffffff80258523>] ? cleanup_workqueue_thread+0x23/0xf1
[  562.689800]  [<ffffffff8025854a>] cleanup_workqueue_thread+0x4a/0xf1
[  562.689804]  [<ffffffff80258523>] ? cleanup_workqueue_thread+0x23/0xf1
[  562.689809]  [<ffffffff8049b999>] workqueue_cpu_callback+0xc7/0x10a
[  562.689813]  [<ffffffff802606ff>] notifier_call_chain+0x33/0x5b
[  562.689818]  [<ffffffff802607ab>] raw_notifier_call_chain+0x14/0x16
[  562.689822]  [<ffffffff80499bca>] _cpu_down+0x280/0x29d
[  562.689827]  [<ffffffff802476ca>] disable_nonboot_cpus+0x7d/0x125
[  562.689832]  [<ffffffff8027b235>] suspend_devices_and_enter+0xdb/0x1c0
[  562.689836]  [<ffffffff8027b4b0>] enter_state+0x168/0x1ce
[  562.689841]  [<ffffffff8027b5d2>] state_store+0xbc/0xdd
[  562.689845]  [<ffffffff803696ef>] kobj_attr_store+0x17/0x19
[  562.689849]  [<ffffffff8032d5f9>] sysfs_write_file+0xe9/0x11e
[  562.689854]  [<ffffffff802db580>] vfs_write+0xb3/0x13c
[  562.689859]  [<ffffffff802db6d7>] sys_write+0x4c/0x73
[  562.689863]  [<ffffffff8020b202>] system_call_fastpath+0x16/0x1b



-- 
Lei Ming
