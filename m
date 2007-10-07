Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXJGVAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXJGVAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbXJGU77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 16:59:59 -0400
Received: from ns.suse.de ([195.135.220.2]:32788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbXJGU75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 16:59:57 -0400
From: Andi Kleen <ak@suse.de>
References: <200710071059.126674000@suse.de>
In-Reply-To: <200710071059.126674000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] [2/6] scheduler: Refactor common code of sleep_on / wait_for_completion
Message-Id: <20071007205955.4D60E1474B@wotan.suse.de>
Date: Sun,  7 Oct 2007 22:59:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These functions were largely cut'n'pasted. This moves
the common code into single helpers instead.  Advantage
is about 1k less code on x86-64 and 91 lines of code removed.
It adds one function call to the non timeout version of
the functions; i don't expect this to be measurable.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6-sched-devel/kernel/sched.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/sched.c
+++ linux-2.6-sched-devel/kernel/sched.c
@@ -3689,206 +3689,115 @@ void fastcall complete_all(struct comple
 }
 EXPORT_SYMBOL(complete_all);
 
-void fastcall __sched wait_for_completion(struct completion *x)
+static inline long __sched
+do_wait_for_common(struct completion *x, long timeout, int state)
 {
-	might_sleep();
-
-	spin_lock_irq(&x->wait.lock);
 	if (!x->done) {
 		DECLARE_WAITQUEUE(wait, current);
 
 		wait.flags |= WQ_FLAG_EXCLUSIVE;
 		__add_wait_queue_tail(&x->wait, &wait);
 		do {
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			spin_unlock_irq(&x->wait.lock);
-			schedule();
-			spin_lock_irq(&x->wait.lock);
-		} while (!x->done);
-		__remove_wait_queue(&x->wait, &wait);
-	}
-	x->done--;
-	spin_unlock_irq(&x->wait.lock);
-}
-EXPORT_SYMBOL(wait_for_completion);
-
-unsigned long fastcall __sched
-wait_for_completion_timeout(struct completion *x, unsigned long timeout)
-{
-	might_sleep();
-
-	spin_lock_irq(&x->wait.lock);
-	if (!x->done) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue_tail(&x->wait, &wait);
-		do {
-			__set_current_state(TASK_UNINTERRUPTIBLE);
+			if (state == TASK_INTERRUPTIBLE &&
+			    signal_pending(current)) {
+				__remove_wait_queue(&x->wait, &wait);
+				return -ERESTARTSYS;
+			}
+			__set_current_state(state);
 			spin_unlock_irq(&x->wait.lock);
 			timeout = schedule_timeout(timeout);
 			spin_lock_irq(&x->wait.lock);
 			if (!timeout) {
 				__remove_wait_queue(&x->wait, &wait);
-				goto out;
+				return timeout;
 			}
 		} while (!x->done);
 		__remove_wait_queue(&x->wait, &wait);
 	}
 	x->done--;
-out:
-	spin_unlock_irq(&x->wait.lock);
 	return timeout;
 }
-EXPORT_SYMBOL(wait_for_completion_timeout);
 
-int fastcall __sched wait_for_completion_interruptible(struct completion *x)
+static long __sched
+wait_for_common(struct completion *x, long timeout, int state)
 {
-	int ret = 0;
-
 	might_sleep();
 
 	spin_lock_irq(&x->wait.lock);
-	if (!x->done) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue_tail(&x->wait, &wait);
-		do {
-			if (signal_pending(current)) {
-				ret = -ERESTARTSYS;
-				__remove_wait_queue(&x->wait, &wait);
-				goto out;
-			}
-			__set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock_irq(&x->wait.lock);
-			schedule();
-			spin_lock_irq(&x->wait.lock);
-		} while (!x->done);
-		__remove_wait_queue(&x->wait, &wait);
-	}
-	x->done--;
-out:
+	timeout = do_wait_for_common(x, timeout, state);
 	spin_unlock_irq(&x->wait.lock);
+	return timeout;
+}
 
-	return ret;
+void fastcall __sched wait_for_completion(struct completion *x)
+{
+	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
 }
-EXPORT_SYMBOL(wait_for_completion_interruptible);
+EXPORT_SYMBOL(wait_for_completion);
 
 unsigned long fastcall __sched
-wait_for_completion_interruptible_timeout(struct completion *x,
-					  unsigned long timeout)
+wait_for_completion_timeout(struct completion *x, unsigned long timeout)
 {
-	might_sleep();
-
-	spin_lock_irq(&x->wait.lock);
-	if (!x->done) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue_tail(&x->wait, &wait);
-		do {
-			if (signal_pending(current)) {
-				timeout = -ERESTARTSYS;
-				__remove_wait_queue(&x->wait, &wait);
-				goto out;
-			}
-			__set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock_irq(&x->wait.lock);
-			timeout = schedule_timeout(timeout);
-			spin_lock_irq(&x->wait.lock);
-			if (!timeout) {
-				__remove_wait_queue(&x->wait, &wait);
-				goto out;
-			}
-		} while (!x->done);
-		__remove_wait_queue(&x->wait, &wait);
-	}
-	x->done--;
-out:
-	spin_unlock_irq(&x->wait.lock);
-	return timeout;
+	return wait_for_common(x, timeout, TASK_UNINTERRUPTIBLE);
 }
-EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
+EXPORT_SYMBOL(wait_for_completion_timeout);
 
-static inline void
-sleep_on_head(wait_queue_head_t *q, wait_queue_t *wait, unsigned long *flags)
+int __sched wait_for_completion_interruptible(struct completion *x)
 {
-	spin_lock_irqsave(&q->lock, *flags);
-	__add_wait_queue(q, wait);
-	spin_unlock(&q->lock);
+	return wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
 }
+EXPORT_SYMBOL(wait_for_completion_interruptible);
 
-static inline void
-sleep_on_tail(wait_queue_head_t *q, wait_queue_t *wait, unsigned long *flags)
+unsigned long fastcall __sched
+wait_for_completion_interruptible_timeout(struct completion *x,
+					  unsigned long timeout)
 {
-	spin_lock_irq(&q->lock);
-	__remove_wait_queue(q, wait);
-	spin_unlock_irqrestore(&q->lock, *flags);
+	return wait_for_common(x, timeout, TASK_INTERRUPTIBLE);
 }
+EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
 
-void __sched interruptible_sleep_on(wait_queue_head_t *q)
+static long sleep_on_common(wait_queue_head_t *q, int state, long timeout)
 {
 	unsigned long flags;
 	wait_queue_t wait;
 
 	init_waitqueue_entry(&wait, current);
 
-	current->state = TASK_INTERRUPTIBLE;
+	__set_current_state(state);
 
-	sleep_on_head(q, &wait, &flags);
-	schedule();
-	sleep_on_tail(q, &wait, &flags);
+	spin_lock_irqsave(&q->lock, flags);
+	__add_wait_queue(q, &wait);
+	spin_unlock(&q->lock);
+	timeout = schedule_timeout(timeout);
+	spin_lock_irq(&q->lock);
+	__remove_wait_queue(q, &wait);
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return timeout;
+}
+
+void __sched interruptible_sleep_on(wait_queue_head_t *q)
+{
+	sleep_on_common(q, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 }
 EXPORT_SYMBOL(interruptible_sleep_on);
 
 long __sched
 interruptible_sleep_on_timeout(wait_queue_head_t *q, long timeout)
 {
-	unsigned long flags;
-	wait_queue_t wait;
-
-	init_waitqueue_entry(&wait, current);
-
-	current->state = TASK_INTERRUPTIBLE;
-
-	sleep_on_head(q, &wait, &flags);
-	timeout = schedule_timeout(timeout);
-	sleep_on_tail(q, &wait, &flags);
-
-	return timeout;
+	return sleep_on_common(q, TASK_INTERRUPTIBLE, timeout);
 }
 EXPORT_SYMBOL(interruptible_sleep_on_timeout);
 
 void __sched sleep_on(wait_queue_head_t *q)
 {
-	unsigned long flags;
-	wait_queue_t wait;
-
-	init_waitqueue_entry(&wait, current);
-
-	current->state = TASK_UNINTERRUPTIBLE;
-
-	sleep_on_head(q, &wait, &flags);
-	schedule();
-	sleep_on_tail(q, &wait, &flags);
+	sleep_on_common(q, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 }
 EXPORT_SYMBOL(sleep_on);
 
 long __sched sleep_on_timeout(wait_queue_head_t *q, long timeout)
 {
-	unsigned long flags;
-	wait_queue_t wait;
-
-	init_waitqueue_entry(&wait, current);
-
-	current->state = TASK_UNINTERRUPTIBLE;
-
-	sleep_on_head(q, &wait, &flags);
-	timeout = schedule_timeout(timeout);
-	sleep_on_tail(q, &wait, &flags);
-
-	return timeout;
+	return sleep_on_common(q, TASK_UNINTERRUPTIBLE, timeout);
 }
 EXPORT_SYMBOL(sleep_on_timeout);
 
