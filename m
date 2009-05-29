Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbZE2Xep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbZE2Xep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 19:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZE2Xeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 19:34:37 -0400
Received: from newpeace.netnation.com ([204.174.223.7]:47620 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751825AbZE2Xeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 19:34:37 -0400
X-Greylist: delayed 1179 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 May 2009 19:34:36 EDT
Date: Fri, 29 May 2009 16:14:55 -0700
From: Simon Kirby <sim@netnation.com>
To: linux-kernel@vger.kernel.org
Subject: [Oops] EXT3 / journal / possibly NFS-tickled issues
Message-ID: <20090529231455.GA14665@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!  Happy Friday...

We have a Linux HA NFS "NAS" setup (with heartbeat et al) that has been
backended with about 40 TB of storage.  LVM and AOE are in use, and
there are about 40 1 TB EXT3 file systems.  The kernel is vanilla amd64
2.6.28.10 except that I've built DRBD (unused) and newer AOE into it
(sorry).

Over the past few months, the file systems have been through a lot
(in particular, the bnx2 scatter-gather jumbo frame firmware bugs have
corrupted memory a few times), so don't assume that the EXT3 metadata
is at all consistent, although a lot of fscking has occurred.

Since there are a number of possibly-related issues that are occurring, I
will list them all here.  These errors and and Oopses are occurring at
mostly consistent intervals across both boxes and and across reboots, and
as such are reproducible other than I do not know what is triggering
them.

We have been seeing a number of these errors occurring about 4 to 50
times daily:

May 27 08:46:34 nas02 kernel: EXT3-fs warning (device dm-18): ext3_unlink: Deleting nonexistent file (105070649), 0
May 27 11:29:10 nas02 kernel: EXT3-fs warning (device dm-6): ext3_unlink: Deleting nonexistent file (129958170), 0
May 27 13:30:34 nas02 kernel: EXT3-fs warning (device dm-0): ext3_unlink: Deleting nonexistent file (51102071), 0
May 27 15:10:59 nas02 kernel: EXT3-fs warning (device dm-1): ext3_unlink: Deleting nonexistent file (72155364), 0
May 27 17:08:54 nas02 kernel: EXT3-fs warning (device dm-6): ext3_unlink: Deleting nonexistent file (53855397), 0
May 27 19:00:28 nas02 kernel: EXT3-fs warning (device dm-29): ext3_unlink: Deleting nonexistent file (16220197), 0

More recently, this seems to be occurring one a day or so (though I have
no idea from which file system):

May 27 20:14:27 nas02 kernel: EXT3 Inode ffff8800b62eaa30: orphan list check failed!
May 27 20:14:27 nas02 kernel: ffff8800b62eaa30: 0a83106c 0a83106d 0a83106e 0a83109a 
May 27 20:14:27 nas02 kernel: ffff8800b62eaa40: 0a8310a7 0a8310aa 0a831109 0a831341 
May 27 20:14:27 nas02 kernel: ffff8800b62eaa50: 0a83134c 0a83135f 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eaa60: 00000000 00000000 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eaa70: 00000000 00000000 00000000 0541803f 
May 27 20:14:27 nas02 kernel: ffff8800b62eaa80: 00001506 00000000 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eaa90: 00000000 223d6e67 4ffd0068 ffff8801 
May 27 20:14:27 nas02 kernel: ffff8800b62eaaa0: d04a41d0 ffff8803 0000979f 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eaab0: 3c3e0000 61206474 00000001 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eaac0: b62eaac0 ffff8800 b62eaac0 ffff8800 
May 27 20:14:27 nas02 kernel: ffff8800b62eaad0: 00000000 00000000 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eaae0: 00100100 00000000 00200200 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eaaf0: b62eaaf0 ffff8800 b62eaaf0 ffff8800 
May 27 20:14:27 nas02 kernel: ffff8800b62eab00: b62eab00 ffff8800 b62eab00 ffff8800 
May 27 20:14:27 nas02 kernel: ffff8800b62eab10: 054180d6 00000000 00000000 fffffffe 
May 27 20:14:27 nas02 kernel: ffff8800b62eab20: 000f8c79 000f8c79 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eab30: 00000001 00000000 0000979f 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eab40: 4a1daaf2 00000000 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eab50: 4a1daaf2 00000000 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eab60: 4a1de32d 00000000 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eab70: 0000000c 00000000 00000050 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eab80: 81a40000 00001a1a 00000001 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eab90: b62eab90 ffff8800 b62eab90 ffff8800 
May 27 20:14:27 nas02 kernel: ffff8800b62eaba0: 00000000 00000000 b62eaba8 ffff8800 
May 27 20:14:27 nas02 kernel: ffff8800b62eabb0: b62eaba8 ffff8800 806bee80 ffffffff 
May 27 20:14:27 nas02 kernel: ffff8800b62eabc0: 806beda0 ffffffff c560f000 ffff8803 
May 27 20:14:27 nas02 kernel: ffff8800b62eabd0: 00000000 00000000 b62eabe0 ffff8800 
May 27 20:14:27 nas02 kernel: ffff8800b62eabe0: b62eaad0 ffff8800 00000000 00000020
May 27 20:14:27 nas02 kernel: ffff8800b62eabf0: 00000000 00000000 00003434 00000000
May 27 20:14:27 nas02 kernel: ffff8800b62eac00: 00000000 00000000 00010001 00000000
May 27 20:14:27 nas02 kernel: ffff8800b62eac10: b62eac10 ffff8800 b62eac10 ffff8800
May 27 20:14:27 nas02 kernel: ffff8800b62eac20: 00000000 00000000 00000000 00000000
May 27 20:14:27 nas02 kernel: ffff8800b62eac30: 0000000a 00000000 806bf0c0 ffffffff 
May 27 20:14:27 nas02 kernel: ffff8800b62eac40: 001200d2 00000000 3fab5548 ffff8804 
May 27 20:14:27 nas02 kernel: ffff8800b62eac50: 00001414 00000000 b62eac58 ffff8800 
May 27 20:14:27 nas02 kernel: ffff8800b62eac60: b62eac58 ffff8800 00000000 00000000
May 27 20:14:27 nas02 kernel: ffff8800b62eac70: 00000000 00000000 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eac80: b62eac80 ffff8800 b62eac80 ffff8800 
May 27 20:14:27 nas02 kernel: ffff8800b62eac90: 00000000 00000000 00000000 cc44edf1 
May 27 20:14:27 nas02 kernel: ffff8800b62eaca0: 00000000 00000000 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eacb0: b62eacb0 ffff8800 b62eacb0 ffff8800 
May 27 20:14:27 nas02 kernel: ffff8800b62eacc0: 00000001 00000000 b62eacc8 ffff8800 
May 27 20:14:27 nas02 kernel: ffff8800b62eacd0: b62eacc8 ffff8800 00000040 00000000
May 27 20:14:27 nas02 kernel: ffff8800b62eace0: 05ce3e27 00000001 00000000 00000000 
May 27 20:14:27 nas02 kernel: ffff8800b62eacf0: 00000000 00000000 
May 27 20:14:27 nas02 kernel: Pid: 411, comm: kswapd0 Not tainted 2.6.28.10-hw #1
May 27 20:14:27 nas02 kernel: Call Trace:
May 27 20:14:27 nas02 kernel:  [<ffffffff8030b0e6>] ext3_destroy_inode+0x66/0x80
May 27 20:14:27 nas02 kernel:  [<ffffffff802b55ae>] destroy_inode+0x2e/0x50
May 27 20:14:27 nas02 kernel:  [<ffffffff802b60f7>] dispose_list+0xa7/0x120
May 27 20:14:27 nas02 kernel:  [<ffffffff802b6347>] shrink_icache_memory+0x1d7/0x2e0
May 27 20:14:27 nas02 kernel:  [<ffffffff80280fa5>] shrink_slab+0x125/0x180
May 27 20:14:27 nas02 kernel:  [<ffffffff80281dd3>] kswapd+0x3c3/0x5c0
May 27 20:14:27 nas02 kernel:  [<ffffffff8027f0f0>] ? isolate_pages_global+0x0/0x290
May 27 20:14:27 nas02 kernel:  [<ffffffff80255110>] ? autoremove_wake_function+0x0/0x40
May 27 20:14:27 nas02 kernel:  [<ffffffff80281a10>] ? kswapd+0x0/0x5c0
May 27 20:14:27 nas02 kernel:  [<ffffffff80254c9d>] kthread+0x4d/0x80 
May 27 20:14:27 nas02 kernel:  [<ffffffff8020d659>] child_rip+0xa/0x11
May 27 20:14:27 nas02 kernel:  [<ffffffff80254c50>] ? kthread+0x0/0x80
May 27 20:14:27 nas02 kernel:  [<ffffffff8020d64f>] ? child_rip+0x0/0x11

Finally, after no other messages for ~4 hours, this Oops triggered
another fail-over event:

May 29 04:09:48 nas02 kernel: ------------[ cut here ]------------
May 29 04:09:48 nas02 kernel: WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x75/0x90()
May 29 04:09:48 nas02 kernel: Modules linked in: drbd cn aoe xt_MARK e1000e bnx2 zlib_inflate
May 29 04:09:48 nas02 kernel: Pid: 16334, comm: kjournald Not tainted 2.6.28.10-hw #1
May 29 04:09:48 nas02 kernel: Call Trace:
May 29 04:09:48 nas02 kernel:  [<ffffffff8023f57f>] warn_on_slowpath+0x5f/0x80
May 29 04:09:48 nas02 kernel:  [<ffffffff8040bc60>] ? generic_make_request+0x230/0x440
May 29 04:09:48 nas02 kernel:  [<ffffffff806a1d69>] ? _spin_lock+0x9/0x10
May 29 04:09:48 nas02 kernel:  [<ffffffff803147f6>] ? journal_free_journal_head+0x16/0x20
May 29 04:09:48 nas02 kernel:  [<ffffffff8029d573>] ? __slab_free+0x1e3/0x330
May 29 04:09:48 nas02 kernel:  [<ffffffff803147f6>] ? journal_free_journal_head+0x16/0x20
May 29 04:09:48 nas02 kernel:  [<ffffffff802c4015>] mark_buffer_dirty+0x75/0x90
May 29 04:09:48 nas02 kernel:  [<ffffffff8030f824>] __journal_temp_unlink_buffer+0xa4/0x140
May 29 04:09:48 nas02 kernel:  [<ffffffff8030fa81>] __journal_unfile_buffer+0x11/0x20
May 29 04:09:48 nas02 kernel:  [<ffffffff80311d7f>] journal_commit_transaction+0x3cf/0xf50
May 29 04:09:48 nas02 kernel:  [<ffffffff8023923b>] ? finish_task_switch+0x3b/0xc0
May 29 04:09:48 nas02 kernel:  [<ffffffff80226b69>] ? default_spin_lock_flags+0x9/0x10
May 29 04:09:48 nas02 kernel:  [<ffffffff806a1f32>] ? _spin_lock_irqsave+0x32/0x50
May 29 04:09:48 nas02 kernel:  [<ffffffff80249e48>] ? try_to_del_timer_sync+0x58/0x70
May 29 04:09:48 nas02 kernel:  [<ffffffff80315d78>] kjournald+0xe8/0x250
May 29 04:09:48 nas02 kernel:  [<ffffffff80255110>] ? autoremove_wake_function+0x0/0x40
May 29 04:09:48 nas02 kernel:  [<ffffffff80315c90>] ? kjournald+0x0/0x250
May 29 04:09:48 nas02 kernel:  [<ffffffff80254c9d>] kthread+0x4d/0x80
May 29 04:09:48 nas02 kernel:  [<ffffffff8020d659>] child_rip+0xa/0x11
May 29 04:09:48 nas02 kernel:  [<ffffffff80254c50>] ? kthread+0x0/0x80
May 29 04:09:48 nas02 kernel:  [<ffffffff8020d64f>] ? child_rip+0x0/0x11
May 29 04:09:48 nas02 kernel: ---[ end trace e041847d9d183680 ]---
May 29 04:09:48 nas02 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
May 29 04:09:48 nas02 kernel: IP: [<ffffffff802c3fd5>] mark_buffer_dirty+0x35/0x90
May 29 04:09:48 nas02 kernel: PGD 3b0958067 PUD 3b0959067 PMD 0 
May 29 04:09:48 nas02 kernel: Oops: 0000 [#1] SMP 
May 29 04:09:48 nas02 kernel: last sysfs file: /sys/block/sda/stat
May 29 04:09:48 nas02 kernel: CPU 2 
May 29 04:09:48 nas02 kernel: Modules linked in: drbd cn aoe xt_MARK e1000e bnx2 zlib_inflate
May 29 04:09:48 nas02 kernel: Pid: 16334, comm: kjournald Tainted: G        W  2.6.28.10-hw #1
May 29 04:09:48 nas02 kernel: RIP: 0010:[<ffffffff802c3fd5>]  [<ffffffff802c3fd5>] mark_buffer_dirty+0x35/0x90
May 29 04:09:48 nas02 kernel: RSP: 0018:ffff8803b25e5d50  EFLAGS: 00010246
May 29 04:09:48 nas02 kernel: RAX: 0000000000000000 RBX: ffff8803d04a41d0 RCX: ffffffff804ae700
May 29 04:09:48 nas02 kernel: RDX: ffff8800a76ee000 RSI: 0000000000000082 RDI: 0000000000000000
May 29 04:09:48 nas02 kernel: RBP: ffff8803b25e5d60 R08: 0000000000000000 R09: ffff8800000bb660
May 29 04:09:48 nas02 kernel: R10: 0000000000000001 R11: 0000000000000020 R12: ffff8803915c8b40
May 29 04:09:48 nas02 kernel: R13: ffff8803d04a41d0 R14: ffff8803915c8b40 R15: ffff8803b3694a00
May 29 04:09:48 nas02 kernel: FS:  0000000000000000(0000) GS:ffff88043f802a80(0000) knlGS:0000000000000000
May 29 04:09:48 nas02 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
May 29 04:09:48 nas02 kernel: CR2: 0000000000000000 CR3: 00000003b37d0000 CR4: 00000000000006e0
May 29 04:09:48 nas02 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 29 04:09:48 nas02 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 29 04:09:48 nas02 kernel: Process kjournald (pid: 16334, threadinfo ffff8803b25e4000, task ffff8803c04f3d40)
May 29 04:09:48 nas02 kernel: Stack:
May 29 04:09:48 nas02 kernel:  ffff8803c960f800 ffff880093c91f60 ffff8803b25e5d90 ffffffff8030f824
May 29 04:09:48 nas02 kernel:  0000000000000000 ffff880093c91f60 ffff880093c91f60 ffff8803b3694b54
May 29 04:09:48 nas02 kernel:  ffff8803b25e5db0 ffffffff8030fa81 0000000000000010 ffff8803d04a41d0
May 29 04:09:48 nas02 kernel: Call Trace:
May 29 04:09:48 nas02 kernel:  [<ffffffff8030f824>] __journal_temp_unlink_buffer+0xa4/0x140
May 29 04:09:48 nas02 kernel:  [<ffffffff8030fa81>] __journal_unfile_buffer+0x11/0x20
May 29 04:09:48 nas02 kernel:  [<ffffffff80311d7f>] journal_commit_transaction+0x3cf/0xf50
May 29 04:09:48 nas02 kernel:  [<ffffffff8023923b>] ? finish_task_switch+0x3b/0xc0
May 29 04:09:48 nas02 kernel:  [<ffffffff80226b69>] ? default_spin_lock_flags+0x9/0x10
May 29 04:09:48 nas02 kernel:  [<ffffffff806a1f32>] ? _spin_lock_irqsave+0x32/0x50
May 29 04:09:48 nas02 kernel:  [<ffffffff80249e48>] ? try_to_del_timer_sync+0x58/0x70
May 29 04:09:48 nas02 kernel:  [<ffffffff80315d78>] kjournald+0xe8/0x250
May 29 04:09:48 nas02 kernel:  [<ffffffff80255110>] ? autoremove_wake_function+0x0/0x40
May 29 04:09:48 nas02 kernel:  [<ffffffff80315c90>] ? kjournald+0x0/0x250
May 29 04:09:48 nas02 kernel:  [<ffffffff80254c9d>] kthread+0x4d/0x80
May 29 04:09:48 nas02 kernel:  [<ffffffff8020d659>] child_rip+0xa/0x11
May 29 04:09:48 nas02 kernel:  [<ffffffff80254c50>] ? kthread+0x0/0x80
May 29 04:09:48 nas02 kernel:  [<ffffffff8020d64f>] ? child_rip+0x0/0x11
May 29 04:09:48 nas02 kernel: Code: ec 08 48 8b 07 a8 01 74 47 a8 02 74 08 0f ae f0 f6 03 02 75 0b f0 0f ba 2b 01 19 c0 85 c0 74 07 48 83 c4 08 5b c9 c3 48 8b 7b 10 <66> 83 3f 00 48 8b 77 18 78 45 40 f6 c6 01 b8 00 00 00 00 48 0f 
May 29 04:09:48 nas02 kernel: RIP  [<ffffffff802c3fd5>] mark_buffer_dirty+0x35/0x90
May 29 04:09:48 nas02 kernel:  RSP <ffff8803b25e5d50>
May 29 04:09:48 nas02 kernel: CR2: 0000000000000000
May 29 04:09:48 nas02 kernel: ---[ end trace e041847d9d183680 ]---

Kernel config, dmesg, etc., available here:

	http://0x.ca/sim/ref/oops/2009-05-29/0/

Simon-
