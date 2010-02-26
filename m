Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936160Ab0BZMXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:23:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:43343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935909Ab0BZMO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:29 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 07/43] sched: implement try_to_wake_up_local()
Date: Fri, 26 Feb 2010 21:22:44 +0900
Message-Id: <1267187000-18791-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement try_to_wake_up_local().  try_to_wake_up_local() is similar
to try_to_wake_up() but it assumes the caller has this_rq() locked and
the target task is bound to this_rq().  try_to_wake_up_local() can be
called from wakeup and sleep scheduler notifiers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +
 kernel/sched.c        |   56 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 401d746..b9247e6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2103,6 +2103,8 @@ extern void release_uids(struct user_namespace *ns);
 
 extern void do_timer(unsigned long ticks);
 
+extern bool try_to_wake_up_local(struct task_struct *p, unsigned int state,
+				 int wake_flags);
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
 extern void wake_up_new_task(struct task_struct *tsk,
diff --git a/kernel/sched.c b/kernel/sched.c
index c371b8f..439ab59 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2438,6 +2438,10 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 		rq->idle_stamp = 0;
 	}
 #endif
+	/*
+	 * Wake up is complete, fire wake up notifier.  This allows
+	 * try_to_wake_up_local() to be called from wake up notifiers.
+	 */
 	if (success)
 		fire_sched_notifiers(p, wakeup);
 }
@@ -2540,6 +2544,53 @@ out:
 }
 
 /**
+ * try_to_wake_up_local - try to wake up a local task with rq lock held
+ * @p: the thread to be awakened
+ * @state: the mask of task states that can be woken
+ * @wake_flags: wake modifier flags (WF_*)
+ *
+ * Put @p on the run-queue if it's not alredy there.  The caller must
+ * ensure that this_rq() is locked, @p is bound to this_rq() and @p is
+ * not the current task.  this_rq() stays locked over invocation.
+ *
+ * This function can be called from wakeup and sleep scheduler
+ * notifiers.  Be careful not to create deep recursion by chaining
+ * wakeup notifiers.
+ *
+ * Returns %true if @p was woken up, %false if it was already running
+ * or @state didn't match @p's state.
+ */
+bool try_to_wake_up_local(struct task_struct *p, unsigned int state,
+			  int wake_flags)
+{
+	struct rq *rq = task_rq(p);
+	bool success = false;
+
+	BUG_ON(rq != this_rq());
+	BUG_ON(p == current);
+	lockdep_assert_held(&rq->lock);
+
+	if (!sched_feat(SYNC_WAKEUPS))
+		wake_flags &= ~WF_SYNC;
+
+	if (!(p->state & state))
+		return false;
+
+	if (!p->se.on_rq) {
+		if (likely(!task_running(rq, p))) {
+			schedstat_inc(rq, ttwu_count);
+			schedstat_inc(rq, ttwu_local);
+		}
+		ttwu_activate(p, rq, wake_flags & WF_SYNC, false, true);
+		success = true;
+	}
+
+	ttwu_post_activation(p, rq, wake_flags, success);
+
+	return success;
+}
+
+/**
  * wake_up_process - Wake up a specific process
  * @p: The process to be woken up.
  *
@@ -5498,6 +5549,11 @@ need_resched_nonpreemptible:
 		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
 		} else {
+			/*
+			 * Fire sleep notifier before changing any scheduler
+			 * state.  This allows try_to_wake_up_local() to be
+			 * called from sleep notifiers.
+			 */
 			fire_sched_notifiers(prev, sleep);
 			deactivate_task(rq, prev, 1);
 		}
-- 
1.6.4.2

