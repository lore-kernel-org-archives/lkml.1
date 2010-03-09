Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0CIIfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:35:41 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58717 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab0CIIfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:35:38 -0500
Date: Tue, 9 Mar 2010 09:35:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/3] lockdep: Move lock events under lockdep recursion
	protection
Message-ID: <20100309083536.GE5768@kernel.dk>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com> <1267599302-2886-2-git-send-regression-fweisbec@gmail.com> <20100309083410.GD5768@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309083410.GD5768@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09 2010, Jens Axboe wrote:
> On Wed, Mar 03 2010, Frederic Weisbecker wrote:
> > There are rcu locked read side areas in the path where we submit
> > a trace event. And these rcu_read_(un)lock() trigger lock events,
> > which create recursive events.
> > 
> > One pair in do_perf_sw_event:
> > 
> > __lock_acquire
> >       |
> >       |--96.11%-- lock_acquire
> >       |          |
> >       |          |--27.21%-- do_perf_sw_event
> >       |          |          perf_tp_event
> >       |          |          |
> >       |          |          |--49.62%-- ftrace_profile_lock_release
> >       |          |          |          lock_release
> >       |          |          |          |
> >       |          |          |          |--33.85%-- _raw_spin_unlock
> > 
> > Another pair in perf_output_begin/end:
> > 
> > __lock_acquire
> >       |--23.40%-- perf_output_begin
> >       |          |          __perf_event_overflow
> >       |          |          perf_swevent_overflow
> >       |          |          perf_swevent_add
> >       |          |          perf_swevent_ctx_event
> >       |          |          do_perf_sw_event
> >       |          |          perf_tp_event
> >       |          |          |
> >       |          |          |--55.37%-- ftrace_profile_lock_acquire
> >       |          |          |          lock_acquire
> >       |          |          |          |
> >       |          |          |          |--37.31%-- _raw_spin_lock
> > 
> > The problem is not that much the trace recursion itself, as we have a
> > recursion protection already (though it's always wasteful to recurse).
> > But the trace events are outside the lockdep recursion protection, then
> > each lockdep event triggers a lock trace, which will trigger two
> > other lockdep events. Here the recursive lock trace event won't
> > be taken because of the trace recursion, so the recursion stops there
> > but lockdep will still analyse these new events:
> > 
> > To sum up, for each lockdep events we have:
> > 
> > 	lock_*()
> > 	     |
> >              trace lock_acquire
> >                   |
> >                   ----- rcu_read_lock()
> >                   |          |
> >                   |          lock_acquire()
> >                   |          |
> >                   |          trace_lock_acquire() (stopped)
> >                   |          |
> > 		  |          lockdep analyze
> >                   |
> >                   ----- rcu_read_unlock()
> >                              |
> >                              lock_release
> >                              |
> >                              trace_lock_release() (stopped)
> >                              |
> >                              lockdep analyze
> > 
> > And you can repeat the above two times as we have two rcu read side
> > sections when we submit an event.
> > 
> > This is fixed in this patch by moving the lock trace event under
> > the lockdep recursion protection.
> 
> I went to try this on 2.6.34-rc1 to see how much it would improve things
> here. With 2.6.34-rc1, a

Which, btw, throws a new lockdep warning fest:

[   42.247718] scsi7 : ioc0: LSISAS1068E B3, FwRev=011b0300h, Ports=1, MaxQ=483, IRQ=26
[   42.281125] BUG: key ffff880c7cb75250 not in .data!
[   42.288346] ------------[ cut here ]------------
[   42.294490] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x545/0x5f0()
[   42.304013] Hardware name: QSSC-S4R
[   42.309674] Modules linked in: hid_apple usbhid ehci_hcd uhci_hcd usbcore nls_base mptsas(+) mptscsih mptbase scsi_transport_sas igb sg sr_mod cdrom
[   42.332072] Pid: 5197, comm: modprobe Not tainted 2.6.34-rc1 #176
[   42.340597] Call Trace:
[   42.345335]  [<ffffffff8107fb8d>] ? is_module_address+0x2d/0x60
[   42.353670]  [<ffffffff81074aa5>] ? lockdep_init_map+0x545/0x5f0
[   42.362154]  [<ffffffff81044648>] warn_slowpath_common+0x78/0xd0
[   42.371913]  [<ffffffff810446af>] warn_slowpath_null+0xf/0x20
[   42.380109]  [<ffffffff81074aa5>] lockdep_init_map+0x545/0x5f0
[   42.388402]  [<ffffffff81156636>] ? sysfs_new_dirent+0x76/0x120
[   42.396748]  [<ffffffff81155b6c>] sysfs_add_file_mode+0x6c/0xd0
[   42.405170]  [<ffffffff812dd260>] ? transport_add_class_device+0x0/0x50
[   42.414406]  [<ffffffff81155bdc>] sysfs_add_file+0xc/0x10
[   42.422183]  [<ffffffff81155ca1>] sysfs_create_file+0x21/0x40
[   42.430328]  [<ffffffff812d6574>] device_create_file+0x14/0x20
[   42.438584]  [<ffffffff812dcace>] attribute_container_add_attrs+0x8e/0xb0
[   42.447952]  [<ffffffff812dcb0d>] attribute_container_add_class_device+0x1d/0x30
[   42.457968]  [<ffffffff812dd27f>] transport_add_class_device+0x1f/0x50
[   42.467108]  [<ffffffff812dcc4f>] attribute_container_device_trigger+0x9f/0xe0
[   42.476978]  [<ffffffff812dd1e0>] transport_add_device+0x10/0x20
[   42.485415]  [<ffffffffa0049208>] sas_phy_add+0x28/0x40 [scsi_transport_sas]
[   42.495039]  [<ffffffffa0079e58>] mptsas_probe_one_phy+0x5f8/0x850 [mptsas]
[   42.504680]  [<ffffffff813fb469>] ? mutex_unlock+0x9/0x10
[   42.512429]  [<ffffffffa0079459>] ? mptsas_setup_wide_ports+0x269/0x380 [mptsas]
[   42.522481]  [<ffffffffa007a65d>] mptsas_probe_hba_phys+0x5ad/0xa10 [mptsas]
[   42.532154]  [<ffffffff8107401e>] ? lock_release_holdtime+0xfe/0x1f0
[   42.541071]  [<ffffffffa007af6d>] mptsas_scan_sas_topology+0x1d/0x340 [mptsas]
[   42.550920]  [<ffffffff812dd1c0>] ? transport_configure_device+0x10/0x20
[   42.560106]  [<ffffffff812ecd78>] ? scsi_sysfs_add_host+0x98/0xb0
[   42.568590]  [<ffffffffa007b693>] mptsas_probe+0x403/0x4b0 [mptsas]
[   42.577215]  [<ffffffff8123f2b2>] local_pci_probe+0x12/0x20
[   42.585257]  [<ffffffff8123f611>] pci_device_probe+0x111/0x120
[   42.593590]  [<ffffffff812d936b>] ? driver_sysfs_add+0x6b/0x90
[   42.601814]  [<ffffffff812d94a5>] driver_probe_device+0x95/0x1a0
[   42.610212]  [<ffffffff812d9643>] __driver_attach+0x93/0xa0
[   42.618261]  [<ffffffff812d95b0>] ? __driver_attach+0x0/0xa0
[   42.626320]  [<ffffffff812d8b5b>] bus_for_each_dev+0x6b/0xa0
[   42.634509]  [<ffffffff812d92fc>] driver_attach+0x1c/0x20
[   42.642204]  [<ffffffff812d8315>] bus_add_driver+0x1d5/0x320
[   42.650234]  [<ffffffffa0015000>] ? mptsas_init+0x0/0x114 [mptsas]
[   42.658889]  [<ffffffff812d994c>] driver_register+0x7c/0x170
[   42.667004]  [<ffffffffa0015000>] ? mptsas_init+0x0/0x114 [mptsas]
[   42.675673]  [<ffffffff8123f8ba>] __pci_register_driver+0x6a/0xf0
[   42.684215]  [<ffffffffa0015000>] ? mptsas_init+0x0/0x114 [mptsas]
[   42.692814]  [<ffffffffa00150f9>] mptsas_init+0xf9/0x114 [mptsas]
[   42.701336]  [<ffffffff810001d8>] do_one_initcall+0x38/0x190
[   42.709375]  [<ffffffff81083fe3>] sys_init_module+0xe3/0x260
[   42.717447]  [<ffffffff81002e2b>] system_call_fastpath+0x16/0x1b
[   42.726261] ---[ end trace 52cf32179b76155b ]---
[   42.731555] BUG: key ffff880c7cb75288 not in .data!
[   42.737130] BUG: key ffff880c7cb752c0 not in .data!
[   42.742817] BUG: key ffff880c7cb752f8 not in .data!
[   42.748476] BUG: key ffff880c7cb75330 not in .data!
[   42.754039] BUG: key ffff880c7cb75368 not in .data!
[   42.759634] BUG: key ffff880c7cb753a0 not in .data!
[   42.765192] BUG: key ffff880c7cb753d8 not in .data!
[   42.770833] BUG: key ffff880c7cb75410 not in .data!
[   42.776394] BUG: key ffff880c7cb75448 not in .data!
[   42.781967] BUG: key ffff880c7cb75480 not in .data!
[   42.787480] BUG: key ffff880c7cb754b8 not in .data!
[   42.793026] BUG: key ffff880c7cb754f0 not in .data!
[   42.798689] BUG: key ffff880c7cb75528 not in .data!
[   42.804235] BUG: key ffff880c7cb75560 not in .data!
[   42.809828] BUG: key ffff880c7cb75598 not in .data!
[   42.815401] BUG: key ffff880c7cb755d0 not in .data!
[   42.821078] BUG: key ffff880c7cb75250 not in .data!
[   42.826714] BUG: key ffff880c7cb75288 not in .data!
[   42.832401] BUG: key ffff880c7cb752c0 not in .data!
[   42.838064] BUG: key ffff880c7cb752f8 not in .data!
[   42.843619] BUG: key ffff880c7cb75330 not in .data!
[   42.849324] BUG: key ffff880c7cb75368 not in .data!
[   42.854900] BUG: key ffff880c7cb753a0 not in .data!
[   42.860519] BUG: key ffff880c7cb753d8 not in .data!
[   42.866135] BUG: key ffff880c7cb75410 not in .data!
[   42.871746] BUG: key ffff880c7cb75448 not in .data!
[   42.877257] BUG: key ffff880c7cb75480 not in .data!
[   42.882831] BUG: key ffff880c7cb754b8 not in .data!
[   42.888425] BUG: key ffff880c7cb754f0 not in .data!
[   42.893990] BUG: key ffff880c7cb75528 not in .data!
[   42.899668] BUG: key ffff880c7cb75560 not in .data!
[   42.905220] BUG: key ffff880c7cb75598 not in .data!
[   42.910881] BUG: key ffff880c7cb755d0 not in .data!
[   42.916753] BUG: key ffff880c7cb75250 not in .data!
[   42.922374] BUG: key ffff880c7cb75288 not in .data!
[   42.928045] BUG: key ffff880c7cb752c0 not in .data!
[   42.933596] BUG: key ffff880c7cb752f8 not in .data!
[   42.939245] BUG: key ffff880c7cb75330 not in .data!
[   42.944820] BUG: key ffff880c7cb75368 not in .data!
[   42.950467] BUG: key ffff880c7cb753a0 not in .data!
[   42.956052] BUG: key ffff880c7cb753d8 not in .data!
[   42.961694] BUG: key ffff880c7cb75410 not in .data!
[   42.967206] BUG: key ffff880c7cb75448 not in .data!
[   42.972741] BUG: key ffff880c7cb75480 not in .data!
[   42.978397] BUG: key ffff880c7cb754b8 not in .data!
[   42.983965] BUG: key ffff880c7cb754f0 not in .data!
[   42.989570] BUG: key ffff880c7cb75528 not in .data!
[   42.995116] BUG: key ffff880c7cb75560 not in .data!
[   43.000777] BUG: key ffff880c7cb75598 not in .data!
[   43.006418] BUG: key ffff880c7cb755d0 not in .data!
[   43.012110] BUG: key ffff880c7cb75250 not in .data!
[   43.017697] BUG: key ffff880c7cb75288 not in .data!
[   43.023278] BUG: key ffff880c7cb752c0 not in .data!
[   43.028927] BUG: key ffff880c7cb752f8 not in .data!
[   43.034543] BUG: key ffff880c7cb75330 not in .data!
[   43.040158] BUG: key ffff880c7cb75368 not in .data!
[   43.045767] BUG: key ffff880c7cb753a0 not in .data!
[   43.051370] BUG: key ffff880c7cb753d8 not in .data!
[   43.056882] BUG: key ffff880c7cb75410 not in .data!
[   43.062395] BUG: key ffff880c7cb75448 not in .data!
[   43.068074] BUG: key ffff880c7cb75480 not in .data!
[   43.073629] BUG: key ffff880c7cb754b8 not in .data!
[   43.079261] BUG: key ffff880c7cb754f0 not in .data!
[   43.084775] BUG: key ffff880c7cb75528 not in .data!
[   43.090401] BUG: key ffff880c7cb75560 not in .data!
[   43.095914] BUG: key ffff880c7cb75598 not in .data!
[   43.101507] BUG: key ffff880c7cb755d0 not in .data!
[   43.107046] BUG: key ffff880c7cb75250 not in .data!
[   43.112684] BUG: key ffff880c7cb75288 not in .data!
[   43.118270] BUG: key ffff880c7cb752c0 not in .data!
[   43.123832] BUG: key ffff880c7cb752f8 not in .data!
[   43.129442] BUG: key ffff880c7cb75330 not in .data!
[   43.134967] BUG: key ffff880c7cb75368 not in .data!
[   43.140574] BUG: key ffff880c7cb753a0 not in .data!
[   43.146190] BUG: key ffff880c7cb753d8 not in .data!
[   43.151806] BUG: key ffff880c7cb75410 not in .data!
[   43.157403] BUG: key ffff880c7cb75448 not in .data!
[   43.162976] BUG: key ffff880c7cb75480 not in .data!
[   43.168570] BUG: key ffff880c7cb754b8 not in .data!
[   43.174200] BUG: key ffff880c7cb754f0 not in .data!
[   43.179791] BUG: key ffff880c7cb75528 not in .data!
[   43.185350] BUG: key ffff880c7cb75560 not in .data!
[   43.190907] BUG: key ffff880c7cb75598 not in .data!
[   43.196421] BUG: key ffff880c7cb755d0 not in .data!
[   43.202012] BUG: key ffff880c7cb75250 not in .data!
[   43.207579] BUG: key ffff880c7cb75288 not in .data!
[   43.213112] BUG: key ffff880c7cb752c0 not in .data!
[   43.218880] BUG: key ffff880c7cb752f8 not in .data!
[   43.224416] BUG: key ffff880c7cb75330 not in .data!
[   43.230075] BUG: key ffff880c7cb75368 not in .data!
[   43.235699] BUG: key ffff880c7cb753a0 not in .data!
[   43.241477] BUG: key ffff880c7cb753d8 not in .data!
[   43.247058] BUG: key ffff880c7cb75410 not in .data!
[   43.252559] BUG: key ffff880c7cb75448 not in .data!
[   43.258273] BUG: key ffff880c7cb75480 not in .data!
[   43.263775] BUG: key ffff880c7cb754b8 not in .data!
[   43.269451] BUG: key ffff880c7cb754f0 not in .data!
[   43.275018] BUG: key ffff880c7cb75528 not in .data!
[   43.280674] BUG: key ffff880c7cb75560 not in .data!
[   43.286185] BUG: key ffff880c7cb75598 not in .data!
[   43.291700] BUG: key ffff880c7cb755d0 not in .data!
[   43.297239] BUG: key ffff880c7cb75250 not in .data!
[   43.302749] BUG: key ffff880c7cb75288 not in .data!
[   43.308351] BUG: key ffff880c7cb752c0 not in .data!
[   43.313968] BUG: key ffff880c7cb752f8 not in .data!
[   43.319584] BUG: key ffff880c7cb75330 not in .data!
[   43.325202] BUG: key ffff880c7cb75368 not in .data!
[   43.330813] BUG: key ffff880c7cb753a0 not in .data!
[   43.336326] BUG: key ffff880c7cb753d8 not in .data!
[   43.341900] BUG: key ffff880c7cb75410 not in .data!
[   43.347480] BUG: key ffff880c7cb75448 not in .data!
[   43.353050] BUG: key ffff880c7cb75480 not in .data!
[   43.358664] BUG: key ffff880c7cb754b8 not in .data!
[   43.364187] BUG: key ffff880c7cb754f0 not in .data!
[   43.369865] BUG: key ffff880c7cb75528 not in .data!
[   43.375417] BUG: key ffff880c7cb75560 not in .data!
[   43.381026] BUG: key ffff880c7cb75598 not in .data!
[   43.386632] BUG: key ffff880c7cb755d0 not in .data!
[   43.392189] BUG: key ffff880c7cb75250 not in .data!
[   43.397785] BUG: key ffff880c7cb75288 not in .data!
[   43.403343] BUG: key ffff880c7cb752c0 not in .data!
[   43.408862] BUG: key ffff880c7cb752f8 not in .data!
[   43.414405] BUG: key ffff880c7cb75330 not in .data!
[   43.420069] BUG: key ffff880c7cb75368 not in .data!
[   43.425720] BUG: key ffff880c7cb753a0 not in .data!
[   43.431331] BUG: key ffff880c7cb753d8 not in .data!
[   43.436970] BUG: key ffff880c7cb75410 not in .data!
[   43.442554] BUG: key ffff880c7cb75448 not in .data!
[   43.448209] BUG: key ffff880c7cb75480 not in .data!
[   43.453786] BUG: key ffff880c7cb754b8 not in .data!
[   43.459429] BUG: key ffff880c7cb754f0 not in .data!
[   43.465011] BUG: key ffff880c7cb75528 not in .data!
[   43.470654] BUG: key ffff880c7cb75560 not in .data!
[   43.476168] BUG: key ffff880c7cb75598 not in .data!
[   43.483110] BUG: key ffff880c7cb755d0 not in .data!


-- 
Jens Axboe

