Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbZHZOpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbZHZOpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZHZOpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:45:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZHZOpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:45:42 -0400
Subject: [RFC][PATCH -rt] sched: fully ignore RT tasks for CFS
 load-balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 16:44:35 +0200
Message-Id: <1251297875.18584.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since -rt runs IRQs and SoftIRQs as RT tasks and load-balancing is done
from softirq context, there is always at least one RT task (and very
likely multiple) running when we balance.

The current (and totally broken) interaction between RT tasks and CFS
load-balancing makes it so that we'll try to evacuate a significant
amount of tasks due to RT tasks being runnable.

Solve this in another broken way by not accounting RT tasks at all.

This will likely break another class of cases, but until we can properly
fix this, we might as well do this.

Chucked-on-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_rt.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index adcbc68..385d31f 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -926,8 +926,6 @@ static void enqueue_task_rt(struct rq *rq, struct
task_struct *p, int wakeup)
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
-
-	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int
sleep)
@@ -942,8 +940,6 @@ static void dequeue_task_rt(struct rq *rq, struct
task_struct *p, int sleep)
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
-
-	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*

