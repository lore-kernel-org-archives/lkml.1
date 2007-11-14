Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbXKNPSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbXKNPSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbXKNPSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:18:18 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:40888 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbXKNPSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:18:17 -0500
Date: Wed, 14 Nov 2007 18:17:08 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Grant Wilson <grant.wilson@zen.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc1-gb4f5550 oops
Message-ID: <20071114151708.GA12355@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Wilson wrote:
>
> [18073.371126] Unable to handle kernel NULL pointer dereference at 0000000000000120 RIP:
> [18073.371134]  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> [18073.371144] PGD 81f9067 PUD 81c8067 PMD 0
> [18073.371151] Oops: 0000 [1] PREEMPT SMP
> [18073.371157] CPU 2
> [18073.371161] Modules linked in: vfat fat
> [18073.371168] Pid: 4639, comm: kwin Not tainted 2.6.24-rc1 #1
> [18073.371171] RIP: 0010:[<ffffffff8023572e>]  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> [18073.371177] RSP: 0018:ffff810008531a78  EFLAGS: 00010006
> [18073.371179] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [18073.371183] RDX: ffff810004441bf0 RSI: ffff81000801e860 RDI: ffff81000444ab80
> [18073.371186] RBP: ffff810008531aa8 R08: 000000d0d47a4a90 R09: 0000000000000000
> [18073.371188] R10: ffff810004441bf0 R11: 0000000000000001 R12: ffff810006520400
> [18073.371190] R13: ffff81000801e860 R14: ffff81000a63a000 R15: ffff81000443d8e0
> [18073.371193] FS:  00002b7d646a86f0(0000) GS:ffff810004c11780(0000) knlGS:0000000000000000
> [18073.371196] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [18073.371199] CR2: 0000000000000120 CR3: 0000000008495000 CR4: 00000000000006e0
> [18073.371202] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [18073.371211] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [18073.371214] Process kwin (pid: 4639, threadinfo ffff810008530000, task ffff81000840a860)
> [18073.371216] Stack:  ffff81000444ab80 0000000000000001 ffff81000801e860 ffff81000444ab80
> [18073.371231]  0000000000000002 ffff81000443d8e0 ffff810008531b38 ffffffff8023061e
> [18073.371238]  0000000000000000 ffff810004441b80 0000000000000002 0000000100000000
> [18073.371245] Call Trace:
> [18073.371250]  [<ffffffff8023061e>] try_to_wake_up+0x2fe/0x3a0

I suspect I see the bug in that area, but I am not sure it can explain this
trace completely.

Suppose that the SCHED_FIFO task does

	switch_uid(new_user);

Now, p->se.cfs_rq and p->se.parent both point into the old user_struct->tg
because sched_move_task() doesn't call set_task_cfs_rq() for !fair_sched_class
case.

Suppose that old user_struct/task_group is freed/reused, and the task does

	sched_setscheduler(SCHED_NORMAL);

__setscheduler() sets fair_sched_class, but doesn't update ->se.cfs_rq/parent
which point to the freed memory.

This means that check_preempt_wakeup() doing

		while (!is_same_group(se, pse)) {
			se = parent_entity(se);
			pse = parent_entity(pse);
		}

may OOPS in a similar way if rq->curr or p did something like above.

Perhaps we need something like the patch below, note that __setscheduler()
can't do set_task_cfs_rq().

Oleg.

--- kernel/sched.c	2007-11-14 17:32:21.000000000 +0300
+++ -	2007-11-14 18:14:00.245492756 +0300
@@ -7068,8 +7068,10 @@ void sched_move_task(struct task_struct 
 
 	rq = task_rq_lock(tsk, &flags);
 
-	if (tsk->sched_class != &fair_sched_class)
+	if (tsk->sched_class != &fair_sched_class) {
+		set_task_cfs_rq(tsk);
 		goto done;
+	}
 
 	update_rq_clock(rq);
 

