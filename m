Return-Path: <linux-kernel-owner+w=401wt.eu-S2992786AbXEBFl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992786AbXEBFl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXEBFlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:41:39 -0400
Received: from haxent.com ([65.99.219.155]:2170 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbXEBFeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:44 -0400
Message-Id: <20070502053426.922300000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:48 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 13/22] pollfs: asynchronous futex wait
Content-Disposition: inline; filename=pollfs-futex-async-wait.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Break apart and export the futex_wait function in order to be able to
associate (wait for) a futex with other resources.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 include/linux/futex.h |   80 ++++++++++++++++++++++++++++++
 kernel/futex.c        |  130 ++++++++++++++------------------------------------
 2 files changed, 118 insertions(+), 92 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -55,81 +55,6 @@
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
 /*
- * Futexes are matched on equal values of this key.
- * The key type depends on whether it's a shared or private mapping.
- * Don't rearrange members without looking at hash_futex().
- *
- * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.
- * We set bit 0 to indicate if it's an inode-based key.
- */
-union futex_key {
-	struct {
-		unsigned long pgoff;
-		struct inode *inode;
-		int offset;
-	} shared;
-	struct {
-		unsigned long address;
-		struct mm_struct *mm;
-		int offset;
-	} private;
-	struct {
-		unsigned long word;
-		void *ptr;
-		int offset;
-	} both;
-};
-
-/*
- * Priority Inheritance state:
- */
-struct futex_pi_state {
-	/*
-	 * list of 'owned' pi_state instances - these have to be
-	 * cleaned up in do_exit() if the task exits prematurely:
-	 */
-	struct list_head list;
-
-	/*
-	 * The PI object:
-	 */
-	struct rt_mutex pi_mutex;
-
-	struct task_struct *owner;
-	atomic_t refcount;
-
-	union futex_key key;
-};
-
-/*
- * We use this hashed waitqueue instead of a normal wait_queue_t, so
- * we can wake only the relevant ones (hashed queues may be shared).
- *
- * A futex_q has a woken state, just like tasks have TASK_RUNNING.
- * It is considered woken when list_empty(&q->list) || q->lock_ptr == 0.
- * The order of wakup is always to make the first condition true, then
- * wake up q->waiters, then make the second condition true.
- */
-struct futex_q {
-	struct list_head list;
-	wait_queue_head_t waiters;
-
-	/* Which hash list lock to use: */
-	spinlock_t *lock_ptr;
-
-	/* Key which the futex is hashed on: */
-	union futex_key key;
-
-	/* For fd, sigio sent using these: */
-	int fd;
-	struct file *filp;
-
-	/* Optional priority inheritance state: */
-	struct futex_pi_state *pi_state;
-	struct task_struct *task;
-};
-
-/*
  * Split the global futex_lock into every hash list lock.
  */
 struct futex_hash_bucket {
@@ -904,8 +829,6 @@ queue_lock(struct futex_q *q, int fd, st
 	q->fd = fd;
 	q->filp = filp;
 
-	init_waitqueue_head(&q->waiters);
-
 	get_key_refs(&q->key);
 	hb = hash_futex(&q->key);
 	q->lock_ptr = &hb->lock;
@@ -938,6 +861,7 @@ static void queue_me(struct futex_q *q, 
 {
 	struct futex_hash_bucket *hb;
 
+	init_waitqueue_head(&q->waiters);
 	hb = queue_lock(q, fd, filp);
 	__queue_me(q, hb);
 }
@@ -1002,24 +926,22 @@ static void unqueue_me_pi(struct futex_q
 	drop_key_refs(&q->key);
 }
 
-static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)
+int futex_wait_queue(struct futex_q *q, u32 __user *uaddr, u32 val)
 {
 	struct task_struct *curr = current;
-	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
-	struct futex_q q;
 	u32 uval;
 	int ret;
 
-	q.pi_state = NULL;
+	q->pi_state = NULL;
  retry:
 	down_read(&curr->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr, &q.key);
+	ret = get_futex_key(uaddr, &q->key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
-	hb = queue_lock(&q, -1, NULL);
+	hb = queue_lock(q, -1, NULL);
 
 	/*
 	 * Access the page AFTER the futex is queued.
@@ -1044,7 +966,7 @@ static int futex_wait(u32 __user *uaddr,
 	ret = get_futex_value_locked(&uval, uaddr);
 
 	if (unlikely(ret)) {
-		queue_unlock(&q, hb);
+		queue_unlock(q, hb);
 
 		/*
 		 * If we would have faulted, release mmap_sem, fault it in and
@@ -1063,14 +985,37 @@ static int futex_wait(u32 __user *uaddr,
 		goto out_unlock_release_sem;
 
 	/* Only actually queue if *uaddr contained val.  */
-	__queue_me(&q, hb);
+	__queue_me(q, hb);
 
 	/*
 	 * Now the futex is queued and we have checked the data, we
-	 * don't want to hold mmap_sem while we sleep.
+	 * don't want to hold mmap_sem while we (might) sleep.
 	 */
 	up_read(&curr->mm->mmap_sem);
 
+	return 0;
+
+ out_unlock_release_sem:
+	queue_unlock(q, hb);
+
+ out_release_sem:
+	up_read(&curr->mm->mmap_sem);
+	return ret;
+}
+
+static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)
+{
+	int ret;
+	struct futex_q q;
+	DECLARE_WAITQUEUE(wait, current);
+
+	init_waitqueue_head(&q.waiters);
+
+	ret = futex_wait_queue(&q, uaddr, val);
+
+	if (ret)
+		return ret;
+
 	/*
 	 * There might have been scheduling since the queue_me(), as we
 	 * cannot hold a spinlock across the get_user() in case it
@@ -1106,13 +1051,12 @@ static int futex_wait(u32 __user *uaddr,
 	 * have handled it for us already.
 	 */
 	return -EINTR;
+}
 
- out_unlock_release_sem:
-	queue_unlock(&q, hb);
-
- out_release_sem:
-	up_read(&curr->mm->mmap_sem);
-	return ret;
+/* Return 1 if we were still queued, 0 means we were woken. */
+int futex_wait_unqueue(struct futex_q *q)
+{
+	return unqueue_me(q);
 }
 
 /*
@@ -1142,6 +1086,8 @@ static int futex_lock_pi(u32 __user *uad
 	}
 
 	q.pi_state = NULL;
+
+	init_waitqueue_head(&q.waiters);
  retry:
 	down_read(&curr->mm->mmap_sem);
 
Index: linux-2.6/include/linux/futex.h
===================================================================
--- linux-2.6.orig/include/linux/futex.h
+++ linux-2.6/include/linux/futex.h
@@ -94,12 +94,92 @@ struct robust_list_head {
 #define ROBUST_LIST_LIMIT	2048
 
 #ifdef __KERNEL__
+
+#include <linux/rtmutex.h>
+
+/*
+ * Futexes are matched on equal values of this key.
+ * The key type depends on whether it's a shared or private mapping.
+ * Don't rearrange members without looking at hash_futex().
+ *
+ * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.
+ * We set bit 0 to indicate if it's an inode-based key.
+ */
+union futex_key {
+	struct {
+		unsigned long pgoff;
+		struct inode *inode;
+		int offset;
+	} shared;
+	struct {
+		unsigned long address;
+		struct mm_struct *mm;
+		int offset;
+	} private;
+	struct {
+		unsigned long word;
+		void *ptr;
+		int offset;
+	} both;
+};
+
+/*
+ * Priority Inheritance state:
+ */
+struct futex_pi_state {
+	/*
+	 * list of 'owned' pi_state instances - these have to be
+	 * cleaned up in do_exit() if the task exits prematurely:
+	 */
+	struct list_head list;
+
+	/*
+	 * The PI object:
+	 */
+	struct rt_mutex pi_mutex;
+
+	struct task_struct *owner;
+	atomic_t refcount;
+
+	union futex_key key;
+};
+
+/*
+ * We use this hashed waitqueue instead of a normal wait_queue_t, so
+ * we can wake only the relevant ones (hashed queues may be shared).
+ *
+ * A futex_q has a woken state, just like tasks have TASK_RUNNING.
+ * It is considered woken when list_empty(&q->list) || q->lock_ptr == 0.
+ * The order of wakup is always to make the first condition true, then
+ * wake up q->waiters, then make the second condition true.
+ */
+struct futex_q {
+	struct list_head list;
+	wait_queue_head_t waiters;
+
+	/* Which hash list lock to use: */
+	spinlock_t *lock_ptr;
+
+	/* Key which the futex is hashed on: */
+	union futex_key key;
+
+	/* For fd, sigio sent using these: */
+	int fd;
+	struct file *filp;
+
+	/* Optional priority inheritance state: */
+	struct futex_pi_state *pi_state;
+	struct task_struct *task;
+};
 long do_futex(u32 __user *uaddr, int op, u32 val, unsigned long timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 
 extern int
 handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
 
+extern int futex_wait_queue(struct futex_q *q, u32 __user *uaddr, u32 val);
+extern int futex_wait_unqueue(struct futex_q *q);
+
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);

--
