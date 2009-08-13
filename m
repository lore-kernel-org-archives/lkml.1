Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZHMSyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZHMSyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 14:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZHMSym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 14:54:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37404 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZHMSym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 14:54:42 -0400
Date: Thu, 13 Aug 2009 20:54:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20090813185428.GA17738@elte.hu>
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
      futex: Update futex_q lock_ptr on requeue proxy lock
      futex: Fix handling of bad requeue syscall pairing

Dinakar Guniguntala (1):
      futex: Fix compat_futex to be same as futex for REQUEUE_PI

Peter Zijlstra (1):
      locking, sched: Give waitqueue spinlocks their own lockdep classes


 include/linux/wait.h  |    9 ++++++++-
 kernel/futex.c        |   28 ++++++++++++++++++++++------
 kernel/futex_compat.c |    6 ++++--
 kernel/wait.c         |    5 +++--
 4 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6788e1a..cf3c2f5 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -77,7 +77,14 @@ struct task_struct;
 #define __WAIT_BIT_KEY_INITIALIZER(word, bit)				\
 	{ .flags = word, .bit_nr = bit, }
 
-extern void init_waitqueue_head(wait_queue_head_t *q);
+extern void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *);
+
+#define init_waitqueue_head(q)				\
+	do {						\
+		static struct lock_class_key __key;	\
+							\
+		__init_waitqueue_head((q), &__key);	\
+	} while (0)
 
 #ifdef CONFIG_LOCKDEP
 # define __WAIT_QUEUE_HEAD_INIT_ONSTACK(name) \
diff --git a/kernel/futex.c b/kernel/futex.c
index 0672ff8..e18cfbd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1010,15 +1010,19 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
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
+ * with both q->lock_ptr and hb->lock held.
  */
 static inline
-void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
+void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
+			   struct futex_hash_bucket *hb)
 {
 	drop_futex_key_refs(&q->key);
 	get_futex_key_refs(key);
@@ -1030,6 +1034,11 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
 	WARN_ON(!q->rt_waiter);
 	q->rt_waiter = NULL;
 
+	q->lock_ptr = &hb->lock;
+#ifdef CONFIG_DEBUG_PI_LIST
+	q->list.plist.lock = &hb->lock;
+#endif
+
 	wake_up_state(q->task, TASK_NORMAL);
 }
 
@@ -1088,7 +1097,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
 				   set_waiters);
 	if (ret == 1)
-		requeue_pi_wake_futex(top_waiter, key2);
+		requeue_pi_wake_futex(top_waiter, key2, hb2);
 
 	return ret;
 }
@@ -1247,8 +1256,15 @@ retry_private:
 		if (!match_futex(&this->key, &key1))
 			continue;
 
-		WARN_ON(!requeue_pi && this->rt_waiter);
-		WARN_ON(requeue_pi && !this->rt_waiter);
+		/*
+		 * FUTEX_WAIT_REQEUE_PI and FUTEX_CMP_REQUEUE_PI should always
+		 * be paired with each other and no other futex ops.
+		 */
+		if ((requeue_pi && !this->rt_waiter) ||
+		    (!requeue_pi && this->rt_waiter)) {
+			ret = -EINVAL;
+			break;
+		}
 
 		/*
 		 * Wake nr_wake waiters.  For requeue_pi, if we acquired the
@@ -1273,7 +1289,7 @@ retry_private:
 							this->task, 1);
 			if (ret == 1) {
 				/* We got the lock. */
-				requeue_pi_wake_futex(this, &key2);
+				requeue_pi_wake_futex(this, &key2, hb2);
 				continue;
 			} else if (ret) {
 				/* -EDEADLK */
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index d607a5b..2357165 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -180,7 +180,8 @@ asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
 	int cmd = op & FUTEX_CMD_MASK;
 
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
-		      cmd == FUTEX_WAIT_BITSET)) {
+		      cmd == FUTEX_WAIT_BITSET ||
+		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
 		if (get_compat_timespec(&ts, utime))
 			return -EFAULT;
 		if (!timespec_valid(&ts))
@@ -191,7 +192,8 @@ asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
 			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
 	}
-	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
+	    cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
 		val2 = (int) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
diff --git a/kernel/wait.c b/kernel/wait.c
index ea7c3b4..c4bd3d8 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -10,13 +10,14 @@
 #include <linux/wait.h>
 #include <linux/hash.h>
 
-void init_waitqueue_head(wait_queue_head_t *q)
+void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *key)
 {
 	spin_lock_init(&q->lock);
+	lockdep_set_class(&q->lock, key);
 	INIT_LIST_HEAD(&q->task_list);
 }
 
-EXPORT_SYMBOL(init_waitqueue_head);
+EXPORT_SYMBOL(__init_waitqueue_head);
 
 void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
