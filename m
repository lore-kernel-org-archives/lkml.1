Return-Path: <linux-kernel-owner+w=401wt.eu-S1759816AbYE1B2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbYE1B2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYE1B1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:27:52 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:3888 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYE1B1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:27:50 -0400
X-Greylist: delayed 1700 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 21:27:50 EDT
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/3] sched: fix RT task-wakeup logic
To: Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Date: Tue, 27 May 2008 18:59:34 -0600
Message-ID: <20080528005934.4146.77828.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080528005647.4146.13252.stgit@lsg.lsg.lab.novell.com>
References: <20080528005647.4146.13252.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko pointed out a logic error in task_wake_up_rt() where we
will always evaluate to "true".  You can find the thread here:

http://lkml.org/lkml/2008/4/22/296

In reality, we only want to try to push tasks away when a wake up request is
not going to preempt the current task.  So lets fix it.

Note: We introduce test_tsk_need_resched() instead of open-coding the flag
check so that the merge-conflict with -rt should help remind us that we
may need to support NEEDS_RESCHED_DELAYED in the future, too.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 include/linux/sched.h |    7 ++++++-
 kernel/sched_rt.c     |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 823819c..6fff051 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2118,6 +2118,11 @@ static inline void clear_tsk_need_resched(struct task_struct *tsk)
 	clear_tsk_thread_flag(tsk,TIF_NEED_RESCHED);
 }
 
+static inline int test_tsk_need_resched(struct task_struct *tsk)
+{
+	return unlikely(test_tsk_thread_flag(tsk,TIF_NEED_RESCHED));
+}
+
 static inline int signal_pending(struct task_struct *p)
 {
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
@@ -2132,7 +2137,7 @@ static inline int fatal_signal_pending(struct task_struct *p)
 
 static inline int _need_resched(void)
 {
-	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
+	return unlikely(test_tsk_need_resched(current));
 }
 
 static inline int need_resched(void)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 5a5da00..80ef2ee 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -987,7 +987,7 @@ static void post_schedule_rt(struct rq *rq)
 static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
 {
 	if (!task_running(rq, p) &&
-	    (p->prio >= rq->rt.highest_prio) &&
+	    !test_tsk_need_resched(rq->curr) &&
 	    rq->rt.overloaded) {
 		push_rt_tasks(rq);
  		schedstat_inc(rq, rto_wakeup);

