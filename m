Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbZHIQHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbZHIQHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 12:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZHIQHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 12:07:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59250 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZHIQHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 12:07:45 -0400
Date: Sun, 9 Aug 2009 18:07:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20090809160730.GA26383@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Darren Hart (2):
      rtmutex: Avoid deadlock in rt_mutex_start_proxy_lock()
      futex: Update woken requeued futex_q lock_ptr

Li Zefan (2):
      lockdep: Fix file mode of lock_stat
      lockdep: Fix typos in documentation


 Documentation/lockdep-design.txt |    6 +++---
 kernel/futex.c                   |   13 +++++++++----
 kernel/lockdep_proc.c            |    3 ++-
 kernel/rtmutex.c                 |    4 +---
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
index e20d913..abf768c 100644
--- a/Documentation/lockdep-design.txt
+++ b/Documentation/lockdep-design.txt
@@ -30,9 +30,9 @@ State
 The validator tracks lock-class usage history into 4n + 1 separate state bits:
 
 - 'ever held in STATE context'
-- 'ever head as readlock in STATE context'
-- 'ever head with STATE enabled'
-- 'ever head as readlock with STATE enabled'
+- 'ever held as readlock in STATE context'
+- 'ever held with STATE enabled'
+- 'ever held as readlock with STATE enabled'
 
 Where STATE can be either one of (kernel/lockdep_states.h)
  - hardirq
diff --git a/kernel/futex.c b/kernel/futex.c
index 0672ff8..57f5a80 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1010,19 +1010,24 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
  * requeue_pi_wake_futex() - Wake a task that acquired the lock during requeue
  * q:	the futex_q
  * key:	the key of the requeue target futex
+ * hb:  the hash_bucket of the requeue target futex
  *
  * During futex_requeue, with requeue_pi=1, it is possible to acquire the
  * target futex if it is uncontended or via a lock steal.  Set the futex_q key
  * to the requeue target futex so the waiter can detect the wakeup on the right
  * futex, but remove it from the hb and NULL the rt_waiter so it can detect
- * atomic lock acquisition.  Must be called with the q->lock_ptr held.
+ * atomic lock acquisition.  Set the q->lock_ptr to the requeue target hb->lock
+ * to protect access to the pi_state to fixup the owner later.  Must be called
+ * with the q->lock_ptr held.
  */
 static inline
-void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
+void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
+			   struct futex_hash_bucket *hb)
 {
 	drop_futex_key_refs(&q->key);
 	get_futex_key_refs(key);
 	q->key = *key;
+	q->lock_ptr = &hb->lock;
 
 	WARN_ON(plist_node_empty(&q->list));
 	plist_del(&q->list, &q->list.plist);
@@ -1088,7 +1093,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
 				   set_waiters);
 	if (ret == 1)
-		requeue_pi_wake_futex(top_waiter, key2);
+		requeue_pi_wake_futex(top_waiter, key2, hb2);
 
 	return ret;
 }
@@ -1273,7 +1278,7 @@ retry_private:
 							this->task, 1);
 			if (ret == 1) {
 				/* We got the lock. */
-				requeue_pi_wake_futex(this, &key2);
+				requeue_pi_wake_futex(this, &key2, hb2);
 				continue;
 			} else if (ret) {
 				/* -EDEADLK */
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index d7135aa..e94caa6 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -758,7 +758,8 @@ static int __init lockdep_proc_init(void)
 		    &proc_lockdep_stats_operations);
 
 #ifdef CONFIG_LOCK_STAT
-	proc_create("lock_stat", S_IRUSR, NULL, &proc_lock_stat_operations);
+	proc_create("lock_stat", S_IRUSR | S_IWUSR, NULL,
+		    &proc_lock_stat_operations);
 #endif
 
 	return 0;
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index fcd107a..29bd4ba 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1039,16 +1039,14 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
 		/* We got the lock for task. */
 		debug_rt_mutex_lock(lock);
-
 		rt_mutex_set_owner(lock, task, 0);
-
+		spin_unlock(&lock->wait_lock);
 		rt_mutex_deadlock_account_lock(lock, task);
 		return 1;
 	}
 
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
 
-
 	if (ret && !waiter->task) {
 		/*
 		 * Reset the return value. We might have
