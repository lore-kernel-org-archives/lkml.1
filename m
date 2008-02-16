Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYBPN6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYBPN6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 08:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYBPN6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 08:58:45 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:41180 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbYBPN6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 08:58:44 -0500
Date: Sat, 16 Feb 2008 17:02:12 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] do_signal_stop: use signal_group_exit()
Message-ID: <20080216140212.GA1421@tv-sign.ru>
References: <20080215180204.GA4359@tv-sign.ru> <20080215193756.9e5b8205.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215193756.9e5b8205.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Andrew Morton wrote:
>
> ug.  On about the fourth boot with the current -mm lineup I hit:
>
> : BUG: unable to handle kernel paging request at 0000000000200200
                                                   ^^^^^^^^^^^^^^^^
== LIST_POISON2

> : IP: [<ffffffff802444f5>] free_pid+0x35/0x8e

most probably == hlist_del_rcu(pid_chain)

> : PGD 2574cb067 PUD 257561067 PMD 0 
> : Oops: 0002 [1] SMP 
> : last sysfs file: /sys/class/net/eth0/address
> : CPU 2 
> : Modules linked in: ipv6 dm_mirror dm_multipath dm_mod sbs sbshc dock battery ac parport_pc lp parport snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq shpchp snd_seq_device sg snd_pcm_oss snd_mixer_oss snd_pcm floppy snd_timer button i2c_i801 snd soundcore ide_cd_mod cdrom serio_raw i2c_core snd_page_alloc pcspkr ehci_hcd ohci_hcd uhci_hcd
> : Pid: 3132, comm: ifup-eth Not tainted 2.6.25-rc2-mm1 #5
> : RIP: 0010:[<ffffffff802444f5>]  [<ffffffff802444f5>] free_pid+0x35/0x8e
> : RSP: 0018:ffff81025754de58  EFLAGS: 00010046
> : RAX: 0000000000000000 RBX: ffff81025f268840 RCX: ffff81025f263f08
> : RDX: 0000000000200200 RSI: 0000000000000046 RDI: 0000000000000000
> : RBP: ffff81025f263ec0 R08: ffff81025f268b18 R09: ffff81025f268b08
> : R10: ffff81025f268b08 R11: 0000000000000000 R12: ffff810259853140
> : R13: 0000000000000c78 R14: 0000000000000000 R15: 0000000000000000
> : FS:  00007f8f9ba7d6f0(0000) GS:ffff81025f16f0c0(0000) knlGS:0000000000000000
> : CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> : CR2: 0000000000200200 CR3: 00000002598d0000 CR4: 00000000000006e0
> : DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> : DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> : Process ifup-eth (pid: 3132, threadinfo ffff81025754c000, task ffff81025d467620)
> : Stack:  ffff81025f268b08 ffff81025f268840 ffff81025994b660 ffffffff80237727
> :  ffff81025994b660 ffff81025994b660 0000000000000000 ffffffff80237f81
> :  00000000000005d0 ffff810257561018 0000000000000000 00007fffa3aa9514
> : Call Trace:
> :  [<ffffffff80237727>] ? release_task+0x152/0x2e5
> :  [<ffffffff80237f81>] ? do_wait+0x6c7/0xa1c
> :  [<ffffffff8022f4cc>] ? default_wake_function+0x0/0xe
> :  [<ffffffff8023e670>] ? sys_rt_sigaction+0x7a/0x98
> :  [<ffffffff80238360>] ? sys_wait4+0x8a/0xa1
> :  [<ffffffff8020be4b>] ? system_call_after_swapgs+0x7b/0x80

(Can't understand why there is no detach_pid() in this stack trace,
 but it is the only possible caller of free_pid()).

So, detach_pid()->free_pid() hit an already unhashed pid. But this
is not possible?

This means we already did detach_pid(), but in that case the previous
detach_pid() has set task->pids[].pid = NULL, and we should OOPS earlier,
somewhere at "if (!hlist_empty(&pid->tasks[tmp]))".

> and I don't have a clue which patch caused it and I won't be near this
> machine again for over a week.

Definitely not this patch...

I'll try to think more about this, but I doubt very much I'll find the
reason :(

Oleg.

