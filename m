Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYCNU7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYCNU7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYCNU73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:59:29 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:1063 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbYCNU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k2steamPDFgJj65VW0jmOHWDuhOomnf4fQ/bE061naeU3/U2I3O5Jxt+g3nAVNAhrSRn2miLb5Rm65biPwwzRPX64DdPfoFTIpWCezA3IiYS0IzloCU+eL3om98tLvmjMMOKLsfTelcaIpZcAQnSQd12op41JbTZiOgRnJ6G804=
Subject: Re: Updated generic semaphore patch set
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, lenb@kernel.org,
       dhowells@redhat.com, peterz@infradead.org, mingo@elte.hu
In-Reply-To: <20080314204248.GV613@parisc-linux.org>
References: <20080314204248.GV613@parisc-linux.org>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 13:59:27 -0700
Message-Id: <1205528367.27712.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] semaphore: eliminate forward declarations

Move the internal helper functions before their use and remove
the forward declarations.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This is a pretty trivial thing...other than this looks good to me.

 kernel/semaphore.c |  156 +++++++++++++++++++++++++---------------------------
 1 files changed, 75 insertions(+), 81 deletions(-)

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index bef977b..bae1017 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -22,11 +22,81 @@
  * semaphore.  If it's zero, there may be tasks waiting on the list.
  */
 
-static noinline void __down(struct semaphore *sem);
-static noinline int __down_interruptible(struct semaphore *sem);
-static noinline int __down_killable(struct semaphore *sem);
-static noinline int __down_timeout(struct semaphore *sem, long jiffies);
-static noinline void __up(struct semaphore *sem);
+/* Functions for the contended case */
+
+struct semaphore_waiter {
+	struct list_head list;
+	struct task_struct *task;
+	int up;
+};
+
+/*
+ * Because this function is inlined, the 'state' parameter will be
+ * constant, and thus optimised away by the compiler.  Likewise the
+ * 'timeout' parameter for the cases without timeouts.
+ */
+static inline int __sched __down_common(struct semaphore *sem, long state,
+								long timeout)
+{
+	struct task_struct *task = current;
+	struct semaphore_waiter waiter;
+
+	list_add_tail(&waiter.list, &sem->wait_list);
+	waiter.task = task;
+	waiter.up = 0;
+
+	for (;;) {
+		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
+			goto interrupted;
+		if (state == TASK_KILLABLE && fatal_signal_pending(task))
+			goto interrupted;
+		if (timeout <= 0)
+			goto timed_out;
+		__set_task_state(task, state);
+		spin_unlock_irq(&sem->lock);
+		timeout = schedule_timeout(timeout);
+		spin_lock_irq(&sem->lock);
+		if (waiter.up)
+			return 0;
+	}
+
+ timed_out:
+	list_del(&waiter.list);
+	return -ETIME;
+
+ interrupted:
+	list_del(&waiter.list);
+	return -EINTR;
+}
+
+static noinline void __sched __down(struct semaphore *sem)
+{
+	__down_common(sem, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
+}
+
+static noinline int __sched __down_interruptible(struct semaphore *sem)
+{
+	return __down_common(sem, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
+}
+
+static noinline int __sched __down_killable(struct semaphore *sem)
+{
+	return __down_common(sem, TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT);
+}
+
+static noinline int __sched __down_timeout(struct semaphore *sem, long jiffies)
+{
+	return __down_common(sem, TASK_UNINTERRUPTIBLE, jiffies);
+}
+
+static noinline void __sched __up(struct semaphore *sem)
+{
+	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
+						struct semaphore_waiter, list);
+	list_del(&waiter->list);
+	waiter->up = 1;
+	wake_up_process(waiter->task);
+}
 
 void down(struct semaphore *sem)
 {
@@ -129,79 +199,3 @@ void up(struct semaphore *sem)
 	spin_unlock_irqrestore(&sem->lock, flags);
 }
 EXPORT_SYMBOL(up);
-
-/* Functions for the contended case */
-
-struct semaphore_waiter {
-	struct list_head list;
-	struct task_struct *task;
-	int up;
-};
-
-/*
- * Because this function is inlined, the 'state' parameter will be
- * constant, and thus optimised away by the compiler.  Likewise the
- * 'timeout' parameter for the cases without timeouts.
- */
-static inline int __sched __down_common(struct semaphore *sem, long state,
-								long timeout)
-{
-	struct task_struct *task = current;
-	struct semaphore_waiter waiter;
-
-	list_add_tail(&waiter.list, &sem->wait_list);
-	waiter.task = task;
-	waiter.up = 0;
-
-	for (;;) {
-		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
-			goto interrupted;
-		if (state == TASK_KILLABLE && fatal_signal_pending(task))
-			goto interrupted;
-		if (timeout <= 0)
-			goto timed_out;
-		__set_task_state(task, state);
-		spin_unlock_irq(&sem->lock);
-		timeout = schedule_timeout(timeout);
-		spin_lock_irq(&sem->lock);
-		if (waiter.up)
-			return 0;
-	}
-
- timed_out:
-	list_del(&waiter.list);
-	return -ETIME;
-
- interrupted:
-	list_del(&waiter.list);
-	return -EINTR;
-}
-
-static noinline void __sched __down(struct semaphore *sem)
-{
-	__down_common(sem, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
-}
-
-static noinline int __sched __down_interruptible(struct semaphore *sem)
-{
-	return __down_common(sem, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
-}
-
-static noinline int __sched __down_killable(struct semaphore *sem)
-{
-	return __down_common(sem, TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT);
-}
-
-static noinline int __sched __down_timeout(struct semaphore *sem, long jiffies)
-{
-	return __down_common(sem, TASK_UNINTERRUPTIBLE, jiffies);
-}
-
-static noinline void __sched __up(struct semaphore *sem)
-{
-	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
-						struct semaphore_waiter, list);
-	list_del(&waiter->list);
-	waiter->up = 1;
-	wake_up_process(waiter->task);
-}
-- 
1.5.4.4.684.g0e08



