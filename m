Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYJFPLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYJFPLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYJFPKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:10:17 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:45730
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753506AbYJFPKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:10:15 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RT PATCH v3 2/2] RT: fix push_rt_task() to handle dequeue_pushable
	properly
To: Chirag Jog <chirag@linux.vnet.ibm.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, dvhltc@us.ibm.com, dino@in.ibm.com,
       Gilles.Carry@bull.net
Date: Mon, 06 Oct 2008 11:14:43 -0400
Message-ID: <20081006151442.8452.7838.stgit@dev.haskins.net>
In-Reply-To: <20081006151228.8452.69938.stgit@dev.haskins.net>
References: <20081006151228.8452.69938.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A panic was discovered by Chirag Jog where a BUG_ON sanity check
in the new "pushable_task" logic would trigger a panic under
certain circumstances:

http://lkml.org/lkml/2008/9/25/189

Gilles Carry discovered that the root cause was attributed to the
pushable_tasks list getting corrupted in the push_rt_task logic.
This was the result of a dropped rq lock in double_lock_balance
allowing a task in the process of being pushed to potentially migrate
away, and thus corrupt the pushable_tasks() list.

I traced back the problem as introduced by the pushable_tasks patch
that went in recently.   There is a "retry" path in push_rt_task()
that actually had a compound conditional to decide whether to
retry or exit.  I missed the meaning behind the rationale for the
virtual "if(!task) goto out;" portion of the compound statement and
thus did not handle it properly.  The new pushable_tasks logic
actually creates three distinct conditions:

1) an untouched and unpushable task should be dequeued
2) a migrated task where more pushable tasks remain should be retried
3) a migrated task where no more pushable tasks exist should exit

The original logic mushed (1) and (3) together, resulting in the
system dequeuing a migrated task (against an unlocked foreign run-queue
nonetheless).

To fix this, we get rid of the notion of "paranoid" and we support the
three unique conditions properly.  The paranoid feature is no longer
relevant with the new pushable logic (since pushable naturally limits
the loop) anyway, so lets just remove it.

Reported-By: Chirag Jog <chirag@linux.vnet.ibm.com>
Found-by: Gilles Carry <gilles.carry@bull.net>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 59ead84..05a1d4a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1056,7 +1056,6 @@ static int push_rt_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
-	int paranoid = RT_MAX_TRIES;
 
 	if (!rq->rt.overloaded)
 		return 0;
@@ -1090,23 +1089,34 @@ static int push_rt_task(struct rq *rq)
 		struct task_struct *task;
 		/*
 		 * find lock_lowest_rq releases rq->lock
-		 * so it is possible that next_task has changed.
-		 * If it has, then try again.
+		 * so it is possible that next_task has migrated.
+		 *
+		 * We need to make sure that the task is still on the same
+		 * run-queue and is also still the next task eligible for
+		 * pushing.
 		 */
 		task = pick_next_pushable_task(rq);
-		if (unlikely(task != next_task) && task && paranoid--) {
-			put_task_struct(next_task);
-			next_task = task;
-			goto retry;
+		if (task_cpu(next_task) == rq->cpu && task == next_task) {
+			/*
+			 * If we get here, the task hasnt moved at all, but
+			 * it has failed to push.  We will not try again,
+			 * since the other cpus will pull from us when they
+			 * are ready.
+			 */
+			dequeue_pushable_task(rq, next_task);
+			goto out;
 		}
+		
+		if (!task)
+			/* No more tasks, just exit */
+			goto out;
 
 		/*
-		 * Once we have failed to push this task, we will not
-		 * try again, since the other cpus will pull from us
-		 * when they are ready
+		 * Something has shifted, try again.
 		 */
-		dequeue_pushable_task(rq, next_task);
-		goto out;
+		put_task_struct(next_task);
+		next_task = task;
+		goto retry;
 	}
 
 	deactivate_task(rq, next_task, 0);

