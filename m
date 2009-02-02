Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZBBCIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZBBCIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 21:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZBBCIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 21:08:30 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:48151 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbZBBCI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 21:08:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQEADfehUlMQWt2/2dsb2JhbACBbcRThBQG
Date: Sun, 1 Feb 2009 21:08:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090202020811.GA19565@Krystal>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal> <20090120073709.GC30821@kernel.dk> <20090120122855.GF30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090120122855.GF30821@kernel.dk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:02:22 up 32 days,  2:00,  8 users,  load average: 0.71, 0.52,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I tried your patch at

http://bugzilla.kernel.org/attachment.cgi?id=20001

On a 2.6.29-rc3 kernel. I get the following OOPS just after I start
running the fio test. It happens after a few

cfq: moving ffff88043d4b42e0 to dispatch                         
cfq: moving ffff88043d4b4170 to dispatch                        

messages (~20).

Here is the oops :

------------[ cut here ]------------
kernel BUG at block/cfq-iosched.c:650!
invalid opcode: 0000 [#1] PREEMPT SMP
LTT NESTING LEVEL : 0
last sysfs file: /sys/block/sda/stat
CPU 2
Modules linked in: loop ltt_tracer ltt_trace_control ltt_userspa]
Pid: 2934, comm: kjournald Not tainted 2.6.29-rc3 #3
RIP: 0010:[<ffffffff80419c2b>]  [<ffffffff80419c2b>] cfq_remove_0
RSP: 0018:ffff88043b167c20  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff88043fd9e088 RCX: 0000000000000001
RDX: 0000000000000010 RSI: ffff88043887b590 RDI: ffff88043887b590
RBP: ffff88043b167c50 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88043fd9e088
R13: ffff88043887b590 R14: ffff88043fc40200 R15: ffff88043fd9e088
FS:  0000000000000000(0000) GS:ffff88043e81a080(0000) knlGS:00000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f2a5f98b8c0 CR3: 000000043e8c4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kjournald (pid: 2934, threadinfo ffff88043b166000, task )
Stack:
 000000000000003b ffff88043887b590 ffff88043fd9e088 ffff88043e5a0
 ffff88043fc40200 ffff88002809ed50 ffff88043b167c80 ffffffff8041d
 0000000000000001 ffff88043887b590 ffffe2001b805138 ffff88043e5a0
Call Trace:
 [<ffffffff80419e4d>] cfq_dispatch_insert+0x3d/0x70
 [<ffffffff80419f2f>] cfq_wait_on_page+0xaf/0xc0
 [<ffffffff804098ed>] elv_wait_on_page+0x1d/0x20
 [<ffffffff8040d207>] blk_backing_dev_wop+0x17/0x50
 [<ffffffff80301872>] sync_buffer+0x52/0x80
 [<ffffffff806a33b2>] __wait_on_bit+0x62/0x90
 [<ffffffff80301820>] ? sync_buffer+0x0/0x80
 [<ffffffff80301820>] ? sync_buffer+0x0/0x80
 [<ffffffff806a3459>] out_of_line_wait_on_bit+0x79/0x90
 [<ffffffff8025a8a0>] ? wake_bit_function+0x0/0x50
 [<ffffffff80301769>] __wait_on_buffer+0xf9/0x130
 [<ffffffff80379acd>] journal_commit_transaction+0x72d/0x1650
 [<ffffffff806a5c87>] ? _spin_unlock_irqrestore+0x47/0x80
 [<ffffffff8024dd2f>] ? try_to_del_timer_sync+0x5f/0x70
 [<ffffffff8037e488>] kjournald+0xe8/0x250
 [<ffffffff8025a860>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8037e3a0>] ? kjournald+0x0/0x250
 [<ffffffff8025a38e>] kthread+0x4e/0x90
 [<ffffffff8025a340>] ? kthread+0x0/0x90
 [<ffffffff8020db2a>] child_rip+0xa/0x20
 [<ffffffff8020d480>] ? restore_args+0x0/0x30
 [<ffffffff8025a340>] ? kthread+0x0/0x90
 [<ffffffff8020db20>] ? child_rip+0x0/0x20
Code: 4d 89 6d 00 49 8b 9d c0 00 00 00 41 8b 45 48 4c 8b 73 08 2
RIP  [<ffffffff80419c2b>] cfq_remove_request+0x6b/0x250
 RSP <ffff88043b167c20>
---[ end trace eab134a8bd405d05 ]---

It seems that the cfqq->queued[sync] counter should either be
incremented/decremented in the new cfq_wait_on_page, or that the fact
that the type of request (sync vs !sync) changes would not be taken care
of correctly. I have not looked at the code enough to find out exactly
what is happening, but I though you might have an idea of the cause.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
