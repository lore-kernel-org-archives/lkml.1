Return-Path: <linux-kernel-owner+w=401wt.eu-S1762367AbYESRkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762367AbYESRkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbYESRjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:39:49 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:45679
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754017AbYESRjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:39:47 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/8] allow rt-mutex lock-stealing to include lateral priority
To: mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, pavel@ucw.cz, acme@redhat.com,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Mon, 19 May 2008 13:07:16 -0400
Message-ID: <20080519170715.6820.35734.stgit@novell1.haskins.net>
In-Reply-To: <20080519170356.6820.5274.stgit@novell1.haskins.net>
References: <20080519170356.6820.5274.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current logic only allows lock stealing to occur if the current task
is of higher priority than the pending owner. We can gain signficant
throughput improvements (200%+) by allowing the lock-stealing code to
include tasks of equal priority.  The theory is that the system will make
faster progress by allowing the task already on the CPU to take the lock
rather than waiting for the system to wake-up a different task.

This does add a degree of unfairness, yes.  But also note that the users
of these locks under non -rt environments have already been using unfair
raw spinlocks anyway so the tradeoff is probably worth it.

The way I like to think of this is that higher priority tasks should
clearly preempt, and lower priority tasks should clearly block.  However,
if tasks have an identical priority value, then we can think of the
scheduler decisions as the tie-breaking parameter. (e.g. tasks that the
scheduler picked to run first have a logically higher priority amoung tasks
of the same prio).  This helps to keep the system "primed" with tasks doing
useful work, and the end result is higher throughput.

Thanks to Steven Rostedt for pointing out that RT tasks should be excluded
to prevent the introduction of an unnatural unbounded latency.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/rtmutex.c        |   17 +++++++++++------
 kernel/rtmutex_common.h |   19 +++++++++++++++++++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 3ef23d4..0d3f76f 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -318,7 +318,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
  * assigned pending owner [which might not have taken the
  * lock yet]:
  */
-static inline int try_to_steal_lock(struct rt_mutex *lock)
+static inline int try_to_steal_lock(struct rt_mutex *lock, int mode)
 {
 	struct task_struct *pendowner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *next;
@@ -330,7 +330,7 @@ static inline int try_to_steal_lock(struct rt_mutex *lock)
 		return 1;
 
 	spin_lock(&pendowner->pi_lock);
-	if (current->prio >= pendowner->prio) {
+	if (!lock_is_stealable(pendowner, mode)) {
 		spin_unlock(&pendowner->pi_lock);
 		return 0;
 	}
@@ -383,7 +383,7 @@ static inline int try_to_steal_lock(struct rt_mutex *lock)
  *
  * Must be called with lock->wait_lock held.
  */
-static int try_to_take_rt_mutex(struct rt_mutex *lock)
+static int do_try_to_take_rt_mutex(struct rt_mutex *lock, int mode)
 {
 	/*
 	 * We have to be careful here if the atomic speedups are
@@ -406,7 +406,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
 	 */
 	mark_rt_mutex_waiters(lock);
 
-	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock))
+	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, mode))
 		return 0;
 
 	/* We got the lock. */
@@ -419,6 +419,11 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
 	return 1;
 }
 
+static inline int try_to_take_rt_mutex(struct rt_mutex *lock)
+{
+	return do_try_to_take_rt_mutex(lock, STEAL_NORMAL);
+}
+
 /*
  * Task blocks on lock.
  *
@@ -684,7 +689,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	init_lists(lock);
 
 	/* Try to acquire the lock again: */
-	if (try_to_take_rt_mutex(lock)) {
+	if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL)) {
 		spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return;
 	}
@@ -707,7 +712,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 		int saved_lock_depth = current->lock_depth;
 
 		/* Try to acquire the lock */
-		if (try_to_take_rt_mutex(lock))
+		if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL))
 			break;
 		/*
 		 * waiter.task is NULL the first time we come here and
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index e124bf5..9ef0ffe 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -121,6 +121,25 @@ extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 				  struct task_struct *proxy_owner);
 
+
+#define STEAL_LATERAL 1
+#define STEAL_NORMAL  0
+
+/*
+ * Note that RT tasks are excluded from lateral-steals to prevent the
+ * introduction of an unbounded latency
+ */
+static inline int lock_is_stealable(struct task_struct *pendowner, int mode)
+{
+    if (mode == STEAL_NORMAL || rt_task(current)) {
+	    if (current->prio >= pendowner->prio)
+		    return 0;
+    } else if (current->prio > pendowner->prio)
+	    return 0;
+
+    return 1;
+}
+
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 # include "rtmutex-debug.h"
 #else

