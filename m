Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbXLDVKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbXLDVKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbXLDVHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:07:15 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53451
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755203AbXLDVHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:07:13 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 09/23] Subject: SCHED - Consistency cleanup for this_rq usage
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:45:11 -0500
Message-ID: <20071204204511.3567.79678.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"this_rq" is normally used to denote the RQ on the current cpu
(i.e. "cpu_rq(this_cpu)").  So clean up the usage of this_rq to be
more consistent with the rest of the code.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index e5bce6a..d8f8738 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -326,21 +326,21 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
  * running task can migrate over to a CPU that is running a task
  * of lesser priority.
  */
-static int push_rt_task(struct rq *this_rq)
+static int push_rt_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
 	int ret = 0;
 	int paranoid = RT_MAX_TRIES;
 
-	assert_spin_locked(&this_rq->lock);
+	assert_spin_locked(&rq->lock);
 
-	next_task = pick_next_highest_task_rt(this_rq, -1);
+	next_task = pick_next_highest_task_rt(rq, -1);
 	if (!next_task)
 		return 0;
 
  retry:
-	if (unlikely(next_task == this_rq->curr)) {
+	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
 		return 0;
 	}
@@ -350,24 +350,24 @@ static int push_rt_task(struct rq *this_rq)
 	 * higher priority than current. If that's the case
 	 * just reschedule current.
 	 */
-	if (unlikely(next_task->prio < this_rq->curr->prio)) {
-		resched_task(this_rq->curr);
+	if (unlikely(next_task->prio < rq->curr->prio)) {
+		resched_task(rq->curr);
 		return 0;
 	}
 
-	/* We might release this_rq lock */
+	/* We might release rq lock */
 	get_task_struct(next_task);
 
 	/* find_lock_lowest_rq locks the rq if found */
-	lowest_rq = find_lock_lowest_rq(next_task, this_rq);
+	lowest_rq = find_lock_lowest_rq(next_task, rq);
 	if (!lowest_rq) {
 		struct task_struct *task;
 		/*
-		 * find lock_lowest_rq releases this_rq->lock
+		 * find lock_lowest_rq releases rq->lock
 		 * so it is possible that next_task has changed.
 		 * If it has, then try again.
 		 */
-		task = pick_next_highest_task_rt(this_rq, -1);
+		task = pick_next_highest_task_rt(rq, -1);
 		if (unlikely(task != next_task) && task && paranoid--) {
 			put_task_struct(next_task);
 			next_task = task;
@@ -378,7 +378,7 @@ static int push_rt_task(struct rq *this_rq)
 
 	assert_spin_locked(&lowest_rq->lock);
 
-	deactivate_task(this_rq, next_task, 0);
+	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
 

