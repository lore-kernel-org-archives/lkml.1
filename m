Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428Ab0ATVAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0ATVAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308Ab0ATU76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:59:58 -0500
Received: from www.tglx.de ([62.245.132.106]:43014 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0ATU7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:59:55 -0500
Message-Id: <20100120171629.809074113@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 20 Jan 2010 20:59:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Carsten Emde <cbe@osadl.org>,
       Mathias Weber <mathias.weber.mw1@roche.com>
Subject: [patch 3/3] sched: Queue a deboosted task to the head of the RT
	priority queue
References: <20100120171231.922420383@linutronix.de>
Content-Disposition: inline;
	filename=rtmutex-set-prio-fix-deboost-enqueueing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtmutex_set_prio() is used to implement priority inheritance for
futexes. When a task is deboosted it gets enqueued at the tail of its RT
priority list. This is violating the POSIX scheduling semantics:

rt priority list X contains two runnable tasks A and B

task A	 runs with priority X and holds mutex M
task C	 preempts A and is blocked on mutex M 
     	 -> task A is boosted to priority of task C (Y)
task A	 unlocks the mutex M and deboosts itself
     	 -> A is dequeued from rt priority list Y
	 -> A is enqueued to the tail of rt priority list X
task C	 schedules away
task B	 runs

This is wrong as task A did not schedule away and therefor violates
the POSIX scheduling semantics.

Enqueue the task to the head of the priority list instead. 

Reported-by: Mathias Weber <mathias.weber.mw1@roche.com>
Reported-by: Carsten Emde <cbe@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -6066,7 +6066,7 @@ void rt_mutex_setprio(struct task_struct
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, 0, false);
+		enqueue_task(rq, p, 0, oldprio < prio);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}


