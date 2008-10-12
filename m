Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbYJLNMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbYJLNMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYJLNMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:12:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:48266 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbYJLNMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=KjcT3WSCC4JaB0gI0OKyWGn7bdBnNOSBE8cQOr/fuRHo0sity8dZFwaXTFpTVq4Cl/
         uD0EUguVXr4wlFOdIjJGfBlGgdgDTnm9VYxcOab2OZ66S0Z8JYWAIzaOpAAbwR6g0fWK
         WBOXCw9wQ7UddVXdbSt4OA0jOQsAtQ6bvZa18=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu, srostedt@redhat.com
Cc: a.p.zijlstra@chello.nl, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH 3/4] add tracepoints in rwsem
Date: Sun, 12 Oct 2008 16:12:03 +0300
Message-Id: <1223817124-27239-5-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows a tracing framework, such as ftrace to measure the latency
during lock contention, and (unlike latencytop) allows to show whom to blame for holding
the lock for too long.

The tracepoints consist of 3 events
- a down_read, or down_write failed - a tracer can use this as a point of reference
- semaphore  is granted after a failed down_read or down_write - usable to measure latency
- one writer, or all readers are woken - a tracer can see who was/is holding the lock,
 and blame it for the latencies of all reader/writer tasks on the waiter list

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 include/trace/rwsem.h |   35 +++++++++++++++++++++++++++++++++++
 lib/rwsem-spinlock.c  |   16 ++++++++--------
 lib/rwsem.c           |   13 +++++--------
 3 files changed, 48 insertions(+), 16 deletions(-)
 create mode 100644 include/trace/rwsem.h

diff --git a/include/trace/rwsem.h b/include/trace/rwsem.h
new file mode 100644
index 0000000..8afb773
--- /dev/null
+++ b/include/trace/rwsem.h
@@ -0,0 +1,35 @@
+#ifndef _TRACE_RWSEM_H
+#define _TRACE_RWSEM_H
+
+#include <linux/tracepoint.h>
+
+struct rwsem_waiter {
+	struct list_head list;
+	struct task_struct *task;
+	unsigned int flags;
+#define RWSEM_WAITING_FOR_READ	0x00000001
+#define RWSEM_WAITING_FOR_WRITE	0x00000002
+};
+
+/* some waiters from the waiter list are woken,
+ * some remain sleeping */
+DEFINE_TRACE(rwsem_wake,
+		TPPROTO(const struct rw_semaphore *sem,
+			const struct rwsem_waiter *waiter),
+		TPARGS(sem, waiter));
+
+/* a down_read() failed because a writer already has the lock,
+ * or a down_write() failed because another reader or writer
+ * already has the lock.
+ * tsk indicates this task, and waiter->list contains
+ * all other tasks that wait for this lock */
+DEFINE_TRACE(rwsem_lock_failed,
+		TPPROTO(const struct rw_semaphore *sem),
+		TPARGS(sem));
+
+/* the tsk was granted the lock, after previously failing to
+ * acquire the lock due to contention */
+DEFINE_TRACE(rwsem_lock_ok,
+		TPPROTO(const struct task_struct *tsk),
+		TPARGS(tsk));
+#endif
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index 9df3ca5..9e32ce4 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -8,14 +8,7 @@
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/module.h>
-
-struct rwsem_waiter {
-	struct list_head list;
-	struct task_struct *task;
-	unsigned int flags;
-#define RWSEM_WAITING_FOR_READ	0x00000001
-#define RWSEM_WAITING_FOR_WRITE	0x00000002
-};
+#include <trace/rwsem.h>
 
 /*
  * initialise the semaphore
@@ -69,6 +62,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 		list_del(&waiter->list);
 		tsk = waiter->task;
 		/* Don't touch waiter after ->task has been NULLed */
+		trace_rwsem_wake(sem, waiter);
 		smp_mb();
 		waiter->task = NULL;
 		wake_up_process(tsk);
@@ -78,6 +72,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 
 	/* grant an infinite number of read locks to the front of the queue */
  dont_wake_writers:
+	trace_rwsem_wake(sem, waiter);
 	woken = 0;
 	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
 		struct list_head *next = waiter->list.next;
@@ -115,6 +110,7 @@ __rwsem_wake_one_writer(struct rw_semaphore *sem)
 	list_del(&waiter->list);
 
 	tsk = waiter->task;
+	trace_rwsem_wake(sem, waiter);
 	smp_mb();
 	waiter->task = NULL;
 	wake_up_process(tsk);
@@ -152,6 +148,7 @@ void __sched __down_read(struct rw_semaphore *sem)
 	/* we don't need to touch the semaphore struct anymore */
 	spin_unlock_irq(&sem->wait_lock);
 
+	trace_rwsem_lock_failed(sem);
 	/* wait to be given the lock */
 	for (;;) {
 		if (!waiter.task)
@@ -160,6 +157,7 @@ void __sched __down_read(struct rw_semaphore *sem)
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	}
 
+	trace_rwsem_lock_ok(tsk);
 	tsk->state = TASK_RUNNING;
  out:
 	;
@@ -218,6 +216,7 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 	/* we don't need to touch the semaphore struct anymore */
 	spin_unlock_irq(&sem->wait_lock);
 
+	trace_rwsem_lock_failed(sem);
 	/* wait to be given the lock */
 	for (;;) {
 		if (!waiter.task)
@@ -226,6 +225,7 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	}
 
+	trace_rwsem_lock_ok(tsk);
 	tsk->state = TASK_RUNNING;
  out:
 	;
diff --git a/lib/rwsem.c b/lib/rwsem.c
index 3e3365e..a9c5571 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <trace/rwsem.h>
 
 /*
  * Initialize an rwsem:
@@ -28,14 +29,6 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 
 EXPORT_SYMBOL(__init_rwsem);
 
-struct rwsem_waiter {
-	struct list_head list;
-	struct task_struct *task;
-	unsigned int flags;
-#define RWSEM_WAITING_FOR_READ	0x00000001
-#define RWSEM_WAITING_FOR_WRITE	0x00000002
-};
-
 /*
  * handle the lock release when processes blocked on it that can now run
  * - if we come here from up_xxxx(), then:
@@ -81,6 +74,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	 */
 	list_del(&waiter->list);
 	tsk = waiter->task;
+	trace_rwsem_wake(sem, waiter);
 	smp_mb();
 	waiter->task = NULL;
 	wake_up_process(tsk);
@@ -99,6 +93,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	 *   readers before waking any processes up
 	 */
  readers_only:
+	trace_rwsem_wake(sem, waiter);
 	woken = 0;
 	do {
 		woken++;
@@ -171,6 +166,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 
 	spin_unlock_irq(&sem->wait_lock);
 
+	trace_rwsem_lock_failed(sem);
 	/* wait to be given the lock */
 	for (;;) {
 		if (!waiter->task)
@@ -179,6 +175,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	}
 
+	trace_rwsem_lock_ok(tsk);
 	tsk->state = TASK_RUNNING;
 
 	return sem;
-- 
1.5.6.5

