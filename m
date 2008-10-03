Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYJCRWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYJCRWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYJCRVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:21:49 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:48797
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753878AbYJCRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:21:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RT PATCH v2 2/2] RT: remove "paranoid" limit in push_rt_task
To: Chirag Jog <chirag@linux.vnet.ibm.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, dvhltc@us.ibm.com, dino@in.ibm.com,
       Gilles.Carry@bull.net
Date: Fri, 03 Oct 2008 13:26:18 -0400
Message-ID: <20081003172618.23714.55546.stgit@dev.haskins.net>
In-Reply-To: <20081003172221.23714.71575.stgit@dev.haskins.net>
References: <20081003172221.23714.71575.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A panic was discovered by Chirag Jog and investigated by Gilles Carry
to be originating in the fact that a task being pushed away
may get migrated away during a double_lock_balance.  The result was
that the pushable_tasks list may become corrupted.

The root cause is that the "paranoid" retry limit could cause us to
bail out of a retry, but still try to remove the item from the (now
potentially incorrect) list.  There are numerous ways to correct the
condition, but the paranoid feature is no longer relevant with the new
pushable logic (since pushable naturally limits the loop anyway), so
lets just remove it.

Reported By: Chirag Jog <chirag@linux.vnet.ibm.com>
Found-by: Gilles Carry <gilles.carry@bull.net>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 59ead84..201bd97 100644
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
+			 * If we get here, the task hasnt moved it all, but
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

