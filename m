Return-Path: <linux-kernel-owner+w=401wt.eu-S932721AbYA2Ry4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbYA2Ry4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763938AbYA2Ryj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:54:39 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:30873 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbYA2Ryi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:54:38 -0500
Date: Tue, 29 Jan 2008 09:54:26 -0800
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: mike.miller@hp.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
       jens.axboe@oracle.com
Subject: kernel BUG at drivers/block/cciss.c:1260! (with recent linux-2.6
	tree)
Message-ID: <20080129175426.GJ12400@plap3.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 29 Jan 2008 17:54:36.0810 (UTC) FILETIME=[03342EA0:01C862A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitting a consistent BUG() with recent Linus' linux-2.6.git:

	[   12.941428] ------------[ cut here ]------------
	[   12.944874] kernel BUG at drivers/block/cciss.c:1260!
	[   12.944874] invalid opcode: 0000 [1] SMP 
	[   12.944874] CPU 0 
	[   12.944874] Modules linked in:
	[   12.944874] Pid: 0, comm: swapper Not tainted 2.6.24 #43
	[   12.944874] RIP: 0010:[<ffffffff8039e43d>]  [<ffffffff8039e43d>] cciss_softirq_done+0xbc/0x1bf
	[   12.944874] RSP: 0018:ffffffff8063aed0  EFLAGS: 00010202
	[   12.944874] RAX: 0000000000000001 RBX: ffff8100cf800010 RCX: ffff81042f1253b0
	[   12.944874] RDX: ffff81042de398f0 RSI: ffff81042de398f0 RDI: 0000000000000001
	[   12.944874] RBP: ffff81042daa0000 R08: ffff81042f1253b0 R09: 0000000000000001
	[   12.944874] R10: 00000000000000fe R11: 0000000000000000 R12: 0000000000000002
	[   12.944874] R13: 0000000000000001 R14: ffff8100cf800000 R15: ffff81042de398f0
	[   12.944874] FS:  0000000000000000(0000) GS:ffffffff805bb000(0000) knlGS:0000000000000000
	[   12.944874] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
	[   12.944874] CR2: 00002afed7eea340 CR3: 000000042dbba000 CR4: 00000000000006e0
	[   12.944874] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
	[   12.944874] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
	[   12.944874] Process swapper (pid: 0, threadinfo ffffffff805f4000, task ffffffff805624a0)
	[   12.944874] Stack:  0000000000000000 ffffffff8063af10 0000000000000001 ffffffff80632d60
	[   12.944874]  0000000000000000 000000000000000a ffffffff805bb900 ffffffff8032038f
	[   12.944874]  ffffffff8063af10 ffffffff8063af10 ffffffff805bb940 ffffffff802346b4
	[   12.944874] Call Trace:
	[   12.944874]  <IRQ>  [<ffffffff8032038f>] blk_done_softirq+0x69/0x78
	[   12.944874]  [<ffffffff802346b4>] __do_softirq+0x6f/0xd8
	[   12.944874]  [<ffffffff8020c45c>] call_softirq+0x1c/0x30
	[   12.944874]  [<ffffffff8020e347>] do_softirq+0x30/0x80
	[   12.944874]  [<ffffffff8020e409>] do_IRQ+0x72/0xd9
	[   12.944874]  [<ffffffff8020a50a>] mwait_idle+0x0/0x46
	[   12.944874]  [<ffffffff8020a3da>] default_idle+0x0/0x3d
	[   12.944874]  [<ffffffff8020b7e1>] ret_from_intr+0x0/0xa
	[   12.944874]  <EOI>  [<ffffffff8020a54c>] mwait_idle+0x42/0x46
	[   12.944874]  [<ffffffff8020a481>] cpu_idle+0x6a/0xae
	[   12.944874] 
	[   12.944874] 
	[   12.944874] Code: 0f 0b eb fe 48 8d 85 d8 c0 00 00 48 89 04 24 48 89 c7 e8 e5 
	[   12.944874] RIP  [<ffffffff8039e43d>] cciss_softirq_done+0xbc/0x1bf
	[   12.944874]  RSP <ffffffff8063aed0>
	[   12.944903] ---[ end trace e9c631603f90d22f ]---

code in question is in drivers/block/cciss.c:cciss_softirq_done():

	...
        if (blk_end_request(rq, (rq->errors == 0) ? 0 : -EIO, blk_rq_bytes(rq)))
                BUG();

And appears to be a result of a recent merge:

	commit f0f0052069989b80d2a3e50c9cd2f2a650bc1aea
	Refs: v2.6.24-1949-gf0f0052
	Merge: 68fbda7... a65b586...
	Author: Linus Torvalds <torvalds@linux-foundation.org>
	Date:   Tue Jan 29 08:51:32 2008 +1100

	    Merge branch 'blk-end-request' of git://git.kernel.dk/linux-2.6-block

Here's the commit which added the blk_end_request() BUG() on:

	commit 3daeea29f9348263e0dda89a565074390475bdf8
	Refs: v2.6.24-1743-g3daeea2
	Author: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
	Date:   Tue Dec 11 17:50:03 2007 -0500

	    blk_end_request: changing cciss (take 4)

	    This patch converts cciss to use blk_end_request interfaces.
	    Related 'uptodate' arguments are converted to 'error'.

	    cciss is a little bit different from "normal" drivers.
	    cciss directly calls bio_endio() and disk_stat_add()
	    when completing request.  But those can be replaced with
	    __end_that_request_first().
	    After the replacement, request completion procedures of
	    those drivers become like the following:
		o end_that_request_first()
		o add_disk_randomness()
		o end_that_request_last()
	    This can be converted to blk_end_request() by following
	    the rule (a) mentioned in the patch subject
	    "[PATCH 01/30] blk_end_request: add new request completion interface".

	    Cc: Mike Miller <mike.miller@hp.com>
	    Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
	    Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
	    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

--
av
