Return-Path: <linux-kernel-owner+w=401wt.eu-S936173AbXHIIgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936173AbXHIIgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbXHIIgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:36:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36291 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbXHIIgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:36:11 -0400
Date: Thu, 9 Aug 2007 10:36:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Mitchell Erblich <erblichs@earthlink.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question: RT schedular : task_tick_rt(struct rq *rq, struct
	task_struct *p) : decreases overhead when rq->nr_running == 1
Message-ID: <20070809083606.GA24130@elte.hu>
References: <000501c7d945$f30af1a0$6501a8c0@earthlink.net> <20070808123418.GA30248@elte.hu> <b647ffbd0708090111r50d29dbp779e014db1a63296@mail.gmail.com> <20070809082656.GA21973@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809082656.GA21973@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, that's the patch i applied:

--------------------------->
Subject: sched: optimize task_tick_rt() a bit
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Mitchell Erblich suggested a change to not requeue SCHED_RR
tasks if there's only a single task on the runqueue, by
checking for rq->nr_running == 1.

provide a more efficient implementation of that, to check that
particular RT priority-queue only.

[ From: mingo@elte.hu ]

Also first requeue the task then set need_resched - results
in slightly better machine-instruction ordering. Also clean
up the code a bit.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux/kernel/sched_rt.c
===================================================================
--- linux.orig/kernel/sched_rt.c
+++ linux/kernel/sched_rt.c
@@ -207,10 +207,15 @@ static void task_tick_rt(struct rq *rq, 
 		return;
 
 	p->time_slice = static_prio_timeslice(p->static_prio);
-	set_tsk_need_resched(p);
 
-	/* put it at the end of the queue: */
-	requeue_task_rt(rq, p);
+	/*
+	 * Requeue to the end of queue if we are not the only element
+	 * on the queue:
+	 */
+	if (p->run_list.prev != p->run_list.next) {
+		requeue_task_rt(rq, p);
+		set_tsk_need_resched(p);
+	}
 }
 
 static struct sched_class rt_sched_class __read_mostly = {
