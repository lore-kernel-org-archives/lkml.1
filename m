Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbYKZGgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbYKZGgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 01:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbYKZGf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 01:35:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:10815 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYKZGf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 01:35:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,667,1220252400"; 
   d="scan'208";a="83029801"
Date: Wed, 26 Nov 2008 14:35:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Len Brown <len.brown@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2.6.28-rc6] ACPICA: don't cond_resched() when
	irqs_disabled()
Message-ID: <20081126063522.GA23611@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Linus: please consider this bug fix for 2.6.28-rc7]

The ACPI routines could be called from run_workqueue() with irqs disabled.
So we should test irqs_disabled() before calling cond_resched().

This fixes the following BUG:

[30490.707880] BUG: sleeping function called from invalid context at kernel/sched.c:5570
[30490.707910] BUG: unable to handle kernel paging request at 000000007bc14a88
[30490.707918] IP: [<ffffffff81505317>] kprobe_exceptions_notify+0x27/0x6d0
[30490.707934] PGD 7355c067 PUD 7352f067 PMD 0
[30490.707941] Oops: 0000 [#1] SMP
[30490.707946] last sysfs file: /sys/class/power_supply/C23B/charge_full
[30490.707952] Dumping ftrace buffer:
[30490.707957]    (ftrace buffer empty)
[30490.707960] CPU 1
[30490.707964] Modules linked in: ipv6 pata_pcmcia ide_cs usbhid hci_usb snd_hda_intel pcmcia snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc yenta_socket ohci1394 rsrc_nonstatic snd_hwdep pcspkr pcmcia_core iwlagn ieee1394 snd iwlcore rfkill led_class ehci_hcd soundcore uhci_hcd ide_pci_generic wmi
[30490.708007] Pid: 191, comm: kacpid Not tainted 2.6.28-rc5 #3
[30490.708011] RIP: 0010:[<ffffffff81505317>]  [<ffffffff81505317>] kprobe_exceptions_notify+0x27/0x6d0
[30490.708021] RSP: 0018:ffff88007bc19728  EFLAGS: 00010006
[30490.708026] RAX: ffffffff8174f190 RBX: 000000007bc14a00 RCX: ffff88007bc197f8
[30490.708030] RDX: ffff88007bc197f8 RSI: 000000000000000a RDI: ffffffff8174f190
[30490.708035] RBP: ffff88007bc19758 R08: 0000000000000000 R09: 0000000000000000
[30490.708039] R10: 00000000ffffffff R11: ffffffff816916fe R12: 00000000ffffffff
[30490.708043] R13: ffffffff8174fe20 R14: ffff88007bc197f8 R15: 000000000000000a
[30490.708049] FS:  0000000000000000(0000) GS:ffff88007c15d3d8(0000) knlGS:0000000000000000
[30490.708053] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[30490.708058] CR2: 000000007bc14a88 CR3: 0000000073513000 CR4: 00000000000006e0
[30490.708062] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[30490.708067] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[30490.708072] Process kacpid (pid: 191, threadinfo ffff88007bc18000, task ffff88007bc14a00)
[30490.708075] Stack:
[30490.708078]  0000000000000000 0000000000000000 00000000ffffffff ffffffff8174fe20
[30490.708085]  ffff88007bc197f8 000000000000000a ffff88007bc19798 ffffffff815069df
[30490.708093]  ffffffff8174f580 ffffffff8174cef8 0000000000000000 00000000ffffffff
[30490.708102] Call Trace:
[30490.708106]  [<ffffffff815069df>] notifier_call_chain+0x3f/0x80
[30490.708113]  [<ffffffff81506a89>] __atomic_notifier_call_chain+0x69/0xa0
[30490.708121]  [<ffffffff81506a20>] ? __atomic_notifier_call_chain+0x0/0xa0
[30490.708129]  [<ffffffff8107925d>] ? trace_hardirqs_off+0xd/0x10
[30490.708138]  [<ffffffff81502b08>] _spin_unlock_irqrestore+0x68/0x70
[30490.708146]  [<ffffffff810791b9>] ? trace_hardirqs_off_caller+0x29/0xc0
[30490.708153]  [<ffffffff8107925d>] ? trace_hardirqs_off+0xd/0x10
[30490.708160]  [<ffffffff81502b08>] ? _spin_unlock_irqrestore+0x68/0x70
[30490.708167]  [<ffffffff812decd4>] ? e1000_xmit_frame+0xb34/0xf10
[30490.708177]  [<ffffffff810e8c39>] ? cache_alloc_debugcheck_after+0x159/0x250
[30490.708185]  [<ffffffff8107925d>] ? trace_hardirqs_off+0xd/0x10
[30490.708192]  [<ffffffff813c66eb>] ? netpoll_send_skb+0x19b/0x210
[30490.708201]  [<ffffffff81204534>] ? delay_tsc+0x44/0x90
[30490.708210]  [<ffffffff812045f4>] ? __const_udelay+0x44/0x50
[30490.708218]  [<ffffffff812adc1c>] ? wait_for_xmitr+0x5c/0xd0
[30490.708227]  [<ffffffff812adcb0>] ? serial8250_console_putchar+0x20/0x40
[30490.708234]  [<ffffffff812adc90>] ? serial8250_console_putchar+0x0/0x40
[30490.708241]  [<ffffffff812a97d4>] ? uart_console_write+0x34/0x70
[30490.708249]  [<ffffffff812ae1b2>] ? serial8250_console_write+0xc2/0x1a0
[30490.708257]  [<ffffffff810518de>] ? __call_console_drivers+0x6e/0x90
[30490.708265]  [<ffffffff81051945>] ? _call_console_drivers+0x45/0x70
[30490.708272]  [<ffffffff81051e3b>] ? release_console_sem+0x18b/0x250
[30490.708279]  [<ffffffff8105253d>] ? vprintk+0x34d/0x460
[30490.708285]  [<ffffffff8107925d>] ? trace_hardirqs_off+0xd/0x10
[30490.708292]  [<ffffffff8107ae14>] ? debug_check_no_locks_freed+0xe4/0x170
[30490.708300]  [<ffffffff814fef71>] ? printk+0x67/0x6e
[30490.708306]  [<ffffffff810eaa38>] ? kmem_cache_free+0x1a8/0x210
[30490.708313]  [<ffffffff8107925d>] ? trace_hardirqs_off+0xd/0x10
[30490.708319]  [<ffffffff810eaa38>] ? kmem_cache_free+0x1a8/0x210
[30490.708326]  [<ffffffff8123b2d9>] ? acpi_os_release_object+0x9/0xd
[30490.708334]  [<ffffffff81048afb>] ? __might_sleep+0x9b/0x140
[30490.708343]  [<ffffffff8104db75>] ? __cond_resched+0x15/0x60
[30490.708349]  [<ffffffff814ffd15>] ? _cond_resched+0x35/0x50
[30490.708355]  [<ffffffff8124e15d>] ? acpi_ps_complete_op+0x235/0x24b
[30490.708365]  [<ffffffff8124e872>] ? acpi_ps_parse_loop+0x6ff/0x859
[30490.708372]  [<ffffffff8124da6f>] ? acpi_ps_parse_aml+0x7c/0x2bb
[30490.708380]  [<ffffffff8124efe9>] ? acpi_ps_execute_method+0x144/0x213
[30490.708386]  [<ffffffff8124b3ee>] ? acpi_ns_evaluate+0x152/0x230
[30490.708394]  [<ffffffff8123b595>] ? acpi_os_execute_deferred+0x0/0x39
[30490.708401]  [<ffffffff81242ab4>] ? acpi_ev_asynch_execute_gpe_method+0xc7/0x11f
[30490.708408]  [<ffffffff81064e8a>] ? run_workqueue+0xaa/0x240
[30490.708417]  [<ffffffff8123b5c1>] ? acpi_os_execute_deferred+0x2c/0x39
[30490.708424]  [<ffffffff8123b595>] ? acpi_os_execute_deferred+0x0/0x39
[30490.708431]  [<ffffffff81064edc>] ? run_workqueue+0xfc/0x240
[30490.708438]  [<ffffffff81064e8a>] ? run_workqueue+0xaa/0x240
[30490.708445]  [<ffffffff8107ad2d>] ? trace_hardirqs_on+0xd/0x10
[30490.708452]  [<ffffffff810650cf>] ? worker_thread+0xaf/0x130
[30490.708459]  [<ffffffff81069890>] ? autoremove_wake_function+0x0/0x40
[30490.708467]  [<ffffffff81065020>] ? worker_thread+0x0/0x130
[30490.708474]  [<ffffffff81069469>] ? kthread+0x49/0x90
[30490.708480]  [<ffffffff81013bb9>] ? child_rip+0xa/0x11
[30490.708487]  [<ffffffff81012dc3>] ? restore_args+0x0/0x30
[30490.708493]  [<ffffffff81069420>] ? kthread+0x0/0x90
[30490.708499]  [<ffffffff81013baf>] ? child_rip+0x0/0x11
[30490.708505] Code: 00 00 00 00 55 48 89 d1 48 89 e5 48 83 ec 30 48 89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 48 8b 1a 48 85 db 74 09 <f6> 83 88 00 00 00 03 75 26 48 83 fe 03 74 3a 48 83 fe 0a 66 0f
[30490.708566] RIP  [<ffffffff81505317>] kprobe_exceptions_notify+0x27/0x6d0
[30490.708574]  RSP <ffff88007bc19728>
[30490.708578] CR2: 000000007bc14a88
[30490.708582] ---[ end trace b9160e7389cc0254 ]---
[30490.713043] in_atomic(): 0, irqs_disabled(): 1, pid: 0, name: swapper
[30490.713043] INFO: lockdep is turned off.
[30490.713043] irq event stamp: 38438696
[30490.713043] hardirqs last  enabled at (38438695): [<ffffffff810765e0>] tick_nohz_restart_sched_tick+0x160/0x1c0
[30490.713043] hardirqs last disabled at (38438696): [<ffffffff81502dab>] _spin_lock_irq+0x1b/0x70
[30490.713043] softirqs last  enabled at (38438632): [<ffffffff81057cf9>] __do_softirq+0x139/0x190
[30490.713043] softirqs last disabled at (38438621): [<ffffffff810140ac>] call_softirq+0x1c/0x40
[30490.713043] Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc5 #3
[30490.713043] Call Trace:
[30490.935741] BUG: scheduling while atomic: swapper/0/0x10010100
[30490.938057] INFO: lockdep is turned off.
[30490.939840] Modules linked in: ipv6 pata_pcmcia ide_cs usbhid hci_usb snd_hda_intel pcmcia snd_pcm_oss snd_mixer_oss snd_pcm<3>bad: scheduling from the idle thread!
[30490.943356] Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc5 #3
[30490.943360] Call Trace:
[30490.948220] BUG: scheduling while atomic: swapper/0/0x10010000
 usbhid hci_usb snd_hda_intel pcmcia snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc yenta_socket ohci1394 rsrc_nonstatic snd_hwdep pcspkr pcmcia_core iwlagn ieee1394 snd iwlcore rfkill led_class ehci_hcd soundcore uhci_hcd ide_pci_generic wmi
[30490.948227] INFO: lockdep is turned off.
[30490.948231] Modules linked in: ipv6 pata_pcmcia snd_timer ide_cs<4>[30490.952748]  snd_page_alloc yenta_socket ohci1394 rsrc_nonstatic snd_hwdep[30490.948315] CPU 1:
 pcspkr pcmcia_core[30490.948319] Modules linked in: ipv6 pata_pcmcia ide_cs usbhid hci_usb snd_hda_intel pcmcia snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc yenta_socket ohci1394 rsrc_nonstatic snd_hwdep pcspkr pcmcia_core iwlagn ieee1394 snd iwlcore rfkill led_class ehci_hcd soundcore uhci_hcd ide_pci_generic wmi
 iwlagn ieee1394 snd iwlcore rfkill led_class ehci_hcd soundcore uhci_hcd ide_pci_generic wmi
[30490.957028] CPU 1:
[30490.957684] Modules linked in: ipv6 pata_pcmcia ide_cs usbhid hci_usb snd_hda_intel pcmcia snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc[30490.948380] Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc5 #3
 yenta_socket ohci1394 rsrc_nonstatic snd_hwdep pcspkr pcmcia_core[30490.948385] RIP: deca:[<0000000000000000>]  [<0000000000000000>] 0x0
 iwlagn ieee1394 snd iwlcore rfkill led_class ehci_hcd[30490.948395] RSP: ffff88007c17fd18:0000000000000000  EFLAGS: 0000000a
 soundcore uhci_hcd ide_pci_generic wmi
[30490.964997] Pid: 10, comm: events/1 Tainted: G      D    2.6.28-rc5 #3
[30490.948400] RAX: 00000000fffffeb4 RBX: 000000000000ec0c RCX: 000000000000ec0c
[30490.966598] RIP: 925d:[<0000000000000000>] [30490.948405] RDX: ffff88007c17fc68 RSI: ffffffff81051e3b RDI: 000000000000000a
 [<0000000000000000>] 0x0
[30490.968496] RSP: ffffffff810153e0:ffff88007c1b42c0  EFLAGS: ffffffff81057b59
[30490.948410] RBP: ffff88007c17fc08 R08: ffffffff81051945 R09: ffff88007c17fc28
[30490.970737] RAX: 0000000000000100 RBX: ffff88007c187ef0 RCX: 000000000000000a
[30490.948415] R10: 000000000000ec0c R11: 000000000000ec81 R12: ffffffff810518de
[30490.972009] RDX: ffffffff81a38d20 RSI: ffff88007c187ee0 RDI: ffffffff810791b9
[30490.948420] R13: ffff88007c17fc08 R14: 0000000000000082 R15: 00000000fffffeb4
[30490.973981] RBP: 000000000000005f R08: ffffffff81057cac R09: ffff88007c1b42c0
[30490.948426] FS:  0000000000000000(0000) GS:ffff88007c15d3d8(0000) knlGS:0000000000000000
[30490.975653] R10: ffff88007c16dc48 R11: ffffffff8107925d R12: 0000000000000008
[30490.948431] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[30490.977134] R13: ffffffff81502a8b R14: ffff88007c187e80 R15: ffffffff8107ad2d
[30490.948436] CR2: 00007f101dd0dd30 CR3: 000000007958b000 CR4: 00000000000006e0
[30490.978855] FS:  0000000000000000(0000) GS:ffff88007c15d3d8(0000) knlGS:0000000000000000
[30490.948441] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[30490.980736] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[30490.948446] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[30490.982074] CR2: 000000007bc14a88 CR3: 0000000073513000 CR4: 00000000000006e0
[30490.948450] Call Trace:
[30490.948461]  [<ffffffff8105253d>] ? vprintk+0x34d/0x460
[30490.983787] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[30490.948470]  [<ffffffff814fef71>] ? printk+0x67/0x6e
[30490.985593] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[30490.948481]  [<ffffffff8107547f>] ? tick_broadcast_oneshot_control+0x8f/0x130
[30490.987003] Call Trace:
[30490.948488]  [<ffffffff81074d2d>] ? tick_notify+0x2ed/0x440
[30490.987729]  <IRQ>  [<ffffffff8150262d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[30490.948497]  [<ffffffff810856f1>] ? print_modules+0x81/0xb0
[30490.990540]  [<ffffffff81012cbd>] ? ret_from_intr+0x25/0x2e
[30490.948505]  [<ffffffff81079573>] ? __debug_show_held_locks+0x23/0x30
[30490.991728]  [<ffffffff810791b9>] ? trace_hardirqs_off_caller+0x29/0xc0
[30490.948513]  [<ffffffff8104d745>] ? __schedule_bug+0x55/0xa0
[30490.993102]  [<ffffffff8150262d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[30490.948520]  [<ffffffff814ff7dd>] ? thread_return+0x1b9/0x5ac
[30490.994828]  [<ffffffff810153e0>] ? do_softirq+0x80/0xd0
[30490.948527]  [<ffffffff81502b36>] ? _spin_unlock+0x26/0x30
[30490.996910]  [<ffffffff81012cbd>] ? ret_from_intr+0x25/0x2e
[30490.948536]  [<ffffffff8107abb9>] ? trace_hardirqs_on_caller+0x29/0x190
[30490.998124]  <EOI> [30490.948544]  [<ffffffff8107ad2d>] ? trace_hardirqs_on+0xd/0x10
<3>bad: scheduling from the idle thread!
[30490.999726] Pid: 10, comm: events/1 Tainted: G      D    2.6.28-rc5 #3
[30490.948553]  [<ffffffff81011635>] ? cpu_idle+0xb5/0xd0
[30490.948563]  [<ffffffff814fb016>] ? start_secondary+0x1a9/0x2d3
[30491.001118] Call Trace:
[30491.001877] BUG: unable to handle kernel NULL pointer dereference at 0000000000000320
[30491.004884] IP: [<ffffffff814ff573>] schedule+0x403/0x4b4
[30491.005111] PGD 7355c067 PUD 7355b067 PMD 0
[30491.005111] Oops: 0002 [#2] SMP
[30491.005111] last sysfs file: /sys/class/power_supply/C23B/charge_full
[30491.005111] CPU 1
[30491.005111] Modules linked in: ipv6 pata_pcmcia ide_cs usbhid hci_usb snd_hda_intel pcmcia snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc yenta_socket ohci1394 rsrc_nonstatic snd_hwdep pcspkr pcmcia_core iwlagn ieee1394 snd iwlcore rfkill led_class ehci_hcd soundcore uhci_hcd ide_pci_generic wmi
[30491.005111] Pid: 10, comm: events/1 Tainted: G      D    2.6.28-rc5 #3
[30491.005111] RIP: 0010:[<ffffffff814ff573>]  [<ffffffff814ff573>] schedule+0x403/0x4b4
[30491.005111] RSP: 0018:ffff88007c17fe58  EFLAGS: 00010086
[30491.005111] RAX: 0000000000000320 RBX: ffff880005719480 RCX: ffff88007c180598
[30491.005111] RDX: 0000000000000001 RSI: ffff88007c180240 RDI: ffff880078c4cd00
[30491.005111] RBP: ffff88007c17ff08 R08: 0000000000000000 R09: 0000000000000000
[30491.005111] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007a4da4f0
[30491.005111] R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
[30491.005111] FS:  0000000000000000(0000) GS:ffff88007c15d3d8(0000) knlGS:0000000000000000
[30491.005111] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[30491.005111] CR2: 0000000000000320 CR3: 0000000073513000 CR4: 00000000000006e0
[30491.005111] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[30491.005111] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[30491.005111] Process events/1 (pid: 10, threadinfo ffff88007c1b2000, task ffff88007c1b42c0)
[30491.005111] Stack:
[30491.005111]  ffff88007c17fe78 ffffffff81502b36 ffff88007c17fe78 ffff88007c180240
[30491.005111]  ffff880078c4cd00 ffff88007c180598 00000001810764eb 0000000000000001
[30491.005111]  ffff88007c180598 0000000000000000 ffff88007c17fec8 ffffffff8107abb9
[30491.005111] Call Trace:
[30491.005111] Code: 28 02 00 00 66 0f 1f 44 00 00 4d 85 e4 0f 84 25 03 00 00 65 8b 14 25 24 00 00 00 4d 39 ec 0f 84 f4 01 00 00 49 8d 85 20 03 00 00 <f0> 41 0f b3 95 20 03 00 00 65 66 c7 04 25 3c 00 00 00 01 00 65
[30491.005111] RIP  [<ffffffff814ff573>] schedule+0x403/0x4b4
[30491.005111]  RSP <ffff88007c17fe58>
[30491.005111] CR2: 0000000000000320
[30491.005111] ---[ end trace b9160e7389cc0254 ]---

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
---
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 029c8c0..0515e75 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -141,6 +141,10 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 /*
  * We need to show where it is safe to preempt execution of ACPICA
  */
-#define ACPI_PREEMPTION_POINT()	cond_resched()
+#define ACPI_PREEMPTION_POINT()		\
+	do {				\
+		if (!irqs_disabled())	\
+			cond_resched();	\
+	} while (0)
 
 #endif				/* __ACLINUX_H__ */
