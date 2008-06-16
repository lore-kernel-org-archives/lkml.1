Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbYFPJlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbYFPJlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 05:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbYFPJlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 05:41:35 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:41232 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755321AbYFPJlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 05:41:35 -0400
From: bharathravi1@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       dhaval@linux.vnet.ibm.com, vatsa@in.ibm.com, balbir@in.ibm.com,
       Bharath Ravi <bharathravi1@gmail.com>,
       Madhava K R <madhavakr@gmail.com>
Subject: [PATCH] Delay accounting, fix incorrect delay time when constantly waiting on runqueue
Date: Mon, 16 Jun 2008 15:11:01 +0530
Message-Id: <1213609261-9554-1-git-send-email-bharathravi1@gmail.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharath Ravi <bharathravi1@gmail.com>

This patch corrects the incorrect value of per process run-queue wait time
reported by delay statistics. The anomaly was due to the following reason.
When a process leaves the CPU and immediately starts waiting for CPU on
the runqueue (which means it remains in the TASK_RUNNABLE state), the time
of re-entry into the run-queue is never recorded. Due to this, the waiting time
on the runqueue from this point of re-entry upto the next time it hits the CPU
is not accounted for. This is solved by recording the time of re-entry of a
process leaving the CPU in the sched_info_depart() function IF the process will
go back to waiting on the run-queue. This IF condition is verified by checking
whether the process is still in the TASK_RUNNABLE state.

The patch was tested on 2.6.26-rc6 using two simple CPU hog programs. The
values noted prior to the fix did not account for the time spent on the
runqueue waiting. After the fix, the correct values were reported back
to user space.

Signed-off-by: Bharath Ravi <bharathravi1@gmail.com>
Signed-off-by: Madhava K R  <madhavakr@gmail.com>
---
 kernel/sched_stats.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index a38878e..80179ef 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -198,6 +198,9 @@ static inline void sched_info_queued(struct task_struct *t)
 /*
  * Called when a process ceases being the active-running process, either
  * voluntarily or involuntarily.  Now we can calculate how long we ran.
+ * Also, if the process is still in the TASK_RUNNING state, call
+ * sched_info_queued() to mark that it has now again started waiting on
+ * the runqueue.
  */
 static inline void sched_info_depart(struct task_struct *t)
 {
@@ -206,6 +209,9 @@ static inline void sched_info_depart(struct task_struct *t)
 
 	t->sched_info.cpu_time += delta;
 	rq_sched_info_depart(task_rq(t), delta);
+
+	if (t->state == TASK_RUNNING)
+		sched_info_queued(t);
 }
 
 /*
-- 
1.5.5.1

