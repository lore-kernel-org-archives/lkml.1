Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYBGUEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYBGUEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758831AbYBGUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:38645 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbYBGUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tNiankLuXmz1XbOlSC8j+SSWhqJTCUC2o/sGh1UBzeAc9NLS8eO5l9uD/ybtqKAucJzS7T29FNU2ZKSeLwEP0Qg848zFjtEdOoDmcWEorddp5qPeLE0bbDHU1+NGSy7XUt7e8F6Ozdh/29CsHqcE2w+uLhq/J8FfgattdxfXVOE=
Message-ID: <6101e8c40802071203t29fcb4fk11ff1e7169bafdbd@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:14 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {02/14} - Panic in blk_rq_map_sg() from CCISS driver - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: cciss-panic-in-blk_rq_map_sg.patch

>From a683d652d334a546be9175b894f42dbd8e399536 Mon Sep 17 00:00:00 2001
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Date: Fri, 21 Sep 2007 08:33:55 +0200
Subject: [PATCH] Panic in blk_rq_map_sg() from CCISS driver

mainline: a683d652d334a546be9175b894f42dbd8e399536

New scatter/gather list chaining [sg_next()] treats 'page' member of
struct scatterlist with low bit set [0x01] as a chain pointer to
another struct scatterlist [array].  The CCISS driver request function
passes an uninitialized, temporary, on-stack scatterlist array to
blk_rq_map_sq().  sg_next() interprets random data on the stack as a
chain pointer and eventually tries to de-reference an invalid pointer,
resulting in:

[<ffffffff8031dd70>] blk_rq_map_sg+0x70/0x170
PGD 6090c3067 PUD 0
Oops: 0000 [1] SMP
last sysfs file: /block/cciss!c0d0/cciss!c0d0p1/dev
CPU 6
Modules linked in: ehci_hcd ohci_hcd uhci_hcd
Pid: 1, comm: init Not tainted 2.6.23-rc6-mm1 #3
RIP: 0010:[<ffffffff8031dd70>] [<ffffffff8031dd70>] blk_rq_map_sg+0x70/0x170
RSP: 0018:ffff81060901f768 EFLAGS: 00010206
RAX: 000000040b161000 RBX: ffff81060901f7d8 RCX: 000000040b162c00
RDX: 0000000000000000 RSI: ffff81060b13a260 RDI: ffff81060b139600
RBP: 0000000000001400 R08: 00000000fffffffe R09: 0000000000000400
R10: 0000000000000000 R11: 000000040b163000 R12: ffff810102fe0000
R13: 0000000000000001 R14: 0000000000000001 R15: 00001e0000000000
FS: 00000000026108f0(0063) GS:ffff810409000b80(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000010000001e CR3: 00000006090c6000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff81060901e000, task ffff810409020800)
last branch before last exception/interrupt
from [<ffffffff8031de0a>] blk_rq_map_sg+0x10a/0x170
to [<ffffffff8031dd70>] blk_rq_map_sg+0x70/0x170
Stack: 000000018068ea00 ffff810102fe0000 0000000000000000 ffff810011400000
0000000000000002 0000000000000000 ffff81040b172000 ffffffff803acd3d
0000000000003ec1 ffff8106090d5000 ffff8106090d5000 ffff810102fe0000
Call Trace:
[<ffffffff803acd3d>] do_cciss_request+0x15d/0x4c0
[<ffffffff80298968>] new_slab+0x1c8/0x270
[<ffffffff80298ffd>] __slab_alloc+0x22d/0x470
[<ffffffff8027327b>] mempool_alloc+0x4b/0x130
[<ffffffff8032b21e>] cfq_set_request+0xee/0x380
[<ffffffff8027327b>] mempool_alloc+0x4b/0x130
[<ffffffff8031ff98>] get_request+0x168/0x360
[<ffffffff80331b0d>] rb_insert_color+0x8d/0x110
[<ffffffff8031cfd8>] elv_rb_add+0x58/0x60
[<ffffffff8032a329>] cfq_add_rq_rb+0x69/0xa0
[<ffffffff8031c1ab>] elv_merged_request+0x5b/0x60
[<ffffffff803224fd>] __make_request+0x23d/0x650
[<ffffffff80298ffd>] __slab_alloc+0x22d/0x470
[<ffffffff80270000>] generic_write_checks+0x140/0x190
[<ffffffff8031f012>] generic_make_request+0x1c2/0x3a0
<etc>
Kernel panic - not syncing: Attempted to kill init!

This patch initializes the tmp_sg array to zeroes.  Perhaps not the ultimate
fix, but an effective work-around.  I can now boot 23-rc6-mm1 on an HP
Proliant x86_64 with CCISS boot disk.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>

 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 55c3237..2023d61 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2570,6 +2570,7 @@ static void do_cciss_request(struct request_queue *q)
 	       (int)creq->nr_sectors);
 #endif				/* CCISS_DEBUG */

+	memset(tmp_sg, 0, sizeof(tmp_sg));
 	seg = blk_rq_map_sg(q, creq, tmp_sg);

 	/* get the DMA records for the setup */


-- 
Thanks,
Oliver
