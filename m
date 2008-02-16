Return-Path: <linux-kernel-owner+w=401wt.eu-S1764220AbYBPDja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764220AbYBPDja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763859AbYBPDi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:38:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757807AbYBPDix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:38:53 -0500
Date: Fri, 15 Feb 2008 19:37:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] do_signal_stop: use signal_group_exit()
Message-Id: <20080215193756.9e5b8205.akpm@linux-foundation.org>
In-Reply-To: <20080215180204.GA4359@tv-sign.ru>
References: <20080215180204.GA4359@tv-sign.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ug.  On about the fourth boot with the current -mm lineup I hit:


: security:  permission sendto in class node not defined in policy
: security:  permission dccp_recv in class netif not defined in policy
: security:  permission dccp_send in class netif not defined in policy
: security:  permission ingress in class netif not defined in policy
: security:  permission egress in class netif not defined in policy
: security:  permission setfcap in class capability not defined in policy
: security:  permission forward_in in class packet not defined in policy
: security:  permission forward_out in class packet not defined in policy
: SELinux: policy loaded with handle_unknown=deny
: type=1403 audit(1203124656.152:3): policy loaded auid=4294967295 ses=4294967295
: BUG: unable to handle kernel paging request at 0000000000200200
: IP: [<ffffffff802444f5>] free_pid+0x35/0x8e
: PGD 2574cb067 PUD 257561067 PMD 0 
: Oops: 0002 [1] SMP 
: last sysfs file: /sys/class/net/eth0/address
: CPU 2 
: Modules linked in: ipv6 dm_mirror dm_multipath dm_mod sbs sbshc dock battery ac parport_pc lp parport snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq shpchp snd_seq_device sg snd_pcm_oss snd_mixer_oss snd_pcm floppy snd_timer button i2c_i801 snd soundcore ide_cd_mod cdrom serio_raw i2c_core snd_page_alloc pcspkr ehci_hcd ohci_hcd uhci_hcd
: Pid: 3132, comm: ifup-eth Not tainted 2.6.25-rc2-mm1 #5
: RIP: 0010:[<ffffffff802444f5>]  [<ffffffff802444f5>] free_pid+0x35/0x8e
: RSP: 0018:ffff81025754de58  EFLAGS: 00010046
: RAX: 0000000000000000 RBX: ffff81025f268840 RCX: ffff81025f263f08
: RDX: 0000000000200200 RSI: 0000000000000046 RDI: 0000000000000000
: RBP: ffff81025f263ec0 R08: ffff81025f268b18 R09: ffff81025f268b08
: R10: ffff81025f268b08 R11: 0000000000000000 R12: ffff810259853140
: R13: 0000000000000c78 R14: 0000000000000000 R15: 0000000000000000
: FS:  00007f8f9ba7d6f0(0000) GS:ffff81025f16f0c0(0000) knlGS:0000000000000000
: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
: CR2: 0000000000200200 CR3: 00000002598d0000 CR4: 00000000000006e0
: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
: Process ifup-eth (pid: 3132, threadinfo ffff81025754c000, task ffff81025d467620)
: Stack:  ffff81025f268b08 ffff81025f268840 ffff81025994b660 ffffffff80237727
:  ffff81025994b660 ffff81025994b660 0000000000000000 ffffffff80237f81
:  00000000000005d0 ffff810257561018 0000000000000000 00007fffa3aa9514
: Call Trace:
:  [<ffffffff80237727>] ? release_task+0x152/0x2e5
:  [<ffffffff80237f81>] ? do_wait+0x6c7/0xa1c
:  [<ffffffff8022f4cc>] ? default_wake_function+0x0/0xe
:  [<ffffffff8023e670>] ? sys_rt_sigaction+0x7a/0x98
:  [<ffffffff80238360>] ? sys_wait4+0x8a/0xa1
:  [<ffffffff8020be4b>] ? system_call_after_swapgs+0x7b/0x80
: 
: 
: Code: 80 53 41 51 e8 83 d4 28 00 31 ff 48 89 c6 eb 2e 48 63 c7 48 c1 e0 05 48 8d 44 28 40 48 8d 48 08 48 8b 40 08 48 8b 51 08 48 85 c0 <48> 89 02 74 04 48 89 50 08 48 c7 41 08 00 02 20 00 ff c7 3b 7d 
: RIP  [<ffffffff802444f5>] free_pid+0x35/0x8e
:  RSP <ffff81025754de58>
: CR2: 0000000000200200
: ---[ end trace efde415d3f801416 ]---
: BUG: sleeping function called from invalid context at kernel/rwsem.c:21
: in_atomic():0, irqs_disabled():1
: Pid: 3132, comm: ifup-eth Tainted: G      D   2.6.25-rc2-mm1 #5
: 
: Call Trace:
:  [<ffffffff804d0c0a>] down_read+0x15/0x23
:  [<ffffffff802550cc>] acct_collect+0x40/0x180
:  [<ffffffff802385fd>] do_exit+0x1f3/0x6ba
:  [<ffffffff804d1ea1>] sync_regs+0x0/0x67
:  [<ffffffff804d3c02>] do_page_fault+0x755/0x80e
:  [<ffffffff804d1ae9>] error_exit+0x0/0x51
:  [<ffffffff802444f5>] free_pid+0x35/0x8e
:  [<ffffffff802444d3>] free_pid+0x13/0x8e
:  [<ffffffff80237727>] release_task+0x152/0x2e5
:  [<ffffffff80237f81>] do_wait+0x6c7/0xa1c
:  [<ffffffff8022f4cc>] default_wake_function+0x0/0xe
:  [<ffffffff8023e670>] sys_rt_sigaction+0x7a/0x98
:  [<ffffffff80238360>] sys_wait4+0x8a/0xa1
:  [<ffffffff8020be4b>] system_call_after_swapgs+0x7b/0x80
: 
: eth0: no IPv6 routers present
: 

and I don't have a clue which patch caused it and I won't be near this
machine again for over a week.

