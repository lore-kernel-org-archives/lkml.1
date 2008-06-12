Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbYFLTTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbYFLTTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYFLTTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:19:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42062 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbYFLTTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:19:02 -0400
Date: Thu, 12 Jun 2008 21:18:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fixes
Message-ID: <20080612191848.GA31003@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

thanks,

	Ingo

------------------>
Lai Jiangshan (2):
      sched: fair group: fix overflow(was: fix divide by zero)
      sched: 64-bit: fix arithmetics overflow

Oleg Nesterov (1):
      sched: fix TASK_WAKEKILL vs SIGKILL race

 include/linux/sched.h |   13 +++++++++++++
 kernel/sched.c        |   22 ++++++++++++++--------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ae0be3c..c5d3f84 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2026,6 +2026,19 @@ static inline int fatal_signal_pending(struct task_struct *p)
 	return signal_pending(p) && __fatal_signal_pending(p);
 }
 
+static inline int signal_pending_state(long state, struct task_struct *p)
+{
+	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
+		return 0;
+	if (!signal_pending(p))
+		return 0;
+
+	if (state & (__TASK_STOPPED | __TASK_TRACED))
+		return 0;
+
+	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
+}
+
 static inline int need_resched(void)
 {
 	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
diff --git a/kernel/sched.c b/kernel/sched.c
index bfb8ad8..eaf6751 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -312,12 +312,15 @@ static DEFINE_SPINLOCK(task_group_lock);
 #endif
 
 /*
- * A weight of 0, 1 or ULONG_MAX can cause arithmetics problems.
+ * A weight of 0 or 1 can cause arithmetics problems.
+ * A weight of a cfs_rq is the sum of weights of which entities
+ * are queued on this cfs_rq, so a weight of a entity should not be
+ * too large, so as the shares value of a task group.
  * (The default weight is 1024 - so there's no practical
  *  limitation from this.)
  */
 #define MIN_SHARES	2
-#define MAX_SHARES	(ULONG_MAX - 1)
+#define MAX_SHARES	(1UL << 18)
 
 static int init_task_group_load = INIT_TASK_GROUP_LOAD;
 #endif
@@ -1337,8 +1340,13 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 {
 	u64 tmp;
 
-	if (!lw->inv_weight)
-		lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)/(lw->weight+1);
+	if (!lw->inv_weight) {
+		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
+			lw->inv_weight = 1;
+		else
+			lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
+				/ (lw->weight+1);
+	}
 
 	tmp = (u64)delta_exec * weight;
 	/*
@@ -4159,12 +4167,10 @@ need_resched_nonpreemptible:
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
-		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
-				signal_pending(prev))) {
+		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
-		} else {
+		else
 			deactivate_task(rq, prev, 1);
-		}
 		switch_count = &prev->nvcsw;
 	}
 
