Return-Path: <linux-kernel-owner+w=401wt.eu-S1764121AbYEHPLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764121AbYEHPLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763418AbYEHPK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:10:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59754 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762834AbYEHPKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:10:48 -0400
Date: Thu, 8 May 2008 17:10:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] scheduler fixes
Message-ID: <20080508151028.GA12109@elte.hu>
References: <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508144316.GA9869@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Peter pointed it out that because sem->count is u32, the <= 0 is in 
> > fact a "== 0" condition - the patch below does that. As expected gcc 
> > figured out the same thing too so the resulting code output did not 
> > change. (so this is just a cleanup)
> 
> a second update patch, i've further simplified the semaphore wakeup 
> logic: there's no need for the wakeup to remove the task from the wait 
> list. This will make them a slighly bit more fair, but more 
> importantly, this closes a race in my first patch for the unlikely 
> case of a signal (or a timeout) and an unlock coming in at the same 
> time and the task not getting removed from the wait-list.
> 
> ( my performance testing with 2000 AIM7 tasks on a quad never hit that
>   race but x86.git QA actually triggered it after about 30 random 
>   kernel bootups and it caused a nasty crash and lockup. )

ok, it's looking good here so far so here's the scheduler fixes tree 
that you can pull if my semaphore fix looks good to you too:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-fixes.git for-linus

also includes a scheduler arithmetics fix from Mike. Find the shortlog 
and diff below.

	Ingo

------------------>
Ingo Molnar (1):
      semaphore: fix

Mike Galbraith (1):
      sched: fix weight calculations

 kernel/sched_fair.c |   11 ++++++--
 kernel/semaphore.c  |   64 ++++++++++++++++++++++++---------------------------
 2 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c863663..e24ecd3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -662,10 +662,15 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS)) {
+			unsigned long thresh = sysctl_sched_latency;
+
+			/*
+			 * convert the sleeper threshold into virtual time
+			 */
 			if (sched_feat(NORMALIZED_SLEEPER))
-				vruntime -= calc_delta_weight(sysctl_sched_latency, se);
-			else
-				vruntime -= sysctl_sched_latency;
+				thresh = calc_delta_fair(thresh, se);
+
+			vruntime -= thresh;
 		}
 
 		/* ensure we never gain time by being placed backwards. */
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 5c2942e..5e41217 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -54,10 +54,9 @@ void down(struct semaphore *sem)
 	unsigned long flags;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(sem->count > 0))
-		sem->count--;
-	else
+	if (unlikely(!sem->count))
 		__down(sem);
+	sem->count--;
 	spin_unlock_irqrestore(&sem->lock, flags);
 }
 EXPORT_SYMBOL(down);
@@ -77,10 +76,10 @@ int down_interruptible(struct semaphore *sem)
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(sem->count > 0))
-		sem->count--;
-	else
+	if (unlikely(!sem->count))
 		result = __down_interruptible(sem);
+	if (!result)
+		sem->count--;
 	spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
@@ -103,10 +102,10 @@ int down_killable(struct semaphore *sem)
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(sem->count > 0))
-		sem->count--;
-	else
+	if (unlikely(!sem->count))
 		result = __down_killable(sem);
+	if (!result)
+		sem->count--;
 	spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
@@ -157,10 +156,10 @@ int down_timeout(struct semaphore *sem, long jiffies)
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(sem->count > 0))
-		sem->count--;
-	else
+	if (unlikely(!sem->count))
 		result = __down_timeout(sem, jiffies);
+	if (!result)
+		sem->count--;
 	spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
@@ -179,9 +178,8 @@ void up(struct semaphore *sem)
 	unsigned long flags;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(list_empty(&sem->wait_list)))
-		sem->count++;
-	else
+	sem->count++;
+	if (unlikely(!list_empty(&sem->wait_list)))
 		__up(sem);
 	spin_unlock_irqrestore(&sem->lock, flags);
 }
@@ -192,7 +190,6 @@ EXPORT_SYMBOL(up);
 struct semaphore_waiter {
 	struct list_head list;
 	struct task_struct *task;
-	int up;
 };
 
 /*
@@ -205,33 +202,34 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
 {
 	struct task_struct *task = current;
 	struct semaphore_waiter waiter;
+	int ret = 0;
 
-	list_add_tail(&waiter.list, &sem->wait_list);
 	waiter.task = task;
-	waiter.up = 0;
+	list_add_tail(&waiter.list, &sem->wait_list);
 
 	for (;;) {
-		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
-			goto interrupted;
-		if (state == TASK_KILLABLE && fatal_signal_pending(task))
-			goto interrupted;
-		if (timeout <= 0)
-			goto timed_out;
+		if (state == TASK_INTERRUPTIBLE && signal_pending(task)) {
+			ret = -EINTR;
+			break;
+		}
+		if (state == TASK_KILLABLE && fatal_signal_pending(task)) {
+			ret = -EINTR;
+			break;
+		}
+		if (timeout <= 0) {
+			ret = -ETIME;
+			break;
+		}
 		__set_task_state(task, state);
 		spin_unlock_irq(&sem->lock);
 		timeout = schedule_timeout(timeout);
 		spin_lock_irq(&sem->lock);
-		if (waiter.up)
-			return 0;
+		if (sem->count > 0)
+			break;
 	}
 
- timed_out:
-	list_del(&waiter.list);
-	return -ETIME;
-
- interrupted:
 	list_del(&waiter.list);
-	return -EINTR;
+	return ret;
 }
 
 static noinline void __sched __down(struct semaphore *sem)
@@ -258,7 +256,5 @@ static noinline void __sched __up(struct semaphore *sem)
 {
 	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
 						struct semaphore_waiter, list);
-	list_del(&waiter->list);
-	waiter->up = 1;
 	wake_up_process(waiter->task);
 }
