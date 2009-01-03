Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbZACQnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbZACQnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759044AbZACQnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:43:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40346 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZACQnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:43:15 -0500
Date: Sat, 3 Jan 2009 17:42:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
Message-ID: <20090103164255.GA20657@elte.hu>
References: <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <495F7D27.8020104@sgi.com> <20090103150634.GA28693@elte.hu> <495F84D8.1070404@sgi.com> <20090103154733.GA8111@elte.hu> <20090103160017.GA8920@elte.hu> <495F8DCA.1060905@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495F8DCA.1060905@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >> i suspect it's:
> >>
> >> | commit 2d22bd5e74519854458ad372a89006e65f45e628
> >> | Author: Mike Travis <travis@sgi.com>
> >> | Date:   Wed Dec 31 18:08:46 2008 -0800
> >> |
> >> |     x86: cleanup remaining cpumask_t code in microcode_core.c
> >>
> >> as the microcode is loaded during CPU onlining.
> > 
> > yep, that's the bad one. Should i revert it or do you have a safe fix in 
> > mind?
> > 
> > 	Ingo
> 
> Probably revert for now.  There are a few more following patches that 
> also use 'work_on_cpu' so a better (more global?) fix should be used.
> 
> Any thought on using a recursive lock for cpu-hotplug-lock?  (At least 
> for get_online_cpus()?)

but the problem has nothing to do with self-recursion. Take a look at the 
lockdep warning i posted (also below) - the locks are simply taken in the 
wrong order.

your change adds this cpu_hotplug.lock usage:

[   43.652000] -> #1 (&cpu_hotplug.lock){--..}:
[   43.652000]        [<ffffffff8027a7c0>] __lock_acquire+0xf10/0x1360
[   43.652000]        [<ffffffff8027aca9>] lock_acquire+0x99/0xd0
[   43.652000]        [<ffffffff809b5e4a>] __mutex_lock_common+0xaa/0x450
[   43.652000]        [<ffffffff809b62cf>] mutex_lock_nested+0x3f/0x50
[   43.652000]        [<ffffffff802516ba>] get_online_cpus+0x3a/0x50
[   43.652000]        [<ffffffff802648dc>] work_on_cpu+0x6c/0xc0
[   43.652000]        [<ffffffff8022b2a2>] mc_sysdev_add+0x92/0xa0
[   43.652000]        [<ffffffff8050a800>] sysdev_driver_register+0xb0/0x140
[   43.652000]        [<ffffffff8163c792>] microcode_init+0xb2/0x13b
[   43.652000]        [<ffffffff8020a041>] do_one_initcall+0x41/0x180
[   43.652000]        [<ffffffff8162e6cb>] kernel_init+0x145/0x19d
[   43.652000]        [<ffffffff802146aa>] child_rip+0xa/0x20
[   43.652000]        [<ffffffffffffffff>] 0xffffffffffffffff

which nests the inside sysdev_drivers_lock - which is wrong 
[sysdev_drivers_lock is a pretty lowlevel lock that generally nests inside 
the CPU hotplug lock].

If you want to use work_on_cpu() it should be done on a higher level, so 
that sysdev_drivers_lock is taken after the hotplug lock.

	Ingo

[   43.376051] lockdep: fixing up alternatives.
[   43.380007] SMP alternatives: switching to UP code
[   43.616014] CPU0 attaching NULL sched-domain.
[   43.620068] CPU1 attaching NULL sched-domain.
[   43.644482] CPU0 attaching NULL sched-domain.
[   43.648264] 
[   43.648265] =======================================================
[   43.652000] [ INFO: possible circular locking dependency detected ]
[   43.652000] 2.6.28-05081-geeff031-dirty #37
[   43.652000] -------------------------------------------------------
[   43.652000] S99local/1238 is trying to acquire lock:
[   43.652000]  (sysdev_drivers_lock){--..}, at: [<ffffffff8050a52d>] sysdev_unregister+0x1d/0x80
[   43.652000] 
[   43.652000] but task is already holding lock:
[   43.652000]  (&cpu_hotplug.lock){--..}, at: [<ffffffff802515d7>] cpu_hotplug_begin+0x27/0x60
[   43.652000] 
[   43.652000] which lock already depends on the new lock.
[   43.652000] 
[   43.652000] 
[   43.652000] the existing dependency chain (in reverse order) is:
[   43.652000] 
[   43.652000] -> #1 (&cpu_hotplug.lock){--..}:
[   43.652000]        [<ffffffff8027a7c0>] __lock_acquire+0xf10/0x1360
[   43.652000]        [<ffffffff8027aca9>] lock_acquire+0x99/0xd0
[   43.652000]        [<ffffffff809b5e4a>] __mutex_lock_common+0xaa/0x450
[   43.652000]        [<ffffffff809b62cf>] mutex_lock_nested+0x3f/0x50
[   43.652000]        [<ffffffff802516ba>] get_online_cpus+0x3a/0x50
[   43.652000]        [<ffffffff802648dc>] work_on_cpu+0x6c/0xc0
[   43.652000]        [<ffffffff8022b2a2>] mc_sysdev_add+0x92/0xa0
[   43.652000]        [<ffffffff8050a800>] sysdev_driver_register+0xb0/0x140
[   43.652000]        [<ffffffff8163c792>] microcode_init+0xb2/0x13b
[   43.652000]        [<ffffffff8020a041>] do_one_initcall+0x41/0x180
[   43.652000]        [<ffffffff8162e6cb>] kernel_init+0x145/0x19d
[   43.652000]        [<ffffffff802146aa>] child_rip+0xa/0x20
[   43.652000]        [<ffffffffffffffff>] 0xffffffffffffffff
[   43.652000] 
[   43.652000] -> #0 (sysdev_drivers_lock){--..}:
[   43.652000]        [<ffffffff8027a89c>] __lock_acquire+0xfec/0x1360
[   43.652000]        [<ffffffff8027aca9>] lock_acquire+0x99/0xd0
[   43.652000]        [<ffffffff809b5e4a>] __mutex_lock_common+0xaa/0x450
[   43.652000]        [<ffffffff809b62cf>] mutex_lock_nested+0x3f/0x50
[   43.652000]        [<ffffffff8050a52d>] sysdev_unregister+0x1d/0x80
[   43.652000]        [<ffffffff809af9d1>] mce_cpu_callback+0xce/0x101
[   43.652000]        [<ffffffff809bbb75>] notifier_call_chain+0x65/0xa0
[   43.652000]        [<ffffffff8026d696>] raw_notifier_call_chain+0x16/0x20
[   43.652000]        [<ffffffff80964a00>] _cpu_down+0x240/0x350
[   43.652000]        [<ffffffff80964b8b>] cpu_down+0x7b/0xa0
[   43.652000]        [<ffffffff80966268>] store_online+0x48/0xa0
[   43.652000]        [<ffffffff80509e90>] sysdev_store+0x20/0x30
[   43.652000]        [<ffffffff80335ddf>] sysfs_write_file+0xcf/0x140
[   43.652000]        [<ffffffff802dc1f7>] vfs_write+0xc7/0x150
[   43.652000]        [<ffffffff802dc375>] sys_write+0x55/0x90
[   43.652000]        [<ffffffff802133ca>] system_call_fastpath+0x16/0x1b
[   43.652000]        [<ffffffffffffffff>] 0xffffffffffffffff
[   43.652000] 
[   43.652000] other info that might help us debug this:
[   43.652000] 
[   43.652000] 3 locks held by S99local/1238:
[   43.652000]  #0:  (&buffer->mutex){--..}, at: [<ffffffff80335d58>] sysfs_write_file+0x48/0x140
[   43.652000]  #1:  (cpu_add_remove_lock){--..}, at: [<ffffffff80964b3f>] cpu_down+0x2f/0xa0
[   43.652000]  #2:  (&cpu_hotplug.lock){--..}, at: [<ffffffff802515d7>] cpu_hotplug_begin+0x27/0x60
[   43.652000] 
[   43.652000] stack backtrace:
[   43.652000] Pid: 1238, comm: S99local Not tainted 2.6.28-05081-geeff031-dirty #37
[   43.652000] Call Trace:
[   43.652000]  [<ffffffff80277f24>] print_circular_bug_tail+0xa4/0x100
[   43.652000]  [<ffffffff8027a89c>] __lock_acquire+0xfec/0x1360
[   43.652000]  [<ffffffff8027aca9>] lock_acquire+0x99/0xd0
[   43.652000]  [<ffffffff8050a52d>] ? sysdev_unregister+0x1d/0x80
[   43.652000]  [<ffffffff809b5e4a>] __mutex_lock_common+0xaa/0x450
[   43.652000]  [<ffffffff8050a52d>] ? sysdev_unregister+0x1d/0x80
[   43.652000]  [<ffffffff8050a52d>] ? sysdev_unregister+0x1d/0x80
[   43.652000]  [<ffffffff809b62cf>] mutex_lock_nested+0x3f/0x50
[   43.652000]  [<ffffffff8050a52d>] sysdev_unregister+0x1d/0x80
[   43.652000]  [<ffffffff809af9d1>] mce_cpu_callback+0xce/0x101
[   43.652000]  [<ffffffff809bbb75>] notifier_call_chain+0x65/0xa0
[   43.652000]  [<ffffffff8026d696>] raw_notifier_call_chain+0x16/0x20
[   43.652000]  [<ffffffff80964a00>] _cpu_down+0x240/0x350
[   43.652000]  [<ffffffff809b4763>] ? wait_for_common+0xe3/0x1b0
[   43.652000]  [<ffffffff80964b8b>] cpu_down+0x7b/0xa0
[   43.652000]  [<ffffffff80966268>] store_online+0x48/0xa0
[   43.652000]  [<ffffffff80509e90>] sysdev_store+0x20/0x30
[   43.652000]  [<ffffffff80335ddf>] sysfs_write_file+0xcf/0x140
[   43.652000]  [<ffffffff802dc1f7>] vfs_write+0xc7/0x150
[   43.652000]  [<ffffffff802dc375>] sys_write+0x55/0x90
[   43.652000]  [<ffffffff802133ca>] system_call_fastpath+0x16/0x1b
[   43.652104] device: 'msr1': device_unregister
[   43.656005] PM: Removing info for No Bus:msr1
