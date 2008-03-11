Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYCKCNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYCKCNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYCKCMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:12:52 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:15423 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYCKCMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:12:51 -0400
Message-ID: <47D5EA9C.1040404@ct.jp.nec.com>
Date: Mon, 10 Mar 2008 19:12:44 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, hpj@urpla.net,
       stable <stable@kernel.org>
Subject: Re: [PATCH] sched: fix race in schedule
References: <47D57770.50909@ct.jp.nec.com> <1205174197.8514.159.camel@twins>	 <47D593A5.5060906@ct.jp.nec.com> <1205181256.6241.320.camel@lappy>
In-Reply-To: <1205181256.6241.320.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-03-10 at 13:01 -0700, Hiroshi Shimamoto wrote:
> 
>> thanks, your patch looks nice to me.
>> I had focused setprio, on_rq=0 and running=1 situation, it makes me to
>> fix these functions.
>> But one point, I've just noticed. I'm not sure on same situation against
>> sched_rt. I think the pre_schedule() of rt has chance to drop rq lock.
>> Is it OK?
> 
> Ah, you are quite right, that'll teach me to rush out a patch just
> because dinner is ready :-). 
> 
> How about we submit the following patch for mainline and CC -stable to
> fix .23 and .24:
> 

Unfortunately, I encountered similar panic with this patch on -rt.
I'll look into this, again. I might have missed something...

Unable to handle kernel NULL pointer dereference at 0000000000000128 RIP:
 [<ffffffff802297f5>] pick_next_task_fair+0x2d/0x42
PGD 13dbb2067 PUD 15146a067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 3
Modules linked in:
Pid: 31981, comm: dbench Not tainted 2.6.24.3-rt3 #1
RIP: 0010:[<ffffffff802297f5>]  [<ffffffff802297f5>] pick_next_task_fair+0x2d/0x42
RSP: 0018:ffff8101d75b5b38  EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000639
RDX: ffff810005009680 RSI: 0000000000000003 RDI: ffff8100050216e0
RBP: ffff8101d75b5b48 R08: ffff81000501dac0 R09: 0000000000000002
R10: ffff8101d75b5b08 R11: ffff81000501dac0 R12: ffff810005009680
R13: 0000000000000000 R14: ffff810005021680 R15: 00000001002ee6d0
FS:  00002b93ea5fe6f0(0000) GS:ffff81022fd28bc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000128 CR3: 000000013dbca000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process dbench (pid: 31981, threadinfo ffff8101d75b4000, task ffff8101515f4100)
Stack:  ffff8101d75b5b48 0000000000000000 ffff8101d75b5bd8 ffffffff804d98d5
 ffff8101d75b5ba0 ffffffff8022f2b6 00000003e9550280 ffff8101515f4100
 ffff8101d75b5b98 ffff8101515f4440 00000000000000ff ffffffff804db74f
Call Trace:
 [<ffffffff804d98d5>] __schedule+0x414/0x775
 [<ffffffff8022f2b6>] add_preempt_count+0x18/0xb2
 [<ffffffff804db74f>] __spin_unlock+0x14/0x2e
 [<ffffffff804d9f30>] schedule+0xdf/0xff
 [<ffffffff804da77d>] rt_spin_lock_slowlock+0xf9/0x19e
 [<ffffffff804db100>] __rt_spin_lock+0x6b/0x70
 [<ffffffff804db10e>] rt_spin_lock+0x9/0xb
 [<ffffffff802de7f0>] journal_invalidatepage+0xdd/0x282
 [<ffffffff802d149f>] ext3_invalidatepage+0x38/0x3a
 [<ffffffff8026e6cf>] do_invalidatepage+0x23/0x25
 [<ffffffff8026ecf5>] truncate_complete_page+0x30/0x4e
 [<ffffffff8026eddb>] truncate_inode_pages_range+0xc8/0x302
 [<ffffffff8026f022>] truncate_inode_pages+0xd/0xf
 [<ffffffff802d1956>] ext3_delete_inode+0x18/0xd8
 [<ffffffff802d193e>] ext3_delete_inode+0x0/0xd8
 [<ffffffff8029d307>] generic_delete_inode+0x7b/0xfb
 [<ffffffff8029d39e>] generic_drop_inode+0x17/0x16f
 [<ffffffff8029c898>] iput+0x7c/0x80
 [<ffffffff8029433b>] do_unlinkat+0xf5/0x150
 [<ffffffff8028d8a6>] sys_newstat+0x31/0x3c
 [<ffffffff802943a7>] sys_unlink+0x11/0x13
 [<ffffffff8020c19e>] system_call+0x7e/0x83
Code: 48 8b bb 28 01 00 00 48 85 ff 75 dd 48 8d 43 b8 41 58 5b 5d
RIP  [<ffffffff802297f5>] pick_next_task_fair+0x2d/0x42
 RSP <ffff8101d75b5b38>

thanks,
Hiroshi Shimamoto
