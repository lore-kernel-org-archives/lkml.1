Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZGFUao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZGFUao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbZGFUah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:30:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40938 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbZGFUag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:30:36 -0400
Subject: Re: kernel BUG at fs/notify/notification.c:93!
From: Eric Paris <eparis@redhat.com>
To: "Mikko C." <mikko.cal@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <4A4F6C1D.5060803@gmail.com>
References: <4A4F0FD4.7070009@gmail.com>
	 <1246718455.20265.2.camel@dhcp235-23.rdu.redhat.com>
	 <4A4F6C1D.5060803@gmail.com>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 16:30:28 -0400
Message-Id: <1246912228.2866.51.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-04 at 16:50 +0200, Mikko C. wrote:
> Eric Paris wrote:
> >
> > This is the first time I've heard about it.  I'm looking for the problem
> > but I don't see it right offhand.  Is there anything you know of that
> > causes it?  I'm looking though....
> >   
> 
> No, sorry - it seems very random to me. Most of the times the related 
> process is krunner.
> But sometimes it can be something else, for example firefox:

Mikko sent a third trace offlist, even more interesting since this one
looks like we are hitting things with LIST_POISON1, which looks friggin
impossible to me as I never call list_del() on the anchor of the list
and the only way we run the list is via the list_for_each_entry() macro
starting at the anchor.  So how in the hell can LIST_POISON1 ever be
possible?  I'm at a loss, but haven't given up yet.  All running,
addition, and removal of the list are done holding a spin_lock declared
in the same struct as the list anchor (struct fsnotify_event -> lock).  

Anyone have suggestions on common ways someone can end up with
LIST_POISON1 biting them?

 BUG: unable to handle kernel paging request at 0000000000100100
 IP: [<ffffffff810dba99>] fsnotify_remove_priv_from_event+0x29/0x70
 PGD 68f2b067 PUD 68f2c067 PMD 0
 Oops: 0000 [#1] PREEMPT SMP
 last sysfs file: 00/device:00/PNP0C0A:00/power_supply/BAT0/charge_full
 CPU 1
 Modules linked in: radeon drm snd_seq snd_seq_device vfat fat coretemp hwmon cpufreq_ondemand fan iwl3945 usb_storage iwlcore mac80211 led_class snd_hda_codec_idt snd_hda_intel cfg80211 snd_hda_codec snd_pcm snd_timer snd psmouse dell_laptop soundcore evdev uhci_hcd snd_page_alloc rfkill ehci_hcd wmi ac button battery thermal
 Pid: 5653, comm: dolphin Not tainted 2.6.31-rc2 #1 MM061
 RIP: 0010:[<ffffffff810dba99>]  [<ffffffff810dba99>] fsnotify_remove_priv_from_event+0x29/0x70       
 RSP: 0018:ffff880068ddfe60  EFLAGS: 00010206
 RAX: ffff880072ef6ab8 RBX: ffff880072e2e5c0 RCX: 0000000000100100
 RDX: 00000000001000f8 RSI: ffff880072e2e600 RDI: ffff88007eee00c0
 RBP: 0000000000000020 R08: 0000000002244470 R09: ffff88007b348540
 R10: 000000000219b080 R11: 0000000000000246 R12: ffff880072e2e5a8
 R13: 00007ffff5ac6970 R14: 0000000000000000 R15: ffff88007eee00c0
 FS:  00007f1afd69e750(0000) GS:ffff88000166a000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000100100 CR3: 0000000068f2a000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process dolphin (pid: 5653, threadinfo ffff880068dde000, task ffff88007f8f4140)
 Stack:

 ffffffff810de304 0000000000000020 00007ffff5ac6970 ffff88007b348540
 <0> ffff88007eee0118 ffff88007eee00e8 00007ffff5ac7c9c 0000000000000000
 <0> ffff88007f8f4140 ffffffff81051c20 ffff88007eee0120 ffff88007eee0120
 Call Trace:

 [<ffffffff810de304>] ?  inotify_read+0x184/0x310
 [<ffffffff81051c20>] ?  autoremove_wake_function+0x0/0x30
 [<ffffffff810ba80b>] ?  do_vfs_ioctl+0x3fb/0x580
 [<ffffffff810ac528>] ?  vfs_read+0xc8/0x1a0
 [<ffffffff810ac703>] ?  sys_read+0x53/0xa0
 [<ffffffff8100b3eb>] ?  system_call_fastpath+0x16/0x1b



