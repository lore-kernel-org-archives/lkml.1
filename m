Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZKJASU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZKJASU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZKJAST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:18:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53151 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbZKJAST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:18:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd)
Date: Tue, 10 Nov 2009 01:19:37 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200911100119.38019.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Linus Torvalds wrote:
> 
> On Mon, 9 Nov 2009, Rafael J. Wysocki wrote:
> >
> > [   52.013018] general protection fault: 0000 [#1] PREEMPT SMP 
> 
> It'sa GP fault only because it's an invalid pointer - it's the same as a 
> NULL pointer page fault, except pointing into the invalid hole in between 
> low virtual memory and high virtual memory mappings.
> 
> > [   52.013431] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.3/ttyUSB3/port_number
> > [   52.013700] CPU 0 
> > [   52.013900] Modules linked in: ip6t_LOG af_packet xt_tcpudp xt_pkttype ipt_LOG xt_limit bnep sco rfcomm l2cap crc16 snd_pcm_oss snd_mixer_oss snd_seq binfmt_misc snd_seq_device ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 cpufreq_conservative nf_conntrack nf_defrag_ipv4 cpufreq_ondemand ip_tables cpufreq_userspace cpufreq_powersave acpi_cpufreq ip6table_filter ip6_tables x_tables freq_table ipv6 microcode fuse loop sr_mod cdrom dm_mod arc4 ecb btusb snd_hda_codec_realtek bluetooth iwlagn snd_hda_intel snd_hda_codec iwlcore pcmcia snd_hwdep snd_pcm sdhci_pci mac80211 snd_timer joydev sdhci toshiba_acpi yenta_socket usbhid cfg80211 snd option rtc_cmos mmc_core firewire_ohci video rsrc_nonstatic psmouse firewire_core backlight soundcore iTCO_wdt rtc_core hid battery ac intel_agp button usb_storage snd_page_alloc usbserial rfkill pcmcia_core iTCO_vendor_support !
>  e1000e rtc_lib led_class serio_raw crc_itu_t output uinput sg ehci_hcd uhci_hcd sd_mod crc_t10dif usbcore ext3 jbd fan ahci libata thermal processor
> > [   52.016961] Pid: 9, comm: events/0 Not tainted 2.6.32-rc6-tst #160 PORTEGE R500
> > [   52.016961] RIP: 0010:[<ffffffff81054bff>]  [<ffffffff81054bff>] worker_thread+0x15b/0x22a
> > [   52.016961] RSP: 0018:ffff88007f0d9e40  EFLAGS: 00010046
> > [   52.016961] RAX: ffff88007e056b68 RBX: ffff88007f09bd48 RCX: 6b6b6b6b6b6b6b6b
> 
> The code is
> 
>    8:	ff 13                	callq  *(%rbx)
>    a:	48 83 c3 08          	add    $0x8,%rbx
>    e:	48 83 3b 00          	cmpq   $0x0,(%rbx)
>   12:	eb ec                	jmp    0x0
>   14:	e8 3d ef ff ff       	callq  0xffffffffffffef56
>   19:	49 8b 45 08          	mov    0x8(%r13),%rax
>   1d:	4d 89 65 30          	mov    %r12,0x30(%r13)
>   21:	4c 89 ef             	mov    %r13,%rdi
>   24:	48 8b 08             	mov    (%rax),%rcx
>   27:	48 8b 50 08          	mov    0x8(%rax),%rdx
>   2b:*	48 89 51 08          	mov    %rdx,0x8(%rcx)     <-- trapping instruction
>   2f:	48 89 0a             	mov    %rcx,(%rdx)
>   32:	48 89 40 08          	mov    %rax,0x8(%rax)
> 
> and %rcx is 0x6b6b6b6b6b6b6b6b, which is the POISON_FREE byte sequence.
> 
> So somebody is trying to remove a list entry that was already free'd.

The entry is being removed by run_workqueue(), so I wonder what the scenario is.

It appears that the problem is not reproducible with init=/bin/bash and the
minimal set of modules loaded, so perhaps one of the (modular) drivers
removes a work item from keventd_wq in a racy way.

In the meantime I got another trace, this time with a slab corruption involved.
Note that it crashed in exactly the same place as previously.

[  210.450676] usb 1-2: GSM modem (1-port) converter now attached to ttyUSB0
[  210.450725] option 1-2:1.1: GSM modem (1-port) converter detected
[  210.450997] usb 1-2: GSM modem (1-port) converter now attached to ttyUSB1
[  210.451044] option 1-2:1.2: GSM modem (1-port) converter detected
[  210.451422] usb 1-2: GSM modem (1-port) converter now attached to ttyUSB2
[  210.451470] option 1-2:1.3: GSM modem (1-port) converter detected
[  210.451746] usb 1-2: GSM modem (1-port) converter now attached to ttyUSB3
[  210.452092] PM: Finishing wakeup.
[  210.452095] Restarting tasks ... 
[  210.452293] usb 5-2: USB disconnect, address 2
[  210.470519] done.
[  210.845547] Slab corruption: size-512 start=ffff88007f1182b0, len=512
[  210.845718] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[  210.845880] Last user: [<ffffffff810c8bdb>](kfree+0x7c/0x88)
[  210.846142] 050: 6b 6b 6b 6b 6b 6b 6b 6b 38 e7 60 01 00 88 ff ff
[  210.847114] Prev obj: start=ffff88007f118098, len=512
[  210.847275] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
[  210.847436] Last user: [<ffffffffa01ffce0>](kzalloc+0xf/0x11 [snd])
[  210.847724] 000: 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00
[  210.850735] 010: 50 43 4d 20 50 6c 61 79 62 61 63 6b 20 56 6f 6c
[  210.851844] Next obj: start=ffff88007f1184c8, len=512
[  210.852220] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
[  210.852384] Last user: [<ffffffff8106a4c8>](kzalloc+0xf/0x11)
[  210.852655] 000: 17 ea 3b 81 ff ff ff ff 00 00 00 00 00 00 00 00
[  210.853981] 010: 24 01 00 00 00 00 00 00 0e a9 06 81 ff ff ff ff
[  210.887295] e1000e 0000:01:00.0: irq 27 for MSI/MSI-X
[  210.940224] e1000e 0000:01:00.0: irq 27 for MSI/MSI-X
[  210.941776] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  211.061316] general protection fault: 0000 [#1] PREEMPT SMP 
[  211.061626] last sysfs file: /sys/class/pcmcia_socket/pcmcia_socket0/card_insert
[  211.061891] CPU 0 
[  211.062090] Modules linked in: ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit af_packet bnep sco rfcomm l2cap crc16 snd_pcm_oss snd_mixer_oss snd_seq binfmt_misc snd_seq_device ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 cpufreq_conservative ip_tables cpufreq_ondemand cpufreq_userspace cpufreq_powersave ip6table_filter acpi_cpufreq ip6_tables x_tables freq_table ipv6 microcode fuse loop sr_mod cdrom dm_mod btusb snd_hda_codec_realtek bluetooth arc4 snd_hda_intel ecb snd_hda_codec pcmcia snd_hwdep iwlcore snd_pcm mac80211 toshiba_acpi joydev snd_timer yenta_socket usbhid option video cfg80211 backlight rtc_cmos snd rsrc_nonstatic psmouse usb_storage hid output usbserial rtc_core iTCO_wdt soundcore battery pcmcia_core ac rfkill led_class button intel_agp rtc_lib crc_itu_t serio_raw e1000e iTCO_vendor_support snd_page_alloc uinput sg ehci_hcd uhci_hcd sd_mod crc_t10dif usbcore ext3 jbd fan ahci libata thermal processor [last unloaded: iwlagn]
[  211.064780] Pid: 9, comm: events/0 Not tainted 2.6.32-rc6-tst #169 PORTEGE R500
[  211.064780] RIP: 0010:[<ffffffff81054c07>]  [<ffffffff81054c07>] worker_thread+0x15b/0x22a
[  211.064780] RSP: 0018:ffff88007f0d9e40  EFLAGS: 00010046
[  211.064780] RAX: ffff88007f118308 RBX: ffff88007f09bd48 RCX: 6b6b6b6b6b6b6b6b
[  211.064780] RDX: 6b6b6b6b6b6b6b6b RSI: 0000000000000000 RDI: ffff880001613d00
[  211.064780] RBP: ffff88007f0d9ee0 R08: ffff88007f0d9cf0 R09: ffff88007f0d9e02
[  211.064780] R10: ffff880001613d00 R11: 0000000000000000 R12: ffff88007f118300
[  211.064780] R13: ffff880001613d00 R14: ffff88007f0b9140 R15: ffff88007f0b9140
[  211.064780] FS:  0000000000000000(0000) GS:ffff880001600000(0000) knlGS:0000000000000000
[  211.064780] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  211.064780] CR2: 00007f7678984660 CR3: 000000007d3ce000 CR4: 00000000000006f0
[  211.064780] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  211.064780] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  211.064780] Process events/0 (pid: 9, threadinfo ffff88007f0d8000, task ffff88007f0b9140)
[  211.064780] Stack:
[  211.064780]  000000000000c918 ffff88007f0b9578 ffff88007f0d9fd8 ffff88007f0b9140
[  211.064780] <0> ffff880001613d08 ffff88007f0b9140 ffff880001613d18 6b6b6b6b6b6b6b6b
[  211.064780] <0> 0000000000000000 ffff88007f0b9140 ffffffff81058289 ffff88007f0d9e98
[  211.064780] Call Trace:
[  211.064780]  [<ffffffff81058289>] ? autoremove_wake_function+0x0/0x38
[  211.064780]  [<ffffffff81054aac>] ? worker_thread+0x0/0x22a
[  211.064780]  [<ffffffff81058062>] kthread+0x69/0x71
[  211.064780]  [<ffffffff8100c16a>] child_rip+0xa/0x20
[  211.064780]  [<ffffffff81057ff9>] ? kthread+0x0/0x71
[  211.064780]  [<ffffffff8100c160>] ? child_rip+0x0/0x20
[  211.064780] Code: 74 12 4c 89 e6 4c 89 f7 ff 13 48 83 c3 08 48 83 3b 00 eb ec e8 3d ef ff ff 49 8b 45 08 4d 89 65 30 4c 89 ef 48 8b 08 48 8b 50 08 <48> 89 51 08 48 89 0a 48 89 40 08 48 89 00 e8 f6 11 24 00 49 8b 
[  211.064780] RIP  [<ffffffff81054c07>] worker_thread+0x15b/0x22a
[  211.064780]  RSP <ffff88007f0d9e40>
[  211.064780] ---[ end trace 586a2f2b96b909e0 ]---
[  211.064780] note: events/0[9] exited with preempt_count 1

Rafael
