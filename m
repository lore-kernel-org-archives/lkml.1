Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZBBL21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZBBL21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbZBBL15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:27:57 -0500
Received: from brick.kernel.dk ([93.163.65.50]:21907 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866AbZBBL14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:27:56 -0500
Date: Mon, 2 Feb 2009 12:26:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090202112600.GE30821@kernel.dk>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal> <20090120073709.GC30821@kernel.dk> <20090120122855.GF30821@kernel.dk> <20090202020811.GA19565@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202020811.GA19565@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 01 2009, Mathieu Desnoyers wrote:
> Hi Jens,
> 
> I tried your patch at
> 
> http://bugzilla.kernel.org/attachment.cgi?id=20001
> 
> On a 2.6.29-rc3 kernel. I get the following OOPS just after I start
> running the fio test. It happens after a few
> 
> cfq: moving ffff88043d4b42e0 to dispatch                         
> cfq: moving ffff88043d4b4170 to dispatch                        
> 
> messages (~20).
> 
> Here is the oops :
> 
> ------------[ cut here ]------------
> kernel BUG at block/cfq-iosched.c:650!
> invalid opcode: 0000 [#1] PREEMPT SMP
> LTT NESTING LEVEL : 0
> last sysfs file: /sys/block/sda/stat
> CPU 2
> Modules linked in: loop ltt_tracer ltt_trace_control ltt_userspa]
> Pid: 2934, comm: kjournald Not tainted 2.6.29-rc3 #3
> RIP: 0010:[<ffffffff80419c2b>]  [<ffffffff80419c2b>] cfq_remove_0
> RSP: 0018:ffff88043b167c20  EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff88043fd9e088 RCX: 0000000000000001
> RDX: 0000000000000010 RSI: ffff88043887b590 RDI: ffff88043887b590
> RBP: ffff88043b167c50 R08: 0000000000000002 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88043fd9e088
> R13: ffff88043887b590 R14: ffff88043fc40200 R15: ffff88043fd9e088
> FS:  0000000000000000(0000) GS:ffff88043e81a080(0000) knlGS:00000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00007f2a5f98b8c0 CR3: 000000043e8c4000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kjournald (pid: 2934, threadinfo ffff88043b166000, task )
> Stack:
>  000000000000003b ffff88043887b590 ffff88043fd9e088 ffff88043e5a0
>  ffff88043fc40200 ffff88002809ed50 ffff88043b167c80 ffffffff8041d
>  0000000000000001 ffff88043887b590 ffffe2001b805138 ffff88043e5a0
> Call Trace:
>  [<ffffffff80419e4d>] cfq_dispatch_insert+0x3d/0x70
>  [<ffffffff80419f2f>] cfq_wait_on_page+0xaf/0xc0
>  [<ffffffff804098ed>] elv_wait_on_page+0x1d/0x20
>  [<ffffffff8040d207>] blk_backing_dev_wop+0x17/0x50
>  [<ffffffff80301872>] sync_buffer+0x52/0x80
>  [<ffffffff806a33b2>] __wait_on_bit+0x62/0x90
>  [<ffffffff80301820>] ? sync_buffer+0x0/0x80
>  [<ffffffff80301820>] ? sync_buffer+0x0/0x80
>  [<ffffffff806a3459>] out_of_line_wait_on_bit+0x79/0x90
>  [<ffffffff8025a8a0>] ? wake_bit_function+0x0/0x50
>  [<ffffffff80301769>] __wait_on_buffer+0xf9/0x130
>  [<ffffffff80379acd>] journal_commit_transaction+0x72d/0x1650
>  [<ffffffff806a5c87>] ? _spin_unlock_irqrestore+0x47/0x80
>  [<ffffffff8024dd2f>] ? try_to_del_timer_sync+0x5f/0x70
>  [<ffffffff8037e488>] kjournald+0xe8/0x250
>  [<ffffffff8025a860>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff8037e3a0>] ? kjournald+0x0/0x250
>  [<ffffffff8025a38e>] kthread+0x4e/0x90
>  [<ffffffff8025a340>] ? kthread+0x0/0x90
>  [<ffffffff8020db2a>] child_rip+0xa/0x20
>  [<ffffffff8020d480>] ? restore_args+0x0/0x30
>  [<ffffffff8025a340>] ? kthread+0x0/0x90
>  [<ffffffff8020db20>] ? child_rip+0x0/0x20
> Code: 4d 89 6d 00 49 8b 9d c0 00 00 00 41 8b 45 48 4c 8b 73 08 2
> RIP  [<ffffffff80419c2b>] cfq_remove_request+0x6b/0x250
>  RSP <ffff88043b167c20>
> ---[ end trace eab134a8bd405d05 ]---
> 
> It seems that the cfqq->queued[sync] counter should either be
> incremented/decremented in the new cfq_wait_on_page, or that the fact
> that the type of request (sync vs !sync) changes would not be taken care
> of correctly. I have not looked at the code enough to find out exactly
> what is happening, but I though you might have an idea of the cause.

Just ignore the patch for now, I'm not going to be spending more time on
it. It was just an attempt at a quick test, I don't think this approach
is very feasible since it doesn't appear to be the root of the problem.
In any case, were we to continue on this path, the accounting logic in
CFQ would have to be adjusted for this new behaviour. Otherwise there's
a big risk of giving great preference to async writeout once things get
tight.

It's also working around the real problem for this specific issue, which
is that you just don't want to have sync apps blocked waiting for async
writeout in the first place.

-- 
Jens Axboe

