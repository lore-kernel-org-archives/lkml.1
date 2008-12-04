Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbYLDPZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbYLDPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYLDPZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:25:49 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:23353 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYLDPZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:25:49 -0500
Message-ID: <4937F65F.2040404@hp.com>
Date: Thu, 04 Dec 2008 10:25:19 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: kernel BUG at block/blk-timeout.c:178!
References: <4937E888.3060208@hp.com>
In-Reply-To: <4937E888.3060208@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(First: It seems to be easily reproduced - 3 for 3.)

Interestingly, if I add a test forward :

diff --git a/block/elevator.c b/block/elevator.c
index 9ac82dd..c2c8342 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -586,6 +586,7 @@ void elv_insert(struct request_queue *q, struct
request *rq,
        unsigned ordseq;
        int unplug_it = 1;

+       BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
        blk_add_trace_rq(q, rq, BLK_TA_INSERT);

        rq->q = q;

the problem moves with it:

------------[ cut here ]------------
kernel BUG at block/elevator.c:589!
invalid opcode: 0000 [#1] SMP
last sysfs file:
CPU 0
Pid: 268, comm: scsi_wq_0 Not tainted 2.6.28-rc6 #14
RIP: 0010:[<ffffffff804e278e>]  [<ffffffff804e278e>] elv_insert+0x25e/0x270
RSP: 0018:ffff88087cd4f8c0  EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffff88087b6d52c8 RCX: 00000000fffee229
RDX: 0000000000000001 RSI: ffff88087b6d52c8 RDI: ffff88087cd57670
RBP: ffff88087cd4f8e0 R08: 0000000000000000 R09: ffff88087cd57670
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88087cd57670
R13: ffff88087cd57670 R14: ffff88087cdf5920 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffffffff80f76980(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process scsi_wq_0 (pid: 268, threadinfo ffff88087cd4e000, task
ffff88087ba9c040)
Stack:
 ffff88087b6d52c8 ffff88087cd57670 0000000000000001 ffff88087cdf5920
 ffff88087cd4f910 ffffffff804e281b 0000000000200200 0000000000000001
 ffff88087b6d52c8 ffff88087cd57670 ffff88087cd4f940 ffffffff804e7d5e
Call Trace:
 [<ffffffff804e281b>] __elv_add_request+0x7b/0xd0
 [<ffffffff804e7d5e>] blk_execute_rq_nowait+0x5e/0xb0
 [<ffffffff804e7e0d>] blk_execute_rq+0x5d/0xb0
 [<ffffffff80308c80>] ? sysfs_ilookup_test+0x0/0x20
 [<ffffffff8063012e>] hp_sw_tur+0xbe/0x230
 [<ffffffff8062ecd6>] ? scsi_dh_handler_lookup+0x56/0xb0
 [<ffffffff806305d8>] hp_sw_bus_attach+0x58/0x160
 [<ffffffff8062ebb2>] scsi_dh_handler_attach+0x32/0x40
 [<ffffffff8062f0ea>] scsi_dh_notifier+0x6a/0xa0
 [<ffffffff8025f3df>] notifier_call_chain+0x3f/0x80
 [<ffffffff8025f7f8>] __blocking_notifier_call_chain+0x58/0x80
 [<ffffffff8025f831>] blocking_notifier_call_chain+0x11/0x20
 [<ffffffff805b4713>] device_add+0x133/0x650
 [<ffffffff805ba51c>] ? attribute_container_device_trigger+0xbc/0xd0
 [<ffffffff80612954>] scsi_sysfs_add_sdev+0x64/0x280
 [<ffffffff80610389>] scsi_probe_and_add_lun+0xdb9/0xde0
 [<ffffffff80610a17>] __scsi_scan_target+0x4d7/0x6f0
 [<ffffffff806112f0>] scsi_scan_target+0xc0/0xd0
 [<ffffffff8061c307>] fc_scsi_scan_rport+0xb7/0xc0
 [<ffffffff8061c250>] ? fc_scsi_scan_rport+0x0/0xc0
 [<ffffffff80256c70>] run_workqueue+0x70/0x120
 [<ffffffff80256d80>] worker_thread+0x60/0xb0
 [<ffffffff8025aca0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80256d20>] ? worker_thread+0x0/0xb0
 [<ffffffff8025a8e9>] kthread+0x49/0x80
 [<ffffffff8020d269>] child_rip+0xa/0x11
 [<ffffffff8025a8a0>] ? kthread+0x0/0x80
 [<ffffffff8020d25f>] ? child_rip+0x0/0x11
Code: 89 ef 0f 1f 00 e8 53 20 00 00 0f 1f 00 e9 29 fe ff ff 49 8b 44 24
08 4c 89 23 49 89 5c 24 08 48 89 18 48 89 43 08 e9 10 fe ff ff <0f> 0b
eb fe 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
RIP  [<ffffffff804e278e>] elv_insert+0x25e/0x270
 RSP <ffff88087cd4f8c0>
---[ end trace 0bd30bab78e129e5 ]---



