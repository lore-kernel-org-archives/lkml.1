Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZKIUoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZKIUoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZKIUoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:44:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52484 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbZKIUoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:44:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd)
Date: Mon, 9 Nov 2009 21:45:27 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200911091250.31626.rjw@sisk.pl> <alpine.LFD.2.00.0911091949500.2725@localhost.localdomain> <200911092100.58187.rjw@sisk.pl>
In-Reply-To: <200911092100.58187.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200911092145.27485.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Rafael J. Wysocki wrote:
> On Monday 09 November 2009, Thomas Gleixner wrote:
> > On Mon, 9 Nov 2009, Rafael J. Wysocki wrote:
> > 
> > > On Monday 09 November 2009, Mike Galbraith wrote:
> > > > On Mon, 2009-11-09 at 16:47 +0100, Rafael J. Wysocki wrote:
> > > > > On Monday 09 November 2009, Mike Galbraith wrote:
> > > > 
> > > > > > > Very likely.  What did you do to fix it?
> > > > > > 
> > > > > > You don't really wanna know.  In 31 with newidle enabled, the below
> > > > > > fixed it.  It won't fix 32, though it might cure the resume problem.
> > > > > 
> > > > > OK, I'll give it a try.
> > > 
> > > It doesn't help.
> > > 
> > > Also, I can reproduce the issue with current -git and kernel preepmtion
> > > disabled.
> > > 
> > > > I just tried to trigger badness via high speed online/offline combined
> > > > with taskset with CONFIG_PREEMPT enabled, and couldn't make it explode.
> > > 
> > > I'm not able to do it this way too, so resume seems to be necessary to trigger
> > > it.  I'm going try with the suspend debug in the "core" mode.
> > > 
> > > > (damn, wish i could s2ram this box)
> > > 
> > > That need not suffice.  I have two other boxes that suspend and resume
> > > correctly with 2.6.32-rc, AFAICS.
> > > 
> > > However, there seems to be a systematic error somewhere, since the failure
> > > always happens at the same place, ie. list_del_init(cwq->worklist.next); in
> > > run_workqueue(), in preemptible as well as in non-preemptible kernels.
> > > 
> > > Which is kind of strange, given the !list_empty(&cwq->worklist) test right
> > > before it.
> > 
> > Does that happen before or after the secondary CPU has been brought up ?
> 
> Way after.  It seems to happen more-or-less during or right after the thawing
> of tasks.
> 
> Moreover, the call trace I get is (manual transcription):

OK, below is the full call trace I found in the kernel log.

[   51.520183] PM: Finishing wakeup.
[   51.520186] Restarting tasks ... 
[   51.520387] usb 5-2: USB disconnect, address 2
[   51.544197] done.
[   52.013018] general protection fault: 0000 [#1] PREEMPT SMP 
[   52.013431] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.3/ttyUSB3/port_number
[   52.013700] CPU 0 
[   52.013900] Modules linked in: ip6t_LOG af_packet xt_tcpudp xt_pkttype ipt_LOG xt_limit bnep sco rfcomm l2cap crc16 snd_pcm_oss snd_mixer_oss snd_seq binfmt_misc snd_seq_device ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 cpufreq_conservative nf_conntrack nf_defrag_ipv4 cpufreq_ondemand ip_tables cpufreq_userspace cpufreq_powersave acpi_cpufreq ip6table_filter ip6_tables x_tables freq_table ipv6 microcode fuse loop sr_mod cdrom dm_mod arc4 ecb btusb snd_hda_codec_realtek bluetooth iwlagn snd_hda_intel snd_hda_codec iwlcore pcmcia snd_hwdep snd_pcm sdhci_pci mac80211 snd_timer joydev sdhci toshiba_acpi yenta_socket usbhid cfg80211 snd option rtc_cmos mmc_core firewire_ohci video rsrc_nonstatic psmouse firewire_core backlight soundcore iTCO_wdt rtc_core hid battery ac intel_agp button usb_storage snd_page_alloc usbserial rfkill pcmcia_core iTCO_vendor_support e1000e rtc_lib led_class serio_raw crc_itu_t output uinput sg ehci_hcd uhci_hcd sd_mod crc_t10dif usbcore ext3 jbd fan ahci libata thermal processor
[   52.016961] Pid: 9, comm: events/0 Not tainted 2.6.32-rc6-tst #160 PORTEGE R500
[   52.016961] RIP: 0010:[<ffffffff81054bff>]  [<ffffffff81054bff>] worker_thread+0x15b/0x22a
[   52.016961] RSP: 0018:ffff88007f0d9e40  EFLAGS: 00010046
[   52.016961] RAX: ffff88007e056b68 RBX: ffff88007f09bd48 RCX: 6b6b6b6b6b6b6b6b
[   52.016961] RDX: 6b6b6b6b6b6b6b6b RSI: 0000000000000000 RDI: ffff880001613d00
[   52.016961] RBP: ffff88007f0d9ee0 R08: ffff88007f0b9178 R09: ffff88007f0d9e10
[   52.016961] R10: ffff880001613d00 R11: 0000000000000001 R12: ffff88007e056b60
[   52.016961] R13: ffff880001613d00 R14: ffff88007f0b9140 R15: ffff88007f0b9140
[   52.016961] FS:  0000000000000000(0000) GS:ffff880001600000(0000) knlGS:0000000000000000
[   52.016961] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   52.016961] CR2: 00007f786667d060 CR3: 0000000001001000 CR4: 00000000000006f0
[   52.016961] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   52.016961] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   52.016961] Process events/0 (pid: 9, threadinfo ffff88007f0d8000, task ffff88007f0b9140)
[   52.016961] Stack:
[   52.016961]  000000000000c918 ffff88007f0b9578 ffff88007f0d9fd8 ffff88007f0b9140
[   52.016961] <0> ffff880001613d08 ffff88007f0b9140 ffff880001613d18 6b6b6b6b6b6b6b6b
[   52.016961] <0> 0000000000000000 ffff88007f0b9140 ffffffff81058281 ffff88007f0d9e98
[   52.016961] Call Trace:
[   52.016961]  [<ffffffff81058281>] ? autoremove_wake_function+0x0/0x38
[   52.016961]  [<ffffffff81054aa4>] ? worker_thread+0x0/0x22a
[   52.016961]  [<ffffffff8105805a>] kthread+0x69/0x71
[   52.016961]  [<ffffffff8100c16a>] child_rip+0xa/0x20
[   52.016961]  [<ffffffff81057ff1>] ? kthread+0x0/0x71
[   52.016961]  [<ffffffff8100c160>] ? child_rip+0x0/0x20
[   52.016961] Code: 74 12 4c 89 e6 4c 89 f7 ff 13 48 83 c3 08 48 83 3b 00 eb ec e8 3d ef ff ff 49 8b 45 08 4d 89 65 30 4c 89 ef 48 8b 08 48 8b 50 08 <48> 89 51 08 48 89 0a 48 89 40 08 48 89 00 e8 f6 11 24 00 49 8b 
[   52.016961] RIP  [<ffffffff81054bff>] worker_thread+0x15b/0x22a
[   52.016961]  RSP <ffff88007f0d9e40>
[   52.016961] ---[ end trace 1d831fad17e9eb5d ]---
[   52.016961] note: events/0[9] exited with preempt_count 1

So, this actually is a general protection fault that killed events and it
happened exactly in list_del_init(cwq->worklist.next); in run_workqueue().

Thanks,
Rafael
