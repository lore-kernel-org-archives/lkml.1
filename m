Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbZJMKI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbZJMKI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933841AbZJMKIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:08:25 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:39389 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844AbZJMKIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:08:24 -0400
Message-ID: <4AD45169.2030507@gmail.com>
Date: Tue, 13 Oct 2009 12:07:37 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Craig Sanders <cas@taz.net.au>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: PROBLEM: kernel oops when tickless. 2.6.28.x to 2.6.31.3
References: <20091013090554.GB28715@taz.net.au>
In-Reply-To: <20091013090554.GB28715@taz.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 13 Oct 2009 12:07:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Craig Sanders a écrit :
> (please CC me on any replies.  I'm not subscribed to the list)
> 
> I've been trying to switch to a tickless kernel on this one machine
> since at least 2.6.28.  Every time I run a tickless kernel, though,
> I get a kernel oops within a few days (at most).
> 
> The *exact* same kernels work on 3 other machines on my home network
> without a problem (I compile them on my fastest machine using debian's
> make-kpkg and install the same kernel on all boxes, they're all fairly
> similar).  It's ONLY this one machine which oopses - this machine is my
> combined pppoe internet gateway/server/personal desktop.
> 
> this machine is a Quad core AMD Phenom II 940 with 8GB RAM.  Motherboard
> is a Gigabyte M3A79-T Deluxe.
> 
> The other machines are all either dual or quad core AMD CPUs with either
> 4GB or 8GB RAM.  All machines are running debian sid (unstable) and are
> updated regularly (last update was on Sunday when i compiled, installed,
> and rebooted them all with the new kernel).
> 
> 
> the main things that this machine is running that the others aren't are:
> 
> 1. pppoe
> 
> 2. rsyslogd UDPServer, as a syslog server for the other machines and
>    various network devices (adsl modem, siemens gigaset phone, linksys
>    3102 ATA)
> 
> 3. bind9
> 
> 4. asterisk  (although asterisk seems unaffected and unrelated)
> 
> 5. /proc/sys/net/ipv4/ip_forward=1
> 
> 6. iptables firewall rules
> 
> 7. the kvm and kvm_amd modules (unlikely to be the cause because i've
>    only recently started compiling support for this in, and i'm not
>    actively using kvm on this machine yet)
> 
> 8. this machine also has two network interfaces in use, one for the LAN
>    (eth0 - sky2) and one for pppoe (eth1 - r8169).
> 
> $ lspci | grep Ethernet
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
> 03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 12)
> 
> $ cat /etc/udev/rules.d/70-persistent-net.rules
> # PCI device 0x11ab:0x4364 (sky2)
> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:23:54:f3:86:8e", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"
> 
> # PCI device 0x10ec:0x8168 (r8169)
> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:23:cd:b0:23:b9", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1"
> 
> 
> The oopses nearly always mention both rsyslogd and "last sysfs file:
> /sys/class/net/ppp0/statistics/collisions".  Bind 9 also hangs (stops
> responding to requests), which causes some dependent services (e.g.
> postfix) to have problems until I notice and restart bind9...and then
> manually restart affected services.
> 
> if i recompile the same kernel but go back to 250 or 1000 Hz ticks,
> it can run for months without a problem...essentially until I decide
> to upgrade the kernel, at which point i try tickless again.
> 
> 
> nothing in particular seems to trigger it.  there's nothing in the kernel
> log immediately before the oops, and nothing unusual in the other logs.
> 
> 
> I'd like to get this fixed, or at least find out what the problem is
> and work around it....in the meantime, i'll be compiling a non-tickless
> kernel for this machine (and upgrade to 2.6.31.4 at the same time) and
> rebooting ASAP.
> 
> anyone have any ideas on what it might be?
> 
> 
> 
> Oct 13 14:10:02 taz kernel: [170654.573785] BUG: unable to handle kernel NULL pointer dereference at (null)
> Oct 13 14:10:02 taz kernel: [170654.573791] IP: [<(null)>] (null)
> Oct 13 14:10:02 taz kernel: [170654.573793] PGD 227734067 PUD 22773b067 PMD 0 
> Oct 13 14:10:02 taz kernel: [170654.573796] Oops: 0010 [#1] PREEMPT SMP 
> Oct 13 14:10:02 taz kernel: [170654.573798] last sysfs file: /sys/class/net/ppp0/statistics/collisions
> Oct 13 14:10:02 taz kernel: [170654.573800] CPU 1 
> Oct 13 14:10:02 taz kernel: [170654.573802] Modules linked in: xt_comment sch_ingress cls_u32 sch_sfq sch_htb pppoe pppox ppp_generic slhc binfmt_misc sco bridge stp llc bnep rfcomm l2cap vboxnetadp vboxnetflt vboxdrv ipt_ULOG kvm_amd kvm powernow_k8 cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats xt_pkttype xt_recent xt_conntrack xt_multiport ipt_REDIRECT xt_tcpudp xt_state ipt_REJECT ipt_LOG iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc fuse xt_mac x_tables hwmon_vid lp parport nvidia(P) visor usbserial tun mt2060 snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss dvb_usb_dib0700 snd_pcm dib7000p dib7000m dvb_usb dvb_core snd_seq_dummy snd_seq_oss dib3000mc dibx000_common snd_seq_midi dib0070 firewire_ohci asus_atk0110 firewire_core snd_rawmidi snd_seq_midi_event snd_seq ohci1394 hwmon snd_timer snd_seq_device pcspkr ieee1394 i2c_pi
ix4 snd rtc_cmos r8169 soundcore btus
> Oct 13 14:10:02 taz kernel: b mii snd_page_alloc evdev sky2 thermal button usblp usb_storage sg ub amd64_edac_mod bluetooth sr_mod processor rfkill
> Oct 13 14:10:02 taz kernel: [170654.573854] Pid: 23870, comm: rsyslogd Tainted: P           2.6.31.3 #1 System Product Name
> Oct 13 14:10:02 taz kernel: [170654.573855] RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
> Oct 13 14:10:02 taz kernel: [170654.573857] RSP: 0018:ffff8800be83bbf0  EFLAGS: 00010246
> Oct 13 14:10:02 taz kernel: [170654.573859] RAX: ffff88019c0d37a0 RBX: 0000000000000179 RCX: ffff88022dc68038
> Oct 13 14:10:02 taz kernel: [170654.573860] RDX: ffffffff81432ac0 RSI: ffff88022dc68000 RDI: ffff88019c0d3700
> Oct 13 14:10:02 taz kernel: [170654.573862] RBP: 00000000fffffe88 R08: ffff8801f5e3b980 R09: 0000000000000000
> Oct 13 14:10:02 taz kernel: [170654.573863] R10: 0000000000000000 R11: 0000000000000246 R12: ffff88019c0d3700
> Oct 13 14:10:02 taz kernel: [170654.573864] R13: ffff88022dc68000 R14: ffff8801f5e3b700 R15: ffff8801d4c818c0
> Oct 13 14:10:02 taz kernel: [170654.573866] FS:  00007fa29c930950(0000) GS:ffff880028050000(0000) knlGS:0000000000e4fb90
> Oct 13 14:10:02 taz kernel: [170654.573868] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct 13 14:10:02 taz kernel: [170654.573869] CR2: 0000000000000000 CR3: 0000000227791000 CR4: 00000000000006e0
> Oct 13 14:10:02 taz kernel: [170654.573870] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct 13 14:10:02 taz kernel: [170654.573872] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct 13 14:10:02 taz kernel: [170654.573873] Process rsyslogd (pid: 23870, threadinfo ffff8800be83a000, task ffff88015e828000)
> Oct 13 14:10:02 taz kernel: [170654.573875] Stack:
> Oct 13 14:10:02 taz kernel: [170654.573876]  ffffffff81432b43 ffff88022dc68000 0000000000000000 ffff8800be83bee8
> Oct 13 14:10:02 taz kernel: [170654.573878] <0> ffffffff814370cc ffff88022dc68000 ffffffff81436de9 ffff8801f5e3b700
> Oct 13 14:10:02 taz kernel: [170654.573880] <0> ffffffff8143a48c ffff8800be83bc68 ffffffff814b5102 0000000000000058
> Oct 13 14:10:02 taz kernel: [170654.573883] Call Trace:
> Oct 13 14:10:02 taz kernel: [170654.573889]  [<ffffffff81432b43>] ? sock_wfree+0x83/0x90
> Oct 13 14:10:02 taz kernel: [170654.573892]  [<ffffffff814370cc>] ? skb_release_head_state+0x5c/0x110
> Oct 13 14:10:02 taz kernel: [170654.573894]  [<ffffffff81436de9>] ? __kfree_skb+0x9/0xa0
> Oct 13 14:10:02 taz kernel: [170654.573896]  [<ffffffff8143a48c>] ? skb_free_datagram+0xc/0x40
> Oct 13 14:10:02 taz kernel: [170654.573900]  [<ffffffff814b5102>] ? unix_dgram_recvmsg+0x202/0x330
> Oct 13 14:10:02 taz kernel: [170654.573902]  [<ffffffff8142f1f5>] ? sock_recvmsg+0xd5/0x100
> Oct 13 14:10:02 taz kernel: [170654.573905]  [<ffffffff8103ca32>] ? enqueue_entity+0x12/0x140
> Oct 13 14:10:02 taz kernel: [170654.573909]  [<ffffffff8105f200>] ? autoremove_wake_function+0x0/0x30
> Oct 13 14:10:02 taz kernel: [170654.573913]  [<ffffffff810d039f>] ? core_sys_select+0x28f/0x350
> Oct 13 14:10:02 taz kernel: [170654.573916]  [<ffffffff8106f101>] ? do_futex+0x711/0xa70
> Oct 13 14:10:02 taz kernel: [170654.573918]  [<ffffffff8100be4e>] ? common_interrupt+0xe/0x13
> Oct 13 14:10:02 taz kernel: [170654.573921]  [<ffffffff814711e0>] ? tcp_poll+0x0/0x160
> Oct 13 14:10:02 taz kernel: [170654.573923]  [<ffffffff8142e962>] ? sockfd_lookup_light+0x22/0x80
> Oct 13 14:10:02 taz kernel: [170654.573925]  [<ffffffff81430789>] ? sys_recvfrom+0xe9/0x180
> Oct 13 14:10:02 taz kernel: [170654.573927]  [<ffffffff8103c4c5>] ? set_next_entity+0x35/0x80
> Oct 13 14:10:02 taz kernel: [170654.573929]  [<ffffffff810419a2>] ? finish_task_switch+0x102/0x130
> Oct 13 14:10:02 taz kernel: [170654.573931]  [<ffffffff810d06f3>] ? sys_select+0x63/0x110
> Oct 13 14:10:02 taz kernel: [170654.573933]  [<ffffffff8100b4c2>] ? system_call_fastpath+0x16/0x1b
> Oct 13 14:10:02 taz kernel: [170654.573934] Code:  Bad RIP value.
> Oct 13 14:10:02 taz kernel: [170654.573939] RIP  [<(null)>] (null)
> Oct 13 14:10:02 taz kernel: [170654.573940]  RSP <ffff8800be83bbf0>
> Oct 13 14:10:02 taz kernel: [170654.573941] CR2: 0000000000000000
> Oct 13 14:10:02 taz kernel: [170654.573943] ---[ end trace f32dd62a9c839c8c ]---
> 
> 
> 
> $ sh scripts/ver_linux
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
> 
> Linux ganesh 2.6.31.3 #1 SMP PREEMPT Sun Oct 11 10:50:25 EST 2009 x86_64 GNU/Linux
> 
> Gnu C                  4.3.4
> Gnu make               3.81
> binutils               2.19.91.20091006
> util-linux             2.16.1
> mount                  support
> module-init-tools      3.10
> e2fsprogs              1.41.9
> xfsprogs               3.0.4
> pcmciautils            014
> quota-tools            3.17.
> Linux C Library        2.9
> Dynamic linker (ldd)   2.9
> Procps                 3.2.8
> Net-tools              1.60
> Console-tools          0.2.3
> oprofile               0.9.5cvs
> Sh-utils               7.5
> wireless-tools         29
> Modules Loaded         xt_comment sch_ingress cls_u32 sch_sfq sch_htb pppoe pppox ppp_generic slhc binfmt_misc sco bridge stp llc bnep rfcomm l2cap ipt_ULOG kvm_amd kvm
> powernow_k8 cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats xt_pkttype xt_recent xt_conntrack xt_multiport ipt_REDIRECT xt_tcpudp xt_state
> ipt_REJECT ipt_LOG iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc fuse
> xt_mac x_tables hwmon_vid lp parport nvidia visor usbserial tun mt2060 snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss dvb_usb_dib0700
> snd_pcm dib7000p dib7000m dvb_usb dvb_core snd_seq_dummy snd_seq_oss dib3000mc dibx000_common snd_seq_midi dib0070 firewire_ohci asus_atk0110 firewire_core snd_rawmidi
> snd_seq_midi_event snd_seq ohci1394 hwmon snd_timer snd_seq_device pcspkr ieee1394 i2c_piix4 snd rtc_cmos r8169 soundcore btusb mii snd_page_alloc evdev sky2 thermal
> button usblp usb_storage sg ub amd64_edac_mod bluetooth sr_mod processor rfkill
> 
> 
> 
> craig
> 

Hi Craig

This particular problem should/could be fixed in 2.6.31.4 by commit 
d99927f4d93f36553699573b279e0ff98ad7dea6
(net: Fix sock_wfree() race)

Please try to reproduce your tickless problem on 2.6.31.4 or latest Linus git tree

Thanks

