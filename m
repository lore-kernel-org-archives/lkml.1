Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbYLXC0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbYLXC0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 21:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYLXCZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 21:25:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54794 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYLXCZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 21:25:54 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: BUG: general protection fault: 0000 [#1] SMP
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       pzijlstr@redhat.com
In-Reply-To: <c4e36d110812231616x2b0d00e9o562699a459466987@mail.gmail.com>
References: <c4e36d110812231616x2b0d00e9o562699a459466987@mail.gmail.com>
Message-Id: <20081224110302.433B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 24 Dec 2008 11:25:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> I've been just doing exit in rather 'large' firefox run and got this oops.
> Machine - T61, 64bit, C2D, 2GB, - kernel relatively fresh 2.6.28-rc9
> 
> it looks like casting in __set_page_dirty() is the place where this
> fault happens: (0xe8e)
> int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
> 
> Maybe it was already invalid during process destruction ??
> 
> --
> 	if (likely(mapping)) {
>      e89:	48 85 c0             	test   %rax,%rax
>      e8c:	74 3a                	je     ec8 <set_page_dirty+0x68>
> 		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
>      e8e:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
> #ifdef CONFIG_BLOCK
> 		if (!spd)
>      e95:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
> static int __set_page_dirty(struct page *page)
> --
> 

It seems memory corruption bug.
Can you reproduce this bug always?





> general protection fault: 0000 [#1] SMP
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/rfkill/rfkill1/state
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> CPU 0
> Modules linked in: fuse ipt_MASQUERADE iptable_nat nf_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
> xt_tcpudp iptable_filter ip_ta
> bles x_tables bridge stp llc bluetooth autofs4 sunrpc ipv6 binfmt_misc
> dm_mirror dm_region_hash dm_log dm_mod rtc_cmos rtc_core rtc_lib
> kvm_intel kvm i915 drm uinput snd
> _hda_intel snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device arc4
> snd_pcm_oss ecb cryptomgr snd_mixer_oss snd_pcm aead crypto_blkcipher
> crypto_algapi thinkpad_acpi i
> wl3945 sdhci_pci snd_timer sdhci snd e1000e button backlight led_class
> evdev sr_mod cdrom i2c_i801 soundcore rfkill mac80211 intel_agp
> i2c_core mmc_core nvram psmouse cf
> g80211 ac battery iTCO_wdt iTCO_vendor_support snd_page_alloc
> serio_raw uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
> microcode]
> Pid: 4081, comm: firefox Not tainted 2.6.28-rc9 #99
> RIP: 0010:[<ffffffff802ac32e>]  [<ffffffff802ac32e>] set_page_dirty+0x2e/0x100
> RSP: 0018:ffff88005b31faa8  EFLAGS: 00010206
> RAX: 683c1508e07cd70c RBX: ffffe200015b04c0 RCX: ffff8800042034e0
> RDX: 8000000039d62067 RSI: 0000000000000007 RDI: ffffe200015b04c0
> RBP: ffff88005b31fac8 R08: 0000000000000067 R09: ffff880001101200
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffe200015b04c0
> R13: 00007f7a6f976000 R14: ffff88005b28fbb0 R15: 00000000001c3dcc
> FS:  00007f7a70aff950(0000) GS:ffffffff80705640(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f7a78698c08 CR3: 000000004aac7000 CR4: 00000000000026e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process firefox (pid: 4081, threadinfo ffff88005b31e000, task ffff88005b1a8000)
> Stack:
>  ffff88005b31fac8 00007f7a6fa00000 ffffe200015b04c0 00007f7a6f976000
>  ffff88005b31fbc8 ffffffff802b7627 0000000000000067 00007f7a701fffff
>  0000000000000000 ffff88005b31fbe0 ffffffffffffffff 0000000000000000
> Call Trace:
>  [<ffffffff802b7627>] unmap_vmas+0x6f7/0x920
>  [<ffffffff802bbf36>] exit_mmap+0xa6/0x170
>  [<ffffffff80241ff8>] mmput+0x48/0xe0
>  [<ffffffff802464e8>] exit_mm+0x108/0x140
>  [<ffffffff802482b7>] do_exit+0x177/0xa00
>  [<ffffffff80213853>] ? native_sched_clock+0x13/0x60
>  [<ffffffff80254295>] ? get_signal_to_deliver+0x245/0x3c0
>  [<ffffffff8052db02>] ? _spin_unlock_irq+0x32/0x50
>  [<ffffffff80248b85>] do_group_exit+0x45/0xc0
>  [<ffffffff802542db>] get_signal_to_deliver+0x28b/0x3c0
>  [<ffffffff8020bbea>] do_notify_resume+0xba/0x920
>  [<ffffffff80213853>] ? native_sched_clock+0x13/0x60
>  [<ffffffff8025c926>] ? remove_wait_queue+0x46/0x60
>  [<ffffffff8026de33>] ? trace_hardirqs_on_caller+0x133/0x190
>  [<ffffffff8026de9d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8025c926>] ? remove_wait_queue+0x46/0x60
>  [<ffffffff8023e3f0>] ? default_wake_function+0x0/0x10
>  [<ffffffff8020c601>] ? sysret_signal+0x5/0x2f
>  [<ffffffff8026de33>] ? trace_hardirqs_on_caller+0x133/0x190
>  [<ffffffff8020c61b>] ? sysret_signal+0x1f/0x2f
>  [<ffffffff8020c977>] ptregscall_common+0x67/0xb0
> Code: e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 4c 89 6d f8 48 89 fb 48
> 8b 47 18 66 83 3f 00 0f 88 c8 00 00 00 a8 01 75 3f 48 85 c0 74 3a <48>
> 8b 80 c8 00 00
>  00 48 c7 c2 20 a0 2f 80 48 8b 40 20 48 89 df
> RIP  [<ffffffff802ac32e>] set_page_dirty+0x2e/0x100
>  RSP <ffff88005b31faa8>
> ---[ end trace 0aff50e6830fbc8a ]---
> 
> 
> Zdenek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



