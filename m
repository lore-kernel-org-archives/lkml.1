Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbXKNPbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbXKNPbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbXKNPaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:30:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343AbXKNPay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:30:54 -0500
Date: Wed, 14 Nov 2007 16:29:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Wilson <grant.wilson@zen.co.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc1-gb4f5550 oops
Message-ID: <20071114152930.GA1690@elte.hu>
References: <20071114151708.GA12355@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114151708.GA12355@tv-sign.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > [18073.371126] Unable to handle kernel NULL pointer dereference at 0000000000000120 RIP:
> > [18073.371134]  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> > [18073.371144] PGD 81f9067 PUD 81c8067 PMD 0
> > [18073.371151] Oops: 0000 [1] PREEMPT SMP
> > [18073.371157] CPU 2
> > [18073.371161] Modules linked in: vfat fat
> > [18073.371168] Pid: 4639, comm: kwin Not tainted 2.6.24-rc1 #1
> > [18073.371171] RIP: 0010:[<ffffffff8023572e>]  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> > [18073.371177] RSP: 0018:ffff810008531a78  EFLAGS: 00010006
> > [18073.371179] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > [18073.371183] RDX: ffff810004441bf0 RSI: ffff81000801e860 RDI: ffff81000444ab80
> > [18073.371186] RBP: ffff810008531aa8 R08: 000000d0d47a4a90 R09: 0000000000000000
> > [18073.371188] R10: ffff810004441bf0 R11: 0000000000000001 R12: ffff810006520400
> > [18073.371190] R13: ffff81000801e860 R14: ffff81000a63a000 R15: ffff81000443d8e0
> > [18073.371193] FS:  00002b7d646a86f0(0000) GS:ffff810004c11780(0000) knlGS:0000000000000000
> > [18073.371196] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [18073.371199] CR2: 0000000000000120 CR3: 0000000008495000 CR4: 00000000000006e0
> > [18073.371202] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [18073.371211] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [18073.371214] Process kwin (pid: 4639, threadinfo ffff810008530000, task ffff81000840a860)
> > [18073.371216] Stack:  ffff81000444ab80 0000000000000001 ffff81000801e860 ffff81000444ab80
> > [18073.371231]  0000000000000002 ffff81000443d8e0 ffff810008531b38 ffffffff8023061e
> > [18073.371238]  0000000000000000 ffff810004441b80 0000000000000002 0000000100000000
> > [18073.371245] Call Trace:
> > [18073.371250]  [<ffffffff8023061e>] try_to_wake_up+0x2fe/0x3a0
> 
> I suspect I see the bug in that area, but I am not sure it can explain 
> this trace completely.

there's a fix pending from Dmitry - please see below. It took days for 
Grant to trigger the crash so it needs some time to be confirmed but it 
could explain the crash in theory.

	Ingo

---------------------->
Subject: sched: fix __set_task_cpu() SMP race
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Grant Wilson has reported rare SCHED_FAIR_USER crashes on his quad-core 
system, which crashes can only be explained via runqueue corruption.

there is a narrow SMP race in __set_task_cpu(): after ->cpu is set up to 
a new value, task_rq_lock(p, ...) can be successfuly executed on another 
CPU. We must ensure that updates of per-task data have been completed by 
this moment.

this bug has been hiding in the Linux scheduler for an eternity (we 
never had any explicit barrier for task->cpu in set_task_cpu() - so the 
bug was introduced in 2.5.1), but only became visible via 
set_task_cfs_rq() being accidentally put after the task->cpu update. It 
also probably needs a sufficiently out-of-order CPU to trigger.

Reported-by: Grant Wilson <grant.wilson@zen.co.uk>
Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -217,15 +217,15 @@ static inline struct task_group *task_gr
 }
 
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
-static inline void set_task_cfs_rq(struct task_struct *p)
+static inline void set_task_cfs_rq(struct task_struct *p, unsigned int cpu)
 {
-	p->se.cfs_rq = task_group(p)->cfs_rq[task_cpu(p)];
-	p->se.parent = task_group(p)->se[task_cpu(p)];
+	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
+	p->se.parent = task_group(p)->se[cpu];
 }
 
 #else
 
-static inline void set_task_cfs_rq(struct task_struct *p) { }
+static inline void set_task_cfs_rq(struct task_struct *p, unsigned int cpu) { }
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
@@ -1023,10 +1023,16 @@ unsigned long weighted_cpuload(const int
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
+	set_task_cfs_rq(p, cpu);
 #ifdef CONFIG_SMP
+	/*
+	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
+	 * successfuly executed on another CPU. We must ensure that updates of
+	 * per-task data have been completed by this moment.
+	 */
+	smp_wmb();
 	task_thread_info(p)->cpu = cpu;
 #endif
-	set_task_cfs_rq(p);
 }
 
 #ifdef CONFIG_SMP
@@ -7111,7 +7117,7 @@ void sched_move_task(struct task_struct 
 			tsk->sched_class->put_prev_task(rq, tsk);
 	}
 
-	set_task_cfs_rq(tsk);
+	set_task_cfs_rq(tsk, task_cpu(tsk));
 
 	if (on_rq) {
 		if (unlikely(running))
