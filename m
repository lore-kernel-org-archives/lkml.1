Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZAKO4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZAKO4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZAKO41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:56:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46982 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZAKO40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:56:26 -0500
Date: Sun, 11 Jan 2009 15:56:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>, andeas.herrmann3@amd.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Mohr <andi@lisas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [patch] Re: [Bug #12100] resume (S2R) broken by Intel
	microcode module, on A110L
Message-ID: <20090111145615.GA26173@elte.hu>
References: <1229728524.5122.13.camel@earth> <20081219233006.GA17984@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219233006.GA17984@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> 
> > Hi,
> > 
> > 
> > This is in response to the following bug report:
> > 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12100
> > Subject         : resume (S2R) broken by Intel microcode module, on A110L
> > Submitter       : Andreas Mohr <andi@lisas.de>
> > Date            : 2008-11-25 08:48 (19 days old)
> > Handled-By      : Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> applied to tip/x86/microcode, thanks Dmitry!
> 
> The fix looks right but somewhat intrusive in scope, so i'm a bit 
> reluctant to push it towards .28 straight away - without having feedback 
> in the bugzilla. If feedback is positive (the bug reported there goes 
> away completely) we can cherry-pick it over into x86/urgent, ok? And in 
> any case i've marked it as a -stable backport for .28.1.

hm, -tip testing just found this microcode locking lockdep splat:

[   48.004158] SMP alternatives: switching to UP code
[   48.342853] CPU0 attaching NULL sched-domain.
[   48.344288] CPU1 attaching NULL sched-domain.
[   48.354696] CPU0 attaching NULL sched-domain.
[   48.361215] device: 'cpu1': device_unregister
[   48.364231] device: 'cpu1': device_create_release
[   48.368138] 
[   48.368139] =======================================================
[   48.372039] [ INFO: possible circular locking dependency detected ]
[   48.372039] 2.6.29-rc1-tip-00901-g9699183-dirty #15577
[   48.372039] -------------------------------------------------------
[   48.372039] S99local/3496 is trying to acquire lock:
[   48.372039]  (microcode_mutex){--..}, at: [<c0118489>] microcode_fini_cpu+0x17/0x2b
[   48.372039] 
[   48.372039] but task is already holding lock:
[   48.372039]  (&cpu_hotplug.lock){--..}, at: [<c012f508>] cpu_hotplug_begin+0x1f/0x47
[   48.372039] 
[   48.372039] which lock already depends on the new lock.
[   48.372039] 
[   48.372039] 
[   48.372039] the existing dependency chain (in reverse order) is:
[   48.372039] 
[   48.372039] -> #1 (&cpu_hotplug.lock){--..}:
[   48.372039]        [<c014d3f1>] validate_chain+0x8e9/0xb94
[   48.372039]        [<c014dd03>] __lock_acquire+0x667/0x6e1
[   48.372039]        [<c014ddda>] lock_acquire+0x5d/0x7a
[   48.372039]        [<c0a6fac3>] mutex_lock_nested+0xdc/0x170
[   48.372039]        [<c012f552>] get_online_cpus+0x22/0x34
[   48.372039]        [<c013ce08>] work_on_cpu+0x50/0x8a
[   48.372039]        [<c0118465>] microcode_init_cpu+0x25/0x32
[   48.372039]        [<c0118699>] mc_sysdev_add+0x91/0x9b
[   48.372039]        [<c04cbd09>] sysdev_driver_register+0x9b/0xea
[   48.372039]        [<c0fb68e0>] microcode_init+0x8a/0xe4
[   48.372039]        [<c010106a>] do_one_initcall+0x6a/0x16e
[   48.372039]        [<c0fa952d>] kernel_init+0x115/0x166
[   48.372039]        [<c0103737>] kernel_thread_helper+0x7/0x10
[   48.372039]        [<ffffffff>] 0xffffffff
[   48.372039] 
[   48.372039] -> #0 (microcode_mutex){--..}:
[   48.372039]        [<c014d0fc>] validate_chain+0x5f4/0xb94
[   48.372039]        [<c014dd03>] __lock_acquire+0x667/0x6e1
[   48.372039]        [<c014ddda>] lock_acquire+0x5d/0x7a
[   48.372039]        [<c0a6fac3>] mutex_lock_nested+0xdc/0x170
[   48.372039]        [<c0118489>] microcode_fini_cpu+0x17/0x2b
[   48.372039]        [<c0a6ce38>] mc_cpu_callback+0xed/0xfa
[   48.372039]        [<c0142a48>] notifier_call_chain+0x2b/0x4a
[   48.372039]        [<c0142a98>] __raw_notifier_call_chain+0x13/0x15
[   48.372039]        [<c0142aab>] raw_notifier_call_chain+0x11/0x13
[   48.372039]        [<c0a2925e>] _cpu_down+0x171/0x22a
[   48.372039]        [<c0a2935a>] cpu_down+0x43/0x68
[   48.372039]        [<c0a2a27f>] store_online+0x2a/0x5e
[   48.372039]        [<c04cba85>] sysdev_store+0x20/0x28
[   48.372039]        [<c01d07d0>] sysfs_write_file+0xbd/0xe8
[   48.372039]        [<c01912c2>] vfs_write+0x91/0x138
[   48.372039]        [<c01917c8>] sys_write+0x40/0x65
[   48.372039]        [<c0102e55>] sysenter_do_call+0x12/0x35
[   48.372039]        [<ffffffff>] 0xffffffff
[   48.372039] 
[   48.372039] other info that might help us debug this:
[   48.372039] 
[   48.372039] 3 locks held by S99local/3496:
[   48.372039]  #0:  (&buffer->mutex){--..}, at: [<c01d073d>] sysfs_write_file+0x2a/0xe8
[   48.372039]  #1:  (cpu_add_remove_lock){--..}, at: [<c012f4b5>] cpu_maps_update_begin+0x14/0x16
[   48.372039]  #2:  (&cpu_hotplug.lock){--..}, at: [<c012f508>] cpu_hotplug_begin+0x1f/0x47
[   48.372039] 
[   48.372039] stack backtrace:
[   48.372039] Pid: 3496, comm: S99local Not tainted 2.6.29-rc1-tip-00901-g9699183-dirty #15577
[   48.372039] Call Trace:
[   48.372039]  [<c014cafd>] print_circular_bug_tail+0xab/0xb6
[   48.372039]  [<c014d0fc>] validate_chain+0x5f4/0xb94
[   48.372039]  [<c0a710b4>] ? _spin_unlock_irqrestore+0x34/0x41
[   48.372039]  [<c014dd03>] __lock_acquire+0x667/0x6e1
[   48.372039]  [<c014c508>] ? trace_hardirqs_on_caller+0x120/0x15f
[   48.372039]  [<c014ddda>] lock_acquire+0x5d/0x7a
[   48.372039]  [<c0118489>] ? microcode_fini_cpu+0x17/0x2b
[   48.372039]  [<c0a6fac3>] mutex_lock_nested+0xdc/0x170
[   48.372039]  [<c0118489>] ? microcode_fini_cpu+0x17/0x2b
[   48.372039]  [<c0118489>] ? microcode_fini_cpu+0x17/0x2b
[   48.372039]  [<c0118489>] microcode_fini_cpu+0x17/0x2b
[   48.372039]  [<c0a6ce38>] mc_cpu_callback+0xed/0xfa
[   48.372039]  [<c0142a48>] notifier_call_chain+0x2b/0x4a
[   48.372039]  [<c0142a98>] __raw_notifier_call_chain+0x13/0x15
[   48.372039]  [<c0142aab>] raw_notifier_call_chain+0x11/0x13
[   48.372039]  [<c0a2925e>] _cpu_down+0x171/0x22a
[   48.372039]  [<c0a2935a>] cpu_down+0x43/0x68
[   48.372039]  [<c0a2a27f>] store_online+0x2a/0x5e
[   48.372039]  [<c0a2a255>] ? store_online+0x0/0x5e
[   48.372039]  [<c04cba85>] sysdev_store+0x20/0x28
[   48.372039]  [<c01d07d0>] sysfs_write_file+0xbd/0xe8
[   48.372039]  [<c01d0713>] ? sysfs_write_file+0x0/0xe8
[   48.372039]  [<c01912c2>] vfs_write+0x91/0x138
[   48.372039]  [<c01917c8>] sys_write+0x40/0x65
[   48.372039]  [<c0102e55>] sysenter_do_call+0x12/0x35
[   49.380693] device: 'cpu1': device_add
[   49.384346] lockdep: fixing up alternatives.
[   49.388142] SMP alternatives: switching to SMP code

config/full bootlog on request. Andreas, Dmitry, any ideas?

	Ingo
