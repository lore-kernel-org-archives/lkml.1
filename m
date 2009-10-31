Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbZJaGOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbZJaGOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 02:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZJaGOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 02:14:44 -0400
Received: from cobra.newdream.net ([66.33.216.30]:37231 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZJaGOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 02:14:43 -0400
Date: Fri, 30 Oct 2009 23:14:47 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: ext3/jbd oops in journal_start
Message-ID: <Pine.LNX.4.64.0910302253100.1867@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm consistently seeing ext3 oops on a fresh ~60 GB fs on 2.6.32-rc3 (and 
2.6.31).  data=writeback or data=ordered.  It's not the hardware or 
drive... I have 8 boxes (each with slightly different hardware) that crash 
identically.

The oops is at fs/jbd/transaction.c, journal_start():

		J_ASSERT(handle->h_transaction->t_journal == journal);

because handle->h_transaction is 0x1bf (or some other value close to 
that).  I can trigger on the 10th or so call to journal_start after 
mounting.

Has anyone seen this before?  I feel like I must be doing something silly 
here, since I can't find any references to this particular crash, but I'm 
having no problem triggering it right away, even after a fresh mke2fs 
-j...

Any suggestions on where to look or should I just start testing older 
kernel versions and bisect?

sage


[   83.550657] handle->h_transaction 00000000000001bf
[   83.555564] BUG: unable to handle kernel NULL pointer dereference at 00000000000001bf
[   83.559531] IP: [<ffffffff8118793c>] journal_start+0x87/0x184
[   83.559531] PGD 10e351067 PUD 10e1cb067 PMD 0 
[   83.559531] Oops: 0000 [#1] PREEMPT SMP 
[   83.559531] last sysfs file: /sys/class/net/lo/operstate
[   83.559531] CPU 1 
[   83.559531] Modules linked in: btrfs zlib_deflate fan ac battery 
ide_pci_generic shpchp k8temp serio_raw psmouse pcspkr ehci_hcd 
serverworks processor ohci_hcd pci_hotplug thermal button
[   83.559531] Pid: 2849, comm: cosd Not tainted 2.6.32-rc5 #7 H8SSL-I2
[   83.559531] RIP: 0010:[<ffffffff8118793c>]  [<ffffffff8118793c>] journal_start+0x87/0x184
[   83.559531] RSP: 0018:ffff88010e335b28  EFLAGS: 00010292
[   83.559531] RAX: 00000000000001bf RBX: ffff88010eeee4e0 RCX: 000000000000ad01
[   83.559531] RDX: ffff88002f400000 RSI: 0000000000000001 RDI: ffffffff81610214
[   83.559531] RBP: ffff88010e335b58 R08: ffff88010e3359d7 R09: 0000000000000000
[   83.559531] R10: ffffffff8106314b R11: ffff88010e335908 R12: ffff88010eeee4e0
[   83.559531] R13: ffff88010e17a200 R14: ffff88010f535800 R15: 000000000000000b
[   83.559531] FS:  00007fe3bce8b6f0(0000) GS:ffff88002f400000(0000) knlGS:0000000000000000
[   83.559531] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   83.559531] CR2: 00000000000001bf CR3: 0000000110223000 CR4: 00000000000006e0
[   83.559531] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   83.559531] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   83.559531] Process cosd (pid: 2849, threadinfo ffff88010e334000, task ffff88010e17a200)
[   83.559531] Stack:
[   83.559531]  ffff88010e335b58 ffffffff814cbb10 ffffea0006cf6038 ffff88010eeea888
[   83.559531] <0> 0000000000000000 00000000000005f4 ffff88010e335b68 ffffffff811443b3
[   83.559531] <0> ffff88010e335c08 ffffffff8113c347 ffff88010e335ca8 ffffffff81070369
[   83.559531] Call Trace:
[   83.559531]  [<ffffffff811443b3>] ext3_journal_start_sb+0x4a/0x4c
[   83.559531]  [<ffffffff8113c347>] ext3_write_begin+0x9c/0x1e2
[   83.559531]  [<ffffffff81070369>] ? __lock_acquire+0x17d8/0x17ea
[   83.559531]  [<ffffffff810a5021>] generic_file_buffered_write+0x120/0x2a5
[   83.559531]  [<ffffffff810a564d>] __generic_file_aio_write+0x34f/0x383
[   83.559531]  [<ffffffff810a56e4>] generic_file_aio_write+0x63/0xaa
[   83.559531]  [<ffffffff810d98b2>] do_sync_write+0xe7/0x12d
[   83.559531]  [<ffffffff8105f368>] ? autoremove_wake_function+0x0/0x38
[   83.559531]  [<ffffffff8106a7fc>] ? put_lock_stats+0xe/0x27
[   83.559531]  [<ffffffff8125752c>] ? security_file_permission+0x11/0x13
[   83.559531]  [<ffffffff810da240>] vfs_write+0xae/0x14a
[   83.559531]  [<ffffffff810da3a0>] sys_write+0x47/0x6e
[   83.559531]  [<ffffffff8100baab>] system_call_fastpath+0x16/0x1b
[   83.559531] Code: 89 de 48 c7 c7 e9 01 61 81 31 c0 e8 71 f6 31 00 48 8b 
33 48 c7 c7 f7 01 61 81 31 c0 e8 60 f6 31 00 48 8b 03 48 c7 c7 14 02 61 81 
<48> 8b 30 31 c0 e8 4c f6 31 00 48 8b 03 48 8b 30 4c 39 f6 74 11 
[   83.559531] RIP  [<ffffffff8118793c>] journal_start+0x87/0x184
[   83.559531]  RSP <ffff88010e335b28>
[   83.559531] CR2: 00000000000001bf
[   83.847504] ---[ end trace 450f151cbabc2177 ]---

