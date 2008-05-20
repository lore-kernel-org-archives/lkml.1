Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbYETPWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbYETPWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933665AbYETPVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:21:52 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:57736
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933404AbYETPVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:21:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/5] sched: make task->oncpu available in all configurations
To: mingo@elte.hu, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sdietrich@novell.com, pmorreale@novell.com,
       mkohari@novell.com, ghaskins@novell.com
Date: Tue, 20 May 2008 10:49:20 -0400
Message-ID: <20080520144920.15992.40920.stgit@novell1.haskins.net>
In-Reply-To: <20080520143954.15992.85900.stgit@novell1.haskins.net>
References: <20080520143954.15992.85900.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will use this later in the series to eliminate the need for a function
call.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h |    2 --
 kernel/sched.c        |   35 ++++++++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ec94970..70175e0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1080,10 +1080,8 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
 #endif
-#endif
 
 	int prio, static_prio, normal_prio;
 #ifdef CONFIG_PREEMPT_RCU_BOOST
diff --git a/kernel/sched.c b/kernel/sched.c
index 4428916..03cb222 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -699,18 +699,39 @@ static inline int task_current(struct rq *rq, struct task_struct *p)
 	return rq->curr == p;
 }
 
-#ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline int task_running(struct rq *rq, struct task_struct *p)
 {
+#ifdef CONFIG_SMP
+	return p->oncpu;
+#else
 	return task_current(rq, p);
+#endif
 }
 
+#ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
+#ifdef CONFIG_SMP
+	/*
+	 * We can optimise this out completely for !SMP, because the
+	 * SMP rebalancing from interrupt is the only thing that cares
+	 * here.
+	 */
+	next->oncpu = 1;
+#endif
 }
 
 static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 {
+#ifdef CONFIG_SMP
+	/*
+	 * After ->oncpu is cleared, the task can be moved to a different CPU.
+	 * We must ensure this doesn't happen until the switch is completely
+	 * finished.
+	 */
+	smp_wmb();
+	prev->oncpu = 0;
+#endif
 #ifdef CONFIG_DEBUG_SPINLOCK
 	/* this is a valid case when another task releases the spinlock */
 	rq->lock.owner = current;
@@ -726,14 +747,6 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 }
 
 #else /* __ARCH_WANT_UNLOCKED_CTXSW */
-static inline int task_running(struct rq *rq, struct task_struct *p)
-{
-#ifdef CONFIG_SMP
-	return p->oncpu;
-#else
-	return task_current(rq, p);
-#endif
-}
 
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
@@ -2082,7 +2095,7 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
 #endif
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
+#if defined(CONFIG_SMP)
 	p->oncpu = 0;
 #endif
 #ifdef CONFIG_PREEMPT
@@ -5684,7 +5697,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 
 	spin_lock_irqsave(&rq->lock, flags);
 	rq->curr = rq->idle = idle;
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
+#if defined(CONFIG_SMP)
 	idle->oncpu = 1;
 #endif
 	spin_unlock_irqrestore(&rq->lock, flags);

