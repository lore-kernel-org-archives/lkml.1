Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968Ab0AVRN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0AVRN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956Ab0AVRNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:13:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:41418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942Ab0AVRNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:13:52 -0500
Date: Fri, 22 Jan 2010 17:13:04 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, cbe@osadl.org, mathias.weber.mw1@roche.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, mathias.weber.mw1@roche.com, cbe@osadl.org,
       tglx@linutronix.de
In-Reply-To: <20100120171629.809074113@linutronix.de>
References: <20100120171629.809074113@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Queue a deboosted task to the head of the RT prio queue
Message-ID: <tip-60db48cacb9b253d5607a5ff206112a59cd09e34@git.kernel.org>
Git-Commit-ID: 60db48cacb9b253d5607a5ff206112a59cd09e34
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jan 2010 17:13:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60db48cacb9b253d5607a5ff206112a59cd09e34
Gitweb:     http://git.kernel.org/tip/60db48cacb9b253d5607a5ff206112a59cd09e34
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 20 Jan 2010 20:59:06 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 22 Jan 2010 18:09:59 +0100

sched: Queue a deboosted task to the head of the RT prio queue

rtmutex_set_prio() is used to implement priority inheritance for
futexes. When a task is deboosted it gets enqueued at the tail of its
RT priority list. This is violating the POSIX scheduling semantics:

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
Acked-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Carsten Emde <cbe@osadl.org>
Tested-by: Mathias Weber <mathias.weber.mw1@roche.com>
LKML-Reference: <20100120171629.809074113@linutronix.de>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f47560f..a56ead4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4237,7 +4237,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, 0, false);
+		enqueue_task(rq, p, 0, oldprio < prio);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
