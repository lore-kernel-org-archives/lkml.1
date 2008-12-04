Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbYLDO0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbYLDO0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYLDO02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:26:28 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:42968 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbYLDO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:26:24 -0500
Message-ID: <4937E888.3060208@hp.com>
Date: Thu, 04 Dec 2008 09:26:16 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>
Subject: kernel BUG at block/blk-timeout.c:178!
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'll be checking into reproducibility &c., but for now...)

Using git tree as of:

commit 6a1214113090905aca6a492fc8ef10d84c608a69
Merge: c07f62e... 2642b11...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Dec 1 09:34:23 2008 -0800

    Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/ie

    * 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linu
      ieee1394: sbp2: fix race condition in state change
      ieee1394: fix list corruption (reported at module removal)
      firewire: fw-sbp2: another iPod mini quirk entry
      ieee1394: sbp2: another iPod mini quirk entry

I just got whilst booting (16-way AMD64, 126GB RAM, 3@CCISS, 4@QLA):

------------[ cut here ]------------
kernel BUG at block/blk-timeout.c:178!
invalid opcode: 0000 [#1] SMP
last sysfs file:
CPU 0
Pid: 268, comm: scsi_wq_0 Not tainted 2.6.28-rc6 #13
RIP: 0010:[<ffffffff804e8d4d>]  [<ffffffff804e8d4d>] blk_add_timer+0xdd/0xf0
RSP: 0018:ffff88087b6c3830  EFLAGS: 00010002
RAX: ffff88087cdf4408 RBX: ffff88087cded670 RCX: ffff88087cdf4408
RDX: ffff88087cded670 RSI: ffff88087cdf42c8 RDI: ffff88087cdf42c8
RBP: ffff88087b6c3840 R08: 0000000000000020 R09: ffff88087cded670
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000020
R13: ffff88087cdf42c8 R14: 0000000000000020 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffffffff80f76980(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process scsi_wq_0 (pid: 268, threadinfo ffff88087b6c2000, task
ffff88087bf706c0)
Stack:
 ffff88087cded670 ffff88087b6cf460 ffff88087b6c3850 ffffffff804e2308
 ffff88087b6c3890 ffffffff804e5566 ffff88087cded670 ffff88087cded670
 ffff88087cdf1800 ffff88087cded670 ffff88087cded670 ffff88087cdf42c8
Call Trace:
 [<ffffffff804e2308>] elv_dequeue_request+0x48/0x60
 [<ffffffff804e5566>] blk_queue_start_tag+0x96/0x130
 [<ffffffff8060c900>] scsi_request_fn+0x120/0x5a0
 [<ffffffff804e47db>] __generic_unplug_device+0x2b/0x40
 [<ffffffff804e7d56>] blk_execute_rq_nowait+0x66/0xb0
 [<ffffffff804e7dfd>] blk_execute_rq+0x5d/0xb0
 [<ffffffff80308c80>] ? sysfs_ilookup_test+0x0/0x20
 [<ffffffff8063011e>] hp_sw_tur+0xbe/0x230
 [<ffffffff8062ecc6>] ? scsi_dh_handler_lookup+0x56/0xb0
 [<ffffffff806305c8>] hp_sw_bus_attach+0x58/0x160
 [<ffffffff8062eba2>] scsi_dh_handler_attach+0x32/0x40
 [<ffffffff8062f0da>] scsi_dh_notifier+0x6a/0xa0
 [<ffffffff8025f3df>] notifier_call_chain+0x3f/0x80
 [<ffffffff8025f7f8>] __blocking_notifier_call_chain+0x58/0x80
 [<ffffffff8025f831>] blocking_notifier_call_chain+0x11/0x20
 [<ffffffff805b4703>] device_add+0x133/0x650
 [<ffffffff805ba50c>] ? attribute_container_device_trigger+0xbc/0xd0
 [<ffffffff80612944>] scsi_sysfs_add_sdev+0x64/0x280
 [<ffffffff80610379>] scsi_probe_and_add_lun+0xdb9/0xde0
 [<ffffffff80610a07>] __scsi_scan_target+0x4d7/0x6f0
 [<ffffffff806112e0>] scsi_scan_target+0xc0/0xd0
 [<ffffffff8061c2f7>] fc_scsi_scan_rport+0xb7/0xc0
 [<ffffffff8061c240>] ? fc_scsi_scan_rport+0x0/0xc0
 [<ffffffff80256c70>] run_workqueue+0x70/0x120
 [<ffffffff80256d80>] worker_thread+0x60/0xb0
 [<ffffffff8025aca0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80256d20>] ? worker_thread+0x0/0xb0
 [<ffffffff8025a8e9>] kthread+0x49/0x80
 [<ffffffff8020d269>] child_rip+0xa/0x11
 [<ffffffff8025a8a0>] ? kthread+0x0/0x80
 [<ffffffff8020d25f>] ? child_rip+0x0/0x11
Code: 48 8d bb 28 03 00 00 48 89 c6 e8 af 6f d6 ff 48 83 c4 08 5b c9 c3
48 8b 15 81 cb a9 00 89 c0 48 01 d0 48 89 87 38 01 00 00 eb 90 <0f> 0b
eb fe 0f 1f 80 00 00 00 00 0f 0b eb fe 0f 1f 40 00 55 48
RIP  [<ffffffff804e8d4d>] blk_add_timer+0xdd/0xf0
 RSP <ffff88087b6c3830>
---[ end trace 1d1b7db6f1a8b5dd ]---
