Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYLBCpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYLBCpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 21:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYLBCpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 21:45:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:11980 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbYLBCpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 21:45:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,700,1220252400"; 
   d="scan'208";a="85272848"
Date: Tue, 2 Dec 2008 10:45:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "astarikovskiy@suse.de" <astarikovskiy@suse.de>,
       "sitsofe@yahoo.com" <sitsofe@yahoo.com>,
       "Brown, Len" <len.brown@intel.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "Zhang, Rui" <rui.zhang@intel.com>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       "Zhao, Yakui" <yakui.zhao@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc6] ACPICA: don't cond_resched() when
	irqs_disabled()
Message-ID: <20081202024522.GA8908@localhost>
References: <20081126063522.GA23611@localhost> <20081126135508.GA1891@localhost> <20081126152043.c92ae839.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126152043.c92ae839.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[update on the bug after some extensive debugging efforts]

This bug may be related to the one in
http://bugzilla.kernel.org/show_bug.cgi?id=11259
and can be reliably reproduced by enabling CONFIG_ACPI_VIDEO and SMP,
boot and close the lid. It dies so hard that makes NMI watchdog useless.

It's not a new bug, and we are close to root causing it.
In function acpi_ex_system_io_space_handler():

301         case ACPI_WRITE:
302
303                 status = acpi_os_write_port((acpi_io_address) address,
304                                             (u32) * value, bit_width);
305                 break;

The notebook stalls immediately after line 303, which is triggering an SMI,
and invoking SMM code to interact with system firmware.

Lin Ming and Zhao Yakui helped locating this line. Zhang Rui collected
a lot detailed info and is working on this issue.

Thanks,
Fengguang

On Thu, Nov 27, 2008 at 01:20:43AM +0200, Andrew Morton wrote:
> On Wed, 26 Nov 2008 21:55:08 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
>
> > [add CC to <stable@kernel.org>, since this bug was introduced in the
> > 2.6.27-rcX time frame, and should help 2.6.28 and 2.6.27.x alike]
> >
> > The ACPI routines could be called from run_workqueue() with irqs disabled.
> > So we should test irqs_disabled() before calling cond_resched().
> >
>
> It is a bug for anyone to call run_workqueue() with local interrupts
> disabled.
>
>
> > ---
> > PS. the BUG that this patch fixed:
>
> It isn't immediately obvious from this trace why/how run_workqueue() is
> being called that way.  Are you able to work out what's going on here
> please?
>
> > [30490.707880] BUG: sleeping function called from invalid context at kernel/sched.c:5570
> > [30490.707910] BUG: unable to handle kernel paging request at 000000007bc14a88
> > [30490.707918] IP: [<ffffffff81505317>] kprobe_exceptions_notify+0x27/0x6d0
>
> Do I see kprobes oopsing in the middle of our attempt to do a WARN_ON()?
>
> If so, is this a separate kprobes bug?
>
> Is the acpi problem reproducible with kprobes disabled, so we can fix
> one thing at a time?
>
> > [30490.707934] PGD 7355c067 PUD 7352f067 PMD 0
> > [30490.707941] Oops: 0000 [#1] SMP
> > [30490.707946] last sysfs file: /sys/class/power_supply/C23B/charge_full
> > [30490.707952] Dumping ftrace buffer:
> > [30490.707957]    (ftrace buffer empty)
> > [30490.707960] CPU 1
> > [30490.707964] Modules linked in: ipv6 pata_pcmcia ide_cs usbhid hci_usb snd_hda_intel pcmcia snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc yenta_socket ohci1394 rsrc_nonstatic snd_hwdep pcspkr pcmcia_core iwlagn ieee1394 snd iwlcore rfkill led_class ehci_hcd soundcore uhci_hcd ide_pci_generic wmi
> > [30490.708007] Pid: 191, comm: kacpid Not tainted 2.6.28-rc5 #3
> > [30490.708011] RIP: 0010:[<ffffffff81505317>]  [<ffffffff81505317>] kprobe_exceptions_notify+0x27/0x6d0
> > [30490.708021] RSP: 0018:ffff88007bc19728  EFLAGS: 00010006
> > [30490.708026] RAX: ffffffff8174f190 RBX: 000000007bc14a00 RCX: ffff88007bc197f8
> > [30490.708030] RDX: ffff88007bc197f8 RSI: 000000000000000a RDI: ffffffff8174f190
> > [30490.708035] RBP: ffff88007bc19758 R08: 0000000000000000 R09: 0000000000000000
> > [30490.708039] R10: 00000000ffffffff R11: ffffffff816916fe R12: 00000000ffffffff
> > [30490.708043] R13: ffffffff8174fe20 R14: ffff88007bc197f8 R15: 000000000000000a
> > [30490.708049] FS:  0000000000000000(0000) GS:ffff88007c15d3d8(0000) knlGS:0000000000000000
> > [30490.708053] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > [30490.708058] CR2: 000000007bc14a88 CR3: 0000000073513000 CR4: 00000000000006e0
> > [30490.708062] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [30490.708067] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [30490.708072] Process kacpid (pid: 191, threadinfo ffff88007bc18000, task ffff88007bc14a00)
> > [30490.708075] Stack:
> > [30490.708078]  0000000000000000 0000000000000000 00000000ffffffff ffffffff8174fe20
> > [30490.708085]  ffff88007bc197f8 000000000000000a ffff88007bc19798 ffffffff815069df
> > [30490.708093]  ffffffff8174f580 ffffffff8174cef8 0000000000000000 00000000ffffffff
> > [30490.708102] Call Trace:
> > [30490.708106]  [<ffffffff815069df>] notifier_call_chain+0x3f/0x80
> > [30490.708113]  [<ffffffff81506a89>] __atomic_notifier_call_chain+0x69/0xa0
> > [30490.708121]  [<ffffffff81506a20>] ? __atomic_notifier_call_chain+0x0/0xa0
> > [30490.708129]  [<ffffffff8107925d>] ? trace_hardirqs_off+0xd/0x10
> > [30490.708138]  [<ffffffff81502b08>] _spin_unlock_irqrestore+0x68/0x70
> > [30490.708146]  [<ffffffff810791b9>] ? trace_hardirqs_off_caller+0x29/0xc0
> > [30490.708153]  [<ffffffff8107925d>] ? trace_hardirqs_off+0xd/0x10
> > [30490.708160]  [<ffffffff81502b08>] ? _spin_unlock_irqrestore+0x68/0x70
> > [30490.708167]  [<ffffffff812decd4>] ? e1000_xmit_frame+0xb34/0xf10
> > [30490.708177]  [<ffffffff810e8c39>] ? cache_alloc_debugcheck_after+0x159/0x250
> > [30490.708185]  [<ffffffff8107925d>] ? trace_hardirqs_off+0xd/0x10
> > [30490.708192]  [<ffffffff813c66eb>] ? netpoll_send_skb+0x19b/0x210
> > [30490.708201]  [<ffffffff81204534>] ? delay_tsc+0x44/0x90
> > [30490.708210]  [<ffffffff812045f4>] ? __const_udelay+0x44/0x50
> > [30490.708218]  [<ffffffff812adc1c>] ? wait_for_xmitr+0x5c/0xd0
> > [30490.708227]  [<ffffffff812adcb0>] ? serial8250_console_putchar+0x20/0x40
> > [30490.708234]  [<ffffffff812adc90>] ? serial8250_console_putchar+0x0/0x40
> > [30490.708241]  [<ffffffff812a97d4>] ? uart_console_write+0x34/0x70
> > [30490.708249]  [<ffffffff812ae1b2>] ? serial8250_console_write+0xc2/0x1a0
> > [30490.708257]  [<ffffffff810518de>] ? __call_console_drivers+0x6e/0x90
> > [30490.708265]  [<ffffffff81051945>] ? _call_console_drivers+0x45/0x70
> > [30490.708272]  [<ffffffff81051e3b>] ? release_console_sem+0x18b/0x250
> > [30490.708279]  [<ffffffff8105253d>] ? vprintk+0x34d/0x460
> > [30490.708285]  [<ffffffff8107925d>] ? trace_hardirqs_off+0xd/0x10
> > [30490.708292]  [<ffffffff8107ae14>] ? debug_check_no_locks_freed+0xe4/0x170
> > [30490.708300]  [<ffffffff814fef71>] ? printk+0x67/0x6e
> > [30490.708306]  [<ffffffff810eaa38>] ? kmem_cache_free+0x1a8/0x210
> > [30490.708313]  [<ffffffff8107925d>] ? trace_hardirqs_off+0xd/0x10
> > [30490.708319]  [<ffffffff810eaa38>] ? kmem_cache_free+0x1a8/0x210
> > [30490.708326]  [<ffffffff8123b2d9>] ? acpi_os_release_object+0x9/0xd
> > [30490.708334]  [<ffffffff81048afb>] ? __might_sleep+0x9b/0x140
> > [30490.708343]  [<ffffffff8104db75>] ? __cond_resched+0x15/0x60
> > [30490.708349]  [<ffffffff814ffd15>] ? _cond_resched+0x35/0x50
> > [30490.708355]  [<ffffffff8124e15d>] ? acpi_ps_complete_op+0x235/0x24b
> > [30490.708365]  [<ffffffff8124e872>] ? acpi_ps_parse_loop+0x6ff/0x859
> > [30490.708372]  [<ffffffff8124da6f>] ? acpi_ps_parse_aml+0x7c/0x2bb
> > [30490.708380]  [<ffffffff8124efe9>] ? acpi_ps_execute_method+0x144/0x213
> > [30490.708386]  [<ffffffff8124b3ee>] ? acpi_ns_evaluate+0x152/0x230
> > [30490.708394]  [<ffffffff8123b595>] ? acpi_os_execute_deferred+0x0/0x39
> > [30490.708401]  [<ffffffff81242ab4>] ? acpi_ev_asynch_execute_gpe_method+0xc7/0x11f
> > [30490.708408]  [<ffffffff81064e8a>] ? run_workqueue+0xaa/0x240
> > [30490.708417]  [<ffffffff8123b5c1>] ? acpi_os_execute_deferred+0x2c/0x39
> > [30490.708424]  [<ffffffff8123b595>] ? acpi_os_execute_deferred+0x0/0x39
> > [30490.708431]  [<ffffffff81064edc>] ? run_workqueue+0xfc/0x240
> > [30490.708438]  [<ffffffff81064e8a>] ? run_workqueue+0xaa/0x240
> > [30490.708445]  [<ffffffff8107ad2d>] ? trace_hardirqs_on+0xd/0x10
> > [30490.708452]  [<ffffffff810650cf>] ? worker_thread+0xaf/0x130
> > [30490.708459]  [<ffffffff81069890>] ? autoremove_wake_function+0x0/0x40
> > [30490.708467]  [<ffffffff81065020>] ? worker_thread+0x0/0x130
> > [30490.708474]  [<ffffffff81069469>] ? kthread+0x49/0x90
> > [30490.708480]  [<ffffffff81013bb9>] ? child_rip+0xa/0x11
> > [30490.708487]  [<ffffffff81012dc3>] ? restore_args+0x0/0x30
> > [30490.708493]  [<ffffffff81069420>] ? kthread+0x0/0x90
> > [30490.708499]  [<ffffffff81013baf>] ? child_rip+0x0/0x11
